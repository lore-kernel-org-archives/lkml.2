Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab1KJAvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:51:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:32783 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898Ab1KJAvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:51:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,486,1315206000"; 
   d="scan'208";a="35103428"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3 5/7] Documentations/cpu-hotplug.tx, kernel-parameters.txt: Add x86 CPU0 online/offline feature
Date: Wed,  9 Nov 2011 16:34:15 -0800
Message-Id: <1320885257-16647-6-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
References: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Add x86 CPU0 online/offline feature in the two documentations.

By default BSP is not pluggable. Kernel parameter bsp_hotplug enables BSP
online/offline feature.

The documentations point out two BSP dependencies. First, resume from hibernate
or suspend always starts from BSP. So hibernate and suspend are prevented if BSP
is offline. Another dependency is PIC interrupts always go to BSP.

It's said that some machines may depend on CPU0 to poweroff/reboot. But I
haven't seen such dependency on a few tested machines.

Please let me know if you see any CPU0 dependencies on your machine.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
---
 Documentation/cpu-hotplug.txt       |   19 +++++++++++++++++++
 Documentation/kernel-parameters.txt |   13 +++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index a20bfd4..93af1a0 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -207,6 +207,25 @@ by making it not-removable.
 
 In such cases you will also notice that the online file is missing under cpu0.
 
+Q: Is CPU0 removable on X86?
+A: Yes. If given kernel option bsp_hotplug, CPU0 is removable.
+
+But some features depend on BSP. Known dependencies are:
+1. Resume from hibernate/suspend depends on BSP. Hibernate/suspend will fail if
+BSP is offline and you need to online BSP before hibernate/suspend can continue.
+2. PIC interrupts also depend on BSP. BSP can't be removed if a PIC interrupt
+is detected.
+
+It's said poweroff/reboot may depend on BSP on some machines although I haven't
+seen any poweroff/reboot failure so far after BSP is offline on a few tested
+machines.
+
+Please let me know if you know or see any other dependencies of BSP.
+
+If the dependencies are under your control, you can turn on bsp_hotplug.
+
+--Fenghua Yu
+
 Q: How do i find out if a particular CPU is not removable?
 A: Depending on the implementation, some architectures may show this by the
 absence of the "online" file. This is done if it can be determined ahead of
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..55582db 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1842,6 +1842,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
+	bsp_hotplug	[X86] BSP (aka CPU0) is hotpluggable.
+			Some features depend on BSP. Known dependencies are:
+			1. Resume from suspend/hibernate depends on BSP.
+			Suspend/hibernate will fail if BSP is offline and you
+			need to online BSP before suspend/hibernate.
+			2. PIC interrupts also depend on BSP. BSP can't be
+			removed if a PIC interrupt is detected.
+			It's said poweroff/reboot may depend on BSP on some
+			machines although I haven't seen such issues so far
+			after BSP is offline on a few tested machines.
+			If the dependencies are under your control, you can
+			turn on bsp_hotplug.
+
 	nptcg=		[IA-64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
-- 
1.6.0.3

