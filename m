Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062Ab2JKBXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:23:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52309 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934022Ab2JKBUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:20:32 -0400
X-Sasl-enc: HsO62tpOR4opn3eAo2USto3YY46/Hv4hzl4jFqaXX5h+ 1349918430
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dave Jones <davej@redhat.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 047/120] net: guard tcp_set_keepalive() to tcp sockets
Date: Thu, 11 Oct 2012 09:59:59 +0900
Message-Id: <20121011005834.179031944@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3e10986d1d698140747fcfc2761ec9cb64c1d582 ]

Its possible to use RAW sockets to get a crash in
tcp_set_keepalive() / sk_reset_timer()

Fix is to make sure socket is a SOCK_STREAM one.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -644,7 +644,8 @@ set_rcvbuf:
 
 	case SO_KEEPALIVE:
 #ifdef CONFIG_INET
-		if (sk->sk_protocol == IPPROTO_TCP)
+		if (sk->sk_protocol == IPPROTO_TCP &&
+		    sk->sk_type == SOCK_STREAM)
 			tcp_set_keepalive(sk, valbool);
 #endif
 		sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);


