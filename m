Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab1FFWmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:42:12 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37256
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758177Ab1FFWfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 24/49] Staging: hv: vmbus: Get rid of the unused wrapper - vmbus_onchannel_event()
Date: Mon,  6 Jun 2011 15:49:48 -0700
Message-Id: <1307400613-13234-24-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of the unused wrapper - vmbus_onchannel_event().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/channel.c |   10 ----------
 drivers/staging/hv/hyperv.h  |    1 -
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 7854de2..334885d 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -881,16 +881,6 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 EXPORT_SYMBOL_GPL(vmbus_recvpacket_raw);
 
 /*
- * vmbus_onchannel_event - Channel event callback
- */
-void vmbus_onchannel_event(struct vmbus_channel *channel)
-{
-
-	channel->onchannel_callback(channel->channel_callback_context);
-
-}
-
-/*
  * vmbus_ontimer - Timer event callback
  */
 void vmbus_ontimer(unsigned long data)
diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 3310e9b..e881cfe 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -691,7 +691,6 @@ extern int vmbus_recvpacket_raw(struct vmbus_channel *channel,
 				     u32 *buffer_actual_len,
 				     u64 *requestid);
 
-extern void vmbus_onchannel_event(struct vmbus_channel *channel);
 
 extern void vmbus_get_debug_info(struct vmbus_channel *channel,
 				     struct vmbus_channel_debug_info *debug);
-- 
1.7.4.1

