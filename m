Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab1EIVuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:50:04 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47696
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755069Ab1EIVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 112/206] Staging: hv: Rename the variable gChannelMessageTable
Date: Mon,  9 May 2011 14:56:34 -0700
Message-Id: <1304978288-22999-112-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/channel_mgmt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index a8be565..95eef92 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -698,7 +698,7 @@ static void vmbus_onversion_response(
 
 /* Channel message dispatch table */
 static struct vmbus_channel_message_table_entry
-	gChannelMessageTable[CHANNELMSG_COUNT] = {
+	channel_message_table[CHANNELMSG_COUNT] = {
 	{CHANNELMSG_INVALID,			NULL},
 	{CHANNELMSG_OFFERCHANNEL,		vmbus_onoffer},
 	{CHANNELMSG_RESCIND_CHANNELOFFER,	vmbus_onoffer_rescind},
@@ -740,8 +740,8 @@ void vmbus_onmessage(void *context)
 		return;
 	}
 
-	if (gChannelMessageTable[hdr->msgtype].message_handler)
-		gChannelMessageTable[hdr->msgtype].message_handler(hdr);
+	if (channel_message_table[hdr->msgtype].message_handler)
+		channel_message_table[hdr->msgtype].message_handler(hdr);
 	else
 		pr_err("Unhandled channel message type %d\n", hdr->msgtype);
 }
-- 
1.7.4.1

