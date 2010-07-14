Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab0GNA55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:57:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52974 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab0GNA4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:56:31 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/11] time: Kill off CONFIG_GENERIC_TIME
Date: Tue, 13 Jul 2010 17:56:20 -0700
Message-Id: <1279068988-21864-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
References: <1279068988-21864-1-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-2-git-send-email-johnstul@us.ibm.com>
 <1279068988-21864-3-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all arches have been converted over to use generic time via clocksources or arch_gettimeoffset(), we can remove the GENERIC_TIME config option and simplify the generic code.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/kernel-parameters.txt |    3 +-
 arch/alpha/Kconfig                  |    4 --
 arch/arm/Kconfig                    |    4 --
 arch/avr32/Kconfig                  |    3 --
 arch/blackfin/Kconfig               |    3 --
 arch/cris/Kconfig                   |    3 --
 arch/frv/Kconfig                    |    4 --
 arch/h8300/Kconfig                  |    4 --
 arch/ia64/Kconfig                   |    4 --
 arch/m32r/Kconfig                   |    3 --
 arch/m68k/Kconfig                   |    3 --
 arch/m68knommu/Kconfig              |    4 --
 arch/microblaze/Kconfig             |    3 --
 arch/mips/Kconfig                   |    4 --
 arch/mn10300/Kconfig                |    3 --
 arch/parisc/Kconfig                 |    4 --
 arch/powerpc/Kconfig                |    3 --
 arch/s390/Kconfig                   |    3 --
 arch/score/Kconfig                  |    3 --
 arch/sh/Kconfig                     |    3 --
 arch/sparc/Kconfig                  |    3 --
 arch/um/Kconfig.common              |    4 --
 arch/x86/Kconfig                    |    5 +--
 arch/xtensa/Kconfig                 |    3 --
 drivers/Makefile                    |    4 ++-
 drivers/acpi/acpi_pad.c             |    2 +-
 drivers/acpi/processor_idle.c       |    2 +-
 drivers/misc/Kconfig                |    4 +-
 kernel/time.c                       |   16 ----------
 kernel/time/Kconfig                 |    4 +-
 kernel/time/clocksource.c           |    4 +-
 kernel/time/timekeeping.c           |   55 ++--------------------------------
 kernel/trace/Kconfig                |    4 +-
 33 files changed, 19 insertions(+), 159 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82d6aeb..1014f91 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -73,7 +73,6 @@ parameter is applicable:
 	MTD	MTD (Memory Technology Device) support is enabled.
 	NET	Appropriate network support is enabled.
 	NUMA	NUMA support is enabled.
-	GENERIC_TIME The generic timeofday code is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
@@ -468,7 +467,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			clocksource is not available, it defaults to PIT.
 			Format: { pit | tsc | cyclone | pmtmr }
 
-	clocksource=	[GENERIC_TIME] Override the default clocksource
+	clocksource=	Override the default clocksource
 			Format: <string>
 			Override the default clocksource and use the clocksource
 			with the name specified.
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 3e2e540..b9647bb 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -47,10 +47,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
         def_bool y
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 98922f7..655b4ae 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -41,10 +41,6 @@ config SYS_SUPPORTS_APM_EMULATION
 config GENERIC_GPIO
 	bool
 
-config GENERIC_TIME
-	bool
-	default y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default n
diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index f2b3193..f515727 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -45,9 +45,6 @@ config GENERIC_IRQ_PROBE
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f66294b..c88fd35 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -614,9 +614,6 @@ comment "Kernel Timer/Scheduler"
 
 source kernel/Kconfig.hz
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	bool "Generic clock events"
 	default y
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index e25bf44..887ef85 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -20,9 +20,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
diff --git a/arch/frv/Kconfig b/arch/frv/Kconfig
index 4b5830b..16399bd 100644
--- a/arch/frv/Kconfig
+++ b/arch/frv/Kconfig
@@ -40,10 +40,6 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	default y
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 53cc669..988b6ff 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -62,10 +62,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_BUG
         bool
         depends on BUG
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 9561082..8711d13 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -82,10 +82,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_TIME_VSYSCALL
 	bool
 	default y
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 3a9319f..836abbb 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -44,9 +44,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2e3737b..8030e24 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -59,9 +59,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index efeb603..2609c39 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -63,10 +63,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 76818f9..c96dab8 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -48,9 +48,6 @@ config GENERIC_IRQ_PROBE
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool n
 
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cdaae94..01c44cb 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -733,10 +733,6 @@ config GENERIC_CLOCKEVENTS
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CMOS_UPDATE
 	bool
 	default y
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 1c4565a..444b9f9 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -46,9 +46,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 05a366a..907417d 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -66,10 +66,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME
-	bool
-	default y
-
 config TIME_LOW_RES
 	bool
 	depends on SMP
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6506bf4..dd12626 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -29,9 +29,6 @@ config MMU
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bee1c0f..f0777a4 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -40,9 +40,6 @@ config ARCH_HAS_ILOG2_U64
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_TIME_VSYSCALL
 	def_bool y
 
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 55d413e..be4a155 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -55,9 +55,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	def_bool y
 
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 573fca1..1d0a711 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -98,9 +98,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_IOMAP
 	bool
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 6f1470b..0011052 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -66,9 +66,6 @@ config BITS
 	default 32 if SPARC32
 	default 64 if SPARC64
 
-config GENERIC_TIME
-	def_bool y
-
 config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y if SPARC32
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 0d207e7..7c8e277 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -55,10 +55,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config GENERIC_TIME
-	bool
-	default y
-
 config GENERIC_CLOCKEVENTS
 	bool
 	default y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..546b610 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -72,9 +72,6 @@ config ARCH_DEFCONFIG
 	default "arch/x86/configs/i386_defconfig" if X86_32
 	default "arch/x86/configs/x86_64_defconfig" if X86_64
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CMOS_UPDATE
 	def_bool y
 
@@ -2046,7 +2043,7 @@ config SCx200
 
 config SCx200HR_TIMER
 	tristate "NatSemi SCx200 27MHz High-Resolution Timer Support"
-	depends on SCx200 && GENERIC_TIME
+	depends on SCx200
 	default y
 	---help---
 	  This driver provides a clocksource built upon the on-chip
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ebe228d..0859bfd 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -48,9 +48,6 @@ config HZ
 	int
 	default 100
 
-config GENERIC_TIME
-	def_bool y
-
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/drivers/Makefile b/drivers/Makefile
index 91874e0..ae47344 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -101,7 +101,9 @@ obj-y				+= firmware/
 obj-$(CONFIG_CRYPTO)		+= crypto/
 obj-$(CONFIG_SUPERH)		+= sh/
 obj-$(CONFIG_ARCH_SHMOBILE)	+= sh/
-obj-$(CONFIG_GENERIC_TIME)	+= clocksource/
+ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
+obj-y				+= clocksource/
+endif
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
 obj-$(CONFIG_DCA)		+= dca/
 obj-$(CONFIG_HID)		+= hid/
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 446aced..b76848c 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -77,7 +77,7 @@ static void power_saving_mwait_init(void)
 	power_saving_mwait_eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
 		(highest_subcstate - 1);
 
-#if defined(CONFIG_GENERIC_TIME) && defined(CONFIG_X86)
+#if defined(CONFIG_X86)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 	case X86_VENDOR_INTEL:
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b1b3856..0e562d0 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -259,7 +259,7 @@ int acpi_processor_resume(struct acpi_device * device)
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
+#if defined(CONFIG_X86)
 static void tsc_check_state(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 26386a9..5b9ba48 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -72,7 +72,7 @@ config ATMEL_TCLIB
 
 config ATMEL_TCB_CLKSRC
 	bool "TC Block Clocksource"
-	depends on ATMEL_TCLIB && GENERIC_TIME
+	depends on ATMEL_TCLIB
 	default y
 	help
 	  Select this to get a high precision clocksource based on a
@@ -240,7 +240,7 @@ config CS5535_MFGPT_DEFAULT_IRQ
 
 config CS5535_CLOCK_EVENT_SRC
 	tristate "CS5535/CS5536 high-res timer (MFGPT) events"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS && CS5535_MFGPT
+	depends on GENERIC_CLOCKEVENTS && CS5535_MFGPT
 	help
 	  This driver provides a clock event source based on the MFGPT
 	  timer(s) in the CS5535 and CS5536 companion chips.
diff --git a/kernel/time.c b/kernel/time.c
index 848b1c2..ba9b338 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -300,22 +300,6 @@ struct timespec timespec_trunc(struct timespec t, unsigned gran)
 }
 EXPORT_SYMBOL(timespec_trunc);
 
-#ifndef CONFIG_GENERIC_TIME
-/*
- * Simulate gettimeofday using do_gettimeofday which only allows a timeval
- * and therefore only yields usec accuracy
- */
-void getnstimeofday(struct timespec *tv)
-{
-	struct timeval x;
-
-	do_gettimeofday(&x);
-	tv->tv_sec = x.tv_sec;
-	tv->tv_nsec = x.tv_usec * NSEC_PER_USEC;
-}
-EXPORT_SYMBOL_GPL(getnstimeofday);
-#endif
-
 /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
  * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
  * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 95ed429..f06a8a3 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -6,7 +6,7 @@ config TICK_ONESHOT
 
 config NO_HZ
 	bool "Tickless System (Dynamic Ticks)"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables a tickless system: timer interrupts will
@@ -15,7 +15,7 @@ config NO_HZ
 
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
-	depends on GENERIC_TIME && GENERIC_CLOCKEVENTS
+	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
 	select TICK_ONESHOT
 	help
 	  This option enables high resolution timer support. If your
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index f08e99c..c543d21 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -531,7 +531,7 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 	return max_nsecs - (max_nsecs >> 5);
 }
 
-#ifdef CONFIG_GENERIC_TIME
+#ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
 
 /**
  * clocksource_select - Select the best clocksource available
@@ -577,7 +577,7 @@ static void clocksource_select(void)
 	}
 }
 
-#else /* CONFIG_GENERIC_TIME */
+#else /* !CONFIG_ARCH_USES_GETTIMEOFFSET */
 
 static inline void clocksource_select(void) { }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 623fe3d..73edd40 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -173,8 +173,6 @@ void timekeeping_leap_insert(int leapsecond)
 	update_vsyscall(&xtime, timekeeper.clock, timekeeper.mult);
 }
 
-#ifdef CONFIG_GENERIC_TIME
-
 /**
  * timekeeping_forward_now - update clock to the current time
  *
@@ -376,52 +374,6 @@ void timekeeping_notify(struct clocksource *clock)
 	tick_clock_notify();
 }
 
-#else /* GENERIC_TIME */
-
-static inline void timekeeping_forward_now(void) { }
-
-/**
- * ktime_get - get the monotonic time in ktime_t format
- *
- * returns the time in ktime_t format
- */
-ktime_t ktime_get(void)
-{
-	struct timespec now;
-
-	ktime_get_ts(&now);
-
-	return timespec_to_ktime(now);
-}
-EXPORT_SYMBOL_GPL(ktime_get);
-
-/**
- * ktime_get_ts - get the monotonic clock in timespec format
- * @ts:		pointer to timespec variable
- *
- * The function calculates the monotonic clock from the realtime
- * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by @ts.
- */
-void ktime_get_ts(struct timespec *ts)
-{
-	struct timespec tomono;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		getnstimeofday(ts);
-		tomono = wall_to_monotonic;
-
-	} while (read_seqretry(&xtime_lock, seq));
-
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec);
-}
-EXPORT_SYMBOL_GPL(ktime_get_ts);
-
-#endif /* !GENERIC_TIME */
-
 /**
  * ktime_get_real - get the real (wall-) time in ktime_t format
  *
@@ -784,10 +736,11 @@ void update_wall_time(void)
 		return;
 
 	clock = timekeeper.clock;
-#ifdef CONFIG_GENERIC_TIME
-	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
-#else
+
+#ifdef CONFIG_ARCH_USES_GETTIMEOFFSET
 	offset = timekeeper.cycle_interval;
+#else
+	offset = (clock->read(clock) - clock->cycle_last) & clock->mask;
 #endif
 	timekeeper.xtime_nsec = (s64)xtime.tv_nsec << timekeeper.shift;
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 8b1797c..7531dda 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -153,7 +153,7 @@ config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
 	default n
 	depends on TRACE_IRQFLAGS_SUPPORT
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	select TRACE_IRQFLAGS
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
@@ -175,7 +175,7 @@ config IRQSOFF_TRACER
 config PREEMPT_TRACER
 	bool "Preemption-off Latency Tracer"
 	default n
-	depends on GENERIC_TIME
+	depends on !ARCH_USES_GETTIMEOFFSET
 	depends on PREEMPT
 	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
-- 
1.6.0.4

