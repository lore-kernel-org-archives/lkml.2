Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab0G3Slj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:41:39 -0400
Received: from kroah.org ([198.145.64.141]:57836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759721Ab0G3RyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:34 2010
Message-Id: <20100730175134.672544666@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [012/205] tcp: use correct net ns in cookie_v4_check()
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit c44649216522cd607a4027d2ebf4a8147d3fa94c ]

Its better to make a route lookup in appropriate namespace.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/syncookies.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -347,7 +347,7 @@ struct sock *cookie_v4_check(struct sock
 					       { .sport = th->dest,
 						 .dport = th->source } } };
 		security_req_classify_flow(req, &fl);
-		if (ip_route_output_key(&init_net, &rt, &fl)) {
+		if (ip_route_output_key(sock_net(sk), &rt, &fl)) {
 			reqsk_free(req);
 			goto out;
 		}


