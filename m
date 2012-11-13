Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2KNCh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:37:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:3412 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932423Ab2KNCdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:33:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="217413928"
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
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v10 06/14] kernel/cpu.c: Add comment for priority in cpu_hotplug_pm_callback
Date: Tue, 13 Nov 2012 11:32:43 -0800
Message-Id: <1352835171-3958-7-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1352835171-3958-1-git-send-email-fenghua.yu@intel.com>
References: <1352835171-3958-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

cpu_hotplug_pm_callback should have higher priority than
bsp_pm_callback which depends on cpu_hotplug_pm_callback to disable cpu hotplug
to avoid race during bsp online checking.

This is to hightlight the priorities between the two callbacks in case people
may overlook the order.

Ideally the priorities should be defined in macro/enum instead of fixed values.
To do that, a seperate patchset may be pushed which will touch serveral other
generic files and is out of scope of this patchset.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/cpu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 42bd331..a2491a2 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -601,6 +601,11 @@ cpu_hotplug_pm_callback(struct notifier_block *nb,
 
 static int __init cpu_hotplug_pm_sync_init(void)
 {
+	/*
+	 * cpu_hotplug_pm_callback has higher priority than x86
+	 * bsp_pm_callback which depends on cpu_hotplug_pm_callback
+	 * to disable cpu hotplug to avoid cpu hotplug race.
+	 */
 	pm_notifier(cpu_hotplug_pm_callback, 0);
 	return 0;
 }
-- 
1.7.2

