Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2AKR1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:27:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:1574 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933491Ab2AKRYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:24:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106055463"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 07/12] x86/head_32.S: Define start_cpu0
Date: Wed, 11 Jan 2012 09:04:48 -0800
Message-Id: <1326301493-28760-8-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

start_cpu0() is defined in head_32.S for 32-bit. The function sets up stack and
jumps to start_secondary() for CPU0 wake up.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/head_32.S |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce0be7c..5a38a1a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -265,6 +265,20 @@ num_subarch_entries = (. - subarch_entries) / 4
 	jmp default_entry
 #endif /* CONFIG_PARAVIRT */
 
+__CPUINIT
+
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
+ * up already except stack. We just set up stack here. Then call
+ * start_secondary().
+ */
+ENTRY(start_cpu0)
+	movl stack_start, %ecx
+	movl %ecx, %esp
+	jmp  *(initial_code)
+#endif
+
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
@@ -273,9 +287,6 @@ num_subarch_entries = (. - subarch_entries) / 4
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
  */
-
-__CPUINIT
-
 #ifdef CONFIG_SMP
 ENTRY(startup_32_smp)
 	cld
-- 
1.6.0.3

