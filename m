Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1HFAM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:12:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab1HFAMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:16 2011
Message-Id: <20110806000416.034830747@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:04:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [44/50] netns xfrm: fixup xfrm6_tunnel error propagation
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit e924960dacdf85d118a98c7262edf2f99c3015cf upstream.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/xfrm6_tunnel.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -353,13 +353,19 @@ static struct xfrm6_tunnel xfrm46_tunnel
 
 static int __init xfrm6_tunnel_init(void)
 {
-	if (xfrm_register_type(&xfrm6_tunnel_type, AF_INET6) < 0)
+	int rv;
+
+	rv = xfrm_register_type(&xfrm6_tunnel_type, AF_INET6);
+	if (rv < 0)
 		goto err;
-	if (xfrm6_tunnel_register(&xfrm6_tunnel_handler, AF_INET6))
+	rv = xfrm6_tunnel_register(&xfrm6_tunnel_handler, AF_INET6);
+	if (rv < 0)
 		goto unreg;
-	if (xfrm6_tunnel_register(&xfrm46_tunnel_handler, AF_INET))
+	rv = xfrm6_tunnel_register(&xfrm46_tunnel_handler, AF_INET);
+	if (rv < 0)
 		goto dereg6;
-	if (xfrm6_tunnel_spi_init() < 0)
+	rv = xfrm6_tunnel_spi_init();
+	if (rv < 0)
 		goto dereg46;
 	return 0;
 
@@ -370,7 +376,7 @@ dereg6:
 unreg:
 	xfrm_unregister_type(&xfrm6_tunnel_type, AF_INET6);
 err:
-	return -EAGAIN;
+	return rv;
 }
 
 static void __exit xfrm6_tunnel_fini(void)


