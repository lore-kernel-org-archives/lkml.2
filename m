Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2JZAL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:11:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:54126 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab2JZAIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [ 74/85] ipv4: fix forwarding for strict source routes
Date: Thu, 25 Oct 2012 17:06:32 -0700
Message-Id: <20121026000038.553161820@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit e0adef0f7456d5d3a3bfe8ea61c7dddf146b40e1 ]

After the change "Adjust semantics of rt->rt_gateway"
(commit f8126f1d51) rt_gateway can be 0 but ip_forward() compares
it directly with nexthop. What we want here is to check if traffic
is to directly connected nexthop and to fail if using gateway.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_forward.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -85,7 +85,7 @@ int ip_forward(struct sk_buff *skb)
 
 	rt = skb_rtable(skb);
 
-	if (opt->is_strictroute && opt->nexthop != rt->rt_gateway)
+	if (opt->is_strictroute && rt->rt_gateway)
 		goto sr_failed;
 
 	if (unlikely(skb->len > dst_mtu(&rt->dst) && !skb_is_gso(skb) &&


