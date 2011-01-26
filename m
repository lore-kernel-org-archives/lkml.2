Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab1AZULE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:11:04 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34514
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753951Ab1AZULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:11:00 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 7/8] staging: hv: Convert camel cased struct fields in vmbus_packet_format.h to lower cases
Date: Wed, 26 Jan 2011 12:12:13 -0800
Message-Id: <1296072734-11963-7-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1296072734-11963-6-git-send-email-haiyangz@microsoft.com>
References: <1296072734-11963-1-git-send-email-haiyangz@microsoft.com>
 <1296072734-11963-2-git-send-email-haiyangz@microsoft.com>
 <1296072734-11963-3-git-send-email-haiyangz@microsoft.com>
 <1296072734-11963-4-git-send-email-haiyangz@microsoft.com>
 <1296072734-11963-5-git-send-email-haiyangz@microsoft.com>
 <1296072734-11963-6-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c          |    2 +-
 drivers/staging/hv/channel.c             |   56 +++++++-------
 drivers/staging/hv/channel_mgmt.c        |    2 +-
 drivers/staging/hv/hv_kvp.c              |    4 +-
 drivers/staging/hv/hv_util.c             |    6 +-
 drivers/staging/hv/netvsc.c              |   68 +++++++++---------
 drivers/staging/hv/storvsc.c             |   12 ++--
 drivers/staging/hv/vmbus_packet_format.h |  118 +++++++++++++++---------------
 8 files changed, 134 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index cabadf0..58bbcd6 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -873,7 +873,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 		DPRINT_DBG(BLKVSC_DRV, "blkvsc_submit_request() - "
 			   "req %p pfn[%d] %llx\n",
 			   blkvsc_req, i,
-			   blkvsc_req->request.data_buffer.PfnArray[i]);
+			   blkvsc_req->request.data_buffer.pfn_array[i]);
 	}
 #endif
 
diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 711548f..a8f5c38 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -338,16 +338,16 @@ static void dump_gpadl_header(struct vmbus_channel_gpadl_header *gpadl)
 		   "gpadl header - relid %d, range count %d, range buflen %d",
 		   gpadl->child_relid, gpadl->rangecount, gpadl->range_buflen);
 	for (i = 0; i < gpadl->rangecount; i++) {
-		pagecount = gpadl->range[i].ByteCount >> PAGE_SHIFT;
+		pagecount = gpadl->range[i].byte_count >> PAGE_SHIFT;
 		pagecount = (pagecount > 26) ? 26 : pagecount;
 
 		DPRINT_DBG(VMBUS, "gpadl range %d - len %d offset %d "
-			   "page count %d", i, gpadl->range[i].ByteCount,
-			   gpadl->range[i].ByteOffset, pagecount);
+			   "page count %d", i, gpadl->range[i].byte_count,
+			   gpadl->range[i].byte_offset, pagecount);
 
 		for (j = 0; j < pagecount; j++)
 			DPRINT_DBG(VMBUS, "%d) pfn %llu", j,
-				   gpadl->range[i].PfnArray[j]);
+				   gpadl->range[i].pfn_array[j]);
 	}
 }
 
@@ -399,10 +399,10 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->rangecount = 1;
 		gpadl_header->range_buflen = sizeof(struct gpa_range) +
 					 pagecount * sizeof(u64);
-		gpadl_header->range[0].ByteOffset = 0;
-		gpadl_header->range[0].ByteCount = size;
+		gpadl_header->range[0].byte_offset = 0;
+		gpadl_header->range[0].byte_count = size;
 		for (i = 0; i < pfncount; i++)
-			gpadl_header->range[0].PfnArray[i] = pfn+i;
+			gpadl_header->range[0].pfn_array[i] = pfn+i;
 		*msginfo = msgheader;
 		*messagecount = 1;
 
@@ -463,10 +463,10 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 		gpadl_header->rangecount = 1;
 		gpadl_header->range_buflen = sizeof(struct gpa_range) +
 					 pagecount * sizeof(u64);
-		gpadl_header->range[0].ByteOffset = 0;
-		gpadl_header->range[0].ByteCount = size;
+		gpadl_header->range[0].byte_offset = 0;
+		gpadl_header->range[0].byte_count = size;
 		for (i = 0; i < pagecount; i++)
-			gpadl_header->range[0].PfnArray[i] = pfn+i;
+			gpadl_header->range[0].pfn_array[i] = pfn+i;
 
 		*msginfo = msgheader;
 		*messagecount = 1;
@@ -739,12 +739,12 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
-	desc.Type = type; /* VmbusPacketTypeDataInBand; */
-	desc.Flags = flags; /* VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED; */
+	desc.type = type; /* VmbusPacketTypeDataInBand; */
+	desc.flags = flags; /* VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED; */
 	/* in 8-bytes granularity */
-	desc.DataOffset8 = sizeof(struct vmpacket_descriptor) >> 3;
-	desc.Length8 = (u16)(packetlen_aligned >> 3);
-	desc.TransactionId = requestid;
+	desc.offset8 = sizeof(struct vmpacket_descriptor) >> 3;
+	desc.len8 = (u16)(packetlen_aligned >> 3);
+	desc.trans_id = requestid;
 
 	sg_init_table(bufferlist, 3);
 	sg_set_buf(&bufferlist[0], &desc, sizeof(struct vmpacket_descriptor));
@@ -798,7 +798,7 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
-	desc.type = VmbusPacketTypeDataUsingGpaDirect;
+	desc.type = VM_PKT_DATA_USING_GPA_DIRECT;
 	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
 	desc.dataoffset8 = descsize >> 3; /* in 8-bytes grandularity */
 	desc.length8 = (u16)(packetlen_aligned >> 3);
@@ -867,7 +867,7 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
-	desc.type = VmbusPacketTypeDataUsingGpaDirect;
+	desc.type = VM_PKT_DATA_USING_GPA_DIRECT;
 	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
 	desc.dataoffset8 = descsize >> 3; /* in 8-bytes grandularity */
 	desc.length8 = (u16)(packetlen_aligned >> 3);
@@ -934,14 +934,14 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 
 	/* VmbusChannelClearEvent(Channel); */
 
-	packetlen = desc.Length8 << 3;
-	userlen = packetlen - (desc.DataOffset8 << 3);
+	packetlen = desc.len8 << 3;
+	userlen = packetlen - (desc.offset8 << 3);
 	/* ASSERT(userLen > 0); */
 
 	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
 		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->offermsg.child_relid, desc.Type,
-		   desc.Flags, desc.TransactionId, packetlen, userlen);
+		   channel, channel->offermsg.child_relid, desc.type,
+		   desc.flags, desc.trans_id, packetlen, userlen);
 
 	*buffer_actual_len = userlen;
 
@@ -953,11 +953,11 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 		return -1;
 	}
 
-	*requestid = desc.TransactionId;
+	*requestid = desc.trans_id;
 
 	/* Copy over the packet to the user buffer */
 	ret = ringbuffer_read(&channel->inbound, buffer, userlen,
-			     (desc.DataOffset8 << 3));
+			     (desc.offset8 << 3));
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 
@@ -994,13 +994,13 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 
 	/* VmbusChannelClearEvent(Channel); */
 
-	packetlen = desc.Length8 << 3;
-	userlen = packetlen - (desc.DataOffset8 << 3);
+	packetlen = desc.len8 << 3;
+	userlen = packetlen - (desc.offset8 << 3);
 
 	DPRINT_DBG(VMBUS, "packet received on channel %p relid %d <type %d "
 		   "flag %d tid %llx pktlen %d datalen %d> ",
-		   channel, channel->offermsg.child_relid, desc.Type,
-		   desc.Flags, desc.TransactionId, packetlen, userlen);
+		   channel, channel->offermsg.child_relid, desc.type,
+		   desc.flags, desc.trans_id, packetlen, userlen);
 
 	*buffer_actual_len = packetlen;
 
@@ -1012,7 +1012,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 		return -2;
 	}
 
-	*requestid = desc.TransactionId;
+	*requestid = desc.trans_id;
 
 	/* Copy over the entire packet to the user buffer */
 	ret = ringbuffer_read(&channel->inbound, buffer, packetlen, 0);
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 3e229fa..78c4f10 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -194,7 +194,7 @@ void chn_cb_negotiate(void *context)
 
 		vmbus_sendpacket(channel, buf,
 				       recvlen, requestid,
-				       VmbusPacketTypeDataInBand, 0);
+				       VM_PKT_DATA_INBAND, 0);
 	}
 
 	kfree(buf);
diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index 5458631..bc1c20e 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -224,7 +224,7 @@ response_done:
 	icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
 
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
-				VmbusPacketTypeDataInBand, 0);
+				VM_PKT_DATA_INBAND, 0);
 
 	kvp_transaction.active = false;
 }
@@ -318,7 +318,7 @@ callback_done:
 
 		vmbus_sendpacket(channel, recv_buffer,
 				       recvlen, requestid,
-				       VmbusPacketTypeDataInBand, 0);
+				       VM_PKT_DATA_INBAND, 0);
 	}
 
 }
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index dea0513..43c7ec0 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -97,7 +97,7 @@ static void shutdown_onchannelcallback(void *context)
 
 		vmbus_sendpacket(channel, shut_txf_buf,
 				       recvlen, requestid,
-				       VmbusPacketTypeDataInBand, 0);
+				       VM_PKT_DATA_INBAND, 0);
 	}
 
 	if (execute_shutdown == true)
@@ -179,7 +179,7 @@ static void timesync_onchannelcallback(void *context)
 
 		vmbus_sendpacket(channel, time_txf_buf,
 				recvlen, requestid,
-				VmbusPacketTypeDataInBand, 0);
+				VM_PKT_DATA_INBAND, 0);
 	}
 }
 
@@ -225,7 +225,7 @@ static void heartbeat_onchannelcallback(void *context)
 
 		vmbus_sendpacket(channel, hbeat_txf_buf,
 				       recvlen, requestid,
-				       VmbusPacketTypeDataInBand, 0);
+				       VM_PKT_DATA_INBAND, 0);
 	}
 }
 
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 2d46528..4319363 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -270,7 +270,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
@@ -404,7 +404,7 @@ static int netvsc_init_send_buf(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
@@ -466,7 +466,7 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 				       revoke_packet,
 				       sizeof(struct nvsp_message),
 				       (unsigned long)revoke_packet,
-				       VmbusPacketTypeDataInBand, 0);
+				       VM_PKT_DATA_INBAND, 0);
 		/*
 		 * If we failed here, we might as well return and
 		 * have a leak rather than continue and a bugchk
@@ -540,7 +540,7 @@ static int netvsc_destroy_send_buf(struct netvsc_device *net_device)
 				       revoke_packet,
 				       sizeof(struct nvsp_message),
 				       (unsigned long)revoke_packet,
-				       VmbusPacketTypeDataInBand, 0);
+				       VM_PKT_DATA_INBAND, 0);
 		/*
 		 * If we failed here, we might as well return and have a leak
 		 * rather than continue and a bugchk
@@ -612,7 +612,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
 	if (ret != 0) {
@@ -666,7 +666,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, init_packet,
 			       sizeof(struct nvsp_message),
 			       (unsigned long)init_packet,
-			       VmbusPacketTypeDataInBand, 0);
+			       VM_PKT_DATA_INBAND, 0);
 	if (ret != 0) {
 		DPRINT_ERR(NETVSC,
 			   "unable to send NvspMessage1TypeSendNdisVersion");
@@ -872,7 +872,7 @@ static void netvsc_send_completion(struct hv_device *device,
 	}
 
 	nvsp_packet = (struct nvsp_message *)((unsigned long)packet +
-			(packet->DataOffset8 << 3));
+			(packet->offset8 << 3));
 
 	DPRINT_DBG(NETVSC, "send completion packet - type %d",
 		   nvsp_packet->hdr.msg_type);
@@ -890,7 +890,7 @@ static void netvsc_send_completion(struct hv_device *device,
 		   NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE) {
 		/* Get the send context */
 		nvsc_packet = (struct hv_netvsc_packet *)(unsigned long)
-			packet->TransactionId;
+			packet->trans_id;
 		/* ASSERT(nvscPacket); */
 
 		/* Notify the layer above us */
@@ -946,7 +946,7 @@ static int netvsc_send(struct hv_device *device,
 		ret = vmbus_sendpacket(device->channel, &sendMessage,
 				       sizeof(struct nvsp_message),
 				       (unsigned long)packet,
-				       VmbusPacketTypeDataInBand,
+				       VM_PKT_DATA_INBAND,
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
 	}
@@ -987,15 +987,15 @@ static void netvsc_receive(struct hv_device *device,
 	 * All inbound packets other than send completion should be xfer page
 	 * packet
 	 */
-	if (packet->Type != VmbusPacketTypeDataUsingTransferPages) {
+	if (packet->type != VM_PKT_DATA_USING_XFER_PAGES) {
 		DPRINT_ERR(NETVSC, "Unknown packet type received - %d",
-			   packet->Type);
+			   packet->type);
 		put_net_device(device);
 		return;
 	}
 
 	nvsp_packet = (struct nvsp_message *)((unsigned long)packet +
-			(packet->DataOffset8 << 3));
+			(packet->offset8 << 3));
 
 	/* Make sure this is a valid nvsp packet */
 	if (nvsp_packet->hdr.msg_type !=
@@ -1011,16 +1011,16 @@ static void netvsc_receive(struct hv_device *device,
 
 	vmxferpage_packet = (struct vmtransfer_page_packet_header *)packet;
 
-	if (vmxferpage_packet->TransferPageSetId != NETVSC_RECEIVE_BUFFER_ID) {
+	if (vmxferpage_packet->xfer_pageset_id != NETVSC_RECEIVE_BUFFER_ID) {
 		DPRINT_ERR(NETVSC, "Invalid xfer page set id - "
 			   "expecting %x got %x", NETVSC_RECEIVE_BUFFER_ID,
-			   vmxferpage_packet->TransferPageSetId);
+			   vmxferpage_packet->xfer_pageset_id);
 		put_net_device(device);
 		return;
 	}
 
 	DPRINT_DBG(NETVSC, "xfer page - range count %d",
-		   vmxferpage_packet->RangeCount);
+		   vmxferpage_packet->range_cnt);
 
 	/*
 	 * Grab free packets (range count + 1) to represent this xfer
@@ -1031,7 +1031,7 @@ static void netvsc_receive(struct hv_device *device,
 	spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
 	while (!list_empty(&net_device->recv_pkt_list)) {
 		list_move_tail(net_device->recv_pkt_list.next, &listHead);
-		if (++count == vmxferpage_packet->RangeCount + 1)
+		if (++count == vmxferpage_packet->range_cnt + 1)
 			break;
 	}
 	spin_unlock_irqrestore(&net_device->recv_pkt_list_lock, flags);
@@ -1044,7 +1044,7 @@ static void netvsc_receive(struct hv_device *device,
 	if (count < 2) {
 		DPRINT_ERR(NETVSC, "Got only %d netvsc pkt...needed %d pkts. "
 			   "Dropping this xfer page packet completely!",
-			   count, vmxferpage_packet->RangeCount + 1);
+			   count, vmxferpage_packet->range_cnt + 1);
 
 		/* Return it to the freelist */
 		spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
@@ -1056,7 +1056,7 @@ static void netvsc_receive(struct hv_device *device,
 				       flags);
 
 		netvsc_send_recv_completion(device,
-					    vmxferpage_packet->d.TransactionId);
+					    vmxferpage_packet->d.trans_id);
 
 		put_net_device(device);
 		return;
@@ -1071,9 +1071,9 @@ static void netvsc_receive(struct hv_device *device,
 	/* ASSERT(xferpagePacket->Count > 0 && xferpagePacket->Count <= */
 	/* 	vmxferpagePacket->RangeCount); */
 
-	if (xferpage_packet->count != vmxferpage_packet->RangeCount) {
+	if (xferpage_packet->count != vmxferpage_packet->range_cnt) {
 		DPRINT_INFO(NETVSC, "Needed %d netvsc pkts to satisy this xfer "
-			    "page...got %d", vmxferpage_packet->RangeCount,
+			    "page...got %d", vmxferpage_packet->range_cnt,
 			    xferpage_packet->count);
 	}
 
@@ -1091,10 +1091,10 @@ static void netvsc_receive(struct hv_device *device,
 		netvsc_packet->device = device;
 		/* Save this so that we can send it back */
 		netvsc_packet->completion.recv.recv_completion_tid =
-					vmxferpage_packet->d.TransactionId;
+					vmxferpage_packet->d.trans_id;
 
 		netvsc_packet->total_data_buflen =
-					vmxferpage_packet->Ranges[i].ByteCount;
+					vmxferpage_packet->ranges[i].byte_count;
 		netvsc_packet->page_buf_cnt = 1;
 
 		/* ASSERT(vmxferpagePacket->Ranges[i].ByteOffset + */
@@ -1102,20 +1102,20 @@ static void netvsc_receive(struct hv_device *device,
 		/* 	netDevice->ReceiveBufferSize); */
 
 		netvsc_packet->page_buf[0].len =
-					vmxferpage_packet->Ranges[i].ByteCount;
+					vmxferpage_packet->ranges[i].byte_count;
 
 		start = virt_to_phys((void *)((unsigned long)net_device->
-		recv_buf + vmxferpage_packet->Ranges[i].ByteOffset));
+		recv_buf + vmxferpage_packet->ranges[i].byte_offset));
 
 		netvsc_packet->page_buf[0].pfn = start >> PAGE_SHIFT;
 		end_virtual = (unsigned long)net_device->recv_buf
-		    + vmxferpage_packet->Ranges[i].ByteOffset
-		    + vmxferpage_packet->Ranges[i].ByteCount - 1;
+		    + vmxferpage_packet->ranges[i].byte_offset
+		    + vmxferpage_packet->ranges[i].byte_count - 1;
 		end = virt_to_phys((void *)end_virtual);
 
 		/* Calculate the page relative offset */
 		netvsc_packet->page_buf[0].offset =
-			vmxferpage_packet->Ranges[i].ByteOffset &
+			vmxferpage_packet->ranges[i].byte_offset &
 			(PAGE_SIZE - 1);
 		if ((end >> PAGE_SHIFT) != (start >> PAGE_SHIFT)) {
 			/* Handle frame across multiple pages: */
@@ -1147,8 +1147,8 @@ static void netvsc_receive(struct hv_device *device,
 		}
 		DPRINT_DBG(NETVSC, "[%d] - (abs offset %u len %u) => "
 			   "(pfn %llx, offset %u, len %u)", i,
-			   vmxferpage_packet->Ranges[i].ByteOffset,
-			   vmxferpage_packet->Ranges[i].ByteCount,
+			   vmxferpage_packet->ranges[i].byte_offset,
+			   vmxferpage_packet->ranges[i].byte_count,
 			   netvsc_packet->page_buf[0].pfn,
 			   netvsc_packet->page_buf[0].offset,
 			   netvsc_packet->page_buf[0].len);
@@ -1187,7 +1187,7 @@ retry_send_cmplt:
 	/* Send the completion */
 	ret = vmbus_sendpacket(device->channel, &recvcompMessage,
 			       sizeof(struct nvsp_message), transaction_id,
-			       VmbusPacketTypeCompletion, 0);
+			       VM_PKT_COMP, 0);
 	if (ret == 0) {
 		/* success */
 		/* no-op */
@@ -1300,12 +1300,12 @@ static void netvsc_channel_cb(void *context)
 					   bytes_recvd, request_id);
 
 				desc = (struct vmpacket_descriptor *)buffer;
-				switch (desc->Type) {
-				case VmbusPacketTypeCompletion:
+				switch (desc->type) {
+				case VM_PKT_COMP:
 					netvsc_send_completion(device, desc);
 					break;
 
-				case VmbusPacketTypeDataUsingTransferPages:
+				case VM_PKT_DATA_USING_XFER_PAGES:
 					netvsc_receive(device, desc);
 					break;
 
@@ -1313,7 +1313,7 @@ static void netvsc_channel_cb(void *context)
 					DPRINT_ERR(NETVSC,
 						   "unhandled packet type %d, "
 						   "tid %llx len %d\n",
-						   desc->Type, request_id,
+						   desc->type, request_id,
 						   bytes_recvd);
 					break;
 				}
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index b80b1e9..a612109 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -218,7 +218,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC,
@@ -249,7 +249,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC,
@@ -280,7 +280,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
 	if (ret != 0) {
@@ -317,7 +317,7 @@ static int stor_vsc_channel_init(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)request,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
 	if (ret != 0) {
@@ -642,7 +642,7 @@ int stor_vsc_on_host_reset(struct hv_device *device)
 	ret = vmbus_sendpacket(device->channel, vstor_packet,
 			       sizeof(struct vstor_packet),
 			       (unsigned long)&stor_device->reset_request,
-			       VmbusPacketTypeDataInBand,
+			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC, "Unable to send reset packet %p ret %d",
@@ -744,7 +744,7 @@ static int stor_vsc_on_io_request(struct hv_device *device,
 		ret = vmbus_sendpacket(device->channel, vstor_packet,
 				       sizeof(struct vstor_packet),
 				       (unsigned long)request_extension,
-				       VmbusPacketTypeDataInBand,
+				       VM_PKT_DATA_INBAND,
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
diff --git a/drivers/staging/hv/vmbus_packet_format.h b/drivers/staging/hv/vmbus_packet_format.h
index f9f6b4b..5cb13e5 100644
--- a/drivers/staging/hv/vmbus_packet_format.h
+++ b/drivers/staging/hv/vmbus_packet_format.h
@@ -25,43 +25,43 @@
 #define _VMBUSPACKETFORMAT_H_
 
 struct vmpacket_descriptor {
-	u16 Type;
-	u16 DataOffset8;
-	u16 Length8;
-	u16 Flags;
-	u64 TransactionId;
+	u16 type;
+	u16 offset8;
+	u16 len8;
+	u16 flags;
+	u64 trans_id;
 } __attribute__((packed));
 
 struct vmpacket_header {
-	u32 PreviousPacketStartOffset;
-	struct vmpacket_descriptor Descriptor;
+	u32 prev_pkt_start_offset;
+	struct vmpacket_descriptor descriptor;
 } __attribute__((packed));
 
 struct vmtransfer_page_range {
-	u32 ByteCount;
-	u32 ByteOffset;
+	u32 byte_count;
+	u32 byte_offset;
 } __attribute__((packed));
 
 struct vmtransfer_page_packet_header {
 	struct vmpacket_descriptor d;
-	u16 TransferPageSetId;
-	bool SenderOwnsSet;
-	u8 Reserved;
-	u32 RangeCount;
-	struct vmtransfer_page_range Ranges[1];
+	u16 xfer_pageset_id;
+	bool sender_owns_set;
+	u8 reserved;
+	u32 range_cnt;
+	struct vmtransfer_page_range ranges[1];
 } __attribute__((packed));
 
 struct vmgpadl_packet_header {
 	struct vmpacket_descriptor d;
-	u32 Gpadl;
-	u32 Reserved;
+	u32 gpadl;
+	u32 reserved;
 } __attribute__((packed));
 
 struct vmadd_remove_transfer_page_set {
 	struct vmpacket_descriptor d;
-	u32 Gpadl;
-	u16 TransferPageSetId;
-	u16 Reserved;
+	u32 gpadl;
+	u16 xfer_pageset_id;
+	u16 reserved;
 } __attribute__((packed));
 
 /*
@@ -69,9 +69,9 @@ struct vmadd_remove_transfer_page_set {
  * look virtually contiguous.
  */
 struct gpa_range {
-	u32 ByteCount;
-	u32 ByteOffset;
-	u64 PfnArray[0];
+	u32 byte_count;
+	u32 byte_offset;
+	u64 pfn_array[0];
 };
 
 /*
@@ -83,9 +83,9 @@ struct gpa_range {
  */
 struct vmestablish_gpadl {
 	struct vmpacket_descriptor d;
-	u32 Gpadl;
-	u32 RangeCount;
-	struct gpa_range Range[1];
+	u32 gpadl;
+	u32 range_cnt;
+	struct gpa_range range[1];
 } __attribute__((packed));
 
 /*
@@ -94,8 +94,8 @@ struct vmestablish_gpadl {
  */
 struct vmteardown_gpadl {
 	struct vmpacket_descriptor d;
-	u32 Gpadl;
-	u32 Reserved;	/* for alignment to a 8-byte boundary */
+	u32 gpadl;
+	u32 reserved;	/* for alignment to a 8-byte boundary */
 } __attribute__((packed));
 
 /*
@@ -104,56 +104,56 @@ struct vmteardown_gpadl {
  */
 struct vmdata_gpa_direct {
 	struct vmpacket_descriptor d;
-	u32 Reserved;
-	u32 RangeCount;
-	struct gpa_range Range[1];
+	u32 reserved;
+	u32 range_cnt;
+	struct gpa_range range[1];
 } __attribute__((packed));
 
 /* This is the format for a Additional Data Packet. */
 struct vmadditional_data {
 	struct vmpacket_descriptor d;
-	u64 TotalBytes;
-	u32 ByteOffset;
-	u32 ByteCount;
-	unsigned char Data[1];
+	u64 total_bytes;
+	u32 offset;
+	u32 byte_cnt;
+	unsigned char data[1];
 } __attribute__((packed));
 
 union vmpacket_largest_possible_header {
-	struct vmpacket_descriptor SimpleHeader;
-	struct vmtransfer_page_packet_header TransferPageHeader;
-	struct vmgpadl_packet_header GpadlHeader;
-	struct vmadd_remove_transfer_page_set AddRemoveTransferPageHeader;
-	struct vmestablish_gpadl EstablishGpadlHeader;
-	struct vmteardown_gpadl TeardownGpadlHeader;
-	struct vmdata_gpa_direct DataGpaDirectHeader;
+	struct vmpacket_descriptor simple_hdr;
+	struct vmtransfer_page_packet_header xfer_page_hdr;
+	struct vmgpadl_packet_header gpadl_hdr;
+	struct vmadd_remove_transfer_page_set add_rm_xfer_page_hdr;
+	struct vmestablish_gpadl establish_gpadl_hdr;
+	struct vmteardown_gpadl teardown_gpadl_hdr;
+	struct vmdata_gpa_direct data_gpa_direct_hdr;
 };
 
 #define VMPACKET_DATA_START_ADDRESS(__packet)	\
 	(void *)(((unsigned char *)__packet) +	\
-	 ((struct vmpacket_descriptor)__packet)->DataOffset8 * 8)
+	 ((struct vmpacket_descriptor)__packet)->offset8 * 8)
 
 #define VMPACKET_DATA_LENGTH(__packet)		\
-	((((struct vmpacket_descriptor)__packet)->Length8 -	\
-	  ((struct vmpacket_descriptor)__packet)->DataOffset8) * 8)
+	((((struct vmpacket_descriptor)__packet)->len8 -	\
+	  ((struct vmpacket_descriptor)__packet)->offset8) * 8)
 
 #define VMPACKET_TRANSFER_MODE(__packet)	\
-	(((struct IMPACT)__packet)->Type)
+	(((struct IMPACT)__packet)->type)
 
 enum vmbus_packet_type {
-	VmbusPacketTypeInvalid				= 0x0,
-	VmbusPacketTypeSynch				= 0x1,
-	VmbusPacketTypeAddTransferPageSet		= 0x2,
-	VmbusPacketTypeRemoveTransferPageSet		= 0x3,
-	VmbusPacketTypeEstablishGpadl			= 0x4,
-	VmbusPacketTypeTearDownGpadl			= 0x5,
-	VmbusPacketTypeDataInBand			= 0x6,
-	VmbusPacketTypeDataUsingTransferPages		= 0x7,
-	VmbusPacketTypeDataUsingGpadl			= 0x8,
-	VmbusPacketTypeDataUsingGpaDirect		= 0x9,
-	VmbusPacketTypeCancelRequest			= 0xa,
-	VmbusPacketTypeCompletion			= 0xb,
-	VmbusPacketTypeDataUsingAdditionalPackets	= 0xc,
-	VmbusPacketTypeAdditionalData			= 0xd
+	VM_PKT_INVALID				= 0x0,
+	VM_PKT_SYNCH				= 0x1,
+	VM_PKT_ADD_XFER_PAGESET			= 0x2,
+	VM_PKT_RM_XFER_PAGESET			= 0x3,
+	VM_PKT_ESTABLISH_GPADL			= 0x4,
+	VM_PKT_TEARDOWN_GPADL			= 0x5,
+	VM_PKT_DATA_INBAND			= 0x6,
+	VM_PKT_DATA_USING_XFER_PAGES		= 0x7,
+	VM_PKT_DATA_USING_GPADL			= 0x8,
+	VM_PKT_DATA_USING_GPA_DIRECT		= 0x9,
+	VM_PKT_CANCEL_REQUEST			= 0xa,
+	VM_PKT_COMP				= 0xb,
+	VM_PKT_DATA_USING_ADDITIONAL_PKT	= 0xc,
+	VM_PKT_ADDITIONAL_DATA			= 0xd
 };
 
 #define VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED	1
-- 
1.6.3.2

