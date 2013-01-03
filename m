Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab3ACKK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:10:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65502 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3ACKKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:10:53 -0500
X-AuditID: cbfec7f4-b7f6d6d000001620-84-50e559283367
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7/8] fs/configfs: checkpatch cleanup
Date: Thu, 03 Jan 2013 11:10:24 +0100
Message-id: <1357207825-10485-8-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
References: <1357207825-10485-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xy7oakU8DDH6tFbO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ5w9uZy+Yx1/xfO5HtgbGFTxdjJwcEgImEqu6NjJC2GISF+6t
	Z+ti5OIQEljKKHF71TNWCGcDk8Seze9YQKrYBIwl9h7sAOsQEVCQ2NwLUcQssJ5RYuL9BrCE
	MNDYUyuWMYPYLAKqEi8/vwGL8wq4Shy91sYEsU5e4un9PjYQm1PATeLLnUZ2EFsIqGb+lscs
	Exh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQI8fqXHYyLj1kdYhTgYFTi4V1R8yRA
	iDWxrLgy9xCjBAezkgjv9RygEG9KYmVValF+fFFpTmrxIUYmDk6pBkaWfQ9rN/EbLs9dv0LK
	6vPBczO53e7v3SG3ZpP269i3T1bnFD87+Gv/nyMcHz97zOd7fk3z2//b5lbrWhq+cU3uitXd
	vEY388ehPeH7v5jMu74k1EBGcldfzut5MSteXPJ1lOQ5sXTt102abCqbf/R5lP4IfvojM1yV
	t0xgztxXDj4L6o5GOcr7KbEUZyQaajEXFScCAGpg+tjYAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 fs/configfs/mount.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index aee0a7e..0815d62 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -19,7 +19,7 @@
  * Boston, MA 021110-1307, USA.
  *
  * Based on sysfs:
- * 	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
+ *	sysfs is Copyright (C) 2001, 2002, 2003 Patrick Mochel
  *
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
@@ -37,9 +37,9 @@
 /* Random magic number */
 #define CONFIGFS_MAGIC 0x62656570
 
-static struct vfsmount *configfs_mount = NULL;
+static struct vfsmount *configfs_mount;
 struct kmem_cache *configfs_dir_cachep;
-static int configfs_mnt_count = 0;
+static int configfs_mnt_count;
 
 static const struct super_operations configfs_ops = {
 	.statfs		= simple_statfs,
@@ -82,7 +82,7 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (inode) {
 		inode->i_op = &configfs_root_inode_operations;
 		inode->i_fop = &configfs_dir_operations;
-		/* directory inodes start off with i_nlink == 2 (for "." entry) */
+		/* directory inodes start off with i_nlink == 2 (for the ".") */
 		inc_nlink(inode);
 	} else {
 		pr_debug("configfs: could not get root inode\n");
@@ -91,7 +91,7 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	root = d_make_root(inode);
 	if (!root) {
-		pr_debug("%s: could not get root dentry!\n",__func__);
+		pr_debug("%s: could not get root dentry!\n", __func__);
 		return -ENOMEM;
 	}
 	config_group_init(&configfs_root_group);
@@ -154,7 +154,7 @@ static int __init configfs_init(void)
 
 	return 0;
 out4:
-	printk(KERN_ERR "configfs: Unable to register filesystem!\n");
+	pr_err("configfs: Unable to register filesystem!\n");
 	configfs_inode_exit();
 out3:
 	kobject_put(config_kobj);
-- 
1.7.0.4

