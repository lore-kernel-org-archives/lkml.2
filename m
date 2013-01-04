Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3ADTNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 14:13:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:32520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab3ADTNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:13:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,412,1355126400"; 
   d="scan'208";a="267479578"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Joe Perches <joe@perches.com>,
        Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v6 1/3] tick: export nohz tick idle symbols for module use
Date: Fri,  4 Jan 2013 03:12:43 -0800
Message-Id: <1357297965-17839-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357297965-17839-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1357297965-17839-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers such as intel_powerclamp to use these apis for
turning on/off ticks during idle.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 kernel/time/tick-sched.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d58e552..a767757 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -553,6 +553,7 @@ void tick_nohz_idle_enter(void)
 
 	local_irq_enable();
 }
+EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
 
 /**
  * tick_nohz_irq_exit - update next tick event from interrupt exit
@@ -681,6 +682,7 @@ void tick_nohz_idle_exit(void)
 
 	local_irq_enable();
 }
+EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
 
 static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 {
-- 
1.7.9.5

