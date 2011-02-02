Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1BBBBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:01:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:58186 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab1BBAoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028433"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: dlstevens@us.ibm.com, herbert@gondor.hengli.com.au, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [63/139] bridge: fix IPv6 queries for bridge multicast snooping
Message-Id: <20110202004419.BCB813E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David Stevens <dlstevens@us.ibm.com>

[ Upstream commit 76d661586c8131453ba75a2e027c1f21511a893a]

This patch fixes a missing ntohs() for bridge IPv6 multicast snooping.

Signed-off-by: David L Stevens <dlstevens@us.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/bridge/br_multicast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/net/bridge/br_multicast.c
===================================================================
--- linux-2.6.35.y.orig/net/bridge/br_multicast.c
+++ linux-2.6.35.y/net/bridge/br_multicast.c
@@ -437,7 +437,7 @@ static struct sk_buff *br_ip6_multicast_
 	ip6h = ipv6_hdr(skb);
 
 	*(__force __be32 *)ip6h = htonl(0x60000000);
-	ip6h->payload_len = 8 + sizeof(*mldq);
+	ip6h->payload_len = htons(8 + sizeof(*mldq));
 	ip6h->nexthdr = IPPROTO_HOPOPTS;
 	ip6h->hop_limit = 1;
 	ipv6_addr_set(&ip6h->saddr, 0, 0, 0, 0);
