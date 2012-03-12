Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2CLXif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:38:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780Ab2CLXi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:38:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/35] Disintegrate asm/system.h for M68K [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux-m68k@vger.kernel.org
Date: Mon, 12 Mar 2012 23:38:16 +0000
Message-ID: <20120312233816.13888.142.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for M68K.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-m68k@lists.linux-m68k.org
---

 arch/m68k/amiga/amisound.c          |    1 
 arch/m68k/amiga/config.c            |    1 
 arch/m68k/apollo/config.c           |    1 
 arch/m68k/atari/ataints.c           |    1 
 arch/m68k/atari/atasound.c          |    1 
 arch/m68k/atari/config.c            |    1 
 arch/m68k/bvme6000/config.c         |    1 
 arch/m68k/bvme6000/rtc.c            |    1 
 arch/m68k/hp300/time.c              |    1 
 arch/m68k/include/asm/atomic.h      |    2 
 arch/m68k/include/asm/barrier.h     |   20 ++++
 arch/m68k/include/asm/cmpxchg.h     |  129 +++++++++++++++++++++++
 arch/m68k/include/asm/exec.h        |    6 +
 arch/m68k/include/asm/sun3xflop.h   |    1 
 arch/m68k/include/asm/switch_to.h   |   41 +++++++
 arch/m68k/include/asm/system.h      |  198 +----------------------------------
 arch/m68k/kernel/ints.c             |    1 
 arch/m68k/kernel/irq.c              |    1 
 arch/m68k/kernel/process_mm.c       |    1 
 arch/m68k/kernel/process_no.c       |    1 
 arch/m68k/kernel/ptrace_mm.c        |    1 
 arch/m68k/kernel/ptrace_no.c        |    1 
 arch/m68k/kernel/traps.c            |    1 
 arch/m68k/kernel/vectors.c          |    1 
 arch/m68k/mac/config.c              |    1 
 arch/m68k/mac/misc.c                |    1 
 arch/m68k/mm/fault.c                |    1 
 arch/m68k/mm/init_mm.c              |    1 
 arch/m68k/mm/init_no.c              |    1 
 arch/m68k/mm/kmap.c                 |    1 
 arch/m68k/mm/memory.c               |    1 
 arch/m68k/mm/motorola.c             |    1 
 arch/m68k/mm/sun3mmu.c              |    1 
 arch/m68k/mvme147/config.c          |    1 
 arch/m68k/mvme16x/config.c          |    1 
 arch/m68k/mvme16x/rtc.c             |    1 
 arch/m68k/platform/68328/config.c   |    1 
 arch/m68k/platform/68328/timers.c   |    1 
 arch/m68k/platform/68360/config.c   |    1 
 arch/m68k/platform/68EZ328/config.c |    1 
 arch/m68k/platform/68VZ328/config.c |    1 
 arch/m68k/q40/config.c              |    1 
 arch/m68k/q40/q40ints.c             |    1 
 arch/m68k/sun3/intersil.c           |    1 
 arch/m68k/sun3/mmu_emu.c            |    1 
 arch/m68k/sun3/prom/console.c       |    1 
 arch/m68k/sun3x/config.c            |    1 
 arch/m68k/sun3x/time.c              |    1 
 48 files changed, 202 insertions(+), 236 deletions(-)
 create mode 100644 arch/m68k/include/asm/barrier.h
 create mode 100644 arch/m68k/include/asm/cmpxchg.h
 create mode 100644 arch/m68k/include/asm/exec.h
 create mode 100644 arch/m68k/include/asm/switch_to.h

diff --git a/arch/m68k/amiga/amisound.c b/arch/m68k/amiga/amisound.c
index 61e5c54..2559eef 100644
--- a/arch/m68k/amiga/amisound.c
+++ b/arch/m68k/amiga/amisound.c
@@ -14,7 +14,6 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/amigahw.h>
 
 static unsigned short *snd_data;
diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index b95a451..ee01b7a 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -29,7 +29,6 @@
 
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index 8d3eafa..0a30406 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -9,7 +9,6 @@
 
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/apollohw.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 8048e1b..783d8f0 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -42,7 +42,6 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/atarihw.h>
diff --git a/arch/m68k/atari/atasound.c b/arch/m68k/atari/atasound.c
index d266fe8..1c1181e 100644
--- a/arch/m68k/atari/atasound.c
+++ b/arch/m68k/atari/atasound.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 
 #include <asm/atarihw.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/atariints.h>
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index c4ac15c..d8eb327 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -39,7 +39,6 @@
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 #include <asm/atari_stram.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/hwtest.h>
 #include <asm/io.h>
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 8128647..0bf850a 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -28,7 +28,6 @@
 #include <linux/bcd.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/bvme6000/rtc.c b/arch/m68k/bvme6000/rtc.c
index 1c4d4c7..cf12a17 100644
--- a/arch/m68k/bvme6000/rtc.c
+++ b/arch/m68k/bvme6000/rtc.c
@@ -21,7 +21,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 
 /*
diff --git a/arch/m68k/hp300/time.c b/arch/m68k/hp300/time.c
index c87fe69..29a71be 100644
--- a/arch/m68k/hp300/time.c
+++ b/arch/m68k/hp300/time.c
@@ -15,7 +15,6 @@
 #include <asm/machdep.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/blinken.h>
 
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 4eba796..336e617 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -2,7 +2,7 @@
 #define __ARCH_M68K_ATOMIC__
 
 #include <linux/types.h>
-#include <asm/system.h>
+#include <linux/irqflags.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
new file mode 100644
index 0000000..445ce22
--- /dev/null
+++ b/arch/m68k/include/asm/barrier.h
@@ -0,0 +1,20 @@
+#ifndef _M68K_BARRIER_H
+#define _M68K_BARRIER_H
+
+/*
+ * Force strict CPU ordering.
+ * Not really required on m68k...
+ */
+#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
+#define mb()		barrier()
+#define rmb()		barrier()
+#define wmb()		barrier()
+#define read_barrier_depends()	((void)0)
+#define set_mb(var, value)	({ (var) = (value); wmb(); })
+
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	((void)0)
+
+#endif /* _M68K_BARRIER_H */
diff --git a/arch/m68k/include/asm/cmpxchg.h b/arch/m68k/include/asm/cmpxchg.h
new file mode 100644
index 0000000..f8acc0f
--- /dev/null
+++ b/arch/m68k/include/asm/cmpxchg.h
@@ -0,0 +1,129 @@
+#ifndef __ARCH_M68K_CMPXCHG__
+#define __ARCH_M68K_CMPXCHG__
+
+#include <linux/irqflags.h>
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((volatile struct __xchg_dummy *)(x))
+
+#ifndef CONFIG_RMW_INSNS
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	unsigned long flags, tmp;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		tmp = *(u8 *)ptr;
+		*(u8 *)ptr = x;
+		x = tmp;
+		break;
+	case 2:
+		tmp = *(u16 *)ptr;
+		*(u16 *)ptr = x;
+		x = tmp;
+		break;
+	case 4:
+		tmp = *(u32 *)ptr;
+		*(u32 *)ptr = x;
+		x = tmp;
+		break;
+	default:
+		BUG();
+	}
+
+	local_irq_restore(flags);
+	return x;
+}
+#else
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+	    case 1:
+		__asm__ __volatile__
+			("moveb %2,%0\n\t"
+			 "1:\n\t"
+			 "casb %0,%1,%2\n\t"
+			 "jne 1b"
+			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	    case 2:
+		__asm__ __volatile__
+			("movew %2,%0\n\t"
+			 "1:\n\t"
+			 "casw %0,%1,%2\n\t"
+			 "jne 1b"
+			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	    case 4:
+		__asm__ __volatile__
+			("movel %2,%0\n\t"
+			 "1:\n\t"
+			 "casl %0,%1,%2\n\t"
+			 "jne 1b"
+			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	}
+	return x;
+}
+#endif
+
+#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+#ifdef CONFIG_RMW_INSNS
+#define __HAVE_ARCH_CMPXCHG	1
+
+static inline unsigned long __cmpxchg(volatile void *p, unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ __volatile__ ("casb %0,%2,%1"
+				      : "=d" (old), "=m" (*(char *)p)
+				      : "d" (new), "0" (old), "m" (*(char *)p));
+		break;
+	case 2:
+		__asm__ __volatile__ ("casw %0,%2,%1"
+				      : "=d" (old), "=m" (*(short *)p)
+				      : "d" (new), "0" (old), "m" (*(short *)p));
+		break;
+	case 4:
+		__asm__ __volatile__ ("casl %0,%2,%1"
+				      : "=d" (old), "=m" (*(int *)p)
+				      : "d" (new), "0" (old), "m" (*(int *)p));
+		break;
+	}
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg_local(ptr, o, n)					    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#else
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg.h>
+
+#endif
+
+#endif /* __ARCH_M68K_CMPXCHG__ */
diff --git a/arch/m68k/include/asm/exec.h b/arch/m68k/include/asm/exec.h
new file mode 100644
index 0000000..0499adf
--- /dev/null
+++ b/arch/m68k/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef _M68K_EXEC_H
+#define _M68K_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _M68K_EXEC_H */
diff --git a/arch/m68k/include/asm/sun3xflop.h b/arch/m68k/include/asm/sun3xflop.h
index 32c45f8..95231e2 100644
--- a/arch/m68k/include/asm/sun3xflop.h
+++ b/arch/m68k/include/asm/sun3xflop.h
@@ -11,7 +11,6 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/sun3x.h>
 
diff --git a/arch/m68k/include/asm/switch_to.h b/arch/m68k/include/asm/switch_to.h
new file mode 100644
index 0000000..16fd6b6
--- /dev/null
+++ b/arch/m68k/include/asm/switch_to.h
@@ -0,0 +1,41 @@
+#ifndef _M68K_SWITCH_TO_H
+#define _M68K_SWITCH_TO_H
+
+/*
+ * switch_to(n) should switch tasks to task ptr, first checking that
+ * ptr isn't the current task, in which case it does nothing.  This
+ * also clears the TS-flag if the task we switched to has used the
+ * math co-processor latest.
+ */
+/*
+ * switch_to() saves the extra registers, that are not saved
+ * automatically by SAVE_SWITCH_STACK in resume(), ie. d0-d5 and
+ * a0-a1. Some of these are used by schedule() and its predecessors
+ * and so we might get see unexpected behaviors when a task returns
+ * with unexpected register values.
+ *
+ * syscall stores these registers itself and none of them are used
+ * by syscall after the function in the syscall has been called.
+ *
+ * Beware that resume now expects *next to be in d1 and the offset of
+ * tss to be in a1. This saves a few instructions as we no longer have
+ * to push them onto the stack and read them back right after.
+ *
+ * 02/17/96 - Jes Sorensen (jds@kom.auc.dk)
+ *
+ * Changed 96/09/19 by Andreas Schwab
+ * pass prev in a0, next in a1
+ */
+asmlinkage void resume(void);
+#define switch_to(prev,next,last) do { \
+  register void *_prev __asm__ ("a0") = (prev); \
+  register void *_next __asm__ ("a1") = (next); \
+  register void *_last __asm__ ("d1"); \
+  __asm__ __volatile__("jbsr resume" \
+		       : "=a" (_prev), "=a" (_next), "=d" (_last) \
+		       : "0" (_prev), "1" (_next) \
+		       : "d0", "d2", "d3", "d4", "d5"); \
+  (last) = _last; \
+} while (0)
+
+#endif /* _M68K_SWITCH_TO_H */
diff --git a/arch/m68k/include/asm/system.h b/arch/m68k/include/asm/system.h
index 47b01f4..a7f4057 100644
--- a/arch/m68k/include/asm/system.h
+++ b/arch/m68k/include/asm/system.h
@@ -1,193 +1,5 @@
-#ifndef _M68K_SYSTEM_H
-#define _M68K_SYSTEM_H
-
-#include <linux/linkage.h>
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-#include <asm/segment.h>
-#include <asm/entry.h>
-
-#ifdef __KERNEL__
-
-/*
- * switch_to(n) should switch tasks to task ptr, first checking that
- * ptr isn't the current task, in which case it does nothing.  This
- * also clears the TS-flag if the task we switched to has used the
- * math co-processor latest.
- */
-/*
- * switch_to() saves the extra registers, that are not saved
- * automatically by SAVE_SWITCH_STACK in resume(), ie. d0-d5 and
- * a0-a1. Some of these are used by schedule() and its predecessors
- * and so we might get see unexpected behaviors when a task returns
- * with unexpected register values.
- *
- * syscall stores these registers itself and none of them are used
- * by syscall after the function in the syscall has been called.
- *
- * Beware that resume now expects *next to be in d1 and the offset of
- * tss to be in a1. This saves a few instructions as we no longer have
- * to push them onto the stack and read them back right after.
- *
- * 02/17/96 - Jes Sorensen (jds@kom.auc.dk)
- *
- * Changed 96/09/19 by Andreas Schwab
- * pass prev in a0, next in a1
- */
-asmlinkage void resume(void);
-#define switch_to(prev,next,last) do { \
-  register void *_prev __asm__ ("a0") = (prev); \
-  register void *_next __asm__ ("a1") = (next); \
-  register void *_last __asm__ ("d1"); \
-  __asm__ __volatile__("jbsr resume" \
-		       : "=a" (_prev), "=a" (_next), "=d" (_last) \
-		       : "0" (_prev), "1" (_next) \
-		       : "d0", "d2", "d3", "d4", "d5"); \
-  (last) = _last; \
-} while (0)
-
-
-/*
- * Force strict CPU ordering.
- * Not really required on m68k...
- */
-#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define read_barrier_depends()	((void)0)
-#define set_mb(var, value)	({ (var) = (value); wmb(); })
-
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	((void)0)
-
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((volatile struct __xchg_dummy *)(x))
-
-#ifndef CONFIG_RMW_INSNS
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	unsigned long flags, tmp;
-
-	local_irq_save(flags);
-
-	switch (size) {
-	case 1:
-		tmp = *(u8 *)ptr;
-		*(u8 *)ptr = x;
-		x = tmp;
-		break;
-	case 2:
-		tmp = *(u16 *)ptr;
-		*(u16 *)ptr = x;
-		x = tmp;
-		break;
-	case 4:
-		tmp = *(u32 *)ptr;
-		*(u32 *)ptr = x;
-		x = tmp;
-		break;
-	default:
-		BUG();
-	}
-
-	local_irq_restore(flags);
-	return x;
-}
-#else
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-	    case 1:
-		__asm__ __volatile__
-			("moveb %2,%0\n\t"
-			 "1:\n\t"
-			 "casb %0,%1,%2\n\t"
-			 "jne 1b"
-			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	    case 2:
-		__asm__ __volatile__
-			("movew %2,%0\n\t"
-			 "1:\n\t"
-			 "casw %0,%1,%2\n\t"
-			 "jne 1b"
-			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	    case 4:
-		__asm__ __volatile__
-			("movel %2,%0\n\t"
-			 "1:\n\t"
-			 "casl %0,%1,%2\n\t"
-			 "jne 1b"
-			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	}
-	return x;
-}
-#endif
-
-#include <asm-generic/cmpxchg-local.h>
-
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-#ifdef CONFIG_RMW_INSNS
-#define __HAVE_ARCH_CMPXCHG	1
-
-static inline unsigned long __cmpxchg(volatile void *p, unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-		__asm__ __volatile__ ("casb %0,%2,%1"
-				      : "=d" (old), "=m" (*(char *)p)
-				      : "d" (new), "0" (old), "m" (*(char *)p));
-		break;
-	case 2:
-		__asm__ __volatile__ ("casw %0,%2,%1"
-				      : "=d" (old), "=m" (*(short *)p)
-				      : "d" (new), "0" (old), "m" (*(short *)p));
-		break;
-	case 4:
-		__asm__ __volatile__ ("casl %0,%2,%1"
-				      : "=d" (old), "=m" (*(int *)p)
-				      : "d" (new), "0" (old), "m" (*(int *)p));
-		break;
-	}
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						    \
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg_local(ptr, o, n)					    \
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
-			(unsigned long)(n), sizeof(*(ptr))))
-#else
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-
-#include <asm-generic/cmpxchg.h>
-
-#endif
-
-#define arch_align_stack(x) (x)
-
-#endif /* __KERNEL__ */
-
-#endif /* _M68K_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 74fefac..6b32b64 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/page.h>
diff --git a/arch/m68k/kernel/irq.c b/arch/m68k/kernel/irq.c
index c73988c..9ab4f55 100644
--- a/arch/m68k/kernel/irq.c
+++ b/arch/m68k/kernel/irq.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/seq_file.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
diff --git a/arch/m68k/kernel/process_mm.c b/arch/m68k/kernel/process_mm.c
index 099283e..a4ecd7e 100644
--- a/arch/m68k/kernel/process_mm.c
+++ b/arch/m68k/kernel/process_mm.c
@@ -27,7 +27,6 @@
 #include <linux/mqueue.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/setup.h>
diff --git a/arch/m68k/kernel/process_no.c b/arch/m68k/kernel/process_no.c
index 5e1078c..2b24672 100644
--- a/arch/m68k/kernel/process_no.c
+++ b/arch/m68k/kernel/process_no.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/setup.h>
diff --git a/arch/m68k/kernel/ptrace_mm.c b/arch/m68k/kernel/ptrace_mm.c
index 7bc999b..e853a05 100644
--- a/arch/m68k/kernel/ptrace_mm.c
+++ b/arch/m68k/kernel/ptrace_mm.c
@@ -23,7 +23,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 /*
diff --git a/arch/m68k/kernel/ptrace_no.c b/arch/m68k/kernel/ptrace_no.c
index 6709fb7..92851d8 100644
--- a/arch/m68k/kernel/ptrace_no.c
+++ b/arch/m68k/kernel/ptrace_no.c
@@ -23,7 +23,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 /*
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index daaa918..388e5cc 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -32,7 +32,6 @@
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/traps.h>
 #include <asm/pgalloc.h>
diff --git a/arch/m68k/kernel/vectors.c b/arch/m68k/kernel/vectors.c
index 147b03f..322c977 100644
--- a/arch/m68k/kernel/vectors.c
+++ b/arch/m68k/kernel/vectors.c
@@ -25,7 +25,6 @@
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 /* assembler routines */
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index f60ff5f..96fa6ed 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -30,7 +30,6 @@
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index eb91555..5e08555 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -19,7 +19,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/setup.h>
 #include <asm/macintosh.h>
diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index 2db6099..6b020a8 100644
--- a/arch/m68k/mm/fault.c
+++ b/arch/m68k/mm/fault.c
@@ -13,7 +13,6 @@
 
 #include <asm/setup.h>
 #include <asm/traps.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 
diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
index 89f3b20..f77f258 100644
--- a/arch/m68k/mm/init_mm.c
+++ b/arch/m68k/mm/init_mm.c
@@ -23,7 +23,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
diff --git a/arch/m68k/mm/init_no.c b/arch/m68k/mm/init_no.c
index 1e33d39..345ec0d 100644
--- a/arch/m68k/mm/init_no.c
+++ b/arch/m68k/mm/init_no.c
@@ -36,7 +36,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 
 /*
diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
index 1cc2bed..568cfad 100644
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -20,7 +20,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #undef DEBUG
 
diff --git a/arch/m68k/mm/memory.c b/arch/m68k/mm/memory.c
index a5dbb74..250b8b7 100644
--- a/arch/m68k/mm/memory.c
+++ b/arch/m68k/mm/memory.c
@@ -17,7 +17,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 8b3db1c..0dafa69 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -24,7 +24,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/dma.h>
diff --git a/arch/m68k/mm/sun3mmu.c b/arch/m68k/mm/sun3mmu.c
index 1b902db..e080406 100644
--- a/arch/m68k/mm/sun3mmu.c
+++ b/arch/m68k/mm/sun3mmu.c
@@ -21,7 +21,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
 
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 5de924e..a41c091 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index c3fb3bd..b6d7d8a 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -29,7 +29,6 @@
 #include <linux/module.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/mvme16x/rtc.c b/arch/m68k/mvme16x/rtc.c
index 39c79eb..6ef7a81 100644
--- a/arch/m68k/mvme16x/rtc.c
+++ b/arch/m68k/mvme16x/rtc.c
@@ -20,7 +20,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 
 /*
diff --git a/arch/m68k/platform/68328/config.c b/arch/m68k/platform/68328/config.c
index d70bf26..856d945 100644
--- a/arch/m68k/platform/68328/config.c
+++ b/arch/m68k/platform/68328/config.c
@@ -17,7 +17,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/MC68328.h>
 #if defined(CONFIG_PILOT) || defined(CONFIG_INIT_LCD)
diff --git a/arch/m68k/platform/68328/timers.c b/arch/m68k/platform/68328/timers.c
index f267886..2b4c912 100644
--- a/arch/m68k/platform/68328/timers.c
+++ b/arch/m68k/platform/68328/timers.c
@@ -21,7 +21,6 @@
 #include <linux/irq.h>
 #include <linux/clocksource.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
diff --git a/arch/m68k/platform/68360/config.c b/arch/m68k/platform/68360/config.c
index 9dd5bca..624dafc 100644
--- a/arch/m68k/platform/68360/config.c
+++ b/arch/m68k/platform/68360/config.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/m68360.h>
diff --git a/arch/m68k/platform/68EZ328/config.c b/arch/m68k/platform/68EZ328/config.c
index 1be1a16..080ad05 100644
--- a/arch/m68k/platform/68EZ328/config.c
+++ b/arch/m68k/platform/68EZ328/config.c
@@ -15,7 +15,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68EZ328.h>
diff --git a/arch/m68k/platform/68VZ328/config.c b/arch/m68k/platform/68VZ328/config.c
index eabaabe..ef4ceda 100644
--- a/arch/m68k/platform/68VZ328/config.c
+++ b/arch/m68k/platform/68VZ328/config.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index ad10fec..4c346ec 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -28,7 +28,6 @@
 #include <asm/io.h>
 #include <asm/rtc.h>
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 2b88849..513f9bb 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/q40_master.h>
diff --git a/arch/m68k/sun3/intersil.c b/arch/m68k/sun3/intersil.c
index 0116d20..94fe801 100644
--- a/arch/m68k/sun3/intersil.c
+++ b/arch/m68k/sun3/intersil.c
@@ -14,7 +14,6 @@
 #include <linux/rtc.h>
 
 #include <asm/errno.h>
-#include <asm/system.h>
 #include <asm/rtc.h>
 #include <asm/intersil.h>
 
diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index 94f81ec..8edc510 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -17,7 +17,6 @@
 
 #include <asm/setup.h>
 #include <asm/traps.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/m68k/sun3/prom/console.c b/arch/m68k/sun3/prom/console.c
index 2bcb6e4..e923643 100644
--- a/arch/m68k/sun3/prom/console.c
+++ b/arch/m68k/sun3/prom/console.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <linux/string.h>
 
 /* Non blocking get character from console input device, returns -1
diff --git a/arch/m68k/sun3x/config.c b/arch/m68k/sun3x/config.c
index fc599fa..dd306c8 100644
--- a/arch/m68k/sun3x/config.c
+++ b/arch/m68k/sun3x/config.c
@@ -12,7 +12,6 @@
 #include <linux/console.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/irq.h>
 #include <asm/sun3xprom.h>
diff --git a/arch/m68k/sun3x/time.c b/arch/m68k/sun3x/time.c
index 536a04a..1d0a724 100644
--- a/arch/m68k/sun3x/time.c
+++ b/arch/m68k/sun3x/time.c
@@ -15,7 +15,6 @@
 
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/sun3x.h>
 #include <asm/sun3ints.h>

