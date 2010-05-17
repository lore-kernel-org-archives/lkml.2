Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab0EQEiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 00:38:19 -0400
Received: from ozlabs.org ([203.10.76.45]:56168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0EQEiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 00:38:00 -0400
Date: Mon, 17 May 2010 14:33:53 +1000
From: Anton Blanchard <anton@samba.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       willy@linux.intel.com, benh@kernel.crashing.org, paulus@samba.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2]: atomic_t: Cast to volatile when accessing atomic
 variables
Message-ID: <20100517043353.GA22127@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In preparation for removing volatile from the atomic_t definition, this
patch adds a volatile cast to all the atomic read functions.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

I did my best to fix every architecture, but I'd appreciate it if arch
maintainers could double check this catches everything.

Index: linux-cpumask/arch/alpha/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/alpha/include/asm/atomic.h	2010-04-08 19:46:03.177952918 +1000
+++ linux-cpumask/arch/alpha/include/asm/atomic.h	2010-05-17 13:21:55.353455034 +1000
@@ -17,8 +17,8 @@
 #define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
 #define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
 
-#define atomic_read(v)		((v)->counter + 0)
-#define atomic64_read(v)	((v)->counter + 0)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
 
 #define atomic_set(v,i)		((v)->counter = (i))
 #define atomic64_set(v,i)	((v)->counter = (i))
Index: linux-cpumask/arch/arm/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/arm/include/asm/atomic.h	2010-04-08 19:46:03.197946415 +1000
+++ linux-cpumask/arch/arm/include/asm/atomic.h	2010-05-17 13:21:55.364704766 +1000
@@ -24,7 +24,7 @@
  * strex/ldrex monitor on some implementations. The reason we can use it for
  * atomic_set() is the clrex or dummy strex done on every exception return.
  */
-#define atomic_read(v)	((v)->counter)
+#define atomic_read(v)	(*(volatile int *)&(v)->counter)
 #define atomic_set(v,i)	(((v)->counter) = (i))
 
 #if __LINUX_ARM_ARCH__ >= 6
Index: linux-cpumask/arch/avr32/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/avr32/include/asm/atomic.h	2010-04-08 19:46:03.167946279 +1000
+++ linux-cpumask/arch/avr32/include/asm/atomic.h	2010-05-17 13:21:55.384708819 +1000
@@ -19,7 +19,7 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 /*
Index: linux-cpumask/arch/cris/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/cris/include/asm/atomic.h	2010-04-08 19:46:03.147945641 +1000
+++ linux-cpumask/arch/cris/include/asm/atomic.h	2010-05-17 13:21:55.404706041 +1000
@@ -15,7 +15,7 @@
 
 #define ATOMIC_INIT(i)  { (i) }
 
-#define atomic_read(v) ((v)->counter)
+#define atomic_read(v) (*(volatile int *)&(v)->counter)
 #define atomic_set(v,i) (((v)->counter) = (i))
 
 /* These should be written in asm but we do it in C for now. */
Index: linux-cpumask/arch/frv/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/frv/include/asm/atomic.h	2010-04-08 19:46:03.397951974 +1000
+++ linux-cpumask/arch/frv/include/asm/atomic.h	2010-05-17 13:21:55.424704874 +1000
@@ -36,7 +36,7 @@
 #define smp_mb__after_atomic_inc()	barrier()
 
 #define ATOMIC_INIT(i)		{ (i) }
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = (i))
 
 #ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
Index: linux-cpumask/arch/h8300/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/h8300/include/asm/atomic.h	2010-04-08 19:46:03.237946283 +1000
+++ linux-cpumask/arch/h8300/include/asm/atomic.h	2010-05-17 13:21:55.445954164 +1000
@@ -10,7 +10,7 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 #include <asm/system.h>
Index: linux-cpumask/arch/ia64/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/ia64/include/asm/atomic.h	2010-04-08 19:46:03.207982670 +1000
+++ linux-cpumask/arch/ia64/include/asm/atomic.h	2010-05-17 13:21:55.453760038 +1000
@@ -21,8 +21,8 @@
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
 #define ATOMIC64_INIT(i)	((atomic64_t) { (i) })
 
-#define atomic_read(v)		((v)->counter)
-#define atomic64_read(v)	((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
 
 #define atomic_set(v,i)		(((v)->counter) = (i))
 #define atomic64_set(v,i)	(((v)->counter) = (i))
Index: linux-cpumask/arch/m32r/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/m32r/include/asm/atomic.h	2010-04-08 19:46:03.377953123 +1000
+++ linux-cpumask/arch/m32r/include/asm/atomic.h	2010-05-17 13:21:55.464742675 +1000
@@ -26,7 +26,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)	((v)->counter)
+#define atomic_read(v)	(*(volatile int *)&(v)->counter)
 
 /**
  * atomic_set - set atomic variable
Index: linux-cpumask/arch/m68k/include/asm/atomic_mm.h
===================================================================
--- linux-cpumask.orig/arch/m68k/include/asm/atomic_mm.h	2010-05-05 23:02:20.013473674 +1000
+++ linux-cpumask/arch/m68k/include/asm/atomic_mm.h	2010-05-17 13:21:55.485966391 +1000
@@ -15,7 +15,7 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 static inline void atomic_add(int i, atomic_t *v)
Index: linux-cpumask/arch/m68k/include/asm/atomic_no.h
===================================================================
--- linux-cpumask.orig/arch/m68k/include/asm/atomic_no.h	2010-04-08 19:46:03.277950527 +1000
+++ linux-cpumask/arch/m68k/include/asm/atomic_no.h	2010-05-17 13:21:55.485966391 +1000
@@ -15,7 +15,7 @@
 
 #define ATOMIC_INIT(i)	{ (i) }
 
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
 static __inline__ void atomic_add(int i, atomic_t *v)
Index: linux-cpumask/arch/mips/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/mips/include/asm/atomic.h	2010-04-08 19:46:03.337946398 +1000
+++ linux-cpumask/arch/mips/include/asm/atomic.h	2010-05-17 13:21:55.523485056 +1000
@@ -29,7 +29,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 
 /*
  * atomic_set - set atomic variable
@@ -410,7 +410,7 @@ static __inline__ int atomic_add_unless(
  * @v: pointer of type atomic64_t
  *
  */
-#define atomic64_read(v)	((v)->counter)
+#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
 
 /*
  * atomic64_set - set atomic variable
Index: linux-cpumask/arch/mn10300/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/mn10300/include/asm/atomic.h	2010-04-08 19:46:03.327946770 +1000
+++ linux-cpumask/arch/mn10300/include/asm/atomic.h	2010-05-17 13:21:55.613465776 +1000
@@ -31,7 +31,7 @@
  * Atomically reads the value of @v.  Note that the guaranteed
  * useful range of an atomic_t is only 24 bits.
  */
-#define atomic_read(v)	((v)->counter)
+#define atomic_read(v)	(*(volatile int *)&(v)->counter)
 
 /**
  * atomic_set - set atomic variable
Index: linux-cpumask/arch/parisc/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/parisc/include/asm/atomic.h	2010-04-08 19:46:03.347946599 +1000
+++ linux-cpumask/arch/parisc/include/asm/atomic.h	2010-05-17 13:21:55.643453602 +1000
@@ -189,7 +189,7 @@ static __inline__ void atomic_set(atomic
 
 static __inline__ int atomic_read(const atomic_t *v)
 {
-	return v->counter;
+	return (*(volatile int *)&(v)->counter);
 }
 
 /* exported interface */
@@ -286,7 +286,7 @@ atomic64_set(atomic64_t *v, s64 i)
 static __inline__ s64
 atomic64_read(const atomic64_t *v)
 {
-	return v->counter;
+	return (*(volatile long *)&(v)->counter);
 }
 
 #define atomic64_add(i,v)	((void)(__atomic64_add_return( ((s64)(i)),(v))))
Index: linux-cpumask/arch/x86/include/asm/atomic64_64.h
===================================================================
--- linux-cpumask.orig/arch/x86/include/asm/atomic64_64.h	2010-04-08 19:46:03.297951878 +1000
+++ linux-cpumask/arch/x86/include/asm/atomic64_64.h	2010-05-17 13:21:55.673453935 +1000
@@ -18,7 +18,7 @@
  */
 static inline long atomic64_read(const atomic64_t *v)
 {
-	return v->counter;
+	return (*(volatile long *)&(v)->counter);
 }
 
 /**
Index: linux-cpumask/arch/sh/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/sh/include/asm/atomic.h	2010-04-08 19:46:03.227947464 +1000
+++ linux-cpumask/arch/sh/include/asm/atomic.h	2010-05-17 13:21:55.703454497 +1000
@@ -13,7 +13,7 @@
 
 #define ATOMIC_INIT(i)	( (atomic_t) { (i) } )
 
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v,i)		((v)->counter = (i))
 
 #if defined(CONFIG_GUSA_RB)
Index: linux-cpumask/arch/sparc/include/asm/atomic_32.h
===================================================================
--- linux-cpumask.orig/arch/sparc/include/asm/atomic_32.h	2010-04-08 19:46:03.247946656 +1000
+++ linux-cpumask/arch/sparc/include/asm/atomic_32.h	2010-05-17 13:21:55.723453281 +1000
@@ -25,7 +25,7 @@ extern int atomic_cmpxchg(atomic_t *, in
 extern int atomic_add_unless(atomic_t *, int, int);
 extern void atomic_set(atomic_t *, int);
 
-#define atomic_read(v)          ((v)->counter)
+#define atomic_read(v)          (*(volatile int *)&(v)->counter)
 
 #define atomic_add(i, v)	((void)__atomic_add_return( (int)(i), (v)))
 #define atomic_sub(i, v)	((void)__atomic_add_return(-(int)(i), (v)))
Index: linux-cpumask/arch/sparc/include/asm/atomic_64.h
===================================================================
--- linux-cpumask.orig/arch/sparc/include/asm/atomic_64.h	2010-04-08 19:46:03.257945857 +1000
+++ linux-cpumask/arch/sparc/include/asm/atomic_64.h	2010-05-17 13:21:55.743456221 +1000
@@ -13,8 +13,8 @@
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
 
-#define atomic_read(v)		((v)->counter)
-#define atomic64_read(v)	((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
+#define atomic64_read(v)	(*(volatile long *)&(v)->counter)
 
 #define atomic_set(v, i)	(((v)->counter) = i)
 #define atomic64_set(v, i)	(((v)->counter) = i)
Index: linux-cpumask/arch/x86/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/x86/include/asm/atomic.h	2010-04-08 19:46:03.307951966 +1000
+++ linux-cpumask/arch/x86/include/asm/atomic.h	2010-05-17 13:21:55.743456221 +1000
@@ -22,7 +22,7 @@
  */
 static inline int atomic_read(const atomic_t *v)
 {
-	return v->counter;
+	return (*(volatile int *)&(v)->counter);
 }
 
 /**
Index: linux-cpumask/arch/xtensa/include/asm/atomic.h
===================================================================
--- linux-cpumask.orig/arch/xtensa/include/asm/atomic.h	2010-04-08 19:46:03.367946559 +1000
+++ linux-cpumask/arch/xtensa/include/asm/atomic.h	2010-05-17 13:21:55.753456882 +1000
@@ -46,7 +46,7 @@
  *
  * Atomically reads the value of @v.
  */
-#define atomic_read(v)		((v)->counter)
+#define atomic_read(v)		(*(volatile int *)&(v)->counter)
 
 /**
  * atomic_set - set atomic variable
Index: linux-cpumask/include/asm-generic/atomic.h
===================================================================
--- linux-cpumask.orig/include/asm-generic/atomic.h	2010-04-08 19:46:03.137946549 +1000
+++ linux-cpumask/include/asm-generic/atomic.h	2010-05-17 13:21:55.773453759 +1000
@@ -33,7 +33,7 @@
  * Atomically reads the value of @v.  Note that the guaranteed
  * useful range of an atomic_t is only 24 bits.
  */
-#define atomic_read(v)	((v)->counter)
+#define atomic_read(v)	(*(volatile int *)&(v)->counter)
 
 /**
  * atomic_set - set atomic variable
