Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab1FFWgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:36:47 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39495
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758210Ab1FFWfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 48/49] Staging: hv: vmbus: Change Cleanup to cleanup in channel.c
Date: Mon,  6 Jun 2011 15:50:12 -0700
Message-Id: <1307400613-13234-48-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the jump label Cleanup to cleanup.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 21f1efc..cffca7c 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -209,7 +209,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 			       sizeof(struct vmbus_channel_open_channel));
 
 	if (ret != 0)
-		goto Cleanup;
+		goto cleanup;
 
 	t = wait_for_completion_timeout(&openInfo->waitevent, HZ);
 	if (t == 0) {
@@ -221,7 +221,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	if (openInfo->response.open_result.status)
 		err = openInfo->response.open_result.status;
 
-Cleanup:
+cleanup:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&openInfo->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
@@ -472,7 +472,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	ret = vmbus_post_msg(gpadlmsg, msginfo->msgsize -
 			       sizeof(*msginfo));
 	if (ret != 0)
-		goto Cleanup;
+		goto cleanup;
 
 	if (msgcount > 1) {
 		list_for_each(curr, &msginfo->submsglist) {
@@ -491,7 +491,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 					       submsginfo->msgsize -
 					       sizeof(*submsginfo));
 			if (ret != 0)
-				goto Cleanup;
+				goto cleanup;
 
 		}
 	}
@@ -502,7 +502,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	/* At this point, we received the gpadl created msg */
 	*gpadl_handle = gpadlmsg->gpadl;
 
-Cleanup:
+cleanup:
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_del(&msginfo->msglistentry);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
-- 
1.7.4.1

