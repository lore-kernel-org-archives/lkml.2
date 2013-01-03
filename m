Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3ACLnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 06:43:14 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21269 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab3ACLm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 06:42:56 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-9d-50e56ebd1fdd
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 7/8] fs/configfs: mount.c checkpatch cleanup
Date: Thu, 03 Jan 2013 12:42:40 +0100
Message-id: <1357213361-23620-8-git-send-email-andrzej.p@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
References: <"Message-id: <CAHdPZaNZQcS3YggV5rGkBGULp3BBBXXeeRn4BhTgNfLci0=AwA"@mail.gmail.com>
 <1357213361-23620-1-git-send-email-andrzej.p@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJMWRmVeSWpSXmKPExsVy+t/xq7p7854GGPR1Mltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mjqmz2AoOCVT8+jGLsYFxF28XIyeHhICJxOKZnawQtpjEhXvr
	2boYuTiEBJYySvw88ZEdwtnAJPF34mwmkCo2AWOJvQc7GEFsEQEFic29z1hBipgF1jNKTLzf
	AJYQFrCRmDi3GcxmEVCVODbjMVARBwevgKtE994oiG3yEk/v97GB2JwCbhIr+5ewQiybyyjx
	bel61gmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihHj96w7GpcesDjEKcDAq8fAy
	1j8JEGJNLCuuzD3EKMHBrCTCez0HKMSbklhZlVqUH19UmpNafIiRiYNTqoFR+KPjnFh+O/EM
	18dRM59aRkYEJH6+KzH3WIDau460QPsVBsfm1jtucju0o+ux74R3+X03ntzZ+na5z+y9C04b
	MUaHPt7amSSySLHNdva+LRltrlx2Ql3zPokoR+zO2p90Mb3y99Mly//OuS9mGblowjNW539X
	4wQVEqRWpvev615w7YyW2ZsgJZbijERDLeai4kQAPSXDTtgBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate checkpatch errors and warnings

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
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

