Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792Ab2BAVZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:25:42 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33584 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932668Ab2BAVTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:34 -0500
X-Sasl-enc: ZNbLe4yDvjQPwyRzvcsL1jp5+4OhMa1Fh7J55R0tMlia 1328131173
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:50 2012
Message-Id: <20120201210050.911189030@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, shawnlu <shawn.lu@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [80/89] tcp: md5: using remote adress for md5 lookup in rst packet
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: shawnlu <shawn.lu@ericsson.com>

[ Upstream commit 8a622e71f58ec9f092fc99eacae0e6cf14f6e742 ]

md5 key is added in socket through remote address.
remote address should be used in finding md5 key when
sending out reset packet.

Signed-off-by: shawnlu <shawn.lu@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    2 +-
 net/ipv6/tcp_ipv6.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -630,7 +630,7 @@ static void tcp_v4_send_reset(struct soc
 	arg.iov[0].iov_len  = sizeof(rep.th);
 
 #ifdef CONFIG_TCP_MD5SIG
-	key = sk ? tcp_v4_md5_do_lookup(sk, ip_hdr(skb)->daddr) : NULL;
+	key = sk ? tcp_v4_md5_do_lookup(sk, ip_hdr(skb)->saddr) : NULL;
 	if (key) {
 		rep.opt[0] = htonl((TCPOPT_NOP << 24) |
 				   (TCPOPT_NOP << 16) |
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1084,7 +1084,7 @@ static void tcp_v6_send_reset(struct soc
 
 #ifdef CONFIG_TCP_MD5SIG
 	if (sk)
-		key = tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->daddr);
+		key = tcp_v6_md5_do_lookup(sk, &ipv6_hdr(skb)->saddr);
 #endif
 
 	if (th->ack)


