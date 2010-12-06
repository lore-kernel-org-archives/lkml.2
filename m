Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab0LFUan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:30:43 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52453
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754488Ab0LFU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:58 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 6/8] staging: hv: Convert camel case local variables in storvsc.c to lowercase
Date: Mon,  6 Dec 2010 12:26:49 -0800
Message-Id: <1291667211-1865-6-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1291667211-1865-5-git-send-email-hjanssen@microsoft.com>
References: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-3-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-4-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-5-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Convert camel case local variables in storvsc.c to lowercase

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/storvsc.c |  496 +++++++++++++++++++++---------------------
 1 files changed, 249 insertions(+), 247 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 6643038..9295113 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -50,7 +50,7 @@ struct storvsc_device {
 	/* 0 indicates the device is being destroyed */
 	atomic_t ref_count;
 
-	atomic_t num_outstanding_requests;
+	atomic_t num_outstanding_req;
 
 	/*
 	 * Each unique Port/Path/Target represents 1 channel ie scsi
@@ -81,119 +81,119 @@ static const struct hv_guid gStorVscDeviceType = {
 };
 
 
-static inline struct storvsc_device *alloc_stor_device(struct hv_device *Device)
+static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
-	storDevice = kzalloc(sizeof(struct storvsc_device), GFP_KERNEL);
-	if (!storDevice)
+	stor_device = kzalloc(sizeof(struct storvsc_device), GFP_KERNEL);
+	if (!stor_device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffics */
 	/* (ie get_stor_device() and must_get_stor_device()) to proceed. */
-	atomic_cmpxchg(&storDevice->ref_count, 0, 2);
+	atomic_cmpxchg(&stor_device->ref_count, 0, 2);
 
-	storDevice->device = Device;
-	Device->Extension = storDevice;
+	stor_device->device = device;
+	device->Extension = stor_device;
 
-	return storDevice;
+	return stor_device;
 }
 
-static inline void free_stor_device(struct storvsc_device *Device)
+static inline void free_stor_device(struct storvsc_device *device)
 {
-	/* ASSERT(atomic_read(&Device->ref_count) == 0); */
-	kfree(Device);
+	/* ASSERT(atomic_read(&device->ref_count) == 0); */
+	kfree(device);
 }
 
 /* Get the stordevice object iff exists and its refcount > 1 */
-static inline struct storvsc_device *get_stor_device(struct hv_device *Device)
+static inline struct storvsc_device *get_stor_device(struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
-	storDevice = (struct storvsc_device *)Device->Extension;
-	if (storDevice && atomic_read(&storDevice->ref_count) > 1)
-		atomic_inc(&storDevice->ref_count);
+	stor_device = (struct storvsc_device *)device->Extension;
+	if (stor_device && atomic_read(&stor_device->ref_count) > 1)
+		atomic_inc(&stor_device->ref_count);
 	else
-		storDevice = NULL;
+		stor_device = NULL;
 
-	return storDevice;
+	return stor_device;
 }
 
 /* Get the stordevice object iff exists and its refcount > 0 */
 static inline struct storvsc_device *must_get_stor_device(
-					struct hv_device *Device)
+					struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
-	storDevice = (struct storvsc_device *)Device->Extension;
-	if (storDevice && atomic_read(&storDevice->ref_count))
-		atomic_inc(&storDevice->ref_count);
+	stor_device = (struct storvsc_device *)device->Extension;
+	if (stor_device && atomic_read(&stor_device->ref_count))
+		atomic_inc(&stor_device->ref_count);
 	else
-		storDevice = NULL;
+		stor_device = NULL;
 
-	return storDevice;
+	return stor_device;
 }
 
-static inline void put_stor_device(struct hv_device *Device)
+static inline void put_stor_device(struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
-	storDevice = (struct storvsc_device *)Device->Extension;
-	/* ASSERT(storDevice); */
+	stor_device = (struct storvsc_device *)device->Extension;
+	/* ASSERT(stor_device); */
 
-	atomic_dec(&storDevice->ref_count);
-	/* ASSERT(atomic_read(&storDevice->ref_count)); */
+	atomic_dec(&stor_device->ref_count);
+	/* ASSERT(atomic_read(&stor_device->ref_count)); */
 }
 
 /* Drop ref count to 1 to effectively disable get_stor_device() */
 static inline struct storvsc_device *release_stor_device(
-					struct hv_device *Device)
+					struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
-	storDevice = (struct storvsc_device *)Device->Extension;
-	/* ASSERT(storDevice); */
+	stor_device = (struct storvsc_device *)device->Extension;
+	/* ASSERT(stor_device); */
 
 	/* Busy wait until the ref drop to 2, then set it to 1 */
-	while (atomic_cmpxchg(&storDevice->ref_count, 2, 1) != 2)
+	while (atomic_cmpxchg(&stor_device->ref_count, 2, 1) != 2)
 		udelay(100);
 
-	return storDevice;
+	return stor_device;
 }
 
-/* Drop ref count to 0. No one can use StorDevice object. */
+/* Drop ref count to 0. No one can use stor_device object. */
 static inline struct storvsc_device *final_release_stor_device(
-			struct hv_device *Device)
+			struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
-	storDevice = (struct storvsc_device *)Device->Extension;
-	/* ASSERT(storDevice); */
+	stor_device = (struct storvsc_device *)device->Extension;
+	/* ASSERT(stor_device); */
 
 	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&storDevice->ref_count, 1, 0) != 1)
+	while (atomic_cmpxchg(&stor_device->ref_count, 1, 0) != 1)
 		udelay(100);
 
-	Device->Extension = NULL;
-	return storDevice;
+	device->Extension = NULL;
+	return stor_device;
 }
 
-static int stor_vsc_channel_init(struct hv_device *Device)
+static int stor_vsc_channel_init(struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
-	struct vstor_packet *vstorPacket;
+	struct vstor_packet *vstor_packet;
 	int ret;
 
-	storDevice = get_stor_device(Device);
-	if (!storDevice) {
+	stor_device = get_stor_device(device);
+	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
 		return -1;
 	}
 
-	request = &storDevice->init_request;
-	vstorPacket = &request->vstor_packet;
+	request = &stor_device->init_request;
+	vstor_packet = &request->vstor_packet;
 
 	/*
 	 * Now, initiate the vsc/vsp initialization protocol on the open
@@ -206,8 +206,8 @@ static int stor_vsc_channel_init(struct hv_device *Device)
 		goto nomem;
 	}
 
-	vstorPacket->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
-	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
+	vstor_packet->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
 	/*SpinlockAcquire(gDriverExt.packetListLock);
 	INSERT_TAIL_LIST(&gDriverExt.packetList, &packet->listEntry.entry);
@@ -215,7 +215,7 @@ static int stor_vsc_channel_init(struct hv_device *Device)
 
 	DPRINT_INFO(STORVSC, "BEGIN_INITIALIZATION_OPERATION...");
 
-	ret = vmbus_sendpacket(Device->channel, vstorPacket,
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
 			       VmbusPacketTypeDataInBand,
@@ -228,25 +228,25 @@ static int stor_vsc_channel_init(struct hv_device *Device)
 
 	osd_waitevent_wait(request->wait_event);
 
-	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstorPacket->status != 0) {
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0) {
 		DPRINT_ERR(STORVSC, "BEGIN_INITIALIZATION_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->operation, vstorPacket->status);
+			   vstor_packet->operation, vstor_packet->status);
 		goto Cleanup;
 	}
 
 	DPRINT_INFO(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION...");
 
 	/* reuse the packet for version range supported */
-	memset(vstorPacket, 0, sizeof(struct vstor_packet));
-	vstorPacket->operation = VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
-	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
+	memset(vstor_packet, 0, sizeof(struct vstor_packet));
+	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	vstorPacket->version.major_minor = VMSTOR_PROTOCOL_VERSION_CURRENT;
-	FILL_VMSTOR_REVISION(vstorPacket->version.revision);
+	vstor_packet->version.major_minor = VMSTOR_PROTOCOL_VERSION_CURRENT;
+	FILL_VMSTOR_REVISION(vstor_packet->version.revision);
 
-	ret = vmbus_sendpacket(Device->channel, vstorPacket,
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
 			       VmbusPacketTypeDataInBand,
@@ -260,24 +260,24 @@ static int stor_vsc_channel_init(struct hv_device *Device)
 	osd_waitevent_wait(request->wait_event);
 
 	/* TODO: Check returned version */
-	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstorPacket->status != 0) {
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0) {
 		DPRINT_ERR(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->operation, vstorPacket->status);
+			   vstor_packet->operation, vstor_packet->status);
 		goto Cleanup;
 	}
 
 	/* Query channel properties */
 	DPRINT_INFO(STORVSC, "QUERY_PROPERTIES_OPERATION...");
 
-	memset(vstorPacket, 0, sizeof(struct vstor_packet));
-	vstorPacket->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
-	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
-	vstorPacket->storage_channel_properties.port_number =
-					storDevice->port_number;
+	memset(vstor_packet, 0, sizeof(struct vstor_packet));
+	vstor_packet->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+	vstor_packet->storage_channel_properties.port_number =
+					stor_device->port_number;
 
-	ret = vmbus_sendpacket(Device->channel, vstorPacket,
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
 			       VmbusPacketTypeDataInBand,
@@ -292,29 +292,29 @@ static int stor_vsc_channel_init(struct hv_device *Device)
 	osd_waitevent_wait(request->wait_event);
 
 	/* TODO: Check returned version */
-	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstorPacket->status != 0) {
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0) {
 		DPRINT_ERR(STORVSC, "QUERY_PROPERTIES_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->operation, vstorPacket->status);
+			   vstor_packet->operation, vstor_packet->status);
 		goto Cleanup;
 	}
 
-	storDevice->path_id = vstorPacket->storage_channel_properties.path_id;
-	storDevice->target_id
-		= vstorPacket->storage_channel_properties.target_id;
+	stor_device->path_id = vstor_packet->storage_channel_properties.path_id;
+	stor_device->target_id
+		= vstor_packet->storage_channel_properties.target_id;
 
 	DPRINT_DBG(STORVSC, "channel flag 0x%x, max xfer len 0x%x",
-		   vstorPacket->storage_channel_properties.flags,
-		   vstorPacket->storage_channel_properties.max_transfer_bytes);
+		   vstor_packet->storage_channel_properties.flags,
+		   vstor_packet->storage_channel_properties.max_transfer_bytes);
 
 	DPRINT_INFO(STORVSC, "END_INITIALIZATION_OPERATION...");
 
-	memset(vstorPacket, 0, sizeof(struct vstor_packet));
-	vstorPacket->operation = VSTOR_OPERATION_END_INITIALIZATION;
-	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
+	memset(vstor_packet, 0, sizeof(struct vstor_packet));
+	vstor_packet->operation = VSTOR_OPERATION_END_INITIALIZATION;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
 
-	ret = vmbus_sendpacket(Device->channel, vstorPacket,
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
 			       VmbusPacketTypeDataInBand,
@@ -328,11 +328,11 @@ static int stor_vsc_channel_init(struct hv_device *Device)
 
 	osd_waitevent_wait(request->wait_event);
 
-	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstorPacket->status != 0) {
+	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstor_packet->status != 0) {
 		DPRINT_ERR(STORVSC, "END_INITIALIZATION_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->operation, vstorPacket->status);
+			   vstor_packet->operation, vstor_packet->status);
 		goto Cleanup;
 	}
 
@@ -342,82 +342,82 @@ Cleanup:
 	kfree(request->wait_event);
 	request->wait_event = NULL;
 nomem:
-	put_stor_device(Device);
+	put_stor_device(device);
 	return ret;
 }
 
-static void stor_vsc_on_io_completion(struct hv_device *Device,
-				  struct vstor_packet *VStorPacket,
-				  struct storvsc_request_extension *RequestExt)
+static void stor_vsc_on_io_completion(struct hv_device *device,
+				  struct vstor_packet *vstor_packet,
+				  struct storvsc_request_extension *request_ext)
 {
 	struct hv_storvsc_request *request;
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
-	storDevice = must_get_stor_device(Device);
-	if (!storDevice) {
+	stor_device = must_get_stor_device(device);
+	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
 		return;
 	}
 
 	DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION - request extension %p "
-		   "completed bytes xfer %u", RequestExt,
-		   VStorPacket->vm_srb.data_transfer_length);
+		   "completed bytes xfer %u", request_ext,
+		   vstor_packet->vm_srb.data_transfer_length);
 
-	/* ASSERT(RequestExt != NULL); */
-	/* ASSERT(RequestExt->Request != NULL); */
+	/* ASSERT(request_ext != NULL); */
+	/* ASSERT(request_ext->request != NULL); */
 
-	request = RequestExt->request;
+	request = request_ext->request;
 
 	/* ASSERT(request->OnIOCompletion != NULL); */
 
 	/* Copy over the status...etc */
-	request->status = VStorPacket->vm_srb.scsi_status;
+	request->status = vstor_packet->vm_srb.scsi_status;
 
-	if (request->status != 0 || VStorPacket->vm_srb.srb_status != 1) {
+	if (request->status != 0 || vstor_packet->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
 			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
-			    request->cdb[0], VStorPacket->vm_srb.scsi_status,
-			    VStorPacket->vm_srb.srb_status);
+			    request->cdb[0], vstor_packet->vm_srb.scsi_status,
+			    vstor_packet->vm_srb.srb_status);
 	}
 
 	if ((request->status & 0xFF) == 0x02) {
 		/* CHECK_CONDITION */
-		if (VStorPacket->vm_srb.srb_status & 0x80) {
+		if (vstor_packet->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
 			DPRINT_WARN(STORVSC, "storvsc pkt %p autosense data "
-				    "valid - len %d\n", RequestExt,
-				    VStorPacket->vm_srb.sense_info_length);
+				    "valid - len %d\n", request_ext,
+				    vstor_packet->vm_srb.sense_info_length);
 
-			/* ASSERT(VStorPacket->vm_srb.sense_info_length <= */
+			/* ASSERT(vstor_packet->vm_srb.sense_info_length <= */
 			/* 	request->SenseBufferSize); */
 			memcpy(request->sense_buffer,
-			       VStorPacket->vm_srb.sense_data,
-			       VStorPacket->vm_srb.sense_info_length);
+			       vstor_packet->vm_srb.sense_data,
+			       vstor_packet->vm_srb.sense_info_length);
 
 			request->sense_buffer_size =
-					VStorPacket->vm_srb.sense_info_length;
+					vstor_packet->vm_srb.sense_info_length;
 		}
 	}
 
 	/* TODO: */
-	request->bytes_xfer = VStorPacket->vm_srb.data_transfer_length;
+	request->bytes_xfer = vstor_packet->vm_srb.data_transfer_length;
 
 	request->on_io_completion(request);
 
-	atomic_dec(&storDevice->num_outstanding_requests);
+	atomic_dec(&stor_device->num_outstanding_req);
 
-	put_stor_device(Device);
+	put_stor_device(device);
 }
 
-static void stor_vsc_on_receive(struct hv_device *Device,
-			     struct vstor_packet *VStorPacket,
-			     struct storvsc_request_extension *RequestExt)
+static void stor_vsc_on_receive(struct hv_device *device,
+			     struct vstor_packet *vstor_packet,
+			     struct storvsc_request_extension *request_ext)
 {
-	switch (VStorPacket->operation) {
+	switch (vstor_packet->operation) {
 	case VSTOR_OPERATION_COMPLETE_IO:
 		DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION");
-		stor_vsc_on_io_completion(Device, VStorPacket, RequestExt);
+		stor_vsc_on_io_completion(device, vstor_packet, request_ext);
 		break;
 	case VSTOR_OPERATION_REMOVE_DEVICE:
 		DPRINT_INFO(STORVSC, "REMOVE_DEVICE_OPERATION");
@@ -426,7 +426,7 @@ static void stor_vsc_on_receive(struct hv_device *Device,
 
 	default:
 		DPRINT_INFO(STORVSC, "Unknown operation received - %d",
-			    VStorPacket->operation);
+			    vstor_packet->operation);
 		break;
 	}
 }
@@ -434,17 +434,17 @@ static void stor_vsc_on_receive(struct hv_device *Device,
 static void stor_vsc_on_channel_callback(void *context)
 {
 	struct hv_device *device = (struct hv_device *)context;
-	struct storvsc_device *storDevice;
-	u32 bytesRecvd;
-	u64 requestId;
+	struct storvsc_device *stor_device;
+	u32 bytes_recvd;
+	u64 request_id;
 	unsigned char packet[ALIGN_UP(sizeof(struct vstor_packet), 8)];
 	struct storvsc_request_extension *request;
 	int ret;
 
 	/* ASSERT(device); */
 
-	storDevice = must_get_stor_device(device);
-	if (!storDevice) {
+	stor_device = must_get_stor_device(device);
+	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
 		return;
@@ -453,25 +453,26 @@ static void stor_vsc_on_channel_callback(void *context)
 	do {
 		ret = vmbus_recvpacket(device->channel, packet,
 				       ALIGN_UP(sizeof(struct vstor_packet), 8),
-				       &bytesRecvd, &requestId);
-		if (ret == 0 && bytesRecvd > 0) {
+				       &bytes_recvd, &request_id);
+		if (ret == 0 && bytes_recvd > 0) {
 			DPRINT_DBG(STORVSC, "receive %d bytes - tid %llx",
-				   bytesRecvd, requestId);
+				   bytes_recvd, request_id);
 
-			/* ASSERT(bytesRecvd == sizeof(struct vstor_packet)); */
+			/* ASSERT(bytes_recvd ==
+					sizeof(struct vstor_packet)); */
 
 			request = (struct storvsc_request_extension *)
-					(unsigned long)requestId;
+					(unsigned long)request_id;
 			/* ASSERT(request);c */
 
-			/* if (vstorPacket.Flags & SYNTHETIC_FLAG) */
-			if ((request == &storDevice->init_request) ||
-			    (request == &storDevice->reset_request)) {
+			/* if (vstor_packet.Flags & SYNTHETIC_FLAG) */
+			if ((request == &stor_device->init_request) ||
+			    (request == &stor_device->reset_request)) {
 				/* DPRINT_INFO(STORVSC,
 				 *             "reset completion - operation "
 				 *             "%u status %u",
-				 *             vstorPacket.Operation,
-				 *             vstorPacket.Status); */
+				 *             vstor_packet.Operation,
+				 *             vstor_packet.Status); */
 
 				memcpy(&request->vstor_packet, packet,
 				       sizeof(struct vstor_packet));
@@ -492,22 +493,22 @@ static void stor_vsc_on_channel_callback(void *context)
 	return;
 }
 
-static int stor_vsc_connect_to_vsp(struct hv_device *Device)
+static int stor_vsc_connect_to_vsp(struct hv_device *device)
 {
 	struct vmstorage_channel_properties props;
-	struct storvsc_driver_object *storDriver;
+	struct storvsc_driver_object *stor_driver;
 	int ret;
 
-	storDriver = (struct storvsc_driver_object *)Device->Driver;
+	stor_driver = (struct storvsc_driver_object *)device->Driver;
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
 	/* Open the channel */
-	ret = vmbus_open(Device->channel,
-			 storDriver->ring_buffer_size,
-			 storDriver->ring_buffer_size,
+	ret = vmbus_open(device->channel,
+			 stor_driver->ring_buffer_size,
+			 stor_driver->ring_buffer_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
-			 stor_vsc_on_channel_callback, Device);
+			 stor_vsc_on_channel_callback, device);
 
 	DPRINT_DBG(STORVSC, "storage props: path id %d, tgt id %d, max xfer %d",
 		   props.path_id, props.target_id, props.max_transfer_bytes);
@@ -517,7 +518,7 @@ static int stor_vsc_connect_to_vsp(struct hv_device *Device)
 		return -1;
 	}
 
-	ret = stor_vsc_channel_init(Device);
+	ret = stor_vsc_channel_init(device);
 
 	return ret;
 }
@@ -526,17 +527,17 @@ static int stor_vsc_connect_to_vsp(struct hv_device *Device)
  * stor_vsc_on_device_add - Callback when the device belonging to this driver
  * is added
  */
-static int stor_vsc_on_device_add(struct hv_device *Device,
-					void *AdditionalInfo)
+static int stor_vsc_on_device_add(struct hv_device *device,
+					void *additional_info)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 	/* struct vmstorage_channel_properties *props; */
-	struct storvsc_device_info *deviceInfo;
+	struct storvsc_device_info *device_info;
 	int ret = 0;
 
-	deviceInfo = (struct storvsc_device_info *)AdditionalInfo;
-	storDevice = alloc_stor_device(Device);
-	if (!storDevice) {
+	device_info = (struct storvsc_device_info *)additional_info;
+	stor_device = alloc_stor_device(device);
+	if (!stor_device) {
 		ret = -1;
 		goto Cleanup;
 	}
@@ -556,17 +557,17 @@ static int stor_vsc_on_device_add(struct hv_device *Device,
 	storChannel->PathId = props->PathId;
 	storChannel->TargetId = props->TargetId; */
 
-	storDevice->port_number = deviceInfo->port_number;
+	stor_device->port_number = device_info->port_number;
 	/* Send it back up */
-	ret = stor_vsc_connect_to_vsp(Device);
+	ret = stor_vsc_connect_to_vsp(device);
 
-	/* deviceInfo->PortNumber = storDevice->PortNumber; */
-	deviceInfo->path_id = storDevice->path_id;
-	deviceInfo->target_id = storDevice->target_id;
+	/* device_info->PortNumber = stor_device->PortNumber; */
+	device_info->path_id = stor_device->path_id;
+	device_info->target_id = stor_device->target_id;
 
 	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u\n",
-		   storDevice->port_number, storDevice->path_id,
-		   storDevice->target_id);
+		   stor_device->port_number, stor_device->path_id,
+		   stor_device->target_id);
 
 Cleanup:
 	return ret;
@@ -575,58 +576,58 @@ Cleanup:
 /*
  * stor_vsc_on_device_remove - Callback when the our device is being removed
  */
-static int stor_vsc_on_device_remove(struct hv_device *Device)
+static int stor_vsc_on_device_remove(struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 
 	DPRINT_INFO(STORVSC, "disabling storage device (%p)...",
-		    Device->Extension);
+		    device->Extension);
 
-	storDevice = release_stor_device(Device);
+	stor_device = release_stor_device(device);
 
 	/*
 	 * At this point, all outbound traffic should be disable. We
 	 * only allow inbound traffic (responses) to proceed so that
 	 * outstanding requests can be completed.
 	 */
-	while (atomic_read(&storDevice->num_outstanding_requests)) {
+	while (atomic_read(&stor_device->num_outstanding_req)) {
 		DPRINT_INFO(STORVSC, "waiting for %d requests to complete...",
-			    atomic_read(&storDevice->num_outstanding_requests));
+			    atomic_read(&stor_device->num_outstanding_req));
 		udelay(100);
 	}
 
 	DPRINT_INFO(STORVSC, "removing storage device (%p)...",
-		    Device->Extension);
+		    device->Extension);
 
-	storDevice = final_release_stor_device(Device);
+	stor_device = final_release_stor_device(device);
 
-	DPRINT_INFO(STORVSC, "storage device (%p) safe to remove", storDevice);
+	DPRINT_INFO(STORVSC, "storage device (%p) safe to remove", stor_device);
 
 	/* Close the channel */
-	vmbus_close(Device->channel);
+	vmbus_close(device->channel);
 
-	free_stor_device(storDevice);
+	free_stor_device(stor_device);
 	return 0;
 }
 
-int stor_vsc_on_host_reset(struct hv_device *Device)
+int stor_vsc_on_host_reset(struct hv_device *device)
 {
-	struct storvsc_device *storDevice;
+	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
-	struct vstor_packet *vstorPacket;
+	struct vstor_packet *vstor_packet;
 	int ret;
 
 	DPRINT_INFO(STORVSC, "resetting host adapter...");
 
-	storDevice = get_stor_device(Device);
-	if (!storDevice) {
+	stor_device = get_stor_device(device);
+	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
 		return -1;
 	}
 
-	request = &storDevice->reset_request;
-	vstorPacket = &request->vstor_packet;
+	request = &stor_device->reset_request;
+	vstor_packet = &request->vstor_packet;
 
 	request->wait_event = osd_waitevent_create();
 	if (!request->wait_event) {
@@ -634,18 +635,18 @@ int stor_vsc_on_host_reset(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	vstorPacket->operation = VSTOR_OPERATION_RESET_BUS;
-	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
-	vstorPacket->vm_srb.path_id = storDevice->path_id;
+	vstor_packet->operation = VSTOR_OPERATION_RESET_BUS;
+	vstor_packet->flags = REQUEST_COMPLETION_FLAG;
+	vstor_packet->vm_srb.path_id = stor_device->path_id;
 
-	ret = vmbus_sendpacket(Device->channel, vstorPacket,
+	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
-			       (unsigned long)&storDevice->reset_request,
+			       (unsigned long)&stor_device->reset_request,
 			       VmbusPacketTypeDataInBand,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC, "Unable to send reset packet %p ret %d",
-			   vstorPacket, ret);
+			   vstor_packet, ret);
 		goto Cleanup;
 	}
 
@@ -661,118 +662,118 @@ int stor_vsc_on_host_reset(struct hv_device *Device)
 	 */
 
 Cleanup:
-	put_stor_device(Device);
+	put_stor_device(device);
 	return ret;
 }
 
 /*
  * stor_vsc_on_io_request - Callback to initiate an I/O request
  */
-static int stor_vsc_on_io_request(struct hv_device *Device,
-			      struct hv_storvsc_request *Request)
+static int stor_vsc_on_io_request(struct hv_device *device,
+			      struct hv_storvsc_request *request)
 {
-	struct storvsc_device *storDevice;
-	struct storvsc_request_extension *requestExtension;
-	struct vstor_packet *vstorPacket;
+	struct storvsc_device *stor_device;
+	struct storvsc_request_extension *request_extension;
+	struct vstor_packet *vstor_packet;
 	int ret = 0;
 
-	requestExtension =
-		(struct storvsc_request_extension *)Request->extension;
-	vstorPacket = &requestExtension->vstor_packet;
-	storDevice = get_stor_device(Device);
+	request_extension =
+		(struct storvsc_request_extension *)request->extension;
+	vstor_packet = &request_extension->vstor_packet;
+	stor_device = get_stor_device(device);
 
 	DPRINT_DBG(STORVSC, "enter - Device %p, DeviceExt %p, Request %p, "
-		   "Extension %p", Device, storDevice, Request,
-		   requestExtension);
+		   "Extension %p", device, stor_device, request,
+		   request_extension);
 
 	DPRINT_DBG(STORVSC, "req %p len %d bus %d, target %d, lun %d cdblen %d",
-		   Request, Request->data_buffer.Length, Request->bus,
-		   Request->target_id, Request->lun_id, Request->cdb_len);
+		   request, request->data_buffer.Length, request->bus,
+		   request->target_id, request->lun_id, request->cdb_len);
 
-	if (!storDevice) {
+	if (!stor_device) {
 		DPRINT_ERR(STORVSC, "unable to get stor device..."
 			   "device being destroyed?");
 		return -2;
 	}
 
-	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, Request->Cdb,
-	 *			Request->CdbLen); */
+	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, request->Cdb,
+	 *			request->CdbLen); */
 
-	requestExtension->request = Request;
-	requestExtension->device  = Device;
+	request_extension->request = request;
+	request_extension->device  = device;
 
-	memset(vstorPacket, 0 , sizeof(struct vstor_packet));
+	memset(vstor_packet, 0 , sizeof(struct vstor_packet));
 
-	vstorPacket->flags |= REQUEST_COMPLETION_FLAG;
+	vstor_packet->flags |= REQUEST_COMPLETION_FLAG;
 
-	vstorPacket->vm_srb.length = sizeof(struct vmscsi_request);
+	vstor_packet->vm_srb.length = sizeof(struct vmscsi_request);
 
-	vstorPacket->vm_srb.port_number = Request->host;
-	vstorPacket->vm_srb.path_id = Request->bus;
-	vstorPacket->vm_srb.target_id = Request->target_id;
-	vstorPacket->vm_srb.lun = Request->lun_id;
+	vstor_packet->vm_srb.port_number = request->host;
+	vstor_packet->vm_srb.path_id = request->bus;
+	vstor_packet->vm_srb.target_id = request->target_id;
+	vstor_packet->vm_srb.lun = request->lun_id;
 
-	vstorPacket->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
+	vstor_packet->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
 
 	/* Copy over the scsi command descriptor block */
-	vstorPacket->vm_srb.cdb_length = Request->cdb_len;
-	memcpy(&vstorPacket->vm_srb.cdb, Request->cdb, Request->cdb_len);
+	vstor_packet->vm_srb.cdb_length = request->cdb_len;
+	memcpy(&vstor_packet->vm_srb.cdb, request->cdb, request->cdb_len);
 
-	vstorPacket->vm_srb.data_in = Request->type;
-	vstorPacket->vm_srb.data_transfer_length = Request->data_buffer.Length;
+	vstor_packet->vm_srb.data_in = request->type;
+	vstor_packet->vm_srb.data_transfer_length = request->data_buffer.Length;
 
-	vstorPacket->operation = VSTOR_OPERATION_EXECUTE_SRB;
+	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
 	DPRINT_DBG(STORVSC, "srb - len %d port %d, path %d, target %d, "
 		   "lun %d senselen %d cdblen %d",
-		   vstorPacket->vm_srb.length,
-		   vstorPacket->vm_srb.port_number,
-		   vstorPacket->vm_srb.path_id,
-		   vstorPacket->vm_srb.target_id,
-		   vstorPacket->vm_srb.lun,
-		   vstorPacket->vm_srb.sense_info_length,
-		   vstorPacket->vm_srb.cdb_length);
-
-	if (requestExtension->request->data_buffer.Length) {
-		ret = vmbus_sendpacket_multipagebuffer(Device->channel,
-				&requestExtension->request->data_buffer,
-				vstorPacket,
+		   vstor_packet->vm_srb.length,
+		   vstor_packet->vm_srb.port_number,
+		   vstor_packet->vm_srb.path_id,
+		   vstor_packet->vm_srb.target_id,
+		   vstor_packet->vm_srb.lun,
+		   vstor_packet->vm_srb.sense_info_length,
+		   vstor_packet->vm_srb.cdb_length);
+
+	if (request_extension->request->data_buffer.Length) {
+		ret = vmbus_sendpacket_multipagebuffer(device->channel,
+				&request_extension->request->data_buffer,
+				vstor_packet,
 				sizeof(struct vstor_packet),
-				(unsigned long)requestExtension);
+				(unsigned long)request_extension);
 	} else {
-		ret = vmbus_sendpacket(Device->channel, vstorPacket,
+		ret = vmbus_sendpacket(device->channel, vstor_packet,
 				       sizeof(struct vstor_packet),
-				       (unsigned long)requestExtension,
+				       (unsigned long)request_extension,
 				       VmbusPacketTypeDataInBand,
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
 	if (ret != 0) {
 		DPRINT_DBG(STORVSC, "Unable to send packet %p ret %d",
-			   vstorPacket, ret);
+			   vstor_packet, ret);
 	}
 
-	atomic_inc(&storDevice->num_outstanding_requests);
+	atomic_inc(&stor_device->num_outstanding_req);
 
-	put_stor_device(Device);
+	put_stor_device(device);
 	return ret;
 }
 
 /*
  * stor_vsc_on_cleanup - Perform any cleanup when the driver is removed
  */
-static void stor_vsc_on_cleanup(struct hv_driver *Driver)
+static void stor_vsc_on_cleanup(struct hv_driver *driver)
 {
 }
 
 /*
  * stor_vsc_initialize - Main entry point
  */
-int stor_vsc_initialize(struct hv_driver *Driver)
+int stor_vsc_initialize(struct hv_driver *driver)
 {
-	struct storvsc_driver_object *storDriver;
+	struct storvsc_driver_object *stor_driver;
 
-	storDriver = (struct storvsc_driver_object *)Driver;
+	stor_driver = (struct storvsc_driver_object *)driver;
 
 	DPRINT_DBG(STORVSC, "sizeof(STORVSC_REQUEST)=%zd "
 		   "sizeof(struct storvsc_request_extension)=%zd "
@@ -784,13 +785,14 @@ int stor_vsc_initialize(struct hv_driver *Driver)
 		   sizeof(struct vmscsi_request));
 
 	/* Make sure we are at least 2 pages since 1 page is used for control */
-	/* ASSERT(storDriver->RingBufferSize >= (PAGE_SIZE << 1)); */
+	/* ASSERT(stor_driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
-	Driver->name = g_driver_name;
-	memcpy(&Driver->deviceType, &gStorVscDeviceType,
+	driver->name = g_driver_name;
+	memcpy(&driver->deviceType, &gStorVscDeviceType,
 	       sizeof(struct hv_guid));
 
-	storDriver->request_ext_size = sizeof(struct storvsc_request_extension);
+	stor_driver->request_ext_size =
+			sizeof(struct storvsc_request_extension);
 
 	/*
 	 * Divide the ring buffer data size (which is 1 page less
@@ -798,22 +800,22 @@ int stor_vsc_initialize(struct hv_driver *Driver)
 	 * the ring buffer indices) by the max request size (which is
 	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
 	 */
-	storDriver->max_outstanding_req_per_channel =
-		((storDriver->ring_buffer_size - PAGE_SIZE) /
+	stor_driver->max_outstanding_req_per_channel =
+		((stor_driver->ring_buffer_size - PAGE_SIZE) /
 		  ALIGN_UP(MAX_MULTIPAGE_BUFFER_PACKET +
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
 	DPRINT_INFO(STORVSC, "max io %u, currently %u\n",
-		    storDriver->max_outstanding_req_per_channel,
+		    stor_driver->max_outstanding_req_per_channel,
 		    STORVSC_MAX_IO_REQUESTS);
 
 	/* Setup the dispatch table */
-	storDriver->base.OnDeviceAdd	= stor_vsc_on_device_add;
-	storDriver->base.OnDeviceRemove	= stor_vsc_on_device_remove;
-	storDriver->base.OnCleanup	= stor_vsc_on_cleanup;
+	stor_driver->base.OnDeviceAdd	= stor_vsc_on_device_add;
+	stor_driver->base.OnDeviceRemove	= stor_vsc_on_device_remove;
+	stor_driver->base.OnCleanup	= stor_vsc_on_cleanup;
 
-	storDriver->on_io_request	= stor_vsc_on_io_request;
+	stor_driver->on_io_request	= stor_vsc_on_io_request;
 
 	return 0;
 }
-- 
1.6.0.2

