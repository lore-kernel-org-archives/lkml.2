Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1H3Eny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:43:54 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35295 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1H3Enw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:43:52 -0400
Message-ID: <4E5C6A7D.2010909@linux.vnet.ibm.com>
Date: Tue, 30 Aug 2011 10:13:41 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend
 events
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11083004-2674-0000-0000-0000002BC27F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf events, powerpc: Add POWER7 stalled-cycles-frontend/backend events

	Extent the POWER7 PMU driver with definitions
	for generic front-end and back-end stall events.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

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


