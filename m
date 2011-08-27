Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1H0SMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:22 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39872
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751540Ab1H0SLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in connection.c
Date: Sat, 27 Aug 2011 11:31:43 -0700
Message-Id: <1314469905-7058-44-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings in connection.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/connection.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index ca92ca3..9e99c04 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -220,11 +220,11 @@ static void process_chn_event(u32 relid)
 	channel = relid2channel(relid);
 
 	spin_lock_irqsave(&channel->inbound_lock, flags);
-	if (channel && (channel->onchannel_callback != NULL)) {
+	if (channel && (channel->onchannel_callback != NULL))
 		channel->onchannel_callback(channel->channel_callback_context);
-	} else {
+	else
 		pr_err("channel not found for relid - %u\n", relid);
-	}
+
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 }
 
@@ -246,16 +246,17 @@ void vmbus_on_event(unsigned long data)
 		if (!recv_int_page[dword])
 			continue;
 		for (bit = 0; bit < 32; bit++) {
-			if (sync_test_and_clear_bit(bit, (unsigned long *)&recv_int_page[dword])) {
+			if (sync_test_and_clear_bit(bit,
+				(unsigned long *)&recv_int_page[dword])) {
 				relid = (dword << 5) + bit;
 
-				if (relid == 0) {
+				if (relid == 0)
 					/*
 					 * Special case - vmbus
 					 * channel protocol msg
 					 */
 					continue;
-				}
+
 				process_chn_event(relid);
 			}
 		}
-- 
1.7.4.1

