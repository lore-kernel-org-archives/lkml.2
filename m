Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab2JBXxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:53:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:60113 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756832Ab2JBXtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="199832070"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/31] perf, x86: Disable LBR recording for unknown LBR_FMT
Date: Tue,  2 Oct 2012 16:48:29 -0700
Message-Id: <1349221731-15665-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When the LBR format is unknown disable LBR recording. This prevents
crashes when the LBR address is misdecoded and mis-sign extended.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 2af6695b..ad5af13 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -13,6 +13,7 @@ enum {
 	LBR_FORMAT_EIP		= 0x02,
 	LBR_FORMAT_EIP_FLAGS	= 0x03,
 	LBR_FORMAT_EIP_FLAGS2	= 0x04,
+	LBR_FORMAT_MAX_KNOWN	= LBR_FORMAT_EIP_FLAGS2,
 };
 
 /*
@@ -392,7 +393,7 @@ int intel_pmu_setup_lbr_filter(struct perf_event *event)
 	/*
 	 * no LBR on this PMU
 	 */
-	if (!x86_pmu.lbr_nr)
+	if (!x86_pmu.lbr_nr || x86_pmu.intel_cap.lbr_format > LBR_FORMAT_MAX_KNOWN)
 		return -EOPNOTSUPP;
 
 	/*
-- 
1.7.7.6

