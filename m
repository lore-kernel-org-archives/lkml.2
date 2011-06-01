Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161101Ab1FAHds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:33:48 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34710 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212Ab1FAHc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:32:57 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Chris Zankel <chris@zankel.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/6] clocksource: xtensa: convert to clocksource_register_hz/khz
Date: Wed,  1 Jun 2011 00:32:48 -0700
Message-Id: <1306913570-9445-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
References: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

This converts the xtensa clocksource to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: Chris Zankel <chris@zankel.net>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/xtensa/kernel/time.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index f3e5eb4..ac62f9c 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -41,14 +41,6 @@ static struct clocksource ccount_clocksource = {
 	.rating = 200,
 	.read = ccount_read,
 	.mask = CLOCKSOURCE_MASK(32),
-	/*
-	 * With a shift of 22 the lower limit of the cpu clock is
-	 * 1MHz, where NSEC_PER_CCOUNT is 1000 or a bit less than
-	 * 2^10: Since we have 32 bits and the multiplicator can
-	 * already take up as much as 10 bits, this leaves us with
-	 * remaining upper 22 bits.
-	 */
-	.shift = 22,
 };
 
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
@@ -66,10 +58,7 @@ void __init time_init(void)
 	printk("%d.%02d MHz\n", (int)ccount_per_jiffy/(1000000/HZ),
 			(int)(ccount_per_jiffy/(10000/HZ))%100);
 #endif
-	ccount_clocksource.mult =
-		clocksource_hz2mult(CCOUNT_PER_JIFFY * HZ,
-				ccount_clocksource.shift);
-	clocksource_register(&ccount_clocksource);
+	clocksource_register_hz(&ccount_clocksource, CCOUNT_PER_JIFFY * HZ);
 
 	/* Initialize the linux timer interrupt. */
 
-- 
1.7.3.2.146.gca209

