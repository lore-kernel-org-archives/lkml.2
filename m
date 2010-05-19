Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab0ERRqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:46:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:35182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560Ab0ERRqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:46:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,256,1272870000"; 
   d="scan'208";a="278572628"
Subject: [RFC][PATCH v2 05/11] perf: x86, remove hw_perf_event_init
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 01:46:11 +0000
Message-Id: <1274233571.3036.83.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now x86 hw_perf_event_init can be removed.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |   31 -------------------------------
 1 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index aad4221..8a3aea6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1757,34 +1757,3 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 	return misc;
 }
-
-struct pmu *hw_perf_event_init(struct perf_event *event)
-{
-	struct pmu *tmp;
-	int err;
-
-	err = __hw_perf_event_init(event);
-	if (!err) {
-		/*
-		 * we temporarily connect event to its pmu
-		 * such that validate_group() can classify
-		 * it as an x86 event using is_x86_event()
-		 */
-		tmp = event->pmu;
-		event->pmu = &pmu;
-
-		if (event->group_leader != event)
-			err = validate_group(event);
-		else
-			err = validate_event(event);
-
-		event->pmu = tmp;
-	}
-	if (err) {
-		if (event->destroy)
-			event->destroy(event);
-		return ERR_PTR(err);
-	}
-
-	return &pmu;
-}




