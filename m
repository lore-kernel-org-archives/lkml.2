Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab1FINIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:08:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:59811 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab1FINIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:08:32 -0400
Message-Id: <20110609130622.348437125@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:08:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>
Subject: [patch 5/5] i8253: Cleanup outb/inb magic
References: <20110609130509.346588418@linutronix.de>
Content-Disposition: inline; filename=i8253-cleanup-outb-inb-magic.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the hysterical outb/inb_pit defines and use outb_p/inb_p in the
code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/x86/kernel/apm_32.c |    6 +++---
 include/linux/i8253.h    |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6-tip/arch/x86/kernel/apm_32.c
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
Index: linux-2.6-tip/include/linux/i8253.h
===================================================================
--- linux-2.6-tip.orig/include/linux/i8253.h
+++ linux-2.6-tip/include/linux/i8253.h
@@ -20,9 +20,6 @@
 
 #define PIT_LATCH	((PIT_TICK_RATE + HZ/2) / HZ)
 
-#define inb_pit         inb_p
-#define outb_pit        outb_p
-
 extern raw_spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);


