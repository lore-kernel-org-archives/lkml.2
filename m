Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0LQMqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab0LQMqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:09 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/15] GFS2: Remove unreachable calls to vmtruncate
Date: Fri, 17 Dec 2010 12:24:09 +0000
Message-Id: <1292588661-14350-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index e1213f7..14e682d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -916,17 +916,8 @@ static int __gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr)
 	if (error)
 		return error;
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		error = vmtruncate(inode, attr->ia_size);
-		if (error)
-			return error;
-	}
-
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
-
-	gfs2_assert_warn(GFS2_SB(inode), !error);
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 12cbea7..457ecd1 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1104,17 +1104,8 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (error)
 		goto out_end_trans;
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		int error;
-
-		error = vmtruncate(inode, attr->ia_size);
-		gfs2_assert_warn(sdp, !error);
-	}
-
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
-
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 30b58f0..ecfd40d 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -1325,17 +1325,8 @@ int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 	if (error)
 		goto out_trans_end;
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode)) {
-		int error;
-
-		error = vmtruncate(inode, attr->ia_size);
-		gfs2_assert_warn(GFS2_SB(inode), !error);
-	}
-
 	setattr_copy(inode, attr);
 	mark_inode_dirty(inode);
-
 	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
-- 
1.7.3.3

