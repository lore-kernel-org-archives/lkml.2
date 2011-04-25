Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648Ab1DYUfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:35:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34531 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414Ab1DYUZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:18 -0400
Message-Id: <20110425200239.684847903@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 154/173] net: tipc: fix information leak to userland
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kulikov Vasiliy <segooon@gmail.com>

commit 88f8a5e3e7defccd3925cabb1ee4d3994e5cdb52 upstream.

Structure sockaddr_tipc is copied to userland with padding bytes after
"id" field in union field "name" unitialized.  It leads to leaking of
contents of kernel stack memory.  We have to initialize them to zero.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/tipc/socket.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -393,6 +393,7 @@ static int get_name(struct socket *sock,
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	struct tipc_sock *tsock = tipc_sk(sock->sk);
 
+	memset(addr, 0, sizeof(*addr));
 	if (peer) {
 		if ((sock->state != SS_CONNECTED) &&
 			((peer != 2) || (sock->state != SS_DISCONNECTING)))


