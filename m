Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1JLQtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:49:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab1JLQtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:49:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/7] CacheFiles: Use new core assertion macros
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 17:47:58 +0100
Message-ID: <20111012164758.539.36637.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
References: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make CacheFiles use the new core assertion macros in place of its own.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/internal.h |   53 ++--------------------------------------------
 1 files changed, 2 insertions(+), 51 deletions(-)

diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index 4938251..0b99c9e 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -14,6 +14,8 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
+#define ENABLE_ASSERTIONS
+#include <linux/assert.h>
 
 struct cachefiles_cache;
 struct cachefiles_object;
@@ -303,54 +305,3 @@ do {							\
 #define _leave(FMT, ...) no_printk("<== %s()"FMT"", __func__, ##__VA_ARGS__)
 #define _debug(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 #endif
-
-#if 1 /* defined(__KDEBUGALL) */
-
-#define ASSERT(X)							\
-do {									\
-	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		BUG();							\
-	}								\
-} while (0)
-
-#define ASSERTCMP(X, OP, Y)						\
-do {									\
-	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		BUG();							\
-	}								\
-} while (0)
-
-#define ASSERTIF(C, X)							\
-do {									\
-	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		BUG();							\
-	}								\
-} while (0)
-
-#define ASSERTIFCMP(C, X, OP, Y)					\
-do {									\
-	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
-		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
-		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
-		       (unsigned long)(X), (unsigned long)(Y));		\
-		BUG();							\
-	}								\
-} while (0)
-
-#else
-
-#define ASSERT(X)			do {} while (0)
-#define ASSERTCMP(X, OP, Y)		do {} while (0)
-#define ASSERTIF(C, X)			do {} while (0)
-#define ASSERTIFCMP(C, X, OP, Y)	do {} while (0)
-
-#endif

