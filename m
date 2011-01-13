Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1AMWQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:16:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53237 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab1AMWQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:16:43 -0500
Date: Thu, 13 Jan 2011 22:16:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] ECRYPT_FS
Message-ID: <20110113221642.GR19804@ZenIV.linux.org.uk>
References: <1294950181.3403.9.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294950181.3403.9.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 09:23:01PM +0100, Eric Dumazet wrote:
> Hi Al
> 
> FYI, current linux-2.6 is broken for CONFIG_ECRYPT_FS
> 
> commit 66cb76666d69502fe982990b2cff5b6d607fd3b1
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Wed Jan 12 20:04:37 2011 -0500

Ugh...  Unfolded compile fix lost in branch reordering.  My apologies ;-/

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Wed, 12 Jan 2011 20:32:19 -0500
Subject: foldme

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ecryptfs/main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 9ed4769..d3b28ab 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -141,13 +141,12 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 	return rc;
 }
 
-static inode *ecryptfs_get_inode(struct inode *lower_inode,
+static struct inode *ecryptfs_get_inode(struct inode *lower_inode,
 		       struct super_block *sb)
 {
 	struct inode *inode;
 	int rc = 0;
 
-	lower_inode = lower_dentry->d_inode;
 	if (lower_inode->i_sb != ecryptfs_superblock_to_lower(sb)) {
 		rc = -EXDEV;
 		goto out;
@@ -202,7 +201,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 {
 	struct inode *lower_inode = lower_dentry->d_inode;
 	struct inode *inode = ecryptfs_get_inode(lower_inode, sb);
-	if (IS_ERR(inode)
+	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
 		d_add(dentry, inode);

