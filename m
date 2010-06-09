Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0FIKSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:18:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:36403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab0FIKSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:18:01 -0400
Date: Wed, 9 Jun 2010 10:17:05 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] arch: Implement local64_t
Message-ID: <tip-1996bda2a42480c275656233e631ee0966574be4@git.kernel.org>
Git-Commit-ID: 1996bda2a42480c275656233e631ee0966574be4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:17:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1996bda2a42480c275656233e631ee0966574be4
Gitweb:     http://git.kernel.org/tip/1996bda2a42480c275656233e631ee0966574be4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 14:05:13 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:36 +0200

arch: Implement local64_t

On 64bit, local_t is of size long, and thus we make local64_t an alias.
On 32bit, we fall back to atomic64_t. (architecture can provide optimized
32-bit version)

(This new facility is to be used by perf events optimizations.)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/include/asm/local64.h      |    1 +
 arch/arm/include/asm/local64.h        |    1 +
 arch/avr32/include/asm/local64.h      |    1 +
 arch/blackfin/include/asm/local64.h   |    1 +
 arch/cris/include/asm/local64.h       |    1 +
 arch/frv/include/asm/local64.h        |    1 +
 arch/frv/kernel/local64.h             |    1 +
 arch/h8300/include/asm/local64.h      |    1 +
 arch/ia64/include/asm/local64.h       |    1 +
 arch/m32r/include/asm/local64.h       |    1 +
 arch/m68k/include/asm/local64.h       |    1 +
 arch/microblaze/include/asm/local64.h |    1 +
 arch/mips/include/asm/local64.h       |    1 +
 arch/mn10300/include/asm/local64.h    |    1 +
 arch/parisc/include/asm/local64.h     |    1 +
 arch/powerpc/include/asm/local64.h    |    1 +
 arch/s390/include/asm/local64.h       |    1 +
 arch/score/include/asm/local64.h      |    1 +
 arch/sh/include/asm/local64.h         |    1 +
 arch/sparc/include/asm/local64.h      |    1 +
 arch/x86/include/asm/local64.h        |    1 +
 arch/xtensa/include/asm/local64.h     |    1 +
 include/asm-generic/local64.h         |   96 +++++++++++++++++++++++++++++++++
 23 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/local64.h b/arch/alpha/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/alpha/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/arm/include/asm/local64.h b/arch/arm/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/arm/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/avr32/include/asm/local64.h b/arch/avr32/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/avr32/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/blackfin/include/asm/local64.h b/arch/blackfin/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/blackfin/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/cris/include/asm/local64.h b/arch/cris/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/cris/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/frv/include/asm/local64.h b/arch/frv/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/frv/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/frv/kernel/local64.h b/arch/frv/kernel/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/frv/kernel/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/h8300/include/asm/local64.h b/arch/h8300/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/h8300/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/ia64/include/asm/local64.h b/arch/ia64/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/ia64/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/m32r/include/asm/local64.h b/arch/m32r/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/m32r/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/m68k/include/asm/local64.h b/arch/m68k/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/m68k/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/microblaze/include/asm/local64.h b/arch/microblaze/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/microblaze/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/mips/include/asm/local64.h b/arch/mips/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/mips/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/mn10300/include/asm/local64.h b/arch/mn10300/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/mn10300/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/parisc/include/asm/local64.h b/arch/parisc/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/parisc/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/powerpc/include/asm/local64.h b/arch/powerpc/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/powerpc/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/s390/include/asm/local64.h b/arch/s390/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/s390/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/score/include/asm/local64.h b/arch/score/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/score/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/sh/include/asm/local64.h b/arch/sh/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/sh/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/sparc/include/asm/local64.h b/arch/sparc/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/sparc/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/x86/include/asm/local64.h b/arch/x86/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/x86/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/arch/xtensa/include/asm/local64.h b/arch/xtensa/include/asm/local64.h
new file mode 100644
index 0000000..36c93b5
--- /dev/null
+++ b/arch/xtensa/include/asm/local64.h
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>
diff --git a/include/asm-generic/local64.h b/include/asm-generic/local64.h
new file mode 100644
index 0000000..02ac760
--- /dev/null
+++ b/include/asm-generic/local64.h
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
+#include <asm/atomic.h>
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
