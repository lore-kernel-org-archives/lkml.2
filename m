Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab2JAXTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:19:15 -0400
Received: from 1wt.eu ([62.212.114.60]:35423 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941Ab2JAXBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:44 -0400
Message-Id: <20121001225203.630763715@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 142/180] tcp: drop SYN+FIN messages
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit fdf5af0daf8019cec2396cdef8fb042d80fe71fa upstream.

Denys Fedoryshchenko reported that SYN+FIN attacks were bringing his
linux machines to their limits.

Dont call conn_request() if the TCP flags includes SYN flag

Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/tcp_input.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4b148e5..db755c4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5634,6 +5634,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 			goto discard;
 
 		if (th->syn) {
+			if (th->fin)
+				goto discard;
 			if (icsk->icsk_af_ops->conn_request(sk, skb) < 0)
 				return 1;
 
-- 
1.7.2.1.45.g54fbc



