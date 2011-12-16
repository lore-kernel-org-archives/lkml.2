Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804Ab1LPOPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:15:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1LPOPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:15:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 7/7] RxRPC: Use new core assertion macros
To: linux-arch@vger.kernel.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 16 Dec 2011 14:14:59 +0000
Message-ID: <20111216141459.24668.91001.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
References: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
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

