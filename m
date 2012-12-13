Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab2LMONI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:13:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44964 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab2LMONA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:13:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 197/241] ipv6: Set default hoplimit as zero.
Date: Thu, 13 Dec 2012 11:59:22 -0200
Message-Id: <1355407206-17100-198-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

commit 14edd87dc67311556f1254a8f29cf4dd6cb5b7d1 upstream.

Commit a02e4b7dae4551(Demark default hoplimit as zero) only changes the
hoplimit checking condition and default value in ip6_dst_hoplimit, not
zeros all hoplimit default value.

Keep the zeroing ip6_template_metrics[RTAX_HOPLIMIT - 1] to force it as
const, cause as a37e6e344910(net: force dst_default_metrics to const
section)

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv6/route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index a3ef2ad..fd44184 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -205,7 +205,7 @@ static struct dst_ops ip6_dst_blackhole_ops = {
 };
 
 static const u32 ip6_template_metrics[RTAX_MAX] = {
-	[RTAX_HOPLIMIT - 1] = 255,
+	[RTAX_HOPLIMIT - 1] = 0,
 };
 
 static struct rt6_info ip6_null_entry_template = {
@@ -1135,7 +1135,7 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
 	rt->rt6i_dst.addr = fl6->daddr;
 	rt->rt6i_dst.plen = 128;
 	rt->rt6i_idev     = idev;
-	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 255);
+	dst_metric_set(&rt->dst, RTAX_HOPLIMIT, 0);
 
 	spin_lock_bh(&icmp6_dst_lock);
 	rt->dst.next = icmp6_dst_gc_list;
-- 
1.7.9.5

