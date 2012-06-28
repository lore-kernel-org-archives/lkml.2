Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab2F1G4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:56:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:8013 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab2F1G4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:56:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185961929"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86: Fix event constraint for SandyBridge-EP C-Box
Date: Thu, 28 Jun 2012 14:56:36 +0800
Message-Id: <1340866596-22502-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340866596-22502-1-git-send-email-zheng.z.yan@intel.com>
References: <1340866596-22502-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The constraint for C-Box event 0x1f should have overlap flag set.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index e15344d..29d0f43 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -348,7 +348,7 @@ static struct event_constraint snbep_uncore_cbox_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0x1c, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0x1d, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0x1e, 0xc),
-	UNCORE_EVENT_CONSTRAINT(0x1f, 0xe),
+	EVENT_CONSTRAINT_OVERLAP(0x1f, 0xe, 0xff),
 	UNCORE_EVENT_CONSTRAINT(0x21, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x23, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x31, 0x3),
-- 
1.7.10.2

