Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2BBHw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 02:52:26 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47158 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab2BBHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 02:52:25 -0500
MIME-Version: 1.0
Date: Thu, 2 Feb 2012 13:22:24 +0530
Message-ID: <CAB4K4y6zBBz7BXZoUUeSMO+QMnVAAUzbzyPRp-JSc46jVEakGQ@mail.gmail.com>
Subject: [PATCH] Squashfs: use define instead of constant
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2b99588058197b841fa45fbc247bd99ae260e756 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Thu, 2 Feb 2012 13:04:49 +0530
Subject: [PATCH] Squashfs: use define instead of constant

Its better to use defined name instead of constant

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 fs/squashfs/dir.c         |    3 +--
 fs/squashfs/namei.c       |    3 +--
 fs/squashfs/squashfs_fs.h |    3 +++
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index 9dfe2ce..4a812bf 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -173,8 +173,7 @@ static int squashfs_readdir(struct file *file,
void *dirent, filldir_t filldir)

 		dir_count = le32_to_cpu(dirh.count) + 1;

-		/* dir_count should never be larger than 256 */
-		if (dir_count > 256)
+		if (dir_count > SQUASHFS_DIR_COUNT)
 			goto failed_read;

 		while (dir_count--) {
diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 0682b38..66c70fc 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -177,8 +177,7 @@ static struct dentry *squashfs_lookup(struct inode
*dir, struct dentry *dentry,

 		dir_count = le32_to_cpu(dirh.count) + 1;

-		/* dir_count should never be larger than 256 */
-		if (dir_count > 256)
+		if (dir_count > SQUASHFS_DIR_COUNT)
 			goto data_error;

 		while (dir_count--) {
diff --git a/fs/squashfs/squashfs_fs.h b/fs/squashfs/squashfs_fs.h
index e8e1464..b2f9f62 100644
--- a/fs/squashfs/squashfs_fs.h
+++ b/fs/squashfs/squashfs_fs.h
@@ -52,6 +52,9 @@
 /* Max length of filename (not 255) */
 #define SQUASHFS_NAME_LEN		256

+/* Max value for directory header count*/
+#define SQUASHFS_DIR_COUNT		256
+
 #define SQUASHFS_INVALID_FRAG		(0xffffffffU)
 #define SQUASHFS_INVALID_XATTR		(0xffffffffU)
 #define SQUASHFS_INVALID_BLK		(-1LL)
-- 
1.7.8.4
