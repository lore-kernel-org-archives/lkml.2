Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab1JYSPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:15:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34894 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab1JYSPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:15:30 -0400
From: y@kernel.beaverton.ibm.com
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 7/8] clocksource: Convert m68k to use clocksource_register_hz/khz
Date: Tue, 25 Oct 2011 11:08:15 -0700
Message-Id: <1319566096-3222-7-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1319566096-3222-1-git-send-email-y>
References: <1319566096-3222-1-git-send-email-y>
x-cbid: 11102518-1976-0000-0000-00000057CFA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

Cleanup m68k clocksource registration.

This is untested, so any assistance in testing would be appreciated!

CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/m68k/platform/coldfire/pit.c      |    4 +---
 arch/m68k/platform/coldfire/sltimers.c |    4 +---
 arch/m68k/platform/coldfire/timers.c   |    4 +---
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/platform/coldfire/pit.c b/arch/m68k/platform/coldfire/pit.c
index c2b9809..02663d2 100644
--- a/arch/m68k/platform/coldfire/pit.c
+++ b/arch/m68k/platform/coldfire/pit.c
@@ -144,7 +144,6 @@ static struct clocksource pit_clk = {
 	.name	= "pit",
 	.rating	= 100,
 	.read	= pit_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 };
 
@@ -162,8 +161,7 @@ void hw_timer_init(void)
 
 	setup_irq(MCFINT_VECBASE + MCFINT_PIT1, &pit_irq);
 
-	pit_clk.mult = clocksource_hz2mult(FREQ, pit_clk.shift);
-	clocksource_register(&pit_clk);
+	clocksource_register_hz(&pit_clk, FREQ);
 }
 
 /***************************************************************************/
diff --git a/arch/m68k/platform/coldfire/sltimers.c b/arch/m68k/platform/coldfire/sltimers.c
index 6a85daf..b7f822b 100644
--- a/arch/m68k/platform/coldfire/sltimers.c
+++ b/arch/m68k/platform/coldfire/sltimers.c
@@ -114,7 +114,6 @@ static struct clocksource mcfslt_clk = {
 	.name	= "slt",
 	.rating	= 250,
 	.read	= mcfslt_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -136,8 +135,7 @@ void hw_timer_init(void)
 
 	setup_irq(MCF_IRQ_TIMER, &mcfslt_timer_irq);
 
-	mcfslt_clk.mult = clocksource_hz2mult(MCF_BUSCLK, mcfslt_clk.shift);
-	clocksource_register(&mcfslt_clk);
+	clocksource_register_hz(&mcfslt_clk, MCF_BUSCLK);
 
 #ifdef CONFIG_HIGHPROFILE
 	mcfslt_profile_init();
diff --git a/arch/m68k/platform/coldfire/timers.c b/arch/m68k/platform/coldfire/timers.c
index 60242f6..0d90da3 100644
--- a/arch/m68k/platform/coldfire/timers.c
+++ b/arch/m68k/platform/coldfire/timers.c
@@ -88,7 +88,6 @@ static struct clocksource mcftmr_clk = {
 	.name	= "tmr",
 	.rating	= 250,
 	.read	= mcftmr_read_clk,
-	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
@@ -109,8 +108,7 @@ void hw_timer_init(void)
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
-	mcftmr_clk.mult = clocksource_hz2mult(FREQ, mcftmr_clk.shift);
-	clocksource_register(&mcftmr_clk);
+	clocksource_register_hz(&mcftmr_clk, FREQ);
 
 	setup_irq(MCF_IRQ_TIMER, &mcftmr_timer_irq);
 
-- 
1.7.3.2.146.gca209

