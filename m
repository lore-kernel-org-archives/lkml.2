Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2E0N7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 09:59:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47501 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab2E0N7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 09:59:49 -0400
Subject: Re: WARNING: at net/ipv4/tcp.c:1610 tcp_recvmsg+0xb1b/0xc70()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4FC0BCE1.6070601@fastmail.fm>
References: <4FBFEACC.8040601@fastmail.fm>
	 <1337978725.10135.0.camel@edumazet-glaptop>
	 <1337979331.10135.2.camel@edumazet-glaptop>  <4FC0BCE1.6070601@fastmail.fm>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 May 2012 15:59:44 +0200
Message-ID: <1338127184.3670.50.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 12:22 +0100, Jack Stone wrote:

> I'm still getting this with da89fb1 which includes the above
> 
> Linux hover1 3.4.0-07797-gda89fb1 #4 SMP Fri May 25 22:23:14 BST 2012 x86_64 x86_64 x86_64 GNU/Linux

Thanks

Could you add following debugging patch ?

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3ba605f..b56c63c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1606,8 +1606,9 @@ int tcp_recvmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 			if (tcp_hdr(skb)->fin)
 				goto found_fin_ok;
 			WARN(!(flags & MSG_PEEK),
-			     "recvmsg bug 2: copied %X seq %X rcvnxt %X fl %X\n",
-			     *seq, TCP_SKB_CB(skb)->seq, tp->rcv_nxt, flags);
+			     "recvmsg bug 2: copied %X seq %X end_seq %X rcvnxt %X fl %X offset %u len %u syn %d\n",
+			     *seq, TCP_SKB_CB(skb)->seq, TCP_SKB_CB(skb)->end_seq,
+			     tp->rcv_nxt, flags, offset, skb->len, tcp_hdr(skb)->syn);
 		}
 
 		/* Well, if we have backlog, try to process it now yet. */


