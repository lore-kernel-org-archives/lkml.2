Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759768Ab1FATuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:50:40 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59144 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759644Ab1FATri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:38 -0400
Message-Id: <20110601180610.054254048@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:04:57 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        John Stultz <johnstul@us.ibm.com>, linux-mips@linux-mips.org
Subject: [patch 01/14] i8253: Create <linux/i8253.h> and make all in kernel users to use it.
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-add-shared-header.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: John Stultz <johnstul@us.ibm.com>
Cc: linux-mips@linux-mips.org

 arch/arm/mach-footbridge/isa-timer.c |    2 +-
 arch/mips/cobalt/time.c              |    2 +-
 arch/mips/jazz/irq.c                 |    2 +-
 arch/mips/kernel/i8253.c             |    2 +-
 arch/mips/mti-malta/malta-time.c     |    2 +-
 arch/mips/sgi-ip22/ip22-time.c       |    2 +-
 arch/mips/sni/time.c                 |    2 +-
 arch/x86/kernel/apic/apic.c          |    2 +-
 arch/x86/kernel/apm_32.c             |    2 +-
 arch/x86/kernel/hpet.c               |    2 +-
 arch/x86/kernel/i8253.c              |    2 +-
 arch/x86/kernel/time.c               |    2 +-
 drivers/block/hd.c                   |    2 +-
 drivers/clocksource/i8253.c          |    2 +-
 drivers/input/gameport/gameport.c    |    2 +-
 drivers/input/joystick/analog.c      |    2 +-
 drivers/input/misc/pcspkr.c          |    2 +-
 include/linux/i8253.h                |   11 +++++++++++
 sound/drivers/pcsp/pcsp.h            |    2 +-
 19 files changed, 29 insertions(+), 18 deletions(-)

Index: linux-mips/include/linux/i8253.h
===================================================================
--- /dev/null
+++ linux-mips/include/linux/i8253.h
@@ -0,0 +1,11 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __LINUX_I8253_H
+#define __LINUX_I8253_H
+
+#include <asm/i8253.h>
+
+#endif /* __LINUX_I8253_H */
Index: linux-mips/arch/arm/mach-footbridge/isa-timer.c
===================================================================
--- linux-mips.orig/arch/arm/mach-footbridge/isa-timer.c
+++ linux-mips/arch/arm/mach-footbridge/isa-timer.c
@@ -6,6 +6,7 @@
  */
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -14,7 +15,6 @@
 #include <linux/timex.h>
 
 #include <asm/irq.h>
-#include <asm/i8253.h>
 #include <asm/mach/time.h>
 
 #include "common.h"
Index: linux-mips/arch/mips/cobalt/time.c
===================================================================
--- linux-mips.orig/arch/mips/cobalt/time.c
+++ linux-mips/arch/mips/cobalt/time.c
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
Index: linux-mips/arch/mips/jazz/irq.c
===================================================================
--- linux-mips.orig/arch/mips/jazz/irq.c
+++ linux-mips/arch/mips/jazz/irq.c
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
Index: linux-mips/arch/mips/kernel/i8253.c
===================================================================
--- linux-mips.orig/arch/mips/kernel/i8253.c
+++ linux-mips/arch/mips/kernel/i8253.c
@@ -3,6 +3,7 @@
  *
  */
 #include <linux/clockchips.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
@@ -12,7 +13,6 @@
 #include <linux/irq.h>
 
 #include <asm/delay.h>
-#include <asm/i8253.h>
 #include <asm/io.h>
 #include <asm/time.h>
 
Index: linux-mips/arch/mips/mti-malta/malta-time.c
===================================================================
--- linux-mips.orig/arch/mips/mti-malta/malta-time.c
+++ linux-mips/arch/mips/mti-malta/malta-time.c
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
Index: linux-mips/arch/mips/sgi-ip22/ip22-time.c
===================================================================
--- linux-mips.orig/arch/mips/sgi-ip22/ip22-time.c
+++ linux-mips/arch/mips/sgi-ip22/ip22-time.c
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
Index: linux-mips/arch/mips/sni/time.c
===================================================================
--- linux-mips.orig/arch/mips/sni/time.c
+++ linux-mips/arch/mips/sni/time.c
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
Index: linux-mips/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/apic/apic.c
+++ linux-mips/arch/x86/kernel/apic/apic.c
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
Index: linux-mips/arch/x86/kernel/apm_32.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/apm_32.c
+++ linux-mips/arch/x86/kernel/apm_32.c
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
Index: linux-mips/arch/x86/kernel/hpet.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/hpet.c
+++ linux-mips/arch/x86/kernel/hpet.c
@@ -4,6 +4,7 @@
 #include <linux/sysdev.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
+#include <linux/i8253.h>
 #include <linux/slab.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
@@ -12,7 +13,6 @@
 #include <linux/io.h>
 
 #include <asm/fixmap.h>
-#include <asm/i8253.h>
 #include <asm/hpet.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
Index: linux-mips/arch/x86/kernel/i8253.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/i8253.c
+++ linux-mips/arch/x86/kernel/i8253.c
@@ -9,10 +9,10 @@
 #include <linux/module.h>
 #include <linux/timex.h>
 #include <linux/delay.h>
+#include <linux/i8253.h>
 #include <linux/init.h>
 #include <linux/io.h>
 
-#include <asm/i8253.h>
 #include <asm/hpet.h>
 #include <asm/smp.h>
 
Index: linux-mips/arch/x86/kernel/time.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/time.c
+++ linux-mips/arch/x86/kernel/time.c
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
Index: linux-mips/drivers/block/hd.c
===================================================================
--- linux-mips.orig/drivers/block/hd.c
+++ linux-mips/drivers/block/hd.c
@@ -155,7 +155,7 @@ else \
 
 #if (HD_DELAY > 0)
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 unsigned long last_req;
 
Index: linux-mips/drivers/clocksource/i8253.c
===================================================================
--- linux-mips.orig/drivers/clocksource/i8253.c
+++ linux-mips/drivers/clocksource/i8253.c
@@ -7,7 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/timex.h>
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 /*
  * Since the PIT overflows every tick, its not very useful
Index: linux-mips/drivers/input/gameport/gameport.c
===================================================================
--- linux-mips.orig/drivers/input/gameport/gameport.c
+++ linux-mips/drivers/input/gameport/gameport.c
@@ -47,7 +47,7 @@ static void gameport_disconnect_port(str
 
 #if defined(__i386__)
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 #define DELTA(x,y)      ((y)-(x)+((y)<(x)?1193182/HZ:0))
 #define GET_TIME(x)     do { x = get_time_pit(); } while (0)
Index: linux-mips/drivers/input/joystick/analog.c
===================================================================
--- linux-mips.orig/drivers/input/joystick/analog.c
+++ linux-mips/drivers/input/joystick/analog.c
@@ -136,7 +136,7 @@ struct analog_port {
 
 #ifdef __i386__
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 #define GET_TIME(x)	do { if (cpu_has_tsc) rdtscl(x); else x = get_time_pit(); } while (0)
 #define DELTA(x,y)	(cpu_has_tsc ? ((y) - (x)) : ((x) - (y) + ((x) < (y) ? CLOCK_TICK_RATE / HZ : 0)))
Index: linux-mips/drivers/input/misc/pcspkr.c
===================================================================
--- linux-mips.orig/drivers/input/misc/pcspkr.c
+++ linux-mips/drivers/input/misc/pcspkr.c
@@ -27,7 +27,7 @@ MODULE_ALIAS("platform:pcspkr");
 
 #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
 /* Use the global PIT lock ! */
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 #else
 #include <asm/8253pit.h>
 static DEFINE_RAW_SPINLOCK(i8253_lock);
Index: linux-mips/sound/drivers/pcsp/pcsp.h
===================================================================
--- linux-mips.orig/sound/drivers/pcsp/pcsp.h
+++ linux-mips/sound/drivers/pcsp/pcsp.h
@@ -13,7 +13,7 @@
 #include <linux/timex.h>
 #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
 /* Use the global PIT lock ! */
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 #else
 #include <asm/8253pit.h>
 static DEFINE_RAW_SPINLOCK(i8253_lock);


