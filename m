Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2I0MwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61278 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab2I0MwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:22 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] fs/namespace.c: trivial code clean
Date: Thu, 27 Sep 2012 20:51:51 +0800
Message-Id: <1348750316-4138-3-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
References: <no>
 <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index dd969f8..bbe9014 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -763,7 +763,7 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 
 	mnt->mnt.mnt_root = root;
 	mnt->mnt.mnt_sb = root->d_sb;
-	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
+	mnt->mnt_mountpoint = root;
 	mnt->mnt_parent = mnt;
 	br_write_lock(&vfsmount_lock);
 	list_add_tail(&mnt->mnt_instance, &root->d_sb->s_mounts);
@@ -798,7 +798,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_sb = sb;
 	mnt->mnt.mnt_root = dget(root);
-	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
+	mnt->mnt_mountpoint = root;
 	mnt->mnt_parent = mnt;
 	br_write_lock(&vfsmount_lock);
 	list_add_tail(&mnt->mnt_instance, &sb->s_mounts);
-- 
1.7.9.5

