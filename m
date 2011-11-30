Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1K3CTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:19:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36187 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757445Ab1K3CTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:19:44 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 28/28] buffer: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:26 -0800
Message-Id: <1cd4f6ae92bd363b1a32daa6f35a96d7d4a428a9.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a few ignorable warnings remain.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/buffer.c | \
  cut -f3- -d":" | sort | uniq -c
      5  ERROR: "foo * bar" should be "foo *bar"
      1  ERROR: space required after that close brace '}'
      1  ERROR: space required after that ',' (ctx:VxO)
      3  ERROR: space required after that ',' (ctx:VxV)
      1  ERROR: space required before that '&' (ctx:OxV)
      3  ERROR: space required before the open parenthesis '('
      1  ERROR: spaces required around that '=' (ctx:OxV)
      3  ERROR: spaces required around that '=' (ctx:VxV)
     13  ERROR: trailing whitespace
      2  WARNING: braces {} are not necessary for any arm of this statement
      2  WARNING: braces {} are not necessary for single statement blocks
      4  WARNING: line over 80 characters
      1  WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
      1  WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/buffer.c |   85 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 576a1ba..16a259c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -83,9 +83,10 @@ EXPORT_SYMBOL(unlock_buffer);
  * from becoming locked again - you have to lock it yourself
  * if you want to preserve its state.
  */
-void __wait_on_buffer(struct buffer_head * bh)
+void __wait_on_buffer(struct buffer_head *bh)
 {
-	wait_on_bit(&bh->b_state, BH_Lock, sleep_on_buffer, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&bh->b_state, BH_Lock, sleep_on_buffer,
+		    TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__wait_on_buffer);
 
@@ -238,7 +239,7 @@ out:
    Thus invalidate_buffers in general usage is not allwowed to trash
    dirty buffers. For example ioctl(FLSBLKBUF) expects dirty data to
    be preserved.  These buffers are simply skipped.
-  
+
    We also skip buffers which are still in use.  For example this can
    happen if a userspace program is reading the block device.
 
@@ -474,7 +475,7 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * try_to_free_buffers() will be operating against the *blockdev* mapping
  * at the time, not against the S_ISREG file which depends on those buffers.
  * So the locking for private_list is via the private_lock in the address_space
- * which backs the buffers.  Which is different from the address_space 
+ * which backs the buffers.  Which is different from the address_space
  * against which the buffers are listed.  So for a particular address_space,
  * mapping->private_lock does *not* protect mapping->private_list!  In fact,
  * mapping->private_list will always be protected by the backing blockdev's
@@ -635,11 +636,11 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *buffer_mapping = bh->b_page->mapping;
 
 	mark_buffer_dirty(bh);
-	if (!mapping->assoc_mapping) {
+	if (!mapping->assoc_mapping)
 		mapping->assoc_mapping = buffer_mapping;
-	} else {
+	else
 		BUG_ON(mapping->assoc_mapping != buffer_mapping);
-	}
+
 	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
@@ -734,7 +735,7 @@ EXPORT_SYMBOL(__set_page_dirty_buffers);
  * Do this in two main stages: first we copy dirty buffers to a
  * temporary inode list, queueing the writes as we go.  Then we clean
  * up, waiting for those writes to complete.
- * 
+ *
  * During this second stage, any subsequent updates to the file may end
  * up refiling the buffer on the original inode's dirty list again, so
  * there is a chance we will end up with a buffer queued for write but
@@ -812,7 +813,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 		brelse(bh);
 		spin_lock(lock);
 	}
-	
+
 	spin_unlock(lock);
 	err2 = osync_buffers_list(lock, list);
 	if (err)
@@ -927,7 +928,7 @@ no_grow:
 	/*
 	 * Return failure for non-async IO requests.  Async IO requests
 	 * are not allowed to fail, so we have to wait until buffer heads
-	 * become available.  But we don't want tasks sleeping with 
+	 * become available.  But we don't want tasks sleeping with
 	 * partially complete buffers, so all were released above.
 	 */
 	if (!retry)
@@ -936,7 +937,7 @@ no_grow:
 	/* We're _really_ low on memory. Now we just
 	 * wait for old buffer heads to become free due to
 	 * finishing IO.  Since this is an async request and
-	 * the reserve list is empty, we're sure there are 
+	 * the reserve list is empty, we're sure there are
 	 * async buffer heads in use.
 	 */
 	free_more_memory();
@@ -960,7 +961,7 @@ link_dev_buffers(struct page *page, struct buffer_head *head)
 
 /*
  * Initialise the state of a blockdev page's buffers.
- */ 
+ */
 static void
 init_page_buffers(struct page *page, struct block_device *bdev,
 			sector_t block, int size)
@@ -1093,7 +1094,7 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
 	}
 
 	for (;;) {
-		struct buffer_head * bh;
+		struct buffer_head *bh;
 		int ret;
 
 		bh = __find_get_block(bdev, block, size);
@@ -1177,7 +1178,7 @@ EXPORT_SYMBOL(mark_buffer_dirty);
  * in preparation for freeing it (sometimes, rarely, buffers are removed from
  * a page but it ends up not being freed, and buffers may later be reattached).
  */
-void __brelse(struct buffer_head * buf)
+void __brelse(struct buffer_head *buf)
 {
 	if (atomic_read(&buf->b_count)) {
 		put_bh(buf);
@@ -1398,7 +1399,7 @@ EXPORT_SYMBOL(__breadahead);
  *  @bdev: the block_device to read from
  *  @block: number of block
  *  @size: size (in bytes) to read
- * 
+ *
  *  Reads a specified block, and returns buffer head that contains it.
  *  It returns NULL if the block was unreadable.
  */
@@ -1429,7 +1430,7 @@ static void invalidate_bh_lru(void *arg)
 	}
 	put_cpu_var(bh_lrus);
 }
-	
+
 void invalidate_bh_lrus(void)
 {
 	on_each_cpu(invalidate_bh_lru, NULL, 1);
@@ -1454,7 +1455,7 @@ EXPORT_SYMBOL(set_bh_page);
 /*
  * Called when truncating a buffer on a page completely.
  */
-static void discard_buffer(struct buffer_head * bh)
+static void discard_buffer(struct buffer_head *bh)
 {
 	lock_buffer(bh);
 	clear_buffer_dirty(bh);
@@ -1700,11 +1701,10 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			redirty_page_for_writepage(wbc, page);
 			continue;
 		}
-		if (test_clear_buffer_dirty(bh)) {
+		if (test_clear_buffer_dirty(bh))
 			mark_buffer_async_write_endio(bh, handler);
-		} else {
+		else
 			unlock_buffer(bh);
-		}
 	} while ((bh = bh->b_this_page) != head);
 
 	/*
@@ -1832,7 +1832,7 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 	sector_t block;
 	int err = 0;
 	unsigned blocksize, bbits;
-	struct buffer_head *bh, *head, *wait[2], **wait_bh=wait;
+	struct buffer_head *bh, *head, *wait[2], **wait_bh = wait;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(from > PAGE_CACHE_SIZE);
@@ -1847,8 +1847,8 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 	bbits = inode->i_blkbits;
 	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
 
-	for(bh = head, block_start = 0; bh != head || !block_start;
-	    block++, block_start=block_end, bh = bh->b_this_page) {
+	for (bh = head, block_start = 0; bh != head || !block_start;
+	     block++, block_start = block_end, bh = bh->b_this_page) {
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
 			if (PageUptodate(page)) {
@@ -1883,19 +1883,19 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 		if (PageUptodate(page)) {
 			if (!buffer_uptodate(bh))
 				set_buffer_uptodate(bh);
-			continue; 
+			continue;
 		}
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
 			ll_rw_block(READ, 1, &bh);
-			*wait_bh++=bh;
+			*wait_bh++ = bh;
 		}
 	}
 	/*
 	 * If we issued read requests - let them complete.
 	 */
-	while(wait_bh > wait) {
+	while (wait_bh > wait) {
 		wait_on_buffer(*--wait_bh);
 		if (!buffer_uptodate(*wait_bh))
 			err = -EIO;
@@ -1916,9 +1916,9 @@ static int __block_commit_write(struct inode *inode, struct page *page,
 
 	blocksize = 1 << inode->i_blkbits;
 
-	for(bh = head = page_buffers(page), block_start = 0;
-	    bh != head || !block_start;
-	    block_start=block_end, bh = bh->b_this_page) {
+	for (bh = head = page_buffers(page), block_start = 0;
+	     bh != head || !block_start;
+	     block_start = block_end, bh = bh->b_this_page) {
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
 			if (!buffer_uptodate(bh))
@@ -2186,7 +2186,7 @@ EXPORT_SYMBOL(block_read_full_page);
 
 /* utility function for filesystems that need to do work on expanding
  * truncates.  Uses filesystem pagecache writes to allow the filesystem to
- * deal with the hole.  
+ * deal with the hole.
  */
 int generic_cont_expand_simple(struct inode *inode, loff_t size)
 {
@@ -2256,9 +2256,9 @@ static int cont_expand_zero(struct file *file, struct address_space *mapping,
 	if (index == curidx) {
 		zerofrom = curpos & ~PAGE_CACHE_MASK;
 		/* if we will expand the thing last block will be filled */
-		if (offset <= zerofrom) {
+		if (offset <= zerofrom)
 			goto out;
-		}
+
 		if (zerofrom & (blocksize-1)) {
 			*bytes |= (blocksize-1);
 			(*bytes)++;
@@ -2313,7 +2313,7 @@ EXPORT_SYMBOL(cont_write_begin);
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	__block_commit_write(inode,page,from,to);
+	__block_commit_write(inode, page, from, to);
 	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
@@ -2503,8 +2503,8 @@ int nobh_write_begin(struct address_space *mapping,
 	 * page is fully mapped-to-disk.
 	 */
 	for (block_start = 0, block_in_page = 0, bh = head;
-		  block_start < PAGE_CACHE_SIZE;
-		  block_in_page++, block_start += blocksize, bh = bh->b_this_page) {
+	     block_start < PAGE_CACHE_SIZE;
+	     block_in_page++, block_start += blocksize, bh = bh->b_this_page) {
 		int create;
 
 		block_end = block_start + blocksize;
@@ -2769,7 +2769,7 @@ int block_truncate_page(struct address_space *mapping,
 
 	length = blocksize - length;
 	iblock = (sector_t)index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
-	
+
 	page = grab_cache_page(mapping, index);
 	err = -ENOMEM;
 	if (!page)
@@ -2802,7 +2802,9 @@ int block_truncate_page(struct address_space *mapping,
 	if (PageUptodate(page))
 		set_buffer_uptodate(bh);
 
-	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
+	if (!buffer_uptodate(bh) &&
+	    !buffer_delay(bh) &&
+	    !buffer_unwritten(bh)) {
 		err = -EIO;
 		ll_rw_block(READ, 1, &bh);
 		wait_on_buffer(bh);
@@ -2893,18 +2895,17 @@ static void end_bio_bh_io_sync(struct bio *bio, int err)
 {
 	struct buffer_head *bh = bio->bi_private;
 
-	if (err == -EOPNOTSUPP) {
+	if (err == -EOPNOTSUPP)
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-	}
 
-	if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
+	if (unlikely(test_bit(BIO_QUIET, &bio->bi_flags)))
 		set_bit(BH_Quiet, &bh->b_state);
 
 	bh->b_end_io(bh, test_bit(BIO_UPTODATE, &bio->bi_flags));
 	bio_put(bio);
 }
 
-int submit_bh(int rw, struct buffer_head * bh)
+int submit_bh(int rw, struct buffer_head *bh)
 {
 	struct bio *bio;
 	int ret = 0;
@@ -2971,7 +2972,7 @@ EXPORT_SYMBOL(submit_bh);
  *
  * ll_rw_block sets b_end_io to simple completion handler that marks
  * the buffer up-to-date (if approriate), unlocks the buffer and wakes
- * any waiters. 
+ * any waiters.
  *
  * All of the buffers must be for the same device, and must also be a
  * multiple of the current approved size for the device.
-- 
1.7.6.405.gc1be0

