Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1CVMIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:08:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59018 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1CVMH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:07:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cFBIE5iSzSFQ+vSDHIcn0G85gha5r+wztCtgP9ufUVlt+B4WRpeItZcX+J9a77xH0g
         TEYuDnW1X07vnSvC9CO7xzJDggIx11GqmB45RbPtD34+Rr0PVT6gE5/7PFmZ3EvdsMYz
         F0TXWwbassSFr6//WbDCiMh0geewlj8nmkDnI=
Date: Tue, 22 Mar 2011 14:11:02 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jffs2: unused variables cleanup in jffs2_lookup and
 jffs2_readdir
Message-ID: <20110322121102.GC5086@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jffs2: cleanup unused jffs2_sb_info *c variable and JFFS2_SB_INFO call from jffs2_lookup 
and jffs2_readdir

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 fs/jffs2/dir.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 82faddd..4bca6a2 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -75,7 +75,6 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 				   struct nameidata *nd)
 {
 	struct jffs2_inode_info *dir_f;
-	struct jffs2_sb_info *c;
 	struct jffs2_full_dirent *fd = NULL, *fd_list;
 	uint32_t ino = 0;
 	struct inode *inode = NULL;
@@ -86,7 +85,6 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 		return ERR_PTR(-ENAMETOOLONG);
 
 	dir_f = JFFS2_INODE_INFO(dir_i);
-	c = JFFS2_SB_INFO(dir_i->i_sb);
 
 	mutex_lock(&dir_f->sem);
 
@@ -119,7 +117,6 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct jffs2_inode_info *f;
-	struct jffs2_sb_info *c;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct jffs2_full_dirent *fd;
 	unsigned long offset, curofs;
@@ -127,7 +124,6 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	D1(printk(KERN_DEBUG "jffs2_readdir() for dir_i #%lu\n", filp->f_path.dentry->d_inode->i_ino));
 
 	f = JFFS2_INODE_INFO(inode);
-	c = JFFS2_SB_INFO(inode->i_sb);
 
 	offset = filp->f_pos;
 

