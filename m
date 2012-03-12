Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2CLXhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab2CLXhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:37:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/35] Disintegrate asm/system.h for CRIS [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux-cris-kernel@axis.com
Date: Mon, 12 Mar 2012 23:37:16 +0000
Message-ID: <20120312233716.13888.47074.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for CRIS.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cris-kernel@axis.com
---

 arch/cris/arch-v10/drivers/ds1302.c          |    1 
 arch/cris/arch-v10/drivers/gpio.c            |    1 
 arch/cris/arch-v10/drivers/i2c.c             |    1 
 arch/cris/arch-v10/drivers/pcf8563.c         |    1 
 arch/cris/arch-v10/drivers/sync_serial.c     |    1 
 arch/cris/arch-v10/kernel/debugport.c        |    1 
 arch/cris/arch-v10/kernel/dma.c              |    1 
 arch/cris/arch-v10/kernel/io_interface_mux.c |    1 
 arch/cris/arch-v10/kernel/process.c          |    1 
 arch/cris/arch-v10/kernel/ptrace.c           |    1 
 arch/cris/arch-v10/kernel/setup.c            |    1 
 arch/cris/arch-v10/kernel/signal.c           |    1 
 arch/cris/arch-v10/kernel/traps.c            |    1 
 arch/cris/arch-v32/drivers/i2c.c             |    1 
 arch/cris/arch-v32/drivers/mach-a3/gpio.c    |    1 
 arch/cris/arch-v32/drivers/mach-fs/gpio.c    |    1 
 arch/cris/arch-v32/kernel/debugport.c        |    1 
 arch/cris/arch-v32/kernel/fasttimer.c        |    1 
 arch/cris/arch-v32/kernel/ptrace.c           |    1 
 arch/cris/arch-v32/mach-a3/dma.c             |    1 
 arch/cris/arch-v32/mach-fs/dma.c             |    1 
 arch/cris/include/arch-v10/arch/elf.h        |    2 +
 arch/cris/include/arch-v32/arch/elf.h        |    2 +
 arch/cris/include/asm/atomic.h               |    2 -
 arch/cris/include/asm/barrier.h              |   23 ++++++
 arch/cris/include/asm/bitops.h               |    1 
 arch/cris/include/asm/cmpxchg.h              |   51 ++++++++++++++
 arch/cris/include/asm/exec.h                 |    6 ++
 arch/cris/include/asm/processor.h            |   11 +++
 arch/cris/include/asm/switch_to.h            |   12 +++
 arch/cris/include/asm/system.h               |   94 +-------------------------
 arch/cris/kernel/irq.c                       |    1 
 arch/cris/kernel/process.c                   |    1 
 arch/cris/kernel/ptrace.c                    |    1 
 arch/cris/kernel/setup.c                     |    1 
 arch/cris/kernel/traps.c                     |    1 
 arch/cris/mm/fault.c                         |    1 
 drivers/tty/serial/crisv10.c                 |    1 
 38 files changed, 123 insertions(+), 109 deletions(-)
 create mode 100644 arch/cris/include/asm/barrier.h
 create mode 100644 arch/cris/include/asm/cmpxchg.h
 create mode 100644 arch/cris/include/asm/exec.h
 create mode 100644 arch/cris/include/asm/switch_to.h

diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 3d655dc..74f99c6 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -24,7 +24,6 @@
 #include <linux/capability.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index a276f08..609d551 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -24,7 +24,6 @@
 #include <asm/etraxgpio.h>
 #include <arch/svinto.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <arch/io_interface_mux.h>
 
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index c413539..b3d1f9e 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -22,7 +22,6 @@
 
 #include <asm/etraxi2c.h>
 
-#include <asm/system.h>
 #include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/delay.h>
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index 1391b73..9da0568 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -29,7 +29,6 @@
 #include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
 
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 466af40..c4b7171 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -27,7 +27,6 @@
 #include <asm/io.h>
 #include <arch/svinto.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/sync_serial.h>
 #include <arch/io_interface_mux.h>
 
diff --git a/arch/cris/arch-v10/kernel/debugport.c b/arch/cris/arch-v10/kernel/debugport.c
index 99851ba..f932c85 100644
--- a/arch/cris/arch-v10/kernel/debugport.c
+++ b/arch/cris/arch-v10/kernel/debugport.c
@@ -18,7 +18,6 @@
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <linux/tty.h>
-#include <asm/system.h>
 #include <arch/svinto.h>
 #include <asm/io.h>             /* Get SIMCOUT. */
 
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
diff --git a/arch/cris/arch-v10/kernel/ptrace.c b/arch/cris/arch-v10/kernel/ptrace.c
index 320065f..bfddfb9 100644
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -15,7 +15,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 /* 
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
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index ddb2399..3b2c82c 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -36,7 +36,6 @@
 
 #include <asm/etraxi2c.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index c845831..0b86dee 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -31,7 +31,6 @@
 #include <hwregs/gio_defs.h>
 #include <hwregs/intr_vect_defs.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/pinmux.h>
 
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index ee90d26..a2ac091 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -30,7 +30,6 @@
 #include <hwregs/gio_defs.h>
 #include <hwregs/intr_vect_defs.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/kernel/debugport.c b/arch/cris/arch-v32/kernel/debugport.c
index 794b364..610909b 100644
--- a/arch/cris/arch-v32/kernel/debugport.c
+++ b/arch/cris/arch-v32/kernel/debugport.c
@@ -4,7 +4,6 @@
 
 #include <linux/console.h>
 #include <linux/init.h>
-#include <asm/system.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/ser_defs.h>
diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index 111caa1..ab1551e 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -17,7 +17,6 @@
 #include <linux/delay.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 511ece9..f7ad9e8 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -15,7 +15,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <arch/hwregs/supp_reg.h>
 
diff --git a/arch/cris/arch-v32/mach-a3/dma.c b/arch/cris/arch-v32/mach-a3/dma.c
index f35e4f6..47c64bf 100644
--- a/arch/cris/arch-v32/mach-a3/dma.c
+++ b/arch/cris/arch-v32/mach-a3/dma.c
@@ -9,7 +9,6 @@
 #include <hwregs/clkgen_defs.h>
 #include <hwregs/strmux_defs.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <arbiter.h>
 
 static char used_dma_channels[MAX_DMA_CHANNELS];
diff --git a/arch/cris/arch-v32/mach-fs/dma.c b/arch/cris/arch-v32/mach-fs/dma.c
index 2d970d7..fc6416a 100644
--- a/arch/cris/arch-v32/mach-fs/dma.c
+++ b/arch/cris/arch-v32/mach-fs/dma.c
@@ -9,7 +9,6 @@
 #include <hwregs/config_defs.h>
 #include <hwregs/strmux_defs.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <mach/arbiter.h>
 
 static char used_dma_channels[MAX_DMA_CHANNELS];
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
index bbf0938..1056a5d 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -5,7 +5,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/system.h>
+#include <asm/cmpxchg.h>
 #include <arch/atomic.h>
 
 /*
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
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index a78a2d7..184066c 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -19,7 +19,6 @@
 #endif
 
 #include <arch/bitops.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
 
diff --git a/arch/cris/include/asm/cmpxchg.h b/arch/cris/include/asm/cmpxchg.h
new file mode 100644
index 0000000..7ee390e
--- /dev/null
+++ b/arch/cris/include/asm/cmpxchg.h
@@ -0,0 +1,51 @@
+#ifndef __ASM_CRIS_CMPXCHG__
+#define __ASM_CRIS_CMPXCHG__
+
+#include <linux/irqflags.h>
+
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
+#endif /* __ASM_CRIS_CMPXCHG__ */
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
index 3f7248f..4210d72 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -10,10 +10,10 @@
 #ifndef __ASM_CRIS_PROCESSOR_H
 #define __ASM_CRIS_PROCESSOR_H
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <arch/processor.h>
+#include <arch/system.h>
 
 struct task_struct;
 
@@ -72,4 +72,13 @@ static inline void release_thread(struct task_struct *dead_task)
 
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
index ea10592..a7f4057 100644
--- a/arch/cris/include/asm/system.h
+++ b/arch/cris/include/asm/system.h
@@ -1,89 +1,5 @@
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
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
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
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index aa585e4..41a973b 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -16,7 +16,6 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/init_task.h>
diff --git a/arch/cris/kernel/ptrace.c b/arch/cris/kernel/ptrace.c
index 48b0f39..d114ad3 100644
--- a/arch/cris/kernel/ptrace.c
+++ b/arch/cris/kernel/ptrace.c
@@ -21,7 +21,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 
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
index 1dfba7b..fb13a17 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -37,6 +37,7 @@ static char *serial_version = "$Revision: 1.25 $";
 #include <asm/system.h>
 
 #include <arch/svinto.h>
+#include <arch/system.h>
 
 /* non-arch dependent serial structures are in linux/serial.h */
 #include <linux/serial.h>

