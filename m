Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934186Ab2FENNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:13:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab2FENLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:11:09 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz, Sage Weil <sage@newdream.net>
Subject: [PATCH 13/21] ceph: remove unused arg from ceph_lookup_open()
Date: Tue,  5 Jun 2012 15:10:24 +0200
Message-Id: <1338901832-14049-14-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

What was the purpose of this?

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Sage Weil <sage@newdream.net>
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
index 988d4f3..4bf9773 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -219,8 +219,7 @@ out:
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

