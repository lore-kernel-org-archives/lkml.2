Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab0IGThl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:37:41 -0400
Received: from ns2.cypress.com ([157.95.67.5]:40956 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0IGThi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:37:38 -0400
Subject: Re: [PATCH] west bridge, block driver fixes
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Cypress
Date: Tue, 07 Sep 2010 12:37:33 -0700
Message-Id: <1283888253.7250.21.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes minor fixes to the block driver for locking issues,
printk statements and minor change for a kernel update to 2.6.36.
Please let me know if there are issues or concerns with this patch.
Thanks,
David

Signed-off-by: David Cross <david.cross@cypress.com>

diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2010-09-07 11:28:49.000000000 -0700
@@ -202,7 +202,7 @@ static struct cyasblkdev_blk_data *cyasb
 	if (bd) {
 		bd->usage++;
 		#ifndef NBDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"cyasblkdev_blk_get: usage = %d\n", bd->usage) ;
 		#endif
 	}
@@ -222,12 +222,12 @@ static void cyasblkdev_blk_put(
 	if (bd) {
 		bd->usage--;
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			" cyasblkdev_blk_put , bd->usage= %d\n", bd->usage);
 		#endif
 	} else  {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"cyasblkdev: blk_put(bd) on bd = NULL!: usage = %d\n",
 			bd->usage);
 		#endif
@@ -244,7 +244,7 @@ static void cyasblkdev_blk_put(
 		if (CY_AS_ERROR_SUCCESS !=
 			cy_as_storage_release(bd->dev_handle, 0, 0, 0, 0)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 				"cyasblkdev: cannot release bus 0\n") ;
 			#endif
 		}
@@ -252,7 +252,7 @@ static void cyasblkdev_blk_put(
 		if (CY_AS_ERROR_SUCCESS !=
 			cy_as_storage_release(bd->dev_handle, 1, 0, 0, 0)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 				"cyasblkdev: cannot release bus 1\n") ;
 			#endif
 		}
@@ -260,7 +260,7 @@ static void cyasblkdev_blk_put(
 		if (CY_AS_ERROR_SUCCESS !=
 			cy_as_storage_stop(bd->dev_handle, 0, 0)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 				"cyasblkdev: cannot stop storage stack\n") ;
 			#endif
 		}
@@ -278,7 +278,7 @@ static void cyasblkdev_blk_put(
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	printk(KERN_INFO
 		"cyasblkdev (blk_put): usage = %d\n",
 		bd->usage) ;
 	#endif
@@ -304,7 +304,7 @@ static int cyasblkdev_blk_open(
 		if (bdev->bd_disk == bd->user_disk_0) {
 			if ((mode & FMODE_WRITE) && bd->user_disk_0_read_only) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 					"device marked as readonly "
 					"and write requested\n");
 				#endif
@@ -315,7 +315,7 @@ static int cyasblkdev_blk_open(
 		} else if (bdev->bd_disk == bd->user_disk_1) {
 			if ((mode & FMODE_WRITE) && bd->user_disk_1_read_only) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 					"device marked as readonly "
 					"and write requested\n");
 				#endif
@@ -326,7 +326,7 @@ static int cyasblkdev_blk_open(
 		} else if (bdev->bd_disk == bd->system_disk) {
 			if ((mode & FMODE_WRITE) && bd->system_disk_read_only) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 					"device marked as readonly "
 					"and write requested\n");
 				#endif
@@ -389,14 +389,14 @@ int cyasblkdev_media_changed(struct gend
 	struct cyasblkdev_blk_data *bd;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cyasblkdev_media_changed() is called\n");
+	printk(KERN_INFO "cyasblkdev_media_changed() is called\n");
 	#endif
 
 	if (gd)
 		bd = gd->private_data;
 	else {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"cyasblkdev_media_changed() is called, "
 			"but gd is null\n");
 		#endif
@@ -415,7 +415,7 @@ int cyasblkdev_revalidate_disk(struct ge
 
 	#ifndef WESTBRIDGE_NDEBUG
 	if (gd)
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"cyasblkdev_revalidate_disk() is called, "
 			"(gl_bd->usage:%d)\n", gl_bd->usage);
 	#endif
@@ -452,7 +452,7 @@ static int cyasblkdev_blk_prep_rq(
 	/* If we have no device, we haven't finished initialising. */
 	if (!bd || !bd->dev_handle) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(KERN_ERR
+		printk(KERN_ERR
 			"cyasblkdev %s: killing request - no device/host\n",
 			req->rq_disk->disk_name);
 		#endif
@@ -466,7 +466,7 @@ static int cyasblkdev_blk_prep_rq(
 
 	/* Check for excessive requests.*/
 	if (blk_rq_pos(req) + blk_rq_sectors(req) > get_capacity(req->rq_disk)) {
-		cy_as_hal_print_message("cyasblkdev: bad request address\n");
+		printk(KERN_INFO "cyasblkdev: bad request address\n");
 		stat = BLKPREP_KILL;
 	}
 
@@ -496,20 +496,23 @@ static void cyasblkdev_issuecallback(
 
 	if (status != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 		  "%s: async r/w: op:%d failed with error %d at address %d\n",
 			__func__, op, status, block_number) ;
 		#endif
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	printk(KERN_INFO
 		"%s calling blk_end_request from issue_callback "
 		"req=0x%x, status=0x%x, nr_sectors=0x%x\n",
 		__func__, (unsigned int) gl_bd->queue.req, status,
 		(unsigned int) blk_rq_sectors(gl_bd->queue.req)) ;
 	#endif
 
+	if (rq_data_dir(gl_bd->queue.req) != READ)
+		cy_as_release_common_lock();
+
 	/* note: blk_end_request w/o __ prefix should
 	 * not require spinlocks on the queue*/
 	while (blk_end_request(gl_bd->queue.req,
@@ -518,7 +521,7 @@ static void cyasblkdev_issuecallback(
 	};
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	printk(KERN_INFO
 		"%s blkdev_callback: ended rq on %d sectors, "
 		"with err:%d, n:%d times\n", __func__,
 		(int)blk_rq_sectors(gl_bd->queue.req), status,
@@ -533,7 +536,7 @@ static void cyasblkdev_issuecallback(
 		/* queue is not plugged */
 		gl_bd->queue.req = blk_fetch_request(gl_bd->queue.queue);
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s blkdev_callback: "
+		printk(KERN_INFO "%s blkdev_callback: "
 		"blk_fetch_request():%p\n",
 			__func__, gl_bd->queue.req);
 		#endif
@@ -543,7 +546,7 @@ static void cyasblkdev_issuecallback(
 		spin_unlock_irq(&gl_bd->lock);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s blkdev_callback: about to "
+		printk(KERN_INFO "%s blkdev_callback: about to "
 		"call issue_fn:%p\n", __func__, gl_bd->queue.req);
 		#endif
 
@@ -585,7 +588,7 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->user_disk_0_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to disk 0 "
+		printk(KERN_INFO "%s: request made to disk 0 "
 			"for sector=%d, num_sectors=%d, unit_no=%d\n",
 			__func__, req_sector, (int) blk_rq_sectors(req),
 			lcl_unit_no);
@@ -598,7 +601,7 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->user_disk_1_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to disk 1 for "
+		printk(KERN_INFO "%s: request made to disk 1 for "
 			"sector=%d, num_sectors=%d, unit_no=%d\n", __func__,
 			req_sector, (int) blk_rq_sectors(req), lcl_unit_no);
 		#endif
@@ -609,14 +612,14 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->system_disk_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to system disk "
+		printk(KERN_INFO "%s: request made to system disk "
 			"for sector=%d, num_sectors=%d, unit_no=%d\n", __func__,
 			req_sector, (int) blk_rq_sectors(req), lcl_unit_no);
 		#endif
 	}
 	#ifndef WESTBRIDGE_NDEBUG
 	else {
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: invalid disk used for request\n", __func__);
 	}
 	#endif
@@ -625,7 +628,7 @@ static int cyasblkdev_blk_issue_rq(
 
 	if (rq_data_dir(req) == READ) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: calling readasync() "
+		printk(KERN_INFO "%s: calling readasync() "
 			"req_sector=0x%x, req_nr_sectors=0x%x, bd->sg:%x\n\n",
 			__func__, req_sector, req_nr_sectors, (uint32_t)bd->sg);
 		#endif
@@ -636,10 +639,10 @@ static int cyasblkdev_blk_issue_rq(
 
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s:readasync() error %d at "
+			printk(KERN_INFO "%s:readasync() error %d at "
 				"address %ld, unit no %d\n", __func__, ret,
 				blk_rq_pos(req), lcl_unit_no);
-			cy_as_hal_print_message("%s:ending i/o request "
+			printk(KERN_INFO "%s:ending i/o request "
 				"on reg:%x\n", __func__, (uint32_t)req);
 			#endif
 
@@ -651,13 +654,14 @@ static int cyasblkdev_blk_issue_rq(
 			bq->req = NULL ;
 		}
 	} else {
+		cy_as_acquire_common_lock();
 		ret = cy_as_storage_write_async(bd->dev_handle, bus_num, 0,
 			lcl_unit_no, req_sector, bd->sg, req_nr_sectors,
 			(cy_as_storage_callback)cyasblkdev_issuecallback);
 
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: write failed with "
+			printk(KERN_INFO "%s: write failed with "
 			"error %d at address %ld, unit no %d\n",
 			__func__, ret, blk_rq_pos(req), lcl_unit_no);
 			#endif
@@ -690,7 +694,7 @@ static void cyasblkdev_storage_callback(
 					)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: bus:%d, device:%d, evtype:%d, "
+	printk(KERN_INFO "%s: bus:%d, device:%d, evtype:%d, "
 	"evdata:%p\n ", __func__, bus, device, evtype, evdata);
 	#endif
 
@@ -740,13 +744,13 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 	* code and ,0x55AA) is found
 	*/
 	#ifndef WESTBRIDGE_NDEBUG
-	  cy_as_hal_print_message(
+	  printk(KERN_INFO
 		"%s scanning media for vfat partition...\n", __func__) ;
 	#endif
 
 	for (sect_no = 0; sect_no < SECTORS_TO_SCAN; sect_no++) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s before cyasstorageread "
+		printk(KERN_INFO "%s before cyasstorageread "
 			"gl_bd->sg addr=0x%x\n", __func__,
 			(unsigned int) gl_bd->sg);
 		#endif
@@ -774,7 +778,7 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 			 * sector 0, check it first  */
 			if (sect_buf[0] == 0xEB) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 					"%s vfat partition found "
 					"at sector:%d\n",
 					__func__, sect_no);
@@ -787,8 +791,8 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 
 		if (stat != 0) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s sector scan error\n",
-				__func__);
+			printk(KERN_INFO "%s sector scan error: %d\n",
+				__func__, stat);
 			#endif
 			break;
 		}
@@ -800,7 +804,7 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 		return sect_no;
 	} else {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s vfat partition is not found, using 0 offset\n",
 			__func__);
 		#endif
@@ -821,7 +825,7 @@ static int cyasblkdev_add_disks(int bus_
 	cy_as_storage_query_unit_data unit_data = {0} ;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s:query device: "
+		printk(KERN_INFO "%s:query device: "
 		"type:%d, removable:%d, writable:%d, "
 		"blksize %d, units:%d, locked:%d, "
 		"erase_sz:%d\n",
@@ -839,14 +843,14 @@ static int cyasblkdev_add_disks(int bus_
 	/*  make sure that device is not locked  */
 	if (dev_data.desc_p.locked) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: device is locked\n", __func__);
 		#endif
 		ret = cy_as_storage_release(
 			bd->dev_handle, bus_num, 0, 0, 0) ;
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s cannot release"
+			printk(KERN_INFO "%s cannot release"
 				" storage\n", __func__) ;
 			#endif
 			goto out;
@@ -861,7 +865,7 @@ static int cyasblkdev_add_disks(int bus_
 		&unit_data, 0, 0) ;
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cannot query "
+		printk(KERN_INFO "%s: cannot query "
 			"%d device unit - reason code %d\n",
 			__func__, bus_num, ret) ;
 		#endif
@@ -876,7 +880,7 @@ static int cyasblkdev_add_disks(int bus_
 			if ((ret != CY_AS_ERROR_SUCCESS) &&
 			(ret != CY_AS_ERROR_ALREADY_PARTITIONED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("%s: cy_as_storage_"
+				printk(KERN_INFO "%s: cy_as_storage_"
 				"create_p_partition after size > 0 check "
 				"failed with error code %d\n",
 				__func__, ret);
@@ -888,7 +892,7 @@ static int cyasblkdev_add_disks(int bus_
 
 			} else if (ret == CY_AS_ERROR_ALREADY_PARTITIONED) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 				"%s: cy_as_storage_create_p_partition "
 				"indicates memory already partitioned\n",
 				__func__);
@@ -911,7 +915,7 @@ static int cyasblkdev_add_disks(int bus_
 							unit_data.unit = 1 ;
 						} else {
 							#ifndef WESTBRIDGE_NDEBUG
-							cy_as_hal_print_message(
+							printk(KERN_INFO
 							"%s: cy_as_storage_create_p_partition "
 							"after removal unexpectedly failed "
 							"with error %d\n", __func__, ret) ;
@@ -932,7 +936,7 @@ static int cyasblkdev_add_disks(int bus_
 						&unit_data, 0, 0) ;
 						if (ret != CY_AS_ERROR_SUCCESS) {
 							#ifndef WESTBRIDGE_NDEBUG
-							cy_as_hal_print_message(
+							printk(KERN_INFO
 							"%s: cannot query %d "
 							"device unit - reason code %d\n",
 							__func__, bus_num, ret) ;
@@ -946,7 +950,7 @@ static int cyasblkdev_add_disks(int bus_
 						}
 					} else {
 					#ifndef WESTBRIDGE_NDEBUG
-					cy_as_hal_print_message(
+					printk(KERN_INFO
 					"%s: cy_as_storage_remove_p_partition "
 					"failed with error %d\n",
 					__func__, ret);
@@ -960,7 +964,7 @@ static int cyasblkdev_add_disks(int bus_
 							bd->dev_handle, &unit_data, 0, 0) ;
 						if (ret != CY_AS_ERROR_SUCCESS) {
 						#ifndef WESTBRIDGE_NDEBUG
-							cy_as_hal_print_message(
+							printk(KERN_INFO
 							"%s: cannot query %d "
 							"device unit - reason "
 							"code %d\n", __func__,
@@ -976,7 +980,7 @@ static int cyasblkdev_add_disks(int bus_
 					}
 				} else {
 					#ifndef WESTBRIDGE_NDEBUG
-					cy_as_hal_print_message("%s: partition "
+					printk(KERN_INFO "%s: partition "
 						"exists and sizes equal\n",
 						__func__);
 					#endif
@@ -991,7 +995,7 @@ static int cyasblkdev_add_disks(int bus_
 						bd->dev_handle, &unit_data, 0, 0) ;
 					if (ret != CY_AS_ERROR_SUCCESS) {
 					#ifndef WESTBRIDGE_NDEBUG
-						cy_as_hal_print_message(
+						printk(KERN_INFO
 							"%s: cannot query %d "
 							"device unit "
 							"- reason code %d\n",
@@ -1006,7 +1010,7 @@ static int cyasblkdev_add_disks(int bus_
 				}
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 				"%s: cy_as_storage_create_p_partition "
 				"created successfully\n", __func__);
 				#endif
@@ -1020,7 +1024,7 @@ static int cyasblkdev_add_disks(int bus_
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else {
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 			"%s: invalid partition_size%d\n", __func__,
 			private_partition_size);
 
@@ -1041,7 +1045,7 @@ static int cyasblkdev_add_disks(int bus_
 			"cyasblkdevblk%d", devidx);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: disk unit_sz:%lu blk_sz:%d, "
 			"start_blk:%lu, capacity:%llu\n",
 			__func__, (unsigned long)
@@ -1054,13 +1058,13 @@ static int cyasblkdev_add_disks(int bus_
 		#endif
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: setting gendisk disk "
+		printk(KERN_INFO "%s: setting gendisk disk "
 			"capacity to %d\n", __func__, (int) disk_cap);
 		#endif
 
 		/* initializing bd->queue */
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: init bd->queue\n",
+		printk(KERN_INFO "%s: init bd->queue\n",
 			__func__);
 		#endif
 
@@ -1102,7 +1106,7 @@ static int cyasblkdev_add_disks(int bus_
 			disk_cap);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: returned from set_capacity %d\n",
 			__func__, (int) disk_cap);
 		#endif
@@ -1111,65 +1115,66 @@ static int cyasblkdev_add_disks(int bus_
 		 * public partition beginning */
 		if (vfat_search) {
 			bd->user_disk_0_first_sector =
-				cyasblkdev_get_vfat_offset(0,
+				cyasblkdev_get_vfat_offset(
+					bd->user_disk_0_bus_num,
 					bd->user_disk_0_unit_no);
 		} else {
 			bd->user_disk_0_first_sector = 0;
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: set user_disk_0_first "
 			"sector to %d\n", __func__,
 			 bd->user_disk_0_first_sector);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: disk->major=0x%x\n",
 			__func__,
 			bd->user_disk_0->major);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->first_minor=0x%x\n", __func__,
 			bd->user_disk_0->first_minor);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->minors=0x%x\n", __func__,
 			bd->user_disk_0->minors);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->disk_name=%s\n",
 			__func__,
 			bd->user_disk_0->disk_name);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->part_tbl=0x%x\n", __func__,
 			(unsigned int)
 			bd->user_disk_0->part_tbl);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->queue=0x%x\n", __func__,
 			(unsigned int)
 			bd->user_disk_0->queue);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->flags=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->flags);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->driverfs_dev=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->driverfs_dev);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->slave_dir=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->slave_dir);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->random=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->random);
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: add_disk: "
 			"disk->node_id=0x%x\n",
 			__func__, (unsigned int)
@@ -1198,7 +1203,7 @@ static int cyasblkdev_add_disks(int bus_
 			"cyasblkdevblk%d", (devidx + 1));
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		printk(KERN_INFO
 			"%s: disk unit_sz:%lu "
 			"blk_sz:%d, "
 			"start_blk:%lu, "
@@ -1224,7 +1229,7 @@ static int cyasblkdev_add_disks(int bus_
 			blk_queue_logical_block_size(bd->queue.queue,
 				bd->user_disk_0_blk_size);
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 			"%s: set hard sect_sz:%d\n",
 			__func__,
 			bd->user_disk_0_blk_size);
@@ -1233,7 +1238,7 @@ static int cyasblkdev_add_disks(int bus_
 			blk_queue_logical_block_size(bd->queue.queue,
 				bd->user_disk_1_blk_size);
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 			"%s: set hard sect_sz:%d\n",
 			__func__,
 			bd->user_disk_1_blk_size);
@@ -1244,7 +1249,8 @@ static int cyasblkdev_add_disks(int bus_
 		if (vfat_search) {
 			bd->user_disk_1_first_sector =
 				cyasblkdev_get_vfat_offset(
-					1, bd->user_disk_1_unit_no);
+					bd->user_disk_1_bus_num,
+					bd->user_disk_1_unit_no);
 		} else {
 			bd->user_disk_1_first_sector
 				= 0;
@@ -1292,7 +1298,7 @@ static int cyasblkdev_add_disks(int bus_
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else {
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 				"%s: system disk already allocated %d\n",
 				__func__, bus_num) ;
 		}
@@ -1334,7 +1340,7 @@ static struct cyasblkdev_blk_data *cyasb
 		bd->dev_handle = cyasdevice_getdevhandle() ;
 		if (0 == bd->dev_handle) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 				"%s: get device failed\n", __func__) ;
 			#endif
 			ret = ENODEV ;
@@ -1342,7 +1348,7 @@ static struct cyasblkdev_blk_data *cyasb
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s west bridge device handle:%x\n",
+		printk(KERN_INFO "%s west bridge device handle:%x\n",
 			__func__, (uint32_t)bd->dev_handle);
 		#endif
 
@@ -1356,7 +1362,7 @@ static struct cyasblkdev_blk_data *cyasb
 		if ((stat != CY_AS_ERROR_SUCCESS) &&
 		(stat != CY_AS_ERROR_RESOURCE_NOT_OWNED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot release "
+			printk(KERN_INFO "%s: cannot release "
 				"resource bus 0 - reason code %d\n",
 				__func__, stat) ;
 			#endif
@@ -1366,7 +1372,7 @@ static struct cyasblkdev_blk_data *cyasb
 		if ((stat != CY_AS_ERROR_SUCCESS) &&
 		(stat != CY_AS_ERROR_RESOURCE_NOT_OWNED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot release "
+			printk(KERN_INFO "%s: cannot release "
 				"resource bus 0 - reason code %d\n",
 				__func__, stat) ;
 			#endif
@@ -1376,14 +1382,14 @@ static struct cyasblkdev_blk_data *cyasb
 		stat = cy_as_storage_start(bd->dev_handle, 0, 0x101) ;
 		if (stat != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot start storage "
+			printk(KERN_INFO "%s: cannot start storage "
 				"stack - reason code %d\n", __func__, stat) ;
 			#endif
 			goto out;
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: storage started:%d ok\n",
+		printk(KERN_INFO "%s: storage started:%d ok\n",
 			__func__, stat);
 		#endif
 
@@ -1391,7 +1397,7 @@ static struct cyasblkdev_blk_data *cyasb
 			cyasblkdev_storage_callback);
 		if (stat != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot register callback "
+			printk(KERN_INFO "%s: cannot register callback "
 				"- reason code %d\n", __func__, stat) ;
 			#endif
 			goto out;
@@ -1405,7 +1411,7 @@ static struct cyasblkdev_blk_data *cyasb
 					bd->media_count[bus_num];
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("%s: cannot query %d, "
+				printk(KERN_INFO "%s: cannot query %d, "
 					"reason code: %d\n",
 					__func__, bus_num, stat) ;
 				#endif
@@ -1415,7 +1421,7 @@ static struct cyasblkdev_blk_data *cyasb
 
 		if (total_media_count == 0) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			printk(KERN_INFO
 				"%s: no storage media was found\n", __func__) ;
 			#endif
 			goto out ;
@@ -1433,7 +1439,7 @@ static struct cyasblkdev_blk_data *cyasb
 			}
 			#ifndef WESTBRIDGE_NDEBUG
 			else {
-				cy_as_hal_print_message("%s: no available "
+				printk(KERN_INFO "%s: no available "
 					"gen_disk for disk 0, "
 					"physically inconsistent\n", __func__);
 			}
@@ -1453,7 +1459,7 @@ static struct cyasblkdev_blk_data *cyasb
 			}
 			#ifndef WESTBRIDGE_NDEBUG
 			else {
-				cy_as_hal_print_message("%s: no available "
+				printk(KERN_INFO "%s: no available "
 					"gen_disk for media, "
 					"physically inconsistent\n", __func__);
 			}
@@ -1461,13 +1467,13 @@ static struct cyasblkdev_blk_data *cyasb
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else if (total_media_count > 2) {
-			cy_as_hal_print_message("%s: count corrupted = 0x%d\n",
+			printk(KERN_INFO "%s: count corrupted = 0x%d\n",
 				__func__, total_media_count);
 		}
 		#endif
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: %d device(s) found\n",
+		printk(KERN_INFO "%s: %d device(s) found\n",
 			__func__, total_media_count) ;
 		#endif
 
@@ -1476,7 +1482,7 @@ static struct cyasblkdev_blk_data *cyasb
 			stat = cy_as_storage_claim(bd->dev_handle,
 				bus_num, 0, 0, 0) ;
 			if (stat != CY_AS_ERROR_SUCCESS) {
-				cy_as_hal_print_message("%s: cannot claim "
+				printk(KERN_INFO "%s: cannot claim "
 					"%d bus - reason code %d\n",
 					__func__, bus_num, stat) ;
 				goto out;
@@ -1492,13 +1498,13 @@ static struct cyasblkdev_blk_data *cyasb
 					total_media_count, devidx);
 			} else if (stat == CY_AS_ERROR_NO_SUCH_DEVICE) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 					"%s: no device on bus %d\n",
 					__func__, bus_num) ;
 				#endif
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				printk(KERN_INFO
 					"%s: cannot query %d device "
 					"- reason code %d\n",
 					__func__, bus_num, stat) ;
@@ -1511,7 +1517,7 @@ static struct cyasblkdev_blk_data *cyasb
 	}
 out:
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	printk(KERN_INFO
 		"%s: bd failed to initialize\n", __func__);
 	#endif
 
@@ -1533,7 +1539,7 @@ static int cyasblkdev_blk_initialize(voi
 
 	if (res < 0) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(KERN_WARNING
+		printk(KERN_WARNING
 			"%s unable to get major %d for cyasblkdev media: %d\n",
 			__func__, major, res);
 		#endif
@@ -1544,7 +1550,7 @@ static int cyasblkdev_blk_initialize(voi
 		major = res;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	printk(KERN_INFO
 		"%s cyasblkdev registered with major number: %d\n",
 		__func__, major) ;
 	#endif
@@ -1570,7 +1576,7 @@ static int __init cyasblkdev_blk_init(vo
 		return 0;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cyasblkdev init error:%d\n", res);
+	printk(KERN_INFO "cyasblkdev init error:%d\n", res);
 	#endif
 	return res;
 }
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-01 15:56:46.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2010-09-07 11:51:23.000000000 -0700
@@ -95,9 +95,9 @@ static int cyasblkdev_prep_request(
 	DBGPRN_FUNC_NAME;
 
 	/* we only like normal block requests.*/
-	if (!blk_fs_request(req)) {
+	if (req->cmd_type != REQ_TYPE_FS && !(req->cmd_flags & REQ_DISCARD)) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s:%x bad request received\n",
+		printk(KERN_INFO "%s:%x bad request received\n",
 			__func__, current->pid) ;
 		#endif
 
@@ -192,7 +192,7 @@ static int cyasblkdev_queue_thread(void 
 				"thread_sem->count=%d\n",
 				__func__, bq->thread_sem.count);
 			if (spin_is_locked(q->queue_lock)) {
-				cy_as_hal_print_message("%s: queue_lock "
+				printk(KERN_INFO "%s: queue_lock "
 				"is locked, need to release\n", __func__);
 				spin_unlock(q->queue_lock);
 
@@ -249,7 +249,7 @@ static int cyasblkdev_queue_thread(void 
 	complete_and_exit(&bq->thread_complete, 0);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: is finished\n", __func__) ;
+	printk(KERN_INFO "%s: is finished\n", __func__) ;
 	#endif
 
 	return 0;
@@ -274,7 +274,7 @@ static void cyasblkdev_request(struct re
 
 	if (!bq->req) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s wake_up(&bq->thread_wq)\n",
+		printk(KERN_INFO "%s wake_up(&bq->thread_wq)\n",
 			__func__);
 		#endif
 
@@ -282,7 +282,7 @@ static void cyasblkdev_request(struct re
 		wake_up(&bq->thread_wq);
 	} else {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: don't wake Q_thr, bq->req:%x\n",
+		printk(KERN_INFO "%s: don't wake Q_thr, bq->req:%x\n",
 			__func__, (uint32_t)bq->req);
 		#endif
 	}
diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h
--- linux-next-vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h	2010-08-31 19:32:51.000000000 -0700
+++ linux-next-incl-sdk/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h	2010-08-23 16:45:15.000000000 -0700
@@ -54,6 +54,8 @@ extern int cyasblkdev_init_queue(struct 
 extern void cyasblkdev_cleanup_queue(struct cyasblkdev_queue *);
 extern void cyasblkdev_queue_suspend(struct cyasblkdev_queue *);
 extern void cyasblkdev_queue_resume(struct cyasblkdev_queue *);
+extern void cy_as_acquire_common_lock(void);
+extern void cy_as_release_common_lock(void);
 
 extern cy_as_device_handle cyasdevice_getdevhandle(void) ;
 #define MOD_LOGS 1


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

