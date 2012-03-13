Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357Ab2CMJqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:46:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48524 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252Ab2CMJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:46:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="169647444"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCHv2 1/3] libfs: Add simple_open()
Date: Tue, 13 Mar 2012 02:46:26 -0700
Message-Id: <1331631988-20527-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
References: <1331631988-20527-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs and a few other drivers use a version of simple_open() to
pass a pointer from the file to the read/write file ops. Add
support for this simple case to libfs so that we can remove the
many duplicate copies of this simple function.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

 Changes since v1: None

 fs/libfs.c         |    8 ++++++++
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index 7c895a7..f5af1d6 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -264,6 +264,13 @@ Enomem:
 	return ERR_PTR(-ENOMEM);
 }
 
+int simple_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+	return 0;
+}
+
 int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = old_dentry->d_inode;
@@ -984,6 +991,7 @@ EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
 EXPORT_SYMBOL(simple_fill_super);
 EXPORT_SYMBOL(simple_getattr);
+EXPORT_SYMBOL(simple_open);
 EXPORT_SYMBOL(simple_link);
 EXPORT_SYMBOL(simple_lookup);
 EXPORT_SYMBOL(simple_pin_fs);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f42a557..7871f90 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2517,6 +2517,7 @@ extern int dcache_readdir(struct file *, void *, filldir_t);
 extern int simple_setattr(struct dentry *, struct iattr *);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
+extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

