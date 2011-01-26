Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1AZUHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:07:47 -0500
Received: from www.tglx.de ([62.245.132.106]:44518 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab1AZUG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:06:29 -0500
Message-Id: <20110126195833.483520950@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 26 Jan 2011 20:05:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Howells <dhowells@redhat.com>,
        x86@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Chris Zankel <chris@zankel.net>
Subject: [patch 1/6] rwsem: Cleanup includes
References: <20110126195810.247325792@linutronix.de>
Content-Disposition: inline; filename=rwsem-cleanup-includes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All rwsem implementations include the same headers. Include them from
include/linux/rwsem.h

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/rwsem.h   |    4 ----
 arch/ia64/include/asm/rwsem.h    |    3 ---
 arch/powerpc/include/asm/rwsem.h |    5 -----
 arch/s390/include/asm/rwsem.h    |    5 -----
 arch/sh/include/asm/rwsem.h      |    5 -----
 arch/sparc/include/asm/rwsem.h   |    6 ------
 arch/x86/include/asm/rwsem.h     |    6 ------
 arch/xtensa/include/asm/rwsem.h  |    6 ------
 include/linux/rwsem-spinlock.h   |    8 --------
 include/linux/rwsem.h            |    3 +++
 10 files changed, 3 insertions(+), 48 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/rwsem.h
+++ linux-2.6/arch/alpha/include/asm/rwsem.h
@@ -13,10 +13,6 @@
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
 
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *sem);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *sem);
Index: linux-2.6/arch/ia64/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/rwsem.h
+++ linux-2.6/arch/ia64/include/asm/rwsem.h
@@ -25,9 +25,6 @@
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
 #include <asm/intrinsics.h>
 
 /*
Index: linux-2.6/arch/powerpc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/rwsem.h
+++ linux-2.6/arch/powerpc/include/asm/rwsem.h
@@ -13,11 +13,6 @@
  * by Paul Mackerras <paulus@samba.org>.
  */
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
 /*
  * the semaphore definition
  */
Index: linux-2.6/arch/s390/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/rwsem.h
+++ linux-2.6/arch/s390/include/asm/rwsem.h
@@ -43,11 +43,6 @@
 
 #ifdef __KERNEL__
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
-
 extern struct rw_semaphore *rwsem_down_read_failed(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_down_write_failed(struct rw_semaphore *);
 extern struct rw_semaphore *rwsem_wake(struct rw_semaphore *);
Index: linux-2.6/arch/sh/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sh/include/asm/rwsem.h
+++ linux-2.6/arch/sh/include/asm/rwsem.h
@@ -11,11 +11,6 @@
 #endif
 
 #ifdef __KERNEL__
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
 /*
  * the semaphore definition
  */
Index: linux-2.6/arch/sparc/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/rwsem.h
+++ linux-2.6/arch/sparc/include/asm/rwsem.h
@@ -12,12 +12,6 @@
 #endif
 
 #ifdef __KERNEL__
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-
-struct rwsem_waiter;
-
 struct rw_semaphore {
 	signed long			count;
 #define RWSEM_UNLOCKED_VALUE		0x00000000L
Index: linux-2.6/arch/x86/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/rwsem.h
+++ linux-2.6/arch/x86/include/asm/rwsem.h
@@ -37,14 +37,8 @@
 #endif
 
 #ifdef __KERNEL__
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/lockdep.h>
 #include <asm/asm.h>
 
-struct rwsem_waiter;
-
 extern asmregparm struct rw_semaphore *
  rwsem_down_read_failed(struct rw_semaphore *sem);
 extern asmregparm struct rw_semaphore *
Index: linux-2.6/arch/xtensa/include/asm/rwsem.h
===================================================================
--- linux-2.6.orig/arch/xtensa/include/asm/rwsem.h
+++ linux-2.6/arch/xtensa/include/asm/rwsem.h
@@ -16,12 +16,6 @@
 #ifndef _LINUX_RWSEM_H
 #error "Please don't include <asm/rwsem.h> directly, use <linux/rwsem.h> instead."
 #endif
-
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <asm/atomic.h>
-#include <asm/system.h>
-
 /*
  * the semaphore definition
  */
Index: linux-2.6/include/linux/rwsem-spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem-spinlock.h
+++ linux-2.6/include/linux/rwsem-spinlock.h
@@ -12,15 +12,7 @@
 #error "please don't include linux/rwsem-spinlock.h directly, use linux/rwsem.h instead"
 #endif
 
-#include <linux/spinlock.h>
-#include <linux/list.h>
-
 #ifdef __KERNEL__
-
-#include <linux/types.h>
-
-struct rwsem_waiter;
-
 /*
  * the rw-semaphore definition
  * - if activity is 0 then there are no active readers or writers
Index: linux-2.6/include/linux/rwsem.h
===================================================================
--- linux-2.6.orig/include/linux/rwsem.h
+++ linux-2.6/include/linux/rwsem.h
@@ -11,6 +11,9 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
 #include <asm/system.h>
 #include <asm/atomic.h>
 


