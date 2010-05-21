Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0EUOV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:21:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:53604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab0EUOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:20:47 -0400
Message-Id: <20100521135944.884367426@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 15:42:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH 1/4] arch: local64_t
References: <20100521134205.781916350@chello.nl>
Content-Disposition: inline; filename=local64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements local64_t.

On 64bit, local_t is of size long, and thus we make local64_t an alias.
On 32bit, we fall back to atomic64_t.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-arch@vger.kernel.org
LKML-Reference: <new-submission>
---
 arch/alpha/include/asm/local64.h      |    1 
 arch/arm/include/asm/local64.h        |    1 
 arch/avr32/include/asm/local64.h      |    1 
 arch/blackfin/include/asm/local64.h   |    1 
 arch/cris/include/asm/local64.h       |    1 
 arch/frv/include/asm/local64.h        |    1 
 arch/frv/kernel/local64.h             |    1 
 arch/h8300/include/asm/local64.h      |    1 
 arch/ia64/include/asm/local64.h       |    1 
 arch/m32r/include/asm/local64.h       |    1 
 arch/m68k/include/asm/local64.h       |    1 
 arch/microblaze/include/asm/local64.h |    1 
 arch/mips/include/asm/local64.h       |    1 
 arch/mn10300/include/asm/local64.h    |    1 
 arch/parisc/include/asm/local64.h     |    1 
 arch/powerpc/include/asm/local64.h    |    1 
 arch/s390/include/asm/local64.h       |    1 
 arch/score/include/asm/local64.h      |    1 
 arch/sh/include/asm/local64.h         |    1 
 arch/sparc/include/asm/local64.h      |    1 
 arch/x86/include/asm/local64.h        |    1 
 arch/xtensa/include/asm/local64.h     |    1 
 include/asm-generic/local64.h         |   96 ++++++++++++++++++++++++++++++++++
 23 files changed, 118 insertions(+)

Index: linux-2.6/arch/alpha/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/alpha/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/arm/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/arm/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/avr32/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/avr32/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/blackfin/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/blackfin/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/cris/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/cris/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/frv/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/frv/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/frv/kernel/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/frv/kernel/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/h8300/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/h8300/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/ia64/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/ia64/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/m32r/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/m32r/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/m68k/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/m68k/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/microblaze/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/microblaze/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/mips/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/mips/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/mn10300/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/mn10300/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/parisc/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/parisc/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/powerpc/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/powerpc/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/s390/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/s390/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/score/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/score/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/sh/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/sh/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/sparc/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/sparc/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/x86/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/arch/xtensa/include/asm/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/xtensa/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
Index: linux-2.6/include/asm-generic/local64.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/local64.h
@@ -0,0 +1,96 @@
+#ifndef _ASM_GENERIC_LOCAL64_H
+#define _ASM_GENERIC_LOCAL64_H
+
+#include <linux/percpu.h>
+#include <asm/types.h>
+
+/*
+ * A signed long type for operations which are atomic for a single CPU.
+ * Usually used in combination with per-cpu variables.
+ *
+ * This is the default implementation, which uses atomic64_t.  Which is
+ * rather pointless.  The whole point behind local64_t is that some processors
+ * can perform atomic adds and subtracts in a manner which is atomic wrt IRQs
+ * running on this CPU.  local64_t allows exploitation of such capabilities.
+ */
+
+/* Implement in terms of atomics. */
+
+#if BITS_PER_LONG == 64
+
+#include <asm/local.h>
+
+typedef struct {
+	local_t a;
+} local64_t;
+
+#define LOCAL64_INIT(i)	{ LOCAL_INIT(i) }
+
+#define local64_read(l)		local_read(&(l)->a)
+#define local64_set(l,i)	local_set((&(l)->a),(i))
+#define local64_inc(l)		local_inc(&(l)->a)
+#define local64_dec(l)		local_dec(&(l)->a)
+#define local64_add(i,l)	local_add((i),(&(l)->a))
+#define local64_sub(i,l)	local_sub((i),(&(l)->a))
+
+#define local64_sub_and_test(i, l) local_sub_and_test((i), (&(l)->a))
+#define local64_dec_and_test(l) local_dec_and_test(&(l)->a)
+#define local64_inc_and_test(l) local_inc_and_test(&(l)->a)
+#define local64_add_negative(i, l) local_add_negative((i), (&(l)->a))
+#define local64_add_return(i, l) local_add_return((i), (&(l)->a))
+#define local64_sub_return(i, l) local_sub_return((i), (&(l)->a))
+#define local64_inc_return(l)	local_inc_return(&(l)->a)
+
+#define local64_cmpxchg(l, o, n) local_cmpxchg((&(l)->a), (o), (n))
+#define local64_xchg(l, n)	local_xchg((&(l)->a), (n))
+#define local64_add_unless(l, _a, u) local_add_unless((&(l)->a), (_a), (u))
+#define local64_inc_not_zero(l)	local_inc_not_zero(&(l)->a)
+
+/* Non-atomic variants, ie. preemption disabled and won't be touched
+ * in interrupt, etc.  Some archs can optimize this case well. */
+#define __local64_inc(l)	local64_set((l), local64_read(l) + 1)
+#define __local64_dec(l)	local64_set((l), local64_read(l) - 1)
+#define __local64_add(i,l)	local64_set((l), local64_read(l) + (i))
+#define __local64_sub(i,l)	local64_set((l), local64_read(l) - (i))
+
+#else /* BITS_PER_LONG != 64 */
+
+#include <asm/atomic64.h>
+
+/* Don't use typedef: don't want them to be mixed with atomic_t's. */
+typedef struct {
+	atomic64_t a;
+} local64_t;
+
+#define LOCAL64_INIT(i)	{ ATOMIC_LONG_INIT(i) }
+
+#define local64_read(l)		atomic64_read(&(l)->a)
+#define local64_set(l,i)	atomic64_set((&(l)->a),(i))
+#define local64_inc(l)		atomic64_inc(&(l)->a)
+#define local64_dec(l)		atomic64_dec(&(l)->a)
+#define local64_add(i,l)	atomic64_add((i),(&(l)->a))
+#define local64_sub(i,l)	atomic64_sub((i),(&(l)->a))
+
+#define local64_sub_and_test(i, l) atomic64_sub_and_test((i), (&(l)->a))
+#define local64_dec_and_test(l) atomic64_dec_and_test(&(l)->a)
+#define local64_inc_and_test(l) atomic64_inc_and_test(&(l)->a)
+#define local64_add_negative(i, l) atomic64_add_negative((i), (&(l)->a))
+#define local64_add_return(i, l) atomic64_add_return((i), (&(l)->a))
+#define local64_sub_return(i, l) atomic64_sub_return((i), (&(l)->a))
+#define local64_inc_return(l)	atomic64_inc_return(&(l)->a)
+
+#define local64_cmpxchg(l, o, n) atomic64_cmpxchg((&(l)->a), (o), (n))
+#define local64_xchg(l, n)	atomic64_xchg((&(l)->a), (n))
+#define local64_add_unless(l, _a, u) atomic64_add_unless((&(l)->a), (_a), (u))
+#define local64_inc_not_zero(l)	atomic64_inc_not_zero(&(l)->a)
+
+/* Non-atomic variants, ie. preemption disabled and won't be touched
+ * in interrupt, etc.  Some archs can optimize this case well. */
+#define __local64_inc(l)	local64_set((l), local64_read(l) + 1)
+#define __local64_dec(l)	local64_set((l), local64_read(l) - 1)
+#define __local64_add(i,l)	local64_set((l), local64_read(l) + (i))
+#define __local64_sub(i,l)	local64_set((l), local64_read(l) - (i))
+
+#endif /* BITS_PER_LONG != 64 */
+
+#endif /* _ASM_GENERIC_LOCAL64_H */


