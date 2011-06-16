Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab1FPUKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:10:42 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:32912
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758718Ab1FPUCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:02:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 48/77] Staging: hv: vmbus: Change the variable name openInfo to open_info in channel.c
Date: Thu, 16 Jun 2011 13:17:21 -0700
Message-Id: <1308255470-3826-48-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the variable name openInfo to open_info in channel.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 8065775..5476863 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -119,7 +119,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		     void (*onchannelcallback)(void *context), void *context)
 {
 	struct vmbus_channel_open_channel *open_msg;
-	struct vmbus_channel_msginfo *openInfo = NULL;
+	struct vmbus_channel_msginfo *open_info = NULL;
 	void *in, *out;
 	unsigned long flags;
 	int ret, t, err = 0;
@@ -172,17 +172,17 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	}
 
 	/* Create and init the channel open message */
-	openInfo = kmalloc(sizeof(*openInfo) +
+	open_info = kmalloc(sizeof(*open_info) +
 			   sizeof(struct vmbus_channel_open_channel),
 			   GFP_KERNEL);
-	if (!openInfo) {
+	if (!open_info) {
 		err = -ENOMEM;
 		goto errorout;
 	}
 
-	init_completion(&openInfo->waitevent);
+	init_completion(&open_info->waitevent);
 
-	open_msg = (struct vmbus_channel_open_channel *)openInfo->msg;
+	open_msg = (struct vmbus_channel_open_channel *)open_info->msg;
 	open_msg->header.msgtype = CHANNELMSG_OPENCHANNEL;
 	open_msg->openid = newchannel->offermsg.child_relid;
 	open_msg->child_relid = newchannel->offermsg.child_relid;
@@ -200,7 +200,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		memcpy(open_msg->userdata, userdata, userdatalen);
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_add_tail(&openInfo->msglistentry,
+	list_add_tail(&open_info->msglistentry,
 		      &vmbus_connection.chn_msg_list);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
@@ -210,22 +210,22 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	if (ret != 0)
 		goto cleanup;
 
-	t = wait_for_completion_timeout(&openInfo->waitevent, 5*HZ);
+	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {
 		err = -ETIMEDOUT;
 		goto errorout;
 	}
 
 
-	if (openInfo->response.open_result.status)
-		err = openInfo->response.open_result.status;
+	if (open_info->response.open_result.status)
+		err = open_info->response.open_result.status;
 
 cleanup:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
-	list_del(&openInfo->msglistentry);
+	list_del(&open_info->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
-	kfree(openInfo);
+	kfree(open_info);
 	return err;
 
 errorout:
@@ -233,7 +233,7 @@ errorout:
 	hv_ringbuffer_cleanup(&newchannel->inbound);
 	free_pages((unsigned long)out,
 		get_order(send_ringbuffer_size + recv_ringbuffer_size));
-	kfree(openInfo);
+	kfree(open_info);
 	return err;
 }
 EXPORT_SYMBOL_GPL(vmbus_open);
-- 
1.7.4.1

