Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab0G3Smm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:42:42 -0400
Received: from kroah.org ([198.145.64.141]:57797 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759685Ab0G3RyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:11 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:34 2010
Message-Id: <20100730175134.222598795@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Brian Haley <brian.haley@hp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [007/205] IPv6: fix Mobile IPv6 regression
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Brian Haley <brian.haley@hp.com>

[ Upstream commit 6057fd78a8dcce6269f029b967051d5a2e9b0895 ]

Commit f4f914b5 (net: ipv6 bind to device issue) caused
a regression with Mobile IPv6 when it changed the meaning
of fl->oif to become a strict requirement of the route
lookup.  Instead, only force strict mode when
sk->sk_bound_dev_if is set on the calling socket, getting
the intended behavior and fixing the regression.

Tested-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Brian Haley <brian.haley@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/route.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -815,7 +815,7 @@ struct dst_entry * ip6_route_output(stru
 {
 	int flags = 0;
 
-	if (fl->oif || rt6_need_strict(&fl->fl6_dst))
+	if ((sk && sk->sk_bound_dev_if) || rt6_need_strict(&fl->fl6_dst))
 		flags |= RT6_LOOKUP_F_IFACE;
 
 	if (!ipv6_addr_any(&fl->fl6_src))


