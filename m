Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1JLQtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab1JLQtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:49:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/7] RxRPC: Use new core assertion macros
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 17:48:18 +0100
Message-ID: <20111012164818.539.48082.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
References: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make RxRPC use the new core assertion macros in place of its own.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |   71 +----------------------------------------------
 1 files changed, 2 insertions(+), 69 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 8e22bd3..b86fe78 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -10,6 +10,8 @@
  */
 
 #include <rxrpc/packet.h>
+#define ENABLE_ASSERTIONS
+#include <linux/assert.h>
 
 #if 0
 #define CHECK_SLAB_OKAY(X)				     \
@@ -657,75 +659,6 @@ do {							\
 #endif
 
 /*
- * debug assertion checking
- */
-#if 1 // defined(__KDEBUGALL)
-
-#define ASSERT(X)						\
-do {								\
-	if (unlikely(!(X))) {					\
-		printk(KERN_ERR "\n");				\
-		printk(KERN_ERR "RxRPC: Assertion failed\n");	\
-		BUG();						\
-	}							\
-} while(0)
-
-#define ASSERTCMP(X, OP, Y)						\
-do {									\
-	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "RxRPC: Assertion failed\n");		\
-		printk(KERN_ERR "%lu " #OP " %lu is false\n",		\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		printk(KERN_ERR "0x%lx " #OP " 0x%lx is false\n",	\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		BUG();							\
-	}								\
-} while(0)
-
-#define ASSERTIF(C, X)						\
-do {								\
-	if (unlikely((C) && !(X))) {				\
-		printk(KERN_ERR "\n");				\
-		printk(KERN_ERR "RxRPC: Assertion failed\n");	\
-		BUG();						\
-	}							\
-} while(0)
-
-#define ASSERTIFCMP(C, X, OP, Y)					\
-do {									\
-	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "RxRPC: Assertion failed\n");		\
-		printk(KERN_ERR "%lu " #OP " %lu is false\n",		\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		printk(KERN_ERR "0x%lx " #OP " 0x%lx is false\n",	\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		BUG();							\
-	}								\
-} while(0)
-
-#else
-
-#define ASSERT(X)				\
-do {						\
-} while(0)
-
-#define ASSERTCMP(X, OP, Y)			\
-do {						\
-} while(0)
-
-#define ASSERTIF(C, X)				\
-do {						\
-} while(0)
-
-#define ASSERTIFCMP(C, X, OP, Y)		\
-do {						\
-} while(0)
-
-#endif /* __KDEBUGALL */
-
-/*
  * socket buffer accounting / leak finding
  */
 static inline void __rxrpc_new_skb(struct sk_buff *skb, const char *fn)

