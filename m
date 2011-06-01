Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab1FAHdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 03:33:03 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39853 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab1FAHc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:32:59 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Jeff Dike <jdike@addtoit.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6] clocksource: um: convert to clocksource_register_hz/khz
Date: Wed,  1 Jun 2011 00:32:47 -0700
Message-Id: <1306913570-9445-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
References: <1306913570-9445-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

This converts the um clocksource to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: Jeff Dike <jdike@addtoit.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/um/kernel/time.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index a08d9fa..82a6e22 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -75,8 +75,6 @@ static struct clocksource itimer_clocksource = {
 	.rating		= 300,
 	.read		= itimer_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1000,
-	.shift		= 0,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
@@ -94,9 +92,9 @@ static void __init setup_itimer(void)
 		clockevent_delta2ns(60 * HZ, &itimer_clockevent);
 	itimer_clockevent.min_delta_ns =
 		clockevent_delta2ns(1, &itimer_clockevent);
-	err = clocksource_register(&itimer_clocksource);
+	err = clocksource_register_hz(&itimer_clocksource, USEC_PER_SEC);
 	if (err) {
-		printk(KERN_ERR "clocksource_register returned %d\n", err);
+		printk(KERN_ERR "clocksource_register_hz returned %d\n", err);
 		return;
 	}
 	clockevents_register_device(&itimer_clockevent);
-- 
1.7.3.2.146.gca209

