Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab0HQHAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:00:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44536 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab0HQHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:00:48 -0400
Date: Tue, 17 Aug 2010 16:00:43 +0900
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, Xiaoyu Du <tingsrain@gmail.com>
Subject: [patch nf-next] IPVS: ICMPv6 checksum calculation
Message-ID: <20100817070036.GB742@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaoyu Du <tingsrain@gmail.com>

Correct the ICMPv6 checksum calculation when IPv6 is is used

Signed-off-by: Xiaoyu Du <tingsrain@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>

---
 net/netfilter/ipvs/ip_vs_core.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

I wonder if this is -stable or .35 material.

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 4f8ddba..124a1ae 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -638,8 +638,12 @@ void ip_vs_nat_icmp_v6(struct sk_buff *skb,
struct ip_vs_protocol *pp,

 	/* And finally the ICMP checksum */
 	icmph->icmp6_cksum = 0;
-	/* TODO IPv6: is this correct for ICMPv6? */
 	ip_vs_checksum_complete(skb, icmp_offset);
+	icmph->icmp6_cksum = csum_ipv6_magic(&iph->saddr,
+			&iph->daddr,
+			skb->len - icmp_offset, IPPROTO_ICMPV6,
+			skb->csum);
+
 	skb->ip_summed = CHECKSUM_UNNECESSARY;

 	if (inout)
--
