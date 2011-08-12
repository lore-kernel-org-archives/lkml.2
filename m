Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1HNQV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:21:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab1HNQI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:08:58 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:57 2011
Message-Id: <20110812210557.276382052@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [59/90] ipv4: use RT_TOS after some rt_tos conversions
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit b0fe4a31849063fcac0bdc93716ca92615e93f57 ]

rt_tos was changed to iph->tos but it must be filtered by RT_TOS

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/ipmr.c  |    2 +-
 net/ipv4/route.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1796,7 +1796,7 @@ static struct mr_table *ipmr_rt_fib_look
 	struct flowi4 fl4 = {
 		.daddr = iph->daddr,
 		.saddr = iph->saddr,
-		.flowi4_tos = iph->tos,
+		.flowi4_tos = RT_TOS(iph->tos),
 		.flowi4_oif = rt->rt_oif,
 		.flowi4_iif = rt->rt_iif,
 		.flowi4_mark = rt->rt_mark,
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1705,7 +1705,7 @@ void ip_rt_get_source(u8 *addr, struct s
 		memset(&fl4, 0, sizeof(fl4));
 		fl4.daddr = iph->daddr;
 		fl4.saddr = iph->saddr;
-		fl4.flowi4_tos = iph->tos;
+		fl4.flowi4_tos = RT_TOS(iph->tos);
 		fl4.flowi4_oif = rt->dst.dev->ifindex;
 		fl4.flowi4_iif = skb->dev->ifindex;
 		fl4.flowi4_mark = skb->mark;


