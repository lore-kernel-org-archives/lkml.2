Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2HUJJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:09:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:56078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab2HUJIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:08:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,801,1336374000"; 
   d="scan'208";a="183342786"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: a.p.zijlstra@chello.nl, eranian@google.com, mingo@elte.hu,
        andi@firstfloor.org, avi@redhat.com, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH] perf/x86: Disable uncore on virtualized CPU.
Date: Tue, 21 Aug 2012 17:08:37 +0800
Message-Id: <1345540117-14164-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Initializing uncore PMU on virtualized CPU may hang the kernel.
This is because kvm does not emulate the entire hardware. Thers
are lots of uncore related MSRs, making kvm enumerate them all
is a non-trival task. So just disable uncore on virtualized CPU.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0a55710..2f005ba 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2898,6 +2898,9 @@ static int __init intel_uncore_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return -ENODEV;
 
+	if (cpu_has_hypervisor)
+		return -ENODEV;
+
 	ret = uncore_pci_init();
 	if (ret)
 		goto fail;
-- 
1.7.11.2

