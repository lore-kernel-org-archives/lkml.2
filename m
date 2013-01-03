Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3ACMVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:21:35 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:51630 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3ACMUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:20:30 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH -v2 25/26] net: rename random32 to prandom
Date: Thu,  3 Jan 2013 21:19:21 +0900
Message-Id: <1357215562-6288-26-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 496f2f93b1cc286f5a4f4f9acdc1e5314978683f ("random32: rename
random32 to prandom") renamed random32() and srandom32() to prandom_u32()
and prandom_seed() respectively.

net_random() and net_srandom() need to be redefined with prandom_* in
order to finish the naming transition.

While I'm at it, enclose macro argument of net_srandom() with parenthesis.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---

* New patch from v2

 include/linux/net.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index aa16731..99c9f0c 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -240,8 +240,8 @@ do {								\
 #define net_dbg_ratelimited(fmt, ...)				\
 	net_ratelimited_function(pr_debug, fmt, ##__VA_ARGS__)
 
-#define net_random()		random32()
-#define net_srandom(seed)	srandom32((__force u32)seed)
+#define net_random()		prandom_u32()
+#define net_srandom(seed)	prandom_seed((__force u32)(seed))
 
 extern int   	     kernel_sendmsg(struct socket *sock, struct msghdr *msg,
 				    struct kvec *vec, size_t num, size_t len);
-- 
1.7.11.7

