Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3ACTCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 14:02:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:38776 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab3ACTBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 14:01:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,404,1355126400"; 
   d="scan'208";a="266915589"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Joe Perches <joe@perches.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v4 1/3] tick: export nohz tick idle symbols for module use
Date: Thu,  3 Jan 2013 03:01:13 -0800
Message-Id: <1357210875-5025-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357210875-5025-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1357210875-5025-1-git-send-email-jacob.jun.pan@linux.intel.com>
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

