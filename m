Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2HBKzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:55:41 -0400
Received: from osrc3.amd.com ([217.9.48.20]:41656 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab2HBKzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:55:40 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Zheng Yan <zheng.z.yan@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] perf, x86: Fix uncore_types_exit section mismatch
Date: Thu,  2 Aug 2012 12:55:27 +0200
Message-Id: <1343904927-16905-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Fix the following section mismatch:

WARNING: arch/x86/kernel/cpu/built-in.o(.text+0x7ad9): Section mismatch in reference from the function uncore_types_exit() to the function .init.text:uncore_type_exit()
The function uncore_types_exit() references
the function __init uncore_type_exit().
This is often because uncore_types_exit lacks a __init
annotation or the annotation of uncore_type_exit is wrong.

caused by 14371cce03c2 ("perf: Add generic PCI uncore PMU device
support").

Cc: Zheng Yan <zheng.z.yan@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1339741902-8449-8-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 7563fda9f033..a7ccd68aa13a 100644
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
1.7.11.rc1

