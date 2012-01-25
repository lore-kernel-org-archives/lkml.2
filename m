Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2AYSrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:47:03 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64417 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AYSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:47:00 -0500
MIME-Version: 1.0
From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Subject: [PATCH net] amd/lance.c: dev_alloc_skb to netdev_alloc_skb
Date: Thu, 26 Jan 2012 00:16:28 +0530
Message-Id: <1327517188-14088-1-git-send-email-netdev@pradeepdalvi.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced deprecating dev_alloc_skb with netdev_alloc_skb for amd/lance.c
  - Removed extra skb->dev = dev

Signed-off-by: Pradeep A. Dalvi <netdev@pradeepdalvi.com>
---
 drivers/net/ethernet/amd/lance.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index a6e2e84..a8a6b45 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -871,12 +871,11 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
 		struct sk_buff *skb;
 		void *rx_buff;
 
-		skb = alloc_skb(PKT_BUF_SZ, GFP_DMA | gfp);
+		skb = __netdev_alloc_skb(dev, PKT_BUF_SZ, GFP_DMA | gfp);
 		lp->rx_skbuff[i] = skb;
-		if (skb) {
-			skb->dev = dev;
+		if (skb)
 			rx_buff = skb->data;
-		} else
+		else
 			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
 		if (rx_buff == NULL)
 			lp->rx_ring[i].base = 0;
@@ -1183,7 +1182,7 @@ lance_rx(struct net_device *dev)
 			}
 			else
 			{
-				skb = dev_alloc_skb(pkt_len+2);
+				skb = netdev_alloc_skb(dev, pkt_len + 2);
 				if (skb == NULL)
 				{
 					printk("%s: Memory squeeze, deferring packet.\n", dev->name);
