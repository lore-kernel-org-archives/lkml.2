Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab0EJWyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:54:17 -0400
Received: from kroah.org ([198.145.64.141]:33321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab0EJWwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:44 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:25 2010
Message-Id: <20100510223325.064561622@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.hengli.com.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [085/117] ipv6: Fix tcp_v6_send_response transport header setting.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 6651ffc8e8bdd5fb4b7d1867c6cfebb4f309512c ]

My recent patch to remove the open-coded checksum sequence in
tcp_v6_send_response broke it as we did not set the transport
header pointer on the new packet.

Actually, there is code there trying to set the transport
header properly, but it sets it for the wrong skb ('skb'
instead of 'buff').

This bug was introduced by commit
a8fdf2b331b38d61fb5f11f3aec4a4f9fb2dedcb ("ipv6: Fix
tcp_v6_send_response(): it didn't set skb transport header")

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv6/tcp_ipv6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1006,7 +1006,7 @@ static void tcp_v6_send_response(struct
 	skb_reserve(buff, MAX_HEADER + sizeof(struct ipv6hdr) + tot_len);
 
 	t1 = (struct tcphdr *) skb_push(buff, tot_len);
-	skb_reset_transport_header(skb);
+	skb_reset_transport_header(buff);
 
 	/* Swap the send and the receive. */
 	memset(t1, 0, sizeof(*t1));


