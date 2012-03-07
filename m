Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab2CGTr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759955Ab2CGTrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:47:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/29] Disintegrate asm/system.h for CRIS
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:47:35 +0000
Message-ID: <20120307194735.15987.39717.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for CRIS.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/cris/arch-v10/kernel/dma.c              |    1 
 arch/cris/arch-v10/kernel/io_interface_mux.c |    1 
 arch/cris/arch-v10/kernel/process.c          |    1 
 arch/cris/arch-v10/kernel/setup.c            |    1 
 arch/cris/arch-v10/kernel/signal.c           |    1 
 arch/cris/arch-v10/kernel/traps.c            |    1 
 arch/cris/include/arch-v10/arch/elf.h        |    2 +
 arch/cris/include/arch-v32/arch/elf.h        |    2 +
 arch/cris/include/asm/atomic.h               |   46 +++++++++++++
 arch/cris/include/asm/barrier.h              |   23 +++++++
 arch/cris/include/asm/exec.h                 |    6 ++
 arch/cris/include/asm/processor.h            |   10 +++
 arch/cris/include/asm/switch_to.h            |   12 ++++
 arch/cris/include/asm/system.h               |   89 --------------------------
 arch/cris/kernel/irq.c                       |    1 
 arch/cris/kernel/setup.c                     |    1 
 arch/cris/kernel/traps.c                     |    1 
 arch/cris/mm/fault.c                         |    1 
 drivers/tty/serial/crisv10.c                 |    1 
 19 files changed, 112 insertions(+), 89 deletions(-)
 create mode 100644 arch/cris/include/asm/barrier.h
 create mode 100644 arch/cris/include/asm/exec.h
 create mode 100644 arch/cris/include/asm/switch_to.h
 delete mode 100644 arch/cris/include/asm/system.h

diff --git a/arch/cris/arch-v10/kernel/dma.c b/arch/cris/arch-v10/kernel/dma.c
index d31504b..5795047 100644
--- a/arch/cris/arch-v10/kernel/dma.c
+++ b/arch/cris/arch-v10/kernel/dma.c
@@ -8,6 +8,7 @@
 
 #include <asm/dma.h>
 #include <arch/svinto.h>
+#include <arch/system.h>
 
 /* Macro to access ETRAX 100 registers */
 #define SETS(var, reg, field, val) var = (var & ~IO_MASK_(reg##_, field##_)) | \
diff --git a/arch/cris/arch-v10/kernel/io_interface_mux.c b/arch/cris/arch-v10/kernel/io_interface_mux.c
index 29f97e9..ad64cd1 100644
--- a/arch/cris/arch-v10/kernel/io_interface_mux.c
+++ b/arch/cris/arch-v10/kernel/io_interface_mux.c
@@ -14,6 +14,7 @@
 #include <arch/svinto.h>
 #include <asm/io.h>
 #include <arch/io_interface_mux.h>
+#include <arch/system.h>
 
 
 #define DBG(s)
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index 9a57db6..bee8df4 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <arch/svinto.h>
 #include <linux/init.h>
+#include <arch/system.h>
 
 #ifdef CONFIG_ETRAX_GPIO
 void etrax_gpio_wake_up_check(void); /* drivers/gpio.c */
diff --git a/arch/cris/arch-v10/kernel/setup.c b/arch/cris/arch-v10/kernel/setup.c
index de27b50..4f96d71 100644
--- a/arch/cris/arch-v10/kernel/setup.c
+++ b/arch/cris/arch-v10/kernel/setup.c
@@ -14,6 +14,7 @@
 #include <linux/proc_fs.h>
 #include <linux/delay.h>
 #include <linux/param.h>
+#include <arch/system.h>
 
 #ifdef CONFIG_PROC_FS
 #define HAS_FPU		0x0001
diff --git a/arch/cris/arch-v10/kernel/signal.c b/arch/cris/arch-v10/kernel/signal.c
index e78fe49..289c584 100644
--- a/arch/cris/arch-v10/kernel/signal.c
+++ b/arch/cris/arch-v10/kernel/signal.c
@@ -27,6 +27,7 @@
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
+#include <arch/system.h>
 
 #define DEBUG_SIG 0
 
diff --git a/arch/cris/arch-v10/kernel/traps.c b/arch/cris/arch-v10/kernel/traps.c
index 8bebb96..7001bed 100644
--- a/arch/cris/arch-v10/kernel/traps.c
+++ b/arch/cris/arch-v10/kernel/traps.c
@@ -11,6 +11,7 @@
 #include <linux/ptrace.h>
 #include <asm/uaccess.h>
 #include <arch/sv_addr_ag.h>
+#include <arch/system.h>
 
 void
 show_registers(struct pt_regs *regs)
diff --git a/arch/cris/include/arch-v10/arch/elf.h b/arch/cris/include/arch-v10/arch/elf.h
index 1c38ee7..1eb638a 100644
--- a/arch/cris/include/arch-v10/arch/elf.h
+++ b/arch/cris/include/arch-v10/arch/elf.h
@@ -1,6 +1,8 @@
 #ifndef __ASMCRIS_ARCH_ELF_H
 #define __ASMCRIS_ARCH_ELF_H
 
+#include <arch/system.h>
+
 #define ELF_MACH EF_CRIS_VARIANT_ANY_V0_V10
 
 /*
diff --git a/arch/cris/include/arch-v32/arch/elf.h b/arch/cris/include/arch-v32/arch/elf.h
index 1324e50..c46d582 100644
--- a/arch/cris/include/arch-v32/arch/elf.h
+++ b/arch/cris/include/arch-v32/arch/elf.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_CRIS_ELF_H
 #define _ASM_CRIS_ELF_H
 
+#include <arch/system.h>
+
 #define ELF_CORE_EFLAGS EF_CRIS_VARIANT_V32
 
 /*
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 62760f8..44e1571 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -5,8 +5,54 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/irqflags.h>
 #include <arch/atomic.h>
 
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+  /* since Etrax doesn't have any atomic xchg instructions, we need to disable
+     irq's (if enabled) and do it with move.d's */
+  unsigned long flags,temp;
+  local_irq_save(flags); /* save flags, including irq enable bit and shut off irqs */
+  switch (size) {
+  case 1:
+    *((unsigned char *)&temp) = x;
+    x = *(unsigned char *)ptr;
+    *(unsigned char *)ptr = *((unsigned char *)&temp);
+    break;
+  case 2:
+    *((unsigned short *)&temp) = x;
+    x = *(unsigned short *)ptr;
+    *(unsigned short *)ptr = *((unsigned short *)&temp);
+    break;
+  case 4:
+    temp = x;
+    x = *(unsigned long *)ptr;
+    *(unsigned long *)ptr = temp;
+    break;
+  }
+  local_irq_restore(flags); /* restore irq enable bit */
+  return x;
+}
+
+#define xchg(ptr,x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				 	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
diff --git a/arch/cris/include/asm/barrier.h b/arch/cris/include/asm/barrier.h
new file mode 100644
index 0000000..ce0f293
--- /dev/null
+++ b/arch/cris/include/asm/barrier.h
@@ -0,0 +1,23 @@
+#ifndef __ASM_CRIS_BARRIER_H
+#define __ASM_CRIS_BARRIER_H
+
+#define barrier() __asm__ __volatile__("": : :"memory")
+#define mb() barrier()
+#define rmb() mb()
+#define wmb() mb()
+#define read_barrier_depends() do { } while(0)
+#define set_mb(var, value)  do { var = value; mb(); } while (0)
+
+#ifdef CONFIG_SMP
+#define smp_mb()        mb()
+#define smp_rmb()       rmb()
+#define smp_wmb()       wmb()
+#define smp_read_barrier_depends()     read_barrier_depends()
+#else
+#define smp_mb()        barrier()
+#define smp_rmb()       barrier()
+#define smp_wmb()       barrier()
+#define smp_read_barrier_depends()     do { } while(0)
+#endif
+
+#endif /* __ASM_CRIS_BARRIER_H */
diff --git a/arch/cris/include/asm/exec.h b/arch/cris/include/asm/exec.h
new file mode 100644
index 0000000..9665dab
--- /dev/null
+++ b/arch/cris/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_CRIS_EXEC_H
+#define __ASM_CRIS_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __ASM_CRIS_EXEC_H */
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index b43c9bb..4210d72 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -13,6 +13,7 @@
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <arch/processor.h>
+#include <arch/system.h>
 
 struct task_struct;
 
@@ -71,4 +72,13 @@ static inline void release_thread(struct task_struct *dead_task)
 
 #define cpu_relax()     barrier()
 
+/*
+ * disable hlt during certain critical i/o operations
+ */
+#define HAVE_DISABLE_HLT
+void disable_hlt(void);
+void enable_hlt(void);
+
+void default_idle(void);
+
 #endif /* __ASM_CRIS_PROCESSOR_H */
diff --git a/arch/cris/include/asm/switch_to.h b/arch/cris/include/asm/switch_to.h
new file mode 100644
index 0000000..d842e11
--- /dev/null
+++ b/arch/cris/include/asm/switch_to.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_CRIS_SWITCH_TO_H
+#define __ASM_CRIS_SWITCH_TO_H
+
+/* the switch_to macro calls resume, an asm function in entry.S which does the actual
+ * task switching.
+ */
+
+extern struct task_struct *resume(struct task_struct *prev, struct task_struct *next, int);
+#define switch_to(prev,next,last) last = resume(prev,next, \
+					 (int)&((struct task_struct *)0)->thread)
+
+#endif /* __ASM_CRIS_SWITCH_TO_H */
diff --git a/arch/cris/include/asm/system.h b/arch/cris/include/asm/system.h
deleted file mode 100644
index ea10592..0000000
--- a/arch/cris/include/asm/system.h
+++ /dev/null
@@ -1,89 +0,0 @@
-#ifndef __ASM_CRIS_SYSTEM_H
-#define __ASM_CRIS_SYSTEM_H
-
-#include <linux/irqflags.h>
-#include <arch/system.h>
-
-/* the switch_to macro calls resume, an asm function in entry.S which does the actual
- * task switching.
- */
-
-extern struct task_struct *resume(struct task_struct *prev, struct task_struct *next, int);
-#define switch_to(prev,next,last) last = resume(prev,next, \
-					 (int)&((struct task_struct *)0)->thread)
-
-#define barrier() __asm__ __volatile__("": : :"memory")
-#define mb() barrier()
-#define rmb() mb()
-#define wmb() mb()
-#define read_barrier_depends() do { } while(0)
-#define set_mb(var, value)  do { var = value; mb(); } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()        mb()
-#define smp_rmb()       rmb()
-#define smp_wmb()       wmb()
-#define smp_read_barrier_depends()     read_barrier_depends()
-#else
-#define smp_mb()        barrier()
-#define smp_rmb()       barrier()
-#define smp_wmb()       barrier()
-#define smp_read_barrier_depends()     do { } while(0)
-#endif
-
-#define iret()
-
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
-void disable_hlt(void);
-void enable_hlt(void);
-
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-  /* since Etrax doesn't have any atomic xchg instructions, we need to disable
-     irq's (if enabled) and do it with move.d's */
-  unsigned long flags,temp;
-  local_irq_save(flags); /* save flags, including irq enable bit and shut off irqs */
-  switch (size) {
-  case 1:
-    *((unsigned char *)&temp) = x;
-    x = *(unsigned char *)ptr;
-    *(unsigned char *)ptr = *((unsigned char *)&temp);
-    break;
-  case 2:
-    *((unsigned short *)&temp) = x;
-    x = *(unsigned short *)ptr;
-    *(unsigned short *)ptr = *((unsigned short *)&temp);
-    break;
-  case 4:
-    temp = x;
-    x = *(unsigned long *)ptr;
-    *(unsigned long *)ptr = temp;
-    break;
-  }
-  local_irq_restore(flags); /* restore irq enable bit */
-  return x;
-}
-
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				 	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#ifndef CONFIG_SMP
-#include <asm-generic/cmpxchg.h>
-#endif
-
-#define arch_align_stack(x) (x)
-
-void default_idle(void);
-
-#endif
diff --git a/arch/cris/kernel/irq.c b/arch/cris/kernel/irq.c
index 788eb22..d36836d 100644
--- a/arch/cris/kernel/irq.c
+++ b/arch/cris/kernel/irq.c
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 
 #include <asm/io.h>
+#include <arch/system.h>
 
 /* called by the assembler IRQ entry functions defined in irq.h
  * to dispatch the interrupts to registered handlers
diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
index b712f49..32c3d24 100644
--- a/arch/cris/kernel/setup.c
+++ b/arch/cris/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/pfn.h>
 #include <linux/cpu.h>
 #include <asm/setup.h>
+#include <arch/system.h>
 
 /*
  * Setup options
diff --git a/arch/cris/kernel/traps.c b/arch/cris/kernel/traps.c
index 8da53f3..a11ad32 100644
--- a/arch/cris/kernel/traps.c
+++ b/arch/cris/kernel/traps.c
@@ -17,6 +17,7 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
+#include <arch/system.h>
 
 extern void arch_enable_nmi(void);
 extern void stop_watchdog(void);
diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 9dcac8e..b4760d8 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
+#include <arch/system.h>
 
 extern int find_fixup_code(struct pt_regs *);
 extern void die_if_kernel(const char *, struct pt_regs *, long);
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index d52cb25..a900954 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -36,6 +36,7 @@ static char *serial_version = "$Revision: 1.25 $";
 #include <asm/dma.h>
 
 #include <arch/svinto.h>
+#include <arch/system.h>
 
 /* non-arch dependent serial structures are in linux/serial.h */
 #include <linux/serial.h>

