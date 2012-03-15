Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161571Ab2COU4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:56:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161544Ab2COU4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:56:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 05/38] Disintegrate asm/system.h for ARM [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 15 Mar 2012 20:56:03 +0000
Message-ID: <20120315205603.28759.91855.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-arm-kernel@lists.infradead.org
---

 arch/arm/common/via82c505.c                  |    1 
 arch/arm/include/asm/atomic.h                |    4 
 arch/arm/include/asm/barrier.h               |   70 ++++
 arch/arm/include/asm/bitops.h                |    2 
 arch/arm/include/asm/bug.h                   |   30 ++
 arch/arm/include/asm/cmpxchg.h               |  295 ++++++++++++++++
 arch/arm/include/asm/compiler.h              |   15 +
 arch/arm/include/asm/div64.h                 |    2 
 arch/arm/include/asm/dma.h                   |    1 
 arch/arm/include/asm/domain.h                |    4 
 arch/arm/include/asm/exec.h                  |    6 
 arch/arm/include/asm/io.h                    |    2 
 arch/arm/include/asm/mmu.h                   |    7 
 arch/arm/include/asm/processor.h             |    1 
 arch/arm/include/asm/switch_to.h             |   18 +
 arch/arm/include/asm/system.h                |  474 --------------------------
 arch/arm/include/asm/system_info.h           |   27 +
 arch/arm/include/asm/system_misc.h           |   30 ++
 arch/arm/include/asm/uaccess.h               |    2 
 arch/arm/kernel/armksyms.c                   |    1 
 arch/arm/kernel/elf.c                        |    1 
 arch/arm/kernel/entry-armv.S                 |    2 
 arch/arm/kernel/hw_breakpoint.c              |    1 
 arch/arm/kernel/irq.c                        |    1 
 arch/arm/kernel/kprobes-common.c             |    1 
 arch/arm/kernel/machine_kexec.c              |    2 
 arch/arm/kernel/process.c                    |    1 
 arch/arm/kernel/ptrace.c                     |    1 
 arch/arm/kernel/setup.c                      |    2 
 arch/arm/kernel/sleep.S                      |    1 
 arch/arm/kernel/tcm.c                        |    1 
 arch/arm/kernel/thumbee.c                    |    1 
 arch/arm/kernel/traps.c                      |    2 
 arch/arm/mach-at91/at91cap9.c                |    2 
 arch/arm/mach-at91/at91rm9200.c              |    1 
 arch/arm/mach-at91/at91sam9260.c             |    1 
 arch/arm/mach-at91/at91sam9261.c             |    1 
 arch/arm/mach-at91/at91sam9263.c             |    1 
 arch/arm/mach-at91/at91sam9g45.c             |    1 
 arch/arm/mach-at91/at91sam9rl.c              |    1 
 arch/arm/mach-at91/include/mach/system_rev.h |    2 
 arch/arm/mach-clps711x/common.c              |    1 
 arch/arm/mach-clps711x/p720t-leds.c          |    1 
 arch/arm/mach-davinci/board-da850-evm.c      |    1 
 arch/arm/mach-ebsa110/core.c                 |    2 
 arch/arm/mach-ebsa110/leds.c                 |    1 
 arch/arm/mach-footbridge/common.c            |    1 
 arch/arm/mach-footbridge/dc21285-timer.c     |    1 
 arch/arm/mach-footbridge/dc21285.c           |    1 
 arch/arm/mach-footbridge/ebsa285-leds.c      |    1 
 arch/arm/mach-footbridge/netwinder-hw.c      |    1 
 arch/arm/mach-footbridge/netwinder-leds.c    |    1 
 arch/arm/mach-imx/dma-v1.c                   |    1 
 arch/arm/mach-imx/mach-imx6q.c               |    1 
 arch/arm/mach-imx/mach-mx51_efikamx.c        |    1 
 arch/arm/mach-imx/mach-mx51_efikasb.c        |    1 
 arch/arm/mach-integrator/core.c              |    1 
 arch/arm/mach-integrator/leds.c              |    1 
 arch/arm/mach-integrator/pci.c               |    1 
 arch/arm/mach-integrator/pci_v3.c            |    1 
 arch/arm/mach-iop33x/uart.c                  |    1 
 arch/arm/mach-ixp2000/core.c                 |    1 
 arch/arm/mach-ixp2000/enp2611.c              |    1 
 arch/arm/mach-ixp2000/ixdp2400.c             |    1 
 arch/arm/mach-ixp2000/ixdp2800.c             |    1 
 arch/arm/mach-ixp2000/ixdp2x00.c             |    1 
 arch/arm/mach-ixp2000/ixdp2x01.c             |    1 
 arch/arm/mach-ixp2000/pci.c                  |    1 
 arch/arm/mach-ixp23xx/core.c                 |    1 
 arch/arm/mach-ixp23xx/espresso.c             |    1 
 arch/arm/mach-ixp23xx/ixdp2351.c             |    1 
 arch/arm/mach-ixp23xx/pci.c                  |    1 
 arch/arm/mach-ixp23xx/roadrunner.c           |    1 
 arch/arm/mach-ixp4xx/common-pci.c            |    1 
 arch/arm/mach-ixp4xx/goramo_mlr.c            |    1 
 arch/arm/mach-ks8695/time.c                  |    1 
 arch/arm/mach-mmp/common.c                   |    1 
 arch/arm/mach-mmp/pxa168.c                   |    1 
 arch/arm/mach-msm/board-sapphire.c           |    1 
 arch/arm/mach-mxs/system.c                   |    2 
 arch/arm/mach-omap1/id.c                     |    1 
 arch/arm/mach-omap1/leds-h2p2-debug.c        |    1 
 arch/arm/mach-omap1/leds-innovator.c         |    1 
 arch/arm/mach-omap1/leds-osk.c               |    1 
 arch/arm/mach-omap1/mux.c                    |    1 
 arch/arm/mach-omap1/time.c                   |    1 
 arch/arm/mach-omap1/timer32k.c               |    1 
 arch/arm/mach-omap2/board-omap3touchbook.c   |    1 
 arch/arm/mach-omap2/board-rx51-peripherals.c |    1 
 arch/arm/mach-omap2/mux.c                    |    1 
 arch/arm/mach-omap2/omap-mpuss-lowpower.c    |    1 
 arch/arm/mach-omap2/pm24xx.c                 |    1 
 arch/arm/mach-omap2/pm34xx.c                 |    1 
 arch/arm/mach-omap2/pm44xx.c                 |    1 
 arch/arm/mach-omap2/sleep44xx.S              |    1 
 arch/arm/mach-orion5x/common.c               |    1 
 arch/arm/mach-orion5x/dns323-setup.c         |    1 
 arch/arm/mach-orion5x/ls-chl-setup.c         |    1 
 arch/arm/mach-orion5x/ls_hgl-setup.c         |    1 
 arch/arm/mach-orion5x/lsmini-setup.c         |    1 
 arch/arm/mach-pnx4008/core.c                 |    2 
 arch/arm/mach-pnx4008/dma.c                  |    1 
 arch/arm/mach-pnx4008/irq.c                  |    1 
 arch/arm/mach-pnx4008/time.c                 |    1 
 arch/arm/mach-pxa/cm-x300.c                  |    1 
 arch/arm/mach-pxa/colibri-pxa3xx.c           |    1 
 arch/arm/mach-pxa/corgi.c                    |    1 
 arch/arm/mach-pxa/generic.c                  |    1 
 arch/arm/mach-pxa/leds-idp.c                 |    1 
 arch/arm/mach-pxa/leds-lubbock.c             |    1 
 arch/arm/mach-pxa/leds-mainstone.c           |    1 
 arch/arm/mach-pxa/magician.c                 |    1 
 arch/arm/mach-pxa/poodle.c                   |    1 
 arch/arm/mach-pxa/reset.c                    |    1 
 arch/arm/mach-pxa/viper.c                    |    1 
 arch/arm/mach-pxa/zeus.c                     |    1 
 arch/arm/mach-realview/core.c                |    1 
 arch/arm/mach-rpc/riscpc.c                   |    1 
 arch/arm/mach-s3c2410/s3c2410.c              |    1 
 arch/arm/mach-s3c2412/s3c2412.c              |    1 
 arch/arm/mach-s3c2416/s3c2416.c              |    1 
 arch/arm/mach-s3c2440/s3c244x.c              |    1 
 arch/arm/mach-s3c2443/s3c2443.c              |    1 
 arch/arm/mach-s3c64xx/common.c               |    1 
 arch/arm/mach-s5p64x0/common.c               |    1 
 arch/arm/mach-s5pc100/common.c               |    1 
 arch/arm/mach-sa1100/dma.c                   |    1 
 arch/arm/mach-sa1100/generic.c               |    2 
 arch/arm/mach-sa1100/leds-assabet.c          |    1 
 arch/arm/mach-sa1100/leds-badge4.c           |    1 
 arch/arm/mach-sa1100/leds-cerf.c             |    1 
 arch/arm/mach-sa1100/leds-hackkit.c          |    1 
 arch/arm/mach-sa1100/leds-lart.c             |    1 
 arch/arm/mach-sa1100/pm.c                    |    1 
 arch/arm/mach-shark/leds.c                   |    1 
 arch/arm/mach-shmobile/cpuidle.c             |    1 
 arch/arm/mach-shmobile/include/mach/system.h |    2 
 arch/arm/mach-shmobile/pm-r8a7779.c          |    1 
 arch/arm/mach-shmobile/pm-sh7372.c           |    1 
 arch/arm/mach-shmobile/suspend.c             |    2 
 arch/arm/mach-tegra/cpu-tegra.c              |    1 
 arch/arm/mach-versatile/core.c               |    1 
 arch/arm/mach-versatile/pci.c                |    1 
 arch/arm/mach-w90x900/cpu.c                  |    1 
 arch/arm/mm/alignment.c                      |    1 
 arch/arm/mm/fault.c                          |    3 
 arch/arm/mm/flush.c                          |    1 
 arch/arm/mm/idmap.c                          |    1 
 arch/arm/mm/ioremap.c                        |    1 
 arch/arm/mm/mmu.c                            |    1 
 arch/arm/mm/proc-fa526.S                     |    1 
 arch/arm/nwfpe/fpa11.c                       |    1 
 arch/arm/plat-iop/i2c.c                      |    1 
 arch/arm/plat-iop/pci.c                      |    1 
 arch/arm/plat-iop/restart.c                  |    1 
 arch/arm/plat-mxc/system.c                   |    2 
 arch/arm/plat-omap/debug-leds.c              |    1 
 arch/arm/plat-omap/dma.c                     |    1 
 arch/arm/plat-omap/mux.c                     |    1 
 arch/arm/plat-pxa/dma.c                      |    1 
 arch/arm/plat-s3c24xx/cpu.c                  |    1 
 arch/arm/plat-s3c24xx/dma.c                  |    1 
 arch/arm/plat-samsung/cpu.c                  |    1 
 arch/arm/plat-samsung/time.c                 |    1 
 arch/arm/plat-spear/restart.c                |    1 
 arch/arm/vfp/vfpmodule.c                     |    1 
 drivers/cpuidle/cpuidle.c                    |    1 
 drivers/net/ethernet/8390/etherh.c           |    1 
 drivers/tty/serial/21285.c                   |    1 
 drivers/watchdog/wdt285.c                    |    1 
 include/linux/mtd/map.h                      |    2 
 171 files changed, 594 insertions(+), 565 deletions(-)
 create mode 100644 arch/arm/include/asm/barrier.h
 create mode 100644 arch/arm/include/asm/cmpxchg.h
 create mode 100644 arch/arm/include/asm/compiler.h
 create mode 100644 arch/arm/include/asm/exec.h
 create mode 100644 arch/arm/include/asm/switch_to.h
 create mode 100644 arch/arm/include/asm/system_info.h
 create mode 100644 arch/arm/include/asm/system_misc.h

diff --git a/arch/arm/common/via82c505.c b/arch/arm/common/via82c505.c
index 67dd2af..1171a50 100644
--- a/arch/arm/common/via82c505.c
+++ b/arch/arm/common/via82c505.c
@@ -6,7 +6,6 @@
 #include <linux/ioport.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #include <asm/mach/pci.h>
 
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 86976d0..68374ba 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -13,7 +13,9 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/system.h>
+#include <linux/irqflags.h>
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
diff --git a/arch/arm/include/asm/barrier.h b/arch/arm/include/asm/barrier.h
new file mode 100644
index 0000000..408e392
--- /dev/null
+++ b/arch/arm/include/asm/barrier.h
@@ -0,0 +1,70 @@
+#ifndef __ASM_BARRIER_H
+#define __ASM_BARRIER_H
+
+#ifdef __ASSEMBLY__
+#error do not include asm/barrier.h from assembly
+#endif
+
+#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
+
+#if __LINUX_ARM_ARCH__ >= 7 ||		\
+	(__LINUX_ARM_ARCH__ == 6 && defined(CONFIG_CPU_32v6K))
+#define sev()	__asm__ __volatile__ ("sev" : : : "memory")
+#define wfe()	__asm__ __volatile__ ("wfe" : : : "memory")
+#define wfi()	__asm__ __volatile__ ("wfi" : : : "memory")
+#endif
+
+#if __LINUX_ARM_ARCH__ >= 7
+#define isb() __asm__ __volatile__ ("isb" : : : "memory")
+#define dsb() __asm__ __volatile__ ("dsb" : : : "memory")
+#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
+#elif defined(CONFIG_CPU_XSC3) || __LINUX_ARM_ARCH__ == 6
+#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
+				    : : "r" (0) : "memory")
+#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
+				    : : "r" (0) : "memory")
+#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
+				    : : "r" (0) : "memory")
+#elif defined(CONFIG_CPU_FA526)
+#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
+				    : : "r" (0) : "memory")
+#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
+				    : : "r" (0) : "memory")
+#define dmb() __asm__ __volatile__ ("" : : : "memory")
+#else
+#define isb() __asm__ __volatile__ ("" : : : "memory")
+#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
+				    : : "r" (0) : "memory")
+#define dmb() __asm__ __volatile__ ("" : : : "memory")
+#endif
+
+#ifdef CONFIG_ARCH_HAS_BARRIERS
+#include <mach/barriers.h>
+#elif defined(CONFIG_ARM_DMA_MEM_BUFFERABLE) || defined(CONFIG_SMP)
+#include <asm/outercache.h>
+#define mb()		do { dsb(); outer_sync(); } while (0)
+#define rmb()		dsb()
+#define wmb()		mb()
+#else
+#include <asm/memory.h>
+#define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
+#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
+#define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
+#endif
+
+#ifndef CONFIG_SMP
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#else
+#define smp_mb()	dmb()
+#define smp_rmb()	dmb()
+#define smp_wmb()	dmb()
+#endif
+
+#define read_barrier_depends()		do { } while(0)
+#define smp_read_barrier_depends()	do { } while(0)
+
+#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
+
+#endif /* __ASM_BARRIER_H */
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index f7419ef..e691ec9 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -24,7 +24,7 @@
 #endif
 
 #include <linux/compiler.h>
-#include <asm/system.h>
+#include <linux/irqflags.h>
 
 #define smp_mb__before_clear_bit()	smp_mb()
 #define smp_mb__after_clear_bit()	smp_mb()
diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
index fac79dc..7af5c6c 100644
--- a/arch/arm/include/asm/bug.h
+++ b/arch/arm/include/asm/bug.h
@@ -1,6 +1,7 @@
 #ifndef _ASMARM_BUG_H
 #define _ASMARM_BUG_H
 
+#include <linux/linkage.h>
 
 #ifdef CONFIG_BUG
 
@@ -57,4 +58,33 @@ do {								\
 
 #include <asm-generic/bug.h>
 
+struct pt_regs;
+void die(const char *msg, struct pt_regs *regs, int err);
+
+struct siginfo;
+void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
+		unsigned long err, unsigned long trap);
+
+#ifdef CONFIG_ARM_LPAE
+#define FAULT_CODE_ALIGNMENT	33
+#define FAULT_CODE_DEBUG	34
+#else
+#define FAULT_CODE_ALIGNMENT	1
+#define FAULT_CODE_DEBUG	2
+#endif
+
+void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
+				       struct pt_regs *),
+		     int sig, int code, const char *name);
+
+void hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int,
+				       struct pt_regs *),
+		     int sig, int code, const char *name);
+
+extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+
+struct mm_struct;
+extern void show_pte(struct mm_struct *mm, unsigned long addr);
+extern void __show_regs(struct pt_regs *);
+
 #endif
diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
new file mode 100644
index 0000000..d41d7cb
--- /dev/null
+++ b/arch/arm/include/asm/cmpxchg.h
@@ -0,0 +1,295 @@
+#ifndef __ASM_ARM_CMPXCHG_H
+#define __ASM_ARM_CMPXCHG_H
+
+#include <linux/irqflags.h>
+#include <asm/barrier.h>
+
+#if defined(CONFIG_CPU_SA1100) || defined(CONFIG_CPU_SA110)
+/*
+ * On the StrongARM, "swp" is terminally broken since it bypasses the
+ * cache totally.  This means that the cache becomes inconsistent, and,
+ * since we use normal loads/stores as well, this is really bad.
+ * Typically, this causes oopsen in filp_close, but could have other,
+ * more disastrous effects.  There are two work-arounds:
+ *  1. Disable interrupts and emulate the atomic swap
+ *  2. Clean the cache, perform atomic swap, flush the cache
+ *
+ * We choose (1) since its the "easiest" to achieve here and is not
+ * dependent on the processor type.
+ *
+ * NOTE that this solution won't work on an SMP system, so explcitly
+ * forbid it here.
+ */
+#define swp_is_buggy
+#endif
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
+{
+	extern void __bad_xchg(volatile void *, int);
+	unsigned long ret;
+#ifdef swp_is_buggy
+	unsigned long flags;
+#endif
+#if __LINUX_ARM_ARCH__ >= 6
+	unsigned int tmp;
+#endif
+
+	smp_mb();
+
+	switch (size) {
+#if __LINUX_ARM_ARCH__ >= 6
+	case 1:
+		asm volatile("@	__xchg1\n"
+		"1:	ldrexb	%0, [%3]\n"
+		"	strexb	%1, %2, [%3]\n"
+		"	teq	%1, #0\n"
+		"	bne	1b"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("@	__xchg4\n"
+		"1:	ldrex	%0, [%3]\n"
+		"	strex	%1, %2, [%3]\n"
+		"	teq	%1, #0\n"
+		"	bne	1b"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+#elif defined(swp_is_buggy)
+#ifdef CONFIG_SMP
+#error SMP is not supported on this platform
+#endif
+	case 1:
+		raw_local_irq_save(flags);
+		ret = *(volatile unsigned char *)ptr;
+		*(volatile unsigned char *)ptr = x;
+		raw_local_irq_restore(flags);
+		break;
+
+	case 4:
+		raw_local_irq_save(flags);
+		ret = *(volatile unsigned long *)ptr;
+		*(volatile unsigned long *)ptr = x;
+		raw_local_irq_restore(flags);
+		break;
+#else
+	case 1:
+		asm volatile("@	__xchg1\n"
+		"	swpb	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("@	__xchg4\n"
+		"	swp	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+#endif
+	default:
+		__bad_xchg(ptr, size), ret = 0;
+		break;
+	}
+	smp_mb();
+
+	return ret;
+}
+
+#define xchg(ptr,x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+#if __LINUX_ARM_ARCH__ < 6
+/* min ARCH < ARMv6 */
+
+#ifdef CONFIG_SMP
+#error "SMP is not supported on this platform"
+#endif
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
+#else	/* min ARCH >= ARMv6 */
+
+extern void __bad_cmpxchg(volatile void *ptr, int size);
+
+/*
+ * cmpxchg only support 32-bits operands on ARMv6.
+ */
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long oldval, res;
+
+	switch (size) {
+#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
+	case 1:
+		do {
+			asm volatile("@ __cmpxchg1\n"
+			"	ldrexb	%1, [%2]\n"
+			"	mov	%0, #0\n"
+			"	teq	%1, %3\n"
+			"	strexbeq %0, %4, [%2]\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "memory", "cc");
+		} while (res);
+		break;
+	case 2:
+		do {
+			asm volatile("@ __cmpxchg1\n"
+			"	ldrexh	%1, [%2]\n"
+			"	mov	%0, #0\n"
+			"	teq	%1, %3\n"
+			"	strexheq %0, %4, [%2]\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "memory", "cc");
+		} while (res);
+		break;
+#endif
+	case 4:
+		do {
+			asm volatile("@ __cmpxchg4\n"
+			"	ldrex	%1, [%2]\n"
+			"	mov	%0, #0\n"
+			"	teq	%1, %3\n"
+			"	strexeq %0, %4, [%2]\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "memory", "cc");
+		} while (res);
+		break;
+	default:
+		__bad_cmpxchg(ptr, size);
+		oldval = 0;
+	}
+
+	return oldval;
+}
+
+static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
+					 unsigned long new, int size)
+{
+	unsigned long ret;
+
+	smp_mb();
+	ret = __cmpxchg(ptr, old, new, size);
+	smp_mb();
+
+	return ret;
+}
+
+#define cmpxchg(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg_mb((ptr),			\
+					  (unsigned long)(o),		\
+					  (unsigned long)(n),		\
+					  sizeof(*(ptr))))
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+					    unsigned long old,
+					    unsigned long new, int size)
+{
+	unsigned long ret;
+
+	switch (size) {
+#ifdef CONFIG_CPU_V6	/* min ARCH == ARMv6 */
+	case 1:
+	case 2:
+		ret = __cmpxchg_local_generic(ptr, old, new, size);
+		break;
+#endif
+	default:
+		ret = __cmpxchg(ptr, old, new, size);
+	}
+
+	return ret;
+}
+
+#define cmpxchg_local(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),			\
+				       (unsigned long)(o),		\
+				       (unsigned long)(n),		\
+				       sizeof(*(ptr))))
+
+#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
+
+/*
+ * Note : ARMv7-M (currently unsupported by Linux) does not support
+ * ldrexd/strexd. If ARMv7-M is ever supported by the Linux kernel, it should
+ * not be allowed to use __cmpxchg64.
+ */
+static inline unsigned long long __cmpxchg64(volatile void *ptr,
+					     unsigned long long old,
+					     unsigned long long new)
+{
+	register unsigned long long oldval asm("r0");
+	register unsigned long long __old asm("r2") = old;
+	register unsigned long long __new asm("r4") = new;
+	unsigned long res;
+
+	do {
+		asm volatile(
+		"	@ __cmpxchg8\n"
+		"	ldrexd	%1, %H1, [%2]\n"
+		"	mov	%0, #0\n"
+		"	teq	%1, %3\n"
+		"	teqeq	%H1, %H3\n"
+		"	strexdeq %0, %4, %H4, [%2]\n"
+			: "=&r" (res), "=&r" (oldval)
+			: "r" (ptr), "Ir" (__old), "r" (__new)
+			: "memory", "cc");
+	} while (res);
+
+	return oldval;
+}
+
+static inline unsigned long long __cmpxchg64_mb(volatile void *ptr,
+						unsigned long long old,
+						unsigned long long new)
+{
+	unsigned long long ret;
+
+	smp_mb();
+	ret = __cmpxchg64(ptr, old, new);
+	smp_mb();
+
+	return ret;
+}
+
+#define cmpxchg64(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg64_mb((ptr),			\
+					    (unsigned long long)(o),	\
+					    (unsigned long long)(n)))
+
+#define cmpxchg64_local(ptr,o,n)					\
+	((__typeof__(*(ptr)))__cmpxchg64((ptr),				\
+					 (unsigned long long)(o),	\
+					 (unsigned long long)(n)))
+
+#else /* min ARCH = ARMv6 */
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#endif
+
+#endif	/* __LINUX_ARM_ARCH__ >= 6 */
+
+#endif /* __ASM_ARM_CMPXCHG_H */
diff --git a/arch/arm/include/asm/compiler.h b/arch/arm/include/asm/compiler.h
new file mode 100644
index 0000000..8155db2
--- /dev/null
+++ b/arch/arm/include/asm/compiler.h
@@ -0,0 +1,15 @@
+#ifndef __ASM_ARM_COMPILER_H
+#define __ASM_ARM_COMPILER_H
+
+/*
+ * This is used to ensure the compiler did actually allocate the register we
+ * asked it for some inline assembly sequences.  Apparently we can't trust
+ * the compiler from one version to another so a bit of paranoia won't hurt.
+ * This string is meant to be concatenated with the inline asm string and
+ * will cause compilation to stop on mismatch.
+ * (for details, see gcc PR 15089)
+ */
+#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
+
+
+#endif /* __ASM_ARM_COMPILER_H */
diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index d3f0a9e..fe92ccf 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -1,8 +1,8 @@
 #ifndef __ASM_ARM_DIV64
 #define __ASM_ARM_DIV64
 
-#include <asm/system.h>
 #include <linux/types.h>
+#include <asm/compiler.h>
 
 /*
  * The semantics of do_div() are:
diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 69a5b0b..5694a0d 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -19,7 +19,6 @@
  * It should not be re-used except for that purpose.
  */
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <asm/scatterlist.h>
 
 #include <mach/isa-dma.h>
diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index b5dc173..3d22204 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -10,6 +10,10 @@
 #ifndef __ASM_PROC_DOMAIN_H
 #define __ASM_PROC_DOMAIN_H
 
+#ifndef __ASSEMBLY__
+#include <asm/barrier.h>
+#endif
+
 /*
  * Domain numbers
  *
diff --git a/arch/arm/include/asm/exec.h b/arch/arm/include/asm/exec.h
new file mode 100644
index 0000000..7c4fbef
--- /dev/null
+++ b/arch/arm/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_ARM_EXEC_H
+#define __ASM_ARM_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __ASM_ARM_EXEC_H */
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 9275828..bae7eb6 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 #include <asm/memory.h>
-#include <asm/system.h>
 #include <asm-generic/pci_iomap.h>
 
 /*
@@ -99,6 +98,7 @@ static inline void __iomem *__typesafe_io(unsigned long addr)
 
 /* IO barriers */
 #ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
+#include <asm/barrier.h>
 #define __iormb()		rmb()
 #define __iowmb()		wmb()
 #else
diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
index 1496565..b8e580a 100644
--- a/arch/arm/include/asm/mmu.h
+++ b/arch/arm/include/asm/mmu.h
@@ -34,4 +34,11 @@ typedef struct {
 
 #endif
 
+/*
+ * switch_mm() may do a full cache flush over the context switch,
+ * so enable interrupts over the context switch to avoid high
+ * latency.
+ */
+#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
+
 #endif
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index cb8d638..ce280b8 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -22,7 +22,6 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/ptrace.h>
 #include <asm/types.h>
-#include <asm/system.h>
 
 #ifdef __KERNEL__
 #define STACK_TOP	((current->personality & ADDR_LIMIT_32BIT) ? \
diff --git a/arch/arm/include/asm/switch_to.h b/arch/arm/include/asm/switch_to.h
new file mode 100644
index 0000000..fa09e6b
--- /dev/null
+++ b/arch/arm/include/asm/switch_to.h
@@ -0,0 +1,18 @@
+#ifndef __ASM_ARM_SWITCH_TO_H
+#define __ASM_ARM_SWITCH_TO_H
+
+#include <linux/thread_info.h>
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.  schedule() itself
+ * contains the memory barrier to tell GCC not to cache `current'.
+ */
+extern struct task_struct *__switch_to(struct task_struct *, struct thread_info *, struct thread_info *);
+
+#define switch_to(prev,next,last)					\
+do {									\
+	last = __switch_to(prev,task_thread_info(prev), task_thread_info(next));	\
+} while (0)
+
+#endif /* __ASM_ARM_SWITCH_TO_H */
diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index 774c41e..74542c5 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -1,466 +1,8 @@
-#ifndef __ASM_ARM_SYSTEM_H
-#define __ASM_ARM_SYSTEM_H
-
-#ifdef __KERNEL__
-
-#define CPU_ARCH_UNKNOWN	0
-#define CPU_ARCH_ARMv3		1
-#define CPU_ARCH_ARMv4		2
-#define CPU_ARCH_ARMv4T		3
-#define CPU_ARCH_ARMv5		4
-#define CPU_ARCH_ARMv5T		5
-#define CPU_ARCH_ARMv5TE	6
-#define CPU_ARCH_ARMv5TEJ	7
-#define CPU_ARCH_ARMv6		8
-#define CPU_ARCH_ARMv7		9
-
-/*
- * This is used to ensure the compiler did actually allocate the register we
- * asked it for some inline assembly sequences.  Apparently we can't trust
- * the compiler from one version to another so a bit of paranoia won't hurt.
- * This string is meant to be concatenated with the inline asm string and
- * will cause compilation to stop on mismatch.
- * (for details, see gcc PR 15089)
- */
-#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
-
-#ifndef __ASSEMBLY__
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-
-#include <asm/outercache.h>
-
-struct thread_info;
-struct task_struct;
-
-/* information about the system we're running on */
-extern unsigned int system_rev;
-extern unsigned int system_serial_low;
-extern unsigned int system_serial_high;
-extern unsigned int mem_fclk_21285;
-
-struct pt_regs;
-
-void die(const char *msg, struct pt_regs *regs, int err);
-
-struct siginfo;
-void arm_notify_die(const char *str, struct pt_regs *regs, struct siginfo *info,
-		unsigned long err, unsigned long trap);
-
-#ifdef CONFIG_ARM_LPAE
-#define FAULT_CODE_ALIGNMENT	33
-#define FAULT_CODE_DEBUG	34
-#else
-#define FAULT_CODE_ALIGNMENT	1
-#define FAULT_CODE_DEBUG	2
-#endif
-
-void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-void hook_ifault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-#define xchg(ptr,x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
-
-struct mm_struct;
-extern void show_pte(struct mm_struct *mm, unsigned long addr);
-extern void __show_regs(struct pt_regs *);
-
-extern int __pure cpu_architecture(void);
-extern void cpu_init(void);
-
-void soft_restart(unsigned long);
-extern void (*arm_pm_restart)(char str, const char *cmd);
-
-#define UDBG_UNDEFINED	(1 << 0)
-#define UDBG_SYSCALL	(1 << 1)
-#define UDBG_BADABORT	(1 << 2)
-#define UDBG_SEGV	(1 << 3)
-#define UDBG_BUS	(1 << 4)
-
-extern unsigned int user_debug;
-
-#if __LINUX_ARM_ARCH__ >= 7 ||		\
-	(__LINUX_ARM_ARCH__ == 6 && defined(CONFIG_CPU_32v6K))
-#define sev()	__asm__ __volatile__ ("sev" : : : "memory")
-#define wfe()	__asm__ __volatile__ ("wfe" : : : "memory")
-#define wfi()	__asm__ __volatile__ ("wfi" : : : "memory")
-#endif
-
-#if __LINUX_ARM_ARCH__ >= 7
-#define isb() __asm__ __volatile__ ("isb" : : : "memory")
-#define dsb() __asm__ __volatile__ ("dsb" : : : "memory")
-#define dmb() __asm__ __volatile__ ("dmb" : : : "memory")
-#elif defined(CONFIG_CPU_XSC3) || __LINUX_ARM_ARCH__ == 6
-#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
-				    : : "r" (0) : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 5" \
-				    : : "r" (0) : "memory")
-#elif defined(CONFIG_CPU_FA526)
-#define isb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c5, 4" \
-				    : : "r" (0) : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-#else
-#define isb() __asm__ __volatile__ ("" : : : "memory")
-#define dsb() __asm__ __volatile__ ("mcr p15, 0, %0, c7, c10, 4" \
-				    : : "r" (0) : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-#endif
-
-#ifdef CONFIG_ARCH_HAS_BARRIERS
-#include <mach/barriers.h>
-#elif defined(CONFIG_ARM_DMA_MEM_BUFFERABLE) || defined(CONFIG_SMP)
-#define mb()		do { dsb(); outer_sync(); } while (0)
-#define rmb()		dsb()
-#define wmb()		mb()
-#else
-#include <asm/memory.h>
-#define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
-#endif
-
-#ifndef CONFIG_SMP
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#else
-#define smp_mb()	dmb()
-#define smp_rmb()	dmb()
-#define smp_wmb()	dmb()
-#endif
-
-#define read_barrier_depends()		do { } while(0)
-#define smp_read_barrier_depends()	do { } while(0)
-
-#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
-#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
-
-/*
- * switch_mm() may do a full cache flush over the context switch,
- * so enable interrupts over the context switch to avoid high
- * latency.
- */
-#define __ARCH_WANT_INTERRUPTS_ON_CTXSW
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.  schedule() itself
- * contains the memory barrier to tell GCC not to cache `current'.
- */
-extern struct task_struct *__switch_to(struct task_struct *, struct thread_info *, struct thread_info *);
-
-#define switch_to(prev,next,last)					\
-do {									\
-	last = __switch_to(prev,task_thread_info(prev), task_thread_info(next));	\
-} while (0)
-
-#if defined(CONFIG_CPU_SA1100) || defined(CONFIG_CPU_SA110)
-/*
- * On the StrongARM, "swp" is terminally broken since it bypasses the
- * cache totally.  This means that the cache becomes inconsistent, and,
- * since we use normal loads/stores as well, this is really bad.
- * Typically, this causes oopsen in filp_close, but could have other,
- * more disastrous effects.  There are two work-arounds:
- *  1. Disable interrupts and emulate the atomic swap
- *  2. Clean the cache, perform atomic swap, flush the cache
- *
- * We choose (1) since its the "easiest" to achieve here and is not
- * dependent on the processor type.
- *
- * NOTE that this solution won't work on an SMP system, so explcitly
- * forbid it here.
- */
-#define swp_is_buggy
-#endif
-
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
-{
-	extern void __bad_xchg(volatile void *, int);
-	unsigned long ret;
-#ifdef swp_is_buggy
-	unsigned long flags;
-#endif
-#if __LINUX_ARM_ARCH__ >= 6
-	unsigned int tmp;
-#endif
-
-	smp_mb();
-
-	switch (size) {
-#if __LINUX_ARM_ARCH__ >= 6
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"1:	ldrexb	%0, [%3]\n"
-		"	strexb	%1, %2, [%3]\n"
-		"	teq	%1, #0\n"
-		"	bne	1b"
-			: "=&r" (ret), "=&r" (tmp)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"1:	ldrex	%0, [%3]\n"
-		"	strex	%1, %2, [%3]\n"
-		"	teq	%1, #0\n"
-		"	bne	1b"
-			: "=&r" (ret), "=&r" (tmp)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-#elif defined(swp_is_buggy)
-#ifdef CONFIG_SMP
-#error SMP is not supported on this platform
-#endif
-	case 1:
-		raw_local_irq_save(flags);
-		ret = *(volatile unsigned char *)ptr;
-		*(volatile unsigned char *)ptr = x;
-		raw_local_irq_restore(flags);
-		break;
-
-	case 4:
-		raw_local_irq_save(flags);
-		ret = *(volatile unsigned long *)ptr;
-		*(volatile unsigned long *)ptr = x;
-		raw_local_irq_restore(flags);
-		break;
-#else
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"	swpb	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"	swp	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-#endif
-	default:
-		__bad_xchg(ptr, size), ret = 0;
-		break;
-	}
-	smp_mb();
-
-	return ret;
-}
-
-extern void disable_hlt(void);
-extern void enable_hlt(void);
-
-void cpu_idle_wait(void);
-
-#include <asm-generic/cmpxchg-local.h>
-
-#if __LINUX_ARM_ARCH__ < 6
-/* min ARCH < ARMv6 */
-
-#ifdef CONFIG_SMP
-#error "SMP is not supported on this platform"
-#endif
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#ifndef CONFIG_SMP
-#include <asm-generic/cmpxchg.h>
-#endif
-
-#else	/* min ARCH >= ARMv6 */
-
-extern void __bad_cmpxchg(volatile void *ptr, int size);
-
-/*
- * cmpxchg only support 32-bits operands on ARMv6.
- */
-
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long oldval, res;
-
-	switch (size) {
-#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
-	case 1:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexb	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexbeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-	case 2:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexh	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexheq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-#endif
-	case 4:
-		do {
-			asm volatile("@ __cmpxchg4\n"
-			"	ldrex	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
-		break;
-	default:
-		__bad_cmpxchg(ptr, size);
-		oldval = 0;
-	}
-
-	return oldval;
-}
-
-static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
-					 unsigned long new, int size)
-{
-	unsigned long ret;
-
-	smp_mb();
-	ret = __cmpxchg(ptr, old, new, size);
-	smp_mb();
-
-	return ret;
-}
-
-#define cmpxchg(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg_mb((ptr),			\
-					  (unsigned long)(o),		\
-					  (unsigned long)(n),		\
-					  sizeof(*(ptr))))
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-					    unsigned long old,
-					    unsigned long new, int size)
-{
-	unsigned long ret;
-
-	switch (size) {
-#ifdef CONFIG_CPU_V6	/* min ARCH == ARMv6 */
-	case 1:
-	case 2:
-		ret = __cmpxchg_local_generic(ptr, old, new, size);
-		break;
-#endif
-	default:
-		ret = __cmpxchg(ptr, old, new, size);
-	}
-
-	return ret;
-}
-
-#define cmpxchg_local(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr),			\
-				       (unsigned long)(o),		\
-				       (unsigned long)(n),		\
-				       sizeof(*(ptr))))
-
-#ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
-
-/*
- * Note : ARMv7-M (currently unsupported by Linux) does not support
- * ldrexd/strexd. If ARMv7-M is ever supported by the Linux kernel, it should
- * not be allowed to use __cmpxchg64.
- */
-static inline unsigned long long __cmpxchg64(volatile void *ptr,
-					     unsigned long long old,
-					     unsigned long long new)
-{
-	register unsigned long long oldval asm("r0");
-	register unsigned long long __old asm("r2") = old;
-	register unsigned long long __new asm("r4") = new;
-	unsigned long res;
-
-	do {
-		asm volatile(
-		"	@ __cmpxchg8\n"
-		"	ldrexd	%1, %H1, [%2]\n"
-		"	mov	%0, #0\n"
-		"	teq	%1, %3\n"
-		"	teqeq	%H1, %H3\n"
-		"	strexdeq %0, %4, %H4, [%2]\n"
-			: "=&r" (res), "=&r" (oldval)
-			: "r" (ptr), "Ir" (__old), "r" (__new)
-			: "memory", "cc");
-	} while (res);
-
-	return oldval;
-}
-
-static inline unsigned long long __cmpxchg64_mb(volatile void *ptr,
-						unsigned long long old,
-						unsigned long long new)
-{
-	unsigned long long ret;
-
-	smp_mb();
-	ret = __cmpxchg64(ptr, old, new);
-	smp_mb();
-
-	return ret;
-}
-
-#define cmpxchg64(ptr,o,n)						\
-	((__typeof__(*(ptr)))__cmpxchg64_mb((ptr),			\
-					    (unsigned long long)(o),	\
-					    (unsigned long long)(n)))
-
-#define cmpxchg64_local(ptr,o,n)					\
-	((__typeof__(*(ptr)))__cmpxchg64((ptr),				\
-					 (unsigned long long)(o),	\
-					 (unsigned long long)(n)))
-
-#else /* min ARCH = ARMv6 */
-
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#endif
-
-#endif	/* __LINUX_ARM_ARCH__ >= 6 */
-
-#endif /* __ASSEMBLY__ */
-
-#define arch_align_stack(x) (x)
-
-#endif /* __KERNEL__ */
-
-#endif
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/compiler.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
+#include <asm/system_info.h>
+#include <asm/system_misc.h>
diff --git a/arch/arm/include/asm/system_info.h b/arch/arm/include/asm/system_info.h
new file mode 100644
index 0000000..dfd386d
--- /dev/null
+++ b/arch/arm/include/asm/system_info.h
@@ -0,0 +1,27 @@
+#ifndef __ASM_ARM_SYSTEM_INFO_H
+#define __ASM_ARM_SYSTEM_INFO_H
+
+#define CPU_ARCH_UNKNOWN	0
+#define CPU_ARCH_ARMv3		1
+#define CPU_ARCH_ARMv4		2
+#define CPU_ARCH_ARMv4T		3
+#define CPU_ARCH_ARMv5		4
+#define CPU_ARCH_ARMv5T		5
+#define CPU_ARCH_ARMv5TE	6
+#define CPU_ARCH_ARMv5TEJ	7
+#define CPU_ARCH_ARMv6		8
+#define CPU_ARCH_ARMv7		9
+
+#ifndef __ASSEMBLY__
+
+/* information about the system we're running on */
+extern unsigned int system_rev;
+extern unsigned int system_serial_low;
+extern unsigned int system_serial_high;
+extern unsigned int mem_fclk_21285;
+
+extern int __pure cpu_architecture(void);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_ARM_SYSTEM_INFO_H */
diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
new file mode 100644
index 0000000..ccda6c2
--- /dev/null
+++ b/arch/arm/include/asm/system_misc.h
@@ -0,0 +1,30 @@
+#ifndef __ASM_ARM_SYSTEM_MISC_H
+#define __ASM_ARM_SYSTEM_MISC_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+
+extern void cpu_init(void);
+
+void soft_restart(unsigned long);
+extern void (*arm_pm_restart)(char str, const char *cmd);
+
+#define UDBG_UNDEFINED	(1 << 0)
+#define UDBG_SYSCALL	(1 << 1)
+#define UDBG_BADABORT	(1 << 2)
+#define UDBG_SEGV	(1 << 3)
+#define UDBG_BUS	(1 << 4)
+
+extern unsigned int user_debug;
+
+extern void disable_hlt(void);
+extern void enable_hlt(void);
+
+void cpu_idle_wait(void);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_ARM_SYSTEM_MISC_H */
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 2958976..71f6536 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -16,8 +16,8 @@
 #include <asm/errno.h>
 #include <asm/memory.h>
 #include <asm/domain.h>
-#include <asm/system.h>
 #include <asm/unified.h>
+#include <asm/compiler.h>
 
 #define VERIFY_READ 0
 #define VERIFY_WRITE 1
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 5b0bce6..b57c75e 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -18,7 +18,6 @@
 #include <linux/io.h>
 
 #include <asm/checksum.h>
-#include <asm/system.h>
 #include <asm/ftrace.h>
 
 /*
diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
index ddba41d..d0d1e83 100644
--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -3,6 +3,7 @@
 #include <linux/personality.h>
 #include <linux/binfmts.h>
 #include <linux/elf.h>
+#include <asm/system_info.h>
 
 int elf_check_arch(const struct elf32_hdr *x)
 {
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index be16a48..093a415 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -24,7 +24,7 @@
 #include <asm/unwind.h>
 #include <asm/unistd.h>
 #include <asm/tls.h>
-#include <asm/system.h>
+#include <asm/system_info.h>
 
 #include "entry-header.S"
 #include <asm/entry-macro-multi.S>
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index d6a95ef..ba386bd 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -34,7 +34,6 @@
 #include <asm/current.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/kdebug.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 /* Breakpoint currently in use for each BRP. */
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 3efd82c..6a6a097 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -36,7 +36,6 @@
 #include <linux/proc_fs.h>
 
 #include <asm/exception.h>
-#include <asm/system.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/kernel/kprobes-common.c b/arch/arm/kernel/kprobes-common.c
index a5394fb4..18a7628 100644
--- a/arch/arm/kernel/kprobes-common.c
+++ b/arch/arm/kernel/kprobes-common.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/kprobes.h>
+#include <asm/system_info.h>
 
 #include "kprobes.h"
 
diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 764bd45..5699598 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -12,7 +12,7 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
+#include <asm/system_misc.h>
 
 extern const unsigned char relocate_new_kernel[];
 extern const unsigned int relocate_new_kernel_size;
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 971d65c..784222c 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -35,7 +35,6 @@
 #include <asm/cacheflush.h>
 #include <asm/leds.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/thread_notify.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index ede6443..45956c9 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <linux/audit.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #define REG_PC	15
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 615e992..9b19972 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -53,6 +53,8 @@
 #include <asm/traps.h>
 #include <asm/unwind.h>
 #include <asm/memblock.h>
+#include <asm/system_info.h>
+#include <asm/system_misc.h>
 
 #if defined(CONFIG_DEPRECATED_PARAM_STRUCT)
 #include "compat.h"
diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index 1f268bd..987dcf3 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -4,7 +4,6 @@
 #include <asm/assembler.h>
 #include <asm/glue-cache.h>
 #include <asm/glue-proc.h>
-#include <asm/system.h>
 	.text
 
 /*
diff --git a/arch/arm/kernel/tcm.c b/arch/arm/kernel/tcm.c
index 01ec453..30ae6bb 100644
--- a/arch/arm/kernel/tcm.c
+++ b/arch/arm/kernel/tcm.c
@@ -16,6 +16,7 @@
 #include <asm/cputype.h>
 #include <asm/mach/map.h>
 #include <asm/memory.h>
+#include <asm/system_info.h>
 #include "tcm.h"
 
 static struct gen_pool *tcm_pool;
diff --git a/arch/arm/kernel/thumbee.c b/arch/arm/kernel/thumbee.c
index 9cb7aac..37bc322 100644
--- a/arch/arm/kernel/thumbee.c
+++ b/arch/arm/kernel/thumbee.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 
 #include <asm/thread_notify.h>
+#include <asm/system_info.h>
 
 /*
  * Access to the ThumbEE Handler Base register
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index f84dfe6..cd77743 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -29,11 +29,11 @@
 #include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/exception.h>
-#include <asm/system.h>
 #include <asm/unistd.h>
 #include <asm/traps.h>
 #include <asm/unwind.h>
 #include <asm/tls.h>
+#include <asm/system_misc.h>
 
 #include "signal.h"
 
diff --git a/arch/arm/mach-at91/at91cap9.c b/arch/arm/mach-at91/at91cap9.c
index a42edc2..fc460e9 100644
--- a/arch/arm/mach-at91/at91cap9.c
+++ b/arch/arm/mach-at91/at91cap9.c
@@ -17,6 +17,8 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_info.h>
+#include <asm/system_misc.h>
 
 #include <mach/cpu.h>
 #include <mach/at91cap9.h>
diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
index 99c3174..413c027 100644
--- a/arch/arm/mach-at91/at91rm9200.c
+++ b/arch/arm/mach-at91/at91rm9200.c
@@ -15,6 +15,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 #include <mach/at91rm9200.h>
 #include <mach/at91_pmc.h>
 #include <mach/at91_st.h>
diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index d4036ba..79f5718 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -15,6 +15,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
 #include <mach/at91sam9260.h>
diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
index 023c2ff..62818b9 100644
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@ -15,6 +15,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 #include <mach/cpu.h>
 #include <mach/at91sam9261.h>
 #include <mach/at91_pmc.h>
diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index 75e876c..722ee08 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -15,6 +15,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 #include <mach/at91sam9263.h>
 #include <mach/at91_pmc.h>
 #include <mach/at91_rstc.h>
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 1cb6a96..47e8fdb 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -16,6 +16,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 #include <mach/at91sam9g45.h>
 #include <mach/at91_pmc.h>
 #include <mach/cpu.h>
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index d2c91a8..7ae4993 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -14,6 +14,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_misc.h>
 #include <mach/cpu.h>
 #include <mach/at91_dbgu.h>
 #include <mach/at91sam9rl.h>
diff --git a/arch/arm/mach-at91/include/mach/system_rev.h b/arch/arm/mach-at91/include/mach/system_rev.h
index ec164a4..ef79a9a 100644
--- a/arch/arm/mach-at91/include/mach/system_rev.h
+++ b/arch/arm/mach-at91/include/mach/system_rev.h
@@ -7,6 +7,8 @@
 #ifndef __ARCH_SYSTEM_REV_H__
 #define __ARCH_SYSTEM_REV_H__
 
+#include <asm/system_info.h>
+
 /*
  * board revision encoding
  * mach specific
diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index ab1711b..ac84f92 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -37,6 +37,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach/time.h>
 #include <asm/hardware/clps7111.h>
+#include <asm/system_misc.h>
 
 /*
  * This maps the generic CLPS711x registers
diff --git a/arch/arm/mach-clps711x/p720t-leds.c b/arch/arm/mach-clps711x/p720t-leds.c
index 1512144..dd9a6cd 100644
--- a/arch/arm/mach-clps711x/p720t-leds.c
+++ b/arch/arm/mach-clps711x/p720t-leds.c
@@ -25,7 +25,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #include <asm/hardware/clps7111.h>
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index d508890..5d9afd8 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/wl12xx.h>
 
+#include <asm/system_info.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
index 294aad0..0c40e59 100644
--- a/arch/arm/mach-ebsa110/core.c
+++ b/arch/arm/mach-ebsa110/core.c
@@ -22,7 +22,7 @@
 #include <asm/mach-types.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
+#include <asm/system_misc.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
diff --git a/arch/arm/mach-ebsa110/leds.c b/arch/arm/mach-ebsa110/leds.c
index 6a6ea57..101a320 100644
--- a/arch/arm/mach-ebsa110/leds.c
+++ b/arch/arm/mach-ebsa110/leds.c
@@ -17,7 +17,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 static spinlock_t leds_lock;
diff --git a/arch/arm/mach-footbridge/common.c b/arch/arm/mach-footbridge/common.c
index 41978ee..3e6aaa6 100644
--- a/arch/arm/mach-footbridge/common.c
+++ b/arch/arm/mach-footbridge/common.c
@@ -21,6 +21,7 @@
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/setup.h>
+#include <asm/system_misc.h>
 #include <asm/hardware/dec21285.h>
 
 #include <asm/mach/irq.h>
diff --git a/arch/arm/mach-footbridge/dc21285-timer.c b/arch/arm/mach-footbridge/dc21285-timer.c
index 121ad1d..3b54196 100644
--- a/arch/arm/mach-footbridge/dc21285-timer.c
+++ b/arch/arm/mach-footbridge/dc21285-timer.c
@@ -14,6 +14,7 @@
 
 #include <asm/hardware/dec21285.h>
 #include <asm/mach/time.h>
+#include <asm/system_info.h>
 
 #include "common.h"
 
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index f685650..94a7087 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -21,7 +21,6 @@
 #include <video/vga.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/hardware/dec21285.h>
 
diff --git a/arch/arm/mach-footbridge/ebsa285-leds.c b/arch/arm/mach-footbridge/ebsa285-leds.c
index 4e10090..5bd2667 100644
--- a/arch/arm/mach-footbridge/ebsa285-leds.c
+++ b/arch/arm/mach-footbridge/ebsa285-leds.c
@@ -24,7 +24,6 @@
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
 #define LED_STATE_ENABLED	1
 #define LED_STATE_CLAIMED	2
diff --git a/arch/arm/mach-footbridge/netwinder-hw.c b/arch/arm/mach-footbridge/netwinder-hw.c
index 80a1c5c..cac9f67 100644
--- a/arch/arm/mach-footbridge/netwinder-hw.c
+++ b/arch/arm/mach-footbridge/netwinder-hw.c
@@ -17,6 +17,7 @@
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/setup.h>
+#include <asm/system_misc.h>
 
 #include <asm/mach/arch.h>
 
diff --git a/arch/arm/mach-footbridge/netwinder-leds.c b/arch/arm/mach-footbridge/netwinder-leds.c
index e57102e..5a2bd89 100644
--- a/arch/arm/mach-footbridge/netwinder-leds.c
+++ b/arch/arm/mach-footbridge/netwinder-leds.c
@@ -24,7 +24,6 @@
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
 #define LED_STATE_ENABLED	1
 #define LED_STATE_CLAIMED	2
diff --git a/arch/arm/mach-imx/dma-v1.c b/arch/arm/mach-imx/dma-v1.c
index 42afc29..3189a60 100644
--- a/arch/arm/mach-imx/dma-v1.c
+++ b/arch/arm/mach-imx/dma-v1.c
@@ -32,7 +32,6 @@
 #include <linux/scatterlist.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma-v1.h>
diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index c257281..527b697 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -21,6 +21,7 @@
 #include <linux/of_platform.h>
 #include <linux/phy.h>
 #include <linux/micrel_phy.h>
+#include <asm/system_misc.h>
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/hardware/gic.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-imx/mach-mx51_efikamx.c b/arch/arm/mach-imx/mach-mx51_efikamx.c
index 3a5ed2d..586e9f8 100644
--- a/arch/arm/mach-imx/mach-mx51_efikamx.c
+++ b/arch/arm/mach-imx/mach-mx51_efikamx.c
@@ -33,6 +33,7 @@
 #include <mach/iomux-mx51.h>
 
 #include <asm/setup.h>
+#include <asm/system_info.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/mach-imx/mach-mx51_efikasb.c b/arch/arm/mach-imx/mach-mx51_efikasb.c
index ea5f65b..24aded9 100644
--- a/arch/arm/mach-imx/mach-mx51_efikasb.c
+++ b/arch/arm/mach-imx/mach-mx51_efikasb.c
@@ -36,6 +36,7 @@
 #include <mach/iomux-mx51.h>
 
 #include <asm/setup.h>
+#include <asm/system_info.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index 019f0ab..d2fd9f3 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -27,7 +27,6 @@
 #include <mach/platform.h>
 #include <asm/irq.h>
 #include <mach/cm.h>
-#include <asm/system.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/mach-integrator/leds.c b/arch/arm/mach-integrator/leds.c
index 28be186..466defa 100644
--- a/arch/arm/mach-integrator/leds.c
+++ b/arch/arm/mach-integrator/leds.c
@@ -29,7 +29,6 @@
 #include <mach/hardware.h>
 #include <mach/platform.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 #include <mach/cm.h>
 
diff --git a/arch/arm/mach-integrator/pci.c b/arch/arm/mach-integrator/pci.c
index 520b6bf..36068f4 100644
--- a/arch/arm/mach-integrator/pci.c
+++ b/arch/arm/mach-integrator/pci.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 3c82566..9d47b4c 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -32,7 +32,6 @@
 #include <mach/platform.h>
 #include <asm/irq.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/irq_regs.h>
 
diff --git a/arch/arm/mach-iop33x/uart.c b/arch/arm/mach-iop33x/uart.c
index cdae24e..bbf54d7 100644
--- a/arch/arm/mach-iop33x/uart.c
+++ b/arch/arm/mach-iop33x/uart.c
@@ -22,7 +22,6 @@
 #include <asm/page.h>
 #include <asm/mach/map.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/hardware/iop3xx.h>
diff --git a/arch/arm/mach-ixp2000/core.c b/arch/arm/mach-ixp2000/core.c
index 81c4537..f214cdf 100644
--- a/arch/arm/mach-ixp2000/core.c
+++ b/arch/arm/mach-ixp2000/core.c
@@ -32,7 +32,6 @@
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp2000/enp2611.c b/arch/arm/mach-ixp2000/enp2611.c
index e872d23..4867f40 100644
--- a/arch/arm/mach-ixp2000/enp2611.c
+++ b/arch/arm/mach-ixp2000/enp2611.c
@@ -36,7 +36,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2400.c b/arch/arm/mach-ixp2000/ixdp2400.c
index f53e911..558f5f8 100644
--- a/arch/arm/mach-ixp2000/ixdp2400.c
+++ b/arch/arm/mach-ixp2000/ixdp2400.c
@@ -29,7 +29,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2800.c b/arch/arm/mach-ixp2000/ixdp2800.c
index a2e7c39..33c6d5f 100644
--- a/arch/arm/mach-ixp2000/ixdp2800.c
+++ b/arch/arm/mach-ixp2000/ixdp2800.c
@@ -29,7 +29,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2x00.c b/arch/arm/mach-ixp2000/ixdp2x00.c
index 634b6c8..910426a 100644
--- a/arch/arm/mach-ixp2000/ixdp2x00.c
+++ b/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -30,7 +30,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2x01.c b/arch/arm/mach-ixp2000/ixdp2x01.c
index 7632bea..5196c39 100644
--- a/arch/arm/mach-ixp2000/ixdp2x01.c
+++ b/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -34,7 +34,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/pci.c b/arch/arm/mach-ixp2000/pci.c
index 626fda4..7e9a1f3 100644
--- a/arch/arm/mach-ixp2000/pci.c
+++ b/arch/arm/mach-ixp2000/pci.c
@@ -26,7 +26,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 
 #include <asm/mach/pci.h>
diff --git a/arch/arm/mach-ixp23xx/core.c b/arch/arm/mach-ixp23xx/core.c
index 0923bb9..ccdec42 100644
--- a/arch/arm/mach-ixp23xx/core.c
+++ b/arch/arm/mach-ixp23xx/core.c
@@ -34,7 +34,6 @@
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp23xx/espresso.c b/arch/arm/mach-ixp23xx/espresso.c
index 8f2487e..d142d45 100644
--- a/arch/arm/mach-ixp23xx/espresso.c
+++ b/arch/arm/mach-ixp23xx/espresso.c
@@ -32,7 +32,6 @@
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp23xx/ixdp2351.c b/arch/arm/mach-ixp23xx/ixdp2351.c
index 5d5dd3e..b0e07db 100644
--- a/arch/arm/mach-ixp23xx/ixdp2351.c
+++ b/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -36,7 +36,6 @@
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp23xx/pci.c b/arch/arm/mach-ixp23xx/pci.c
index 25b5c46..bdf2866 100644
--- a/arch/arm/mach-ixp23xx/pci.c
+++ b/arch/arm/mach-ixp23xx/pci.c
@@ -28,7 +28,6 @@
 
 #include <asm/irq.h>
 #include <asm/sizes.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ixp23xx/roadrunner.c b/arch/arm/mach-ixp23xx/roadrunner.c
index 377283f..eaaa3fa 100644
--- a/arch/arm/mach-ixp23xx/roadrunner.c
+++ b/arch/arm/mach-ixp23xx/roadrunner.c
@@ -36,7 +36,6 @@
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 5eff15f..0f445d3 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -32,7 +32,6 @@
 #include <asm/cputype.h>
 #include <asm/irq.h>
 #include <asm/sizes.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ixp4xx/goramo_mlr.c b/arch/arm/mach-ixp4xx/goramo_mlr.c
index c0e3d69..78ae12c 100644
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ b/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -12,7 +12,6 @@
 #include <linux/pci.h>
 #include <linux/serial_8250.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 #include <asm/mach/pci.h>
diff --git a/arch/arm/mach-ks8695/time.c b/arch/arm/mach-ks8695/time.c
index 37dfcd5..ec783a3 100644
--- a/arch/arm/mach-ks8695/time.c
+++ b/arch/arm/mach-ks8695/time.c
@@ -27,6 +27,7 @@
 #include <linux/io.h>
 
 #include <asm/mach/time.h>
+#include <asm/system_misc.h>
 
 #include <mach/regs-timer.h>
 #include <mach/regs-irq.h>
diff --git a/arch/arm/mach-mmp/common.c b/arch/arm/mach-mmp/common.c
index 062b5b9..c868a6c 100644
--- a/arch/arm/mach-mmp/common.c
+++ b/arch/arm/mach-mmp/common.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 
 #include <asm/page.h>
+#include <asm/system_misc.h>
 #include <asm/mach/map.h>
 #include <mach/addr-map.h>
 #include <mach/cputype.h>
diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
index ada1213..d5c9a2e 100644
--- a/arch/arm/mach-mmp/pxa168.c
+++ b/arch/arm/mach-mmp/pxa168.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 
+#include <asm/system_misc.h>
 #include <asm/mach/time.h>
 #include <mach/addr-map.h>
 #include <mach/cputype.h>
diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
index 97b8191..4a8ea0d 100644
--- a/arch/arm/mach-msm/board-sapphire.c
+++ b/arch/arm/mach-msm/board-sapphire.c
@@ -27,7 +27,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
-#include <asm/system.h>
 #include <mach/system.h>
 #include <mach/vreg.h>
 #include <mach/board.h>
diff --git a/arch/arm/mach-mxs/system.c b/arch/arm/mach-mxs/system.c
index 54f91ad..30042e2 100644
--- a/arch/arm/mach-mxs/system.c
+++ b/arch/arm/mach-mxs/system.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 
 #include <asm/proc-fns.h>
-#include <asm/system.h>
+#include <asm/system_misc.h>
 
 #include <mach/mxs.h>
 #include <mach/common.h>
diff --git a/arch/arm/mach-omap1/id.c b/arch/arm/mach-omap1/id.c
index a0e3560..b3f3363 100644
--- a/arch/arm/mach-omap1/id.c
+++ b/arch/arm/mach-omap1/id.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <asm/system_info.h>
 #include <plat/cpu.h>
 
 #define OMAP_DIE_ID_0		0xfffe1800
diff --git a/arch/arm/mach-omap1/leds-h2p2-debug.c b/arch/arm/mach-omap1/leds-h2p2-debug.c
index 4b818eb..f6b14a1 100644
--- a/arch/arm/mach-omap1/leds-h2p2-debug.c
+++ b/arch/arm/mach-omap1/leds-h2p2-debug.c
@@ -17,7 +17,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #include <plat/fpga.h>
diff --git a/arch/arm/mach-omap1/leds-innovator.c b/arch/arm/mach-omap1/leds-innovator.c
index 9b99c28..3a066ee 100644
--- a/arch/arm/mach-omap1/leds-innovator.c
+++ b/arch/arm/mach-omap1/leds-innovator.c
@@ -5,7 +5,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-omap1/leds-osk.c b/arch/arm/mach-omap1/leds-osk.c
index da09f43..936ed42 100644
--- a/arch/arm/mach-omap1/leds-osk.c
+++ b/arch/arm/mach-omap1/leds-osk.c
@@ -8,7 +8,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-omap1/mux.c b/arch/arm/mach-omap1/mux.c
index 5fdef7a..087dba0 100644
--- a/arch/arm/mach-omap1/mux.c
+++ b/arch/arm/mach-omap1/mux.c
@@ -27,7 +27,6 @@
 #include <linux/io.h>
 #include <linux/spinlock.h>
 
-#include <asm/system.h>
 
 #include <plat/mux.h>
 
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index b8faffa..7595e0a 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -44,7 +44,6 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 9a54ef4..10bcd13 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -46,7 +46,6 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index a0b851a..c524c9d 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -38,6 +38,7 @@
 #include <linux/i2c/twl.h>
 
 #include <mach/hardware.h>
+#include <asm/system_info.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index acb4e77..2bf84fd 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -25,6 +25,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/mmc/host.h>
 #include <linux/power/isp1704_charger.h>
+#include <asm/system_info.h>
 
 #include <plat/mcspi.h>
 #include <plat/board.h>
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 611a0e3..e974d33 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -35,7 +35,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 
 #include <plat/omap_hwmod.h>
 
diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 1d5d010..069f8fc 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -46,7 +46,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/smp_scu.h>
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/suspend.h>
 #include <asm/hardware/cache-l2x0.h>
diff --git a/arch/arm/mach-omap2/pm24xx.c b/arch/arm/mach-omap2/pm24xx.c
index 23de98d..730bb00 100644
--- a/arch/arm/mach-omap2/pm24xx.c
+++ b/arch/arm/mach-omap2/pm24xx.c
@@ -34,6 +34,7 @@
 #include <asm/mach/time.h>
 #include <asm/mach/irq.h>
 #include <asm/mach-types.h>
+#include <asm/system_misc.h>
 
 #include <mach/irqs.h>
 #include <plat/clock.h>
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index fc69875..64d95e6 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -31,6 +31,7 @@
 #include <trace/events/power.h>
 
 #include <asm/suspend.h>
+#include <asm/system_misc.h>
 
 #include <plat/sram.h>
 #include "clockdomain.h"
diff --git a/arch/arm/mach-omap2/pm44xx.c b/arch/arm/mach-omap2/pm44xx.c
index c264ef7..a73e325 100644
--- a/arch/arm/mach-omap2/pm44xx.c
+++ b/arch/arm/mach-omap2/pm44xx.c
@@ -16,6 +16,7 @@
 #include <linux/list.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <asm/system_misc.h>
 
 #include "common.h"
 #include "clockdomain.h"
diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index abd2834..9f6b83d 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -10,7 +10,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/system.h>
 #include <asm/smp_scu.h>
 #include <asm/memory.h>
 #include <asm/hardware/cache-l2x0.h>
diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 5dad38e..2448166 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -21,6 +21,7 @@
 #include <net/dsa.h>
 #include <asm/page.h>
 #include <asm/setup.h>
+#include <asm/system_misc.h>
 #include <asm/timex.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-orion5x/dns323-setup.c b/arch/arm/mach-orion5x/dns323-setup.c
index 91b0f47..f4f6ad2d 100644
--- a/arch/arm/mach-orion5x/dns323-setup.c
+++ b/arch/arm/mach-orion5x/dns323-setup.c
@@ -29,6 +29,7 @@
 #include <linux/ata_platform.h>
 #include <linux/phy.h>
 #include <linux/marvell_phy.h>
+#include <asm/system_info.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/pci.h>
diff --git a/arch/arm/mach-orion5x/ls-chl-setup.c b/arch/arm/mach-orion5x/ls-chl-setup.c
index 5272131..0c9e413 100644
--- a/arch/arm/mach-orion5x/ls-chl-setup.c
+++ b/arch/arm/mach-orion5x/ls-chl-setup.c
@@ -22,7 +22,6 @@
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <asm/system.h>
 #include <mach/orion5x.h>
 #include "common.h"
 #include "mpp.h"
diff --git a/arch/arm/mach-orion5x/ls_hgl-setup.c b/arch/arm/mach-orion5x/ls_hgl-setup.c
index 9a8697b..c1b5d8a 100644
--- a/arch/arm/mach-orion5x/ls_hgl-setup.c
+++ b/arch/arm/mach-orion5x/ls_hgl-setup.c
@@ -21,7 +21,6 @@
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <asm/system.h>
 #include <mach/orion5x.h>
 #include "common.h"
 #include "mpp.h"
diff --git a/arch/arm/mach-orion5x/lsmini-setup.c b/arch/arm/mach-orion5x/lsmini-setup.c
index 09c7365..949eaa8 100644
--- a/arch/arm/mach-orion5x/lsmini-setup.c
+++ b/arch/arm/mach-orion5x/lsmini-setup.c
@@ -21,7 +21,6 @@
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <asm/system.h>
 #include <mach/orion5x.h>
 #include "common.h"
 #include "mpp.h"
diff --git a/arch/arm/mach-pnx4008/core.c b/arch/arm/mach-pnx4008/core.c
index 4cfb40b..be4c928 100644
--- a/arch/arm/mach-pnx4008/core.c
+++ b/arch/arm/mach-pnx4008/core.c
@@ -32,7 +32,7 @@
 #include <asm/mach-types.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
+#include <asm/system_misc.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pnx4008/dma.c b/arch/arm/mach-pnx4008/dma.c
index 7fa4bf2..a4739e9 100644
--- a/arch/arm/mach-pnx4008/dma.c
+++ b/arch/arm/mach-pnx4008/dma.c
@@ -24,7 +24,6 @@
 #include <linux/io.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
 #include <asm/dma-mapping.h>
diff --git a/arch/arm/mach-pnx4008/irq.c b/arch/arm/mach-pnx4008/irq.c
index 7608c7a..41e4201 100644
--- a/arch/arm/mach-pnx4008/irq.c
+++ b/arch/arm/mach-pnx4008/irq.c
@@ -28,7 +28,6 @@
 #include <asm/setup.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pnx4008/time.c b/arch/arm/mach-pnx4008/time.c
index 0c8aad4..0cfe8af 100644
--- a/arch/arm/mach-pnx4008/time.c
+++ b/arch/arm/mach-pnx4008/time.c
@@ -24,7 +24,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
index 4b981b8..125ae08 100644
--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -55,6 +55,7 @@
 #include <mach/pxa3xx-u2d.h>
 
 #include <asm/mach/map.h>
+#include <asm/system_info.h>
 
 #include "generic.h"
 #include "devices.h"
diff --git a/arch/arm/mach-pxa/colibri-pxa3xx.c b/arch/arm/mach-pxa/colibri-pxa3xx.c
index 2b8ca0d..2075a69 100644
--- a/arch/arm/mach-pxa/colibri-pxa3xx.c
+++ b/arch/arm/mach-pxa/colibri-pxa3xx.c
@@ -20,6 +20,7 @@
 #include <asm/sizes.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
+#include <asm/system_info.h>
 #include <mach/pxa3xx-regs.h>
 #include <mach/mfp-pxa300.h>
 #include <mach/colibri.h>
diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index 11f1e73..de9d45e 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -40,7 +40,6 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 5432ecb..4225417 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 
 #include <mach/hardware.h>
-#include <asm/system.h>
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-pxa/leds-idp.c b/arch/arm/mach-pxa/leds-idp.c
index 8b9c171..06b0600 100644
--- a/arch/arm/mach-pxa/leds-idp.c
+++ b/arch/arm/mach-pxa/leds-idp.c
@@ -16,7 +16,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include <mach/pxa25x.h>
 #include <mach/idp.h>
diff --git a/arch/arm/mach-pxa/leds-lubbock.c b/arch/arm/mach-pxa/leds-lubbock.c
index e26d5ef..0bd85c8 100644
--- a/arch/arm/mach-pxa/leds-lubbock.c
+++ b/arch/arm/mach-pxa/leds-lubbock.c
@@ -15,7 +15,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <mach/pxa25x.h>
 #include <mach/lubbock.h>
 
diff --git a/arch/arm/mach-pxa/leds-mainstone.c b/arch/arm/mach-pxa/leds-mainstone.c
index db4af5e..4058ab3 100644
--- a/arch/arm/mach-pxa/leds-mainstone.c
+++ b/arch/arm/mach-pxa/leds-mainstone.c
@@ -14,7 +14,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include <mach/pxa27x.h>
 #include <mach/mainstone.h>
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index 3d6baf9..264cd89 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -31,6 +31,7 @@
 #include <linux/i2c/pxa-i2c.h>
 
 #include <mach/hardware.h>
+#include <asm/system_info.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
diff --git a/arch/arm/mach-pxa/poodle.c b/arch/arm/mach-pxa/poodle.c
index 744baee..89d98c8 100644
--- a/arch/arm/mach-pxa/poodle.c
+++ b/arch/arm/mach-pxa/poodle.c
@@ -34,7 +34,6 @@
 #include <asm/mach-types.h>
 #include <asm/irq.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pxa/reset.c b/arch/arm/mach-pxa/reset.c
index c8497b0..b452889 100644
--- a/arch/arm/mach-pxa/reset.c
+++ b/arch/arm/mach-pxa/reset.c
@@ -9,6 +9,7 @@
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <asm/proc-fns.h>
+#include <asm/system_misc.h>
 
 #include <mach/regs-ost.h>
 #include <mach/reset.h>
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 023d6ca..7a3d342 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -57,6 +57,7 @@
 #include <asm/mach-types.h>
 #include <asm/irq.h>
 #include <asm/sizes.h>
+#include <asm/system_info.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pxa/zeus.c b/arch/arm/mach-pxa/zeus.c
index a4dd1c3..4c5ae58 100644
--- a/arch/arm/mach-pxa/zeus.c
+++ b/arch/arm/mach-pxa/zeus.c
@@ -34,6 +34,7 @@
 #include <asm/suspend.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
+#include <asm/system_info.h>
 
 #include <mach/pxa27x.h>
 #include <mach/regs-uart.h>
diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index acd329a..45868bb 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -33,7 +33,6 @@
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/leds.h>
diff --git a/arch/arm/mach-rpc/riscpc.c b/arch/arm/mach-rpc/riscpc.c
index 3d44a59..e958597 100644
--- a/arch/arm/mach-rpc/riscpc.c
+++ b/arch/arm/mach-rpc/riscpc.c
@@ -28,6 +28,7 @@
 #include <asm/page.h>
 #include <asm/domain.h>
 #include <asm/setup.h>
+#include <asm/system_misc.h>
 
 #include <asm/mach/map.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/mach-s3c2410/s3c2410.c b/arch/arm/mach-s3c2410/s3c2410.c
index 061b6bb..a3c5cb0 100644
--- a/arch/arm/mach-s3c2410/s3c2410.c
+++ b/arch/arm/mach-s3c2410/s3c2410.c
@@ -30,6 +30,7 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
+#include <asm/system_misc.h>
 
 #include <plat/cpu-freq.h>
 
diff --git a/arch/arm/mach-s3c2412/s3c2412.c b/arch/arm/mach-s3c2412/s3c2412.c
index aff6e85..100ef1c 100644
--- a/arch/arm/mach-s3c2412/s3c2412.c
+++ b/arch/arm/mach-s3c2412/s3c2412.c
@@ -31,6 +31,7 @@
 #include <mach/hardware.h>
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
+#include <asm/system_misc.h>
 
 #include <mach/idle.h>
 
diff --git a/arch/arm/mach-s3c2416/s3c2416.c b/arch/arm/mach-s3c2416/s3c2416.c
index 5287d28..ed67ec9 100644
--- a/arch/arm/mach-s3c2416/s3c2416.c
+++ b/arch/arm/mach-s3c2416/s3c2416.c
@@ -43,6 +43,7 @@
 #include <mach/hardware.h>
 #include <asm/proc-fns.h>
 #include <asm/irq.h>
+#include <asm/system_misc.h>
 
 #include <mach/idle.h>
 #include <mach/regs-s3c2443-clock.h>
diff --git a/arch/arm/mach-s3c2440/s3c244x.c b/arch/arm/mach-s3c2440/s3c244x.c
index d15852f..6f74118 100644
--- a/arch/arm/mach-s3c2440/s3c244x.c
+++ b/arch/arm/mach-s3c2440/s3c244x.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 
+#include <asm/system_misc.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
diff --git a/arch/arm/mach-s3c2443/s3c2443.c b/arch/arm/mach-s3c2443/s3c2443.c
index b9deaeb..9318847 100644
--- a/arch/arm/mach-s3c2443/s3c2443.c
+++ b/arch/arm/mach-s3c2443/s3c2443.c
@@ -29,6 +29,7 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
+#include <asm/system_misc.h>
 
 #include <mach/regs-s3c2443-clock.h>
 
diff --git a/arch/arm/mach-s3c64xx/common.c b/arch/arm/mach-s3c64xx/common.c
index bee7dcd..b313380 100644
--- a/arch/arm/mach-s3c64xx/common.c
+++ b/arch/arm/mach-s3c64xx/common.c
@@ -29,6 +29,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/hardware/vic.h>
+#include <asm/system_misc.h>
 
 #include <mach/map.h>
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-s5p64x0/common.c b/arch/arm/mach-s5p64x0/common.c
index 52b89a3..a9d1ad4 100644
--- a/arch/arm/mach-s5p64x0/common.c
+++ b/arch/arm/mach-s5p64x0/common.c
@@ -30,6 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
+#include <asm/system_misc.h>
 
 #include <mach/map.h>
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-s5pc100/common.c b/arch/arm/mach-s5pc100/common.c
index c909573..dff11c3 100644
--- a/arch/arm/mach-s5pc100/common.c
+++ b/arch/arm/mach-s5pc100/common.c
@@ -30,6 +30,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
+#include <asm/system_misc.h>
 
 #include <mach/map.h>
 #include <mach/hardware.h>
diff --git a/arch/arm/mach-sa1100/dma.c b/arch/arm/mach-sa1100/dma.c
index ad66035..56e1333 100644
--- a/arch/arm/mach-sa1100/dma.c
+++ b/arch/arm/mach-sa1100/dma.c
@@ -16,7 +16,6 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index bb10ee2..9ad9469 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -21,10 +21,10 @@
 
 #include <asm/div64.h>
 #include <mach/hardware.h>
-#include <asm/system.h>
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
 #include <asm/irq.h>
+#include <asm/system_misc.h>
 
 #include "generic.h"
 
diff --git a/arch/arm/mach-sa1100/leds-assabet.c b/arch/arm/mach-sa1100/leds-assabet.c
index 64e9b4b..3699176 100644
--- a/arch/arm/mach-sa1100/leds-assabet.c
+++ b/arch/arm/mach-sa1100/leds-assabet.c
@@ -13,7 +13,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <mach/assabet.h>
 
 #include "leds.h"
diff --git a/arch/arm/mach-sa1100/leds-badge4.c b/arch/arm/mach-sa1100/leds-badge4.c
index cf1e384..f99fac3 100644
--- a/arch/arm/mach-sa1100/leds-badge4.c
+++ b/arch/arm/mach-sa1100/leds-badge4.c
@@ -14,7 +14,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/leds-cerf.c b/arch/arm/mach-sa1100/leds-cerf.c
index 259b48e..040540f 100644
--- a/arch/arm/mach-sa1100/leds-cerf.c
+++ b/arch/arm/mach-sa1100/leds-cerf.c
@@ -7,7 +7,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/leds-hackkit.c b/arch/arm/mach-sa1100/leds-hackkit.c
index 2bce137..6a23524 100644
--- a/arch/arm/mach-sa1100/leds-hackkit.c
+++ b/arch/arm/mach-sa1100/leds-hackkit.c
@@ -13,7 +13,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/leds-lart.c b/arch/arm/mach-sa1100/leds-lart.c
index 0505a1f..a51830c 100644
--- a/arch/arm/mach-sa1100/leds-lart.c
+++ b/arch/arm/mach-sa1100/leds-lart.c
@@ -13,7 +13,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/pm.c b/arch/arm/mach-sa1100/pm.c
index bf85b8b..2fa499e 100644
--- a/arch/arm/mach-sa1100/pm.c
+++ b/arch/arm/mach-sa1100/pm.c
@@ -30,7 +30,6 @@
 #include <mach/hardware.h>
 #include <asm/memory.h>
 #include <asm/suspend.h>
-#include <asm/system.h>
 #include <asm/mach/time.h>
 
 extern int sa1100_finish_suspend(unsigned long);
diff --git a/arch/arm/mach-shark/leds.c b/arch/arm/mach-shark/leds.c
index ccd4918..2560907 100644
--- a/arch/arm/mach-shark/leds.c
+++ b/arch/arm/mach-shark/leds.c
@@ -23,7 +23,6 @@
 #include <linux/io.h>
 
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #define LED_STATE_ENABLED	1
 #define LED_STATE_CLAIMED	2
diff --git a/arch/arm/mach-shmobile/cpuidle.c b/arch/arm/mach-shmobile/cpuidle.c
index 1b23342..21b09b6 100644
--- a/arch/arm/mach-shmobile/cpuidle.c
+++ b/arch/arm/mach-shmobile/cpuidle.c
@@ -13,7 +13,6 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 static void shmobile_enter_wfi(void)
diff --git a/arch/arm/mach-shmobile/include/mach/system.h b/arch/arm/mach-shmobile/include/mach/system.h
index 956ac18..9204270 100644
--- a/arch/arm/mach-shmobile/include/mach/system.h
+++ b/arch/arm/mach-shmobile/include/mach/system.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_ARCH_SYSTEM_H
 #define __ASM_ARCH_SYSTEM_H
 
+#include <asm/system_misc.h>
+
 static inline void arch_idle(void)
 {
 	cpu_do_idle();
diff --git a/arch/arm/mach-shmobile/pm-r8a7779.c b/arch/arm/mach-shmobile/pm-r8a7779.c
index c38ba7b..a18a4ae 100644
--- a/arch/arm/mach-shmobile/pm-r8a7779.c
+++ b/arch/arm/mach-shmobile/pm-r8a7779.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/console.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <mach/common.h>
 #include <mach/r8a7779.h>
diff --git a/arch/arm/mach-shmobile/pm-sh7372.c b/arch/arm/mach-shmobile/pm-sh7372.c
index fcf8b17..a3bdb12 100644
--- a/arch/arm/mach-shmobile/pm-sh7372.c
+++ b/arch/arm/mach-shmobile/pm-sh7372.c
@@ -21,7 +21,6 @@
 #include <linux/irq.h>
 #include <linux/bitrev.h>
 #include <linux/console.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/tlbflush.h>
 #include <asm/suspend.h>
diff --git a/arch/arm/mach-shmobile/suspend.c b/arch/arm/mach-shmobile/suspend.c
index c1febe1..4d1b86a 100644
--- a/arch/arm/mach-shmobile/suspend.c
+++ b/arch/arm/mach-shmobile/suspend.c
@@ -12,8 +12,8 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <asm/system.h>
 #include <asm/io.h>
+#include <asm/system_misc.h>
 
 static int shmobile_suspend_default_enter(suspend_state_t suspend_state)
 {
diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index bb5ce39..7a065f0 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -30,7 +30,6 @@
 #include <linux/io.h>
 #include <linux/suspend.h>
 
-#include <asm/system.h>
 
 #include <mach/clk.h>
 
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 02b7b93..f0932b5 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -36,7 +36,6 @@
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/leds.h>
 #include <asm/hardware/arm_timer.h>
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 90069bc..787cf5f 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -24,7 +24,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 
 /*
diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 9a06619..9e4dd8b 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -28,6 +28,7 @@
 #include <asm/mach/map.h>
 #include <asm/mach/irq.h>
 #include <asm/irq.h>
+#include <asm/system_misc.h>
 
 #include <mach/hardware.h>
 #include <mach/regs-serial.h>
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 78459b8..72c751a 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -24,6 +24,7 @@
 
 #include <asm/cp15.h>
 #include <asm/unaligned.h>
+#include <asm/system_info.h>
 
 #include "fault.h"
 
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bb7eac3..2da5df7 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -21,9 +21,10 @@
 #include <linux/perf_event.h>
 
 #include <asm/exception.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/system_misc.h>
+#include <asm/system_info.h>
 
 #include "fault.h"
 
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 1a8d4aa..062d61a 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -16,7 +16,6 @@
 #include <asm/cachetype.h>
 #include <asm/highmem.h>
 #include <asm/smp_plat.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 
 #include "mm.h"
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index feacf4c..ab88ed4 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -5,6 +5,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/sections.h>
+#include <asm/system_info.h>
 
 pgd_t *idmap_pgd;
 
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 66daf17..6780b49 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -33,6 +33,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/sizes.h>
+#include <asm/system_info.h>
 
 #include <asm/mach/map.h>
 #include "mm.h"
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 163a69a..8aa1add 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -27,6 +27,7 @@
 #include <asm/tlb.h>
 #include <asm/highmem.h>
 #include <asm/traps.h>
+#include <asm/system_info.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
index 272558a..d217e97 100644
--- a/arch/arm/mm/proc-fa526.S
+++ b/arch/arm/mm/proc-fa526.S
@@ -22,7 +22,6 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #include "proc-macros.S"
 
diff --git a/arch/arm/nwfpe/fpa11.c b/arch/arm/nwfpe/fpa11.c
index cc60acd..2782ebc 100644
--- a/arch/arm/nwfpe/fpa11.c
+++ b/arch/arm/nwfpe/fpa11.c
@@ -28,7 +28,6 @@
 
 #include <linux/compiler.h>
 #include <linux/string.h>
-#include <asm/system.h>
 
 /* Reset the FPA11 chip.  Called to initialize and reset the emulator. */
 static void resetFPA11(void)
diff --git a/arch/arm/plat-iop/i2c.c b/arch/arm/plat-iop/i2c.c
index 4efe392..88215ad 100644
--- a/arch/arm/plat-iop/i2c.c
+++ b/arch/arm/plat-iop/i2c.c
@@ -23,7 +23,6 @@
 #include <asm/page.h>
 #include <asm/mach/map.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/hardware/iop3xx.h>
diff --git a/arch/arm/plat-iop/pci.c b/arch/arm/plat-iop/pci.c
index f4d40a2..bb26981 100644
--- a/arch/arm/plat-iop/pci.c
+++ b/arch/arm/plat-iop/pci.c
@@ -20,7 +20,6 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach/pci.h>
 #include <asm/hardware/iop3xx.h>
diff --git a/arch/arm/plat-iop/restart.c b/arch/arm/plat-iop/restart.c
index 6a85a0c..33fa699 100644
--- a/arch/arm/plat-iop/restart.c
+++ b/arch/arm/plat-iop/restart.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 #include <asm/hardware/iop3xx.h>
+#include <asm/system_misc.h>
 #include <mach/hardware.h>
 
 void iop3xx_restart(char mode, const char *cmd)
diff --git a/arch/arm/plat-mxc/system.c b/arch/arm/plat-mxc/system.c
index 3599bf2..c195d6d 100644
--- a/arch/arm/plat-mxc/system.c
+++ b/arch/arm/plat-mxc/system.c
@@ -25,8 +25,8 @@
 
 #include <mach/hardware.h>
 #include <mach/common.h>
+#include <asm/system_misc.h>
 #include <asm/proc-fns.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 void __iomem *(*imx_ioremap)(unsigned long, size_t, unsigned int) = NULL;
diff --git a/arch/arm/plat-omap/debug-leds.c b/arch/arm/plat-omap/debug-leds.c
index 61a1ec2..39407cb 100644
--- a/arch/arm/plat-omap/debug-leds.c
+++ b/arch/arm/plat-omap/debug-leds.c
@@ -15,7 +15,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #include <plat/fpga.h>
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 002fb4d..dbb1049 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <plat/dma.h>
 
diff --git a/arch/arm/plat-omap/mux.c b/arch/arm/plat-omap/mux.c
index 0d4aa0d..976fc80 100644
--- a/arch/arm/plat-omap/mux.c
+++ b/arch/arm/plat-omap/mux.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <linux/spinlock.h>
 #include <plat/mux.h>
 
diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
index 2d3c19d..79ef102 100644
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -20,7 +20,6 @@
 #include <linux/errno.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/memory.h>
 #include <mach/hardware.h>
diff --git a/arch/arm/plat-s3c24xx/cpu.c b/arch/arm/plat-s3c24xx/cpu.c
index 21f1fda..ded6431 100644
--- a/arch/arm/plat-s3c24xx/cpu.c
+++ b/arch/arm/plat-s3c24xx/cpu.c
@@ -34,6 +34,7 @@
 #include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/cacheflush.h>
+#include <asm/system_info.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
index 2bab4c9..28f898f 100644
--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -27,7 +27,6 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/arch/arm/plat-samsung/cpu.c b/arch/arm/plat-samsung/cpu.c
index 81c06d4..46b426e 100644
--- a/arch/arm/plat-samsung/cpu.c
+++ b/arch/arm/plat-samsung/cpu.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #include <mach/map.h>
 #include <plat/cpu.h>
diff --git a/arch/arm/plat-samsung/time.c b/arch/arm/plat-samsung/time.c
index e3bb806..4dcb11c 100644
--- a/arch/arm/plat-samsung/time.c
+++ b/arch/arm/plat-samsung/time.c
@@ -28,7 +28,6 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/plat-spear/restart.c b/arch/arm/plat-spear/restart.c
index 2b4e3d8..16f203e 100644
--- a/arch/arm/plat-spear/restart.c
+++ b/arch/arm/plat-spear/restart.c
@@ -11,6 +11,7 @@
  * warranty of any kind, whether express or implied.
  */
 #include <linux/io.h>
+#include <asm/system_misc.h>
 #include <asm/hardware/sp810.h>
 #include <mach/hardware.h>
 #include <mach/generic.h>
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index d89068f..9f50997 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -22,6 +22,7 @@
 #include <asm/cputype.h>
 #include <asm/thread_notify.h>
 #include <asm/vfp.h>
+#include <asm/system_info.h>
 
 #include "vfpinstr.h"
 #include "vfp.h"
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..654076e 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -19,6 +19,7 @@
 #include <linux/hrtimer.h>
 #include <linux/module.h>
 #include <trace/events/power.h>
+#include <asm/system_misc.h>
 
 #include "cpuidle.h"
 
diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/8390/etherh.c
index 48c4948..a45b0d8 100644
--- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -48,6 +48,7 @@
 #include <asm/system.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
+#include <asm/system_info.h>
 
 #define EI_SHIFT(x)	(ei_local->reg_offset[x])
 
diff --git a/drivers/tty/serial/21285.c b/drivers/tty/serial/21285.c
index 1b37626..6d0ddbc 100644
--- a/drivers/tty/serial/21285.c
+++ b/drivers/tty/serial/21285.c
@@ -16,6 +16,7 @@
 
 #include <asm/irq.h>
 #include <asm/mach-types.h>
+#include <asm/system_info.h>
 #include <asm/hardware/dec21285.h>
 #include <mach/hardware.h>
 
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index f551356..658a36d 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -32,6 +32,7 @@
 #include <mach/hardware.h>
 
 #include <asm/mach-types.h>
+#include <asm/system_info.h>
 #include <asm/hardware/dec21285.h>
 
 /*
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 94e924e..d9072d9 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -1,4 +1,4 @@
-/*
+ r/*
  * Copyright © 2000-2010 David Woodhouse <dwmw2@infradead.org> et al.
  *
  * This program is free software; you can redistribute it and/or modify

