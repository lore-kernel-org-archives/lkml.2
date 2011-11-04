Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1KDWVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:21:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:9875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1KDWVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:21:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71337188"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 1/9] include/linux/cpu.h: Define architecture dependent cpu map update and state check functions
Date: Fri,  4 Nov 2011 15:03:53 -0700
Message-Id: <1320444241-834-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

arch_cpu_maps_update_begin() and arch_cpu_maps_update_done() are architecture
dependent cpu map update functions which are called during cpu_up() and
cpu_down().

arch_state_check() is architecture dependent state check function which is
called during hibernate and suspend.

They are empty __weak functions and are overriden in x86.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 include/linux/cpu.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index b1a635a..88a6390 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -137,6 +137,8 @@ int cpu_up(unsigned int cpu);
 void notify_cpu_starting(unsigned int cpu);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
+extern void arch_cpu_maps_update_begin(void);
+extern void arch_cpu_maps_update_done(void);
 
 #else	/* CONFIG_SMP */
 
@@ -207,4 +209,8 @@ static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif /* !CONFIG_PM_SLEEP_SMP */
 
+#ifdef CONFIG_PM
+extern int  arch_state_check(void);
+#endif
+
 #endif /* _LINUX_CPU_H_ */
-- 
1.6.0.3

