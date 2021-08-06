#!/bin/bash

# Replay pcap

pcap_file=dump.pcap
dest_host=localhost
dest_port=8888
tmp_request_dir=requests

urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

if [ -z "$(ls $tmp_request_dir)" ]; then
    tshark -r $pcap_file --export-objects http,$tmp_request_dir http
fi

requests=$(ls "$tmp_request_dir")
for request in $requests; do
    file="$tmp_request_dir/$request"
    query=$(urldecode "$file")
    url="http://$dest_host:$dest_port/$query"
    curl -d "@$file" "$url"
done
