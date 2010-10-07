Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab0JGShw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:37:52 -0400
Received: from p3plsmtpa01-09.prod.phx3.secureserver.net ([72.167.82.89]:52795
	"HELO p3plsmtpa01-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751181Ab0JGShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:37:43 -0400
Message-ID: <4CAE1408.1050306@sailtheuniverse.com>
Date: Thu, 07 Oct 2010 11:40:08 -0700
From: Hank Janssen <hjanssen@sailtheuniverse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: gregkh@suse.de, hjanssen@microsoft.com,
        Haiyang Zhang <haiyangz@microsoft.com>, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] staging: hv: Rename camel cased functions in channel.c
 to lowercase
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Rename camel cased functions in channel.c to lowercase

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c           |  102 ++++++++++++++++----------------
 drivers/staging/hv/channel.h           |   94 +++++++++++++++---------------
 drivers/staging/hv/channel_interface.c |   20 +++---
 drivers/staging/hv/channel_mgmt.c      |    8 +-
 drivers/staging/hv/connection.c        |    4 +-
 drivers/staging/hv/hv_utils.c          |   12 ++--
 6 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 1037488..39b8fd3 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -27,13 +27,13 @@
 #include "vmbus_private.h"
 
 /* Internal routines */
-static int VmbusChannelCreateGpadlHeader(
+static int create_gpadl_header(
 	void *kbuffer,	/* must be phys and virt contiguous */
 	u32 size,	/* page-size multiple */
 	struct vmbus_channel_msginfo **msginfo,
 	u32 *messagecount);
-static void DumpVmbusChannel(struct vmbus_channel *channel);
-static void VmbusChannelSetEvent(struct vmbus_channel *channel);
+static void dump_vmbus_channel(struct vmbus_channel *channel);
+static void vmbus_setevent(struct vmbus_channel *channel);
 
 
 #if 0
@@ -67,10 +67,10 @@ static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)
 #endif
 
 /*
- * VmbusChannelSetEvent - Trigger an event notification on the specified
+ * vmbus_setevent- Trigger an event notification on the specified
  * channel.
  */
-static void VmbusChannelSetEvent(struct vmbus_channel *channel)
+static void vmbus_setevent(struct vmbus_channel *channel)
 {
 	struct hv_monitor_page *monitorpage;
 
@@ -115,9 +115,9 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 
 #endif
 /*
- * VmbusChannelGetDebugInfo -Retrieve various channel debug info
+ * vmbus_get_debug_info -Retrieve various channel debug info
  */
-void VmbusChannelGetDebugInfo(struct vmbus_channel *channel,
+void vmbus_get_debug_info(struct vmbus_channel *channel,
 			      struct vmbus_channel_debug_info *debuginfo)
 {
 	struct hv_monitor_page *monitorpage;
@@ -160,9 +160,9 @@ void VmbusChannelGetDebugInfo(struct vmbus_channel *channel,
 }
 
 /*
- * VmbusChannelOpen - Open the specified channel.
+ * vmbus_open - Open the specified channel.
  */
-int VmbusChannelOpen(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
+int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		     u32 recv_ringbuffer_size, void *userdata, u32 userdatalen,
 		     void (*onchannelcallback)(void *context), void *context)
 {
@@ -212,7 +212,7 @@ int VmbusChannelOpen(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	newchannel->RingBufferGpadlHandle = 0;
 
-	ret = VmbusChannelEstablishGpadl(newchannel,
+	ret = vmbus_establish_gpadl(newchannel,
 					 newchannel->Outbound.RingBuffer,
 					 send_ringbuffer_size +
 					 recv_ringbuffer_size,
@@ -307,10 +307,10 @@ errorout:
 }
 
 /*
- * DumpGpadlBody - Dump the gpadl body message to the console for
+ * dump_gpadl_body - Dump the gpadl body message to the console for
  * debugging purposes.
  */
-static void DumpGpadlBody(struct vmbus_channel_gpadl_body *gpadl, u32 len)
+static void dump_gpadl_body(struct vmbus_channel_gpadl_body *gpadl, u32 len)
 {
 	int i;
 	int pfncount;
@@ -325,10 +325,10 @@ static void DumpGpadlBody(struct vmbus_channel_gpadl_body *gpadl, u32 len)
 }
 
 /*
- * DumpGpadlHeader - Dump the gpadl header message to the console for
+ * dump_gpadl_header - Dump the gpadl header message to the console for
  * debugging purposes.
  */
-static void DumpGpadlHeader(struct vmbus_channel_gpadl_header *gpadl)
+static void dump_gpadl_header(struct vmbus_channel_gpadl_header *gpadl)
 {
 	int i, j;
 	int pagecount;
@@ -351,9 +351,9 @@ static void DumpGpadlHeader(struct vmbus_channel_gpadl_header *gpadl)
 }
 
 /*
- * VmbusChannelCreateGpadlHeader - Creates a gpadl for the specified buffer
+ * create_gpadl_header - Creates a gpadl for the specified buffer
  */
-static int VmbusChannelCreateGpadlHeader(void *kbuffer, u32 size,
+static int create_gpadl_header(void *kbuffer, u32 size,
 					 struct vmbus_channel_msginfo **msginfo,
 					 u32 *messagecount)
 {
@@ -479,14 +479,14 @@ nomem:
 }
 
 /*
- * VmbusChannelEstablishGpadl - Estabish a GPADL for the specified buffer
+ * vmbus_establish_gpadl - Estabish a GPADL for the specified buffer
  *
  * @channel: a channel
  * @kbuffer: from kmalloc
  * @size: page-size multiple
  * @gpadl_handle: some funky thing
  */
-int VmbusChannelEstablishGpadl(struct vmbus_channel *channel, void *kbuffer,
+int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 			       u32 size, u32 *gpadl_handle)
 {
 	struct vmbus_channel_gpadl_header *gpadlmsg;
@@ -503,7 +503,7 @@ int VmbusChannelEstablishGpadl(struct vmbus_channel *channel, void *kbuffer,
 	next_gpadl_handle = atomic_read(&gVmbusConnection.NextGpadlHandle);
 	atomic_inc(&gVmbusConnection.NextGpadlHandle);
 
-	ret = VmbusChannelCreateGpadlHeader(kbuffer, size, &msginfo, &msgcount);
+	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
 	if (ret)
 		return ret;
 
@@ -518,7 +518,7 @@ int VmbusChannelEstablishGpadl(struct vmbus_channel *channel, void *kbuffer,
 	gpadlmsg->ChildRelId = channel->OfferMsg.ChildRelId;
 	gpadlmsg->Gpadl = next_gpadl_handle;
 
-	DumpGpadlHeader(gpadlmsg);
+	dump_gpadl_header(gpadlmsg);
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
 	list_add_tail(&msginfo->MsgListEntry,
@@ -554,7 +554,7 @@ int VmbusChannelEstablishGpadl(struct vmbus_channel *channel, void *kbuffer,
 				   submsginfo->MessageSize -
 				   sizeof(*submsginfo));
 
-			DumpGpadlBody(gpadl_body, submsginfo->MessageSize -
+			dump_gpadl_body(gpadl_body, submsginfo->MessageSize -
 				      sizeof(*submsginfo));
 			ret = VmbusPostMessage(gpadl_body,
 					       submsginfo->MessageSize -
@@ -586,9 +586,9 @@ Cleanup:
 }
 
 /*
- * VmbusChannelTeardownGpadl -Teardown the specified GPADL handle
+ * vmbus_teardown_gpadl -Teardown the specified GPADL handle
  */
-int VmbusChannelTeardownGpadl(struct vmbus_channel *channel, u32 gpadl_handle)
+int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 {
 	struct vmbus_channel_gpadl_teardown *msg;
 	struct vmbus_channel_msginfo *info;
@@ -639,9 +639,9 @@ int VmbusChannelTeardownGpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 }
 
 /*
- * VmbusChannelClose - Close the specified channel
+ * vmbus_close - Close the specified channel
  */
-void VmbusChannelClose(struct vmbus_channel *channel)
+void vmbus_close(struct vmbus_channel *channel)
 {
 	struct vmbus_channel_close_channel *msg;
 	struct vmbus_channel_msginfo *info;
@@ -674,7 +674,7 @@ void VmbusChannelClose(struct vmbus_channel *channel)
 
 	/* Tear down the gpadl for the channel's ring buffer */
 	if (channel->RingBufferGpadlHandle)
-		VmbusChannelTeardownGpadl(channel,
+		vmbus_teardown_gpadl(channel,
 					  channel->RingBufferGpadlHandle);
 
 	/* TODO: Send a msg to release the childRelId */
@@ -703,7 +703,7 @@ void VmbusChannelClose(struct vmbus_channel *channel)
 }
 
 /**
- * VmbusChannelSendPacket() - Send the specified buffer on the given channel
+ * vmbus_sendpacket() - Send the specified buffer on the given channel
  * @channel: Pointer to vmbus_channel structure.
  * @buffer: Pointer to the buffer you want to receive the data into.
  * @bufferlen: Maximum size of what the the buffer will hold
@@ -716,7 +716,7 @@ void VmbusChannelClose(struct vmbus_channel *channel)
  *
  * Mainly used by Hyper-V drivers.
  */
-int VmbusChannelSendPacket(struct vmbus_channel *channel, const void *buffer,
+int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 			   u32 bufferlen, u64 requestid,
 			   enum vmbus_packet_type type, u32 flags)
 {
@@ -730,7 +730,7 @@ int VmbusChannelSendPacket(struct vmbus_channel *channel, const void *buffer,
 	DPRINT_DBG(VMBUS, "channel %p buffer %p len %d",
 		   channel, buffer, bufferlen);
 
-	DumpVmbusChannel(channel);
+	dump_vmbus_channel(channel);
 
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
@@ -752,17 +752,17 @@ int VmbusChannelSendPacket(struct vmbus_channel *channel, const void *buffer,
 
 	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
-		VmbusChannelSetEvent(channel);
+		vmbus_setevent(channel);
 
 	return ret;
 }
-EXPORT_SYMBOL(VmbusChannelSendPacket);
+EXPORT_SYMBOL(vmbus_sendpacket);
 
 /*
- * VmbusChannelSendPacketPageBuffer - Send a range of single-page buffer
+ * vmbus_sendpacket_pagebuffer - Send a range of single-page buffer
  * packets using a GPADL Direct packet type.
  */
-int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *channel,
+int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 				     struct hv_page_buffer pagebuffers[],
 				     u32 pagecount, void *buffer, u32 bufferlen,
 				     u64 requestid)
@@ -779,7 +779,7 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *channel,
 	if (pagecount > MAX_PAGE_BUFFER_COUNT)
 		return -EINVAL;
 
-	DumpVmbusChannel(channel);
+	dump_vmbus_channel(channel);
 
 	/*
 	 * Adjust the size down since vmbus_channel_packet_page_buffer is the
@@ -817,16 +817,16 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *channel,
 
 	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
-		VmbusChannelSetEvent(channel);
+		vmbus_setevent(channel);
 
 	return ret;
 }
 
 /*
- * VmbusChannelSendPacketMultiPageBuffer - Send a multi-page buffer packet
+ * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
  * using a GPADL Direct packet type.
  */
-int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *channel,
+int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 				struct hv_multipage_buffer *multi_pagebuffer,
 				void *buffer, u32 bufferlen, u64 requestid)
 {
@@ -840,7 +840,7 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *channel,
 	u32 pfncount = NUM_PAGES_SPANNED(multi_pagebuffer->Offset,
 					 multi_pagebuffer->Length);
 
-	DumpVmbusChannel(channel);
+	dump_vmbus_channel(channel);
 
 	DPRINT_DBG(VMBUS, "data buffer - offset %u len %u pfn count %u",
 		multi_pagebuffer->Offset,
@@ -885,14 +885,14 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *channel,
 
 	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
-		VmbusChannelSetEvent(channel);
+		vmbus_setevent(channel);
 
 	return ret;
 }
 
 
 /**
- * VmbusChannelRecvPacket() - Retrieve the user packet on the specified channel
+ * vmbus_recvpacket() - Retrieve the user packet on the specified channel
  * @channel: Pointer to vmbus_channel structure.
  * @buffer: Pointer to the buffer you want to receive the data into.
  * @bufferlen: Maximum size of what the the buffer will hold
@@ -904,7 +904,7 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *channel,
  *
  * Mainly used by Hyper-V drivers.
  */
-int VmbusChannelRecvPacket(struct vmbus_channel *channel, void *buffer,
+int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 			u32 bufferlen, u32 *buffer_actual_len, u64 *requestid)
 {
 	struct vmpacket_descriptor desc;
@@ -958,12 +958,12 @@ int VmbusChannelRecvPacket(struct vmbus_channel *channel, void *buffer,
 
 	return 0;
 }
-EXPORT_SYMBOL(VmbusChannelRecvPacket);
+EXPORT_SYMBOL(vmbus_recvpacket);
 
 /*
- * VmbusChannelRecvPacketRaw - Retrieve the raw packet on the specified channel
+ * vmbus_recvpacket_raw - Retrieve the raw packet on the specified channel
  */
-int VmbusChannelRecvPacketRaw(struct vmbus_channel *channel, void *buffer,
+int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 			      u32 bufferlen, u32 *buffer_actual_len,
 			      u64 *requestid)
 {
@@ -1017,11 +1017,11 @@ int VmbusChannelRecvPacketRaw(struct vmbus_channel *channel, void *buffer,
 }
 
 /*
- * VmbusChannelOnChannelEvent - Channel event callback
+ * vmbus_onchannel_event - Channel event callback
  */
-void VmbusChannelOnChannelEvent(struct vmbus_channel *channel)
+void vmbus_onchannel_event(struct vmbus_channel *channel)
 {
-	DumpVmbusChannel(channel);
+	dump_vmbus_channel(channel);
 	/* ASSERT(Channel->OnChannelCallback); */
 
 	channel->OnChannelCallback(channel->ChannelCallbackContext);
@@ -1030,9 +1030,9 @@ void VmbusChannelOnChannelEvent(struct vmbus_channel *channel)
 }
 
 /*
- * VmbusChannelOnTimer - Timer event callback
+ * vmbus_ontimer - Timer event callback
  */
-void VmbusChannelOnTimer(unsigned long data)
+void vmbus_ontimer(unsigned long data)
 {
 	struct vmbus_channel *channel = (struct vmbus_channel *)data;
 
@@ -1041,9 +1041,9 @@ void VmbusChannelOnTimer(unsigned long data)
 }
 
 /*
- * DumpVmbusChannel - Dump vmbus channel info to the console
+ * dump_vmbus_channel- Dump vmbus channel info to the console
  */
-static void DumpVmbusChannel(struct vmbus_channel *channel)
+static void dump_vmbus_channel(struct vmbus_channel *channel)
 {
 	DPRINT_DBG(VMBUS, "Channel (%d)", channel->OfferMsg.ChildRelId);
 	DumpRingInfo(&channel->Outbound, "Outbound ");
diff --git a/drivers/staging/hv/channel.h b/drivers/staging/hv/channel.h
index 85c5079..7997056 100644
--- a/drivers/staging/hv/channel.h
+++ b/drivers/staging/hv/channel.h
@@ -52,61 +52,61 @@ struct vmbus_channel_packet_multipage_buffer {
 } __attribute__((packed));
 
 
-extern int VmbusChannelOpen(struct vmbus_channel *channel,
-			    u32 SendRingBufferSize,
-			    u32 RecvRingBufferSize,
-			    void *UserData,
-			    u32 UserDataLen,
-			    void(*OnChannelCallback)(void *context),
-			    void *Context);
-
-extern void VmbusChannelClose(struct vmbus_channel *channel);
-
-extern int VmbusChannelSendPacket(struct vmbus_channel *channel,
-				  const void *Buffer,
-				  u32 BufferLen,
-				  u64 RequestId,
-				  enum vmbus_packet_type Type,
-				  u32 Flags);
-
-extern int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *channel,
-					    struct hv_page_buffer PageBuffers[],
-					    u32 PageCount,
-					    void *Buffer,
-					    u32 BufferLen,
-					    u64 RequestId);
-
-extern int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *channel,
+extern int vmbus_open(struct vmbus_channel *channel,
+			    u32 send_ringbuffersize,
+			    u32 recv_ringbuffersize,
+			    void *userdata,
+			    u32 userdatalen,
+			    void(*onchannel_callback)(void *context),
+			    void *context);
+
+extern void vmbus_close(struct vmbus_channel *channel);
+
+extern int vmbus_sendpacket(struct vmbus_channel *channel,
+				  const void *buffer,
+				  u32 bufferLen,
+				  u64 requestid,
+				  enum vmbus_packet_type type,
+				  u32 flags);
+
+extern int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
+					    struct hv_page_buffer pagebuffers[],
+					    u32 pagecount,
+					    void *buffer,
+					    u32 bufferlen,
+					    u64 requestid);
+
+extern int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 					struct hv_multipage_buffer *mpb,
-					void *Buffer,
-					u32 BufferLen,
-					u64 RequestId);
+					void *buffer,
+					u32 bufferlen,
+					u64 requestid);
 
-extern int VmbusChannelEstablishGpadl(struct vmbus_channel *channel,
-				      void *Kbuffer,
-				      u32 Size,
-				      u32 *GpadlHandle);
+extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
+				      void *kbuffer,
+				      u32 size,
+				      u32 *gpadl_handle);
 
-extern int VmbusChannelTeardownGpadl(struct vmbus_channel *channel,
-				     u32 GpadlHandle);
+extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
+				     u32 gpadl_handle);
 
-extern int VmbusChannelRecvPacket(struct vmbus_channel *channel,
-				  void *Buffer,
-				  u32 BufferLen,
-				  u32 *BufferActualLen,
-				  u64 *RequestId);
+extern int vmbus_recvpacket(struct vmbus_channel *channel,
+				  void *buffer,
+				  u32 bufferlen,
+				  u32 *buffer_actual_len,
+				  u64 *requestid);
 
-extern int VmbusChannelRecvPacketRaw(struct vmbus_channel *channel,
-				     void *Buffer,
-				     u32 BufferLen,
-				     u32 *BufferActualLen,
-				     u64 *RequestId);
+extern int vmbus_recvpacket_raw(struct vmbus_channel *channel,
+				     void *buffer,
+				     u32 bufferlen,
+				     u32 *buffer_actual_len,
+				     u64 *requestid);
 
-extern void VmbusChannelOnChannelEvent(struct vmbus_channel *channel);
+extern void vmbus_onchannel_event(struct vmbus_channel *channel);
 
-extern void VmbusChannelGetDebugInfo(struct vmbus_channel *channel,
+extern void vmbus_get_debug_info(struct vmbus_channel *channel,
 				     struct vmbus_channel_debug_info *debug);
 
-extern void VmbusChannelOnTimer(unsigned long data);
+extern void vmbus_ontimer(unsigned long data);
 
 #endif /* _CHANNEL_H_ */
diff --git a/drivers/staging/hv/channel_interface.c b/drivers/staging/hv/channel_interface.c
index 3f6a1cb..4d35923 100644
--- a/drivers/staging/hv/channel_interface.c
+++ b/drivers/staging/hv/channel_interface.c
@@ -31,21 +31,21 @@ static int IVmbusChannelOpen(struct hv_device *device, u32 SendBufferSize,
 			     void (*ChannelCallback)(void *context),
 			     void *Context)
 {
-	return VmbusChannelOpen(device->context, SendBufferSize,
+	return vmbus_open(device->context, SendBufferSize,
 				RecvRingBufferSize, UserData, UserDataLen,
 				ChannelCallback, Context);
 }
 
 static void IVmbusChannelClose(struct hv_device *device)
 {
-	VmbusChannelClose(device->context);
+	vmbus_close(device->context);
 }
 
 static int IVmbusChannelSendPacket(struct hv_device *device, const void *Buffer,
 				   u32 BufferLen, u64 RequestId, u32 Type,
 				   u32 Flags)
 {
-	return VmbusChannelSendPacket(device->context, Buffer, BufferLen,
+	return vmbus_sendpacket(device->context, Buffer, BufferLen,
 				      RequestId, Type, Flags);
 }
 
@@ -54,7 +54,7 @@ static int IVmbusChannelSendPacketPageBuffer(struct hv_device *device,
 				u32 PageCount, void *Buffer,
 				u32 BufferLen, u64 RequestId)
 {
-	return VmbusChannelSendPacketPageBuffer(device->context, PageBuffers,
+	return vmbus_sendpacket_pagebuffer(device->context, PageBuffers,
 						PageCount, Buffer, BufferLen,
 						RequestId);
 }
@@ -63,7 +63,7 @@ static int IVmbusChannelSendPacketMultiPageBuffer(struct hv_device *device,
 				struct hv_multipage_buffer *MultiPageBuffer,
 				void *Buffer, u32 BufferLen, u64 RequestId)
 {
-	return VmbusChannelSendPacketMultiPageBuffer(device->context,
+	return vmbus_sendpacket_multipagebuffer(device->context,
 						     MultiPageBuffer, Buffer,
 						     BufferLen, RequestId);
 }
@@ -72,7 +72,7 @@ static int IVmbusChannelRecvPacket(struct hv_device *device, void *Buffer,
 				   u32 BufferLen, u32 *BufferActualLen,
 				   u64 *RequestId)
 {
-	return VmbusChannelRecvPacket(device->context, Buffer, BufferLen,
+	return vmbus_recvpacket(device->context, Buffer, BufferLen,
 				      BufferActualLen, RequestId);
 }
 
@@ -80,20 +80,20 @@ static int IVmbusChannelRecvPacketRaw(struct hv_device *device, void *Buffer,
 				      u32 BufferLen, u32 *BufferActualLen,
 				      u64 *RequestId)
 {
-	return VmbusChannelRecvPacketRaw(device->context, Buffer, BufferLen,
+	return vmbus_recvpacket_raw(device->context, Buffer, BufferLen,
 					 BufferActualLen, RequestId);
 }
 
 static int IVmbusChannelEstablishGpadl(struct hv_device *device, void *Buffer,
 				       u32 BufferLen, u32 *GpadlHandle)
 {
-	return VmbusChannelEstablishGpadl(device->context, Buffer, BufferLen,
+	return vmbus_establish_gpadl(device->context, Buffer, BufferLen,
 					  GpadlHandle);
 }
 
 static int IVmbusChannelTeardownGpadl(struct hv_device *device, u32 GpadlHandle)
 {
-	return VmbusChannelTeardownGpadl(device->context, GpadlHandle);
+	return vmbus_teardown_gpadl(device->context, GpadlHandle);
 
 }
 
@@ -105,7 +105,7 @@ void GetChannelInfo(struct hv_device *device, struct hv_device_info *info)
 	if (!device->context)
 		return;
 
-	VmbusChannelGetDebugInfo(device->context, &debugInfo);
+	vmbus_get_debug_info(device->context, &debugInfo);
 
 	info->ChannelId = debugInfo.RelId;
 	info->ChannelState = debugInfo.State;
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 6ccf505..bdfd5af 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -172,7 +172,7 @@ void chn_cb_negotiate(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		icmsghdrp = (struct icmsg_hdr *)&buf[
@@ -183,7 +183,7 @@ void chn_cb_negotiate(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbus_sendpacket(channel, buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
@@ -249,7 +249,7 @@ struct vmbus_channel *AllocVmbusChannel(void)
 
 	init_timer(&channel->poll_timer);
 	channel->poll_timer.data = (unsigned long)channel;
-	channel->poll_timer.function = VmbusChannelOnTimer;
+	channel->poll_timer.function = vmbus_ontimer;
 
 	channel->ControlWQ = create_workqueue("hv_vmbus_ctl");
 	if (!channel->ControlWQ) {
@@ -392,7 +392,7 @@ static void VmbusChannelProcessOffer(void *context)
 			if (memcmp(&newChannel->OfferMsg.Offer.InterfaceType,
 				   &hv_cb_utils[cnt].data,
 				   sizeof(struct hv_guid)) == 0 &&
-				VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
+				vmbus_open(newChannel, 2 * PAGE_SIZE,
 						 2 * PAGE_SIZE, NULL, 0,
 						 hv_cb_utils[cnt].callback,
 						 newChannel) == 0) {
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 1f4d668..f847707 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -254,10 +254,10 @@ static void VmbusProcessChannelEvent(void *context)
 	channel = GetChannelFromRelId(relId);
 
 	if (channel) {
-		VmbusChannelOnChannelEvent(channel);
+		vmbus_onchannel_event(channel);
 		/*
 		 * WorkQueueQueueWorkItem(channel->dataWorkQueue,
-		 *			  VmbusChannelOnChannelEvent,
+		 *			  vmbus_onchannel_event,
 		 *			  (void*)channel);
 		 */
 	} else {
diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 6eb79fe..702a478 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -55,7 +55,7 @@ static void shutdown_onchannelcallback(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
@@ -93,7 +93,7 @@ static void shutdown_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbus_sendpacket(channel, buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
@@ -159,7 +159,7 @@ static void timesync_onchannelcallback(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "timesync packet: recvlen=%d, requestid=%lld",
@@ -180,7 +180,7 @@ static void timesync_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbus_sendpacket(channel, buf,
 				recvlen, requestid,
 				VmbusPacketTypeDataInBand, 0);
 	}
@@ -205,7 +205,7 @@ static void heartbeat_onchannelcallback(void *context)
 	buflen = PAGE_SIZE;
 	buf = kmalloc(buflen, GFP_ATOMIC);
 
-	VmbusChannelRecvPacket(channel, buf, buflen, &recvlen, &requestid);
+	vmbus_recvpacket(channel, buf, buflen, &recvlen, &requestid);
 
 	if (recvlen > 0) {
 		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
@@ -233,7 +233,7 @@ static void heartbeat_onchannelcallback(void *context)
 		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
 			| ICMSGHDRFLAG_RESPONSE;
 
-		VmbusChannelSendPacket(channel, buf,
+		vmbus_sendpacket(channel, buf,
 				       recvlen, requestid,
 				       VmbusPacketTypeDataInBand, 0);
 	}
-- 
1.6.3.2


