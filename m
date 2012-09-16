Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2IPMXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 08:23:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58454 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2IPMX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 08:23:29 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v3 5/5] Documentation: update nfs option in filesystem/vfat.txt
Date: Sun, 16 Sep 2012 08:23:20 -0400
Message-Id: <1347798200-2765-1-git-send-email-linkinjeon@gmail.com>
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
 Documentation/filesystems/vfat.txt |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index de1e6c4..3371b8e 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -141,13 +141,22 @@ discard       -- If set, issues discard/TRIM commands to the block
 		 device when blocks are freed. This is useful for SSD devices
 		 and sparse/thinly-provisoned LUNs.
 
-nfs           -- This option maintains an index (cache) of directory
-		 inodes by i_logstart which is used by the nfs-related code to
-		 improve look-ups.
-
-		 Enable this only if you want to export the FAT filesystem
+nfs=full_unstable|limited_stable
+	      -- Enable this only if you want to export the FAT filesystem
 		 over NFS
 
+		 full_unstable:This option maintains an index (cache) of
+		 directory inodes by i_logstart which is used by
+		 the nfs-related code to improve look-ups.Full file operations
+		 (read/write) over NFS is supported but with cache eviction
+		 at NFS server, this could result in ESTALE issues.
+
+		 limited_stable:This options makes NFS support for FAT as
+		 read-only and provides stable inode based on the on-disk
+		 location of the MS-DOS directory entry.This helps in
+		 reconstruction of the inodes in case of lookup failure,
+		 making FAT behaviour stable with respect to ESTALE issues.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
-- 
1.7.9.5

