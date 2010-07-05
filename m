Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0GEACn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 20:02:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49913 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab0GEACm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 20:02:42 -0400
Date: Mon, 5 Jul 2010 10:02:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiro SEKIBA <jir@unicus.jp>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: linux-next: manual merge of the vfs tree with the nilfs tree
Message-Id: <20100705100239.9f92d5e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/nilfs2/super.c between commit 9fafbf39607e8002f90ca24b74ccd5be5087e50f
("nilfs2: sync super blocks in turns") from the nilfs tree and commit
030c97b8a358cc3d6322b64ecb67adb849e27cd1 ("convert nilfs2 to
->evict_inode()") from the vfs tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nilfs2/super.c
index 29be735,7c7572a..0000000
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@@ -168,24 -159,7 +168,7 @@@ void nilfs_destroy_inode(struct inode *
  	kmem_cache_free(nilfs_inode_cachep, NILFS_I(inode));
  }
  
- static void nilfs_clear_inode(struct inode *inode)
- {
- 	struct nilfs_inode_info *ii = NILFS_I(inode);
- 
- 	/*
- 	 * Free resources allocated in nilfs_read_inode(), here.
- 	 */
- 	BUG_ON(!list_empty(&ii->i_dirty));
- 	brelse(ii->i_bh);
- 	ii->i_bh = NULL;
- 
- 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
- 		nilfs_bmap_clear(ii->i_bmap);
- 
- 	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
- }
- 
 -static int nilfs_sync_super(struct nilfs_sb_info *sbi, int dupsb)
 +static int nilfs_sync_super(struct nilfs_sb_info *sbi, int flag)
  {
  	struct the_nilfs *nilfs = sbi->s_nilfs;
  	int err;
