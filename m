Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab0LJUAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:00:17 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53985
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756835Ab0LJUAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:00:12 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 2/7] staging: hv: Convert camel cased functions in netvsc.c to lower cases
Date: Fri, 10 Dec 2010 12:03:55 -0800
Message-Id: <1292011440-21174-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
References: <1292011440-21174-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c     |  173 ++++++++++++++++++++-------------------
 drivers/staging/hv/netvsc_api.h |    2 +-
 drivers/staging/hv/netvsc_drv.c |    2 +-
 3 files changed, 90 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 1c1ee57..781d7bd 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -41,40 +41,40 @@ static const struct hv_guid netvsc_device_type = {
 	}
 };
 
-static int NetVscOnDeviceAdd(struct hv_device *device, void *additional_info);
+static int netvsc_device_add(struct hv_device *device, void *additional_info);
 
-static int NetVscOnDeviceRemove(struct hv_device *device);
+static int netvsc_device_remove(struct hv_device *device);
 
-static void NetVscOnCleanup(struct hv_driver *driver);
+static void netvsc_cleanup(struct hv_driver *driver);
 
-static void NetVscOnChannelCallback(void *context);
+static void netvsc_channel_cb(void *context);
 
-static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *device);
+static int netvsc_init_send_buf(struct hv_device *device);
 
-static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *device);
+static int netvsc_init_recv_buf(struct hv_device *device);
 
-static int NetVscDestroySendBuffer(struct netvsc_device *net_device);
+static int netvsc_destroy_send_buf(struct netvsc_device *net_device);
 
-static int NetVscDestroyReceiveBuffer(struct netvsc_device *net_device);
+static int netvsc_destroy_recv_buf(struct netvsc_device *net_device);
 
-static int NetVscConnectToVsp(struct hv_device *device);
+static int netvsc_connect_vsp(struct hv_device *device);
 
-static void NetVscOnSendCompletion(struct hv_device *device,
+static void netvsc_send_completion(struct hv_device *device,
 				   struct vmpacket_descriptor *packet);
 
-static int NetVscOnSend(struct hv_device *device,
+static int netvsc_send(struct hv_device *device,
 			struct hv_netvsc_packet *packet);
 
-static void NetVscOnReceive(struct hv_device *device,
+static void netvsc_receive(struct hv_device *device,
 			    struct vmpacket_descriptor *packet);
 
-static void NetVscOnReceiveCompletion(void *context);
+static void netvsc_receive_completion(void *context);
 
-static void NetVscSendReceiveCompletion(struct hv_device *device,
+static void netvsc_send_recv_completion(struct hv_device *device,
 					u64 transaction_id);
 
 
-static struct netvsc_device *AllocNetDevice(struct hv_device *device)
+static struct netvsc_device *alloc_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -91,7 +91,7 @@ static struct netvsc_device *AllocNetDevice(struct hv_device *device)
 	return net_device;
 }
 
-static void FreeNetDevice(struct netvsc_device *device)
+static void free_net_device(struct netvsc_device *device)
 {
 	WARN_ON(atomic_read(&device->RefCount) == 0);
 	device->Device->Extension = NULL;
@@ -100,7 +100,7 @@ static void FreeNetDevice(struct netvsc_device *device)
 
 
 /* Get the net device object iff exists and its refcount > 1 */
-static struct netvsc_device *GetOutboundNetDevice(struct hv_device *device)
+static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -114,7 +114,7 @@ static struct netvsc_device *GetOutboundNetDevice(struct hv_device *device)
 }
 
 /* Get the net device object iff exists and its refcount > 0 */
-static struct netvsc_device *GetInboundNetDevice(struct hv_device *device)
+static struct netvsc_device *get_inbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -127,7 +127,7 @@ static struct netvsc_device *GetInboundNetDevice(struct hv_device *device)
 	return net_device;
 }
 
-static void PutNetDevice(struct hv_device *device)
+static void put_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -137,7 +137,8 @@ static void PutNetDevice(struct hv_device *device)
 	atomic_dec(&net_device->RefCount);
 }
 
-static struct netvsc_device *ReleaseOutboundNetDevice(struct hv_device *device)
+static struct netvsc_device *release_outbound_net_device(
+		struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -152,7 +153,8 @@ static struct netvsc_device *ReleaseOutboundNetDevice(struct hv_device *device)
 	return net_device;
 }
 
-static struct netvsc_device *ReleaseInboundNetDevice(struct hv_device *device)
+static struct netvsc_device *release_inbound_net_device(
+		struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 
@@ -169,9 +171,9 @@ static struct netvsc_device *ReleaseInboundNetDevice(struct hv_device *device)
 }
 
 /*
- * NetVscInitialize - Main entry point
+ * netvsc_initialize - Main entry point
  */
-int NetVscInitialize(struct hv_driver *drv)
+int netvsc_initialize(struct hv_driver *drv)
 {
 	struct netvsc_driver *driver = (struct netvsc_driver *)drv;
 
@@ -194,23 +196,23 @@ int NetVscInitialize(struct hv_driver *drv)
 	/* ASSERT(driver->OnLinkStatusChanged); */
 
 	/* Setup the dispatch table */
-	driver->Base.OnDeviceAdd	= NetVscOnDeviceAdd;
-	driver->Base.OnDeviceRemove	= NetVscOnDeviceRemove;
-	driver->Base.OnCleanup		= NetVscOnCleanup;
+	driver->Base.OnDeviceAdd	= netvsc_device_add;
+	driver->Base.OnDeviceRemove	= netvsc_device_remove;
+	driver->Base.OnCleanup		= netvsc_cleanup;
 
-	driver->OnSend			= NetVscOnSend;
+	driver->OnSend			= netvsc_send;
 
 	RndisFilterInit(driver);
 	return 0;
 }
 
-static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *device)
+static int netvsc_init_recv_buf(struct hv_device *device)
 {
 	int ret = 0;
 	struct netvsc_device *net_device;
 	struct nvsp_message *init_packet;
 
-	net_device = GetOutboundNetDevice(device);
+	net_device = get_outbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
@@ -330,20 +332,20 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *device)
 	goto Exit;
 
 Cleanup:
-	NetVscDestroyReceiveBuffer(net_device);
+	netvsc_destroy_recv_buf(net_device);
 
 Exit:
-	PutNetDevice(device);
+	put_net_device(device);
 	return ret;
 }
 
-static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *device)
+static int netvsc_init_send_buf(struct hv_device *device)
 {
 	int ret = 0;
 	struct netvsc_device *net_device;
 	struct nvsp_message *init_packet;
 
-	net_device = GetOutboundNetDevice(device);
+	net_device = get_outbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
@@ -429,14 +431,14 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *device)
 	goto Exit;
 
 Cleanup:
-	NetVscDestroySendBuffer(net_device);
+	netvsc_destroy_send_buf(net_device);
 
 Exit:
-	PutNetDevice(device);
+	put_net_device(device);
 	return ret;
 }
 
-static int NetVscDestroyReceiveBuffer(struct netvsc_device *net_device)
+static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 {
 	struct nvsp_message *revoke_packet;
 	int ret = 0;
@@ -510,7 +512,7 @@ static int NetVscDestroyReceiveBuffer(struct netvsc_device *net_device)
 	return ret;
 }
 
-static int NetVscDestroySendBuffer(struct netvsc_device *net_device)
+static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 {
 	struct nvsp_message *revoke_packet;
 	int ret = 0;
@@ -581,14 +583,14 @@ static int NetVscDestroySendBuffer(struct netvsc_device *net_device)
 }
 
 
-static int NetVscConnectToVsp(struct hv_device *device)
+static int netvsc_connect_vsp(struct hv_device *device)
 {
 	int ret;
 	struct netvsc_device *net_device;
 	struct nvsp_message *init_packet;
 	int ndis_version;
 
-	net_device = GetOutboundNetDevice(device);
+	net_device = get_outbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
@@ -680,25 +682,26 @@ static int NetVscConnectToVsp(struct hv_device *device)
 	 /* osd_waitevent_wait(NetVscChannel->ChannelInitEvent); */
 
 	/* Post the big receive buffer to NetVSP */
-	ret = NetVscInitializeReceiveBufferWithNetVsp(device);
+	ret = netvsc_init_recv_buf(device);
 	if (ret == 0)
-		ret = NetVscInitializeSendBufferWithNetVsp(device);
+		ret = netvsc_init_send_buf(device);
 
 Cleanup:
-	PutNetDevice(device);
+	put_net_device(device);
 	return ret;
 }
 
 static void NetVscDisconnectFromVsp(struct netvsc_device *net_device)
 {
-	NetVscDestroyReceiveBuffer(net_device);
-	NetVscDestroySendBuffer(net_device);
+	netvsc_destroy_recv_buf(net_device);
+	netvsc_destroy_send_buf(net_device);
 }
 
 /*
- * NetVscOnDeviceAdd - Callback when the device belonging to this driver is added
+ * netvsc_device_add - Callback when the device belonging to this
+ * driver is added
  */
-static int NetVscOnDeviceAdd(struct hv_device *device, void *additional_info)
+static int netvsc_device_add(struct hv_device *device, void *additional_info)
 {
 	int ret = 0;
 	int i;
@@ -707,7 +710,7 @@ static int NetVscOnDeviceAdd(struct hv_device *device, void *additional_info)
 	struct netvsc_driver *net_driver =
 				(struct netvsc_driver *)device->Driver;
 
-	net_device = AllocNetDevice(device);
+	net_device = alloc_net_device(device);
 	if (!net_device) {
 		ret = -1;
 		goto Cleanup;
@@ -745,7 +748,7 @@ static int NetVscOnDeviceAdd(struct hv_device *device, void *additional_info)
 	/* Open the channel */
 	ret = vmbus_open(device->channel, net_driver->RingBufferSize,
 			 net_driver->RingBufferSize, NULL, 0,
-			 NetVscOnChannelCallback, device);
+			 netvsc_channel_cb, device);
 
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to open channel: %d", ret);
@@ -757,7 +760,7 @@ static int NetVscOnDeviceAdd(struct hv_device *device, void *additional_info)
 	DPRINT_INFO(NETVSC, "*** NetVSC channel opened successfully! ***");
 
 	/* Connect with the NetVsp */
-	ret = NetVscConnectToVsp(device);
+	ret = netvsc_connect_vsp(device);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC, "unable to connect to NetVSP - %d", ret);
 		ret = -1;
@@ -785,19 +788,19 @@ Cleanup:
 			kfree(packet);
 		}
 
-		ReleaseOutboundNetDevice(device);
-		ReleaseInboundNetDevice(device);
+		release_outbound_net_device(device);
+		release_inbound_net_device(device);
 
-		FreeNetDevice(net_device);
+		free_net_device(net_device);
 	}
 
 	return ret;
 }
 
 /*
- * NetVscOnDeviceRemove - Callback when the root bus device is removed
+ * netvsc_device_remove - Callback when the root bus device is removed
  */
-static int NetVscOnDeviceRemove(struct hv_device *device)
+static int netvsc_device_remove(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
 	struct hv_netvsc_packet *netvsc_packet, *pos;
@@ -806,7 +809,7 @@ static int NetVscOnDeviceRemove(struct hv_device *device)
 		    device->Extension);
 
 	/* Stop outbound traffic ie sends and receives completions */
-	net_device = ReleaseOutboundNetDevice(device);
+	net_device = release_outbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "No net device present!!");
 		return -1;
@@ -827,7 +830,7 @@ static int NetVscOnDeviceRemove(struct hv_device *device)
 		    device->Extension);
 
 	/* Stop inbound traffic ie receives and sends completions */
-	net_device = ReleaseInboundNetDevice(device);
+	net_device = release_inbound_net_device(device);
 
 	/* At this point, no one should be accessing netDevice except in here */
 	DPRINT_INFO(NETVSC, "net device (%p) safe to remove", net_device);
@@ -843,25 +846,25 @@ static int NetVscOnDeviceRemove(struct hv_device *device)
 	}
 
 	kfree(net_device->ChannelInitEvent);
-	FreeNetDevice(net_device);
+	free_net_device(net_device);
 	return 0;
 }
 
 /*
- * NetVscOnCleanup - Perform any cleanup when the driver is removed
+ * netvsc_cleanup - Perform any cleanup when the driver is removed
  */
-static void NetVscOnCleanup(struct hv_driver *drv)
+static void netvsc_cleanup(struct hv_driver *drv)
 {
 }
 
-static void NetVscOnSendCompletion(struct hv_device *device,
+static void netvsc_send_completion(struct hv_device *device,
 				   struct vmpacket_descriptor *packet)
 {
 	struct netvsc_device *net_device;
 	struct nvsp_message *nvsp_packet;
 	struct hv_netvsc_packet *nvsc_packet;
 
-	net_device = GetInboundNetDevice(device);
+	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
@@ -900,10 +903,10 @@ static void NetVscOnSendCompletion(struct hv_device *device,
 			   "%d received!!", nvsp_packet->Header.MessageType);
 	}
 
-	PutNetDevice(device);
+	put_net_device(device);
 }
 
-static int NetVscOnSend(struct hv_device *device,
+static int netvsc_send(struct hv_device *device,
 			struct hv_netvsc_packet *packet)
 {
 	struct netvsc_device *net_device;
@@ -911,7 +914,7 @@ static int NetVscOnSend(struct hv_device *device,
 
 	struct nvsp_message sendMessage;
 
-	net_device = GetOutboundNetDevice(device);
+	net_device = get_outbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "net device (%p) shutting down..."
 			   "ignoring outbound packets", net_device);
@@ -952,11 +955,11 @@ static int NetVscOnSend(struct hv_device *device,
 			   packet, ret);
 
 	atomic_inc(&net_device->NumOutstandingSends);
-	PutNetDevice(device);
+	put_net_device(device);
 	return ret;
 }
 
-static void NetVscOnReceive(struct hv_device *device,
+static void netvsc_receive(struct hv_device *device,
 			    struct vmpacket_descriptor *packet)
 {
 	struct netvsc_device *net_device;
@@ -972,7 +975,7 @@ static void NetVscOnReceive(struct hv_device *device,
 	unsigned long flags;
 	LIST_HEAD(listHead);
 
-	net_device = GetInboundNetDevice(device);
+	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
@@ -986,7 +989,7 @@ static void NetVscOnReceive(struct hv_device *device,
 	if (packet->Type != VmbusPacketTypeDataUsingTransferPages) {
 		DPRINT_ERR(NETVSC, "Unknown packet type received - %d",
 			   packet->Type);
-		PutNetDevice(device);
+		put_net_device(device);
 		return;
 	}
 
@@ -998,7 +1001,7 @@ static void NetVscOnReceive(struct hv_device *device,
 	    NvspMessage1TypeSendRNDISPacket) {
 		DPRINT_ERR(NETVSC, "Unknown nvsp packet type received - %d",
 			   nvsp_packet->Header.MessageType);
-		PutNetDevice(device);
+		put_net_device(device);
 		return;
 	}
 
@@ -1011,7 +1014,7 @@ static void NetVscOnReceive(struct hv_device *device,
 		DPRINT_ERR(NETVSC, "Invalid xfer page set id - "
 			   "expecting %x got %x", NETVSC_RECEIVE_BUFFER_ID,
 			   vmxferpage_packet->TransferPageSetId);
-		PutNetDevice(device);
+		put_net_device(device);
 		return;
 	}
 
@@ -1051,10 +1054,10 @@ static void NetVscOnReceive(struct hv_device *device,
 		spin_unlock_irqrestore(&net_device->receive_packet_list_lock,
 				       flags);
 
-		NetVscSendReceiveCompletion(device,
+		netvsc_send_recv_completion(device,
 					    vmxferpage_packet->d.TransactionId);
 
-		PutNetDevice(device);
+		put_net_device(device);
 		return;
 	}
 
@@ -1081,7 +1084,7 @@ static void NetVscOnReceive(struct hv_device *device,
 		/* Initialize the netvsc packet */
 		netvsc_packet->XferPagePacket = xferpage_packet;
 		netvsc_packet->Completion.Recv.OnReceiveCompletion =
-					NetVscOnReceiveCompletion;
+					netvsc_receive_completion;
 		netvsc_packet->Completion.Recv.ReceiveCompletionContext =
 					netvsc_packet;
 		netvsc_packet->Device = device;
@@ -1153,16 +1156,16 @@ static void NetVscOnReceive(struct hv_device *device,
 		((struct netvsc_driver *)device->Driver)->
 			OnReceiveCallback(device, netvsc_packet);
 
-		NetVscOnReceiveCompletion(netvsc_packet->
+		netvsc_receive_completion(netvsc_packet->
 				Completion.Recv.ReceiveCompletionContext);
 	}
 
 	/* ASSERT(list_empty(&listHead)); */
 
-	PutNetDevice(device);
+	put_net_device(device);
 }
 
-static void NetVscSendReceiveCompletion(struct hv_device *device,
+static void netvsc_send_recv_completion(struct hv_device *device,
 					u64 transaction_id)
 {
 	struct nvsp_message recvcompMessage;
@@ -1207,7 +1210,7 @@ retry_send_cmplt:
 }
 
 /* Send a receive completion packet to RNDIS device (ie NetVsp) */
-static void NetVscOnReceiveCompletion(void *context)
+static void netvsc_receive_completion(void *context)
 {
 	struct hv_netvsc_packet *packet = context;
 	struct hv_device *device = (struct hv_device *)packet->Device;
@@ -1223,7 +1226,7 @@ static void NetVscOnReceiveCompletion(void *context)
 	 * send out receive completion, we are using GetInboundNetDevice()
 	 * since we may have disable outbound traffic already.
 	 */
-	net_device = GetInboundNetDevice(device);
+	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "unable to get net device..."
 			   "device being destroyed?");
@@ -1254,12 +1257,12 @@ static void NetVscOnReceiveCompletion(void *context)
 
 	/* Send a receive completion for the xfer page packet */
 	if (fsend_receive_comp)
-		NetVscSendReceiveCompletion(device, transaction_id);
+		netvsc_send_recv_completion(device, transaction_id);
 
-	PutNetDevice(device);
+	put_net_device(device);
 }
 
-static void NetVscOnChannelCallback(void *context)
+static void netvsc_channel_cb(void *context)
 {
 	int ret;
 	struct hv_device *device = context;
@@ -1279,7 +1282,7 @@ static void NetVscOnChannelCallback(void *context)
 		return;
 	buffer = packet;
 
-	net_device = GetInboundNetDevice(device);
+	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		DPRINT_ERR(NETVSC, "net device (%p) shutting down..."
 			   "ignoring inbound packets", net_device);
@@ -1297,11 +1300,11 @@ static void NetVscOnChannelCallback(void *context)
 				desc = (struct vmpacket_descriptor *)buffer;
 				switch (desc->Type) {
 				case VmbusPacketTypeCompletion:
-					NetVscOnSendCompletion(device, desc);
+					netvsc_send_completion(device, desc);
 					break;
 
 				case VmbusPacketTypeDataUsingTransferPages:
-					NetVscOnReceive(device, desc);
+					netvsc_receive(device, desc);
 					break;
 
 				default:
@@ -1344,7 +1347,7 @@ static void NetVscOnChannelCallback(void *context)
 		}
 	} while (1);
 
-	PutNetDevice(device);
+	put_net_device(device);
 out:
 	kfree(buffer);
 	return;
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index 4b5b3ac..dbf154a 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -109,7 +109,7 @@ struct netvsc_device_info {
 };
 
 /* Interface */
-int NetVscInitialize(struct hv_driver *drv);
+int netvsc_initialize(struct hv_driver *drv);
 int RndisFilterOnOpen(struct hv_device *Device);
 int RndisFilterOnClose(struct hv_device *Device);
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index f527e5f..cd3eef0 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -539,7 +539,7 @@ static int __init netvsc_init(void)
 	if (!dmi_check_system(hv_netvsc_dmi_table))
 		return -ENODEV;
 
-	return netvsc_drv_init(NetVscInitialize);
+	return netvsc_drv_init(netvsc_initialize);
 }
 
 static void __exit netvsc_exit(void)
-- 
1.6.3.2

