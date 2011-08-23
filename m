Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1HWLU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:20:58 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:43421 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HWLUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:20:54 -0400
Date: Tue, 23 Aug 2011 13:20:46 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nohz: remove "Switched to NOHz mode" debugging messages
Message-ID: <20110823112046.GB2540@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

When performing cpu hotplug tests the kernel printk log buffer gets flooded
with pointless "Switched to NOHz mode..." messages. Especially when afterwards
analyzing a dump this might have removed more interesting stuff out of the
buffer.
Assuming that switching to NOHz mode simply works just remove the printk.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/time/tick-sched.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..8b3b014 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -640,8 +640,6 @@ static void tick_nohz_switch_to_nohz(void)
 		next = ktime_add(next, tick_period);
 	}
 	local_irq_enable();
-
-	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 }
 
 /*
@@ -793,10 +791,8 @@ void tick_setup_sched_timer(void)
 	}
 
 #ifdef CONFIG_NO_HZ
-	if (tick_nohz_enabled) {
+	if (tick_nohz_enabled)
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
-		printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
-	}
 #endif
 }
 #endif /* HIGH_RES_TIMERS */
