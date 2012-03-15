Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091Ab2COVDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161756Ab2COU75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:59:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/38] Make asm-generic/cmpxchg.h #include
 asm-generic/cmpxchg-local.h [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Date: Thu, 15 Mar 2012 20:59:49 +0000
Message-ID: <20120315205949.28759.66530.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make asm-generic/cmpxchg.h #include asm-generic/cmpxchg-local.h as all arch
files that #include the former also #include the latter.  See:

	grep -rl asm-generic/cmpxchg-local[.]h arch/ | sort > b
	grep -rl asm-generic/cmpxchg[.]h arch/ | sort > a
	comm a b

This simplifies the disintegration of asm-generic/system.h for arches that
don't have their own.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---

 include/asm-generic/atomic.h  |    2 ++
 include/asm-generic/cmpxchg.h |    2 ++
 include/asm-generic/system.h  |    1 -
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index e37963c..8b8cf94 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -15,6 +15,8 @@
 #ifndef __ASM_GENERIC_ATOMIC_H
 #define __ASM_GENERIC_ATOMIC_H
 
+#include <asm/cmpxchg.h>
+
 #ifdef CONFIG_SMP
 /* Force people to define core atomics */
 # if !defined(atomic_add_return) || !defined(atomic_sub_return) || \
diff --git a/include/asm-generic/cmpxchg.h b/include/asm-generic/cmpxchg.h
index 213ac6e..e0449af 100644
--- a/include/asm-generic/cmpxchg.h
+++ b/include/asm-generic/cmpxchg.h
@@ -10,6 +10,8 @@
 #error "Cannot use generic cmpxchg on SMP"
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
 /*
  * Atomic compare and exchange.
  *
diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index 215efa7..82cb53a 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <linux/irqflags.h>
 
-#include <asm/cmpxchg-local.h>
 #include <asm/cmpxchg.h>
 
 struct task_struct;

