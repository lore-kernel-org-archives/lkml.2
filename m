Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab1ERVdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:33:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:54572 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab1ERVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:33:44 -0400
Message-Id: <20110518210136.545615675@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 21:33:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <john.stultz@linaro.org>
Subject: [patch 6/7] x86: Convert PIT to clockevents_config_and_register()
References: <20110518205713.947614271@linutronix.de>
Content-Disposition: inline; filename=x86-pit-convert-ce.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core do the work.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/i8253.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/i8253.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/i8253.c
+++ linux-2.6-tip/arch/x86/kernel/i8253.c
@@ -93,7 +93,6 @@ static struct clock_event_device pit_ce 
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= init_pit_timer,
 	.set_next_event = pit_next_event,
-	.shift		= 32,
 	.irq		= 0,
 };
 
@@ -108,11 +107,8 @@ void __init setup_pit_timer(void)
 	 * IO_APIC has been initialized.
 	 */
 	pit_ce.cpumask = cpumask_of(smp_processor_id());
-	pit_ce.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, pit_ce.shift);
-	pit_ce.max_delta_ns = clockevent_delta2ns(0x7FFF, &pit_ce);
-	pit_ce.min_delta_ns = clockevent_delta2ns(0xF, &pit_ce);
 
-	clockevents_register_device(&pit_ce);
+	clockevents_config_and_register(&pit_ce, CLOCK_TICK_RATE, 0xF, 0x7FFF);
 	global_clock_event = &pit_ce;
 }
 


