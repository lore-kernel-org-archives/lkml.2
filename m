Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab1FFWlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:41:25 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39454
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758190Ab1FFWfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 32/49] Staging: hv: vmbus: Correct some dated comments in channel.c
Date: Mon,  6 Jun 2011 15:49:56 -0700
Message-Id: <1307400613-13234-32-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct some dated comments in channel.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 95b410f..043fe25 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -185,12 +185,12 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	openMsg = (struct vmbus_channel_open_channel *)openInfo->msg;
 	openMsg->header.msgtype = CHANNELMSG_OPENCHANNEL;
-	openMsg->openid = newchannel->offermsg.child_relid; /* FIXME */
+	openMsg->openid = newchannel->offermsg.child_relid;
 	openMsg->child_relid = newchannel->offermsg.child_relid;
 	openMsg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
 	openMsg->downstream_ringbuffer_pageoffset = send_ringbuffer_size >>
 						  PAGE_SHIFT;
-	openMsg->server_contextarea_gpadlhandle = 0; /* TODO */
+	openMsg->server_contextarea_gpadlhandle = 0;
 
 	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
@@ -364,11 +364,11 @@ static int create_gpadl_header(void *kbuffer, u32 size,
 				(struct vmbus_channel_gpadl_body *)msgbody->msg;
 
 			/*
-			 * FIXME:
 			 * Gpadl is u32 and we are using a pointer which could
 			 * be 64-bit
+			 * This is governed by the guest/host protocol and
+			 * so the hypervisor gurantees that this is ok.
 			 */
-			/* gpadl_body->Gpadl = kbuffer; */
 			for (i = 0; i < pfncurr; i++)
 				gpadl_body->pfn[i] = pfn + pfnsum + i;
 
@@ -462,7 +462,6 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	if (msgcount > 1) {
 		list_for_each(curr, &msginfo->submsglist) {
 
-			/* FIXME: should this use list_entry() instead ? */
 			submsginfo = (struct vmbus_channel_msginfo *)curr;
 			gpadl_body =
 			     (struct vmbus_channel_gpadl_body *)submsginfo->msg;
@@ -577,8 +576,6 @@ void vmbus_close(struct vmbus_channel *channel)
 		vmbus_teardown_gpadl(channel,
 					  channel->ringbuffer_gpadlhandle);
 
-	/* TODO: Send a msg to release the childRelId */
-
 	/* Cleanup the ring buffers for this channel */
 	hv_ringbuffer_cleanup(&channel->outbound);
 	hv_ringbuffer_cleanup(&channel->inbound);
-- 
1.7.4.1

