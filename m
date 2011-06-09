Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1FILQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:16:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:41101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab1FILQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:16:26 -0400
Date: Thu, 9 Jun 2011 11:16:16 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-9e5f52db252be87dc88615c5a48f80a2c70cd2a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110601180610.054254048@duck.linux-mips.net>
References: <20110601180610.054254048@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Create linux/i8253.h and use it in all 8253 related files
Git-Commit-ID: 9e5f52db252be87dc88615c5a48f80a2c70cd2a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:16:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e5f52db252be87dc88615c5a48f80a2c70cd2a0
Gitweb:     http://git.kernel.org/tip/9e5f52db252be87dc88615c5a48f80a2c70cd2a0
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:04:57 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 12:03:49 +0200

i8253: Create linux/i8253.h and use it in all 8253 related files

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20110601180610.054254048@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

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

---
 arch/arm/mach-footbridge/isa-timer.c               |    2 +-
 arch/mips/cobalt/time.c                            |    2 +-
 arch/mips/jazz/irq.c                               |    2 +-
 arch/mips/kernel/i8253.c                           |    2 +-
 arch/mips/mti-malta/malta-time.c                   |    2 +-
 arch/mips/sgi-ip22/ip22-time.c                     |    2 +-
 arch/mips/sni/time.c                               |    2 +-
 arch/x86/kernel/apic/apic.c                        |    2 +-
 arch/x86/kernel/apm_32.c                           |    2 +-
 arch/x86/kernel/hpet.c                             |    2 +-
 arch/x86/kernel/i8253.c                            |    2 +-
 arch/x86/kernel/time.c                             |    2 +-
 drivers/block/hd.c                                 |    2 +-
 drivers/clocksource/i8253.c                        |    2 +-
 drivers/input/gameport/gameport.c                  |    2 +-
 drivers/input/joystick/analog.c                    |    2 +-
 drivers/input/misc/pcspkr.c                        |    2 +-
 .../include/asm/ide.h => include/linux/i8253.h     |   10 ++++------
 sound/drivers/pcsp/pcsp.h                          |    2 +-
 19 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-footbridge/isa-timer.c b/arch/arm/mach-footbridge/isa-timer.c
index 7020f1a..3c7367b 100644
--- a/arch/arm/mach-footbridge/isa-timer.c
+++ b/arch/arm/mach-footbridge/isa-timer.c
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
index 391221b..82b5a9f 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
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
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b961af8..f3c3784 100644
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
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 965a766..a30740e 100644
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
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 6781765..85b8a8a 100644
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
@@ -12,7 +13,6 @@
 #include <linux/io.h>
 
 #include <asm/fixmap.h>
-#include <asm/i8253.h>
 #include <asm/hpet.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index fb66dc9..3235550 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
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
 
diff --git a/drivers/clocksource/i8253.c b/drivers/clocksource/i8253.c
index 225c176..33735eb 100644
--- a/drivers/clocksource/i8253.c
+++ b/drivers/clocksource/i8253.c
@@ -7,7 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/timex.h>
 
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 
 /*
  * Since the PIT overflows every tick, its not very useful
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
index f080dd3..2aa9d90 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -27,7 +27,7 @@ MODULE_ALIAS("platform:pcspkr");
 
 #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
 /* Use the global PIT lock ! */
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 #else
 #include <asm/8253pit.h>
 static DEFINE_RAW_SPINLOCK(i8253_lock);
diff --git a/arch/mips/include/asm/ide.h b/include/linux/i8253.h
similarity index 55%
copy from arch/mips/include/asm/ide.h
copy to include/linux/i8253.h
index bb674c3..d2cba88 100644
--- a/arch/mips/include/asm/ide.h
+++ b/include/linux/i8253.h
@@ -2,12 +2,10 @@
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
- *
- * This file contains the MIPS architecture specific IDE code.
  */
-#ifndef __ASM_IDE_H
-#define __ASM_IDE_H
+#ifndef __LINUX_I8253_H
+#define __LINUX_I8253_H
 
-#include <ide.h>
+#include <asm/i8253.h>
 
-#endif /* __ASM_IDE_H */
+#endif /* __LINUX_I8253_H */
diff --git a/sound/drivers/pcsp/pcsp.h b/sound/drivers/pcsp/pcsp.h
index 4ff6c8c..6757c30 100644
--- a/sound/drivers/pcsp/pcsp.h
+++ b/sound/drivers/pcsp/pcsp.h
@@ -13,7 +13,7 @@
 #include <linux/timex.h>
 #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
 /* Use the global PIT lock ! */
-#include <asm/i8253.h>
+#include <linux/i8253.h>
 #else
 #include <asm/8253pit.h>
 static DEFINE_RAW_SPINLOCK(i8253_lock);
