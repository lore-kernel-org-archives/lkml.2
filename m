Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2LXCQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:16:14 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50088 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab2LXCPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:15:34 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 29/29] remove unused net_random(), net_srandom(), random32(), and srandom32()
Date: Mon, 24 Dec 2012 11:14:16 +0900
Message-Id: <1356315256-6572-30-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After finishing a naming transition, remove unused backward
compatibility wrapper macros

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 include/linux/net.h    | 3 ---
 include/linux/random.h | 7 -------
 2 files changed, 10 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index aa16731..937e2bf 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -240,9 +240,6 @@ do {								\
 #define net_dbg_ratelimited(fmt, ...)				\
 	net_ratelimited_function(pr_debug, fmt, ##__VA_ARGS__)
 
-#define net_random()		random32()
-#define net_srandom(seed)	srandom32((__force u32)seed)
-
 extern int   	     kernel_sendmsg(struct socket *sock, struct msghdr *msg,
 				    struct kvec *vec, size_t num, size_t len);
 extern int   	     kernel_recvmsg(struct socket *sock, struct msghdr *msg,
diff --git a/include/linux/random.h b/include/linux/random.h
index d984608..2ae2840 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -29,13 +29,6 @@ u32 prandom_u32(void);
 void prandom_bytes(void *buf, int nbytes);
 void prandom_seed(u32 seed);
 
-/*
- * These macros are preserved for backward compatibility and should be
- * removed as soon as a transition is finished.
- */
-#define random32() prandom_u32()
-#define srandom32(seed) prandom_seed(seed)
-
 u32 prandom_u32_state(struct rnd_state *);
 void prandom_bytes_state(struct rnd_state *state, void *buf, int nbytes);
 
-- 
1.7.11.7

