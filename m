Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1JYSLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:11:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60586 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab1JYSLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:11:20 -0400
From: y@kernel.beaverton.ibm.com
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Nikolaus Voss <n.voss@weinmann.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/8] clocksource: Convert tcb_clksrc to use clocksource_register_hz/khz
Date: Tue, 25 Oct 2011 11:08:09 -0700
Message-Id: <1319566096-3222-1-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11102518-6078-0000-0000-000002294BE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Convert tcb_clksrc to use clocksource_register_hz.

Untested. Help from maintainers would be appreciated.

CC: Nikolaus Voss <n.voss@weinmann.de>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/clocksource/tcb_clksrc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/tcb_clksrc.c b/drivers/clocksource/tcb_clksrc.c
index 79c47e8..55d0f95 100644
--- a/drivers/clocksource/tcb_clksrc.c
+++ b/drivers/clocksource/tcb_clksrc.c
@@ -59,7 +59,6 @@ static struct clocksource clksrc = {
 	.rating         = 200,
 	.read           = tc_get_cycles,
 	.mask           = CLOCKSOURCE_MASK(32),
-	.shift          = 18,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -256,7 +255,6 @@ static int __init tcb_clksrc_init(void)
 		best_divisor_idx = i;
 	}
 
-	clksrc.mult = clocksource_hz2mult(divided_rate, clksrc.shift);
 
 	printk(bootinfo, clksrc.name, CONFIG_ATMEL_TCB_CLKSRC_BLOCK,
 			divided_rate / 1000000,
@@ -292,7 +290,7 @@ static int __init tcb_clksrc_init(void)
 	__raw_writel(ATMEL_TC_SYNC, tcaddr + ATMEL_TC_BCR);
 
 	/* and away we go! */
-	clocksource_register(&clksrc);
+	clocksource_register_hz(&clksrc, divided_rate);
 
 	/* channel 2:  periodic and oneshot timer support */
 	setup_clkevents(tc, clk32k_divisor_idx);
-- 
1.7.3.2.146.gca209

