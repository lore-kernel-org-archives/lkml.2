Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1ABHY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:36711 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1ABHYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:54 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 200/260] netxen: dont set skb->truesize
Date: Sun,  2 Jan 2011 02:18:16 -0500
Message-Id: <1293952756-15010-201-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:49.0667 (UTC) FILETIME=[00233730:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 7e96dc7045bff8758804b047c0dfb6868f182500 upstream.

skb->truesize is set in core network.

Dont change it unless dealing with fragments.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/netxen/netxen_nic_init.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index 02876f5..00001bf 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -1402,7 +1402,6 @@ netxen_process_rcv(struct netxen_adapter *adapter,
 	if (pkt_offset)
 		skb_pull(skb, pkt_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff);
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	napi_gro_receive(&sds_ring->napi, skb);
@@ -1464,8 +1463,6 @@ netxen_process_lro(struct netxen_adapter *adapter,
 
 	skb_put(skb, lro_length + data_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff) + skb_headroom(skb);
-
 	skb_pull(skb, l2_hdr_offset);
 	skb->protocol = eth_type_trans(skb, netdev);
 
-- 
1.7.3.3

