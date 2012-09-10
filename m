Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab2IJQNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:13:40 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:57822 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758035Ab2IJQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:13:37 -0400
Message-ID: <504E1193.4060809@xenotime.net>
Date: Mon, 10 Sep 2012 09:13:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: [PATCH -next] net: fix net/core/sock.c build error
References: <20120910172407.c5ad953c008165fcd862bd3c@canb.auug.org.au>
In-Reply-To: <20120910172407.c5ad953c008165fcd862bd3c@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix net/core/sock.c build error when CONFIG_INET is not enabled:

net/built-in.o: In function `sock_edemux':
(.text+0xd396): undefined reference to `inet_twsk_put'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 net/core/sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20120910.orig/net/core/sock.c
+++ linux-next-20120910/net/core/sock.c
@@ -1525,9 +1525,11 @@ void sock_edemux(struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;
 
+#ifdef CONFIG_INET
 	if (sk->sk_state == TCP_TIME_WAIT)
 		inet_twsk_put(inet_twsk(sk));
 	else
+#endif
 		sock_put(sk);
 }
 EXPORT_SYMBOL(sock_edemux);
