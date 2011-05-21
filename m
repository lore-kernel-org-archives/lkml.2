Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1EUQcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 12:32:43 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:48260 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1EUQck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 12:32:40 -0400
From: Bart Van Assche <bvanassche@acm.org>
To: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drbd: Fix spelling
Date: Sat, 21 May 2011 18:32:29 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.6-scst; KDE/4.6.0; x86_64; ; )
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211832.29750.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found these with the help of ispell -l.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>

---
 drivers/block/drbd/drbd_actlog.c   |    2 +-
 drivers/block/drbd/drbd_bitmap.c   |    6 +++---
 drivers/block/drbd/drbd_int.h      |    6 +++---
 drivers/block/drbd/drbd_main.c     |    4 ++--
 drivers/block/drbd/drbd_nl.c       |    6 +++---
 drivers/block/drbd/drbd_receiver.c |   30 +++++++++++++++---------------
 drivers/block/drbd/drbd_req.c      |   18 +++++++++---------
 drivers/block/drbd/drbd_req.h      |    4 ++--
 drivers/block/drbd/drbd_worker.c   |    4 ++--
 include/linux/drbd.h               |    8 ++++----
 include/linux/drbd_tag_magic.h     |    2 +-
 11 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index c6828b6..09ef9a8 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -28,7 +28,7 @@
 #include "drbd_int.h"
 #include "drbd_wrappers.h"
 
-/* We maintain a trivial check sum in our on disk activity log.
+/* We maintain a trivial checksum in our on disk activity log.
  * With that we can ensure correct operation even when the storage
  * device might do a partial (last) sector write while losing power.
  */
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 76210ba..f440a02 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -74,7 +74,7 @@
  *	as we are "attached" to a local disk, which at 32 GiB for 1PiB storage
  *	seems excessive.
  *
- *	We plan to reduce the amount of in-core bitmap pages by pageing them in
+ *	We plan to reduce the amount of in-core bitmap pages by paging them in
  *	and out against their on-disk location as necessary, but need to make
  *	sure we don't cause too much meta data IO, and must not deadlock in
  *	tight memory situations. This needs some more work.
@@ -200,7 +200,7 @@ void drbd_bm_unlock(struct drbd_conf *mdev)
  * we if bits have been cleared since last IO. */
 #define BM_PAGE_LAZY_WRITEOUT	28
 
-/* store_page_idx uses non-atomic assingment. It is only used directly after
+/* store_page_idx uses non-atomic assignment. It is only used directly after
  * allocating the page.  All other bm_set_page_* and bm_clear_page_* need to
  * use atomic bit manipulation, as set_out_of_sync (and therefore bitmap
  * changes) may happen from various contexts, and wait_on_bit/wake_up_bit
@@ -318,7 +318,7 @@ static void bm_unmap(unsigned long *p_addr)
 /* word offset from start of bitmap to word number _in_page_
  * modulo longs per page
 #define MLPP(X) ((X) % (PAGE_SIZE/sizeof(long))
- hm, well, Philipp thinks gcc might not optimze the % into & (... - 1)
+ hm, well, Philipp thinks gcc might not optimize the % into & (... - 1)
  so do it explicitly:
  */
 #define MLPP(X) ((X) & ((PAGE_SIZE/sizeof(long))-1))
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b2699bb..819d6ea 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -699,7 +699,7 @@ struct drbd_request {
 	 * see drbd_endio_pri(). */
 	struct bio *private_bio;
 
-	struct hlist_node colision;
+	struct hlist_node collision;
 	sector_t sector;
 	unsigned int size;
 	unsigned int epoch; /* barrier_nr */
@@ -765,7 +765,7 @@ struct digest_info {
 
 struct drbd_epoch_entry {
 	struct drbd_work w;
-	struct hlist_node colision;
+	struct hlist_node collision;
 	struct drbd_epoch *epoch; /* for writes */
 	struct drbd_conf *mdev;
 	struct page *pages;
@@ -1517,7 +1517,7 @@ extern void drbd_resume_io(struct drbd_conf *mdev);
 extern char *ppsize(char *buf, unsigned long long size);
 extern sector_t drbd_new_dev_size(struct drbd_conf *, struct drbd_backing_dev *, int);
 enum determine_dev_size { dev_size_error = -1, unchanged = 0, shrunk = 1, grew = 2 };
-extern enum determine_dev_size drbd_determin_dev_size(struct drbd_conf *, enum dds_flags) __must_hold(local);
+extern enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *, enum dds_flags) __must_hold(local);
 extern void resync_after_online_grow(struct drbd_conf *);
 extern void drbd_setup_queue_param(struct drbd_conf *mdev, unsigned int) __must_hold(local);
 extern enum drbd_state_rv drbd_set_role(struct drbd_conf *mdev,
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 5b525c1..0ef5a31 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2722,7 +2722,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 
 		/* double check digest, sometimes buffers have been modified in flight. */
 		if (dgs > 0 && dgs <= 64) {
-			/* 64 byte, 512 bit, is the larges digest size
+			/* 64 byte, 512 bit, is the largest digest size
 			 * currently supported in kernel crypto. */
 			unsigned char digest[64];
 			drbd_csum_bio(mdev, mdev->integrity_w_tfm, req->master_bio, digest);
@@ -3275,7 +3275,7 @@ static void drbd_delete_device(unsigned int minor)
 
 	drbd_release_ee_lists(mdev);
 
-	/* should be free'd on disconnect? */
+	/* should be freed on disconnect? */
 	kfree(mdev->ee_hash);
 	/*
 	mdev->ee_hash_s = 0;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 03b29f7..0593713 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -577,7 +577,7 @@ void drbd_resume_io(struct drbd_conf *mdev)
  * Returns 0 on success, negative return values indicate errors.
  * You should call drbd_md_sync() after calling this function.
  */
-enum determine_dev_size drbd_determin_dev_size(struct drbd_conf *mdev, enum dds_flags flags) __must_hold(local)
+enum determine_dev_size drbd_determine_dev_size(struct drbd_conf *mdev, enum dds_flags flags) __must_hold(local)
 {
 	sector_t prev_first_sect, prev_size; /* previous meta location */
 	sector_t la_size;
@@ -1152,7 +1152,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	    !drbd_md_test_flag(mdev->ldev, MDF_CONNECTED_IND))
 		set_bit(USE_DEGR_WFC_T, &mdev->flags);
 
-	dd = drbd_determin_dev_size(mdev, 0);
+	dd = drbd_determine_dev_size(mdev, 0);
 	if (dd == dev_size_error) {
 		retcode = ERR_NOMEM_BITMAP;
 		goto force_diskless_dec;
@@ -1658,7 +1658,7 @@ static int drbd_nl_resize(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 
 	mdev->ldev->dc.disk_size = (sector_t)rs.resize_size;
 	ddsf = (rs.resize_force ? DDSF_FORCED : 0) | (rs.no_resync ? DDSF_NO_RESYNC : 0);
-	dd = drbd_determin_dev_size(mdev, ddsf);
+	dd = drbd_determine_dev_size(mdev, ddsf);
 	drbd_md_sync(mdev);
 	put_ldev(mdev);
 	if (dd == dev_size_error) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index fd26666..95cffad 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -333,7 +333,7 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 	if (!page)
 		goto fail;
 
-	INIT_HLIST_NODE(&e->colision);
+	INIT_HLIST_NODE(&e->collision);
 	e->epoch = NULL;
 	e->mdev = mdev;
 	e->pages = page;
@@ -356,7 +356,7 @@ void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e, int i
 		kfree(e->digest);
 	drbd_pp_free(mdev, e->pages, is_net);
 	D_ASSERT(atomic_read(&e->pending_bios) == 0);
-	D_ASSERT(hlist_unhashed(&e->colision));
+	D_ASSERT(hlist_unhashed(&e->collision));
 	mempool_free(e, drbd_ee_mempool);
 }
 
@@ -1418,7 +1418,7 @@ static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int u
 	sector_t sector = e->sector;
 	int ok;
 
-	D_ASSERT(hlist_unhashed(&e->colision));
+	D_ASSERT(hlist_unhashed(&e->collision));
 
 	if (likely((e->flags & EE_WAS_ERROR) == 0)) {
 		drbd_set_in_sync(mdev, sector, e->size);
@@ -1487,7 +1487,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 		return false;
 	}
 
-	/* hlist_del(&req->colision) is done in _req_may_be_done, to avoid
+	/* hlist_del(&req->collision) is done in _req_may_be_done, to avoid
 	 * special casing it there for the various failure cases.
 	 * still no race with drbd_fail_pending_reads */
 	ok = recv_dless_read(mdev, req, sector, data_size);
@@ -1558,11 +1558,11 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	 * P_WRITE_ACK / P_NEG_ACK, to get the sequence number right.  */
 	if (mdev->net_conf->two_primaries) {
 		spin_lock_irq(&mdev->req_lock);
-		D_ASSERT(!hlist_unhashed(&e->colision));
-		hlist_del_init(&e->colision);
+		D_ASSERT(!hlist_unhashed(&e->collision));
+		hlist_del_init(&e->collision);
 		spin_unlock_irq(&mdev->req_lock);
 	} else {
-		D_ASSERT(hlist_unhashed(&e->colision));
+		D_ASSERT(hlist_unhashed(&e->collision));
 	}
 
 	drbd_may_finish_epoch(mdev, e->epoch, EV_PUT + (cancel ? EV_CLEANUP : 0));
@@ -1579,8 +1579,8 @@ static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int u
 	ok = drbd_send_ack(mdev, P_DISCARD_ACK, e);
 
 	spin_lock_irq(&mdev->req_lock);
-	D_ASSERT(!hlist_unhashed(&e->colision));
-	hlist_del_init(&e->colision);
+	D_ASSERT(!hlist_unhashed(&e->collision));
+	hlist_del_init(&e->collision);
 	spin_unlock_irq(&mdev->req_lock);
 
 	dec_unacked(mdev);
@@ -1755,7 +1755,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 		spin_lock_irq(&mdev->req_lock);
 
-		hlist_add_head(&e->colision, ee_hash_slot(mdev, sector));
+		hlist_add_head(&e->collision, ee_hash_slot(mdev, sector));
 
 #define OVERLAPS overlaps(i->sector, i->size, sector, size)
 		slot = tl_hash_slot(mdev, sector);
@@ -1765,7 +1765,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 			int have_conflict = 0;
 			prepare_to_wait(&mdev->misc_wait, &wait,
 				TASK_INTERRUPTIBLE);
-			hlist_for_each_entry(i, n, slot, colision) {
+			hlist_for_each_entry(i, n, slot, collision) {
 				if (OVERLAPS) {
 					/* only ALERT on first iteration,
 					 * we may be woken up early... */
@@ -1804,7 +1804,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 			}
 
 			if (signal_pending(current)) {
-				hlist_del_init(&e->colision);
+				hlist_del_init(&e->collision);
 
 				spin_unlock_irq(&mdev->req_lock);
 
@@ -1862,7 +1862,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 	dev_err(DEV, "submit failed, triggering re-connect\n");
 	spin_lock_irq(&mdev->req_lock);
 	list_del(&e->w.list);
-	hlist_del_init(&e->colision);
+	hlist_del_init(&e->collision);
 	spin_unlock_irq(&mdev->req_lock);
 	if (e->flags & EE_CALL_AL_COMPLETE_IO)
 		drbd_al_complete_io(mdev, e->sector);
@@ -2994,7 +2994,7 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 	ddsf = be16_to_cpu(p->dds_flags);
 	if (get_ldev(mdev)) {
-		dd = drbd_determin_dev_size(mdev, ddsf);
+		dd = drbd_determine_dev_size(mdev, ddsf);
 		put_ldev(mdev);
 		if (dd == dev_size_error)
 			return false;
@@ -4275,7 +4275,7 @@ static struct drbd_request *_ack_id_to_req(struct drbd_conf *mdev,
 	struct hlist_node *n;
 	struct drbd_request *req;
 
-	hlist_for_each_entry(req, n, slot, colision) {
+	hlist_for_each_entry(req, n, slot, collision) {
 		if ((unsigned long)req == (unsigned long)id) {
 			if (req->sector != sector) {
 				dev_err(DEV, "_ack_id_to_req: found req %p but it has "
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 5c0c8be..7fe9088 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -163,7 +163,7 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 		 * they must have been failed on the spot */
 #define OVERLAPS overlaps(sector, size, i->sector, i->size)
 		slot = tl_hash_slot(mdev, sector);
-		hlist_for_each_entry(i, n, slot, colision) {
+		hlist_for_each_entry(i, n, slot, collision) {
 			if (OVERLAPS) {
 				dev_alert(DEV, "LOGIC BUG: completed: %p %llus +%u; "
 				      "other: %p %llus +%u\n",
@@ -187,7 +187,7 @@ static void _about_to_complete_local_write(struct drbd_conf *mdev,
 #undef OVERLAPS
 #define OVERLAPS overlaps(sector, size, e->sector, e->size)
 		slot = ee_hash_slot(mdev, req->sector);
-		hlist_for_each_entry(e, n, slot, colision) {
+		hlist_for_each_entry(e, n, slot, collision) {
 			if (OVERLAPS) {
 				wake_up(&mdev->misc_wait);
 				break;
@@ -260,8 +260,8 @@ void _req_may_be_done(struct drbd_request *req, struct bio_and_error *m)
 
 		/* remove the request from the conflict detection
 		 * respective block_id verification hash */
-		if (!hlist_unhashed(&req->colision))
-			hlist_del(&req->colision);
+		if (!hlist_unhashed(&req->collision))
+			hlist_del(&req->collision);
 		else
 			D_ASSERT((s & (RQ_NET_MASK & ~RQ_NET_DONE)) == 0);
 
@@ -329,7 +329,7 @@ static int _req_conflicts(struct drbd_request *req)
 	struct hlist_node *n;
 	struct hlist_head *slot;
 
-	D_ASSERT(hlist_unhashed(&req->colision));
+	D_ASSERT(hlist_unhashed(&req->collision));
 
 	if (!get_net_conf(mdev))
 		return 0;
@@ -341,7 +341,7 @@ static int _req_conflicts(struct drbd_request *req)
 
 #define OVERLAPS overlaps(i->sector, i->size, sector, size)
 	slot = tl_hash_slot(mdev, sector);
-	hlist_for_each_entry(i, n, slot, colision) {
+	hlist_for_each_entry(i, n, slot, collision) {
 		if (OVERLAPS) {
 			dev_alert(DEV, "%s[%u] Concurrent local write detected! "
 			      "[DISCARD L] new: %llus +%u; "
@@ -359,7 +359,7 @@ static int _req_conflicts(struct drbd_request *req)
 #undef OVERLAPS
 #define OVERLAPS overlaps(e->sector, e->size, sector, size)
 		slot = ee_hash_slot(mdev, sector);
-		hlist_for_each_entry(e, n, slot, colision) {
+		hlist_for_each_entry(e, n, slot, collision) {
 			if (OVERLAPS) {
 				dev_alert(DEV, "%s[%u] Concurrent remote write detected!"
 				      " [DISCARD L] new: %llus +%u; "
@@ -491,7 +491,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		/* so we can verify the handle in the answer packet
 		 * corresponding hlist_del is in _req_may_be_done() */
-		hlist_add_head(&req->colision, ar_hash_slot(mdev, req->sector));
+		hlist_add_head(&req->collision, ar_hash_slot(mdev, req->sector));
 
 		set_bit(UNPLUG_REMOTE, &mdev->flags);
 
@@ -507,7 +507,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		/* assert something? */
 		/* from drbd_make_request_common only */
 
-		hlist_add_head(&req->colision, tl_hash_slot(mdev, req->sector));
+		hlist_add_head(&req->collision, tl_hash_slot(mdev, req->sector));
 		/* corresponding hlist_del is in _req_may_be_done() */
 
 		/* NOTE
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index 32e2c3e..281342d 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -256,7 +256,7 @@ static inline struct drbd_request *_ar_id_to_req(struct drbd_conf *mdev,
 	struct hlist_node *n;
 	struct drbd_request *req;
 
-	hlist_for_each_entry(req, n, slot, colision) {
+	hlist_for_each_entry(req, n, slot, collision) {
 		if ((unsigned long)req == (unsigned long)id) {
 			D_ASSERT(req->sector == sector);
 			return req;
@@ -291,7 +291,7 @@ static inline struct drbd_request *drbd_req_new(struct drbd_conf *mdev,
 		req->epoch       = 0;
 		req->sector      = bio_src->bi_sector;
 		req->size        = bio_src->bi_size;
-		INIT_HLIST_NODE(&req->colision);
+		INIT_HLIST_NODE(&req->collision);
 		INIT_LIST_HEAD(&req->tl_requests);
 		INIT_LIST_HEAD(&req->w.list);
 	}
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index f7e6c92..3d54c62 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -126,7 +126,7 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
 	list_del(&e->w.list); /* has been on active_ee or sync_ee */
 	list_add_tail(&e->w.list, &mdev->done_ee);
 
-	/* No hlist_del_init(&e->colision) here, we did not send the Ack yet,
+	/* No hlist_del_init(&e->collision) here, we did not send the Ack yet,
 	 * neither did we wake possibly waiting conflicting requests.
 	 * done from "drbd_process_done_ee" within the appropriate w.cb
 	 * (e_end_block/e_end_resync_block) or from _drbd_clear_done_ee */
@@ -834,7 +834,7 @@ int drbd_resync_finished(struct drbd_conf *mdev)
 			const int ratio =
 				(t == 0)     ? 0 :
 			(t < 100000) ? ((s*100)/t) : (s/(t/100));
-			dev_info(DEV, "%u %% had equal check sums, eliminated: %luK; "
+			dev_info(DEV, "%u %% had equal checksums, eliminated: %luK; "
 			     "transferred %luK total %luK\n",
 			     ratio,
 			     Bit2KB(mdev->rs_same_csum),
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index cec467f..ebafda5 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -38,7 +38,7 @@
 
 /* Although the Linux source code makes a difference between
    generic endianness and the bitfields' endianness, there is no
-   architecture as of Linux-2.6.24-rc4 where the bitfileds' endianness
+   architecture as of Linux-2.6.24-rc4 where the bitfields' endianness
    does not match the generic endianness. */
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
@@ -195,7 +195,7 @@ enum drbd_conns {
 	C_WF_REPORT_PARAMS, /* we have a socket */
 	C_CONNECTED,      /* we have introduced each other */
 	C_STARTING_SYNC_S,  /* starting full sync by admin request. */
-	C_STARTING_SYNC_T,  /* stariing full sync by admin request. */
+	C_STARTING_SYNC_T,  /* starting full sync by admin request. */
 	C_WF_BITMAP_S,
 	C_WF_BITMAP_T,
 	C_WF_SYNC_UUID,
@@ -236,7 +236,7 @@ union drbd_state {
  * pointed out by Maxim Uvarov q<muvarov@ru.mvista.com>
  * even though we transmit as "cpu_to_be32(state)",
  * the offsets of the bitfields still need to be swapped
- * on different endianess.
+ * on different endianness.
  */
 	struct {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
@@ -266,7 +266,7 @@ union drbd_state {
 		unsigned peer:2 ;   /* 3/4	 primary/secondary/unknown */
 		unsigned role:2 ;   /* 3/4	 primary/secondary/unknown */
 #else
-# error "this endianess is not supported"
+# error "this endianness is not supported"
 #endif
 	};
 	unsigned int i;
diff --git a/include/linux/drbd_tag_magic.h b/include/linux/drbd_tag_magic.h
index f14a165..0695431 100644
--- a/include/linux/drbd_tag_magic.h
+++ b/include/linux/drbd_tag_magic.h
@@ -30,7 +30,7 @@ enum packet_types {
 	int tag_and_len ## member;
 #include "linux/drbd_nl.h"
 
-/* declate tag-list-sizes */
+/* declare tag-list-sizes */
 static const int tag_list_sizes[] = {
 #define NL_PACKET(name, number, fields) 2 fields ,
 #define NL_INTEGER(pn, pr, member)      + 4 + 4
-- 
1.7.3.4

