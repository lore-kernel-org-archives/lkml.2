Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2KNGGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:06:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55044 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517Ab2KNFuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:23 -0500
Message-Id: <20121114053943.660691711@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:44 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 71/82] ipv6: Set default hoplimit as zero.
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 14edd87dc67311556f1254a8f29cf4dd6cb5b7d1 ]

Commit a02e4b7dae4551(Demark default hoplimit as zero) only changes the
hoplimit checking condition and default value in ip6_dst_hoplimit, not
zeros all hoplimit default value.

Keep the zeroing ip6_template_metrics[RTAX_HOPLIMIT - 1] to force it as
const, cause as a37e6e344910(net: force dst_default_metrics to const
section)

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 488a1b7..19724bd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -185,7 +185,7 @@ static struct dst_ops ip6_dst_blackhole_ops = {
 };
 
 static const u32 ip6_template_metrics[RTAX_MAX] = {
-	[RTAX_HOPLIMIT - 1] = 255,
+	[RTAX_HOPLIMIT - 1] = 0,
 };
 
 static struct rt6_info ip6_null_entry_template = {
@@ -1097,7 +1097,7 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
 	ipv6_addr_copy(&rt->rt6i_dst.addr, addr);
 	rt->rt6i_dst.plen = 128;
 	rt->rt6i_idev     = idev;
-	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 255);
+	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 0);
 
 	spin_lock_bh(&icmp6_dst_lock);
 	rt->dst.next = icmp6_dst_gc_list;


