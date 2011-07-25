Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab1GYJrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:47:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35372 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1GYJrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:47:39 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH] time: Convert noisy NOHz prints to pr_debug.
Date: Mon, 25 Jul 2011 15:15:54 +0530
Message-ID: <1311587154-17186-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of prints from tick-sched.c which says 'Switched to NOHz mode on CPU'
is more of debug information with NOHZ enabled. Mark these as debug prints
to avoid console noise.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d5097c4..bc10bd6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -641,7 +641,7 @@ static void tick_nohz_switch_to_nohz(void)
 	}
 	local_irq_enable();
 
-	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
+	pr_debug("Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 }
 
 /*
@@ -795,7 +795,7 @@ void tick_setup_sched_timer(void)
 #ifdef CONFIG_NO_HZ
 	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
-		printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
+		pr_debug("Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 	}
 #endif
 }
-- 
1.6.0.4

