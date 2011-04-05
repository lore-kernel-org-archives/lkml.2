Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1DEO7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:59:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab1DEO7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:31 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/34] kbuild: Call gzip with -n
Date: Tue,  5 Apr 2011 16:58:49 +0200
Message-Id: <1302015561-21047-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timestamps recorded in the .gz files add no value.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.lib          |    2 +-
 scripts/gen_initramfs_list.sh |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 1c702ca..93b2b59 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -197,7 +197,7 @@ cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@
 # ---------------------------------------------------------------------------
 
 quiet_cmd_gzip = GZIP    $@
-cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
+cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -n -f -9 > $@) || \
 	(rm -f $@ ; false)
 
 # DTC
diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 55caecd..4a43fe1 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -226,7 +226,7 @@ cpio_list=
 output="/dev/stdout"
 output_file=""
 is_cpio_compressed=
-compr="gzip -9 -f"
+compr="gzip -n -9 -f"
 
 arg="$1"
 case "$arg" in
@@ -240,7 +240,7 @@ case "$arg" in
 		output_file="$1"
 		cpio_list="$(mktemp ${TMPDIR:-/tmp}/cpiolist.XXXXXX)"
 		output=${cpio_list}
-		echo "$output_file" | grep -q "\.gz$" && compr="gzip -9 -f"
+		echo "$output_file" | grep -q "\.gz$" && compr="gzip -n -9 -f"
 		echo "$output_file" | grep -q "\.bz2$" && compr="bzip2 -9 -f"
 		echo "$output_file" | grep -q "\.lzma$" && compr="lzma -9 -f"
 		echo "$output_file" | grep -q "\.xz$" && \
-- 
1.7.4.1

