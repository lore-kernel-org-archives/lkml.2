Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab2JZR4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:56:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:53663 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934045Ab2JZRz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:55:57 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] debugfs: break long lines
Date: Sat, 27 Oct 2012 01:55:44 +0800
Message-Id: <1351274144-31591-3-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
References: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/debugfs/file.c  |   42 ++++++++++++++++++++++++++++--------------
 fs/debugfs/inode.c |   10 ++++++----
 2 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 3915cc9..b37eee1 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -95,10 +95,12 @@ struct dentry *debugfs_create_u8(const char *name, umode_t mode,
 {
 	/* if there are no write bits set, make read only */
 	if (!(mode & S_IWUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u8_ro);
+		return debugfs_create_file(name, mode, parent, value,
+								&fops_u8_ro);
 	/* if there are no read bits set, make write only */
 	if (!(mode & S_IRUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u8_wo);
+		return debugfs_create_file(name, mode, parent, value,
+								&fops_u8_wo);
 
 	return debugfs_create_file(name, mode, parent, value, &fops_u8);
 }
@@ -147,10 +149,12 @@ struct dentry *debugfs_create_u16(const char *name, umode_t mode,
 {
 	/* if there are no write bits set, make read only */
 	if (!(mode & S_IWUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u16_ro);
+		return debugfs_create_file(name, mode, parent, value,
+								&fops_u16_ro);
 	/* if there are no read bits set, make write only */
 	if (!(mode & S_IRUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u16_wo);
+		return debugfs_create_file(name, mode, parent, value,
+								&fops_u16_wo);
 
 	return debugfs_create_file(name, mode, parent, value, &fops_u16);
 }
@@ -199,10 +203,12 @@ struct dentry *debugfs_create_u32(const char *name, umode_t mode,
 {
 	/* if there are no write bits set, make read only */
 	if (!(mode & S_IWUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u32_ro);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_u32_ro);
 	/* if there are no read bits set, make write only */
 	if (!(mode & S_IRUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u32_wo);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_u32_wo);
 
 	return debugfs_create_file(name, mode, parent, value, &fops_u32);
 }
@@ -252,10 +258,12 @@ struct dentry *debugfs_create_u64(const char *name, umode_t mode,
 {
 	/* if there are no write bits set, make read only */
 	if (!(mode & S_IWUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u64_ro);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_u64_ro);
 	/* if there are no read bits set, make write only */
 	if (!(mode & S_IRUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_u64_wo);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_u64_wo);
 
 	return debugfs_create_file(name, mode, parent, value, &fops_u64);
 }
@@ -298,10 +306,12 @@ struct dentry *debugfs_create_x8(const char *name, umode_t mode,
 {
 	/* if there are no write bits set, make read only */
 	if (!(mode & S_IWUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_x8_ro);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_x8_ro);
 	/* if there are no read bits set, make write only */
 	if (!(mode & S_IRUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_x8_wo);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_x8_wo);
 
 	return debugfs_create_file(name, mode, parent, value, &fops_x8);
 }
@@ -322,10 +332,12 @@ struct dentry *debugfs_create_x16(const char *name, umode_t mode,
 {
 	/* if there are no write bits set, make read only */
 	if (!(mode & S_IWUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_x16_ro);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_x16_ro);
 	/* if there are no read bits set, make write only */
 	if (!(mode & S_IRUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_x16_wo);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_x16_wo);
 
 	return debugfs_create_file(name, mode, parent, value, &fops_x16);
 }
@@ -346,10 +358,12 @@ struct dentry *debugfs_create_x32(const char *name, umode_t mode,
 {
 	/* if there are no write bits set, make read only */
 	if (!(mode & S_IWUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_x32_ro);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_x32_ro);
 	/* if there are no read bits set, make write only */
 	if (!(mode & S_IRUGO))
-		return debugfs_create_file(name, mode, parent, value, &fops_x32_wo);
+		return debugfs_create_file(name, mode, parent, value,
+								 &fops_x32_wo);
 
 	return debugfs_create_file(name, mode, parent, value, &fops_x32);
 }
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 58eadc1..edbaf37 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -34,8 +34,9 @@ static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 static bool debugfs_registered;
 
-static struct inode *debugfs_get_inode(struct super_block *sb, umode_t mode, dev_t dev,
-				       void *data, const struct file_operations *fops)
+static struct inode *debugfs_get_inode(struct super_block *sb, umode_t mode,
+				dev_t dev,  void *data,
+				const struct file_operations *fops)
 
 {
 	struct inode *inode = new_inode(sb);
@@ -110,8 +111,9 @@ static int debugfs_link(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return debugfs_mknod(dir, dentry, mode, 0, data, NULL);
 }
 
-static int debugfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-			  void *data, const struct file_operations *fops)
+static int debugfs_create(struct inode *dir, struct dentry *dentry,
+					umode_t mode, void *data,
+					const struct file_operations *fops)
 {
 	int res;
 
-- 
1.7.9.5

