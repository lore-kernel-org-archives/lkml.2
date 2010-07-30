Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab0G3S41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:56:27 -0400
Received: from kroah.org ([198.145.64.141]:35464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798Ab0G3Rd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:33:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:03 2010
Message-Id: <20100730173103.686440327@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [010/140] tcp: use correct net ns in cookie_v4_check()
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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


