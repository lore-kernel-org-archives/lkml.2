Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2CLXsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:48:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090Ab2CLXhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:37:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/35] Disintegrate asm/system.h for ARM [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Date: Mon, 12 Mar 2012 23:36:37 +0000
Message-ID: <20120312233636.13888.21843.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-arm-kernel@lists.infradead.org
---

 arch/arm/common/via82c505.c               |    1 
 arch/arm/include/asm/atomic.h             |    4 
 arch/arm/include/asm/barrier.h            |   64 +++
 arch/arm/include/asm/bitops.h             |    2 
 arch/arm/include/asm/bug.h                |   30 ++
 arch/arm/include/asm/cmpxchg.h            |  295 +++++++++++++++
 arch/arm/include/asm/compiler.h           |   15 +
 arch/arm/include/asm/cr_reg.h             |   85 ++++
 arch/arm/include/asm/div64.h              |    2 
 arch/arm/include/asm/dma.h                |    1 
 arch/arm/include/asm/domain.h             |    2 
 arch/arm/include/asm/exec.h               |    6 
 arch/arm/include/asm/io.h                 |    1 
 arch/arm/include/asm/mmu.h                |    7 
 arch/arm/include/asm/processor.h          |    1 
 arch/arm/include/asm/switch_to.h          |   18 +
 arch/arm/include/asm/system.h             |  552 -----------------------------
 arch/arm/include/asm/system_info.h        |   27 +
 arch/arm/include/asm/system_misc.h        |   35 ++
 arch/arm/include/asm/uaccess.h            |    2 
 arch/arm/kernel/armksyms.c                |    1 
 arch/arm/kernel/elf.c                     |    1 
 arch/arm/kernel/entry-armv.S              |    1 
 arch/arm/kernel/fiq.c                     |    1 
 arch/arm/kernel/head-nommu.S              |    1 
 arch/arm/kernel/head.S                    |    2 
 arch/arm/kernel/hw_breakpoint.c           |    1 
 arch/arm/kernel/irq.c                     |    1 
 arch/arm/kernel/machine_kexec.c           |    1 
 arch/arm/kernel/process.c                 |    1 
 arch/arm/kernel/ptrace.c                  |    1 
 arch/arm/kernel/setup.c                   |    4 
 arch/arm/kernel/sleep.S                   |    1 
 arch/arm/kernel/traps.c                   |    2 
 arch/arm/mach-clps711x/p720t-leds.c       |    1 
 arch/arm/mach-ebsa110/core.c              |    1 
 arch/arm/mach-ebsa110/leds.c              |    1 
 arch/arm/mach-footbridge/dc21285.c        |    1 
 arch/arm/mach-footbridge/ebsa285-leds.c   |    1 
 arch/arm/mach-footbridge/netwinder-leds.c |    1 
 arch/arm/mach-imx/dma-v1.c                |    1 
 arch/arm/mach-integrator/core.c           |    1 
 arch/arm/mach-integrator/leds.c           |    1 
 arch/arm/mach-integrator/pci.c            |    1 
 arch/arm/mach-integrator/pci_v3.c         |    1 
 arch/arm/mach-iop33x/uart.c               |    1 
 arch/arm/mach-ixp2000/core.c              |    1 
 arch/arm/mach-ixp2000/enp2611.c           |    1 
 arch/arm/mach-ixp2000/ixdp2400.c          |    1 
 arch/arm/mach-ixp2000/ixdp2800.c          |    1 
 arch/arm/mach-ixp2000/ixdp2x00.c          |    1 
 arch/arm/mach-ixp2000/ixdp2x01.c          |    1 
 arch/arm/mach-ixp2000/pci.c               |    1 
 arch/arm/mach-ixp23xx/core.c              |    1 
 arch/arm/mach-ixp23xx/espresso.c          |    1 
 arch/arm/mach-ixp23xx/ixdp2351.c          |    1 
 arch/arm/mach-ixp23xx/pci.c               |    1 
 arch/arm/mach-ixp23xx/roadrunner.c        |    1 
 arch/arm/mach-ixp4xx/common-pci.c         |    1 
 arch/arm/mach-ixp4xx/goramo_mlr.c         |    1 
 arch/arm/mach-msm/board-sapphire.c        |    1 
 arch/arm/mach-mxs/system.c                |    1 
 arch/arm/mach-omap1/leds-h2p2-debug.c     |    1 
 arch/arm/mach-omap1/leds-innovator.c      |    1 
 arch/arm/mach-omap1/leds-osk.c            |    1 
 arch/arm/mach-omap1/mux.c                 |    1 
 arch/arm/mach-omap1/time.c                |    1 
 arch/arm/mach-omap1/timer32k.c            |    1 
 arch/arm/mach-omap2/mux.c                 |    1 
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |    1 
 arch/arm/mach-omap2/sleep44xx.S           |    1 
 arch/arm/mach-orion5x/ls-chl-setup.c      |    1 
 arch/arm/mach-orion5x/ls_hgl-setup.c      |    1 
 arch/arm/mach-orion5x/lsmini-setup.c      |    1 
 arch/arm/mach-pnx4008/core.c              |    1 
 arch/arm/mach-pnx4008/dma.c               |    1 
 arch/arm/mach-pnx4008/irq.c               |    1 
 arch/arm/mach-pnx4008/time.c              |    1 
 arch/arm/mach-pxa/corgi.c                 |    1 
 arch/arm/mach-pxa/generic.c               |    1 
 arch/arm/mach-pxa/leds-idp.c              |    1 
 arch/arm/mach-pxa/leds-lubbock.c          |    1 
 arch/arm/mach-pxa/leds-mainstone.c        |    1 
 arch/arm/mach-pxa/poodle.c                |    1 
 arch/arm/mach-realview/core.c             |    1 
 arch/arm/mach-sa1100/dma.c                |    1 
 arch/arm/mach-sa1100/generic.c            |    1 
 arch/arm/mach-sa1100/leds-assabet.c       |    1 
 arch/arm/mach-sa1100/leds-badge4.c        |    1 
 arch/arm/mach-sa1100/leds-cerf.c          |    1 
 arch/arm/mach-sa1100/leds-hackkit.c       |    1 
 arch/arm/mach-sa1100/leds-lart.c          |    1 
 arch/arm/mach-sa1100/pm.c                 |    1 
 arch/arm/mach-shark/leds.c                |    1 
 arch/arm/mach-shmobile/cpuidle.c          |    1 
 arch/arm/mach-shmobile/pm-r8a7779.c       |    1 
 arch/arm/mach-shmobile/pm-sh7372.c        |    1 
 arch/arm/mach-shmobile/suspend.c          |    1 
 arch/arm/mach-tegra/cpu-tegra.c           |    1 
 arch/arm/mach-versatile/core.c            |    1 
 arch/arm/mach-versatile/pci.c             |    1 
 arch/arm/mach-vexpress/hotplug.c          |    1 
 arch/arm/mm/alignment.c                   |    3 
 arch/arm/mm/cache-xsc3l2.c                |    1 
 arch/arm/mm/fault.c                       |    3 
 arch/arm/mm/flush.c                       |    1 
 arch/arm/mm/idmap.c                       |    1 
 arch/arm/mm/ioremap.c                     |    2 
 arch/arm/mm/mmu.c                         |    2 
 arch/arm/mm/pgd.c                         |    1 
 arch/arm/mm/proc-fa526.S                  |    1 
 arch/arm/nwfpe/fpa11.c                    |    1 
 arch/arm/plat-iop/i2c.c                   |    1 
 arch/arm/plat-iop/pci.c                   |    1 
 arch/arm/plat-mxc/system.c                |    1 
 arch/arm/plat-omap/debug-leds.c           |    1 
 arch/arm/plat-omap/dma.c                  |    1 
 arch/arm/plat-omap/mux.c                  |    1 
 arch/arm/plat-pxa/dma.c                   |    1 
 arch/arm/plat-s3c24xx/dma.c               |    1 
 arch/arm/plat-samsung/cpu.c               |    1 
 arch/arm/plat-samsung/time.c              |    1 
 arch/arm/vfp/vfpmodule.c                  |    2 
 123 files changed, 617 insertions(+), 648 deletions(-)
 create mode 100644 arch/arm/include/asm/barrier.h
 create mode 100644 arch/arm/include/asm/cmpxchg.h
 create mode 100644 arch/arm/include/asm/compiler.h
 create mode 100644 arch/arm/include/asm/cr_reg.h
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
index 0000000..81b24b6
--- /dev/null
+++ b/arch/arm/include/asm/barrier.h
@@ -0,0 +1,64 @@
+#ifndef __ASM_BARRIER_H
+#define __ASM_BARRIER_H
+
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
diff --git a/arch/arm/include/asm/cr_reg.h b/arch/arm/include/asm/cr_reg.h
new file mode 100644
index 0000000..df83b5b
--- /dev/null
+++ b/arch/arm/include/asm/cr_reg.h
@@ -0,0 +1,85 @@
+#ifndef __ASM_ARM_CR_REG_H
+#define __ASM_ARM_CR_REG_H
+
+/*
+ * CR1 bits (CP#15 CR1)
+ */
+#define CR_M	(1 << 0)	/* MMU enable				*/
+#define CR_A	(1 << 1)	/* Alignment abort enable		*/
+#define CR_C	(1 << 2)	/* Dcache enable			*/
+#define CR_W	(1 << 3)	/* Write buffer enable			*/
+#define CR_P	(1 << 4)	/* 32-bit exception handler		*/
+#define CR_D	(1 << 5)	/* 32-bit data address range		*/
+#define CR_L	(1 << 6)	/* Implementation defined		*/
+#define CR_B	(1 << 7)	/* Big endian				*/
+#define CR_S	(1 << 8)	/* System MMU protection		*/
+#define CR_R	(1 << 9)	/* ROM MMU protection			*/
+#define CR_F	(1 << 10)	/* Implementation defined		*/
+#define CR_Z	(1 << 11)	/* Implementation defined		*/
+#define CR_I	(1 << 12)	/* Icache enable			*/
+#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
+#define CR_RR	(1 << 14)	/* Round Robin cache replacement	*/
+#define CR_L4	(1 << 15)	/* LDR pc can set T bit			*/
+#define CR_DT	(1 << 16)
+#define CR_IT	(1 << 18)
+#define CR_ST	(1 << 19)
+#define CR_FI	(1 << 21)	/* Fast interrupt (lower latency mode)	*/
+#define CR_U	(1 << 22)	/* Unaligned access operation		*/
+#define CR_XP	(1 << 23)	/* Extended page tables			*/
+#define CR_VE	(1 << 24)	/* Vectored interrupts			*/
+#define CR_EE	(1 << 25)	/* Exception (Big) Endian		*/
+#define CR_TRE	(1 << 28)	/* TEX remap enable			*/
+#define CR_AFE	(1 << 29)	/* Access flag enable			*/
+#define CR_TE	(1 << 30)	/* Thumb exception enable		*/
+
+#ifndef __ASSEMBLY__
+
+extern unsigned long cr_no_alignment;	/* defined in entry-armv.S */
+extern unsigned long cr_alignment;	/* defined in entry-armv.S */
+
+#if __LINUX_ARM_ARCH__ >= 4
+#define vectors_high()	(cr_alignment & CR_V)
+#else
+#define vectors_high()	(0)
+#endif
+
+static inline unsigned int get_cr(void)
+{
+	unsigned int val;
+	asm("mrc p15, 0, %0, c1, c0, 0	@ get CR" : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_cr(unsigned int val)
+{
+	asm volatile("mcr p15, 0, %0, c1, c0, 0	@ set CR"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+#ifndef CONFIG_SMP
+extern void adjust_cr(unsigned long mask, unsigned long set);
+#endif
+
+#define CPACC_FULL(n)		(3 << (n * 2))
+#define CPACC_SVC(n)		(1 << (n * 2))
+#define CPACC_DISABLE(n)	(0 << (n * 2))
+
+static inline unsigned int get_copro_access(void)
+{
+	unsigned int val;
+	asm("mrc p15, 0, %0, c1, c0, 2 @ get copro access"
+	  : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_copro_access(unsigned int val)
+{
+	asm volatile("mcr p15, 0, %0, c1, c0, 2 @ set copro access"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __ASM_ARM_CR_REG_H */
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
index b5dc173..489f160 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -10,6 +10,8 @@
 #ifndef __ASM_PROC_DOMAIN_H
 #define __ASM_PROC_DOMAIN_H
 
+#include <asm/barrier.h>
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
index 9275828..0a34bf7 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 #include <asm/memory.h>
-#include <asm/system.h>
 #include <asm-generic/pci_iomap.h>
 
 /*
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
index e4c96cc..ae2c8c2 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -1,543 +1,9 @@
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
- * CR1 bits (CP#15 CR1)
- */
-#define CR_M	(1 << 0)	/* MMU enable				*/
-#define CR_A	(1 << 1)	/* Alignment abort enable		*/
-#define CR_C	(1 << 2)	/* Dcache enable			*/
-#define CR_W	(1 << 3)	/* Write buffer enable			*/
-#define CR_P	(1 << 4)	/* 32-bit exception handler		*/
-#define CR_D	(1 << 5)	/* 32-bit data address range		*/
-#define CR_L	(1 << 6)	/* Implementation defined		*/
-#define CR_B	(1 << 7)	/* Big endian				*/
-#define CR_S	(1 << 8)	/* System MMU protection		*/
-#define CR_R	(1 << 9)	/* ROM MMU protection			*/
-#define CR_F	(1 << 10)	/* Implementation defined		*/
-#define CR_Z	(1 << 11)	/* Implementation defined		*/
-#define CR_I	(1 << 12)	/* Icache enable			*/
-#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
-#define CR_RR	(1 << 14)	/* Round Robin cache replacement	*/
-#define CR_L4	(1 << 15)	/* LDR pc can set T bit			*/
-#define CR_DT	(1 << 16)
-#define CR_IT	(1 << 18)
-#define CR_ST	(1 << 19)
-#define CR_FI	(1 << 21)	/* Fast interrupt (lower latency mode)	*/
-#define CR_U	(1 << 22)	/* Unaligned access operation		*/
-#define CR_XP	(1 << 23)	/* Extended page tables			*/
-#define CR_VE	(1 << 24)	/* Vectored interrupts			*/
-#define CR_EE	(1 << 25)	/* Exception (Big) Endian		*/
-#define CR_TRE	(1 << 28)	/* TEX remap enable			*/
-#define CR_AFE	(1 << 29)	/* Access flag enable			*/
-#define CR_TE	(1 << 30)	/* Thumb exception enable		*/
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
-#if __LINUX_ARM_ARCH__ >= 4
-#define vectors_high()	(cr_alignment & CR_V)
-#else
-#define vectors_high()	(0)
-#endif
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
-extern unsigned long cr_no_alignment;	/* defined in entry-armv.S */
-extern unsigned long cr_alignment;	/* defined in entry-armv.S */
-
-static inline unsigned int get_cr(void)
-{
-	unsigned int val;
-	asm("mrc p15, 0, %0, c1, c0, 0	@ get CR" : "=r" (val) : : "cc");
-	return val;
-}
-
-static inline void set_cr(unsigned int val)
-{
-	asm volatile("mcr p15, 0, %0, c1, c0, 0	@ set CR"
-	  : : "r" (val) : "cc");
-	isb();
-}
-
-#ifndef CONFIG_SMP
-extern void adjust_cr(unsigned long mask, unsigned long set);
-#endif
-
-#define CPACC_FULL(n)		(3 << (n * 2))
-#define CPACC_SVC(n)		(1 << (n * 2))
-#define CPACC_DISABLE(n)	(0 << (n * 2))
-
-static inline unsigned int get_copro_access(void)
-{
-	unsigned int val;
-	asm("mrc p15, 0, %0, c1, c0, 2 @ get copro access"
-	  : "=r" (val) : : "cc");
-	return val;
-}
-
-static inline void set_copro_access(unsigned int val)
-{
-	asm volatile("mcr p15, 0, %0, c1, c0, 2 @ set copro access"
-	  : : "r" (val) : "cc");
-	isb();
-}
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
+#include <asm/cr_reg.h>
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
index 0000000..f5cf1e8
--- /dev/null
+++ b/arch/arm/include/asm/system_misc.h
@@ -0,0 +1,35 @@
+#ifndef __ASM_ARM_SYSTEM_MISC_H
+#define __ASM_ARM_SYSTEM_MISC_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+
+#include <asm/outercache.h>
+
+extern int __pure cpu_architecture(void);
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
+#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
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
index be16a48..0260594 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -24,7 +24,6 @@
 #include <asm/unwind.h>
 #include <asm/unistd.h>
 #include <asm/tls.h>
-#include <asm/system.h>
 
 #include "entry-header.S"
 #include <asm/entry-macro-multi.S>
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 4c164ec..0b484c2 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -44,7 +44,6 @@
 #include <asm/cacheflush.h>
 #include <asm/fiq.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 static unsigned long no_fiq_insn;
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index d46f259..601d2fd 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -18,7 +18,6 @@
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
-#include <asm/system.h>
 
 /*
  * Kernel startup entry point.
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6d57911..db344db 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -20,8 +20,8 @@
 #include <asm/asm-offsets.h>
 #include <asm/memory.h>
 #include <asm/thread_info.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
+#include <asm/cr_reg.h>
 
 #ifdef CONFIG_DEBUG_LL
 #include <mach/debug-macro.S>
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
diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 764bd45..e097865 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -12,7 +12,6 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
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
index a255c39..e20ed9b 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -44,7 +44,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 
 #include <asm/prom.h>
 #include <asm/mach/arch.h>
@@ -53,6 +52,9 @@
 #include <asm/traps.h>
 #include <asm/unwind.h>
 #include <asm/memblock.h>
+#include <asm/system_info.h>
+#include <asm/system_misc.h>
+#include <asm/cr_reg.h>
 
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
diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
index 294aad0..e43dcc0 100644
--- a/arch/arm/mach-ebsa110/core.c
+++ b/arch/arm/mach-ebsa110/core.c
@@ -22,7 +22,6 @@
 #include <asm/mach-types.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
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
index 54f91ad..32fe638 100644
--- a/arch/arm/mach-mxs/system.c
+++ b/arch/arm/mach-mxs/system.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 
 #include <asm/proc-fns.h>
-#include <asm/system.h>
 
 #include <mach/mxs.h>
 #include <mach/common.h>
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
index 4cfb40b..977538f 100644
--- a/arch/arm/mach-pnx4008/core.c
+++ b/arch/arm/mach-pnx4008/core.c
@@ -32,7 +32,6 @@
 #include <asm/mach-types.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
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
index bb10ee2..17caece 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -21,7 +21,6 @@
 
 #include <asm/div64.h>
 #include <mach/hardware.h>
-#include <asm/system.h>
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
 #include <asm/irq.h>
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
index c1febe1..12d760c 100644
--- a/arch/arm/mach-shmobile/suspend.c
+++ b/arch/arm/mach-shmobile/suspend.c
@@ -12,7 +12,6 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 static int shmobile_suspend_default_enter(suspend_state_t suspend_state)
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
diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index 3034a4d..e352494 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -14,7 +14,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
-#include <asm/system.h>
 
 extern volatile int pen_release;
 
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index caf14dc..b524eb2 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -22,8 +22,9 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/unaligned.h>
+#include <asm/cr_reg.h>
+#include <asm/system_info.h>
 
 #include "fault.h"
 
diff --git a/arch/arm/mm/cache-xsc3l2.c b/arch/arm/mm/cache-xsc3l2.c
index 5a32020..c4ae2b4 100644
--- a/arch/arm/mm/cache-xsc3l2.c
+++ b/arch/arm/mm/cache-xsc3l2.c
@@ -18,7 +18,6 @@
  */
 #include <linux/init.h>
 #include <linux/highmem.h>
-#include <asm/system.h>
 #include <asm/cputype.h>
 #include <asm/cacheflush.h>
 
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
index 80632e8..436ebee 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -32,6 +32,8 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/sizes.h>
+#include <asm/system_info.h>
+#include <asm/cr_reg.h>
 
 #include <asm/mach/map.h>
 #include "mm.h"
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 94c5a0c..bd48a73 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -26,6 +26,8 @@
 #include <asm/tlb.h>
 #include <asm/highmem.h>
 #include <asm/traps.h>
+#include <asm/cr_reg.h>
+#include <asm/system_info.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mm/pgd.c b/arch/arm/mm/pgd.c
index a3e78cc..8121294 100644
--- a/arch/arm/mm/pgd.c
+++ b/arch/arm/mm/pgd.c
@@ -15,6 +15,7 @@
 #include <asm/pgalloc.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
+#include <asm/cr_reg.h>
 
 #include "mm.h"
 
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
diff --git a/arch/arm/plat-mxc/system.c b/arch/arm/plat-mxc/system.c
index 3599bf2..8f12074 100644
--- a/arch/arm/plat-mxc/system.c
+++ b/arch/arm/plat-mxc/system.c
@@ -26,7 +26,6 @@
 #include <mach/hardware.h>
 #include <mach/common.h>
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
 
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8f3ccdd..f5cc605 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -21,6 +21,8 @@
 #include <asm/cputype.h>
 #include <asm/thread_notify.h>
 #include <asm/vfp.h>
+#include <asm/cr_reg.h>
+#include <asm/system_info.h>
 
 #include "vfpinstr.h"
 #include "vfp.h"

