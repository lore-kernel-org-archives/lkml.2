Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab0LJUAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:00:16 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53999
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756249Ab0LJUAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:00:12 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 1/7] staging: hv: Convert camel cased variables in netvsc.c to lower cases
Date: Fri, 10 Dec 2010 12:03:54 -0800
Message-Id: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |  852 ++++++++++++++++++++++---------------------
 1 files changed, 445 insertions(+), 407 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 8022781..1c1ee57 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -31,141 +31,141 @@
 
 
 /* Globals */
-static const char *gDriverName = "netvsc";
+static const char *driver_name = "netvsc";
 
 /* {F8615163-DF3E-46c5-913F-F2D2F965ED0E} */
-static const struct hv_guid gNetVscDeviceType = {
+static const struct hv_guid netvsc_device_type = {
 	.data = {
 		0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
 		0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
 	}
 };
 
-static int NetVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo);
+static int NetVscOnDeviceAdd(struct hv_device *device, void *additional_info);
 
-static int NetVscOnDeviceRemove(struct hv_device *Device);
+static int NetVscOnDeviceRemove(struct hv_device *device);
 
-static void NetVscOnCleanup(struct hv_driver *Driver);
+static void NetVscOnCleanup(struct hv_driver *driver);
 
 static void NetVscOnChannelCallback(void *context);
 
-static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device);
+static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *device);
 
-static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device);
+static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *device);
 
-static int NetVscDestroySendBuffer(struct netvsc_device *NetDevice);
+static int NetVscDestroySendBuffer(struct netvsc_device *net_device);
 
-static int NetVscDestroyReceiveBuffer(struct netvsc_device *NetDevice);
+static int NetVscDestroyReceiveBuffer(struct netvsc_device *net_device);
 
-static int NetVscConnectToVsp(struct hv_device *Device);
+static int NetVscConnectToVsp(struct hv_device *device);
 
-static void NetVscOnSendCompletion(struct hv_device *Device,
-				   struct vmpacket_descriptor *Packet);
+static void NetVscOnSendCompletion(struct hv_device *device,
+				   struct vmpacket_descriptor *packet);
 
-static int NetVscOnSend(struct hv_device *Device,
-			struct hv_netvsc_packet *Packet);
+static int NetVscOnSend(struct hv_device *device,
+			struct hv_netvsc_packet *packet);
 
-static void NetVscOnReceive(struct hv_device *Device,
-			    struct vmpacket_descriptor *Packet);
+static void NetVscOnReceive(struct hv_device *device,
+			    struct vmpacket_descriptor *packet);
 
-static void NetVscOnReceiveCompletion(void *Context);
+static void NetVscOnReceiveCompletion(void *context);
 
-static void NetVscSendReceiveCompletion(struct hv_device *Device,
-					u64 TransactionId);
+static void NetVscSendReceiveCompletion(struct hv_device *device,
+					u64 transaction_id);
 
 
-static struct netvsc_device *AllocNetDevice(struct hv_device *Device)
+static struct netvsc_device *AllocNetDevice(struct hv_device *device)
 {
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 
-	netDevice = kzalloc(sizeof(struct netvsc_device), GFP_KERNEL);
-	if (!netDevice)
+	net_device = kzalloc(sizeof(struct netvsc_device), GFP_KERNEL);
+	if (!net_device)
 		return NULL;
 
 	/* Set to 2 to allow both inbound and outbound traffic */
-	atomic_cmpxchg(&netDevice->RefCount, 0, 2);
+	atomic_cmpxchg(&net_device->RefCount, 0, 2);
 
-	netDevice->Device = Device;
-	Device->Extension = netDevice;
+	net_device->Device = device;
+	device->Extension = net_device;
 
-	return netDevice;
+	return net_device;
 }
 
-static void FreeNetDevice(struct netvsc_device *Device)
+static void FreeNetDevice(struct netvsc_device *device)
 {
-	WARN_ON(atomic_read(&Device->RefCount) == 0);
-	Device->Device->Extension = NULL;
-	kfree(Device);
+	WARN_ON(atomic_read(&device->RefCount) == 0);
+	device->Device->Extension = NULL;
+	kfree(device);
 }
 
 
 /* Get the net device object iff exists and its refcount > 1 */
-static struct netvsc_device *GetOutboundNetDevice(struct hv_device *Device)
+static struct netvsc_device *GetOutboundNetDevice(struct hv_device *device)
 {
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 
-	netDevice = Device->Extension;
-	if (netDevice && atomic_read(&netDevice->RefCount) > 1)
-		atomic_inc(&netDevice->RefCount);
+	net_device = device->Extension;
+	if (net_device && atomic_read(&net_device->RefCount) > 1)
+		atomic_inc(&net_device->RefCount);
 	else
-		netDevice = NULL;
+		net_device = NULL;
 
-	return netDevice;
+	return net_device;
 }
 
 /* Get the net device object iff exists and its refcount > 0 */
-static struct netvsc_device *GetInboundNetDevice(struct hv_device *Device)
+static struct netvsc_device *GetInboundNetDevice(struct hv_device *device)
 {
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 
-	netDevice = Device->Extension;
-	if (netDevice && atomic_read(&netDevice->RefCount))
-		atomic_inc(&netDevice->RefCount);
+	net_device = device->Extension;
+	if (net_device && atomic_read(&net_device->RefCount))
+		atomic_inc(&net_device->RefCount);
 	else
-		netDevice = NULL;
+		net_device = NULL;
 
-	return netDevice;
+	return net_device;
 }
 
-static void PutNetDevice(struct hv_device *Device)
+static void PutNetDevice(struct hv_device *device)
 {
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 
-	netDevice = Device->Extension;
+	net_device = device->Extension;
 	/* ASSERT(netDevice); */
 
-	atomic_dec(&netDevice->RefCount);
+	atomic_dec(&net_device->RefCount);
 }
 
-static struct netvsc_device *ReleaseOutboundNetDevice(struct hv_device *Device)
+static struct netvsc_device *ReleaseOutboundNetDevice(struct hv_device *device)
 {
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 
-	netDevice = Device->Extension;
-	if (netDevice == NULL)
+	net_device = device->Extension;
+	if (net_device == NULL)
 		return NULL;
 
 	/* Busy wait until the ref drop to 2, then set it to 1 */
-	while (atomic_cmpxchg(&netDevice->RefCount, 2, 1) != 2)
+	while (atomic_cmpxchg(&net_device->RefCount, 2, 1) != 2)
 		udelay(100);
 
-	return netDevice;
+	return net_device;
 }
 
-static struct netvsc_device *ReleaseInboundNetDevice(struct hv_device *Device)
+static struct netvsc_device *ReleaseInboundNetDevice(struct hv_device *device)
 {
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 
-	netDevice = Device->Extension;
-	if (netDevice == NULL)
+	net_device = device->Extension;
+	if (net_device == NULL)
 		return NULL;
 
 	/* Busy wait until the ref drop to 1, then set it to 0 */
-	while (atomic_cmpxchg(&netDevice->RefCount, 1, 0) != 1)
+	while (atomic_cmpxchg(&net_device->RefCount, 1, 0) != 1)
 		udelay(100);
 
-	Device->Extension = NULL;
-	return netDevice;
+	device->Extension = NULL;
+	return net_device;
 }
 
 /*
@@ -185,8 +185,8 @@ int NetVscInitialize(struct hv_driver *drv)
 	/* Make sure we are at least 2 pages since 1 page is used for control */
 	/* ASSERT(driver->RingBufferSize >= (PAGE_SIZE << 1)); */
 
-	drv->name = gDriverName;
-	memcpy(&drv->deviceType, &gNetVscDeviceType, sizeof(struct hv_guid));
+	drv->name = driver_name;
+	memcpy(&drv->deviceType, &netvsc_device_type, sizeof(struct hv_guid));
 
 	/* Make sure it is set by the caller */
 	/* FIXME: These probably should still be tested in some way */
@@ -204,14 +204,14 @@ int NetVscInitialize(struct hv_driver *drv)
 	return 0;
 }
 
-static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
+static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *device)
 {
 	int ret = 0;
-	struct netvsc_device *netDevice;
-	struct nvsp_message *initPacket;
+	struct netvsc_device *net_device;
+	struct nvsp_message *init_packet;
 
-	netDevice = GetOutboundNetDevice(Device);
-	if (!netDevice) {
+	net_device = GetOutboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
 		return -1;
@@ -220,12 +220,12 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 	/* page-size grandularity */
 	/* ASSERT((netDevice->ReceiveBufferSize & (PAGE_SIZE - 1)) == 0); */
 
-	netDevice->ReceiveBuffer =
-		osd_page_alloc(netDevice->ReceiveBufferSize >> PAGE_SHIFT);
-	if (!netDevice->ReceiveBuffer) {
+	net_device->ReceiveBuffer =
+		osd_page_alloc(net_device->ReceiveBufferSize >> PAGE_SHIFT);
+	if (!net_device->ReceiveBuffer) {
 		DPRINT_ERR(NETVSC,
 			   "unable to allocate receive buffer of size %d",
-			   netDevice->ReceiveBufferSize);
+			   net_device->ReceiveBufferSize);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -240,9 +240,9 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 	 * channel.  Note: This call uses the vmbus connection rather
 	 * than the channel to establish the gpadl handle.
 	 */
-	ret = vmbus_establish_gpadl(Device->channel, netDevice->ReceiveBuffer,
-				    netDevice->ReceiveBufferSize,
-				    &netDevice->ReceiveBufferGpadlHandle);
+	ret = vmbus_establish_gpadl(device->channel, net_device->ReceiveBuffer,
+				    net_device->ReceiveBufferSize,
+				    &net_device->ReceiveBufferGpadlHandle);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
 			   "unable to establish receive buffer's gpadl");
@@ -254,18 +254,20 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendReceiveBuffer...");
 
-	initPacket = &netDevice->ChannelInitPacket;
+	init_packet = &net_device->ChannelInitPacket;
 
-	memset(initPacket, 0, sizeof(struct nvsp_message));
+	memset(init_packet, 0, sizeof(struct nvsp_message));
 
-	initPacket->Header.MessageType = NvspMessage1TypeSendReceiveBuffer;
-	initPacket->Messages.Version1Messages.SendReceiveBuffer.GpadlHandle = netDevice->ReceiveBufferGpadlHandle;
-	initPacket->Messages.Version1Messages.SendReceiveBuffer.Id = NETVSC_RECEIVE_BUFFER_ID;
+	init_packet->Header.MessageType = NvspMessage1TypeSendReceiveBuffer;
+	init_packet->Messages.Version1Messages.SendReceiveBuffer.
+		GpadlHandle = net_device->ReceiveBufferGpadlHandle;
+	init_packet->Messages.Version1Messages.
+		SendReceiveBuffer.Id = NETVSC_RECEIVE_BUFFER_ID;
 
 	/* Send the gpadl notification request */
-	ret = vmbus_sendpacket(Device->channel, initPacket,
+	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
-			       (unsigned long)initPacket,
+			       (unsigned long)init_packet,
 			       VmbusPacketTypeDataInBand,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
@@ -274,13 +276,15 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(netDevice->ChannelInitEvent);
+	osd_waitevent_wait(net_device->ChannelInitEvent);
 
 	/* Check the response */
-	if (initPacket->Messages.Version1Messages.SendReceiveBufferComplete.Status != NvspStatusSuccess) {
+	if (init_packet->Messages.Version1Messages.
+	    SendReceiveBufferComplete.Status != NvspStatusSuccess) {
 		DPRINT_ERR(NETVSC, "Unable to complete receive buffer "
 			   "initialzation with NetVsp - status %d",
-			   initPacket->Messages.Version1Messages.SendReceiveBufferComplete.Status);
+			   init_packet->Messages.Version1Messages.
+			   SendReceiveBufferComplete.Status);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -289,32 +293,36 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 	/* ASSERT(netDevice->ReceiveSectionCount == 0); */
 	/* ASSERT(netDevice->ReceiveSections == NULL); */
 
-	netDevice->ReceiveSectionCount = initPacket->Messages.Version1Messages.SendReceiveBufferComplete.NumSections;
+	net_device->ReceiveSectionCount = init_packet->Messages.
+		Version1Messages.SendReceiveBufferComplete.NumSections;
 
-	netDevice->ReceiveSections = kmalloc(netDevice->ReceiveSectionCount * sizeof(struct nvsp_1_receive_buffer_section), GFP_KERNEL);
-	if (netDevice->ReceiveSections == NULL) {
+	net_device->ReceiveSections = kmalloc(net_device->ReceiveSectionCount
+		* sizeof(struct nvsp_1_receive_buffer_section), GFP_KERNEL);
+	if (net_device->ReceiveSections == NULL) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	memcpy(netDevice->ReceiveSections,
-		initPacket->Messages.Version1Messages.SendReceiveBufferComplete.Sections,
-		netDevice->ReceiveSectionCount * sizeof(struct nvsp_1_receive_buffer_section));
+	memcpy(net_device->ReceiveSections,
+		init_packet->Messages.Version1Messages.
+	       SendReceiveBufferComplete.Sections,
+		net_device->ReceiveSectionCount *
+	       sizeof(struct nvsp_1_receive_buffer_section));
 
 	DPRINT_INFO(NETVSC, "Receive sections info (count %d, offset %d, "
 		    "endoffset %d, suballoc size %d, num suballocs %d)",
-		    netDevice->ReceiveSectionCount,
-		    netDevice->ReceiveSections[0].Offset,
-		    netDevice->ReceiveSections[0].EndOffset,
-		    netDevice->ReceiveSections[0].SubAllocationSize,
-		    netDevice->ReceiveSections[0].NumSubAllocations);
+		    net_device->ReceiveSectionCount,
+		    net_device->ReceiveSections[0].Offset,
+		    net_device->ReceiveSections[0].EndOffset,
+		    net_device->ReceiveSections[0].SubAllocationSize,
+		    net_device->ReceiveSections[0].NumSubAllocations);
 
 	/*
 	 * For 1st release, there should only be 1 section that represents the
 	 * entire receive buffer
 	 */
-	if (netDevice->ReceiveSectionCount != 1 ||
-	    netDevice->ReceiveSections->Offset != 0) {
+	if (net_device->ReceiveSectionCount != 1 ||
+	    net_device->ReceiveSections->Offset != 0) {
 		ret = -1;
 		goto Cleanup;
 	}
@@ -322,26 +330,26 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 	goto Exit;
 
 Cleanup:
-	NetVscDestroyReceiveBuffer(netDevice);
+	NetVscDestroyReceiveBuffer(net_device);
 
 Exit:
-	PutNetDevice(Device);
+	PutNetDevice(device);
 	return ret;
 }
 
-static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
+static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *device)
 {
 	int ret = 0;
-	struct netvsc_device *netDevice;
-	struct nvsp_message *initPacket;
+	struct netvsc_device *net_device;
+	struct nvsp_message *init_packet;
 
-	netDevice = GetOutboundNetDevice(Device);
-	if (!netDevice) {
+	net_device = GetOutboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
 		return -1;
 	}
-	if (netDevice->SendBufferSize <= 0) {
+	if (net_device->SendBufferSize <= 0) {
 		ret = -EINVAL;
 		goto Cleanup;
 	}
@@ -349,11 +357,11 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
 	/* page-size grandularity */
 	/* ASSERT((netDevice->SendBufferSize & (PAGE_SIZE - 1)) == 0); */
 
-	netDevice->SendBuffer =
-		osd_page_alloc(netDevice->SendBufferSize >> PAGE_SHIFT);
-	if (!netDevice->SendBuffer) {
+	net_device->SendBuffer =
+		osd_page_alloc(net_device->SendBufferSize >> PAGE_SHIFT);
+	if (!net_device->SendBuffer) {
 		DPRINT_ERR(NETVSC, "unable to allocate send buffer of size %d",
-			   netDevice->SendBufferSize);
+			   net_device->SendBufferSize);
 		ret = -1;
 		goto Cleanup;
 	}
@@ -367,9 +375,9 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
 	 * channel.  Note: This call uses the vmbus connection rather
 	 * than the channel to establish the gpadl handle.
 	 */
-	ret = vmbus_establish_gpadl(Device->channel, netDevice->SendBuffer,
-				    netDevice->SendBufferSize,
-				    &netDevice->SendBufferGpadlHandle);
+	ret = vmbus_establish_gpadl(device->channel, net_device->SendBuffer,
+				    net_device->SendBufferSize,
+				    &net_device->SendBufferGpadlHandle);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to establish send buffer's gpadl");
 		goto Cleanup;
@@ -380,18 +388,20 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendSendBuffer...");
 
-	initPacket = &netDevice->ChannelInitPacket;
+	init_packet = &net_device->ChannelInitPacket;
 
-	memset(initPacket, 0, sizeof(struct nvsp_message));
+	memset(init_packet, 0, sizeof(struct nvsp_message));
 
-	initPacket->Header.MessageType = NvspMessage1TypeSendSendBuffer;
-	initPacket->Messages.Version1Messages.SendReceiveBuffer.GpadlHandle = netDevice->SendBufferGpadlHandle;
-	initPacket->Messages.Version1Messages.SendReceiveBuffer.Id = NETVSC_SEND_BUFFER_ID;
+	init_packet->Header.MessageType = NvspMessage1TypeSendSendBuffer;
+	init_packet->Messages.Version1Messages.SendReceiveBuffer.
+		GpadlHandle = net_device->SendBufferGpadlHandle;
+	init_packet->Messages.Version1Messages.SendReceiveBuffer.Id =
+		NETVSC_SEND_BUFFER_ID;
 
 	/* Send the gpadl notification request */
-	ret = vmbus_sendpacket(Device->channel, initPacket,
+	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
-			       (unsigned long)initPacket,
+			       (unsigned long)init_packet,
 			       VmbusPacketTypeDataInBand,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
@@ -400,32 +410,35 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(netDevice->ChannelInitEvent);
+	osd_waitevent_wait(net_device->ChannelInitEvent);
 
 	/* Check the response */
-	if (initPacket->Messages.Version1Messages.SendSendBufferComplete.Status != NvspStatusSuccess) {
+	if (init_packet->Messages.Version1Messages.
+	    SendSendBufferComplete.Status != NvspStatusSuccess) {
 		DPRINT_ERR(NETVSC, "Unable to complete send buffer "
 			   "initialzation with NetVsp - status %d",
-			   initPacket->Messages.Version1Messages.SendSendBufferComplete.Status);
+			   init_packet->Messages.Version1Messages.
+			   SendSendBufferComplete.Status);
 		ret = -1;
 		goto Cleanup;
 	}
 
-	netDevice->SendSectionSize = initPacket->Messages.Version1Messages.SendSendBufferComplete.SectionSize;
+	net_device->SendSectionSize = init_packet->
+	Messages.Version1Messages.SendSendBufferComplete.SectionSize;
 
 	goto Exit;
 
 Cleanup:
-	NetVscDestroySendBuffer(netDevice);
+	NetVscDestroySendBuffer(net_device);
 
 Exit:
-	PutNetDevice(Device);
+	PutNetDevice(device);
 	return ret;
 }
 
-static int NetVscDestroyReceiveBuffer(struct netvsc_device *NetDevice)
+static int NetVscDestroyReceiveBuffer(struct netvsc_device *net_device)
 {
-	struct nvsp_message *revokePacket;
+	struct nvsp_message *revoke_packet;
 	int ret = 0;
 
 	/*
@@ -434,20 +447,23 @@ static int NetVscDestroyReceiveBuffer(struct netvsc_device *NetDevice)
 	 * NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
 	 * to send a revoke msg here
 	 */
-	if (NetDevice->ReceiveSectionCount) {
+	if (net_device->ReceiveSectionCount) {
 		DPRINT_INFO(NETVSC,
 			    "Sending NvspMessage1TypeRevokeReceiveBuffer...");
 
 		/* Send the revoke receive buffer */
-		revokePacket = &NetDevice->RevokePacket;
-		memset(revokePacket, 0, sizeof(struct nvsp_message));
+		revoke_packet = &net_device->RevokePacket;
+		memset(revoke_packet, 0, sizeof(struct nvsp_message));
 
-		revokePacket->Header.MessageType = NvspMessage1TypeRevokeReceiveBuffer;
-		revokePacket->Messages.Version1Messages.RevokeReceiveBuffer.Id = NETVSC_RECEIVE_BUFFER_ID;
+		revoke_packet->Header.MessageType =
+			NvspMessage1TypeRevokeReceiveBuffer;
+		revoke_packet->Messages.Version1Messages.
+		RevokeReceiveBuffer.Id = NETVSC_RECEIVE_BUFFER_ID;
 
-		ret = vmbus_sendpacket(NetDevice->Device->channel, revokePacket,
+		ret = vmbus_sendpacket(net_device->Device->channel,
+				       revoke_packet,
 				       sizeof(struct nvsp_message),
-				       (unsigned long)revokePacket,
+				       (unsigned long)revoke_packet,
 				       VmbusPacketTypeDataInBand, 0);
 		/*
 		 * If we failed here, we might as well return and
@@ -461,11 +477,11 @@ static int NetVscDestroyReceiveBuffer(struct netvsc_device *NetDevice)
 	}
 
 	/* Teardown the gpadl on the vsp end */
-	if (NetDevice->ReceiveBufferGpadlHandle) {
+	if (net_device->ReceiveBufferGpadlHandle) {
 		DPRINT_INFO(NETVSC, "Tearing down receive buffer's GPADL...");
 
-		ret = vmbus_teardown_gpadl(NetDevice->Device->channel,
-					   NetDevice->ReceiveBufferGpadlHandle);
+		ret = vmbus_teardown_gpadl(net_device->Device->channel,
+			   net_device->ReceiveBufferGpadlHandle);
 
 		/* If we failed here, we might as well return and have a leak rather than continue and a bugchk */
 		if (ret != 0) {
@@ -473,30 +489,30 @@ static int NetVscDestroyReceiveBuffer(struct netvsc_device *NetDevice)
 				   "unable to teardown receive buffer's gpadl");
 			return -1;
 		}
-		NetDevice->ReceiveBufferGpadlHandle = 0;
+		net_device->ReceiveBufferGpadlHandle = 0;
 	}
 
-	if (NetDevice->ReceiveBuffer) {
+	if (net_device->ReceiveBuffer) {
 		DPRINT_INFO(NETVSC, "Freeing up receive buffer...");
 
 		/* Free up the receive buffer */
-		osd_page_free(NetDevice->ReceiveBuffer,
-			     NetDevice->ReceiveBufferSize >> PAGE_SHIFT);
-		NetDevice->ReceiveBuffer = NULL;
+		osd_page_free(net_device->ReceiveBuffer,
+			     net_device->ReceiveBufferSize >> PAGE_SHIFT);
+		net_device->ReceiveBuffer = NULL;
 	}
 
-	if (NetDevice->ReceiveSections) {
-		NetDevice->ReceiveSectionCount = 0;
-		kfree(NetDevice->ReceiveSections);
-		NetDevice->ReceiveSections = NULL;
+	if (net_device->ReceiveSections) {
+		net_device->ReceiveSectionCount = 0;
+		kfree(net_device->ReceiveSections);
+		net_device->ReceiveSections = NULL;
 	}
 
 	return ret;
 }
 
-static int NetVscDestroySendBuffer(struct netvsc_device *NetDevice)
+static int NetVscDestroySendBuffer(struct netvsc_device *net_device)
 {
-	struct nvsp_message *revokePacket;
+	struct nvsp_message *revoke_packet;
 	int ret = 0;
 
 	/*
@@ -505,20 +521,23 @@ static int NetVscDestroySendBuffer(struct netvsc_device *NetDevice)
 	 *  NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
 	 *  to send a revoke msg here
 	 */
-	if (NetDevice->SendSectionSize) {
+	if (net_device->SendSectionSize) {
 		DPRINT_INFO(NETVSC,
 			    "Sending NvspMessage1TypeRevokeSendBuffer...");
 
 		/* Send the revoke send buffer */
-		revokePacket = &NetDevice->RevokePacket;
-		memset(revokePacket, 0, sizeof(struct nvsp_message));
+		revoke_packet = &net_device->RevokePacket;
+		memset(revoke_packet, 0, sizeof(struct nvsp_message));
 
-		revokePacket->Header.MessageType = NvspMessage1TypeRevokeSendBuffer;
-		revokePacket->Messages.Version1Messages.RevokeSendBuffer.Id = NETVSC_SEND_BUFFER_ID;
+		revoke_packet->Header.MessageType =
+			NvspMessage1TypeRevokeSendBuffer;
+		revoke_packet->Messages.Version1Messages.
+			RevokeSendBuffer.Id = NETVSC_SEND_BUFFER_ID;
 
-		ret = vmbus_sendpacket(NetDevice->Device->channel, revokePacket,
+		ret = vmbus_sendpacket(net_device->Device->channel,
+				       revoke_packet,
 				       sizeof(struct nvsp_message),
-				       (unsigned long)revokePacket,
+				       (unsigned long)revoke_packet,
 				       VmbusPacketTypeDataInBand, 0);
 		/*
 		 * If we failed here, we might as well return and have a leak
@@ -532,10 +551,10 @@ static int NetVscDestroySendBuffer(struct netvsc_device *NetDevice)
 	}
 
 	/* Teardown the gpadl on the vsp end */
-	if (NetDevice->SendBufferGpadlHandle) {
+	if (net_device->SendBufferGpadlHandle) {
 		DPRINT_INFO(NETVSC, "Tearing down send buffer's GPADL...");
-		ret = vmbus_teardown_gpadl(NetDevice->Device->channel,
-					   NetDevice->SendBufferGpadlHandle);
+		ret = vmbus_teardown_gpadl(net_device->Device->channel,
+					   net_device->SendBufferGpadlHandle);
 
 		/*
 		 * If we failed here, we might as well return and have a leak
@@ -546,49 +565,51 @@ static int NetVscDestroySendBuffer(struct netvsc_device *NetDevice)
 				   "gpadl");
 			return -1;
 		}
-		NetDevice->SendBufferGpadlHandle = 0;
+		net_device->SendBufferGpadlHandle = 0;
 	}
 
-	if (NetDevice->SendBuffer) {
+	if (net_device->SendBuffer) {
 		DPRINT_INFO(NETVSC, "Freeing up send buffer...");
 
 		/* Free up the receive buffer */
-		osd_page_free(NetDevice->SendBuffer,
-			     NetDevice->SendBufferSize >> PAGE_SHIFT);
-		NetDevice->SendBuffer = NULL;
+		osd_page_free(net_device->SendBuffer,
+			     net_device->SendBufferSize >> PAGE_SHIFT);
+		net_device->SendBuffer = NULL;
 	}
 
 	return ret;
 }
 
 
-static int NetVscConnectToVsp(struct hv_device *Device)
+static int NetVscConnectToVsp(struct hv_device *device)
 {
 	int ret;
-	struct netvsc_device *netDevice;
-	struct nvsp_message *initPacket;
-	int ndisVersion;
+	struct netvsc_device *net_device;
+	struct nvsp_message *init_packet;
+	int ndis_version;
 
-	netDevice = GetOutboundNetDevice(Device);
-	if (!netDevice) {
+	net_device = GetOutboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
 		return -1;
 	}
 
-	initPacket = &netDevice->ChannelInitPacket;
+	init_packet = &net_device->ChannelInitPacket;
 
-	memset(initPacket, 0, sizeof(struct nvsp_message));
-	initPacket->Header.MessageType = NvspMessageTypeInit;
-	initPacket->Messages.InitMessages.Init.MinProtocolVersion = NVSP_MIN_PROTOCOL_VERSION;
-	initPacket->Messages.InitMessages.Init.MaxProtocolVersion = NVSP_MAX_PROTOCOL_VERSION;
+	memset(init_packet, 0, sizeof(struct nvsp_message));
+	init_packet->Header.MessageType = NvspMessageTypeInit;
+	init_packet->Messages.InitMessages.Init.MinProtocolVersion =
+		NVSP_MIN_PROTOCOL_VERSION;
+	init_packet->Messages.InitMessages.Init.MaxProtocolVersion =
+		NVSP_MAX_PROTOCOL_VERSION;
 
 	DPRINT_INFO(NETVSC, "Sending NvspMessageTypeInit...");
 
 	/* Send the init request */
-	ret = vmbus_sendpacket(Device->channel, initPacket,
+	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
-			       (unsigned long)initPacket,
+			       (unsigned long)init_packet,
 			       VmbusPacketTypeDataInBand,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
@@ -597,47 +618,52 @@ static int NetVscConnectToVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_waitevent_wait(netDevice->ChannelInitEvent);
+	osd_waitevent_wait(net_device->ChannelInitEvent);
 
 	/* Now, check the response */
 	/* ASSERT(initPacket->Messages.InitMessages.InitComplete.MaximumMdlChainLength <= MAX_MULTIPAGE_BUFFER_COUNT); */
 	DPRINT_INFO(NETVSC, "NvspMessageTypeInit status(%d) max mdl chain (%d)",
-		initPacket->Messages.InitMessages.InitComplete.Status,
-		initPacket->Messages.InitMessages.InitComplete.MaximumMdlChainLength);
+		init_packet->Messages.InitMessages.InitComplete.Status,
+		init_packet->Messages.InitMessages.
+		    InitComplete.MaximumMdlChainLength);
 
-	if (initPacket->Messages.InitMessages.InitComplete.Status !=
+	if (init_packet->Messages.InitMessages.InitComplete.Status !=
 	    NvspStatusSuccess) {
 		DPRINT_ERR(NETVSC,
 			"unable to initialize with netvsp (status 0x%x)",
-			initPacket->Messages.InitMessages.InitComplete.Status);
+			init_packet->Messages.InitMessages.InitComplete.Status);
 		ret = -1;
 		goto Cleanup;
 	}
 
-	if (initPacket->Messages.InitMessages.InitComplete.NegotiatedProtocolVersion != NVSP_PROTOCOL_VERSION_1) {
+	if (init_packet->Messages.InitMessages.InitComplete.
+	    NegotiatedProtocolVersion != NVSP_PROTOCOL_VERSION_1) {
 		DPRINT_ERR(NETVSC, "unable to initialize with netvsp "
 			   "(version expected 1 got %d)",
-			   initPacket->Messages.InitMessages.InitComplete.NegotiatedProtocolVersion);
+			   init_packet->Messages.InitMessages.
+			   InitComplete.NegotiatedProtocolVersion);
 		ret = -1;
 		goto Cleanup;
 	}
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendNdisVersion...");
 
 	/* Send the ndis version */
-	memset(initPacket, 0, sizeof(struct nvsp_message));
+	memset(init_packet, 0, sizeof(struct nvsp_message));
 
-	ndisVersion = 0x00050000;
+	ndis_version = 0x00050000;
 
-	initPacket->Header.MessageType = NvspMessage1TypeSendNdisVersion;
-	initPacket->Messages.Version1Messages.SendNdisVersion.NdisMajorVersion =
-				(ndisVersion & 0xFFFF0000) >> 16;
-	initPacket->Messages.Version1Messages.SendNdisVersion.NdisMinorVersion =
-				ndisVersion & 0xFFFF;
+	init_packet->Header.MessageType = NvspMessage1TypeSendNdisVersion;
+	init_packet->Messages.Version1Messages.
+		SendNdisVersion.NdisMajorVersion =
+				(ndis_version & 0xFFFF0000) >> 16;
+	init_packet->Messages.Version1Messages.
+		SendNdisVersion.NdisMinorVersion =
+				ndis_version & 0xFFFF;
 
 	/* Send the init request */
-	ret = vmbus_sendpacket(Device->channel, initPacket,
+	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
-			       (unsigned long)initPacket,
+			       (unsigned long)init_packet,
 			       VmbusPacketTypeDataInBand, 0);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
@@ -654,48 +680,48 @@ static int NetVscConnectToVsp(struct hv_device *Device)
 	 /* osd_waitevent_wait(NetVscChannel->ChannelInitEvent); */
 
 	/* Post the big receive buffer to NetVSP */
-	ret = NetVscInitializeReceiveBufferWithNetVsp(Device);
+	ret = NetVscInitializeReceiveBufferWithNetVsp(device);
 	if (ret == 0)
-		ret = NetVscInitializeSendBufferWithNetVsp(Device);
+		ret = NetVscInitializeSendBufferWithNetVsp(device);
 
 Cleanup:
-	PutNetDevice(Device);
+	PutNetDevice(device);
 	return ret;
 }
 
-static void NetVscDisconnectFromVsp(struct netvsc_device *NetDevice)
+static void NetVscDisconnectFromVsp(struct netvsc_device *net_device)
 {
-	NetVscDestroyReceiveBuffer(NetDevice);
-	NetVscDestroySendBuffer(NetDevice);
+	NetVscDestroyReceiveBuffer(net_device);
+	NetVscDestroySendBuffer(net_device);
 }
 
 /*
  * NetVscOnDeviceAdd - Callback when the device belonging to this driver is added
  */
-static int NetVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
+static int NetVscOnDeviceAdd(struct hv_device *device, void *additional_info)
 {
 	int ret = 0;
 	int i;
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *packet, *pos;
-	struct netvsc_driver *netDriver =
-				(struct netvsc_driver *)Device->Driver;
+	struct netvsc_driver *net_driver =
+				(struct netvsc_driver *)device->Driver;
 
-	netDevice = AllocNetDevice(Device);
-	if (!netDevice) {
+	net_device = AllocNetDevice(device);
+	if (!net_device) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	DPRINT_DBG(NETVSC, "netvsc channel object allocated - %p", netDevice);
+	DPRINT_DBG(NETVSC, "netvsc channel object allocated - %p", net_device);
 
 	/* Initialize the NetVSC channel extension */
-	netDevice->ReceiveBufferSize = NETVSC_RECEIVE_BUFFER_SIZE;
-	spin_lock_init(&netDevice->receive_packet_list_lock);
+	net_device->ReceiveBufferSize = NETVSC_RECEIVE_BUFFER_SIZE;
+	spin_lock_init(&net_device->receive_packet_list_lock);
 
-	netDevice->SendBufferSize = NETVSC_SEND_BUFFER_SIZE;
+	net_device->SendBufferSize = NETVSC_SEND_BUFFER_SIZE;
 
-	INIT_LIST_HEAD(&netDevice->ReceivePacketList);
+	INIT_LIST_HEAD(&net_device->ReceivePacketList);
 
 	for (i = 0; i < NETVSC_RECEIVE_PACKETLIST_COUNT; i++) {
 		packet = kzalloc(sizeof(struct hv_netvsc_packet) +
@@ -708,18 +734,18 @@ static int NetVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 			break;
 		}
 		list_add_tail(&packet->ListEntry,
-			      &netDevice->ReceivePacketList);
+			      &net_device->ReceivePacketList);
 	}
-	netDevice->ChannelInitEvent = osd_waitevent_create();
-	if (!netDevice->ChannelInitEvent) {
+	net_device->ChannelInitEvent = osd_waitevent_create();
+	if (!net_device->ChannelInitEvent) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
 	/* Open the channel */
-	ret = vmbus_open(Device->channel, netDriver->RingBufferSize,
-			 netDriver->RingBufferSize, NULL, 0,
-			 NetVscOnChannelCallback, Device);
+	ret = vmbus_open(device->channel, net_driver->RingBufferSize,
+			 net_driver->RingBufferSize, NULL, 0,
+			 NetVscOnChannelCallback, device);
 
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to open channel: %d", ret);
@@ -731,7 +757,7 @@ static int NetVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 	DPRINT_INFO(NETVSC, "*** NetVSC channel opened successfully! ***");
 
 	/* Connect with the NetVsp */
-	ret = NetVscConnectToVsp(Device);
+	ret = NetVscConnectToVsp(device);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to connect to NetVSP - %d", ret);
 		ret = -1;
@@ -745,24 +771,24 @@ static int NetVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 
 close:
 	/* Now, we can close the channel safely */
-	vmbus_close(Device->channel);
+	vmbus_close(device->channel);
 
 Cleanup:
 
-	if (netDevice) {
-		kfree(netDevice->ChannelInitEvent);
+	if (net_device) {
+		kfree(net_device->ChannelInitEvent);
 
 		list_for_each_entry_safe(packet, pos,
-					 &netDevice->ReceivePacketList,
+					 &net_device->ReceivePacketList,
 					 ListEntry) {
 			list_del(&packet->ListEntry);
 			kfree(packet);
 		}
 
-		ReleaseOutboundNetDevice(Device);
-		ReleaseInboundNetDevice(Device);
+		ReleaseOutboundNetDevice(device);
+		ReleaseInboundNetDevice(device);
 
-		FreeNetDevice(netDevice);
+		FreeNetDevice(net_device);
 	}
 
 	return ret;
@@ -771,53 +797,53 @@ Cleanup:
 /*
  * NetVscOnDeviceRemove - Callback when the root bus device is removed
  */
-static int NetVscOnDeviceRemove(struct hv_device *Device)
+static int NetVscOnDeviceRemove(struct hv_device *device)
 {
-	struct netvsc_device *netDevice;
-	struct hv_netvsc_packet *netvscPacket, *pos;
+	struct netvsc_device *net_device;
+	struct hv_netvsc_packet *netvsc_packet, *pos;
 
 	DPRINT_INFO(NETVSC, "Disabling outbound traffic on net device (%p)...",
-		    Device->Extension);
+		    device->Extension);
 
 	/* Stop outbound traffic ie sends and receives completions */
-	netDevice = ReleaseOutboundNetDevice(Device);
-	if (!netDevice) {
+	net_device = ReleaseOutboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "No net device present!!");
 		return -1;
 	}
 
 	/* Wait for all send completions */
-	while (atomic_read(&netDevice->NumOutstandingSends)) {
+	while (atomic_read(&net_device->NumOutstandingSends)) {
 		DPRINT_INFO(NETVSC, "waiting for %d requests to complete...",
-			    atomic_read(&netDevice->NumOutstandingSends));
+			    atomic_read(&net_device->NumOutstandingSends));
 		udelay(100);
 	}
 
 	DPRINT_INFO(NETVSC, "Disconnecting from netvsp...");
 
-	NetVscDisconnectFromVsp(netDevice);
+	NetVscDisconnectFromVsp(net_device);
 
 	DPRINT_INFO(NETVSC, "Disabling inbound traffic on net device (%p)...",
-		    Device->Extension);
+		    device->Extension);
 
 	/* Stop inbound traffic ie receives and sends completions */
-	netDevice = ReleaseInboundNetDevice(Device);
+	net_device = ReleaseInboundNetDevice(device);
 
 	/* At this point, no one should be accessing netDevice except in here */
-	DPRINT_INFO(NETVSC, "net device (%p) safe to remove", netDevice);
+	DPRINT_INFO(NETVSC, "net device (%p) safe to remove", net_device);
 
 	/* Now, we can close the channel safely */
-	vmbus_close(Device->channel);
+	vmbus_close(device->channel);
 
 	/* Release all resources */
-	list_for_each_entry_safe(netvscPacket, pos,
-				 &netDevice->ReceivePacketList, ListEntry) {
-		list_del(&netvscPacket->ListEntry);
-		kfree(netvscPacket);
+	list_for_each_entry_safe(netvsc_packet, pos,
+				 &net_device->ReceivePacketList, ListEntry) {
+		list_del(&netvsc_packet->ListEntry);
+		kfree(netvsc_packet);
 	}
 
-	kfree(netDevice->ChannelInitEvent);
-	FreeNetDevice(netDevice);
+	kfree(net_device->ChannelInitEvent);
+	FreeNetDevice(net_device);
 	return 0;
 }
 
@@ -828,69 +854,72 @@ static void NetVscOnCleanup(struct hv_driver *drv)
 {
 }
 
-static void NetVscOnSendCompletion(struct hv_device *Device,
-				   struct vmpacket_descriptor *Packet)
+static void NetVscOnSendCompletion(struct hv_device *device,
+				   struct vmpacket_descriptor *packet)
 {
-	struct netvsc_device *netDevice;
-	struct nvsp_message *nvspPacket;
-	struct hv_netvsc_packet *nvscPacket;
+	struct netvsc_device *net_device;
+	struct nvsp_message *nvsp_packet;
+	struct hv_netvsc_packet *nvsc_packet;
 
-	netDevice = GetInboundNetDevice(Device);
-	if (!netDevice) {
+	net_device = GetInboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
 		return;
 	}
 
-	nvspPacket = (struct nvsp_message *)((unsigned long)Packet + (Packet->DataOffset8 << 3));
+	nvsp_packet = (struct nvsp_message *)((unsigned long)packet +
+			(packet->DataOffset8 << 3));
 
 	DPRINT_DBG(NETVSC, "send completion packet - type %d",
-		   nvspPacket->Header.MessageType);
+		   nvsp_packet->Header.MessageType);
 
-	if ((nvspPacket->Header.MessageType == NvspMessageTypeInitComplete) ||
-	    (nvspPacket->Header.MessageType ==
+	if ((nvsp_packet->Header.MessageType == NvspMessageTypeInitComplete) ||
+	    (nvsp_packet->Header.MessageType ==
 	     NvspMessage1TypeSendReceiveBufferComplete) ||
-	    (nvspPacket->Header.MessageType ==
+	    (nvsp_packet->Header.MessageType ==
 	     NvspMessage1TypeSendSendBufferComplete)) {
 		/* Copy the response back */
-		memcpy(&netDevice->ChannelInitPacket, nvspPacket,
+		memcpy(&net_device->ChannelInitPacket, nvsp_packet,
 		       sizeof(struct nvsp_message));
-		osd_waitevent_set(netDevice->ChannelInitEvent);
-	} else if (nvspPacket->Header.MessageType ==
+		osd_waitevent_set(net_device->ChannelInitEvent);
+	} else if (nvsp_packet->Header.MessageType ==
 		   NvspMessage1TypeSendRNDISPacketComplete) {
 		/* Get the send context */
-		nvscPacket = (struct hv_netvsc_packet *)(unsigned long)Packet->TransactionId;
+		nvsc_packet = (struct hv_netvsc_packet *)(unsigned long)
+			packet->TransactionId;
 		/* ASSERT(nvscPacket); */
 
 		/* Notify the layer above us */
-		nvscPacket->Completion.Send.OnSendCompletion(nvscPacket->Completion.Send.SendCompletionContext);
+		nvsc_packet->Completion.Send.OnSendCompletion(
+			nvsc_packet->Completion.Send.SendCompletionContext);
 
-		atomic_dec(&netDevice->NumOutstandingSends);
+		atomic_dec(&net_device->NumOutstandingSends);
 	} else {
 		DPRINT_ERR(NETVSC, "Unknown send completion packet type - "
-			   "%d received!!", nvspPacket->Header.MessageType);
+			   "%d received!!", nvsp_packet->Header.MessageType);
 	}
 
-	PutNetDevice(Device);
+	PutNetDevice(device);
 }
 
-static int NetVscOnSend(struct hv_device *Device,
-			struct hv_netvsc_packet *Packet)
+static int NetVscOnSend(struct hv_device *device,
+			struct hv_netvsc_packet *packet)
 {
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 	int ret = 0;
 
 	struct nvsp_message sendMessage;
 
-	netDevice = GetOutboundNetDevice(Device);
-	if (!netDevice) {
+	net_device = GetOutboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "net device (%p) shutting down..."
-			   "ignoring outbound packets", netDevice);
+			   "ignoring outbound packets", net_device);
 		return -2;
 	}
 
 	sendMessage.Header.MessageType = NvspMessage1TypeSendRNDISPacket;
-	if (Packet->IsDataPacket) {
+	if (packet->IsDataPacket) {
 		/* 0 is RMC_DATA; */
 		sendMessage.Messages.Version1Messages.SendRNDISPacket.ChannelType = 0;
 	} else {
@@ -902,17 +931,17 @@ static int NetVscOnSend(struct hv_device *Device,
 	sendMessage.Messages.Version1Messages.SendRNDISPacket.SendBufferSectionIndex = 0xFFFFFFFF;
 	sendMessage.Messages.Version1Messages.SendRNDISPacket.SendBufferSectionSize = 0;
 
-	if (Packet->PageBufferCount) {
-		ret = vmbus_sendpacket_pagebuffer(Device->channel,
-						  Packet->PageBuffers,
-						  Packet->PageBufferCount,
+	if (packet->PageBufferCount) {
+		ret = vmbus_sendpacket_pagebuffer(device->channel,
+						  packet->PageBuffers,
+						  packet->PageBufferCount,
 						  &sendMessage,
 						  sizeof(struct nvsp_message),
-						  (unsigned long)Packet);
+						  (unsigned long)packet);
 	} else {
-		ret = vmbus_sendpacket(Device->channel, &sendMessage,
+		ret = vmbus_sendpacket(device->channel, &sendMessage,
 				       sizeof(struct nvsp_message),
-				       (unsigned long)Packet,
+				       (unsigned long)packet,
 				       VmbusPacketTypeDataInBand,
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
@@ -920,31 +949,31 @@ static int NetVscOnSend(struct hv_device *Device,
 
 	if (ret != 0)
 		DPRINT_ERR(NETVSC, "Unable to send packet %p ret %d",
-			   Packet, ret);
+			   packet, ret);
 
-	atomic_inc(&netDevice->NumOutstandingSends);
-	PutNetDevice(Device);
+	atomic_inc(&net_device->NumOutstandingSends);
+	PutNetDevice(device);
 	return ret;
 }
 
-static void NetVscOnReceive(struct hv_device *Device,
-			    struct vmpacket_descriptor *Packet)
+static void NetVscOnReceive(struct hv_device *device,
+			    struct vmpacket_descriptor *packet)
 {
-	struct netvsc_device *netDevice;
-	struct vmtransfer_page_packet_header *vmxferpagePacket;
-	struct nvsp_message *nvspPacket;
-	struct hv_netvsc_packet *netvscPacket = NULL;
+	struct netvsc_device *net_device;
+	struct vmtransfer_page_packet_header *vmxferpage_packet;
+	struct nvsp_message *nvsp_packet;
+	struct hv_netvsc_packet *netvsc_packet = NULL;
 	unsigned long start;
-	unsigned long end, endVirtual;
+	unsigned long end, end_virtual;
 	/* struct netvsc_driver *netvscDriver; */
-	struct xferpage_packet *xferpagePacket = NULL;
+	struct xferpage_packet *xferpage_packet = NULL;
 	int i, j;
-	int count = 0, bytesRemain = 0;
+	int count = 0, bytes_remain = 0;
 	unsigned long flags;
 	LIST_HEAD(listHead);
 
-	netDevice = GetInboundNetDevice(Device);
-	if (!netDevice) {
+	net_device = GetInboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
 		return;
@@ -954,39 +983,40 @@ static void NetVscOnReceive(struct hv_device *Device,
 	 * All inbound packets other than send completion should be xfer page
 	 * packet
 	 */
-	if (Packet->Type != VmbusPacketTypeDataUsingTransferPages) {
+	if (packet->Type != VmbusPacketTypeDataUsingTransferPages) {
 		DPRINT_ERR(NETVSC, "Unknown packet type received - %d",
-			   Packet->Type);
-		PutNetDevice(Device);
+			   packet->Type);
+		PutNetDevice(device);
 		return;
 	}
 
-	nvspPacket = (struct nvsp_message *)((unsigned long)Packet +
-			(Packet->DataOffset8 << 3));
+	nvsp_packet = (struct nvsp_message *)((unsigned long)packet +
+			(packet->DataOffset8 << 3));
 
 	/* Make sure this is a valid nvsp packet */
-	if (nvspPacket->Header.MessageType != NvspMessage1TypeSendRNDISPacket) {
+	if (nvsp_packet->Header.MessageType !=
+	    NvspMessage1TypeSendRNDISPacket) {
 		DPRINT_ERR(NETVSC, "Unknown nvsp packet type received - %d",
-			   nvspPacket->Header.MessageType);
-		PutNetDevice(Device);
+			   nvsp_packet->Header.MessageType);
+		PutNetDevice(device);
 		return;
 	}
 
 	DPRINT_DBG(NETVSC, "NVSP packet received - type %d",
-		   nvspPacket->Header.MessageType);
+		   nvsp_packet->Header.MessageType);
 
-	vmxferpagePacket = (struct vmtransfer_page_packet_header *)Packet;
+	vmxferpage_packet = (struct vmtransfer_page_packet_header *)packet;
 
-	if (vmxferpagePacket->TransferPageSetId != NETVSC_RECEIVE_BUFFER_ID) {
+	if (vmxferpage_packet->TransferPageSetId != NETVSC_RECEIVE_BUFFER_ID) {
 		DPRINT_ERR(NETVSC, "Invalid xfer page set id - "
 			   "expecting %x got %x", NETVSC_RECEIVE_BUFFER_ID,
-			   vmxferpagePacket->TransferPageSetId);
-		PutNetDevice(Device);
+			   vmxferpage_packet->TransferPageSetId);
+		PutNetDevice(device);
 		return;
 	}
 
 	DPRINT_DBG(NETVSC, "xfer page - range count %d",
-		   vmxferpagePacket->RangeCount);
+		   vmxferpage_packet->RangeCount);
 
 	/*
 	 * Grab free packets (range count + 1) to represent this xfer
@@ -994,13 +1024,13 @@ static void NetVscOnReceive(struct hv_device *Device,
 	 * We grab it here so that we know exactly how many we can
 	 * fulfil
 	 */
-	spin_lock_irqsave(&netDevice->receive_packet_list_lock, flags);
-	while (!list_empty(&netDevice->ReceivePacketList)) {
-		list_move_tail(netDevice->ReceivePacketList.next, &listHead);
-		if (++count == vmxferpagePacket->RangeCount + 1)
+	spin_lock_irqsave(&net_device->receive_packet_list_lock, flags);
+	while (!list_empty(&net_device->ReceivePacketList)) {
+		list_move_tail(net_device->ReceivePacketList.next, &listHead);
+		if (++count == vmxferpage_packet->RangeCount + 1)
 			break;
 	}
-	spin_unlock_irqrestore(&netDevice->receive_packet_list_lock, flags);
+	spin_unlock_irqrestore(&net_device->receive_packet_list_lock, flags);
 
 	/*
 	 * We need at least 2 netvsc pkts (1 to represent the xfer
@@ -1010,129 +1040,137 @@ static void NetVscOnReceive(struct hv_device *Device,
 	if (count < 2) {
 		DPRINT_ERR(NETVSC, "Got only %d netvsc pkt...needed %d pkts. "
 			   "Dropping this xfer page packet completely!",
-			   count, vmxferpagePacket->RangeCount + 1);
+			   count, vmxferpage_packet->RangeCount + 1);
 
 		/* Return it to the freelist */
-		spin_lock_irqsave(&netDevice->receive_packet_list_lock, flags);
+		spin_lock_irqsave(&net_device->receive_packet_list_lock, flags);
 		for (i = count; i != 0; i--) {
 			list_move_tail(listHead.next,
-				       &netDevice->ReceivePacketList);
+				       &net_device->ReceivePacketList);
 		}
-		spin_unlock_irqrestore(&netDevice->receive_packet_list_lock,
+		spin_unlock_irqrestore(&net_device->receive_packet_list_lock,
 				       flags);
 
-		NetVscSendReceiveCompletion(Device,
-					    vmxferpagePacket->d.TransactionId);
+		NetVscSendReceiveCompletion(device,
+					    vmxferpage_packet->d.TransactionId);
 
-		PutNetDevice(Device);
+		PutNetDevice(device);
 		return;
 	}
 
 	/* Remove the 1st packet to represent the xfer page packet itself */
-	xferpagePacket = (struct xferpage_packet *)listHead.next;
-	list_del(&xferpagePacket->ListEntry);
+	xferpage_packet = (struct xferpage_packet *)listHead.next;
+	list_del(&xferpage_packet->ListEntry);
 
 	/* This is how much we can satisfy */
-	xferpagePacket->Count = count - 1;
+	xferpage_packet->Count = count - 1;
 	/* ASSERT(xferpagePacket->Count > 0 && xferpagePacket->Count <= */
 	/* 	vmxferpagePacket->RangeCount); */
 
-	if (xferpagePacket->Count != vmxferpagePacket->RangeCount) {
+	if (xferpage_packet->Count != vmxferpage_packet->RangeCount) {
 		DPRINT_INFO(NETVSC, "Needed %d netvsc pkts to satisy this xfer "
-			    "page...got %d", vmxferpagePacket->RangeCount,
-			    xferpagePacket->Count);
+			    "page...got %d", vmxferpage_packet->RangeCount,
+			    xferpage_packet->Count);
 	}
 
 	/* Each range represents 1 RNDIS pkt that contains 1 ethernet frame */
 	for (i = 0; i < (count - 1); i++) {
-		netvscPacket = (struct hv_netvsc_packet *)listHead.next;
-		list_del(&netvscPacket->ListEntry);
+		netvsc_packet = (struct hv_netvsc_packet *)listHead.next;
+		list_del(&netvsc_packet->ListEntry);
 
 		/* Initialize the netvsc packet */
-		netvscPacket->XferPagePacket = xferpagePacket;
-		netvscPacket->Completion.Recv.OnReceiveCompletion =
+		netvsc_packet->XferPagePacket = xferpage_packet;
+		netvsc_packet->Completion.Recv.OnReceiveCompletion =
 					NetVscOnReceiveCompletion;
-		netvscPacket->Completion.Recv.ReceiveCompletionContext =
-					netvscPacket;
-		netvscPacket->Device = Device;
+		netvsc_packet->Completion.Recv.ReceiveCompletionContext =
+					netvsc_packet;
+		netvsc_packet->Device = device;
 		/* Save this so that we can send it back */
-		netvscPacket->Completion.Recv.ReceiveCompletionTid =
-					vmxferpagePacket->d.TransactionId;
+		netvsc_packet->Completion.Recv.ReceiveCompletionTid =
+					vmxferpage_packet->d.TransactionId;
 
-		netvscPacket->TotalDataBufferLength =
-					vmxferpagePacket->Ranges[i].ByteCount;
-		netvscPacket->PageBufferCount = 1;
+		netvsc_packet->TotalDataBufferLength =
+					vmxferpage_packet->Ranges[i].ByteCount;
+		netvsc_packet->PageBufferCount = 1;
 
 		/* ASSERT(vmxferpagePacket->Ranges[i].ByteOffset + */
 		/* 	vmxferpagePacket->Ranges[i].ByteCount < */
 		/* 	netDevice->ReceiveBufferSize); */
 
-		netvscPacket->PageBuffers[0].Length =
-					vmxferpagePacket->Ranges[i].ByteCount;
+		netvsc_packet->PageBuffers[0].Length =
+					vmxferpage_packet->Ranges[i].ByteCount;
 
-		start = virt_to_phys((void *)((unsigned long)netDevice->ReceiveBuffer + vmxferpagePacket->Ranges[i].ByteOffset));
+		start = virt_to_phys((void *)((unsigned long)net_device->
+		ReceiveBuffer + vmxferpage_packet->Ranges[i].ByteOffset));
 
-		netvscPacket->PageBuffers[0].Pfn = start >> PAGE_SHIFT;
-		endVirtual = (unsigned long)netDevice->ReceiveBuffer
-		    + vmxferpagePacket->Ranges[i].ByteOffset
-		    + vmxferpagePacket->Ranges[i].ByteCount - 1;
-		end = virt_to_phys((void *)endVirtual);
+		netvsc_packet->PageBuffers[0].Pfn = start >> PAGE_SHIFT;
+		end_virtual = (unsigned long)net_device->ReceiveBuffer
+		    + vmxferpage_packet->Ranges[i].ByteOffset
+		    + vmxferpage_packet->Ranges[i].ByteCount - 1;
+		end = virt_to_phys((void *)end_virtual);
 
 		/* Calculate the page relative offset */
-		netvscPacket->PageBuffers[0].Offset =
-			vmxferpagePacket->Ranges[i].ByteOffset & (PAGE_SIZE - 1);
+		netvsc_packet->PageBuffers[0].Offset =
+			vmxferpage_packet->Ranges[i].ByteOffset &
+			(PAGE_SIZE - 1);
 		if ((end >> PAGE_SHIFT) != (start >> PAGE_SHIFT)) {
 			/* Handle frame across multiple pages: */
-			netvscPacket->PageBuffers[0].Length =
-				(netvscPacket->PageBuffers[0].Pfn << PAGE_SHIFT)
+			netvsc_packet->PageBuffers[0].Length =
+				(netvsc_packet->PageBuffers[0].Pfn <<
+				 PAGE_SHIFT)
 				+ PAGE_SIZE - start;
-			bytesRemain = netvscPacket->TotalDataBufferLength -
-					netvscPacket->PageBuffers[0].Length;
+			bytes_remain = netvsc_packet->TotalDataBufferLength -
+					netvsc_packet->PageBuffers[0].Length;
 			for (j = 1; j < NETVSC_PACKET_MAXPAGE; j++) {
-				netvscPacket->PageBuffers[j].Offset = 0;
-				if (bytesRemain <= PAGE_SIZE) {
-					netvscPacket->PageBuffers[j].Length = bytesRemain;
-					bytesRemain = 0;
+				netvsc_packet->PageBuffers[j].Offset = 0;
+				if (bytes_remain <= PAGE_SIZE) {
+					netvsc_packet->PageBuffers[j].Length =
+						bytes_remain;
+					bytes_remain = 0;
 				} else {
-					netvscPacket->PageBuffers[j].Length = PAGE_SIZE;
-					bytesRemain -= PAGE_SIZE;
+					netvsc_packet->PageBuffers[j].Length =
+						PAGE_SIZE;
+					bytes_remain -= PAGE_SIZE;
 				}
-				netvscPacket->PageBuffers[j].Pfn =
-				    virt_to_phys((void *)(endVirtual - bytesRemain)) >> PAGE_SHIFT;
-				netvscPacket->PageBufferCount++;
-				if (bytesRemain == 0)
+				netvsc_packet->PageBuffers[j].Pfn =
+				    virt_to_phys((void *)(end_virtual -
+						bytes_remain)) >> PAGE_SHIFT;
+				netvsc_packet->PageBufferCount++;
+				if (bytes_remain == 0)
 					break;
 			}
 			/* ASSERT(bytesRemain == 0); */
 		}
 		DPRINT_DBG(NETVSC, "[%d] - (abs offset %u len %u) => "
 			   "(pfn %llx, offset %u, len %u)", i,
-			   vmxferpagePacket->Ranges[i].ByteOffset,
-			   vmxferpagePacket->Ranges[i].ByteCount,
-			   netvscPacket->PageBuffers[0].Pfn,
-			   netvscPacket->PageBuffers[0].Offset,
-			   netvscPacket->PageBuffers[0].Length);
+			   vmxferpage_packet->Ranges[i].ByteOffset,
+			   vmxferpage_packet->Ranges[i].ByteCount,
+			   netvsc_packet->PageBuffers[0].Pfn,
+			   netvsc_packet->PageBuffers[0].Offset,
+			   netvsc_packet->PageBuffers[0].Length);
 
 		/* Pass it to the upper layer */
-		((struct netvsc_driver *)Device->Driver)->OnReceiveCallback(Device, netvscPacket);
+		((struct netvsc_driver *)device->Driver)->
+			OnReceiveCallback(device, netvsc_packet);
 
-		NetVscOnReceiveCompletion(netvscPacket->Completion.Recv.ReceiveCompletionContext);
+		NetVscOnReceiveCompletion(netvsc_packet->
+				Completion.Recv.ReceiveCompletionContext);
 	}
 
 	/* ASSERT(list_empty(&listHead)); */
 
-	PutNetDevice(Device);
+	PutNetDevice(device);
 }
 
-static void NetVscSendReceiveCompletion(struct hv_device *Device,
-					u64 TransactionId)
+static void NetVscSendReceiveCompletion(struct hv_device *device,
+					u64 transaction_id)
 {
 	struct nvsp_message recvcompMessage;
 	int retries = 0;
 	int ret;
 
 	DPRINT_DBG(NETVSC, "Sending receive completion pkt - %llx",
-		   TransactionId);
+		   transaction_id);
 
 	recvcompMessage.Header.MessageType =
 				NvspMessage1TypeSendRNDISPacketComplete;
@@ -1142,8 +1180,8 @@ static void NetVscSendReceiveCompletion(struct hv_device *Device,
 
 retry_send_cmplt:
 	/* Send the completion */
-	ret = vmbus_sendpacket(Device->channel, &recvcompMessage,
-			       sizeof(struct nvsp_message), TransactionId,
+	ret = vmbus_sendpacket(device->channel, &recvcompMessage,
+			       sizeof(struct nvsp_message), transaction_id,
 			       VmbusPacketTypeCompletion, 0);
 	if (ret == 0) {
 		/* success */
@@ -1152,7 +1190,7 @@ retry_send_cmplt:
 		/* no more room...wait a bit and attempt to retry 3 times */
 		retries++;
 		DPRINT_ERR(NETVSC, "unable to send receive completion pkt "
-			   "(tid %llx)...retrying %d", TransactionId, retries);
+			   "(tid %llx)...retrying %d", transaction_id, retries);
 
 		if (retries < 4) {
 			udelay(100);
@@ -1160,22 +1198,22 @@ retry_send_cmplt:
 		} else {
 			DPRINT_ERR(NETVSC, "unable to send receive completion "
 				  "pkt (tid %llx)...give up retrying",
-				  TransactionId);
+				  transaction_id);
 		}
 	} else {
 		DPRINT_ERR(NETVSC, "unable to send receive completion pkt - "
-			   "%llx", TransactionId);
+			   "%llx", transaction_id);
 	}
 }
 
 /* Send a receive completion packet to RNDIS device (ie NetVsp) */
-static void NetVscOnReceiveCompletion(void *Context)
+static void NetVscOnReceiveCompletion(void *context)
 {
-	struct hv_netvsc_packet *packet = Context;
+	struct hv_netvsc_packet *packet = context;
 	struct hv_device *device = (struct hv_device *)packet->Device;
-	struct netvsc_device *netDevice;
-	u64 transactionId = 0;
-	bool fSendReceiveComp = false;
+	struct netvsc_device *net_device;
+	u64 transaction_id = 0;
+	bool fsend_receive_comp = false;
 	unsigned long flags;
 
 	/* ASSERT(packet->XferPagePacket); */
@@ -1185,15 +1223,15 @@ static void NetVscOnReceiveCompletion(void *Context)
 	 * send out receive completion, we are using GetInboundNetDevice()
 	 * since we may have disable outbound traffic already.
 	 */
-	netDevice = GetInboundNetDevice(device);
-	if (!netDevice) {
+	net_device = GetInboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
 		return;
 	}
 
 	/* Overloading use of the lock. */
-	spin_lock_irqsave(&netDevice->receive_packet_list_lock, flags);
+	spin_lock_irqsave(&net_device->receive_packet_list_lock, flags);
 
 	/* ASSERT(packet->XferPagePacket->Count > 0); */
 	packet->XferPagePacket->Count--;
@@ -1203,31 +1241,31 @@ static void NetVscOnReceiveCompletion(void *Context)
 	 * Return the xfer page packet itself to the freelist
 	 */
 	if (packet->XferPagePacket->Count == 0) {
-		fSendReceiveComp = true;
-		transactionId = packet->Completion.Recv.ReceiveCompletionTid;
+		fsend_receive_comp = true;
+		transaction_id = packet->Completion.Recv.ReceiveCompletionTid;
 		list_add_tail(&packet->XferPagePacket->ListEntry,
-			      &netDevice->ReceivePacketList);
+			      &net_device->ReceivePacketList);
 
 	}
 
 	/* Put the packet back */
-	list_add_tail(&packet->ListEntry, &netDevice->ReceivePacketList);
-	spin_unlock_irqrestore(&netDevice->receive_packet_list_lock, flags);
+	list_add_tail(&packet->ListEntry, &net_device->ReceivePacketList);
+	spin_unlock_irqrestore(&net_device->receive_packet_list_lock, flags);
 
 	/* Send a receive completion for the xfer page packet */
-	if (fSendReceiveComp)
-		NetVscSendReceiveCompletion(device, transactionId);
+	if (fsend_receive_comp)
+		NetVscSendReceiveCompletion(device, transaction_id);
 
 	PutNetDevice(device);
 }
 
-static void NetVscOnChannelCallback(void *Context)
+static void NetVscOnChannelCallback(void *context)
 {
 	int ret;
-	struct hv_device *device = Context;
-	struct netvsc_device *netDevice;
-	u32 bytesRecvd;
-	u64 requestId;
+	struct hv_device *device = context;
+	struct netvsc_device *net_device;
+	u32 bytes_recvd;
+	u64 request_id;
 	unsigned char *packet;
 	struct vmpacket_descriptor *desc;
 	unsigned char *buffer;
@@ -1241,20 +1279,20 @@ static void NetVscOnChannelCallback(void *Context)
 		return;
 	buffer = packet;
 
-	netDevice = GetInboundNetDevice(device);
-	if (!netDevice) {
+	net_device = GetInboundNetDevice(device);
+	if (!net_device) {
 		DPRINT_ERR(NETVSC, "net device (%p) shutting down..."
-			   "ignoring inbound packets", netDevice);
+			   "ignoring inbound packets", net_device);
 		goto out;
 	}
 
 	do {
 		ret = vmbus_recvpacket_raw(device->channel, buffer, bufferlen,
-					   &bytesRecvd, &requestId);
+					   &bytes_recvd, &request_id);
 		if (ret == 0) {
-			if (bytesRecvd > 0) {
+			if (bytes_recvd > 0) {
 				DPRINT_DBG(NETVSC, "receive %d bytes, tid %llx",
-					   bytesRecvd, requestId);
+					   bytes_recvd, request_id);
 
 				desc = (struct vmpacket_descriptor *)buffer;
 				switch (desc->Type) {
@@ -1270,8 +1308,8 @@ static void NetVscOnChannelCallback(void *Context)
 					DPRINT_ERR(NETVSC,
 						   "unhandled packet type %d, "
 						   "tid %llx len %d\n",
-						   desc->Type, requestId,
-						   bytesRecvd);
+						   desc->Type, request_id,
+						   bytes_recvd);
 					break;
 				}
 
@@ -1293,16 +1331,16 @@ static void NetVscOnChannelCallback(void *Context)
 			}
 		} else if (ret == -2) {
 			/* Handle large packet */
-			buffer = kmalloc(bytesRecvd, GFP_ATOMIC);
+			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
 			if (buffer == NULL) {
 				/* Try again next time around */
 				DPRINT_ERR(NETVSC,
 					   "unable to allocate buffer of size "
-					   "(%d)!!", bytesRecvd);
+					   "(%d)!!", bytes_recvd);
 				break;
 			}
 
-			bufferlen = bytesRecvd;
+			bufferlen = bytes_recvd;
 		}
 	} while (1);
 
-- 
1.6.3.2

