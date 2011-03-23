Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877Ab1CWNL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:11:27 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:45594 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab1CWNL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:11:26 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmxtMZ80VwmRVC9ACJPg==
X-RZG-CLASS-ID: mo00
Date: Wed, 23 Mar 2011 14:11:18 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hv: remove double newline in DPRINT functions
Message-ID: <20110323131118.GB6579@aepfle.de>
References: <20110322210207.GA17724@aepfle.de>
 <20110322210627.GB17724@aepfle.de>
 <20110322210850.GC17724@aepfle.de>
 <20110323130854.GA6579@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110323130854.GA6579@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove double newline in DPRINT* functions, the macro already adds a
newline.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 compile tested

 drivers/staging/hv/blkvsc_drv.c  |   70 +++++++++++++++++++--------------------
 drivers/staging/hv/hv_mouse.c    |    4 +-
 drivers/staging/hv/netvsc.c      |    2 -
 drivers/staging/hv/storvsc.c     |    8 ++--
 drivers/staging/hv/storvsc_drv.c |    2 -
 5 files changed, 43 insertions(+), 43 deletions(-)

Index: linux-2.6/drivers/staging/hv/blkvsc_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/blkvsc_drv.c
+++ linux-2.6/drivers/staging/hv/blkvsc_drv.c
@@ -405,7 +405,7 @@ static void blkvsc_shutdown(struct devic
 	if (!blkdev)
 		return;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_shutdown - users %d disk %s\n",
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_shutdown - users %d disk %s",
 		   blkdev->users, blkdev->gd->disk_name);
 
 	spin_lock_irqsave(&blkdev->lock, flags);
@@ -435,7 +435,7 @@ static int blkvsc_do_flush(struct block_
 {
 	struct blkvsc_request *blkvsc_req;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_flush()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_flush()");
 
 	if (blkdev->device_type != HARDDISK_TYPE)
 		return 0;
@@ -479,7 +479,7 @@ static int blkvsc_do_inquiry(struct bloc
 	unsigned char *buf;
 	unsigned char device_type;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_inquiry()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_inquiry()");
 
 	blkvsc_req = kmem_cache_alloc(blkdev->request_pool, GFP_KERNEL);
 	if (!blkvsc_req)
@@ -515,7 +515,7 @@ static int blkvsc_do_inquiry(struct bloc
 
 	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
 
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete - cond %d\n",
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete - cond %d",
 		   blkvsc_req, blkvsc_req->cond);
 
 	wait_event_interruptible(blkvsc_req->wevent, blkvsc_req->cond);
@@ -535,7 +535,7 @@ static int blkvsc_do_inquiry(struct bloc
 		blkdev->device_type = UNKNOWN_DEV_TYPE;
 	}
 
-	DPRINT_DBG(BLKVSC_DRV, "device type %d\n", device_type);
+	DPRINT_DBG(BLKVSC_DRV, "device type %d", device_type);
 
 	blkdev->device_id_len = buf[7];
 	if (blkdev->device_id_len > 64)
@@ -562,7 +562,7 @@ static int blkvsc_do_read_capacity(struc
 	unsigned char *buf;
 	struct scsi_sense_hdr sense_hdr;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity()");
 
 	blkdev->sector_size = 0;
 	blkdev->capacity = 0;
@@ -599,7 +599,7 @@ static int blkvsc_do_read_capacity(struc
 
 	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
 
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete - cond %d\n",
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete - cond %d",
 		   blkvsc_req, blkvsc_req->cond);
 
 	wait_event_interruptible(blkvsc_req->wevent, blkvsc_req->cond);
@@ -639,7 +639,7 @@ static int blkvsc_do_read_capacity16(str
 	unsigned char *buf;
 	struct scsi_sense_hdr sense_hdr;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity16()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity16()");
 
 	blkdev->sector_size = 0;
 	blkdev->capacity = 0;
@@ -676,7 +676,7 @@ static int blkvsc_do_read_capacity16(str
 
 	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
 
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete - cond %d\n",
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete - cond %d",
 		   blkvsc_req, blkvsc_req->cond);
 
 	wait_event_interruptible(blkvsc_req->wevent, blkvsc_req->cond);
@@ -727,7 +727,7 @@ static int blkvsc_remove(struct device *
 	unsigned long flags;
 	int ret;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_remove()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_remove()");
 
 	if (!storvsc_drv_obj->base.dev_rm)
 		return -1;
@@ -847,7 +847,7 @@ static int blkvsc_submit_request(struct
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
 		   "req %p type %s start_sector %lu count %ld offset %d "
-		   "len %d\n", blkvsc_req,
+		   "len %d", blkvsc_req,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long) blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
@@ -856,7 +856,7 @@ static int blkvsc_submit_request(struct
 #if 0
 	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
 		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
-			   "req %p pfn[%d] %llx\n",
+			   "req %p pfn[%d] %llx",
 			   blkvsc_req, i,
 			   blkvsc_req->request.data_buffer.pfn_array[i]);
 	}
@@ -911,7 +911,7 @@ static int blkvsc_do_request(struct bloc
 	int pending = 0;
 	struct blkvsc_request_group *group = NULL;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu\n", blkdev, req,
+	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu", blkdev, req,
 		  (unsigned long)blk_rq_pos(req));
 
 	/* Create a group to tie req to list of blkvsc_reqs */
@@ -933,7 +933,7 @@ static int blkvsc_do_request(struct bloc
 			bio_for_each_segment(bvec, bio, seg_idx) {
 				DPRINT_DBG(BLKVSC_DRV, "bio_for_each_segment() "
 					   "- req %p bio %p bvec %p seg_idx %d "
-					   "databuf_idx %d\n", req, bio, bvec,
+					   "databuf_idx %d", req, bio, bvec,
 					   seg_idx, databuf_idx);
 
 				/* Get a new storvsc request */
@@ -1013,7 +1013,7 @@ static int blkvsc_do_request(struct bloc
 
 	/* Handle the last one */
 	if (blkvsc_req) {
-		DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p group %p count %d\n",
+		DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p group %p count %d",
 			   blkdev, req, blkvsc_req->group,
 			   blkvsc_req->group->outstanding);
 
@@ -1031,7 +1031,7 @@ static int blkvsc_do_request(struct bloc
 		if (pending) {
 			DPRINT_DBG(BLKVSC_DRV, "adding blkvsc_req to "
 				   "pending_list - blkvsc_req %p start_sect %lu"
-				   " sect_count %ld (%lu %ld)\n", blkvsc_req,
+				   " sect_count %ld (%lu %ld)", blkvsc_req,
 				   (unsigned long)blkvsc_req->sector_start,
 				   blkvsc_req->sector_count,
 				   (unsigned long)start_sector,
@@ -1050,7 +1050,7 @@ static int blkvsc_do_request(struct bloc
 
 			DPRINT_DBG(BLKVSC_DRV, "submitted blkvsc_req %p "
 				   "start_sect %lu sect_count %ld (%lu %ld) "
-				   "ret %d\n", blkvsc_req,
+				   "ret %d", blkvsc_req,
 				   (unsigned long)blkvsc_req->sector_start,
 				   blkvsc_req->sector_count,
 				   (unsigned long)start_sector,
@@ -1069,7 +1069,7 @@ static void blkvsc_cmd_completion(struct
 			(struct block_device_context *)blkvsc_req->dev;
 	struct scsi_sense_hdr sense_hdr;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p\n",
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p",
 		   blkvsc_req);
 
 	blkdev->num_outstanding_reqs--;
@@ -1096,7 +1096,7 @@ static void blkvsc_request_completion(st
 
 	DPRINT_DBG(BLKVSC_DRV, "blkdev %p blkvsc_req %p group %p type %s "
 		   "sect_start %lu sect_count %ld len %d group outstd %d "
-		   "total outstd %d\n",
+		   "total outstd %d",
 		   blkdev, blkvsc_req, blkvsc_req->group,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long)blkvsc_req->sector_start,
@@ -1120,7 +1120,7 @@ static void blkvsc_request_completion(st
 					 &blkvsc_req->group->blkvsc_req_list,
 					 req_entry) {
 			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld\n",
+				   "sect_start %lu sect_count %ld",
 				   comp_req,
 				   (unsigned long)comp_req->sector_start,
 				   comp_req->sector_count);
@@ -1134,7 +1134,7 @@ static void blkvsc_request_completion(st
 				 * All the sectors have been xferred ie the
 				 * request is done
 				 */
-				DPRINT_DBG(BLKVSC_DRV, "req %p COMPLETED\n",
+				DPRINT_DBG(BLKVSC_DRV, "req %p COMPLETED",
 					   comp_req->req);
 				kmem_cache_free(blkdev->request_pool,
 						comp_req->group);
@@ -1174,7 +1174,7 @@ static int blkvsc_cancel_pending_reqs(st
 					 &pend_req->group->blkvsc_req_list,
 					 req_entry) {
 			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld\n",
+				   "sect_start %lu sect_count %ld",
 				   comp_req,
 				   (unsigned long) comp_req->sector_start,
 				   comp_req->sector_count);
@@ -1198,7 +1198,7 @@ static int blkvsc_cancel_pending_reqs(st
 			kmem_cache_free(blkdev->request_pool, comp_req);
 		}
 
-		DPRINT_DBG(BLKVSC_DRV, "cancelling pending request - %p\n",
+		DPRINT_DBG(BLKVSC_DRV, "cancelling pending request - %p",
 			   pend_req);
 
 		list_del(&pend_req->pend_entry);
@@ -1215,7 +1215,7 @@ static int blkvsc_cancel_pending_reqs(st
 				 */
 				DPRINT_DBG(BLKVSC_DRV,
 					   "blkvsc_cancel_pending_reqs() - "
-					   "req %p COMPLETED\n", pend_req->req);
+					   "req %p COMPLETED", pend_req->req);
 				kmem_cache_free(blkdev->request_pool,
 						pend_req->group);
 			}
@@ -1236,7 +1236,7 @@ static int blkvsc_do_pending_reqs(struct
 	/* Flush the pending list first */
 	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
 				 pend_entry) {
-		DPRINT_DBG(BLKVSC_DRV, "working off pending_list - %p\n",
+		DPRINT_DBG(BLKVSC_DRV, "working off pending_list - %p",
 			   pend_req);
 
 		ret = blkvsc_submit_request(pend_req,
@@ -1256,9 +1256,9 @@ static void blkvsc_request(struct reques
 	struct request *req;
 	int ret = 0;
 
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	DPRINT_DBG(BLKVSC_DRV, "- enter");
 	while ((req = blk_peek_request(queue)) != NULL) {
-		DPRINT_DBG(BLKVSC_DRV, "- req %p\n", req);
+		DPRINT_DBG(BLKVSC_DRV, "- req %p", req);
 
 		blkdev = req->rq_disk->private_data;
 		if (blkdev->shutting_down || req->cmd_type != REQ_TYPE_FS ||
@@ -1271,7 +1271,7 @@ static void blkvsc_request(struct reques
 
 		if (ret != 0) {
 			DPRINT_DBG(BLKVSC_DRV,
-				   "- stop queue - pending_list not empty\n");
+				   "- stop queue - pending_list not empty");
 			blk_stop_queue(queue);
 			break;
 		}
@@ -1280,11 +1280,11 @@ static void blkvsc_request(struct reques
 
 		ret = blkvsc_do_request(blkdev, req);
 		if (ret > 0) {
-			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no room\n");
+			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no room");
 			blk_stop_queue(queue);
 			break;
 		} else if (ret < 0) {
-			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no mem\n");
+			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no mem");
 			blk_requeue_request(queue, req);
 			blk_stop_queue(queue);
 			break;
@@ -1296,7 +1296,7 @@ static int blkvsc_open(struct block_devi
 {
 	struct block_device_context *blkdev = bdev->bd_disk->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
+	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s", blkdev->users,
 		   blkdev->gd->disk_name);
 
 	mutex_lock(&blkvsc_mutex);
@@ -1319,7 +1319,7 @@ static int blkvsc_release(struct gendisk
 {
 	struct block_device_context *blkdev = disk->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
+	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s", blkdev->users,
 		   blkdev->gd->disk_name);
 
 	mutex_lock(&blkvsc_mutex);
@@ -1339,7 +1339,7 @@ static int blkvsc_release(struct gendisk
 
 static int blkvsc_media_changed(struct gendisk *gd)
 {
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	DPRINT_DBG(BLKVSC_DRV, "- enter");
 	return 1;
 }
 
@@ -1347,7 +1347,7 @@ static int blkvsc_revalidate_disk(struct
 {
 	struct block_device_context *blkdev = gd->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	DPRINT_DBG(BLKVSC_DRV, "- enter");
 
 	if (blkdev->device_type == DVD_TYPE) {
 		blkvsc_do_read_capacity(blkdev);
@@ -1451,7 +1451,7 @@ static int blkvsc_ioctl(struct block_dev
 	 */
 #if 0
 	case HDIO_GET_IDENTITY:
-		DPRINT_INFO(BLKVSC_DRV, "HDIO_GET_IDENTITY\n");
+		DPRINT_INFO(BLKVSC_DRV, "HDIO_GET_IDENTITY");
 		if (copy_to_user((void __user *)arg, blkdev->device_id,
 				 blkdev->device_id_len))
 			ret = -EFAULT;
Index: linux-2.6/drivers/staging/hv/hv_mouse.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/hv_mouse.c
+++ linux-2.6/drivers/staging/hv/hv_mouse.c
@@ -917,13 +917,13 @@ static void reportdesc_callback(struct h
 			input_device_ctx->connected = 1;
 
 			DPRINT_INFO(INPUTVSC_DRV,
-				     "HID device claimed by input\n");
+				     "HID device claimed by input");
 		}
 
 		if (!hid_dev->claimed) {
 			DPRINT_ERR(INPUTVSC_DRV,
 				    "HID device not claimed by "
-				    "input or hiddev\n");
+				    "input or hiddev");
 		}
 
 		input_device_ctx->hid_device = hid_dev;
Index: linux-2.6/drivers/staging/hv/netvsc.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/netvsc.c
+++ linux-2.6/drivers/staging/hv/netvsc.c
@@ -1277,7 +1277,7 @@ static void netvsc_channel_cb(void *cont
 				default:
 					DPRINT_ERR(NETVSC,
 						   "unhandled packet type %d, "
-						   "tid %llx len %d\n",
+						   "tid %llx len %d",
 						   desc->type, request_id,
 						   bytes_recvd);
 					break;
Index: linux-2.6/drivers/staging/hv/storvsc.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/storvsc.c
+++ linux-2.6/drivers/staging/hv/storvsc.c
@@ -392,7 +392,7 @@ static void stor_vsc_on_io_completion(st
 
 	if (request->status != 0 || vstor_packet->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
-			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
+			    "cmd 0x%x scsi status 0x%x srb status 0x%x",
 			    request->cdb[0], vstor_packet->vm_srb.scsi_status,
 			    vstor_packet->vm_srb.srb_status);
 	}
@@ -402,7 +402,7 @@ static void stor_vsc_on_io_completion(st
 		if (vstor_packet->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
 			DPRINT_WARN(STORVSC, "storvsc pkt %p autosense data "
-				    "valid - len %d\n", request_ext,
+				    "valid - len %d", request_ext,
 				    vstor_packet->vm_srb.sense_info_length);
 
 			/* ASSERT(vstor_packet->vm_srb.sense_info_length <= */
@@ -581,7 +581,7 @@ static int stor_vsc_on_device_add(struct
 	device_info->path_id = stor_device->path_id;
 	device_info->target_id = stor_device->target_id;
 
-	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u\n",
+	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u",
 		   stor_device->port_number, stor_device->path_id,
 		   stor_device->target_id);
 
@@ -822,7 +822,7 @@ int stor_vsc_initialize(struct hv_driver
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
-	DPRINT_INFO(STORVSC, "max io %u, currently %u\n",
+	DPRINT_INFO(STORVSC, "max io %u, currently %u",
 		    stor_driver->max_outstanding_req_per_channel,
 		    STORVSC_MAX_IO_REQUESTS);
 
Index: linux-2.6/drivers/staging/hv/storvsc_drv.c
===================================================================
--- linux-2.6.orig/drivers/staging/hv/storvsc_drv.c
+++ linux-2.6/drivers/staging/hv/storvsc_drv.c
@@ -720,7 +720,7 @@ static int storvsc_queuecommand_lck(stru
 		request->data_buffer.offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++) {
-			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
+			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d",
 				   i, sgl[i].length, sgl[i].offset);
 			request->data_buffer.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));
