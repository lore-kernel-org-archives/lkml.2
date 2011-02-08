Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1BHO4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:56:08 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:53703
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752457Ab1BHO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:56:07 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: hjanssen@microsoft.com, haiyangz@microsoft.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH 2/2] Staging: hv: moved assigngents out of if conditions
Date: Tue,  8 Feb 2011 15:55:49 +0100
Message-Id: <1297176949-9396-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: 1e5e6351e500a80c55a8cf674c555188
X-Authenticated-Sender: user tvh from 86.103.149.108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved all assignments in if conditions to the preceeding line

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/hv/netvsc_drv.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 95fa810..6b8fd0c 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -126,7 +126,8 @@ static void netvsc_xmit_completion(void *context)
 
 		dev_kfree_skb_any(skb);
 
-		if ((net_device_ctx->avail += num_pages) >= PACKET_PAGES_HIWATER)
+		net_device_ctx->avail += num_pages;
+		if (net_device_ctx->avail >= PACKET_PAGES_HIWATER)
  			netif_wake_queue(net);
 	}
 }
@@ -207,7 +208,8 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 			   net->stats.tx_packets,
 			   net->stats.tx_bytes);
 
-		if ((net_device_ctx->avail -= num_pages) < PACKET_PAGES_LOWATER)
+		net_device_ctx->avail -= num_pages;
+		if (net_device_ctx->avail < PACKET_PAGES_LOWATER)
 			netif_stop_queue(net);
 	} else {
 		/* we are shutting down or bus overloaded, just drop packet */
-- 
1.7.4

