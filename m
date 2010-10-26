Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab0JZC43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:56:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485Ab0JZC4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 35/43] MN10300: And Panasonic AM34 subarch and implement SMP
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:56:08 +0100
Message-ID: <20101026025608.23512.60938.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Implement the Panasonic MN10300 AM34 CPU subarch and implement SMP support for
MN10300.  Also implement support for the MN2WS0060 processor and the ASB2364
evaluation board which are AM34 based.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 MAINTAINERS                                        |    2 
 arch/mn10300/Kconfig                               |  119 ++
 arch/mn10300/Makefile                              |    6 
 arch/mn10300/boot/compressed/head.S                |   20 
 arch/mn10300/include/asm/exceptions.h              |    2 
 arch/mn10300/include/asm/frame.inc                 |   36 +
 arch/mn10300/include/asm/hardirq.h                 |    2 
 arch/mn10300/include/asm/intctl-regs.h             |   37 -
 arch/mn10300/include/asm/irq.h                     |    4 
 arch/mn10300/include/asm/irqflags.h                |   26 
 arch/mn10300/include/asm/pgtable.h                 |   19 
 arch/mn10300/include/asm/processor.h               |   47 +
 arch/mn10300/include/asm/ptrace.h                  |   15 
 arch/mn10300/include/asm/reset-regs.h              |    2 
 arch/mn10300/include/asm/rtc.h                     |   11 
 arch/mn10300/include/asm/rwlock.h                  |  125 ++
 arch/mn10300/include/asm/serial-regs.h             |   51 +
 arch/mn10300/include/asm/serial.h                  |    8 
 arch/mn10300/include/asm/smp.h                     |  102 ++
 arch/mn10300/include/asm/spinlock.h                |  179 +++
 arch/mn10300/include/asm/spinlock_types.h          |   20 
 arch/mn10300/include/asm/system.h                  |   11 
 arch/mn10300/include/asm/timer-regs.h              |  191 +++
 arch/mn10300/include/asm/timex.h                   |    3 
 arch/mn10300/include/asm/uaccess.h                 |    2 
 arch/mn10300/kernel/Makefile                       |    3 
 arch/mn10300/kernel/asm-offsets.c                  |    2 
 arch/mn10300/kernel/entry.S                        |  113 ++
 arch/mn10300/kernel/gdb-io-serial-low.S            |    5 
 arch/mn10300/kernel/gdb-io-serial.c                |   37 -
 arch/mn10300/kernel/gdb-io-ttysm.c                 |   24 
 arch/mn10300/kernel/gdb-stub.c                     |   17 
 arch/mn10300/kernel/head.S                         |  196 +++
 arch/mn10300/kernel/internal.h                     |   12 
 arch/mn10300/kernel/irq.c                          |  266 ++++-
 arch/mn10300/kernel/mn10300-serial-low.S           |    6 
 arch/mn10300/kernel/mn10300-serial.c               |  210 +++-
 arch/mn10300/kernel/mn10300-watchdog-low.S         |    9 
 arch/mn10300/kernel/mn10300-watchdog.c             |  100 +-
 arch/mn10300/kernel/process.c                      |   41 +
 arch/mn10300/kernel/profile.c                      |    2 
 arch/mn10300/kernel/rtc.c                          |   41 -
 arch/mn10300/kernel/setup.c                        |   75 +
 arch/mn10300/kernel/smp-low.S                      |   97 ++
 arch/mn10300/kernel/smp.c                          | 1141 ++++++++++++++++++++
 arch/mn10300/kernel/switch_to.S                    |   17 
 arch/mn10300/kernel/time.c                         |   32 -
 arch/mn10300/kernel/traps.c                        |   18 
 arch/mn10300/lib/delay.c                           |    8 
 arch/mn10300/mm/fault.c                            |   12 
 arch/mn10300/proc-mn103e010/include/proc/clock.h   |    2 
 .../proc-mn103e010/include/proc/intctl-regs.h      |   29 +
 arch/mn10300/proc-mn103e010/proc-init.c            |   35 +
 arch/mn10300/proc-mn2ws0050/Makefile               |    5 
 arch/mn10300/proc-mn2ws0050/include/proc/cache.h   |   48 +
 arch/mn10300/proc-mn2ws0050/include/proc/clock.h   |   20 
 .../proc-mn2ws0050/include/proc/dmactl-regs.h      |  103 ++
 .../proc-mn2ws0050/include/proc/intctl-regs.h      |   29 +
 arch/mn10300/proc-mn2ws0050/include/proc/irq.h     |   49 +
 .../proc-mn2ws0050/include/proc/nand-regs.h        |  120 ++
 arch/mn10300/proc-mn2ws0050/include/proc/proc.h    |   18 
 .../mn10300/proc-mn2ws0050/include/proc/smp-regs.h |   51 +
 arch/mn10300/proc-mn2ws0050/proc-init.c            |  134 ++
 arch/mn10300/unit-asb2303/include/unit/clock.h     |   25 
 arch/mn10300/unit-asb2303/include/unit/serial.h    |    5 
 arch/mn10300/unit-asb2303/include/unit/timex.h     |   64 +
 arch/mn10300/unit-asb2303/unit-init.c              |   10 
 arch/mn10300/unit-asb2305/include/unit/clock.h     |   25 
 arch/mn10300/unit-asb2305/include/unit/serial.h    |    5 
 arch/mn10300/unit-asb2305/include/unit/timex.h     |   66 +
 arch/mn10300/unit-asb2305/pci.c                    |    2 
 arch/mn10300/unit-asb2305/unit-init.c              |    6 
 arch/mn10300/unit-asb2364/Makefile                 |   10 
 arch/mn10300/unit-asb2364/include/unit/clock.h     |   29 +
 arch/mn10300/unit-asb2364/include/unit/fpga-regs.h |   50 +
 arch/mn10300/unit-asb2364/include/unit/leds.h      |   54 +
 arch/mn10300/unit-asb2364/include/unit/serial.h    |  151 +++
 arch/mn10300/unit-asb2364/include/unit/timex.h     |  125 ++
 arch/mn10300/unit-asb2364/leds.c                   |   98 ++
 arch/mn10300/unit-asb2364/unit-init.c              |   85 +
 80 files changed, 4495 insertions(+), 482 deletions(-)
 create mode 100644 arch/mn10300/include/asm/rwlock.h
 create mode 100644 arch/mn10300/include/asm/spinlock_types.h
 create mode 100644 arch/mn10300/kernel/smp-low.S
 create mode 100644 arch/mn10300/kernel/smp.c
 create mode 100644 arch/mn10300/proc-mn103e010/include/proc/intctl-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/Makefile
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/cache.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/clock.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/dmactl-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/intctl-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/irq.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/nand-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/proc.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/include/proc/smp-regs.h
 create mode 100644 arch/mn10300/proc-mn2ws0050/proc-init.c
 create mode 100644 arch/mn10300/unit-asb2364/Makefile
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/clock.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/fpga-regs.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/leds.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/serial.h
 create mode 100644 arch/mn10300/unit-asb2364/include/unit/timex.h
 create mode 100644 arch/mn10300/unit-asb2364/leds.c
 create mode 100644 arch/mn10300/unit-asb2364/unit-init.c


diff --git a/MAINTAINERS b/MAINTAINERS
index 146b8a0..5ef7776 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4481,7 +4481,7 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/panasonic-laptop.c
 
-PANASONIC MN10300/AM33 PORT
+PANASONIC MN10300/AM33/AM34 PORT
 M:	David Howells <dhowells@redhat.com>
 M:	Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
 L:	linux-am33-list@redhat.com (moderated for non-subscribers)
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index a0a16e6..81e2781 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -48,7 +48,7 @@ config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
 config GENERIC_CMOS_UPDATE
-        def_bool y
+        def_bool n
 
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
@@ -72,10 +72,6 @@ config GENERIC_HARDIRQS
 config HOTPLUG_CPU
 	def_bool n
 
-config HZ
-	int
-	default 1000
-
 mainmenu "Matsushita MN10300/AM33 Kernel Configuration"
 
 source "init/Kconfig"
@@ -98,6 +94,9 @@ config MN10300_UNIT_ASB2303
 config MN10300_UNIT_ASB2305
 	bool "ASB2305"
 
+config MN10300_UNIT_ASB2364
+	bool "ASB2364"
+
 endchoice
 
 choice
@@ -115,17 +114,13 @@ config MN10300_PROC_MN103E010
 	select MN10300_PROC_HAS_TTYSM1
 	select MN10300_PROC_HAS_TTYSM2
 
-endchoice
-
-choice
-	prompt "Processor core support"
-	default MN10300_CPU_AM33V2
-	help
-	  This option specifies the processor core for which the kernel will be
-	  compiled. It affects the instruction set used.
-
-config MN10300_CPU_AM33V2
-	bool "AM33v2"
+config MN10300_PROC_MN2WS0050
+	bool "MN2WS0050"
+	depends on MN10300_UNIT_ASB2364
+	select AM34_2
+	select MN10300_PROC_HAS_TTYSM0
+	select MN10300_PROC_HAS_TTYSM1
+	select MN10300_PROC_HAS_TTYSM2
 
 endchoice
 
@@ -138,7 +133,7 @@ config MN10300_HAS_ATOMIC_OPS_UNIT
 config FPU
 	bool "FPU present"
 	default y
-	depends on MN10300_PROC_MN103E010
+	depends on MN10300_PROC_MN103E010 || MN10300_PROC_MN2WS0050
 
 config LAZY_SAVE_FPU
 	bool "Save FPU state lazily"
@@ -179,24 +174,55 @@ config KERNEL_TEXT_ADDRESS
 
 config KERNEL_ZIMAGE_BASE_ADDRESS
 	hex "Base address of compressed vmlinux image"
-	default "0x90700000"
+	default "0x50700000"
+
+config BOOT_STACK_OFFSET
+	hex
+	default	"0xF00"	if SMP
+	default	"0xFF0" if !SMP
 
+config BOOT_STACK_SIZE
+	hex
+	depends on SMP
+	default	"0x100"
 endmenu
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	help
-	  This option reduces the latency of the kernel when reacting to
-	  real-time or interactive events by allowing a low priority process to
-	  be preempted even if it is in kernel mode executing a system call.
-	  This allows applications to run more reliably even when the system is
-	  under load.
+config SMP
+	bool "Symmetric multi-processing support"
+	default y
+	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
+	---help---
+	  This enables support for systems with more than one CPU. If you have
+	  a system with only one CPU, like most personal computers, say N. If
+	  you have a system with more than one CPU, say Y.
+
+	  If you say N here, the kernel will run on single and multiprocessor
+	  machines, but will use only one CPU of a multiprocessor machine. If
+	  you say Y here, the kernel will run on many, but not all,
+	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  will run faster if you say N here.
+
+	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
+	  <http://www.tldp.org/docs.html#howto>.
 
-	  Say Y here if you are building a kernel for a desktop, embedded
-	  or real-time system.  Say N if you are unsure.
+	  If you don't know what to do here, say N.
+
+config NR_CPUS
+	int
+	depends on SMP
+	default "2"
+
+config USE_GENERIC_SMP_HELPERS
+	bool
+	depends on SMP
+	default y
+
+source "kernel/Kconfig.preempt"
 
 config MN10300_CURRENT_IN_E2
 	bool "Hold current task address in E2 register"
+	depends on !SMP
 	default y
 	help
 	  This option removes the E2/R2 register from the set available to gcc
@@ -218,12 +244,14 @@ config MN10300_USING_JTAG
 	  suppresses the use of certain hardware debugging features, such as
 	  single-stepping, which are taken over completely by the JTAG unit.
 
+source "kernel/Kconfig.hz"
+
 config MN10300_RTC
 	bool "Using MN10300 RTC"
-	depends on MN10300_PROC_MN103E010
+	depends on MN10300_PROC_MN103E010 || MN10300_PROC_MN2WS0050
+	select GENERIC_CMOS_UPDATE
 	default n
 	help
-
 	  This option enables support for the RTC, thus enabling time to be
 	  tracked, even when system is powered down. This is available on-chip
 	  on the MN103E010.
@@ -315,14 +343,23 @@ config MN10300_TTYSM1
 
 choice
 	prompt "Select the timer to supply the clock for SIF1"
-	default MN10300_TTYSM0_TIMER9
+	default MN10300_TTYSM1_TIMER12 \
+		if !(AM33_2 || AM33_3)
+	default MN10300_TTYSM1_TIMER9 \
+		if AM33_2 || AM33_3
 	depends on MN10300_TTYSM1
 
+config MN10300_TTYSM1_TIMER12
+	bool "Use timer 12 (16-bit)"
+	depends on !(AM33_2 || AM33_3)
+
 config MN10300_TTYSM1_TIMER9
 	bool "Use timer 9 (16-bit)"
+	depends on AM33_2 || AM33_3
 
 config MN10300_TTYSM1_TIMER3
 	bool "Use timer 3 (8-bit)"
+	depends on AM33_2 || AM33_3
 
 endchoice
 
@@ -337,17 +374,33 @@ config MN10300_TTYSM2
 
 choice
 	prompt "Select the timer to supply the clock for SIF2"
-	default MN10300_TTYSM0_TIMER10
+	default MN10300_TTYSM2_TIMER3 \
+		if !(AM33_2 || AM33_3)
+	default MN10300_TTYSM2_TIMER10 \
+		if AM33_2 || AM33_3
 	depends on MN10300_TTYSM2
 
+config MN10300_TTYSM2_TIMER9
+	bool "Use timer 9 (16-bit)"
+	depends on !(AM33_2 || AM33_3)
+
+config MN10300_TTYSM2_TIMER1
+	bool "Use timer 1 (8-bit)"
+	depends on !(AM33_2 || AM33_3)
+
+config MN10300_TTYSM2_TIMER3
+	bool "Use timer 3 (8-bit)"
+	depends on !(AM33_2 || AM33_3)
+
 config MN10300_TTYSM2_TIMER10
 	bool "Use timer 10 (16-bit)"
+	depends on AM33_2 || AM33_3
 
 endchoice
 
 config MN10300_TTYSM2_CTS
 	bool "Enable the use of the CTS line /dev/ttySM2"
-	depends on MN10300_TTYSM2
+	depends on MN10300_TTYSM2 && AM33_2
 
 endmenu
 
diff --git a/arch/mn10300/Makefile b/arch/mn10300/Makefile
index ac5c6bd..7120282 100644
--- a/arch/mn10300/Makefile
+++ b/arch/mn10300/Makefile
@@ -36,6 +36,9 @@ endif
 ifeq ($(CONFIG_MN10300_PROC_MN103E010),y)
 PROCESSOR	:= mn103e010
 endif
+ifeq ($(CONFIG_MN10300_PROC_MN2WS0050),y)
+PROCESSOR	:= mn2ws0050
+endif
 
 ifeq ($(CONFIG_MN10300_UNIT_ASB2303),y)
 UNIT		:= asb2303
@@ -43,6 +46,9 @@ endif
 ifeq ($(CONFIG_MN10300_UNIT_ASB2305),y)
 UNIT		:= asb2305
 endif
+ifeq ($(CONFIG_MN10300_UNIT_ASB2364),y)
+UNIT		:= asb2364
+endif
 
 
 head-y		:= arch/mn10300/kernel/head.o arch/mn10300/kernel/init_task.o
diff --git a/arch/mn10300/boot/compressed/head.S b/arch/mn10300/boot/compressed/head.S
index 4ef608a..7b50345 100644
--- a/arch/mn10300/boot/compressed/head.S
+++ b/arch/mn10300/boot/compressed/head.S
@@ -15,10 +15,28 @@
 #include <linux/linkage.h>
 #include <asm/cpu-regs.h>
 #include <asm/cache.h>
+#ifdef CONFIG_SMP
+#include <proc/smp-regs.h>
+#endif
 
 	.globl startup_32
 startup_32:
-	# first save off parameters from bootloader
+#ifdef CONFIG_SMP
+	#
+	# Secondary CPUs jump directly to the kernel entry point
+	#
+	# Must save primary CPU's D0-D2 registers as they hold boot parameters
+	#
+	mov	(CPUID), d3
+	and	CPUID_MASK,d3
+	beq	startup_primary
+	mov	CONFIG_KERNEL_TEXT_ADDRESS,a0
+	jmp	(a0)
+
+startup_primary:
+#endif /* CONFIG_SMP */
+
+	# first save parameters from bootloader
 	mov	param_save_area,a0
 	mov	d0,(a0)
 	mov	d1,(4,a0)
diff --git a/arch/mn10300/include/asm/exceptions.h b/arch/mn10300/include/asm/exceptions.h
index 7d8080b..ca3e205 100644
--- a/arch/mn10300/include/asm/exceptions.h
+++ b/arch/mn10300/include/asm/exceptions.h
@@ -114,6 +114,8 @@ extern void die(const char *, struct pt_regs *, enum exception_code)
 
 extern int die_if_no_fixup(const char *, struct pt_regs *, enum exception_code);
 
+#define NUM2EXCEP_IRQ_LEVEL(num)	(EXCEP_IRQ_LEVEL0 + (num) * 8)
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_EXCEPTIONS_H */
diff --git a/arch/mn10300/include/asm/frame.inc b/arch/mn10300/include/asm/frame.inc
index 5b1949b..406060e 100644
--- a/arch/mn10300/include/asm/frame.inc
+++ b/arch/mn10300/include/asm/frame.inc
@@ -18,6 +18,9 @@
 #ifndef __ASM_OFFSETS_H__
 #include <asm/asm-offsets.h>
 #endif
+#ifdef CONFIG_SMP
+#include <proc/smp-regs.h>
+#endif
 
 #define pi break
 
@@ -37,9 +40,25 @@
 	movm	[d2,d3,a2,a3,exreg0,exreg1,exother],(sp)
 	mov	sp,fp				# FRAME pointer in A3
 	add	-12,sp				# allow for calls to be made
+#ifdef CONFIG_SMP
+#ifdef CONFIG_PREEMPT /* FIXME */
+	mov	epsw,d2
+	and	~EPSW_IE,epsw
+#endif
+	mov	(CPUID),a0
+	add	a0,a0
+	add	a0,a0
+	mov	(___frame,a0),a1
+	mov	a1,(REG_NEXT,fp)
+	mov	fp,(___frame,a0)
+#ifdef CONFIG_PREEMPT /* FIXME */
+	mov	d2,epsw
+#endif
+#else  /* CONFIG_SMP */
 	mov	(__frame),a1
 	mov	a1,(REG_NEXT,fp)
 	mov	fp,(__frame)
+#endif /* CONFIG_SMP */
 
 	and	~EPSW_FE,epsw			# disable the FPU inside the kernel
 
@@ -57,10 +76,27 @@
 .macro RESTORE_ALL
 	# peel back the stack to the calling frame
 	# - this permits execve() to discard extra frames due to kernel syscalls
+#ifdef  CONFIG_SMP
+#ifdef CONFIG_PREEMPT /* FIXME */
+	mov	epsw,d2
+	and	~EPSW_IE,epsw
+#endif
+	mov	(CPUID),a0
+	add	a0,a0
+	add	a0,a0
+	mov	(___frame,a0),fp
+	mov	fp,sp
+	mov	(REG_NEXT,fp),d0                # userspace has regs->next == 0
+	mov	d0,(___frame,a0)
+#ifdef CONFIG_PREEMPT /* FIXME */
+	mov	d2,epsw
+#endif
+#else   /* CONFIG_SMP */
 	mov	(__frame),fp
 	mov	fp,sp
 	mov	(REG_NEXT,fp),d0                # userspace has regs->next == 0
 	mov	d0,(__frame)
+#endif  /* CONFIG_SMP */
 
 #ifndef CONFIG_MN10300_USING_JTAG
 	mov	(REG_EPSW,fp),d0
diff --git a/arch/mn10300/include/asm/hardirq.h b/arch/mn10300/include/asm/hardirq.h
index 7bd9b7c..0000d65 100644
--- a/arch/mn10300/include/asm/hardirq.h
+++ b/arch/mn10300/include/asm/hardirq.h
@@ -19,8 +19,10 @@
 /* assembly code in softirq.h is sensitive to the offsets of these fields */
 typedef struct {
 	unsigned int	__softirq_pending;
+#ifdef CONFIG_MN10300_WD_TIMER
 	unsigned int	__nmi_count;	/* arch dependent */
 	unsigned int	__irq_count;	/* arch dependent */
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
diff --git a/arch/mn10300/include/asm/intctl-regs.h b/arch/mn10300/include/asm/intctl-regs.h
index ba544c7..585b708 100644
--- a/arch/mn10300/include/asm/intctl-regs.h
+++ b/arch/mn10300/include/asm/intctl-regs.h
@@ -15,24 +15,19 @@
 
 #ifdef __KERNEL__
 
-/* interrupt controller registers */
-#define GxICR(X)		__SYSREG(0xd4000000 + (X) * 4, u16)	/* group irq ctrl regs */
-
-#define IAGR			__SYSREG(0xd4000100, u16)	/* intr acceptance group reg */
-#define IAGR_GN			0x00fc		/* group number register
-						 * (documentation _has_ to be wrong)
-						 */
+/*
+ * Interrupt controller registers
+ * - Registers 64-191 are at addresses offset from the main array
+ */
+#define GxICR(X)						\
+	__SYSREG(0xd4000000 + (X) * 4 +				\
+		 (((X) >= 64) && ((X) < 192)) * 0xf00, u16)
 
-#define EXTMD			__SYSREG(0xd4000200, u16)	/* external pin intr spec reg */
-#define GET_XIRQ_TRIGGER(X) ((EXTMD >> ((X) * 2)) & 3)
+#define GxICR_u8(X)							\
+	__SYSREG(0xd4000000 + (X) * 4 +					\
+		 (((X) >= 64) && ((X) < 192)) * 0xf00, u8)
 
-#define SET_XIRQ_TRIGGER(X,Y)			\
-do {						\
-	u16 x = EXTMD;				\
-	x &= ~(3 << ((X) * 2));			\
-	x |= ((Y) & 3) << ((X) * 2);		\
-	EXTMD = x;				\
-} while (0)
+#include <proc/intctl-regs.h>
 
 #define XIRQ_TRIGGER_LOWLEVEL	0
 #define XIRQ_TRIGGER_HILEVEL	1
@@ -59,10 +54,18 @@ do {						\
 #define GxICR_LEVEL_5		0x5000		/* - level 5 */
 #define GxICR_LEVEL_6		0x6000		/* - level 6 */
 #define GxICR_LEVEL_SHIFT	12
+#define GxICR_NMI		0x8000		/* nmi request flag */
+
+#define NUM2GxICR_LEVEL(num)	((num) << GxICR_LEVEL_SHIFT)
 
 #ifndef __ASSEMBLY__
 extern void set_intr_level(int irq, u16 level);
-extern void set_intr_postackable(int irq);
+extern void mn10300_intc_set_level(unsigned int irq, unsigned int level);
+extern void mn10300_intc_clear(unsigned int irq);
+extern void mn10300_intc_set(unsigned int irq);
+extern void mn10300_intc_enable(unsigned int irq);
+extern void mn10300_intc_disable(unsigned int irq);
+extern void mn10300_set_lateack_irq_type(int irq);
 #endif
 
 /* external interrupts */
diff --git a/arch/mn10300/include/asm/irq.h b/arch/mn10300/include/asm/irq.h
index 25c045d..b7b8e17 100644
--- a/arch/mn10300/include/asm/irq.h
+++ b/arch/mn10300/include/asm/irq.h
@@ -22,7 +22,11 @@
 #define NO_IRQ		INT_MAX
 
 /* hardware irq numbers */
+#ifdef CONFIG_SMP
+#define NR_IRQS		GxICR_NUM_EXT_IRQS
+#else
 #define NR_IRQS		GxICR_NUM_IRQS
+#endif
 
 /* external hardware irq numbers */
 #define NR_XIRQS	GxICR_NUM_XIRQS
diff --git a/arch/mn10300/include/asm/irqflags.h b/arch/mn10300/include/asm/irqflags.h
index b3ab207..7a7ae12 100644
--- a/arch/mn10300/include/asm/irqflags.h
+++ b/arch/mn10300/include/asm/irqflags.h
@@ -13,6 +13,9 @@
 #define _ASM_IRQFLAGS_H
 
 #include <asm/cpu-regs.h>
+#ifndef __ASSEMBLY__
+#include <linux/smp.h>
+#endif
 
 /*
  * interrupt control
@@ -60,11 +63,12 @@ static inline unsigned long arch_local_irq_save(void)
 /*
  * we make sure arch_irq_enable() doesn't cause priority inversion
  */
-extern unsigned long __mn10300_irq_enabled_epsw;
+extern unsigned long __mn10300_irq_enabled_epsw[];
 
 static inline void arch_local_irq_enable(void)
 {
 	unsigned long tmp;
+	int cpu = raw_smp_processor_id();
 
 	asm volatile(
 		"	mov	epsw,%0		\n"
@@ -72,8 +76,8 @@ static inline void arch_local_irq_enable(void)
 		"	or	%2,%0		\n"
 		"	mov	%0,epsw		\n"
 		: "=&d"(tmp)
-		: "i"(~EPSW_IM), "r"(__mn10300_irq_enabled_epsw)
-		: "memory");
+		: "i"(~EPSW_IM), "r"(__mn10300_irq_enabled_epsw[cpu])
+		: "memory", "cc");
 }
 
 static inline void arch_local_irq_restore(unsigned long flags)
@@ -105,6 +109,9 @@ static inline bool arch_irqs_disabled(void)
  */
 static inline void arch_safe_halt(void)
 {
+#ifdef CONFIG_SMP
+	arch_local_irq_enable();
+#else
 	asm volatile(
 		"	or	%0,epsw	\n"
 		"	nop		\n"
@@ -113,8 +120,21 @@ static inline void arch_safe_halt(void)
 		:
 		: "i"(EPSW_IE|EPSW_IM), "n"(&CPUM), "i"(CPUM_SLEEP)
 		: "cc");
+#endif
 }
 
+#define __sleep_cpu()				\
+do {						\
+	asm volatile(				\
+		"	bset	%1,(%0)\n"	\
+		"1:	btst	%1,(%0)\n"	\
+		"	bne	1b\n"		\
+		:				\
+		: "i"(&CPUM), "i"(CPUM_SLEEP)	\
+		: "cc"				\
+		);				\
+} while (0)
+
 static inline void arch_local_cli(void)
 {
 	asm volatile(
diff --git a/arch/mn10300/include/asm/pgtable.h b/arch/mn10300/include/asm/pgtable.h
index 93c3294..ba66606 100644
--- a/arch/mn10300/include/asm/pgtable.h
+++ b/arch/mn10300/include/asm/pgtable.h
@@ -90,9 +90,15 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
  * The vmalloc() routines also leaves a hole of 4kB between each vmalloced
  * area to catch addressing errors.
  */
+#ifndef __ASSEMBLY__
+#define VMALLOC_OFFSET	(8UL * 1024 * 1024)
+#define VMALLOC_START	(0x70000000UL)
+#define VMALLOC_END	(0x7C000000UL)
+#else
 #define VMALLOC_OFFSET	(8 * 1024 * 1024)
 #define VMALLOC_START	(0x70000000)
 #define VMALLOC_END	(0x7C000000)
+#endif
 
 #ifndef __ASSEMBLY__
 extern pte_t kernel_vmalloc_ptes[(VMALLOC_END - VMALLOC_START) / PAGE_SIZE];
@@ -329,11 +335,7 @@ static inline int pte_exec_kernel(pte_t pte)
 	return 1;
 }
 
-/*
- * Bits 0 and 1 are taken, split up the 29 bits of offset
- * into this range:
- */
-#define PTE_FILE_MAX_BITS	29
+#define PTE_FILE_MAX_BITS	30
 
 #define pte_to_pgoff(pte)	(pte_val(pte) >> 2)
 #define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
@@ -379,8 +381,13 @@ static inline void ptep_mkdirty(pte_t *ptep)
  * Macro to mark a page protection value as "uncacheable".  On processors which
  * do not support it, this is a no-op.
  */
-#define pgprot_noncached(prot)	__pgprot(pgprot_val(prot) | _PAGE_CACHE)
+#define pgprot_noncached(prot)	__pgprot(pgprot_val(prot) & ~_PAGE_CACHE)
 
+/*
+ * Macro to mark a page protection value as "Write-Through".
+ * On processors which do not support it, this is a no-op.
+ */
+#define pgprot_through(prot)	__pgprot(pgprot_val(prot) | _PAGE_CACHE_WT)
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index 0032fc7..75c422a 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -33,6 +33,8 @@ struct mm_struct;
 	__pc;					\
 })
 
+extern void get_mem_info(unsigned long *mem_base, unsigned long *mem_size);
+
 extern void show_registers(struct pt_regs *regs);
 
 /*
@@ -43,17 +45,22 @@ extern void show_registers(struct pt_regs *regs);
 
 struct mn10300_cpuinfo {
 	int		type;
-	unsigned long	loops_per_sec;
+	unsigned long	loops_per_jiffy;
 	char		hard_math;
-	unsigned long	*pgd_quick;
-	unsigned long	*pte_quick;
-	unsigned long	pgtable_cache_sz;
 };
 
 extern struct mn10300_cpuinfo boot_cpu_data;
 
+#ifdef CONFIG_SMP
+#if CONFIG_NR_CPUS < 2 || CONFIG_NR_CPUS > 8
+# error Sorry, NR_CPUS should be 2 to 8
+#endif
+extern struct mn10300_cpuinfo cpu_data[];
+#define current_cpu_data cpu_data[smp_processor_id()]
+#else  /* CONFIG_SMP */
 #define cpu_data &boot_cpu_data
 #define current_cpu_data boot_cpu_data
+#endif /* CONFIG_SMP */
 
 extern void identify_cpu(struct mn10300_cpuinfo *);
 extern void print_cpu_info(struct mn10300_cpuinfo *);
@@ -92,21 +99,21 @@ struct thread_struct {
 	unsigned long		a3;		/* kernel FP */
 	unsigned long		wchan;
 	unsigned long		usp;
-	struct pt_regs		*__frame;
+	struct pt_regs		*frame;
 	unsigned long		fpu_flags;
 #define THREAD_USING_FPU	0x00000001	/* T if this task is using the FPU */
 #define THREAD_HAS_FPU		0x00000002	/* T if this task owns the FPU right now */
 	struct fpu_state_struct	fpu_state;
 };
 
-#define INIT_THREAD				\
-{						\
-	.uregs		= init_uregs,		\
-	.pc		= 0,			\
-	.sp		= 0,			\
-	.a3		= 0,			\
-	.wchan		= 0,			\
-	.__frame	= NULL,			\
+#define INIT_THREAD		\
+{				\
+	.uregs	= init_uregs,	\
+	.pc	= 0,		\
+	.sp	= 0,		\
+	.a3	= 0,		\
+	.wchan	= 0,		\
+	.frame	= NULL,		\
 }
 
 #define INIT_MMAP \
@@ -118,6 +125,19 @@ struct thread_struct {
  * - need to discard the frame stacked by the kernel thread invoking the execve
  *   syscall (see RESTORE_ALL macro)
  */
+#if defined(CONFIG_SMP) && defined(CONFIG_PREEMPT) /* FIXME */
+#define start_thread(regs, new_pc, new_sp) do {		\
+	int cpu;					\
+	preempt_disable();				\
+	cpu = CPUID;					\
+	set_fs(USER_DS);				\
+	___frame[cpu] = current->thread.uregs;		\
+	___frame[cpu]->epsw = EPSW_nSL | EPSW_IE | EPSW_IM;\
+	___frame[cpu]->pc = new_pc;			\
+	___frame[cpu]->sp = new_sp;			\
+	preempt_enable();				\
+} while (0)
+#else  /* CONFIG_SMP && CONFIG_PREEMPT */
 #define start_thread(regs, new_pc, new_sp) do {		\
 	set_fs(USER_DS);				\
 	__frame = current->thread.uregs;		\
@@ -125,6 +145,7 @@ struct thread_struct {
 	__frame->pc = new_pc;				\
 	__frame->sp = new_sp;				\
 } while (0)
+#endif /* CONFIG_SMP && CONFIG_PREEMPT */
 
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
diff --git a/arch/mn10300/include/asm/ptrace.h b/arch/mn10300/include/asm/ptrace.h
index 7c2e911..c2b77bd 100644
--- a/arch/mn10300/include/asm/ptrace.h
+++ b/arch/mn10300/include/asm/ptrace.h
@@ -40,7 +40,6 @@
 #define	PT_PC		26
 #define NR_PTREGS	27
 
-#ifndef __ASSEMBLY__
 /*
  * This defines the way registers are stored in the event of an exception
  * - the strange order is due to the MOVM instruction
@@ -75,7 +74,6 @@ struct pt_regs {
 	unsigned long		epsw;
 	unsigned long		pc;
 };
-#endif
 
 /* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
 #define PTRACE_GETREGS            12
@@ -86,12 +84,13 @@ struct pt_regs {
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD     0x00000001
 
-#if defined(__KERNEL__)
+#ifdef __KERNEL__
 
+#ifdef CONFIG_SMP
+extern struct pt_regs *___frame[];	/* current frame pointer */
+#else
 extern struct pt_regs *__frame;		/* current frame pointer */
-
-#if !defined(__ASSEMBLY__)
-struct task_struct;
+#endif
 
 #define user_mode(regs)			(((regs)->epsw & EPSW_nSL) == EPSW_nSL)
 #define instruction_pointer(regs)	((regs)->pc)
@@ -100,9 +99,7 @@ extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
 
-#endif  /*  !__ASSEMBLY  */
-
 #define profile_pc(regs) ((regs)->pc)
 
-#endif  /*  __KERNEL__  */
+#endif /* __KERNEL__  */
 #endif /* _ASM_PTRACE_H */
diff --git a/arch/mn10300/include/asm/reset-regs.h b/arch/mn10300/include/asm/reset-regs.h
index 174523d..10c7502 100644
--- a/arch/mn10300/include/asm/reset-regs.h
+++ b/arch/mn10300/include/asm/reset-regs.h
@@ -50,7 +50,7 @@ static inline void mn10300_proc_hard_reset(void)
 	RSTCTR |= RSTCTR_CHIPRST;
 }
 
-extern unsigned int watchdog_alert_counter;
+extern unsigned int watchdog_alert_counter[];
 
 extern void watchdog_go(void);
 extern asmlinkage void watchdog_handler(void);
diff --git a/arch/mn10300/include/asm/rtc.h b/arch/mn10300/include/asm/rtc.h
index c295194..6c14bb1 100644
--- a/arch/mn10300/include/asm/rtc.h
+++ b/arch/mn10300/include/asm/rtc.h
@@ -15,25 +15,14 @@
 
 #include <linux/init.h>
 
-extern void check_rtc_time(void);
 extern void __init calibrate_clock(void);
-extern unsigned long __init get_initial_rtc_time(void);
 
 #else /* !CONFIG_MN10300_RTC */
 
-static inline void check_rtc_time(void)
-{
-}
-
 static inline void calibrate_clock(void)
 {
 }
 
-static inline unsigned long get_initial_rtc_time(void)
-{
-	return 0;
-}
-
 #endif /* !CONFIG_MN10300_RTC */
 
 #include <asm-generic/rtc.h>
diff --git a/arch/mn10300/include/asm/rwlock.h b/arch/mn10300/include/asm/rwlock.h
new file mode 100644
index 0000000..6d594d4
--- /dev/null
+++ b/arch/mn10300/include/asm/rwlock.h
@@ -0,0 +1,125 @@
+/*
+ * Helpers used by both rw spinlocks and rw semaphores.
+ *
+ * Based in part on code from semaphore.h and
+ * spinlock.h Copyright 1996 Linus Torvalds.
+ *
+ * Copyright 1999 Red Hat, Inc.
+ *
+ * Written by Benjamin LaHaise.
+ *
+ * Modified by Matsushita Electric Industrial Co., Ltd.
+ * Modifications:
+ * 13-Nov-2006 MEI Temporarily delete lock functions for SMP support.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+#ifndef _ASM_RWLOCK_H
+#define _ASM_RWLOCK_H
+
+#define RW_LOCK_BIAS		 0x01000000
+
+#ifndef CONFIG_SMP
+
+typedef struct { unsigned long a[100]; } __dummy_lock_t;
+#define __dummy_lock(lock) (*(__dummy_lock_t *)(lock))
+
+#define RW_LOCK_BIAS_STR	"0x01000000"
+
+#define __build_read_lock_ptr(rw, helper)				\
+	do {								\
+		asm volatile(						\
+			"	mov	(%0),d3			\n"	\
+			"	sub	1,d3			\n"	\
+			"	mov	d3,(%0)			\n"	\
+			"	blt	1f			\n"	\
+			"	bra	2f			\n"	\
+			"1:	jmp	3f			\n"	\
+			"2:					\n"	\
+			"	.section .text.lock,\"ax\"	\n"	\
+			"3:	call	"helper"[],0		\n"	\
+			"	jmp	2b			\n"	\
+			"	.previous"				\
+			:						\
+			: "d" (rw)					\
+			: "memory", "d3", "cc");			\
+	} while (0)
+
+#define __build_read_lock_const(rw, helper)				\
+	do {								\
+		asm volatile(						\
+			"	mov	(%0),d3			\n"	\
+			"	sub	1,d3			\n"	\
+			"	mov	d3,(%0)			\n"	\
+			"	blt	1f			\n"	\
+			"	bra	2f			\n"	\
+			"1:	jmp	3f			\n"	\
+			"2:					\n"	\
+			"	.section .text.lock,\"ax\"	\n"	\
+			"3:	call	"helper"[],0		\n"	\
+			"	jmp	2b			\n"	\
+			"	.previous"				\
+			:						\
+			: "d" (rw)					\
+			: "memory", "d3", "cc");			\
+	} while (0)
+
+#define __build_read_lock(rw, helper) \
+	do {								\
+		if (__builtin_constant_p(rw))				\
+			__build_read_lock_const(rw, helper);		\
+		else							\
+			__build_read_lock_ptr(rw, helper);		\
+	} while (0)
+
+#define __build_write_lock_ptr(rw, helper)				\
+	do {								\
+		asm volatile(						\
+			"	mov	(%0),d3			\n"	\
+			"	sub	1,d3			\n"	\
+			"	mov	d3,(%0)			\n"	\
+			"	blt	1f			\n"	\
+			"	bra	2f			\n"	\
+			"1:	jmp	3f			\n"	\
+			"2:					\n"	\
+			"	.section .text.lock,\"ax\"	\n"	\
+			"3:	call	"helper"[],0		\n"	\
+			"	jmp	2b			\n"	\
+			"	.previous"				\
+			:						\
+			: "d" (rw)					\
+			: "memory", "d3", "cc");			\
+	} while (0)
+
+#define __build_write_lock_const(rw, helper)				\
+	do {								\
+		asm volatile(						\
+			"	mov	(%0),d3			\n"	\
+			"	sub	1,d3			\n"	\
+			"	mov	d3,(%0)			\n"	\
+			"	blt	1f			\n"	\
+			"	bra	2f			\n"	\
+			"1:	jmp	3f			\n"	\
+			"2:					\n"	\
+			"	.section .text.lock,\"ax\"	\n"	\
+			"3:	call	"helper"[],0		\n"	\
+			"	jmp	2b			\n"	\
+			"	.previous"				\
+			:						\
+			: "d" (rw)					\
+			: "memory", "d3", "cc");			\
+	} while (0)
+
+#define __build_write_lock(rw, helper)					\
+	do {								\
+		if (__builtin_constant_p(rw))				\
+			__build_write_lock_const(rw, helper);		\
+		else							\
+			__build_write_lock_ptr(rw, helper);		\
+	} while (0)
+
+#endif /* CONFIG_SMP */
+#endif /* _ASM_RWLOCK_H */
diff --git a/arch/mn10300/include/asm/serial-regs.h b/arch/mn10300/include/asm/serial-regs.h
index 6498469..8320cda 100644
--- a/arch/mn10300/include/asm/serial-regs.h
+++ b/arch/mn10300/include/asm/serial-regs.h
@@ -20,18 +20,25 @@
 /* serial port 0 */
 #define	SC0CTR			__SYSREG(0xd4002000, u16)	/* control reg */
 #define	SC01CTR_CK		0x0007	/* clock source select */
-#define	SC0CTR_CK_TM8UFLOW_8	0x0000	/* - 1/8 timer 8 underflow (serial port 0 only) */
-#define	SC1CTR_CK_TM9UFLOW_8	0x0000	/* - 1/8 timer 9 underflow (serial port 1 only) */
 #define	SC01CTR_CK_IOCLK_8	0x0001	/* - 1/8 IOCLK */
 #define	SC01CTR_CK_IOCLK_32	0x0002	/* - 1/32 IOCLK */
+#define	SC01CTR_CK_EXTERN_8	0x0006	/* - 1/8 external closk */
+#define	SC01CTR_CK_EXTERN	0x0007	/* - external closk */
+#if defined(CONFIG_AM33_2) || defined(CONFIG_AM33_3)
+#define	SC0CTR_CK_TM8UFLOW_8	0x0000	/* - 1/8 timer 8 underflow (serial port 0 only) */
 #define	SC0CTR_CK_TM2UFLOW_2	0x0003	/* - 1/2 timer 2 underflow (serial port 0 only) */
-#define	SC1CTR_CK_TM3UFLOW_2	0x0003	/* - 1/2 timer 3 underflow (serial port 1 only) */
-#define	SC0CTR_CK_TM0UFLOW_8	0x0004	/* - 1/8 timer 1 underflow (serial port 0 only) */
-#define	SC1CTR_CK_TM1UFLOW_8	0x0004	/* - 1/8 timer 2 underflow (serial port 1 only) */
+#define	SC0CTR_CK_TM0UFLOW_8	0x0004	/* - 1/8 timer 0 underflow (serial port 0 only) */
 #define	SC0CTR_CK_TM2UFLOW_8	0x0005	/* - 1/8 timer 2 underflow (serial port 0 only) */
+#define	SC1CTR_CK_TM9UFLOW_8	0x0000	/* - 1/8 timer 9 underflow (serial port 1 only) */
+#define	SC1CTR_CK_TM3UFLOW_2	0x0003	/* - 1/2 timer 3 underflow (serial port 1 only) */
+#define	SC1CTR_CK_TM1UFLOW_8	0x0004	/* - 1/8 timer 1 underflow (serial port 1 only) */
 #define	SC1CTR_CK_TM3UFLOW_8	0x0005	/* - 1/8 timer 3 underflow (serial port 1 only) */
-#define	SC01CTR_CK_EXTERN_8	0x0006	/* - 1/8 external closk */
-#define	SC01CTR_CK_EXTERN	0x0007	/* - external closk */
+#else  /* CONFIG_AM33_2 || CONFIG_AM33_3 */
+#define	SC0CTR_CK_TM8UFLOW_8	0x0000	/* - 1/8 timer 8 underflow (serial port 0 only) */
+#define	SC0CTR_CK_TM0UFLOW_8	0x0004	/* - 1/8 timer 0 underflow (serial port 0 only) */
+#define	SC0CTR_CK_TM2UFLOW_8	0x0005	/* - 1/8 timer 2 underflow (serial port 0 only) */
+#define	SC1CTR_CK_TM12UFLOW_8	0x0000	/* - 1/8 timer 12 underflow (serial port 1 only) */
+#endif /* CONFIG_AM33_2 || CONFIG_AM33_3 */
 #define	SC01CTR_STB		0x0008	/* stop bit select */
 #define	SC01CTR_STB_1BIT	0x0000	/* - 1 stop bit */
 #define	SC01CTR_STB_2BIT	0x0008	/* - 2 stop bits */
@@ -100,11 +107,23 @@
 
 /* serial port 2 */
 #define	SC2CTR			__SYSREG(0xd4002020, u16)	/* control reg */
+#ifdef CONFIG_AM33_2
 #define	SC2CTR_CK		0x0003	/* clock source select */
 #define	SC2CTR_CK_TM10UFLOW	0x0000	/* - timer 10 underflow */
 #define	SC2CTR_CK_TM2UFLOW	0x0001	/* - timer 2 underflow */
 #define	SC2CTR_CK_EXTERN	0x0002	/* - external closk */
 #define	SC2CTR_CK_TM3UFLOW	0x0003	/* - timer 3 underflow */
+#else  /* CONFIG_AM33_2 */
+#define	SC2CTR_CK		0x0007	/* clock source select */
+#define	SC2CTR_CK_TM9UFLOW_8	0x0000	/* - 1/8 timer 9 underflow */
+#define	SC2CTR_CK_IOCLK_8	0x0001	/* - 1/8 IOCLK */
+#define	SC2CTR_CK_IOCLK_32	0x0002	/* - 1/32 IOCLK */
+#define	SC2CTR_CK_TM3UFLOW_2	0x0003	/* - 1/2 timer 3 underflow */
+#define	SC2CTR_CK_TM1UFLOW_8	0x0004	/* - 1/8 timer 1 underflow */
+#define	SC2CTR_CK_TM3UFLOW_8	0x0005	/* - 1/8 timer 3 underflow */
+#define	SC2CTR_CK_EXTERN_8	0x0006	/* - 1/8 external closk */
+#define	SC2CTR_CK_EXTERN	0x0007	/* - external closk */
+#endif /* CONFIG_AM33_2 */
 #define	SC2CTR_STB		0x0008	/* stop bit select */
 #define	SC2CTR_STB_1BIT		0x0000	/* - 1 stop bit */
 #define	SC2CTR_STB_2BIT		0x0008	/* - 2 stop bits */
@@ -134,9 +153,14 @@
 #define SC2ICR_RES		0x04	/* receive error select */
 #define SC2ICR_RI		0x01	/* receive interrupt cause */
 
-#define	SC2TXB			__SYSREG(0xd4002018, u8)	/* transmit buffer reg */
-#define	SC2RXB			__SYSREG(0xd4002019, u8)	/* receive buffer reg */
-#define	SC2STR			__SYSREG(0xd400201c, u8)	/* status reg */
+#define	SC2TXB			__SYSREG(0xd4002028, u8)	/* transmit buffer reg */
+#define	SC2RXB			__SYSREG(0xd4002029, u8)	/* receive buffer reg */
+
+#ifdef CONFIG_AM33_2
+#define	SC2STR			__SYSREG(0xd400202c, u8)	/* status reg */
+#else  /* CONFIG_AM33_2 */
+#define	SC2STR			__SYSREG(0xd400202c, u16)	/* status reg */
+#endif /* CONFIG_AM33_2 */
 #define SC2STR_OEF		0x0001	/* overrun error found */
 #define SC2STR_PEF		0x0002	/* parity error found */
 #define SC2STR_FEF		0x0004	/* framing error found */
@@ -146,10 +170,17 @@
 #define SC2STR_RXF		0x0040	/* receive status */
 #define SC2STR_TXF		0x0080	/* transmit status */
 
+#ifdef CONFIG_AM33_2
 #define	SC2TIM			__SYSREG(0xd400202d, u8)	/* status reg */
+#endif
 
+#ifdef CONFIG_AM33_2
 #define SC2RXIRQ		24	/* serial 2 Receive IRQ */
 #define SC2TXIRQ		25	/* serial 2 Transmit IRQ */
+#else  /* CONFIG_AM33_2 */
+#define SC2RXIRQ		68	/* serial 2 Receive IRQ */
+#define SC2TXIRQ		69	/* serial 2 Transmit IRQ */
+#endif /* CONFIG_AM33_2 */
 
 #define	SC2RXICR		GxICR(SC2RXIRQ)	/* serial 2 receive intr ctrl reg */
 #define	SC2TXICR		GxICR(SC2TXIRQ)	/* serial 2 transmit intr ctrl reg */
diff --git a/arch/mn10300/include/asm/serial.h b/arch/mn10300/include/asm/serial.h
index a29445c..23a7992 100644
--- a/arch/mn10300/include/asm/serial.h
+++ b/arch/mn10300/include/asm/serial.h
@@ -9,10 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
-/*
- * The ASB2305 has an 18.432 MHz clock the UART
- */
-#define BASE_BAUD	(18432000 / 16)
+#ifndef _ASM_SERIAL_H
+#define _ASM_SERIAL_H
 
 /* Standard COM flags (except for COM4, because of the 8514 problem) */
 #ifdef CONFIG_SERIAL_DETECT_IRQ
@@ -34,3 +32,5 @@
 #endif
 
 #include <unit/serial.h>
+
+#endif /* _ASM_SERIAL_H */
diff --git a/arch/mn10300/include/asm/smp.h b/arch/mn10300/include/asm/smp.h
index 4eb8c61..b8585b4 100644
--- a/arch/mn10300/include/asm/smp.h
+++ b/arch/mn10300/include/asm/smp.h
@@ -3,6 +3,16 @@
  * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  *
+ * Modified by Matsushita Electric Industrial Co., Ltd.
+ * Modifications:
+ *  13-Nov-2006 MEI Define IPI-IRQ number and add inline/macro function
+ *                  for SMP support.
+ *  22-Jan-2007 MEI Add the define related to SMP_BOOT_IRQ.
+ *  23-Feb-2007 MEI Add the define related to SMP icahce invalidate.
+ *  23-Jun-2008 MEI Delete INTC_IPI.
+ *  22-Jul-2008 MEI Add smp_nmi_call_function and related defines.
+ *  04-Aug-2008 MEI Delete USE_DOIRQ_CACHE_IPI.
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public Licence
  * as published by the Free Software Foundation; either version
@@ -11,8 +21,98 @@
 #ifndef _ASM_SMP_H
 #define _ASM_SMP_H
 
+#ifndef __ASSEMBLY__
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#endif
+
 #ifdef CONFIG_SMP
-#error SMP not yet supported for MN10300
+#include <proc/smp-regs.h>
+
+#define RESCHEDULE_IPI		63
+#define CALL_FUNC_SINGLE_IPI	192
+#define LOCAL_TIMER_IPI		193
+#define FLUSH_CACHE_IPI		194
+#define CALL_FUNCTION_NMI_IPI	195
+#define GDB_NMI_IPI		196
+
+#define SMP_BOOT_IRQ		195
+
+#define RESCHEDULE_GxICR_LV	GxICR_LEVEL_6
+#define CALL_FUNCTION_GxICR_LV	GxICR_LEVEL_4
+#define LOCAL_TIMER_GxICR_LV	GxICR_LEVEL_4
+#define FLUSH_CACHE_GxICR_LV	GxICR_LEVEL_0
+#define SMP_BOOT_GxICR_LV	GxICR_LEVEL_0
+
+#define TIME_OUT_COUNT_BOOT_IPI	100
+#define DELAY_TIME_BOOT_IPI	75000
+
+
+#ifndef __ASSEMBLY__
+
+/**
+ * raw_smp_processor_id - Determine the raw CPU ID of the CPU running it
+ *
+ * What we really want to do is to use the CPUID hardware CPU register to get
+ * this information, but accesses to that aren't cached, and run at system bus
+ * speed, not CPU speed.  A copy of this value is, however, stored in the
+ * thread_info struct, and that can be cached.
+ *
+ * An alternate way of dealing with this could be to use the EPSW.S bits to
+ * cache this information for systems with up to four CPUs.
+ */
+#if 0
+#define raw_smp_processor_id()	(CPUID)
+#else
+#define raw_smp_processor_id()	(current_thread_info()->cpu)
 #endif
 
+static inline int cpu_logical_map(int cpu)
+{
+	return cpu;
+}
+
+static inline int cpu_number_map(int cpu)
+{
+	return cpu;
+}
+
+
+extern cpumask_t cpu_boot_map;
+
+extern void smp_init_cpus(void);
+extern void smp_cache_interrupt(void);
+extern void send_IPI_allbutself(int irq);
+extern int smp_nmi_call_function(smp_call_func_t func, void *info, int wait);
+
+extern void arch_send_call_function_single_ipi(int cpu);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+
+#ifdef CONFIG_HOTPLUG_CPU
+extern int __cpu_disable(void);
+extern void __cpu_die(unsigned int cpu);
+#endif /* CONFIG_HOTPLUG_CPU */
+
+#ifdef CONFIG_PREEMPT /* FIXME */
+#define __frame					\
+	({					\
+		struct pt_regs *f;		\
+		preempt_disable();		\
+		f = ___frame[CPUID];		\
+		preempt_enable();		\
+		f;				\
+	})
+#else
+#define __frame ___frame[CPUID]
 #endif
+
+#endif /* __ASSEMBLY__ */
+#else /* CONFIG_SMP */
+#ifndef __ASSEMBLY__
+
+static inline void smp_init_cpus(void) {}
+
+#endif /* __ASSEMBLY__ */
+#endif /* CONFIG_SMP */
+
+#endif /* _ASM_SMP_H */
diff --git a/arch/mn10300/include/asm/spinlock.h b/arch/mn10300/include/asm/spinlock.h
index 4bf9c8b..9342915 100644
--- a/arch/mn10300/include/asm/spinlock.h
+++ b/arch/mn10300/include/asm/spinlock.h
@@ -11,6 +11,183 @@
 #ifndef _ASM_SPINLOCK_H
 #define _ASM_SPINLOCK_H
 
-#error SMP spinlocks not implemented for MN10300
+#include <asm/atomic.h>
+#include <asm/rwlock.h>
+#include <asm/page.h>
 
+/*
+ * Simple spin lock operations.  There are two variants, one clears IRQ's
+ * on the local processor, one does not.
+ *
+ * We make no fairness assumptions. They have a cost.
+ */
+
+#define arch_spin_is_locked(x)	(*(volatile signed char *)(&(x)->slock) != 0)
+#define arch_spin_unlock_wait(x) do { barrier(); } while (arch_spin_is_locked(x))
+
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	asm volatile(
+		"	bclr	1,(0,%0)	\n"
+		:
+		: "a"(&lock->slock)
+		: "memory", "cc");
+}
+
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
+{
+	int ret;
+
+	asm volatile(
+		"	mov	1,%0		\n"
+		"	bset	%0,(%1)		\n"
+		"	bne	1f		\n"
+		"	clr	%0		\n"
+		"1:	xor	1,%0		\n"
+		: "=d"(ret)
+		: "a"(&lock->slock)
+		: "memory", "cc");
+
+	return ret;
+}
+
+static inline void arch_spin_lock(arch_spinlock_t *lock)
+{
+	asm volatile(
+		"1:	bset	1,(0,%0)	\n"
+		"	bne	1b		\n"
+		:
+		: "a"(&lock->slock)
+		: "memory", "cc");
+}
+
+static inline void arch_spin_lock_flags(arch_spinlock_t *lock,
+					 unsigned long flags)
+{
+	int temp;
+
+	asm volatile(
+		"1:	bset	1,(0,%2)	\n"
+		"	beq	3f		\n"
+		"	mov	%1,epsw		\n"
+		"2:	mov	(0,%2),%0	\n"
+		"	or	%0,%0		\n"
+		"	bne	2b		\n"
+		"	mov	%3,%0		\n"
+		"	mov	%0,epsw		\n"
+		"	nop			\n"
+		"	nop			\n"
+		"	bra	1b\n"
+		"3:				\n"
+		: "=&d" (temp)
+		: "d" (flags), "a"(&lock->slock), "i"(EPSW_IE | MN10300_CLI_LEVEL)
+		: "memory", "cc");
+}
+
+#ifdef __KERNEL__
+
+/*
+ * Read-write spinlocks, allowing multiple readers
+ * but only one writer.
+ *
+ * NOTE! it is quite common to have readers in interrupts
+ * but no interrupt writers. For those circumstances we
+ * can "mix" irq-safe locks - any writer needs to get a
+ * irq-safe write-lock, but readers can get non-irqsafe
+ * read-locks.
+ */
+
+/**
+ * read_can_lock - would read_trylock() succeed?
+ * @lock: the rwlock in question.
+ */
+#define arch_read_can_lock(x) ((int)(x)->lock > 0)
+
+/**
+ * write_can_lock - would write_trylock() succeed?
+ * @lock: the rwlock in question.
+ */
+#define arch_write_can_lock(x) ((x)->lock == RW_LOCK_BIAS)
+
+/*
+ * On mn10300, we implement read-write locks as a 32-bit counter
+ * with the high bit (sign) being the "contended" bit.
+ */
+static inline void arch_read_lock(arch_rwlock_t *rw)
+{
+#if 0 //def CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+	__build_read_lock(rw, "__read_lock_failed");
+#else
+	{
+		atomic_t *count = (atomic_t *)rw;
+		while (atomic_dec_return(count) < 0)
+			atomic_inc(count);
+	}
+#endif
+}
+
+static inline void arch_write_lock(arch_rwlock_t *rw)
+{
+#if 0 //def CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+	__build_write_lock(rw, "__write_lock_failed");
+#else
+	{
+		atomic_t *count = (atomic_t *)rw;
+		while (!atomic_sub_and_test(RW_LOCK_BIAS, count))
+			atomic_add(RW_LOCK_BIAS, count);
+	}
+#endif
+}
+
+static inline void arch_read_unlock(arch_rwlock_t *rw)
+{
+#if 0 //def CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+	__build_read_unlock(rw);
+#else
+	{
+		atomic_t *count = (atomic_t *)rw;
+		atomic_inc(count);
+	}
+#endif
+}
+
+static inline void arch_write_unlock(arch_rwlock_t *rw)
+{
+#if 0 //def CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+	__build_write_unlock(rw);
+#else
+	{
+		atomic_t *count = (atomic_t *)rw;
+		atomic_add(RW_LOCK_BIAS, count);
+	}
+#endif
+}
+
+static inline int arch_read_trylock(arch_rwlock_t *lock)
+{
+	atomic_t *count = (atomic_t *)lock;
+	atomic_dec(count);
+	if (atomic_read(count) >= 0)
+		return 1;
+	atomic_inc(count);
+	return 0;
+}
+
+static inline int arch_write_trylock(arch_rwlock_t *lock)
+{
+	atomic_t *count = (atomic_t *)lock;
+	if (atomic_sub_and_test(RW_LOCK_BIAS, count))
+		return 1;
+	atomic_add(RW_LOCK_BIAS, count);
+	return 0;
+}
+
+#define arch_read_lock_flags(lock, flags)  arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
+
+#define _raw_spin_relax(lock)	cpu_relax()
+#define _raw_read_relax(lock)	cpu_relax()
+#define _raw_write_relax(lock)	cpu_relax()
+
+#endif /* __KERNEL__ */
 #endif /* _ASM_SPINLOCK_H */
diff --git a/arch/mn10300/include/asm/spinlock_types.h b/arch/mn10300/include/asm/spinlock_types.h
new file mode 100644
index 0000000..653dc51
--- /dev/null
+++ b/arch/mn10300/include/asm/spinlock_types.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_SPINLOCK_TYPES_H
+#define _ASM_SPINLOCK_TYPES_H
+
+#ifndef __LINUX_SPINLOCK_TYPES_H
+# error "please don't include this file directly"
+#endif
+
+typedef struct arch_spinlock {
+	unsigned int slock;
+} arch_spinlock_t;
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+
+typedef struct {
+	unsigned int lock;
+} arch_rwlock_t;
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+
+#endif /* _ASM_SPINLOCK_TYPES_H */
diff --git a/arch/mn10300/include/asm/system.h b/arch/mn10300/include/asm/system.h
index 7de90bc..8ff3e5a 100644
--- a/arch/mn10300/include/asm/system.h
+++ b/arch/mn10300/include/asm/system.h
@@ -12,6 +12,7 @@
 #define _ASM_SYSTEM_H
 
 #include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
@@ -57,8 +58,6 @@ do {									\
 
 #define nop() asm volatile ("nop")
 
-#endif /* !__ASSEMBLY__ */
-
 /*
  * Force strict CPU ordering.
  * And yes, this is required on UP too when we're talking
@@ -85,17 +84,19 @@ do {									\
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
 #define smp_wmb()	wmb()
-#else
+#define set_mb(var, value)  do { xchg(&var, value); } while (0)
+#else  /* CONFIG_SMP */
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
 #define smp_wmb()	barrier()
-#endif
-
 #define set_mb(var, value)  do { var = value;  mb(); } while (0)
+#endif /* CONFIG_SMP */
+
 #define set_wmb(var, value) do { var = value; wmb(); } while (0)
 
 #define read_barrier_depends()		do {} while (0)
 #define smp_read_barrier_depends()	do {} while (0)
 
+#endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_SYSTEM_H */
diff --git a/arch/mn10300/include/asm/timer-regs.h b/arch/mn10300/include/asm/timer-regs.h
index 1d883b7..c634977 100644
--- a/arch/mn10300/include/asm/timer-regs.h
+++ b/arch/mn10300/include/asm/timer-regs.h
@@ -17,21 +17,27 @@
 
 #ifdef __KERNEL__
 
-/* timer prescalar control */
+/*
+ * Timer prescalar control
+ */
 #define	TMPSCNT			__SYSREG(0xd4003071, u8) /* timer prescaler control */
 #define	TMPSCNT_ENABLE		0x80	/* timer prescaler enable */
 #define	TMPSCNT_DISABLE		0x00	/* timer prescaler disable */
 
-/* 8 bit timers */
+/*
+ * 8-bit timers
+ */
 #define	TM0MD			__SYSREG(0xd4003000, u8) /* timer 0 mode register */
 #define	TM0MD_SRC		0x07	/* timer source */
 #define	TM0MD_SRC_IOCLK		0x00	/* - IOCLK */
 #define	TM0MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
 #define	TM0MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
-#define	TM0MD_SRC_TM2IO		0x03	/* - TM2IO pin input */
 #define	TM0MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM0MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if	defined(CONFIG_AM33_2)
+#define	TM0MD_SRC_TM2IO		0x03	/* - TM2IO pin input */
 #define	TM0MD_SRC_TM0IO		0x07	/* - TM0IO pin input */
+#endif /* CONFIG_AM33_2 */
 #define	TM0MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM0MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -43,7 +49,9 @@
 #define	TM1MD_SRC_TM0CASCADE	0x03	/* - cascade with timer 0 */
 #define	TM1MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM1MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM1MD_SRC_TM1IO		0x07	/* - TM1IO pin input */
+#endif	/* CONFIG_AM33_2 */
 #define	TM1MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM1MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -55,7 +63,9 @@
 #define	TM2MD_SRC_TM1CASCADE	0x03	/* - cascade with timer 1 */
 #define	TM2MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM2MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM2MD_SRC_TM2IO		0x07	/* - TM2IO pin input */
+#endif	/* CONFIG_AM33_2 */
 #define	TM2MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM2MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -64,11 +74,13 @@
 #define	TM3MD_SRC_IOCLK		0x00	/* - IOCLK */
 #define	TM3MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
 #define	TM3MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
-#define	TM3MD_SRC_TM1CASCADE	0x03	/* - cascade with timer 2 */
+#define	TM3MD_SRC_TM2CASCADE	0x03	/* - cascade with timer 2 */
 #define	TM3MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM3MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM3MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM3MD_SRC_TM3IO		0x07	/* - TM3IO pin input */
+#endif	/* CONFIG_AM33_2 */
 #define	TM3MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM3MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -96,7 +108,9 @@
 #define	TM2ICR			GxICR(TM2IRQ)	/* timer 2 uflow intr ctrl reg */
 #define	TM3ICR			GxICR(TM3IRQ)	/* timer 3 uflow intr ctrl reg */
 
-/* 16-bit timers 4,5 & 7-11 */
+/*
+ * 16-bit timers 4,5 & 7-15
+ */
 #define	TM4MD			__SYSREG(0xd4003080, u8)   /* timer 4 mode register */
 #define	TM4MD_SRC		0x07	/* timer source */
 #define	TM4MD_SRC_IOCLK		0x00	/* - IOCLK */
@@ -105,7 +119,9 @@
 #define	TM4MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM4MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM4MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM4MD_SRC_TM4IO		0x07	/* - TM4IO pin input */
+#endif	/* CONFIG_AM33_2 */
 #define	TM4MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM4MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -118,7 +134,11 @@
 #define	TM5MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM5MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM5MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM5MD_SRC_TM5IO		0x07	/* - TM5IO pin input */
+#else	/* !CONFIG_AM33_2 */
+#define	TM5MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#endif	/* CONFIG_AM33_2 */
 #define	TM5MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM5MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -130,7 +150,9 @@
 #define	TM7MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM7MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM7MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM7MD_SRC_TM7IO		0x07	/* - TM7IO pin input */
+#endif	/* CONFIG_AM33_2 */
 #define	TM7MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM7MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -143,7 +165,11 @@
 #define	TM8MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM8MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM8MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM8MD_SRC_TM8IO		0x07	/* - TM8IO pin input */
+#else	/* !CONFIG_AM33_2 */
+#define	TM8MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#endif	/* CONFIG_AM33_2 */
 #define	TM8MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM8MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -156,7 +182,11 @@
 #define	TM9MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM9MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM9MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM9MD_SRC_TM9IO		0x07	/* - TM9IO pin input */
+#else	/* !CONFIG_AM33_2 */
+#define	TM9MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#endif	/* CONFIG_AM33_2 */
 #define	TM9MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM9MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -169,7 +199,11 @@
 #define	TM10MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM10MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM10MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM10MD_SRC_TM10IO	0x07	/* - TM10IO pin input */
+#else	/* !CONFIG_AM33_2 */
+#define	TM10MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#endif	/* CONFIG_AM33_2 */
 #define	TM10MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM10MD_COUNT_ENABLE	0x80	/* timer count enable */
 
@@ -178,32 +212,101 @@
 #define	TM11MD_SRC_IOCLK	0x00	/* - IOCLK */
 #define	TM11MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
 #define	TM11MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
-#define	TM11MD_SRC_TM7CASCADE	0x03	/* - cascade with timer 7 */
 #define	TM11MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
 #define	TM11MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
 #define	TM11MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
 #define	TM11MD_SRC_TM11IO	0x07	/* - TM11IO pin input */
+#else	/* !CONFIG_AM33_2 */
+#define	TM11MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#endif	/* CONFIG_AM33_2 */
 #define	TM11MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
 #define	TM11MD_COUNT_ENABLE	0x80	/* timer count enable */
 
+#if defined(CONFIG_AM34_2)
+#define	TM12MD			__SYSREG(0xd4003180, u8)   /* timer 11 mode register */
+#define	TM12MD_SRC		0x07	/* timer source */
+#define	TM12MD_SRC_IOCLK	0x00	/* - IOCLK */
+#define	TM12MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM12MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM12MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM12MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM12MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM12MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#define	TM12MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM12MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM13MD			__SYSREG(0xd4003182, u8)   /* timer 11 mode register */
+#define	TM13MD_SRC		0x07	/* timer source */
+#define	TM13MD_SRC_IOCLK	0x00	/* - IOCLK */
+#define	TM13MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM13MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM13MD_SRC_TM12CASCADE	0x03	/* - cascade with timer 12 */
+#define	TM13MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM13MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM13MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM13MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#define	TM13MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM13MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM14MD			__SYSREG(0xd4003184, u8)   /* timer 11 mode register */
+#define	TM14MD_SRC		0x07	/* timer source */
+#define	TM14MD_SRC_IOCLK	0x00	/* - IOCLK */
+#define	TM14MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM14MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM14MD_SRC_TM13CASCADE	0x03	/* - cascade with timer 13 */
+#define	TM14MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM14MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM14MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM14MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#define	TM14MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM14MD_COUNT_ENABLE	0x80	/* timer count enable */
+
+#define	TM15MD			__SYSREG(0xd4003186, u8)   /* timer 11 mode register */
+#define	TM15MD_SRC		0x07	/* timer source */
+#define	TM15MD_SRC_IOCLK	0x00	/* - IOCLK */
+#define	TM15MD_SRC_IOCLK_8	0x01	/* - 1/8 IOCLK */
+#define	TM15MD_SRC_IOCLK_32	0x02	/* - 1/32 IOCLK */
+#define	TM15MD_SRC_TM0UFLOW	0x04	/* - timer 0 underflow */
+#define	TM15MD_SRC_TM1UFLOW	0x05	/* - timer 1 underflow */
+#define	TM15MD_SRC_TM2UFLOW	0x06	/* - timer 2 underflow */
+#define	TM15MD_SRC_TM7UFLOW	0x07	/* - timer 7 underflow */
+#define	TM15MD_INIT_COUNTER	0x40	/* initialize TMnBC = TMnBR */
+#define	TM15MD_COUNT_ENABLE	0x80	/* timer count enable */
+#endif	/* CONFIG_AM34_2 */
+
+
 #define	TM4BR			__SYSREG(0xd4003090, u16)  /* timer 4 base register */
 #define	TM5BR			__SYSREG(0xd4003092, u16)  /* timer 5 base register */
+#define	TM45BR			__SYSREG(0xd4003090, u32)  /* timer 4:5 base register */
 #define	TM7BR			__SYSREG(0xd4003096, u16)  /* timer 7 base register */
 #define	TM8BR			__SYSREG(0xd4003098, u16)  /* timer 8 base register */
 #define	TM9BR			__SYSREG(0xd400309a, u16)  /* timer 9 base register */
+#define	TM89BR			__SYSREG(0xd4003098, u32)  /* timer 8:9 base register */
 #define	TM10BR			__SYSREG(0xd400309c, u16)  /* timer 10 base register */
 #define	TM11BR			__SYSREG(0xd400309e, u16)  /* timer 11 base register */
-#define	TM45BR			__SYSREG(0xd4003090, u32)  /* timer 4:5 base register */
+#if defined(CONFIG_AM34_2)
+#define	TM12BR			__SYSREG(0xd4003190, u16)  /* timer 12 base register */
+#define	TM13BR			__SYSREG(0xd4003192, u16)  /* timer 13 base register */
+#define	TM14BR			__SYSREG(0xd4003194, u16)  /* timer 14 base register */
+#define	TM15BR			__SYSREG(0xd4003196, u16)  /* timer 15 base register */
+#endif	/* CONFIG_AM34_2 */
 
 #define	TM4BC			__SYSREG(0xd40030a0, u16)  /* timer 4 binary counter */
 #define	TM5BC			__SYSREG(0xd40030a2, u16)  /* timer 5 binary counter */
 #define	TM45BC			__SYSREG(0xd40030a0, u32)  /* timer 4:5 binary counter */
-
 #define	TM7BC			__SYSREG(0xd40030a6, u16)  /* timer 7 binary counter */
 #define	TM8BC			__SYSREG(0xd40030a8, u16)  /* timer 8 binary counter */
 #define	TM9BC			__SYSREG(0xd40030aa, u16)  /* timer 9 binary counter */
+#define	TM89BC			__SYSREG(0xd40030a8, u32)  /* timer 8:9 binary counter */
 #define	TM10BC			__SYSREG(0xd40030ac, u16)  /* timer 10 binary counter */
 #define	TM11BC			__SYSREG(0xd40030ae, u16)  /* timer 11 binary counter */
+#if defined(CONFIG_AM34_2)
+#define	TM12BC			__SYSREG(0xd40031a0, u16)  /* timer 12 binary counter */
+#define	TM13BC			__SYSREG(0xd40031a2, u16)  /* timer 13 binary counter */
+#define	TM14BC			__SYSREG(0xd40031a4, u16)  /* timer 14 binary counter */
+#define	TM15BC			__SYSREG(0xd40031a6, u16)  /* timer 15 binary counter */
+#endif	/* CONFIG_AM34_2 */
 
 #define TM4IRQ			6	/* timer 4 IRQ */
 #define TM5IRQ			7	/* timer 5 IRQ */
@@ -212,6 +315,12 @@
 #define TM9IRQ			13	/* timer 9 IRQ */
 #define TM10IRQ			14	/* timer 10 IRQ */
 #define TM11IRQ			15	/* timer 11 IRQ */
+#if defined(CONFIG_AM34_2)
+#define TM12IRQ			64	/* timer 12 IRQ */
+#define TM13IRQ			65	/* timer 13 IRQ */
+#define TM14IRQ			66	/* timer 14 IRQ */
+#define TM15IRQ			67	/* timer 15 IRQ */
+#endif	/* CONFIG_AM34_2 */
 
 #define	TM4ICR			GxICR(TM4IRQ)	/* timer 4 uflow intr ctrl reg */
 #define	TM5ICR			GxICR(TM5IRQ)	/* timer 5 uflow intr ctrl reg */
@@ -220,8 +329,16 @@
 #define	TM9ICR			GxICR(TM9IRQ)	/* timer 9 uflow intr ctrl reg */
 #define	TM10ICR			GxICR(TM10IRQ)	/* timer 10 uflow intr ctrl reg */
 #define	TM11ICR			GxICR(TM11IRQ)	/* timer 11 uflow intr ctrl reg */
-
-/* 16-bit timer 6 */
+#if defined(CONFIG_AM34_2)
+#define	TM12ICR			GxICR(TM12IRQ)	/* timer 12 uflow intr ctrl reg */
+#define	TM13ICR			GxICR(TM13IRQ)	/* timer 13 uflow intr ctrl reg */
+#define	TM14ICR			GxICR(TM14IRQ)	/* timer 14 uflow intr ctrl reg */
+#define	TM15ICR			GxICR(TM15IRQ)	/* timer 15 uflow intr ctrl reg */
+#endif	/* CONFIG_AM34_2 */
+
+/*
+ * 16-bit timer 6
+ */
 #define	TM6MD			__SYSREG(0xd4003084, u16)  /* timer6 mode register */
 #define	TM6MD_SRC		0x0007	/* timer source */
 #define	TM6MD_SRC_IOCLK		0x0000	/* - IOCLK */
@@ -229,10 +346,14 @@
 #define	TM6MD_SRC_IOCLK_32	0x0002	/* - 1/32 IOCLK */
 #define	TM6MD_SRC_TM0UFLOW	0x0004	/* - timer 0 underflow */
 #define	TM6MD_SRC_TM1UFLOW	0x0005	/* - timer 1 underflow */
-#define	TM6MD_SRC_TM6IOB_BOTH	0x0006	/* - TM6IOB pin input (both edges) */
+#define	TM6MD_SRC_TM2UFLOW	0x0006	/* - timer 2 underflow */
+#if defined(CONFIG_AM33_2)
+/* #define	TM6MD_SRC_TM6IOB_BOTH	0x0006 */	/* - TM6IOB pin input (both edges) */
 #define	TM6MD_SRC_TM6IOB_SINGLE	0x0007	/* - TM6IOB pin input (single edge) */
-#define	TM6MD_CLR_ENABLE	0x0010	/* clear count enable */
+#endif	/* CONFIG_AM33_2 */
 #define	TM6MD_ONESHOT_ENABLE	0x0040	/* oneshot count */
+#define	TM6MD_CLR_ENABLE	0x0010	/* clear count enable */
+#if	defined(CONFIG_AM33_2)
 #define	TM6MD_TRIG_ENABLE	0x0080	/* TM6IOB pin trigger enable */
 #define TM6MD_PWM		0x3800	/* PWM output mode */
 #define TM6MD_PWM_DIS		0x0000	/* - disabled */
@@ -240,10 +361,15 @@
 #define	TM6MD_PWM_11BIT		0x1800	/* - 11 bits mode */
 #define	TM6MD_PWM_12BIT		0x3000	/* - 12 bits mode */
 #define	TM6MD_PWM_14BIT		0x3800	/* - 14 bits mode */
+#endif	/* CONFIG_AM33_2 */
+
 #define	TM6MD_INIT_COUNTER	0x4000	/* initialize TMnBC to zero */
 #define	TM6MD_COUNT_ENABLE	0x8000	/* timer count enable */
 
 #define	TM6MDA			__SYSREG(0xd40030b4, u8)   /* timer6 cmp/cap A mode reg */
+#define	TM6MDA_MODE_CMP_SINGLE	0x00	/* - compare, single buffer mode */
+#define	TM6MDA_MODE_CMP_DOUBLE	0x40	/* - compare, double buffer mode */
+#if	defined(CONFIG_AM33_2)
 #define TM6MDA_OUT		0x07	/* output select */
 #define	TM6MDA_OUT_SETA_RESETB	0x00	/* - set at match A, reset at match B */
 #define	TM6MDA_OUT_SETA_RESETOV	0x01	/* - set at match A, reset at overflow */
@@ -251,30 +377,35 @@
 #define	TM6MDA_OUT_RESETA	0x03	/* - reset at match A */
 #define	TM6MDA_OUT_TOGGLE	0x04	/* - toggle on match A */
 #define TM6MDA_MODE		0xc0	/* compare A register mode */
-#define	TM6MDA_MODE_CMP_SINGLE	0x00	/* - compare, single buffer mode */
-#define	TM6MDA_MODE_CMP_DOUBLE	0x40	/* - compare, double buffer mode */
 #define	TM6MDA_MODE_CAP_S_EDGE	0x80	/* - capture, single edge mode */
 #define	TM6MDA_MODE_CAP_D_EDGE	0xc0	/* - capture, double edge mode */
 #define TM6MDA_EDGE		0x20	/* compare A edge select */
 #define	TM6MDA_EDGE_FALLING	0x00	/* capture on falling edge */
 #define	TM6MDA_EDGE_RISING	0x20	/* capture on rising edge */
 #define	TM6MDA_CAPTURE_ENABLE	0x10	/* capture enable */
+#else	/* !CONFIG_AM33_2 */
+#define	TM6MDA_MODE		0x40	/* compare A register mode */
+#endif	/* CONFIG_AM33_2 */
 
 #define	TM6MDB			__SYSREG(0xd40030b5, u8)   /* timer6 cmp/cap B mode reg */
+#define	TM6MDB_MODE_CMP_SINGLE	0x00	/* - compare, single buffer mode */
+#define	TM6MDB_MODE_CMP_DOUBLE	0x40	/* - compare, double buffer mode */
+#if defined(CONFIG_AM33_2)
 #define TM6MDB_OUT		0x07	/* output select */
 #define	TM6MDB_OUT_SETB_RESETA	0x00	/* - set at match B, reset at match A */
 #define	TM6MDB_OUT_SETB_RESETOV	0x01	/* - set at match B */
 #define	TM6MDB_OUT_RESETB	0x03	/* - reset at match B */
 #define	TM6MDB_OUT_TOGGLE	0x04	/* - toggle on match B */
 #define TM6MDB_MODE		0xc0	/* compare B register mode */
-#define	TM6MDB_MODE_CMP_SINGLE	0x00	/* - compare, single buffer mode */
-#define	TM6MDB_MODE_CMP_DOUBLE	0x40	/* - compare, double buffer mode */
 #define	TM6MDB_MODE_CAP_S_EDGE	0x80	/* - capture, single edge mode */
 #define	TM6MDB_MODE_CAP_D_EDGE	0xc0	/* - capture, double edge mode */
 #define TM6MDB_EDGE		0x20	/* compare B edge select */
 #define	TM6MDB_EDGE_FALLING	0x00	/* capture on falling edge */
 #define	TM6MDB_EDGE_RISING	0x20	/* capture on rising edge */
 #define	TM6MDB_CAPTURE_ENABLE	0x10	/* capture enable */
+#else	/* !CONFIG_AM33_2 */
+#define	TM6MDB_MODE		0x40	/* compare B register mode */
+#endif	/* CONFIG_AM33_2 */
 
 #define	TM6CA			__SYSREG(0xd40030c4, u16)   /* timer6 cmp/capture reg A */
 #define	TM6CB			__SYSREG(0xd40030d4, u16)   /* timer6 cmp/capture reg B */
@@ -288,6 +419,34 @@
 #define	TM6AICR			GxICR(TM6AIRQ)	/* timer 6A intr control reg */
 #define	TM6BICR			GxICR(TM6BIRQ)	/* timer 6B intr control reg */
 
+#if defined(CONFIG_AM34_2)
+/*
+ * MTM: OS Tick-Timer
+ */
+#define	TMTMD			__SYSREG(0xd4004100, u8)	/* Tick Timer mode register */
+#define	TMTMD_TMTLDE		0x40	/* initialize TMTBC = TMTBR */
+#define	TMTMD_TMTCNE		0x80	/* timer count enable       */
+
+#define	TMTBR			__SYSREG(0xd4004110, u32)	/* Tick Timer mode reg */
+#define	TMTBC			__SYSREG(0xd4004120, u32)	/* Tick Timer mode reg */
+
+/*
+ * MTM: OS Timestamp-Timer
+ */
+#define	TMSMD			__SYSREG(0xd4004140, u8)	/* Tick Timer mode register */
+#define	TMSMD_TMSLDE		0x40		/* initialize TMSBC = TMSBR */
+#define	TMSMD_TMSCNE		0x80		/* timer count enable       */
+
+#define	TMSBR			__SYSREG(0xd4004150, u32)	/* Tick Timer mode register */
+#define	TMSBC			__SYSREG(0xd4004160, u32)	/* Tick Timer mode register */
+
+#define TMTIRQ			119		/* OS Tick timer   IRQ */
+#define TMSIRQ			120		/* Timestamp timer IRQ */
+
+#define	TMTICR			GxICR(TMTIRQ)	/* OS Tick timer   uflow intr ctrl reg */
+#define	TMSICR			GxICR(TMSIRQ)	/* Timestamp timer uflow intr ctrl reg */
+#endif	/* CONFIG_AM34_2 */
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_TIMER_REGS_H */
diff --git a/arch/mn10300/include/asm/timex.h b/arch/mn10300/include/asm/timex.h
index 8d031f9..ce5719a 100644
--- a/arch/mn10300/include/asm/timex.h
+++ b/arch/mn10300/include/asm/timex.h
@@ -16,8 +16,7 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-#define CLOCK_TICK_RATE 1193180 /* Underlying HZ - this should probably be set
-				 * to something appropriate, but what? */
+#define CLOCK_TICK_RATE MN10300_JCCLK /* Underlying HZ */
 
 extern cycles_t cacheflush_time;
 
diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
index 197a7af..47e7951 100644
--- a/arch/mn10300/include/asm/uaccess.h
+++ b/arch/mn10300/include/asm/uaccess.h
@@ -377,7 +377,7 @@ unsigned long __generic_copy_to_user_nocheck(void *to, const void *from,
 
 
 #if 0
-#error don't use - these macros don't increment to & from pointers
+#error "don't use - these macros don't increment to & from pointers"
 /* Optimize just a little bit when we know the size of the move. */
 #define __constant_copy_user(to, from, size)	\
 do {						\
diff --git a/arch/mn10300/kernel/Makefile b/arch/mn10300/kernel/Makefile
index 9902235..5b41192 100644
--- a/arch/mn10300/kernel/Makefile
+++ b/arch/mn10300/kernel/Makefile
@@ -10,8 +10,9 @@ obj-y   := process.o signal.o entry.o traps.o irq.o \
 	   ptrace.o setup.o time.o sys_mn10300.o io.o kthread.o \
 	   switch_to.o mn10300_ksyms.o kernel_execve.o $(fpu-obj-y)
 
-obj-$(CONFIG_MN10300_WD_TIMER) += mn10300-watchdog.o mn10300-watchdog-low.o
+obj-$(CONFIG_SMP) += smp.o smp-low.o
 
+obj-$(CONFIG_MN10300_WD_TIMER) += mn10300-watchdog.o mn10300-watchdog-low.o
 
 obj-$(CONFIG_MN10300_TTYSM) += mn10300-serial.o mn10300-serial-low.o \
 			       mn10300-debug.o
diff --git a/arch/mn10300/kernel/asm-offsets.c b/arch/mn10300/kernel/asm-offsets.c
index 78e290e..54cc5b6 100644
--- a/arch/mn10300/kernel/asm-offsets.c
+++ b/arch/mn10300/kernel/asm-offsets.c
@@ -66,7 +66,7 @@ void foo(void)
 	OFFSET(THREAD_SP,		thread_struct, sp);
 	OFFSET(THREAD_A3,		thread_struct, a3);
 	OFFSET(THREAD_USP,		thread_struct, usp);
-	OFFSET(THREAD_FRAME,		thread_struct, __frame);
+	OFFSET(THREAD_FRAME,		thread_struct, frame);
 #ifdef CONFIG_FPU
 	OFFSET(THREAD_FPU_FLAGS,	thread_struct, fpu_flags);
 	OFFSET(THREAD_FPU_STATE,	thread_struct, fpu_state);
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 355f681..f00b9ba 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -28,25 +28,17 @@
 #include <asm/asm-offsets.h>
 #include <asm/frame.inc>
 
+#if defined(CONFIG_SMP) && defined(CONFIG_GDBSTUB)
+#include <asm/gdb-stub.h>
+#endif /* CONFIG_SMP && CONFIG_GDBSTUB */
+
 #ifdef CONFIG_PREEMPT
-#define preempt_stop		__cli
+#define preempt_stop		LOCAL_IRQ_DISABLE
 #else
 #define preempt_stop
 #define resume_kernel		restore_all
 #endif
 
-	.macro __cli
-	and	~EPSW_IM,epsw
-	or	EPSW_IE|MN10300_CLI_LEVEL,epsw
-	nop
-	nop
-	nop
-	.endm
-	.macro __sti
-	or	EPSW_IE|EPSW_IM_7,epsw
-	.endm
-
-
 	.am33_2
 
 ###############################################################################
@@ -88,7 +80,7 @@ syscall_call:
 syscall_exit:
 	# make sure we don't miss an interrupt setting need_resched or
 	# sigpending between sampling and the rti
-	__cli
+	LOCAL_IRQ_DISABLE
 	mov	(TI_flags,a2),d2
 	btst	_TIF_ALLWORK_MASK,d2
 	bne	syscall_exit_work
@@ -105,7 +97,7 @@ restore_all:
 syscall_exit_work:
 	btst	_TIF_SYSCALL_TRACE,d2
 	beq	work_pending
-	__sti				# could let syscall_trace_exit() call
+	LOCAL_IRQ_ENABLE		# could let syscall_trace_exit() call
 					# schedule() instead
 	mov	fp,d0
 	call	syscall_trace_exit[],0	# do_syscall_trace(regs)
@@ -121,7 +113,7 @@ work_resched:
 
 	# make sure we don't miss an interrupt setting need_resched or
 	# sigpending between sampling and the rti
-	__cli
+	LOCAL_IRQ_DISABLE
 
 	# is there any work to be done other than syscall tracing?
 	mov	(TI_flags,a2),d2
@@ -168,7 +160,7 @@ ret_from_intr:
 ENTRY(resume_userspace)
 	# make sure we don't miss an interrupt setting need_resched or
 	# sigpending between sampling and the rti
-	__cli
+	LOCAL_IRQ_DISABLE
 
 	# is there any work to be done on int/exception return?
 	mov	(TI_flags,a2),d2
@@ -178,7 +170,7 @@ ENTRY(resume_userspace)
 
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
-	__cli
+	LOCAL_IRQ_DISABLE
 	mov	(TI_preempt_count,a2),d0	# non-zero preempt_count ?
 	cmp	0,d0
 	bne	restore_all
@@ -281,6 +273,79 @@ ENTRY(nmi_handler)
 	add	-4,sp
 	mov	d0,(sp)
 	mov	(TBR),d0
+
+#ifdef CONFIG_SMP
+	add	-4,sp
+	mov	d0,(sp)			# save d0(TBR)
+	movhu	(NMIAGR),d0
+	and	NMIAGR_GN,d0
+	lsr	0x2,d0
+	cmp	CALL_FUNCTION_NMI_IPI,d0
+	bne	5f			# if not call function, jump
+
+	# function call nmi ipi
+	add	4,sp			# no need to store TBR
+	mov	GxICR_DETECT,d0		# clear NMI request
+	movbu	d0,(GxICR(CALL_FUNCTION_NMI_IPI))
+	movhu	(GxICR(CALL_FUNCTION_NMI_IPI)),d0
+	and	~EPSW_NMID,epsw		# enable NMI
+
+	mov	(sp),d0			# restore d0
+	SAVE_ALL
+	call	smp_nmi_call_function_interrupt[],0
+	RESTORE_ALL
+
+5:
+#ifdef CONFIG_GDBSTUB
+	cmp	GDB_NMI_IPI,d0
+	bne	3f			# if not gdb nmi ipi, jump
+
+	# gdb nmi ipi
+	add	4,sp			# no need to store TBR
+	mov	GxICR_DETECT,d0		# clear NMI
+	movbu	d0,(GxICR(GDB_NMI_IPI))
+	movhu	(GxICR(GDB_NMI_IPI)),d0
+	and	~EPSW_NMID,epsw		# enable NMI
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+	mov	(gdbstub_nmi_opr_type),d0
+	cmp	GDBSTUB_NMI_CACHE_PURGE,d0
+	bne	4f			# if not gdb cache purge, jump
+
+	# gdb cache purge nmi ipi
+	add	-20,sp
+	mov	d1,(4,sp)
+	mov	a0,(8,sp)
+	mov	a1,(12,sp)
+	mov	mdr,d0
+	mov	d0,(16,sp)
+	call	gdbstub_local_purge_cache[],0
+	mov	0x1,d0
+	mov	(CPUID),d1
+	asl	d1,d0
+	mov	gdbstub_nmi_cpumask,a0
+	bclr	d0,(a0)
+	mov	(4,sp),d1
+	mov	(8,sp),a0
+	mov	(12,sp),a1
+	mov	(16,sp),d0
+	mov	d0,mdr
+	add	20,sp
+	mov	(sp),d0
+	add	4,sp
+	rti
+4:
+#endif /* CONFIG_MN10300_CACHE_ENABLED */
+	# gdb wait nmi ipi
+	mov     (sp),d0
+	SAVE_ALL
+	call    gdbstub_nmi_wait[],0
+	RESTORE_ALL
+3:
+#endif /* CONFIG_GDBSTUB */
+	mov     (sp),d0                 # restore TBR to d0
+	add     4,sp
+#endif /* CONFIG_SMP */
+
 	bra	__common_exception_nonmi
 
 ENTRY(__common_exception)
@@ -314,15 +379,21 @@ __common_exception_nonmi:
 	mov	d0,(REG_ORIG_D0,fp)
 
 #ifdef CONFIG_GDBSTUB
+#ifdef CONFIG_SMP
+	call	gdbstub_busy_check[],0
+	and	d0,d0			# check return value
+	beq	2f
+#else  /* CONFIG_SMP */
 	btst	0x01,(gdbstub_busy)
 	beq	2f
+#endif /* CONFIG_SMP */
 	and	~EPSW_IE,epsw
 	mov	fp,d0
 	mov	a2,d1
 	call	gdbstub_exception[],0	# gdbstub itself caused an exception
 	bra	restore_all
 2:
-#endif
+#endif /* CONFIG_GDBSTUB */
 
 	mov	fp,d0			# arg 0: stacked register file
 	mov	a2,d1			# arg 1: exception number
@@ -357,11 +428,7 @@ ENTRY(set_excp_vector)
 	add	exception_table,d0
 	mov	d1,(d0)
 	mov	4,d1
-#if defined(CONFIG_MN10300_CACHE_WBACK)
-	jmp	mn10300_dcache_flush_inv_range2
-#else
 	ret	[],0
-#endif
 
 ###############################################################################
 #
diff --git a/arch/mn10300/kernel/gdb-io-serial-low.S b/arch/mn10300/kernel/gdb-io-serial-low.S
index 4998b24..b1d0152 100644
--- a/arch/mn10300/kernel/gdb-io-serial-low.S
+++ b/arch/mn10300/kernel/gdb-io-serial-low.S
@@ -18,6 +18,7 @@
 #include <asm/thread_info.h>
 #include <asm/frame.inc>
 #include <asm/intctl-regs.h>
+#include <asm/irqflags.h>
 #include <unit/serial.h>
 
 	.text
@@ -69,7 +70,7 @@ gdbstub_io_rx_overflow:
 	bra	gdbstub_io_rx_done
 
 gdbstub_io_rx_enter:
-	or	EPSW_IE|EPSW_IM_1,epsw
+	LOCAL_CHANGE_INTR_MASK_LEVEL(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL+1))
 	add	-4,sp
 	SAVE_ALL
 
@@ -80,7 +81,7 @@ gdbstub_io_rx_enter:
 	mov	fp,d0
 	call	gdbstub_rx_irq[],0	# gdbstub_rx_irq(regs,excep)
 
-	and	~EPSW_IE,epsw
+	LOCAL_CLI
 	bclr	0x01,(gdbstub_busy)
 
 	.globl gdbstub_return
diff --git a/arch/mn10300/kernel/gdb-io-serial.c b/arch/mn10300/kernel/gdb-io-serial.c
index ae663dc..0d5d63c 100644
--- a/arch/mn10300/kernel/gdb-io-serial.c
+++ b/arch/mn10300/kernel/gdb-io-serial.c
@@ -23,6 +23,7 @@
 #include <asm/exceptions.h>
 #include <asm/serial-regs.h>
 #include <unit/serial.h>
+#include <asm/smp.h>
 
 /*
  * initialise the GDB stub
@@ -45,22 +46,34 @@ void gdbstub_io_init(void)
 	XIRQxICR(GDBPORT_SERIAL_IRQ) = 0;
 	tmp = XIRQxICR(GDBPORT_SERIAL_IRQ);
 
+#if   CONFIG_GDBSTUB_IRQ_LEVEL == 0
 	IVAR0 = EXCEP_IRQ_LEVEL0;
-	set_intr_stub(EXCEP_IRQ_LEVEL0, gdbstub_io_rx_handler);
+#elif CONFIG_GDBSTUB_IRQ_LEVEL == 1
+	IVAR1 = EXCEP_IRQ_LEVEL1;
+#elif CONFIG_GDBSTUB_IRQ_LEVEL == 2
+	IVAR2 = EXCEP_IRQ_LEVEL2;
+#elif CONFIG_GDBSTUB_IRQ_LEVEL == 3
+	IVAR3 = EXCEP_IRQ_LEVEL3;
+#elif CONFIG_GDBSTUB_IRQ_LEVEL == 4
+	IVAR4 = EXCEP_IRQ_LEVEL4;
+#elif CONFIG_GDBSTUB_IRQ_LEVEL == 5
+	IVAR5 = EXCEP_IRQ_LEVEL5;
+#else
+#error "Unknown irq level for gdbstub."
+#endif
+
+	set_intr_stub(NUM2EXCEP_IRQ_LEVEL(CONFIG_GDBSTUB_IRQ_LEVEL),
+		gdbstub_io_rx_handler);
 
 	XIRQxICR(GDBPORT_SERIAL_IRQ) &= ~GxICR_REQUEST;
-	XIRQxICR(GDBPORT_SERIAL_IRQ) = GxICR_ENABLE | GxICR_LEVEL_0;
+	XIRQxICR(GDBPORT_SERIAL_IRQ) =
+		GxICR_ENABLE | NUM2GxICR_LEVEL(CONFIG_GDBSTUB_IRQ_LEVEL);
 	tmp = XIRQxICR(GDBPORT_SERIAL_IRQ);
 
 	GDBPORT_SERIAL_IER = UART_IER_RDI | UART_IER_RLSI;
 
 	/* permit level 0 IRQs to take place */
-	asm volatile(
-		"	and %0,epsw	\n"
-		"	or %1,epsw	\n"
-		:
-		: "i"(~EPSW_IM), "i"(EPSW_IE | EPSW_IM_1)
-		);
+	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 }
 
 /*
@@ -87,6 +100,9 @@ int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
 {
 	unsigned ix;
 	u8 ch, st;
+#if defined(CONFIG_MN10300_WD_TIMER)
+	int cpu;
+#endif
 
 	*_ch = 0xff;
 
@@ -104,8 +120,9 @@ int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
 		if (nonblock)
 			return -EAGAIN;
 #ifdef CONFIG_MN10300_WD_TIMER
-		watchdog_alert_counter = 0;
-#endif /* CONFIG_MN10300_WD_TIMER */
+	for (cpu = 0; cpu < NR_CPUS; cpu++)
+		watchdog_alert_counter[cpu] = 0;
+#endif
 		goto try_again;
 	}
 
diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
index a560bbc..97dfda2 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ b/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -58,9 +58,12 @@ void __init gdbstub_io_init(void)
 	gdbstub_io_set_baud(115200);
 
 	/* we want to get serial receive interrupts */
-	set_intr_level(gdbstub_port->rx_irq, GxICR_LEVEL_0);
-	set_intr_level(gdbstub_port->tx_irq, GxICR_LEVEL_0);
-	set_intr_stub(EXCEP_IRQ_LEVEL0, gdbstub_io_rx_handler);
+	set_intr_level(gdbstub_port->rx_irq,
+		NUM2GxICR_LEVEL(CONFIG_GDBSTUB_IRQ_LEVEL));
+	set_intr_level(gdbstub_port->tx_irq,
+		NUM2GxICR_LEVEL(CONFIG_GDBSTUB_IRQ_LEVEL));
+	set_intr_stub(NUM2EXCEP_IRQ_LEVEL(CONFIG_GDBSTUB_IRQ_LEVEL),
+		gdbstub_io_rx_handler);
 
 	*gdbstub_port->rx_icr |= GxICR_ENABLE;
 	tmp = *gdbstub_port->rx_icr;
@@ -84,12 +87,7 @@ void __init gdbstub_io_init(void)
 	tmp = *gdbstub_port->_control;
 
 	/* permit level 0 IRQs only */
-	asm volatile(
-		"	and %0,epsw	\n"
-		"	or %1,epsw	\n"
-		:
-		: "i"(~EPSW_IM), "i"(EPSW_IE|EPSW_IM_1)
-		);
+	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 }
 
 /*
@@ -184,6 +182,9 @@ int gdbstub_io_rx_char(unsigned char *_ch, int nonblock)
 {
 	unsigned ix;
 	u8 ch, st;
+#if defined(CONFIG_MN10300_WD_TIMER)
+	int cpu;
+#endif
 
 	*_ch = 0xff;
 
@@ -201,8 +202,9 @@ try_again:
 		if (nonblock)
 			return -EAGAIN;
 #ifdef CONFIG_MN10300_WD_TIMER
-		watchdog_alert_counter = 0;
-#endif /* CONFIG_MN10300_WD_TIMER */
+	for (cpu = 0; cpu < NR_CPUS; cpu++)
+		watchdog_alert_counter[cpu] = 0;
+#endif
 		goto try_again;
 	}
 
diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 41b1170..a5fc3f0 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -440,15 +440,11 @@ static const unsigned char gdbstub_insn_sizes[256] =
 
 static int __gdbstub_mark_bp(u8 *addr, int ix)
 {
-	if (addr < (u8 *) 0x70000000UL)
-		return 0;
-	/* 70000000-7fffffff: vmalloc area */
-	if (addr < (u8 *) 0x80000000UL)
+	/* vmalloc area */
+	if (((u8 *) VMALLOC_START <= addr) && (addr < (u8 *) VMALLOC_END))
 		goto okay;
-	if (addr < (u8 *) 0x8c000000UL)
-		return 0;
-	/* 8c000000-93ffffff: SRAM, SDRAM */
-	if (addr < (u8 *) 0x94000000UL)
+	/* SRAM, SDRAM */
+	if (((u8 *) 0x80000000UL <= addr) && (addr < (u8 *) 0xa0000000UL))
 		goto okay;
 	return 0;
 
@@ -1197,9 +1193,8 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
 	mn10300_set_gdbleds(1);
 
 	asm volatile("mov mdr,%0" : "=d"(mdr));
-	asm volatile("mov epsw,%0" : "=d"(epsw));
-	asm volatile("mov %0,epsw"
-		     :: "d"((epsw & ~EPSW_IM) | EPSW_IE | EPSW_IM_1));
+	local_save_flags(epsw);
+	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 
 	gdbstub_store_fpu();
 
diff --git a/arch/mn10300/kernel/head.S b/arch/mn10300/kernel/head.S
index a81e34f..73e00fc 100644
--- a/arch/mn10300/kernel/head.S
+++ b/arch/mn10300/kernel/head.S
@@ -19,6 +19,12 @@
 #include <asm/frame.inc>
 #include <asm/param.h>
 #include <unit/serial.h>
+#ifdef CONFIG_SMP
+#include <asm/smp.h>
+#include <asm/intctl-regs.h>
+#include <asm/cpu-regs.h>
+#include <proc/smp-regs.h>
+#endif /* CONFIG_SMP */
 
 	__HEAD
 
@@ -30,17 +36,51 @@
 	.globl	_start
 	.type	_start,@function
 _start:
+#ifdef CONFIG_SMP
+	#
+	# If this is a secondary CPU (AP), then deal with that elsewhere
+	#
+	mov	(CPUID),d3
+	and	CPUID_MASK,d3
+	bne	startup_secondary
+
+	#
+	# We're dealing with the primary CPU (BP) here, then.
+	# Keep BP's D0,D1,D2 register for boot check.
+	#
+
+	# Set up the Boot IPI for each secondary CPU
+	mov	0x1,a0
+loop_set_secondary_icr:
+	mov	a0,a1
+	asl	CROSS_ICR_CPU_SHIFT,a1
+	add	CROSS_GxICR(SMP_BOOT_IRQ,0),a1
+	movhu	(a1),d3
+	or	GxICR_ENABLE|GxICR_LEVEL_0,d3
+	movhu	d3,(a1)
+	movhu	(a1),d3				# flush
+	inc	a0
+	cmp	NR_CPUS,a0
+	bne	loop_set_secondary_icr
+#endif /* CONFIG_SMP */
+
 	# save commandline pointer
 	mov	d0,a3
 
 	# preload the PGD pointer register
 	mov	swapper_pg_dir,d0
 	mov	d0,(PTBR)
+	clr	d0
+	movbu	d0,(PIDR)
 
 	# turn on the TLBs
 	mov	MMUCTR_IIV|MMUCTR_DIV,d0
 	mov	d0,(MMUCTR)
+#ifdef CONFIG_AM34_2
+	mov	MMUCTR_ITE|MMUCTR_DTE|MMUCTR_CE|MMUCTR_WTE,d0
+#else
 	mov	MMUCTR_ITE|MMUCTR_DTE|MMUCTR_CE,d0
+#endif
 	mov	d0,(MMUCTR)
 
 	# turn on AM33v2 exception handling mode and set the trap table base
@@ -51,6 +91,11 @@ _start:
 	mov	d0,(TBR)
 
 	# invalidate and enable both of the caches
+#ifdef CONFIG_SMP
+	mov	ECHCTR,a0
+	clr	d0
+	mov	d0,(a0)
+#endif
 	mov	CHCTR,a0
 	clr	d0
 	movhu	d0,(a0)					# turn off first
@@ -206,6 +251,44 @@ __no_parameters:
 	call	processor_init[],0
 	call	unit_init[],0
 
+#ifdef CONFIG_SMP
+	# mark the primary CPU in cpu_boot_map
+	mov	cpu_boot_map,a0
+	mov	0x1,d0
+	mov	d0,(a0)
+
+	# signal each secondary CPU to begin booting
+	mov	0x1,d2				# CPU ID
+
+loop_request_boot_secondary:
+	mov	d2,a0
+	# send SMP_BOOT_IPI to secondary CPU
+	asl	CROSS_ICR_CPU_SHIFT,a0
+	add	CROSS_GxICR(SMP_BOOT_IRQ,0),a0
+	movhu	(a0),d0
+	or	GxICR_REQUEST|GxICR_DETECT,d0
+	movhu	d0,(a0)
+	movhu	(a0),d0				# flush
+
+	# wait up to 100ms for AP's IPI to be received
+	clr	d3
+wait_on_secondary_boot:
+	mov	DELAY_TIME_BOOT_IPI,d0
+	call	__delay[],0
+	inc	d3
+	mov	cpu_boot_map,a0
+	mov	(a0),d0
+	lsr	d2,d0
+	btst	0x1,d0
+	bne	1f
+	cmp	TIME_OUT_COUNT_BOOT_IPI,d3
+	bne	wait_on_secondary_boot
+1:
+	inc	d2
+	cmp	NR_CPUS,d2
+	bne	loop_request_boot_secondary
+#endif /* CONFIG_SMP */
+
 #ifdef CONFIG_GDBSTUB
 	call	gdbstub_init[],0
 
@@ -217,7 +300,118 @@ __gdbstub_pause:
 #endif
 
 	jmp	start_kernel
-	.size	_start, _start-.
+	.size	_start,.-_start
+
+###############################################################################
+#
+# Secondary CPU boot point
+#
+###############################################################################
+#ifdef CONFIG_SMP
+startup_secondary:
+	# preload the PGD pointer register
+	mov	swapper_pg_dir,d0
+	mov	d0,(PTBR)
+	clr	d0
+	movbu	d0,(PIDR)
+
+	# turn on the TLBs
+	mov	MMUCTR_IIV|MMUCTR_DIV,d0
+	mov	d0,(MMUCTR)
+#ifdef CONFIG_AM34_2
+	mov	MMUCTR_ITE|MMUCTR_DTE|MMUCTR_CE|MMUCTR_WTE,d0
+#else
+	mov	MMUCTR_ITE|MMUCTR_DTE|MMUCTR_CE,d0
+#endif
+	mov	d0,(MMUCTR)
+
+	# turn on AM33v2 exception handling mode and set the trap table base
+	movhu	(CPUP),d0
+	or	CPUP_EXM_AM33V2,d0
+	movhu	d0,(CPUP)
+
+	# set the interrupt vector table
+	mov	CONFIG_INTERRUPT_VECTOR_BASE,d0
+	mov	d0,(TBR)
+
+	# invalidate and enable both of the caches
+	mov	ECHCTR,a0
+	clr	d0
+	mov	d0,(a0)
+	mov	CHCTR,a0
+	clr	d0
+	movhu	d0,(a0)					# turn off first
+	mov	CHCTR_ICINV|CHCTR_DCINV,d0
+	movhu	d0,(a0)
+	setlb
+	mov	(a0),d0
+	btst	CHCTR_ICBUSY|CHCTR_DCBUSY,d0		# wait till not busy (use CPU loop buffer)
+	lne
+
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+#ifdef  CONFIG_MN10300_CACHE_WBACK
+#ifndef CONFIG_MN10300_CACHE_WBACK_NOWRALLOC
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRBACK,d0
+#else
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRBACK|CHCTR_DCALMD,d0
+#endif  /* !NOWRALLOC */
+#else
+	mov	CHCTR_ICEN|CHCTR_DCEN|CHCTR_DCWTMD_WRTHROUGH,d0
+#endif  /* WBACK */
+	movhu	d0,(a0)					# enable
+#endif  /* ENABLED */
+
+	# Clear the boot IPI interrupt for this CPU
+	movhu	(GxICR(SMP_BOOT_IRQ)),d0
+	and	~GxICR_REQUEST,d0
+	movhu	d0,(GxICR(SMP_BOOT_IRQ))
+	movhu	(GxICR(SMP_BOOT_IRQ)),d0		# flush
+
+	/* get stack */
+	mov	CONFIG_INTERRUPT_VECTOR_BASE + CONFIG_BOOT_STACK_OFFSET,a0
+	mov	(CPUID),d0
+	and	CPUID_MASK,d0
+	mulu	CONFIG_BOOT_STACK_SIZE,d0
+	sub	d0,a0
+	mov	a0,sp
+
+	# init interrupt for AP
+	call	smp_prepare_cpu_init[],0
+
+	# mark this secondary CPU in cpu_boot_map
+	mov	(CPUID),d0
+	mov	0x1,d1
+	asl	d0,d1
+	mov	cpu_boot_map,a0
+	bset	d1,(a0)
+
+	or	EPSW_IE|EPSW_IM_1,epsw  # permit level 0 interrupts
+	nop
+	nop
+#ifdef  CONFIG_MN10300_CACHE_WBACK
+	# flush the local cache if it's in writeback mode
+	call	mn10300_local_dcache_flush_inv[],0
+	setlb
+	mov	(CHCTR),d0
+	btst	CHCTR_DCBUSY,d0		# wait till not busy (use CPU loop buffer)
+	lne
+#endif
+
+	# now sleep waiting for further instructions
+secondary_sleep:
+	mov	CPUM_SLEEP,d0
+	movhu	d0,(CPUM)
+	nop
+	nop
+	bra	secondary_sleep
+	.size	startup_secondary,.-startup_secondary
+#endif /* CONFIG_SMP */
+
+###############################################################################
+#
+#
+#
+###############################################################################
 ENTRY(__head_end)
 
 /*
diff --git a/arch/mn10300/kernel/internal.h b/arch/mn10300/kernel/internal.h
index eee2eee..3b1f48b 100644
--- a/arch/mn10300/kernel/internal.h
+++ b/arch/mn10300/kernel/internal.h
@@ -18,3 +18,15 @@ extern int kernel_thread_helper(int);
  * entry.S
  */
 extern void ret_from_fork(struct task_struct *) __attribute__((noreturn));
+
+/*
+ * smp-low.S
+ */
+#ifdef CONFIG_SMP
+extern void mn10300_low_ipi_handler(void);
+#endif
+
+/*
+ * time.c
+ */
+extern irqreturn_t local_timer_interrupt(void);
diff --git a/arch/mn10300/kernel/irq.c b/arch/mn10300/kernel/irq.c
index b5b970d..80f1572 100644
--- a/arch/mn10300/kernel/irq.c
+++ b/arch/mn10300/kernel/irq.c
@@ -12,11 +12,34 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/seq_file.h>
+#include <linux/cpumask.h>
 #include <asm/setup.h>
+#include <asm/serial-regs.h>
 
-unsigned long __mn10300_irq_enabled_epsw = EPSW_IE | EPSW_IM_7;
+#ifdef CONFIG_SMP
+#undef  GxICR
+#define GxICR(X) CROSS_GxICR(X, irq_affinity_online[X])
+
+#undef  GxICR_u8
+#define GxICR_u8(X) CROSS_GxICR_u8(X, irq_affinity_online[X])
+#endif /* CONFIG_SMP */
+
+unsigned long __mn10300_irq_enabled_epsw[NR_CPUS] __cacheline_aligned_in_smp = {
+	[0 ... NR_CPUS - 1] = EPSW_IE | EPSW_IM_7
+};
 EXPORT_SYMBOL(__mn10300_irq_enabled_epsw);
 
+#ifdef CONFIG_SMP
+static char irq_affinity_online[NR_IRQS] = {
+	[0 ... NR_IRQS - 1] = 0
+};
+
+#define NR_IRQ_WORDS	((NR_IRQS + 31) / 32)
+static unsigned long irq_affinity_request[NR_IRQ_WORDS] = {
+	[0 ... NR_IRQ_WORDS - 1] = 0
+};
+#endif  /* CONFIG_SMP */
+
 atomic_t irq_err_count;
 
 /*
@@ -24,30 +47,65 @@ atomic_t irq_err_count;
  */
 static void mn10300_cpupic_ack(unsigned int irq)
 {
+	unsigned long flags;
+	u16 tmp;
+
+	flags = arch_local_cli_save();
+	GxICR_u8(irq) = GxICR_DETECT;
+	tmp = GxICR(irq);
+	arch_local_irq_restore(flags);
+}
+
+static void __mask_and_set_icr(unsigned int irq,
+			       unsigned int mask, unsigned int set)
+{
+	unsigned long flags;
 	u16 tmp;
-	*(volatile u8 *) &GxICR(irq) = GxICR_DETECT;
+
+	flags = arch_local_cli_save();
 	tmp = GxICR(irq);
+	GxICR(irq) = (tmp & mask) | set;
+	tmp = GxICR(irq);
+	arch_local_irq_restore(flags);
 }
 
 static void mn10300_cpupic_mask(unsigned int irq)
 {
-	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL);
-	tmp = GxICR(irq);
+	__mask_and_set_icr(irq, GxICR_LEVEL, 0);
 }
 
 static void mn10300_cpupic_mask_ack(unsigned int irq)
 {
-	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
-	tmp = GxICR(irq);
+#ifdef CONFIG_SMP
+	unsigned long flags;
+	u16 tmp;
+
+	flags = arch_local_cli_save();
+
+	if (!test_and_clear_bit(irq, irq_affinity_request)) {
+		tmp = GxICR(irq);
+		GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
+		tmp = GxICR(irq);
+	} else {
+		u16 tmp2;
+		tmp = GxICR(irq);
+		GxICR(irq) = (tmp & GxICR_LEVEL);
+		tmp2 = GxICR(irq);
+
+		irq_affinity_online[irq] = any_online_cpu(*irq_desc[irq].affinity);
+		GxICR(irq) = (tmp & (GxICR_LEVEL | GxICR_ENABLE)) | GxICR_DETECT;
+		tmp = GxICR(irq);
+	}
+
+	arch_local_irq_restore(flags);
+#else  /* CONFIG_SMP */
+	__mask_and_set_icr(irq, GxICR_LEVEL, GxICR_DETECT);
+#endif /* CONFIG_SMP */
 }
 
 static void mn10300_cpupic_unmask(unsigned int irq)
 {
-	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
-	tmp = GxICR(irq);
+	__mask_and_set_icr(irq, GxICR_LEVEL, GxICR_ENABLE);
 }
 
 static void mn10300_cpupic_unmask_clear(unsigned int irq)
@@ -56,11 +114,89 @@ static void mn10300_cpupic_unmask_clear(unsigned int irq)
 	 * device has ceased to assert its interrupt line and the interrupt
 	 * channel has been disabled in the PIC, so for level-triggered
 	 * interrupts we need to clear the request bit when we re-enable */
-	u16 tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
-	tmp = GxICR(irq);
+#ifdef CONFIG_SMP
+	unsigned long flags;
+	u16 tmp;
+
+	flags = arch_local_cli_save();
+
+	if (!test_and_clear_bit(irq, irq_affinity_request)) {
+		tmp = GxICR(irq);
+		GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
+		tmp = GxICR(irq);
+	} else {
+		tmp = GxICR(irq);
+
+		irq_affinity_online[irq] = any_online_cpu(*irq_desc[irq].affinity);
+		GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE | GxICR_DETECT;
+		tmp = GxICR(irq);
+	}
+
+	arch_local_irq_restore(flags);
+#else  /* CONFIG_SMP */
+	__mask_and_set_icr(irq, GxICR_LEVEL, GxICR_ENABLE | GxICR_DETECT);
+#endif /* CONFIG_SMP */
 }
 
+#ifdef CONFIG_SMP
+static int
+mn10300_cpupic_setaffinity(unsigned int irq, const struct cpumask *mask)
+{
+	unsigned long flags;
+	int err;
+
+	flags = arch_local_cli_save();
+
+	/* check irq no */
+	switch (irq) {
+	case TMJCIRQ:
+	case RESCHEDULE_IPI:
+	case CALL_FUNC_SINGLE_IPI:
+	case LOCAL_TIMER_IPI:
+	case FLUSH_CACHE_IPI:
+	case CALL_FUNCTION_NMI_IPI:
+	case GDB_NMI_IPI:
+#ifdef CONFIG_MN10300_TTYSM0
+	case SC0RXIRQ:
+	case SC0TXIRQ:
+#ifdef CONFIG_MN10300_TTYSM0_TIMER8
+	case TM8IRQ:
+#elif CONFIG_MN10300_TTYSM0_TIMER2
+	case TM2IRQ:
+#endif /* CONFIG_MN10300_TTYSM0_TIMER8 */
+#endif /* CONFIG_MN10300_TTYSM0 */
+
+#ifdef CONFIG_MN10300_TTYSM1
+	case SC1RXIRQ:
+	case SC1TXIRQ:
+#ifdef CONFIG_MN10300_TTYSM1_TIMER12
+	case TM12IRQ:
+#elif CONFIG_MN10300_TTYSM1_TIMER9
+	case TM9IRQ:
+#elif CONFIG_MN10300_TTYSM1_TIMER3
+	case TM3IRQ:
+#endif /* CONFIG_MN10300_TTYSM1_TIMER12 */
+#endif /* CONFIG_MN10300_TTYSM1 */
+
+#ifdef CONFIG_MN10300_TTYSM2
+	case SC2RXIRQ:
+	case SC2TXIRQ:
+	case TM10IRQ:
+#endif /* CONFIG_MN10300_TTYSM2 */
+		err = -1;
+		break;
+
+	default:
+		set_bit(irq, irq_affinity_request);
+		err = 0;
+		break;
+	}
+
+	arch_local_irq_restore(flags);
+	return err;
+}
+#endif /* CONFIG_SMP */
+
 /*
  * MN10300 PIC level-triggered IRQ handling.
  *
@@ -79,6 +215,9 @@ static struct irq_chip mn10300_cpu_pic_level = {
 	.mask		= mn10300_cpupic_mask,
 	.mask_ack	= mn10300_cpupic_mask,
 	.unmask		= mn10300_cpupic_unmask_clear,
+#ifdef CONFIG_SMP
+	.set_affinity	= mn10300_cpupic_setaffinity,
+#endif /* CONFIG_SMP */
 };
 
 /*
@@ -94,6 +233,9 @@ static struct irq_chip mn10300_cpu_pic_edge = {
 	.mask		= mn10300_cpupic_mask,
 	.mask_ack	= mn10300_cpupic_mask_ack,
 	.unmask		= mn10300_cpupic_unmask,
+#ifdef CONFIG_SMP
+	.set_affinity	= mn10300_cpupic_setaffinity,
+#endif /* CONFIG_SMP */
 };
 
 /*
@@ -111,14 +253,34 @@ void ack_bad_irq(int irq)
  */
 void set_intr_level(int irq, u16 level)
 {
-	u16 tmp;
+	BUG_ON(in_interrupt());
 
-	if (in_interrupt())
-		BUG();
+	__mask_and_set_icr(irq, GxICR_ENABLE, level);
+}
 
-	tmp = GxICR(irq);
-	GxICR(irq) = (tmp & GxICR_ENABLE) | level;
-	tmp = GxICR(irq);
+void mn10300_intc_set_level(unsigned int irq, unsigned int level)
+{
+	set_intr_level(irq, NUM2GxICR_LEVEL(level) & GxICR_LEVEL);
+}
+
+void mn10300_intc_clear(unsigned int irq)
+{
+	__mask_and_set_icr(irq, GxICR_LEVEL | GxICR_ENABLE, GxICR_DETECT);
+}
+
+void mn10300_intc_set(unsigned int irq)
+{
+	__mask_and_set_icr(irq, 0, GxICR_REQUEST | GxICR_DETECT);
+}
+
+void mn10300_intc_enable(unsigned int irq)
+{
+	mn10300_cpupic_unmask(irq);
+}
+
+void mn10300_intc_disable(unsigned int irq)
+{
+	mn10300_cpupic_mask(irq);
 }
 
 /*
@@ -126,7 +288,7 @@ void set_intr_level(int irq, u16 level)
  * than before
  * - see Documentation/mn10300/features.txt
  */
-void set_intr_postackable(int irq)
+void mn10300_set_lateack_irq_type(int irq)
 {
 	set_irq_chip_and_handler(irq, &mn10300_cpu_pic_level,
 				 handle_level_irq);
@@ -147,6 +309,7 @@ void __init init_IRQ(void)
 			 * interrupts */
 			set_irq_chip_and_handler(irq, &mn10300_cpu_pic_edge,
 						 handle_level_irq);
+
 	unit_init_IRQ();
 }
 
@@ -156,6 +319,7 @@ void __init init_IRQ(void)
 asmlinkage void do_IRQ(void)
 {
 	unsigned long sp, epsw, irq_disabled_epsw, old_irq_enabled_epsw;
+	unsigned int cpu_id = smp_processor_id();
 	int irq;
 
 	sp = current_stack_pointer();
@@ -163,12 +327,14 @@ asmlinkage void do_IRQ(void)
 
 	/* make sure local_irq_enable() doesn't muck up the interrupt priority
 	 * setting in EPSW */
-	old_irq_enabled_epsw = __mn10300_irq_enabled_epsw;
+	old_irq_enabled_epsw = __mn10300_irq_enabled_epsw[cpu_id];
 	local_save_flags(epsw);
-	__mn10300_irq_enabled_epsw = EPSW_IE | (EPSW_IM & epsw);
+	__mn10300_irq_enabled_epsw[cpu_id] = EPSW_IE | (EPSW_IM & epsw);
 	irq_disabled_epsw = EPSW_IE | MN10300_CLI_LEVEL;
 
-	__IRQ_STAT(smp_processor_id(), __irq_count)++;
+#ifdef CONFIG_MN10300_WD_TIMER
+	__IRQ_STAT(cpu_id, __irq_count)++;
+#endif
 
 	irq_enter();
 
@@ -188,7 +354,7 @@ asmlinkage void do_IRQ(void)
 		local_irq_restore(epsw);
 	}
 
-	__mn10300_irq_enabled_epsw = old_irq_enabled_epsw;
+	__mn10300_irq_enabled_epsw[cpu_id] = old_irq_enabled_epsw;
 
 	irq_exit();
 }
@@ -239,11 +405,13 @@ int show_interrupts(struct seq_file *p, void *v)
 
 		/* polish off with NMI and error counters */
 	case NR_IRQS:
+#ifdef CONFIG_MN10300_WD_TIMER
 		seq_printf(p, "NMI: ");
 		for (j = 0; j < NR_CPUS; j++)
 			if (cpu_online(j))
 				seq_printf(p, "%10u ", nmi_count(j));
 		seq_putc(p, '\n');
+#endif
 
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 		break;
@@ -251,3 +419,51 @@ int show_interrupts(struct seq_file *p, void *v)
 
 	return 0;
 }
+
+#ifdef CONFIG_HOTPLUG_CPU
+void migrate_irqs(void)
+{
+	irq_desc_t *desc;
+	int irq;
+	unsigned int self, new;
+	unsigned long flags;
+
+	self = smp_processor_id();
+	for (irq = 0; irq < NR_IRQS; irq++) {
+		desc = irq_desc + irq;
+
+		if (desc->status == IRQ_PER_CPU)
+			continue;
+
+		if (cpu_isset(self, irq_desc[irq].affinity) &&
+		    !cpus_intersects(irq_affinity[irq], cpu_online_map)) {
+			int cpu_id;
+			cpu_id = first_cpu(cpu_online_map);
+			cpu_set(cpu_id, irq_desc[irq].affinity);
+		}
+		/* We need to operate irq_affinity_online atomically. */
+		arch_local_cli_save(flags);
+		if (irq_affinity_online[irq] == self) {
+			u16 x, tmp;
+
+			x = CROSS_GxICR(irq, self);
+			CROSS_GxICR(irq, self) = x & GxICR_LEVEL;
+			tmp = CROSS_GxICR(irq, self);
+
+			new = any_online_cpu(irq_desc[irq].affinity);
+			irq_affinity_online[irq] = new;
+
+			CROSS_GxICR(irq, new) =
+				(x & GxICR_LEVEL) | GxICR_DETECT;
+			tmp = CROSS_GxICR(irq, new);
+
+			x &= GxICR_LEVEL | GxICR_ENABLE;
+			if (CROSS_GxICR(irq, self) & GxICR_REQUEST)
+				x |= GxICR_REQUEST | GxICR_DETECT;
+			CROSS_GxICR(irq, new) = x;
+			tmp = CROSS_GxICR(irq, new);
+		}
+		arch_local_irq_restore(flags);
+	}
+}
+#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/arch/mn10300/kernel/mn10300-serial-low.S b/arch/mn10300/kernel/mn10300-serial-low.S
index 66702d2..dfc1b6f 100644
--- a/arch/mn10300/kernel/mn10300-serial-low.S
+++ b/arch/mn10300/kernel/mn10300-serial-low.S
@@ -39,7 +39,7 @@
 ###############################################################################
 	.balign	L1_CACHE_BYTES
 ENTRY(mn10300_serial_vdma_interrupt)
-	or	EPSW_IE,psw			# permit overriding by
+#	or	EPSW_IE,psw			# permit overriding by
 						# debugging interrupts
 	movm	[d2,d3,a2,a3,exreg0],(sp)
 
@@ -164,7 +164,7 @@ mnsc_vdma_tx_noint:
 	rti
 
 mnsc_vdma_tx_empty:
-	mov	+(GxICR_LEVEL_1|GxICR_DETECT),d2
+	mov	+(NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL)|GxICR_DETECT),d2
 	movhu	d2,(e3)			# disable the interrupt
 	movhu	(e3),d2			# flush
 
@@ -175,7 +175,7 @@ mnsc_vdma_tx_break:
 	movhu	(SCxCTR,e2),d2		# turn on break mode
 	or	SC01CTR_BKE,d2
 	movhu	d2,(SCxCTR,e2)
-	mov	+(GxICR_LEVEL_1|GxICR_DETECT),d2
+	mov	+(NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL)|GxICR_DETECT),d2
 	movhu	d2,(e3)			# disable transmit interrupts on this
 					# channel
 	movhu	(e3),d2			# flush
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index db509dd..996384d 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -44,6 +44,11 @@ static const char serial_revdate[] = "2007-11-06";
 #include <unit/timex.h>
 #include "mn10300-serial.h"
 
+#ifdef CONFIG_SMP
+#undef  GxICR
+#define GxICR(X) CROSS_GxICR(X, 0)
+#endif /* CONFIG_SMP */
+
 #define kenter(FMT, ...) \
 	printk(KERN_DEBUG "-->%s(" FMT ")\n", __func__, ##__VA_ARGS__)
 #define _enter(FMT, ...) \
@@ -57,6 +62,11 @@ static const char serial_revdate[] = "2007-11-06";
 #define _proto(FMT, ...) \
 	no_printk(KERN_DEBUG "### MNSERIAL " FMT " ###\n", ##__VA_ARGS__)
 
+#ifndef CODMSB
+/* c_cflag bit meaning */
+#define CODMSB	004000000000	/* change Transfer bit-order */
+#endif
+
 #define NR_UARTS 3
 
 #ifdef CONFIG_MN10300_TTYSM_CONSOLE
@@ -152,26 +162,35 @@ struct mn10300_serial_port mn10300_serial_port_sif0 = {
 	.name		= "ttySM0",
 	._iobase	= &SC0CTR,
 	._control	= &SC0CTR,
-	._status	= (volatile u8 *) &SC0STR,
+	._status	= (volatile u8 *)&SC0STR,
 	._intr		= &SC0ICR,
 	._rxb		= &SC0RXB,
 	._txb		= &SC0TXB,
 	.rx_name	= "ttySM0:Rx",
 	.tx_name	= "ttySM0:Tx",
-#ifdef CONFIG_MN10300_TTYSM0_TIMER8
+#if defined(CONFIG_MN10300_TTYSM0_TIMER8)
 	.tm_name	= "ttySM0:Timer8",
 	._tmxmd		= &TM8MD,
 	._tmxbr		= &TM8BR,
 	._tmicr		= &TM8ICR,
 	.tm_irq		= TM8IRQ,
 	.div_timer	= MNSCx_DIV_TIMER_16BIT,
-#else /* CONFIG_MN10300_TTYSM0_TIMER2 */
+#elif defined(CONFIG_MN10300_TTYSM0_TIMER0)
+	.tm_name	= "ttySM0:Timer0",
+	._tmxmd		= &TM0MD,
+	._tmxbr		= (volatile u16 *)&TM0BR,
+	._tmicr		= &TM0ICR,
+	.tm_irq		= TM0IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_8BIT,
+#elif defined(CONFIG_MN10300_TTYSM0_TIMER2)
 	.tm_name	= "ttySM0:Timer2",
 	._tmxmd		= &TM2MD,
-	._tmxbr		= (volatile u16 *) &TM2BR,
+	._tmxbr		= (volatile u16 *)&TM2BR,
 	._tmicr		= &TM2ICR,
 	.tm_irq		= TM2IRQ,
 	.div_timer	= MNSCx_DIV_TIMER_8BIT,
+#else
+#error "Unknown config for ttySM0"
 #endif
 	.rx_irq		= SC0RXIRQ,
 	.tx_irq		= SC0TXIRQ,
@@ -205,26 +224,35 @@ struct mn10300_serial_port mn10300_serial_port_sif1 = {
 	.name		= "ttySM1",
 	._iobase	= &SC1CTR,
 	._control	= &SC1CTR,
-	._status	= (volatile u8 *) &SC1STR,
+	._status	= (volatile u8 *)&SC1STR,
 	._intr		= &SC1ICR,
 	._rxb		= &SC1RXB,
 	._txb		= &SC1TXB,
 	.rx_name	= "ttySM1:Rx",
 	.tx_name	= "ttySM1:Tx",
-#ifdef CONFIG_MN10300_TTYSM1_TIMER9
+#if defined(CONFIG_MN10300_TTYSM1_TIMER9)
 	.tm_name	= "ttySM1:Timer9",
 	._tmxmd		= &TM9MD,
 	._tmxbr		= &TM9BR,
 	._tmicr		= &TM9ICR,
 	.tm_irq		= TM9IRQ,
 	.div_timer	= MNSCx_DIV_TIMER_16BIT,
-#else /* CONFIG_MN10300_TTYSM1_TIMER3 */
+#elif defined(CONFIG_MN10300_TTYSM1_TIMER3)
 	.tm_name	= "ttySM1:Timer3",
 	._tmxmd		= &TM3MD,
-	._tmxbr		= (volatile u16 *) &TM3BR,
+	._tmxbr		= (volatile u16 *)&TM3BR,
 	._tmicr		= &TM3ICR,
 	.tm_irq		= TM3IRQ,
 	.div_timer	= MNSCx_DIV_TIMER_8BIT,
+#elif defined(CONFIG_MN10300_TTYSM1_TIMER12)
+	.tm_name	= "ttySM1/Timer12",
+	._tmxmd		= &TM12MD,
+	._tmxbr		= &TM12BR,
+	._tmicr		= &TM12ICR,
+	.tm_irq		= TM12IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_16BIT,
+#else
+#error "Unknown config for ttySM1"
 #endif
 	.rx_irq		= SC1RXIRQ,
 	.tx_irq		= SC1TXIRQ,
@@ -260,20 +288,45 @@ struct mn10300_serial_port mn10300_serial_port_sif2 = {
 	.uart.lock	=
 	__SPIN_LOCK_UNLOCKED(mn10300_serial_port_sif2.uart.lock),
 	.name		= "ttySM2",
-	.rx_name	= "ttySM2:Rx",
-	.tx_name	= "ttySM2:Tx",
-	.tm_name	= "ttySM2:Timer10",
 	._iobase	= &SC2CTR,
 	._control	= &SC2CTR,
-	._status	= &SC2STR,
+	._status	= (volatile u8 *)&SC2STR,
 	._intr		= &SC2ICR,
 	._rxb		= &SC2RXB,
 	._txb		= &SC2TXB,
+	.rx_name	= "ttySM2:Rx",
+	.tx_name	= "ttySM2:Tx",
+#if defined(CONFIG_MN10300_TTYSM2_TIMER10)
+	.tm_name	= "ttySM2/Timer10",
 	._tmxmd		= &TM10MD,
 	._tmxbr		= &TM10BR,
 	._tmicr		= &TM10ICR,
 	.tm_irq		= TM10IRQ,
 	.div_timer	= MNSCx_DIV_TIMER_16BIT,
+#elif defined(CONFIG_MN10300_TTYSM2_TIMER9)
+	.tm_name	= "ttySM2/Timer9",
+	._tmxmd		= &TM9MD,
+	._tmxbr		= &TM9BR,
+	._tmicr		= &TM9ICR,
+	.tm_irq		= TM9IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_16BIT,
+#elif defined(CONFIG_MN10300_TTYSM2_TIMER1)
+	.tm_name	= "ttySM2/Timer1",
+	._tmxmd		= &TM1MD,
+	._tmxbr		= (volatile u16 *)&TM1BR,
+	._tmicr		= &TM1ICR,
+	.tm_irq		= TM1IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_8BIT,
+#elif defined(CONFIG_MN10300_TTYSM2_TIMER3)
+	.tm_name	= "ttySM2/Timer3",
+	._tmxmd		= &TM3MD,
+	._tmxbr		= (volatile u16 *)&TM3BR,
+	._tmicr		= &TM3ICR,
+	.tm_irq		= TM3IRQ,
+	.div_timer	= MNSCx_DIV_TIMER_8BIT,
+#else
+#error "Unknown config for ttySM2"
+#endif
 	.rx_irq		= SC2RXIRQ,
 	.tx_irq		= SC2TXIRQ,
 	.rx_icr		= &GxICR(SC2RXIRQ),
@@ -322,9 +375,13 @@ struct mn10300_serial_port *mn10300_serial_ports[NR_UARTS + 1] = {
  */
 static void mn10300_serial_mask_ack(unsigned int irq)
 {
+	unsigned long flags;
 	u16 tmp;
+
+	flags = arch_local_cli_save();
 	GxICR(irq) = GxICR_LEVEL_6;
 	tmp = GxICR(irq); /* flush write buffer */
+	arch_local_irq_restore(flags);
 }
 
 static void mn10300_serial_nop(unsigned int irq)
@@ -348,23 +405,36 @@ struct mn10300_serial_int mn10300_serial_int_tbl[NR_IRQS];
 
 static void mn10300_serial_dis_tx_intr(struct mn10300_serial_port *port)
 {
+	unsigned long flags;
 	u16 x;
-	*port->tx_icr = GxICR_LEVEL_1 | GxICR_DETECT;
+
+	flags = arch_local_cli_save();
+	*port->tx_icr = NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL);
 	x = *port->tx_icr;
+	arch_local_irq_restore(flags);
 }
 
 static void mn10300_serial_en_tx_intr(struct mn10300_serial_port *port)
 {
+	unsigned long flags;
 	u16 x;
-	*port->tx_icr = GxICR_LEVEL_1 | GxICR_ENABLE;
+
+	flags = arch_local_cli_save();
+	*port->tx_icr =
+		NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL) | GxICR_ENABLE;
 	x = *port->tx_icr;
+	arch_local_irq_restore(flags);
 }
 
 static void mn10300_serial_dis_rx_intr(struct mn10300_serial_port *port)
 {
+	unsigned long flags;
 	u16 x;
-	*port->rx_icr = GxICR_LEVEL_1 | GxICR_DETECT;
+
+	flags = arch_local_cli_save();
+	*port->rx_icr = NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL);
 	x = *port->rx_icr;
+	arch_local_irq_restore(flags);
 }
 
 /*
@@ -650,7 +720,7 @@ static unsigned int mn10300_serial_tx_empty(struct uart_port *_port)
 static void mn10300_serial_set_mctrl(struct uart_port *_port,
 				     unsigned int mctrl)
 {
-	struct mn10300_serial_port *port =
+	struct mn10300_serial_port *port __attribute__ ((unused)) =
 		container_of(_port, struct mn10300_serial_port, uart);
 
 	_enter("%s,%x", port->name, mctrl);
@@ -706,6 +776,7 @@ static void mn10300_serial_start_tx(struct uart_port *_port)
 			UART_XMIT_SIZE));
 
 	/* kick the virtual DMA controller */
+	arch_local_cli();
 	x = *port->tx_icr;
 	x |= GxICR_ENABLE;
 
@@ -716,10 +787,14 @@ static void mn10300_serial_start_tx(struct uart_port *_port)
 
 	_debug("CTR=%04hx ICR=%02hx STR=%04x TMD=%02hx TBR=%04hx ICR=%04hx",
 	       *port->_control, *port->_intr, *port->_status,
-	       *port->_tmxmd, *port->_tmxbr, *port->tx_icr);
+	       *port->_tmxmd,
+	       (port->div_timer == MNSCx_DIV_TIMER_8BIT) ?
+	           *(volatile u8 *)port->_tmxbr : *port->_tmxbr,
+	       *port->tx_icr);
 
 	*port->tx_icr = x;
 	x = *port->tx_icr;
+	arch_local_sti();
 }
 
 /*
@@ -842,8 +917,10 @@ static int mn10300_serial_startup(struct uart_port *_port)
 	pint->port = port;
 	pint->vdma = mn10300_serial_vdma_tx_handler;
 
-	set_intr_level(port->rx_irq, GxICR_LEVEL_1);
-	set_intr_level(port->tx_irq, GxICR_LEVEL_1);
+	set_intr_level(port->rx_irq,
+		NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL));
+	set_intr_level(port->tx_irq,
+		NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL));
 	set_irq_chip(port->tm_irq, &mn10300_serial_pic);
 
 	if (request_irq(port->rx_irq, mn10300_serial_interrupt,
@@ -876,6 +953,7 @@ error:
  */
 static void mn10300_serial_shutdown(struct uart_port *_port)
 {
+	u16 x;
 	struct mn10300_serial_port *port =
 		container_of(_port, struct mn10300_serial_port, uart);
 
@@ -897,8 +975,12 @@ static void mn10300_serial_shutdown(struct uart_port *_port)
 	free_irq(port->rx_irq, port);
 	free_irq(port->tx_irq, port);
 
-	*port->rx_icr = GxICR_LEVEL_1;
-	*port->tx_icr = GxICR_LEVEL_1;
+	arch_local_cli();
+	*port->rx_icr = NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL);
+	x = *port->rx_icr;
+	*port->tx_icr = NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL);
+	x = *port->tx_icr;
+	arch_local_sti();
 }
 
 /*
@@ -947,11 +1029,66 @@ static void mn10300_serial_change_speed(struct mn10300_serial_port *port,
 	/* Determine divisor based on baud rate */
 	battempt = 0;
 
-	if (div_timer == MNSCx_DIV_TIMER_16BIT)
-		scxctr |= SC0CTR_CK_TM8UFLOW_8; /* ( == SC1CTR_CK_TM9UFLOW_8
-						 *   == SC2CTR_CK_TM10UFLOW) */
-	else if (div_timer == MNSCx_DIV_TIMER_8BIT)
+	switch (port->uart.line) {
+#ifdef CONFIG_MN10300_TTYSM0
+	case 0: /* ttySM0 */
+#if   defined(CONFIG_MN10300_TTYSM0_TIMER8)
+		scxctr |= SC0CTR_CK_TM8UFLOW_8;
+#elif defined(CONFIG_MN10300_TTYSM0_TIMER0)
+		scxctr |= SC0CTR_CK_TM0UFLOW_8;
+#elif defined(CONFIG_MN10300_TTYSM0_TIMER2)
 		scxctr |= SC0CTR_CK_TM2UFLOW_8;
+#else
+#error "Unknown config for ttySM0"
+#endif
+		break;
+#endif /* CONFIG_MN10300_TTYSM0 */
+
+#ifdef CONFIG_MN10300_TTYSM1
+	case 1: /* ttySM1 */
+#if defined(CONFIG_AM33_2) || defined(CONFIG_AM33_3)
+#if   defined(CONFIG_MN10300_TTYSM1_TIMER9)
+		scxctr |= SC1CTR_CK_TM9UFLOW_8;
+#elif defined(CONFIG_MN10300_TTYSM1_TIMER3)
+		scxctr |= SC1CTR_CK_TM3UFLOW_8;
+#else
+#error "Unknown config for ttySM1"
+#endif
+#else /* CONFIG_AM33_2 || CONFIG_AM33_3 */
+#if defined(CONFIG_MN10300_TTYSM1_TIMER12)
+		scxctr |= SC1CTR_CK_TM12UFLOW_8;
+#else
+#error "Unknown config for ttySM1"
+#endif
+#endif /* CONFIG_AM33_2 || CONFIG_AM33_3 */
+		break;
+#endif /* CONFIG_MN10300_TTYSM1 */
+
+#ifdef CONFIG_MN10300_TTYSM2
+	case 2: /* ttySM2 */
+#if defined(CONFIG_AM33_2)
+#if   defined(CONFIG_MN10300_TTYSM2_TIMER10)
+		scxctr |= SC2CTR_CK_TM10UFLOW;
+#else
+#error "Unknown config for ttySM2"
+#endif
+#else /* CONFIG_AM33_2 */
+#if   defined(CONFIG_MN10300_TTYSM2_TIMER9)
+		scxctr |= SC2CTR_CK_TM9UFLOW_8;
+#elif defined(CONFIG_MN10300_TTYSM2_TIMER1)
+		scxctr |= SC2CTR_CK_TM1UFLOW_8;
+#elif defined(CONFIG_MN10300_TTYSM2_TIMER3)
+		scxctr |= SC2CTR_CK_TM3UFLOW_8;
+#else
+#error "Unknown config for ttySM2"
+#endif
+#endif /* CONFIG_AM33_2 */
+		break;
+#endif /* CONFIG_MN10300_TTYSM2 */
+
+	default:
+		break;
+	}
 
 try_alternative:
 	baud = uart_get_baud_rate(&port->uart, new, old, 0,
@@ -1195,6 +1332,12 @@ static void mn10300_serial_set_termios(struct uart_port *_port,
 		ctr &= ~SC2CTR_TWE;
 		*port->_control = ctr;
 	}
+
+	/* change Transfer bit-order (LSB/MSB) */
+	if (new->c_cflag & CODMSB)
+		*port->_control |= SC01CTR_OD_MSBFIRST; /* MSB MODE */
+	else
+		*port->_control &= ~SC01CTR_OD_MSBFIRST; /* LSB MODE */
 }
 
 /*
@@ -1302,11 +1445,16 @@ static int __init mn10300_serial_init(void)
 	printk(KERN_INFO "%s version %s (%s)\n",
 	       serial_name, serial_version, serial_revdate);
 
-#ifdef CONFIG_MN10300_TTYSM2
-	SC2TIM = 8; /* make the baud base of timer 2 IOCLK/8 */
+#if defined(CONFIG_MN10300_TTYSM2) && defined(CONFIG_AM33_2)
+	{
+		int tmp;
+		SC2TIM = 8; /* make the baud base of timer 2 IOCLK/8 */
+		tmp = SC2TIM;
+	}
 #endif
 
-	set_intr_stub(EXCEP_IRQ_LEVEL1, mn10300_serial_vdma_interrupt);
+	set_intr_stub(NUM2EXCEP_IRQ_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL),
+		mn10300_serial_vdma_interrupt);
 
 	ret = uart_register_driver(&mn10300_serial_driver);
 	if (!ret) {
@@ -1366,9 +1514,11 @@ static void mn10300_serial_console_write(struct console *co,
 	port = mn10300_serial_ports[co->index];
 
 	/* firstly hijack the serial port from the "virtual DMA" controller */
+	arch_local_cli();
 	txicr = *port->tx_icr;
-	*port->tx_icr = GxICR_LEVEL_1;
+	*port->tx_icr = NUM2GxICR_LEVEL(CONFIG_MN10300_SERIAL_IRQ_LEVEL);
 	tmp = *port->tx_icr;
+	arch_local_sti();
 
 	/* the transmitter may be disabled */
 	scxctr = *port->_control;
@@ -1422,8 +1572,10 @@ static void mn10300_serial_console_write(struct console *co,
 	if (!(scxctr & SC01CTR_TXE))
 		*port->_control = scxctr;
 
+	arch_local_cli();
 	*port->tx_icr = txicr;
 	tmp = *port->tx_icr;
+	arch_local_sti();
 }
 
 /*
diff --git a/arch/mn10300/kernel/mn10300-watchdog-low.S b/arch/mn10300/kernel/mn10300-watchdog-low.S
index 9962447..f2f5c9c 100644
--- a/arch/mn10300/kernel/mn10300-watchdog-low.S
+++ b/arch/mn10300/kernel/mn10300-watchdog-low.S
@@ -16,6 +16,7 @@
 #include <asm/intctl-regs.h>
 #include <asm/timer-regs.h>
 #include <asm/frame.inc>
+#include <linux/threads.h>
 
 	.text
 
@@ -53,7 +54,13 @@ watchdog_handler:
 	.type	touch_nmi_watchdog,@function
 touch_nmi_watchdog:
 	clr	d0
-	mov	d0,(watchdog_alert_counter)
+	clr	d1
+	mov	watchdog_alert_counter, a0
+	setlb
+	mov	d0, (a0+)
+	inc	d1
+	cmp	NR_CPUS, d1
+	lne
 	ret	[],0
 
 	.size	touch_nmi_watchdog,.-touch_nmi_watchdog
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index f362d9d..965dd61 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -30,7 +30,7 @@
 static DEFINE_SPINLOCK(watchdog_print_lock);
 static unsigned int watchdog;
 static unsigned int watchdog_hz = 1;
-unsigned int watchdog_alert_counter;
+unsigned int watchdog_alert_counter[NR_CPUS];
 
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
@@ -39,9 +39,6 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
  * is to check its timer makes IRQ counts. If they are not
  * changing then that CPU has some problem.
  *
- * as these watchdog NMI IRQs are generated on every CPU, we only
- * have to check the current processor.
- *
  * since NMIs dont listen to _any_ locks, we have to be extremely
  * careful not to rely on unsafe variables. The printk might lock
  * up though, so we have to break up any console locks first ...
@@ -69,8 +66,8 @@ int __init check_watchdog(void)
 
 	printk(KERN_INFO "OK.\n");
 
-	/* now that we know it works we can reduce NMI frequency to
-	 * something more reasonable; makes a difference in some configs
+	/* now that we know it works we can reduce NMI frequency to something
+	 * more reasonable; makes a difference in some configs
 	 */
 	watchdog_hz = 1;
 
@@ -121,15 +118,22 @@ void __init watchdog_go(void)
 	}
 }
 
+#ifdef CONFIG_SMP
+static void watchdog_dump_register(void *dummy)
+{
+	printk(KERN_ERR "--- Register Dump (CPU%d) ---\n", CPUID);
+	show_registers(__frame);
+}
+#endif
+
 asmlinkage
 void watchdog_interrupt(struct pt_regs *regs, enum exception_code excep)
 {
-
 	/*
 	 * Since current-> is always on the stack, and we always switch
 	 * the stack NMI-atomically, it's safe to use smp_processor_id().
 	 */
-	int sum, cpu = smp_processor_id();
+	int sum, cpu;
 	int irq = NMIIRQ;
 	u8 wdt, tmp;
 
@@ -138,43 +142,61 @@ void watchdog_interrupt(struct pt_regs *regs, enum exception_code excep)
 	tmp = WDCTR;
 	NMICR = NMICR_WDIF;
 
-	nmi_count(cpu)++;
+	nmi_count(smp_processor_id())++;
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
-	sum = irq_stat[cpu].__irq_count;
-
-	if (last_irq_sums[cpu] == sum) {
-		/*
-		 * Ayiee, looks like this CPU is stuck ...
-		 * wait a few IRQs (5 seconds) before doing the oops ...
-		 */
-		watchdog_alert_counter++;
-		if (watchdog_alert_counter == 5 * watchdog_hz) {
-			spin_lock(&watchdog_print_lock);
+
+	for_each_online_cpu(cpu) {
+
+		sum = irq_stat[cpu].__irq_count;
+
+		if ((last_irq_sums[cpu] == sum)
+#if defined(CONFIG_GDBSTUB) && defined(CONFIG_SMP)
+			&& !(CHK_GDBSTUB_BUSY()
+			     || atomic_read(&cpu_doing_single_step))
+#endif
+			) {
 			/*
-			 * We are in trouble anyway, lets at least try
-			 * to get a message out.
+			 * Ayiee, looks like this CPU is stuck ...
+			 * wait a few IRQs (5 seconds) before doing the oops ...
 			 */
-			bust_spinlocks(1);
-			printk(KERN_ERR
-			       "NMI Watchdog detected LOCKUP on CPU%d,"
-			       " pc %08lx, registers:\n",
-			       cpu, regs->pc);
-			show_registers(regs);
-			printk("console shuts up ...\n");
-			console_silent();
-			spin_unlock(&watchdog_print_lock);
-			bust_spinlocks(0);
+			watchdog_alert_counter[cpu]++;
+			if (watchdog_alert_counter[cpu] == 5 * watchdog_hz) {
+				spin_lock(&watchdog_print_lock);
+				/*
+				 * We are in trouble anyway, lets at least try
+				 * to get a message out.
+				 */
+				bust_spinlocks(1);
+				printk(KERN_ERR
+				       "NMI Watchdog detected LOCKUP on CPU%d,"
+				       " pc %08lx, registers:\n",
+				       cpu, regs->pc);
+#ifdef CONFIG_SMP
+				printk(KERN_ERR
+				       "--- Register Dump (CPU%d) ---\n",
+				       CPUID);
+#endif
+				show_registers(regs);
+#ifdef CONFIG_SMP
+				smp_nmi_call_function(watchdog_dump_register,
+					NULL, 1);
+#endif
+				printk(KERN_NOTICE "console shuts up ...\n");
+				console_silent();
+				spin_unlock(&watchdog_print_lock);
+				bust_spinlocks(0);
 #ifdef CONFIG_GDBSTUB
-			if (gdbstub_busy)
-				gdbstub_exception(regs, excep);
-			else
-				gdbstub_intercept(regs, excep);
+				if (CHK_GDBSTUB_BUSY_AND_ACTIVE())
+					gdbstub_exception(regs, excep);
+				else
+					gdbstub_intercept(regs, excep);
 #endif
-			do_exit(SIGSEGV);
+				do_exit(SIGSEGV);
+			}
+		} else {
+			last_irq_sums[cpu] = sum;
+			watchdog_alert_counter[cpu] = 0;
 		}
-	} else {
-		last_irq_sums[cpu] = sum;
-		watchdog_alert_counter = 0;
 	}
 
 	WDCTR = wdt | WDCTR_WDRST;
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 243e33c..b2e85ed 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -57,6 +57,7 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
+#if !defined(CONFIG_SMP) || defined(CONFIG_HOTPLUG_CPU)
 /*
  * we use this if we don't have any better idle routine
  */
@@ -69,6 +70,35 @@ static void default_idle(void)
 		local_irq_enable();
 }
 
+#else /* !CONFIG_SMP || CONFIG_HOTPLUG_CPU  */
+/*
+ * On SMP it's slightly faster (but much more power-consuming!)
+ * to poll the ->work.need_resched flag instead of waiting for the
+ * cross-CPU IPI to arrive. Use this option with caution.
+ */
+static inline void poll_idle(void)
+{
+	int oldval;
+
+	local_irq_enable();
+
+	/*
+	 * Deal with another CPU just having chosen a thread to
+	 * run here:
+	 */
+	oldval = test_and_clear_thread_flag(TIF_NEED_RESCHED);
+
+	if (!oldval) {
+		set_thread_flag(TIF_POLLING_NRFLAG);
+		while (!need_resched())
+			cpu_relax();
+		clear_thread_flag(TIF_POLLING_NRFLAG);
+	} else {
+		set_need_resched();
+	}
+}
+#endif /* !CONFIG_SMP || CONFIG_HOTPLUG_CPU */
+
 /*
  * the idle thread
  * - there's no useful work to be done, so just try to conserve power and have
@@ -77,8 +107,6 @@ static void default_idle(void)
  */
 void cpu_idle(void)
 {
-	int cpu = smp_processor_id();
-
 	/* endless idle loop with no priority at all */
 	for (;;) {
 		while (!need_resched()) {
@@ -86,8 +114,13 @@ void cpu_idle(void)
 
 			smp_rmb();
 			idle = pm_idle;
-			if (!idle)
+			if (!idle) {
+#if defined(CONFIG_SMP) && !defined(CONFIG_HOTPLUG_CPU)
+				idle = poll_idle;
+#else  /* CONFIG_SMP && !CONFIG_HOTPLUG_CPU */
 				idle = default_idle;
+#endif /* CONFIG_SMP && !CONFIG_HOTPLUG_CPU */
+			}
 			idle();
 		}
 
@@ -233,7 +266,7 @@ int copy_thread(unsigned long clone_flags,
 	}
 
 	/* set up things up so the scheduler can start the new task */
-	p->thread.__frame = c_kregs;
+	p->thread.frame = c_kregs;
 	p->thread.a3	= (unsigned long) c_kregs;
 	p->thread.sp	= c_ksp;
 	p->thread.pc	= (unsigned long) ret_from_fork;
diff --git a/arch/mn10300/kernel/profile.c b/arch/mn10300/kernel/profile.c
index 20d7d03..4f342f7 100644
--- a/arch/mn10300/kernel/profile.c
+++ b/arch/mn10300/kernel/profile.c
@@ -41,7 +41,7 @@ static __init int profile_init(void)
 	tmp = TM11ICR;
 
 	printk(KERN_INFO "Profiling initiated on timer 11, priority 0, %uHz\n",
-	       mn10300_ioclk / 8 / (TM11BR + 1));
+	       MN10300_IOCLK / 8 / (TM11BR + 1));
 	printk(KERN_INFO "Profile histogram stored %p-%p\n",
 	       prof_buffer, (u8 *)(prof_buffer + prof_len) - 1);
 
diff --git a/arch/mn10300/kernel/rtc.c b/arch/mn10300/kernel/rtc.c
index 4eef0e7..e9e20f9 100644
--- a/arch/mn10300/kernel/rtc.c
+++ b/arch/mn10300/kernel/rtc.c
@@ -20,18 +20,22 @@
 DEFINE_SPINLOCK(rtc_lock);
 EXPORT_SYMBOL(rtc_lock);
 
-/* time for RTC to update itself in ioclks */
-static unsigned long mn10300_rtc_update_period;
-
+/*
+ * Read the current RTC time
+ */
 void read_persistent_clock(struct timespec *ts)
 {
 	struct rtc_time tm;
 
 	get_rtc_time(&tm);
 
-	ts->tv_sec = mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
-		      tm.tm_hour, tm.tm_min, tm.tm_sec);
 	ts->tv_nsec = 0;
+	ts->tv_sec = mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
+			    tm.tm_hour, tm.tm_min, tm.tm_sec);
+
+	/* if rtc is way off in the past, set something reasonable */
+	if (ts->tv_sec < 0)
+		ts->tv_sec = mktime(2009, 1, 1, 12, 0, 0);
 }
 
 /*
@@ -115,39 +119,14 @@ int update_persistent_clock(struct timespec now)
  */
 void __init calibrate_clock(void)
 {
-	unsigned long count0, counth, count1;
 	unsigned char status;
 
 	/* make sure the RTC is running and is set to operate in 24hr mode */
 	status = RTSRC;
 	RTCRB |= RTCRB_SET;
 	RTCRB |= RTCRB_TM_24HR;
+	RTCRB &= ~RTCRB_DM_BINARY;
 	RTCRA |= RTCRA_DVR;
 	RTCRA &= ~RTCRA_DVR;
 	RTCRB &= ~RTCRB_SET;
-
-	/* work out the clock speed by counting clock cycles between ends of
-	 * the RTC update cycle - track the RTC through one complete update
-	 * cycle (1 second)
-	 */
-	startup_timestamp_counter();
-
-	while (!(RTCRA & RTCRA_UIP)) {}
-	while ((RTCRA & RTCRA_UIP)) {}
-
-	count0 = TMTSCBC;
-
-	while (!(RTCRA & RTCRA_UIP)) {}
-
-	counth = TMTSCBC;
-
-	while ((RTCRA & RTCRA_UIP)) {}
-
-	count1 = TMTSCBC;
-
-	shutdown_timestamp_counter();
-
-	MN10300_TSCCLK = count0 - count1; /* the timers count down */
-	mn10300_rtc_update_period = counth - count1;
-	MN10300_TSC_PER_HZ = MN10300_TSCCLK / HZ;
 }
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index d464aff..1251457 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
+#include <linux/cpu.h>
 #include <asm/processor.h>
 #include <linux/console.h>
 #include <asm/uaccess.h>
@@ -30,7 +31,6 @@
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <proc/proc.h>
-#include <asm/busctl-regs.h>
 #include <asm/fpu.h>
 #include <asm/sections.h>
 
@@ -64,11 +64,13 @@ unsigned long memory_size;
 struct thread_info *__current_ti = &init_thread_union.thread_info;
 struct task_struct *__current = &init_task;
 
-#define mn10300_known_cpus 3
+#define mn10300_known_cpus 5
 static const char *const mn10300_cputypes[] = {
-	"am33v1",
-	"am33v2",
-	"am34v1",
+	"am33-1",
+	"am33-2",
+	"am34-1",
+	"am33-3",
+	"am34-2",
 	"unknown"
 };
 
@@ -123,6 +125,7 @@ void __init setup_arch(char **cmdline_p)
 
 	cpu_init();
 	unit_setup();
+	smp_init_cpus();
 	parse_mem_cmdline(cmdline_p);
 
 	init_mm.start_code = (unsigned long)&_text;
@@ -179,7 +182,6 @@ void __init setup_arch(char **cmdline_p)
 void __init cpu_init(void)
 {
 	unsigned long cpurev = CPUREV, type;
-	unsigned long base, size;
 
 	type = (CPUREV & CPUREV_TYPE) >> CPUREV_TYPE_S;
 	if (type > mn10300_known_cpus)
@@ -189,47 +191,46 @@ void __init cpu_init(void)
 	       mn10300_cputypes[type],
 	       (cpurev & CPUREV_REVISION) >> CPUREV_REVISION_S);
 
-	/* determine the memory size and base from the memory controller regs */
-	memory_size = 0;
-
-	base = SDBASE(0);
-	if (base & SDBASE_CE) {
-		size = (base & SDBASE_CBAM) << SDBASE_CBAM_SHIFT;
-		size = ~size + 1;
-		base &= SDBASE_CBA;
+	get_mem_info(&phys_memory_base, &memory_size);
+	phys_memory_end = phys_memory_base + memory_size;
 
-		printk(KERN_INFO "SDRAM[0]: %luMb @%08lx\n", size >> 20, base);
-		memory_size += size;
-		phys_memory_base = base;
-	}
+	fpu_init_state();
+}
 
-	base = SDBASE(1);
-	if (base & SDBASE_CE) {
-		size = (base & SDBASE_CBAM) << SDBASE_CBAM_SHIFT;
-		size = ~size + 1;
-		base &= SDBASE_CBA;
+static struct cpu cpu_devices[NR_CPUS];
 
-		printk(KERN_INFO "SDRAM[1]: %luMb @%08lx\n", size >> 20, base);
-		memory_size += size;
-		if (phys_memory_base == 0)
-			phys_memory_base = base;
-	}
+static int __init topology_init(void)
+{
+	int i;
 
-	phys_memory_end = phys_memory_base + memory_size;
+	for_each_present_cpu(i)
+		register_cpu(&cpu_devices[i], i);
 
-#ifdef CONFIG_FPU
-	fpu_init_state();
-#endif
+	return 0;
 }
 
+subsys_initcall(topology_init);
+
 /*
  * Get CPU information for use by the procfs.
  */
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
+#ifdef CONFIG_SMP
+	struct mn10300_cpuinfo *c = v;
+	unsigned long cpu_id = c - cpu_data;
+	unsigned long cpurev = c->type, type, icachesz, dcachesz;
+#else  /* CONFIG_SMP */
+	unsigned long cpu_id = 0;
 	unsigned long cpurev = CPUREV, type, icachesz, dcachesz;
+#endif /* CONFIG_SMP */
 
-	type = (CPUREV & CPUREV_TYPE) >> CPUREV_TYPE_S;
+#ifdef CONFIG_SMP
+	if (!cpu_online(cpu_id))
+		return 0;
+#endif
+
+	type = (cpurev & CPUREV_TYPE) >> CPUREV_TYPE_S;
 	if (type > mn10300_known_cpus)
 		type = mn10300_known_cpus;
 
@@ -244,13 +245,14 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		1024;
 
 	seq_printf(m,
-		   "processor  : 0\n"
+		   "processor  : %ld\n"
 		   "vendor_id  : Matsushita\n"
 		   "cpu core   : %s\n"
 		   "cpu rev    : %lu\n"
 		   "model name : " PROCESSOR_MODEL_NAME		"\n"
 		   "icache size: %lu\n"
 		   "dcache size: %lu\n",
+		   cpu_id,
 		   mn10300_cputypes[type],
 		   (cpurev & CPUREV_REVISION) >> CPUREV_REVISION_S,
 		   icachesz,
@@ -262,8 +264,13 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		   "bogomips   : %lu.%02lu\n\n",
 		   MN10300_IOCLK / 1000000,
 		   (MN10300_IOCLK / 10000) % 100,
+#ifdef CONFIG_SMP
+		   c->loops_per_jiffy / (500000 / HZ),
+		   (c->loops_per_jiffy / (5000 / HZ)) % 100
+#else  /* CONFIG_SMP */
 		   loops_per_jiffy / (500000 / HZ),
 		   (loops_per_jiffy / (5000 / HZ)) % 100
+#endif /* CONFIG_SMP */
 		   );
 
 	return 0;
diff --git a/arch/mn10300/kernel/smp-low.S b/arch/mn10300/kernel/smp-low.S
new file mode 100644
index 0000000..72938ce
--- /dev/null
+++ b/arch/mn10300/kernel/smp-low.S
@@ -0,0 +1,97 @@
+/* SMP IPI low-level handler
+ *
+ * Copyright (C) 2006-2007 Matsushita Electric Industrial Co., Ltd.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ */
+
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/smp.h>
+#include <asm/system.h>
+#include <asm/thread_info.h>
+#include <asm/cpu-regs.h>
+#include <proc/smp-regs.h>
+#include <asm/asm-offsets.h>
+#include <asm/frame.inc>
+
+	.am33_2
+
+###############################################################################
+#
+# IPI interrupt handler
+#
+###############################################################################
+	.globl mn10300_low_ipi_handler
+mn10300_low_ipi_handler:
+	add	-4,sp
+	mov	d0,(sp)
+	movhu	(IAGR),d0
+	and	IAGR_GN,d0
+	lsr	0x2,d0
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+	cmp	FLUSH_CACHE_IPI,d0
+	beq	mn10300_flush_cache_ipi
+#endif
+	cmp	SMP_BOOT_IRQ,d0
+	beq	mn10300_smp_boot_ipi
+	/* OTHERS */
+	mov	(sp),d0
+	add	4,sp
+#ifdef CONFIG_GDBSTUB
+	jmp	gdbstub_io_rx_handler
+#else
+	jmp	end
+#endif
+
+###############################################################################
+#
+# Cache flush IPI interrupt handler
+#
+###############################################################################
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+mn10300_flush_cache_ipi:
+	mov	(sp),d0
+	add	4,sp
+
+	/* FLUSH_CACHE_IPI */
+	add	-4,sp
+	SAVE_ALL
+	mov	GxICR_DETECT,d2
+	movbu	d2,(GxICR(FLUSH_CACHE_IPI))	# ACK the interrupt
+	movhu	(GxICR(FLUSH_CACHE_IPI)),d2
+	call	smp_cache_interrupt[],0
+	RESTORE_ALL
+	jmp	end
+#endif
+
+###############################################################################
+#
+# SMP boot CPU IPI interrupt handler
+#
+###############################################################################
+mn10300_smp_boot_ipi:
+	/* clear interrupt */
+	movhu	(GxICR(SMP_BOOT_IRQ)),d0
+	and	~GxICR_REQUEST,d0
+	movhu	d0,(GxICR(SMP_BOOT_IRQ))
+	mov	(sp),d0
+	add	4,sp
+
+	# get stack
+	mov	(CPUID),a0
+	add	-1,a0
+	add	a0,a0
+	add	a0,a0
+	mov	(start_stack,a0),a0
+	mov	a0,sp
+	jmp	initialize_secondary
+
+
+# Jump here after RTI to suppress the icache lookahead
+end:
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
new file mode 100644
index 0000000..b80234c
--- /dev/null
+++ b/arch/mn10300/kernel/smp.c
@@ -0,0 +1,1141 @@
+/* SMP support routines.
+ *
+ * Copyright (C) 2006-2008 Panasonic Corporation
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/cpumask.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/profile.h>
+#include <linux/smp.h>
+#include <asm/tlbflush.h>
+#include <asm/system.h>
+#include <asm/bitops.h>
+#include <asm/processor.h>
+#include <asm/bug.h>
+#include <asm/exceptions.h>
+#include <asm/hardirq.h>
+#include <asm/fpu.h>
+#include <asm/mmu_context.h>
+#include <asm/thread_info.h>
+#include <asm/cpu-regs.h>
+#include <asm/intctl-regs.h>
+#include "internal.h"
+
+#ifdef CONFIG_HOTPLUG_CPU
+#include <linux/cpu.h>
+#include <asm/cacheflush.h>
+
+static unsigned long sleep_mode[NR_CPUS];
+
+static void run_sleep_cpu(unsigned int cpu);
+static void run_wakeup_cpu(unsigned int cpu);
+#endif /* CONFIG_HOTPLUG_CPU */
+
+/*
+ * Debug Message function
+ */
+
+#undef DEBUG_SMP
+#ifdef DEBUG_SMP
+#define Dprintk(fmt, ...) printk(KERN_DEBUG fmt, ##__VA_ARGS__)
+#else
+#define Dprintk(fmt, ...) no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
+#endif
+
+/* timeout value in msec for smp_nmi_call_function. zero is no timeout. */
+#define	CALL_FUNCTION_NMI_IPI_TIMEOUT	0
+
+/*
+ * Structure and data for smp_nmi_call_function().
+ */
+struct nmi_call_data_struct {
+	smp_call_func_t	func;
+	void		*info;
+	cpumask_t	started;
+	cpumask_t	finished;
+	int		wait;
+	char		size_alignment[0]
+	__attribute__ ((__aligned__(SMP_CACHE_BYTES)));
+} __attribute__ ((__aligned__(SMP_CACHE_BYTES)));
+
+static DEFINE_SPINLOCK(smp_nmi_call_lock);
+static struct nmi_call_data_struct *nmi_call_data;
+
+/*
+ * Data structures and variables
+ */
+static cpumask_t cpu_callin_map;	/* Bitmask of callin CPUs */
+static cpumask_t cpu_callout_map;	/* Bitmask of callout CPUs */
+cpumask_t cpu_boot_map;			/* Bitmask of boot APs */
+unsigned long start_stack[NR_CPUS - 1];
+
+/*
+ * Per CPU parameters
+ */
+struct mn10300_cpuinfo cpu_data[NR_CPUS] __cacheline_aligned;
+
+static int cpucount;			/* The count of boot CPUs */
+static cpumask_t smp_commenced_mask;
+cpumask_t cpu_initialized __initdata = CPU_MASK_NONE;
+
+/*
+ * Function Prototypes
+ */
+static int do_boot_cpu(int);
+static void smp_show_cpu_info(int cpu_id);
+static void smp_callin(void);
+static void smp_online(void);
+static void smp_store_cpu_info(int);
+static void smp_cpu_init(void);
+static void smp_tune_scheduling(void);
+static void send_IPI_mask(const cpumask_t *cpumask, int irq);
+static void init_ipi(void);
+
+/*
+ * IPI Initialization interrupt definitions
+ */
+static void mn10300_ipi_disable(unsigned int irq);
+static void mn10300_ipi_enable(unsigned int irq);
+static void mn10300_ipi_ack(unsigned int irq);
+static void mn10300_ipi_nop(unsigned int irq);
+
+static struct irq_chip mn10300_ipi_type = {
+	.name		= "cpu_ipi",
+	.disable	= mn10300_ipi_disable,
+	.enable		= mn10300_ipi_enable,
+	.ack		= mn10300_ipi_ack,
+	.eoi		= mn10300_ipi_nop
+};
+
+static irqreturn_t smp_reschedule_interrupt(int irq, void *dev_id);
+static irqreturn_t smp_call_function_interrupt(int irq, void *dev_id);
+static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id);
+
+static struct irqaction reschedule_ipi = {
+	.handler	= smp_reschedule_interrupt,
+	.name		= "smp reschedule IPI"
+};
+static struct irqaction call_function_ipi = {
+	.handler	= smp_call_function_interrupt,
+	.name		= "smp call function IPI"
+};
+static struct irqaction local_timer_ipi = {
+	.handler	= smp_ipi_timer_interrupt,
+	.flags		= IRQF_DISABLED,
+	.name		= "smp local timer IPI"
+};
+
+/**
+ * init_ipi - Initialise the IPI mechanism
+ */
+static void init_ipi(void)
+{
+	unsigned long flags;
+	u16 tmp16;
+
+	/* set up the reschedule IPI */
+	set_irq_chip_and_handler(RESCHEDULE_IPI,
+				 &mn10300_ipi_type, handle_percpu_irq);
+	setup_irq(RESCHEDULE_IPI, &reschedule_ipi);
+	set_intr_level(RESCHEDULE_IPI, RESCHEDULE_GxICR_LV);
+	mn10300_ipi_enable(RESCHEDULE_IPI);
+
+	/* set up the call function IPI */
+	set_irq_chip_and_handler(CALL_FUNC_SINGLE_IPI,
+				 &mn10300_ipi_type, handle_percpu_irq);
+	setup_irq(CALL_FUNC_SINGLE_IPI, &call_function_ipi);
+	set_intr_level(CALL_FUNC_SINGLE_IPI, CALL_FUNCTION_GxICR_LV);
+	mn10300_ipi_enable(CALL_FUNC_SINGLE_IPI);
+
+	/* set up the local timer IPI */
+	set_irq_chip_and_handler(LOCAL_TIMER_IPI,
+				 &mn10300_ipi_type, handle_percpu_irq);
+	setup_irq(LOCAL_TIMER_IPI, &local_timer_ipi);
+	set_intr_level(LOCAL_TIMER_IPI, LOCAL_TIMER_GxICR_LV);
+	mn10300_ipi_enable(LOCAL_TIMER_IPI);
+
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+	/* set up the cache flush IPI */
+	flags = arch_local_cli_save();
+	__set_intr_stub(NUM2EXCEP_IRQ_LEVEL(FLUSH_CACHE_GxICR_LV),
+			mn10300_low_ipi_handler);
+	GxICR(FLUSH_CACHE_IPI) = FLUSH_CACHE_GxICR_LV | GxICR_DETECT;
+	mn10300_ipi_enable(FLUSH_CACHE_IPI);
+	arch_local_irq_restore(flags);
+#endif
+
+	/* set up the NMI call function IPI */
+	flags = arch_local_cli_save();
+	GxICR(CALL_FUNCTION_NMI_IPI) = GxICR_NMI | GxICR_ENABLE | GxICR_DETECT;
+	tmp16 = GxICR(CALL_FUNCTION_NMI_IPI);
+	arch_local_irq_restore(flags);
+
+	/* set up the SMP boot IPI */
+	flags = arch_local_cli_save();
+	__set_intr_stub(NUM2EXCEP_IRQ_LEVEL(SMP_BOOT_GxICR_LV),
+			mn10300_low_ipi_handler);
+	arch_local_irq_restore(flags);
+}
+
+/**
+ * mn10300_ipi_shutdown - Shut down handling of an IPI
+ * @irq: The IPI to be shut down.
+ */
+static void mn10300_ipi_shutdown(unsigned int irq)
+{
+	unsigned long flags;
+	u16 tmp;
+
+	flags = arch_local_cli_save();
+
+	tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_DETECT;
+	tmp = GxICR(irq);
+
+	arch_local_irq_restore(flags);
+}
+
+/**
+ * mn10300_ipi_enable - Enable an IPI
+ * @irq: The IPI to be enabled.
+ */
+static void mn10300_ipi_enable(unsigned int irq)
+{
+	unsigned long flags;
+	u16 tmp;
+
+	flags = arch_local_cli_save();
+
+	tmp = GxICR(irq);
+	GxICR(irq) = (tmp & GxICR_LEVEL) | GxICR_ENABLE;
+	tmp = GxICR(irq);
+
+	arch_local_irq_restore(flags);
+}
+
+/**
+ * mn10300_ipi_disable - Disable an IPI
+ * @irq: The IPI to be disabled.
+ */
+static void mn10300_ipi_disable(unsigned int irq)
+{
+	unsigned long flags;
+	u16 tmp;
+
+	flags = arch_local_cli_save();
+
+	tmp = GxICR(irq);
+	GxICR(irq) = tmp & GxICR_LEVEL;
+	tmp = GxICR(irq);
+
+	arch_local_irq_restore(flags);
+}
+
+/**
+ * mn10300_ipi_ack - Acknowledge an IPI interrupt in the PIC
+ * @irq: The IPI to be acknowledged.
+ *
+ * Clear the interrupt detection flag for the IPI on the appropriate interrupt
+ * channel in the PIC.
+ */
+static void mn10300_ipi_ack(unsigned int irq)
+{
+	unsigned long flags;
+	u16 tmp;
+
+	flags = arch_local_cli_save();
+	GxICR_u8(irq) = GxICR_DETECT;
+	tmp = GxICR(irq);
+	arch_local_irq_restore(flags);
+}
+
+/**
+ * mn10300_ipi_nop - Dummy IPI action
+ * @irq: The IPI to be acted upon.
+ */
+static void mn10300_ipi_nop(unsigned int irq)
+{
+}
+
+/**
+ * send_IPI_mask - Send IPIs to all CPUs in list
+ * @cpumask: The list of CPUs to target.
+ * @irq: The IPI request to be sent.
+ *
+ * Send the specified IPI to all the CPUs in the list, not waiting for them to
+ * finish before returning.  The caller is responsible for synchronisation if
+ * that is needed.
+ */
+static void send_IPI_mask(const cpumask_t *cpumask, int irq)
+{
+	int i;
+	u16 tmp;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		if (cpu_isset(i, *cpumask)) {
+			/* send IPI */
+			tmp = CROSS_GxICR(irq, i);
+			CROSS_GxICR(irq, i) =
+				tmp | GxICR_REQUEST | GxICR_DETECT;
+			tmp = CROSS_GxICR(irq, i); /* flush write buffer */
+		}
+	}
+}
+
+/**
+ * send_IPI_self - Send an IPI to this CPU.
+ * @irq: The IPI request to be sent.
+ *
+ * Send the specified IPI to the current CPU.
+ */
+void send_IPI_self(int irq)
+{
+	send_IPI_mask(cpumask_of(smp_processor_id()), irq);
+}
+
+/**
+ * send_IPI_allbutself - Send IPIs to all the other CPUs.
+ * @irq: The IPI request to be sent.
+ *
+ * Send the specified IPI to all CPUs in the system barring the current one,
+ * not waiting for them to finish before returning.  The caller is responsible
+ * for synchronisation if that is needed.
+ */
+void send_IPI_allbutself(int irq)
+{
+	cpumask_t cpumask;
+
+	cpumask = cpu_online_map;
+	cpu_clear(smp_processor_id(), cpumask);
+	send_IPI_mask(&cpumask, irq);
+}
+
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
+{
+	BUG();
+	/*send_IPI_mask(mask, CALL_FUNCTION_IPI);*/
+}
+
+void arch_send_call_function_single_ipi(int cpu)
+{
+	send_IPI_mask(cpumask_of(cpu), CALL_FUNC_SINGLE_IPI);
+}
+
+/**
+ * smp_send_reschedule - Send reschedule IPI to a CPU
+ * @cpu: The CPU to target.
+ */
+void smp_send_reschedule(int cpu)
+{
+	send_IPI_mask(cpumask_of(cpu), RESCHEDULE_IPI);
+}
+
+/**
+ * smp_nmi_call_function - Send a call function NMI IPI to all CPUs
+ * @func: The function to ask to be run.
+ * @info: The context data to pass to that function.
+ * @wait: If true, wait (atomically) until function is run on all CPUs.
+ *
+ * Send a non-maskable request to all CPUs in the system, requesting them to
+ * run the specified function with the given context data, and, potentially, to
+ * wait for completion of that function on all CPUs.
+ *
+ * Returns 0 if successful, -ETIMEDOUT if we were asked to wait, but hit the
+ * timeout.
+ */
+int smp_nmi_call_function(smp_call_func_t func, void *info, int wait)
+{
+	struct nmi_call_data_struct data;
+	unsigned long flags;
+	unsigned int cnt;
+	int cpus, ret = 0;
+
+	cpus = num_online_cpus() - 1;
+	if (cpus < 1)
+		return 0;
+
+	data.func = func;
+	data.info = info;
+	data.started = cpu_online_map;
+	cpu_clear(smp_processor_id(), data.started);
+	data.wait = wait;
+	if (wait)
+		data.finished = data.started;
+
+	spin_lock_irqsave(&smp_nmi_call_lock, flags);
+	nmi_call_data = &data;
+	smp_mb();
+
+	/* Send a message to all other CPUs and wait for them to respond */
+	send_IPI_allbutself(CALL_FUNCTION_NMI_IPI);
+
+	/* Wait for response */
+	if (CALL_FUNCTION_NMI_IPI_TIMEOUT > 0) {
+		for (cnt = 0;
+		     cnt < CALL_FUNCTION_NMI_IPI_TIMEOUT &&
+			     !cpus_empty(data.started);
+		     cnt++)
+			mdelay(1);
+
+		if (wait && cnt < CALL_FUNCTION_NMI_IPI_TIMEOUT) {
+			for (cnt = 0;
+			     cnt < CALL_FUNCTION_NMI_IPI_TIMEOUT &&
+				     !cpus_empty(data.finished);
+			     cnt++)
+				mdelay(1);
+		}
+
+		if (cnt >= CALL_FUNCTION_NMI_IPI_TIMEOUT)
+			ret = -ETIMEDOUT;
+
+	} else {
+		/* If timeout value is zero, wait until cpumask has been
+		 * cleared */
+		while (!cpus_empty(data.started))
+			barrier();
+		if (wait)
+			while (!cpus_empty(data.finished))
+				barrier();
+	}
+
+	spin_unlock_irqrestore(&smp_nmi_call_lock, flags);
+	return ret;
+}
+
+/**
+ * stop_this_cpu - Callback to stop a CPU.
+ * @unused: Callback context (ignored).
+ */
+void stop_this_cpu(void *unused)
+{
+	static volatile int stopflag;
+	unsigned long flags;
+
+#ifdef CONFIG_GDBSTUB
+	/* In case of single stepping smp_send_stop by other CPU,
+	 * clear procindebug to avoid deadlock.
+	 */
+	atomic_set(&procindebug[smp_processor_id()], 0);
+#endif	/* CONFIG_GDBSTUB */
+
+	flags = arch_local_cli_save();
+	cpu_clear(smp_processor_id(), cpu_online_map);
+
+	while (!stopflag)
+		cpu_relax();
+
+	cpu_set(smp_processor_id(), cpu_online_map);
+	arch_local_irq_restore(flags);
+}
+
+/**
+ * smp_send_stop - Send a stop request to all CPUs.
+ */
+void smp_send_stop(void)
+{
+	smp_nmi_call_function(stop_this_cpu, NULL, 0);
+}
+
+/**
+ * smp_reschedule_interrupt - Reschedule IPI handler
+ * @irq: The interrupt number.
+ * @dev_id: The device ID.
+ *
+ * We need do nothing here, since the scheduling will be effected on our way
+ * back through entry.S.
+ *
+ * Returns IRQ_HANDLED to indicate we handled the interrupt successfully.
+ */
+static irqreturn_t smp_reschedule_interrupt(int irq, void *dev_id)
+{
+	/* do nothing */
+	return IRQ_HANDLED;
+}
+
+/**
+ * smp_call_function_interrupt - Call function IPI handler
+ * @irq: The interrupt number.
+ * @dev_id: The device ID.
+ *
+ * Returns IRQ_HANDLED to indicate we handled the interrupt successfully.
+ */
+static irqreturn_t smp_call_function_interrupt(int irq, void *dev_id)
+{
+	/* generic_smp_call_function_interrupt(); */
+	generic_smp_call_function_single_interrupt();
+	return IRQ_HANDLED;
+}
+
+/**
+ * smp_nmi_call_function_interrupt - Non-maskable call function IPI handler
+ */
+void smp_nmi_call_function_interrupt(void)
+{
+	smp_call_func_t func = nmi_call_data->func;
+	void *info = nmi_call_data->info;
+	int wait = nmi_call_data->wait;
+
+	/* Notify the initiating CPU that I've grabbed the data and am about to
+	 * execute the function
+	 */
+	smp_mb();
+	cpu_clear(smp_processor_id(), nmi_call_data->started);
+	(*func)(info);
+
+	if (wait) {
+		smp_mb();
+		cpu_clear(smp_processor_id(), nmi_call_data->finished);
+	}
+}
+
+/**
+ * smp_ipi_timer_interrupt - Local timer IPI handler
+ * @irq: The interrupt number.
+ * @dev_id: The device ID.
+ *
+ * Returns IRQ_HANDLED to indicate we handled the interrupt successfully.
+ */
+static irqreturn_t smp_ipi_timer_interrupt(int irq, void *dev_id)
+{
+	return local_timer_interrupt();
+}
+
+void __init smp_init_cpus(void)
+{
+	int i;
+	for (i = 0; i < NR_CPUS; i++) {
+		set_cpu_possible(i, true);
+		set_cpu_present(i, true);
+	}
+}
+
+/**
+ * smp_cpu_init - Initialise AP in start_secondary.
+ *
+ * For this Application Processor, set up init_mm, initialise FPU and set
+ * interrupt level 0-6 setting.
+ */
+static void __init smp_cpu_init(void)
+{
+	unsigned long flags;
+	int cpu_id = smp_processor_id();
+	u16 tmp16;
+
+	if (test_and_set_bit(cpu_id, &cpu_initialized)) {
+		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu_id);
+		for (;;)
+			local_irq_enable();
+	}
+	printk(KERN_INFO "Initializing CPU#%d\n", cpu_id);
+
+	atomic_inc(&init_mm.mm_count);
+	current->active_mm = &init_mm;
+	BUG_ON(current->mm);
+
+	enter_lazy_tlb(&init_mm, current);
+
+	/* Force FPU initialization */
+	clear_using_fpu(current);
+
+	GxICR(CALL_FUNC_SINGLE_IPI) = CALL_FUNCTION_GxICR_LV | GxICR_DETECT;
+	mn10300_ipi_enable(CALL_FUNC_SINGLE_IPI);
+
+	GxICR(LOCAL_TIMER_IPI) = LOCAL_TIMER_GxICR_LV | GxICR_DETECT;
+	mn10300_ipi_enable(LOCAL_TIMER_IPI);
+
+	GxICR(RESCHEDULE_IPI) = RESCHEDULE_GxICR_LV | GxICR_DETECT;
+	mn10300_ipi_enable(RESCHEDULE_IPI);
+
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+	GxICR(FLUSH_CACHE_IPI) = FLUSH_CACHE_GxICR_LV | GxICR_DETECT;
+	mn10300_ipi_enable(FLUSH_CACHE_IPI);
+#endif
+
+	mn10300_ipi_shutdown(SMP_BOOT_IRQ);
+
+	/* Set up the non-maskable call function IPI */
+	flags = arch_local_cli_save();
+	GxICR(CALL_FUNCTION_NMI_IPI) = GxICR_NMI | GxICR_ENABLE | GxICR_DETECT;
+	tmp16 = GxICR(CALL_FUNCTION_NMI_IPI);
+	arch_local_irq_restore(flags);
+}
+
+/**
+ * smp_prepare_cpu_init - Initialise CPU in startup_secondary
+ *
+ * Set interrupt level 0-6 setting and init ICR of gdbstub.
+ */
+void smp_prepare_cpu_init(void)
+{
+	int loop;
+
+	/* Set the interrupt vector registers */
+	IVAR0 = EXCEP_IRQ_LEVEL0;
+	IVAR1 = EXCEP_IRQ_LEVEL1;
+	IVAR2 = EXCEP_IRQ_LEVEL2;
+	IVAR3 = EXCEP_IRQ_LEVEL3;
+	IVAR4 = EXCEP_IRQ_LEVEL4;
+	IVAR5 = EXCEP_IRQ_LEVEL5;
+	IVAR6 = EXCEP_IRQ_LEVEL6;
+
+	/* Disable all interrupts and set to priority 6 (lowest) */
+	for (loop = 0; loop < GxICR_NUM_IRQS; loop++)
+		GxICR(loop) = GxICR_LEVEL_6 | GxICR_DETECT;
+
+#ifdef CONFIG_GDBSTUB
+	/* initialise GDB-stub */
+	do {
+		unsigned long flags;
+		u16 tmp16;
+
+		flags = arch_local_cli_save();
+		GxICR(GDB_NMI_IPI) = GxICR_NMI | GxICR_ENABLE | GxICR_DETECT;
+		tmp16 = GxICR(GDB_NMI_IPI);
+		arch_local_irq_restore(flags);
+	} while (0);
+#endif
+}
+
+/**
+ * start_secondary - Activate a secondary CPU (AP)
+ * @unused: Thread parameter (ignored).
+ */
+int __init start_secondary(void *unused)
+{
+	smp_cpu_init();
+
+	smp_callin();
+	while (!cpu_isset(smp_processor_id(), smp_commenced_mask))
+		cpu_relax();
+
+	local_flush_tlb();
+	preempt_disable();
+	smp_online();
+
+	cpu_idle();
+	return 0;
+}
+
+/**
+ * smp_prepare_cpus - Boot up secondary CPUs (APs)
+ * @max_cpus: Maximum number of CPUs to boot.
+ *
+ * Call do_boot_cpu, and boot up APs.
+ */
+void __init smp_prepare_cpus(unsigned int max_cpus)
+{
+	int phy_id;
+
+	/* Setup boot CPU information */
+	smp_store_cpu_info(0);
+	smp_tune_scheduling();
+
+	init_ipi();
+
+	/* If SMP should be disabled, then finish */
+	if (max_cpus == 0) {
+		printk(KERN_INFO "SMP mode deactivated.\n");
+		goto smp_done;
+	}
+
+	/* Boot secondary CPUs (for which phy_id > 0) */
+	for (phy_id = 0; phy_id < NR_CPUS; phy_id++) {
+		/* Don't boot primary CPU */
+		if (max_cpus <= cpucount + 1)
+			continue;
+		if (phy_id != 0)
+			do_boot_cpu(phy_id);
+		set_cpu_possible(phy_id, true);
+		smp_show_cpu_info(phy_id);
+	}
+
+smp_done:
+	Dprintk("Boot done.\n");
+}
+
+/**
+ * smp_store_cpu_info - Save a CPU's information
+ * @cpu: The CPU to save for.
+ *
+ * Save boot_cpu_data and jiffy for the specified CPU.
+ */
+static void __init smp_store_cpu_info(int cpu)
+{
+	struct mn10300_cpuinfo *ci = &cpu_data[cpu];
+
+	*ci = boot_cpu_data;
+	ci->loops_per_jiffy = loops_per_jiffy;
+	ci->type = CPUREV;
+}
+
+/**
+ * smp_tune_scheduling - Set time slice value
+ *
+ * Nothing to do here.
+ */
+static void __init smp_tune_scheduling(void)
+{
+}
+
+/**
+ * do_boot_cpu: Boot up one CPU
+ * @phy_id: Physical ID of CPU to boot.
+ *
+ * Send an IPI to a secondary CPU to boot it.  Returns 0 on success, 1
+ * otherwise.
+ */
+static int __init do_boot_cpu(int phy_id)
+{
+	struct task_struct *idle;
+	unsigned long send_status, callin_status;
+	int timeout, cpu_id;
+
+	send_status = GxICR_REQUEST;
+	callin_status = 0;
+	timeout = 0;
+	cpu_id = phy_id;
+
+	cpucount++;
+
+	/* Create idle thread for this CPU */
+	idle = fork_idle(cpu_id);
+	if (IS_ERR(idle))
+		panic("Failed fork for CPU#%d.", cpu_id);
+
+	idle->thread.pc = (unsigned long)start_secondary;
+
+	printk(KERN_NOTICE "Booting CPU#%d\n", cpu_id);
+	start_stack[cpu_id - 1] = idle->thread.sp;
+
+	task_thread_info(idle)->cpu = cpu_id;
+
+	/* Send boot IPI to AP */
+	send_IPI_mask(cpumask_of(phy_id), SMP_BOOT_IRQ);
+
+	Dprintk("Waiting for send to finish...\n");
+
+	/* Wait for AP's IPI receive in 100[ms] */
+	do {
+		udelay(1000);
+		send_status =
+			CROSS_GxICR(SMP_BOOT_IRQ, phy_id) & GxICR_REQUEST;
+	} while (send_status == GxICR_REQUEST && timeout++ < 100);
+
+	Dprintk("Waiting for cpu_callin_map.\n");
+
+	if (send_status == 0) {
+		/* Allow AP to start initializing */
+		cpu_set(cpu_id, cpu_callout_map);
+
+		/* Wait for setting cpu_callin_map */
+		timeout = 0;
+		do {
+			udelay(1000);
+			callin_status = cpu_isset(cpu_id, cpu_callin_map);
+		} while (callin_status == 0 && timeout++ < 5000);
+
+		if (callin_status == 0)
+			Dprintk("Not responding.\n");
+	} else {
+		printk(KERN_WARNING "IPI not delivered.\n");
+	}
+
+	if (send_status == GxICR_REQUEST || callin_status == 0) {
+		cpu_clear(cpu_id, cpu_callout_map);
+		cpu_clear(cpu_id, cpu_callin_map);
+		cpu_clear(cpu_id, cpu_initialized);
+		cpucount--;
+		return 1;
+	}
+	return 0;
+}
+
+/**
+ * smp_show_cpu_info - Show SMP CPU information
+ * @cpu: The CPU of interest.
+ */
+static void __init smp_show_cpu_info(int cpu)
+{
+	struct mn10300_cpuinfo *ci = &cpu_data[cpu];
+
+	printk(KERN_INFO
+	       "CPU#%d : ioclk speed: %lu.%02luMHz : bogomips : %lu.%02lu\n",
+	       cpu,
+	       MN10300_IOCLK / 1000000,
+	       (MN10300_IOCLK / 10000) % 100,
+	       ci->loops_per_jiffy / (500000 / HZ),
+	       (ci->loops_per_jiffy / (5000 / HZ)) % 100);
+}
+
+/**
+ * smp_callin - Set cpu_callin_map of the current CPU ID
+ */
+static void __init smp_callin(void)
+{
+	unsigned long timeout;
+	int cpu;
+
+	cpu = smp_processor_id();
+	timeout = jiffies + (2 * HZ);
+
+	if (cpu_isset(cpu, cpu_callin_map)) {
+		printk(KERN_ERR "CPU#%d already present.\n", cpu);
+		BUG();
+	}
+	Dprintk("CPU#%d waiting for CALLOUT\n", cpu);
+
+	/* Wait for AP startup 2s total */
+	while (time_before(jiffies, timeout)) {
+		if (cpu_isset(cpu, cpu_callout_map))
+			break;
+		cpu_relax();
+	}
+
+	if (!time_before(jiffies, timeout)) {
+		printk(KERN_ERR
+		       "BUG: CPU#%d started up but did not get a callout!\n",
+		       cpu);
+		BUG();
+	}
+
+#ifdef CONFIG_CALIBRATE_DELAY
+	calibrate_delay();		/* Get our bogomips */
+#endif
+
+	/* Save our processor parameters */
+	smp_store_cpu_info(cpu);
+
+	/* Allow the boot processor to continue */
+	cpu_set(cpu, cpu_callin_map);
+}
+
+/**
+ * smp_online - Set cpu_online_map
+ */
+static void __init smp_online(void)
+{
+	int cpu;
+
+	cpu = smp_processor_id();
+
+	local_irq_enable();
+
+	cpu_set(cpu, cpu_online_map);
+	smp_wmb();
+}
+
+/**
+ * smp_cpus_done -
+ * @max_cpus: Maximum CPU count.
+ *
+ * Do nothing.
+ */
+void __init smp_cpus_done(unsigned int max_cpus)
+{
+}
+
+/*
+ * smp_prepare_boot_cpu - Set up stuff for the boot processor.
+ *
+ * Set up the cpu_online_map, cpu_callout_map and cpu_callin_map of the boot
+ * processor (CPU 0).
+ */
+void __devinit smp_prepare_boot_cpu(void)
+{
+	cpu_set(0, cpu_callout_map);
+	cpu_set(0, cpu_callin_map);
+	current_thread_info()->cpu = 0;
+}
+
+/*
+ * initialize_secondary - Initialise a secondary CPU (Application Processor).
+ *
+ * Set SP register and jump to thread's PC address.
+ */
+void initialize_secondary(void)
+{
+	asm volatile (
+		"mov	%0,sp	\n"
+		"jmp	(%1)	\n"
+		:
+		: "a"(current->thread.sp), "a"(current->thread.pc));
+}
+
+/**
+ * __cpu_up - Set smp_commenced_mask for the nominated CPU
+ * @cpu: The target CPU.
+ */
+int __devinit __cpu_up(unsigned int cpu)
+{
+	int timeout;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	if (num_online_cpus() == 1)
+		disable_hlt();
+	if (sleep_mode[cpu])
+		run_wakeup_cpu(cpu);
+#endif /* CONFIG_HOTPLUG_CPU */
+
+	cpu_set(cpu, smp_commenced_mask);
+
+	/* Wait 5s total for a response */
+	for (timeout = 0 ; timeout < 5000 ; timeout++) {
+		if (cpu_isset(cpu, cpu_online_map))
+			break;
+		udelay(1000);
+	}
+
+	BUG_ON(!cpu_isset(cpu, cpu_online_map));
+	return 0;
+}
+
+/**
+ * setup_profiling_timer - Set up the profiling timer
+ * @multiplier - The frequency multiplier to use
+ *
+ * The frequency of the profiling timer can be changed by writing a multiplier
+ * value into /proc/profile.
+ */
+int setup_profiling_timer(unsigned int multiplier)
+{
+	return -EINVAL;
+}
+
+/*
+ * CPU hotplug routines
+ */
+#ifdef CONFIG_HOTPLUG_CPU
+
+static DEFINE_PER_CPU(struct cpu, cpu_devices);
+
+static int __init topology_init(void)
+{
+	int cpu, ret;
+
+	for_each_cpu(cpu) {
+		ret = register_cpu(&per_cpu(cpu_devices, cpu), cpu, NULL);
+		if (ret)
+			printk(KERN_WARNING
+			       "topology_init: register_cpu %d failed (%d)\n",
+			       cpu, ret);
+	}
+	return 0;
+}
+
+subsys_initcall(topology_init);
+
+int __cpu_disable(void)
+{
+	int cpu = smp_processor_id();
+	if (cpu == 0)
+		return -EBUSY;
+
+	migrate_irqs();
+	cpu_clear(cpu, current->active_mm->cpu_vm_mask);
+	return 0;
+}
+
+void __cpu_die(unsigned int cpu)
+{
+	run_sleep_cpu(cpu);
+
+	if (num_online_cpus() == 1)
+		enable_hlt();
+}
+
+#ifdef CONFIG_MN10300_CACHE_ENABLED
+static inline void hotplug_cpu_disable_cache(void)
+{
+	int tmp;
+	asm volatile(
+		"	movhu	(%1),%0	\n"
+		"	and	%2,%0	\n"
+		"	movhu	%0,(%1)	\n"
+		"1:	movhu	(%1),%0	\n"
+		"	btst	%3,%0	\n"
+		"	bne	1b	\n"
+		: "=&r"(tmp)
+		: "a"(&CHCTR),
+		  "i"(~(CHCTR_ICEN | CHCTR_DCEN)),
+		  "i"(CHCTR_ICBUSY | CHCTR_DCBUSY)
+		: "memory", "cc");
+}
+
+static inline void hotplug_cpu_enable_cache(void)
+{
+	int tmp;
+	asm volatile(
+		"movhu	(%1),%0	\n"
+		"or	%2,%0	\n"
+		"movhu	%0,(%1)	\n"
+		: "=&r"(tmp)
+		: "a"(&CHCTR),
+		  "i"(CHCTR_ICEN | CHCTR_DCEN)
+		: "memory", "cc");
+}
+
+static inline void hotplug_cpu_invalidate_cache(void)
+{
+	int tmp;
+	asm volatile (
+		"movhu	(%1),%0	\n"
+		"or	%2,%0	\n"
+		"movhu	%0,(%1)	\n"
+		: "=&r"(tmp)
+		: "a"(&CHCTR),
+		  "i"(CHCTR_ICINV | CHCTR_DCINV)
+		: "cc");
+}
+
+#else /* CONFIG_MN10300_CACHE_ENABLED */
+#define hotplug_cpu_disable_cache()	do {} while (0)
+#define hotplug_cpu_enable_cache()	do {} while (0)
+#define hotplug_cpu_invalidate_cache()	do {} while (0)
+#endif /* CONFIG_MN10300_CACHE_ENABLED */
+
+/**
+ * hotplug_cpu_nmi_call_function - Call a function on other CPUs for hotplug
+ * @cpumask: List of target CPUs.
+ * @func: The function to call on those CPUs.
+ * @info: The context data for the function to be called.
+ * @wait: Whether to wait for the calls to complete.
+ *
+ * Non-maskably call a function on another CPU for hotplug purposes.
+ *
+ * This function must be called with maskable interrupts disabled.
+ */
+static int hotplug_cpu_nmi_call_function(cpumask_t cpumask,
+					 smp_call_func_t func, void *info,
+					 int wait)
+{
+	/*
+	 * The address and the size of nmi_call_func_mask_data
+	 * need to be aligned on L1_CACHE_BYTES.
+	 */
+	static struct nmi_call_data_struct nmi_call_func_mask_data
+		__cacheline_aligned;
+	unsigned long start, end;
+
+	start = (unsigned long)&nmi_call_func_mask_data;
+	end = start + sizeof(struct nmi_call_data_struct);
+
+	nmi_call_func_mask_data.func = func;
+	nmi_call_func_mask_data.info = info;
+	nmi_call_func_mask_data.started = cpumask;
+	nmi_call_func_mask_data.wait = wait;
+	if (wait)
+		nmi_call_func_mask_data.finished = cpumask;
+
+	spin_lock(&smp_nmi_call_lock);
+	nmi_call_data = &nmi_call_func_mask_data;
+	mn10300_local_dcache_flush_range(start, end);
+	smp_wmb();
+
+	send_IPI_mask(cpumask, CALL_FUNCTION_NMI_IPI);
+
+	do {
+		mn10300_local_dcache_inv_range(start, end);
+		barrier();
+	} while (!cpus_empty(nmi_call_func_mask_data.started));
+
+	if (wait) {
+		do {
+			mn10300_local_dcache_inv_range(start, end);
+			barrier();
+		} while (!cpus_empty(nmi_call_func_mask_data.finished));
+	}
+
+	spin_unlock(&smp_nmi_call_lock);
+	return 0;
+}
+
+static void restart_wakeup_cpu(void)
+{
+	unsigned int cpu = smp_processor_id();
+
+	cpu_set(cpu, cpu_callin_map);
+	local_flush_tlb();
+	cpu_set(cpu, cpu_online_map);
+	smp_wmb();
+}
+
+static void prepare_sleep_cpu(void *unused)
+{
+	sleep_mode[smp_processor_id()] = 1;
+	smp_mb();
+	mn10300_local_dcache_flush_inv();
+	hotplug_cpu_disable_cache();
+	hotplug_cpu_invalidate_cache();
+}
+
+/* when this function called, IE=0, NMID=0. */
+static void sleep_cpu(void *unused)
+{
+	unsigned int cpu_id = smp_processor_id();
+	/*
+	 * CALL_FUNCTION_NMI_IPI for wakeup_cpu() shall not be requested,
+	 * before this cpu goes in SLEEP mode.
+	 */
+	do {
+		smp_mb();
+		__sleep_cpu();
+	} while (sleep_mode[cpu_id]);
+	restart_wakeup_cpu();
+}
+
+static void run_sleep_cpu(unsigned int cpu)
+{
+	unsigned long flags;
+	cpumask_t cpumask = cpumask_of(cpu);
+
+	flags = arch_local_cli_save();
+	hotplug_cpu_nmi_call_function(cpumask, prepare_sleep_cpu, NULL, 1);
+	hotplug_cpu_nmi_call_function(cpumask, sleep_cpu, NULL, 0);
+	udelay(1);		/* delay for the cpu to sleep. */
+	arch_local_irq_restore(flags);
+}
+
+static void wakeup_cpu(void)
+{
+	hotplug_cpu_invalidate_cache();
+	hotplug_cpu_enable_cache();
+	smp_mb();
+	sleep_mode[smp_processor_id()] = 0;
+}
+
+static void run_wakeup_cpu(unsigned int cpu)
+{
+	unsigned long flags;
+
+	flags = arch_local_cli_save();
+#if NR_CPUS == 2
+	mn10300_local_dcache_flush_inv();
+#else
+	/*
+	 * Before waking up the cpu,
+	 * all online cpus should stop and flush D-Cache for global data.
+	 */
+#error not support NR_CPUS > 2, when CONFIG_HOTPLUG_CPU=y.
+#endif
+	hotplug_cpu_nmi_call_function(cpumask_of(cpu), wakeup_cpu, NULL, 1);
+	arch_local_irq_restore(flags);
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/arch/mn10300/kernel/switch_to.S b/arch/mn10300/kernel/switch_to.S
index 630aad7..b08cb2e 100644
--- a/arch/mn10300/kernel/switch_to.S
+++ b/arch/mn10300/kernel/switch_to.S
@@ -15,6 +15,9 @@
 #include <linux/linkage.h>
 #include <asm/thread_info.h>
 #include <asm/cpu-regs.h>
+#ifdef CONFIG_SMP
+#include <proc/smp-regs.h>
+#endif /* CONFIG_SMP */
 
 	.text
 
@@ -35,7 +38,14 @@ ENTRY(__switch_to)
 	mov	d1,a1
 
 	# save prev context
+#ifdef CONFIG_SMP
+	mov	(CPUID),a2
+	add	a2,a2
+	add	a2,a2
+	mov	(___frame,a2),d0
+#else  /* CONFIG_SMP */
 	mov	(__frame),d0
+#endif /* CONFIG_SMP */
 	mov	d0,(THREAD_FRAME,a0)
 	mov	__switch_back,d0
 	mov	d0,(THREAD_PC,a0)
@@ -59,7 +69,14 @@ ENTRY(__switch_to)
 #endif
 
 	mov	(THREAD_FRAME,a1),a2
+#ifdef CONFIG_SMP
+	mov	(CPUID),a0
+	add	a0,a0
+	add	a0,a0
+	mov	a2,(___frame,a0)
+#else  /* CONFIG_SMP */
 	mov	a2,(__frame)
+#endif /* CONFIG_SMP */
 	mov	(THREAD_PC,a1),a2
 	mov	d2,d0			# for ret_from_fork
 	mov	d0,a0			# for __switch_to
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 0b5c856..0cb9bdb 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -22,12 +22,7 @@
 #include <asm/processor.h>
 #include <asm/intctl-regs.h>
 #include <asm/rtc.h>
-
-#ifdef CONFIG_MN10300_RTC
-unsigned long mn10300_ioclk;		/* system I/O clock frequency */
-unsigned long mn10300_iobclk;		/* system I/O clock frequency */
-unsigned long mn10300_tsc_per_HZ;	/* number of ioclks per jiffy */
-#endif /* CONFIG_MN10300_RTC */
+#include "internal.h"
 
 static unsigned long mn10300_last_tsc;	/* time-stamp counter at last time
 					 * interrupt occurred */
@@ -95,6 +90,19 @@ static void __init mn10300_sched_clock_init(void)
 		__muldiv64u(NSEC_PER_SEC, 1 << 16, MN10300_TSCCLK);
 }
 
+/**
+ * local_timer_interrupt - Local timer interrupt handler
+ *
+ * Handle local timer interrupts for this CPU.  They may have been propagated
+ * to this CPU from the CPU that actually gets them by way of an IPI.
+ */
+irqreturn_t local_timer_interrupt(void)
+{
+	profile_tick(CPU_PROFILING);
+	update_process_times(user_mode(get_irq_regs()));
+	return IRQ_HANDLED;
+}
+
 /*
  * advance the kernel's time keeping clocks (xtime and jiffies)
  * - we use Timer 0 & 1 cascaded as a clock to nudge us the next time
@@ -103,6 +111,7 @@ static void __init mn10300_sched_clock_init(void)
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	unsigned tsc, elapse;
+	irqreturn_t ret;
 
 	write_seqlock(&xtime_lock);
 
@@ -114,15 +123,16 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		mn10300_last_tsc -= MN10300_TSC_PER_HZ;
 
 		/* advance the kernel's time tracking system */
-		profile_tick(CPU_PROFILING);
 		do_timer(1);
 	}
 
 	write_sequnlock(&xtime_lock);
 
-	update_process_times(user_mode(get_irq_regs()));
-
-	return IRQ_HANDLED;
+	ret = local_timer_interrupt();
+#ifdef CONFIG_SMP
+	send_IPI_allbutself(LOCAL_TIMER_IPI);
+#endif
+	return ret;
 }
 
 /*
@@ -148,7 +158,7 @@ void __init time_init(void)
 	/* use timer 0 & 1 cascaded to tick at as close to HZ as possible */
 	setup_irq(TMJCIRQ, &timer_irq);
 
-	set_intr_level(TMJCIRQ, TMJCICR_LEVEL);
+	set_intr_level(TMJCIRQ, NUM2GxICR_LEVEL(CONFIG_TIMER_IRQ_LEVEL));
 
 	startup_jiffies_counter();
 
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 716a221..c924a1d 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -45,8 +45,13 @@
 #error "INTERRUPT_VECTOR_BASE not aligned to 16MiB boundary!"
 #endif
 
+#ifdef CONFIG_SMP
+struct pt_regs *___frame[NR_CPUS]; /* current frame pointer */
+EXPORT_SYMBOL(___frame);
+#else  /* CONFIG_SMP */
 struct pt_regs *__frame; /* current frame pointer */
 EXPORT_SYMBOL(__frame);
+#endif /* CONFIG_SMP */
 
 int kstack_depth_to_print = 24;
 
@@ -221,11 +226,14 @@ void show_registers_only(struct pt_regs *regs)
 	printk(KERN_EMERG "threadinfo=%p task=%p)\n",
 	       current_thread_info(), current);
 
-	if ((unsigned long) current >= 0x90000000UL &&
-	    (unsigned long) current < 0x94000000UL)
+	if ((unsigned long) current >= PAGE_OFFSET &&
+	    (unsigned long) current < (unsigned long)high_memory)
 		printk(KERN_EMERG "Process %s (pid: %d)\n",
 		       current->comm, current->pid);
 
+#ifdef CONFIG_SMP
+	printk(KERN_EMERG "CPUID:  %08x\n", CPUID);
+#endif
 	printk(KERN_EMERG "CPUP:   %04hx\n", CPUP);
 	printk(KERN_EMERG "TBR:    %08x\n", TBR);
 	printk(KERN_EMERG "DEAR:   %08x\n", DEAR);
@@ -521,8 +529,12 @@ void __init set_intr_stub(enum exception_code code, void *handler)
 {
 	unsigned long addr;
 	u8 *vector = (u8 *)(CONFIG_INTERRUPT_VECTOR_BASE + code);
+	unsigned long flags;
 
 	addr = (unsigned long) handler - (unsigned long) vector;
+
+	flags = arch_local_cli_save();
+
 	vector[0] = 0xdc;		/* JMP handler */
 	vector[1] = addr;
 	vector[2] = addr >> 8;
@@ -532,6 +544,8 @@ void __init set_intr_stub(enum exception_code code, void *handler)
 	vector[6] = 0xcb;
 	vector[7] = 0xcb;
 
+	arch_local_irq_restore(flags);
+
 #ifndef CONFIG_MN10300_CACHE_SNOOP
 	mn10300_dcache_flush_inv();
 	mn10300_icache_inv();
diff --git a/arch/mn10300/lib/delay.c b/arch/mn10300/lib/delay.c
index fdf6f71..8e7ceb8 100644
--- a/arch/mn10300/lib/delay.c
+++ b/arch/mn10300/lib/delay.c
@@ -38,14 +38,14 @@ EXPORT_SYMBOL(__delay);
  */
 void __udelay(unsigned long usecs)
 {
-	signed long ioclk, stop;
+	unsigned long start, stop, cnt;
 
 	/* usecs * CLK / 1E6 */
 	stop = __muldiv64u(usecs, MN10300_TSCCLK, 1000000);
-	stop = TMTSCBC - stop;
+	start = TMTSCBC;
 
 	do {
-		ioclk = TMTSCBC;
-	} while (stop < ioclk);
+		cnt = start - TMTSCBC;
+	} while (cnt < stop);
 }
 EXPORT_SYMBOL(__udelay);
diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 906e4c8..59c3da4 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -39,10 +39,6 @@ void bust_spinlocks(int yes)
 {
 	if (yes) {
 		oops_in_progress = 1;
-#ifdef CONFIG_SMP
-		/* Many serial drivers do __global_cli() */
-		global_irq_lock = 0;
-#endif
 	} else {
 		int loglevel_save = console_loglevel;
 #ifdef CONFIG_VT
@@ -334,10 +330,10 @@ no_context:
  */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	if ((fault_code & MMUFCR_xFC_ACCESS) != MMUFCR_xFC_ACCESS_USR)
-		goto no_context;
-	pagefault_out_of_memory();
-	return;
+	printk(KERN_ALERT "VM: killing process %s\n", tsk->comm);
+	if ((fault_code & MMUFCR_xFC_ACCESS) == MMUFCR_xFC_ACCESS_USR)
+		do_exit(SIGKILL);
+	goto no_context;
 
 do_sigbus:
 	up_read(&mm->mmap_sem);
diff --git a/arch/mn10300/proc-mn103e010/include/proc/clock.h b/arch/mn10300/proc-mn103e010/include/proc/clock.h
index aa23e14..704a819 100644
--- a/arch/mn10300/proc-mn103e010/include/proc/clock.h
+++ b/arch/mn10300/proc-mn103e010/include/proc/clock.h
@@ -13,6 +13,4 @@
 
 #include <unit/clock.h>
 
-#define MN10300_WDCLK		MN10300_IOCLK
-
 #endif /* _ASM_PROC_CLOCK_H */
diff --git a/arch/mn10300/proc-mn103e010/include/proc/intctl-regs.h b/arch/mn10300/proc-mn103e010/include/proc/intctl-regs.h
new file mode 100644
index 0000000..f537801
--- /dev/null
+++ b/arch/mn10300/proc-mn103e010/include/proc/intctl-regs.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_PROC_INTCTL_REGS_H
+#define _ASM_PROC_INTCTL_REGS_H
+
+#ifndef _ASM_INTCTL_REGS_H
+# error "please don't include this file directly"
+#endif
+
+/* intr acceptance group reg */
+#define IAGR			__SYSREG(0xd4000100, u16)
+
+/* group number register */
+#define IAGR_GN			0x00fc
+
+#define __GET_XIRQ_TRIGGER(X, Z) (((Z) >> ((X) * 2)) & 3)
+
+#define __SET_XIRQ_TRIGGER(X, Y, Z)		\
+({						\
+	typeof(Z) x = (Z);			\
+	x &= ~(3 << ((X) * 2));			\
+	x |= ((Y) & 3) << ((X) * 2);		\
+	(Z) = x;				\
+})
+
+/* external pin intr spec reg */
+#define EXTMD			__SYSREG(0xd4000200, u16)
+#define GET_XIRQ_TRIGGER(X)	__GET_XIRQ_TRIGGER(X, EXTMD)
+#define SET_XIRQ_TRIGGER(X, Y)	__SET_XIRQ_TRIGGER(X, Y, EXTMD)
+
+#endif /* _ASM_PROC_INTCTL_REGS_H */
diff --git a/arch/mn10300/proc-mn103e010/proc-init.c b/arch/mn10300/proc-mn103e010/proc-init.c
index 0cee787..27b9798 100644
--- a/arch/mn10300/proc-mn103e010/proc-init.c
+++ b/arch/mn10300/proc-mn103e010/proc-init.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <asm/fpu.h>
 #include <asm/rtc.h>
+#include <asm/busctl-regs.h>
 
 /*
  * initialise the on-silicon processor peripherals
@@ -75,3 +76,37 @@ asmlinkage void __init processor_init(void)
 
 	calibrate_clock();
 }
+
+/*
+ * determine the memory size and base from the memory controller regs
+ */
+void __init get_mem_info(unsigned long *mem_base, unsigned long *mem_size)
+{
+	unsigned long base, size;
+
+	*mem_base = 0;
+	*mem_size = 0;
+
+	base = SDBASE(0);
+	if (base & SDBASE_CE) {
+		size = (base & SDBASE_CBAM) << SDBASE_CBAM_SHIFT;
+		size = ~size + 1;
+		base &= SDBASE_CBA;
+
+		printk(KERN_INFO "SDRAM[0]: %luMb @%08lx\n", size >> 20, base);
+		*mem_size += size;
+		*mem_base = base;
+	}
+
+	base = SDBASE(1);
+	if (base & SDBASE_CE) {
+		size = (base & SDBASE_CBAM) << SDBASE_CBAM_SHIFT;
+		size = ~size + 1;
+		base &= SDBASE_CBA;
+
+		printk(KERN_INFO "SDRAM[1]: %luMb @%08lx\n", size >> 20, base);
+		*mem_size += size;
+		if (*mem_base == 0)
+			*mem_base = base;
+	}
+}
diff --git a/arch/mn10300/proc-mn2ws0050/Makefile b/arch/mn10300/proc-mn2ws0050/Makefile
new file mode 100644
index 0000000..d4ca133
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the linux kernel.
+#
+
+obj-y   := proc-init.o
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/cache.h b/arch/mn10300/proc-mn2ws0050/include/proc/cache.h
new file mode 100644
index 0000000..cafd7b5
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/cache.h
@@ -0,0 +1,48 @@
+/* Cache specification
+ *
+ * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Modified by Matsushita Electric Industrial Co., Ltd.
+ * Modifications:
+ *  13-Nov-2006 MEI Add L1_CACHE_SHIFT_MAX definition.
+ *  29-Jul-2008 MEI Add define for MN10300_HAS_AREAPURGE_REG.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_PROC_CACHE_H
+#define _ASM_PROC_CACHE_H
+
+/*
+ * L1 cache
+ */
+#define L1_CACHE_NWAYS		4		/* number of ways in caches */
+#define L1_CACHE_NENTRIES	128		/* number of entries in each way */
+#define L1_CACHE_BYTES		32		/* bytes per entry */
+#define L1_CACHE_SHIFT		5		/* shift for bytes per entry */
+#define L1_CACHE_WAYDISP	0x1000		/* distance from one way to the next */
+
+#define L1_CACHE_TAG_VALID	0x00000001	/* cache tag valid bit */
+#define L1_CACHE_TAG_DIRTY	0x00000008	/* data cache tag dirty bit */
+#define L1_CACHE_TAG_ENTRY	0x00000fe0	/* cache tag entry address mask */
+#define L1_CACHE_TAG_ADDRESS	0xfffff000	/* cache tag line address mask */
+
+/*
+ * specification of the interval between interrupt checking intervals whilst
+ * managing the cache with the interrupts disabled
+ */
+#define MN10300_DCACHE_INV_RANGE_INTR_LOG2_INTERVAL	4
+
+/*
+ * The size of range at which it becomes more economical to just flush the
+ * whole cache rather than trying to flush the specified range.
+ */
+#define MN10300_DCACHE_FLUSH_BORDER \
+	+(L1_CACHE_NWAYS * L1_CACHE_NENTRIES * L1_CACHE_BYTES)
+#define MN10300_DCACHE_FLUSH_INV_BORDER	\
+	+(L1_CACHE_NWAYS * L1_CACHE_NENTRIES * L1_CACHE_BYTES)
+
+#endif /* _ASM_PROC_CACHE_H */
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/clock.h b/arch/mn10300/proc-mn2ws0050/include/proc/clock.h
new file mode 100644
index 0000000..fe4c0a4
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/clock.h
@@ -0,0 +1,20 @@
+/* clock.h: proc-specific clocks
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Modified by Matsushita Electric Industrial Co., Ltd.
+ * Modifications:
+ *  23-Feb-2007 MEI Delete define for watchdog timer.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_PROC_CLOCK_H
+#define _ASM_PROC_CLOCK_H
+
+#include <unit/clock.h>
+
+#endif /* _ASM_PROC_CLOCK_H */
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/dmactl-regs.h b/arch/mn10300/proc-mn2ws0050/include/proc/dmactl-regs.h
new file mode 100644
index 0000000..4c4319e
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/dmactl-regs.h
@@ -0,0 +1,103 @@
+/* MN2WS0050 on-board DMA controller registers
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_PROC_DMACTL_REGS_H
+#define _ASM_PROC_DMACTL_REGS_H
+
+#include <asm/cpu-regs.h>
+
+#ifdef __KERNEL__
+
+/* DMA registers */
+#define	DMxCTR(N)		__SYSREG(0xd4005000+(N*0x100), u32)	/* control reg */
+#define	DMxCTR_BG		0x0000001f	/* transfer request source */
+#define	DMxCTR_BG_SOFT		0x00000000	/* - software source */
+#define	DMxCTR_BG_SC0TX		0x00000002	/* - serial port 0 transmission */
+#define	DMxCTR_BG_SC0RX		0x00000003	/* - serial port 0 reception */
+#define	DMxCTR_BG_SC1TX		0x00000004	/* - serial port 1 transmission */
+#define	DMxCTR_BG_SC1RX		0x00000005	/* - serial port 1 reception */
+#define	DMxCTR_BG_SC2TX		0x00000006	/* - serial port 2 transmission */
+#define	DMxCTR_BG_SC2RX		0x00000007	/* - serial port 2 reception */
+#define	DMxCTR_BG_TM0UFLOW	0x00000008	/* - timer 0 underflow */
+#define	DMxCTR_BG_TM1UFLOW	0x00000009	/* - timer 1 underflow */
+#define	DMxCTR_BG_TM2UFLOW	0x0000000a	/* - timer 2 underflow */
+#define	DMxCTR_BG_TM3UFLOW	0x0000000b	/* - timer 3 underflow */
+#define	DMxCTR_BG_TM6ACMPCAP	0x0000000c	/* - timer 6A compare/capture */
+#define	DMxCTR_BG_RYBY		0x0000000d	/* - NAND Flash RY/BY request source */
+#define	DMxCTR_BG_RMC		0x0000000e	/* - remote controller output */
+#define	DMxCTR_BG_XIRQ12	0x00000011	/* - XIRQ12 pin interrupt source */
+#define	DMxCTR_BG_XIRQ13	0x00000012	/* - XIRQ13 pin interrupt source */
+#define	DMxCTR_BG_TCK		0x00000014	/* - tick timer underflow */
+#define	DMxCTR_BG_SC4TX		0x00000019	/* - serial port4 transmission */
+#define	DMxCTR_BG_SC4RX		0x0000001a	/* - serial port4 reception */
+#define	DMxCTR_BG_SC5TX		0x0000001b	/* - serial port5 transmission */
+#define	DMxCTR_BG_SC5RX		0x0000001c	/* - serial port5 reception */
+#define	DMxCTR_BG_SC6TX		0x0000001d	/* - serial port6 transmission */
+#define	DMxCTR_BG_SC6RX		0x0000001e	/* - serial port6 reception */
+#define	DMxCTR_BG_TMSUFLOW	0x0000001f	/* - timestamp timer underflow */
+#define	DMxCTR_SAM		0x00000060	/* DMA transfer src addr mode */
+#define	DMxCTR_SAM_INCR		0x00000000	/* - increment */
+#define	DMxCTR_SAM_DECR		0x00000020	/* - decrement */
+#define	DMxCTR_SAM_FIXED	0x00000040	/* - fixed */
+#define	DMxCTR_DAM		0x00000300	/* DMA transfer dest addr mode */
+#define	DMxCTR_DAM_INCR		0x00000000	/* - increment */
+#define	DMxCTR_DAM_DECR		0x00000100	/* - decrement */
+#define	DMxCTR_DAM_FIXED	0x00000200	/* - fixed */
+#define	DMxCTR_UT		0x00006000	/* DMA transfer unit */
+#define	DMxCTR_UT_1		0x00000000	/* - 1 byte */
+#define	DMxCTR_UT_2		0x00002000	/* - 2 byte */
+#define	DMxCTR_UT_4		0x00004000	/* - 4 byte */
+#define	DMxCTR_UT_16		0x00006000	/* - 16 byte */
+#define DMxCTR_RRE		0x00008000	/* DMA round robin enable */
+#define	DMxCTR_TEN		0x00010000	/* DMA channel transfer enable */
+#define	DMxCTR_RQM		0x00060000	/* external request input source mode */
+#define	DMxCTR_RQM_FALLEDGE	0x00000000	/* - falling edge */
+#define	DMxCTR_RQM_RISEEDGE	0x00020000	/* - rising edge */
+#define	DMxCTR_RQM_LOLEVEL	0x00040000	/* - low level */
+#define	DMxCTR_RQM_HILEVEL	0x00060000	/* - high level */
+#define	DMxCTR_RQF		0x01000000	/* DMA transfer request flag */
+#define	DMxCTR_PERR		0x40000000	/* DMA transfer parameter error flag */
+#define	DMxCTR_XEND		0x80000000	/* DMA transfer end flag */
+
+#define	DMxSRC(N)		__SYSREG(0xd4005004+(N*0x100), u32)	/* control reg */
+
+#define	DMxDST(N)		__SYSREG(0xd4005008+(N*0x100), u32)	/* source addr reg */
+
+#define	DMxSIZ(N)		__SYSREG(0xd400500c+(N*0x100), u32)	/* dest addr reg */
+#define DMxSIZ_CT		0x000fffff	/* number of bytes to transfer */
+
+#define	DMxCYC(N)		__SYSREG(0xd4005010+(N*0x100), u32)	/* intermittent size reg */
+#define DMxCYC_CYC		0x000000ff	/* number of interrmittent transfers -1 */
+
+#define DM0IRQ			16		/* DMA channel 0 complete IRQ */
+#define DM1IRQ			17		/* DMA channel 1 complete IRQ */
+#define DM2IRQ			18		/* DMA channel 2 complete IRQ */
+#define DM3IRQ			19		/* DMA channel 3 complete IRQ */
+
+#define	DM0ICR			GxICR(DM0IRQ)	/* DMA channel 0 complete intr ctrl reg */
+#define	DM1ICR			GxICR(DM0IR1)	/* DMA channel 1 complete intr ctrl reg */
+#define	DM2ICR			GxICR(DM0IR2)	/* DMA channel 2 complete intr ctrl reg */
+#define	DM3ICR			GxICR(DM0IR3)	/* DMA channel 3 complete intr ctrl reg */
+
+#ifndef __ASSEMBLY__
+
+struct mn10300_dmactl_regs {
+	u32		ctr;
+	const void	*src;
+	void		*dst;
+	u32		siz;
+	u32		cyc;
+} __attribute__((aligned(0x100)));
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_PROC_DMACTL_REGS_H */
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/intctl-regs.h b/arch/mn10300/proc-mn2ws0050/include/proc/intctl-regs.h
new file mode 100644
index 0000000..a1e9772
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/intctl-regs.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_PROC_INTCTL_REGS_H
+#define _ASM_PROC_INTCTL_REGS_H
+
+#ifndef _ASM_INTCTL_REGS_H
+# error "please don't include this file directly"
+#endif
+
+/* intr acceptance group reg */
+#define IAGR			__SYSREG(0xd4000100, u16)
+
+/* group number register */
+#define IAGR_GN			0x003fc
+
+#define __GET_XIRQ_TRIGGER(X, Z) (((Z) >> ((X) * 2)) & 3)
+
+#define __SET_XIRQ_TRIGGER(X, Y, Z)		\
+({						\
+	typeof(Z) x = (Z);			\
+	x &= ~(3 << ((X) * 2));			\
+	x |= ((Y) & 3) << ((X) * 2);		\
+	(Z) = x;				\
+})
+
+/* external pin intr spec reg */
+#define EXTMD0			__SYSREG(0xd4000200, u32)
+#define GET_XIRQ_TRIGGER(X)	__GET_XIRQ_TRIGGER(X, EXTMD0)
+#define SET_XIRQ_TRIGGER(X, Y)	__SET_XIRQ_TRIGGER(X, Y, EXTMD0)
+
+#endif /* _ASM_PROC_INTCTL_REGS_H */
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/irq.h b/arch/mn10300/proc-mn2ws0050/include/proc/irq.h
new file mode 100644
index 0000000..37777a8
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/irq.h
@@ -0,0 +1,49 @@
+/* MN2WS0050 on-board interrupt controller registers
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Modified by Matsushita Electric Industrial Co., Ltd.
+ * Modifications:
+ *  13-Nov-2006 MEI Define extended IRQ number for SMP support.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _PROC_IRQ_H
+#define _PROC_IRQ_H
+
+#ifdef __KERNEL__
+
+#define GxICR_NUM_IRQS		163
+#ifdef CONFIG_SMP
+#define GxICR_NUM_EXT_IRQS	197
+#endif  /* CONFIG_SMP */
+
+#define GxICR_NUM_XIRQS		16
+
+#define XIRQ0		34
+#define XIRQ1		35
+#define XIRQ2		36
+#define XIRQ3		37
+#define XIRQ4		38
+#define XIRQ5		39
+#define XIRQ6		40
+#define XIRQ7		41
+#define XIRQ8		42
+#define XIRQ9		43
+#define XIRQ10		44
+#define XIRQ11		45
+#define XIRQ12		46
+#define XIRQ13		47
+#define XIRQ14		48
+#define XIRQ15		49
+
+#define XIRQ2IRQ(num)	(XIRQ0 + num)
+
+#endif /* __KERNEL__ */
+
+#endif /* _PROC_IRQ_H */
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/nand-regs.h b/arch/mn10300/proc-mn2ws0050/include/proc/nand-regs.h
new file mode 100644
index 0000000..84448f3
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/nand-regs.h
@@ -0,0 +1,120 @@
+/* NAND flash interface register definitions
+ *
+ * Copyright (C) 2008-2009 Panasonic Corporation
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef	_PROC_NAND_REGS_H_
+#define	_PROC_NAND_REGS_H_
+
+/* command register */
+#define FCOMMAND_0		__SYSREG(0xd8f00000, u8) /* fcommand[24:31] */
+#define FCOMMAND_1		__SYSREG(0xd8f00001, u8) /* fcommand[16:23] */
+#define FCOMMAND_2		__SYSREG(0xd8f00002, u8) /* fcommand[8:15] */
+#define FCOMMAND_3		__SYSREG(0xd8f00003, u8) /* fcommand[0:7] */
+
+/* for dma 16 byte trans, use FCOMMAND2 register */
+#define FCOMMAND2_0		__SYSREG(0xd8f00110, u8) /* fcommand2[24:31] */
+#define FCOMMAND2_1		__SYSREG(0xd8f00111, u8) /* fcommand2[16:23] */
+#define FCOMMAND2_2		__SYSREG(0xd8f00112, u8) /* fcommand2[8:15] */
+#define FCOMMAND2_3		__SYSREG(0xd8f00113, u8) /* fcommand2[0:7] */
+
+#define FCOMMAND_FIEN		0x80		/* nand flash I/F enable */
+#define FCOMMAND_BW_8BIT	0x00		/* 8bit bus width */
+#define FCOMMAND_BW_16BIT	0x40		/* 16bit bus width */
+#define FCOMMAND_BLOCKSZ_SMALL	0x00		/* small block */
+#define FCOMMAND_BLOCKSZ_LARGE	0x20		/* large block */
+#define FCOMMAND_DMASTART	0x10		/* dma start */
+#define FCOMMAND_RYBY		0x08		/* ready/busy flag */
+#define FCOMMAND_RYBYINTMSK	0x04		/* mask ready/busy interrupt */
+#define FCOMMAND_XFWP		0x02		/* write protect enable */
+#define FCOMMAND_XFCE		0x01		/* flash device disable */
+#define FCOMMAND_SEQKILL	0x10		/* stop seq-read */
+#define FCOMMAND_ANUM		0x07		/* address cycle */
+#define FCOMMAND_ANUM_NONE	0x00		/* address cycle none */
+#define FCOMMAND_ANUM_1CYC	0x01		/* address cycle 1cycle */
+#define FCOMMAND_ANUM_2CYC	0x02		/* address cycle 2cycle */
+#define FCOMMAND_ANUM_3CYC	0x03		/* address cycle 3cycle */
+#define FCOMMAND_ANUM_4CYC	0x04		/* address cycle 4cycle */
+#define FCOMMAND_ANUM_5CYC	0x05		/* address cycle 5cycle */
+#define FCOMMAND_FCMD_READ0	0x00		/* read1 command */
+#define FCOMMAND_FCMD_SEQIN	0x80		/* page program 1st command */
+#define FCOMMAND_FCMD_PAGEPROG	0x10		/* page program 2nd command */
+#define FCOMMAND_FCMD_RESET	0xff		/* reset command */
+#define FCOMMAND_FCMD_ERASE1	0x60		/* erase 1st command */
+#define FCOMMAND_FCMD_ERASE2	0xd0		/* erase 2nd command */
+#define FCOMMAND_FCMD_STATUS	0x70		/* read status command */
+#define FCOMMAND_FCMD_READID	0x90		/* read id command */
+#define FCOMMAND_FCMD_READOOB	0x50		/* read3 command */
+/* address register */
+#define FADD			__SYSREG(0xd8f00004, u32)
+/* address register 2 */
+#define FADD2			__SYSREG(0xd8f00008, u32)
+/* error judgement register */
+#define FJUDGE			__SYSREG(0xd8f0000c, u32)
+#define FJUDGE_NOERR		0x0		/* no error */
+#define FJUDGE_1BITERR		0x1		/* 1bit error in data area */
+#define FJUDGE_PARITYERR	0x2		/* parity error */
+#define FJUDGE_UNCORRECTABLE	0x3		/* uncorrectable error */
+#define FJUDGE_ERRJDG_MSK	0x3		/* mask of judgement result */
+/* 1st ECC store register */
+#define FECC11			__SYSREG(0xd8f00010, u32)
+/* 2nd ECC store register */
+#define FECC12			__SYSREG(0xd8f00014, u32)
+/* 3rd ECC store register */
+#define FECC21			__SYSREG(0xd8f00018, u32)
+/* 4th ECC store register */
+#define FECC22			__SYSREG(0xd8f0001c, u32)
+/* 5th ECC store register */
+#define FECC31			__SYSREG(0xd8f00020, u32)
+/* 6th ECC store register */
+#define FECC32			__SYSREG(0xd8f00024, u32)
+/* 7th ECC store register */
+#define FECC41			__SYSREG(0xd8f00028, u32)
+/* 8th ECC store register */
+#define FECC42			__SYSREG(0xd8f0002c, u32)
+/* data register */
+#define FDATA			__SYSREG(0xd8f00030, u32)
+/* access pulse register */
+#define FPWS			__SYSREG(0xd8f00100, u32)
+#define FPWS_PWS1W_2CLK		0x00000000 /* write pulse width 1clock */
+#define FPWS_PWS1W_3CLK		0x01000000 /* write pulse width 2clock */
+#define FPWS_PWS1W_4CLK		0x02000000 /* write pulse width 4clock */
+#define FPWS_PWS1W_5CLK		0x03000000 /* write pulse width 5clock */
+#define FPWS_PWS1W_6CLK		0x04000000 /* write pulse width 6clock */
+#define FPWS_PWS1W_7CLK		0x05000000 /* write pulse width 7clock */
+#define FPWS_PWS1W_8CLK		0x06000000 /* write pulse width 8clock */
+#define FPWS_PWS1R_3CLK		0x00010000 /* read pulse width 3clock */
+#define FPWS_PWS1R_4CLK		0x00020000 /* read pulse width 4clock */
+#define FPWS_PWS1R_5CLK		0x00030000 /* read pulse width 5clock */
+#define FPWS_PWS1R_6CLK		0x00040000 /* read pulse width 6clock */
+#define FPWS_PWS1R_7CLK		0x00050000 /* read pulse width 7clock */
+#define FPWS_PWS1R_8CLK		0x00060000 /* read pulse width 8clock */
+#define FPWS_PWS2W_2CLK		0x00000100 /* write pulse interval 2clock */
+#define FPWS_PWS2W_3CLK		0x00000200 /* write pulse interval 3clock */
+#define FPWS_PWS2W_4CLK		0x00000300 /* write pulse interval 4clock */
+#define FPWS_PWS2W_5CLK		0x00000400 /* write pulse interval 5clock */
+#define FPWS_PWS2W_6CLK		0x00000500 /* write pulse interval 6clock */
+#define FPWS_PWS2R_2CLK		0x00000001 /* read pulse interval 2clock */
+#define FPWS_PWS2R_3CLK		0x00000002 /* read pulse interval 3clock */
+#define FPWS_PWS2R_4CLK		0x00000003 /* read pulse interval 4clock */
+#define FPWS_PWS2R_5CLK		0x00000004 /* read pulse interval 5clock */
+#define FPWS_PWS2R_6CLK		0x00000005 /* read pulse interval 6clock */
+/* command register 2 */
+#define FCOMMAND2		__SYSREG(0xd8f00110, u32)
+/* transfer frequency register */
+#define FNUM			__SYSREG(0xd8f00114, u32)
+#define FSDATA_ADDR		0xd8f00400
+/* active data register */
+#define FSDATA			__SYSREG(FSDATA_ADDR, u32)
+
+#endif /* _PROC_NAND_REGS_H_ */
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/proc.h b/arch/mn10300/proc-mn2ws0050/include/proc/proc.h
new file mode 100644
index 0000000..90d5cad
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/proc.h
@@ -0,0 +1,18 @@
+/* proc.h: MN2WS0050 processor description
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROC_PROC_H
+#define _ASM_PROC_PROC_H
+
+#define PROCESSOR_VENDOR_NAME	"Panasonic"
+#define PROCESSOR_MODEL_NAME	"mn2ws0050"
+
+#endif /* _ASM_PROC_PROC_H */
diff --git a/arch/mn10300/proc-mn2ws0050/include/proc/smp-regs.h b/arch/mn10300/proc-mn2ws0050/include/proc/smp-regs.h
new file mode 100644
index 0000000..22f277f
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/include/proc/smp-regs.h
@@ -0,0 +1,51 @@
+/* MN10300/AM33v2 Microcontroller SMP registers
+ *
+ * Copyright (C) 2006 Matsushita Electric Industrial Co., Ltd.
+ * All Rights Reserved.
+ * Created:
+ *  13-Nov-2006 MEI Add extended cache and atomic operation register
+ *                  for SMP support.
+ *  23-Feb-2007 MEI Add define for gdbstub SMP.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROC_SMP_REGS_H
+#define _ASM_PROC_SMP_REGS_H
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+#endif
+#include <asm/cpu-regs.h>
+
+/*
+ * Reference to the interrupt controllers of other CPUs
+ */
+#define CROSS_ICR_CPU_SHIFT	16
+
+#define CROSS_GxICR(X, CPU)	__SYSREG(0xc4000000 + (X) * 4 + \
+	((X) >= 64 && (X) < 192) * 0xf00 + ((CPU) << CROSS_ICR_CPU_SHIFT), u16)
+#define CROSS_GxICR_u8(X, CPU)	__SYSREG(0xc4000000 + (X) * 4 +		\
+	(((X) >= 64) && ((X) < 192)) * 0xf00 + ((CPU) << CROSS_ICR_CPU_SHIFT), u8)
+
+/* CPU ID register */
+#define CPUID		__SYSREGC(0xc0000054, u32)
+#define CPUID_MASK	0x00000007	/* CPU ID mask */
+
+/* extended cache control register */
+#define ECHCTR		__SYSREG(0xc0000c20, u32)
+#define ECHCTR_IBCM	0x00000001	/* instruction cache broad cast mask */
+#define ECHCTR_DBCM	0x00000002	/* data cache broad cast mask */
+#define ECHCTR_ISPM	0x00000004	/* instruction cache snoop mask */
+#define ECHCTR_DSPM	0x00000008	/* data cache snoop mask */
+
+#define NMIAGR		__SYSREG(0xd400013c, u16)
+#define NMIAGR_GN	0x03fc
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_PROC_SMP_REGS_H */
diff --git a/arch/mn10300/proc-mn2ws0050/proc-init.c b/arch/mn10300/proc-mn2ws0050/proc-init.c
new file mode 100644
index 0000000..c58249b
--- /dev/null
+++ b/arch/mn10300/proc-mn2ws0050/proc-init.c
@@ -0,0 +1,134 @@
+/* MN2WS0050 processor initialisation
+ *
+ * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+#include <asm/io.h>
+#include <asm/atomic.h>
+#include <asm/smp.h>
+#include <asm/pgalloc.h>
+#include <asm/busctl-regs.h>
+#include <unit/timex.h>
+#include <asm/fpu.h>
+#include <asm/rtc.h>
+
+#define MEMCONF __SYSREGC(0xdf800400, u32)
+
+/*
+ * initialise the on-silicon processor peripherals
+ */
+asmlinkage void __init processor_init(void)
+{
+	int loop;
+
+	/* set up the exception table first */
+	for (loop = 0x000; loop < 0x400; loop += 8)
+		__set_intr_stub(loop, __common_exception);
+
+	__set_intr_stub(EXCEP_ITLBMISS,		itlb_miss);
+	__set_intr_stub(EXCEP_DTLBMISS,		dtlb_miss);
+	__set_intr_stub(EXCEP_IAERROR,		itlb_aerror);
+	__set_intr_stub(EXCEP_DAERROR,		dtlb_aerror);
+	__set_intr_stub(EXCEP_BUSERROR,		raw_bus_error);
+	__set_intr_stub(EXCEP_DOUBLE_FAULT,	double_fault);
+	__set_intr_stub(EXCEP_FPU_DISABLED,	fpu_disabled);
+	__set_intr_stub(EXCEP_SYSCALL0,		system_call);
+
+	__set_intr_stub(EXCEP_NMI,		nmi_handler);
+	__set_intr_stub(EXCEP_WDT,		nmi_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL0,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL1,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL2,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL3,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL4,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL5,	irq_handler);
+	__set_intr_stub(EXCEP_IRQ_LEVEL6,	irq_handler);
+
+	IVAR0 = EXCEP_IRQ_LEVEL0;
+	IVAR1 = EXCEP_IRQ_LEVEL1;
+	IVAR2 = EXCEP_IRQ_LEVEL2;
+	IVAR3 = EXCEP_IRQ_LEVEL3;
+	IVAR4 = EXCEP_IRQ_LEVEL4;
+	IVAR5 = EXCEP_IRQ_LEVEL5;
+	IVAR6 = EXCEP_IRQ_LEVEL6;
+
+#ifndef CONFIG_MN10300_HAS_CACHE_SNOOP
+	mn10300_dcache_flush_inv();
+	mn10300_icache_inv();
+#endif
+
+	/* disable all interrupts and set to priority 6 (lowest) */
+#ifdef	CONFIG_SMP
+	for (loop = 0; loop < GxICR_NUM_IRQS; loop++)
+		GxICR(loop) = GxICR_LEVEL_6 | GxICR_DETECT;
+#else	/* !CONFIG_SMP */
+	for (loop = 0; loop < NR_IRQS; loop++)
+		GxICR(loop) = GxICR_LEVEL_6 | GxICR_DETECT;
+#endif	/* !CONFIG_SMP */
+
+	/* clear the timers */
+	TM0MD	= 0;
+	TM1MD	= 0;
+	TM2MD	= 0;
+	TM3MD	= 0;
+	TM4MD	= 0;
+	TM5MD	= 0;
+	TM6MD	= 0;
+	TM6MDA	= 0;
+	TM6MDB	= 0;
+	TM7MD	= 0;
+	TM8MD	= 0;
+	TM9MD	= 0;
+	TM10MD	= 0;
+	TM11MD	= 0;
+	TM12MD	= 0;
+	TM13MD	= 0;
+	TM14MD	= 0;
+	TM15MD	= 0;
+
+	calibrate_clock();
+}
+
+/*
+ * determine the memory size and base from the memory controller regs
+ */
+void __init get_mem_info(unsigned long *mem_base, unsigned long *mem_size)
+{
+	unsigned long memconf = MEMCONF;
+	unsigned long size = 0; /* order: MByte */
+
+	*mem_base = 0x90000000; /* fixed address */
+
+	switch (memconf & 0x00000003) {
+	case 0x01:
+		size = 256 / 8;		/* 256 Mbit per chip */
+		break;
+	case 0x02:
+		size = 512 / 8;		/* 512 Mbit per chip */
+		break;
+	case 0x03:
+		size = 1024 / 8;	/*   1 Gbit per chip */
+		break;
+	default:
+		panic("Invalid SDRAM size");
+		break;
+	}
+
+	printk(KERN_INFO "DDR2-SDRAM: %luMB x 2 @%08lx\n", size, *mem_base);
+
+	*mem_size = (size * 2) << 20;
+}
diff --git a/arch/mn10300/unit-asb2303/include/unit/clock.h b/arch/mn10300/unit-asb2303/include/unit/clock.h
index 2a0bf79..0316907 100644
--- a/arch/mn10300/unit-asb2303/include/unit/clock.h
+++ b/arch/mn10300/unit-asb2303/include/unit/clock.h
@@ -14,32 +14,11 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_MN10300_RTC
-
-extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
-extern unsigned long mn10300_iobclk;
-extern unsigned long mn10300_tsc_per_HZ;
-
-#define MN10300_IOCLK		mn10300_ioclk
-/* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	mn10300_iobclk */
-
-#else /* !CONFIG_MN10300_RTC */
-
 #define MN10300_IOCLK		33333333UL
 /* #define MN10300_IOBCLK	66666666UL */
 
-#endif /* !CONFIG_MN10300_RTC */
-
-#define MN10300_JCCLK		MN10300_IOCLK
-#define MN10300_TSCCLK		MN10300_IOCLK
-
-#ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	mn10300_tsc_per_HZ
-#else /* !CONFIG_MN10300_RTC */
-#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
-#endif /* !CONFIG_MN10300_RTC */
-
 #endif /* !__ASSEMBLY__ */
 
+#define MN10300_WDCLK		MN10300_IOCLK
+
 #endif /* _ASM_UNIT_CLOCK_H */
diff --git a/arch/mn10300/unit-asb2303/include/unit/serial.h b/arch/mn10300/unit-asb2303/include/unit/serial.h
index 047566c..991e356 100644
--- a/arch/mn10300/unit-asb2303/include/unit/serial.h
+++ b/arch/mn10300/unit-asb2303/include/unit/serial.h
@@ -22,6 +22,11 @@
 #define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
 
 /*
+ * The ASB2303 has an 18.432 MHz clock the UART
+ */
+#define BASE_BAUD	(18432000 / 16)
+
+/*
  * dispose of the /dev/ttyS0 and /dev/ttyS1 serial ports
  */
 #ifndef CONFIG_GDBSTUB_ON_TTYSx
diff --git a/arch/mn10300/unit-asb2303/include/unit/timex.h b/arch/mn10300/unit-asb2303/include/unit/timex.h
index 88cd96b..d1b8daf 100644
--- a/arch/mn10300/unit-asb2303/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2303/include/unit/timex.h
@@ -1,4 +1,4 @@
-/* ASB2303-specific timer specifcations
+/* ASB2303-specific timer specifications
  *
  * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -17,6 +17,7 @@
 
 #include <asm/timer-regs.h>
 #include <unit/clock.h>
+#include <asm/param.h>
 
 /*
  * jiffies counter specifications
@@ -29,32 +30,43 @@
 #define	TMJCBR			TM01BR
 #define	TMJCIRQ			TM1IRQ
 #define	TMJCICR			TM1ICR
-#define	TMJCICR_LEVEL		GxICR_LEVEL_5
 
 #ifndef __ASSEMBLY__
 
+#define MN10300_SRC_IOCLK	MN10300_IOCLK
+
+#ifndef HZ
+# error HZ undeclared.
+#endif /* !HZ */
+/* use as little prescaling as possible to avoid losing accuracy */
+#if (MN10300_SRC_IOCLK + HZ / 2) / HZ - 1 <= TMJCBR_MAX
+# define IOCLK_PRESCALE		1
+# define JC_TIMER_CLKSRC	TM0MD_SRC_IOCLK
+# define TSC_TIMER_CLKSRC	TM4MD_SRC_IOCLK
+#elif (MN10300_SRC_IOCLK / 8 + HZ / 2) / HZ - 1 <= TMJCBR_MAX
+# define IOCLK_PRESCALE		8
+# define JC_TIMER_CLKSRC	TM0MD_SRC_IOCLK_8
+# define TSC_TIMER_CLKSRC	TM4MD_SRC_IOCLK_8
+#elif (MN10300_SRC_IOCLK / 32 + HZ / 2) / HZ - 1 <= TMJCBR_MAX
+# define IOCLK_PRESCALE		32
+# define JC_TIMER_CLKSRC	TM0MD_SRC_IOCLK_32
+# define TSC_TIMER_CLKSRC	TM4MD_SRC_IOCLK_32
+#else
+# error You lose.
+#endif
+
+#define MN10300_JCCLK		(MN10300_SRC_IOCLK / IOCLK_PRESCALE)
+#define MN10300_TSCCLK		(MN10300_SRC_IOCLK / IOCLK_PRESCALE)
+
+#define MN10300_JC_PER_HZ	((MN10300_JCCLK + HZ / 2) / HZ)
+#define MN10300_TSC_PER_HZ	((MN10300_TSCCLK + HZ / 2) / HZ)
+
 static inline void startup_jiffies_counter(void)
 {
-	unsigned rate;
 	u16 md, t16;
 
-	/* use as little prescaling as possible to avoid losing accuracy */
-	md = TM0MD_SRC_IOCLK;
-	rate = MN10300_JCCLK / HZ;
-
-	if (rate > TMJCBR_MAX) {
-		md = TM0MD_SRC_IOCLK_8;
-		rate = MN10300_JCCLK / 8 / HZ;
-
-		if (rate > TMJCBR_MAX) {
-			md = TM0MD_SRC_IOCLK_32;
-			rate = MN10300_JCCLK / 32 / HZ;
-
-			BUG_ON(rate > TMJCBR_MAX);
-		}
-	}
-
-	TMJCBR = rate - 1;
+	md = JC_TIMER_CLKSRC;
+	TMJCBR = MN10300_JC_PER_HZ - 1;
 	t16 = TMJCBR;
 
 	TMJCMD =
@@ -93,29 +105,39 @@ static inline void shutdown_jiffies_counter(void)
 
 static inline void startup_timestamp_counter(void)
 {
+	u32 t32;
+
 	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
 	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
 	 */
 	TM45BR = TMTSCBR_MAX;
+	t32 = TM45BR;
 
-	TM4MD = TM4MD_SRC_IOCLK;
+	TM4MD = TSC_TIMER_CLKSRC;
 	TM4MD |= TM4MD_INIT_COUNTER;
 	TM4MD &= ~TM4MD_INIT_COUNTER;
 	TM4ICR = 0;
+	t32 = TM4ICR;
 
 	TM5MD = TM5MD_SRC_TM4CASCADE;
 	TM5MD |= TM5MD_INIT_COUNTER;
 	TM5MD &= ~TM5MD_INIT_COUNTER;
 	TM5ICR = 0;
+	t32 = TM5ICR;
 
 	TM5MD |= TM5MD_COUNT_ENABLE;
 	TM4MD |= TM4MD_COUNT_ENABLE;
+	t32 = TM5MD;
+	t32 = TM4MD;
 }
 
 static inline void shutdown_timestamp_counter(void)
 {
+	u8 t8;
 	TM4MD = 0;
 	TM5MD = 0;
+	t8 = TM4MD;
+	t8 = TM5MD;
 }
 
 /*
diff --git a/arch/mn10300/unit-asb2303/unit-init.c b/arch/mn10300/unit-asb2303/unit-init.c
index 70e8cb4..834a76a 100644
--- a/arch/mn10300/unit-asb2303/unit-init.c
+++ b/arch/mn10300/unit-asb2303/unit-init.c
@@ -31,6 +31,14 @@ asmlinkage void __init unit_init(void)
 	SET_XIRQ_TRIGGER(3, XIRQ_TRIGGER_HILEVEL);
 	SET_XIRQ_TRIGGER(4, XIRQ_TRIGGER_LOWLEVEL);
 	SET_XIRQ_TRIGGER(5, XIRQ_TRIGGER_LOWLEVEL);
+
+#ifdef CONFIG_EXT_SERIAL_IRQ_LEVEL
+	set_intr_level(XIRQ0, NUM2GxICR_LEVEL(CONFIG_EXT_SERIAL_IRQ_LEVEL));
+#endif
+
+#ifdef CONFIG_ETHERNET_IRQ_LEVEL
+	set_intr_level(XIRQ3, NUM2GxICR_LEVEL(CONFIG_ETHERNET_IRQ_LEVEL));
+#endif
 }
 
 /*
@@ -51,7 +59,7 @@ void __init unit_init_IRQ(void)
 		switch (GET_XIRQ_TRIGGER(extnum)) {
 		case XIRQ_TRIGGER_HILEVEL:
 		case XIRQ_TRIGGER_LOWLEVEL:
-			set_intr_postackable(XIRQ2IRQ(extnum));
+			mn10300_set_lateack_irq_type(XIRQ2IRQ(extnum));
 			break;
 		default:
 			break;
diff --git a/arch/mn10300/unit-asb2305/include/unit/clock.h b/arch/mn10300/unit-asb2305/include/unit/clock.h
index 67be3f2..29e3425 100644
--- a/arch/mn10300/unit-asb2305/include/unit/clock.h
+++ b/arch/mn10300/unit-asb2305/include/unit/clock.h
@@ -14,32 +14,11 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_MN10300_RTC
-
-extern unsigned long mn10300_ioclk;	/* IOCLK (crystal speed) in HZ */
-extern unsigned long mn10300_iobclk;
-extern unsigned long mn10300_tsc_per_HZ;
-
-#define MN10300_IOCLK		mn10300_ioclk
-/* If this processors has a another clock, uncomment the below. */
-/* #define MN10300_IOBCLK	mn10300_iobclk */
-
-#else /* !CONFIG_MN10300_RTC */
-
 #define MN10300_IOCLK		33333333UL
 /* #define MN10300_IOBCLK	66666666UL */
 
-#endif /* !CONFIG_MN10300_RTC */
-
-#define MN10300_JCCLK		MN10300_IOCLK
-#define MN10300_TSCCLK		MN10300_IOCLK
-
-#ifdef CONFIG_MN10300_RTC
-#define MN10300_TSC_PER_HZ	mn10300_tsc_per_HZ
-#else /* !CONFIG_MN10300_RTC */
-#define MN10300_TSC_PER_HZ	(MN10300_TSCCLK/HZ)
-#endif /* !CONFIG_MN10300_RTC */
-
 #endif /* !__ASSEMBLY__ */
 
+#define MN10300_WDCLK		MN10300_IOCLK
+
 #endif /* _ASM_UNIT_CLOCK_H */
diff --git a/arch/mn10300/unit-asb2305/include/unit/serial.h b/arch/mn10300/unit-asb2305/include/unit/serial.h
index 8086cc0..88c0821 100644
--- a/arch/mn10300/unit-asb2305/include/unit/serial.h
+++ b/arch/mn10300/unit-asb2305/include/unit/serial.h
@@ -21,6 +21,11 @@
 #define SERIAL_IRQ	XIRQ0	/* Dual serial (PC16552)	(Hi) */
 
 /*
+ * The ASB2305 has an 18.432 MHz clock the UART
+ */
+#define BASE_BAUD	(18432000 / 16)
+
+/*
  * dispose of the /dev/ttyS0 serial port
  */
 #ifndef CONFIG_GDBSTUB_ON_TTYSx
diff --git a/arch/mn10300/unit-asb2305/include/unit/timex.h b/arch/mn10300/unit-asb2305/include/unit/timex.h
index 0860186..cd8bc14 100644
--- a/arch/mn10300/unit-asb2305/include/unit/timex.h
+++ b/arch/mn10300/unit-asb2305/include/unit/timex.h
@@ -1,4 +1,4 @@
-/* ASB2305 timer specifcations
+/* ASB2305-specific timer specifications
  *
  * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -17,6 +17,7 @@
 
 #include <asm/timer-regs.h>
 #include <unit/clock.h>
+#include <asm/param.h>
 
 /*
  * jiffies counter specifications
@@ -29,32 +30,43 @@
 #define	TMJCBR			TM01BR
 #define	TMJCIRQ			TM1IRQ
 #define	TMJCICR			TM1ICR
-#define	TMJCICR_LEVEL		GxICR_LEVEL_5
 
 #ifndef __ASSEMBLY__
 
+#define MN10300_SRC_IOCLK	MN10300_IOCLK
+
+#ifndef HZ
+# error HZ undeclared.
+#endif /* !HZ */
+/* use as little prescaling as possible to avoid losing accuracy */
+#if (MN10300_SRC_IOCLK + HZ / 2) / HZ - 1 <= TMJCBR_MAX
+# define IOCLK_PRESCALE		1
+# define JC_TIMER_CLKSRC	TM0MD_SRC_IOCLK
+# define TSC_TIMER_CLKSRC	TM4MD_SRC_IOCLK
+#elif (MN10300_SRC_IOCLK / 8 + HZ / 2) / HZ - 1 <= TMJCBR_MAX
+# define IOCLK_PRESCALE		8
+# define JC_TIMER_CLKSRC	TM0MD_SRC_IOCLK_8
+# define TSC_TIMER_CLKSRC	TM4MD_SRC_IOCLK_8
+#elif (MN10300_SRC_IOCLK / 32 + HZ / 2) / HZ - 1 <= TMJCBR_MAX
+# define IOCLK_PRESCALE		32
+# define JC_TIMER_CLKSRC	TM0MD_SRC_IOCLK_32
+# define TSC_TIMER_CLKSRC	TM4MD_SRC_IOCLK_32
+#else
+# error You lose.
+#endif
+
+#define MN10300_JCCLK		(MN10300_SRC_IOCLK / IOCLK_PRESCALE)
+#define MN10300_TSCCLK		(MN10300_SRC_IOCLK / IOCLK_PRESCALE)
+
+#define MN10300_JC_PER_HZ	((MN10300_JCCLK + HZ / 2) / HZ)
+#define MN10300_TSC_PER_HZ	((MN10300_TSCCLK + HZ / 2) / HZ)
+
 static inline void startup_jiffies_counter(void)
 {
-	unsigned rate;
 	u16 md, t16;
 
-	/* use as little prescaling as possible to avoid losing accuracy */
-	md = TM0MD_SRC_IOCLK;
-	rate = MN10300_JCCLK / HZ;
-
-	if (rate > TMJCBR_MAX) {
-		md = TM0MD_SRC_IOCLK_8;
-		rate = MN10300_JCCLK / 8 / HZ;
-
-		if (rate > TMJCBR_MAX) {
-			md = TM0MD_SRC_IOCLK_32;
-			rate = MN10300_JCCLK / 32 / HZ;
-
-			BUG_ON(rate > TMJCBR_MAX);
-		}
-	}
-
-	TMJCBR = rate - 1;
+	md = JC_TIMER_CLKSRC;
+	TMJCBR = MN10300_JC_PER_HZ - 1;
 	t16 = TMJCBR;
 
 	TMJCMD =
@@ -93,29 +105,39 @@ static inline void shutdown_jiffies_counter(void)
 
 static inline void startup_timestamp_counter(void)
 {
+	u32 t32;
+
 	/* set up timer 4 & 5 cascaded as a 32-bit counter to count real time
 	 * - count down from 4Gig-1 to 0 and wrap at IOCLK rate
 	 */
 	TM45BR = TMTSCBR_MAX;
+	t32 = TM45BR;
 
-	TM4MD = TM4MD_SRC_IOCLK;
+	TM4MD = TSC_TIMER_CLKSRC;
 	TM4MD |= TM4MD_INIT_COUNTER;
 	TM4MD &= ~TM4MD_INIT_COUNTER;
 	TM4ICR = 0;
+	t32 = TM4ICR;
 
 	TM5MD = TM5MD_SRC_TM4CASCADE;
 	TM5MD |= TM5MD_INIT_COUNTER;
 	TM5MD &= ~TM5MD_INIT_COUNTER;
 	TM5ICR = 0;
+	t32 = TM5ICR;
 
 	TM5MD |= TM5MD_COUNT_ENABLE;
 	TM4MD |= TM4MD_COUNT_ENABLE;
+	t32 = TM5MD;
+	t32 = TM4MD;
 }
 
 static inline void shutdown_timestamp_counter(void)
 {
+	u8 t8;
 	TM4MD = 0;
 	TM5MD = 0;
+	t8 = TM4MD;
+	t8 = TM5MD;
 }
 
 /*
@@ -126,7 +148,7 @@ typedef unsigned long cycles_t;
 
 static inline cycles_t read_timestamp_counter(void)
 {
-	return (cycles_t) TMTSCBC;
+	return (cycles_t)TMTSCBC;
 }
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
index 6d8720a..a4954fe 100644
--- a/arch/mn10300/unit-asb2305/pci.c
+++ b/arch/mn10300/unit-asb2305/pci.c
@@ -503,7 +503,7 @@ asmlinkage void __init unit_pci_init(void)
 	struct pci_ops *o = &pci_direct_ampci;
 	u32 x;
 
-	set_intr_level(XIRQ1, GxICR_LEVEL_3);
+	set_intr_level(XIRQ1, NUM2GxICR_LEVEL(CONFIG_PCI_IRQ_LEVEL));
 
 	memset(&bus, 0, sizeof(bus));
 
diff --git a/arch/mn10300/unit-asb2305/unit-init.c b/arch/mn10300/unit-asb2305/unit-init.c
index a76c8e0..e1becd6 100644
--- a/arch/mn10300/unit-asb2305/unit-init.c
+++ b/arch/mn10300/unit-asb2305/unit-init.c
@@ -26,8 +26,10 @@ asmlinkage void __init unit_init(void)
 {
 #ifndef CONFIG_GDBSTUB_ON_TTYSx
 	/* set the 16550 interrupt line to level 3 if not being used for GDB */
-	set_intr_level(XIRQ0, GxICR_LEVEL_3);
+#ifdef CONFIG_EXT_SERIAL_IRQ_LEVEL
+	set_intr_level(XIRQ0, NUM2GxICR_LEVEL(CONFIG_EXT_SERIAL_IRQ_LEVEL));
 #endif
+#endif /* CONFIG_GDBSTUB_ON_TTYSx */
 }
 
 /*
@@ -51,7 +53,7 @@ void __init unit_init_IRQ(void)
 		switch (GET_XIRQ_TRIGGER(extnum)) {
 		case XIRQ_TRIGGER_HILEVEL:
 		case XIRQ_TRIGGER_LOWLEVEL:
-			set_intr_postackable(XIRQ2IRQ(extnum));
+			mn10300_set_lateack_irq_type(XIRQ2IRQ(extnum));
 			break;
 		default:
 			break;
diff --git a/arch/mn10300/unit-asb2364/Makefile b/arch/mn10300/unit-asb2364/Makefile
new file mode 100644
index 0000000..6dd27d6
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the linux kernel.
+#
+# Note! Dependencies are done automagically by 'make dep', which also
+# removes any old dependencies. DON'T put your own dependencies here
+# unless it's something special (ie not a .c file).
+#
+# Note 2! The CFLAGS definitions are now in the main makefile...
+
+obj-y   := unit-init.o leds.o
diff --git a/arch/mn10300/unit-asb2364/include/unit/clock.h b/arch/mn10300/unit-asb2364/include/unit/clock.h
new file mode 100644
index 0000000..d34ac9a
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/include/unit/clock.h
@@ -0,0 +1,29 @@
+/* clock.h: unit-specific clocks
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * Modified by Matsushita Electric Industrial Co., Ltd.
+ * Modifications:
+ *	23-Feb-2007 MEI Add define for watchdog timer.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_CLOCK_H
+#define _ASM_UNIT_CLOCK_H
+
+#ifndef __ASSEMBLY__
+
+#define MN10300_IOCLK		100000000UL		/* for DDR800 */
+/*#define MN10300_IOCLK		83333333UL */		/* for DDR667 */
+#define MN10300_IOBCLK		MN10300_IOCLK		/* IOBCLK is equal to IOCLK */
+
+#endif /* !__ASSEMBLY__ */
+
+#define MN10300_WDCLK		27000000UL
+
+#endif /* _ASM_UNIT_CLOCK_H */
diff --git a/arch/mn10300/unit-asb2364/include/unit/fpga-regs.h b/arch/mn10300/unit-asb2364/include/unit/fpga-regs.h
new file mode 100644
index 0000000..a039a50
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/include/unit/fpga-regs.h
@@ -0,0 +1,50 @@
+/* ASB2364 FPGA registers
+ */
+
+#ifndef _ASM_UNIT_FPGA_REGS_H
+#define _ASM_UNIT_FPGA_REGS_H
+
+#include <asm/cpu-regs.h>
+
+#ifdef __KERNEL__
+
+#define ASB2364_FPGA_REG_RESET_LAN	__SYSREG(0xa9001300, u16)
+#define ASB2364_FPGA_REG_RESET_UART	__SYSREG(0xa9001304, u16)
+#define ASB2364_FPGA_REG_RESET_I2C	__SYSREG(0xa9001308, u16)
+#define ASB2364_FPGA_REG_RESET_USB	__SYSREG(0xa900130c, u16)
+#define ASB2364_FPGA_REG_RESET_AV	__SYSREG(0xa9001310, u16)
+
+#define ASB2364_FPGA_REG_IRQ_LAN	__SYSREG(0xa9001510, u16)
+#define ASB2364_FPGA_REG_IRQ_UART	__SYSREG(0xa9001514, u16)
+#define ASB2364_FPGA_REG_IRQ_I2C	__SYSREG(0xa9001518, u16)
+#define ASB2364_FPGA_REG_IRQ_USB	__SYSREG(0xa900151c, u16)
+#define ASB2364_FPGA_REG_IRQ_FPGA	__SYSREG(0xa9001524, u16)
+
+#define ASB2364_FPGA_REG_MASK_LAN	__SYSREG(0xa9001590, u16)
+#define ASB2364_FPGA_REG_MASK_UART	__SYSREG(0xa9001594, u16)
+#define ASB2364_FPGA_REG_MASK_I2C	__SYSREG(0xa9001598, u16)
+#define ASB2364_FPGA_REG_MASK_USB	__SYSREG(0xa900159c, u16)
+#define ASB2364_FPGA_REG_MASK_FPGA	__SYSREG(0xa90015a4, u16)
+
+#define ASB2364_FPGA_REG_CPLD5_SET1	__SYSREG(0xa9002500, u16)
+#define ASB2364_FPGA_REG_CPLD5_SET2	__SYSREG(0xa9002504, u16)
+#define ASB2364_FPGA_REG_CPLD6_SET1	__SYSREG(0xa9002600, u16)
+#define ASB2364_FPGA_REG_CPLD6_SET2	__SYSREG(0xa9002604, u16)
+#define ASB2364_FPGA_REG_CPLD7_SET1	__SYSREG(0xa9002700, u16)
+#define ASB2364_FPGA_REG_CPLD7_SET2	__SYSREG(0xa9002704, u16)
+#define ASB2364_FPGA_REG_CPLD8_SET1	__SYSREG(0xa9002800, u16)
+#define ASB2364_FPGA_REG_CPLD8_SET2	__SYSREG(0xa9002804, u16)
+#define ASB2364_FPGA_REG_CPLD9_SET1	__SYSREG(0xa9002900, u16)
+#define ASB2364_FPGA_REG_CPLD9_SET2	__SYSREG(0xa9002904, u16)
+#define ASB2364_FPGA_REG_CPLD10_SET1	__SYSREG(0xa9002a00, u16)
+#define ASB2364_FPGA_REG_CPLD10_SET2	__SYSREG(0xa9002a04, u16)
+
+#define SyncExBus()					\
+	do {						\
+		unsigned short w;			\
+		w = *(volatile short *)0xa9000000;	\
+	} while (0)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_UNIT_FPGA_REGS_H */
diff --git a/arch/mn10300/unit-asb2364/include/unit/leds.h b/arch/mn10300/unit-asb2364/include/unit/leds.h
new file mode 100644
index 0000000..03a3933
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/include/unit/leds.h
@@ -0,0 +1,54 @@
+/* Unit-specific leds
+ *
+ * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_LEDS_H
+#define _ASM_UNIT_LEDS_H
+
+#include <asm/pio-regs.h>
+#include <asm/cpu-regs.h>
+#include <asm/exceptions.h>
+
+#define MN10300_USE_7SEGLEDS	0
+
+#define ASB2364_7SEGLEDS	__SYSREG(0xA9001630, u32)
+
+/*
+ * use the 7-segment LEDs to indicate states
+ */
+
+#if MN10300_USE_7SEGLEDS
+/* flip the 7-segment LEDs between "Gdb-" and "----" */
+#define mn10300_set_gdbleds(ONOFF)					\
+	do {								\
+		ASB2364_7SEGLEDS = (ONOFF) ? 0x8543077f : 0x7f7f7f7f;	\
+	} while (0)
+#else
+#define mn10300_set_gdbleds(ONOFF) do {} while (0)
+#endif
+
+#if MN10300_USE_7SEGLEDS
+/* indicate double-fault by displaying "db-f" on the LEDs */
+#define mn10300_set_dbfleds			\
+	mov	0x43077f1d,d0		;	\
+	mov	d0,(ASB2364_7SEGLEDS)
+#else
+#define mn10300_set_dbfleds
+#endif
+
+#ifndef __ASSEMBLY__
+extern void peripheral_leds_display_exception(enum exception_code);
+extern void peripheral_leds_led_chase(void);
+extern void peripheral_leds7x4_display_dec(unsigned int, unsigned int);
+extern void peripheral_leds7x4_display_hex(unsigned int, unsigned int);
+extern void debug_to_serial(const char *, int);
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_LEDS_H */
diff --git a/arch/mn10300/unit-asb2364/include/unit/serial.h b/arch/mn10300/unit-asb2364/include/unit/serial.h
new file mode 100644
index 0000000..7f048bb
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/include/unit/serial.h
@@ -0,0 +1,151 @@
+/* Unit-specific 8250 serial ports
+ *
+ * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNIT_SERIAL_H
+#define _ASM_UNIT_SERIAL_H
+
+#include <asm/cpu-regs.h>
+#include <proc/irq.h>
+#include <unit/fpga-regs.h>
+#include <linux/serial_reg.h>
+
+#define SERIAL_PORT0_BASE_ADDRESS	0xA8200000
+
+#define SERIAL_IRQ	XIRQ1	/* single serial (TL16C550C)	(Lo) */
+
+/*
+ * The ASB2364 has an 12.288 MHz clock
+ * for your UART.
+ *
+ * It'd be nice if someone built a serial card with a 24.576 MHz
+ * clock, since the 16550A is capable of handling a top speed of 1.5
+ * megabits/second; but this requires the faster clock.
+ */
+#define BASE_BAUD (12288000 / 16)
+
+/*
+ * dispose of the /dev/ttyS0 and /dev/ttyS1 serial ports
+ */
+#ifndef CONFIG_GDBSTUB_ON_TTYSx
+
+#define SERIAL_PORT_DFNS						\
+	{								\
+		.baud_base	= BASE_BAUD,				\
+		.irq		= SERIAL_IRQ,				\
+		.flags		= STD_COM_FLAGS,			\
+		.iomem_base	= (u8 *) SERIAL_PORT0_BASE_ADDRESS,	\
+		.iomem_reg_shift = 1,					\
+		.io_type	= SERIAL_IO_MEM,			\
+	},
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#else /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#define SERIAL_PORT_DFNS /* stolen by gdb-stub */
+
+#if defined(CONFIG_GDBSTUB_ON_TTYS0)
+#define GDBPORT_SERIAL_RX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_RX  * 4, u8)
+#define GDBPORT_SERIAL_TX	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_TX  * 4, u8)
+#define GDBPORT_SERIAL_DLL	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLL * 4, u8)
+#define GDBPORT_SERIAL_DLM	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_DLM * 4, u8)
+#define GDBPORT_SERIAL_IER	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IER * 4, u8)
+#define GDBPORT_SERIAL_IIR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_IIR * 4, u8)
+#define GDBPORT_SERIAL_FCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_FCR * 4, u8)
+#define GDBPORT_SERIAL_LCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LCR * 4, u8)
+#define GDBPORT_SERIAL_MCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MCR * 4, u8)
+#define GDBPORT_SERIAL_LSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_LSR * 4, u8)
+#define GDBPORT_SERIAL_MSR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_MSR * 4, u8)
+#define GDBPORT_SERIAL_SCR	__SYSREG(SERIAL_PORT0_BASE_ADDRESS + UART_SCR * 4, u8)
+#define GDBPORT_SERIAL_IRQ	SERIAL_IRQ
+
+#elif defined(CONFIG_GDBSTUB_ON_TTYS1)
+#error The ASB2364 does not have a /dev/ttyS1
+#endif
+
+#ifndef __ASSEMBLY__
+
+static inline void __debug_to_serial(const char *p, int n)
+{
+	char ch;
+
+#define LSR_WAIT_FOR(STATE)	\
+	do {} while (!(GDBPORT_SERIAL_LSR & UART_LSR_##STATE))
+#define FLOWCTL_QUERY(LINE)	\
+	({ GDBPORT_SERIAL_MSR & UART_MSR_##LINE; })
+#define FLOWCTL_WAIT_FOR(LINE)	\
+	do {} while (!(GDBPORT_SERIAL_MSR & UART_MSR_##LINE))
+#define FLOWCTL_CLEAR(LINE)	\
+	do { GDBPORT_SERIAL_MCR &= ~UART_MCR_##LINE; } while (0)
+#define FLOWCTL_SET(LINE)	\
+	do { GDBPORT_SERIAL_MCR |= UART_MCR_##LINE; } while (0)
+
+	FLOWCTL_SET(DTR);
+
+	for (; n > 0; n--) {
+		LSR_WAIT_FOR(THRE);
+		FLOWCTL_WAIT_FOR(CTS);
+
+		ch = *p++;
+		if (ch == 0x0a) {
+			GDBPORT_SERIAL_TX = 0x0d;
+			LSR_WAIT_FOR(THRE);
+			FLOWCTL_WAIT_FOR(CTS);
+		}
+		GDBPORT_SERIAL_TX = ch;
+	}
+
+	FLOWCTL_CLEAR(DTR);
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* CONFIG_GDBSTUB_ON_TTYSx */
+
+#define SERIAL_INITIALIZE					\
+do {								\
+	/* release reset */					\
+	ASB2364_FPGA_REG_RESET_UART = 0x0001;			\
+	SyncExBus();						\
+} while (0)
+
+#define SERIAL_CHECK_INTERRUPT					\
+do {								\
+	if ((ASB2364_FPGA_REG_IRQ_UART & 0x0001) == 0x0001) {	\
+		return IRQ_NONE;				\
+	}							\
+} while (0)
+
+#define SERIAL_CLEAR_INTERRUPT					\
+do {								\
+	ASB2364_FPGA_REG_IRQ_UART = 0x0001;			\
+	SyncExBus();						\
+} while (0)
+
+#define SERIAL_SET_INT_MASK					\
+do {								\
+	ASB2364_FPGA_REG_MASK_UART = 0x0001;			\
+	SyncExBus();						\
+} while (0)
+
+#define SERIAL_CLEAR_INT_MASK					\
+do {								\
+	ASB2364_FPGA_REG_MASK_UART = 0x0000;			\
+	SyncExBus();						\
+} while (0)
+
+#endif /* _ASM_UNIT_SERIAL_H */
diff --git a/arch/mn10300/unit-asb2364/include/unit/timex.h b/arch/mn10300/unit-asb2364/include/unit/timex.h
new file mode 100644
index 0000000..b5223f7
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/include/unit/timex.h
@@ -0,0 +1,125 @@
+/* timex.h: MN2WS0038 architecture timer specifications
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_UNIT_TIMEX_H
+#define _ASM_UNIT_TIMEX_H
+
+#ifndef __ASSEMBLY__
+#include <linux/irq.h>
+#endif /* __ASSEMBLY__ */
+
+#include <asm/timer-regs.h>
+#include <unit/clock.h>
+#include <asm/param.h>
+
+/*
+ * jiffies counter specifications
+ */
+
+#define	TMJCBR_MAX		0xffffff	/* 24bit */
+#define	TMJCBC			TMTBC
+
+#define	TMJCMD			TMTMD
+#define	TMJCBR			TMTBR
+#define	TMJCIRQ			TMTIRQ
+#define	TMJCICR			TMTICR
+
+#ifndef __ASSEMBLY__
+
+#define MN10300_SRC_IOBCLK	MN10300_IOBCLK
+
+#ifndef HZ
+# error HZ undeclared.
+#endif /* !HZ */
+
+#define MN10300_JCCLK		(MN10300_SRC_IOBCLK)
+#define MN10300_TSCCLK		(MN10300_SRC_IOBCLK)
+
+#define MN10300_JC_PER_HZ	((MN10300_JCCLK + HZ / 2) / HZ)
+#define MN10300_TSC_PER_HZ	((MN10300_TSCCLK + HZ / 2) / HZ)
+
+/* Check bit width of MTM interval value that sets base register */
+#if (MN10300_JC_PER_HZ - 1) > TMJCBR_MAX
+# error MTM tick timer interval value is overflow.
+#endif
+
+
+static inline void startup_jiffies_counter(void)
+{
+	u32 sync;
+
+	TMJCBR = MN10300_JC_PER_HZ - 1;
+	sync = TMJCBR;
+
+	TMJCMD = TMTMD_TMTLDE;
+	TMJCMD = TMTMD_TMTCNE;
+	sync = TMJCMD;
+
+	TMJCICR |= GxICR_ENABLE | GxICR_DETECT | GxICR_REQUEST;
+	sync = TMJCICR;
+}
+
+static inline void shutdown_jiffies_counter(void)
+{
+}
+
+#endif /* !__ASSEMBLY__ */
+
+
+/*
+ * timestamp counter specifications
+ */
+
+#define	TMTSCBR_MAX	0xffffffff
+#define	TMTSCMD		TMSMD
+#define	TMTSCBR		TMSBR
+#define	TMTSCBC		TMSBC
+#define	TMTSCICR	TMSICR
+
+#ifndef __ASSEMBLY__
+
+static inline void startup_timestamp_counter(void)
+{
+	u32 sync;
+
+	/* set up TMS(Timestamp) 32bit timer register to count real time
+	 * - count down from 4Gig-1 to 0 and wrap at IOBCLK rate
+	 */
+
+	TMTSCBR = TMTSCBR_MAX;
+	sync = TMTSCBR;
+
+	TMTSCICR = 0;
+	sync = TMTSCICR;
+
+	TMTSCMD = TMTMD_TMTLDE;
+	TMTSCMD = TMTMD_TMTCNE;
+	sync = TMTSCMD;
+}
+
+static inline void shutdown_timestamp_counter(void)
+{
+	TMTSCMD = 0;
+}
+
+/*
+ * we use a cascaded pair of 16-bit down-counting timers to count I/O
+ * clock cycles for the purposes of time keeping
+ */
+typedef unsigned long cycles_t;
+
+static inline cycles_t read_timestamp_counter(void)
+{
+	return (cycles_t)TMTSCBC;
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_UNIT_TIMEX_H */
diff --git a/arch/mn10300/unit-asb2364/leds.c b/arch/mn10300/unit-asb2364/leds.c
new file mode 100644
index 0000000..1ff830c
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/leds.c
@@ -0,0 +1,98 @@
+/* leds.c: ASB2364 peripheral 7seg LEDs x4 support
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+#include <asm/processor.h>
+#include <asm/intctl-regs.h>
+#include <asm/rtc-regs.h>
+#include <unit/leds.h>
+
+#if MN10300_USE_7SEGLEDS
+static const u8 asb2364_led_hex_tbl[16] = {
+	0x80, 0xf2, 0x48, 0x60, 0x32, 0x24, 0x04, 0xf0,
+	0x00, 0x20, 0x10, 0x06, 0x8c, 0x42, 0x0c, 0x1c
+};
+
+static const u32 asb2364_led_chase_tbl[6] = {
+	~0x02020202,	/* top		- segA */
+	~0x04040404,	/* right top	- segB */
+	~0x08080808,	/* right bottom	- segC */
+	~0x10101010,	/* bottom	- segD */
+	~0x20202020,	/* left bottom	- segE */
+	~0x40404040,	/* left top	- segF */
+};
+
+static unsigned asb2364_led_chase;
+
+void peripheral_leds7x4_display_dec(unsigned int val, unsigned int points)
+{
+	u32 leds;
+
+	leds = asb2364_led_hex_tbl[(val/1000) % 10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[(val/100) % 10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[(val/10) % 10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[val % 10];
+	leds |= points^0x01010101;
+
+	ASB2364_7SEGLEDS = leds;
+}
+
+void peripheral_leds7x4_display_hex(unsigned int val, unsigned int points)
+{
+	u32 leds;
+
+	leds = asb2364_led_hex_tbl[(val/1000) % 10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[(val/100) % 10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[(val/10) % 10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[val % 10];
+	leds |= points^0x01010101;
+
+	ASB2364_7SEGLEDS = leds;
+}
+
+/* display triple horizontal bar and exception code */
+void peripheral_leds_display_exception(enum exception_code code)
+{
+	u32 leds;
+
+	leds = asb2364_led_hex_tbl[(code/0x100) % 0x10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[(code/0x10) % 0x10];
+	leds <<= 8;
+	leds |= asb2364_led_hex_tbl[code % 0x10];
+	leds |= 0x6d010101;
+
+	ASB2364_7SEGLEDS = leds;
+}
+
+void peripheral_leds_led_chase(void)
+{
+	ASB2364_7SEGLEDS = asb2364_led_chase_tbl[asb2364_led_chase];
+	asb2364_led_chase++;
+	if (asb2364_led_chase >= 6)
+		asb2364_led_chase = 0;
+}
+#else  /* MN10300_USE_7SEGLEDS */
+void peripheral_leds7x4_display_dec(unsigned int val, unsigned int points) { }
+void peripheral_leds7x4_display_hex(unsigned int val, unsigned int points) { }
+void peripheral_leds_display_exception(enum exception_code code) { }
+void peripheral_leds_led_chase(void) { }
+#endif /* MN10300_USE_7SEGLEDS */
diff --git a/arch/mn10300/unit-asb2364/unit-init.c b/arch/mn10300/unit-asb2364/unit-init.c
new file mode 100644
index 0000000..a3fc09b
--- /dev/null
+++ b/arch/mn10300/unit-asb2364/unit-init.c
@@ -0,0 +1,85 @@
+/* ASB2364 initialisation
+ *
+ * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+
+#include <asm/io.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/irq.h>
+#include <asm/intctl-regs.h>
+
+/*
+ * initialise some of the unit hardware before gdbstub is set up
+ */
+asmlinkage void __init unit_init(void)
+{
+	/* set up the external interrupts */
+
+	/* XIRQ[0]: NAND RXBY */
+	/* SET_XIRQ_TRIGGER(0, XIRQ_TRIGGER_LOWLEVEL); */
+
+	/* XIRQ[1]: LAN, UART, I2C, USB, PCI, FPGA */
+	SET_XIRQ_TRIGGER(1, XIRQ_TRIGGER_LOWLEVEL);
+
+	/* XIRQ[2]: Extend Slot 1-9 */
+	/* SET_XIRQ_TRIGGER(2, XIRQ_TRIGGER_LOWLEVEL); */
+
+#if defined(CONFIG_EXT_SERIAL_IRQ_LEVEL) &&	\
+    defined(CONFIG_ETHERNET_IRQ_LEVEL) &&	\
+    (CONFIG_EXT_SERIAL_IRQ_LEVEL != CONFIG_ETHERNET_IRQ_LEVEL)
+# error CONFIG_EXT_SERIAL_IRQ_LEVEL != CONFIG_ETHERNET_IRQ_LEVEL
+#endif
+
+#if defined(CONFIG_EXT_SERIAL_IRQ_LEVEL)
+	set_intr_level(XIRQ1, NUM2GxICR_LEVEL(CONFIG_EXT_SERIAL_IRQ_LEVEL));
+#elif defined(CONFIG_ETHERNET_IRQ_LEVEL)
+	set_intr_level(XIRQ1, NUM2GxICR_LEVEL(CONFIG_ETHERNET_IRQ_LEVEL));
+#endif
+}
+
+/*
+ * initialise the rest of the unit hardware after gdbstub is ready
+ */
+asmlinkage void __init unit_setup(void)
+{
+
+}
+
+/*
+ * initialise the external interrupts used by a unit of this type
+ */
+void __init unit_init_IRQ(void)
+{
+	unsigned int extnum;
+
+	for (extnum = 0 ; extnum < NR_XIRQS ; extnum++) {
+		switch (GET_XIRQ_TRIGGER(extnum)) {
+			/* LEVEL triggered interrupts should be made
+			 * post-ACK'able as they hold their lines until
+			 * serviced
+			 */
+		case XIRQ_TRIGGER_HILEVEL:
+		case XIRQ_TRIGGER_LOWLEVEL:
+			mn10300_set_lateack_irq_type(XIRQ2IRQ(extnum));
+			break;
+		default:
+			break;
+		}
+	}
+
+#define IRQCTL	__SYSREG(0xd5000090, u32)
+	IRQCTL |= 0x02;
+}

