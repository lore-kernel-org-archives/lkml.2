Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2BAVMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:12:31 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46900 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932682Ab2BAVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:51 -0500
X-Sasl-enc: TPHU+4kl+gvjP3x9RqBDwh0rXrYo9p1glCyBkgyQ1awz 1328130649
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:50 2012
Message-Id: <20120201210050.459861995@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Ben Greear <greearb@candelatech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [75/89] macvlan: fix a possible use after free
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit 4ec7ac1203bcf21f5e3d977c9818b1a56c9ef40d ]

Commit bc416d9768 (macvlan: handle fragmented multicast frames) added a
possible use after free in macvlan_handle_frame(), since
ip_check_defrag() uses pskb_may_pull() : skb header can be reallocated.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -172,6 +172,7 @@ static rx_handler_result_t macvlan_handl
 		skb = ip_check_defrag(skb, IP_DEFRAG_MACVLAN);
 		if (!skb)
 			return RX_HANDLER_CONSUMED;
+		eth = eth_hdr(skb);
 		src = macvlan_hash_lookup(port, eth->h_source);
 		if (!src)
 			/* frame comes from an external address */


