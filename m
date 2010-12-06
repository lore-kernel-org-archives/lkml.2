Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0LFUb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:31:27 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:59281
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753819Ab0LFU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:57 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 2/8] staging: hv: Convert camel case struct fields in storvsc_api.h to lowercase
Date: Mon,  6 Dec 2010 12:26:45 -0800
Message-Id: <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
References: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Convert camel case struct fields in vstorage.h to lowercase

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c      |   20 +++---
 drivers/staging/hv/blkvsc_drv.c  |  115 ++++++++++++++++++++------------------
 drivers/staging/hv/storvsc.c     |   67 +++++++++++-----------
 drivers/staging/hv/storvsc_api.h |   50 ++++++++--------
 drivers/staging/hv/storvsc_drv.c |   91 +++++++++++++++---------------
 5 files changed, 175 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index d5b0abd..9ac04c3 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -51,12 +51,12 @@ static int BlkVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 	 * id. For IDE devices, the device instance id is formatted as
 	 * <bus id> * - <device id> - 8899 - 000000000000.
 	 */
-	deviceInfo->PathId = Device->deviceInstance.data[3] << 24 |
+	deviceInfo->path_id = Device->deviceInstance.data[3] << 24 |
 			     Device->deviceInstance.data[2] << 16 |
 			     Device->deviceInstance.data[1] << 8  |
 			     Device->deviceInstance.data[0];
 
-	deviceInfo->TargetId = Device->deviceInstance.data[5] << 8 |
+	deviceInfo->target_id = Device->deviceInstance.data[5] << 8 |
 			       Device->deviceInstance.data[4];
 
 	return ret;
@@ -75,7 +75,7 @@ int BlkVscInitialize(struct hv_driver *Driver)
 	Driver->name = gBlkDriverName;
 	memcpy(&Driver->deviceType, &gBlkVscDeviceType, sizeof(struct hv_guid));
 
-	storDriver->RequestExtSize = sizeof(struct storvsc_request_extension);
+	storDriver->request_ext_size = sizeof(struct storvsc_request_extension);
 
 	/*
 	 * Divide the ring buffer data size (which is 1 page less than the ring
@@ -83,20 +83,20 @@ int BlkVscInitialize(struct hv_driver *Driver)
 	 * by the max request size (which is
 	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
 	 */
-	storDriver->MaxOutstandingRequestsPerChannel =
-		((storDriver->RingBufferSize - PAGE_SIZE) /
+	storDriver->max_outstanding_req_per_channel =
+		((storDriver->ring_buffer_size - PAGE_SIZE) /
 		  ALIGN_UP(MAX_MULTIPAGE_BUFFER_PACKET +
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
 	DPRINT_INFO(BLKVSC, "max io outstd %u",
-		    storDriver->MaxOutstandingRequestsPerChannel);
+		    storDriver->max_outstanding_req_per_channel);
 
 	/* Setup the dispatch table */
-	storDriver->Base.OnDeviceAdd = BlkVscOnDeviceAdd;
-	storDriver->Base.OnDeviceRemove = StorVscOnDeviceRemove;
-	storDriver->Base.OnCleanup = StorVscOnCleanup;
-	storDriver->OnIORequest	= StorVscOnIORequest;
+	storDriver->base.OnDeviceAdd = BlkVscOnDeviceAdd;
+	storDriver->base.OnDeviceRemove = StorVscOnDeviceRemove;
+	storDriver->base.OnCleanup = StorVscOnCleanup;
+	storDriver->on_io_request = StorVscOnIORequest;
 
 	return ret;
 }
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 3f81ca5..d65d69e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -177,13 +177,13 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
 	int ret;
 
-	storvsc_drv_obj->RingBufferSize = blkvsc_ringbuffer_size;
+	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
-	drv_init(&storvsc_drv_obj->Base);
+	drv_init(&storvsc_drv_obj->base);
 
-	drv_ctx->driver.name = storvsc_drv_obj->Base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->Base.deviceType,
+	drv_ctx->driver.name = storvsc_drv_obj->base.name;
+	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.deviceType,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = blkvsc_probe;
@@ -230,8 +230,8 @@ static void blkvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (storvsc_drv_obj->Base.OnCleanup)
-		storvsc_drv_obj->Base.OnCleanup(&storvsc_drv_obj->Base);
+	if (storvsc_drv_obj->base.OnCleanup)
+		storvsc_drv_obj->base.OnCleanup(&storvsc_drv_obj->base);
 
 	vmbus_child_driver_unregister(drv_ctx);
 
@@ -262,7 +262,7 @@ static int blkvsc_probe(struct device *device)
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_probe - enter");
 
-	if (!storvsc_drv_obj->Base.OnDeviceAdd) {
+	if (!storvsc_drv_obj->base.OnDeviceAdd) {
 		DPRINT_ERR(BLKVSC_DRV, "OnDeviceAdd() not set");
 		ret = -1;
 		goto Cleanup;
@@ -284,7 +284,7 @@ static int blkvsc_probe(struct device *device)
 
 	blkdev->request_pool = kmem_cache_create(dev_name(&device_ctx->device),
 					sizeof(struct blkvsc_request) +
-					storvsc_drv_obj->RequestExtSize, 0,
+					storvsc_drv_obj->request_ext_size, 0,
 					SLAB_HWCACHE_ALIGN, NULL);
 	if (!blkdev->request_pool) {
 		ret = -ENOMEM;
@@ -293,7 +293,7 @@ static int blkvsc_probe(struct device *device)
 
 
 	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv_obj->Base.OnDeviceAdd(device_obj, &device_info);
+	ret = storvsc_drv_obj->base.OnDeviceAdd(device_obj, &device_info);
 	if (ret != 0) {
 		DPRINT_ERR(BLKVSC_DRV, "unable to add blkvsc device");
 		goto Cleanup;
@@ -301,9 +301,9 @@ static int blkvsc_probe(struct device *device)
 
 	blkdev->device_ctx = device_ctx;
 	/* this identified the device 0 or 1 */
-	blkdev->target = device_info.TargetId;
+	blkdev->target = device_info.target_id;
 	/* this identified the ide ctrl 0 or 1 */
-	blkdev->path = device_info.PathId;
+	blkdev->path = device_info.path_id;
 
 	dev_set_drvdata(device, blkdev);
 
@@ -391,7 +391,7 @@ static int blkvsc_probe(struct device *device)
 	return ret;
 
 Remove:
-	storvsc_drv_obj->Base.OnDeviceRemove(device_obj);
+	storvsc_drv_obj->base.OnDeviceRemove(device_obj);
 
 Cleanup:
 	if (blkdev) {
@@ -459,9 +459,9 @@ static int blkvsc_do_flush(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.DataBuffer.PfnArray[0] = 0;
-	blkvsc_req->request.DataBuffer.Offset = 0;
-	blkvsc_req->request.DataBuffer.Length = 0;
+	blkvsc_req->request.data_buffer.PfnArray[0] = 0;
+	blkvsc_req->request.data_buffer.Offset = 0;
+	blkvsc_req->request.data_buffer.Length = 0;
 
 	blkvsc_req->cmnd[0] = SYNCHRONIZE_CACHE;
 	blkvsc_req->cmd_len = 10;
@@ -506,9 +506,9 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.DataBuffer.PfnArray[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.DataBuffer.Offset = 0;
-	blkvsc_req->request.DataBuffer.Length = 64;
+	blkvsc_req->request.data_buffer.PfnArray[0] = page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.Offset = 0;
+	blkvsc_req->request.data_buffer.Length = 64;
 
 	blkvsc_req->cmnd[0] = INQUIRY;
 	blkvsc_req->cmnd[1] = 0x1;		/* Get product data */
@@ -593,9 +593,9 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.DataBuffer.PfnArray[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.DataBuffer.Offset = 0;
-	blkvsc_req->request.DataBuffer.Length = 8;
+	blkvsc_req->request.data_buffer.PfnArray[0] = page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.Offset = 0;
+	blkvsc_req->request.data_buffer.Length = 8;
 
 	blkvsc_req->cmnd[0] = READ_CAPACITY;
 	blkvsc_req->cmd_len = 16;
@@ -614,7 +614,7 @@ static int blkvsc_do_read_capacity(struct block_device_context *blkdev)
 	wait_event_interruptible(blkvsc_req->wevent, blkvsc_req->cond);
 
 	/* check error */
-	if (blkvsc_req->request.Status) {
+	if (blkvsc_req->request.status) {
 		scsi_normalize_sense(blkvsc_req->sense_buffer,
 				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 
@@ -670,9 +670,9 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	blkvsc_req->req = NULL;
 	blkvsc_req->write = 0;
 
-	blkvsc_req->request.DataBuffer.PfnArray[0] = page_to_pfn(page_buf);
-	blkvsc_req->request.DataBuffer.Offset = 0;
-	blkvsc_req->request.DataBuffer.Length = 12;
+	blkvsc_req->request.data_buffer.PfnArray[0] = page_to_pfn(page_buf);
+	blkvsc_req->request.data_buffer.Offset = 0;
+	blkvsc_req->request.data_buffer.Length = 12;
 
 	blkvsc_req->cmnd[0] = 0x9E; /* READ_CAPACITY16; */
 	blkvsc_req->cmd_len = 16;
@@ -691,7 +691,7 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
 	wait_event_interruptible(blkvsc_req->wevent, blkvsc_req->cond);
 
 	/* check error */
-	if (blkvsc_req->request.Status) {
+	if (blkvsc_req->request.status) {
 		scsi_normalize_sense(blkvsc_req->sense_buffer,
 				     SCSI_SENSE_BUFFERSIZE, &sense_hdr);
 		if (sense_hdr.asc == 0x3A) {
@@ -741,14 +741,14 @@ static int blkvsc_remove(struct device *device)
 
 	DPRINT_DBG(BLKVSC_DRV, "blkvsc_remove()\n");
 
-	if (!storvsc_drv_obj->Base.OnDeviceRemove)
+	if (!storvsc_drv_obj->base.OnDeviceRemove)
 		return -1;
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = storvsc_drv_obj->Base.OnDeviceRemove(device_obj);
+	ret = storvsc_drv_obj->base.OnDeviceRemove(device_obj);
 	if (ret != 0) {
 		/* TODO: */
 		DPRINT_ERR(BLKVSC_DRV,
@@ -865,38 +865,38 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long) blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.DataBuffer.Offset,
-		   blkvsc_req->request.DataBuffer.Length);
+		   blkvsc_req->request.data_buffer.Offset,
+		   blkvsc_req->request.data_buffer.Length);
 #if 0
-	for (i = 0; i < (blkvsc_req->request.DataBuffer.Length >> 12); i++) {
+	for (i = 0; i < (blkvsc_req->request.data_buffer.Length >> 12); i++) {
 		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
 			   "req %p pfn[%d] %llx\n",
 			   blkvsc_req, i,
-			   blkvsc_req->request.DataBuffer.PfnArray[i]);
+			   blkvsc_req->request.data_buffer.PfnArray[i]);
 	}
 #endif
 
 	storvsc_req = &blkvsc_req->request;
-	storvsc_req->Extension = (void *)((unsigned long)blkvsc_req +
+	storvsc_req->extension = (void *)((unsigned long)blkvsc_req +
 					  sizeof(struct blkvsc_request));
 
-	storvsc_req->Type = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
+	storvsc_req->type = blkvsc_req->write ? WRITE_TYPE : READ_TYPE;
 
-	storvsc_req->OnIOCompletion = request_completion;
-	storvsc_req->Context = blkvsc_req;
+	storvsc_req->on_io_completion = request_completion;
+	storvsc_req->context = blkvsc_req;
 
-	storvsc_req->Host = blkdev->port;
-	storvsc_req->Bus = blkdev->path;
-	storvsc_req->TargetId = blkdev->target;
-	storvsc_req->LunId = 0;	 /* this is not really used at all */
+	storvsc_req->host = blkdev->port;
+	storvsc_req->bus = blkdev->path;
+	storvsc_req->target_id = blkdev->target;
+	storvsc_req->lun_id = 0;	 /* this is not really used at all */
 
-	storvsc_req->CdbLen = blkvsc_req->cmd_len;
-	storvsc_req->Cdb = blkvsc_req->cmnd;
+	storvsc_req->cdb_len = blkvsc_req->cmd_len;
+	storvsc_req->cdb = blkvsc_req->cmnd;
 
-	storvsc_req->SenseBuffer = blkvsc_req->sense_buffer;
-	storvsc_req->SenseBufferSize = SCSI_SENSE_BUFFERSIZE;
+	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
+	storvsc_req->sense_buffer_size = SCSI_SENSE_BUFFERSIZE;
 
-	ret = storvsc_drv_obj->OnIORequest(&blkdev->device_ctx->device_obj,
+	ret = storvsc_drv_obj->on_io_request(&blkdev->device_ctx->device_obj,
 					   &blkvsc_req->request);
 	if (ret == 0)
 		blkdev->num_outstanding_reqs++;
@@ -992,8 +992,10 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 
 					blkvsc_req->dev = blkdev;
 					blkvsc_req->req = req;
-					blkvsc_req->request.DataBuffer.Offset = bvec->bv_offset;
-					blkvsc_req->request.DataBuffer.Length = 0;
+					blkvsc_req->request.data_buffer.Offset
+						= bvec->bv_offset;
+					blkvsc_req->request.data_buffer.Length
+						= 0;
 
 					/* Add to the group */
 					blkvsc_req->group = group;
@@ -1007,8 +1009,11 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 				}
 
 				/* Add the curr bvec/segment to the curr blkvsc_req */
-				blkvsc_req->request.DataBuffer.PfnArray[databuf_idx] = page_to_pfn(bvec->bv_page);
-				blkvsc_req->request.DataBuffer.Length += bvec->bv_len;
+				blkvsc_req->request.data_buffer.
+					PfnArray[databuf_idx]
+						= page_to_pfn(bvec->bv_page);
+				blkvsc_req->request.data_buffer.Length
+					+= bvec->bv_len;
 
 				prev_bvec = bvec;
 
@@ -1073,7 +1078,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-			(struct blkvsc_request *)request->Context;
+			(struct blkvsc_request *)request->context;
 	struct block_device_context *blkdev =
 			(struct block_device_context *)blkvsc_req->dev;
 	struct scsi_sense_hdr sense_hdr;
@@ -1083,7 +1088,7 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 
 	blkdev->num_outstanding_reqs--;
 
-	if (blkvsc_req->request.Status)
+	if (blkvsc_req->request.status)
 		if (scsi_normalize_sense(blkvsc_req->sense_buffer,
 					 SCSI_SENSE_BUFFERSIZE, &sense_hdr))
 			scsi_print_sense_hdr("blkvsc", &sense_hdr);
@@ -1095,7 +1100,7 @@ static void blkvsc_cmd_completion(struct hv_storvsc_request *request)
 static void blkvsc_request_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-			(struct blkvsc_request *)request->Context;
+			(struct blkvsc_request *)request->context;
 	struct block_device_context *blkdev =
 			(struct block_device_context *)blkvsc_req->dev;
 	unsigned long flags;
@@ -1110,7 +1115,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 		   (blkvsc_req->write) ? "WRITE" : "READ",
 		   (unsigned long)blkvsc_req->sector_start,
 		   blkvsc_req->sector_count,
-		   blkvsc_req->request.DataBuffer.Length,
+		   blkvsc_req->request.data_buffer.Length,
 		   blkvsc_req->group->outstanding,
 		   blkdev->num_outstanding_reqs);
 
@@ -1137,7 +1142,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 			list_del(&comp_req->req_entry);
 
 			if (!__blk_end_request(comp_req->req,
-				(!comp_req->request.Status ? 0 : -EIO),
+				(!comp_req->request.status ? 0 : -EIO),
 				comp_req->sector_count * blkdev->sector_size)) {
 				/*
 				 * All the sectors have been xferred ie the
@@ -1195,7 +1200,7 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 
 			if (comp_req->req) {
 				ret = __blk_end_request(comp_req->req,
-					(!comp_req->request.Status ? 0 : -EIO),
+					(!comp_req->request.status ? 0 : -EIO),
 					comp_req->sector_count *
 					blkdev->sector_size);
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 96b4ed9..c4346c6 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -370,16 +370,16 @@ static void StorVscOnIOCompletion(struct hv_device *Device,
 	/* ASSERT(request->OnIOCompletion != NULL); */
 
 	/* Copy over the status...etc */
-	request->Status = VStorPacket->vm_srb.scsi_status;
+	request->status = VStorPacket->vm_srb.scsi_status;
 
-	if (request->Status != 0 || VStorPacket->vm_srb.srb_status != 1) {
+	if (request->status != 0 || VStorPacket->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
 			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
-			    request->Cdb[0], VStorPacket->vm_srb.scsi_status,
+			    request->cdb[0], VStorPacket->vm_srb.scsi_status,
 			    VStorPacket->vm_srb.srb_status);
 	}
 
-	if ((request->Status & 0xFF) == 0x02) {
+	if ((request->status & 0xFF) == 0x02) {
 		/* CHECK_CONDITION */
 		if (VStorPacket->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
@@ -389,19 +389,19 @@ static void StorVscOnIOCompletion(struct hv_device *Device,
 
 			/* ASSERT(VStorPacket->vm_srb.sense_info_length <= */
 			/* 	request->SenseBufferSize); */
-			memcpy(request->SenseBuffer,
+			memcpy(request->sense_buffer,
 			       VStorPacket->vm_srb.sense_data,
 			       VStorPacket->vm_srb.sense_info_length);
 
-			request->SenseBufferSize =
+			request->sense_buffer_size =
 					VStorPacket->vm_srb.sense_info_length;
 		}
 	}
 
 	/* TODO: */
-	request->BytesXfer = VStorPacket->vm_srb.data_transfer_length;
+	request->bytes_xfer = VStorPacket->vm_srb.data_transfer_length;
 
-	request->OnIOCompletion(request);
+	request->on_io_completion(request);
 
 	atomic_dec(&storDevice->NumOutstandingRequests);
 
@@ -501,7 +501,8 @@ static int StorVscConnectToVsp(struct hv_device *Device)
 
 	/* Open the channel */
 	ret = vmbus_open(Device->channel,
-			 storDriver->RingBufferSize, storDriver->RingBufferSize,
+			 storDriver->ring_buffer_size,
+			 storDriver->ring_buffer_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
 			 StorVscOnChannelCallback, Device);
@@ -551,13 +552,13 @@ static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 	storChannel->PathId = props->PathId;
 	storChannel->TargetId = props->TargetId; */
 
-	storDevice->PortNumber = deviceInfo->PortNumber;
+	storDevice->PortNumber = deviceInfo->port_number;
 	/* Send it back up */
 	ret = StorVscConnectToVsp(Device);
 
 	/* deviceInfo->PortNumber = storDevice->PortNumber; */
-	deviceInfo->PathId = storDevice->PathId;
-	deviceInfo->TargetId = storDevice->TargetId;
+	deviceInfo->path_id = storDevice->PathId;
+	deviceInfo->target_id = storDevice->TargetId;
 
 	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u\n",
 		   storDevice->PortNumber, storDevice->PathId,
@@ -672,7 +673,7 @@ static int StorVscOnIORequest(struct hv_device *Device,
 	int ret = 0;
 
 	requestExtension =
-		(struct storvsc_request_extension *)Request->Extension;
+		(struct storvsc_request_extension *)Request->extension;
 	vstorPacket = &requestExtension->VStorPacket;
 	storDevice = GetStorDevice(Device);
 
@@ -681,8 +682,8 @@ static int StorVscOnIORequest(struct hv_device *Device,
 		   requestExtension);
 
 	DPRINT_DBG(STORVSC, "req %p len %d bus %d, target %d, lun %d cdblen %d",
-		   Request, Request->DataBuffer.Length, Request->Bus,
-		   Request->TargetId, Request->LunId, Request->CdbLen);
+		   Request, Request->data_buffer.Length, Request->bus,
+		   Request->target_id, Request->lun_id, Request->cdb_len);
 
 	if (!storDevice) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
@@ -702,19 +703,19 @@ static int StorVscOnIORequest(struct hv_device *Device,
 
 	vstorPacket->vm_srb.length = sizeof(struct vmscsi_request);
 
-	vstorPacket->vm_srb.port_number = Request->Host;
-	vstorPacket->vm_srb.path_id = Request->Bus;
-	vstorPacket->vm_srb.target_id = Request->TargetId;
-	vstorPacket->vm_srb.lun = Request->LunId;
+	vstorPacket->vm_srb.port_number = Request->host;
+	vstorPacket->vm_srb.path_id = Request->bus;
+	vstorPacket->vm_srb.target_id = Request->target_id;
+	vstorPacket->vm_srb.lun = Request->lun_id;
 
 	vstorPacket->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
 
 	/* Copy over the scsi command descriptor block */
-	vstorPacket->vm_srb.cdb_length = Request->CdbLen;
-	memcpy(&vstorPacket->vm_srb.cdb, Request->Cdb, Request->CdbLen);
+	vstorPacket->vm_srb.cdb_length = Request->cdb_len;
+	memcpy(&vstorPacket->vm_srb.cdb, Request->cdb, Request->cdb_len);
 
-	vstorPacket->vm_srb.data_in = Request->Type;
-	vstorPacket->vm_srb.data_transfer_length = Request->DataBuffer.Length;
+	vstorPacket->vm_srb.data_in = Request->type;
+	vstorPacket->vm_srb.data_transfer_length = Request->data_buffer.Length;
 
 	vstorPacket->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
@@ -728,9 +729,9 @@ static int StorVscOnIORequest(struct hv_device *Device,
 		   vstorPacket->vm_srb.sense_info_length,
 		   vstorPacket->vm_srb.cdb_length);
 
-	if (requestExtension->Request->DataBuffer.Length) {
+	if (requestExtension->Request->data_buffer.Length) {
 		ret = vmbus_sendpacket_multipagebuffer(Device->channel,
-				&requestExtension->Request->DataBuffer,
+				&requestExtension->Request->data_buffer,
 				vstorPacket,
 				sizeof(struct vstor_packet),
 				(unsigned long)requestExtension);
@@ -785,7 +786,7 @@ int StorVscInitialize(struct hv_driver *Driver)
 	memcpy(&Driver->deviceType, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
-	storDriver->RequestExtSize = sizeof(struct storvsc_request_extension);
+	storDriver->request_ext_size = sizeof(struct storvsc_request_extension);
 
 	/*
 	 * Divide the ring buffer data size (which is 1 page less
@@ -793,22 +794,22 @@ int StorVscInitialize(struct hv_driver *Driver)
 	 * the ring buffer indices) by the max request size (which is
 	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
 	 */
-	storDriver->MaxOutstandingRequestsPerChannel =
-		((storDriver->RingBufferSize - PAGE_SIZE) /
+	storDriver->max_outstanding_req_per_channel =
+		((storDriver->ring_buffer_size - PAGE_SIZE) /
 		  ALIGN_UP(MAX_MULTIPAGE_BUFFER_PACKET +
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
 	DPRINT_INFO(STORVSC, "max io %u, currently %u\n",
-		    storDriver->MaxOutstandingRequestsPerChannel,
+		    storDriver->max_outstanding_req_per_channel,
 		    STORVSC_MAX_IO_REQUESTS);
 
 	/* Setup the dispatch table */
-	storDriver->Base.OnDeviceAdd	= StorVscOnDeviceAdd;
-	storDriver->Base.OnDeviceRemove	= StorVscOnDeviceRemove;
-	storDriver->Base.OnCleanup	= StorVscOnCleanup;
+	storDriver->base.OnDeviceAdd	= StorVscOnDeviceAdd;
+	storDriver->base.OnDeviceRemove	= StorVscOnDeviceRemove;
+	storDriver->base.OnCleanup	= StorVscOnCleanup;
 
-	storDriver->OnIORequest		= StorVscOnIORequest;
+	storDriver->on_io_request	= StorVscOnIORequest;
 
 	return 0;
 }
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 8505a1c..46f031e 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -53,58 +53,58 @@ enum storvsc_request_type{
 };
 
 struct hv_storvsc_request {
-	enum storvsc_request_type Type;
-	u32 Host;
-	u32 Bus;
-	u32 TargetId;
-	u32 LunId;
-	u8 *Cdb;
-	u32 CdbLen;
-	u32 Status;
-	u32 BytesXfer;
+	enum storvsc_request_type type;
+	u32 host;
+	u32 bus;
+	u32 target_id;
+	u32 lun_id;
+	u8 *cdb;
+	u32 cdb_len;
+	u32 status;
+	u32 bytes_xfer;
 
-	unsigned char *SenseBuffer;
-	u32 SenseBufferSize;
+	unsigned char *sense_buffer;
+	u32 sense_buffer_size;
 
-	void *Context;
+	void *context;
 
-	void (*OnIOCompletion)(struct hv_storvsc_request *Request);
+	void (*on_io_completion)(struct hv_storvsc_request *request);
 
 	/* This points to the memory after DataBuffer */
-	void *Extension;
+	void *extension;
 
-	struct hv_multipage_buffer DataBuffer;
+	struct hv_multipage_buffer data_buffer;
 };
 
 /* Represents the block vsc driver */
 struct storvsc_driver_object {
 	/* Must be the first field */
 	/* Which is a bug FIXME! */
-	struct hv_driver Base;
+	struct hv_driver base;
 
 	/* Set by caller (in bytes) */
-	u32 RingBufferSize;
+	u32 ring_buffer_size;
 
 	/* Allocate this much private extension for each I/O request */
-	u32 RequestExtSize;
+	u32 request_ext_size;
 
 	/* Maximum # of requests in flight per channel/device */
-	u32 MaxOutstandingRequestsPerChannel;
+	u32 max_outstanding_req_per_channel;
 
 	/* Specific to this driver */
-	int (*OnIORequest)(struct hv_device *Device,
-			   struct hv_storvsc_request *Request);
+	int (*on_io_request)(struct hv_device *device,
+			   struct hv_storvsc_request *request);
 };
 
 struct storvsc_device_info {
-	unsigned int PortNumber;
-	unsigned char PathId;
-	unsigned char TargetId;
+	unsigned int port_number;
+	unsigned char path_id;
+	unsigned char target_id;
 };
 
 /* Interface */
 int StorVscInitialize(struct hv_driver *driver);
-int StorVscOnHostReset(struct hv_device *Device);
+int StorVscOnHostReset(struct hv_device *device);
 int BlkVscInitialize(struct hv_driver *driver);
 
 #endif /* _STORVSC_API_H_ */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index defc34a..03695ce 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -141,28 +141,28 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
 	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
 
-	storvsc_drv_obj->RingBufferSize = storvsc_ringbuffer_size;
+	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
-	drv_init(&storvsc_drv_obj->Base);
+	drv_init(&storvsc_drv_obj->base);
 
 	DPRINT_INFO(STORVSC_DRV,
 		    "request extension size %u, max outstanding reqs %u",
-		    storvsc_drv_obj->RequestExtSize,
-		    storvsc_drv_obj->MaxOutstandingRequestsPerChannel);
+		    storvsc_drv_obj->request_ext_size,
+		    storvsc_drv_obj->max_outstanding_req_per_channel);
 
-	if (storvsc_drv_obj->MaxOutstandingRequestsPerChannel <
+	if (storvsc_drv_obj->max_outstanding_req_per_channel <
 	    STORVSC_MAX_IO_REQUESTS) {
 		DPRINT_ERR(STORVSC_DRV,
 			   "The number of outstanding io requests (%d) "
 			   "is larger than that supported (%d) internally.",
 			   STORVSC_MAX_IO_REQUESTS,
-			   storvsc_drv_obj->MaxOutstandingRequestsPerChannel);
+			   storvsc_drv_obj->max_outstanding_req_per_channel);
 		return -1;
 	}
 
-	drv_ctx->driver.name = storvsc_drv_obj->Base.name;
-	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->Base.deviceType,
+	drv_ctx->driver.name = storvsc_drv_obj->base.name;
+	memcpy(&drv_ctx->class_id, &storvsc_drv_obj->base.deviceType,
 	       sizeof(struct hv_guid));
 
 	drv_ctx->probe = storvsc_probe;
@@ -207,8 +207,8 @@ static void storvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (storvsc_drv_obj->Base.OnCleanup)
-		storvsc_drv_obj->Base.OnCleanup(&storvsc_drv_obj->Base);
+	if (storvsc_drv_obj->base.OnCleanup)
+		storvsc_drv_obj->base.OnCleanup(&storvsc_drv_obj->base);
 
 	vmbus_child_driver_unregister(drv_ctx);
 	return;
@@ -232,7 +232,7 @@ static int storvsc_probe(struct device *device)
 	struct host_device_context *host_device_ctx;
 	struct storvsc_device_info device_info;
 
-	if (!storvsc_drv_obj->Base.OnDeviceAdd)
+	if (!storvsc_drv_obj->base.OnDeviceAdd)
 		return -1;
 
 	host = scsi_host_alloc(&scsi_driver,
@@ -253,7 +253,7 @@ static int storvsc_probe(struct device *device)
 	host_device_ctx->request_pool =
 				kmem_cache_create(dev_name(&device_ctx->device),
 					sizeof(struct storvsc_cmd_request) +
-					storvsc_drv_obj->RequestExtSize, 0,
+					storvsc_drv_obj->request_ext_size, 0,
 					SLAB_HWCACHE_ALIGN, NULL);
 
 	if (!host_device_ctx->request_pool) {
@@ -261,9 +261,9 @@ static int storvsc_probe(struct device *device)
 		return -ENOMEM;
 	}
 
-	device_info.PortNumber = host->host_no;
+	device_info.port_number = host->host_no;
 	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv_obj->Base.OnDeviceAdd(device_obj,
+	ret = storvsc_drv_obj->base.OnDeviceAdd(device_obj,
 						(void *)&device_info);
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC_DRV, "unable to add scsi vsc device");
@@ -273,8 +273,8 @@ static int storvsc_probe(struct device *device)
 	}
 
 	/* host_device_ctx->port = device_info.PortNumber; */
-	host_device_ctx->path = device_info.PathId;
-	host_device_ctx->target = device_info.TargetId;
+	host_device_ctx->path = device_info.path_id;
+	host_device_ctx->target = device_info.target_id;
 
 	/* max # of devices per target */
 	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
@@ -288,7 +288,7 @@ static int storvsc_probe(struct device *device)
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC_DRV, "unable to add scsi host device");
 
-		storvsc_drv_obj->Base.OnDeviceRemove(device_obj);
+		storvsc_drv_obj->base.OnDeviceRemove(device_obj);
 
 		kmem_cache_destroy(host_device_ctx->request_pool);
 		scsi_host_put(host);
@@ -318,14 +318,14 @@ static int storvsc_remove(struct device *device)
 			(struct host_device_context *)host->hostdata;
 
 
-	if (!storvsc_drv_obj->Base.OnDeviceRemove)
+	if (!storvsc_drv_obj->base.OnDeviceRemove)
 		return -1;
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = storvsc_drv_obj->Base.OnDeviceRemove(device_obj);
+	ret = storvsc_drv_obj->base.OnDeviceRemove(device_obj);
 	if (ret != 0) {
 		/* TODO: */
 		DPRINT_ERR(STORVSC, "unable to remove vsc device (ret %d)",
@@ -351,7 +351,7 @@ static int storvsc_remove(struct device *device)
 static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 {
 	struct storvsc_cmd_request *cmd_request =
-		(struct storvsc_cmd_request *)request->Context;
+		(struct storvsc_cmd_request *)request->context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
 	struct host_device_context *host_device_ctx =
 		(struct host_device_context *)scmnd->device->host->hostdata;
@@ -376,16 +376,17 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 				      cmd_request->bounce_sgl_count);
 	}
 
-	scmnd->result = request->Status;
+	scmnd->result = request->status;
 
 	if (scmnd->result) {
 		if (scsi_normalize_sense(scmnd->sense_buffer,
-					 request->SenseBufferSize, &sense_hdr))
+				request->sense_buffer_size, &sense_hdr))
 			scsi_print_sense_hdr("storvsc", &sense_hdr);
 	}
 
-	/* ASSERT(request->BytesXfer <= request->DataBuffer.Length); */
-	scsi_set_resid(scmnd, request->DataBuffer.Length - request->BytesXfer);
+	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
+	scsi_set_resid(scmnd,
+		request->data_buffer.Length - request->bytes_xfer);
 
 	scsi_done_fn = scmnd->scsi_done;
 
@@ -658,42 +659,42 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	request = &cmd_request->request;
 
-	request->Extension =
+	request->extension =
 		(void *)((unsigned long)cmd_request + request_size);
 	DPRINT_DBG(STORVSC_DRV, "req %p size %d ext %d", request, request_size,
-		   storvsc_drv_obj->RequestExtSize);
+		   storvsc_drv_obj->request_ext_size);
 
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
 	case DMA_TO_DEVICE:
-		request->Type = WRITE_TYPE;
+		request->type = WRITE_TYPE;
 		break;
 	case DMA_FROM_DEVICE:
-		request->Type = READ_TYPE;
+		request->type = READ_TYPE;
 		break;
 	default:
-		request->Type = UNKNOWN_TYPE;
+		request->type = UNKNOWN_TYPE;
 		break;
 	}
 
-	request->OnIOCompletion = storvsc_commmand_completion;
-	request->Context = cmd_request;/* scmnd; */
+	request->on_io_completion = storvsc_commmand_completion;
+	request->context = cmd_request;/* scmnd; */
 
 	/* request->PortId = scmnd->device->channel; */
-	request->Host = host_device_ctx->port;
-	request->Bus = scmnd->device->channel;
-	request->TargetId = scmnd->device->id;
-	request->LunId = scmnd->device->lun;
+	request->host = host_device_ctx->port;
+	request->bus = scmnd->device->channel;
+	request->target_id = scmnd->device->id;
+	request->lun_id = scmnd->device->lun;
 
 	/* ASSERT(scmnd->cmd_len <= 16); */
-	request->CdbLen = scmnd->cmd_len;
-	request->Cdb = scmnd->cmnd;
+	request->cdb_len = scmnd->cmd_len;
+	request->cdb = scmnd->cmnd;
 
-	request->SenseBuffer = scmnd->sense_buffer;
-	request->SenseBufferSize = SCSI_SENSE_BUFFERSIZE;
+	request->sense_buffer = scmnd->sense_buffer;
+	request->sense_buffer_size = SCSI_SENSE_BUFFERSIZE;
 
 
-	request->DataBuffer.Length = scsi_bufflen(scmnd);
+	request->data_buffer.Length = scsi_bufflen(scmnd);
 	if (scsi_sg_count(scmnd)) {
 		sgl = (struct scatterlist *)scsi_sglist(scmnd);
 		sg_count = scsi_sg_count(scmnd);
@@ -734,25 +735,25 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 			sg_count = cmd_request->bounce_sgl_count;
 		}
 
-		request->DataBuffer.Offset = sgl[0].offset;
+		request->data_buffer.Offset = sgl[0].offset;
 
 		for (i = 0; i < sg_count; i++) {
 			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
-			request->DataBuffer.PfnArray[i] =
+			request->data_buffer.PfnArray[i] =
 				page_to_pfn(sg_page((&sgl[i])));
 		}
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
-		request->DataBuffer.Offset =
+		request->data_buffer.Offset =
 			virt_to_phys(scsi_sglist(scmnd)) & (PAGE_SIZE-1);
-		request->DataBuffer.PfnArray[0] =
+		request->data_buffer.PfnArray[0] =
 			virt_to_phys(scsi_sglist(scmnd)) >> PAGE_SHIFT;
 	}
 
 retry_request:
 	/* Invokes the vsc to start an IO */
-	ret = storvsc_drv_obj->OnIORequest(&device_ctx->device_obj,
+	ret = storvsc_drv_obj->on_io_request(&device_ctx->device_obj,
 					   &cmd_request->request);
 	if (ret == -1) {
 		/* no more space */
-- 
1.6.0.2

