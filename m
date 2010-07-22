Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0GVTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:09:29 -0400
Received: from mail.candelatech.com ([208.74.158.172]:34402 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0GVTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:09:28 -0400
From: Ben Greear <greearb@candelatech.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [net 2/2] veth:  Remove redundant timestamp assignment.
Date: Thu, 22 Jul 2010 12:09:16 -0700
Message-Id: <1279825756-11568-3-git-send-email-greearb@candelatech.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279825756-11568-1-git-send-email-greearb@candelatech.com>
References: <1279825756-11568-1-git-send-email-greearb@candelatech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timestamp is already cleared in the dev_forward_skb
logic.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 0cfbb3d... 161ee02... M	drivers/net/veth.c
 drivers/net/veth.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0cfbb3d..161ee02 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -181,11 +181,6 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (dev->features & NETIF_F_NO_CSUM)
 		skb->ip_summed = rcv_priv->ip_summed;
 
-	/* Zero out the time-stamp so that receiving code is forced
-	 * to recalculate it.
-	 */
-	skb->tstamp.tv64 = 0;
-
 	length = skb->len + ETH_HLEN;
 	if (dev_forward_skb(rcv, skb) != NET_RX_SUCCESS)
 		goto rx_drop;
-- 
1.6.2.5

