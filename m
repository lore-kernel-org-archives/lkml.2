Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2JGXnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:43:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38266 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766Ab2JGXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:13 -0400
Message-Id: <20121007225847.978083470@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>, Dave Jones <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 096/108] net: guard tcp_set_keepalive() to tcp sockets
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3e10986d1d698140747fcfc2761ec9cb64c1d582 ]

Its possible to use RAW sockets to get a crash in
tcp_set_keepalive() / sk_reset_timer()

Fix is to make sure socket is a SOCK_STREAM one.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 018fd41..1e8a882 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -593,7 +593,8 @@ set_rcvbuf:
 
 	case SO_KEEPALIVE:
 #ifdef CONFIG_INET
-		if (sk->sk_protocol == IPPROTO_TCP)
+		if (sk->sk_protocol == IPPROTO_TCP &&
+		    sk->sk_type == SOCK_STREAM)
 			tcp_set_keepalive(sk, valbool);
 #endif
 		sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);


