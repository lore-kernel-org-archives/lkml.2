Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1F0WBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:01:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1F0V7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 17:59:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=TwG6gDiB/q30gvNWk99g4GWwJEKStxjxsketJM7eCcSmjFiIW9vwoUR6nITOrV6Bz
	k+TeM3/E9RFCg53nEqM+A==
From: Zhengyu He <zhengyuh@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Zhengyu He <zhengyuh@google.com>
Subject: [PATCH] perf: removed a non-existent event "L1-icache-prefetches" for AMD processors
Date: Mon, 27 Jun 2011 14:58:30 -0700
Message-Id: <1309211910-2803-1-git-send-email-zhengyuh@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to AMD's "BIOS and Kernel Developer's Guide for AMD NPT Family
0Fh Processors"
(http://support.amd.com/us/Processor_TechDocs/32559.pdf), 0x4B is for
prefetch instructions dispatched, and 0x14B is for the load prefetch
instructions including Pretech and PrefetchT0/T1/T2. No event for the
instructions preteched into L1I cache is found.

Signed-off-by: Zhengyu He <zhengyuh@google.com>

resending

---
 arch/x86/kernel/cpu/perf_event_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index fe29c1d..3b7f21d 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -29,7 +29,7 @@ static __initconst const u64 amd_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
+		[ C(RESULT_ACCESS) ] = 0,
 		[ C(RESULT_MISS)   ] = 0,
 	},
  },
-- 
1.7.3.1

