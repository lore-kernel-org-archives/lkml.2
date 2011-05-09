Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1EIVsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:48:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47726
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755080Ab1EIVoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 117/206] Staging: hv: Get rid of some dead code in channel.c
Date: Mon,  9 May 2011 14:56:39 -0700
Message-Id: <1304978288-22999-117-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c |   71 ------------------------------------------
 1 files changed, 0 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 1b50cb7..a2a190e 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -42,37 +42,6 @@ static int create_gpadl_header(
 static void dump_vmbus_channel(struct vmbus_channel *channel);
 static void vmbus_setevent(struct vmbus_channel *channel);
 
-
-#if 0
-static void DumpMonitorPage(struct hv_monitor_page *MonitorPage)
-{
-	int i = 0;
-	int j = 0;
-
-	DPRINT_DBG(VMBUS, "monitorPage - %p, trigger state - %d",
-		   MonitorPage, MonitorPage->trigger_state);
-
-	for (i = 0; i < 4; i++)
-		DPRINT_DBG(VMBUS, "trigger group (%d) - %llx", i,
-			   MonitorPage->trigger_group[i].as_uint64);
-
-	for (i = 0; i < 4; i++) {
-		for (j = 0; j < 32; j++) {
-			DPRINT_DBG(VMBUS, "latency (%d)(%d) - %llx", i, j,
-				   MonitorPage->latency[i][j]);
-		}
-	}
-	for (i = 0; i < 4; i++) {
-		for (j = 0; j < 32; j++) {
-			DPRINT_DBG(VMBUS, "param-conn id (%d)(%d) - %d", i, j,
-			       MonitorPage->parameter[i][j].connectionid.asu32);
-			DPRINT_DBG(VMBUS, "param-flag (%d)(%d) - %d", i, j,
-				MonitorPage->parameter[i][j].flag_number);
-		}
-	}
-}
-#endif
-
 /*
  * vmbus_setevent- Trigger an event notification on the specified
  * channel.
@@ -99,28 +68,6 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 	}
 }
 
-#if 0
-static void VmbusChannelClearEvent(struct vmbus_channel *channel)
-{
-	struct hv_monitor_page *monitorPage;
-
-	if (Channel->offermsg.monitor_allocated) {
-		/* Each u32 represents 32 channels */
-		sync_clear_bit(Channel->offermsg.child_relid & 31,
-			  (unsigned long *)vmbus_connection.send_int_page +
-			  (Channel->offermsg.child_relid >> 5));
-
-		monitorPage = (struct hv_monitor_page *)
-			vmbus_connection.monitor_pages;
-		monitorPage++; /* Get the child to parent monitor page */
-
-		sync_clear_bit(Channel->monitor_bit,
-			  (unsigned long *)&monitorPage->trigger_group
-					[Channel->monitor_grp].Pending);
-	}
-}
-
-#endif
 /*
  * vmbus_get_debug_info -Retrieve various channel debug info
  */
@@ -179,10 +126,6 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	unsigned long flags;
 	int ret, t, err = 0;
 
-	/* Aligned to page size */
-	/* ASSERT(!(SendRingBufferSize & (PAGE_SIZE - 1))); */
-	/* ASSERT(!(RecvRingBufferSize & (PAGE_SIZE - 1))); */
-
 	newchannel->onchannel_callback = onchannelcallback;
 	newchannel->channel_callback_context = context;
 
@@ -193,7 +136,6 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	if (!out)
 		return -ENOMEM;
 
-	/* ASSERT(((unsigned long)out & (PAGE_SIZE-1)) == 0); */
 
 	in = (void *)((unsigned long)out + send_ringbuffer_size);
 
@@ -361,9 +303,6 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 
 	int pfnsum, pfncount, pfnleft, pfncurr, pfnsize;
 
-	/* ASSERT((kbuffer & (PAGE_SIZE-1)) == 0); */
-	/* ASSERT((Size & (PAGE_SIZE-1)) == 0); */
-
 	pagecount = size >> PAGE_SHIFT;
 	pfn = virt_to_phys(kbuffer) >> PAGE_SHIFT;
 
@@ -695,8 +634,6 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 
 	dump_vmbus_channel(channel);
 
-	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
-
 	/* Setup the descriptor */
 	desc.type = type; /* VmbusPacketTypeDataInBand; */
 	desc.flags = flags; /* VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED; */
@@ -754,8 +691,6 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	packetlen = descsize + bufferlen;
 	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
 
-	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
-
 	/* Setup the descriptor */
 	desc.type = VM_PKT_DATA_USING_GPA_DIRECT;
 	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
@@ -819,7 +754,6 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	packetlen = descsize + bufferlen;
 	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
 
-	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
 	desc.type = VM_PKT_DATA_USING_GPA_DIRECT;
@@ -885,11 +819,8 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 		return 0;
 	}
 
-	/* VmbusChannelClearEvent(Channel); */
-
 	packetlen = desc.len8 << 3;
 	userlen = packetlen - (desc.offset8 << 3);
-	/* ASSERT(userLen > 0); */
 
 	*buffer_actual_len = userlen;
 
@@ -938,7 +869,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 		return 0;
 	}
 
-	/* VmbusChannelClearEvent(Channel); */
 
 	packetlen = desc.len8 << 3;
 	userlen = packetlen - (desc.offset8 << 3);
@@ -970,7 +900,6 @@ EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
 void vmbus_onchannel_event(struct vmbus_channel *channel)
 {
 	dump_vmbus_channel(channel);
-	/* ASSERT(Channel->OnChannelCallback); */
 
 	channel->onchannel_callback(channel->channel_callback_context);
 
-- 
1.7.4.1

