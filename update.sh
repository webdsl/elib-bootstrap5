#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o noclobber
set -o nounset
#set -o xtrace

BS_VERSION=5.2.0-beta1
BS_NAME=bootstrap-${BS_VERSION}-dist
BS_URL=https://github.com/twbs/bootstrap/releases/download/v${BS_VERSION}/${BS_NAME}.zip
ASSETS_DIR=stylesheets/bootstrap5
JS_DIR=javascript/bootstrap5

################
# REQUIREMENTS #
################
# The following packages:
# - unzip
# - wget

# Get the script directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Recreating directories..."
rm -r "${dir}/${ASSETS_DIR}/" 2> /dev/null || true
mkdir -p "${dir}/${ASSETS_DIR}/"
echo "  ${ASSETS_DIR}/"
rm -r "${dir}/${JS_DIR}/" 2> /dev/null || true
mkdir -p "${dir}/${JS_DIR}/"
echo "  ${JS_DIR}/"

echo "Downloading: ${BS_URL}..."
tmp_dir=$(mktemp -d)
trap "rm -rf $tmp_dir" 0 2 3 15
wget -q -O "${tmp_dir}/bootstrap5.zip" "${BS_URL}"

echo "Unpacking: ${BS_NAME}.zip..."
unzip -q "${tmp_dir}/bootstrap5.zip" -d "${tmp_dir}/bootstrap5/"

echo "Copying files..."
cp -r "${tmp_dir}/bootstrap5/${BS_NAME}/css/bootstrap.min.css" "${dir}/${ASSETS_DIR}/"
echo "  bootstrap.min.css"
cp -r "${tmp_dir}/bootstrap5/${BS_NAME}/css/bootstrap.min.css.map" "${dir}/${ASSETS_DIR}/"
echo "  bootstrap.min.css.map"
cp -r "${tmp_dir}/bootstrap5/${BS_NAME}/js/bootstrap.bundle.min.js" "${dir}/${JS_DIR}/"
echo "  bootstrap.bundle.min.js"
cp -r "${tmp_dir}/bootstrap5/${BS_NAME}/js/bootstrap.bundle.min.js.map" "${dir}/${JS_DIR}/"
echo "  bootstrap.bundle.min.js.map"

echo "Done!"
