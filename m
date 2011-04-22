Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1DVVnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:43:18 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42354
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756731Ab1DVVnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:43:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 11/21] Staging: hv: Get rid of some DPRINT_DBG() calls
Date: Fri, 22 Apr 2011 14:55:16 -0700
Message-Id: <1303509326-3094-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303509326-3094-1-git-send-email-kys@microsoft.com>
References: <1303509246-3053-1-git-send-email-kys@microsoft.com>
 <1303509326-3094-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some of the DPRINT_DBG() statements.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   84 ---------------------------------------
 1 files changed, 0 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 09633cc..58d4a2d 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -220,14 +220,6 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	struct vmscsi_request *vm_srb;
 	int ret;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
-		   "req %p type %s start_sector %lu count %ld offset %d "
-		   "len %d\n", blkvsc_req,
-		   (blkvsc_req->write) ? "WRITE" : "READ",
-		   (unsigned long) blkvsc_req->sector_start,
-		   blkvsc_req->sector_count,
-		   blkvsc_req->request.data_buffer.offset,
-		   blkvsc_req->request.data_buffer.len);
 
 	storvsc_req = &blkvsc_req->request;
 	vm_srb = &storvsc_req->vstor_packet.vm_srb;
@@ -261,8 +253,6 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 {
 	struct block_device_context *blkdev = bdev->bd_disk->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
-		   blkdev->gd->disk_name);
 
 	mutex_lock(&blkvsc_mutex);
 	spin_lock(&blkdev->lock);
@@ -352,8 +342,6 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cmd_completion() - req %p\n",
-		   blkvsc_req);
 
 	vm_srb = &blkvsc_req->request.vstor_packet.vm_srb;
 	blkdev->num_outstanding_reqs--;
@@ -496,7 +484,6 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 
 	int ret = 0;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_cancel_pending_reqs()");
 
 	/* Flush the pending list first */
 	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
@@ -509,11 +496,6 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 		list_for_each_entry_safe(comp_req, tmp2,
 					 &pend_req->group->blkvsc_req_list,
 					 req_entry) {
-			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld\n",
-				   comp_req,
-				   (unsigned long) comp_req->sector_start,
-				   comp_req->sector_count);
 
 			if (comp_req == pend_req)
 				break;
@@ -537,9 +519,6 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 			kmem_cache_free(blkdev->request_pool, comp_req);
 		}
 
-		DPRINT_DBG(BLKVSC_DRV, "cancelling pending request - %p\n",
-			   pend_req);
-
 		list_del(&pend_req->pend_entry);
 
 		list_del(&pend_req->req_entry);
@@ -552,9 +531,6 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 				 * All the sectors have been xferred ie the
 				 * request is done
 				 */
-				DPRINT_DBG(BLKVSC_DRV,
-					   "blkvsc_cancel_pending_reqs() - "
-					   "req %p COMPLETED\n", pend_req->req);
 				kmem_cache_free(blkdev->request_pool,
 						pend_req->group);
 			}
@@ -582,7 +558,6 @@ static int blkvsc_remove(struct device *device)
 	unsigned long flags;
 	int ret;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_remove()\n");
 
 	if (!storvsc_drv_obj->base.dev_rm)
 		return -1;
@@ -640,9 +615,6 @@ static void blkvsc_shutdown(struct device *device)
 	if (!blkdev)
 		return;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_shutdown - users %d disk %s\n",
-		   blkdev->users, blkdev->gd->disk_name);
-
 	spin_lock_irqsave(&blkdev->lock, flags);
 
 	blkdev->shutting_down = 1;
@@ -670,9 +642,6 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device_context *blkdev = disk->private_data;
 
-	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
-		   blkdev->gd->disk_name);
-
 	mutex_lock(&blkvsc_mutex);
 	spin_lock(&blkdev->lock);
 	if (blkdev->users == 1) {
@@ -710,9 +679,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 	int pending = 0;
 	struct blkvsc_request_group *group = NULL;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu\n", blkdev, req,
-		  (unsigned long)blk_rq_pos(req));
-
 	/* Create a group to tie req to list of blkvsc_reqs */
 	group = kmem_cache_zalloc(blkdev->request_pool, GFP_ATOMIC);
 	if (!group)
@@ -730,11 +696,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 			 * Map this bio into an existing or new storvsc request
 			 */
 			bio_for_each_segment(bvec, bio, seg_idx) {
-				DPRINT_DBG(BLKVSC_DRV, "bio_for_each_segment() "
-					   "- req %p bio %p bvec %p seg_idx %d "
-					   "databuf_idx %d\n", req, bio, bvec,
-					   seg_idx, databuf_idx);
-
 				/* Get a new storvsc request */
 				/* 1st-time */
 				if ((!blkvsc_req) ||
@@ -827,10 +788,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 
 	/* Handle the last one */
 	if (blkvsc_req) {
-		DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p group %p count %d\n",
-			   blkdev, req, blkvsc_req->group,
-			   blkvsc_req->group->outstanding);
-
 		blkvsc_req->sector_start = start_sector;
 		sector_div(blkvsc_req->sector_start,
 			   (blkdev->sector_size >> 9));
@@ -843,13 +800,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 
 	list_for_each_entry(blkvsc_req, &group->blkvsc_req_list, req_entry) {
 		if (pending) {
-			DPRINT_DBG(BLKVSC_DRV, "adding blkvsc_req to "
-				   "pending_list - blkvsc_req %p start_sect %lu"
-				   " sect_count %ld (%lu %ld)\n", blkvsc_req,
-				   (unsigned long)blkvsc_req->sector_start,
-				   blkvsc_req->sector_count,
-				   (unsigned long)start_sector,
-				   (unsigned long)num_sectors);
 
 			list_add_tail(&blkvsc_req->pend_entry,
 				      &blkdev->pending_list);
@@ -862,13 +812,6 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 					      &blkdev->pending_list);
 			}
 
-			DPRINT_DBG(BLKVSC_DRV, "submitted blkvsc_req %p "
-				   "start_sect %lu sect_count %ld (%lu %ld) "
-				   "ret %d\n", blkvsc_req,
-				   (unsigned long)blkvsc_req->sector_start,
-				   blkvsc_req->sector_count,
-				   (unsigned long)start_sector,
-				   num_sectors, ret);
 		}
 	}
 
@@ -883,8 +826,6 @@ static int blkvsc_do_pending_reqs(struct block_device_context *blkdev)
 	/* Flush the pending list first */
 	list_for_each_entry_safe(pend_req, tmp, &blkdev->pending_list,
 				 pend_entry) {
-		DPRINT_DBG(BLKVSC_DRV, "working off pending_list - %p\n",
-			   pend_req);
 
 		ret = blkvsc_submit_request(pend_req,
 					    blkvsc_request_completion);
@@ -904,9 +845,7 @@ static void blkvsc_request(struct request_queue *queue)
 	struct request *req;
 	int ret = 0;
 
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
 	while ((req = blk_peek_request(queue)) != NULL) {
-		DPRINT_DBG(BLKVSC_DRV, "- req %p\n", req);
 
 		blkdev = req->rq_disk->private_data;
 		if (blkdev->shutting_down || req->cmd_type != REQ_TYPE_FS) {
@@ -917,8 +856,6 @@ static void blkvsc_request(struct request_queue *queue)
 		ret = blkvsc_do_pending_reqs(blkdev);
 
 		if (ret != 0) {
-			DPRINT_DBG(BLKVSC_DRV,
-				   "- stop queue - pending_list not empty\n");
 			blk_stop_queue(queue);
 			break;
 		}
@@ -927,11 +864,9 @@ static void blkvsc_request(struct request_queue *queue)
 
 		ret = blkvsc_do_request(blkdev, req);
 		if (ret > 0) {
-			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no room\n");
 			blk_stop_queue(queue);
 			break;
 		} else if (ret < 0) {
-			DPRINT_DBG(BLKVSC_DRV, "- stop queue - no mem\n");
 			blk_requeue_request(queue, req);
 			blk_stop_queue(queue);
 			break;
@@ -1041,7 +976,6 @@ static int blkvsc_probe(struct device *device)
 	static int ide0_registered;
 	static int ide1_registered;
 
-	DPRINT_DBG(BLKVSC_DRV, "blkvsc_probe - enter");
 
 	if (!storvsc_drv_obj->base.dev_add) {
 		DPRINT_ERR(BLKVSC_DRV, "OnDeviceAdd() not set");
@@ -1196,17 +1130,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 	struct vmscsi_request *vm_srb;
 
 
-	DPRINT_DBG(BLKVSC_DRV, "blkdev %p blkvsc_req %p group %p type %s "
-		   "sect_start %lu sect_count %ld len %d group outstd %d "
-		   "total outstd %d\n",
-		   blkdev, blkvsc_req, blkvsc_req->group,
-		   (blkvsc_req->write) ? "WRITE" : "READ",
-		   (unsigned long)blkvsc_req->sector_start,
-		   blkvsc_req->sector_count,
-		   blkvsc_req->request.data_buffer.len,
-		   blkvsc_req->group->outstanding,
-		   blkdev->num_outstanding_reqs);
-
 	spin_lock_irqsave(&blkdev->lock, flags);
 
 	blkdev->num_outstanding_reqs--;
@@ -1221,11 +1144,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 		list_for_each_entry_safe(comp_req, tmp,
 					 &blkvsc_req->group->blkvsc_req_list,
 					 req_entry) {
-			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld\n",
-				   comp_req,
-				   (unsigned long)comp_req->sector_start,
-				   comp_req->sector_count);
 
 			list_del(&comp_req->req_entry);
 
@@ -1238,8 +1156,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 				 * All the sectors have been xferred ie the
 				 * request is done
 				 */
-				DPRINT_DBG(BLKVSC_DRV, "req %p COMPLETED\n",
-					   comp_req->req);
 				kmem_cache_free(blkdev->request_pool,
 						comp_req->group);
 			}
-- 
1.7.4.1

