Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936290Ab1KJEHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:07:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965628Ab1KJDpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:58 2011
Message-Id: <20111109213158.113423378@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gao feng <gaofeng@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [158/264] ipv6: fix route error binding peer in func icmp6_dst_alloc
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <omarapazanadi@gmail.com>

[ Upstream commit 7011687f0f2f12cc348f6a693fafe63d89167eac ]

in func icmp6_dst_alloc,dst_metric_set call ipv6_cow_metrics to set metric.
ipv6_cow_metrics may will call rt6_bind_peer to set rt6_info->rt6i_peer.
So,we should move ipv6_addr_copy before dst_metric_set to make sure rt6_bind_peer success.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/route.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1086,11 +1086,10 @@ struct dst_entry *icmp6_dst_alloc(struct
 	rt->dst.output  = ip6_output;
 	dst_set_neighbour(&rt->dst, neigh);
 	atomic_set(&rt->dst.__refcnt, 1);
-	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 255);
-
 	ipv6_addr_copy(&rt->rt6i_dst.addr, addr);
 	rt->rt6i_dst.plen = 128;
 	rt->rt6i_idev     = idev;
+	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 255);
 
 	spin_lock_bh(&icmp6_dst_lock);
 	rt->dst.next = icmp6_dst_gc_list;


