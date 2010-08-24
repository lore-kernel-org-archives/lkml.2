Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab0HXXDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:14 -0400
Received: from kroah.org ([198.145.64.141]:41235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933561Ab0HXXC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:02:59 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:07 2010
Message-Id: <20100824224507.507205186@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Changli Gao <xiaosuo@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [072/114] act_nat: fix wild pointer
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit 072d79a31a3b870b49886f4347e23f81b7eca3ac ]

pskb_may_pull() may change skb pointers, so adjust icmph after pskb_may_pull().

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sched/act_nat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -218,6 +218,7 @@ static int tcf_nat(struct sk_buff *skb,
 		if (!pskb_may_pull(skb, ihl + sizeof(*icmph) + sizeof(*iph)))
 			goto drop;
 
+		icmph = (void *)(skb_network_header(skb) + ihl);
 		iph = (void *)(icmph + 1);
 		if (egress)
 			addr = iph->daddr;


