Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3ACKMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:12:08 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65502 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3ACKKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:10:54 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-88-50e559287313
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 8/8] fs/configfs: checkpatch cleanup
Date: Thu, 03 Jan 2013 11:10:25 +0100
Message-id: <1357207825-10485-9-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
References: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJMWRmVeSWpSXmKPExsVy+t/xy7oakU8DDCYe07W4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZe3b9Yyo4IVnxYOIl1gbGZSJdjBwcEgImEpM+W3UxcgKZYhIX
	7q1n62Lk4hASWMoo8XLKFWYIZwOTxJ7N71hAqtgEjCX2HuxgBLFFBBQkNvc+YwUpYhZYzygx
	8X4DI8hUYaCpx3Zbg9SwCKhKHNq5lxXE5hVwlXh5oYUJYpu8xNP7fWwgNqeAm8SXO43sILYQ
	UM38LY9ZJjDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kR4vEvOxgXH7M6xCjAwajE
	w7ui5kmAEGtiWXFl7iFGCQ5mJRHe6zlAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzh/DuPiSzo
	PLdMLH77mgfcK6/feHazMDD6ye8VVfJ3di5VW64sefqiTnnwxq/T9N5qqtd1TmvVU/0cd3X+
	mlTbw11a99dFCsmk8yQbarn7xK47JezUOMHikvJp3tXnb23Zqj0n4kyjD4OZ351qGQG/v+E/
	C3RD5u//rlH4offyqdU7cj21snYrsRRnJBpqMRcVJwIAOH3q3tYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/configfs/symlink.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index cc9f254..cb9169d 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
@@ -35,17 +35,17 @@
 /* Protects attachments of new symlinks */
 DEFINE_MUTEX(configfs_symlink_mutex);
 
-static int item_depth(struct config_item * item)
+static int item_depth(struct config_item *item)
 {
-	struct config_item * p = item;
+	struct config_item *p = item;
 	int depth = 0;
 	do { depth++; } while ((p = p->ci_parent) && !configfs_is_root(p));
 	return depth;
 }
 
-static int item_path_length(struct config_item * item)
+static int item_path_length(struct config_item *item)
 {
-	struct config_item * p = item;
+	struct config_item *p = item;
 	int length = 1;
 	do {
 		length += strlen(config_item_name(p)) + 1;
@@ -54,9 +54,9 @@ static int item_path_length(struct config_item * item)
 	return length;
 }
 
-static void fill_item_path(struct config_item * item, char * buffer, int length)
+static void fill_item_path(struct config_item *item, char *buffer, int length)
 {
-	struct config_item * p;
+	struct config_item *p;
 
 	--length;
 	for (p = item; p && !configfs_is_root(p); p = p->ci_parent) {
@@ -64,7 +64,7 @@ static void fill_item_path(struct config_item * item, char * buffer, int length)
 
 		/* back up enough to print this bus id with '/' */
 		length -= cur;
-		strncpy(buffer + length,config_item_name(p),cur);
+		strncpy(buffer + length, config_item_name(p), cur);
 		*(buffer + --length) = '/';
 	}
 }
@@ -132,7 +132,8 @@ static int get_target(const char *symname, struct path *path,
 }
 
 
-int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
+int configfs_symlink(struct inode *dir, struct dentry *dentry,
+		     const char *symname)
 {
 	int ret;
 	struct path path;
@@ -232,10 +233,10 @@ out:
 	return ret;
 }
 
-static int configfs_get_target_path(struct config_item * item, struct config_item * target,
-				   char *path)
+static int configfs_get_target_path(struct config_item *item,
+				    struct config_item *target, char *path)
 {
-	char * s;
+	char *s;
 	int depth, size;
 
 	depth = item_depth(item);
@@ -246,7 +247,7 @@ static int configfs_get_target_path(struct config_item * item, struct config_ite
 	pr_debug("%s: depth = %d, size = %d\n", __func__, depth, size);
 
 	for (s = path; depth--; s += 3)
-		strcpy(s,"../");
+		strcpy(s, "../");
 
 	fill_item_path(target, path, size);
 	pr_debug("%s: path = '%s'\n", __func__, path);
@@ -254,7 +255,7 @@ static int configfs_get_target_path(struct config_item * item, struct config_ite
 	return 0;
 }
 
-static int configfs_getlink(struct dentry *dentry, char * path)
+static int configfs_getlink(struct dentry *dentry, char *path)
 {
 	struct config_item *item, *target_item;
 	int error = 0;
-- 
1.7.0.4

