Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0ESVlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:41:16 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:47052 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0ESVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:41:06 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L2OS86-02-UV7-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/7] perf, x86: implement IBS feature detection
Date: Wed, 19 May 2010 23:20:21 +0200
Message-ID: <1274304024-6551-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new code checks if IBS is available on the cpu. It implements only
a basic detection that should be later extended to read ibs cpuid
feature flags.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |    5 +++++
 arch/x86/kernel/cpu/perf_event_amd.c |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e64502c..e186d3b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -244,6 +244,11 @@ struct x86_pmu {
 	 */
 	unsigned long	lbr_tos, lbr_from, lbr_to; /* MSR base regs       */
 	int		lbr_nr;			   /* hardware stack size */
+
+	/*
+	 * AMD IBS
+	 */
+	int		ibs;			/* cpuid flags */
 };
 
 static struct x86_pmu x86_pmu __read_mostly;
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 87e5ae4..cda8475 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -405,6 +405,8 @@ static __init int amd_pmu_init(void)
 		return -ENODEV;
 
 	x86_pmu = amd_pmu;
+	if (boot_cpu_has(X86_FEATURE_IBS))
+		x86_pmu.ibs = 1;
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.1


