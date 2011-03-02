Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1CBROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:14:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51778 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755280Ab1CBROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:14:50 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19j/3wbhwRjm4ans1EIwy1Qve3UYGXstotetUEJwR
	RvwoBvo0ZW6jlq
From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: gregkh@suse.de
Cc: haiyangz@microsoft.com, hjanssen@microsoft.com,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de
Subject: [PATCH] ./drivers/staging/hv/netvsc_drv.c: no assignment within if + whitespace clean up
Date: Wed,  2 Mar 2011 18:14:47 +0100
Message-Id: <1299086087-20928-1-git-send-email-toralf.foerster@gmx.de>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all complaints of checkpatch.pl.

Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
---
 drivers/staging/hv/netvsc_drv.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index b41c964..c531e08 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -126,8 +126,9 @@ static void netvsc_xmit_completion(void *context)
 
 		dev_kfree_skb_any(skb);
 
-		if ((net_device_ctx->avail += num_pages) >= PACKET_PAGES_HIWATER)
- 			netif_wake_queue(net);
+		net_device_ctx->avail += num_pages
+		if (net_device_ctx->avail >= PACKET_PAGES_HIWATER)
+			netif_wake_queue(net);
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
1.7.4.1

