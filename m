Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1AFAtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:49:47 -0500
Received: from kroah.org ([198.145.64.141]:35743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab1AFA36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:58 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:02 2011
Message-Id: <20110106002302.866028027@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David L Stevens <dlstevens@us.ibm.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [066/152] bridge: fix IPv6 queries for bridge multicast snooping
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David Stevens <dlstevens@us.ibm.com>

[ Upstream commit 04bdf0c9a451863e50fff627713a900a2cabb998 ]

This patch fixes a missing ntohs() for bridge IPv6 multicast snooping.

Signed-off-by: David L Stevens <dlstevens@us.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bridge/br_multicast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -437,7 +437,7 @@ static struct sk_buff *br_ip6_multicast_
 	ip6h = ipv6_hdr(skb);
 
 	*(__force __be32 *)ip6h = htonl(0x60000000);
-	ip6h->payload_len = 8 + sizeof(*mldq);
+	ip6h->payload_len = htons(8 + sizeof(*mldq));
 	ip6h->nexthdr = IPPROTO_HOPOPTS;
 	ip6h->hop_limit = 1;
 	ipv6_addr_set(&ip6h->saddr, 0, 0, 0, 0);


