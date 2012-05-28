Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab2E1Llb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:41:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:44519 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab2E1Ll2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:41:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157891447"
Date: Mon, 28 May 2012 19:41:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] writeback changes for 3.5-rc1
Message-ID: <20120528114124.GA6813@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the writeback changes, mainly from Jan Kara to avoid
iput() in the flusher threads.

Thanks,
Fengguang
---

The following changes since commit 668ce0ac707719d866af7e432e518af7b4c575ad:

  Merge branch 'systemh-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux (2012-04-13 19:44:36 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback

for you to fetch changes up to 169ebd90131b2ffca74bb2dbe7eeacd39fb83714:

  writeback: Avoid iput() from flusher thread (2012-05-06 13:43:41 +0800)

----------------------------------------------------------------
avoid iput() from flusher thread

----------------------------------------------------------------
Fengguang Wu (1):
      writeback: initialize global_dirty_limit

H Hartley Sweeten (1):
      mm: page-writeback.c: local functions should not be exposed globally

Jan Kara (9):
      writeback: Move clearing of I_SYNC into inode_sync_complete()
      writeback: Move requeueing when I_SYNC set to writeback_sb_inodes()
      writeback: Move I_DIRTY_PAGES handling
      writeback: Separate inode requeueing after writeback
      writeback: Remove wb->list_lock from writeback_single_inode()
      writeback: Refactor writeback_single_inode()
      vfs: Move waiting for inode writeback from end_writeback() to evict_inode()
      vfs: Rename end_writeback() to clear_inode()
      writeback: Avoid iput() from flusher thread

Richard Kennedy (1):
      fs: remove 8 bytes of padding from struct writeback_control on 64 bit builds

 Documentation/filesystems/porting         |   16 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    2 +-
 arch/s390/hypfs/inode.c                   |    2 +-
 fs/9p/vfs_inode.c                         |    2 +-
 fs/affs/inode.c                           |    2 +-
 fs/afs/inode.c                            |    2 +-
 fs/autofs4/inode.c                        |    2 +-
 fs/bfs/inode.c                            |    2 +-
 fs/binfmt_misc.c                          |    2 +-
 fs/block_dev.c                            |    2 +-
 fs/btrfs/inode.c                          |    2 +-
 fs/cifs/cifsfs.c                          |    2 +-
 fs/coda/inode.c                           |    2 +-
 fs/ecryptfs/super.c                       |    2 +-
 fs/exofs/inode.c                          |    4 +-
 fs/ext2/inode.c                           |    2 +-
 fs/ext3/inode.c                           |    6 +-
 fs/ext4/super.c                           |    2 +-
 fs/fat/inode.c                            |    2 +-
 fs/freevxfs/vxfs_inode.c                  |    2 +-
 fs/fs-writeback.c                         |  336 ++++++++++++++++++-----------
 fs/fuse/inode.c                           |    2 +-
 fs/gfs2/super.c                           |    2 +-
 fs/hfs/inode.c                            |    2 +-
 fs/hfsplus/super.c                        |    2 +-
 fs/hostfs/hostfs_kern.c                   |    2 +-
 fs/hpfs/inode.c                           |    2 +-
 fs/hppfs/hppfs.c                          |    2 +-
 fs/hugetlbfs/inode.c                      |    2 +-
 fs/inode.c                                |   15 +-
 fs/jffs2/fs.c                             |    2 +-
 fs/jfs/inode.c                            |    2 +-
 fs/logfs/readwrite.c                      |    2 +-
 fs/minix/inode.c                          |    2 +-
 fs/ncpfs/inode.c                          |    2 +-
 fs/nfs/inode.c                            |    4 +-
 fs/nilfs2/inode.c                         |    4 +-
 fs/ntfs/inode.c                           |    2 +-
 fs/ocfs2/dlmfs/dlmfs.c                    |    2 +-
 fs/ocfs2/inode.c                          |    2 +-
 fs/omfs/inode.c                           |    2 +-
 fs/proc/inode.c                           |    2 +-
 fs/pstore/inode.c                         |    2 +-
 fs/reiserfs/inode.c                       |    4 +-
 fs/sysfs/inode.c                          |    2 +-
 fs/sysv/inode.c                           |    2 +-
 fs/ubifs/super.c                          |    2 +-
 fs/udf/inode.c                            |    2 +-
 fs/ufs/inode.c                            |    2 +-
 fs/xfs/xfs_super.c                        |    2 +-
 include/linux/fs.h                        |   13 +-
 include/linux/writeback.h                 |   10 +-
 include/trace/events/writeback.h          |   36 +++-
 ipc/mqueue.c                              |    2 +-
 mm/page-writeback.c                       |    3 +-
 mm/shmem.c                                |    2 +-
 56 files changed, 319 insertions(+), 220 deletions(-)

diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 74acd96..8c91d10 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -297,7 +297,8 @@ in the beginning of ->setattr unconditionally.
 be used instead.  It gets called whenever the inode is evicted, whether it has
 remaining links or not.  Caller does *not* evict the pagecache or inode-associated
 metadata buffers; getting rid of those is responsibility of method, as it had
-been for ->delete_inode().
+been for ->delete_inode(). Caller makes sure async writeback cannot be running
+for the inode while (or after) ->evict_inode() is called.
 
 	->drop_inode() returns int now; it's called on final iput() with
 inode->i_lock held and it returns true if filesystems wants the inode to be
@@ -306,14 +307,11 @@ updated appropriately.  generic_delete_inode() is also alive and it consists
 simply of return 1.  Note that all actual eviction work is done by caller after
 ->drop_inode() returns.
 
-	clear_inode() is gone; use end_writeback() instead.  As before, it must
-be called exactly once on each call of ->evict_inode() (as it used to be for
-each call of ->delete_inode()).  Unlike before, if you are using inode-associated
-metadata buffers (i.e. mark_buffer_dirty_inode()), it's your responsibility to
-call invalidate_inode_buffers() before end_writeback().
-	No async writeback (and thus no calls of ->write_inode()) will happen
-after end_writeback() returns, so actions that should not overlap with ->write_inode()
-(e.g. freeing on-disk inode if i_nlink is 0) ought to be done after that call.
+	As before, clear_inode() must be called exactly once on each call of
+->evict_inode() (as it used to be for each call of ->delete_inode()).  Unlike
+before, if you are using inode-associated metadata buffers (i.e.
+mark_buffer_dirty_inode()), it's your responsibility to call
+invalidate_inode_buffers() before clear_inode().
 
 	NOTE: checking i_nlink in the beginning of ->write_inode() and bailing out
 if it's zero is not *and* *never* *had* *been* enough.  Final unlink() and iput()
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 1d75c92..66519d2 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -151,7 +151,7 @@ static void
 spufs_evict_inode(struct inode *inode)
 {
 	struct spufs_inode_info *ei = SPUFS_I(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (ei->i_ctx)
 		put_spu_context(ei->i_ctx);
 	if (ei->i_gang)
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 6a2cb56..73dae8b 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -115,7 +115,7 @@ static struct inode *hypfs_make_inode(struct super_block *sb, umode_t mode)
 
 static void hypfs_evict_inode(struct inode *inode)
 {
-	end_writeback(inode);
+	clear_inode(inode);
 	kfree(inode->i_private);
 }
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 014c8dd..57ccb75 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -448,7 +448,7 @@ void v9fs_evict_inode(struct inode *inode)
 	struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	truncate_inode_pages(inode->i_mapping, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	filemap_fdatawrite(inode->i_mapping);
 
 #ifdef CONFIG_9P_FSCACHE
diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index 88a4b0b..8bc4a59 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -264,7 +264,7 @@ affs_evict_inode(struct inode *inode)
 	}
 
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	affs_free_prealloc(inode);
 	cache_page = (unsigned long)AFFS_I(inode)->i_lc;
 	if (cache_page) {
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index d890ae3..95cffd3 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -423,7 +423,7 @@ void afs_evict_inode(struct inode *inode)
 	ASSERTCMP(inode->i_ino, ==, vnode->fid.vnode);
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	afs_give_up_callback(vnode);
 
diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
index d8dc002..df31ddb 100644
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -101,7 +101,7 @@ static int autofs4_show_options(struct seq_file *m, struct dentry *root)
 
 static void autofs4_evict_inode(struct inode *inode)
 {
-	end_writeback(inode);
+	clear_inode(inode);
 	kfree(inode->i_private);
 }
 
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index e23dc7c..9870417 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -174,7 +174,7 @@ static void bfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages(&inode->i_data, 0);
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (inode->i_nlink)
 		return;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 613aa06..790b3cd 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -505,7 +505,7 @@ static struct inode *bm_get_inode(struct super_block *sb, int mode)
 
 static void bm_evict_inode(struct inode *inode)
 {
-	end_writeback(inode);
+	clear_inode(inode);
 	kfree(inode->i_private);
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index e08f6a20..d8a7959 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -487,7 +487,7 @@ static void bdev_evict_inode(struct inode *inode)
 	struct list_head *p;
 	truncate_inode_pages(&inode->i_data, 0);
 	invalidate_inode_buffers(inode); /* is it needed here? */
-	end_writeback(inode);
+	clear_inode(inode);
 	spin_lock(&bdev_lock);
 	while ( (p = bdev->bd_inodes.next) != &bdev->bd_inodes ) {
 		__bd_forget(list_entry(p, struct inode, i_devices));
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 115bc05..5c058c4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3756,7 +3756,7 @@ void btrfs_evict_inode(struct inode *inode)
 	btrfs_end_transaction(trans, root);
 	btrfs_btree_balance_dirty(root, nr);
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 	return;
 }
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d342128..acb138f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -272,7 +272,7 @@ static void
 cifs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	cifs_fscache_release_inode_cookie(inode);
 }
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 2870597..f181312 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -244,7 +244,7 @@ static void coda_put_super(struct super_block *sb)
 static void coda_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	coda_cache_clear_inode(inode);
 }
 
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 2dd946b..e879cf8 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -133,7 +133,7 @@ static int ecryptfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 static void ecryptfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	iput(ecryptfs_inode_to_lower(inode));
 }
 
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index ea5e1f9..5badb0c 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1473,7 +1473,7 @@ void exofs_evict_inode(struct inode *inode)
 		goto no_delete;
 
 	inode->i_size = 0;
-	end_writeback(inode);
+	clear_inode(inode);
 
 	/* if we are deleting an obj that hasn't been created yet, wait.
 	 * This also makes sure that create_done cannot be called with an
@@ -1503,5 +1503,5 @@ void exofs_evict_inode(struct inode *inode)
 	return;
 
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 }
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 740cad8..37b8bf6 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -90,7 +90,7 @@ void ext2_evict_inode(struct inode * inode)
 	}
 
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	ext2_discard_reservation(inode);
 	rsv = EXT2_I(inode)->i_block_alloc_info;
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 10d7812..ca5eb61 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -272,18 +272,18 @@ void ext3_evict_inode (struct inode *inode)
 	if (ext3_mark_inode_dirty(handle, inode)) {
 		/* If that failed, just dquot_drop() and be done with that */
 		dquot_drop(inode);
-		end_writeback(inode);
+		clear_inode(inode);
 	} else {
 		ext3_xattr_delete_inode(handle, inode);
 		dquot_free_inode(inode);
 		dquot_drop(inode);
-		end_writeback(inode);
+		clear_inode(inode);
 		ext3_free_inode(handle, inode);
 	}
 	ext3_journal_stop(handle);
 	return;
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ceebaf8..2484f56 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1007,7 +1007,7 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 	ext4_discard_preallocations(inode);
 	if (EXT4_I(inode)->jinode) {
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 21687e3..b3d290c 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -454,7 +454,7 @@ static void fat_evict_inode(struct inode *inode)
 		fat_truncate_blocks(inode, 0);
 	}
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	fat_cache_inval_inode(inode);
 	fat_detach(inode);
 }
diff --git a/fs/freevxfs/vxfs_inode.c b/fs/freevxfs/vxfs_inode.c
index cf9ef91..ef67c95 100644
--- a/fs/freevxfs/vxfs_inode.c
+++ b/fs/freevxfs/vxfs_inode.c
@@ -355,6 +355,6 @@ void
 vxfs_evict_inode(struct inode *ip)
 {
 	truncate_inode_pages(&ip->i_data, 0);
-	end_writeback(ip);
+	clear_inode(ip);
 	call_rcu(&ip->i_rcu, vxfs_i_callback);
 }
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 539f36c..8d2fb8c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -231,11 +231,8 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
 
 static void inode_sync_complete(struct inode *inode)
 {
-	/*
-	 * Prevent speculative execution through
-	 * spin_unlock(&wb->list_lock);
-	 */
-
+	inode->i_state &= ~I_SYNC;
+	/* Waiters must see I_SYNC cleared before being woken up */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
 }
@@ -329,10 +326,12 @@ static int write_inode(struct inode *inode, struct writeback_control *wbc)
 }
 
 /*
- * Wait for writeback on an inode to complete.
+ * Wait for writeback on an inode to complete. Called with i_lock held.
+ * Caller must make sure inode cannot go away when we drop i_lock.
  */
-static void inode_wait_for_writeback(struct inode *inode,
-				     struct bdi_writeback *wb)
+static void __inode_wait_for_writeback(struct inode *inode)
+	__releases(inode->i_lock)
+	__acquires(inode->i_lock)
 {
 	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 	wait_queue_head_t *wqh;
@@ -340,70 +339,119 @@ static void inode_wait_for_writeback(struct inode *inode,
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&wb->list_lock);
 		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
-		spin_lock(&wb->list_lock);
 		spin_lock(&inode->i_lock);
 	}
 }
 
 /*
- * Write out an inode's dirty pages.  Called under wb->list_lock and
- * inode->i_lock.  Either the caller has an active reference on the inode or
- * the inode has I_WILL_FREE set.
- *
- * If `wait' is set, wait on the writeout.
- *
- * The whole writeout design is quite complex and fragile.  We want to avoid
- * starvation of particular inodes when others are being redirtied, prevent
- * livelocks, etc.
+ * Wait for writeback on an inode to complete. Caller must have inode pinned.
  */
-static int
-writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
-		       struct writeback_control *wbc)
+void inode_wait_for_writeback(struct inode *inode)
 {
-	struct address_space *mapping = inode->i_mapping;
-	long nr_to_write = wbc->nr_to_write;
-	unsigned dirty;
-	int ret;
+	spin_lock(&inode->i_lock);
+	__inode_wait_for_writeback(inode);
+	spin_unlock(&inode->i_lock);
+}
 
-	assert_spin_locked(&wb->list_lock);
-	assert_spin_locked(&inode->i_lock);
+/*
+ * Sleep until I_SYNC is cleared. This function must be called with i_lock
+ * held and drops it. It is aimed for callers not holding any inode reference
+ * so once i_lock is dropped, inode can go away.
+ */
+static void inode_sleep_on_writeback(struct inode *inode)
+	__releases(inode->i_lock)
+{
+	DEFINE_WAIT(wait);
+	wait_queue_head_t *wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
+	int sleep;
 
-	if (!atomic_read(&inode->i_count))
-		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
-	else
-		WARN_ON(inode->i_state & I_WILL_FREE);
+	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
+	sleep = inode->i_state & I_SYNC;
+	spin_unlock(&inode->i_lock);
+	if (sleep)
+		schedule();
+	finish_wait(wqh, &wait);
+}
 
-	if (inode->i_state & I_SYNC) {
+/*
+ * Find proper writeback list for the inode depending on its current state and
+ * possibly also change of its state while we were doing writeback.  Here we
+ * handle things such as livelock prevention or fairness of writeback among
+ * inodes. This function can be called only by flusher thread - noone else
+ * processes all inodes in writeback lists and requeueing inodes behind flusher
+ * thread's back can have unexpected consequences.
+ */
+static void requeue_inode(struct inode *inode, struct bdi_writeback *wb,
+			  struct writeback_control *wbc)
+{
+	if (inode->i_state & I_FREEING)
+		return;
+
+	/*
+	 * Sync livelock prevention. Each inode is tagged and synced in one
+	 * shot. If still dirty, it will be redirty_tail()'ed below.  Update
+	 * the dirty time to prevent enqueue and sync it again.
+	 */
+	if ((inode->i_state & I_DIRTY) &&
+	    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
+		inode->dirtied_when = jiffies;
+
+	if (wbc->pages_skipped) {
 		/*
-		 * If this inode is locked for writeback and we are not doing
-		 * writeback-for-data-integrity, move it to b_more_io so that
-		 * writeback can proceed with the other inodes on s_io.
-		 *
-		 * We'll have another go at writing back this inode when we
-		 * completed a full scan of b_io.
+		 * writeback is not making progress due to locked
+		 * buffers. Skip this inode for now.
 		 */
-		if (wbc->sync_mode != WB_SYNC_ALL) {
+		redirty_tail(inode, wb);
+		return;
+	}
+
+	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY)) {
+		/*
+		 * We didn't write back all the pages.  nfs_writepages()
+		 * sometimes bales out without doing anything.
+		 */
+		if (wbc->nr_to_write <= 0) {
+			/* Slice used up. Queue for next turn. */
 			requeue_io(inode, wb);
-			trace_writeback_single_inode_requeue(inode, wbc,
-							     nr_to_write);
-			return 0;
+		} else {
+			/*
+			 * Writeback blocked by something other than
+			 * congestion. Delay the inode for some time to
+			 * avoid spinning on the CPU (100% iowait)
+			 * retrying writeback of the dirty page/inode
+			 * that cannot be performed immediately.
+			 */
+			redirty_tail(inode, wb);
 		}
-
+	} else if (inode->i_state & I_DIRTY) {
 		/*
-		 * It's a data-integrity sync.  We must wait.
+		 * Filesystems can dirty the inode during writeback operations,
+		 * such as delayed allocation during submission or metadata
+		 * updates after data IO completion.
 		 */
-		inode_wait_for_writeback(inode, wb);
+		redirty_tail(inode, wb);
+	} else {
+		/* The inode is clean. Remove from writeback lists. */
+		list_del_init(&inode->i_wb_list);
 	}
+}
 
-	BUG_ON(inode->i_state & I_SYNC);
+/*
+ * Write out an inode and its dirty pages. Do not update the writeback list
+ * linkage. That is left to the caller. The caller is also responsible for
+ * setting I_SYNC flag and calling inode_sync_complete() to clear it.
+ */
+static int
+__writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
+			 struct writeback_control *wbc)
+{
+	struct address_space *mapping = inode->i_mapping;
+	long nr_to_write = wbc->nr_to_write;
+	unsigned dirty;
+	int ret;
 
-	/* Set I_SYNC, reset I_DIRTY_PAGES */
-	inode->i_state |= I_SYNC;
-	inode->i_state &= ~I_DIRTY_PAGES;
-	spin_unlock(&inode->i_lock);
-	spin_unlock(&wb->list_lock);
+	WARN_ON(!(inode->i_state & I_SYNC));
 
 	ret = do_writepages(mapping, wbc);
 
@@ -424,6 +472,9 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	 * write_inode()
 	 */
 	spin_lock(&inode->i_lock);
+	/* Clear I_DIRTY_PAGES if we've written out all dirty pages */
+	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
+		inode->i_state &= ~I_DIRTY_PAGES;
 	dirty = inode->i_state & I_DIRTY;
 	inode->i_state &= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
 	spin_unlock(&inode->i_lock);
@@ -433,60 +484,67 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 		if (ret == 0)
 			ret = err;
 	}
+	trace_writeback_single_inode(inode, wbc, nr_to_write);
+	return ret;
+}
+
+/*
+ * Write out an inode's dirty pages. Either the caller has an active reference
+ * on the inode or the inode has I_WILL_FREE set.
+ *
+ * This function is designed to be called for writing back one inode which
+ * we go e.g. from filesystem. Flusher thread uses __writeback_single_inode()
+ * and does more profound writeback list handling in writeback_sb_inodes().
+ */
+static int
+writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
+		       struct writeback_control *wbc)
+{
+	int ret = 0;
 
-	spin_lock(&wb->list_lock);
 	spin_lock(&inode->i_lock);
-	inode->i_state &= ~I_SYNC;
-	if (!(inode->i_state & I_FREEING)) {
+	if (!atomic_read(&inode->i_count))
+		WARN_ON(!(inode->i_state & (I_WILL_FREE|I_FREEING)));
+	else
+		WARN_ON(inode->i_state & I_WILL_FREE);
+
+	if (inode->i_state & I_SYNC) {
+		if (wbc->sync_mode != WB_SYNC_ALL)
+			goto out;
 		/*
-		 * Sync livelock prevention. Each inode is tagged and synced in
-		 * one shot. If still dirty, it will be redirty_tail()'ed below.
-		 * Update the dirty time to prevent enqueue and sync it again.
+		 * It's a data-integrity sync. We must wait. Since callers hold
+		 * inode reference or inode has I_WILL_FREE set, it cannot go
+		 * away under us.
 		 */
-		if ((inode->i_state & I_DIRTY) &&
-		    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
-			inode->dirtied_when = jiffies;
-
-		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-			/*
-			 * We didn't write back all the pages.  nfs_writepages()
-			 * sometimes bales out without doing anything.
-			 */
-			inode->i_state |= I_DIRTY_PAGES;
-			if (wbc->nr_to_write <= 0) {
-				/*
-				 * slice used up: queue for next turn
-				 */
-				requeue_io(inode, wb);
-			} else {
-				/*
-				 * Writeback blocked by something other than
-				 * congestion. Delay the inode for some time to
-				 * avoid spinning on the CPU (100% iowait)
-				 * retrying writeback of the dirty page/inode
-				 * that cannot be performed immediately.
-				 */
-				redirty_tail(inode, wb);
-			}
-		} else if (inode->i_state & I_DIRTY) {
-			/*
-			 * Filesystems can dirty the inode during writeback
-			 * operations, such as delayed allocation during
-			 * submission or metadata updates after data IO
-			 * completion.
-			 */
-			redirty_tail(inode, wb);
-		} else {
-			/*
-			 * The inode is clean.  At this point we either have
-			 * a reference to the inode or it's on it's way out.
-			 * No need to add it back to the LRU.
-			 */
-			list_del_init(&inode->i_wb_list);
-		}
+		__inode_wait_for_writeback(inode);
 	}
+	WARN_ON(inode->i_state & I_SYNC);
+	/*
+	 * Skip inode if it is clean. We don't want to mess with writeback
+	 * lists in this function since flusher thread may be doing for example
+	 * sync in parallel and if we move the inode, it could get skipped. So
+	 * here we make sure inode is on some writeback list and leave it there
+	 * unless we have completely cleaned the inode.
+	 */
+	if (!(inode->i_state & I_DIRTY))
+		goto out;
+	inode->i_state |= I_SYNC;
+	spin_unlock(&inode->i_lock);
+
+	ret = __writeback_single_inode(inode, wb, wbc);
+
+	spin_lock(&wb->list_lock);
+	spin_lock(&inode->i_lock);
+	/*
+	 * If inode is clean, remove it from writeback lists. Otherwise don't
+	 * touch it. See comment above for explanation.
+	 */
+	if (!(inode->i_state & I_DIRTY))
+		list_del_init(&inode->i_wb_list);
+	spin_unlock(&wb->list_lock);
 	inode_sync_complete(inode);
-	trace_writeback_single_inode(inode, wbc, nr_to_write);
+out:
+	spin_unlock(&inode->i_lock);
 	return ret;
 }
 
@@ -580,29 +638,57 @@ static long writeback_sb_inodes(struct super_block *sb,
 			redirty_tail(inode, wb);
 			continue;
 		}
-		__iget(inode);
+		if ((inode->i_state & I_SYNC) && wbc.sync_mode != WB_SYNC_ALL) {
+			/*
+			 * If this inode is locked for writeback and we are not
+			 * doing writeback-for-data-integrity, move it to
+			 * b_more_io so that writeback can proceed with the
+			 * other inodes on s_io.
+			 *
+			 * We'll have another go at writing back this inode
+			 * when we completed a full scan of b_io.
+			 */
+			spin_unlock(&inode->i_lock);
+			requeue_io(inode, wb);
+			trace_writeback_sb_inodes_requeue(inode);
+			continue;
+		}
+		spin_unlock(&wb->list_lock);
+
+		/*
+		 * We already requeued the inode if it had I_SYNC set and we
+		 * are doing WB_SYNC_NONE writeback. So this catches only the
+		 * WB_SYNC_ALL case.
+		 */
+		if (inode->i_state & I_SYNC) {
+			/* Wait for I_SYNC. This function drops i_lock... */
+			inode_sleep_on_writeback(inode);
+			/* Inode may be gone, start again */
+			continue;
+		}
+		inode->i_state |= I_SYNC;
+		spin_unlock(&inode->i_lock);
+
 		write_chunk = writeback_chunk_size(wb->bdi, work);
 		wbc.nr_to_write = write_chunk;
 		wbc.pages_skipped = 0;
 
-		writeback_single_inode(inode, wb, &wbc);
+		/*
+		 * We use I_SYNC to pin the inode in memory. While it is set
+		 * evict_inode() will wait so the inode cannot be freed.
+		 */
+		__writeback_single_inode(inode, wb, &wbc);
 
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
 		wrote += write_chunk - wbc.nr_to_write;
+		spin_lock(&wb->list_lock);
+		spin_lock(&inode->i_lock);
 		if (!(inode->i_state & I_DIRTY))
 			wrote++;
-		if (wbc.pages_skipped) {
-			/*
-			 * writeback is not making progress due to locked
-			 * buffers.  Skip this inode for now.
-			 */
-			redirty_tail(inode, wb);
-		}
+		requeue_inode(inode, wb, &wbc);
+		inode_sync_complete(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&wb->list_lock);
-		iput(inode);
-		cond_resched();
-		spin_lock(&wb->list_lock);
+		cond_resched_lock(&wb->list_lock);
 		/*
 		 * bail out to wb_writeback() often enough to check
 		 * background threshold and other termination conditions.
@@ -796,8 +882,10 @@ static long wb_writeback(struct bdi_writeback *wb,
 			trace_writeback_wait(wb->bdi, work);
 			inode = wb_inode(wb->b_more_io.prev);
 			spin_lock(&inode->i_lock);
-			inode_wait_for_writeback(inode, wb);
-			spin_unlock(&inode->i_lock);
+			spin_unlock(&wb->list_lock);
+			/* This function drops i_lock... */
+			inode_sleep_on_writeback(inode);
+			spin_lock(&wb->list_lock);
 		}
 	}
 	spin_unlock(&wb->list_lock);
@@ -1331,7 +1419,6 @@ EXPORT_SYMBOL(sync_inodes_sb);
 int write_inode_now(struct inode *inode, int sync)
 {
 	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-	int ret;
 	struct writeback_control wbc = {
 		.nr_to_write = LONG_MAX,
 		.sync_mode = sync ? WB_SYNC_ALL : WB_SYNC_NONE,
@@ -1343,12 +1430,7 @@ int write_inode_now(struct inode *inode, int sync)
 		wbc.nr_to_write = 0;
 
 	might_sleep();
-	spin_lock(&wb->list_lock);
-	spin_lock(&inode->i_lock);
-	ret = writeback_single_inode(inode, wb, &wbc);
-	spin_unlock(&inode->i_lock);
-	spin_unlock(&wb->list_lock);
-	return ret;
+	return writeback_single_inode(inode, wb, &wbc);
 }
 EXPORT_SYMBOL(write_inode_now);
 
@@ -1365,15 +1447,7 @@ EXPORT_SYMBOL(write_inode_now);
  */
 int sync_inode(struct inode *inode, struct writeback_control *wbc)
 {
-	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
-	int ret;
-
-	spin_lock(&wb->list_lock);
-	spin_lock(&inode->i_lock);
-	ret = writeback_single_inode(inode, wb, wbc);
-	spin_unlock(&inode->i_lock);
-	spin_unlock(&wb->list_lock);
-	return ret;
+	return writeback_single_inode(inode, &inode_to_bdi(inode)->wb, wbc);
 }
 EXPORT_SYMBOL(sync_inode);
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4aec599..87e6115 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -122,7 +122,7 @@ static void fuse_destroy_inode(struct inode *inode)
 static void fuse_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (inode->i_sb->s_flags & MS_ACTIVE) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
 		struct fuse_inode *fi = get_fuse_inode(inode);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 6172fa7..713e621 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1554,7 +1554,7 @@ out_unlock:
 out:
 	/* Case 3 starts here */
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);
 	ip->i_gl->gl_object = NULL;
 	flush_delayed_work_sync(&ip->i_gl->gl_work);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 737dbeb..761ec06 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -532,7 +532,7 @@ out:
 void hfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (HFS_IS_RSRC(inode) && HFS_I(inode)->rsrc_inode) {
 		HFS_I(HFS_I(inode)->rsrc_inode)->rsrc_inode = NULL;
 		iput(HFS_I(inode)->rsrc_inode);
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index ceb1c28..a9bca4b 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -154,7 +154,7 @@ static void hfsplus_evict_inode(struct inode *inode)
 {
 	dprint(DBG_INODE, "hfsplus_evict_inode: %lu\n", inode->i_ino);
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (HFSPLUS_IS_RSRC(inode)) {
 		HFSPLUS_I(HFSPLUS_I(inode)->rsrc_inode)->rsrc_inode = NULL;
 		iput(HFSPLUS_I(inode)->rsrc_inode);
diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 07c516b..2afa5bb 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -240,7 +240,7 @@ static struct inode *hostfs_alloc_inode(struct super_block *sb)
 static void hostfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (HOSTFS_I(inode)->fd != -1) {
 		close_file(&HOSTFS_I(inode)->fd);
 		HOSTFS_I(inode)->fd = -1;
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 3b2cec2..b43066c 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -299,7 +299,7 @@ void hpfs_write_if_changed(struct inode *inode)
 void hpfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (!inode->i_nlink) {
 		hpfs_lock(inode->i_sb);
 		hpfs_remove_fnode(inode->i_sb, inode->i_ino);
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index a80e45a..d4f93b5 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -614,7 +614,7 @@ static struct inode *hppfs_alloc_inode(struct super_block *sb)
 
 void hppfs_evict_inode(struct inode *ino)
 {
-	end_writeback(ino);
+	clear_inode(ino);
 	dput(HPPFS_I(ino)->proc_dentry);
 	mntput(ino->i_sb->s_fs_info);
 }
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 28cf06e..568193d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -393,7 +393,7 @@ static void truncate_hugepages(struct inode *inode, loff_t lstart)
 static void hugetlbfs_evict_inode(struct inode *inode)
 {
 	truncate_hugepages(inode, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 }
 
 static inline void
diff --git a/fs/inode.c b/fs/inode.c
index 9f4f5fe..f4e1450 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -486,7 +486,7 @@ void __remove_inode_hash(struct inode *inode)
 }
 EXPORT_SYMBOL(__remove_inode_hash);
 
-void end_writeback(struct inode *inode)
+void clear_inode(struct inode *inode)
 {
 	might_sleep();
 	/*
@@ -500,11 +500,10 @@ void end_writeback(struct inode *inode)
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-	inode_sync_wait(inode);
 	/* don't need i_lock here, no concurrent mods to i_state */
 	inode->i_state = I_FREEING | I_CLEAR;
 }
-EXPORT_SYMBOL(end_writeback);
+EXPORT_SYMBOL(clear_inode);
 
 /*
  * Free the inode passed in, removing it from the lists it is still connected
@@ -531,12 +530,20 @@ static void evict(struct inode *inode)
 
 	inode_sb_list_del(inode);
 
+	/*
+	 * Wait for flusher thread to be done with the inode so that filesystem
+	 * does not start destroying it while writeback is still running. Since
+	 * the inode has I_FREEING set, flusher thread won't start new work on
+	 * the inode.  We just have to wait for running writeback to finish.
+	 */
+	inode_wait_for_writeback(inode);
+
 	if (op->evict_inode) {
 		op->evict_inode(inode);
 	} else {
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
-		end_writeback(inode);
+		clear_inode(inode);
 	}
 	if (S_ISBLK(inode->i_mode) && inode->i_bdev)
 		bd_forget(inode);
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index bb6f993..3d3092e 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -240,7 +240,7 @@ void jffs2_evict_inode (struct inode *inode)
 	jffs2_dbg(1, "%s(): ino #%lu mode %o\n",
 		  __func__, inode->i_ino, inode->i_mode);
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	jffs2_do_clear_inode(c, f);
 }
 
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 77b69b2..4692bf3 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -169,7 +169,7 @@ void jfs_evict_inode(struct inode *inode)
 	} else {
 		truncate_inode_pages(&inode->i_data, 0);
 	}
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 }
 
diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index e3ab5e5..f1cb512 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -2175,7 +2175,7 @@ void logfs_evict_inode(struct inode *inode)
 		}
 	}
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	/* Cheaper version of write_inode.  All changes are concealed in
 	 * aliases, which are moved back.  No write to the medium happens.
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index fcb05d2..2a503ad 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -32,7 +32,7 @@ static void minix_evict_inode(struct inode *inode)
 		minix_truncate(inode);
 	}
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (!inode->i_nlink)
 		minix_free_inode(inode);
 }
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 87484fb..333df07 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -292,7 +292,7 @@ static void
 ncp_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (S_ISDIR(inode->i_mode)) {
 		DDPRINTK("ncp_evict_inode: put directory %ld\n", inode->i_ino);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e8bbfa5..c607313 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -121,7 +121,7 @@ static void nfs_clear_inode(struct inode *inode)
 void nfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	nfs_clear_inode(inode);
 }
 
@@ -1500,7 +1500,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 void nfs4_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	pnfs_return_layout(inode);
 	pnfs_destroy_layout(NFS_I(inode));
 	/* If we are holding a delegation, return it! */
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 8f7b95a..7cc6446 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -734,7 +734,7 @@ void nilfs_evict_inode(struct inode *inode)
 	if (inode->i_nlink || !ii->i_root || unlikely(is_bad_inode(inode))) {
 		if (inode->i_data.nrpages)
 			truncate_inode_pages(&inode->i_data, 0);
-		end_writeback(inode);
+		clear_inode(inode);
 		nilfs_clear_inode(inode);
 		return;
 	}
@@ -746,7 +746,7 @@ void nilfs_evict_inode(struct inode *inode)
 	/* TODO: some of the following operations may fail.  */
 	nilfs_truncate_bmap(ii, 0);
 	nilfs_mark_inode_dirty(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	ret = nilfs_ifile_delete_inode(ii->i_root->ifile, inode->i_ino);
 	if (!ret)
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index 2eaa666..c6dbd3d 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2258,7 +2258,7 @@ void ntfs_evict_big_inode(struct inode *vi)
 	ntfs_inode *ni = NTFS_I(vi);
 
 	truncate_inode_pages(&vi->i_data, 0);
-	end_writeback(vi);
+	clear_inode(vi);
 
 #ifdef NTFS_RW
 	if (NInoDirty(ni)) {
diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 3b5825e..e31d6ae 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -367,7 +367,7 @@ static void dlmfs_evict_inode(struct inode *inode)
 	int status;
 	struct dlmfs_inode_private *ip;
 
-	end_writeback(inode);
+	clear_inode(inode);
 
 	mlog(0, "inode %lu\n", inode->i_ino);
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 17454a9..735514c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1069,7 +1069,7 @@ static void ocfs2_clear_inode(struct inode *inode)
 	int status;
 	struct ocfs2_inode_info *oi = OCFS2_I(inode);
 
-	end_writeback(inode);
+	clear_inode(inode);
 	trace_ocfs2_clear_inode((unsigned long long)oi->ip_blkno,
 				inode->i_nlink);
 
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index dbc8422..e6213b3 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -184,7 +184,7 @@ int omfs_sync_inode(struct inode *inode)
 static void omfs_evict_inode(struct inode *inode)
 {
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (inode->i_nlink)
 		return;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 205c922..29ab406 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -33,7 +33,7 @@ static void proc_evict_inode(struct inode *inode)
 	const struct proc_ns_operations *ns_ops;
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	/* Stop tracking associated processes */
 	put_pid(PROC_I(inode)->pid);
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 1950788..aeb19e6 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -85,7 +85,7 @@ static void pstore_evict_inode(struct inode *inode)
 	struct pstore_private	*p = inode->i_private;
 	unsigned long		flags;
 
-	end_writeback(inode);
+	clear_inode(inode);
 	if (p) {
 		spin_lock_irqsave(&allpstore_lock, flags);
 		list_del(&p->list);
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 494c315..59d0687 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -76,14 +76,14 @@ void reiserfs_evict_inode(struct inode *inode)
 		;
 	}
       out:
-	end_writeback(inode);	/* note this must go after the journal_end to prevent deadlock */
+	clear_inode(inode);	/* note this must go after the journal_end to prevent deadlock */
 	dquot_drop(inode);
 	inode->i_blocks = 0;
 	reiserfs_write_unlock_once(inode->i_sb, depth);
 	return;
 
 no_delete:
-	end_writeback(inode);
+	clear_inode(inode);
 	dquot_drop(inode);
 }
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index feb2d69..b8ce6a9 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -310,7 +310,7 @@ void sysfs_evict_inode(struct inode *inode)
 	struct sysfs_dirent *sd  = inode->i_private;
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	sysfs_put(sd);
 }
 
diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index 3da5ce2..08d0b25 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -316,7 +316,7 @@ static void sysv_evict_inode(struct inode *inode)
 		sysv_truncate(inode);
 	}
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (!inode->i_nlink)
 		sysv_free_inode(inode);
 }
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 76e4e05..7bf60ae 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -378,7 +378,7 @@ out:
 		smp_wmb();
 	}
 done:
-	end_writeback(inode);
+	clear_inode(inode);
 }
 
 static void ubifs_dirty_inode(struct inode *inode, int flags)
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 7d75280..873e1ba 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -80,7 +80,7 @@ void udf_evict_inode(struct inode *inode)
 	} else
 		truncate_inode_pages(&inode->i_data, 0);
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 	if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB &&
 	    inode->i_size != iinfo->i_lenExtents) {
 		udf_warn(inode->i_sb, "Inode %lu (mode %o) has inode size %llu different from extent length %llu. Filesystem need not be standards compliant.\n",
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 7cdd395..dd7c89d 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -895,7 +895,7 @@ void ufs_evict_inode(struct inode * inode)
 	}
 
 	invalidate_inode_buffers(inode);
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (want_delete) {
 		lock_ufs(inode->i_sb);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dab9a5f..5b806f2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -926,7 +926,7 @@ xfs_fs_evict_inode(
 	trace_xfs_evict_inode(ip);
 
 	truncate_inode_pages(&inode->i_data, 0);
-	end_writeback(inode);
+	clear_inode(inode);
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
 	XFS_STATS_DEC(vn_active);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..1c71e7f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1744,8 +1744,8 @@ struct super_operations {
  * I_FREEING		Set when inode is about to be freed but still has dirty
  *			pages or buffers attached or the inode itself is still
  *			dirty.
- * I_CLEAR		Added by end_writeback().  In this state the inode is clean
- *			and can be destroyed.  Inode keeps I_FREEING.
+ * I_CLEAR		Added by clear_inode().  In this state the inode is
+ *			clean and can be destroyed.  Inode keeps I_FREEING.
  *
  *			Inodes that are I_WILL_FREE, I_FREEING or I_CLEAR are
  *			prohibited for many purposes.  iget() must wait for
@@ -1753,9 +1753,10 @@ struct super_operations {
  *			anew.  Other functions will just ignore such inodes,
  *			if appropriate.  I_NEW is used for waiting.
  *
- * I_SYNC		Synchonized write of dirty inode data.  The bits is
- *			set during data writeback, and cleared with a wakeup
- *			on the bit address once it is done.
+ * I_SYNC		Writeback of inode is running. The bit is set during
+ *			data writeback, and cleared with a wakeup on the bit
+ *			address once it is done. The bit is also used to pin
+ *			the inode in memory for flusher thread.
  *
  * I_REFERENCED		Marks the inode as recently references on the LRU list.
  *
@@ -2328,7 +2329,7 @@ extern unsigned int get_next_ino(void);
 
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
-extern void end_writeback(struct inode *);
+extern void clear_inode(struct inode *);
 extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a2b84f5..6d0a0fc 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -58,7 +58,6 @@ extern const char *wb_reason_name[];
  * in a manner such that unspecified fields are set to zero.
  */
 struct writeback_control {
-	enum writeback_sync_modes sync_mode;
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
@@ -71,6 +70,8 @@ struct writeback_control {
 	loff_t range_start;
 	loff_t range_end;
 
+	enum writeback_sync_modes sync_mode;
+
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
 	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */
@@ -94,6 +95,7 @@ long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason);
 long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
+void inode_wait_for_writeback(struct inode *inode);
 
 /* writeback.h requires fs.h; it, too, is not included from here. */
 static inline void wait_on_inode(struct inode *inode)
@@ -101,12 +103,6 @@ static inline void wait_on_inode(struct inode *inode)
 	might_sleep();
 	wait_on_bit(&inode->i_state, __I_NEW, inode_wait, TASK_UNINTERRUPTIBLE);
 }
-static inline void inode_sync_wait(struct inode *inode)
-{
-	might_sleep();
-	wait_on_bit(&inode->i_state, __I_SYNC, inode_wait,
-							TASK_UNINTERRUPTIBLE);
-}
 
 
 /*
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 7b81887..b453d92 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -372,6 +372,35 @@ TRACE_EVENT(balance_dirty_pages,
 	  )
 );
 
+TRACE_EVENT(writeback_sb_inodes_requeue,
+
+	TP_PROTO(struct inode *inode),
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__array(char, name, 32)
+		__field(unsigned long, ino)
+		__field(unsigned long, state)
+		__field(unsigned long, dirtied_when)
+	),
+
+	TP_fast_assign(
+		strncpy(__entry->name,
+		        dev_name(inode_to_bdi(inode)->dev), 32);
+		__entry->ino		= inode->i_ino;
+		__entry->state		= inode->i_state;
+		__entry->dirtied_when	= inode->dirtied_when;
+	),
+
+	TP_printk("bdi %s: ino=%lu state=%s dirtied_when=%lu age=%lu",
+		  __entry->name,
+		  __entry->ino,
+		  show_inode_state(__entry->state),
+		  __entry->dirtied_when,
+		  (jiffies - __entry->dirtied_when) / HZ
+	)
+);
+
 DECLARE_EVENT_CLASS(writeback_congest_waited_template,
 
 	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
@@ -450,13 +479,6 @@ DECLARE_EVENT_CLASS(writeback_single_inode_template,
 	)
 );
 
-DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode_requeue,
-	TP_PROTO(struct inode *inode,
-		 struct writeback_control *wbc,
-		 unsigned long nr_to_write),
-	TP_ARGS(inode, wbc, nr_to_write)
-);
-
 DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode,
 	TP_PROTO(struct inode *inode,
 		 struct writeback_control *wbc,
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 28bd64d..0032d9c 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -249,7 +249,7 @@ static void mqueue_evict_inode(struct inode *inode)
 	int i;
 	struct ipc_namespace *ipc_ns;
 
-	end_writeback(inode);
+	clear_inode(inode);
 
 	if (S_ISDIR(inode->i_mode))
 		return;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 26adea8..93d8d2f 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -204,7 +204,7 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
  * Returns the global number of pages potentially available for dirty
  * page cache.  This is the base value for the global dirty limits.
  */
-unsigned long global_dirtyable_memory(void)
+static unsigned long global_dirtyable_memory(void)
 {
 	unsigned long x;
 
@@ -1568,6 +1568,7 @@ void writeback_set_ratelimit(void)
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	global_dirty_limits(&background_thresh, &dirty_thresh);
+	global_dirty_limit = dirty_thresh;
 	ratelimit_pages = dirty_thresh / (num_online_cpus() * 32);
 	if (ratelimit_pages < 16)
 		ratelimit_pages = 16;
diff --git a/mm/shmem.c b/mm/shmem.c
index f99ff3e..68412fa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -597,7 +597,7 @@ static void shmem_evict_inode(struct inode *inode)
 	}
 	BUG_ON(inode->i_blocks);
 	shmem_free_inode(inode->i_sb);
-	end_writeback(inode);
+	clear_inode(inode);
 }
 
 /*
