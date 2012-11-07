Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2KGTRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:17:39 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39849 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab2KGTRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:17:37 -0500
Date: Wed, 7 Nov 2012 11:18:47 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@au1.ibm.com>, robert.richter@amd.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] perf/Power7: Use macros to identify perf events
Message-ID: <20121107191846.GB16211@us.ibm.com>
References: <20121107191818.GA16211@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121107191818.GA16211@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110719-5112-0000-0000-00000E51379E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 8a0dbd8f3fce2834292efa50c15ca64d4f6a6536 Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 7 Nov 2012 09:36:14 -0800
Subject: [PATCH 2/4] perf/Power7: Use macros to identify perf events

Define and use macros to identify perf events codes This would make it
easier and more readable when these event codes need to be used in more
than one place.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power7-pmu.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index 441af08..256db4f 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -295,15 +295,24 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SH(pmc));
 }
 
+#define	PM_CYC				0x1e
+#define	PM_GCT_NOSLOT_CYC		0x100f8
+#define	PM_CMPLU_STALL			0x4000a
+#define	PM_INST_CMPL			0x2
+#define	PM_LD_REF_L1			0xc880
+#define	PM_LD_MISS_L1			0x400f0
+#define	PM_BRU_FIN			0x10068
+#define	PM_BRU_MPRED			0x400f6
+
 static int power7_generic_events[] = {
-	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
-	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x100f8, /* GCT_NOSLOT_CYC */
-	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x4000a,  /* CMPLU_STALL */
-	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
-	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
-	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
-	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN	*/
-	[PERF_COUNT_HW_BRANCH_MISSES] = 0x400f6,	/* BR_MPRED	*/
+	[PERF_COUNT_HW_CPU_CYCLES] = 			PM_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 	PM_GCT_NOSLOT_CYC,
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 	PM_CMPLU_STALL,
+	[PERF_COUNT_HW_INSTRUCTIONS] = 			PM_INST_CMPL,
+	[PERF_COUNT_HW_CACHE_REFERENCES] = 		PM_LD_REF_L1,
+	[PERF_COUNT_HW_CACHE_MISSES] = 			PM_LD_MISS_L1,
+	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = 		PM_BRU_FIN,
+	[PERF_COUNT_HW_BRANCH_MISSES] = 		PM_BRU_MPRED,
 };
 
 #define C(x)	PERF_COUNT_HW_CACHE_##x
-- 
1.7.1

