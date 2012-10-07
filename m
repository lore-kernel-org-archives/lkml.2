Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2JGIdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 04:33:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48938 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2JGIdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 04:33:12 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v4 4/4] Documentation: update nfs option in filesystem/vfat.txt
Date: Sun,  7 Oct 2012 04:33:02 -0400
Message-Id: <1349598782-3286-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

update nfs option in filesystem/vfat.txt

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 Documentation/filesystems/vfat.txt |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index de1e6c4..d62f8e6 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -141,13 +141,26 @@ discard       -- If set, issues discard/TRIM commands to the block
 		 device when blocks are freed. This is useful for SSD devices
 		 and sparse/thinly-provisoned LUNs.
 
-nfs           -- This option maintains an index (cache) of directory
-		 inodes by i_logstart which is used by the nfs-related code to
-		 improve look-ups.
-
-		 Enable this only if you want to export the FAT filesystem
+nfs= stale_rw|nostale_ro
+	      -- Enable this only if you want to export the FAT filesystem
 		 over NFS
 
+		 stale_rw:This option maintains an index (cache) of directory
+		 inodes by i_logstart which is used by the nfs-related code to
+		 improve look-ups.Full file operations (read/write) over NFS is supported
+		 but with cache eviction at NFS server, this could result in ESTALE issues.
+
+		 nostale_ro:This option bases the inode number and filehandle on the on-disk
+		 location of a file in the MS-DOS directory entry.This ensures that ESTALE
+		 will not be returned after a file is evicted from the inode cache. However,
+		 it means that operations such as rename, create and unlink could cause
+		 filehandles that previously pointed at one file to point at a different file,
+		 potentially causing data corruption. For this reason, this option also mounts
+		 the filesystem readonly.
+
+		 To maintain backward compatibility, '-o nfs' is also accepted, defaulting to
+		 stale_rw
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
-- 
1.7.9.5

