Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2HFFLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 01:11:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:9342 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2HFFLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 01:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="176383261"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 1/3] perf/x86: Fix section mismatch in uncore_types_exit()
Date: Mon,  6 Aug 2012 13:11:20 +0800
Message-Id: <1344229882-3907-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Fix section mismatch in uncore_types_exit():

WARNING: vmlinux.o(.text+0x13831): Section mismatch in
reference from the function uncore_types_exit() to the
function .init.text:uncore_type_exit()

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 7563fda..a7ccd68 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2373,7 +2373,7 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 	type->attr_groups[1] = NULL;
 }
 
-static void uncore_types_exit(struct intel_uncore_type **types)
+static void __init uncore_types_exit(struct intel_uncore_type **types)
 {
 	int i;
 	for (i = 0; types[i]; i++)
-- 
1.7.11.2

