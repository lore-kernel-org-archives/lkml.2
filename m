Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1JYSIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:08:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48298 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab1JYSIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:08:30 -0400
From: y@kernel.beaverton.ibm.com
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Jeff Dike <jdike@addtoit.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/8] clocksource: um: Convert to clocksource_register_hz/khz
Date: Tue, 25 Oct 2011 11:08:11 -0700
Message-Id: <1319566096-3222-3-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1319566096-3222-1-git-send-email-y>
References: <1319566096-3222-1-git-send-email-y>
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

