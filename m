Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab1LPOPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:15:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759675Ab1LPOO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:14:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/7] AFS: Use new core assertion macros
To: linux-arch@vger.kernel.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 16 Dec 2011 14:14:49 +0000
Message-ID: <20111216141448.24668.82403.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
References: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make AFS use the new core assertion macros in place of its own.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h |   90 +----------------------------------------------------
 1 files changed, 2 insertions(+), 88 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index d2b0888..36989c0 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -20,6 +20,8 @@
 #include <linux/sched.h>
 #include <linux/fscache.h>
 #include <linux/backing-dev.h>
+#define ENABLE_ASSERTIONS
+#include <linux/assert.h>
 
 #include "afs.h"
 #include "afs_vl.h"
@@ -800,91 +802,3 @@ do {							\
 #define _leave(FMT,...)	no_printk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define _debug(FMT,...)	no_printk("    "FMT ,##__VA_ARGS__)
 #endif
-
-/*
- * debug assertion checking
- */
-#if 1 // defined(__KDEBUGALL)
-
-#define ASSERT(X)						\
-do {								\
-	if (unlikely(!(X))) {					\
-		printk(KERN_ERR "\n");				\
-		printk(KERN_ERR "AFS: Assertion failed\n");	\
-		BUG();						\
-	}							\
-} while(0)
-
-#define ASSERTCMP(X, OP, Y)						\
-do {									\
-	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "AFS: Assertion failed\n");		\
-		printk(KERN_ERR "%lu " #OP " %lu is false\n",		\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		printk(KERN_ERR "0x%lx " #OP " 0x%lx is false\n",	\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		BUG();							\
-	}								\
-} while(0)
-
-#define ASSERTRANGE(L, OP1, N, OP2, H)					\
-do {									\
-	if (unlikely(!((L) OP1 (N)) || !((N) OP2 (H)))) {		\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "AFS: Assertion failed\n");		\
-		printk(KERN_ERR "%lu "#OP1" %lu "#OP2" %lu is false\n",	\
-		       (unsigned long)(L), (unsigned long)(N),		\
-		       (unsigned long)(H));				\
-		printk(KERN_ERR "0x%lx "#OP1" 0x%lx "#OP2" 0x%lx is false\n", \
-		       (unsigned long)(L), (unsigned long)(N),		\
-		       (unsigned long)(H));				\
-		BUG();							\
-	}								\
-} while(0)
-
-#define ASSERTIF(C, X)						\
-do {								\
-	if (unlikely((C) && !(X))) {				\
-		printk(KERN_ERR "\n");				\
-		printk(KERN_ERR "AFS: Assertion failed\n");	\
-		BUG();						\
-	}							\
-} while(0)
-
-#define ASSERTIFCMP(C, X, OP, Y)					\
-do {									\
-	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "AFS: Assertion failed\n");		\
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
-#define ASSERTRANGE(L, OP1, N, OP2, H)		\
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

