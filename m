Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933478Ab1C3VHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:07:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:26254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933257Ab1C3VHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734855"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: venki@google.com, a.p.zijlstra@chello.nl, ak@linux.intel.com,
        mingo@elte.hu, efault@gmx.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [98/275] sched: Consolidate account_system_vtime extern declaration
Message-Id: <20110330210536.CABB63E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
Commit: e1e10a265d28273ab8c70be19d43dcbdeead6c5a upstream

Just a minor cleanup patch that makes things easier to the following patches.
No functionality change in this patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <1286237003-12406-3-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/ia64/include/asm/system.h    |    4 ----
 arch/powerpc/include/asm/system.h |    4 ----
 arch/s390/include/asm/system.h    |    1 -
 include/linux/hardirq.h           |    2 ++
 4 files changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6.35.y/arch/ia64/include/asm/system.h
===================================================================
--- linux-2.6.35.y.orig/arch/ia64/include/asm/system.h	2011-03-29 22:51:30.768935869 -0700
+++ linux-2.6.35.y/arch/ia64/include/asm/system.h	2011-03-29 23:03:00.172295761 -0700
@@ -272,10 +272,6 @@
 
 void default_idle(void);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
Index: linux-2.6.35.y/arch/powerpc/include/asm/system.h
===================================================================
--- linux-2.6.35.y.orig/arch/powerpc/include/asm/system.h	2011-03-29 22:51:30.768935869 -0700
+++ linux-2.6.35.y/arch/powerpc/include/asm/system.h	2011-03-29 23:03:00.172295761 -0700
@@ -545,10 +545,6 @@
 
 #define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 extern struct dentry *powerpc_debugfs_root;
 
 #endif /* __KERNEL__ */
Index: linux-2.6.35.y/arch/s390/include/asm/system.h
===================================================================
--- linux-2.6.35.y.orig/arch/s390/include/asm/system.h	2011-03-29 22:51:30.768935869 -0700
+++ linux-2.6.35.y/arch/s390/include/asm/system.h	2011-03-29 23:03:00.199295071 -0700
@@ -97,7 +97,6 @@
 
 extern void account_vtime(struct task_struct *, struct task_struct *);
 extern void account_tick_vtime(struct task_struct *);
-extern void account_system_vtime(struct task_struct *);
 
 #ifdef CONFIG_PFAULT
 extern void pfault_irq_init(void);
Index: linux-2.6.35.y/include/linux/hardirq.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/hardirq.h	2011-03-29 23:03:00.144296478 -0700
+++ linux-2.6.35.y/include/linux/hardirq.h	2011-03-29 23:55:00.771447437 -0700
@@ -141,6 +141,8 @@
 static inline void account_system_vtime(struct task_struct *tsk)
 {
 }
+#else
+extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
 #if defined(CONFIG_NO_HZ)
