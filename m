Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab1IIHMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 03:12:21 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56256 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab1IIHMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 03:12:18 -0400
Message-ID: <4E69BC46.4000809@linux.vnet.ibm.com>
Date: Fri, 09 Sep 2011 12:42:06 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <michael.neuling@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend
 events
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11090907-2674-0000-0000-000000525094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend events

Extent the POWER7 PMU driver with definitions for generic front-end and back-end
stall events.

As explained in Ingo's original comment(8f62242246351b5a4bc0c1f00c0c7003edea128a
), the exact definitions of the stall events are very much processor specific as
different things mean different in their respective instruction pipeline. These
two Power7 raw events are the closest approximation to the concept detailed in
Ingo's comment.

[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x100f8, /* GCT_NOSLOT_CYC */
It means cycles when the Global Completion Table has no slots from this thread

[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x4000a,  /* CMPLU_STALL */
It means no groups completed and GCT not empty for this thread

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
Version 2: added new comments in commit message as suggested by Mikey.
No code changes.

diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 593740f..e5d2844 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -297,6 +297,8 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 
 static int power7_generic_events[] = {
 	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
+	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x100f8, /* GCT_NOSLOT_CYC */
+	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x4000a,  /* CMPLU_STALL */
 	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
 	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
 	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/

-- 
Anshuman Khandual 
LTC India 

