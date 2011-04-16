Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1DPQvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:51:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:50053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab1DPQvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:51:02 -0400
Message-Id: <20110416165054.165322229@aepfle.de>
User-Agent: quilt/0.47-15.10
Date: Sat, 16 Apr 2011 18:50:43 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 5/5] hv: remove double newline in DPRINT functions 
References: <20110416165038.986214764@aepfle.de>
Content-Disposition: inline; filename=bug679942-dprintk_newline.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove double newline in DPRINT* functions, the macro already adds a  newline.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
compile tested

 drivers/staging/hv/blkvsc_drv.c  |   70 +++++++++++++++++++--------------------
 drivers/staging/hv/hv_mouse.c    |    4 +-
 drivers/staging/hv/netvsc.c      |    2 -
 drivers/staging/hv/storvsc.c     |    6 +--
 drivers/staging/hv/storvsc_drv.c |    4 +-
 5 files changed, 43 insertions(+), 43 deletions(-)

Index: linux-next/drivers/staging/hv/blkvsc_drv.c
===================================================================
--- linux-next.orig/drivers/staging/hv/blkvsc_drv.c
+++ linux-next/drivers/staging/hv/blkvsc_drv.c
@@ -474,7 +474,7 @@ static void blkvsc_shutdown(struct devic
 	if (!blkdev)
 		return;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_shutdown - users %d disk %s\n",
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_shutdown - users %d disk %s",
 		   blkdev->users, blkdev->gd->disk_name);
 
 	spin_lock_irqsave(&blkdev->lock, flags);
@@ -504,7 +504,7 @@ static int blkvsc_do_flush(struct block_
 {
 	struct blkvsc_request *blkvsc_req;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_flush()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_flush()");
 
 	if (blkdev->device_type != HARDDISK_TYPE)
 		return 0;
@@ -543,7 +543,7 @@ static int blkvsc_do_inquiry(struct bloc
 	unsigned char *buf;
 	unsigned char device_type;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_inquiry()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_inquiry()");
 
 	blkvsc_req = kmem_cache_zalloc(blkdev->request_pool, GFP_KERNEL);
 	if (!blkvsc_req)
@@ -574,7 +574,7 @@ static int blkvsc_do_inquiry(struct bloc
 
 	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
 
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete\n",
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete",
 		   blkvsc_req);
 
 	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
@@ -594,7 +594,7 @@ static int blkvsc_do_inquiry(struct bloc
 		blkdev->device_type = UNKNOWN_DEV_TYPE;
 	}
 
-	DPRINT_DBG(BLKVSC_DRV, "device type %d\n", device_type);
+	DPRINT_DBG(BLKVSC_DRV, "device type %d", device_type);
 
 	blkdev->device_id_len = buf[7];
 	if (blkdev->device_id_len > 64)
@@ -622,7 +622,7 @@ static int blkvsc_do_read_capacity(struc
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity()");
 
 	blkdev->sector_size = 0;
 	blkdev->capacity = 0;
@@ -655,7 +655,7 @@ static int blkvsc_do_read_capacity(struc
 
 	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
 
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete\n",
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete",
 		   blkvsc_req);
 
 	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
@@ -696,7 +696,7 @@ static int blkvsc_do_read_capacity16(str
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity16()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_do_read_capacity16()");
 
 	blkdev->sector_size = 0;
 	blkdev->capacity = 0;
@@ -734,7 +734,7 @@ static int blkvsc_do_read_capacity16(str
 
 	blkvsc_submit_request(blkvsc_req, blkvsc_cmd_completion);
 
-	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete\n",
+	DPRINT_DBG(BLKVSC_DRV, "waiting %p to complete",
 		   blkvsc_req);
 
 	wait_for_completion_interruptible(&blkvsc_req->request.wait_event);
@@ -785,7 +785,7 @@ static int blkvsc_remove(struct device *
 	unsigned long flags;
 	int ret;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_remove()\n");
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_remove()");
 
 	if (!storvsc_drv_obj->base.dev_rm)
 		return -1;
@@ -906,7 +906,7 @@ static int blkvsc_submit_request(struct
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
 		   "req %p type %s start_sector %lu count %ld offset %d "
-		   "len %d\n", blkvsc_req,
+		   "len %d", blkvsc_req,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long) blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
@@ -915,7 +915,7 @@ static int blkvsc_submit_request(struct
 #if 0
 	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
 		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
-			   "req %p pfn[%d] %llx\n",
+			   "req %p pfn[%d] %llx",
 			   blkvsc_req, i,
 			   blkvsc_req->request.data_buffer.pfn_array[i]);
 	}
@@ -969,7 +969,7 @@ static int blkvsc_do_request(struct bloc
 	int pending = 0;
 	struct blkvsc_request_group *group = NULL;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu\n", blkdev, req,
+	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu", blkdev, req,
 		  (unsigned long)blk_rq_pos(req));
 
 	/* Create a group to tie req to list of blkvsc_reqs */
@@ -991,7 +991,7 @@ static int blkvsc_do_request(struct bloc
 			bio_for_each_segment(bvec, bio, seg_idx) {
 				DPRINT_DBG(BLKVSC_DRV, "bio_for_each_segment() "
 					   "- req %p bio %p bvec %p seg_idx %d "
-					   "databuf_idx %d\n", req, bio, bvec,
+					   "databuf_idx %d", req, bio, bvec,
 					   seg_idx, databuf_idx);
 
 				/* Get a new storvsc request */
@@ -1074,7 +1074,7 @@ static int blkvsc_do_request(struct bloc
 
 	/* Handle the last one */
 	if (blkvsc_req) {
-		DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p group %p count %d\n",
+		DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p group %p count %d",
 			   blkdev, req, blkvsc_req->group,
 			   blkvsc_req->group->outstanding);
 
@@ -1092,7 +1092,7 @@ static int blkvsc_do_request(struct bloc
 		if (pending) {
 			DPRINT_DBG(BLKVSC_DRV, "adding blkvsc_req to "
 				   "pending_list - blkvsc_req %p start_sect %lu"
-				   " sect_count %ld (%lu %ld)\n", blkvsc_req,
+				   " sect_count %ld (%lu %ld)", blkvsc_req,
 				   (unsigned long)blkvsc_req->sector_start,
 				   blkvsc_req->sector_count,
 				   (unsigned long)start_sector,
@@ -1111,7 +1111,7 @@ static int blkvsc_do_request(struct bloc
 
 			DPRINT_DBG(BLKVSC_DRV, "submitted blkvsc_req %p "
 				   "start_sect %lu sect_count %ld (%lu %ld) "
-				   "ret %d\n", blkvsc_req,
+				   "ret %d", blkvsc_req,
 				   (unsigned long)blkvsc_req->sector_start,
 				   blkvsc_req->sector_count,
 				   (unsigned long)start_sector,
@@ -1131,7 +1131,7 @@ static void blkvsc_cmd_completion(struct
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p\n",
+	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p",
 		   blkvsc_req);
 
 	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
@@ -1159,7 +1159,7 @@ static void blkvsc_request_completion(st
 
 	DPRINT_DBG(BLKVSC_DRV, "blkdev %p blkvsc_req %p group %p type %s "
 		   "sect_start %lu sect_count %ld len %d group outstd %d "
-		   "total outstd %d\n",
+		   "total outstd %d",
 		   blkdev, blkvsc_req, blkvsc_req->group,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long)blkvsc_req->sector_start,
@@ -1183,7 +1183,7 @@ static void blkvsc_request_completion(st
 					 &blkvsc_req->group->blkvsc_req_list,
 					 req_entry) {
 			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld\n",
+				   "sect_start %lu sect_count %ld",
 				   comp_req,
 				   (unsigned long)comp_req->sector_start,
 				   comp_req->sector_count);
@@ -1199,7 +1199,7 @@ static void blkvsc_request_completion(st
 				 * All the sectors have been xferred ie the
 				 * request is done
 				 */
-				DPRINT_DBG(BLKVSC_DRV, "req %p COMPLETED\n",
+				DPRINT_DBG(BLKVSC_DRV, "req %p COMPLETED",
 					   comp_req->req);
 				kmem_cache_free(blkdev->request_pool,
 						comp_req->group);
@@ -1240,7 +1240,7 @@ static int blkvsc_cancel_pending_reqs(st
 					 &pend_req->group->blkvsc_req_list,
 					 req_entry) {
 			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld\n",
+				   "sect_start %lu sect_count %ld",
 				   comp_req,
 				   (unsigned long) comp_req->sector_start,
 				   comp_req->sector_count);
@@ -1267,7 +1267,7 @@ static int blkvsc_cancel_pending_reqs(st
 			kmem_cache_free(blkdev->request_pool, comp_req);
 		}
 
-		DPRINT_DBG(BLKVSC_DRV, "cancelling pending request - %p\n",
+		DPRINT_DBG(BLKVSC_DRV, "cancelling pending request - %p",
 			   pend_req);
 
 		list_del(&pend_req->pend_entry);
@@ -1284,7 +1284,7 @@ static int blkvsc_cancel_pending_reqs(st
 				 */
 				DPRINT_DBG(BLKVSC_DRV,
 					   "blkvsc_cancel_pending_reqs() - "
-					   "req %p COMPLETED\n", pend_req->req);
+					   "req %p COMPLETED", pend_req->req);
 				kmem_cache_free(blkdev->request_pool,
 						pend_req->group);
 			}
@@ -1305,7 +1305,7 @@ static int blkvsc_do_pending_reqs(struct
 	/* Flush the pending list first */
 	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
 				 pend_entry) {
-		DPRINT_DBG(BLKVSC_DRV, "working off pending_list - %p\n",
+		DPRINT_DBG(BLKVSC_DRV, "working off pending_list - %p",
 			   pend_req);
 
 		ret = blkvsc_submit_request(pend_req,
@@ -1325,9 +1325,9 @@ static void blkvsc_request(struct reques
 	struct request *req;
 	int ret = 0;
 
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	DPRINT_DBG(BLKVSC_DRV, "- enter");
 	while ((req = blk_peek_request(queue)) != NULL) {
-		DPRINT_DBG(BLKVSC_DRV, "- req %p\n", req);
+		DPRINT_DBG(BLKVSC_DRV, "- req %p", req);
 
 		blkdev = req->rq_disk->private_data;
 		if (blkdev->shutting_down || req->cmd_type != REQ_TYPE_FS ||
@@ -1340,7 +1340,7 @@ static void blkvsc_request(struct reques
 
 		if (ret != 0) {
 			DPRINT_DBG(BLKVSC_DRV,
-				   "- stop queue - pending_list not empty\n");
+				   "- stop queue - pending_list not empty");
 			blk_stop_queue(queue);
 			break;
 		}
@@ -1349,11 +1349,11 @@ static void blkvsc_request(struct reques
 
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
@@ -1365,7 +1365,7 @@ static int blkvsc_open(struct block_devi
 {
 	struct block_device_context *blkdev = bdev->bd_disk->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
+	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s", blkdev->users,
 		   blkdev->gd->disk_name);
 
 	mutex_lock(&blkvsc_mutex);
@@ -1388,7 +1388,7 @@ static int blkvsc_release(struct gendisk
 {
 	struct block_device_context *blkdev = disk->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
+	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s", blkdev->users,
 		   blkdev->gd->disk_name);
 
 	mutex_lock(&blkvsc_mutex);
@@ -1409,7 +1409,7 @@ static int blkvsc_release(struct gendisk
 static unsigned int blkvsc_check_events(struct gendisk *gd,
 					unsigned int clearing)
 {
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	DPRINT_DBG(BLKVSC_DRV, "- enter");
 	return DISK_EVENT_MEDIA_CHANGE;
 }
 
@@ -1417,7 +1417,7 @@ static int blkvsc_revalidate_disk(struct
 {
 	struct block_device_context *blkdev = gd->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	DPRINT_DBG(BLKVSC_DRV, "- enter");
 
 	if (blkdev->device_type == DVD_TYPE) {
 		blkvsc_do_read_capacity(blkdev);
@@ -1521,7 +1521,7 @@ static int blkvsc_ioctl(struct block_dev
 	 */
 #if 0
 	case HDIO_GET_IDENTITY:
-		DPRINT_INFO(BLKVSC_DRV, "HDIO_GET_IDENTITY\n");
+		DPRINT_INFO(BLKVSC_DRV, "HDIO_GET_IDENTITY");
 		if (copy_to_user((void __user *)arg, blkdev->device_id,
 				 blkdev->device_id_len))
 			ret = -EFAULT;
Index: linux-next/drivers/staging/hv/hv_mouse.c
===================================================================
--- linux-next.orig/drivers/staging/hv/hv_mouse.c
+++ linux-next/drivers/staging/hv/hv_mouse.c
@@ -931,13 +931,13 @@ static void reportdesc_callback(struct h
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
Index: linux-next/drivers/staging/hv/netvsc.c
===================================================================
--- linux-next.orig/drivers/staging/hv/netvsc.c
+++ linux-next/drivers/staging/hv/netvsc.c
@@ -1186,7 +1186,7 @@ static void netvsc_channel_cb(void *cont
 				default:
 					dev_err(&device->device,
 						   "unhandled packet type %d, "
-						   "tid %llx len %d\n",
+						   "tid %llx len %d",
 						   desc->type, request_id,
 						   bytes_recvd);
 					break;
Index: linux-next/drivers/staging/hv/storvsc.c
===================================================================
--- linux-next.orig/drivers/staging/hv/storvsc.c
+++ linux-next/drivers/staging/hv/storvsc.c
@@ -298,7 +298,7 @@ static void stor_vsc_on_io_completion(st
 	if (vstor_packet->vm_srb.scsi_status != 0 ||
 		vstor_packet->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
-			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
+			    "cmd 0x%x scsi status 0x%x srb status 0x%x",
 			    vstor_packet->vm_srb.cdb[0],
 			    vstor_packet->vm_srb.scsi_status,
 			    vstor_packet->vm_srb.srb_status);
@@ -309,7 +309,7 @@ static void stor_vsc_on_io_completion(st
 		if (vstor_packet->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
 			DPRINT_WARN(STORVSC, "storvsc pkt %p autosense data "
-				    "valid - len %d\n", request,
+				    "valid - len %d", request,
 				    vstor_packet->vm_srb.sense_info_length);
 
 			memcpy(request->sense_buffer,
@@ -462,7 +462,7 @@ int stor_vsc_on_device_add(struct hv_dev
 	device_info->path_id = stor_device->path_id;
 	device_info->target_id = stor_device->target_id;
 
-	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u\n",
+	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u",
 		   stor_device->port_number, stor_device->path_id,
 		   stor_device->target_id);
 
Index: linux-next/drivers/staging/hv/storvsc_drv.c
===================================================================
--- linux-next.orig/drivers/staging/hv/storvsc_drv.c
+++ linux-next/drivers/staging/hv/storvsc_drv.c
@@ -108,7 +108,7 @@ static int stor_vsc_initialize(struct hv
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
-	DPRINT_INFO(STORVSC, "max io %u, currently %u\n",
+	DPRINT_INFO(STORVSC, "max io %u, currently %u",
 		    stor_driver->max_outstanding_req_per_channel,
 		    STORVSC_MAX_IO_REQUESTS);
 
@@ -833,7 +833,7 @@ static int storvsc_queuecommand_lck(stru
 		request->data_buffer.offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++) {
-			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
+			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d",
 				   i, sgl[i].length, sgl[i].offset);
 			request->data_buffer.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));

