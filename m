Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0FEFZD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 01:25:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:56431 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab0FEFZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 01:25:00 -0400
Date: Sat, 05 Jun 2010 14:24:54 +0900 (JST)
Message-Id: <20100605.142454.18033406.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 fixes
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 05 Jun 2010 14:24:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following fixes.  A style fix and a cleanup, both of which
are against changes in rc1.

Thanks,

Ryusuke Konishi
--
The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
  Linus Torvalds (1):
        Linux 2.6.35-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Ryusuke Konishi (2):
      nilfs2: fix style issue in nilfs_destroy_cachep
      nilfs2: remove obsolete declarations of cache constructor and destructor

 fs/nilfs2/btree.h   |    2 --
 fs/nilfs2/segbuf.h  |    2 --
 fs/nilfs2/segment.h |    2 --
 fs/nilfs2/super.c   |    8 ++++----
 4 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/btree.h b/fs/nilfs2/btree.h
index af638d5..43c8c5b 100644
--- a/fs/nilfs2/btree.h
+++ b/fs/nilfs2/btree.h
@@ -75,8 +75,6 @@ struct nilfs_btree_path {
 
 extern struct kmem_cache *nilfs_btree_path_cache;
 
-int nilfs_btree_path_cache_init(void);
-void nilfs_btree_path_cache_destroy(void);
 int nilfs_btree_init(struct nilfs_bmap *);
 int nilfs_btree_convert_and_insert(struct nilfs_bmap *, __u64, __u64,
 				   const __u64 *, const __u64 *, int);
diff --git a/fs/nilfs2/segbuf.h b/fs/nilfs2/segbuf.h
index fdf1c3b..85fbb66 100644
--- a/fs/nilfs2/segbuf.h
+++ b/fs/nilfs2/segbuf.h
@@ -127,8 +127,6 @@ struct nilfs_segment_buffer {
 
 extern struct kmem_cache *nilfs_segbuf_cachep;
 
-int __init nilfs_init_segbuf_cache(void);
-void nilfs_destroy_segbuf_cache(void);
 struct nilfs_segment_buffer *nilfs_segbuf_new(struct super_block *);
 void nilfs_segbuf_free(struct nilfs_segment_buffer *);
 void nilfs_segbuf_map(struct nilfs_segment_buffer *, __u64, unsigned long,
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index dca1423..01e20db 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -221,8 +221,6 @@ enum {
 extern struct kmem_cache *nilfs_transaction_cachep;
 
 /* segment.c */
-extern int nilfs_init_transaction_cache(void);
-extern void nilfs_destroy_transaction_cache(void);
 extern void nilfs_relax_pressure_in_lock(struct super_block *);
 
 extern int nilfs_construct_segment(struct super_block *);
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 03b34b7..414ef68 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1130,13 +1130,13 @@ static void nilfs_segbuf_init_once(void *obj)
 
 static void nilfs_destroy_cachep(void)
 {
-	 if (nilfs_inode_cachep)
+	if (nilfs_inode_cachep)
 		kmem_cache_destroy(nilfs_inode_cachep);
-	 if (nilfs_transaction_cachep)
+	if (nilfs_transaction_cachep)
 		kmem_cache_destroy(nilfs_transaction_cachep);
-	 if (nilfs_segbuf_cachep)
+	if (nilfs_segbuf_cachep)
 		kmem_cache_destroy(nilfs_segbuf_cachep);
-	 if (nilfs_btree_path_cache)
+	if (nilfs_btree_path_cache)
 		kmem_cache_destroy(nilfs_btree_path_cache);
 }
 
