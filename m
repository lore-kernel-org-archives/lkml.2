Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1AVBSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:18:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:45818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab1AVBRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:44 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 05/10] block: remove per-queue plugging
Date: Sat, 22 Jan 2011 01:17:24 +0000
Message-Id: <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 Documentation/block/biodoc.txt     |    5 -
 block/blk-core.c                   |  173 ++++-------------------------------
 block/blk-exec.c                   |    4 +-
 block/blk-flush.c                  |    3 +-
 block/blk-settings.c               |    8 --
 block/blk-sysfs.c                  |    3 +
 block/blk.h                        |    2 -
 block/cfq-iosched.c                |    8 --
 block/deadline-iosched.c           |    9 --
 block/elevator.c                   |   38 +-------
 block/noop-iosched.c               |    8 --
 drivers/block/cciss.c              |    6 --
 drivers/block/cpqarray.c           |    3 -
 drivers/block/drbd/drbd_actlog.c   |    2 -
 drivers/block/drbd/drbd_bitmap.c   |    1 -
 drivers/block/drbd/drbd_int.h      |   14 ---
 drivers/block/drbd/drbd_main.c     |   33 +-------
 drivers/block/drbd/drbd_receiver.c |   20 +----
 drivers/block/drbd/drbd_req.c      |    4 -
 drivers/block/drbd/drbd_worker.c   |    1 -
 drivers/block/drbd/drbd_wrappers.h |   18 ----
 drivers/block/floppy.c             |    1 -
 drivers/block/loop.c               |   13 ---
 drivers/block/pktcdvd.c            |    2 -
 drivers/block/umem.c               |   16 +---
 drivers/ide/ide-atapi.c            |    3 +-
 drivers/ide/ide-io.c               |    4 -
 drivers/ide/ide-park.c             |    2 +-
 drivers/md/bitmap.c                |    3 +-
 drivers/md/dm-crypt.c              |    9 +--
 drivers/md/dm-kcopyd.c             |   43 +--------
 drivers/md/dm-raid.c               |    2 +-
 drivers/md/dm-raid1.c              |    2 -
 drivers/md/dm-table.c              |   24 -----
 drivers/md/dm.c                    |   33 +------
 drivers/md/linear.c                |   17 ----
 drivers/md/md.c                    |    7 --
 drivers/md/multipath.c             |   31 -------
 drivers/md/raid0.c                 |   16 ----
 drivers/md/raid1.c                 |   82 ++++--------------
 drivers/md/raid10.c                |   86 ++++--------------
 drivers/md/raid5.c                 |   63 ++-----------
 drivers/md/raid5.h                 |    2 +-
 drivers/message/i2o/i2o_block.c    |    6 +-
 drivers/mmc/card/queue.c           |    3 +-
 drivers/s390/block/dasd.c          |    2 +-
 drivers/s390/char/tape_block.c     |    1 -
 drivers/scsi/scsi_transport_fc.c   |    2 +-
 drivers/scsi/scsi_transport_sas.c  |    6 +-
 fs/adfs/inode.c                    |    1 -
 fs/affs/file.c                     |    2 -
 fs/aio.c                           |    4 +-
 fs/befs/linuxvfs.c                 |    1 -
 fs/bfs/file.c                      |    1 -
 fs/block_dev.c                     |    1 -
 fs/btrfs/disk-io.c                 |   79 ----------------
 fs/btrfs/inode.c                   |    1 -
 fs/btrfs/volumes.c                 |   91 +++-----------------
 fs/buffer.c                        |   31 +------
 fs/cifs/file.c                     |   30 ------
 fs/direct-io.c                     |    5 +-
 fs/efs/inode.c                     |    1 -
 fs/exofs/inode.c                   |    1 -
 fs/ext2/inode.c                    |    2 -
 fs/ext3/inode.c                    |    3 -
 fs/ext4/inode.c                    |    4 -
 fs/fat/inode.c                     |    1 -
 fs/freevxfs/vxfs_subr.c            |    1 -
 fs/fuse/inode.c                    |    1 -
 fs/gfs2/aops.c                     |    3 -
 fs/gfs2/meta_io.c                  |    1 -
 fs/hfs/inode.c                     |    2 -
 fs/hfsplus/inode.c                 |    2 -
 fs/hpfs/file.c                     |    1 -
 fs/isofs/inode.c                   |    1 -
 fs/jfs/inode.c                     |    1 -
 fs/jfs/jfs_metapage.c              |    1 -
 fs/logfs/dev_bdev.c                |    2 -
 fs/minix/inode.c                   |    1 -
 fs/nilfs2/btnode.c                 |    6 +-
 fs/nilfs2/gcinode.c                |    1 -
 fs/nilfs2/inode.c                  |    1 -
 fs/nilfs2/mdt.c                    |    9 +--
 fs/nilfs2/page.c                   |    8 +-
 fs/nilfs2/page.h                   |    3 +-
 fs/ntfs/aops.c                     |    4 -
 fs/ntfs/compress.c                 |    3 +-
 fs/ocfs2/aops.c                    |    1 -
 fs/ocfs2/cluster/heartbeat.c       |    4 -
 fs/omfs/file.c                     |    1 -
 fs/qnx4/inode.c                    |    1 -
 fs/reiserfs/inode.c                |    1 -
 fs/sysv/itree.c                    |    1 -
 fs/ubifs/super.c                   |    1 -
 fs/udf/file.c                      |    1 -
 fs/udf/inode.c                     |    1 -
 fs/ufs/inode.c                     |    1 -
 fs/ufs/truncate.c                  |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c        |    1 -
 fs/xfs/linux-2.6/xfs_buf.c         |   13 +--
 include/linux/backing-dev.h        |   16 ----
 include/linux/blkdev.h             |   31 ++-----
 include/linux/buffer_head.h        |    1 -
 include/linux/device-mapper.h      |    5 -
 include/linux/elevator.h           |    7 +-
 include/linux/fs.h                 |    1 -
 include/linux/pagemap.h            |   12 ---
 include/linux/swap.h               |    2 -
 mm/backing-dev.c                   |    6 --
 mm/filemap.c                       |   67 ++-------------
 mm/memory-failure.c                |    6 +-
 mm/nommu.c                         |    4 -
 mm/page-writeback.c                |    2 +-
 mm/readahead.c                     |   12 ---
 mm/shmem.c                         |    1 -
 mm/swap_state.c                    |    5 +-
 mm/swapfile.c                      |   37 --------
 mm/vmscan.c                        |    2 +-
 118 files changed, 153 insertions(+), 1248 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index b9a83dd..2a7b38c 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -963,11 +963,6 @@ elevator_dispatch_fn*		fills the dispatch queue with ready requests.
 
 elevator_add_req_fn*		called to add a new request into the scheduler
 
-elevator_queue_empty_fn		returns true if the merge queue is empty.
-				Drivers shouldn't use this, but rather check
-				if elv_next_request is NULL (without losing the
-				request if one exists!)
-
 elevator_former_req_fn
 elevator_latter_req_fn		These return the request before or after the
 				one specified in disk sort order. Used by the
diff --git a/block/blk-core.c b/block/blk-core.c
index 42dbfcc..7ab6620 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -208,6 +208,19 @@ void blk_dump_rq_flags(struct request *rq, char *msg)
 }
 EXPORT_SYMBOL(blk_dump_rq_flags);
 
+/*
+ * Make sure that plugs that were pending when this function was entered,
+ * are now complete and requests pushed to the queue.
+*/
+static inline void queue_sync_plugs(struct request_queue *q)
+{
+	/*
+	 * If the current process is plugged and has barriers submitted,
+	 * we will livelock if we don't unplug first.
+	 */
+	blk_flush_plug(current);
+}
+
 static void blk_delay_work(struct work_struct *work)
 {
 	struct request_queue *q;
@@ -234,137 +247,6 @@ void blk_delay_queue(struct request_queue *q, unsigned long msecs)
 }
 EXPORT_SYMBOL(blk_delay_queue);
 
-/*
- * "plug" the device if there are no outstanding requests: this will
- * force the transfer to start only after we have put all the requests
- * on the list.
- *
- * This is called with interrupts off and no requests on the queue and
- * with the queue lock held.
- */
-void blk_plug_device(struct request_queue *q)
-{
-	WARN_ON(!irqs_disabled());
-
-	/*
-	 * don't plug a stopped queue, it must be paired with blk_start_queue()
-	 * which will restart the queueing
-	 */
-	if (blk_queue_stopped(q))
-		return;
-
-	if (!queue_flag_test_and_set(QUEUE_FLAG_PLUGGED, q)) {
-		mod_timer(&q->unplug_timer, jiffies + q->unplug_delay);
-		trace_block_plug(q);
-	}
-}
-EXPORT_SYMBOL(blk_plug_device);
-
-/**
- * blk_plug_device_unlocked - plug a device without queue lock held
- * @q:    The &struct request_queue to plug
- *
- * Description:
- *   Like @blk_plug_device(), but grabs the queue lock and disables
- *   interrupts.
- **/
-void blk_plug_device_unlocked(struct request_queue *q)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_plug_device(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-}
-EXPORT_SYMBOL(blk_plug_device_unlocked);
-
-/*
- * remove the queue from the plugged list, if present. called with
- * queue lock held and interrupts disabled.
- */
-int blk_remove_plug(struct request_queue *q)
-{
-	WARN_ON(!irqs_disabled());
-
-	if (!queue_flag_test_and_clear(QUEUE_FLAG_PLUGGED, q))
-		return 0;
-
-	del_timer(&q->unplug_timer);
-	return 1;
-}
-EXPORT_SYMBOL(blk_remove_plug);
-
-/*
- * remove the plug and let it rip..
- */
-void __generic_unplug_device(struct request_queue *q)
-{
-	if (unlikely(blk_queue_stopped(q)))
-		return;
-	if (!blk_remove_plug(q) && !blk_queue_nonrot(q))
-		return;
-
-	q->request_fn(q);
-}
-
-/**
- * generic_unplug_device - fire a request queue
- * @q:    The &struct request_queue in question
- *
- * Description:
- *   Linux uses plugging to build bigger requests queues before letting
- *   the device have at them. If a queue is plugged, the I/O scheduler
- *   is still adding and merging requests on the queue. Once the queue
- *   gets unplugged, the request_fn defined for the queue is invoked and
- *   transfers started.
- **/
-void generic_unplug_device(struct request_queue *q)
-{
-	if (blk_queue_plugged(q)) {
-		spin_lock_irq(q->queue_lock);
-		__generic_unplug_device(q);
-		spin_unlock_irq(q->queue_lock);
-	}
-}
-EXPORT_SYMBOL(generic_unplug_device);
-
-static void blk_backing_dev_unplug(struct backing_dev_info *bdi,
-				   struct page *page)
-{
-	struct request_queue *q = bdi->unplug_io_data;
-
-	blk_unplug(q);
-}
-
-void blk_unplug_work(struct work_struct *work)
-{
-	struct request_queue *q =
-		container_of(work, struct request_queue, unplug_work);
-
-	trace_block_unplug_io(q);
-	q->unplug_fn(q);
-}
-
-void blk_unplug_timeout(unsigned long data)
-{
-	struct request_queue *q = (struct request_queue *)data;
-
-	trace_block_unplug_timer(q);
-	kblockd_schedule_work(q, &q->unplug_work);
-}
-
-void blk_unplug(struct request_queue *q)
-{
-	/*
-	 * devices don't necessarily have an ->unplug_fn defined
-	 */
-	if (q->unplug_fn) {
-		trace_block_unplug_io(q);
-		q->unplug_fn(q);
-	}
-}
-EXPORT_SYMBOL(blk_unplug);
-
 /**
  * blk_start_queue - restart a previously stopped queue
  * @q:    The &struct request_queue in question
@@ -399,7 +281,6 @@ EXPORT_SYMBOL(blk_start_queue);
  **/
 void blk_stop_queue(struct request_queue *q)
 {
-	blk_remove_plug(q);
 	cancel_delayed_work(&q->delay_work);
 	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 }
@@ -421,11 +302,10 @@ EXPORT_SYMBOL(blk_stop_queue);
  */
 void blk_sync_queue(struct request_queue *q)
 {
-	del_timer_sync(&q->unplug_timer);
 	del_timer_sync(&q->timeout);
-	cancel_work_sync(&q->unplug_work);
 	throtl_shutdown_timer_wq(q);
 	cancel_delayed_work_sync(&q->delay_work);
+	queue_sync_plugs(q);
 }
 EXPORT_SYMBOL(blk_sync_queue);
 
@@ -440,14 +320,9 @@ EXPORT_SYMBOL(blk_sync_queue);
  */
 void __blk_run_queue(struct request_queue *q)
 {
-	blk_remove_plug(q);
-
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
-	if (elv_queue_empty(q))
-		return;
-
 	/*
 	 * Only recurse once to avoid overrunning the stack, let the unplug
 	 * handling reinvoke the handler shortly if we already got there.
@@ -455,10 +330,8 @@ void __blk_run_queue(struct request_queue *q)
 	if (!queue_flag_test_and_set(QUEUE_FLAG_REENTER, q)) {
 		q->request_fn(q);
 		queue_flag_clear(QUEUE_FLAG_REENTER, q);
-	} else {
-		queue_flag_set(QUEUE_FLAG_PLUGGED, q);
-		kblockd_schedule_work(q, &q->unplug_work);
-	}
+	} else
+		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -545,8 +418,6 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
-	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
-	q->backing_dev_info.unplug_io_data = q;
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
@@ -566,11 +437,9 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
-	init_timer(&q->unplug_timer);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->pending_flushes);
-	INIT_WORK(&q->unplug_work, blk_unplug_work);
 	INIT_DELAYED_WORK(&q->delay_work, blk_delay_work);
 
 	kobject_init(&q->kobj, &blk_queue_ktype);
@@ -660,7 +529,6 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unprep_rq_fn		= NULL;
-	q->unplug_fn		= generic_unplug_device;
 	q->queue_flags		= QUEUE_FLAG_DEFAULT;
 	q->queue_lock		= lock;
 
@@ -897,8 +765,8 @@ out:
 }
 
 /*
- * No available requests for this queue, unplug the device and wait for some
- * requests to become available.
+ * No available requests for this queue, wait for some requests to become
+ * available.
  *
  * Called with q->queue_lock held, and returns with it unlocked.
  */
@@ -919,7 +787,6 @@ static struct request *get_request_wait(struct request_queue *q, int rw_flags,
 
 		trace_block_sleeprq(q, bio, rw_flags & 1);
 
-		__generic_unplug_device(q);
 		spin_unlock_irq(q->queue_lock);
 		io_schedule();
 
@@ -1045,7 +912,7 @@ static void add_acct_request(struct request_queue *q, struct request *rq,
 			     int where)
 {
 	drive_stat_acct(rq, 1);
-	__elv_add_request(q, rq, where, 0);
+	__elv_add_request(q, rq, where);
 }
 
 /**
@@ -2781,7 +2648,7 @@ static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
-		__elv_add_request(q, rq, ELEVATOR_INSERT_SORT, 0);
+		__elv_add_request(q, rq, ELEVATOR_INSERT_SORT);
 	}
 
 	if (q) {
diff --git a/block/blk-exec.c b/block/blk-exec.c
index cf1456a..81e3181 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -54,8 +54,8 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	rq->end_io = done;
 	WARN_ON(irqs_disabled());
 	spin_lock_irq(q->queue_lock);
-	__elv_add_request(q, rq, where, 1);
-	__generic_unplug_device(q);
+	__elv_add_request(q, rq, where);
+	__blk_run_queue(q);
 	/* the queue is stopped so it won't be plugged+unplugged */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
 		q->request_fn(q);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 54b123d..c0a07aa 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -59,7 +59,6 @@ static struct request *blk_flush_complete_seq(struct request_queue *q,
 static void blk_flush_complete_seq_end_io(struct request_queue *q,
 					  unsigned seq, int error)
 {
-	bool was_empty = elv_queue_empty(q);
 	struct request *next_rq;
 
 	next_rq = blk_flush_complete_seq(q, seq, error);
@@ -68,7 +67,7 @@ static void blk_flush_complete_seq_end_io(struct request_queue *q,
 	 * Moving a request silently to empty queue_head may stall the
 	 * queue.  Kick the queue in those cases.
 	 */
-	if (was_empty && next_rq)
+	if (next_rq)
 		__blk_run_queue(q);
 }
 
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 36c8c1f..c8d6892 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -164,14 +164,6 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
 
-	q->unplug_thresh = 4;		/* hmm */
-	q->unplug_delay = msecs_to_jiffies(3);	/* 3 milliseconds */
-	if (q->unplug_delay == 0)
-		q->unplug_delay = 1;
-
-	q->unplug_timer.function = blk_unplug_timeout;
-	q->unplug_timer.data = (unsigned long)q;
-
 	blk_set_default_limits(&q->limits);
 	blk_queue_max_hw_sectors(q, BLK_SAFE_MAX_SECTORS);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 41fb691..8d3e40c 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -481,6 +481,9 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blk_trace_shutdown(q);
 
+#if 0
+	cleanup_qrcu_struct(&q->qrcu);
+#endif
 	bdi_destroy(&q->backing_dev_info);
 	kmem_cache_free(blk_requestq_cachep, q);
 }
diff --git a/block/blk.h b/block/blk.h
index 2db8f32..2c3d2e7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -18,8 +18,6 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 
-void blk_unplug_work(struct work_struct *work);
-void blk_unplug_timeout(unsigned long data);
 void blk_rq_timed_out_timer(unsigned long data);
 void blk_delete_timer(struct request *);
 void blk_add_timer(struct request *);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 501ffdf..0a5f731 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -501,13 +501,6 @@ static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
 	}
 }
 
-static int cfq_queue_empty(struct request_queue *q)
-{
-	struct cfq_data *cfqd = q->elevator->elevator_data;
-
-	return !cfqd->rq_queued;
-}
-
 /*
  * Scale schedule slice based on io priority. Use the sync time slice only
  * if a queue is marked sync and has sync io queued. A sync queue with async
@@ -4092,7 +4085,6 @@ static struct elevator_type iosched_cfq = {
 		.elevator_add_req_fn =		cfq_insert_request,
 		.elevator_activate_req_fn =	cfq_activate_request,
 		.elevator_deactivate_req_fn =	cfq_deactivate_request,
-		.elevator_queue_empty_fn =	cfq_queue_empty,
 		.elevator_completed_req_fn =	cfq_completed_request,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index b547cbc..5139c0e 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -326,14 +326,6 @@ dispatch_request:
 	return 1;
 }
 
-static int deadline_queue_empty(struct request_queue *q)
-{
-	struct deadline_data *dd = q->elevator->elevator_data;
-
-	return list_empty(&dd->fifo_list[WRITE])
-		&& list_empty(&dd->fifo_list[READ]);
-}
-
 static void deadline_exit_queue(struct elevator_queue *e)
 {
 	struct deadline_data *dd = e->elevator_data;
@@ -445,7 +437,6 @@ static struct elevator_type iosched_deadline = {
 		.elevator_merge_req_fn =	deadline_merged_requests,
 		.elevator_dispatch_fn =		deadline_dispatch_requests,
 		.elevator_add_req_fn =		deadline_add_request,
-		.elevator_queue_empty_fn =	deadline_queue_empty,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
 		.elevator_init_fn =		deadline_init_queue,
diff --git a/block/elevator.c b/block/elevator.c
index a9fe237..d5d17a4 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -619,8 +619,6 @@ void elv_quiesce_end(struct request_queue *q)
 
 void elv_insert(struct request_queue *q, struct request *rq, int where)
 {
-	int unplug_it = 1;
-
 	trace_block_rq_insert(q, rq);
 
 	rq->q = q;
@@ -632,8 +630,6 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		 * don't force unplug of the queue for that case.
 		 * Clear unplug_it and fall through.
 		 */
-		unplug_it = 0;
-
 	case ELEVATOR_INSERT_FRONT:
 		rq->cmd_flags |= REQ_SOFTBARRIER;
 		list_add(&rq->queuelist, &q->queue_head);
@@ -674,24 +670,14 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		 */
 		q->elevator->ops->elevator_add_req_fn(q, rq);
 		break;
-
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
 		       __func__, where);
 		BUG();
 	}
-
-	if (unplug_it && blk_queue_plugged(q)) {
-		int nrq = q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC]
-				- queue_in_flight(q);
-
-		if (nrq >= q->unplug_thresh)
-			__generic_unplug_device(q);
-	}
 }
 
-void __elv_add_request(struct request_queue *q, struct request *rq, int where,
-		       int plug)
+void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	BUG_ON(rq->cmd_flags & REQ_ON_PLUG);
 
@@ -706,38 +692,20 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where,
 		    where == ELEVATOR_INSERT_SORT)
 		where = ELEVATOR_INSERT_BACK;
 
-	if (plug)
-		blk_plug_device(q);
-
 	elv_insert(q, rq, where);
 }
 EXPORT_SYMBOL(__elv_add_request);
 
-void elv_add_request(struct request_queue *q, struct request *rq, int where,
-		     int plug)
+void elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	__elv_add_request(q, rq, where, plug);
+	__elv_add_request(q, rq, where);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(elv_add_request);
 
-int elv_queue_empty(struct request_queue *q)
-{
-	struct elevator_queue *e = q->elevator;
-
-	if (!list_empty(&q->queue_head))
-		return 0;
-
-	if (e->ops->elevator_queue_empty_fn)
-		return e->ops->elevator_queue_empty_fn(q);
-
-	return 1;
-}
-EXPORT_SYMBOL(elv_queue_empty);
-
 struct request *elv_latter_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 232c4b3..06389e9 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -39,13 +39,6 @@ static void noop_add_request(struct request_queue *q, struct request *rq)
 	list_add_tail(&rq->queuelist, &nd->queue);
 }
 
-static int noop_queue_empty(struct request_queue *q)
-{
-	struct noop_data *nd = q->elevator->elevator_data;
-
-	return list_empty(&nd->queue);
-}
-
 static struct request *
 noop_former_request(struct request_queue *q, struct request *rq)
 {
@@ -90,7 +83,6 @@ static struct elevator_type elevator_noop = {
 		.elevator_merge_req_fn		= noop_merged_requests,
 		.elevator_dispatch_fn		= noop_dispatch,
 		.elevator_add_req_fn		= noop_add_request,
-		.elevator_queue_empty_fn	= noop_queue_empty,
 		.elevator_former_req_fn		= noop_former_request,
 		.elevator_latter_req_fn		= noop_latter_request,
 		.elevator_init_fn		= noop_init_queue,
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 516d5bb..37d1545 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3170,12 +3170,6 @@ static void do_cciss_request(struct request_queue *q)
 	int sg_index = 0;
 	int chained = 0;
 
-	/* We call start_io here in case there is a command waiting on the
-	 * queue that has not been sent.
-	 */
-	if (blk_queue_plugged(q))
-		goto startio;
-
       queue:
 	creq = blk_peek_request(q);
 	if (!creq)
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 946dad4..b2fceb5 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -911,9 +911,6 @@ static void do_ida_request(struct request_queue *q)
 	struct scatterlist tmp_sg[SG_MAX];
 	int i, dir, seg;
 
-	if (blk_queue_plugged(q))
-		goto startio;
-
 queue_next:
 	creq = blk_peek_request(q);
 	if (!creq)
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index ba95cba..2096628 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -689,8 +689,6 @@ void drbd_al_to_on_disk_bm(struct drbd_conf *mdev)
 		}
 	}
 
-	drbd_blk_run_queue(bdev_get_queue(mdev->ldev->md_bdev));
-
 	/* always (try to) flush bitmap to stable storage */
 	drbd_md_flush(mdev);
 
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index fd42832..0645ca8 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -840,7 +840,6 @@ static int bm_rw(struct drbd_conf *mdev, int rw) __must_hold(local)
 	for (i = 0; i < num_pages; i++)
 		bm_page_io_async(mdev, b, i, rw);
 
-	drbd_blk_run_queue(bdev_get_queue(mdev->ldev->md_bdev));
 	wait_event(b->bm_io_wait, atomic_read(&b->bm_async_io) == 0);
 
 	if (test_bit(BM_MD_IO_ERROR, &b->bm_flags)) {
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3803a03..0b5718e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -2382,20 +2382,6 @@ static inline int drbd_queue_order_type(struct drbd_conf *mdev)
 	return QUEUE_ORDERED_NONE;
 }
 
-static inline void drbd_blk_run_queue(struct request_queue *q)
-{
-	if (q && q->unplug_fn)
-		q->unplug_fn(q);
-}
-
-static inline void drbd_kick_lo(struct drbd_conf *mdev)
-{
-	if (get_ldev(mdev)) {
-		drbd_blk_run_queue(bdev_get_queue(mdev->ldev->backing_bdev));
-		put_ldev(mdev);
-	}
-}
-
 static inline void drbd_md_flush(struct drbd_conf *mdev)
 {
 	int r;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 29cd0dc..6049cb8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2719,35 +2719,6 @@ static int drbd_release(struct gendisk *gd, fmode_t mode)
 	return 0;
 }
 
-static void drbd_unplug_fn(struct request_queue *q)
-{
-	struct drbd_conf *mdev = q->queuedata;
-
-	/* unplug FIRST */
-	spin_lock_irq(q->queue_lock);
-	blk_remove_plug(q);
-	spin_unlock_irq(q->queue_lock);
-
-	/* only if connected */
-	spin_lock_irq(&mdev->req_lock);
-	if (mdev->state.pdsk >= D_INCONSISTENT && mdev->state.conn >= C_CONNECTED) {
-		D_ASSERT(mdev->state.role == R_PRIMARY);
-		if (test_and_clear_bit(UNPLUG_REMOTE, &mdev->flags)) {
-			/* add to the data.work queue,
-			 * unless already queued.
-			 * XXX this might be a good addition to drbd_queue_work
-			 * anyways, to detect "double queuing" ... */
-			if (list_empty(&mdev->unplug_work.list))
-				drbd_queue_work(&mdev->data.work,
-						&mdev->unplug_work);
-		}
-	}
-	spin_unlock_irq(&mdev->req_lock);
-
-	if (mdev->state.disk >= D_INCONSISTENT)
-		drbd_kick_lo(mdev);
-}
-
 static void drbd_set_defaults(struct drbd_conf *mdev)
 {
 	/* This way we get a compile error when sync_conf grows,
@@ -3222,9 +3193,7 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	blk_queue_max_segment_size(q, DRBD_MAX_SEGMENT_SIZE);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	blk_queue_merge_bvec(q, drbd_merge_bvec);
-	q->queue_lock = &mdev->req_lock; /* needed since we use */
-		/* plugging on a queue, that actually has no requests! */
-	q->unplug_fn = drbd_unplug_fn;
+	q->queue_lock = &mdev->req_lock;
 
 	mdev->md_io_page = alloc_page(GFP_KERNEL);
 	if (!mdev->md_io_page)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 24487d4..84132f8 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -187,15 +187,6 @@ static struct page *drbd_pp_first_pages_or_try_alloc(struct drbd_conf *mdev, int
 	return NULL;
 }
 
-/* kick lower level device, if we have more than (arbitrary number)
- * reference counts on it, which typically are locally submitted io
- * requests.  don't use unacked_cnt, so we speed up proto A and B, too. */
-static void maybe_kick_lo(struct drbd_conf *mdev)
-{
-	if (atomic_read(&mdev->local_cnt) >= mdev->net_conf->unplug_watermark)
-		drbd_kick_lo(mdev);
-}
-
 static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed)
 {
 	struct drbd_epoch_entry *e;
@@ -219,7 +210,6 @@ static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
 	LIST_HEAD(reclaimed);
 	struct drbd_epoch_entry *e, *t;
 
-	maybe_kick_lo(mdev);
 	spin_lock_irq(&mdev->req_lock);
 	reclaim_net_ee(mdev, &reclaimed);
 	spin_unlock_irq(&mdev->req_lock);
@@ -436,8 +426,7 @@ void _drbd_wait_ee_list_empty(struct drbd_conf *mdev, struct list_head *head)
 	while (!list_empty(head)) {
 		prepare_to_wait(&mdev->ee_wait, &wait, TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(&mdev->req_lock);
-		drbd_kick_lo(mdev);
-		schedule();
+		io_schedule();
 		finish_wait(&mdev->ee_wait, &wait);
 		spin_lock_irq(&mdev->req_lock);
 	}
@@ -1147,7 +1136,6 @@ next_bio:
 
 		drbd_generic_make_request(mdev, fault_type, bio);
 	} while (bios);
-	maybe_kick_lo(mdev);
 	return 0;
 
 fail:
@@ -1167,9 +1155,6 @@ static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packets cmd, unsign
 
 	inc_unacked(mdev);
 
-	if (mdev->net_conf->wire_protocol != DRBD_PROT_C)
-		drbd_kick_lo(mdev);
-
 	mdev->current_epoch->barrier_nr = p->barrier;
 	rv = drbd_may_finish_epoch(mdev, mdev->current_epoch, EV_GOT_BARRIER_NR);
 
@@ -3556,9 +3541,6 @@ static int receive_skip(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	if (mdev->state.disk >= D_INCONSISTENT)
-		drbd_kick_lo(mdev);
-
 	/* Make sure we've acked all the TCP data associated
 	 * with the data requests being unplugged */
 	drbd_tcp_quickack(mdev->data.socket);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 11a75d3..ad3fc62 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -960,10 +960,6 @@ allocate_barrier:
 			bio_endio(req->private_bio, -EIO);
 	}
 
-	/* we need to plug ALWAYS since we possibly need to kick lo_dev.
-	 * we plug after submit, so we won't miss an unplug event */
-	drbd_plug_device(mdev);
-
 	return 0;
 
 fail_conflicting:
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 34f224b..e027446 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -792,7 +792,6 @@ int drbd_resync_finished(struct drbd_conf *mdev)
 		 * queue (or even the read operations for those packets
 		 * is not finished by now).   Retry in 100ms. */
 
-		drbd_kick_lo(mdev);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ / 10);
 		w = kmalloc(sizeof(struct drbd_work), GFP_ATOMIC);
diff --git a/drivers/block/drbd/drbd_wrappers.h b/drivers/block/drbd/drbd_wrappers.h
index defdb50..53586fa 100644
--- a/drivers/block/drbd/drbd_wrappers.h
+++ b/drivers/block/drbd/drbd_wrappers.h
@@ -45,24 +45,6 @@ static inline void drbd_generic_make_request(struct drbd_conf *mdev,
 		generic_make_request(bio);
 }
 
-static inline void drbd_plug_device(struct drbd_conf *mdev)
-{
-	struct request_queue *q;
-	q = bdev_get_queue(mdev->this_bdev);
-
-	spin_lock_irq(q->queue_lock);
-
-/* XXX the check on !blk_queue_plugged is redundant,
- * implicitly checked in blk_plug_device */
-
-	if (!blk_queue_plugged(q)) {
-		blk_plug_device(q);
-		del_timer(&q->unplug_timer);
-		/* unplugging should not happen automatically... */
-	}
-	spin_unlock_irq(q->queue_lock);
-}
-
 static inline int drbd_crypto_is_hash(struct crypto_tfm *tfm)
 {
         return (crypto_tfm_alg_type(tfm) & CRYPTO_ALG_TYPE_HASH_MASK)
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index b9ba04f..271142b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3837,7 +3837,6 @@ static int __floppy_read_block_0(struct block_device *bdev)
 	bio.bi_end_io = floppy_rb0_complete;
 
 	submit_bio(READ, &bio);
-	generic_unplug_device(bdev_get_queue(bdev));
 	process_fd_request();
 	wait_for_completion(&complete);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 44e18c0..03cf2c9 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -541,17 +541,6 @@ out:
 	return 0;
 }
 
-/*
- * kick off io on the underlying address space
- */
-static void loop_unplug(struct request_queue *q)
-{
-	struct loop_device *lo = q->queuedata;
-
-	queue_flag_clear_unlocked(QUEUE_FLAG_PLUGGED, q);
-	blk_run_address_space(lo->lo_backing_file->f_mapping);
-}
-
 struct switch_request {
 	struct file *file;
 	struct completion wait;
@@ -918,7 +907,6 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	 */
 	blk_queue_make_request(lo->lo_queue, loop_make_request);
 	lo->lo_queue->queuedata = lo;
-	lo->lo_queue->unplug_fn = loop_unplug;
 
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_flush(lo->lo_queue, REQ_FLUSH);
@@ -1020,7 +1008,6 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 
 	kthread_stop(lo->lo_thread);
 
-	lo->lo_queue->unplug_fn = NULL;
 	lo->lo_backing_file = NULL;
 
 	loop_release_xfer(lo);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 77d70ee..d20e13f 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1606,8 +1606,6 @@ static int kcdrwd(void *foobar)
 					min_sleep_time = pkt->sleep_time;
 			}
 
-			generic_unplug_device(bdev_get_queue(pd->bdev));
-
 			VPRINTK("kcdrwd: sleeping\n");
 			residue = schedule_timeout(min_sleep_time);
 			VPRINTK("kcdrwd: wake up\n");
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 8be5715..653439f 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -241,8 +241,7 @@ static void dump_dmastat(struct cardinfo *card, unsigned int dmastat)
  *
  * Whenever IO on the active page completes, the Ready page is activated
  * and the ex-Active page is clean out and made Ready.
- * Otherwise the Ready page is only activated when it becomes full, or
- * when mm_unplug_device is called via the unplug_io_fn.
+ * Otherwise the Ready page is only activated when it becomes full.
  *
  * If a request arrives while both pages a full, it is queued, and b_rdev is
  * overloaded to record whether it was a read or a write.
@@ -333,17 +332,6 @@ static inline void reset_page(struct mm_page *page)
 	page->biotail = &page->bio;
 }
 
-static void mm_unplug_device(struct request_queue *q)
-{
-	struct cardinfo *card = q->queuedata;
-	unsigned long flags;
-
-	spin_lock_irqsave(&card->lock, flags);
-	if (blk_remove_plug(q))
-		activate(card);
-	spin_unlock_irqrestore(&card->lock, flags);
-}
-
 /*
  * If there is room on Ready page, take
  * one bh off list and add it.
@@ -535,7 +523,6 @@ static int mm_make_request(struct request_queue *q, struct bio *bio)
 	*card->biotail = bio;
 	bio->bi_next = NULL;
 	card->biotail = &bio->bi_next;
-	blk_plug_device(q);
 	spin_unlock_irq(&card->lock);
 
 	return 0;
@@ -907,7 +894,6 @@ static int __devinit mm_pci_probe(struct pci_dev *dev,
 	blk_queue_make_request(card->queue, mm_make_request);
 	card->queue->queue_lock = &card->lock;
 	card->queue->queuedata = card;
-	card->queue->unplug_fn = mm_unplug_device;
 
 	tasklet_init(&card->tasklet, process_page, (unsigned long)card);
 
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e88a2cf..6f218e01 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -233,8 +233,7 @@ int ide_queue_sense_rq(ide_drive_t *drive, void *special)
 
 	drive->hwif->rq = NULL;
 
-	elv_add_request(drive->queue, &drive->sense_rq,
-			ELEVATOR_INSERT_FRONT, 0);
+	elv_add_request(drive->queue, &drive->sense_rq, ELEVATOR_INSERT_FRONT);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ide_queue_sense_rq);
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 999dac0..f407784 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -549,8 +549,6 @@ plug_device_2:
 
 	if (rq)
 		blk_requeue_request(q, rq);
-	if (!elv_queue_empty(q))
-		blk_plug_device(q);
 }
 
 void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
@@ -562,8 +560,6 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
 
 	if (rq)
 		blk_requeue_request(q, rq);
-	if (!elv_queue_empty(q))
-		blk_plug_device(q);
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 88a380c..6ab9ab2 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -52,7 +52,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	rq->cmd[0] = REQ_UNPARK_HEADS;
 	rq->cmd_len = 1;
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT, 1);
+	elv_add_request(q, rq, ELEVATOR_INSERT_FRONT);
 
 out:
 	return;
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 9a35320..54bfc27 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1339,8 +1339,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
 			spin_unlock_irq(&bitmap->lock);
-			md_unplug(bitmap->mddev);
-			schedule();
+			io_schedule();
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
 		}
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4e054bd..2c62c11 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -991,11 +991,6 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_destructor = dm_crypt_bio_destructor;
 }
 
-static void kcryptd_unplug(struct crypt_config *cc)
-{
-	blk_unplug(bdev_get_queue(cc->dev->bdev));
-}
-
 static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 {
 	struct crypt_config *cc = io->target->private;
@@ -1008,10 +1003,8 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	 * one in order to decrypt the whole bio data *afterwards*.
 	 */
 	clone = bio_alloc_bioset(gfp, bio_segments(base_bio), cc->bs);
-	if (!clone) {
-		kcryptd_unplug(cc);
+	if (!clone)
 		return 1;
-	}
 
 	crypt_inc_pending(io);
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 924f5f0..e8429ce 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -315,31 +315,6 @@ static int run_complete_job(struct kcopyd_job *job)
 	return 0;
 }
 
-/*
- * Unplug the block device at the specified index.
- */
-static void unplug(struct dm_kcopyd_client *kc, int rw)
-{
-	if (kc->unplug[rw] != NULL) {
-		blk_unplug(bdev_get_queue(kc->unplug[rw]));
-		kc->unplug[rw] = NULL;
-	}
-}
-
-/*
- * Prepare block device unplug. If there's another device
- * to be unplugged at the same array index, we unplug that
- * device first.
- */
-static void prepare_unplug(struct dm_kcopyd_client *kc, int rw,
-			   struct block_device *bdev)
-{
-	if (likely(kc->unplug[rw] == bdev))
-		return;
-	unplug(kc, rw);
-	kc->unplug[rw] = bdev;
-}
-
 static void complete_io(unsigned long error, void *context)
 {
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
@@ -386,15 +361,12 @@ static int run_io_job(struct kcopyd_job *job)
 		.client = job->kc->io_client,
 	};
 
-	if (job->rw == READ) {
+	if (job->rw == READ)
 		r = dm_io(&io_req, 1, &job->source, NULL);
-		prepare_unplug(job->kc, READ, job->source.bdev);
-	} else {
+	else {
 		if (job->num_dests > 1)
 			io_req.bi_rw |= REQ_UNPLUG;
 		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
-		if (!(io_req.bi_rw & REQ_UNPLUG))
-			prepare_unplug(job->kc, WRITE, job->dests[0].bdev);
 	}
 
 	return r;
@@ -466,6 +438,7 @@ static void do_work(struct work_struct *work)
 {
 	struct dm_kcopyd_client *kc = container_of(work,
 					struct dm_kcopyd_client, kcopyd_work);
+	struct blk_plug plug;
 
 	/*
 	 * The order that these are called is *very* important.
@@ -473,18 +446,12 @@ static void do_work(struct work_struct *work)
 	 * Pages jobs when successful will jump onto the io jobs
 	 * list.  io jobs call wake when they complete and it all
 	 * starts again.
-	 *
-	 * Note that io_jobs add block devices to the unplug array,
-	 * this array is cleared with "unplug" calls. It is thus
-	 * forbidden to run complete_jobs after io_jobs and before
-	 * unplug because the block device could be destroyed in
-	 * job completion callback.
 	 */
+	blk_start_plug(&plug);
 	process_jobs(&kc->complete_jobs, kc, run_complete_job);
 	process_jobs(&kc->pages_jobs, kc, run_pages_job);
 	process_jobs(&kc->io_jobs, kc, run_io_job);
-	unplug(kc, READ);
-	unplug(kc, WRITE);
+	blk_finish_plug(&plug);
 }
 
 /*
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index b9e1e15..5ef136c 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -394,7 +394,7 @@ static void raid_unplug(struct dm_target_callbacks *cb)
 {
 	struct raid_set *rs = container_of(cb, struct raid_set, callbacks);
 
-	md_raid5_unplug_device(rs->md.private);
+	md_raid5_kick_device(rs->md.private);
 }
 
 /*
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index dee3267..976ad46 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -842,8 +842,6 @@ static void do_mirror(struct work_struct *work)
 	do_reads(ms, &reads);
 	do_writes(ms, &writes);
 	do_failures(ms, &failures);
-
-	dm_table_unplug_all(ms->ti->table);
 }
 
 /*-----------------------------------------------------------------
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 38e4eb1..f50a7b9 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1275,29 +1275,6 @@ int dm_table_any_busy_target(struct dm_table *t)
 	return 0;
 }
 
-void dm_table_unplug_all(struct dm_table *t)
-{
-	struct dm_dev_internal *dd;
-	struct list_head *devices = dm_table_get_devices(t);
-	struct dm_target_callbacks *cb;
-
-	list_for_each_entry(dd, devices, list) {
-		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
-		char b[BDEVNAME_SIZE];
-
-		if (likely(q))
-			blk_unplug(q);
-		else
-			DMWARN_LIMIT("%s: Cannot unplug nonexistent device %s",
-				     dm_device_name(t->md),
-				     bdevname(dd->dm_dev.bdev, b));
-	}
-
-	list_for_each_entry(cb, &t->target_callbacks, list)
-		if (cb->unplug_fn)
-			cb->unplug_fn(cb);
-}
-
 struct mapped_device *dm_table_get_md(struct dm_table *t)
 {
 	return t->md;
@@ -1345,4 +1322,3 @@ EXPORT_SYMBOL(dm_table_get_mode);
 EXPORT_SYMBOL(dm_table_get_md);
 EXPORT_SYMBOL(dm_table_put);
 EXPORT_SYMBOL(dm_table_get);
-EXPORT_SYMBOL(dm_table_unplug_all);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index eaa3af0..d22b990 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -807,8 +807,6 @@ void dm_requeue_unmapped_request(struct request *clone)
 	dm_unprep_request(rq);
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (elv_queue_empty(q))
-		blk_plug_device(q);
 	blk_requeue_request(q, rq);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
@@ -1613,10 +1611,10 @@ static void dm_request_fn(struct request_queue *q)
 	 * number of in-flight I/Os after the queue is stopped in
 	 * dm_suspend().
 	 */
-	while (!blk_queue_plugged(q) && !blk_queue_stopped(q)) {
+	while (!blk_queue_stopped(q)) {
 		rq = blk_peek_request(q);
 		if (!rq)
-			goto plug_and_out;
+			goto delay_and_out;
 
 		/* always use block 0 to find the target for flushes for now */
 		pos = 0;
@@ -1627,7 +1625,7 @@ static void dm_request_fn(struct request_queue *q)
 		BUG_ON(!dm_target_is_valid(ti));
 
 		if (ti->type->busy && ti->type->busy(ti))
-			goto plug_and_out;
+			goto delay_and_out;
 
 		blk_start_request(rq);
 		clone = rq->special;
@@ -1647,11 +1645,8 @@ requeued:
 	BUG_ON(!irqs_disabled());
 	spin_lock(q->queue_lock);
 
-plug_and_out:
-	if (!elv_queue_empty(q))
-		/* Some requests still remain, retry later */
-		blk_plug_device(q);
-
+delay_and_out:
+	blk_delay_queue(q, HZ / 10);
 out:
 	dm_table_put(map);
 
@@ -1680,20 +1675,6 @@ static int dm_lld_busy(struct request_queue *q)
 	return r;
 }
 
-static void dm_unplug_all(struct request_queue *q)
-{
-	struct mapped_device *md = q->queuedata;
-	struct dm_table *map = dm_get_live_table(md);
-
-	if (map) {
-		if (dm_request_based(md))
-			generic_unplug_device(q);
-
-		dm_table_unplug_all(map);
-		dm_table_put(map);
-	}
-}
-
 static int dm_any_congested(void *congested_data, int bdi_bits)
 {
 	int r = bdi_bits;
@@ -1817,7 +1798,6 @@ static void dm_init_md_queue(struct mapped_device *md)
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 	blk_queue_flush(md->queue, REQ_FLUSH | REQ_FUA);
 }
@@ -2263,8 +2243,6 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 	int r = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
-	dm_unplug_all(md->queue);
-
 	add_wait_queue(&md->wait, &wait);
 
 	while (1) {
@@ -2539,7 +2517,6 @@ int dm_resume(struct mapped_device *md)
 
 	clear_bit(DMF_SUSPENDED, &md->flags);
 
-	dm_table_unplug_all(map);
 	r = 0;
 out:
 	dm_table_put(map);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 8a2f767..38861b5 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -87,22 +87,6 @@ static int linear_mergeable_bvec(struct request_queue *q,
 	return maxsectors << 9;
 }
 
-static void linear_unplug(struct request_queue *q)
-{
-	mddev_t *mddev = q->queuedata;
-	linear_conf_t *conf;
-	int i;
-
-	rcu_read_lock();
-	conf = rcu_dereference(mddev->private);
-
-	for (i=0; i < mddev->raid_disks; i++) {
-		struct request_queue *r_queue = bdev_get_queue(conf->disks[i].rdev->bdev);
-		blk_unplug(r_queue);
-	}
-	rcu_read_unlock();
-}
-
 static int linear_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
@@ -225,7 +209,6 @@ static int linear_run (mddev_t *mddev)
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
-	mddev->queue->unplug_fn = linear_unplug;
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	md_integrity_register(mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b76cfc8..d1326ac 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4807,7 +4807,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		__md_stop_writes(mddev);
 		md_stop(mddev);
 		mddev->queue->merge_bvec_fn = NULL;
-		mddev->queue->unplug_fn = NULL;
 		mddev->queue->backing_dev_info.congested_fn = NULL;
 
 		/* tell userspace to handle 'inactive' */
@@ -6662,8 +6661,6 @@ EXPORT_SYMBOL_GPL(md_allow_write);
 
 void md_unplug(mddev_t *mddev)
 {
-	if (mddev->queue)
-		blk_unplug(mddev->queue);
 	if (mddev->plug)
 		mddev->plug->unplug_fn(mddev->plug);
 }
@@ -6846,7 +6843,6 @@ void md_do_sync(mddev_t *mddev)
 		     >= mddev->resync_max - mddev->curr_resync_completed
 			    )) {
 			/* time to update curr_resync_completed */
-			md_unplug(mddev);
 			wait_event(mddev->recovery_wait,
 				   atomic_read(&mddev->recovery_active) == 0);
 			mddev->curr_resync_completed = j;
@@ -6922,7 +6918,6 @@ void md_do_sync(mddev_t *mddev)
 		 * about not overloading the IO subsystem. (things like an
 		 * e2fsck being done on the RAID array should execute fast)
 		 */
-		md_unplug(mddev);
 		cond_resched();
 
 		currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
@@ -6941,8 +6936,6 @@ void md_do_sync(mddev_t *mddev)
 	 * this also signals 'finished resyncing' to md_stop
 	 */
  out:
-	md_unplug(mddev);
-
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	/* tell personality that we are finished */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 6d7ddf3..1cc8ed4 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -106,36 +106,6 @@ static void multipath_end_request(struct bio *bio, int error)
 	rdev_dec_pending(rdev, conf->mddev);
 }
 
-static void unplug_slaves(mddev_t *mddev)
-{
-	multipath_conf_t *conf = mddev->private;
-	int i;
-
-	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->multipaths[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags)
-		    && atomic_read(&rdev->nr_pending)) {
-			struct request_queue *r_queue = bdev_get_queue(rdev->bdev);
-
-			atomic_inc(&rdev->nr_pending);
-			rcu_read_unlock();
-
-			blk_unplug(r_queue);
-
-			rdev_dec_pending(rdev, mddev);
-			rcu_read_lock();
-		}
-	}
-	rcu_read_unlock();
-}
-
-static void multipath_unplug(struct request_queue *q)
-{
-	unplug_slaves(q->queuedata);
-}
-
-
 static int multipath_make_request(mddev_t *mddev, struct bio * bio)
 {
 	multipath_conf_t *conf = mddev->private;
@@ -518,7 +488,6 @@ static int multipath_run (mddev_t *mddev)
 	 */
 	md_set_array_sectors(mddev, multipath_size(mddev, 0, 0));
 
-	mddev->queue->unplug_fn = multipath_unplug;
 	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	md_integrity_register(mddev);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index a39f4c3..3cf4279 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -25,21 +25,6 @@
 #include "raid0.h"
 #include "raid5.h"
 
-static void raid0_unplug(struct request_queue *q)
-{
-	mddev_t *mddev = q->queuedata;
-	raid0_conf_t *conf = mddev->private;
-	mdk_rdev_t **devlist = conf->devlist;
-	int raid_disks = conf->strip_zone[0].nb_dev;
-	int i;
-
-	for (i=0; i < raid_disks; i++) {
-		struct request_queue *r_queue = bdev_get_queue(devlist[i]->bdev);
-
-		blk_unplug(r_queue);
-	}
-}
-
 static int raid0_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
@@ -264,7 +249,6 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 		       mdname(mddev),
 		       (unsigned long long)smallest->sectors);
 	}
-	mddev->queue->unplug_fn = raid0_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a23ffa3..8a61fcc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -52,23 +52,16 @@
 #define	NR_RAID1_BIOS 256
 
 
-static void unplug_slaves(mddev_t *mddev);
-
 static void allow_barrier(conf_t *conf);
 static void lower_barrier(conf_t *conf);
 
 static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
-	r1bio_t *r1_bio;
 	int size = offsetof(r1bio_t, bios[pi->raid_disks]);
 
 	/* allocate a r1bio with room for raid_disks entries in the bios array */
-	r1_bio = kzalloc(size, gfp_flags);
-	if (!r1_bio && pi->mddev)
-		unplug_slaves(pi->mddev);
-
-	return r1_bio;
+	return kzalloc(size, gfp_flags);
 }
 
 static void r1bio_pool_free(void *r1_bio, void *data)
@@ -91,10 +84,8 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	int i, j;
 
 	r1_bio = r1bio_pool_alloc(gfp_flags, pi);
-	if (!r1_bio) {
-		unplug_slaves(pi->mddev);
+	if (!r1_bio)
 		return NULL;
-	}
 
 	/*
 	 * Allocate bios : 1 for reading, n-1 for writing
@@ -520,37 +511,6 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 	return new_disk;
 }
 
-static void unplug_slaves(mddev_t *mddev)
-{
-	conf_t *conf = mddev->private;
-	int i;
-
-	rcu_read_lock();
-	for (i=0; i<mddev->raid_disks; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
-			struct request_queue *r_queue = bdev_get_queue(rdev->bdev);
-
-			atomic_inc(&rdev->nr_pending);
-			rcu_read_unlock();
-
-			blk_unplug(r_queue);
-
-			rdev_dec_pending(rdev, mddev);
-			rcu_read_lock();
-		}
-	}
-	rcu_read_unlock();
-}
-
-static void raid1_unplug(struct request_queue *q)
-{
-	mddev_t *mddev = q->queuedata;
-
-	unplug_slaves(mddev);
-	md_wakeup_thread(mddev->thread);
-}
-
 static int raid1_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
@@ -580,20 +540,17 @@ static int raid1_congested(void *data, int bits)
 }
 
 
-static int flush_pending_writes(conf_t *conf)
+static void flush_pending_writes(conf_t *conf)
 {
 	/* Any writes that have been queued but are awaiting
 	 * bitmap updates get flushed here.
-	 * We return 1 if any requests were actually submitted.
 	 */
-	int rv = 0;
 
 	spin_lock_irq(&conf->device_lock);
 
 	if (conf->pending_bio_list.head) {
 		struct bio *bio;
 		bio = bio_list_get(&conf->pending_bio_list);
-		blk_remove_plug(conf->mddev->queue);
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to
 		 * disk before proceeding w/ I/O */
@@ -605,10 +562,14 @@ static int flush_pending_writes(conf_t *conf)
 			generic_make_request(bio);
 			bio = next;
 		}
-		rv = 1;
 	} else
 		spin_unlock_irq(&conf->device_lock);
-	return rv;
+}
+
+static void md_kick_device(mddev_t *mddev)
+{
+	blk_flush_plug(current);
+	md_wakeup_thread(mddev->thread);
 }
 
 /* Barriers....
@@ -640,8 +601,7 @@ static void raise_barrier(conf_t *conf)
 
 	/* Wait until no block IO is waiting */
 	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
-			    conf->resync_lock,
-			    raid1_unplug(conf->mddev->queue));
+			    conf->resync_lock, md_kick_device(conf->mddev));
 
 	/* block any new IO from starting */
 	conf->barrier++;
@@ -649,8 +609,7 @@ static void raise_barrier(conf_t *conf)
 	/* Now wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock,
-			    raid1_unplug(conf->mddev->queue));
+			    conf->resync_lock, md_kick_device(conf->mddev));
 
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -672,7 +631,7 @@ static void wait_barrier(conf_t *conf)
 		conf->nr_waiting++;
 		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
 				    conf->resync_lock,
-				    raid1_unplug(conf->mddev->queue));
+				    md_kick_device(conf->mddev));
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
@@ -709,7 +668,7 @@ static void freeze_array(conf_t *conf)
 			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
-			       raid1_unplug(conf->mddev->queue); }));
+			       md_kick_device(conf->mddev); }));
 	spin_unlock_irq(&conf->resync_lock);
 }
 static void unfreeze_array(conf_t *conf)
@@ -959,7 +918,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		atomic_inc(&r1_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
-		blk_plug_device(mddev->queue);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 	r1_bio_write_done(r1_bio, bio->bi_vcnt, behind_pages, behind_pages != NULL);
@@ -968,7 +926,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	/* In case raid1d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
 
-	if (do_sync)
+	if (do_sync || !bitmap)
 		md_wakeup_thread(mddev->thread);
 
 	return 0;
@@ -1558,7 +1516,6 @@ static void raid1d(mddev_t *mddev)
 	unsigned long flags;
 	conf_t *conf = mddev->private;
 	struct list_head *head = &conf->retry_list;
-	int unplug=0;
 	mdk_rdev_t *rdev;
 
 	md_check_recovery(mddev);
@@ -1566,7 +1523,7 @@ static void raid1d(mddev_t *mddev)
 	for (;;) {
 		char b[BDEVNAME_SIZE];
 
-		unplug += flush_pending_writes(conf);
+		flush_pending_writes(conf);
 
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (list_empty(head)) {
@@ -1580,10 +1537,9 @@ static void raid1d(mddev_t *mddev)
 
 		mddev = r1_bio->mddev;
 		conf = mddev->private;
-		if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
+		if (test_bit(R1BIO_IsSync, &r1_bio->state))
 			sync_request_write(mddev, r1_bio);
-			unplug = 1;
-		} else {
+		else {
 			int disk;
 
 			/* we got a read error. Maybe the drive is bad.  Maybe just
@@ -1633,14 +1589,11 @@ static void raid1d(mddev_t *mddev)
 				bio->bi_end_io = raid1_end_read_request;
 				bio->bi_rw = READ | do_sync;
 				bio->bi_private = r1_bio;
-				unplug = 1;
 				generic_make_request(bio);
 			}
 		}
 		cond_resched();
 	}
-	if (unplug)
-		unplug_slaves(mddev);
 }
 
 
@@ -2064,7 +2017,6 @@ static int run(mddev_t *mddev)
 
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
-	mddev->queue->unplug_fn = raid1_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 	md_integrity_register(mddev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 69b6595..5811845 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -57,23 +57,16 @@
  */
 #define	NR_RAID10_BIOS 256
 
-static void unplug_slaves(mddev_t *mddev);
-
 static void allow_barrier(conf_t *conf);
 static void lower_barrier(conf_t *conf);
 
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	conf_t *conf = data;
-	r10bio_t *r10_bio;
 	int size = offsetof(struct r10bio_s, devs[conf->copies]);
 
 	/* allocate a r10bio with room for raid_disks entries in the bios array */
-	r10_bio = kzalloc(size, gfp_flags);
-	if (!r10_bio && conf->mddev)
-		unplug_slaves(conf->mddev);
-
-	return r10_bio;
+	return kzalloc(size, gfp_flags);
 }
 
 static void r10bio_pool_free(void *r10_bio, void *data)
@@ -106,10 +99,8 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	int nalloc;
 
 	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
-	if (!r10_bio) {
-		unplug_slaves(conf->mddev);
+	if (!r10_bio)
 		return NULL;
-	}
 
 	if (test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery))
 		nalloc = conf->copies; /* resync */
@@ -597,37 +588,6 @@ rb_out:
 	return disk;
 }
 
-static void unplug_slaves(mddev_t *mddev)
-{
-	conf_t *conf = mddev->private;
-	int i;
-
-	rcu_read_lock();
-	for (i=0; i < conf->raid_disks; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
-			struct request_queue *r_queue = bdev_get_queue(rdev->bdev);
-
-			atomic_inc(&rdev->nr_pending);
-			rcu_read_unlock();
-
-			blk_unplug(r_queue);
-
-			rdev_dec_pending(rdev, mddev);
-			rcu_read_lock();
-		}
-	}
-	rcu_read_unlock();
-}
-
-static void raid10_unplug(struct request_queue *q)
-{
-	mddev_t *mddev = q->queuedata;
-
-	unplug_slaves(q->queuedata);
-	md_wakeup_thread(mddev->thread);
-}
-
 static int raid10_congested(void *data, int bits)
 {
 	mddev_t *mddev = data;
@@ -649,20 +609,17 @@ static int raid10_congested(void *data, int bits)
 	return ret;
 }
 
-static int flush_pending_writes(conf_t *conf)
+static void flush_pending_writes(conf_t *conf)
 {
 	/* Any writes that have been queued but are awaiting
 	 * bitmap updates get flushed here.
 	 * We return 1 if any requests were actually submitted.
 	 */
-	int rv = 0;
-
 	spin_lock_irq(&conf->device_lock);
 
 	if (conf->pending_bio_list.head) {
 		struct bio *bio;
 		bio = bio_list_get(&conf->pending_bio_list);
-		blk_remove_plug(conf->mddev->queue);
 		spin_unlock_irq(&conf->device_lock);
 		/* flush any pending bitmap writes to disk
 		 * before proceeding w/ I/O */
@@ -674,11 +631,16 @@ static int flush_pending_writes(conf_t *conf)
 			generic_make_request(bio);
 			bio = next;
 		}
-		rv = 1;
 	} else
 		spin_unlock_irq(&conf->device_lock);
-	return rv;
 }
+
+static void md_kick_device(mddev_t *mddev)
+{
+	blk_flush_plug(current);
+	md_wakeup_thread(mddev->thread);
+}
+
 /* Barriers....
  * Sometimes we need to suspend IO while we do something else,
  * either some resync/recovery, or reconfigure the array.
@@ -708,8 +670,7 @@ static void raise_barrier(conf_t *conf, int force)
 
 	/* Wait until no block IO is waiting (unless 'force') */
 	wait_event_lock_irq(conf->wait_barrier, force || !conf->nr_waiting,
-			    conf->resync_lock,
-			    raid10_unplug(conf->mddev->queue));
+			    conf->resync_lock, md_kick_device(conf->mddev));
 
 	/* block any new IO from starting */
 	conf->barrier++;
@@ -717,8 +678,7 @@ static void raise_barrier(conf_t *conf, int force)
 	/* No wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-			    conf->resync_lock,
-			    raid10_unplug(conf->mddev->queue));
+			    conf->resync_lock, md_kick_device(conf->mddev));
 
 	spin_unlock_irq(&conf->resync_lock);
 }
@@ -739,7 +699,7 @@ static void wait_barrier(conf_t *conf)
 		conf->nr_waiting++;
 		wait_event_lock_irq(conf->wait_barrier, !conf->barrier,
 				    conf->resync_lock,
-				    raid10_unplug(conf->mddev->queue));
+				    md_kick_device(conf->mddev));
 		conf->nr_waiting--;
 	}
 	conf->nr_pending++;
@@ -776,7 +736,7 @@ static void freeze_array(conf_t *conf)
 			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
-			       raid10_unplug(conf->mddev->queue); }));
+			       md_kick_device(conf->mddev); }));
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -971,7 +931,6 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		atomic_inc(&r10_bio->remaining);
 		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
-		blk_plug_device(mddev->queue);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
@@ -988,7 +947,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	/* In case raid10d snuck in to freeze_array */
 	wake_up(&conf->wait_barrier);
 
-	if (do_sync)
+	if (do_sync || !mddev->bitmap)
 		md_wakeup_thread(mddev->thread);
 
 	return 0;
@@ -1681,7 +1640,6 @@ static void raid10d(mddev_t *mddev)
 	unsigned long flags;
 	conf_t *conf = mddev->private;
 	struct list_head *head = &conf->retry_list;
-	int unplug=0;
 	mdk_rdev_t *rdev;
 
 	md_check_recovery(mddev);
@@ -1689,7 +1647,7 @@ static void raid10d(mddev_t *mddev)
 	for (;;) {
 		char b[BDEVNAME_SIZE];
 
-		unplug += flush_pending_writes(conf);
+		flush_pending_writes(conf);
 
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (list_empty(head)) {
@@ -1703,13 +1661,11 @@ static void raid10d(mddev_t *mddev)
 
 		mddev = r10_bio->mddev;
 		conf = mddev->private;
-		if (test_bit(R10BIO_IsSync, &r10_bio->state)) {
+		if (test_bit(R10BIO_IsSync, &r10_bio->state))
 			sync_request_write(mddev, r10_bio);
-			unplug = 1;
-		} else 	if (test_bit(R10BIO_IsRecover, &r10_bio->state)) {
+		else if (test_bit(R10BIO_IsRecover, &r10_bio->state))
 			recovery_request_write(mddev, r10_bio);
-			unplug = 1;
-		} else {
+		else {
 			int mirror;
 			/* we got a read error. Maybe the drive is bad.  Maybe just
 			 * the block and we can fix it.
@@ -1756,14 +1712,11 @@ static void raid10d(mddev_t *mddev)
 				bio->bi_rw = READ | do_sync;
 				bio->bi_private = r10_bio;
 				bio->bi_end_io = raid10_end_read_request;
-				unplug = 1;
 				generic_make_request(bio);
 			}
 		}
 		cond_resched();
 	}
-	if (unplug)
-		unplug_slaves(mddev);
 }
 
 
@@ -2376,7 +2329,6 @@ static int run(mddev_t *mddev)
 	md_set_array_sectors(mddev, size);
 	mddev->resync_max_sectors = size;
 
-	mddev->queue->unplug_fn = raid10_unplug;
 	mddev->queue->backing_dev_info.congested_fn = raid10_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5044bab..f1f2d3c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -433,8 +433,6 @@ static int has_failed(raid5_conf_t *conf)
 	return 0;
 }
 
-static void unplug_slaves(mddev_t *mddev);
-
 static struct stripe_head *
 get_active_stripe(raid5_conf_t *conf, sector_t sector,
 		  int previous, int noblock, int noquiesce)
@@ -463,8 +461,7 @@ get_active_stripe(raid5_conf_t *conf, sector_t sector,
 						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
 						    conf->device_lock,
-						    md_raid5_unplug_device(conf)
-					);
+						    md_raid5_kick_device(conf));
 				conf->inactive_blocked = 0;
 			} else
 				init_stripe(sh, sector, previous);
@@ -1473,8 +1470,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    !list_empty(&conf->inactive_list),
 				    conf->device_lock,
-				    unplug_slaves(conf->mddev)
-			);
+				    blk_flush_plug(current));
 		osh = get_free_stripe(conf);
 		spin_unlock_irq(&conf->device_lock);
 		atomic_set(&nsh->count, 1);
@@ -3645,58 +3641,19 @@ static void activate_bit_delay(raid5_conf_t *conf)
 	}
 }
 
-static void unplug_slaves(mddev_t *mddev)
-{
-	raid5_conf_t *conf = mddev->private;
-	int i;
-	int devs = max(conf->raid_disks, conf->previous_raid_disks);
-
-	rcu_read_lock();
-	for (i = 0; i < devs; i++) {
-		mdk_rdev_t *rdev = rcu_dereference(conf->disks[i].rdev);
-		if (rdev && !test_bit(Faulty, &rdev->flags) && atomic_read(&rdev->nr_pending)) {
-			struct request_queue *r_queue = bdev_get_queue(rdev->bdev);
-
-			atomic_inc(&rdev->nr_pending);
-			rcu_read_unlock();
-
-			blk_unplug(r_queue);
-
-			rdev_dec_pending(rdev, mddev);
-			rcu_read_lock();
-		}
-	}
-	rcu_read_unlock();
-}
-
-void md_raid5_unplug_device(raid5_conf_t *conf)
+void md_raid5_kick_device(raid5_conf_t *conf)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&conf->device_lock, flags);
-
-	if (plugger_remove_plug(&conf->plug)) {
-		conf->seq_flush++;
-		raid5_activate_delayed(conf);
-	}
+	blk_flush_plug(current);
+	raid5_activate_delayed(conf);
 	md_wakeup_thread(conf->mddev->thread);
-
-	spin_unlock_irqrestore(&conf->device_lock, flags);
-
-	unplug_slaves(conf->mddev);
 }
-EXPORT_SYMBOL_GPL(md_raid5_unplug_device);
+EXPORT_SYMBOL_GPL(md_raid5_kick_device);
 
 static void raid5_unplug(struct plug_handle *plug)
 {
 	raid5_conf_t *conf = container_of(plug, raid5_conf_t, plug);
-	md_raid5_unplug_device(conf);
-}
 
-static void raid5_unplug_queue(struct request_queue *q)
-{
-	mddev_t *mddev = q->queuedata;
-	md_raid5_unplug_device(mddev->private);
+	md_raid5_kick_device(conf);
 }
 
 int md_raid5_congested(mddev_t *mddev, int bits)
@@ -4100,7 +4057,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
 				 */
-				md_raid5_unplug_device(conf);
+				md_raid5_kick_device(conf);
 				release_stripe(sh);
 				schedule();
 				goto retry;
@@ -4365,7 +4322,6 @@ static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *ski
 
 	if (sector_nr >= max_sector) {
 		/* just being told to finish up .. nothing much to do */
-		unplug_slaves(mddev);
 
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
 			end_reshape(conf);
@@ -4569,7 +4525,6 @@ static void raid5d(mddev_t *mddev)
 	spin_unlock_irq(&conf->device_lock);
 
 	async_tx_issue_pending_all();
-	unplug_slaves(mddev);
 
 	pr_debug("--- raid5d inactive\n");
 }
@@ -5201,11 +5156,9 @@ static int run(mddev_t *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 
 		blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
-
 		mddev->queue->backing_dev_info.congested_data = mddev;
 		mddev->queue->backing_dev_info.congested_fn = raid5_congested;
 		mddev->queue->queue_lock = &conf->device_lock;
-		mddev->queue->unplug_fn = raid5_unplug_queue;
 
 		chunk_size = mddev->chunk_sectors << 9;
 		blk_queue_io_min(mddev->queue, chunk_size);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2ace058..8d563a4 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -503,6 +503,6 @@ static inline int algorithm_is_DDF(int layout)
 }
 
 extern int md_raid5_congested(mddev_t *mddev, int bits);
-extern void md_raid5_unplug_device(raid5_conf_t *conf);
+extern void md_raid5_kick_device(raid5_conf_t *conf);
 extern int raid5_set_cache_size(mddev_t *mddev, int size);
 #endif
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index ae7cad1..b29eb4e 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -895,11 +895,7 @@ static void i2o_block_request_fn(struct request_queue *q)
 {
 	struct request *req;
 
-	while (!blk_queue_plugged(q)) {
-		req = blk_peek_request(q);
-		if (!req)
-			break;
-
+	while ((req = blk_peek_request(q)) != NULL) {
 		if (req->cmd_type == REQ_TYPE_FS) {
 			struct i2o_block_delayed_request *dreq;
 			struct i2o_block_request *ireq = req->special;
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4e42d03..2ae7275 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -55,8 +55,7 @@ static int mmc_queue_thread(void *d)
 
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (!blk_queue_plugged(q))
-			req = blk_fetch_request(q);
+		req = blk_fetch_request(q);
 		mq->req = req;
 		spin_unlock_irq(q->queue_lock);
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 794bfd9..4d2df2f 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1917,7 +1917,7 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 		return;
 	}
 	/* Now we try to fetch requests from the request queue */
-	while (!blk_queue_plugged(queue) && (req = blk_peek_request(queue))) {
+	while ((req = blk_peek_request(queue))) {
 		if (basedev->features & DASD_FEATURE_READONLY &&
 		    rq_data_dir(req) == WRITE) {
 			DBF_DEV_EVENT(DBF_ERR, basedev,
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 55d2d0f..f061b25 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -161,7 +161,6 @@ tapeblock_requeue(struct work_struct *work) {
 
 	spin_lock_irq(&device->blk_data.request_queue_lock);
 	while (
-		!blk_queue_plugged(queue) &&
 		blk_peek_request(queue) &&
 		nr_queued < TAPEBLOCK_MIN_REQUEUE
 	) {
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 998c01b..2cefabd 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3913,7 +3913,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 	if (!get_device(dev))
 		return;
 
-	while (!blk_queue_plugged(q)) {
+	while (1) {
 		if (rport && (rport->port_state == FC_PORTSTATE_BLOCKED) &&
 		    !(rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT))
 			break;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 927e99c..c6fcf76 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -173,11 +173,7 @@ static void sas_smp_request(struct request_queue *q, struct Scsi_Host *shost,
 	int ret;
 	int (*handler)(struct Scsi_Host *, struct sas_rphy *, struct request *);
 
-	while (!blk_queue_plugged(q)) {
-		req = blk_fetch_request(q);
-		if (!req)
-			break;
-
+	while ((req = blk_fetch_request(q)) != NULL) {
 		spin_unlock_irq(q->queue_lock);
 
 		handler = to_sas_internal(shost->transportt)->f->smp_handler;
diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
index 65794b8..1cc84b2 100644
--- a/fs/adfs/inode.c
+++ b/fs/adfs/inode.c
@@ -73,7 +73,6 @@ static sector_t _adfs_bmap(struct address_space *mapping, sector_t block)
 static const struct address_space_operations adfs_aops = {
 	.readpage	= adfs_readpage,
 	.writepage	= adfs_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= adfs_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= _adfs_bmap
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 0a90dcd..acf321b 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -429,7 +429,6 @@ static sector_t _affs_bmap(struct address_space *mapping, sector_t block)
 const struct address_space_operations affs_aops = {
 	.readpage = affs_readpage,
 	.writepage = affs_writepage,
-	.sync_page = block_sync_page,
 	.write_begin = affs_write_begin,
 	.write_end = generic_write_end,
 	.bmap = _affs_bmap
@@ -786,7 +785,6 @@ out:
 const struct address_space_operations affs_aops_ofs = {
 	.readpage = affs_readpage_ofs,
 	//.writepage = affs_writepage_ofs,
-	//.sync_page = affs_sync_page_ofs,
 	.write_begin = affs_write_begin_ofs,
 	.write_end = affs_write_end_ofs
 };
diff --git a/fs/aio.c b/fs/aio.c
index fc557a3..c5ea494 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1550,9 +1550,11 @@ static void aio_batch_free(struct hlist_head *batch_hash)
 	struct hlist_node *pos, *n;
 	int i;
 
+	/*
+	 * TODO: kill this
+	 */
 	for (i = 0; i < AIO_BATCH_HASH_SIZE; i++) {
 		hlist_for_each_entry_safe(abe, pos, n, &batch_hash[i], list) {
-			blk_run_address_space(abe->mapping);
 			iput(abe->mapping->host);
 			hlist_del(&abe->list);
 			mempool_free(abe, abe_pool);
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index b1d0c79..06457ed 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -75,7 +75,6 @@ static const struct inode_operations befs_dir_inode_operations = {
 
 static const struct address_space_operations befs_aops = {
 	.readpage	= befs_readpage,
-	.sync_page	= block_sync_page,
 	.bmap		= befs_bmap,
 };
 
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index eb67edd..f20e8a7 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -186,7 +186,6 @@ static sector_t bfs_bmap(struct address_space *mapping, sector_t block)
 const struct address_space_operations bfs_aops = {
 	.readpage	= bfs_readpage,
 	.writepage	= bfs_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= bfs_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= bfs_bmap,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 333a7bb..6dea657 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1521,7 +1521,6 @@ static int blkdev_releasepage(struct page *page, gfp_t wait)
 static const struct address_space_operations def_blk_aops = {
 	.readpage	= blkdev_readpage,
 	.writepage	= blkdev_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= blkdev_write_begin,
 	.write_end	= blkdev_write_end,
 	.writepages	= generic_writepages,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b531c36..bb5c93a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -843,7 +843,6 @@ static const struct address_space_operations btree_aops = {
 	.writepages	= btree_writepages,
 	.releasepage	= btree_releasepage,
 	.invalidatepage = btree_invalidatepage,
-	.sync_page	= block_sync_page,
 #ifdef CONFIG_MIGRATION
 	.migratepage	= btree_migratepage,
 #endif
@@ -1327,82 +1326,6 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 }
 
 /*
- * this unplugs every device on the box, and it is only used when page
- * is null
- */
-static void __unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
-{
-	struct btrfs_device *device;
-	struct btrfs_fs_info *info;
-
-	info = (struct btrfs_fs_info *)bdi->unplug_io_data;
-	list_for_each_entry(device, &info->fs_devices->devices, dev_list) {
-		if (!device->bdev)
-			continue;
-
-		bdi = blk_get_backing_dev_info(device->bdev);
-		if (bdi->unplug_io_fn)
-			bdi->unplug_io_fn(bdi, page);
-	}
-}
-
-static void btrfs_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
-{
-	struct inode *inode;
-	struct extent_map_tree *em_tree;
-	struct extent_map *em;
-	struct address_space *mapping;
-	u64 offset;
-
-	/* the generic O_DIRECT read code does this */
-	if (1 || !page) {
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-
-	/*
-	 * page->mapping may change at any time.  Get a consistent copy
-	 * and use that for everything below
-	 */
-	smp_mb();
-	mapping = page->mapping;
-	if (!mapping)
-		return;
-
-	inode = mapping->host;
-
-	/*
-	 * don't do the expensive searching for a small number of
-	 * devices
-	 */
-	if (BTRFS_I(inode)->root->fs_info->fs_devices->open_devices <= 2) {
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-
-	offset = page_offset(page);
-
-	em_tree = &BTRFS_I(inode)->extent_tree;
-	read_lock(&em_tree->lock);
-	em = lookup_extent_mapping(em_tree, offset, PAGE_CACHE_SIZE);
-	read_unlock(&em_tree->lock);
-	if (!em) {
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-
-	if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
-		free_extent_map(em);
-		__unplug_io_fn(bdi, page);
-		return;
-	}
-	offset = offset - em->start;
-	btrfs_unplug_page(&BTRFS_I(inode)->root->fs_info->mapping_tree,
-			  em->block_start + offset, page);
-	free_extent_map(em);
-}
-
-/*
  * If this fails, caller must call bdi_destroy() to get rid of the
  * bdi again.
  */
@@ -1416,8 +1339,6 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
 		return err;
 
 	bdi->ra_pages	= default_backing_dev_info.ra_pages;
-	bdi->unplug_io_fn	= btrfs_unplug_io_fn;
-	bdi->unplug_io_data	= info;
 	bdi->congested_fn	= btrfs_congested_fn;
 	bdi->congested_data	= info;
 	return 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 160b55b..a4da8bc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7204,7 +7204,6 @@ static const struct address_space_operations btrfs_aops = {
 	.writepage	= btrfs_writepage,
 	.writepages	= btrfs_writepages,
 	.readpages	= btrfs_readpages,
-	.sync_page	= block_sync_page,
 	.direct_IO	= btrfs_direct_IO,
 	.invalidatepage = btrfs_invalidatepage,
 	.releasepage	= btrfs_releasepage,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d158530..a5d4417 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -162,7 +162,6 @@ static noinline int run_scheduled_bios(struct btrfs_device *device)
 	struct bio *cur;
 	int again = 0;
 	unsigned long num_run;
-	unsigned long num_sync_run;
 	unsigned long batch_run = 0;
 	unsigned long limit;
 	unsigned long last_waited = 0;
@@ -173,11 +172,6 @@ static noinline int run_scheduled_bios(struct btrfs_device *device)
 	limit = btrfs_async_submit_limit(fs_info);
 	limit = limit * 2 / 3;
 
-	/* we want to make sure that every time we switch from the sync
-	 * list to the normal list, we unplug
-	 */
-	num_sync_run = 0;
-
 loop:
 	spin_lock(&device->io_lock);
 
@@ -223,15 +217,6 @@ loop_lock:
 
 	spin_unlock(&device->io_lock);
 
-	/*
-	 * if we're doing the regular priority list, make sure we unplug
-	 * for any high prio bios we've sent down
-	 */
-	if (pending_bios == &device->pending_bios && num_sync_run > 0) {
-		num_sync_run = 0;
-		blk_run_backing_dev(bdi, NULL);
-	}
-
 	while (pending) {
 
 		rmb();
@@ -259,19 +244,11 @@ loop_lock:
 
 		BUG_ON(atomic_read(&cur->bi_cnt) == 0);
 
-		if (cur->bi_rw & REQ_SYNC)
-			num_sync_run++;
-
 		submit_bio(cur->bi_rw, cur);
 		num_run++;
 		batch_run++;
-		if (need_resched()) {
-			if (num_sync_run) {
-				blk_run_backing_dev(bdi, NULL);
-				num_sync_run = 0;
-			}
+		if (need_resched())
 			cond_resched();
-		}
 
 		/*
 		 * we made progress, there is more work to do and the bdi
@@ -304,13 +281,8 @@ loop_lock:
 				 * against it before looping
 				 */
 				last_waited = ioc->last_waited;
-				if (need_resched()) {
-					if (num_sync_run) {
-						blk_run_backing_dev(bdi, NULL);
-						num_sync_run = 0;
-					}
+				if (need_resched())
 					cond_resched();
-				}
 				continue;
 			}
 			spin_lock(&device->io_lock);
@@ -323,22 +295,6 @@ loop_lock:
 		}
 	}
 
-	if (num_sync_run) {
-		num_sync_run = 0;
-		blk_run_backing_dev(bdi, NULL);
-	}
-	/*
-	 * IO has already been through a long path to get here.  Checksumming,
-	 * async helper threads, perhaps compression.  We've done a pretty
-	 * good job of collecting a batch of IO and should just unplug
-	 * the device right away.
-	 *
-	 * This will help anyone who is waiting on the IO, they might have
-	 * already unplugged, but managed to do so before the bio they
-	 * cared about found its way down here.
-	 */
-	blk_run_backing_dev(bdi, NULL);
-
 	cond_resched();
 	if (again)
 		goto loop;
@@ -2931,7 +2887,7 @@ static int find_live_mirror(struct map_lookup *map, int first, int num,
 static int __btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 			     u64 logical, u64 *length,
 			     struct btrfs_multi_bio **multi_ret,
-			     int mirror_num, struct page *unplug_page)
+			     int mirror_num)
 {
 	struct extent_map *em;
 	struct map_lookup *map;
@@ -2963,11 +2919,6 @@ again:
 	em = lookup_extent_mapping(em_tree, logical, *length);
 	read_unlock(&em_tree->lock);
 
-	if (!em && unplug_page) {
-		kfree(multi);
-		return 0;
-	}
-
 	if (!em) {
 		printk(KERN_CRIT "unable to find logical %llu len %llu\n",
 		       (unsigned long long)logical,
@@ -3023,13 +2974,13 @@ again:
 		*length = em->len - offset;
 	}
 
-	if (!multi_ret && !unplug_page)
+	if (!multi_ret)
 		goto out;
 
 	num_stripes = 1;
 	stripe_index = 0;
 	if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
-		if (unplug_page || (rw & REQ_WRITE))
+		if (rw & REQ_WRITE)
 			num_stripes = map->num_stripes;
 		else if (mirror_num)
 			stripe_index = mirror_num - 1;
@@ -3051,7 +3002,7 @@ again:
 		stripe_index = do_div(stripe_nr, factor);
 		stripe_index *= map->sub_stripes;
 
-		if (unplug_page || (rw & REQ_WRITE))
+		if (rw & REQ_WRITE)
 			num_stripes = map->sub_stripes;
 		else if (mirror_num)
 			stripe_index += mirror_num - 1;
@@ -3071,22 +3022,10 @@ again:
 	BUG_ON(stripe_index >= map->num_stripes);
 
 	for (i = 0; i < num_stripes; i++) {
-		if (unplug_page) {
-			struct btrfs_device *device;
-			struct backing_dev_info *bdi;
-
-			device = map->stripes[stripe_index].dev;
-			if (device->bdev) {
-				bdi = blk_get_backing_dev_info(device->bdev);
-				if (bdi->unplug_io_fn)
-					bdi->unplug_io_fn(bdi, unplug_page);
-			}
-		} else {
-			multi->stripes[i].physical =
-				map->stripes[stripe_index].physical +
-				stripe_offset + stripe_nr * map->stripe_len;
-			multi->stripes[i].dev = map->stripes[stripe_index].dev;
-		}
+		multi->stripes[i].physical =
+			map->stripes[stripe_index].physical +
+			stripe_offset + stripe_nr * map->stripe_len;
+		multi->stripes[i].dev = map->stripes[stripe_index].dev;
 		stripe_index++;
 	}
 	if (multi_ret) {
@@ -3104,7 +3043,7 @@ int btrfs_map_block(struct btrfs_mapping_tree *map_tree, int rw,
 		      struct btrfs_multi_bio **multi_ret, int mirror_num)
 {
 	return __btrfs_map_block(map_tree, rw, logical, length, multi_ret,
-				 mirror_num, NULL);
+				 mirror_num);
 }
 
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
@@ -3172,14 +3111,6 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	return 0;
 }
 
-int btrfs_unplug_page(struct btrfs_mapping_tree *map_tree,
-		      u64 logical, struct page *page)
-{
-	u64 length = PAGE_CACHE_SIZE;
-	return __btrfs_map_block(map_tree, READ, logical, &length,
-				 NULL, 0, page);
-}
-
 static void end_bio_multi_stripe(struct bio *bio, int err)
 {
 	struct btrfs_multi_bio *multi = bio->bi_private;
diff --git a/fs/buffer.c b/fs/buffer.c
index 2219a76..f903f2e 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -54,23 +54,15 @@ init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 }
 EXPORT_SYMBOL(init_buffer);
 
-static int sync_buffer(void *word)
+static int sleep_on_buffer(void *word)
 {
-	struct block_device *bd;
-	struct buffer_head *bh
-		= container_of(word, struct buffer_head, b_state);
-
-	smp_mb();
-	bd = bh->b_bdev;
-	if (bd)
-		blk_run_address_space(bd->bd_inode->i_mapping);
 	io_schedule();
 	return 0;
 }
 
 void __lock_buffer(struct buffer_head *bh)
 {
-	wait_on_bit_lock(&bh->b_state, BH_Lock, sync_buffer,
+	wait_on_bit_lock(&bh->b_state, BH_Lock, sleep_on_buffer,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__lock_buffer);
@@ -90,7 +82,7 @@ EXPORT_SYMBOL(unlock_buffer);
  */
 void __wait_on_buffer(struct buffer_head * bh)
 {
-	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&bh->b_state, BH_Lock, sleep_on_buffer, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__wait_on_buffer);
 
@@ -749,7 +741,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct list_head tmp;
-	struct address_space *mapping, *prev_mapping = NULL;
+	struct address_space *mapping;
 	int err = 0, err2;
 
 	INIT_LIST_HEAD(&tmp);
@@ -783,10 +775,6 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 				 * wait_on_buffer() will do that for us
 				 * through sync_buffer().
 				 */
-				if (prev_mapping && prev_mapping != mapping)
-					blk_run_address_space(prev_mapping);
-				prev_mapping = mapping;
-
 				brelse(bh);
 				spin_lock(lock);
 			}
@@ -3138,17 +3126,6 @@ out:
 }
 EXPORT_SYMBOL(try_to_free_buffers);
 
-void block_sync_page(struct page *page)
-{
-	struct address_space *mapping;
-
-	smp_mb();
-	mapping = page_mapping(page);
-	if (mapping)
-		blk_run_backing_dev(mapping->backing_dev_info, page);
-}
-EXPORT_SYMBOL(block_sync_page);
-
 /*
  * There are no bdflush tunables left.  But distributions are
  * still running obsolete flush daemons, so we terminate them here.
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d843631..b6431b0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1551,34 +1551,6 @@ int cifs_fsync(struct file *file, int datasync)
 	return rc;
 }
 
-/* static void cifs_sync_page(struct page *page)
-{
-	struct address_space *mapping;
-	struct inode *inode;
-	unsigned long index = page->index;
-	unsigned int rpages = 0;
-	int rc = 0;
-
-	cFYI(1, "sync page %p", page);
-	mapping = page->mapping;
-	if (!mapping)
-		return 0;
-	inode = mapping->host;
-	if (!inode)
-		return; */
-
-/*	fill in rpages then
-	result = cifs_pagein_inode(inode, index, rpages); */ /* BB finish */
-
-/*	cFYI(1, "rpages is %d for sync page of Index %ld", rpages, index);
-
-#if 0
-	if (rc < 0)
-		return rc;
-	return 0;
-#endif
-} */
-
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
@@ -2232,7 +2204,6 @@ const struct address_space_operations cifs_addr_ops = {
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	.releasepage = cifs_release_page,
 	.invalidatepage = cifs_invalidate_page,
-	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
 
@@ -2250,6 +2221,5 @@ const struct address_space_operations cifs_addr_ops_smallbuf = {
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	.releasepage = cifs_release_page,
 	.invalidatepage = cifs_invalidate_page,
-	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
 };
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6..0a9b085 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1106,11 +1106,8 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	    ((rw & READ) || (dio->result == dio->size)))
 		ret = -EIOCBQUEUED;
 
-	if (ret != -EIOCBQUEUED) {
-		/* All IO is now issued, send it on its way */
-		blk_run_address_space(inode->i_mapping);
+	if (ret != -EIOCBQUEUED)
 		dio_await_completion(dio);
-	}
 
 	/*
 	 * Sync will always be dropping the final ref and completing the
diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index a8e7797..9c13412 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -23,7 +23,6 @@ static sector_t _efs_bmap(struct address_space *mapping, sector_t block)
 }
 static const struct address_space_operations efs_aops = {
 	.readpage = efs_readpage,
-	.sync_page = block_sync_page,
 	.bmap = _efs_bmap
 };
 
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 4268542..bd56fed 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -795,7 +795,6 @@ const struct address_space_operations exofs_aops = {
 	.direct_IO	= NULL, /* TODO: Should be trivial to do */
 
 	/* With these NULL has special meaning or default is not exported */
-	.sync_page	= NULL,
 	.get_xip_mem	= NULL,
 	.migratepage	= NULL,
 	.launder_page	= NULL,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 40ad210..c47f706 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -860,7 +860,6 @@ const struct address_space_operations ext2_aops = {
 	.readpage		= ext2_readpage,
 	.readpages		= ext2_readpages,
 	.writepage		= ext2_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext2_write_begin,
 	.write_end		= ext2_write_end,
 	.bmap			= ext2_bmap,
@@ -880,7 +879,6 @@ const struct address_space_operations ext2_nobh_aops = {
 	.readpage		= ext2_readpage,
 	.readpages		= ext2_readpages,
 	.writepage		= ext2_nobh_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext2_nobh_write_begin,
 	.write_end		= nobh_write_end,
 	.bmap			= ext2_bmap,
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ae94f6d..fe2541d 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1894,7 +1894,6 @@ static const struct address_space_operations ext3_ordered_aops = {
 	.readpage		= ext3_readpage,
 	.readpages		= ext3_readpages,
 	.writepage		= ext3_ordered_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext3_write_begin,
 	.write_end		= ext3_ordered_write_end,
 	.bmap			= ext3_bmap,
@@ -1910,7 +1909,6 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.readpage		= ext3_readpage,
 	.readpages		= ext3_readpages,
 	.writepage		= ext3_writeback_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext3_write_begin,
 	.write_end		= ext3_writeback_write_end,
 	.bmap			= ext3_bmap,
@@ -1926,7 +1924,6 @@ static const struct address_space_operations ext3_journalled_aops = {
 	.readpage		= ext3_readpage,
 	.readpages		= ext3_readpages,
 	.writepage		= ext3_journalled_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext3_write_begin,
 	.write_end		= ext3_journalled_write_end,
 	.set_page_dirty		= ext3_journalled_set_page_dirty,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..9297ad4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3903,7 +3903,6 @@ static const struct address_space_operations ext4_ordered_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
 	.writepage		= ext4_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_ordered_write_end,
 	.bmap			= ext4_bmap,
@@ -3919,7 +3918,6 @@ static const struct address_space_operations ext4_writeback_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
 	.writepage		= ext4_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_writeback_write_end,
 	.bmap			= ext4_bmap,
@@ -3935,7 +3933,6 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
 	.writepage		= ext4_writepage,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_journalled_write_end,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
@@ -3951,7 +3948,6 @@ static const struct address_space_operations ext4_da_aops = {
 	.readpages		= ext4_readpages,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_da_writepages,
-	.sync_page		= block_sync_page,
 	.write_begin		= ext4_da_write_begin,
 	.write_end		= ext4_da_write_end,
 	.bmap			= ext4_bmap,
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 86753fe..f4ff09f 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -236,7 +236,6 @@ static const struct address_space_operations fat_aops = {
 	.readpages	= fat_readpages,
 	.writepage	= fat_writepage,
 	.writepages	= fat_writepages,
-	.sync_page	= block_sync_page,
 	.write_begin	= fat_write_begin,
 	.write_end	= fat_write_end,
 	.direct_IO	= fat_direct_IO,
diff --git a/fs/freevxfs/vxfs_subr.c b/fs/freevxfs/vxfs_subr.c
index 1429f3ae..5d318c4 100644
--- a/fs/freevxfs/vxfs_subr.c
+++ b/fs/freevxfs/vxfs_subr.c
@@ -44,7 +44,6 @@ static sector_t		vxfs_bmap(struct address_space *, sector_t);
 const struct address_space_operations vxfs_aops = {
 	.readpage =		vxfs_readpage,
 	.bmap =			vxfs_bmap,
-	.sync_page =		block_sync_page,
 };
 
 inline void
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 9e3f68c..09e8d51 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -868,7 +868,6 @@ static int fuse_bdi_init(struct fuse_conn *fc, struct super_block *sb)
 
 	fc->bdi.name = "fuse";
 	fc->bdi.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
-	fc->bdi.unplug_io_fn = default_unplug_io_fn;
 	/* fuse does it's own writeback accounting */
 	fc->bdi.capabilities = BDI_CAP_NO_ACCT_WB;
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4f36f88..2f87ad2 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1116,7 +1116,6 @@ static const struct address_space_operations gfs2_writeback_aops = {
 	.writepages = gfs2_writeback_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
-	.sync_page = block_sync_page,
 	.write_begin = gfs2_write_begin,
 	.write_end = gfs2_write_end,
 	.bmap = gfs2_bmap,
@@ -1132,7 +1131,6 @@ static const struct address_space_operations gfs2_ordered_aops = {
 	.writepage = gfs2_ordered_writepage,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
-	.sync_page = block_sync_page,
 	.write_begin = gfs2_write_begin,
 	.write_end = gfs2_write_end,
 	.set_page_dirty = gfs2_set_page_dirty,
@@ -1150,7 +1148,6 @@ static const struct address_space_operations gfs2_jdata_aops = {
 	.writepages = gfs2_jdata_writepages,
 	.readpage = gfs2_readpage,
 	.readpages = gfs2_readpages,
-	.sync_page = block_sync_page,
 	.write_begin = gfs2_write_begin,
 	.write_end = gfs2_write_end,
 	.set_page_dirty = gfs2_set_page_dirty,
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 939739c..a566331 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -94,7 +94,6 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 const struct address_space_operations gfs2_meta_aops = {
 	.writepage = gfs2_aspace_writepage,
 	.releasepage = gfs2_releasepage,
-	.sync_page = block_sync_page,
 };
 
 /**
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index dffb4e9..fff16c9 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -150,7 +150,6 @@ static int hfs_writepages(struct address_space *mapping,
 const struct address_space_operations hfs_btree_aops = {
 	.readpage	= hfs_readpage,
 	.writepage	= hfs_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= hfs_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= hfs_bmap,
@@ -160,7 +159,6 @@ const struct address_space_operations hfs_btree_aops = {
 const struct address_space_operations hfs_aops = {
 	.readpage	= hfs_readpage,
 	.writepage	= hfs_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= hfs_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= hfs_bmap,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index a8df651..b248a6c 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -146,7 +146,6 @@ static int hfsplus_writepages(struct address_space *mapping,
 const struct address_space_operations hfsplus_btree_aops = {
 	.readpage	= hfsplus_readpage,
 	.writepage	= hfsplus_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= hfsplus_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= hfsplus_bmap,
@@ -156,7 +155,6 @@ const struct address_space_operations hfsplus_btree_aops = {
 const struct address_space_operations hfsplus_aops = {
 	.readpage	= hfsplus_readpage,
 	.writepage	= hfsplus_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= hfsplus_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= hfsplus_bmap,
diff --git a/fs/hpfs/file.c b/fs/hpfs/file.c
index c034088..9e84257 100644
--- a/fs/hpfs/file.c
+++ b/fs/hpfs/file.c
@@ -120,7 +120,6 @@ static sector_t _hpfs_bmap(struct address_space *mapping, sector_t block)
 const struct address_space_operations hpfs_aops = {
 	.readpage = hpfs_readpage,
 	.writepage = hpfs_writepage,
-	.sync_page = block_sync_page,
 	.write_begin = hpfs_write_begin,
 	.write_end = generic_write_end,
 	.bmap = _hpfs_bmap
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index a0f3833..3db5ba4 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1158,7 +1158,6 @@ static sector_t _isofs_bmap(struct address_space *mapping, sector_t block)
 
 static const struct address_space_operations isofs_aops = {
 	.readpage = isofs_readpage,
-	.sync_page = block_sync_page,
 	.bmap = _isofs_bmap
 };
 
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 9978803..eddbb37 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -352,7 +352,6 @@ const struct address_space_operations jfs_aops = {
 	.readpages	= jfs_readpages,
 	.writepage	= jfs_writepage,
 	.writepages	= jfs_writepages,
-	.sync_page	= block_sync_page,
 	.write_begin	= jfs_write_begin,
 	.write_end	= nobh_write_end,
 	.bmap		= jfs_bmap,
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 48b44bd..6740d34 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -583,7 +583,6 @@ static void metapage_invalidatepage(struct page *page, unsigned long offset)
 const struct address_space_operations jfs_metapage_aops = {
 	.readpage	= metapage_readpage,
 	.writepage	= metapage_writepage,
-	.sync_page	= block_sync_page,
 	.releasepage	= metapage_releasepage,
 	.invalidatepage	= metapage_invalidatepage,
 	.set_page_dirty	= __set_page_dirty_nobuffers,
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 723bc5b..1adc8d4 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -39,7 +39,6 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio.bi_end_io = request_complete;
 
 	submit_bio(rw, &bio);
-	generic_unplug_device(bdev_get_queue(bdev));
 	wait_for_completion(&complete);
 	return test_bit(BIO_UPTODATE, &bio.bi_flags) ? 0 : -EIO;
 }
@@ -168,7 +167,6 @@ static void bdev_writeseg(struct super_block *sb, u64 ofs, size_t len)
 	}
 	len = PAGE_ALIGN(len);
 	__bdev_writeseg(sb, ofs, ofs >> PAGE_SHIFT, len >> PAGE_SHIFT);
-	generic_unplug_device(bdev_get_queue(logfs_super(sb)->s_bdev));
 }
 
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index ae0b83f..adcdc0a 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -399,7 +399,6 @@ static sector_t minix_bmap(struct address_space *mapping, sector_t block)
 static const struct address_space_operations minix_aops = {
 	.readpage = minix_readpage,
 	.writepage = minix_writepage,
-	.sync_page = block_sync_page,
 	.write_begin = minix_write_begin,
 	.write_end = generic_write_end,
 	.bmap = minix_bmap
diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 388e9e8..f4f1c08 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -40,14 +40,10 @@ void nilfs_btnode_cache_init_once(struct address_space *btnc)
 	nilfs_mapping_init_once(btnc);
 }
 
-static const struct address_space_operations def_btnode_aops = {
-	.sync_page		= block_sync_page,
-};
-
 void nilfs_btnode_cache_init(struct address_space *btnc,
 			     struct backing_dev_info *bdi)
 {
-	nilfs_mapping_init(btnc, bdi, &def_btnode_aops);
+	nilfs_mapping_init(btnc, bdi);
 }
 
 void nilfs_btnode_cache_clear(struct address_space *btnc)
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index caf9a6a..1c2a3e2 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -49,7 +49,6 @@
 #include "ifile.h"
 
 static const struct address_space_operations def_gcinode_aops = {
-	.sync_page		= block_sync_page,
 };
 
 /*
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2fd440d..c89d5d1 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -262,7 +262,6 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 const struct address_space_operations nilfs_aops = {
 	.writepage		= nilfs_writepage,
 	.readpage		= nilfs_readpage,
-	.sync_page		= block_sync_page,
 	.writepages		= nilfs_writepages,
 	.set_page_dirty		= nilfs_set_page_dirty,
 	.readpages		= nilfs_readpages,
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 6a0e2a1..3fdb61d 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -399,7 +399,6 @@ nilfs_mdt_write_page(struct page *page, struct writeback_control *wbc)
 
 static const struct address_space_operations def_mdt_aops = {
 	.writepage		= nilfs_mdt_write_page,
-	.sync_page		= block_sync_page,
 };
 
 static const struct inode_operations def_mdt_iops;
@@ -438,10 +437,6 @@ void nilfs_mdt_set_entry_size(struct inode *inode, unsigned entry_size,
 	mi->mi_first_entry_offset = DIV_ROUND_UP(header_size, entry_size);
 }
 
-static const struct address_space_operations shadow_map_aops = {
-	.sync_page		= block_sync_page,
-};
-
 /**
  * nilfs_mdt_setup_shadow_map - setup shadow map and bind it to metadata file
  * @inode: inode of the metadata file
@@ -455,9 +450,9 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
 	nilfs_mapping_init_once(&shadow->frozen_data);
-	nilfs_mapping_init(&shadow->frozen_data, bdi, &shadow_map_aops);
+	nilfs_mapping_init(&shadow->frozen_data, bdi);
 	nilfs_mapping_init_once(&shadow->frozen_btnodes);
-	nilfs_mapping_init(&shadow->frozen_btnodes, bdi, &shadow_map_aops);
+	nilfs_mapping_init(&shadow->frozen_btnodes, bdi);
 	mi->mi_shadow = shadow;
 	return 0;
 }
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 0c43241..c0d4381 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -505,16 +505,18 @@ void nilfs_mapping_init_once(struct address_space *mapping)
 	INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
 }
 
+static const struct address_space_operations def_btnode_aops = {
+};
+
 void nilfs_mapping_init(struct address_space *mapping,
-			struct backing_dev_info *bdi,
-			const struct address_space_operations *aops)
+			struct backing_dev_info *bdi)
 {
 	mapping->host = NULL;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	mapping->assoc_mapping = NULL;
 	mapping->backing_dev_info = bdi;
-	mapping->a_ops = aops;
+	mapping->a_ops = &def_btnode_aops;
 }
 
 /*
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 622df27..ba4d6fd 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -63,8 +63,7 @@ void nilfs_copy_back_pages(struct address_space *, struct address_space *);
 void nilfs_clear_dirty_pages(struct address_space *);
 void nilfs_mapping_init_once(struct address_space *mapping);
 void nilfs_mapping_init(struct address_space *mapping,
-			struct backing_dev_info *bdi,
-			const struct address_space_operations *aops);
+			struct backing_dev_info *bdi);
 unsigned nilfs_page_count_clean_buffers(struct page *, unsigned, unsigned);
 unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index c3c2c7a..0b1e885b 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -1543,8 +1543,6 @@ err_out:
  */
 const struct address_space_operations ntfs_aops = {
 	.readpage	= ntfs_readpage,	/* Fill page with data. */
-	.sync_page	= block_sync_page,	/* Currently, just unplugs the
-						   disk request queue. */
 #ifdef NTFS_RW
 	.writepage	= ntfs_writepage,	/* Write dirty page to disk. */
 #endif /* NTFS_RW */
@@ -1560,8 +1558,6 @@ const struct address_space_operations ntfs_aops = {
  */
 const struct address_space_operations ntfs_mst_aops = {
 	.readpage	= ntfs_readpage,	/* Fill page with data. */
-	.sync_page	= block_sync_page,	/* Currently, just unplugs the
-						   disk request queue. */
 #ifdef NTFS_RW
 	.writepage	= ntfs_writepage,	/* Write dirty page to disk. */
 	.set_page_dirty	= __set_page_dirty_nobuffers,	/* Set the page dirty
diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 6551c7c..ef9ed85 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -698,8 +698,7 @@ lock_retry_remap:
 					"uptodate! Unplugging the disk queue "
 					"and rescheduling.");
 			get_bh(tbh);
-			blk_run_address_space(mapping);
-			schedule();
+			io_schedule();
 			put_bh(tbh);
 			if (unlikely(!buffer_uptodate(tbh)))
 				goto read_err;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 1fbb0e2..daea035 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2043,7 +2043,6 @@ const struct address_space_operations ocfs2_aops = {
 	.write_begin		= ocfs2_write_begin,
 	.write_end		= ocfs2_write_end,
 	.bmap			= ocfs2_bmap,
-	.sync_page		= block_sync_page,
 	.direct_IO		= ocfs2_direct_IO,
 	.invalidatepage		= ocfs2_invalidatepage,
 	.releasepage		= ocfs2_releasepage,
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index b108e86..1adab28 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -367,11 +367,7 @@ static inline void o2hb_bio_wait_dec(struct o2hb_bio_wait_ctxt *wc,
 static void o2hb_wait_on_io(struct o2hb_region *reg,
 			    struct o2hb_bio_wait_ctxt *wc)
 {
-	struct address_space *mapping = reg->hr_bdev->bd_inode->i_mapping;
-
-	blk_run_address_space(mapping);
 	o2hb_bio_wait_dec(wc, 1);
-
 	wait_for_completion(&wc->wc_io_complete);
 }
 
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 8a6d34f..d738a7e 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -372,7 +372,6 @@ const struct address_space_operations omfs_aops = {
 	.readpages = omfs_readpages,
 	.writepage = omfs_writepage,
 	.writepages = omfs_writepages,
-	.sync_page = block_sync_page,
 	.write_begin = omfs_write_begin,
 	.write_end = generic_write_end,
 	.bmap = omfs_bmap,
diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index e63b417..2b06466 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -335,7 +335,6 @@ static sector_t qnx4_bmap(struct address_space *mapping, sector_t block)
 static const struct address_space_operations qnx4_aops = {
 	.readpage	= qnx4_readpage,
 	.writepage	= qnx4_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin	= qnx4_write_begin,
 	.write_end	= generic_write_end,
 	.bmap		= qnx4_bmap
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 0bae036..0367467 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3212,7 +3212,6 @@ const struct address_space_operations reiserfs_address_space_operations = {
 	.readpages = reiserfs_readpages,
 	.releasepage = reiserfs_releasepage,
 	.invalidatepage = reiserfs_invalidatepage,
-	.sync_page = block_sync_page,
 	.write_begin = reiserfs_write_begin,
 	.write_end = reiserfs_write_end,
 	.bmap = reiserfs_aop_bmap,
diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 9ca6627..fa8d43c 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -488,7 +488,6 @@ static sector_t sysv_bmap(struct address_space *mapping, sector_t block)
 const struct address_space_operations sysv_aops = {
 	.readpage = sysv_readpage,
 	.writepage = sysv_writepage,
-	.sync_page = block_sync_page,
 	.write_begin = sysv_write_begin,
 	.write_end = generic_write_end,
 	.bmap = sysv_bmap
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 6e11c29..81368d4 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1979,7 +1979,6 @@ static int ubifs_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	c->bdi.name = "ubifs",
 	c->bdi.capabilities = BDI_CAP_MAP_COPY;
-	c->bdi.unplug_io_fn = default_unplug_io_fn;
 	err  = bdi_init(&c->bdi);
 	if (err)
 		goto out_close;
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 89c7848..94e4553 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -98,7 +98,6 @@ static int udf_adinicb_write_end(struct file *file,
 const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin = simple_write_begin,
 	.write_end = udf_adinicb_write_end,
 };
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index c6a2e78..fa96fc0 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -133,7 +133,6 @@ static sector_t udf_bmap(struct address_space *mapping, sector_t block)
 const struct address_space_operations udf_aops = {
 	.readpage	= udf_readpage,
 	.writepage	= udf_writepage,
-	.sync_page	= block_sync_page,
 	.write_begin		= udf_write_begin,
 	.write_end		= generic_write_end,
 	.bmap		= udf_bmap,
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 2b251f2..83b2844 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -588,7 +588,6 @@ static sector_t ufs_bmap(struct address_space *mapping, sector_t block)
 const struct address_space_operations ufs_aops = {
 	.readpage = ufs_readpage,
 	.writepage = ufs_writepage,
-	.sync_page = block_sync_page,
 	.write_begin = ufs_write_begin,
 	.write_end = generic_write_end,
 	.bmap = ufs_bmap
diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index a58f915..ff0e792 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -481,7 +481,7 @@ int ufs_truncate(struct inode *inode, loff_t old_i_size)
 			break;
 		if (IS_SYNC(inode) && (inode->i_state & I_DIRTY))
 			ufs_sync_inode (inode);
-		blk_run_address_space(inode->i_mapping);
+		blk_flush_plug(current);
 		yield();
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index ec7bbb5..83c1c20 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1495,7 +1495,6 @@ const struct address_space_operations xfs_address_space_operations = {
 	.readpages		= xfs_vm_readpages,
 	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
-	.sync_page		= block_sync_page,
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
 	.write_begin		= xfs_vm_write_begin,
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index ac1c7e8..4f8f53c 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -991,7 +991,7 @@ xfs_buf_lock(
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_target->bt_mount, 0);
 	if (atomic_read(&bp->b_io_remaining))
-		blk_run_address_space(bp->b_target->bt_mapping);
+		blk_flush_plug(current);
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
 
@@ -1035,9 +1035,7 @@ xfs_buf_wait_unpin(
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (atomic_read(&bp->b_pin_count) == 0)
 			break;
-		if (atomic_read(&bp->b_io_remaining))
-			blk_run_address_space(bp->b_target->bt_mapping);
-		schedule();
+		io_schedule();
 	}
 	remove_wait_queue(&bp->b_waiters, &wait);
 	set_current_state(TASK_RUNNING);
@@ -1443,7 +1441,7 @@ xfs_buf_iowait(
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
 	if (atomic_read(&bp->b_io_remaining))
-		blk_run_address_space(bp->b_target->bt_mapping);
+		blk_flush_plug(current);
 	wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
@@ -1667,7 +1665,6 @@ xfs_mapping_buftarg(
 	struct inode		*inode;
 	struct address_space	*mapping;
 	static const struct address_space_operations mapping_aops = {
-		.sync_page = block_sync_page,
 		.migratepage = fail_migrate_page,
 	};
 
@@ -1948,7 +1945,7 @@ xfsbufd(
 			count++;
 		}
 		if (count)
-			blk_run_address_space(target->bt_mapping);
+			blk_flush_plug(current);
 
 	} while (!kthread_should_stop());
 
@@ -1996,7 +1993,7 @@ xfs_flush_buftarg(
 
 	if (wait) {
 		/* Expedite and wait for IO to complete. */
-		blk_run_address_space(target->bt_mapping);
+		blk_flush_plug(current);
 		while (!list_empty(&wait_list)) {
 			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 4ce34fa..96f4094 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -66,8 +66,6 @@ struct backing_dev_info {
 	unsigned int capabilities; /* Device capabilities */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
 	void *congested_data;	/* Pointer to aux data for congested func */
-	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
-	void *unplug_io_data;
 
 	char *name;
 
@@ -251,7 +249,6 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 
 extern struct backing_dev_info default_backing_dev_info;
 extern struct backing_dev_info noop_backing_dev_info;
-void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page);
 
 int writeback_in_progress(struct backing_dev_info *bdi);
 
@@ -336,17 +333,4 @@ static inline int bdi_sched_wait(void *word)
 	return 0;
 }
 
-static inline void blk_run_backing_dev(struct backing_dev_info *bdi,
-				       struct page *page)
-{
-	if (bdi && bdi->unplug_io_fn)
-		bdi->unplug_io_fn(bdi, page);
-}
-
-static inline void blk_run_address_space(struct address_space *mapping)
-{
-	if (mapping)
-		blk_run_backing_dev(mapping->backing_dev_info, NULL);
-}
-
 #endif		/* _LINUX_BACKING_DEV_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3d246a9..dfb6ffd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -190,7 +190,6 @@ typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
-typedef void (unplug_fn) (struct request_queue *);
 
 struct bio_vec;
 struct bvec_merge_data {
@@ -273,7 +272,6 @@ struct request_queue
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
 	unprep_rq_fn		*unprep_rq_fn;
-	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	softirq_done_fn		*softirq_done_fn;
 	rq_timed_out_fn		*rq_timed_out_fn;
@@ -287,14 +285,6 @@ struct request_queue
 	struct request		*boundary_rq;
 
 	/*
-	 * Auto-unplugging state
-	 */
-	struct timer_list	unplug_timer;
-	int			unplug_thresh;	/* After this many requests */
-	unsigned long		unplug_delay;	/* After this many jiffies */
-	struct work_struct	unplug_work;
-
-	/*
 	 * Delayed queue handling
 	 */
 	struct delayed_work	delay_work;
@@ -392,14 +382,13 @@ struct request_queue
 #define QUEUE_FLAG_ASYNCFULL	4	/* write queue has been filled */
 #define QUEUE_FLAG_DEAD		5	/* queue being torn down */
 #define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
-#define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
-#define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
-#define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
-#define QUEUE_FLAG_NOMERGES    10	/* disable merge attempts */
-#define QUEUE_FLAG_SAME_COMP   11	/* force complete on same CPU */
-#define QUEUE_FLAG_FAIL_IO     12	/* fake timeout */
-#define QUEUE_FLAG_STACKABLE   13	/* supports request stacking */
-#define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
+#define QUEUE_FLAG_ELVSWITCH	7	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_BIDI		8	/* queue supports bidi requests */
+#define QUEUE_FLAG_NOMERGES     9	/* disable merge attempts */
+#define QUEUE_FLAG_SAME_COMP   10	/* force complete on same CPU */
+#define QUEUE_FLAG_FAIL_IO     11	/* fake timeout */
+#define QUEUE_FLAG_STACKABLE   12	/* supports request stacking */
+#define QUEUE_FLAG_NONROT      13	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
 #define QUEUE_FLAG_IO_STAT     15	/* do IO stats */
 #define QUEUE_FLAG_DISCARD     16	/* supports DISCARD */
@@ -477,7 +466,6 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	__clear_bit(flag, &q->queue_flags);
 }
 
-#define blk_queue_plugged(q)	test_bit(QUEUE_FLAG_PLUGGED, &(q)->queue_flags)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
@@ -672,9 +660,6 @@ extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 extern void blk_rq_unprep_clone(struct request *rq);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
-extern void blk_plug_device(struct request_queue *);
-extern void blk_plug_device_unlocked(struct request_queue *);
-extern int blk_remove_plug(struct request_queue *);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
@@ -719,7 +704,6 @@ extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
-extern void blk_unplug(struct request_queue *q);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
@@ -856,7 +840,6 @@ extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bd
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
-extern void generic_unplug_device(struct request_queue *);
 extern long nr_blockdev_pages(void);
 
 int blk_get_queue(struct request_queue *);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 68d1fe7..f5df235 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -219,7 +219,6 @@ int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
-void block_sync_page(struct page *);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int nobh_write_begin(struct address_space *, loff_t, unsigned, unsigned,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 272496d..e276883 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -286,11 +286,6 @@ void dm_table_add_target_callbacks(struct dm_table *t, struct dm_target_callback
 int dm_table_complete(struct dm_table *t);
 
 /*
- * Unplug all devices in a table.
- */
-void dm_table_unplug_all(struct dm_table *t);
-
-/*
  * Table reference counting.
  */
 struct dm_table *dm_get_live_table(struct mapped_device *md);
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index ac2b7a0..82a563c 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -20,7 +20,6 @@ typedef void (elevator_bio_merged_fn) (struct request_queue *,
 typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
-typedef int (elevator_queue_empty_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
@@ -46,7 +45,6 @@ struct elevator_ops
 	elevator_activate_req_fn *elevator_activate_req_fn;
 	elevator_deactivate_req_fn *elevator_deactivate_req_fn;
 
-	elevator_queue_empty_fn *elevator_queue_empty_fn;
 	elevator_completed_req_fn *elevator_completed_req_fn;
 
 	elevator_request_list_fn *elevator_former_req_fn;
@@ -101,8 +99,8 @@ struct elevator_queue
  */
 extern void elv_dispatch_sort(struct request_queue *, struct request *);
 extern void elv_dispatch_add_tail(struct request_queue *, struct request *);
-extern void elv_add_request(struct request_queue *, struct request *, int, int);
-extern void __elv_add_request(struct request_queue *, struct request *, int, int);
+extern void elv_add_request(struct request_queue *, struct request *, int);
+extern void __elv_add_request(struct request_queue *, struct request *, int);
 extern void elv_insert(struct request_queue *, struct request *, int);
 extern int elv_merge(struct request_queue *, struct request **, struct bio *);
 extern int elv_try_merge(struct request *, struct bio *);
@@ -112,7 +110,6 @@ extern void elv_merged_request(struct request_queue *, struct request *, int);
 extern void elv_bio_merged(struct request_queue *q, struct request *,
 				struct bio *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
-extern int elv_queue_empty(struct request_queue *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 32b38cd..c53311c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -583,7 +583,6 @@ typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
-	void (*sync_page)(struct page *);
 
 	/* Write back some dirty pages from this mapping. */
 	int (*writepages)(struct address_space *, struct writeback_control *);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9c66e99..e112b8d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -298,7 +298,6 @@ static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 
 extern void __lock_page(struct page *page);
 extern int __lock_page_killable(struct page *page);
-extern void __lock_page_nosync(struct page *page);
 extern int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 				unsigned int flags);
 extern void unlock_page(struct page *page);
@@ -342,17 +341,6 @@ static inline int lock_page_killable(struct page *page)
 }
 
 /*
- * lock_page_nosync should only be used if we can't pin the page's inode.
- * Doesn't play quite so well with block device plugging.
- */
-static inline void lock_page_nosync(struct page *page)
-{
-	might_sleep();
-	if (!trylock_page(page))
-		__lock_page_nosync(page);
-}
-	
-/*
  * lock_page_or_retry - Lock the page, unless this would block and the
  * caller indicated that it can handle a retry.
  */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4d55932..9ee3218 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -299,8 +299,6 @@ extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
 					struct page **pagep, swp_entry_t *ent);
 #endif
 
-extern void swap_unplug_io_fn(struct backing_dev_info *, struct page *);
-
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 027100d..c91e139 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -14,17 +14,11 @@
 
 static atomic_long_t bdi_seq = ATOMIC_LONG_INIT(0);
 
-void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
-{
-}
-EXPORT_SYMBOL(default_unplug_io_fn);
-
 struct backing_dev_info default_backing_dev_info = {
 	.name		= "default",
 	.ra_pages	= VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
 	.state		= 0,
 	.capabilities	= BDI_CAP_MAP_COPY,
-	.unplug_io_fn	= default_unplug_io_fn,
 };
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 83a45d3..380776c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -155,45 +155,15 @@ void remove_from_page_cache(struct page *page)
 }
 EXPORT_SYMBOL(remove_from_page_cache);
 
-static int sync_page(void *word)
+static int sleep_on_page(void *word)
 {
-	struct address_space *mapping;
-	struct page *page;
-
-	page = container_of((unsigned long *)word, struct page, flags);
-
-	/*
-	 * page_mapping() is being called without PG_locked held.
-	 * Some knowledge of the state and use of the page is used to
-	 * reduce the requirements down to a memory barrier.
-	 * The danger here is of a stale page_mapping() return value
-	 * indicating a struct address_space different from the one it's
-	 * associated with when it is associated with one.
-	 * After smp_mb(), it's either the correct page_mapping() for
-	 * the page, or an old page_mapping() and the page's own
-	 * page_mapping() has gone NULL.
-	 * The ->sync_page() address_space operation must tolerate
-	 * page_mapping() going NULL. By an amazing coincidence,
-	 * this comes about because none of the users of the page
-	 * in the ->sync_page() methods make essential use of the
-	 * page_mapping(), merely passing the page down to the backing
-	 * device's unplug functions when it's non-NULL, which in turn
-	 * ignore it for all cases but swap, where only page_private(page) is
-	 * of interest. When page_mapping() does go NULL, the entire
-	 * call stack gracefully ignores the page and returns.
-	 * -- wli
-	 */
-	smp_mb();
-	mapping = page_mapping(page);
-	if (mapping && mapping->a_ops && mapping->a_ops->sync_page)
-		mapping->a_ops->sync_page(page);
 	io_schedule();
 	return 0;
 }
 
-static int sync_page_killable(void *word)
+static int sleep_on_page_killable(void *word)
 {
-	sync_page(word);
+	sleep_on_page(word);
 	return fatal_signal_pending(current) ? -EINTR : 0;
 }
 
@@ -479,12 +449,6 @@ struct page *__page_cache_alloc(gfp_t gfp)
 EXPORT_SYMBOL(__page_cache_alloc);
 #endif
 
-static int __sleep_on_page_lock(void *word)
-{
-	io_schedule();
-	return 0;
-}
-
 /*
  * In order to wait for pages to become available there must be
  * waitqueues associated with pages. By using a hash table of
@@ -512,7 +476,7 @@ void wait_on_page_bit(struct page *page, int bit_nr)
 	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
 
 	if (test_bit(bit_nr, &page->flags))
-		__wait_on_bit(page_waitqueue(page), &wait, sync_page,
+		__wait_on_bit(page_waitqueue(page), &wait, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(wait_on_page_bit);
@@ -576,17 +540,12 @@ EXPORT_SYMBOL(end_page_writeback);
 /**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
  * @page: the page to lock
- *
- * Ugly. Running sync_page() in state TASK_UNINTERRUPTIBLE is scary.  If some
- * random driver's requestfn sets TASK_RUNNING, we could busywait.  However
- * chances are that on the second loop, the block layer's plug list is empty,
- * so sync_page() will then return in state TASK_UNINTERRUPTIBLE.
  */
 void __lock_page(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
-	__wait_on_bit_lock(page_waitqueue(page), &wait, sync_page,
+	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__lock_page);
@@ -596,24 +555,10 @@ int __lock_page_killable(struct page *page)
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
-					sync_page_killable, TASK_KILLABLE);
+					sleep_on_page_killable, TASK_KILLABLE);
 }
 EXPORT_SYMBOL_GPL(__lock_page_killable);
 
-/**
- * __lock_page_nosync - get a lock on the page, without calling sync_page()
- * @page: the page to lock
- *
- * Variant of lock_page that does not require the caller to hold a reference
- * on the page's mapping.
- */
-void __lock_page_nosync(struct page *page)
-{
-	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
-	__wait_on_bit_lock(page_waitqueue(page), &wait, __sleep_on_page_lock,
-							TASK_UNINTERRUPTIBLE);
-}
-
 int __lock_page_or_retry(struct page *page, struct mm_struct *mm,
 			 unsigned int flags)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 548fbd7..9566685 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -995,7 +995,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 			 * Check "just unpoisoned", "filter hit", and
 			 * "race with other subpage."
 			 */
-			lock_page_nosync(hpage);
+			lock_page(hpage);
 			if (!PageHWPoison(hpage)
 			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
 			    || (p != hpage && TestSetPageHWPoison(hpage))) {
@@ -1042,7 +1042,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
 	 */
-	lock_page_nosync(hpage);
+	lock_page(hpage);
 
 	/*
 	 * unpoison always clear PG_hwpoison inside page lock
@@ -1185,7 +1185,7 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
-	lock_page_nosync(page);
+	lock_page(page);
 	/*
 	 * This test is racy because PG_hwpoison is set outside of page lock.
 	 * That's acceptable because that won't trigger kernel panic. Instead,
diff --git a/mm/nommu.c b/mm/nommu.c
index f59e142..fb6cbd6 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1842,10 +1842,6 @@ int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
-void swap_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
-{
-}
-
 unsigned long arch_get_unmapped_area(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long pgoff, unsigned long flags)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2cb01f6..cc0ede1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1239,7 +1239,7 @@ int set_page_dirty_lock(struct page *page)
 {
 	int ret;
 
-	lock_page_nosync(page);
+	lock_page(page);
 	ret = set_page_dirty(page);
 	unlock_page(page);
 	return ret;
diff --git a/mm/readahead.c b/mm/readahead.c
index 77506a2..cbddc3e 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -554,17 +554,5 @@ page_cache_async_readahead(struct address_space *mapping,
 
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
-
-#ifdef CONFIG_BLOCK
-	/*
-	 * Normally the current page is !uptodate and lock_page() will be
-	 * immediately called to implicitly unplug the device. However this
-	 * is not always true for RAID conifgurations, where data arrives
-	 * not strictly in their submission order. In this case we need to
-	 * explicitly kick off the IO.
-	 */
-	if (PageUptodate(page))
-		blk_run_backing_dev(mapping->backing_dev_info, NULL);
-#endif
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
diff --git a/mm/shmem.c b/mm/shmem.c
index 5ee67c9..24d23f5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -224,7 +224,6 @@ static const struct vm_operations_struct shmem_vm_ops;
 static struct backing_dev_info shmem_backing_dev_info  __read_mostly = {
 	.ra_pages	= 0,	/* No readahead */
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
-	.unplug_io_fn	= default_unplug_io_fn,
 };
 
 static LIST_HEAD(shmem_swaplist);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5c8cfab..4668046 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -24,12 +24,10 @@
 
 /*
  * swapper_space is a fiction, retained to simplify the path through
- * vmscan's shrink_page_list, to make sync_page look nicer, and to allow
- * future use of radix_tree tags in the swap cache.
+ * vmscan's shrink_page_list.
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
-	.sync_page	= block_sync_page,
 	.set_page_dirty	= __set_page_dirty_nobuffers,
 	.migratepage	= migrate_page,
 };
@@ -37,7 +35,6 @@ static const struct address_space_operations swap_aops = {
 static struct backing_dev_info swap_backing_dev_info = {
 	.name		= "swap",
 	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK | BDI_CAP_SWAP_BACKED,
-	.unplug_io_fn	= swap_unplug_io_fn,
 };
 
 struct address_space swapper_space = {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 07a458d..7ceea78 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -95,39 +95,6 @@ __try_to_reclaim_swap(struct swap_info_struct *si, unsigned long offset)
 }
 
 /*
- * We need this because the bdev->unplug_fn can sleep and we cannot
- * hold swap_lock while calling the unplug_fn. And swap_lock
- * cannot be turned into a mutex.
- */
-static DECLARE_RWSEM(swap_unplug_sem);
-
-void swap_unplug_io_fn(struct backing_dev_info *unused_bdi, struct page *page)
-{
-	swp_entry_t entry;
-
-	down_read(&swap_unplug_sem);
-	entry.val = page_private(page);
-	if (PageSwapCache(page)) {
-		struct block_device *bdev = swap_info[swp_type(entry)]->bdev;
-		struct backing_dev_info *bdi;
-
-		/*
-		 * If the page is removed from swapcache from under us (with a
-		 * racy try_to_unuse/swapoff) we need an additional reference
-		 * count to avoid reading garbage from page_private(page) above.
-		 * If the WARN_ON triggers during a swapoff it maybe the race
-		 * condition and it's harmless. However if it triggers without
-		 * swapoff it signals a problem.
-		 */
-		WARN_ON(page_count(page) <= 1);
-
-		bdi = bdev->bd_inode->i_mapping->backing_dev_info;
-		blk_run_backing_dev(bdi, page);
-	}
-	up_read(&swap_unplug_sem);
-}
-
-/*
  * swapon tell device that all the old swap contents can be discarded,
  * to allow the swap device to optimize its wear-levelling.
  */
@@ -1643,10 +1610,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 		goto out_dput;
 	}
 
-	/* wait for any unplug function to finish */
-	down_write(&swap_unplug_sem);
-	up_write(&swap_unplug_sem);
-
 	destroy_swap_extents(p);
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 47a5096..e204456 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -359,7 +359,7 @@ static int may_write_to_queue(struct backing_dev_info *bdi,
 static void handle_write_error(struct address_space *mapping,
 				struct page *page, int error)
 {
-	lock_page_nosync(page);
+	lock_page(page);
 	if (page_mapping(page) == mapping)
 		mapping_set_error(mapping, error);
 	unlock_page(page);
-- 
1.7.3.2.146.gca209

