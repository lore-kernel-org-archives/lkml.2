Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0JTXoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:44:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48122 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0JTXoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:44:20 -0400
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/7] sparc: convert to clocksource_register_hz/khz
Date: Wed, 20 Oct 2010 16:44:10 -0700
Message-Id: <1287618253-13258-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287618253-13258-4-git-send-email-johnstul@us.ibm.com>
References: <1287618253-13258-1-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-2-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-3-git-send-email-johnstul@us.ibm.com>
 <1287618253-13258-4-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the sparc clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sparc/kernel/time_64.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 3bc9c99..58aa27b 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -816,14 +816,12 @@ void __init time_init(void)
 		clocksource_hz2mult(freq, SPARC64_NSEC_PER_CYC_SHIFT);
 
 	clocksource_tick.name = tick_ops->name;
-	clocksource_calc_mult_shift(&clocksource_tick, freq, 4);
 	clocksource_tick.read = clocksource_tick_read;
 
+	clocksource_register_hz(&clocksource_tick, freq);
 	printk("clocksource: mult[%x] shift[%d]\n",
 	       clocksource_tick.mult, clocksource_tick.shift);
 
-	clocksource_register(&clocksource_tick);
-
 	sparc64_clockevent.name = tick_ops->name;
 	clockevents_calc_mult_shift(&sparc64_clockevent, freq, 4);
 
-- 
1.6.0.4

