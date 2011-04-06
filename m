Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab1DFV0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:26:21 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60531
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756904Ab1DFVYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 22/22] Staging: hv: Get rid of some dead code in blkvsc_drv.c
Date: Wed,  6 Apr 2011 14:35:20 -0700
Message-Id: <1302125720-10808-22-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some dead code in blkvsc_drv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   26 --------------------------
 1 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 6ad1cad..0b85995 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -172,7 +172,6 @@ static int blk_vsc_initialize(struct hv_driver *driver)
 	stor_driver = hvdr_to_stordr(driver);
 
 	/* Make sure we are at least 2 pages since 1 page is used for control */
-	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
 	driver->name = g_blk_driver_name;
 	memcpy(&driver->dev_type, &g_blk_device_type, sizeof(struct hv_guid));
@@ -224,14 +223,6 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 		   blkvsc_req->sector_count,
 		   blkvsc_req->request.data_buffer.offset,
 		   blkvsc_req->request.data_buffer.len);
-#if 0
-	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
-		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
-			   "req %p pfn[%d] %llx\n",
-			   blkvsc_req, i,
-			   blkvsc_req->request.data_buffer.pfn_array[i]);
-	}
-#endif
 
 	storvsc_req = &blkvsc_req->request;
 	vm_srb = &storvsc_req->vstor_packet.vm_srb;
@@ -376,9 +367,6 @@ static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg)
 
 static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
 {
-	/* ASSERT(blkvsc_req->req); */
-	/* ASSERT(blkvsc_req->sector_count <=
-	   (MAX_MULTIPAGE_BUFFER_COUNT*8)); */
 
 	blkvsc_req->cmd_len = 16;
 
@@ -435,7 +423,6 @@ static void blkvsc_init_rw(struct blkvsc_request *blkvsc_req)
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
 			unsigned cmd, unsigned long argument)
 {
-/*	struct block_device_context *blkdev = bd->bd_disk->private_data; */
 	int ret;
 
 	switch (cmd) {
@@ -862,13 +849,6 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	blkdev->capacity = be64_to_cpu(*(unsigned long long *) &buf[0]) + 1;
 	blkdev->sector_size = be32_to_cpu(*(unsigned int *)&buf[8]);
 
-#if 0
-	blkdev->capacity = ((buf[0] << 24) | (buf[1] << 16) |
-			    (buf[2] << 8) | buf[3]) + 1;
-	blkdev->sector_size = (buf[4] << 24) | (buf[5] << 16) |
-			      (buf[6] << 8) | buf[7];
-#endif
-
 	kunmap(page_buf);
 
 	__free_page(page_buf);
@@ -940,7 +920,6 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 
 	buf = kmap(page_buf);
 
-	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, buf, 64); */
 	/* be to le */
 	device_type = buf[0] & 0x1F;
 
@@ -960,8 +939,6 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 		blkdev->device_id_len = 64;
 
 	memcpy(blkdev->device_id, &buf[8], blkdev->device_id_len);
-	/* printk_hex_dump_bytes("", DUMP_PREFIX_NONE, blkdev->device_id,
-	 * blkdev->device_id_len); */
 
 	kunmap(page_buf);
 
@@ -1346,8 +1323,6 @@ static int blkvsc_probe(struct device *device)
 	/* Initialize what we can here */
 	spin_lock_init(&blkdev->lock);
 
-	/* ASSERT(sizeof(struct blkvsc_request_group) <= */
-	/* 	sizeof(struct blkvsc_request)); */
 
 	blkdev->request_pool = kmem_cache_create(dev_name(&device_obj->device),
 					sizeof(struct blkvsc_request), 0,
@@ -1484,7 +1459,6 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 	struct blkvsc_request *comp_req, *tmp;
 	struct vmscsi_request *vm_srb;
 
-	/* ASSERT(blkvsc_req->group); */
 
 	DPRINT_DBG(BLKVSC_DRV, "blkdev %p blkvsc_req %p group %p type %s "
 		   "sect_start %lu sect_count %ld len %d group outstd %d "
-- 
1.7.4.1

