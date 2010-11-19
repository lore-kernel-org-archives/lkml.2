Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab0KSWDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:03:06 -0500
Received: from kroah.org ([198.145.64.141]:45370 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab0KSV66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:58 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:44 2010
Message-Id: <20101119215644.078287603@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [65/82] qlcnic: dont set skb->truesize
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 8df8fd27123054b02007361bd5483775db84b4a8 ]

skb->truesize is set in core network.

Dont change it unless dealing with fragments.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/qlcnic/qlcnic_init.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/qlcnic/qlcnic_init.c
+++ b/drivers/net/qlcnic/qlcnic_init.c
@@ -1363,7 +1363,6 @@ qlcnic_process_rcv(struct qlcnic_adapter
 	if (pkt_offset)
 		skb_pull(skb, pkt_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff);
 	skb->protocol = eth_type_trans(skb, netdev);
 
 	napi_gro_receive(&sds_ring->napi, skb);
@@ -1425,8 +1424,6 @@ qlcnic_process_lro(struct qlcnic_adapter
 
 	skb_put(skb, lro_length + data_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff) + skb_headroom(skb);
-
 	skb_pull(skb, l2_hdr_offset);
 	skb->protocol = eth_type_trans(skb, netdev);
 
@@ -1659,8 +1656,6 @@ qlcnic_process_rcv_diag(struct qlcnic_ad
 	if (pkt_offset)
 		skb_pull(skb, pkt_offset);
 
-	skb->truesize = skb->len + sizeof(struct sk_buff);
-
 	if (!qlcnic_check_loopback_buff(skb->data))
 		adapter->diag_cnt++;
 


