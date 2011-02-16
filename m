Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1BPGfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:35:36 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38188 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1BPGfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:35:01 -0500
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/6] sparc: convert to clocksource_register_hz/khz
Date: Tue, 15 Feb 2011 22:34:50 -0800
Message-Id: <1297838092-22989-5-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the sparc clocksources to use clocksource_register_hz/khz

This is untested, so any assistance in testing would be appreciated!

CC: "David S. Miller" <davem@davemloft.net>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
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
1.7.3.2.146.gca209

