Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab2EXT1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:27:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:58335 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2EXT1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:27:35 -0400
Date: Thu, 24 May 2012 21:27:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer updates for 3.5
Message-ID: <alpine.LFD.2.02.1205242122490.3231@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-core-for-linus

The Kconfig series will cause a tiny problem with sparc. sparc32
became a new user of GENERIC_CLOCKEVENTS, so it needs the following
fixlet after merging it in your tree.

--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -33,6 +33,7 @@ config SPARC
 	select GENERIC_CMOS_UPDATE
 	select HAVE_BPF_JIT
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_CLOCKEVENTS
 
 config SPARC32
 	def_bool !64BIT
@@ -66,7 +67,6 @@ config SPARC64
 	select IRQ_PREFLOW_FASTEOI
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
-	select GENERIC_CLOCKEVENTS
 	select NO_BOOTMEM
 
 config ARCH_DEFCONFIG


Thanks,

	tglx

------------------>
Anna-Maria Gleixner (22):
      alpha: Use generic time config
      arm: Use generic time config
      avr32: Use generic time config
      blackfin: Use generic time config
      c6x: Use generic time config
      cris: Use generic time config
      hexagon: Use generic time config
      ia64: Use generic time config
      m32r: Use generic time config
      m68k: Use generic time config
      microblaze: Use generic time config
      mips: Use generic time config
      mn10300: Use generic time config
      powerpc: Use generic time config
      openrisc: Use generic time config
      s390: Use generic time config
      score: Use generic time config
      sh: Use generic time config
      sparc: Use: generic time config
      tile: Use generic time config
      um: Use generic time config
      unicore32: Use generic time config

Jan Beulich (2):
      x86: Clear HPET configuration registers on startup
      x86: Allow multiple values to be specified with "hpet="

Richard Cochran (4):
      ntp: Correct TAI offset during leap second
      ntp: Fix a stale comment and a few stray newlines.
      time: remove obsolete declaration
      timekeeping: Fix a few minor newline issues.

Thomas Gleixner (3):
      timers: Provide generic Kconfig switches
      x86: Use generic time config
      timers: Fixup the Kconfig consolidation fallout


 arch/alpha/Kconfig        |    4 +--
 arch/arm/Kconfig          |   20 +------------
 arch/avr32/Kconfig        |    6 +---
 arch/blackfin/Kconfig     |   10 ++-----
 arch/c6x/Kconfig          |    8 +-----
 arch/cris/Kconfig         |    7 +----
 arch/h8300/Kconfig.cpu    |    2 -
 arch/hexagon/Kconfig      |   16 ++---------
 arch/ia64/Kconfig         |    9 +-----
 arch/m32r/Kconfig         |    4 +--
 arch/m68k/Kconfig         |   11 +-------
 arch/microblaze/Kconfig   |    9 +-----
 arch/mips/Kconfig         |   15 +---------
 arch/mn10300/Kconfig      |    8 +-----
 arch/openrisc/Kconfig     |    5 +---
 arch/powerpc/Kconfig      |   13 ++-------
 arch/s390/Kconfig         |   14 ++-------
 arch/score/Kconfig        |    5 +---
 arch/sh/Kconfig           |   15 +---------
 arch/sparc/Kconfig        |   17 ++---------
 arch/tile/Kconfig         |    6 +---
 arch/um/Kconfig.common    |    5 +---
 arch/um/Kconfig.um        |    1 -
 arch/unicore32/Kconfig    |    5 ---
 arch/x86/Kconfig          |   33 +++++-----------------
 arch/x86/kernel/hpet.c    |   66 ++++++++++++++++++++++++++++++++++++++------
 include/linux/time.h      |    1 -
 init/Kconfig              |    1 +
 kernel/time/Kconfig       |   58 ++++++++++++++++++++++++++++++++++-----
 kernel/time/ntp.c         |    8 ++---
 kernel/time/timekeeping.c |    4 +--
 31 files changed, 155 insertions(+), 231 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 22e58a9..77ba268 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -15,6 +15,7 @@ config ALPHA
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CMOS_UPDATE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -47,9 +48,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_CMOS_UPDATE
-        def_bool y
-
 config GENERIC_GPIO
 	bool
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 36586dba..c1e5f07 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -34,6 +34,8 @@ config ARM
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
 	select HAVE_BPF_JIT if NET
+	select KTIME_SCALAR
+	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
@@ -57,22 +59,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config GENERIC_GPIO
 	bool
 
-config ARCH_USES_GETTIMEOFFSET
-	bool
-	default n
-
-config GENERIC_CLOCKEVENTS
-	bool
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-	depends on GENERIC_CLOCKEVENTS
-	default y if SMP
-
-config KTIME_SCALAR
-	bool
-	default y
-
 config HAVE_TCM
 	bool
 	select GENERIC_ALLOCATOR
@@ -1473,8 +1459,6 @@ endmenu
 
 menu "Kernel Features"
 
-source "kernel/time/Kconfig"
-
 config HAVE_SMP
 	bool
 	help
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 3dea7231..f8bc2d2 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -12,6 +12,7 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CLOCKEVENTS
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
@@ -35,9 +36,6 @@ config TRACE_IRQFLAGS_SUPPORT
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool n
 
@@ -63,8 +61,6 @@ source "kernel/Kconfig.freezer"
 
 menu "System Type and features"
 
-source "kernel/time/Kconfig"
-
 config SUBARCH_AVR32B
 	bool
 config MMU
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 373a690..f7897ee 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -37,6 +37,7 @@ config BLACKFIN
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
+	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
 
 config GENERIC_CSUM
 	def_bool y
@@ -593,9 +594,10 @@ comment "Kernel Timer/Scheduler"
 
 source kernel/Kconfig.hz
 
-config GENERIC_CLOCKEVENTS
+config SET_GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
 	default y
+	select GENERIC_CLOCKEVENTS
 
 menu "Clock event device"
 	depends on GENERIC_CLOCKEVENTS
@@ -629,12 +631,6 @@ config GPTMR0_CLOCKSOURCE
 	depends on !TICKSOURCE_GPTMR0
 endmenu
 
-config ARCH_USES_GETTIMEOFFSET
-	depends on !GENERIC_CLOCKEVENTS
-	def_bool y
-
-source kernel/time/Kconfig
-
 comment "Misc"
 
 choice
diff --git a/arch/c6x/Kconfig b/arch/c6x/Kconfig
index 1c3ccd4..9d446ef 100644
--- a/arch/c6x/Kconfig
+++ b/arch/c6x/Kconfig
@@ -15,6 +15,7 @@ config TMS320C6X
 	select IRQ_DOMAIN
 	select OF
 	select OF_EARLY_FLATTREE
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	def_bool n
@@ -43,12 +44,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
 config GENERIC_BUG
 	def_bool y
 
@@ -137,7 +132,6 @@ source "mm/Kconfig"
 source "kernel/Kconfig.preempt"
 
 source "kernel/Kconfig.hz"
-source "kernel/time/Kconfig"
 
 endmenu
 
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index b3abfb0..4a63e7e 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -13,12 +13,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config ARCH_USES_GETTIMEOFFSET
-	def_bool n
-
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
@@ -49,6 +43,7 @@ config CRIS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_CMOS_UPDATE
 
 config HZ
 	int
diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index 15c2228..321f392 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -1,7 +1,5 @@
 menu "Processor type and features"
 
-source "kernel/time/Kconfig"
-
 choice
 	prompt "H8/300 platform"
 	default H8300H_GENERIC
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 9059e39..35f6c32 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -28,6 +28,9 @@ config HEXAGON
 	select NO_IOPORT
 	select GENERIC_IOMAP
 	# mostly generic routines, with some accelerated ones
+	select KTIME_SCALAR
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CLOCKEVENTS_BROADCAST
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
 	  performance and low power across a wide variety of applications.
@@ -56,9 +59,6 @@ config PCI
 config EARLY_PRINTK
 	def_bool y
 
-config KTIME_SCALAR
-	def_bool y
-
 config MMU
 	def_bool y
 
@@ -98,15 +98,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 	select STACKTRACE
@@ -192,7 +183,6 @@ endchoice
 source "mm/Kconfig"
 
 source "kernel/Kconfig.hz"
-source "kernel/time/Kconfig"
 
 config GENERIC_GPIO
 	bool "Generic GPIO support"
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index bd72669..9f9d57b 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -33,6 +33,8 @@ config IA64
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select ARCH_CLOCKSOURCE_DATA
+	select GENERIC_TIME_VSYSCALL
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -88,10 +90,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME_VSYSCALL
-	bool
-	default y
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
@@ -106,9 +104,6 @@ config EFI
 	bool
 	default y
 
-config ARCH_CLOCKSOURCE_DATA
-	def_bool y
-
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index ef80a65..b638d5b 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -11,6 +11,7 @@ config M32R
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
+	select ARCH_USES_GETTIMEOFFSET
 
 config SBUS
 	bool
@@ -33,9 +34,6 @@ config HZ
 	int
 	default 100
 
-config ARCH_USES_GETTIMEOFFSET
-	def_bool y
-
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index d318c60..cac5b6b 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select FPU if MMU
+	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
@@ -22,9 +23,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	bool
 
-config GENERIC_CLOCKEVENTS
-	bool
-
 config GENERIC_GPIO
 	bool
 
@@ -43,9 +41,6 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config ARCH_USES_GETTIMEOFFSET
-	def_bool MMU && !COLDFIRE
-
 config NO_IOPORT
 	def_bool y
 
@@ -111,10 +106,6 @@ if COLDFIRE
 source "kernel/Kconfig.preempt"
 endif
 
-if !MMU || COLDFIRE
-source "kernel/time/Kconfig"
-endif
-
 source "mm/Kconfig"
 
 endmenu
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ac22dc7..8346046 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -22,6 +22,7 @@ config MICROBLAZE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
 
 config SWAP
 	def_bool n
@@ -50,12 +51,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	def_bool n
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
@@ -79,8 +74,6 @@ source "arch/microblaze/platform/Kconfig.platform"
 
 menu "Processor type and features"
 
-source "kernel/time/Kconfig"
-
 source "kernel/Kconfig.preempt"
 
 source "kernel/Kconfig.hz"
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ce30e2f..b65a730 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -29,6 +29,8 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CMOS_UPDATE
 
 menu "Machine selection"
 
@@ -856,14 +858,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
@@ -2050,9 +2044,6 @@ config CPU_HAS_SYNC
 	depends on !CPU_R3000
 	default y
 
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
 #
 # CPU non-features
 #
@@ -2214,8 +2205,6 @@ config NR_CPUS
 	  performance should round up your number of processors to the next
 	  power of two.
 
-source "kernel/time/Kconfig"
-
 #
 # Timer Interrupt Frequency Configuration
 #
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 3aa3de0..687f9b4 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -6,6 +6,7 @@ config MN10300
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
+	select GENERIC_CLOCKEVENTS
 
 config AM33_2
 	def_bool n
@@ -42,15 +43,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_CMOS_UPDATE
-        def_bool n
-
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 
@@ -231,7 +226,6 @@ config MN10300_USING_JTAG
 	  single-stepping, which are taken over completely by the JTAG unit.
 
 source "kernel/Kconfig.hz"
-source "kernel/time/Kconfig"
 
 config MN10300_RTC
 	bool "Using MN10300 RTC"
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index a478719..7065303 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -17,6 +17,7 @@ config OPENRISC
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	def_bool y
@@ -46,9 +47,6 @@ config NO_IOPORT
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config TRACE_IRQFLAGS_SUPPORT
         def_bool y
 
@@ -108,7 +106,6 @@ config OPENRISC_HAVE_INST_DIV
 endmenu
 
 
-source "kernel/time/Kconfig"
 source kernel/Kconfig.hz
 source kernel/Kconfig.preempt
 source "mm/Kconfig"
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index feab3ba..d47cf7f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -27,15 +27,6 @@ config MMU
 	bool
 	default y
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config GENERIC_TIME_VSYSCALL
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
@@ -144,6 +135,9 @@ config PPC
 	select HAVE_BPF_JIT if (PPC64 && NET)
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CMOS_UPDATE
+	select GENERIC_TIME_VSYSCALL
+	select GENERIC_CLOCKEVENTS
 
 config EARLY_PRINTK
 	bool
@@ -284,7 +278,6 @@ config HIGHMEM
 	bool "High memory support"
 	depends on PPC32
 
-source kernel/time/Kconfig
 source kernel/Kconfig.hz
 source kernel/Kconfig.preempt
 source "fs/Kconfig.binfmt"
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9015060..d0325d9 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -28,12 +28,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y if BUG
 
@@ -122,6 +116,9 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select GENERIC_TIME_VSYSCALL
+	select GENERIC_CLOCKEVENTS
+	select KTIME_SCALAR if 32BIT
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
@@ -134,8 +131,6 @@ menu "Base setup"
 
 comment "Processor type and features"
 
-source "kernel/time/Kconfig"
-
 config 64BIT
 	def_bool y
 	prompt "64 bit kernel"
@@ -146,9 +141,6 @@ config 64BIT
 config 32BIT
 	def_bool y if !64BIT
 
-config KTIME_SCALAR
-	def_bool 32BIT
-
 config SMP
 	def_bool y
 	prompt "Symmetric multi-processing support"
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4b28577..ba0f412 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -9,6 +9,7 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
+       select GENERIC_CLOCKEVENTS
 
 choice
 	prompt "System type"
@@ -51,9 +52,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 menu "Kernel type"
 
 config 32BIT
@@ -68,7 +66,6 @@ config MEMORY_START
 	hex
 	default	0xa0000000
 
-source "kernel/time/Kconfig"
 source "kernel/Kconfig.hz"
 source "kernel/Kconfig.preempt"
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index ff9e033..820dfe3 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -28,6 +28,8 @@ config SUPERH
 	select RTC_LIB
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
@@ -86,16 +88,6 @@ config GENERIC_GPIO
 config GENERIC_CALIBRATE_DELAY
 	bool
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
-config GENERIC_CMOS_UPDATE
-	def_bool y
-	depends on SH_SH03 || SH_DREAMCAST
-
 config GENERIC_LOCKBREAK
 	def_bool y
 	depends on SMP && PREEMPT
@@ -585,9 +577,6 @@ config SH_CLK_CPG_LEGACY
 	depends on SH_CLK_CPG
 	def_bool y if !CPU_SUBTYPE_SH7785 && !ARCH_SHMOBILE && \
 		      !CPU_SHX3 && !CPU_SUBTYPE_SH7757
-
-source "kernel/time/Kconfig"
-
 endmenu
 
 menu "CPU Frequency scaling"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6c0683d..b5a035a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -30,11 +30,13 @@ config SPARC
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
+	select GENERIC_CMOS_UPDATE
 
 config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
+	select ARCH_USES_GETTIMEOFFSET
 
 config SPARC64
 	def_bool 64BIT
@@ -61,6 +63,7 @@ config SPARC64
 	select IRQ_PREFLOW_FASTEOI
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
+	select GENERIC_CLOCKEVENTS
 
 config ARCH_DEFCONFIG
 	string
@@ -73,18 +76,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config ARCH_USES_GETTIMEOFFSET
-	bool
-	default y if SPARC32
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
-config GENERIC_CLOCKEVENTS
-	bool
-	default y if SPARC64
-
 config IOMMU_HELPER
 	bool
 	default y if SPARC64
@@ -275,8 +266,6 @@ config HOTPLUG_CPU
 	  can be controlled through /sys/devices/system/cpu/cpu#.
 	  Say N if you want to disable CPU hotplug.
 
-source "kernel/time/Kconfig"
-
 if SPARC64
 source "drivers/cpufreq/Kconfig"
 
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 96033e2..4eec3a1 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -13,6 +13,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CLOCKEVENTS
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
@@ -46,9 +47,6 @@ config NEED_PER_CPU_PAGE_FIRST_CHUNK
 config SYS_SUPPORTS_HUGETLBFS
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 # FIXME: tilegx can implement a more efficient rwsem.
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
@@ -138,8 +136,6 @@ config NR_CPUS
 	  smaller kernel memory footprint results from using a smaller
 	  value on chips with fewer tiles.
 
-source "kernel/time/Kconfig"
-
 source "kernel/Kconfig.hz"
 
 config KEXEC
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 20a49ba..806185d 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -10,6 +10,7 @@ config UML
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	bool
@@ -52,10 +53,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool
diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index 70fd690..bf87f25 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -10,7 +10,6 @@ config STATIC_LINK
 	  2.75G) for UML.
 
 source "mm/Kconfig"
-source "kernel/time/Kconfig"
 
 config LD_SCRIPT_STATIC
 	bool
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index eeb8054..47ad521 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -25,9 +25,6 @@ config HAVE_PWM
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	bool
-
 config GENERIC_CSUM
 	def_bool y
 
@@ -146,8 +143,6 @@ endmenu
 
 menu "Kernel Features"
 
-source "kernel/time/Kconfig"
-
 source "kernel/Kconfig.preempt"
 
 source "kernel/Kconfig.hz"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9866b0..1b1e049 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -82,6 +82,13 @@ config X86
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS
+	select GENERIC_CMOS_UPDATE
+	select CLOCKSOURCE_WATCHDOG
+	select GENERIC_CLOCKEVENTS
+	select ARCH_CLOCKSOURCE_DATA if X86_64
+	select GENERIC_CLOCKEVENTS_BROADCAST if X86_64 || (X86_32 && X86_LOCAL_APIC)
+	select GENERIC_TIME_VSYSCALL if X86_64
+	select KTIME_SCALAR if X86_32
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -96,23 +103,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config CLOCKSOURCE_WATCHDOG
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config ARCH_CLOCKSOURCE_DATA
-	def_bool y
-	depends on X86_64
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	def_bool y
-	depends on X86_64 || (X86_32 && X86_LOCAL_APIC)
-
 config LOCKDEP_SUPPORT
 	def_bool y
 
@@ -166,10 +156,6 @@ config ARCH_HAS_CPU_IDLE_WAIT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	bool
-	default X86_64
-
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
@@ -236,9 +222,6 @@ config ARCH_HWEIGHT_CFLAGS
 	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
 	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
 
-config KTIME_SCALAR
-	def_bool X86_32
-
 config ARCH_CPU_PROBE_RELEASE
 	def_bool y
 	depends on HOTPLUG_CPU
@@ -258,8 +241,6 @@ config ZONE_DMA
 
 	  If unsure, say Y.
 
-source "kernel/time/Kconfig"
-
 config SMP
 	bool "Symmetric multi-processing support"
 	---help---
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad0de0c..9cc7b43 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -94,13 +94,18 @@ static int hpet_verbose;
 
 static int __init hpet_setup(char *str)
 {
-	if (str) {
+	while (str) {
+		char *next = strchr(str, ',');
+
+		if (next)
+			*next++ = 0;
 		if (!strncmp("disable", str, 7))
 			boot_hpet_disable = 1;
 		if (!strncmp("force", str, 5))
 			hpet_force_user = 1;
 		if (!strncmp("verbose", str, 7))
 			hpet_verbose = 1;
+		str = next;
 	}
 	return 1;
 }
@@ -319,8 +324,6 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		now = hpet_readl(HPET_COUNTER);
 		cmp = now + (unsigned int) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
-		/* Make sure we use edge triggered interrupts */
-		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
@@ -787,15 +790,16 @@ static int hpet_clocksource_register(void)
 	return 0;
 }
 
+static u32 *hpet_boot_cfg;
+
 /**
  * hpet_enable - Try to setup the HPET timer. Returns 1 on success.
  */
 int __init hpet_enable(void)
 {
-	unsigned long hpet_period;
-	unsigned int id;
+	u32 hpet_period, cfg, id;
 	u64 freq;
-	int i;
+	unsigned int i, last;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -847,15 +851,45 @@ int __init hpet_enable(void)
 	id = hpet_readl(HPET_ID);
 	hpet_print_config();
 
+	last = (id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT;
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
 	 * The legacy routing mode needs at least two channels, tick timer
 	 * and the rtc emulation channel.
 	 */
-	if (!(id & HPET_ID_NUMBER))
+	if (!last)
 		goto out_nohpet;
 #endif
 
+	cfg = hpet_readl(HPET_CFG);
+	hpet_boot_cfg = kmalloc((last + 2) * sizeof(*hpet_boot_cfg),
+				GFP_KERNEL);
+	if (hpet_boot_cfg)
+		*hpet_boot_cfg = cfg;
+	else
+		pr_warn("HPET initial state will not be saved\n");
+	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
+	hpet_writel(cfg, HPET_Tn_CFG(i));
+	if (cfg)
+		pr_warn("HPET: Unrecognized bits %#x set in global cfg\n",
+			cfg);
+
+	for (i = 0; i <= last; ++i) {
+		cfg = hpet_readl(HPET_Tn_CFG(i));
+		if (hpet_boot_cfg)
+			hpet_boot_cfg[i + 1] = cfg;
+		cfg &= ~(HPET_TN_ENABLE | HPET_TN_LEVEL | HPET_TN_FSB);
+		hpet_writel(cfg, HPET_Tn_CFG(i));
+		cfg &= ~(HPET_TN_PERIODIC | HPET_TN_PERIODIC_CAP
+			 | HPET_TN_64BIT_CAP | HPET_TN_32BIT | HPET_TN_ROUTE
+			 | HPET_TN_FSB | HPET_TN_FSB_CAP);
+		if (cfg)
+			pr_warn("HPET: Unrecognized bits %#x set in cfg#%u\n",
+				cfg, i);
+	}
+	hpet_print_config();
+
 	if (hpet_clocksource_register())
 		goto out_nohpet;
 
@@ -923,14 +957,28 @@ fs_initcall(hpet_late_init);
 void hpet_disable(void)
 {
 	if (is_hpet_capable() && hpet_virt_address) {
-		unsigned int cfg = hpet_readl(HPET_CFG);
+		unsigned int cfg = hpet_readl(HPET_CFG), id, last;
 
-		if (hpet_legacy_int_enabled) {
+		if (hpet_boot_cfg)
+			cfg = *hpet_boot_cfg;
+		else if (hpet_legacy_int_enabled) {
 			cfg &= ~HPET_CFG_LEGACY;
 			hpet_legacy_int_enabled = 0;
 		}
 		cfg &= ~HPET_CFG_ENABLE;
 		hpet_writel(cfg, HPET_CFG);
+
+		if (!hpet_boot_cfg)
+			return;
+
+		id = hpet_readl(HPET_ID);
+		last = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
+
+		for (id = 0; id <= last; ++id)
+			hpet_writel(hpet_boot_cfg[id + 1], HPET_Tn_CFG(id));
+
+		if (*hpet_boot_cfg & HPET_CFG_ENABLE)
+			hpet_writel(*hpet_boot_cfg, HPET_CFG);
 	}
 }
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 33a92ea..179f4d6 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -167,7 +167,6 @@ extern void get_monotonic_boottime(struct timespec *ts);
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
-extern void timekeeping_leap_insert(int leapsecond);
 extern int timekeeping_inject_offset(struct timespec *ts);
 
 struct tms;
diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..528a0c4 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -387,6 +387,7 @@ config AUDIT_LOGINUID_IMMUTABLE
 	  but may not be backwards compatible with older init systems.
 
 source "kernel/irq/Kconfig"
+source "kernel/time/Kconfig"
 
 menu "RCU Subsystem"
 
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index a20dc8a..fd42bd4 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -2,6 +2,55 @@
 # Timer subsystem related configuration options
 #
 
+# Options selectable by arch Kconfig
+
+# Watchdog function for clocksources to detect instabilities
+config CLOCKSOURCE_WATCHDOG
+	bool
+
+# Architecture has extra clocksource data
+config ARCH_CLOCKSOURCE_DATA
+	bool
+
+# Timekeeping vsyscall support
+config GENERIC_TIME_VSYSCALL
+	bool
+
+# ktime_t scalar 64bit nsec representation
+config KTIME_SCALAR
+	bool
+
+# Old style timekeeping
+config ARCH_USES_GETTIMEOFFSET
+	bool
+
+# The generic clock events infrastructure
+config GENERIC_CLOCKEVENTS
+	bool
+
+# Migration helper. Builds, but does not invoke
+config GENERIC_CLOCKEVENTS_BUILD
+	bool
+	default y
+	depends on GENERIC_CLOCKEVENTS
+
+# Clockevents broadcasting infrastructure
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	depends on GENERIC_CLOCKEVENTS
+
+# Automatically adjust the min. reprogramming time for
+# clock event device
+config GENERIC_CLOCKEVENTS_MIN_ADJUST
+	bool
+
+# Generic update of CMOS clock
+config GENERIC_CMOS_UPDATE
+	bool
+
+if GENERIC_CLOCKEVENTS
+menu "Timers subsystem"
+
 # Core internal switch. Selected by NO_HZ / HIGH_RES_TIMERS. This is
 # only related to the tick functionality. Oneshot clockevent devices
 # are supported independ of this.
@@ -26,10 +75,5 @@ config HIGH_RES_TIMERS
 	  hardware is not capable then this option only increases
 	  the size of the kernel image.
 
-config GENERIC_CLOCKEVENTS_BUILD
-	bool
-	default y
-	depends on GENERIC_CLOCKEVENTS
-
-config GENERIC_CLOCKEVENTS_MIN_ADJUST
-	bool
+endmenu
+endif
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index f03fd83..70b33ab 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -412,6 +412,7 @@ int second_overflow(unsigned long secs)
 		if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
+			time_tai++;
 			printk(KERN_NOTICE
 				"Clock: inserting leap second 23:59:60 UTC\n");
 		}
@@ -426,7 +427,6 @@ int second_overflow(unsigned long secs)
 		}
 		break;
 	case TIME_OOP:
-		time_tai++;
 		time_state = TIME_WAIT;
 		break;
 
@@ -473,8 +473,6 @@ int second_overflow(unsigned long secs)
 							 << NTP_SCALE_SHIFT;
 	time_adjust = 0;
 
-
-
 out:
 	spin_unlock_irqrestore(&ntp_lock, flags);
 
@@ -559,10 +557,10 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
 	/* only set allowed bits */
 	time_status &= STA_RONLY;
 	time_status |= txc->status & ~STA_RONLY;
-
 }
+
 /*
- * Called with the xtime lock held, so we can access and modify
+ * Called with ntp_lock held, so we can access and modify
  * all the global NTP state:
  */
 static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d66b213..6e46cac 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -240,7 +240,6 @@ void getnstimeofday(struct timespec *ts)
 
 	timespec_add_ns(ts, nsecs);
 }
-
 EXPORT_SYMBOL(getnstimeofday);
 
 ktime_t ktime_get(void)
@@ -357,8 +356,8 @@ void do_gettimeofday(struct timeval *tv)
 	tv->tv_sec = now.tv_sec;
 	tv->tv_usec = now.tv_nsec/1000;
 }
-
 EXPORT_SYMBOL(do_gettimeofday);
+
 /**
  * do_settimeofday - Sets the time of day
  * @tv:		pointer to the timespec variable containing the new time
@@ -392,7 +391,6 @@ int do_settimeofday(const struct timespec *tv)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(do_settimeofday);
 
 
