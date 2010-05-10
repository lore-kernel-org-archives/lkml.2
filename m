Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0EJJ33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:29:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:29223 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab0EJJ30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:29:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="620310585"
Subject: [RFC][PATCH 8/9] perf: sparc, convert to new API pmu->init_event
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 May 2010 17:28:53 +0800
Message-Id: <1273483733.15998.62.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf: sparc, convert to new API pmu->init_event

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/sparc/kernel/perf_event.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index a163f55..ef7fafc 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1128,22 +1128,21 @@ static int __hw_perf_event_init(struct perf_event *event)
 	return 0;
 }
 
+static int sparc_pmu_init_event(struct perf_event *event)
+{
+	int err = __hw_perf_event_init(event);
+
+	return err;
+}
+
 static struct pmu pmu = {
 	.enable		= sparc_pmu_enable,
 	.disable	= sparc_pmu_disable,
 	.read		= sparc_pmu_read,
 	.unthrottle	= sparc_pmu_unthrottle,
+	.init_event	= sparc_pmu_init_event,
 };
 
-struct pmu *hw_perf_event_init(struct perf_event *event)
-{
-	int err = __hw_perf_event_init(event);
-
-	if (err)
-		return ERR_PTR(err);
-	return &pmu;
-}
-
 void perf_event_print_debug(void)
 {
 	unsigned long flags;
@@ -1264,6 +1263,8 @@ void __init init_hw_perf_events(void)
 	perf_max_events = 2;
 
 	register_die_notifier(&perf_event_nmi_notifier);
+
+	perf_event_register_pmu(&pmu);
 }
 
 static inline void callchain_store(struct perf_callchain_entry *entry, u64 ip)


