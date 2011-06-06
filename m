Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab1FFWmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:42:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58041
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758178Ab1FFWfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 25/49] Staging: hv: vmbus: Get rid of unneeded calls to dump_vmbus_channel
Date: Mon,  6 Jun 2011 15:49:49 -0700
Message-Id: <1307400613-13234-25-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unneeded calls to dump_vmbus_channel and get rid of the unused 
static function that dumps the channel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 334885d..b6f8674 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -39,7 +39,6 @@ static int create_gpadl_header(
 	u32 size,	/* page-size multiple */
 	struct vmbus_channel_msginfo **msginfo,
 	u32 *messagecount);
-static void dump_vmbus_channel(struct vmbus_channel *channel);
 static void vmbus_setevent(struct vmbus_channel *channel);
 
 /*
@@ -618,7 +617,6 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	u64 aligned_data = 0;
 	int ret;
 
-	dump_vmbus_channel(channel);
 
 	/* Setup the descriptor */
 	desc.type = type; /* VmbusPacketTypeDataInBand; */
@@ -665,7 +663,6 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	if (pagecount > MAX_PAGE_BUFFER_COUNT)
 		return -EINVAL;
 
-	dump_vmbus_channel(channel);
 
 	/*
 	 * Adjust the size down since vmbus_channel_packet_page_buffer is the
@@ -725,7 +722,6 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	u32 pfncount = NUM_PAGES_SPANNED(multi_pagebuffer->offset,
 					 multi_pagebuffer->len);
 
-	dump_vmbus_channel(channel);
 
 	if ((pfncount < 0) || (pfncount > MAX_MULTIPAGE_BUFFER_COUNT))
 		return -EINVAL;
@@ -891,12 +887,3 @@ void vmbus_ontimer(unsigned long data)
 		channel->onchannel_callback(channel->channel_callback_context);
 }
 
-/*
- * dump_vmbus_channel- Dump vmbus channel info to the console
- */
-static void dump_vmbus_channel(struct vmbus_channel *channel)
-{
-	DPRINT_DBG(VMBUS, "Channel (%d)", channel->offermsg.child_relid);
-	hv_dump_ring_info(&channel->outbound, "Outbound ");
-	hv_dump_ring_info(&channel->inbound, "Inbound ");
-}
-- 
1.7.4.1

