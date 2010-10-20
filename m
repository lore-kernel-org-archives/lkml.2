Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0JTXo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:44:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:32882 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab0JTXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:44:28 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/7] avr32: Convert to clocksource_register_hz
Date: Wed, 20 Oct 2010 16:44:11 -0700
Message-Id: <1287618253-13258-6-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287618253-13258-5-git-send-email-johnstul@us.ibm.com>
References: <1287618253-13258-1-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-2-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-3-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-4-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-5-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the avr32 clocksource to use clocksource_register_hz.

This is untested, so any assistance in testing would be appreciated!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 arch/avr32/kernel/time.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
index 668ed28..05ad291 100644
--- a/arch/avr32/kernel/time.c
+++ b/arch/avr32/kernel/time.c
@@ -35,7 +35,6 @@ static struct clocksource counter = {
 	.rating		= 50,
 	.read		= read_cycle_count,
 	.mask		= CLOCKSOURCE_MASK(32),
-	.shift		= 16,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -123,9 +122,7 @@ void __init time_init(void)
 
 	/* figure rate for counter */
 	counter_hz = clk_get_rate(boot_cpu_data.clk);
-	counter.mult = clocksource_hz2mult(counter_hz, counter.shift);
-
-	ret = clocksource_register(&counter);
+	ret = clocksource_register_hz(&counter, counter_hz);
 	if (ret)
 		pr_debug("timer: could not register clocksource: %d\n", ret);
 
-- 
1.6.0.4

