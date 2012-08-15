Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2HOVfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:35:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52155 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2HOVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:33:12 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        James Chapman <jchapman@katalix.com>
Subject: [PATCH 09/14] l2tp: fix info leak via getsockname()
Date: Wed, 15 Aug 2012 23:31:52 +0200
Message-Id: <1345066317-22512-10-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
References: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The L2TP code for IPv6 fails to initialize the l2tp_unused member of
struct sockaddr_l2tpip6 and that for leaks two bytes kernel stack via
the getsockname() syscall. Initialize l2tp_unused with 0 to avoid the
info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: James Chapman <jchapman@katalix.com>
---
 net/l2tp/l2tp_ip6.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 35e1e4b..9275471 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -410,6 +410,7 @@ static int l2tp_ip6_getname(struct socket *sock, struct sockaddr *uaddr,
 	lsa->l2tp_family = AF_INET6;
 	lsa->l2tp_flowinfo = 0;
 	lsa->l2tp_scope_id = 0;
+	lsa->l2tp_unused = 0;
 	if (peer) {
 		if (!lsk->peer_conn_id)
 			return -ENOTCONN;
-- 
1.7.10.4

