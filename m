Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1GIGDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:03:54 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38837 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145Ab1GIGBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:24 -0400
X-Sasl-enc: RWWWFpFk7CzHI1+t3m2v0DIMOa4MkwWODLYlTrc1Ewmb 1310191283
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:12 2011
Message-Id: <20110708230112.759695067@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcus Meissner <meissner@suse.de>, Reinhard Max <max@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [32/35] net/ipv4: Check for mistakenly passed in non-IPv4 address
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Marcus Meissner <meissner@suse.de>

[ Upstream commit d0733d2e29b652b2e7b1438ececa732e4eed98eb ]

Check against mistakenly passing in IPv6 addresses (which would result
in an INADDR_ANY bind) or similar incompatible sockaddrs.

Signed-off-by: Marcus Meissner <meissner@suse.de>
Cc: Reinhard Max <max@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/af_inet.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -461,6 +461,9 @@ int inet_bind(struct socket *sock, struc
 	if (addr_len < sizeof(struct sockaddr_in))
 		goto out;
 
+	if (addr->sin_family != AF_INET)
+		goto out;
+
 	chk_addr_ret = inet_addr_type(sock_net(sk), addr->sin_addr.s_addr);
 
 	/* Not specified by any standard per-se, however it breaks too


