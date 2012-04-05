Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2DEPIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:08:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63254 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2DEO73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:59:29 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 29/34] ceph: remove unused arg from ceph_lookup_open()
Date: Thu,  5 Apr 2012 16:58:55 +0200
Message-Id: <1333637940-31884-30-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

What was the purpose of this?

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/ceph/dir.c   |    4 ++--
 fs/ceph/file.c  |    3 +--
 fs/ceph/super.h |    3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 3e8094b..c4b7832 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -599,7 +599,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 	    (nd->flags & LOOKUP_OPEN) &&
 	    !(nd->intent.open.flags & O_CREAT)) {
 		int mode = nd->intent.open.create_mode & ~current->fs->umask;
-		return ceph_lookup_open(dir, dentry, nd, mode, 1);
+		return ceph_lookup_open(dir, dentry, nd, mode);
 	}
 
 	/* can we conclude ENOENT locally? */
@@ -710,7 +710,7 @@ static int ceph_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	if (nd) {
 		BUG_ON((nd->flags & LOOKUP_OPEN) == 0);
-		dentry = ceph_lookup_open(dir, dentry, nd, mode, 0);
+		dentry = ceph_lookup_open(dir, dentry, nd, mode);
 		/* hrm, what should i do here if we get aliased? */
 		if (IS_ERR(dentry))
 			return PTR_ERR(dentry);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ed72428..2fe9a3e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -220,8 +220,7 @@ out:
  *  path_lookup_create -> LOOKUP_OPEN|LOOKUP_CREATE
  */
 struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
-				struct nameidata *nd, int mode,
-				int locked_dir)
+				struct nameidata *nd, int mode)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index fc35036..8471db9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -807,8 +807,7 @@ extern int ceph_copy_from_page_vector(struct page **pages,
 extern struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags);
 extern int ceph_open(struct inode *inode, struct file *file);
 extern struct dentry *ceph_lookup_open(struct inode *dir, struct dentry *dentry,
-				       struct nameidata *nd, int mode,
-				       int locked_dir);
+				       struct nameidata *nd, int mode);
 extern int ceph_release(struct inode *inode, struct file *filp);
 
 /* dir.c */
-- 
1.7.7

