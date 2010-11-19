Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab0KSWDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:03:08 -0500
Received: from kroah.org ([198.145.64.141]:45362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757599Ab0KSV66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:58 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:44 2010
Message-Id: <20101119215643.997221781@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [64/82] netxen: dont set skb->truesize
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 7e96dc7045bff8758804b047c0dfb6868f182500 ]

skb->truesize is set in core network.

Dont change it unless dealing with fragments.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/netxen/netxen_nic_init.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -1540,7 +1540,6 @@ netxen_process_rcv(struct netxen_adapter
 	if (pkt_offset)
 		skb_pull(skb, pkt_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff);
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	napi_gro_receive(&sds_ring->napi, skb);
@@ -1602,8 +1601,6 @@ netxen_process_lro(struct netxen_adapter
 
 	skb_put(skb, lro_length + data_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff) + skb_headroom(skb);
-
 	skb_pull(skb, l2_hdr_offset);
 	skb->protocol = eth_type_trans(skb, netdev);
 


