Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2HHGYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:24:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14721 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2HHGYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:24:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 07 Aug 2012 23:24:52 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: <iommu@lists.linux-foundation.org>, <linux-tegra@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] debugfs: Allow debugfs_create_dir() to take data
Date: Wed, 8 Aug 2012 09:24:32 +0300
Message-ID: <1344407073-12030-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __debugfs_create_dir(), which takes data passed from caller.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 fs/debugfs/inode.c      |    7 ++++---
 include/linux/debugfs.h |    9 ++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4733eab..423df9f 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -387,7 +387,7 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 EXPORT_SYMBOL_GPL(debugfs_create_file);
 
 /**
- * debugfs_create_dir - create a directory in the debugfs filesystem
+ * __debugfs_create_dir - create a directory in the debugfs filesystem
  * @name: a pointer to a string containing the name of the directory to
  *        create.
  * @parent: a pointer to the parent dentry for this file.  This should be a
@@ -404,10 +404,11 @@ EXPORT_SYMBOL_GPL(debugfs_create_file);
  * If debugfs is not enabled in the kernel, the value -%ENODEV will be
  * returned.
  */
-struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
+struct dentry *__debugfs_create_dir(const char *name, struct dentry *parent,
+				    void *data)
 {
 	return __create_file(name, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-				   parent, NULL, NULL);
+				   parent, data, NULL);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
 
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 66c434f..4ba9f0a 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -50,7 +50,14 @@ struct dentry *debugfs_create_file(const char *name, umode_t mode,
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops);
 
-struct dentry *debugfs_create_dir(const char *name, struct dentry *parent);
+struct dentry *__debugfs_create_dir(const char *name, struct dentry *parent,
+				    void *data);
+
+static inline struct dentry *debugfs_create_dir(const char *name,
+						struct dentry *parent)
+{
+	return __debugfs_create_dir(name, parent, NULL);
+}
 
 struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *dest);
-- 
1.7.5.4

