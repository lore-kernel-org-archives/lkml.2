Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1IRPZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:25:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43534 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab1IRPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:25:42 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: phillip@squashfs.org.uk
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] squashfs : devblksize set to 4KB intead of BLOCK_SIZE(1KB).
Date: Mon, 19 Sep 2011 00:24:52 +0900
Message-Id: <1316359492-2297-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If devblksize is set by NAND page size before, I think that it is changed to optimal vaule with increasing physical page size of NAND.
So I suggest that devblksize is set to 4KB. it is suitable for physical page size of NAND(onenand, flexonenand etc..) and the minimal compressed size.
and user gain improved performance(~%20) and stop reading inefficiently several time by page alignment.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/squashfs/squashfs_fs.h |    3 +++
 fs/squashfs/super.c       |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index b4a4e53..c667921 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -32,6 +32,9 @@
 #define SQUASHFS_METADATA_SIZE		8192
 #define SQUASHFS_METADATA_LOG		13
 
+/* size of device blocks */
+#define SQUASHFS_DEVBLK_SIZE		4096
+
 /* default size of data blocks */
 #define SQUASHFS_FILE_SIZE		131072
 #define SQUASHFS_FILE_LOG		17
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 7438850..2da1715 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -95,7 +95,7 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	msblk = sb->s_fs_info;
 
-	msblk->devblksize = sb_min_blocksize(sb, BLOCK_SIZE);
+	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->read_data_mutex);
-- 
1.7.4.4

