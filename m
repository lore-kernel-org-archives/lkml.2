Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab2JLQvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:51:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:21735 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759940Ab2JLQtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:49:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,577,1344236400"; 
   d="scan'208";a="233264067"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatssa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v9 09/12] x86, hotplug: During CPU0 online, enable x2apic, set_numa_node.
Date: Fri, 12 Oct 2012 09:09:46 -0700
Message-Id: <1350058189-6769-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
References: <1350058189-6769-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Previously these functions were not run on the BSP (CPU 0, the boot processor)
since the boot processor init would only be executed before this functionality
was initialized.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/common.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7505f7b..ca165ac 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1237,7 +1237,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && this_cpu_read(numa_node) == 0 &&
+	if (this_cpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
@@ -1269,8 +1269,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	if (cpu != 0)
-		enable_x2apic();
+	enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
-- 
1.7.2

