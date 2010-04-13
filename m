Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0DMU05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:26:57 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:53379 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0DMU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:52 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h6bh467h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SE-02-H0H-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/12] perf, x86: implement IBS feature detection
Date: Tue, 13 Apr 2010 22:23:18 +0200
Message-ID: <1271190201-25705-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0714 (UTC) FILETIME=[9D074220:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
index 67b99a9..a42d033 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -242,6 +242,11 @@ struct x86_pmu {
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
index 611df11..246304d 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -402,6 +402,8 @@ static __init int amd_pmu_init(void)
 		return -ENODEV;
 
 	x86_pmu = amd_pmu;
+	if (boot_cpu_has(X86_FEATURE_IBS))
+		x86_pmu.ibs = 1;
 
 	/* Events are common for all AMDs */
 	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
-- 
1.7.0.3


