Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1CZPKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:10:43 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:53349 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1CZPKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:10:42 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tristram Ha <Tristram.Ha@micrel.com>, linux-kernel@vger.kernel.org,
        Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] net: use CHECKSUM_NONE instead of magic number
Date: Sat, 26 Mar 2011 12:10:30 -0300
Message-Id: <1301152230-4897-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two places in the kernel were doing skb->ip_summed = 0.

Change both to skb->ip_summed = CHECKSUM_NONE, which is more readable.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 drivers/net/ksz884x.c |    2 +-
 net/ipv6/ip6mr.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ksz884x.c b/drivers/net/ksz884x.c
index 540a8dc..7f7d570 100644
--- a/drivers/net/ksz884x.c
+++ b/drivers/net/ksz884x.c
@@ -4898,7 +4898,7 @@ static netdev_tx_t netdev_tx(struct sk_buff *skb, struct net_device *dev)
 				goto unlock;
 			}
 			skb_copy_and_csum_dev(org_skb, skb->data);
-			org_skb->ip_summed = 0;
+			org_skb->ip_summed = CHECKSUM_NONE;
 			skb->len = org_skb->len;
 			copy_old_skb(org_skb, skb);
 		}
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 7ff0343..29e4859 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -663,7 +663,7 @@ static int pim6_rcv(struct sk_buff *skb)
 	skb_pull(skb, (u8 *)encap - skb->data);
 	skb_reset_network_header(skb);
 	skb->protocol = htons(ETH_P_IPV6);
-	skb->ip_summed = 0;
+	skb->ip_summed = CHECKSUM_NONE;
 	skb->pkt_type = PACKET_HOST;
 
 	skb_tunnel_rx(skb, reg_dev);
-- 
1.7.4

