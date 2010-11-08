Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0KHWDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:03:41 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:46106
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755827Ab0KHWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:03 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 01/10] staging: hv: Convert camel cased struct fields in channel_mgmt.h to lower cases
Date: Mon,  8 Nov 2010 14:04:38 -0800
Message-Id: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased struct fields in channel_mgmt.h to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c      |  302 ++++++++++++++++++------------------
 drivers/staging/hv/channel_mgmt.c |  186 ++++++++++++------------
 drivers/staging/hv/channel_mgmt.h |  244 +++++++++++++++---------------
 drivers/staging/hv/connection.c   |   38 +++---
 drivers/staging/hv/hv_utils.c     |   12 +-
 drivers/staging/hv/vmbus_drv.c    |   42 +++---
 6 files changed, 412 insertions(+), 412 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 26ebc77..9fa0fe1 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -74,21 +74,21 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 {
 	struct hv_monitor_page *monitorpage;
 
-	if (channel->OfferMsg.MonitorAllocated) {
+	if (channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
-		set_bit(channel->OfferMsg.ChildRelId & 31,
+		set_bit(channel->offermsg.child_relid & 31,
 			(unsigned long *) gVmbusConnection.SendInterruptPage +
-			(channel->OfferMsg.ChildRelId >> 5));
+			(channel->offermsg.child_relid >> 5));
 
 		monitorpage = gVmbusConnection.MonitorPages;
 		monitorpage++; /* Get the child to parent monitor page */
 
-		set_bit(channel->MonitorBit,
+		set_bit(channel->monitor_bit,
 			(unsigned long *)&monitorpage->TriggerGroup
-					[channel->MonitorGroup].Pending);
+					[channel->monitor_grp].Pending);
 
 	} else {
-		VmbusSetEvent(channel->OfferMsg.ChildRelId);
+		VmbusSetEvent(channel->offermsg.child_relid);
 	}
 }
 
@@ -97,19 +97,19 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 {
 	struct hv_monitor_page *monitorPage;
 
-	if (Channel->OfferMsg.MonitorAllocated) {
+	if (Channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
-		clear_bit(Channel->OfferMsg.ChildRelId & 31,
+		clear_bit(Channel->offermsg.child_relid & 31,
 			  (unsigned long *)gVmbusConnection.SendInterruptPage +
-			  (Channel->OfferMsg.ChildRelId >> 5));
+			  (Channel->offermsg.child_relid >> 5));
 
 		monitorPage =
 			(struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 		monitorPage++; /* Get the child to parent monitor page */
 
-		clear_bit(Channel->MonitorBit,
+		clear_bit(Channel->monitor_bit,
 			  (unsigned long *)&monitorPage->TriggerGroup
-					[Channel->MonitorGroup].Pending);
+					[Channel->monitor_grp].Pending);
 	}
 }
 
@@ -121,42 +121,42 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 			      struct vmbus_channel_debug_info *debuginfo)
 {
 	struct hv_monitor_page *monitorpage;
-	u8 monitor_group = (u8)channel->OfferMsg.MonitorId / 32;
-	u8 monitor_offset = (u8)channel->OfferMsg.MonitorId % 32;
+	u8 monitor_group = (u8)channel->offermsg.monitorid / 32;
+	u8 monitor_offset = (u8)channel->offermsg.monitorid % 32;
 	/* u32 monitorBit	= 1 << monitorOffset; */
 
-	debuginfo->RelId = channel->OfferMsg.ChildRelId;
-	debuginfo->State = channel->State;
-	memcpy(&debuginfo->InterfaceType,
-	       &channel->OfferMsg.Offer.InterfaceType, sizeof(struct hv_guid));
-	memcpy(&debuginfo->InterfaceInstance,
-	       &channel->OfferMsg.Offer.InterfaceInstance,
+	debuginfo->relid = channel->offermsg.child_relid;
+	debuginfo->state = channel->state;
+	memcpy(&debuginfo->interfacetype,
+	       &channel->offermsg.offer.InterfaceType, sizeof(struct hv_guid));
+	memcpy(&debuginfo->interface_instance,
+	       &channel->offermsg.offer.InterfaceInstance,
 	       sizeof(struct hv_guid));
 
 	monitorpage = (struct hv_monitor_page *)gVmbusConnection.MonitorPages;
 
-	debuginfo->MonitorId = channel->OfferMsg.MonitorId;
+	debuginfo->monitorid = channel->offermsg.monitorid;
 
-	debuginfo->ServerMonitorPending =
+	debuginfo->servermonitor_pending =
 			monitorpage->TriggerGroup[monitor_group].Pending;
-	debuginfo->ServerMonitorLatency =
+	debuginfo->servermonitor_latency =
 			monitorpage->Latency[monitor_group][monitor_offset];
-	debuginfo->ServerMonitorConnectionId =
+	debuginfo->servermonitor_connectionid =
 			monitorpage->Parameter[monitor_group]
 					[monitor_offset].ConnectionId.u.Id;
 
 	monitorpage++;
 
-	debuginfo->ClientMonitorPending =
+	debuginfo->clientmonitor_pending =
 			monitorpage->TriggerGroup[monitor_group].Pending;
-	debuginfo->ClientMonitorLatency =
+	debuginfo->clientmonitor_latency =
 			monitorpage->Latency[monitor_group][monitor_offset];
-	debuginfo->ClientMonitorConnectionId =
+	debuginfo->clientmonitor_connectionid =
 			monitorpage->Parameter[monitor_group]
 					[monitor_offset].ConnectionId.u.Id;
 
-	RingBufferGetDebugInfo(&channel->Inbound, &debuginfo->Inbound);
-	RingBufferGetDebugInfo(&channel->Outbound, &debuginfo->Outbound);
+	RingBufferGetDebugInfo(&channel->inbound, &debuginfo->inbound);
+	RingBufferGetDebugInfo(&channel->outbound, &debuginfo->outbound);
 }
 
 /*
@@ -176,8 +176,8 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	/* ASSERT(!(SendRingBufferSize & (PAGE_SIZE - 1))); */
 	/* ASSERT(!(RecvRingBufferSize & (PAGE_SIZE - 1))); */
 
-	newchannel->OnChannelCallback = onchannelcallback;
-	newchannel->ChannelCallbackContext = context;
+	newchannel->onchannel_callback = onchannelcallback;
+	newchannel->channel_callback_context = context;
 
 	/* Allocate the ring buffer */
 	out = osd_PageAlloc((send_ringbuffer_size + recv_ringbuffer_size)
@@ -189,17 +189,17 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	in = (void *)((unsigned long)out + send_ringbuffer_size);
 
-	newchannel->RingBufferPages = out;
-	newchannel->RingBufferPageCount = (send_ringbuffer_size +
+	newchannel->ringbuffer_pages = out;
+	newchannel->ringbuffer_pagecount = (send_ringbuffer_size +
 					   recv_ringbuffer_size) >> PAGE_SHIFT;
 
-	ret = RingBufferInit(&newchannel->Outbound, out, send_ringbuffer_size);
+	ret = RingBufferInit(&newchannel->outbound, out, send_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
 	}
 
-	ret = RingBufferInit(&newchannel->Inbound, in, recv_ringbuffer_size);
+	ret = RingBufferInit(&newchannel->inbound, in, recv_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
@@ -210,13 +210,13 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	DPRINT_DBG(VMBUS, "Establishing ring buffer's gpadl for channel %p...",
 		   newchannel);
 
-	newchannel->RingBufferGpadlHandle = 0;
+	newchannel->ringbuffer_gpadlhandle = 0;
 
 	ret = vmbus_establish_gpadl(newchannel,
-					 newchannel->Outbound.RingBuffer,
+					 newchannel->outbound.RingBuffer,
 					 send_ringbuffer_size +
 					 recv_ringbuffer_size,
-					 &newchannel->RingBufferGpadlHandle);
+					 &newchannel->ringbuffer_gpadlhandle);
 
 	if (ret != 0) {
 		err = ret;
@@ -225,12 +225,12 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	DPRINT_DBG(VMBUS, "channel %p <relid %d gpadl 0x%x send ring %p "
 		   "size %d recv ring %p size %d, downstreamoffset %d>",
-		   newchannel, newchannel->OfferMsg.ChildRelId,
-		   newchannel->RingBufferGpadlHandle,
-		   newchannel->Outbound.RingBuffer,
-		   newchannel->Outbound.RingSize,
-		   newchannel->Inbound.RingBuffer,
-		   newchannel->Inbound.RingSize,
+		   newchannel, newchannel->offermsg.child_relid,
+		   newchannel->ringbuffer_gpadlhandle,
+		   newchannel->outbound.RingBuffer,
+		   newchannel->outbound.RingSize,
+		   newchannel->inbound.RingBuffer,
+		   newchannel->inbound.RingSize,
 		   send_ringbuffer_size);
 
 	/* Create and init the channel open message */
@@ -242,20 +242,20 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		goto errorout;
 	}
 
-	openInfo->WaitEvent = osd_WaitEventCreate();
-	if (!openInfo->WaitEvent) {
+	openInfo->waitevent = osd_WaitEventCreate();
+	if (!openInfo->waitevent) {
 		err = -ENOMEM;
 		goto errorout;
 	}
 
-	openMsg = (struct vmbus_channel_open_channel *)openInfo->Msg;
-	openMsg->Header.MessageType = ChannelMessageOpenChannel;
-	openMsg->OpenId = newchannel->OfferMsg.ChildRelId; /* FIXME */
-	openMsg->ChildRelId = newchannel->OfferMsg.ChildRelId;
-	openMsg->RingBufferGpadlHandle = newchannel->RingBufferGpadlHandle;
-	openMsg->DownstreamRingBufferPageOffset = send_ringbuffer_size >>
+	openMsg = (struct vmbus_channel_open_channel *)openInfo->msg;
+	openMsg->header.msgtype = CHANNELMSG_OPENCHANNEL;
+	openMsg->openid = newchannel->offermsg.child_relid; /* FIXME */
+	openMsg->child_relid = newchannel->offermsg.child_relid;
+	openMsg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
+	openMsg->downstream_ringbuffer_pageoffset = send_ringbuffer_size >>
 						  PAGE_SHIFT;
-	openMsg->ServerContextAreaGpadlHandle = 0; /* TODO */
+	openMsg->server_contextarea_gpadlhandle = 0; /* TODO */
 
 	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
@@ -263,10 +263,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	}
 
 	if (userdatalen)
-		memcpy(openMsg->UserData, userdata, userdatalen);
+		memcpy(openMsg->userdata, userdata, userdatalen);
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_add_tail(&openInfo->MsgListEntry,
+	list_add_tail(&openInfo->msglistentry,
 		      &gVmbusConnection.ChannelMsgList);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
@@ -280,26 +280,26 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	}
 
 	/* FIXME: Need to time-out here */
-	osd_WaitEventWait(openInfo->WaitEvent);
+	osd_WaitEventWait(openInfo->waitevent);
 
-	if (openInfo->Response.OpenResult.Status == 0)
+	if (openInfo->response.open_result.status == 0)
 		DPRINT_INFO(VMBUS, "channel <%p> open success!!", newchannel);
 	else
 		DPRINT_INFO(VMBUS, "channel <%p> open failed - %d!!",
-			    newchannel, openInfo->Response.OpenResult.Status);
+			    newchannel, openInfo->response.open_result.status);
 
 Cleanup:
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_del(&openInfo->MsgListEntry);
+	list_del(&openInfo->msglistentry);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
-	kfree(openInfo->WaitEvent);
+	kfree(openInfo->waitevent);
 	kfree(openInfo);
 	return 0;
 
 errorout:
-	RingBufferCleanup(&newchannel->Outbound);
-	RingBufferCleanup(&newchannel->Inbound);
+	RingBufferCleanup(&newchannel->outbound);
+	RingBufferCleanup(&newchannel->inbound);
 	osd_PageFree(out, (send_ringbuffer_size + recv_ringbuffer_size)
 		     >> PAGE_SHIFT);
 	kfree(openInfo);
@@ -322,7 +322,7 @@ static void dump_gpadl_body(struct vmbus_channel_gpadl_body *gpadl, u32 len)
 
 	for (i = 0; i < pfncount; i++)
 		DPRINT_DBG(VMBUS, "gpadl body  - %d) pfn %llu",
-			   i, gpadl->Pfn[i]);
+			   i, gpadl->pfn[i]);
 }
 
 /*
@@ -336,18 +336,18 @@ static void dump_gpadl_header(struct vmbus_channel_gpadl_header *gpadl)
 
 	DPRINT_DBG(VMBUS,
 		   "gpadl header - relid %d, range count %d, range buflen %d",
-		   gpadl->ChildRelId, gpadl->RangeCount, gpadl->RangeBufLen);
-	for (i = 0; i < gpadl->RangeCount; i++) {
-		pagecount = gpadl->Range[i].ByteCount >> PAGE_SHIFT;
+		   gpadl->child_relid, gpadl->rangecount, gpadl->range_buflen);
+	for (i = 0; i < gpadl->rangecount; i++) {
+		pagecount = gpadl->range[i].ByteCount >> PAGE_SHIFT;
 		pagecount = (pagecount > 26) ? 26 : pagecount;
 
 		DPRINT_DBG(VMBUS, "gpadl range %d - len %d offset %d "
-			   "page count %d", i, gpadl->Range[i].ByteCount,
-			   gpadl->Range[i].ByteOffset, pagecount);
+			   "page count %d", i, gpadl->range[i].ByteCount,
+			   gpadl->range[i].ByteOffset, pagecount);
 
 		for (j = 0; j < pagecount; j++)
 			DPRINT_DBG(VMBUS, "%d) pfn %llu", j,
-				   gpadl->Range[i].PfnArray[j]);
+				   gpadl->range[i].PfnArray[j]);
 	}
 }
 
@@ -391,18 +391,18 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		if (!msgheader)
 			goto nomem;
 
-		INIT_LIST_HEAD(&msgheader->SubMsgList);
-		msgheader->MessageSize = msgsize;
+		INIT_LIST_HEAD(&msgheader->submsglist);
+		msgheader->msgsize = msgsize;
 
 		gpadl_header = (struct vmbus_channel_gpadl_header *)
-			msgheader->Msg;
-		gpadl_header->RangeCount = 1;
-		gpadl_header->RangeBufLen = sizeof(struct gpa_range) +
+			msgheader->msg;
+		gpadl_header->rangecount = 1;
+		gpadl_header->range_buflen = sizeof(struct gpa_range) +
 					 pagecount * sizeof(u64);
-		gpadl_header->Range[0].ByteOffset = 0;
-		gpadl_header->Range[0].ByteCount = size;
+		gpadl_header->range[0].ByteOffset = 0;
+		gpadl_header->range[0].ByteCount = size;
 		for (i = 0; i < pfncount; i++)
-			gpadl_header->Range[0].PfnArray[i] = pfn+i;
+			gpadl_header->range[0].PfnArray[i] = pfn+i;
 		*msginfo = msgheader;
 		*messagecount = 1;
 
@@ -428,10 +428,10 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 			/* FIXME: we probably need to more if this fails */
 			if (!msgbody)
 				goto nomem;
-			msgbody->MessageSize = msgsize;
+			msgbody->msgsize = msgsize;
 			(*messagecount)++;
 			gpadl_body =
-				(struct vmbus_channel_gpadl_body *)msgbody->Msg;
+				(struct vmbus_channel_gpadl_body *)msgbody->msg;
 
 			/*
 			 * FIXME:
@@ -440,11 +440,11 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 			 */
 			/* gpadl_body->Gpadl = kbuffer; */
 			for (i = 0; i < pfncurr; i++)
-				gpadl_body->Pfn[i] = pfn + pfnsum + i;
+				gpadl_body->pfn[i] = pfn + pfnsum + i;
 
 			/* add to msg header */
-			list_add_tail(&msgbody->MsgListEntry,
-				      &msgheader->SubMsgList);
+			list_add_tail(&msgbody->msglistentry,
+				      &msgheader->submsglist);
 			pfnsum += pfncurr;
 			pfnleft -= pfncurr;
 		}
@@ -456,17 +456,17 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		msgheader = kzalloc(msgsize, GFP_KERNEL);
 		if (msgheader == NULL)
 			goto nomem;
-		msgheader->MessageSize = msgsize;
+		msgheader->msgsize = msgsize;
 
 		gpadl_header = (struct vmbus_channel_gpadl_header *)
-			msgheader->Msg;
-		gpadl_header->RangeCount = 1;
-		gpadl_header->RangeBufLen = sizeof(struct gpa_range) +
+			msgheader->msg;
+		gpadl_header->rangecount = 1;
+		gpadl_header->range_buflen = sizeof(struct gpa_range) +
 					 pagecount * sizeof(u64);
-		gpadl_header->Range[0].ByteOffset = 0;
-		gpadl_header->Range[0].ByteCount = size;
+		gpadl_header->range[0].ByteOffset = 0;
+		gpadl_header->range[0].ByteCount = size;
 		for (i = 0; i < pagecount; i++)
-			gpadl_header->Range[0].PfnArray[i] = pfn+i;
+			gpadl_header->range[0].PfnArray[i] = pfn+i;
 
 		*msginfo = msgheader;
 		*messagecount = 1;
@@ -508,21 +508,21 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	if (ret)
 		return ret;
 
-	msginfo->WaitEvent = osd_WaitEventCreate();
-	if (!msginfo->WaitEvent) {
+	msginfo->waitevent = osd_WaitEventCreate();
+	if (!msginfo->waitevent) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
-	gpadlmsg = (struct vmbus_channel_gpadl_header *)msginfo->Msg;
-	gpadlmsg->Header.MessageType = ChannelMessageGpadlHeader;
-	gpadlmsg->ChildRelId = channel->OfferMsg.ChildRelId;
-	gpadlmsg->Gpadl = next_gpadl_handle;
+	gpadlmsg = (struct vmbus_channel_gpadl_header *)msginfo->msg;
+	gpadlmsg->header.msgtype = CHANNELMSG_GPADL_HEADER;
+	gpadlmsg->child_relid = channel->offermsg.child_relid;
+	gpadlmsg->gpadl = next_gpadl_handle;
 
 	dump_gpadl_header(gpadlmsg);
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_add_tail(&msginfo->MsgListEntry,
+	list_add_tail(&msginfo->msglistentry,
 		      &gVmbusConnection.ChannelMsgList);
 
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
@@ -530,9 +530,9 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 		   kbuffer, size, msgcount);
 
 	DPRINT_DBG(VMBUS, "Sending GPADL Header - len %zd",
-		   msginfo->MessageSize - sizeof(*msginfo));
+		   msginfo->msgsize - sizeof(*msginfo));
 
-	ret = VmbusPostMessage(gpadlmsg, msginfo->MessageSize -
+	ret = VmbusPostMessage(gpadlmsg, msginfo->msgsize -
 			       sizeof(*msginfo));
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS, "Unable to open channel - %d", ret);
@@ -540,48 +540,48 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	}
 
 	if (msgcount > 1) {
-		list_for_each(curr, &msginfo->SubMsgList) {
+		list_for_each(curr, &msginfo->submsglist) {
 
 			/* FIXME: should this use list_entry() instead ? */
 			submsginfo = (struct vmbus_channel_msginfo *)curr;
 			gpadl_body =
-			     (struct vmbus_channel_gpadl_body *)submsginfo->Msg;
+			     (struct vmbus_channel_gpadl_body *)submsginfo->msg;
 
-			gpadl_body->Header.MessageType =
-				ChannelMessageGpadlBody;
-			gpadl_body->Gpadl = next_gpadl_handle;
+			gpadl_body->header.msgtype =
+				CHANNELMSG_GPADL_BODY;
+			gpadl_body->gpadl = next_gpadl_handle;
 
 			DPRINT_DBG(VMBUS, "Sending GPADL Body - len %zd",
-				   submsginfo->MessageSize -
+				   submsginfo->msgsize -
 				   sizeof(*submsginfo));
 
-			dump_gpadl_body(gpadl_body, submsginfo->MessageSize -
+			dump_gpadl_body(gpadl_body, submsginfo->msgsize -
 				      sizeof(*submsginfo));
 			ret = VmbusPostMessage(gpadl_body,
-					       submsginfo->MessageSize -
+					       submsginfo->msgsize -
 					       sizeof(*submsginfo));
 			if (ret != 0)
 				goto Cleanup;
 
 		}
 	}
-	osd_WaitEventWait(msginfo->WaitEvent);
+	osd_WaitEventWait(msginfo->waitevent);
 
 	/* At this point, we received the gpadl created msg */
 	DPRINT_DBG(VMBUS, "Received GPADL created "
 		   "(relid %d, status %d handle %x)",
-		   channel->OfferMsg.ChildRelId,
-		   msginfo->Response.GpadlCreated.CreationStatus,
-		   gpadlmsg->Gpadl);
+		   channel->offermsg.child_relid,
+		   msginfo->response.gpadl_created.creation_status,
+		   gpadlmsg->gpadl);
 
-	*gpadl_handle = gpadlmsg->Gpadl;
+	*gpadl_handle = gpadlmsg->gpadl;
 
 Cleanup:
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_del(&msginfo->MsgListEntry);
+	list_del(&msginfo->msglistentry);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
-	kfree(msginfo->WaitEvent);
+	kfree(msginfo->waitevent);
 	kfree(msginfo);
 	return ret;
 }
@@ -604,20 +604,20 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	if (!info)
 		return -ENOMEM;
 
-	info->WaitEvent = osd_WaitEventCreate();
-	if (!info->WaitEvent) {
+	info->waitevent = osd_WaitEventCreate();
+	if (!info->waitevent) {
 		kfree(info);
 		return -ENOMEM;
 	}
 
-	msg = (struct vmbus_channel_gpadl_teardown *)info->Msg;
+	msg = (struct vmbus_channel_gpadl_teardown *)info->msg;
 
-	msg->Header.MessageType = ChannelMessageGpadlTeardown;
-	msg->ChildRelId = channel->OfferMsg.ChildRelId;
-	msg->Gpadl = gpadl_handle;
+	msg->header.msgtype = CHANNELMSG_GPADL_TEARDOWN;
+	msg->child_relid = channel->offermsg.child_relid;
+	msg->gpadl = gpadl_handle;
 
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_add_tail(&info->MsgListEntry,
+	list_add_tail(&info->msglistentry,
 		      &gVmbusConnection.ChannelMsgList);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
@@ -628,14 +628,14 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 		/* something... */
 	}
 
-	osd_WaitEventWait(info->WaitEvent);
+	osd_WaitEventWait(info->waitevent);
 
 	/* Received a torndown response */
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_del(&info->MsgListEntry);
+	list_del(&info->msglistentry);
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
-	kfree(info->WaitEvent);
+	kfree(info->waitevent);
 	kfree(info);
 	return ret;
 }
@@ -652,7 +652,7 @@ void vmbus_close(struct vmbus_channel *channel)
 	int ret;
 
 	/* Stop callback and cancel the timer asap */
-	channel->OnChannelCallback = NULL;
+	channel->onchannel_callback = NULL;
 	del_timer_sync(&channel->poll_timer);
 
 	/* Send a closing message */
@@ -665,9 +665,9 @@ void vmbus_close(struct vmbus_channel *channel)
 
 	/* info->waitEvent = osd_WaitEventCreate(); */
 
-	msg = (struct vmbus_channel_close_channel *)info->Msg;
-	msg->Header.MessageType = ChannelMessageCloseChannel;
-	msg->ChildRelId = channel->OfferMsg.ChildRelId;
+	msg = (struct vmbus_channel_close_channel *)info->msg;
+	msg->header.msgtype = CHANNELMSG_CLOSECHANNEL;
+	msg->child_relid = channel->offermsg.child_relid;
 
 	ret = VmbusPostMessage(msg, sizeof(struct vmbus_channel_close_channel));
 	if (ret != 0) {
@@ -676,17 +676,17 @@ void vmbus_close(struct vmbus_channel *channel)
 	}
 
 	/* Tear down the gpadl for the channel's ring buffer */
-	if (channel->RingBufferGpadlHandle)
+	if (channel->ringbuffer_gpadlhandle)
 		vmbus_teardown_gpadl(channel,
-					  channel->RingBufferGpadlHandle);
+					  channel->ringbuffer_gpadlhandle);
 
 	/* TODO: Send a msg to release the childRelId */
 
 	/* Cleanup the ring buffers for this channel */
-	RingBufferCleanup(&channel->Outbound);
-	RingBufferCleanup(&channel->Inbound);
+	RingBufferCleanup(&channel->outbound);
+	RingBufferCleanup(&channel->inbound);
 
-	osd_PageFree(channel->RingBufferPages, channel->RingBufferPageCount);
+	osd_PageFree(channel->ringbuffer_pages, channel->ringbuffer_pagecount);
 
 	kfree(info);
 
@@ -696,9 +696,9 @@ void vmbus_close(struct vmbus_channel *channel)
 	 * caller will free the channel
 	 */
 
-	if (channel->State == CHANNEL_OPEN_STATE) {
+	if (channel->state == CHANNEL_OPEN_STATE) {
 		spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
-		list_del(&channel->ListEntry);
+		list_del(&channel->listentry);
 		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
 		free_channel(channel);
@@ -752,10 +752,10 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		   packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
+	ret = RingBufferWrite(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -817,10 +817,10 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
+	ret = RingBufferWrite(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -886,10 +886,10 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&channel->Outbound, bufferlist, 3);
+	ret = RingBufferWrite(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&channel->Outbound))
+	if (ret == 0 && !GetRingBufferInterruptMask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -923,7 +923,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 
 	spin_lock_irqsave(&channel->inbound_lock, flags);
 
-	ret = RingBufferPeek(&channel->Inbound, &desc,
+	ret = RingBufferPeek(&channel->inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
@@ -940,7 +940,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 
 	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
 		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->OfferMsg.ChildRelId, desc.Type,
+		   channel, channel->offermsg.child_relid, desc.Type,
 		   desc.Flags, desc.TransactionId, packetlen, userlen);
 
 	*buffer_actual_len = userlen;
@@ -956,7 +956,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	*requestid = desc.TransactionId;
 
 	/* Copy over the packet to the user buffer */
-	ret = RingBufferRead(&channel->Inbound, buffer, userlen,
+	ret = RingBufferRead(&channel->inbound, buffer, userlen,
 			     (desc.DataOffset8 << 3));
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
@@ -983,7 +983,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 
 	spin_lock_irqsave(&channel->inbound_lock, flags);
 
-	ret = RingBufferPeek(&channel->Inbound, &desc,
+	ret = RingBufferPeek(&channel->inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
@@ -999,7 +999,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 
 	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
 		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->OfferMsg.ChildRelId, desc.Type,
+		   channel, channel->offermsg.child_relid, desc.Type,
 		   desc.Flags, desc.TransactionId, packetlen, userlen);
 
 	*buffer_actual_len = packetlen;
@@ -1015,7 +1015,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	*requestid = desc.TransactionId;
 
 	/* Copy over the entire packet to the user buffer */
-	ret = RingBufferRead(&channel->Inbound, buffer, packetlen, 0);
+	ret = RingBufferRead(&channel->inbound, buffer, packetlen, 0);
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 	return 0;
@@ -1030,7 +1030,7 @@ void vmbus_onchannel_event(struct vmbus_channel *channel)
 	dump_vmbus_channel(channel);
 	/* ASSERT(Channel->OnChannelCallback); */
 
-	channel->OnChannelCallback(channel->ChannelCallbackContext);
+	channel->onchannel_callback(channel->channel_callback_context);
 
 	mod_timer(&channel->poll_timer, jiffies + usecs_to_jiffies(100));
 }
@@ -1042,8 +1042,8 @@ void vmbus_ontimer(unsigned long data)
 {
 	struct vmbus_channel *channel = (struct vmbus_channel *)data;
 
-	if (channel->OnChannelCallback)
-		channel->OnChannelCallback(channel->ChannelCallbackContext);
+	if (channel->onchannel_callback)
+		channel->onchannel_callback(channel->channel_callback_context);
 }
 
 /*
@@ -1051,7 +1051,7 @@ void vmbus_ontimer(unsigned long data)
  */
 static void dump_vmbus_channel(struct vmbus_channel *channel)
 {
-	DPRINT_DBG(VMBUS, "Channel (%d)", channel->OfferMsg.ChildRelId);
-	DumpRingInfo(&channel->Outbound, "Outbound ");
-	DumpRingInfo(&channel->Inbound, "Inbound ");
+	DPRINT_DBG(VMBUS, "Channel (%d)", channel->offermsg.child_relid);
+	DumpRingInfo(&channel->outbound, "Outbound ");
+	DumpRingInfo(&channel->inbound, "Inbound ");
 }
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 45dbe30..dbfe0f2 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -251,8 +251,8 @@ static struct vmbus_channel *alloc_channel(void)
 	channel->poll_timer.data = (unsigned long)channel;
 	channel->poll_timer.function = vmbus_ontimer;
 
-	channel->ControlWQ = create_workqueue("hv_vmbus_ctl");
-	if (!channel->ControlWQ) {
+	channel->controlwq = create_workqueue("hv_vmbus_ctl");
+	if (!channel->controlwq) {
 		kfree(channel);
 		return NULL;
 	}
@@ -268,7 +268,7 @@ static inline void release_channel(void *context)
 	struct vmbus_channel *channel = context;
 
 	DPRINT_DBG(VMBUS, "releasing channel (%p)", channel);
-	destroy_workqueue(channel->ControlWQ);
+	destroy_workqueue(channel->controlwq);
 	DPRINT_DBG(VMBUS, "channel released (%p)", channel);
 
 	kfree(channel);
@@ -325,12 +325,12 @@ static void vmbus_process_offer(void *context)
 	/* Make sure this is a new offer */
 	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
 
-	list_for_each_entry(channel, &gVmbusConnection.ChannelList, ListEntry) {
-		if (!memcmp(&channel->OfferMsg.Offer.InterfaceType,
-			    &newchannel->OfferMsg.Offer.InterfaceType,
+	list_for_each_entry(channel, &gVmbusConnection.ChannelList, listentry) {
+		if (!memcmp(&channel->offermsg.offer.InterfaceType,
+			    &newchannel->offermsg.offer.InterfaceType,
 			    sizeof(struct hv_guid)) &&
-		    !memcmp(&channel->OfferMsg.Offer.InterfaceInstance,
-			    &newchannel->OfferMsg.Offer.InterfaceInstance,
+		    !memcmp(&channel->offermsg.offer.InterfaceInstance,
+			    &newchannel->offermsg.offer.InterfaceInstance,
 			    sizeof(struct hv_guid))) {
 			fnew = false;
 			break;
@@ -338,14 +338,14 @@ static void vmbus_process_offer(void *context)
 	}
 
 	if (fnew)
-		list_add_tail(&newchannel->ListEntry,
+		list_add_tail(&newchannel->listentry,
 			      &gVmbusConnection.ChannelList);
 
 	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
 	if (!fnew) {
 		DPRINT_DBG(VMBUS, "Ignoring duplicate offer for relid (%d)",
-			   newchannel->OfferMsg.ChildRelId);
+			   newchannel->offermsg.child_relid);
 		free_channel(newchannel);
 		return;
 	}
@@ -355,27 +355,27 @@ static void vmbus_process_offer(void *context)
 	 * We need to set the DeviceObject field before calling
 	 * VmbusChildDeviceAdd()
 	 */
-	newchannel->DeviceObject = VmbusChildDeviceCreate(
-		&newchannel->OfferMsg.Offer.InterfaceType,
-		&newchannel->OfferMsg.Offer.InterfaceInstance,
+	newchannel->device_obj = VmbusChildDeviceCreate(
+		&newchannel->offermsg.offer.InterfaceType,
+		&newchannel->offermsg.offer.InterfaceInstance,
 		newchannel);
 
 	DPRINT_DBG(VMBUS, "child device object allocated - %p",
-		   newchannel->DeviceObject);
+		   newchannel->device_obj);
 
 	/*
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
 	 * method.
 	 */
-	ret = VmbusChildDeviceAdd(newchannel->DeviceObject);
+	ret = VmbusChildDeviceAdd(newchannel->device_obj);
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS,
 			   "unable to add child device object (relid %d)",
-			   newchannel->OfferMsg.ChildRelId);
+			   newchannel->offermsg.child_relid);
 
 		spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
-		list_del(&newchannel->ListEntry);
+		list_del(&newchannel->listentry);
 		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
 		free_channel(newchannel);
@@ -385,11 +385,11 @@ static void vmbus_process_offer(void *context)
 		 * so that when we do close the channel normally, we
 		 * can cleanup properly
 		 */
-		newchannel->State = CHANNEL_OPEN_STATE;
+		newchannel->state = CHANNEL_OPEN_STATE;
 
 		/* Open IC channels */
 		for (cnt = 0; cnt < MAX_MSG_TYPES; cnt++) {
-			if (memcmp(&newchannel->OfferMsg.Offer.InterfaceType,
+			if (memcmp(&newchannel->offermsg.offer.InterfaceType,
 				   &hv_cb_utils[cnt].data,
 				   sizeof(struct hv_guid)) == 0 &&
 				vmbus_open(newchannel, 2 * PAGE_SIZE,
@@ -413,7 +413,7 @@ static void vmbus_process_rescind_offer(void *context)
 {
 	struct vmbus_channel *channel = context;
 
-	VmbusChildDeviceRemove(channel->DeviceObject);
+	VmbusChildDeviceRemove(channel->device_obj);
 }
 
 /*
@@ -434,7 +434,7 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 
 	offer = (struct vmbus_channel_offer_channel *)hdr;
 	for (i = 0; i < MAX_NUM_DEVICE_CLASSES_SUPPORTED; i++) {
-		if (memcmp(&offer->Offer.InterfaceType,
+		if (memcmp(&offer->offer.InterfaceType,
 		    &gSupportedDeviceClasses[i], sizeof(struct hv_guid)) == 0) {
 			fsupported = 1;
 			break;
@@ -443,12 +443,12 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 
 	if (!fsupported) {
 		DPRINT_DBG(VMBUS, "Ignoring channel offer notification for "
-			   "child relid %d", offer->ChildRelId);
+			   "child relid %d", offer->child_relid);
 		return;
 	}
 
-	guidtype = &offer->Offer.InterfaceType;
-	guidinstance = &offer->Offer.InterfaceInstance;
+	guidtype = &offer->offer.InterfaceType;
+	guidinstance = &offer->offer.InterfaceInstance;
 
 	DPRINT_INFO(VMBUS, "Channel offer notification - "
 		    "child relid %d monitor id %d allocated %d, "
@@ -456,8 +456,8 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 		    "%02x%02x%02x%02x%02x%02x%02x%02x} "
 		    "instance {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
-		    offer->ChildRelId, offer->MonitorId,
-		    offer->MonitorAllocated,
+		    offer->child_relid, offer->monitorid,
+		    offer->monitor_allocated,
 		    guidtype->data[3], guidtype->data[2],
 		    guidtype->data[1], guidtype->data[0],
 		    guidtype->data[5], guidtype->data[4],
@@ -484,13 +484,13 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 
 	DPRINT_DBG(VMBUS, "channel object allocated - %p", newchannel);
 
-	memcpy(&newchannel->OfferMsg, offer,
+	memcpy(&newchannel->offermsg, offer,
 	       sizeof(struct vmbus_channel_offer_channel));
-	newchannel->MonitorGroup = (u8)offer->MonitorId / 32;
-	newchannel->MonitorBit = (u8)offer->MonitorId % 32;
+	newchannel->monitor_grp = (u8)offer->monitorid / 32;
+	newchannel->monitor_bit = (u8)offer->monitorid % 32;
 
 	/* TODO: Make sure the offer comes from our parent partition */
-	osd_schedule_callback(newchannel->ControlWQ, vmbus_process_offer,
+	osd_schedule_callback(newchannel->controlwq, vmbus_process_offer,
 			      newchannel);
 }
 
@@ -505,14 +505,14 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 	struct vmbus_channel *channel;
 
 	rescind = (struct vmbus_channel_rescind_offer *)hdr;
-	channel = GetChannelFromRelId(rescind->ChildRelId);
+	channel = GetChannelFromRelId(rescind->child_relid);
 	if (channel == NULL) {
 		DPRINT_DBG(VMBUS, "channel not found for relId %d",
-			   rescind->ChildRelId);
+			   rescind->child_relid);
 		return;
 	}
 
-	osd_schedule_callback(channel->ControlWQ,
+	osd_schedule_callback(channel->controlwq,
 			      vmbus_process_rescind_offer,
 			      channel);
 }
@@ -545,7 +545,7 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 	unsigned long flags;
 
 	result = (struct vmbus_channel_open_result *)hdr;
-	DPRINT_DBG(VMBUS, "vmbus open result - %d", result->Status);
+	DPRINT_DBG(VMBUS, "vmbus open result - %d", result->status);
 
 	/*
 	 * Find the open msg, copy the result and signal/unblock the wait event
@@ -556,17 +556,17 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
-			(struct vmbus_channel_message_header *)msginfo->Msg;
+			(struct vmbus_channel_message_header *)msginfo->msg;
 
-		if (requestheader->MessageType == ChannelMessageOpenChannel) {
+		if (requestheader->msgtype == CHANNELMSG_OPENCHANNEL) {
 			openmsg =
-			(struct vmbus_channel_open_channel *)msginfo->Msg;
-			if (openmsg->ChildRelId == result->ChildRelId &&
-			    openmsg->OpenId == result->OpenId) {
-				memcpy(&msginfo->Response.OpenResult,
+			(struct vmbus_channel_open_channel *)msginfo->msg;
+			if (openmsg->child_relid == result->child_relid &&
+			    openmsg->openid == result->openid) {
+				memcpy(&msginfo->response.open_result,
 				       result,
 				       sizeof(struct vmbus_channel_open_result));
-				osd_WaitEventSet(msginfo->WaitEvent);
+				osd_WaitEventSet(msginfo->waitevent);
 				break;
 			}
 		}
@@ -592,7 +592,7 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 
 	gpadlcreated = (struct vmbus_channel_gpadl_created *)hdr;
 	DPRINT_DBG(VMBUS, "vmbus gpadl created result - %d",
-		   gpadlcreated->CreationStatus);
+		   gpadlcreated->creation_status);
 
 	/*
 	 * Find the establish msg, copy the result and signal/unblock the wait
@@ -604,19 +604,19 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
-			(struct vmbus_channel_message_header *)msginfo->Msg;
+			(struct vmbus_channel_message_header *)msginfo->msg;
 
-		if (requestheader->MessageType == ChannelMessageGpadlHeader) {
+		if (requestheader->msgtype == CHANNELMSG_GPADL_HEADER) {
 			gpadlheader =
 			(struct vmbus_channel_gpadl_header *)requestheader;
 
-			if ((gpadlcreated->ChildRelId ==
-			     gpadlheader->ChildRelId) &&
-			    (gpadlcreated->Gpadl == gpadlheader->Gpadl)) {
-				memcpy(&msginfo->Response.GpadlCreated,
+			if ((gpadlcreated->child_relid ==
+			     gpadlheader->child_relid) &&
+			    (gpadlcreated->gpadl == gpadlheader->gpadl)) {
+				memcpy(&msginfo->response.gpadl_created,
 				       gpadlcreated,
 				       sizeof(struct vmbus_channel_gpadl_created));
-				osd_WaitEventSet(msginfo->WaitEvent);
+				osd_WaitEventSet(msginfo->waitevent);
 				break;
 			}
 		}
@@ -652,17 +652,17 @@ static void vmbus_ongpadl_torndown(
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
-			(struct vmbus_channel_message_header *)msginfo->Msg;
+			(struct vmbus_channel_message_header *)msginfo->msg;
 
-		if (requestheader->MessageType == ChannelMessageGpadlTeardown) {
+		if (requestheader->msgtype == CHANNELMSG_GPADL_TEARDOWN) {
 			gpadl_teardown =
 			(struct vmbus_channel_gpadl_teardown *)requestheader;
 
-			if (gpadl_torndown->Gpadl == gpadl_teardown->Gpadl) {
-				memcpy(&msginfo->Response.GpadlTorndown,
+			if (gpadl_torndown->gpadl == gpadl_teardown->gpadl) {
+				memcpy(&msginfo->response.gpadl_torndown,
 				       gpadl_torndown,
 				       sizeof(struct vmbus_channel_gpadl_torndown));
-				osd_WaitEventSet(msginfo->WaitEvent);
+				osd_WaitEventSet(msginfo->waitevent);
 				break;
 			}
 		}
@@ -694,16 +694,16 @@ static void vmbus_onversion_response(
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
-			(struct vmbus_channel_message_header *)msginfo->Msg;
+			(struct vmbus_channel_message_header *)msginfo->msg;
 
-		if (requestheader->MessageType ==
-		    ChannelMessageInitiateContact) {
+		if (requestheader->msgtype ==
+		    CHANNELMSG_INITIATE_CONTACT) {
 			initiate =
 			(struct vmbus_channel_initiate_contact *)requestheader;
-			memcpy(&msginfo->Response.VersionResponse,
+			memcpy(&msginfo->response.version_response,
 			      version_response,
 			      sizeof(struct vmbus_channel_version_response));
-			osd_WaitEventSet(msginfo->WaitEvent);
+			osd_WaitEventSet(msginfo->waitevent);
 		}
 	}
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
@@ -711,24 +711,24 @@ static void vmbus_onversion_response(
 
 /* Channel message dispatch table */
 static struct vmbus_channel_message_table_entry
-	gChannelMessageTable[ChannelMessageCount] = {
-	{ChannelMessageInvalid,			NULL},
-	{ChannelMessageOfferChannel,		vmbus_onoffer},
-	{ChannelMessageRescindChannelOffer,	vmbus_onoffer_rescind},
-	{ChannelMessageRequestOffers,		NULL},
-	{ChannelMessageAllOffersDelivered,	vmbus_onoffers_delivered},
-	{ChannelMessageOpenChannel,		NULL},
-	{ChannelMessageOpenChannelResult,	vmbus_onopen_result},
-	{ChannelMessageCloseChannel,		NULL},
-	{ChannelMessageGpadlHeader,		NULL},
-	{ChannelMessageGpadlBody,		NULL},
-	{ChannelMessageGpadlCreated,		vmbus_ongpadl_created},
-	{ChannelMessageGpadlTeardown,		NULL},
-	{ChannelMessageGpadlTorndown,		vmbus_ongpadl_torndown},
-	{ChannelMessageRelIdReleased,		NULL},
-	{ChannelMessageInitiateContact,		NULL},
-	{ChannelMessageVersionResponse,		vmbus_onversion_response},
-	{ChannelMessageUnload,			NULL},
+	gChannelMessageTable[CHANNELMSG_COUNT] = {
+	{CHANNELMSG_INVALID,			NULL},
+	{CHANNELMSG_OFFERCHANNEL,		vmbus_onoffer},
+	{CHANNELMSG_RESCIND_CHANNELOFFER,	vmbus_onoffer_rescind},
+	{CHANNELMSG_REQUESTOFFERS,		NULL},
+	{CHANNELMSG_ALLOFFERS_DELIVERED,	vmbus_onoffers_delivered},
+	{CHANNELMSG_OPENCHANNEL,		NULL},
+	{CHANNELMSG_OPENCHANNEL_RESULT,	vmbus_onopen_result},
+	{CHANNELMSG_CLOSECHANNEL,		NULL},
+	{CHANNELMSG_GPADL_HEADER,		NULL},
+	{CHANNELMSG_GPADL_BODY,		NULL},
+	{CHANNELMSG_GPADL_CREATED,		vmbus_ongpadl_created},
+	{CHANNELMSG_GPADL_TEARDOWN,		NULL},
+	{CHANNELMSG_GPADL_TORNDOWN,		vmbus_ongpadl_torndown},
+	{CHANNELMSG_RELID_RELEASED,		NULL},
+	{CHANNELMSG_INITIATE_CONTACT,		NULL},
+	{CHANNELMSG_VERSION_RESPONSE,		vmbus_onversion_response},
+	{CHANNELMSG_UNLOAD,			NULL},
 };
 
 /*
@@ -745,23 +745,23 @@ void vmbus_onmessage(void *context)
 	hdr = (struct vmbus_channel_message_header *)msg->u.Payload;
 	size = msg->Header.PayloadSize;
 
-	DPRINT_DBG(VMBUS, "message type %d size %d", hdr->MessageType, size);
+	DPRINT_DBG(VMBUS, "message type %d size %d", hdr->msgtype, size);
 
-	if (hdr->MessageType >= ChannelMessageCount) {
+	if (hdr->msgtype >= CHANNELMSG_COUNT) {
 		DPRINT_ERR(VMBUS,
 			   "Received invalid channel message type %d size %d",
-			   hdr->MessageType, size);
+			   hdr->msgtype, size);
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE,
 				     (unsigned char *)msg->u.Payload, size);
 		kfree(msg);
 		return;
 	}
 
-	if (gChannelMessageTable[hdr->MessageType].messageHandler)
-		gChannelMessageTable[hdr->MessageType].messageHandler(hdr);
+	if (gChannelMessageTable[hdr->msgtype].messageHandler)
+		gChannelMessageTable[hdr->msgtype].messageHandler(hdr);
 	else
 		DPRINT_ERR(VMBUS, "Unhandled channel message type %d",
-			   hdr->MessageType);
+			   hdr->msgtype);
 
 	/* Free the msg that was allocated in VmbusOnMsgDPC() */
 	kfree(msg);
@@ -782,15 +782,15 @@ int vmbus_request_offers(void)
 	if (!msginfo)
 		return -ENOMEM;
 
-	msginfo->WaitEvent = osd_WaitEventCreate();
-	if (!msginfo->WaitEvent) {
+	msginfo->waitevent = osd_WaitEventCreate();
+	if (!msginfo->waitevent) {
 		kfree(msginfo);
 		return -ENOMEM;
 	}
 
-	msg = (struct vmbus_channel_message_header *)msginfo->Msg;
+	msg = (struct vmbus_channel_message_header *)msginfo->msg;
 
-	msg->MessageType = ChannelMessageRequestOffers;
+	msg->msgtype = CHANNELMSG_REQUESTOFFERS;
 
 	/*SpinlockAcquire(gVmbusConnection.channelMsgLock);
 	INSERT_TAIL_LIST(&gVmbusConnection.channelMsgList,
@@ -817,7 +817,7 @@ int vmbus_request_offers(void)
 
 Cleanup:
 	if (msginfo) {
-		kfree(msginfo->WaitEvent);
+		kfree(msginfo->waitevent);
 		kfree(msginfo);
 	}
 
@@ -837,17 +837,17 @@ void vmbus_release_unattached_channels(void)
 	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
 
 	list_for_each_entry_safe(channel, pos, &gVmbusConnection.ChannelList,
-				 ListEntry) {
+				 listentry) {
 		if (channel == start)
 			break;
 
-		if (!channel->DeviceObject->Driver) {
-			list_del(&channel->ListEntry);
+		if (!channel->device_obj->Driver) {
+			list_del(&channel->listentry);
 			DPRINT_INFO(VMBUS,
 				    "Releasing unattached device object %p",
-				    channel->DeviceObject);
+				    channel->device_obj);
 
-			VmbusChildDeviceRemove(channel->DeviceObject);
+			VmbusChildDeviceRemove(channel->device_obj);
 			free_channel(channel);
 		} else {
 			if (!start)
diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index d16cc08..12f30af 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -33,60 +33,60 @@
 
 /* Version 1 messages */
 enum vmbus_channel_message_type {
-	ChannelMessageInvalid			=  0,
-	ChannelMessageOfferChannel		=  1,
-	ChannelMessageRescindChannelOffer	=  2,
-	ChannelMessageRequestOffers		=  3,
-	ChannelMessageAllOffersDelivered	=  4,
-	ChannelMessageOpenChannel		=  5,
-	ChannelMessageOpenChannelResult		=  6,
-	ChannelMessageCloseChannel		=  7,
-	ChannelMessageGpadlHeader		=  8,
-	ChannelMessageGpadlBody			=  9,
-	ChannelMessageGpadlCreated		= 10,
-	ChannelMessageGpadlTeardown		= 11,
-	ChannelMessageGpadlTorndown		= 12,
-	ChannelMessageRelIdReleased		= 13,
-	ChannelMessageInitiateContact		= 14,
-	ChannelMessageVersionResponse		= 15,
-	ChannelMessageUnload			= 16,
+	CHANNELMSG_INVALID			=  0,
+	CHANNELMSG_OFFERCHANNEL		=  1,
+	CHANNELMSG_RESCIND_CHANNELOFFER	=  2,
+	CHANNELMSG_REQUESTOFFERS		=  3,
+	CHANNELMSG_ALLOFFERS_DELIVERED	=  4,
+	CHANNELMSG_OPENCHANNEL		=  5,
+	CHANNELMSG_OPENCHANNEL_RESULT		=  6,
+	CHANNELMSG_CLOSECHANNEL		=  7,
+	CHANNELMSG_GPADL_HEADER		=  8,
+	CHANNELMSG_GPADL_BODY			=  9,
+	CHANNELMSG_GPADL_CREATED		= 10,
+	CHANNELMSG_GPADL_TEARDOWN		= 11,
+	CHANNELMSG_GPADL_TORNDOWN		= 12,
+	CHANNELMSG_RELID_RELEASED		= 13,
+	CHANNELMSG_INITIATE_CONTACT		= 14,
+	CHANNELMSG_VERSION_RESPONSE		= 15,
+	CHANNELMSG_UNLOAD			= 16,
 #ifdef VMBUS_FEATURE_PARENT_OR_PEER_MEMORY_MAPPED_INTO_A_CHILD
-	ChannelMessageViewRangeAdd		= 17,
-	ChannelMessageViewRangeRemove		= 18,
+	CHANNELMSG_VIEWRANGE_ADD		= 17,
+	CHANNELMSG_VIEWRANGE_REMOVE		= 18,
 #endif
-	ChannelMessageCount
+	CHANNELMSG_COUNT
 };
 
 struct vmbus_channel_message_header {
-	enum vmbus_channel_message_type MessageType;
-	u32 Padding;
+	enum vmbus_channel_message_type msgtype;
+	u32 padding;
 } __attribute__((packed));
 
 /* Query VMBus Version parameters */
 struct vmbus_channel_query_vmbus_version {
-	struct vmbus_channel_message_header Header;
-	u32 Version;
+	struct vmbus_channel_message_header header;
+	u32 version;
 } __attribute__((packed));
 
 /* VMBus Version Supported parameters */
 struct vmbus_channel_version_supported {
-	struct vmbus_channel_message_header Header;
-	bool VersionSupported;
+	struct vmbus_channel_message_header header;
+	bool version_supported;
 } __attribute__((packed));
 
 /* Offer Channel parameters */
 struct vmbus_channel_offer_channel {
-	struct vmbus_channel_message_header Header;
-	struct vmbus_channel_offer Offer;
-	u32 ChildRelId;
-	u8 MonitorId;
-	bool MonitorAllocated;
+	struct vmbus_channel_message_header header;
+	struct vmbus_channel_offer offer;
+	u32 child_relid;
+	u8 monitorid;
+	bool monitor_allocated;
 } __attribute__((packed));
 
 /* Rescind Offer parameters */
 struct vmbus_channel_rescind_offer {
-	struct vmbus_channel_message_header Header;
-	u32 ChildRelId;
+	struct vmbus_channel_message_header header;
+	u32 child_relid;
 } __attribute__((packed));
 
 /*
@@ -100,43 +100,43 @@ struct vmbus_channel_rescind_offer {
 
 /* Open Channel parameters */
 struct vmbus_channel_open_channel {
-	struct vmbus_channel_message_header Header;
+	struct vmbus_channel_message_header header;
 
 	/* Identifies the specific VMBus channel that is being opened. */
-	u32 ChildRelId;
+	u32 child_relid;
 
 	/* ID making a particular open request at a channel offer unique. */
-	u32 OpenId;
+	u32 openid;
 
 	/* GPADL for the channel's ring buffer. */
-	u32 RingBufferGpadlHandle;
+	u32 ringbuffer_gpadlhandle;
 
 	/* GPADL for the channel's server context save area. */
-	u32 ServerContextAreaGpadlHandle;
+	u32 server_contextarea_gpadlhandle;
 
 	/*
 	* The upstream ring buffer begins at offset zero in the memory
 	* described by RingBufferGpadlHandle. The downstream ring buffer
 	* follows it at this offset (in pages).
 	*/
-	u32 DownstreamRingBufferPageOffset;
+	u32 downstream_ringbuffer_pageoffset;
 
 	/* User-specific data to be passed along to the server endpoint. */
-	unsigned char UserData[MAX_USER_DEFINED_BYTES];
+	unsigned char userdata[MAX_USER_DEFINED_BYTES];
 } __attribute__((packed));
 
 /* Open Channel Result parameters */
 struct vmbus_channel_open_result {
-	struct vmbus_channel_message_header Header;
-	u32 ChildRelId;
-	u32 OpenId;
-	u32 Status;
+	struct vmbus_channel_message_header header;
+	u32 child_relid;
+	u32 openid;
+	u32 status;
 } __attribute__((packed));
 
 /* Close channel parameters; */
 struct vmbus_channel_close_channel {
-	struct vmbus_channel_message_header Header;
-	u32 ChildRelId;
+	struct vmbus_channel_message_header header;
+	u32 child_relid;
 } __attribute__((packed));
 
 /* Channel Message GPADL */
@@ -151,72 +151,72 @@ struct vmbus_channel_close_channel {
  * follow-up packet that contains more.
  */
 struct vmbus_channel_gpadl_header {
-	struct vmbus_channel_message_header Header;
-	u32 ChildRelId;
-	u32 Gpadl;
-	u16 RangeBufLen;
-	u16 RangeCount;
-	struct gpa_range Range[0];
+	struct vmbus_channel_message_header header;
+	u32 child_relid;
+	u32 gpadl;
+	u16 range_buflen;
+	u16 rangecount;
+	struct gpa_range range[0];
 } __attribute__((packed));
 
 /* This is the followup packet that contains more PFNs. */
 struct vmbus_channel_gpadl_body {
-	struct vmbus_channel_message_header Header;
-	u32 MessageNumber;
-	u32 Gpadl;
-	u64 Pfn[0];
+	struct vmbus_channel_message_header header;
+	u32 msgnumber;
+	u32 gpadl;
+	u64 pfn[0];
 } __attribute__((packed));
 
 struct vmbus_channel_gpadl_created {
-	struct vmbus_channel_message_header Header;
-	u32 ChildRelId;
-	u32 Gpadl;
-	u32 CreationStatus;
+	struct vmbus_channel_message_header header;
+	u32 child_relid;
+	u32 gpadl;
+	u32 creation_status;
 } __attribute__((packed));
 
 struct vmbus_channel_gpadl_teardown {
-	struct vmbus_channel_message_header Header;
-	u32 ChildRelId;
-	u32 Gpadl;
+	struct vmbus_channel_message_header header;
+	u32 child_relid;
+	u32 gpadl;
 } __attribute__((packed));
 
 struct vmbus_channel_gpadl_torndown {
-	struct vmbus_channel_message_header Header;
-	u32 Gpadl;
+	struct vmbus_channel_message_header header;
+	u32 gpadl;
 } __attribute__((packed));
 
 #ifdef VMBUS_FEATURE_PARENT_OR_PEER_MEMORY_MAPPED_INTO_A_CHILD
 struct vmbus_channel_view_range_add {
-	struct vmbus_channel_message_header Header;
-	PHYSICAL_ADDRESS ViewRangeBase;
-	u64 ViewRangeLength;
-	u32 ChildRelId;
+	struct vmbus_channel_message_header header;
+	PHYSICAL_ADDRESS viewrange_base;
+	u64 viewrange_length;
+	u32 child_relid;
 } __attribute__((packed));
 
 struct vmbus_channel_view_range_remove {
-	struct vmbus_channel_message_header Header;
-	PHYSICAL_ADDRESS ViewRangeBase;
-	u32 ChildRelId;
+	struct vmbus_channel_message_header header;
+	PHYSICAL_ADDRESS viewrange_base;
+	u32 child_relid;
 } __attribute__((packed));
 #endif
 
 struct vmbus_channel_relid_released {
-	struct vmbus_channel_message_header Header;
-	u32 ChildRelId;
+	struct vmbus_channel_message_header header;
+	u32 child_relid;
 } __attribute__((packed));
 
 struct vmbus_channel_initiate_contact {
-	struct vmbus_channel_message_header Header;
-	u32 VMBusVersionRequested;
-	u32 Padding2;
-	u64 InterruptPage;
-	u64 MonitorPage1;
-	u64 MonitorPage2;
+	struct vmbus_channel_message_header header;
+	u32 vmbus_version_requested;
+	u32 padding2;
+	u64 interrupt_page;
+	u64 monitor_page1;
+	u64 monitor_page2;
 } __attribute__((packed));
 
 struct vmbus_channel_version_response {
-	struct vmbus_channel_message_header Header;
-	bool VersionSupported;
+	struct vmbus_channel_message_header header;
+	bool version_supported;
 } __attribute__((packed));
 
 enum vmbus_channel_state {
@@ -226,54 +226,54 @@ enum vmbus_channel_state {
 };
 
 struct vmbus_channel {
-	struct list_head ListEntry;
+	struct list_head listentry;
 
-	struct hv_device *DeviceObject;
+	struct hv_device *device_obj;
 
 	struct timer_list poll_timer; /* SA-111 workaround */
 
-	enum vmbus_channel_state State;
+	enum vmbus_channel_state state;
 
-	struct vmbus_channel_offer_channel OfferMsg;
+	struct vmbus_channel_offer_channel offermsg;
 	/*
 	 * These are based on the OfferMsg.MonitorId.
 	 * Save it here for easy access.
 	 */
-	u8 MonitorGroup;
-	u8 MonitorBit;
+	u8 monitor_grp;
+	u8 monitor_bit;
 
-	u32 RingBufferGpadlHandle;
+	u32 ringbuffer_gpadlhandle;
 
 	/* Allocated memory for ring buffer */
-	void *RingBufferPages;
-	u32 RingBufferPageCount;
-	struct hv_ring_buffer_info Outbound;	/* send to parent */
-	struct hv_ring_buffer_info Inbound;	/* receive from parent */
+	void *ringbuffer_pages;
+	u32 ringbuffer_pagecount;
+	struct hv_ring_buffer_info outbound;	/* send to parent */
+	struct hv_ring_buffer_info inbound;	/* receive from parent */
 	spinlock_t inbound_lock;
-	struct workqueue_struct *ControlWQ;
+	struct workqueue_struct *controlwq;
 
 	/* Channel callback are invoked in this workqueue context */
 	/* HANDLE dataWorkQueue; */
 
-	void (*OnChannelCallback)(void *context);
-	void *ChannelCallbackContext;
+	void (*onchannel_callback)(void *context);
+	void *channel_callback_context;
 };
 
 struct vmbus_channel_debug_info {
-	u32 RelId;
-	enum vmbus_channel_state State;
-	struct hv_guid InterfaceType;
-	struct hv_guid InterfaceInstance;
-	u32 MonitorId;
-	u32 ServerMonitorPending;
-	u32 ServerMonitorLatency;
-	u32 ServerMonitorConnectionId;
-	u32 ClientMonitorPending;
-	u32 ClientMonitorLatency;
-	u32 ClientMonitorConnectionId;
-
-	struct hv_ring_buffer_debug_info Inbound;
-	struct hv_ring_buffer_debug_info Outbound;
+	u32 relid;
+	enum vmbus_channel_state state;
+	struct hv_guid interfacetype;
+	struct hv_guid interface_instance;
+	u32 monitorid;
+	u32 servermonitor_pending;
+	u32 servermonitor_latency;
+	u32 servermonitor_connectionid;
+	u32 clientmonitor_pending;
+	u32 clientmonitor_latency;
+	u32 clientmonitor_connectionid;
+
+	struct hv_ring_buffer_debug_info inbound;
+	struct hv_ring_buffer_debug_info outbound;
 };
 
 /*
@@ -282,28 +282,28 @@ struct vmbus_channel_debug_info {
  */
 struct vmbus_channel_msginfo {
 	/* Bookkeeping stuff */
-	struct list_head MsgListEntry;
+	struct list_head msglistentry;
 
 	/* So far, this is only used to handle gpadl body message */
-	struct list_head SubMsgList;
+	struct list_head submsglist;
 
 	/* Synchronize the request/response if needed */
-	struct osd_waitevent *WaitEvent;
+	struct osd_waitevent *waitevent;
 
 	union {
-		struct vmbus_channel_version_supported VersionSupported;
-		struct vmbus_channel_open_result OpenResult;
-		struct vmbus_channel_gpadl_torndown GpadlTorndown;
-		struct vmbus_channel_gpadl_created GpadlCreated;
-		struct vmbus_channel_version_response VersionResponse;
-	} Response;
-
-	u32 MessageSize;
+		struct vmbus_channel_version_supported version_supported;
+		struct vmbus_channel_open_result open_result;
+		struct vmbus_channel_gpadl_torndown gpadl_torndown;
+		struct vmbus_channel_gpadl_created gpadl_created;
+		struct vmbus_channel_version_response version_response;
+	} response;
+
+	u32 msgsize;
 	/*
 	 * The channel message that goes out on the "wire".
 	 * It will contain at minimum the VMBUS_CHANNEL_MESSAGE_HEADER header
 	 */
-	unsigned char Msg[0];
+	unsigned char msg[0];
 };
 
 
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index f847707..6f3f525 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -95,19 +95,19 @@ int VmbusConnect(void)
 		goto Cleanup;
 	}
 
-	msgInfo->WaitEvent = osd_WaitEventCreate();
-	if (!msgInfo->WaitEvent) {
+	msgInfo->waitevent = osd_WaitEventCreate();
+	if (!msgInfo->waitevent) {
 		ret = -ENOMEM;
 		goto Cleanup;
 	}
 
-	msg = (struct vmbus_channel_initiate_contact *)msgInfo->Msg;
+	msg = (struct vmbus_channel_initiate_contact *)msgInfo->msg;
 
-	msg->Header.MessageType = ChannelMessageInitiateContact;
-	msg->VMBusVersionRequested = VMBUS_REVISION_NUMBER;
-	msg->InterruptPage = virt_to_phys(gVmbusConnection.InterruptPage);
-	msg->MonitorPage1 = virt_to_phys(gVmbusConnection.MonitorPages);
-	msg->MonitorPage2 = virt_to_phys(
+	msg->header.msgtype = CHANNELMSG_INITIATE_CONTACT;
+	msg->vmbus_version_requested = VMBUS_REVISION_NUMBER;
+	msg->interrupt_page = virt_to_phys(gVmbusConnection.InterruptPage);
+	msg->monitor_page1 = virt_to_phys(gVmbusConnection.MonitorPages);
+	msg->monitor_page2 = virt_to_phys(
 			(void *)((unsigned long)gVmbusConnection.MonitorPages +
 				 PAGE_SIZE));
 
@@ -116,30 +116,30 @@ int VmbusConnect(void)
 	 * receive the response before returning from this routine
 	 */
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
-	list_add_tail(&msgInfo->MsgListEntry,
+	list_add_tail(&msgInfo->msglistentry,
 		      &gVmbusConnection.ChannelMsgList);
 
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
 
 	DPRINT_DBG(VMBUS, "Vmbus connection - interrupt pfn %llx, "
 		   "monitor1 pfn %llx,, monitor2 pfn %llx",
-		   msg->InterruptPage, msg->MonitorPage1, msg->MonitorPage2);
+		   msg->interrupt_page, msg->monitor_page1, msg->monitor_page2);
 
 	DPRINT_DBG(VMBUS, "Sending channel initiate msg...");
 	ret = VmbusPostMessage(msg,
 			       sizeof(struct vmbus_channel_initiate_contact));
 	if (ret != 0) {
-		list_del(&msgInfo->MsgListEntry);
+		list_del(&msgInfo->msglistentry);
 		goto Cleanup;
 	}
 
 	/* Wait for the connection response */
-	osd_WaitEventWait(msgInfo->WaitEvent);
+	osd_WaitEventWait(msgInfo->waitevent);
 
-	list_del(&msgInfo->MsgListEntry);
+	list_del(&msgInfo->msglistentry);
 
 	/* Check if successful */
-	if (msgInfo->Response.VersionResponse.VersionSupported) {
+	if (msgInfo->response.version_response.version_supported) {
 		DPRINT_INFO(VMBUS, "Vmbus connected!!");
 		gVmbusConnection.ConnectState = Connected;
 
@@ -151,7 +151,7 @@ int VmbusConnect(void)
 		goto Cleanup;
 	}
 
-	kfree(msgInfo->WaitEvent);
+	kfree(msgInfo->waitevent);
 	kfree(msgInfo);
 	return 0;
 
@@ -172,7 +172,7 @@ Cleanup:
 	}
 
 	if (msgInfo) {
-		kfree(msgInfo->WaitEvent);
+		kfree(msgInfo->waitevent);
 		kfree(msgInfo);
 	}
 
@@ -195,7 +195,7 @@ int VmbusDisconnect(void)
 	if (!msg)
 		return -ENOMEM;
 
-	msg->MessageType = ChannelMessageUnload;
+	msg->msgtype = CHANNELMSG_UNLOAD;
 
 	ret = VmbusPostMessage(msg,
 			       sizeof(struct vmbus_channel_message_header));
@@ -226,8 +226,8 @@ struct vmbus_channel *GetChannelFromRelId(u32 relId)
 	unsigned long flags;
 
 	spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
-	list_for_each_entry(channel, &gVmbusConnection.ChannelList, ListEntry) {
-		if (channel->OfferMsg.ChildRelId == relId) {
+	list_for_each_entry(channel, &gVmbusConnection.ChannelList, listentry) {
+		if (channel->offermsg.child_relid == relId) {
 			foundChannel = channel;
 			break;
 		}
diff --git a/drivers/staging/hv/hv_utils.c b/drivers/staging/hv/hv_utils.c
index 702a478..6dc1c35 100644
--- a/drivers/staging/hv/hv_utils.c
+++ b/drivers/staging/hv/hv_utils.c
@@ -271,15 +271,15 @@ static int __init init_hyperv_utils(void)
 	if (!dmi_check_system(hv_utils_dmi_table))
 		return -ENODEV;
 
-	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =
+	hv_cb_utils[HV_SHUTDOWN_MSG].channel->onchannel_callback =
 		&shutdown_onchannelcallback;
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;
 
-	hv_cb_utils[HV_TIMESYNC_MSG].channel->OnChannelCallback =
+	hv_cb_utils[HV_TIMESYNC_MSG].channel->onchannel_callback =
 		&timesync_onchannelcallback;
 	hv_cb_utils[HV_TIMESYNC_MSG].callback = &timesync_onchannelcallback;
 
-	hv_cb_utils[HV_HEARTBEAT_MSG].channel->OnChannelCallback =
+	hv_cb_utils[HV_HEARTBEAT_MSG].channel->onchannel_callback =
 		&heartbeat_onchannelcallback;
 	hv_cb_utils[HV_HEARTBEAT_MSG].callback = &heartbeat_onchannelcallback;
 
@@ -290,15 +290,15 @@ static void exit_hyperv_utils(void)
 {
 	printk(KERN_INFO "De-Registered HyperV Utility Driver\n");
 
-	hv_cb_utils[HV_SHUTDOWN_MSG].channel->OnChannelCallback =
+	hv_cb_utils[HV_SHUTDOWN_MSG].channel->onchannel_callback =
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &chn_cb_negotiate;
 
-	hv_cb_utils[HV_TIMESYNC_MSG].channel->OnChannelCallback =
+	hv_cb_utils[HV_TIMESYNC_MSG].channel->onchannel_callback =
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_TIMESYNC_MSG].callback = &chn_cb_negotiate;
 
-	hv_cb_utils[HV_HEARTBEAT_MSG].channel->OnChannelCallback =
+	hv_cb_utils[HV_HEARTBEAT_MSG].channel->onchannel_callback =
 		&chn_cb_negotiate;
 	hv_cb_utils[HV_HEARTBEAT_MSG].callback = &chn_cb_negotiate;
 }
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 0d9f3a4..2bbf4ec 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -139,35 +139,35 @@ static void get_channel_info(struct hv_device *device,
 
 	vmbus_get_debug_info(device->channel, &debug_info);
 
-	info->ChannelId = debug_info.RelId;
-	info->ChannelState = debug_info.State;
-	memcpy(&info->ChannelType, &debug_info.InterfaceType,
+	info->ChannelId = debug_info.relid;
+	info->ChannelState = debug_info.state;
+	memcpy(&info->ChannelType, &debug_info.interfacetype,
 	       sizeof(struct hv_guid));
-	memcpy(&info->ChannelInstance, &debug_info.InterfaceInstance,
+	memcpy(&info->ChannelInstance, &debug_info.interface_instance,
 	       sizeof(struct hv_guid));
 
-	info->MonitorId = debug_info.MonitorId;
+	info->MonitorId = debug_info.monitorid;
 
-	info->ServerMonitorPending = debug_info.ServerMonitorPending;
-	info->ServerMonitorLatency = debug_info.ServerMonitorLatency;
-	info->ServerMonitorConnectionId = debug_info.ServerMonitorConnectionId;
+	info->ServerMonitorPending = debug_info.servermonitor_pending;
+	info->ServerMonitorLatency = debug_info.servermonitor_latency;
+	info->ServerMonitorConnectionId = debug_info.servermonitor_connectionid;
 
-	info->ClientMonitorPending = debug_info.ClientMonitorPending;
-	info->ClientMonitorLatency = debug_info.ClientMonitorLatency;
-	info->ClientMonitorConnectionId = debug_info.ClientMonitorConnectionId;
+	info->ClientMonitorPending = debug_info.clientmonitor_pending;
+	info->ClientMonitorLatency = debug_info.clientmonitor_latency;
+	info->ClientMonitorConnectionId = debug_info.clientmonitor_connectionid;
 
-	info->Inbound.InterruptMask = debug_info.Inbound.CurrentInterruptMask;
-	info->Inbound.ReadIndex = debug_info.Inbound.CurrentReadIndex;
-	info->Inbound.WriteIndex = debug_info.Inbound.CurrentWriteIndex;
-	info->Inbound.BytesAvailToRead = debug_info.Inbound.BytesAvailToRead;
-	info->Inbound.BytesAvailToWrite = debug_info.Inbound.BytesAvailToWrite;
+	info->Inbound.InterruptMask = debug_info.inbound.CurrentInterruptMask;
+	info->Inbound.ReadIndex = debug_info.inbound.CurrentReadIndex;
+	info->Inbound.WriteIndex = debug_info.inbound.CurrentWriteIndex;
+	info->Inbound.BytesAvailToRead = debug_info.inbound.BytesAvailToRead;
+	info->Inbound.BytesAvailToWrite = debug_info.inbound.BytesAvailToWrite;
 
-	info->Outbound.InterruptMask = debug_info.Outbound.CurrentInterruptMask;
-	info->Outbound.ReadIndex = debug_info.Outbound.CurrentReadIndex;
-	info->Outbound.WriteIndex = debug_info.Outbound.CurrentWriteIndex;
-	info->Outbound.BytesAvailToRead = debug_info.Outbound.BytesAvailToRead;
+	info->Outbound.InterruptMask = debug_info.outbound.CurrentInterruptMask;
+	info->Outbound.ReadIndex = debug_info.outbound.CurrentReadIndex;
+	info->Outbound.WriteIndex = debug_info.outbound.CurrentWriteIndex;
+	info->Outbound.BytesAvailToRead = debug_info.outbound.BytesAvailToRead;
 	info->Outbound.BytesAvailToWrite =
-		debug_info.Outbound.BytesAvailToWrite;
+		debug_info.outbound.BytesAvailToWrite;
 }
 
 /*
-- 
1.6.3.2

