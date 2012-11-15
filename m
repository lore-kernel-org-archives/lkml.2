Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993063Ab2KOELz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:11:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:49341 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993010Ab2KOELt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 48/66] ipv6: Set default hoplimit as zero.
Date: Wed, 14 Nov 2012 20:10:53 -0800
Message-Id: <20121115040942.596051625@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -219,7 +219,7 @@ static struct dst_ops ip6_dst_blackhole_
 };
 
 static const u32 ip6_template_metrics[RTAX_MAX] = {
-	[RTAX_HOPLIMIT - 1] = 255,
+	[RTAX_HOPLIMIT - 1] = 0,
 };
 
 static struct rt6_info ip6_null_entry_template = {
@@ -1241,7 +1241,7 @@ struct dst_entry *icmp6_dst_alloc(struct
 	rt->rt6i_dst.addr = fl6->daddr;
 	rt->rt6i_dst.plen = 128;
 	rt->rt6i_idev     = idev;
-	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 255);
+	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 0);
 
 	spin_lock_bh(&icmp6_dst_lock);
 	rt->dst.next = icmp6_dst_gc_list;


