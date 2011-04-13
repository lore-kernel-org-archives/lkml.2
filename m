Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab1DMQNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:42 -0400
Received: from kroah.org ([198.145.64.141]:53070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970Ab1DMQNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:49 2011
Message-Id: <20110413161049.297208227@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: [64/71] net: tipc: fix information leak to userland
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -395,6 +395,7 @@ static int get_name(struct socket *sock,
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
 	struct tipc_sock *tsock = tipc_sk(sock->sk);
 
+	memset(addr, 0, sizeof(*addr));
 	if (peer) {
 		if ((sock->state != SS_CONNECTED) &&
 			((peer != 2) || (sock->state != SS_DISCONNECTING)))


