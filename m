Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab1KOANc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 19:13:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:7753 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab1KOANa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 19:13:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,511,1315206000"; 
   d="scan'208";a="90449093"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>,
        "linux-next" <linux-next@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH] kernel/cpu.c: Add right qualifiers for intel_thermal_interrupt() and cpu_hotplug_pm_sync_init() 
Date: Mon, 14 Nov 2011 15:56:07 -0800
Message-Id: <1321314967-4559-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add __init for functions alloc_frozen_cpus() and cpu_hotplug_pm_sync_init()
because they are only called during boot time.

Add static for function cpu_hotplug_pm_sync_init() because its scope is limited
in this file only.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 kernel/cpu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 563f136..cf915b8 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -470,7 +470,7 @@ out:
 	cpu_maps_update_done();
 }
 
-static int alloc_frozen_cpus(void)
+static int __init alloc_frozen_cpus(void)
 {
 	if (!alloc_cpumask_var(&frozen_cpus, GFP_KERNEL|__GFP_ZERO))
 		return -ENOMEM;
@@ -543,7 +543,7 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 }
 
 
-int cpu_hotplug_pm_sync_init(void)
+static int __init cpu_hotplug_pm_sync_init(void)
 {
 	pm_notifier(cpu_hotplug_pm_callback, 0);
 	return 0;
-- 
1.6.0.3

