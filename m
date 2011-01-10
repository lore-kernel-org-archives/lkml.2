Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1AJBHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 20:07:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab1AJBHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 20:07:50 -0500
Date: Mon, 10 Jan 2011 12:07:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: linux-next: manual merge of the nilfs2 tree with the  tree
Message-Id: <20110110120746.7cd287b0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryusuke,

Today's linux-next merge of the nilfs2 tree got a conflict in
fs/nilfs2/nilfs.h between commit b74c79e99389cd79b31fcc08f82c24e492e63c7e
("fs: provide rcu-walk aware permission i_ops") from Linus' tree and
commit aa9ded135baf342ec5a299b254f0e0dbd5c3c0f0 ("nilfs2: do not pass sbi
to functions which can get it from inode") from the nilfs2 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nilfs2/nilfs.h
index 0ca9882,04ba110..0000000
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@@ -256,14 -251,14 +251,14 @@@ extern void nilfs_update_inode(struct i
  extern void nilfs_truncate(struct inode *);
  extern void nilfs_evict_inode(struct inode *);
  extern int nilfs_setattr(struct dentry *, struct iattr *);
 -int nilfs_permission(struct inode *inode, int mask);
 +int nilfs_permission(struct inode *inode, int mask, unsigned int flags);
- extern int nilfs_load_inode_block(struct nilfs_sb_info *, struct inode *,
- 				  struct buffer_head **);
+ int nilfs_load_inode_block(struct inode *inode, struct buffer_head **pbh);
  extern int nilfs_inode_dirty(struct inode *);
- extern int nilfs_set_file_dirty(struct nilfs_sb_info *, struct inode *,
- 				unsigned);
+ int nilfs_set_file_dirty(struct inode *inode, unsigned nr_dirty);
  extern int nilfs_mark_inode_dirty(struct inode *);
  extern void nilfs_dirty_inode(struct inode *);
+ int nilfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+ 		 __u64 start, __u64 len);
  
  /* super.c */
  extern struct inode *nilfs_alloc_inode(struct super_block *);
