Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab2GDGBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:01:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:28581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932801Ab2GDGAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163860386"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 2/5] perf/x86: Fix event constraint for SandyBridge-EP CBox
Date: Wed,  4 Jul 2012 14:00:13 +0800
Message-Id: <1341381616-12229-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
References: <1341381616-12229-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The constraint for CBox event 0x1f should have overlap flag set.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index afa9970..dbbf5a6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -239,7 +239,7 @@ static struct event_constraint snbep_uncore_cbox_constraints[] = {
 	UNCORE_EVENT_CONSTRAINT(0x1c, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0x1d, 0xc),
 	UNCORE_EVENT_CONSTRAINT(0x1e, 0xc),
-	UNCORE_EVENT_CONSTRAINT(0x1f, 0xe),
+	EVENT_CONSTRAINT_OVERLAP(0x1f, 0xe, 0xff),
 	UNCORE_EVENT_CONSTRAINT(0x21, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x23, 0x3),
 	UNCORE_EVENT_CONSTRAINT(0x31, 0x3),
-- 
1.7.10.4

