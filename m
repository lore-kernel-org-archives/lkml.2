Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab2BEWhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:37:47 -0500
Received: from 1wt.eu ([62.212.114.60]:62087 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2BEW0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:55 -0500
Message-Id: <20120205220953.002657616@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Marcus Meissner <meissner@suse.de>, Reinhard Max <max@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 83/91] net/ipv4: Check for mistakenly passed in non-IPv4 address
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

[ Upstream commit d0733d2e29b652b2e7b1438ececa732e4eed98eb ]

Check against mistakenly passing in IPv6 addresses (which would result
in an INADDR_ANY bind) or similar incompatible sockaddrs.

Signed-off-by: Marcus Meissner <meissner@suse.de>
Cc: Reinhard Max <max@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/af_inet.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/net/ipv4/af_inet.c
===================================================================
--- longterm-2.6.27.orig/net/ipv4/af_inet.c	2012-02-05 22:34:32.462915223 +0100
+++ longterm-2.6.27/net/ipv4/af_inet.c	2012-02-05 22:34:46.727915859 +0100
@@ -458,6 +458,9 @@
 	if (addr_len < sizeof(struct sockaddr_in))
 		goto out;
 
+	if (addr->sin_family != AF_INET)
+		goto out;
+
 	chk_addr_ret = inet_addr_type(sock_net(sk), addr->sin_addr.s_addr);
 
 	/* Not specified by any standard per-se, however it breaks too


