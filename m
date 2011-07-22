Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1GVOIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:08:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44316 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1GVOIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:08:18 -0400
Date: Fri, 22 Jul 2011 16:07:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/cleanups for v3.1
Message-ID: <20110722140729.GA2376@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-cleanup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-cleanup-for-linus

 Thanks,

	Ingo

------------------>
Ralf Baechle (12):
      i8253: Create linux/i8253.h and use it in all 8253 related files
      i8253: Unify all kernel declarations of i8253_lock
      i8253: Consolidate all kernel definitions of i8253_lock
      i8253: Make pcspkr input driver use the shared i8253_lock
      i8253: Make pcsp sound driver use the shared i8253_lock
      alpha: i8253: Cleanup remaining users of i8253pit.h
      i8253: Alpha, PowerPC: Remove unused asm/8253pit.h
      x86: i8253: Consolidate definitions of global_clock_event
      i8253: Consolidate definitions of PIT_LATCH
      i8253: Move remaining content and delete asm/i8253.h
      pcspkr: Cleanup Kconfig dependencies
      pcpskr: MIPS: Make config dependencies finer grained

Thomas Gleixner (8):
      i8253: Remove I8253_LOCK config
      i8253: Export i8253_lock unconditionally
      i8253: Create common clockevent implementation
      x86: Use common i8253 clockevent
      mips: Use common i8253 clockevent
      arm: Footbridge: Use common i8253 clockevent
      i8253: Cleanup outb/inb magic
      mips: Fix i8253 clockevent fallout


 arch/alpha/Kconfig                      |    1 +
 arch/alpha/include/asm/8253pit.h        |    3 -
 arch/alpha/kernel/sys_ruffian.c         |    1 -
 arch/alpha/kernel/time.c                |    1 -
 arch/arm/include/asm/i8253.h            |   15 ----
 arch/arm/mach-footbridge/Kconfig        |    1 +
 arch/arm/mach-footbridge/isa-timer.c    |   59 +---------------
 arch/mips/Kconfig                       |    4 +
 arch/mips/cobalt/time.c                 |    2 +-
 arch/mips/include/asm/i8253.h           |   24 -------
 arch/mips/jazz/irq.c                    |    2 +-
 arch/mips/kernel/i8253.c                |  102 +---------------------------
 arch/mips/mti-malta/malta-time.c        |    2 +-
 arch/mips/sgi-ip22/ip22-time.c          |    2 +-
 arch/mips/sni/time.c                    |    2 +-
 arch/powerpc/include/asm/8253pit.h      |    3 -
 arch/powerpc/platforms/amigaone/Kconfig |    2 +-
 arch/powerpc/platforms/chrp/Kconfig     |    1 +
 arch/powerpc/platforms/prep/Kconfig     |    1 +
 arch/powerpc/platforms/pseries/Kconfig  |    1 +
 arch/x86/Kconfig                        |    2 +
 arch/x86/include/asm/apb_timer.h        |    1 -
 arch/x86/include/asm/i8253.h            |   20 ------
 arch/x86/include/asm/time.h             |    6 +-
 arch/x86/kernel/apb_timer.c             |    1 +
 arch/x86/kernel/apic/apic.c             |    3 +-
 arch/x86/kernel/apm_32.c                |    8 +-
 arch/x86/kernel/hpet.c                  |    3 +-
 arch/x86/kernel/i8253.c                 |   99 ++-------------------------
 arch/x86/kernel/time.c                  |    2 +-
 drivers/block/hd.c                      |    2 +-
 drivers/clocksource/Kconfig             |    9 +++
 drivers/clocksource/Makefile            |    2 +-
 drivers/clocksource/i8253.c             |  114 ++++++++++++++++++++++++++++--
 drivers/input/gameport/gameport.c       |    2 +-
 drivers/input/joystick/analog.c         |    2 +-
 drivers/input/misc/pcspkr.c             |    9 +--
 include/linux/i8253.h                   |   29 ++++++++
 init/Kconfig                            |    7 ++-
 sound/drivers/pcsp/pcsp.h               |    8 +--
 40 files changed, 199 insertions(+), 359 deletions(-)
 delete mode 100644 arch/alpha/include/asm/8253pit.h
 delete mode 100644 arch/arm/include/asm/i8253.h
 delete mode 100644 arch/mips/include/asm/i8253.h
 delete mode 100644 arch/powerpc/include/asm/8253pit.h
 delete mode 100644 arch/x86/include/asm/i8253.h
 create mode 100644 include/linux/i8253.h

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 60219bf..ca2da8d 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -6,6 +6,7 @@ config ALPHA
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_IRQ_WORK
+	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_HARDIRQS
diff --git a/arch/alpha/include/asm/8253pit.h b/arch/alpha/include/asm/8253pit.h
deleted file mode 100644
index a71c9c1..0000000
--- a/arch/alpha/include/asm/8253pit.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/*
- * 8253/8254 Programmable Interval Timer
- */
diff --git a/arch/alpha/kernel/sys_ruffian.c b/arch/alpha/kernel/sys_ruffian.c
index 8de1046..f33648e 100644
--- a/arch/alpha/kernel/sys_ruffian.c
+++ b/arch/alpha/kernel/sys_ruffian.c
@@ -26,7 +26,6 @@
 #include <asm/pgtable.h>
 #include <asm/core_cia.h>
 #include <asm/tlbflush.h>
-#include <asm/8253pit.h>
 
 #include "proto.h"
 #include "irq_impl.h"
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 818e74e..de406c7 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -46,7 +46,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/hwrpb.h>
-#include <asm/8253pit.h>
 #include <asm/rtc.h>
 
 #include <linux/mc146818rtc.h>
diff --git a/arch/arm/include/asm/i8253.h b/arch/arm/include/asm/i8253.h
deleted file mode 100644
index 70656b6..0000000
--- a/arch/arm/include/asm/i8253.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef __ASMARM_I8253_H
-#define __ASMARM_I8253_H
-
-/* i8253A PIT registers */
-#define PIT_MODE	0x43
-#define PIT_CH0		0x40
-
-#define PIT_LATCH	((PIT_TICK_RATE + HZ / 2) / HZ)
-
-extern raw_spinlock_t i8253_lock;
-
-#define outb_pit	outb_p
-#define inb_pit		inb_p
-
-#endif
diff --git a/arch/arm/mach-footbridge/Kconfig b/arch/arm/mach-footbridge/Kconfig
index 46adca0..dc26fff 100644
--- a/arch/arm/mach-footbridge/Kconfig
+++ b/arch/arm/mach-footbridge/Kconfig
@@ -5,6 +5,7 @@ menu "Footbridge Implementations"
 config ARCH_CATS
 	bool "CATS"
 	select CLKSRC_I8253
+	select CLKEVT_I8253
 	select FOOTBRIDGE_HOST
 	select ISA
 	select ISA_DMA
diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index 7020f1a..c40bb41 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
@@ -5,64 +5,18 @@
  *  Copyright (C) 1998 Phil Blundell
  */
 #include <linux/clockchips.h>
-#include <linux/clocksource.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/timex.h>
 
 #include <asm/irq.h>
-#include <asm/i8253.h>
 #include <asm/mach/time.h>
 
 #include "common.h"
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-
-static void pit_set_mode(enum clock_event_mode mode,
-	struct clock_event_device *evt)
-{
-	unsigned long flags;
-
-	raw_local_irq_save(flags);
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		outb_p(0x34, PIT_MODE);
-		outb_p(PIT_LATCH & 0xff, PIT_CH0);
-		outb_p(PIT_LATCH >> 8, PIT_CH0);
-		break;
-
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_UNUSED:
-		outb_p(0x30, PIT_MODE);
-		outb_p(0, PIT_CH0);
-		outb_p(0, PIT_CH0);
-		break;
-
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
-		break;
-	}
-	local_irq_restore(flags);
-}
-
-static int pit_set_next_event(unsigned long delta,
-	struct clock_event_device *evt)
-{
-	return 0;
-}
-
-static struct clock_event_device pit_ce = {
-	.name		= "pit",
-	.features	= CLOCK_EVT_FEAT_PERIODIC,
-	.set_mode	= pit_set_mode,
-	.set_next_event	= pit_set_next_event,
-	.shift		= 32,
-};
-
 static irqreturn_t pit_timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *ce = dev_id;
@@ -74,20 +28,15 @@ static struct irqaction pit_timer_irq = {
 	.name		= "pit",
 	.handler	= pit_timer_interrupt,
 	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
-	.dev_id		= &pit_ce,
+	.dev_id		= &i8253_clockevent,
 };
 
 static void __init isa_timer_init(void)
 {
-	pit_ce.cpumask = cpumask_of(smp_processor_id());
-	pit_ce.mult = div_sc(PIT_TICK_RATE, NSEC_PER_SEC, pit_ce.shift);
-	pit_ce.max_delta_ns = clockevent_delta2ns(0x7fff, &pit_ce);
-	pit_ce.min_delta_ns = clockevent_delta2ns(0x000f, &pit_ce);
-
 	clocksource_i8253_init();
 
-	setup_irq(pit_ce.irq, &pit_timer_irq);
-	clockevents_register_device(&pit_ce);
+	setup_irq(i8253_clockevent.irq, &pit_timer_irq);
+	clockevent_i8253_init(false);
 }
 
 struct sys_timer isa_timer = {
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 653da62..6cb60ad 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -185,6 +185,7 @@ config MACH_JAZZ
 	select CSRC_R4K
 	select DEFAULT_SGI_PARTITION if CPU_BIG_ENDIAN
 	select GENERIC_ISA_DMA
+	select HAVE_PCSPKR_PLATFORM
 	select IRQ_CPU
 	select I8253
 	select I8259
@@ -266,6 +267,7 @@ config MIPS_MALTA
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA
+	select HAVE_PCSPKR_PLATFORM
 	select IRQ_CPU
 	select IRQ_GIC
 	select HW_HAS_PCI
@@ -640,6 +642,7 @@ config SNI_RM
 	select DEFAULT_SGI_PARTITION if CPU_BIG_ENDIAN
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA
+	select HAVE_PCSPKR_PLATFORM
 	select HW_HAS_EISA
 	select HW_HAS_PCI
 	select IRQ_CPU
@@ -2388,6 +2391,7 @@ config MMU
 config I8253
 	bool
 	select CLKSRC_I8253
+	select CLKEVT_I8253
 	select MIPS_EXTERNAL_TIMER
 
 config ZONE_DMA32
diff --git a/arch/mips/cobalt/time.c b/arch/mips/cobalt/time.c
index 0162f9e..3bff3b8 100644
--- a/arch/mips/cobalt/time.c
+++ b/arch/mips/cobalt/time.c
@@ -17,10 +17,10 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  */
+#include <linux/i8253.h>
 #include <linux/init.h>
 
 #include <asm/gt64120.h>
-#include <asm/i8253.h>
 #include <asm/time.h>
 
 #define GT641XX_BASE_CLOCK	50000000	/* 50MHz */
diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
deleted file mode 100644
index 9ad0113..0000000
--- a/arch/mips/include/asm/i8253.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- *  Machine specific IO port address definition for generic.
- *  Written by Osamu Tomita <tomita@cinet.co.jp>
- */
-#ifndef __ASM_I8253_H
-#define __ASM_I8253_H
-
-#include <linux/spinlock.h>
-
-/* i8253A PIT registers */
-#define PIT_MODE		0x43
-#define PIT_CH0			0x40
-#define PIT_CH2			0x42
-
-#define PIT_LATCH		LATCH
-
-extern raw_spinlock_t i8253_lock;
-
-extern void setup_pit_timer(void);
-
-#define inb_pit inb_p
-#define outb_pit outb_p
-
-#endif /* __ASM_I8253_H */
diff --git a/arch/mips/jazz/irq.c b/arch/mips/jazz/irq.c
index 260df47..ca9bd20 100644
--- a/arch/mips/jazz/irq.c
+++ b/arch/mips/jazz/irq.c
@@ -7,6 +7,7 @@
  * Copyright (C) 1994 - 2001, 2003, 07 Ralf Baechle
  */
 #include <linux/clockchips.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -15,7 +16,6 @@
 #include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
-#include <asm/i8253.h>
 #include <asm/i8259.h>
 #include <asm/io.h>
 #include <asm/jazz.h>
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index 391221b..be4ee7d 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -3,96 +3,16 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/jiffies.h>
+#include <linux/i8253.h>
 #include <linux/module.h>
 #include <linux/smp.h>
-#include <linux/spinlock.h>
 #include <linux/irq.h>
 
-#include <asm/delay.h>
-#include <asm/i8253.h>
-#include <asm/io.h>
 #include <asm/time.h>
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
-
-/*
- * Initialize the PIT timer.
- *
- * This is also called after resume to bring the PIT into operation again.
- */
-static void init_pit_timer(enum clock_event_mode mode,
-			   struct clock_event_device *evt)
-{
-	raw_spin_lock(&i8253_lock);
-
-	switch(mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		/* binary, mode 2, LSB/MSB, ch 0 */
-		outb_p(0x34, PIT_MODE);
-		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
-		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
-		break;
-
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
-		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-			outb_p(0x30, PIT_MODE);
-			outb_p(0, PIT_CH0);
-			outb_p(0, PIT_CH0);
-		}
-		break;
-
-	case CLOCK_EVT_MODE_ONESHOT:
-		/* One shot setup */
-		outb_p(0x38, PIT_MODE);
-		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
-		break;
-	}
-	raw_spin_unlock(&i8253_lock);
-}
-
-/*
- * Program the next event in oneshot mode
- *
- * Delta is given in PIT ticks
- */
-static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
-{
-	raw_spin_lock(&i8253_lock);
-	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
-	outb(delta >> 8 , PIT_CH0);	/* MSB */
-	raw_spin_unlock(&i8253_lock);
-
-	return 0;
-}
-
-/*
- * On UP the PIT can serve all of the possible timer functions. On SMP systems
- * it can be solely used for the global tick.
- *
- * The profiling and update capabilites are switched off once the local apic is
- * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
- * !using_apic_timer decisions in do_timer_interrupt_hook()
- */
-static struct clock_event_device pit_clockevent = {
-	.name		= "pit",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= init_pit_timer,
-	.set_next_event = pit_next_event,
-	.irq		= 0,
-};
-
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	pit_clockevent.event_handler(&pit_clockevent);
+	i8253_clockevent.event_handler(&i8253_clockevent);
 
 	return IRQ_HANDLED;
 }
@@ -103,25 +23,9 @@ static struct irqaction irq0  = {
 	.name = "timer"
 };
 
-/*
- * Initialize the conversion factor and the min/max deltas of the clock event
- * structure and register the clock event source with the framework.
- */
 void __init setup_pit_timer(void)
 {
-	struct clock_event_device *cd = &pit_clockevent;
-	unsigned int cpu = smp_processor_id();
-
-	/*
-	 * Start pit with the boot cpu mask and make it global after the
-	 * IO_APIC has been initialized.
-	 */
-	cd->cpumask = cpumask_of(cpu);
-	clockevent_set_clock(cd, CLOCK_TICK_RATE);
-	cd->max_delta_ns = clockevent_delta2ns(0x7FFF, cd);
-	cd->min_delta_ns = clockevent_delta2ns(0xF, cd);
-	clockevents_register_device(cd);
-
+	clockevent_i8253_init(true);
 	setup_irq(0, &irq0);
 }
 
diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index 1620b83..f8ee945 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/kernel_stat.h>
 #include <linux/sched.h>
@@ -31,7 +32,6 @@
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
 #include <asm/hardirq.h>
-#include <asm/i8253.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 #include <asm/cpu.h>
diff --git a/arch/mips/sgi-ip22/ip22-time.c b/arch/mips/sgi-ip22/ip22-time.c
index 1a94c98..6071924 100644
--- a/arch/mips/sgi-ip22/ip22-time.c
+++ b/arch/mips/sgi-ip22/ip22-time.c
@@ -10,6 +10,7 @@
  * Copyright (C) 2003, 06 Ralf Baechle (ralf@linux-mips.org)
  */
 #include <linux/bcd.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/kernel.h>
@@ -20,7 +21,6 @@
 
 #include <asm/cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/i8253.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/time.h>
diff --git a/arch/mips/sni/time.c b/arch/mips/sni/time.c
index 0904d4d..ec0be14 100644
--- a/arch/mips/sni/time.c
+++ b/arch/mips/sni/time.c
@@ -1,11 +1,11 @@
 #include <linux/types.h>
+#include <linux/i8253.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/smp.h>
 #include <linux/time.h>
 #include <linux/clockchips.h>
 
-#include <asm/i8253.h>
 #include <asm/sni.h>
 #include <asm/time.h>
 #include <asm-generic/rtc.h>
diff --git a/arch/powerpc/include/asm/8253pit.h b/arch/powerpc/include/asm/8253pit.h
deleted file mode 100644
index a71c9c1..0000000
--- a/arch/powerpc/include/asm/8253pit.h
+++ /dev/null
@@ -1,3 +0,0 @@
-/*
- * 8253/8254 Programmable Interval Timer
- */
diff --git a/arch/powerpc/platforms/amigaone/Kconfig b/arch/powerpc/platforms/amigaone/Kconfig
index 0224767..128de25 100644
--- a/arch/powerpc/platforms/amigaone/Kconfig
+++ b/arch/powerpc/platforms/amigaone/Kconfig
@@ -8,7 +8,7 @@ config AMIGAONE
 	select NOT_COHERENT_CACHE
 	select CHECK_CACHE_COHERENCY
 	select DEFAULT_UIMAGE
-	select PCSPKR_PLATFORM
+	select HAVE_PCSPKR_PLATFORM
 	help
 	Select AmigaOne for the following machines:
 	- AmigaOne SE/Teron CX (G3 only)
diff --git a/arch/powerpc/platforms/chrp/Kconfig b/arch/powerpc/platforms/chrp/Kconfig
index bc0b0ef..d3cdab5 100644
--- a/arch/powerpc/platforms/chrp/Kconfig
+++ b/arch/powerpc/platforms/chrp/Kconfig
@@ -1,6 +1,7 @@
 config PPC_CHRP
 	bool "Common Hardware Reference Platform (CHRP) based machines"
 	depends on 6xx
+	select HAVE_PCSPKR_PLATFORM
 	select MPIC
 	select PPC_I8259
 	select PPC_INDIRECT_PCI
diff --git a/arch/powerpc/platforms/prep/Kconfig b/arch/powerpc/platforms/prep/Kconfig
index bf8330e..f0536c7 100644
--- a/arch/powerpc/platforms/prep/Kconfig
+++ b/arch/powerpc/platforms/prep/Kconfig
@@ -1,6 +1,7 @@
 config PPC_PREP
 	bool "PowerPC Reference Platform (PReP) based machines"
 	depends on 6xx && BROKEN
+	select HAVE_PCSPKR_PLATFORM
 	select MPIC
 	select PPC_I8259
 	select PPC_INDIRECT_PCI
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 71af4c5..05cf476 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -1,6 +1,7 @@
 config PPC_PSERIES
 	depends on PPC64 && PPC_BOOK3S
 	bool "IBM pSeries & new (POWER5-based) iSeries"
+	select HAVE_PCSPKR_PLATFORM
 	select MPIC
 	select PCI_MSI
 	select PPC_XICS
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..26a14b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
+	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
@@ -70,6 +71,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
+	select CLKEVT_I8253
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
diff --git a/arch/x86/include/asm/apb_timer.h b/arch/x86/include/asm/apb_timer.h
index 2fefa50..963f7d4 100644
--- a/arch/x86/include/asm/apb_timer.h
+++ b/arch/x86/include/asm/apb_timer.h
@@ -50,7 +50,6 @@
 #define APBT_DEV_USED  1
 
 extern void apbt_time_init(void);
-extern struct clock_event_device *global_clock_event;
 extern unsigned long apbt_quick_calibrate(void);
 extern int arch_setup_apbt_irqs(int irq, int trigger, int mask, int cpu);
 extern void apbt_setup_secondary_clock(void);
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
deleted file mode 100644
index 65aaa91..0000000
--- a/arch/x86/include/asm/i8253.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef _ASM_X86_I8253_H
-#define _ASM_X86_I8253_H
-
-/* i8253A PIT registers */
-#define PIT_MODE		0x43
-#define PIT_CH0			0x40
-#define PIT_CH2			0x42
-
-#define PIT_LATCH	LATCH
-
-extern raw_spinlock_t i8253_lock;
-
-extern struct clock_event_device *global_clock_event;
-
-extern void setup_pit_timer(void);
-
-#define inb_pit		inb_p
-#define outb_pit	outb_p
-
-#endif /* _ASM_X86_I8253_H */
diff --git a/arch/x86/include/asm/time.h b/arch/x86/include/asm/time.h
index 7bdec4e..92b8aec 100644
--- a/arch/x86/include/asm/time.h
+++ b/arch/x86/include/asm/time.h
@@ -1,10 +1,12 @@
 #ifndef _ASM_X86_TIME_H
 #define _ASM_X86_TIME_H
 
-extern void hpet_time_init(void);
-
+#include <linux/clocksource.h>
 #include <asm/mc146818rtc.h>
 
+extern void hpet_time_init(void);
 extern void time_init(void);
 
+extern struct clock_event_device *global_clock_event;
+
 #endif /* _ASM_X86_TIME_H */
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 289e928..2b6630d 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -44,6 +44,7 @@
 #include <asm/fixmap.h>
 #include <asm/apb_timer.h>
 #include <asm/mrst.h>
+#include <asm/time.h>
 
 #define APBT_MASK			CLOCKSOURCE_MASK(32)
 #define APBT_SHIFT			22
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b961af8..9da0dc0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -27,6 +27,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/delay.h>
 #include <linux/timex.h>
+#include <linux/i8253.h>
 #include <linux/dmar.h>
 #include <linux/init.h>
 #include <linux/cpu.h>
@@ -39,7 +40,6 @@
 #include <asm/pgalloc.h>
 #include <asm/atomic.h>
 #include <asm/mpspec.h>
-#include <asm/i8253.h>
 #include <asm/i8259.h>
 #include <asm/proto.h>
 #include <asm/apic.h>
@@ -48,6 +48,7 @@
 #include <asm/hpet.h>
 #include <asm/idle.h>
 #include <asm/mtrr.h>
+#include <asm/time.h>
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/tsc.h>
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 965a766..0371c48 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -229,11 +229,11 @@
 #include <linux/jiffies.h>
 #include <linux/acpi.h>
 #include <linux/syscore_ops.h>
+#include <linux/i8253.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/desc.h>
-#include <asm/i8253.h>
 #include <asm/olpc.h>
 #include <asm/paravirt.h>
 #include <asm/reboot.h>
@@ -1220,11 +1220,11 @@ static void reinit_timer(void)
 
 	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/* set the clock to HZ */
-	outb_pit(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
+	outb_p(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
-	outb_pit(LATCH & 0xff, PIT_CH0);	/* LSB */
+	outb_p(LATCH & 0xff, PIT_CH0);	/* LSB */
 	udelay(10);
-	outb_pit(LATCH >> 8, PIT_CH0);	/* MSB */
+	outb_p(LATCH >> 8, PIT_CH0);	/* MSB */
 	udelay(10);
 	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 #endif
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 6781765..0f4b065 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -4,6 +4,7 @@
 #include <linux/sysdev.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
+#include <linux/i8253.h>
 #include <linux/slab.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
@@ -12,8 +13,8 @@
 #include <linux/io.h>
 
 #include <asm/fixmap.h>
-#include <asm/i8253.h>
 #include <asm/hpet.h>
+#include <asm/time.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
 
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index fb66dc9..f2b96de 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -3,113 +3,24 @@
  *
  */
 #include <linux/clockchips.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/timex.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/io.h>
+#include <linux/i8253.h>
 
-#include <asm/i8253.h>
 #include <asm/hpet.h>
+#include <asm/time.h>
 #include <asm/smp.h>
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
-
 /*
  * HPET replaces the PIT, when enabled. So we need to know, which of
  * the two timers is used
  */
 struct clock_event_device *global_clock_event;
 
-/*
- * Initialize the PIT timer.
- *
- * This is also called after resume to bring the PIT into operation again.
- */
-static void init_pit_timer(enum clock_event_mode mode,
-			   struct clock_event_device *evt)
-{
-	raw_spin_lock(&i8253_lock);
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_PERIODIC:
-		/* binary, mode 2, LSB/MSB, ch 0 */
-		outb_pit(0x34, PIT_MODE);
-		outb_pit(LATCH & 0xff , PIT_CH0);	/* LSB */
-		outb_pit(LATCH >> 8 , PIT_CH0);		/* MSB */
-		break;
-
-	case CLOCK_EVT_MODE_SHUTDOWN:
-	case CLOCK_EVT_MODE_UNUSED:
-		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
-		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
-			outb_pit(0x30, PIT_MODE);
-			outb_pit(0, PIT_CH0);
-			outb_pit(0, PIT_CH0);
-		}
-		break;
-
-	case CLOCK_EVT_MODE_ONESHOT:
-		/* One shot setup */
-		outb_pit(0x38, PIT_MODE);
-		break;
-
-	case CLOCK_EVT_MODE_RESUME:
-		/* Nothing to do here */
-		break;
-	}
-	raw_spin_unlock(&i8253_lock);
-}
-
-/*
- * Program the next event in oneshot mode
- *
- * Delta is given in PIT ticks
- */
-static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
-{
-	raw_spin_lock(&i8253_lock);
-	outb_pit(delta & 0xff , PIT_CH0);	/* LSB */
-	outb_pit(delta >> 8 , PIT_CH0);		/* MSB */
-	raw_spin_unlock(&i8253_lock);
-
-	return 0;
-}
-
-/*
- * On UP the PIT can serve all of the possible timer functions. On SMP systems
- * it can be solely used for the global tick.
- *
- * The profiling and update capabilities are switched off once the local apic is
- * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
- * !using_apic_timer decisions in do_timer_interrupt_hook()
- */
-static struct clock_event_device pit_ce = {
-	.name		= "pit",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= init_pit_timer,
-	.set_next_event = pit_next_event,
-	.irq		= 0,
-};
-
-/*
- * Initialize the conversion factor and the min/max deltas of the clock event
- * structure and register the clock event source with the framework.
- */
 void __init setup_pit_timer(void)
 {
-	/*
-	 * Start pit with the boot cpu mask and make it global after the
-	 * IO_APIC has been initialized.
-	 */
-	pit_ce.cpumask = cpumask_of(smp_processor_id());
-
-	clockevents_config_and_register(&pit_ce, CLOCK_TICK_RATE, 0xF, 0x7FFF);
-	global_clock_event = &pit_ce;
+	clockevent_i8253_init(true);
+	global_clock_event = &i8253_clockevent;
 }
 
 #ifndef CONFIG_X86_64
@@ -123,7 +34,7 @@ static int __init init_pit_clocksource(void)
 	  * - when local APIC timer is active (PIT is switched off)
 	  */
 	if (num_possible_cpus() > 1 || is_hpet_enabled() ||
-	    pit_ce.mode != CLOCK_EVT_MODE_PERIODIC)
+	    i8253_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
 	return clocksource_i8253_init();
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 00cbb27..5a64d05 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -11,13 +11,13 @@
 
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
+#include <linux/i8253.h>
 #include <linux/time.h>
 #include <linux/mca.h>
 
 #include <asm/vsyscall.h>
 #include <asm/x86_init.h>
 #include <asm/i8259.h>
-#include <asm/i8253.h>
 #include <asm/timer.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 007c630..b52c9ca 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -155,7 +155,7 @@ else \
 
 #if (HD_DELAY > 0)
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 unsigned long last_req;
 
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 96c9219..d8d3e02 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -1,5 +1,14 @@
 config CLKSRC_I8253
 	bool
 
+config CLKEVT_I8253
+	bool
+
+config I8253_LOCK
+	bool
+
+config CLKBLD_I8253
+	def_bool y if CLKSRC_I8253 || CLKEVT_I8253 || I8253_LOCK
+
 config CLKSRC_MMIO
 	bool
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index b995942..7922a0c 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -6,5 +6,5 @@ obj-$(CONFIG_CS5535_CLOCK_EVENT_SRC)	+= cs5535-clockevt.o
 obj-$(CONFIG_SH_TIMER_CMT)	+= sh_cmt.o
 obj-$(CONFIG_SH_TIMER_MTU2)	+= sh_mtu2.o
 obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
-obj-$(CONFIG_CLKSRC_I8253)	+= i8253.o
+obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
 obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index 225c176..27c49e6 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -1,14 +1,25 @@
 /*
  * i8253 PIT clocksource
  */
-#include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/timex.h>
+#include <linux/module.h>
+#include <linux/i8253.h>
+#include <linux/smp.h>
 
-#include <asm/i8253.h>
+/*
+ * Protects access to I/O ports
+ *
+ * 0040-0043 : timer0, i8253 / i8254
+ * 0061-0061 : NMI Control Register which contains two speaker control bits.
+ */
+DEFINE_RAW_SPINLOCK(i8253_lock);
+EXPORT_SYMBOL(i8253_lock);
 
+#ifdef CONFIG_CLKSRC_I8253
 /*
  * Since the PIT overflows every tick, its not very useful
  * to just read by itself. So use jiffies to emulate a free
@@ -37,15 +48,15 @@ static cycle_t i8253_read(struct clocksource *cs)
 	 * count), it cannot be newer.
 	 */
 	jifs = jiffies;
-	outb_pit(0x00, PIT_MODE);	/* latch the count ASAP */
-	count = inb_pit(PIT_CH0);	/* read the latched count */
-	count |= inb_pit(PIT_CH0) << 8;
+	outb_p(0x00, PIT_MODE);	/* latch the count ASAP */
+	count = inb_p(PIT_CH0);	/* read the latched count */
+	count |= inb_p(PIT_CH0) << 8;
 
 	/* VIA686a test code... reset the latch if count > max + 1 */
 	if (count > LATCH) {
-		outb_pit(0x34, PIT_MODE);
-		outb_pit(PIT_LATCH & 0xff, PIT_CH0);
-		outb_pit(PIT_LATCH >> 8, PIT_CH0);
+		outb_p(0x34, PIT_MODE);
+		outb_p(PIT_LATCH & 0xff, PIT_CH0);
+		outb_p(PIT_LATCH >> 8, PIT_CH0);
 		count = PIT_LATCH - 1;
 	}
 
@@ -86,3 +97,90 @@ int __init clocksource_i8253_init(void)
 {
 	return clocksource_register_hz(&i8253_cs, PIT_TICK_RATE);
 }
+#endif
+
+#ifdef CONFIG_CLKEVT_I8253
+/*
+ * Initialize the PIT timer.
+ *
+ * This is also called after resume to bring the PIT into operation again.
+ */
+static void init_pit_timer(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+	raw_spin_lock(&i8253_lock);
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		/* binary, mode 2, LSB/MSB, ch 0 */
+		outb_p(0x34, PIT_MODE);
+		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
+		outb_p(LATCH >> 8 , PIT_CH0);		/* MSB */
+		break;
+
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
+		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
+			outb_p(0x30, PIT_MODE);
+			outb_p(0, PIT_CH0);
+			outb_p(0, PIT_CH0);
+		}
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+		/* One shot setup */
+		outb_p(0x38, PIT_MODE);
+		break;
+
+	case CLOCK_EVT_MODE_RESUME:
+		/* Nothing to do here */
+		break;
+	}
+	raw_spin_unlock(&i8253_lock);
+}
+
+/*
+ * Program the next event in oneshot mode
+ *
+ * Delta is given in PIT ticks
+ */
+static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
+{
+	raw_spin_lock(&i8253_lock);
+	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
+	outb_p(delta >> 8 , PIT_CH0);		/* MSB */
+	raw_spin_unlock(&i8253_lock);
+
+	return 0;
+}
+
+/*
+ * On UP the PIT can serve all of the possible timer functions. On SMP systems
+ * it can be solely used for the global tick.
+ */
+struct clock_event_device i8253_clockevent = {
+	.name		= "pit",
+	.features	= CLOCK_EVT_FEAT_PERIODIC,
+	.set_mode	= init_pit_timer,
+	.set_next_event = pit_next_event,
+};
+
+/*
+ * Initialize the conversion factor and the min/max deltas of the clock event
+ * structure and register the clock event source with the framework.
+ */
+void __init clockevent_i8253_init(bool oneshot)
+{
+	if (oneshot)
+		i8253_clockevent.features |= CLOCK_EVT_FEAT_ONESHOT;
+	/*
+	 * Start pit with the boot cpu mask. x86 might make it global
+	 * when it is used as broadcast device later.
+	 */
+	i8253_clockevent.cpumask = cpumask_of(smp_processor_id());
+
+	clockevents_config_and_register(&i8253_clockevent, PIT_TICK_RATE,
+					0xF, 0x7FFF);
+}
+#endif
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 5b8f59d..c351aa4 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -47,7 +47,7 @@ static void gameport_disconnect_port(struct gameport *gameport);
 
 #if defined(__i386__)
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 #define DELTA(x,y)      ((y)-(x)+((y)<(x)?1193182/HZ:0))
 #define GET_TIME(x)     do { x = get_time_pit(); } while (0)
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 4afe0a3..9882971 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -136,7 +136,7 @@ struct analog_port {
 
 #ifdef __i386__
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 #define GET_TIME(x)	do { if (cpu_has_tsc) rdtscl(x); else x = get_time_pit(); } while (0)
 #define DELTA(x,y)	(cpu_has_tsc ? ((y) - (x)) : ((x) - (y) + ((x) < (y) ? CLOCK_TICK_RATE / HZ : 0)))
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index f080dd3..34f4d2e 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/platform_device.h>
@@ -25,14 +26,6 @@ MODULE_DESCRIPTION("PC Speaker beeper driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pcspkr");
 
-#if defined(CONFIG_MIPS) || defined(CONFIG_X86)
-/* Use the global PIT lock ! */
-#include <asm/i8253.h>
-#else
-#include <asm/8253pit.h>
-static DEFINE_RAW_SPINLOCK(i8253_lock);
-#endif
-
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
 {
 	unsigned int count = 0;
diff --git a/include/linux/i8253.h b/include/linux/i8253.h
new file mode 100644
index 0000000..e6bb36a
--- /dev/null
+++ b/include/linux/i8253.h
@@ -0,0 +1,29 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ *  Machine specific IO port address definition for generic.
+ *  Written by Osamu Tomita <tomita@cinet.co.jp>
+ */
+#ifndef __LINUX_I8253_H
+#define __LINUX_I8253_H
+
+#include <linux/param.h>
+#include <linux/spinlock.h>
+#include <linux/timex.h>
+
+/* i8253A PIT registers */
+#define PIT_MODE	0x43
+#define PIT_CH0		0x40
+#define PIT_CH2		0x42
+
+#define PIT_LATCH	((PIT_TICK_RATE + HZ/2) / HZ)
+
+extern raw_spinlock_t i8253_lock;
+extern struct clock_event_device i8253_clockevent;
+extern void clockevent_i8253_init(bool oneshot);
+
+extern void setup_pit_timer(void);
+
+#endif /* __LINUX_I8253_H */
diff --git a/init/Kconfig b/init/Kconfig
index ebafac4..6f0e9d5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -999,14 +999,19 @@ config ELF_CORE
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
+
 config PCSPKR_PLATFORM
 	bool "Enable PC-Speaker support" if EXPERT
-	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	depends on HAVE_PCSPKR_PLATFORM
+	select I8253_LOCK
 	default y
 	help
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
+config HAVE_PCSPKR_PLATFORM
+	bool
+
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EXPERT
diff --git a/sound/drivers/pcsp/pcsp.h b/sound/drivers/pcsp/pcsp.h
index 4ff6c8c..fc7a2dc 100644
--- a/sound/drivers/pcsp/pcsp.h
+++ b/sound/drivers/pcsp/pcsp.h
@@ -10,14 +10,8 @@
 #define __PCSP_H__
 
 #include <linux/hrtimer.h>
+#include <linux/i8253.h>
 #include <linux/timex.h>
-#if defined(CONFIG_MIPS) || defined(CONFIG_X86)
-/* Use the global PIT lock ! */
-#include <asm/i8253.h>
-#else
-#include <asm/8253pit.h>
-static DEFINE_RAW_SPINLOCK(i8253_lock);
-#endif
 
 #define PCSP_SOUND_VERSION 0x400	/* read 4.00 */
 #define PCSP_DEBUG 0
