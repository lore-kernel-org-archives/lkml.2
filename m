Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab2JRXWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:22:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:3930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab2JRXUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:20:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="207876590"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/34] perf, x86: Disable LBR recording for unknown LBR_FMT
Date: Thu, 18 Oct 2012 16:19:17 -0700
Message-Id: <1350602382-12771-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
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

