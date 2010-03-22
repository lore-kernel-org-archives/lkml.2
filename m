Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0CVWti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 18:49:38 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:52027 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0CVWth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 18:49:37 -0400
Date: Mon, 22 Mar 2010 16:49:32 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] kbuild: Include gen_initramfs_list.sh and the file list in
	the .d file
Message-ID: <20100322224932.GA26068@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the dependency set used for the initrd to include the
CONFIG_INITRAMFS_SOURCE file and the generator script itself.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 scripts/gen_initramfs_list.sh |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Otherwise changing the initramfs file list does not rebuild the CPIO..

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 76af5f9..f3b5c05 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -202,6 +202,7 @@ input_file() {
 			print_mtime "$1" >> ${output}
 			cat "$1"         >> ${output}
 		else
+		        echo "$1 \\"
 			cat "$1" | while read type dir file perm ; do
 				if [ "$type" == "file" ]; then
 					echo "$file \\";
@@ -231,7 +232,7 @@ arg="$1"
 case "$arg" in
 	"-l")	# files included in initramfs - used by kbuild
 		dep_list="list_"
-		echo "deps_initramfs := \\"
+		echo "deps_initramfs := $0 \\"
 		shift
 		;;
 	"-o")	# generate compressed cpio image named $1
-- 
1.5.4.2

