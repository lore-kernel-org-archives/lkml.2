Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab2HXBML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:12:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:4359 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab2HXBLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:11:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="184254142"
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
Subject: [PATCH v7 02/12] x86/Kconfig: Add config switch for CPU0 hotplug
Date: Thu, 23 Aug 2012 17:56:01 -0700
Message-Id: <1345769771-27019-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
References: <1345769771-27019-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

New config switch CONFIG_BOOTPARAM_HOTPLUG_CPU0 sets default state of whether
the CPU0 hotplug is on or off.

If the switch is off, CPU0 is not hotpluggable by default. But the CPU0 hotplug
feature can still be turned on by kernel parameter cpu0_hotplug at boot.

If the switch is on, CPU0 is always hotpluggable. The default value of
the switch is off.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/Kconfig |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d91dac..31c8b89 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1711,6 +1711,35 @@ config HOTPLUG_CPU
 	    automatically on SMP systems. )
 	  Say N if you want to disable CPU hotplug.
 
+config BOOTPARAM_HOTPLUG_CPU0
+	bool "Set default setting of cpu0_hotpluggable"
+	default n
+	depends on HOTPLUG_CPU && EXPERIMENTAL
+	---help---
+	  Set whether default state of cpu0_hotpluggable is on or off.
+
+	  Say Y here to enable CPU0 hotplug by default. If this switch
+	  is turned on, there is no need to give cpu0_hotplug kernel
+	  parameter and the CPU0 hotplug feature is enabled by default.
+
+	  Please note: there are two known CPU0 dependencies if you want
+	  to enable the CPU0 hotplug feature either by this switch or by
+	  cpu0_hotplug kernel parameter.
+
+	  First, resume from hibernate or suspend always starts from CPU0.
+	  So hibernate and suspend are prevented if CPU0 is offline.
+
+	  Second dependency is PIC interrupts always go to CPU0. CPU0 can not
+	  offline if any interrupt can not migrate out of CPU0. There may
+	  be other CPU0 dependencies.
+
+	  Please make sure the dependencies are under your control before
+	  you enable this feature.
+
+	  Say N if you don't want to enable CPU0 hotplug feature by default.
+	  You still can enable the CPU0 hotplug feature at boot by kernel
+	  parameter cpu0_hotplug.
+
 config COMPAT_VDSO
 	def_bool y
 	prompt "Compat VDSO support"
-- 
1.7.2

