Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab2LRFO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:14:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:3717 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2LRFOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:14:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,305,1355126400"; 
   d="scan'208";a="182202475"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        mingo@kernel.org, Stephane Eranian <eranian@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] x86,perf: Add IvyBridge EP support
Date: Tue, 18 Dec 2012 12:20:23 -0500
Message-Id: <1355851223-27705-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run in perf utility at Ivybridge EP server, encouter "not supported" event

   <not supported> L1-dcache-loads         
   <not supported> L1-dcache-load-misses   
   <not supported> L1-dcache-stores        
   <not supported> L1-dcache-store-misses  
   <not supported> L1-dcache-prefetches    
   <not supported> L1-dcache-prefetch-misses

This patch add the support for this processor.

Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 324bb52..aea3503 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2075,6 +2075,7 @@ __init int intel_pmu_init(void)
 		pr_cont("SandyBridge events, ");
 		break;
 	case 58: /* IvyBridge */
+	case 62: /* IvyBridge EP */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
-- 
1.6.4.2

