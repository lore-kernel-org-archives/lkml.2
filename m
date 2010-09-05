Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0IESdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:33:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46186 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab0IESdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:33:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=toy7472JM8Px8W+xdbw/tdWRNirQPXI+xqbl7DDAyids+S01j0AvLMEv0KefuzDlzk
         e0MSjFyr87sDyOYO08tPFLd1NknMn0qMknDICrGZaLYLbauEQOedb+M3qpSf1gic7Zg5
         rylTtcfRMllJdMjShCXTAOgJG8rUltdP4VWI8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Jeff Dike <jdike@addtoit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] hppfs: check for IS_ERR() instead of != NULL
Date: Sun,  5 Sep 2010 22:32:56 +0400
Message-Id: <1283711577-7505-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Function get_inode may return ERR_PTR(...). Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 fs/hppfs/hppfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 7b02772..e7d6535 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -173,7 +173,7 @@ static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
 
 	err = -ENOMEM;
 	inode = get_inode(ino->i_sb, proc_dentry);
-	if (!inode)
+	if (IS_ERR_OR_NULL(inode))
 		goto out_dput;
 
  	d_add(dentry, inode);
@@ -730,7 +730,7 @@ static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
 
 	err = -ENOMEM;
 	root_inode = get_inode(sb, proc_mnt->mnt_sb->s_root);
-	if (!root_inode)
+	if (IS_ERR_OR_NULL(root_inode))
 		goto out_mntput;
 
 	sb->s_root = d_alloc_root(root_inode);
-- 
1.7.0.4

