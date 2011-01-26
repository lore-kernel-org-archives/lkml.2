Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1AZRsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:48:31 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42446
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752778Ab1AZRsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:48:21 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 5/8] staging: hv: Convert camel cased struct fields in vmbus_api.h to lower cases
Date: Wed, 26 Jan 2011 09:50:03 -0800
Message-Id: <1296064206-11372-5-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1296064206-11372-4-git-send-email-haiyangz@microsoft.com>
References: <1296064206-11372-1-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-2-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-3-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-4-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc.c       |   20 ++--
 drivers/staging/hv/blkvsc_drv.c   |   56 ++++++------
 drivers/staging/hv/channel.c      |   20 ++--
 drivers/staging/hv/channel_mgmt.c |    2 +-
 drivers/staging/hv/netvsc.c       |   58 ++++++------
 drivers/staging/hv/netvsc_drv.c   |   38 ++++----
 drivers/staging/hv/rndis_filter.c |   52 ++++++------
 drivers/staging/hv/storvsc.c      |   34 ++++----
 drivers/staging/hv/storvsc_drv.c  |   28 +++---
 drivers/staging/hv/vmbus_api.h    |   68 +++++++-------
 drivers/staging/hv/vmbus_drv.c    |  181 +++++++++++++++++++------------------
 11 files changed, 279 insertions(+), 278 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 11a2523..b0e07c1 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -51,13 +51,13 @@ static int blk_vsc_on_device_add(struct hv_device *device, void *additional_info
 	 * id. For IDE devices, the device instance id is formatted as
 	 * <bus id> * - <device id> - 8899 - 000000000000.
 	 */
-	device_info->path_id = device->deviceInstance.data[3] << 24 |
-			     device->deviceInstance.data[2] << 16 |
-			     device->deviceInstance.data[1] << 8  |
-			     device->deviceInstance.data[0];
+	device_info->path_id = device->dev_instance.data[3] << 24 |
+			     device->dev_instance.data[2] << 16 |
+			     device->dev_instance.data[1] << 8  |
+			     device->dev_instance.data[0];
 
-	device_info->target_id = device->deviceInstance.data[5] << 8 |
-			       device->deviceInstance.data[4];
+	device_info->target_id = device->dev_instance.data[5] << 8 |
+			       device->dev_instance.data[4];
 
 	return ret;
 }
@@ -73,7 +73,7 @@ int blk_vsc_initialize(struct hv_driver *driver)
 	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
 	driver->name = g_blk_driver_name;
-	memcpy(&driver->deviceType, &g_blk_device_type, sizeof(struct hv_guid));
+	memcpy(&driver->dev_type, &g_blk_device_type, sizeof(struct hv_guid));
 
 	stor_driver->request_ext_size = sizeof(struct storvsc_request_extension);
 
@@ -93,9 +93,9 @@ int blk_vsc_initialize(struct hv_driver *driver)
 		    stor_driver->max_outstanding_req_per_channel);
 
 	/* Setup the dispatch table */
-	stor_driver->base.OnDeviceAdd = blk_vsc_on_device_add;
-	stor_driver->base.OnDeviceRemove = stor_vsc_on_device_remove;
-	stor_driver->base.OnCleanup = stor_vsc_on_cleanup;
+	stor_driver->base.dev_add = blk_vsc_on_device_add;
+	stor_driver->base.dev_rm = stor_vsc_on_device_remove;
+	stor_driver->base.cleanup = stor_vsc_on_cleanup;
 	stor_driver->on_io_request = stor_vsc_on_io_request;
 
 	return ret;
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 4fb8094..cabadf0 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -183,7 +183,7 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv_init(&storvsc_drv_obj->base);
 
 	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.deviceType,
+	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = blkvsc_probe;
@@ -230,8 +230,8 @@ static void blkvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (storvsc_drv_obj->base.OnCleanup)
-		storvsc_drv_obj->base.OnCleanup(&storvsc_drv_obj->base);
+	if (storvsc_drv_obj->base.cleanup)
+		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
 	vmbus_child_driver_unregister(drv_ctx);
 
@@ -262,7 +262,7 @@ static int blkvsc_probe(struct device *device)
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_probe - enter");
 
-	if (!storvsc_drv_obj->base.OnDeviceAdd) {
+	if (!storvsc_drv_obj->base.dev_add) {
 		DPRINT_ERR(BLKVSC_DRV, "OnDeviceAdd() not set");
 		ret = -1;
 		goto Cleanup;
@@ -293,7 +293,7 @@ static int blkvsc_probe(struct device *device)
 
 
 	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv_obj->base.OnDeviceAdd(device_obj, &device_info);
+	ret = storvsc_drv_obj->base.dev_add(device_obj, &device_info);
 	if (ret != 0) {
 		DPRINT_ERR(BLKVSC_DRV, "unable to add blkvsc device");
 		goto Cleanup;
@@ -392,7 +392,7 @@ static int blkvsc_probe(struct device *device)
 	return ret;
 
 Remove:
-	storvsc_drv_obj->base.OnDeviceRemove(device_obj);
+	storvsc_drv_obj->base.dev_rm(device_obj);
 
 Cleanup:
 	if (blkdev) {
@@ -460,9 +460,9 @@ static int blkvsc_do_flush(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.PfnArray[0] = 0;
-	blkvsc_req->request.data_buffer.Offset = 0;
-	blkvsc_req->request.data_buffer.Length = 0;
+	blkvsc_req->request.data_buffer.pfn_array[0] = 0;
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 0;
 
 	blkvsc_req->cmnd[0] = SYNCHRONIZE_CACHE;
 	blkvsc_req->cmd_len = 10;
@@ -507,9 +507,9 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.PfnArray[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.Offset = 0;
-	blkvsc_req->request.data_buffer.Length = 64;
+	blkvsc_req->request.data_buffer.pfn_array[0] = page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 64;
 
 	blkvsc_req->cmnd[0] = INQUIRY;
 	blkvsc_req->cmnd[1] = 0x1;		/* Get product data */
@@ -594,9 +594,9 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.PfnArray[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.Offset = 0;
-	blkvsc_req->request.data_buffer.Length = 8;
+	blkvsc_req->request.data_buffer.pfn_array[0] = page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 8;
 
 	blkvsc_req->cmnd[0] = READ_CAPACITY;
 	blkvsc_req->cmd_len = 16;
@@ -671,9 +671,9 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.data_buffer.PfnArray[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.data_buffer.Offset = 0;
-	blkvsc_req->request.data_buffer.Length = 12;
+	blkvsc_req->request.data_buffer.pfn_array[0] = page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.offset = 0;
+	blkvsc_req->request.data_buffer.len = 12;
 
 	blkvsc_req->cmnd[0] = 0x9E; /* READ_CAPACITY16; */
 	blkvsc_req->cmd_len = 16;
@@ -742,14 +742,14 @@ static int blkvsc_remove(struct device *device)
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_remove()\n");
 
-	if (!storvsc_drv_obj->base.OnDeviceRemove)
+	if (!storvsc_drv_obj->base.dev_rm)
 		return -1;
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = storvsc_drv_obj->base.OnDeviceRemove(device_obj);
+	ret = storvsc_drv_obj->base.dev_rm(device_obj);
 	if (ret != 0) {
 		/* TODO: */
 		DPRINT_ERR(BLKVSC_DRV,
@@ -866,10 +866,10 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long) blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.data_buffer.Offset,
-		   blkvsc_req->request.data_buffer.Length);
+		   blkvsc_req->request.data_buffer.offset,
+		   blkvsc_req->request.data_buffer.len);
 #if 0
-	for (i = 0; i < (blkvsc_req->request.data_buffer.Length >> 12); i++) {
+	for (i = 0; i < (blkvsc_req->request.data_buffer.len >> 12); i++) {
 		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
 			   "req %p pfn[%d] %llx\n",
 			   blkvsc_req, i,
@@ -993,9 +993,9 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 
 					blkvsc_req->dev = blkdev;
 					blkvsc_req->req = req;
-					blkvsc_req->request.data_buffer.Offset
+					blkvsc_req->request.data_buffer.offset
 						= bvec->bv_offset;
-					blkvsc_req->request.data_buffer.Length
+					blkvsc_req->request.data_buffer.len
 						= 0;
 
 					/* Add to the group */
@@ -1011,9 +1011,9 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 
 				/* Add the curr bvec/segment to the curr blkvsc_req */
 				blkvsc_req->request.data_buffer.
-					PfnArray[databuf_idx]
+					pfn_array[databuf_idx]
 						= page_to_pfn(bvec->bv_page);
-				blkvsc_req->request.data_buffer.Length
+				blkvsc_req->request.data_buffer.len
 					+= bvec->bv_len;
 
 				prev_bvec = bvec;
@@ -1116,7 +1116,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long)blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.data_buffer.Length,
+		   blkvsc_req->request.data_buffer.len,
 		   blkvsc_req->group->outstanding,
 		   blkdev->num_outstanding_reqs);
 
diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index ca76098..960e155 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -806,9 +806,9 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	desc.rangecount = pagecount;
 
 	for (i = 0; i < pagecount; i++) {
-		desc.range[i].Length = pagebuffers[i].Length;
-		desc.range[i].Offset = pagebuffers[i].Offset;
-		desc.range[i].Pfn	 = pagebuffers[i].Pfn;
+		desc.range[i].len = pagebuffers[i].len;
+		desc.range[i].offset = pagebuffers[i].offset;
+		desc.range[i].pfn	 = pagebuffers[i].pfn;
 	}
 
 	sg_init_table(bufferlist, 3);
@@ -842,14 +842,14 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	u32 packetlen_aligned;
 	struct scatterlist bufferlist[3];
 	u64 aligned_data = 0;
-	u32 pfncount = NUM_PAGES_SPANNED(multi_pagebuffer->Offset,
-					 multi_pagebuffer->Length);
+	u32 pfncount = NUM_PAGES_SPANNED(multi_pagebuffer->offset,
+					 multi_pagebuffer->len);
 
 	dump_vmbus_channel(channel);
 
 	DPRINT_DBG(VMBUS, "data buffer - offset %u len %u pfn count %u",
-		multi_pagebuffer->Offset,
-		multi_pagebuffer->Length, pfncount);
+		multi_pagebuffer->offset,
+		multi_pagebuffer->len, pfncount);
 
 	if ((pfncount < 0) || (pfncount > MAX_MULTIPAGE_BUFFER_COUNT))
 		return -EINVAL;
@@ -874,10 +874,10 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	desc.transactionid = requestid;
 	desc.rangecount = 1;
 
-	desc.range.Length = multi_pagebuffer->Length;
-	desc.range.Offset = multi_pagebuffer->Offset;
+	desc.range.len = multi_pagebuffer->len;
+	desc.range.offset = multi_pagebuffer->offset;
 
-	memcpy(desc.range.PfnArray, multi_pagebuffer->PfnArray,
+	memcpy(desc.range.pfn_array, multi_pagebuffer->pfn_array,
 	       pfncount * sizeof(u64));
 
 	sg_init_table(bufferlist, 3);
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 732a457..b4a8561 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -864,7 +864,7 @@ void vmbus_release_unattached_channels(void)
 		if (channel == start)
 			break;
 
-		if (!channel->device_obj->Driver) {
+		if (!channel->device_obj->drv) {
 			list_del(&channel->listentry);
 			DPRINT_INFO(VMBUS,
 				    "Releasing unattached device object %p",
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 0edbe74..2d46528 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -86,7 +86,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	atomic_cmpxchg(&net_device->refcnt, 0, 2);
 
 	net_device->dev = device;
-	device->Extension = net_device;
+	device->ext = net_device;
 
 	return net_device;
 }
@@ -94,7 +94,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 static void free_net_device(struct netvsc_device *device)
 {
 	WARN_ON(atomic_read(&device->refcnt) == 0);
-	device->dev->Extension = NULL;
+	device->dev->ext = NULL;
 	kfree(device);
 }
 
@@ -104,7 +104,7 @@ static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
-	net_device = device->Extension;
+	net_device = device->ext;
 	if (net_device && atomic_read(&net_device->refcnt) > 1)
 		atomic_inc(&net_device->refcnt);
 	else
@@ -118,7 +118,7 @@ static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
-	net_device = device->Extension;
+	net_device = device->ext;
 	if (net_device && atomic_read(&net_device->refcnt))
 		atomic_inc(&net_device->refcnt);
 	else
@@ -131,7 +131,7 @@ static void put_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
-	net_device = device->Extension;
+	net_device = device->ext;
 	/* ASSERT(netDevice); */
 
 	atomic_dec(&net_device->refcnt);
@@ -142,7 +142,7 @@ static struct netvsc_device *release_outbound_net_device(
 {
 	struct netvsc_device *net_device;
 
-	net_device = device->Extension;
+	net_device = device->ext;
 	if (net_device == NULL)
 		return NULL;
 
@@ -158,7 +158,7 @@ static struct netvsc_device *release_inbound_net_device(
 {
 	struct netvsc_device *net_device;
 
-	net_device = device->Extension;
+	net_device = device->ext;
 	if (net_device == NULL)
 		return NULL;
 
@@ -166,7 +166,7 @@ static struct netvsc_device *release_inbound_net_device(
 	while (atomic_cmpxchg(&net_device->refcnt, 1, 0) != 1)
 		udelay(100);
 
-	device->Extension = NULL;
+	device->ext = NULL;
 	return net_device;
 }
 
@@ -188,7 +188,7 @@ int netvsc_initialize(struct hv_driver *drv)
 	/* ASSERT(driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
 	drv->name = driver_name;
-	memcpy(&drv->deviceType, &netvsc_device_type, sizeof(struct hv_guid));
+	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
 
 	/* Make sure it is set by the caller */
 	/* FIXME: These probably should still be tested in some way */
@@ -196,9 +196,9 @@ int netvsc_initialize(struct hv_driver *drv)
 	/* ASSERT(driver->OnLinkStatusChanged); */
 
 	/* Setup the dispatch table */
-	driver->base.OnDeviceAdd	= netvsc_device_add;
-	driver->base.OnDeviceRemove	= netvsc_device_remove;
-	driver->base.OnCleanup		= netvsc_cleanup;
+	driver->base.dev_add	= netvsc_device_add;
+	driver->base.dev_rm	= netvsc_device_remove;
+	driver->base.cleanup		= netvsc_cleanup;
 
 	driver->send			= netvsc_send;
 
@@ -708,7 +708,7 @@ static int netvsc_device_add(struct hv_device *device, void *additional_info)
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *packet, *pos;
 	struct netvsc_driver *net_driver =
-				(struct netvsc_driver *)device->Driver;
+				(struct netvsc_driver *)device->drv;
 
 	net_device = alloc_net_device(device);
 	if (!net_device) {
@@ -806,7 +806,7 @@ static int netvsc_device_remove(struct hv_device *device)
 	struct hv_netvsc_packet *netvsc_packet, *pos;
 
 	DPRINT_INFO(NETVSC, "Disabling outbound traffic on net device (%p)...",
-		    device->Extension);
+		    device->ext);
 
 	/* Stop outbound traffic ie sends and receives completions */
 	net_device = release_outbound_net_device(device);
@@ -827,7 +827,7 @@ static int netvsc_device_remove(struct hv_device *device)
 	NetVscDisconnectFromVsp(net_device);
 
 	DPRINT_INFO(NETVSC, "Disabling inbound traffic on net device (%p)...",
-		    device->Extension);
+		    device->ext);
 
 	/* Stop inbound traffic ie receives and sends completions */
 	net_device = release_inbound_net_device(device);
@@ -1101,42 +1101,42 @@ static void netvsc_receive(struct hv_device *device,
 		/* 	vmxferpagePacket->Ranges[i].ByteCount < */
 		/* 	netDevice->ReceiveBufferSize); */
 
-		netvsc_packet->page_buf[0].Length =
+		netvsc_packet->page_buf[0].len =
 					vmxferpage_packet->Ranges[i].ByteCount;
 
 		start = virt_to_phys((void *)((unsigned long)net_device->
 		recv_buf + vmxferpage_packet->Ranges[i].ByteOffset));
 
-		netvsc_packet->page_buf[0].Pfn = start >> PAGE_SHIFT;
+		netvsc_packet->page_buf[0].pfn = start >> PAGE_SHIFT;
 		end_virtual = (unsigned long)net_device->recv_buf
 		    + vmxferpage_packet->Ranges[i].ByteOffset
 		    + vmxferpage_packet->Ranges[i].ByteCount - 1;
 		end = virt_to_phys((void *)end_virtual);
 
 		/* Calculate the page relative offset */
-		netvsc_packet->page_buf[0].Offset =
+		netvsc_packet->page_buf[0].offset =
 			vmxferpage_packet->Ranges[i].ByteOffset &
 			(PAGE_SIZE - 1);
 		if ((end >> PAGE_SHIFT) != (start >> PAGE_SHIFT)) {
 			/* Handle frame across multiple pages: */
-			netvsc_packet->page_buf[0].Length =
-				(netvsc_packet->page_buf[0].Pfn <<
+			netvsc_packet->page_buf[0].len =
+				(netvsc_packet->page_buf[0].pfn <<
 				 PAGE_SHIFT)
 				+ PAGE_SIZE - start;
 			bytes_remain = netvsc_packet->total_data_buflen -
-					netvsc_packet->page_buf[0].Length;
+					netvsc_packet->page_buf[0].len;
 			for (j = 1; j < NETVSC_PACKET_MAXPAGE; j++) {
-				netvsc_packet->page_buf[j].Offset = 0;
+				netvsc_packet->page_buf[j].offset = 0;
 				if (bytes_remain <= PAGE_SIZE) {
-					netvsc_packet->page_buf[j].Length =
+					netvsc_packet->page_buf[j].len =
 						bytes_remain;
 					bytes_remain = 0;
 				} else {
-					netvsc_packet->page_buf[j].Length =
+					netvsc_packet->page_buf[j].len =
 						PAGE_SIZE;
 					bytes_remain -= PAGE_SIZE;
 				}
-				netvsc_packet->page_buf[j].Pfn =
+				netvsc_packet->page_buf[j].pfn =
 				    virt_to_phys((void *)(end_virtual -
 						bytes_remain)) >> PAGE_SHIFT;
 				netvsc_packet->page_buf_cnt++;
@@ -1149,12 +1149,12 @@ static void netvsc_receive(struct hv_device *device,
 			   "(pfn %llx, offset %u, len %u)", i,
 			   vmxferpage_packet->Ranges[i].ByteOffset,
 			   vmxferpage_packet->Ranges[i].ByteCount,
-			   netvsc_packet->page_buf[0].Pfn,
-			   netvsc_packet->page_buf[0].Offset,
-			   netvsc_packet->page_buf[0].Length);
+			   netvsc_packet->page_buf[0].pfn,
+			   netvsc_packet->page_buf[0].offset,
+			   netvsc_packet->page_buf[0].len);
 
 		/* Pass it to the upper layer */
-		((struct netvsc_driver *)device->Driver)->
+		((struct netvsc_driver *)device->drv)->
 			recv_cb(device, netvsc_packet);
 
 		netvsc_receive_completion(netvsc_packet->
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 54706a1..95fa810 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -178,18 +178,18 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	packet->total_data_buflen	= skb->len;
 
 	/* Start filling in the page buffers starting after RNDIS buffer. */
-	packet->page_buf[1].Pfn = virt_to_phys(skb->data) >> PAGE_SHIFT;
-	packet->page_buf[1].Offset
+	packet->page_buf[1].pfn = virt_to_phys(skb->data) >> PAGE_SHIFT;
+	packet->page_buf[1].offset
 		= (unsigned long)skb->data & (PAGE_SIZE - 1);
-	packet->page_buf[1].Length = skb_headlen(skb);
+	packet->page_buf[1].len = skb_headlen(skb);
 
 	/* Additional fragments are after SKB data */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *f = &skb_shinfo(skb)->frags[i];
 
-		packet->page_buf[i+2].Pfn = page_to_pfn(f->page);
-		packet->page_buf[i+2].Offset = f->page_offset;
-		packet->page_buf[i+2].Length = f->size;
+		packet->page_buf[i+2].pfn = page_to_pfn(f->page);
+		packet->page_buf[i+2].offset = f->page_offset;
+		packet->page_buf[i+2].len = f->size;
 	}
 
 	/* Set the completion routine */
@@ -277,16 +277,16 @@ static int netvsc_recv_callback(struct hv_device *device_obj,
 	 * hv_netvsc_packet cannot be deallocated
 	 */
 	for (i = 0; i < packet->page_buf_cnt; i++) {
-		data = kmap_atomic(pfn_to_page(packet->page_buf[i].Pfn),
+		data = kmap_atomic(pfn_to_page(packet->page_buf[i].pfn),
 					       KM_IRQ1);
 		data = (void *)(unsigned long)data +
-				packet->page_buf[i].Offset;
+				packet->page_buf[i].offset;
 
-		memcpy(skb_put(skb, packet->page_buf[i].Length), data,
-		       packet->page_buf[i].Length);
+		memcpy(skb_put(skb, packet->page_buf[i].len), data,
+		       packet->page_buf[i].len);
 
 		kunmap_atomic((void *)((unsigned long)data -
-				       packet->page_buf[i].Offset), KM_IRQ1);
+				       packet->page_buf[i].offset), KM_IRQ1);
 	}
 
 	local_irq_restore(flags);
@@ -349,7 +349,7 @@ static int netvsc_probe(struct device *device)
 	struct netvsc_device_info device_info;
 	int ret;
 
-	if (!net_drv_obj->base.OnDeviceAdd)
+	if (!net_drv_obj->base.dev_add)
 		return -1;
 
 	net = alloc_etherdev(sizeof(struct net_device_context));
@@ -365,7 +365,7 @@ static int netvsc_probe(struct device *device)
 	dev_set_drvdata(device, net);
 
 	/* Notify the netvsc driver of the new device */
-	ret = net_drv_obj->base.OnDeviceAdd(device_obj, &device_info);
+	ret = net_drv_obj->base.dev_add(device_obj, &device_info);
 	if (ret != 0) {
 		free_netdev(net);
 		dev_set_drvdata(device, NULL);
@@ -400,7 +400,7 @@ static int netvsc_probe(struct device *device)
 	ret = register_netdev(net);
 	if (ret != 0) {
 		/* Remove the device and release the resource */
-		net_drv_obj->base.OnDeviceRemove(device_obj);
+		net_drv_obj->base.dev_rm(device_obj);
 		free_netdev(net);
 	}
 
@@ -424,7 +424,7 @@ static int netvsc_remove(struct device *device)
 		return 0;
 	}
 
-	if (!net_drv_obj->base.OnDeviceRemove)
+	if (!net_drv_obj->base.dev_rm)
 		return -1;
 
 	/* Stop outbound asap */
@@ -437,7 +437,7 @@ static int netvsc_remove(struct device *device)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = net_drv_obj->base.OnDeviceRemove(device_obj);
+	ret = net_drv_obj->base.dev_rm(device_obj);
 	if (ret != 0) {
 		/* TODO: */
 		DPRINT_ERR(NETVSC, "unable to remove vsc device (ret %d)", ret);
@@ -483,8 +483,8 @@ static void netvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (netvsc_drv_obj->base.OnCleanup)
-		netvsc_drv_obj->base.OnCleanup(&netvsc_drv_obj->base);
+	if (netvsc_drv_obj->base.cleanup)
+		netvsc_drv_obj->base.cleanup(&netvsc_drv_obj->base);
 
 	vmbus_child_driver_unregister(drv_ctx);
 
@@ -505,7 +505,7 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	drv_init(&net_drv_obj->base);
 
 	drv_ctx->driver.name = net_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &net_drv_obj->base.deviceType,
+	memcpy(&drv_ctx->class_id, &net_drv_obj->base.dev_type,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = netvsc_probe;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 53676dc..287e12e 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -255,10 +255,10 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 	packet->total_data_buflen = req->request_msg.msg_len;
 	packet->page_buf_cnt = 1;
 
-	packet->page_buf[0].Pfn = virt_to_phys(&req->request_msg) >>
+	packet->page_buf[0].pfn = virt_to_phys(&req->request_msg) >>
 					PAGE_SHIFT;
-	packet->page_buf[0].Length = req->request_msg.msg_len;
-	packet->page_buf[0].Offset =
+	packet->page_buf[0].len = req->request_msg.msg_len;
+	packet->page_buf[0].offset =
 		(unsigned long)&req->request_msg & (PAGE_SIZE - 1);
 
 	packet->completion.send.send_completion_ctx = req;/* packet; */
@@ -371,8 +371,8 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 	data_offset = RNDIS_HEADER_SIZE + rndis_pkt->data_offset;
 
 	pkt->total_data_buflen -= data_offset;
-	pkt->page_buf[0].Offset += data_offset;
-	pkt->page_buf[0].Length -= data_offset;
+	pkt->page_buf[0].offset += data_offset;
+	pkt->page_buf[0].len -= data_offset;
 
 	pkt->is_data_pkt = true;
 
@@ -383,7 +383,7 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 static int rndis_filter_receive(struct hv_device *dev,
 				struct hv_netvsc_packet	*pkt)
 {
-	struct netvsc_device *net_dev = dev->Extension;
+	struct netvsc_device *net_dev = dev->ext;
 	struct rndis_device *rndis_dev;
 	struct rndis_message rndis_msg;
 	struct rndis_message *rndis_hdr;
@@ -406,10 +406,10 @@ static int rndis_filter_receive(struct hv_device *dev,
 	}
 
 	rndis_hdr = (struct rndis_message *)kmap_atomic(
-			pfn_to_page(pkt->page_buf[0].Pfn), KM_IRQ0);
+			pfn_to_page(pkt->page_buf[0].pfn), KM_IRQ0);
 
 	rndis_hdr = (void *)((unsigned long)rndis_hdr +
-			pkt->page_buf[0].Offset);
+			pkt->page_buf[0].offset);
 
 	/* Make sure we got a valid rndis message */
 	/*
@@ -419,7 +419,7 @@ static int rndis_filter_receive(struct hv_device *dev,
 	 * */
 #if 0
 	if (pkt->total_data_buflen != rndis_hdr->msg_len) {
-		kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset,
+		kunmap_atomic(rndis_hdr - pkt->page_buf[0].offset,
 			      KM_IRQ0);
 
 		DPRINT_ERR(NETVSC, "invalid rndis message? (expected %u "
@@ -443,7 +443,7 @@ static int rndis_filter_receive(struct hv_device *dev,
 			sizeof(struct rndis_message) :
 			rndis_hdr->msg_len);
 
-	kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset, KM_IRQ0);
+	kunmap_atomic(rndis_hdr - pkt->page_buf[0].offset, KM_IRQ0);
 
 	dump_rndis_message(&rndis_msg);
 
@@ -622,10 +622,10 @@ int rndis_filter_init(struct netvsc_driver *drv)
 	rndisDriver->OnLinkStatusChanged = Driver->OnLinkStatusChanged;*/
 
 	/* Save the original dispatch handlers before we override it */
-	rndis_filter.inner_drv.base.OnDeviceAdd = drv->base.OnDeviceAdd;
-	rndis_filter.inner_drv.base.OnDeviceRemove =
-					drv->base.OnDeviceRemove;
-	rndis_filter.inner_drv.base.OnCleanup = drv->base.OnCleanup;
+	rndis_filter.inner_drv.base.dev_add = drv->base.dev_add;
+	rndis_filter.inner_drv.base.dev_rm =
+					drv->base.dev_rm;
+	rndis_filter.inner_drv.base.cleanup = drv->base.cleanup;
 
 	/* ASSERT(Driver->OnSend); */
 	/* ASSERT(Driver->OnReceiveCallback); */
@@ -635,9 +635,9 @@ int rndis_filter_init(struct netvsc_driver *drv)
 					drv->link_status_change;
 
 	/* Override */
-	drv->base.OnDeviceAdd = rndis_filte_device_add;
-	drv->base.OnDeviceRemove = rndis_filter_device_remove;
-	drv->base.OnCleanup = rndis_filter_cleanup;
+	drv->base.dev_add = rndis_filte_device_add;
+	drv->base.dev_rm = rndis_filter_device_remove;
+	drv->base.cleanup = rndis_filter_cleanup;
 	drv->send = rndis_filter_send;
 	/* Driver->QueryLinkStatus = RndisFilterQueryDeviceLinkStatus; */
 	drv->recv_cb = rndis_filter_receive;
@@ -770,7 +770,7 @@ static int rndis_filte_device_add(struct hv_device *dev,
 	 * NOTE! Once the channel is created, we may get a receive callback
 	 * (RndisFilterOnReceive()) before this call is completed
 	 */
-	ret = rndis_filter.inner_drv.base.OnDeviceAdd(dev, additional_info);
+	ret = rndis_filter.inner_drv.base.dev_add(dev, additional_info);
 	if (ret != 0) {
 		kfree(rndisDevice);
 		return ret;
@@ -778,7 +778,7 @@ static int rndis_filte_device_add(struct hv_device *dev,
 
 
 	/* Initialize the rndis device */
-	netDevice = dev->Extension;
+	netDevice = dev->ext;
 	/* ASSERT(netDevice); */
 	/* ASSERT(netDevice->Device); */
 
@@ -818,7 +818,7 @@ static int rndis_filte_device_add(struct hv_device *dev,
 
 static int rndis_filter_device_remove(struct hv_device *dev)
 {
-	struct netvsc_device *net_dev = dev->Extension;
+	struct netvsc_device *net_dev = dev->ext;
 	struct rndis_device *rndis_dev = net_dev->extension;
 
 	/* Halt and release the rndis device */
@@ -828,7 +828,7 @@ static int rndis_filter_device_remove(struct hv_device *dev)
 	net_dev->extension = NULL;
 
 	/* Pass control to inner driver to remove the device */
-	rndis_filter.inner_drv.base.OnDeviceRemove(dev);
+	rndis_filter.inner_drv.base.dev_rm(dev);
 
 	return 0;
 }
@@ -839,7 +839,7 @@ static void rndis_filter_cleanup(struct hv_driver *drv)
 
 int rndis_filter_open(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice = dev->Extension;
+	struct netvsc_device *netDevice = dev->ext;
 
 	if (!netDevice)
 		return -EINVAL;
@@ -849,7 +849,7 @@ int rndis_filter_open(struct hv_device *dev)
 
 int rndis_filter_close(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice = dev->Extension;
+	struct netvsc_device *netDevice = dev->ext;
 
 	if (!netDevice)
 		return -EINVAL;
@@ -884,10 +884,10 @@ static int rndis_filter_send(struct hv_device *dev,
 	rndisPacket->data_len = pkt->total_data_buflen;
 
 	pkt->is_data_pkt = true;
-	pkt->page_buf[0].Pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
-	pkt->page_buf[0].Offset =
+	pkt->page_buf[0].pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
+	pkt->page_buf[0].offset =
 			(unsigned long)rndisMessage & (PAGE_SIZE-1);
-	pkt->page_buf[0].Length = rndisMessageSize;
+	pkt->page_buf[0].len = rndisMessageSize;
 
 	/* Save the packet send completion and context */
 	filterPacket->completion = pkt->completion.send.send_completion;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 5680fb0..b80b1e9 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -94,7 +94,7 @@ static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 	atomic_cmpxchg(&stor_device->ref_count, 0, 2);
 
 	stor_device->device = device;
-	device->Extension = stor_device;
+	device->ext = stor_device;
 
 	return stor_device;
 }
@@ -110,7 +110,7 @@ static inline struct storvsc_device *get_stor_device(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = (struct storvsc_device *)device->Extension;
+	stor_device = (struct storvsc_device *)device->ext;
 	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
 		atomic_inc(&stor_device->ref_count);
 	else
@@ -125,7 +125,7 @@ static inline struct storvsc_device *must_get_stor_device(
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = (struct storvsc_device *)device->Extension;
+	stor_device = (struct storvsc_device *)device->ext;
 	if (stor_device && atomic_read(&stor_device->ref_count))
 		atomic_inc(&stor_device->ref_count);
 	else
@@ -138,7 +138,7 @@ static inline void put_stor_device(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = (struct storvsc_device *)device->Extension;
+	stor_device = (struct storvsc_device *)device->ext;
 	/* ASSERT(stor_device); */
 
 	atomic_dec(&stor_device->ref_count);
@@ -151,7 +151,7 @@ static inline struct storvsc_device *release_stor_device(
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = (struct storvsc_device *)device->Extension;
+	stor_device = (struct storvsc_device *)device->ext;
 	/* ASSERT(stor_device); */
 
 	/* Busy wait until the ref drop to 2, then set it to 1 */
@@ -167,14 +167,14 @@ static inline struct storvsc_device *final_release_stor_device(
 {
 	struct storvsc_device *stor_device;
 
-	stor_device = (struct storvsc_device *)device->Extension;
+	stor_device = (struct storvsc_device *)device->ext;
 	/* ASSERT(stor_device); */
 
 	/* Busy wait until the ref drop to 1, then set it to 0 */
 	while (atomic_cmpxchg(&stor_device->ref_count, 1, 0) != 1)
 		udelay(100);
 
-	device->Extension = NULL;
+	device->ext = NULL;
 	return stor_device;
 }
 
@@ -499,7 +499,7 @@ static int stor_vsc_connect_to_vsp(struct hv_device *device)
 	struct storvsc_driver_object *stor_driver;
 	int ret;
 
-	stor_driver = (struct storvsc_driver_object *)device->Driver;
+	stor_driver = (struct storvsc_driver_object *)device->drv;
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
 	/* Open the channel */
@@ -581,7 +581,7 @@ static int stor_vsc_on_device_remove(struct hv_device *device)
 	struct storvsc_device *stor_device;
 
 	DPRINT_INFO(STORVSC, "disabling storage device (%p)...",
-		    device->Extension);
+		    device->ext);
 
 	stor_device = release_stor_device(device);
 
@@ -597,7 +597,7 @@ static int stor_vsc_on_device_remove(struct hv_device *device)
 	}
 
 	DPRINT_INFO(STORVSC, "removing storage device (%p)...",
-		    device->Extension);
+		    device->ext);
 
 	stor_device = final_release_stor_device(device);
 
@@ -687,7 +687,7 @@ static int stor_vsc_on_io_request(struct hv_device *device,
 		   request_extension);
 
 	DPRINT_DBG(STORVSC, "req %p len %d bus %d, target %d, lun %d cdblen %d",
-		   request, request->data_buffer.Length, request->bus,
+		   request, request->data_buffer.len, request->bus,
 		   request->target_id, request->lun_id, request->cdb_len);
 
 	if (!stor_device) {
@@ -720,7 +720,7 @@ static int stor_vsc_on_io_request(struct hv_device *device,
 	memcpy(&vstor_packet->vm_srb.cdb, request->cdb, request->cdb_len);
 
 	vstor_packet->vm_srb.data_in = request->type;
-	vstor_packet->vm_srb.data_transfer_length = request->data_buffer.Length;
+	vstor_packet->vm_srb.data_transfer_length = request->data_buffer.len;
 
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
@@ -734,7 +734,7 @@ static int stor_vsc_on_io_request(struct hv_device *device,
 		   vstor_packet->vm_srb.sense_info_length,
 		   vstor_packet->vm_srb.cdb_length);
 
-	if (request_extension->request->data_buffer.Length) {
+	if (request_extension->request->data_buffer.len) {
 		ret = vmbus_sendpacket_multipagebuffer(device->channel,
 				&request_extension->request->data_buffer,
 				vstor_packet,
@@ -788,7 +788,7 @@ int stor_vsc_initialize(struct hv_driver *driver)
 	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
 	driver->name = g_driver_name;
-	memcpy(&driver->deviceType, &gStorVscDeviceType,
+	memcpy(&driver->dev_type, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
 	stor_driver->request_ext_size =
@@ -811,9 +811,9 @@ int stor_vsc_initialize(struct hv_driver *driver)
 		    STORVSC_MAX_IO_REQUESTS);
 
 	/* Setup the dispatch table */
-	stor_driver->base.OnDeviceAdd	= stor_vsc_on_device_add;
-	stor_driver->base.OnDeviceRemove	= stor_vsc_on_device_remove;
-	stor_driver->base.OnCleanup	= stor_vsc_on_cleanup;
+	stor_driver->base.dev_add	= stor_vsc_on_device_add;
+	stor_driver->base.dev_rm	= stor_vsc_on_device_remove;
+	stor_driver->base.cleanup	= stor_vsc_on_cleanup;
 
 	stor_driver->on_io_request	= stor_vsc_on_io_request;
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 7651ca2..956c9eb 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -161,7 +161,7 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	}
 
 	drv_ctx->driver.name = storvsc_drv_obj->base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.deviceType,
+	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.dev_type,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = storvsc_probe;
@@ -206,8 +206,8 @@ static void storvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (storvsc_drv_obj->base.OnCleanup)
-		storvsc_drv_obj->base.OnCleanup(&storvsc_drv_obj->base);
+	if (storvsc_drv_obj->base.cleanup)
+		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
 
 	vmbus_child_driver_unregister(drv_ctx);
 	return;
@@ -231,7 +231,7 @@ static int storvsc_probe(struct device *device)
 	struct host_device_context *host_device_ctx;
 	struct storvsc_device_info device_info;
 
-	if (!storvsc_drv_obj->base.OnDeviceAdd)
+	if (!storvsc_drv_obj->base.dev_add)
 		return -1;
 
 	host = scsi_host_alloc(&scsi_driver,
@@ -262,7 +262,7 @@ static int storvsc_probe(struct device *device)
 
 	device_info.port_number = host->host_no;
 	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv_obj->base.OnDeviceAdd(device_obj,
+	ret = storvsc_drv_obj->base.dev_add(device_obj,
 						(void *)&device_info);
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC_DRV, "unable to add scsi vsc device");
@@ -287,7 +287,7 @@ static int storvsc_probe(struct device *device)
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC_DRV, "unable to add scsi host device");
 
-		storvsc_drv_obj->base.OnDeviceRemove(device_obj);
+		storvsc_drv_obj->base.dev_rm(device_obj);
 
 		kmem_cache_destroy(host_device_ctx->request_pool);
 		scsi_host_put(host);
@@ -317,14 +317,14 @@ static int storvsc_remove(struct device *device)
 			(struct host_device_context *)host->hostdata;
 
 
-	if (!storvsc_drv_obj->base.OnDeviceRemove)
+	if (!storvsc_drv_obj->base.dev_rm)
 		return -1;
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = storvsc_drv_obj->base.OnDeviceRemove(device_obj);
+	ret = storvsc_drv_obj->base.dev_rm(device_obj);
 	if (ret != 0) {
 		/* TODO: */
 		DPRINT_ERR(STORVSC, "unable to remove vsc device (ret %d)",
@@ -385,7 +385,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 
 	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
 	scsi_set_resid(scmnd,
-		request->data_buffer.Length - request->bytes_xfer);
+		request->data_buffer.len - request->bytes_xfer);
 
 	scsi_done_fn = scmnd->scsi_done;
 
@@ -693,7 +693,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	request->sense_buffer_size = SCSI_SENSE_BUFFERSIZE;
 
 
-	request->data_buffer.Length = scsi_bufflen(scmnd);
+	request->data_buffer.len = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
 		sg_count = scsi_sg_count(scmnd);
@@ -734,19 +734,19 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 			sg_count = cmd_request->bounce_sgl_count;
 		}
 
-		request->data_buffer.Offset = sgl[0].offset;
+		request->data_buffer.offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
-			request->data_buffer.PfnArray[i] =
+			request->data_buffer.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));
 		}
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
-		request->data_buffer.Offset =
+		request->data_buffer.offset =
 			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		request->data_buffer.PfnArray[0] =
+		request->data_buffer.pfn_array[0] =
 			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 2da3f52..635ce22 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -32,17 +32,17 @@
 
 /* Single-page buffer */
 struct hv_page_buffer {
-	u32 Length;
-	u32 Offset;
-	u64 Pfn;
+	u32 len;
+	u32 offset;
+	u64 pfn;
 };
 
 /* Multiple-page buffer */
 struct hv_multipage_buffer {
 	/* Length and Offset determines the # of pfns in the array */
-	u32 Length;
-	u32 Offset;
-	u64 PfnArray[MAX_MULTIPAGE_BUFFER_COUNT];
+	u32 len;
+	u32 offset;
+	u64 pfn_array[MAX_MULTIPAGE_BUFFER_COUNT];
 };
 
 /* 0x18 includes the proprietary packet header */
@@ -59,29 +59,29 @@ struct hv_driver;
 struct hv_device;
 
 struct hv_dev_port_info {
-	u32 InterruptMask;
-	u32 ReadIndex;
-	u32 WriteIndex;
-	u32 BytesAvailToRead;
-	u32 BytesAvailToWrite;
+	u32 int_mask;
+	u32 read_idx;
+	u32 write_idx;
+	u32 bytes_avail_toread;
+	u32 bytes_avail_towrite;
 };
 
 struct hv_device_info {
-	u32 ChannelId;
-	u32 ChannelState;
-	struct hv_guid ChannelType;
-	struct hv_guid ChannelInstance;
-
-	u32 MonitorId;
-	u32 ServerMonitorPending;
-	u32 ServerMonitorLatency;
-	u32 ServerMonitorConnectionId;
-	u32 ClientMonitorPending;
-	u32 ClientMonitorLatency;
-	u32 ClientMonitorConnectionId;
-
-	struct hv_dev_port_info Inbound;
-	struct hv_dev_port_info Outbound;
+	u32 chn_id;
+	u32 chn_state;
+	struct hv_guid chn_type;
+	struct hv_guid chn_instance;
+
+	u32 monitor_id;
+	u32 server_monitor_pending;
+	u32 server_monitor_latency;
+	u32 server_monitor_conn_id;
+	u32 client_monitor_pending;
+	u32 client_monitor_latency;
+	u32 client_monitor_conn_id;
+
+	struct hv_dev_port_info inbound;
+	struct hv_dev_port_info outbound;
 };
 
 /* Base driver object */
@@ -89,30 +89,30 @@ struct hv_driver {
 	const char *name;
 
 	/* the device type supported by this driver */
-	struct hv_guid deviceType;
+	struct hv_guid dev_type;
 
-	int (*OnDeviceAdd)(struct hv_device *device, void *data);
-	int (*OnDeviceRemove)(struct hv_device *device);
-	void (*OnCleanup)(struct hv_driver *driver);
+	int (*dev_add)(struct hv_device *device, void *data);
+	int (*dev_rm)(struct hv_device *device);
+	void (*cleanup)(struct hv_driver *driver);
 };
 
 /* Base device object */
 struct hv_device {
 	/* the driver for this device */
-	struct hv_driver *Driver;
+	struct hv_driver *drv;
 
 	char name[64];
 
 	/* the device type id of this device */
-	struct hv_guid deviceType;
+	struct hv_guid dev_type;
 
 	/* the device instance id of this device */
-	struct hv_guid deviceInstance;
+	struct hv_guid dev_instance;
 
 	struct vmbus_channel *channel;
 
 	/* Device extension; */
-	void *Extension;
+	void *ext;
 };
 
 #endif /* _VMBUS_API_H_ */
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 0c0aadb..4c56bea 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -165,8 +165,8 @@ static int vmbus_dev_add(struct hv_device *dev, void *info)
 
 	vmbus_device = dev;
 
-	memcpy(&vmbus_device->deviceType, &device_type, sizeof(struct hv_guid));
-	memcpy(&vmbus_device->deviceInstance, &device_id,
+	memcpy(&vmbus_device->dev_type, &device_type, sizeof(struct hv_guid));
+	memcpy(&vmbus_device->dev_instance, &device_id,
 	       sizeof(struct hv_guid));
 
 	/* strcpy(dev->name, "vmbus"); */
@@ -309,37 +309,38 @@ static void get_channel_info(struct hv_device *device,
 
 	vmbus_get_debug_info(device->channel, &debug_info);
 
-	info->ChannelId = debug_info.relid;
-	info->ChannelState = debug_info.state;
-	memcpy(&info->ChannelType, &debug_info.interfacetype,
+	info->chn_id = debug_info.relid;
+	info->chn_state = debug_info.state;
+	memcpy(&info->chn_type, &debug_info.interfacetype,
 	       sizeof(struct hv_guid));
-	memcpy(&info->ChannelInstance, &debug_info.interface_instance,
+	memcpy(&info->chn_instance, &debug_info.interface_instance,
 	       sizeof(struct hv_guid));
 
-	info->MonitorId = debug_info.monitorid;
+	info->monitor_id = debug_info.monitorid;
 
-	info->ServerMonitorPending = debug_info.servermonitor_pending;
-	info->ServerMonitorLatency = debug_info.servermonitor_latency;
-	info->ServerMonitorConnectionId = debug_info.servermonitor_connectionid;
+	info->server_monitor_pending = debug_info.servermonitor_pending;
+	info->server_monitor_latency = debug_info.servermonitor_latency;
+	info->server_monitor_conn_id = debug_info.servermonitor_connectionid;
 
-	info->ClientMonitorPending = debug_info.clientmonitor_pending;
-	info->ClientMonitorLatency = debug_info.clientmonitor_latency;
-	info->ClientMonitorConnectionId = debug_info.clientmonitor_connectionid;
+	info->client_monitor_pending = debug_info.clientmonitor_pending;
+	info->client_monitor_latency = debug_info.clientmonitor_latency;
+	info->client_monitor_conn_id = debug_info.clientmonitor_connectionid;
 
-	info->Inbound.InterruptMask = debug_info.inbound.current_interrupt_mask;
-	info->Inbound.ReadIndex = debug_info.inbound.current_read_index;
-	info->Inbound.WriteIndex = debug_info.inbound.current_write_index;
-	info->Inbound.BytesAvailToRead = debug_info.inbound.bytes_avail_toread;
-	info->Inbound.BytesAvailToWrite =
+	info->inbound.int_mask = debug_info.inbound.current_interrupt_mask;
+	info->inbound.read_idx = debug_info.inbound.current_read_index;
+	info->inbound.write_idx = debug_info.inbound.current_write_index;
+	info->inbound.bytes_avail_toread =
+		debug_info.inbound.bytes_avail_toread;
+	info->inbound.bytes_avail_towrite =
 		debug_info.inbound.bytes_avail_towrite;
 
-	info->Outbound.InterruptMask =
+	info->outbound.int_mask =
 		debug_info.outbound.current_interrupt_mask;
-	info->Outbound.ReadIndex = debug_info.outbound.current_read_index;
-	info->Outbound.WriteIndex = debug_info.outbound.current_write_index;
-	info->Outbound.BytesAvailToRead =
+	info->outbound.read_idx = debug_info.outbound.current_read_index;
+	info->outbound.write_idx = debug_info.outbound.current_write_index;
+	info->outbound.bytes_avail_toread =
 		debug_info.outbound.bytes_avail_toread;
-	info->Outbound.BytesAvailToWrite =
+	info->outbound.bytes_avail_towrite =
 		debug_info.outbound.bytes_avail_towrite;
 }
 
@@ -363,85 +364,85 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
 		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.ChannelType.data[3],
-			       device_info.ChannelType.data[2],
-			       device_info.ChannelType.data[1],
-			       device_info.ChannelType.data[0],
-			       device_info.ChannelType.data[5],
-			       device_info.ChannelType.data[4],
-			       device_info.ChannelType.data[7],
-			       device_info.ChannelType.data[6],
-			       device_info.ChannelType.data[8],
-			       device_info.ChannelType.data[9],
-			       device_info.ChannelType.data[10],
-			       device_info.ChannelType.data[11],
-			       device_info.ChannelType.data[12],
-			       device_info.ChannelType.data[13],
-			       device_info.ChannelType.data[14],
-			       device_info.ChannelType.data[15]);
+			       device_info.chn_type.data[3],
+			       device_info.chn_type.data[2],
+			       device_info.chn_type.data[1],
+			       device_info.chn_type.data[0],
+			       device_info.chn_type.data[5],
+			       device_info.chn_type.data[4],
+			       device_info.chn_type.data[7],
+			       device_info.chn_type.data[6],
+			       device_info.chn_type.data[8],
+			       device_info.chn_type.data[9],
+			       device_info.chn_type.data[10],
+			       device_info.chn_type.data[11],
+			       device_info.chn_type.data[12],
+			       device_info.chn_type.data[13],
+			       device_info.chn_type.data[14],
+			       device_info.chn_type.data[15]);
 	} else if (!strcmp(dev_attr->attr.name, "device_id")) {
 		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			       "%02x%02x%02x%02x%02x%02x%02x%02x}\n",
-			       device_info.ChannelInstance.data[3],
-			       device_info.ChannelInstance.data[2],
-			       device_info.ChannelInstance.data[1],
-			       device_info.ChannelInstance.data[0],
-			       device_info.ChannelInstance.data[5],
-			       device_info.ChannelInstance.data[4],
-			       device_info.ChannelInstance.data[7],
-			       device_info.ChannelInstance.data[6],
-			       device_info.ChannelInstance.data[8],
-			       device_info.ChannelInstance.data[9],
-			       device_info.ChannelInstance.data[10],
-			       device_info.ChannelInstance.data[11],
-			       device_info.ChannelInstance.data[12],
-			       device_info.ChannelInstance.data[13],
-			       device_info.ChannelInstance.data[14],
-			       device_info.ChannelInstance.data[15]);
+			       device_info.chn_instance.data[3],
+			       device_info.chn_instance.data[2],
+			       device_info.chn_instance.data[1],
+			       device_info.chn_instance.data[0],
+			       device_info.chn_instance.data[5],
+			       device_info.chn_instance.data[4],
+			       device_info.chn_instance.data[7],
+			       device_info.chn_instance.data[6],
+			       device_info.chn_instance.data[8],
+			       device_info.chn_instance.data[9],
+			       device_info.chn_instance.data[10],
+			       device_info.chn_instance.data[11],
+			       device_info.chn_instance.data[12],
+			       device_info.chn_instance.data[13],
+			       device_info.chn_instance.data[14],
+			       device_info.chn_instance.data[15]);
 	} else if (!strcmp(dev_attr->attr.name, "state")) {
-		return sprintf(buf, "%d\n", device_info.ChannelState);
+		return sprintf(buf, "%d\n", device_info.chn_state);
 	} else if (!strcmp(dev_attr->attr.name, "id")) {
-		return sprintf(buf, "%d\n", device_info.ChannelId);
+		return sprintf(buf, "%d\n", device_info.chn_id);
 	} else if (!strcmp(dev_attr->attr.name, "out_intr_mask")) {
-		return sprintf(buf, "%d\n", device_info.Outbound.InterruptMask);
+		return sprintf(buf, "%d\n", device_info.outbound.int_mask);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_index")) {
-		return sprintf(buf, "%d\n", device_info.Outbound.ReadIndex);
+		return sprintf(buf, "%d\n", device_info.outbound.read_idx);
 	} else if (!strcmp(dev_attr->attr.name, "out_write_index")) {
-		return sprintf(buf, "%d\n", device_info.Outbound.WriteIndex);
+		return sprintf(buf, "%d\n", device_info.outbound.write_idx);
 	} else if (!strcmp(dev_attr->attr.name, "out_read_bytes_avail")) {
 		return sprintf(buf, "%d\n",
-			       device_info.Outbound.BytesAvailToRead);
+			       device_info.outbound.bytes_avail_toread);
 	} else if (!strcmp(dev_attr->attr.name, "out_write_bytes_avail")) {
 		return sprintf(buf, "%d\n",
-			       device_info.Outbound.BytesAvailToWrite);
+			       device_info.outbound.bytes_avail_towrite);
 	} else if (!strcmp(dev_attr->attr.name, "in_intr_mask")) {
-		return sprintf(buf, "%d\n", device_info.Inbound.InterruptMask);
+		return sprintf(buf, "%d\n", device_info.inbound.int_mask);
 	} else if (!strcmp(dev_attr->attr.name, "in_read_index")) {
-		return sprintf(buf, "%d\n", device_info.Inbound.ReadIndex);
+		return sprintf(buf, "%d\n", device_info.inbound.read_idx);
 	} else if (!strcmp(dev_attr->attr.name, "in_write_index")) {
-		return sprintf(buf, "%d\n", device_info.Inbound.WriteIndex);
+		return sprintf(buf, "%d\n", device_info.inbound.write_idx);
 	} else if (!strcmp(dev_attr->attr.name, "in_read_bytes_avail")) {
 		return sprintf(buf, "%d\n",
-			       device_info.Inbound.BytesAvailToRead);
+			       device_info.inbound.bytes_avail_toread);
 	} else if (!strcmp(dev_attr->attr.name, "in_write_bytes_avail")) {
 		return sprintf(buf, "%d\n",
-			       device_info.Inbound.BytesAvailToWrite);
+			       device_info.inbound.bytes_avail_towrite);
 	} else if (!strcmp(dev_attr->attr.name, "monitor_id")) {
-		return sprintf(buf, "%d\n", device_info.MonitorId);
+		return sprintf(buf, "%d\n", device_info.monitor_id);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_pending")) {
-		return sprintf(buf, "%d\n", device_info.ServerMonitorPending);
+		return sprintf(buf, "%d\n", device_info.server_monitor_pending);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_latency")) {
-		return sprintf(buf, "%d\n", device_info.ServerMonitorLatency);
+		return sprintf(buf, "%d\n", device_info.server_monitor_latency);
 	} else if (!strcmp(dev_attr->attr.name, "server_monitor_conn_id")) {
 		return sprintf(buf, "%d\n",
-			       device_info.ServerMonitorConnectionId);
+			       device_info.server_monitor_conn_id);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_pending")) {
-		return sprintf(buf, "%d\n", device_info.ClientMonitorPending);
+		return sprintf(buf, "%d\n", device_info.client_monitor_pending);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_latency")) {
-		return sprintf(buf, "%d\n", device_info.ClientMonitorLatency);
+		return sprintf(buf, "%d\n", device_info.client_monitor_latency);
 	} else if (!strcmp(dev_attr->attr.name, "client_monitor_conn_id")) {
 		return sprintf(buf, "%d\n",
-			       device_info.ClientMonitorConnectionId);
+			       device_info.client_monitor_conn_id);
 	} else {
 		return 0;
 	}
@@ -479,12 +480,12 @@ static int vmbus_bus_init(void)
 			sizeof(struct vmbus_channel_packet_multipage_buffer));
 
 	driver->name = driver_name;
-	memcpy(&driver->deviceType, &device_type, sizeof(struct hv_guid));
+	memcpy(&driver->dev_type, &device_type, sizeof(struct hv_guid));
 
 	/* Setup dispatch table */
-	driver->OnDeviceAdd	= vmbus_dev_add;
-	driver->OnDeviceRemove	= vmbus_dev_rm;
-	driver->OnCleanup	= vmbus_cleanup;
+	driver->dev_add	= vmbus_dev_add;
+	driver->dev_rm	= vmbus_dev_rm;
+	driver->cleanup	= vmbus_cleanup;
 
 	/* Hypervisor initialization...setup hypercall page..etc */
 	ret = hv_init();
@@ -495,7 +496,7 @@ static int vmbus_bus_init(void)
 	}
 
 	/* Sanity checks */
-	if (!driver->OnDeviceAdd) {
+	if (!driver->dev_add) {
 		DPRINT_ERR(VMBUS_DRV, "OnDeviceAdd() routine not set");
 		ret = -1;
 		goto cleanup;
@@ -536,7 +537,7 @@ static int vmbus_bus_init(void)
 	/* Call to bus driver to add the root device */
 	memset(dev_ctx, 0, sizeof(struct vm_device));
 
-	ret = driver->OnDeviceAdd(&dev_ctx->device_obj, &vector);
+	ret = driver->dev_add(&dev_ctx->device_obj, &vector);
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS_DRV,
 			   "ERROR - Unable to add vmbus root device");
@@ -550,9 +551,9 @@ static int vmbus_bus_init(void)
 	}
 	/* strcpy(dev_ctx->device.bus_id, dev_ctx->device_obj.name); */
 	dev_set_name(&dev_ctx->device, "vmbus_0_0");
-	memcpy(&dev_ctx->class_id, &dev_ctx->device_obj.deviceType,
+	memcpy(&dev_ctx->class_id, &dev_ctx->device_obj.dev_type,
 		sizeof(struct hv_guid));
-	memcpy(&dev_ctx->device_id, &dev_ctx->device_obj.deviceInstance,
+	memcpy(&dev_ctx->device_id, &dev_ctx->device_obj.dev_instance,
 		sizeof(struct hv_guid));
 
 	/* No need to bind a driver to the root device. */
@@ -596,11 +597,11 @@ static void vmbus_bus_exit(void)
 	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
 
 	/* Remove the root device */
-	if (driver->OnDeviceRemove)
-		driver->OnDeviceRemove(&dev_ctx->device_obj);
+	if (driver->dev_rm)
+		driver->dev_rm(&dev_ctx->device_obj);
 
-	if (driver->OnCleanup)
-		driver->OnCleanup(driver);
+	if (driver->cleanup)
+		driver->cleanup(driver);
 
 	/* Unregister the root bus device */
 	device_unregister(&dev_ctx->device);
@@ -706,8 +707,8 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 
 	child_device_obj = &child_device_ctx->device_obj;
 	child_device_obj->channel = channel;
-	memcpy(&child_device_obj->deviceType, type, sizeof(struct hv_guid));
-	memcpy(&child_device_obj->deviceInstance, instance,
+	memcpy(&child_device_obj->dev_type, type, sizeof(struct hv_guid));
+	memcpy(&child_device_obj->dev_instance, instance,
 	       sizeof(struct hv_guid));
 
 	memcpy(&child_device_ctx->class_id, type, sizeof(struct hv_guid));
@@ -875,11 +876,11 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 		struct vmbus_driver_context *vmbus_drv_ctx =
 			(struct vmbus_driver_context *)driver_ctx;
 
-		device_ctx->device_obj.Driver = &vmbus_drv_ctx->drv_obj;
+		device_ctx->device_obj.drv = &vmbus_drv_ctx->drv_obj;
 		DPRINT_INFO(VMBUS_DRV,
 			    "device object (%p) set to driver object (%p)",
 			    &device_ctx->device_obj,
-			    device_ctx->device_obj.Driver);
+			    device_ctx->device_obj.drv);
 
 		match = 1;
 	}
-- 
1.6.3.2

