Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1GBFzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 01:55:20 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:35586 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1GBFzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 01:55:14 -0400
From: Calvin Owens <jcalvinowens@gmail.com>
To: Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <jcalvinowens@gmail.com>
Subject: [PATCH 1/1] md: style/readability cleanups
Date: Sat,  2 Jul 2011 00:53:16 -0500
Message-Id: <1309585996-28451-1-git-send-email-jcalvinowens@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some lingering CodingStyle issues in the md subsystem.

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 drivers/md/raid0.c  |   30 +++++------
 drivers/md/raid1.c  |   96 +++++++++++++++++------------------
 drivers/md/raid10.c |  108 +++++++++++++++++++-------------------
 drivers/md/raid5.c  |  142 +++++++++++++++++++++++++++------------------------
 4 files changed, 190 insertions(+), 186 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e86bf36..9d2fbc9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -103,10 +103,10 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 		list_for_each_entry(rdev2, &mddev->disks, same_set) {
 			printk(KERN_INFO "md/raid0:%s:   comparing %s(%llu)",
 			       mdname(mddev),
-			       bdevname(rdev1->bdev,b),
+			       bdevname(rdev1->bdev, b),
 			       (unsigned long long)rdev1->sectors);
 			printk(KERN_CONT " with %s(%llu)\n",
-			       bdevname(rdev2->bdev,b),
+			       bdevname(rdev2->bdev, b),
 			       (unsigned long long)rdev2->sectors);
 			if (rdev2 == rdev1) {
 				printk(KERN_INFO "md/raid0:%s:   END\n",
@@ -137,12 +137,11 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 	printk(KERN_INFO "md/raid0:%s: FINAL %d zones\n",
 	       mdname(mddev), conf->nr_strip_zones);
 	err = -ENOMEM;
-	conf->strip_zone = kzalloc(sizeof(struct strip_zone)*
-				conf->nr_strip_zones, GFP_KERNEL);
+	conf->strip_zone = kzalloc(sizeof(struct strip_zone) * conf->nr_strip_zones,
+				GFP_KERNEL);
 	if (!conf->strip_zone)
 		goto abort;
-	conf->devlist = kzalloc(sizeof(mdk_rdev_t*)*
-				conf->nr_strip_zones*mddev->raid_disks,
+	conf->devlist = kzalloc(sizeof(mdk_rdev_t *) * conf->nr_strip_zones * mddev->raid_disks,
 				GFP_KERNEL);
 	if (!conf->devlist)
 		goto abort;
@@ -224,7 +223,7 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 		smallest = NULL;
 		c = 0;
 
-		for (j=0; j<cnt; j++) {
+		for (j = 0; j < cnt; j++) {
 			rdev = conf->devlist[j];
 			printk(KERN_INFO "md/raid0:%s: checking %s ...",
 			       mdname(mddev),
@@ -311,10 +310,11 @@ static int raid0_mergeable_bvec(struct request_queue *q,
 	else
 		max =  (chunk_sectors - (sector_div(sector, chunk_sectors)
 						+ bio_sectors)) << 9;
-	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
+	if (max < 0)
+		max = 0; /* bio_add cannot handle a negative return */
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
-	else 
+	else
 		return max;
 }
 
@@ -371,10 +371,9 @@ static int raid0_run(mddev_t *mddev)
 	 * chunksize should be used in that case.
 	 */
 	{
-		int stripe = mddev->raid_disks *
-			(mddev->chunk_sectors << 9) / PAGE_SIZE;
-		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
-			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
+		int stripe = mddev->raid_disks * (mddev->chunk_sectors << 9) / PAGE_SIZE;
+		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
+			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 	}
 
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
@@ -624,7 +623,7 @@ static void *raid0_takeover_raid10(mddev_t *mddev)
 	mddev->new_level = 0;
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = mddev->chunk_sectors;
-	mddev->delta_disks = - mddev->raid_disks / 2;
+	mddev->delta_disks = -mddev->raid_disks / 2;
 	mddev->raid_disks += mddev->delta_disks;
 	mddev->degraded = 0;
 	/* make sure it will be not marked as dirty */
@@ -695,8 +694,7 @@ static void raid0_quiesce(mddev_t *mddev, int state)
 {
 }
 
-static struct mdk_personality raid0_personality=
-{
+static struct mdk_personality raid0_personality = {
 	.name		= "raid0",
 	.level		= 0,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f7431b6..04cf89f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -55,7 +55,7 @@
 static void allow_barrier(conf_t *conf);
 static void lower_barrier(conf_t *conf);
 
-static void * r1bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
 	int size = offsetof(r1bio_t, bios[pi->raid_disks]);
@@ -75,7 +75,7 @@ static void r1bio_pool_free(void *r1_bio, void *data)
 #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
 #define RESYNC_WINDOW (2048*1024)
 
-static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	struct pool_info *pi = data;
 	struct page *page;
@@ -106,7 +106,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 		j = pi->raid_disks;
 	else
 		j = 1;
-	while(j--) {
+	while (j--) {
 		bio = r1_bio->bios[j];
 		for (i = 0; i < RESYNC_PAGES; i++) {
 			page = alloc_page(gfp_flags);
@@ -119,8 +119,8 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	}
 	/* If not user-requests, copy the page pointers to all bios */
 	if (!test_bit(MD_RECOVERY_REQUESTED, &pi->mddev->recovery)) {
-		for (i=0; i<RESYNC_PAGES ; i++)
-			for (j=1; j<pi->raid_disks; j++)
+		for (i = 0; i < RESYNC_PAGES; i++)
+			for (j = 1; j < pi->raid_disks; j++)
 				r1_bio->bios[j]->bi_io_vec[i].bv_page =
 					r1_bio->bios[0]->bi_io_vec[i].bv_page;
 	}
@@ -130,12 +130,12 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void *data)
 	return r1_bio;
 
 out_free_pages:
-	for (j=0 ; j < pi->raid_disks; j++)
-		for (i=0; i < r1_bio->bios[j]->bi_vcnt ; i++)
+	for (j = 0; j < pi->raid_disks; j++)
+		for (i = 0; i < r1_bio->bios[j]->bi_vcnt; i++)
 			put_page(r1_bio->bios[j]->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
-	while ( ++j < pi->raid_disks )
+	while (++j < pi->raid_disks)
 		bio_put(r1_bio->bios[j]);
 	r1bio_pool_free(r1_bio, data);
 	return NULL;
@@ -144,7 +144,7 @@ out_free_bio:
 static void r1buf_pool_free(void *__r1_bio, void *data)
 {
 	struct pool_info *pi = data;
-	int i,j;
+	int i, j;
 	r1bio_t *r1bio = __r1_bio;
 
 	for (i = 0; i < RESYNC_PAGES; i++)
@@ -154,7 +154,7 @@ static void r1buf_pool_free(void *__r1_bio, void *data)
 			    r1bio->bios[0]->bi_io_vec[i].bv_page)
 				safe_put_page(r1bio->bios[j]->bi_io_vec[i].bv_page);
 		}
-	for (i=0 ; i < pi->raid_disks; i++)
+	for (i = 0; i < pi->raid_disks; i++)
 		bio_put(r1bio->bios[i]);
 
 	r1bio_pool_free(r1bio, data);
@@ -191,7 +191,7 @@ static void put_buf(r1bio_t *r1_bio)
 	conf_t *conf = r1_bio->mddev->private;
 	int i;
 
-	for (i=0; i<conf->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 		struct bio *bio = r1_bio->bios[i];
 		if (bio->bi_end_io)
 			rdev_dec_pending(conf->mirrors[i].rdev, r1_bio->mddev);
@@ -210,7 +210,7 @@ static void reschedule_retry(r1bio_t *r1_bio)
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	list_add(&r1_bio->retry_list, &conf->retry_list);
-	conf->nr_queued ++;
+	conf->nr_queued++;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	wake_up(&conf->wait_barrier);
@@ -290,7 +290,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 		if (printk_ratelimit())
 			printk(KERN_ERR "md/raid1:%s: %s: rescheduling sector %llu\n",
 			       mdname(conf->mddev),
-			       bdevname(conf->mirrors[mirror].rdev->bdev,b), (unsigned long long)r1_bio->sector);
+			       bdevname(conf->mirrors[mirror].rdev->bdev, b), (unsigned long long)r1_bio->sector);
 		reschedule_retry(r1_bio);
 	}
 
@@ -299,8 +299,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 
 static void r1_bio_write_done(r1bio_t *r1_bio)
 {
-	if (atomic_dec_and_test(&r1_bio->remaining))
-	{
+	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		/* it really is the end of this request */
 		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
 			/* free extra copy of the data pages */
@@ -666,13 +665,14 @@ static void unfreeze_array(conf_t *conf)
 }
 
 
-/* duplicate the data pages for behind I/O 
+/*
+ * duplicate the data pages for behind I/O
  */
 static void alloc_behind_pages(struct bio *bio, r1bio_t *r1_bio)
 {
 	int i;
 	struct bio_vec *bvec;
-	struct page **pages = kzalloc(bio->bi_vcnt * sizeof(struct page*),
+	struct page **pages = kzalloc(bio->bi_vcnt * sizeof(struct page *),
 					GFP_NOIO);
 	if (unlikely(!pages))
 		return;
@@ -855,7 +855,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 
 	/* do behind I/O ?
 	 * Not if there are too many, or cannot allocate memory,
-	 * or a reader on WriteMostly is waiting for behind writes 
+	 * or a reader on WriteMostly is waiting for behind writes
 	 * to flush */
 	if (bitmap &&
 	    (atomic_read(&bitmap->behind_writes)
@@ -995,7 +995,7 @@ static void print_conf(conf_t *conf)
 			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
 			       i, !test_bit(In_sync, &rdev->flags),
 			       !test_bit(Faulty, &rdev->flags),
-			       bdevname(rdev->bdev,b));
+			       bdevname(rdev->bdev, b));
 	}
 	rcu_read_unlock();
 }
@@ -1017,7 +1017,7 @@ static int raid1_spare_active(mddev_t *mddev)
 	unsigned long flags;
 
 	/*
-	 * Find all failed disks within the RAID1 configuration 
+	 * Find all failed disks within the RAID1 configuration
 	 * and mark them readable.
 	 * Called under mddev lock, so rcu protection not needed.
 	 */
@@ -1052,7 +1052,7 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 		first = last = rdev->raid_disk;
 
 	for (mirror = first; mirror <= last; mirror++)
-		if ( !(p=conf->mirrors+mirror)->rdev) {
+		if ( !(p = conf->mirrors + mirror)->rdev) {
 
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
@@ -1089,7 +1089,7 @@ static int raid1_remove_disk(mddev_t *mddev, int number)
 	conf_t *conf = mddev->private;
 	int err = 0;
 	mdk_rdev_t *rdev;
-	mirror_info_t *p = conf->mirrors+ number;
+	mirror_info_t *p = conf->mirrors + number;
 
 	print_conf(conf);
 	rdev = p->rdev;
@@ -1130,7 +1130,7 @@ static void end_sync_read(struct bio *bio, int error)
 	r1bio_t *r1_bio = bio->bi_private;
 	int i;
 
-	for (i=r1_bio->mddev->raid_disks; i--; )
+	for (i = r1_bio->mddev->raid_disks; i--; )
 		if (r1_bio->bios[i] == bio)
 			break;
 	BUG_ON(i < 0);
@@ -1154,7 +1154,7 @@ static void end_sync_write(struct bio *bio, int error)
 	mddev_t *mddev = r1_bio->mddev;
 	conf_t *conf = mddev->private;
 	int i;
-	int mirror=0;
+	int mirror = 0;
 
 	for (i = 0; i < conf->raid_disks; i++)
 		if (r1_bio->bios[i] == bio) {
@@ -1201,7 +1201,7 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 	int sectors = r1_bio->sectors;
 	int idx = 0;
 
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int d = r1_bio->read_disk;
 		int success = 0;
@@ -1282,7 +1282,7 @@ static int fix_sync_read_error(r1bio_t *r1_bio)
 		}
 		sectors -= s;
 		sect += s;
-		idx ++;
+		idx++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -1313,7 +1313,7 @@ static int process_checks(r1bio_t *r1_bio)
 	r1_bio->read_disk = primary;
 	for (i = 0; i < conf->raid_disks; i++) {
 		int j;
-		int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
+		int vcnt = r1_bio->sectors >> (PAGE_SHIFT - 9);
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
@@ -1427,7 +1427,7 @@ static void fix_read_error(conf_t *conf, int read_disk,
 			   sector_t sect, int sectors)
 {
 	mddev_t *mddev = conf->mddev;
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int d = read_disk;
 		int success = 0;
@@ -1464,7 +1464,7 @@ static void fix_read_error(conf_t *conf, int read_disk,
 		/* write it back and re-read */
 		start = d;
 		while (d != read_disk) {
-			if (d==0)
+			if (d == 0)
 				d = conf->raid_disks;
 			d--;
 			rdev = conf->mirrors[d].rdev;
@@ -1480,7 +1480,7 @@ static void fix_read_error(conf_t *conf, int read_disk,
 		d = start;
 		while (d != read_disk) {
 			char b[BDEVNAME_SIZE];
-			if (d==0)
+			if (d == 0)
 				d = conf->raid_disks;
 			d--;
 			rdev = conf->mirrors[d].rdev;
@@ -1497,8 +1497,7 @@ static void fix_read_error(conf_t *conf, int read_disk,
 					       "md/raid1:%s: read error corrected "
 					       "(%d sectors at %llu on %s)\n",
 					       mdname(mddev), s,
-					       (unsigned long long)(sect +
-					           rdev->data_offset),
+					       (unsigned long long)(sect + rdev->data_offset),
 					       bdevname(rdev->bdev, b));
 				}
 			}
@@ -1563,11 +1562,11 @@ static void raid1d(mddev_t *mddev)
 					 conf->mirrors[r1_bio->read_disk].rdev);
 
 			bio = r1_bio->bios[r1_bio->read_disk];
-			if ((disk=read_balance(conf, r1_bio)) == -1) {
+			if ((disk = read_balance(conf, r1_bio)) == -1) {
 				printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       mdname(mddev),
-				       bdevname(bio->bi_bdev,b),
+				       bdevname(bio->bi_bdev, b),
 				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 			} else {
@@ -1585,7 +1584,7 @@ static void raid1d(mddev_t *mddev)
 					       " other mirror: %s\n",
 					       mdname(mddev),
 					       (unsigned long long)r1_bio->sector,
-					       bdevname(rdev->bdev,b));
+					       bdevname(rdev->bdev, b));
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_end_io = raid1_end_read_request;
@@ -1704,7 +1703,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	r1_bio->state = 0;
 	set_bit(R1BIO_IsSync, &r1_bio->state);
 
-	for (i=0; i < conf->raid_disks; i++) {
+	for (i = 0; i < conf->raid_disks; i++) {
 		mdk_rdev_t *rdev;
 		bio = r1_bio->bios[i];
 
@@ -1729,7 +1728,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		} else if (!test_bit(In_sync, &rdev->flags)) {
 			bio->bi_rw = WRITE;
 			bio->bi_end_io = end_sync_write;
-			write_targets ++;
+			write_targets++;
 		} else {
 			/* may need to read from here */
 			bio->bi_rw = READ;
@@ -1789,7 +1788,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 				len = sync_blocks<<9;
 		}
 
-		for (i=0 ; i < conf->raid_disks; i++) {
+		for (i = 0; i < conf->raid_disks; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io) {
 				page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
@@ -1799,12 +1798,12 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 					while (i > 0) {
 						i--;
 						bio = r1_bio->bios[i];
-						if (bio->bi_end_io==NULL)
+						if (bio->bi_end_io == NULL)
 							continue;
 						/* remove last page from this bio */
 						bio->bi_vcnt--;
 						bio->bi_size -= len;
-						bio->bi_flags &= ~(1<< BIO_SEG_VALID);
+						bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 					}
 					goto bio_full;
 				}
@@ -1822,7 +1821,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 	 */
 	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		atomic_set(&r1_bio->remaining, read_targets);
-		for (i=0; i<conf->raid_disks; i++) {
+		for (i = 0; i < conf->raid_disks; i++) {
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io == end_sync_read) {
 				md_sync_acct(bio->bi_bdev, nr_sectors);
@@ -1994,7 +1993,7 @@ static int run(mddev_t *mddev)
 	}
 
 	mddev->degraded = 0;
-	for (i=0; i < conf->raid_disks; i++)
+	for (i = 0; i < conf->raid_disks; i++)
 		if (conf->mirrors[i].rdev == NULL ||
 		    !test_bit(In_sync, &conf->mirrors[i].rdev->flags) ||
 		    test_bit(Faulty, &conf->mirrors[i].rdev->flags))
@@ -2007,9 +2006,9 @@ static int run(mddev_t *mddev)
 		printk(KERN_NOTICE "md/raid1:%s: not clean"
 		       " -- starting background reconstruction\n",
 		       mdname(mddev));
-	printk(KERN_INFO 
+	printk(KERN_INFO
 		"md/raid1:%s: active with %d out of %d mirrors\n",
-		mdname(mddev), mddev->raid_disks - mddev->degraded, 
+		mdname(mddev), mddev->raid_disks - mddev->degraded,
 		mddev->raid_disks);
 
 	/*
@@ -2118,8 +2117,8 @@ static int raid1_reshape(mddev_t *mddev)
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
 	if (raid_disks < conf->raid_disks) {
-		cnt=0;
-		for (d= 0; d < conf->raid_disks; d++)
+		cnt = 0;
+		for (d = 0; d < conf->raid_disks; d++)
 			if (conf->mirrors[d].rdev)
 				cnt++;
 		if (cnt > raid_disks)
@@ -2195,7 +2194,7 @@ static void raid1_quiesce(mddev_t *mddev, int state)
 {
 	conf_t *conf = mddev->private;
 
-	switch(state) {
+	switch (state) {
 	case 2: /* wake for suspend */
 		wake_up(&conf->wait_barrier);
 		break;
@@ -2226,8 +2225,7 @@ static void *raid1_takeover(mddev_t *mddev)
 	return ERR_PTR(-EINVAL);
 }
 
-static struct mdk_personality raid1_personality =
-{
+static struct mdk_personality raid1_personality = {
 	.name		= "raid1",
 	.level		= 1,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6e84668..88b5a9f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -60,7 +60,7 @@
 static void allow_barrier(conf_t *conf);
 static void lower_barrier(conf_t *conf);
 
-static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	conf_t *conf = data;
 	int size = offsetof(struct r10bio_s, devs[conf->copies]);
@@ -89,7 +89,7 @@ static void r10bio_pool_free(void *r10_bio, void *data)
  * one for write (we recover only one drive per r10buf)
  *
  */
-static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 {
 	conf_t *conf = data;
 	struct page *page;
@@ -141,7 +141,7 @@ out_free_pages:
 			safe_put_page(r10_bio->devs[j].bio->bi_io_vec[i].bv_page);
 	j = -1;
 out_free_bio:
-	while ( ++j < nalloc )
+	while (++j < nalloc)
 		bio_put(r10_bio->devs[j].bio);
 	r10bio_pool_free(r10_bio, conf);
 	return NULL;
@@ -154,7 +154,7 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 	r10bio_t *r10bio = __r10_bio;
 	int j;
 
-	for (j=0; j < conf->copies; j++) {
+	for (j = 0; j < conf->copies; j++) {
 		struct bio *bio = r10bio->devs[j].bio;
 		if (bio) {
 			for (i = 0; i < RESYNC_PAGES; i++) {
@@ -172,7 +172,7 @@ static void put_all_bios(conf_t *conf, r10bio_t *r10_bio)
 	int i;
 
 	for (i = 0; i < conf->copies; i++) {
-		struct bio **bio = & r10_bio->devs[i].bio;
+		struct bio **bio = &r10_bio->devs[i].bio;
 		if (*bio && *bio != IO_BLOCKED)
 			bio_put(*bio);
 		*bio = NULL;
@@ -210,7 +210,7 @@ static void reschedule_retry(r10bio_t *r10_bio)
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	list_add(&r10_bio->retry_list, &conf->retry_list);
-	conf->nr_queued ++;
+	conf->nr_queued++;
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	/* wake up frozen array... */
@@ -280,7 +280,7 @@ static void raid10_end_read_request(struct bio *bio, int error)
 		if (printk_ratelimit())
 			printk(KERN_ERR "md/raid10:%s: %s: rescheduling sector %llu\n",
 			       mdname(conf->mddev),
-			       bdevname(conf->mirrors[dev].rdev->bdev,b), (unsigned long long)r10_bio->sector);
+			       bdevname(conf->mirrors[dev].rdev->bdev, b), (unsigned long long)r10_bio->sector);
 		reschedule_retry(r10_bio);
 	}
 }
@@ -364,7 +364,7 @@ static void raid10_end_write_request(struct bio *bio, int error)
 
 static void raid10_find_phys(conf_t *conf, r10bio_t *r10bio)
 {
-	int n,f;
+	int n, f;
 	sector_t sector;
 	sector_t chunk;
 	sector_t stripe;
@@ -385,7 +385,7 @@ static void raid10_find_phys(conf_t *conf, r10bio_t *r10bio)
 	sector += stripe << conf->chunk_shift;
 
 	/* and calculate all the others */
-	for (n=0; n < conf->near_copies; n++) {
+	for (n = 0; n < conf->near_copies; n++) {
 		int d = dev;
 		sector_t s = sector;
 		r10bio->devs[slot].addr = sector;
@@ -458,7 +458,8 @@ static int raid10_mergeable_bvec(struct request_queue *q,
 	unsigned int bio_sectors = bvm->bi_size >> 9;
 
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0; /* bio_add cannot handle a negative return */
+	if (max < 0)
+		max = 0; /* bio_add cannot handle a negative return */
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
 	else
@@ -743,7 +744,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	/* If this request crosses a chunk boundary, we need to
 	 * split it.  This will only happen for 1 PAGE (or less) requests.
 	 */
-	if (unlikely( (bio->bi_sector & conf->chunk_mask) + (bio->bi_size >> 9)
+	if (unlikely((bio->bi_sector & conf->chunk_mask) + (bio->bi_size >> 9)
 		      > chunk_sects &&
 		    conf->near_copies < conf->raid_disks)) {
 		struct bio_pair *bp;
@@ -755,7 +756,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 		 * refuse to split for us, so we need to split it.
 		 */
 		bp = bio_split(bio,
-			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
 
 		/* Each of these 'make_request' calls will call 'wait_barrier'.
 		 * If the first succeeds but the second blocks due to the resync
@@ -781,7 +782,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 
 		bio_pair_release(bp);
 		return 0;
-	bad_map:
+bad_map:
 		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
 		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
 		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
@@ -1008,8 +1009,8 @@ static void print_conf(conf_t *conf)
 		if (tmp->rdev)
 			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
 				i, !test_bit(In_sync, &tmp->rdev->flags),
-			        !test_bit(Faulty, &tmp->rdev->flags),
-				bdevname(tmp->rdev->bdev,b));
+				!test_bit(Faulty, &tmp->rdev->flags),
+				bdevname(tmp->rdev->bdev, b));
 	}
 }
 
@@ -1100,7 +1101,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	else
 		mirror = first;
 	for ( ; mirror <= last ; mirror++)
-		if ( !(p=conf->mirrors+mirror)->rdev) {
+		if (!(p = conf->mirrors+mirror)->rdev) {
 
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
@@ -1135,7 +1136,7 @@ static int raid10_remove_disk(mddev_t *mddev, int number)
 	conf_t *conf = mddev->private;
 	int err = 0;
 	mdk_rdev_t *rdev;
-	mirror_info_t *p = conf->mirrors+ number;
+	mirror_info_t *p = conf->mirrors + number;
 
 	print_conf(conf);
 	rdev = p->rdev;
@@ -1174,9 +1175,9 @@ static void end_sync_read(struct bio *bio, int error)
 {
 	r10bio_t *r10_bio = bio->bi_private;
 	conf_t *conf = r10_bio->mddev->private;
-	int i,d;
+	int i, d;
 
-	for (i=0; i<conf->copies; i++)
+	for (i = 0; i < conf->copies; i++)
 		if (r10_bio->devs[i].bio == bio)
 			break;
 	BUG_ON(i == conf->copies);
@@ -1212,7 +1213,7 @@ static void end_sync_write(struct bio *bio, int error)
 	r10bio_t *r10_bio = bio->bi_private;
 	mddev_t *mddev = r10_bio->mddev;
 	conf_t *conf = mddev->private;
-	int i,d;
+	int i, d;
 
 	for (i = 0; i < conf->copies; i++)
 		if (r10_bio->devs[i].bio == bio)
@@ -1265,7 +1266,7 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 	atomic_set(&r10_bio->remaining, 1);
 
 	/* find the first device with a block */
-	for (i=0; i<conf->copies; i++)
+	for (i = 0; i < conf->copies; i++)
 		if (test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags))
 			break;
 
@@ -1276,7 +1277,7 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 	fbio = r10_bio->devs[i].bio;
 
 	/* now find blocks with errors */
-	for (i=0 ; i < conf->copies ; i++) {
+	for (i = 0 ; i < conf->copies ; i++) {
 		int  j, d;
 		int vcnt = r10_bio->sectors >> (PAGE_SHIFT-9);
 
@@ -1318,7 +1319,7 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 		tbio->bi_private = r10_bio;
 		tbio->bi_sector = r10_bio->devs[i].addr;
 
-		for (j=0; j < vcnt ; j++) {
+		for (j = 0; j < vcnt ; j++) {
 			tbio->bi_io_vec[j].bv_offset = 0;
 			tbio->bi_io_vec[j].bv_len = PAGE_SIZE;
 
@@ -1368,7 +1369,7 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 	 */
 	bio = r10_bio->devs[0].bio;
 	wbio = r10_bio->devs[1].bio;
-	for (i=0; i < wbio->bi_vcnt; i++) {
+	for (i = 0; i < wbio->bi_vcnt; i++) {
 		struct page *p = bio->bi_io_vec[i].bv_page;
 		bio->bi_io_vec[i].bv_page = wbio->bi_io_vec[i].bv_page;
 		wbio->bi_io_vec[i].bv_page = p;
@@ -1433,7 +1434,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 {
 	int sect = 0; /* Offset from r10_bio->sector */
 	int sectors = r10_bio->sectors;
-	mdk_rdev_t*rdev;
+	mdk_rdev_t *rdev;
 	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
 	int d = r10_bio->devs[r10_bio->read_slot].devnum;
 
@@ -1465,7 +1466,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 		return;
 	}
 
-	while(sectors) {
+	while (sectors) {
 		int s = sectors;
 		int sl = r10_bio->read_slot;
 		int success = 0;
@@ -1511,7 +1512,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 		while (sl != r10_bio->read_slot) {
 			char b[BDEVNAME_SIZE];
 
-			if (sl==0)
+			if (sl == 0)
 				sl = conf->copies;
 			sl--;
 			d = r10_bio->devs[sl].devnum;
@@ -1548,7 +1549,7 @@ static void fix_read_error(conf_t *conf, mddev_t *mddev, r10bio_t *r10_bio)
 		sl = start;
 		while (sl != r10_bio->read_slot) {
 
-			if (sl==0)
+			if (sl == 0)
 				sl = conf->copies;
 			sl--;
 			d = r10_bio->devs[sl].devnum;
@@ -1658,7 +1659,7 @@ static void raid10d(mddev_t *mddev)
 				printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       mdname(mddev),
-				       bdevname(bio->bi_bdev,b),
+				       bdevname(bio->bi_bdev, b),
 				       (unsigned long long)r10_bio->sector);
 				raid_end_bio_io(r10_bio);
 				bio_put(bio);
@@ -1669,10 +1670,10 @@ static void raid10d(mddev_t *mddev)
 				rdev = conf->mirrors[mirror].rdev;
 				if (printk_ratelimit())
 					printk(KERN_ERR "md/raid10:%s: %s: redirecting sector %llu to"
-					       " another mirror\n",
-					       mdname(mddev),
-					       bdevname(rdev->bdev,b),
-					       (unsigned long long)r10_bio->sector);
+						" another mirror\n",
+						mdname(mddev),
+						bdevname(rdev->bdev, b),
+						(unsigned long long)r10_bio->sector);
 				bio = bio_clone_mddev(r10_bio->master_bio,
 						      GFP_NOIO, mddev);
 				r10_bio->devs[slot].bio = bio;
@@ -1772,7 +1773,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 				bitmap_end_sync(mddev->bitmap, mddev->curr_resync,
 						&sync_blocks, 1);
-			else for (i=0; i<conf->raid_disks; i++) {
+			else for (i = 0; i < conf->raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
 				bitmap_end_sync(mddev->bitmap, sect,
@@ -1831,14 +1832,14 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 		int j, k;
 		r10_bio = NULL;
 
-		for (i=0 ; i<conf->raid_disks; i++) {
+		for (i = 0 ; i < conf->raid_disks; i++) {
 			int still_degraded;
 			r10bio_t *rb2;
 			sector_t sect;
 			int must_sync;
 
 			if (conf->mirrors[i].rdev == NULL ||
-			    test_bit(In_sync, &conf->mirrors[i].rdev->flags)) 
+			    test_bit(In_sync, &conf->mirrors[i].rdev->flags))
 				continue;
 
 			still_degraded = 0;
@@ -1865,7 +1866,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 			raise_barrier(conf, rb2 != NULL);
 			atomic_set(&r10_bio->remaining, 0);
 
-			r10_bio->master_bio = (struct bio*)rb2;
+			r10_bio->master_bio = (struct bio *)rb2;
 			if (rb2)
 				atomic_inc(&rb2->remaining);
 			r10_bio->mddev = mddev;
@@ -1877,7 +1878,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 			/* Need to check if the array will still be
 			 * degraded
 			 */
-			for (j=0; j<conf->raid_disks; j++)
+			for (j = 0; j < conf->raid_disks; j++)
 				if (conf->mirrors[j].rdev == NULL ||
 				    test_bit(Faulty, &conf->mirrors[j].rdev->flags)) {
 					still_degraded = 1;
@@ -1887,7 +1888,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 			must_sync = bitmap_start_sync(mddev->bitmap, sect,
 						      &sync_blocks, still_degraded);
 
-			for (j=0; j<conf->copies;j++) {
+			for (j = 0; j < conf->copies; j++) {
 				int d = r10_bio->devs[j].devnum;
 				if (!conf->mirrors[d].rdev ||
 				    !test_bit(In_sync, &conf->mirrors[d].rdev->flags))
@@ -1906,7 +1907,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 				atomic_inc(&r10_bio->remaining);
 				/* and we write to 'i' */
 
-				for (k=0; k<conf->copies; k++)
+				for (k = 0; k < conf->copies; k++)
 					if (r10_bio->devs[k].devnum == i)
 						break;
 				BUG_ON(k == conf->copies);
@@ -1942,7 +1943,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 		if (biolist == NULL) {
 			while (r10_bio) {
 				r10bio_t *rb2 = r10_bio;
-				r10_bio = (r10bio_t*) rb2->master_bio;
+				r10_bio = (r10bio_t *) rb2->master_bio;
 				rb2->master_bio = NULL;
 				put_buf(rb2);
 			}
@@ -1975,9 +1976,9 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 		r10_bio->sector = sector_nr;
 		set_bit(R10BIO_IsSync, &r10_bio->state);
 		raid10_find_phys(conf, r10_bio);
-		r10_bio->sectors = (sector_nr | conf->chunk_mask) - sector_nr +1;
+		r10_bio->sectors = (sector_nr | conf->chunk_mask) - sector_nr + 1;
 
-		for (i=0; i<conf->copies; i++) {
+		for (i = 0; i < conf->copies; i++) {
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
@@ -1999,7 +2000,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 		}
 
 		if (count < 2) {
-			for (i=0; i<conf->copies; i++) {
+			for (i = 0; i < conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;
 				if (r10_bio->devs[i].bio->bi_end_io)
 					rdev_dec_pending(conf->mirrors[d].rdev,
@@ -2011,7 +2012,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 		}
 	}
 
-	for (bio = biolist; bio ; bio=bio->bi_next) {
+	for (bio = biolist; bio ; bio = bio->bi_next) {
 
 		bio->bi_flags &= ~(BIO_POOL_MASK - 1);
 		if (bio->bi_end_io)
@@ -2032,7 +2033,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 			len = (max_sector - sector_nr) << 9;
 		if (len == 0)
 			break;
-		for (bio= biolist ; bio ; bio=bio->bi_next) {
+		for (bio = biolist ; bio ; bio = bio->bi_next) {
 			struct bio *bio2;
 			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
 			if (bio_add_page(bio, page, len, 0))
@@ -2046,7 +2047,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 				/* remove last page from this bio */
 				bio2->bi_vcnt--;
 				bio2->bi_size -= len;
-				bio2->bi_flags &= ~(1<< BIO_SEG_VALID);
+				bio2->bi_flags &= ~(1 << BIO_SEG_VALID);
 			}
 			goto bio_full;
 		}
@@ -2085,7 +2086,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
 		max_sector = sector_nr + max_sync;
 
 	sectors_skipped += (max_sector - sector_nr);
-	chunks_skipped ++;
+	chunks_skipped++;
 	sector_nr = max_sector;
 	goto skipped;
 }
@@ -2129,7 +2130,7 @@ static conf_t *setup_conf(mddev_t *mddev)
 	fc = (mddev->new_layout >> 8) & 255;
 	fo = mddev->new_layout & (1<<16);
 
-	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
+	if ((nc*fc) < 2 || (nc*fc) > mddev->raid_disks ||
 	    (mddev->new_layout >> 17)) {
 		printk(KERN_ERR "md/raid10:%s: unsupported raid10 layout: 0x%8x\n",
 		       mdname(mddev), mddev->new_layout);
@@ -2318,8 +2319,8 @@ static int run(mddev_t *mddev)
 		int stripe = conf->raid_disks *
 			((mddev->chunk_sectors << 9) / PAGE_SIZE);
 		stripe /= conf->near_copies;
-		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
-			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
+		if (mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
+			mddev->queue->backing_dev_info.ra_pages = 2 * stripe;
 	}
 
 	if (conf->near_copies < conf->raid_disks)
@@ -2364,7 +2365,7 @@ static void raid10_quiesce(mddev_t *mddev, int state)
 {
 	conf_t *conf = mddev->private;
 
-	switch(state) {
+	switch (state) {
 	case 1:
 		raise_barrier(conf, 0);
 		break;
@@ -2427,8 +2428,7 @@ static void *raid10_takeover(mddev_t *mddev)
 	return ERR_PTR(-EINVAL);
 }
 
-static struct mdk_personality raid10_personality =
-{
+static struct mdk_personality raid10_personality = {
 	.name		= "raid10",
 	.level		= 10,
 	.owner		= THIS_MODULE,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b72edf3..4df49a6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -197,7 +197,7 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 {
 	if (atomic_dec_and_test(&sh->count)) {
 		BUG_ON(!list_empty(&sh->lru));
-		BUG_ON(atomic_read(&conf->active_stripes)==0);
+		BUG_ON(atomic_read(&conf->active_stripes) == 0);
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
 			if (test_bit(STRIPE_DELAYED, &sh->state))
 				list_add_tail(&sh->lru, &conf->delayed_list);
@@ -456,7 +456,7 @@ get_active_stripe(raid5_conf_t *conf, sector_t sector,
 				wait_event_lock_irq(conf->wait_for_stripe,
 						    !list_empty(&conf->inactive_list) &&
 						    (atomic_read(&conf->active_stripes)
-						     < (conf->max_nr_stripes *3/4)
+						     < (conf->max_nr_stripes * 3/4)
 						     || !conf->inactive_blocked),
 						    conf->device_lock,
 						    );
@@ -1472,9 +1472,9 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 		osh = get_free_stripe(conf);
 		spin_unlock_irq(&conf->device_lock);
 		atomic_set(&nsh->count, 1);
-		for(i=0; i<conf->pool_size; i++)
+		for (i = 0; i < conf->pool_size; i++)
 			nsh->dev[i].page = osh->dev[i].page;
-		for( ; i<newsize; i++)
+		for ( ; i < newsize; i++)
 			nsh->dev[i].page = NULL;
 		kmem_cache_free(conf->slab_cache, osh);
 	}
@@ -1487,7 +1487,7 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	 */
 	ndisks = kzalloc(newsize * sizeof(struct disk_info), GFP_NOIO);
 	if (ndisks) {
-		for (i=0; i<conf->raid_disks; i++)
+		for (i = 0; i < conf->raid_disks; i++)
 			ndisks[i] = conf->disks[i];
 		kfree(conf->disks);
 		conf->disks = ndisks;
@@ -1514,11 +1514,11 @@ static int resize_stripes(raid5_conf_t *conf, int newsize)
 	put_online_cpus();
 
 	/* Step 4, return new stripes to service */
-	while(!list_empty(&newstripes)) {
+	while (!list_empty(&newstripes)) {
 		nsh = list_entry(newstripes.next, struct stripe_head, lru);
 		list_del_init(&nsh->lru);
 
-		for (i=conf->raid_disks; i < newsize; i++)
+		for (i = conf->raid_disks; i < newsize; i++)
 			if (nsh->dev[i].page == NULL) {
 				struct page *p = alloc_page(GFP_NOIO);
 				nsh->dev[i].page = p;
@@ -1561,7 +1561,7 @@ static void shrink_stripes(raid5_conf_t *conf)
 	conf->slab_cache = NULL;
 }
 
-static void raid5_end_read_request(struct bio * bi, int error)
+static void raid5_end_read_request(struct bio *bi, int error)
 {
 	struct stripe_head *sh = bi->bi_private;
 	raid5_conf_t *conf = sh->raid_conf;
@@ -1571,7 +1571,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	mdk_rdev_t *rdev;
 
 
-	for (i=0 ; i<disks; i++)
+	for (i = 0; i < disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
 
@@ -1650,7 +1650,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 
-	for (i=0 ; i<disks; i++)
+	for (i = 0; i < disks; i++)
 		if (bi == &sh->dev[i].req)
 			break;
 
@@ -1666,7 +1666,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 		md_error(conf->mddev, conf->disks[i].rdev);
 
 	rdev_dec_pending(conf->disks[i].rdev, conf->mddev);
-	
+
 	clear_bit(R5_LOCKED, &sh->dev[i].flags);
 	set_bit(STRIPE_HANDLE, &sh->state);
 	release_stripe(sh);
@@ -1674,7 +1674,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 
 
 static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
-	
+
 static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 {
 	struct r5dev *dev = &sh->dev[i];
@@ -1761,7 +1761,7 @@ static sector_t raid5_compute_sector(raid5_conf_t *conf, sector_t r_sector,
 	 * Select the parity disk based on the user selected algorithm.
 	 */
 	pd_idx = qd_idx = ~0;
-	switch(conf->level) {
+	switch (conf->level) {
 	case 4:
 		pd_idx = data_disks;
 		break;
@@ -1951,8 +1951,9 @@ static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
 
 	if (i == sh->pd_idx)
 		return 0;
-	switch(conf->level) {
-	case 4: break;
+	switch (conf->level) {
+	case 4:
+		break;
 	case 5:
 		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
@@ -2141,7 +2142,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 {
 	struct bio **bip;
 	raid5_conf_t *conf = sh->raid_conf;
-	int firstwrite=0;
+	int firstwrite = 0;
 
 	pr_debug("adding bh b#%llu to stripe s#%llu\n",
 		(unsigned long long)bi->bi_sector,
@@ -2159,7 +2160,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
 		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
 			goto overlap;
-		bip = & (*bip)->bi_next;
+		bip = &(*bip)->bi_next;
 	}
 	if (*bip && (*bip)->bi_sector < bi->bi_sector + ((bi->bi_size)>>9))
 		goto overlap;
@@ -2186,12 +2187,12 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	if (forwrite) {
 		/* check if page is covered */
 		sector_t sector = sh->dev[dd_idx].sector;
-		for (bi=sh->dev[dd_idx].towrite;
+		for (bi = sh->dev[dd_idx].towrite;
 		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_sector <= sector;
 		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
-			if (bi->bi_sector + (bi->bi_size>>9) >= sector)
-				sector = bi->bi_sector + (bi->bi_size>>9);
+			if (bi->bi_sector + (bi->bi_size >> 9) >= sector)
+				sector = bi->bi_sector + (bi->bi_size >> 9);
 		}
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
@@ -2268,7 +2269,8 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 		/* and fail all 'written' */
 		bi = sh->dev[i].written;
 		sh->dev[i].written = NULL;
-		if (bi) bitmap_end = 1;
+		if (bi)
+			bitmap_end = 1;
 		while (bi && bi->bi_sector <
 		       sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
@@ -2291,7 +2293,8 @@ handle_failed_stripe(raid5_conf_t *conf, struct stripe_head *sh,
 			sh->dev[i].toread = NULL;
 			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 				wake_up(&conf->wait_for_overlap);
-			if (bi) s->to_read--;
+			if (bi)
+				s->to_read--;
 			while (bi && bi->bi_sector <
 			       sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *nextbi =
@@ -2561,9 +2564,10 @@ static void handle_stripe_dirtying5(raid5_conf_t *conf,
 		    !test_bit(R5_LOCKED, &dev->flags) &&
 		    !(test_bit(R5_UPTODATE, &dev->flags) ||
 		    test_bit(R5_Wantcompute, &dev->flags))) {
-			if (test_bit(R5_Insync, &dev->flags)) rcw++;
+			if (test_bit(R5_Insync, &dev->flags))
+				rcw++;
 			else
-				rcw += 2*disks;
+				rcw += 2 * disks;
 		}
 	}
 	pr_debug("for sector %llu, rmw=%d rcw=%d\n",
@@ -3033,7 +3037,7 @@ static void handle_stripe5(struct stripe_head *sh)
 
 	/* Now to look around and see what can be done */
 	rcu_read_lock();
-	for (i=disks; i--; ) {
+	for (i = disks; i--; ) {
 		mdk_rdev_t *rdev;
 
 		dev = &sh->dev[i];
@@ -3052,9 +3056,12 @@ static void handle_stripe5(struct stripe_head *sh)
 			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
-		if (test_bit(R5_Wantcompute, &dev->flags)) s.compute++;
+		if (test_bit(R5_LOCKED, &dev->flags))
+			s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags))
+			s.uptodate++;
+		if (test_bit(R5_Wantcompute, &dev->flags))
+			s.compute++;
 
 		if (test_bit(R5_Wantfill, &dev->flags))
 			s.to_fill++;
@@ -3120,10 +3127,10 @@ static void handle_stripe5(struct stripe_head *sh)
 	/* check if the array has lost two devices and, if so, some requests might
 	 * need to be failed
 	 */
-	if (s.failed > 1 && s.to_read+s.to_write+s.written)
+	if (s.failed > 1 && s.to_read + s.to_write + s.written)
 		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
 	if (s.failed > 1 && s.syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		s.syncing = 0;
 	}
@@ -3132,7 +3139,7 @@ static void handle_stripe5(struct stripe_head *sh)
 	 * is safe, or on a failed drive
 	 */
 	dev = &sh->dev[sh->pd_idx];
-	if ( s.written &&
+	if (s.written &&
 	     ((test_bit(R5_Insync, &dev->flags) &&
 	       !test_bit(R5_LOCKED, &dev->flags) &&
 	       test_bit(R5_UPTODATE, &dev->flags)) ||
@@ -3199,7 +3206,7 @@ static void handle_stripe5(struct stripe_head *sh)
 		handle_parity_checks5(conf, sh, &s, disks);
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 
@@ -3324,7 +3331,7 @@ static void handle_stripe6(struct stripe_head *sh)
 	/* Now to look around and see what can be done */
 
 	rcu_read_lock();
-	for (i=disks; i--; ) {
+	for (i = disks; i--; ) {
 		mdk_rdev_t *rdev;
 		dev = &sh->dev[i];
 
@@ -3340,8 +3347,10 @@ static void handle_stripe6(struct stripe_head *sh)
 			set_bit(R5_Wantfill, &dev->flags);
 
 		/* now count some things */
-		if (test_bit(R5_LOCKED, &dev->flags)) s.locked++;
-		if (test_bit(R5_UPTODATE, &dev->flags)) s.uptodate++;
+		if (test_bit(R5_LOCKED, &dev->flags))
+			s.locked++;
+		if (test_bit(R5_UPTODATE, &dev->flags))
+			s.uptodate++;
 		if (test_bit(R5_Wantcompute, &dev->flags)) {
 			s.compute++;
 			BUG_ON(s.compute > 2);
@@ -3412,10 +3421,10 @@ static void handle_stripe6(struct stripe_head *sh)
 	/* check if the array has lost >2 devices and, if so, some requests
 	 * might need to be failed
 	 */
-	if (s.failed > 2 && s.to_read+s.to_write+s.written)
+	if (s.failed > 2 && s.to_read + s.to_write + s.written)
 		handle_failed_stripe(conf, sh, &s, disks, &return_bi);
 	if (s.failed > 2 && s.syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 		s.syncing = 0;
 	}
@@ -3431,11 +3440,11 @@ static void handle_stripe6(struct stripe_head *sh)
 	r6s.q_failed = (s.failed >= 1 && r6s.failed_num[0] == qd_idx)
 		|| (s.failed >= 2 && r6s.failed_num[1] == qd_idx);
 
-	if ( s.written &&
-	     ( r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
+	if (s.written &&
+	     (r6s.p_failed || ((test_bit(R5_Insync, &pdev->flags)
 			     && !test_bit(R5_LOCKED, &pdev->flags)
 			     && test_bit(R5_UPTODATE, &pdev->flags)))) &&
-	     ( r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
+	     (r6s.q_failed || ((test_bit(R5_Insync, &qdev->flags)
 			     && !test_bit(R5_LOCKED, &qdev->flags)
 			     && test_bit(R5_UPTODATE, &qdev->flags)))))
 		handle_stripe_clean_event(conf, sh, disks, &return_bi);
@@ -3498,7 +3507,7 @@ static void handle_stripe6(struct stripe_head *sh)
 		handle_parity_checks6(conf, sh, &s, &r6s, disks);
 
 	if (s.syncing && s.locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
 	}
 
@@ -3682,7 +3691,8 @@ static int raid5_mergeable_bvec(struct request_queue *q,
 	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
 		chunk_sectors = mddev->new_chunk_sectors;
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
-	if (max < 0) max = 0;
+	if (max < 0)
+		max = 0;
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
 	else
@@ -3706,7 +3716,7 @@ static int in_chunk_boundary(mddev_t *mddev, struct bio *bio)
  *  add bio to the retry LIFO  ( in O(1) ... we are in interrupt )
  *  later sampled by raid5d.
  */
-static void add_bio_to_retry(struct bio *bi,raid5_conf_t *conf)
+static void add_bio_to_retry(struct bio *bi, raid5_conf_t *conf)
 {
 	unsigned long flags;
 
@@ -3730,7 +3740,7 @@ static struct bio *remove_bio_from_retry(raid5_conf_t *conf)
 		return bi;
 	}
 	bi = conf->retry_read_aligned_list;
-	if(bi) {
+	if (bi) {
 		conf->retry_read_aligned_list = bi->bi_next;
 		bi->bi_next = NULL;
 		/*
@@ -3752,7 +3762,7 @@ static struct bio *remove_bio_from_retry(raid5_conf_t *conf)
  */
 static void raid5_align_endio(struct bio *bi, int error)
 {
-	struct bio* raid_bi  = bi->bi_private;
+	struct bio *raid_bi  = bi->bi_private;
 	mddev_t *mddev;
 	raid5_conf_t *conf;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
@@ -3760,7 +3770,7 @@ static void raid5_align_endio(struct bio *bi, int error)
 
 	bio_put(bi);
 
-	rdev = (void*)raid_bi->bi_next;
+	rdev = (void *)raid_bi->bi_next;
 	raid_bi->bi_next = NULL;
 	mddev = rdev->mddev;
 	conf = mddev->private;
@@ -3804,7 +3814,7 @@ static int chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio)
 {
 	raid5_conf_t *conf = mddev->private;
 	int dd_idx;
-	struct bio* align_bi;
+	struct bio *align_bi;
 	mdk_rdev_t *rdev;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
@@ -3835,7 +3845,7 @@ static int chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio)
 	if (rdev && test_bit(In_sync, &rdev->flags)) {
 		atomic_inc(&rdev->nr_pending);
 		rcu_read_unlock();
-		raid_bio->bi_next = (void*)rdev;
+		raid_bio->bi_next = (void *)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 		align_bi->bi_sector += rdev->data_offset;
@@ -3936,7 +3946,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
-	     chunk_aligned_read(mddev,bi))
+	     chunk_aligned_read(mddev, bi))
 		return 0;
 
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
@@ -3945,7 +3955,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
 	plugged = mddev_check_plugged(mddev);
-	for (;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
+	for ( ;logical_sector < last_sector; logical_sector += STRIPE_SECTORS) {
 		DEFINE_WAIT(w);
 		int disks, data_disks;
 		int previous;
@@ -3986,7 +3996,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 						  previous,
 						  &dd_idx, NULL);
 		pr_debug("raid456: make_request, sector %llu logical %llu\n",
-			(unsigned long long)new_sector, 
+			(unsigned long long)new_sector,
 			(unsigned long long)logical_sector);
 
 		sh = get_active_stripe(conf, new_sector, previous,
@@ -4057,7 +4067,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 			finish_wait(&conf->wait_for_overlap, &w);
 			break;
 		}
-			
+
 	}
 	if (!plugged)
 		md_wakeup_thread(mddev->thread);
@@ -4067,7 +4077,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 	spin_unlock_irq(&conf->device_lock);
 	if (remaining == 0) {
 
-		if ( rw == WRITE )
+		if (rw == WRITE)
 			md_write_end(mddev);
 
 		bio_endio(bi, 0);
@@ -4176,7 +4186,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Cannot proceed until we've updated the superblock... */
 		wait_event(conf->wait_for_overlap,
-			   atomic_read(&conf->reshape_stripes)==0);
+			   atomic_read(&conf->reshape_stripes) == 0);
 		mddev->reshape_position = conf->reshape_progress;
 		mddev->curr_resync_completed = sector_nr;
 		conf->reshape_checkpoint = jiffies;
@@ -4212,7 +4222,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 		/* If any of this stripe is beyond the end of the old
 		 * array, then we need to zero those blocks
 		 */
-		for (j=sh->disks; j--;) {
+		for (j = sh->disks; j--;) {
 			sector_t s;
 			if (j == sh->pd_idx)
 				continue;
@@ -4503,7 +4513,7 @@ static void raid5d(mddev_t *mddev)
 		if (!sh)
 			break;
 		spin_unlock_irq(&conf->device_lock);
-		
+
 		handled++;
 		handle_stripe(sh);
 		release_stripe(sh);
@@ -4551,7 +4561,8 @@ raid5_set_cache_size(mddev_t *mddev, int size)
 	while (size > conf->max_nr_stripes) {
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;
-		else break;
+		else
+			break;
 	}
 	return 0;
 }
@@ -4919,7 +4930,7 @@ static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded
 			return 1;
 		break;
 	case ALGORITHM_PARITY_0_6:
-		if (raid_disk == 0 || 
+		if (raid_disk == 0 ||
 		    raid_disk == raid_disks - 1)
 			return 1;
 		break;
@@ -4988,7 +4999,7 @@ static int run(mddev_t *mddev)
 			 * readonly mode so it can take control before
 			 * allowing any writes.  So just check for that.
 			 */
-			if ((here_new * mddev->new_chunk_sectors != 
+			if ((here_new * mddev->new_chunk_sectors !=
 			     here_old * mddev->chunk_sectors) ||
 			    mddev->ro == 0) {
 				printk(KERN_ERR "md/raid:%s: in-place reshape must be started"
@@ -5051,7 +5062,7 @@ static int run(mddev_t *mddev)
 		if (mddev->major_version == 0 &&
 		    mddev->minor_version > 90)
 			rdev->recovery_offset = reshape_offset;
-			
+
 		if (rdev->recovery_offset < reshape_offset) {
 			/* We need to check old and new layout */
 			if (!only_parity(rdev->raid_disk,
@@ -5642,7 +5653,7 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 {
 	raid5_conf_t *conf = mddev->private;
 
-	switch(state) {
+	switch (state) {
 	case 2: /* resume for a suspend */
 		wake_up(&conf->wait_for_overlap);
 		break;
@@ -5911,8 +5922,7 @@ static void *raid6_takeover(mddev_t *mddev)
 }
 
 
-static struct mdk_personality raid6_personality =
-{
+static struct mdk_personality raid6_personality = {
 	.name		= "raid6",
 	.level		= 6,
 	.owner		= THIS_MODULE,
@@ -5933,8 +5943,7 @@ static struct mdk_personality raid6_personality =
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
 };
-static struct mdk_personality raid5_personality =
-{
+static struct mdk_personality raid5_personality = {
 	.name		= "raid5",
 	.level		= 5,
 	.owner		= THIS_MODULE,
@@ -5956,8 +5965,7 @@ static struct mdk_personality raid5_personality =
 	.takeover	= raid5_takeover,
 };
 
-static struct mdk_personality raid4_personality =
-{
+static struct mdk_personality raid4_personality = {
 	.name		= "raid4",
 	.level		= 4,
 	.owner		= THIS_MODULE,
-- 
1.7.4.1

