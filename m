Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826Ab1KJFIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:08:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934808Ab1KJD1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:27:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:14 2011
Message-Id: <20111109212714.505840026@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zheng Yan <zheng.z.yan@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [138/262] ipv4: fix ipsec forward performance regression
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

[ Upstream commit b73233960a59ee66e09d642f13d0592b13651e94 ]

There is bug in commit 5e2b61f(ipv4: Remove flowi from struct rtable).
It makes xfrm4_fill_dst() modify wrong data structure.

Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
Reported-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/xfrm4_policy.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -79,13 +79,13 @@ static int xfrm4_fill_dst(struct xfrm_ds
 	struct rtable *rt = (struct rtable *)xdst->route;
 	const struct flowi4 *fl4 = &fl->u.ip4;
 
-	rt->rt_key_dst = fl4->daddr;
-	rt->rt_key_src = fl4->saddr;
-	rt->rt_key_tos = fl4->flowi4_tos;
-	rt->rt_route_iif = fl4->flowi4_iif;
-	rt->rt_iif = fl4->flowi4_iif;
-	rt->rt_oif = fl4->flowi4_oif;
-	rt->rt_mark = fl4->flowi4_mark;
+	xdst->u.rt.rt_key_dst = fl4->daddr;
+	xdst->u.rt.rt_key_src = fl4->saddr;
+	xdst->u.rt.rt_key_tos = fl4->flowi4_tos;
+	xdst->u.rt.rt_route_iif = fl4->flowi4_iif;
+	xdst->u.rt.rt_iif = fl4->flowi4_iif;
+	xdst->u.rt.rt_oif = fl4->flowi4_oif;
+	xdst->u.rt.rt_mark = fl4->flowi4_mark;
 
 	xdst->u.dst.dev = dev;
 	dev_hold(dev);


