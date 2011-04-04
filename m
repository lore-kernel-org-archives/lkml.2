Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1DDT5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:57:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40765 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1DDT5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:57:19 -0400
From: Boris Ostrovsky <ostr@amd64.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>
Subject: [PATCH] ipv6: Don't pass invalid dst_entry pointer to dst_release().
Date: Mon,  4 Apr 2011 15:55:10 -0400
Message-Id: <1301946910-5530-1-git-send-email-ostr@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@amd.com>

Make sure dst_release() is not called with error pointer. This is
similar to commit 4910ac6c526d2868adcb5893e0c428473de862b5.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 net/ipv6/tcp_ipv6.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 2b0c186..56fa125 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -503,6 +503,7 @@ static int tcp_v6_send_synack(struct sock *sk, struct request_sock *req,
 	dst = ip6_dst_lookup_flow(sk, &fl6, final_p, false);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
+		dst = NULL;
 		goto done;
 	}
 	skb = tcp_make_synack(sk, dst, req, rvp);
-- 
1.7.1

