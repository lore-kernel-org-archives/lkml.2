Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1HYQhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:37:43 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48441
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753485Ab1HYQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:56 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 29/59] Staging: hv: vmbus: Rename openMsg to open_msg in channel.c
Date: Thu, 25 Aug 2011 09:48:55 -0700
Message-Id: <1314290965-2698-29-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename openMsg to open_msg in channel.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index aa0a150..ebd7552 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -119,7 +119,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		     u32 recv_ringbuffer_size, void *userdata, u32 userdatalen,
 		     void (*onchannelcallback)(void *context), void *context)
 {
-	struct vmbus_channel_open_channel *openMsg;
+	struct vmbus_channel_open_channel *open_msg;
 	struct vmbus_channel_msginfo *openInfo = NULL;
 	void *in, *out;
 	unsigned long flags;
@@ -183,14 +183,14 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	init_completion(&openInfo->waitevent);
 
-	openMsg = (struct vmbus_channel_open_channel *)openInfo->msg;
-	openMsg->header.msgtype = CHANNELMSG_OPENCHANNEL;
-	openMsg->openid = newchannel->offermsg.child_relid;
-	openMsg->child_relid = newchannel->offermsg.child_relid;
-	openMsg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
-	openMsg->downstream_ringbuffer_pageoffset = send_ringbuffer_size >>
+	open_msg = (struct vmbus_channel_open_channel *)openInfo->msg;
+	open_msg->header.msgtype = CHANNELMSG_OPENCHANNEL;
+	open_msg->openid = newchannel->offermsg.child_relid;
+	open_msg->child_relid = newchannel->offermsg.child_relid;
+	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
+	open_msg->downstream_ringbuffer_pageoffset = send_ringbuffer_size >>
 						  PAGE_SHIFT;
-	openMsg->server_contextarea_gpadlhandle = 0;
+	open_msg->server_contextarea_gpadlhandle = 0;
 
 	if (userdatalen > MAX_USER_DEFINED_BYTES) {
 		err = -EINVAL;
@@ -198,14 +198,14 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	}
 
 	if (userdatalen)
-		memcpy(openMsg->userdata, userdata, userdatalen);
+		memcpy(open_msg->userdata, userdata, userdatalen);
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&openInfo->msglistentry,
 		      &vmbus_connection.chn_msg_list);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	ret = vmbus_post_msg(openMsg,
+	ret = vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
 
 	if (ret != 0)
-- 
1.7.4.1

