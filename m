Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1BJM3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:29:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab1BJMZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:04 -0500
From: stable-bot for Venkatesh Pallipadi <venki@google.com>
Date: Thu, 10 Feb 2011 10:23:26 +0100
Subject: [PATCH 14/28] sched: Consolidate account_system_vtime extern
 declaration
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: e1e10a265d28273ab8c70be19d43dcbdeead6c5a upstream
Author: Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon Oct 4 17:03:17 2010 -0700

Just a minor cleanup patch that makes things easier to the following patches.
No functionality change in this patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-3-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/ia64/include/asm/system.h    |    4 ----
 arch/powerpc/include/asm/system.h |    4 ----
 arch/s390/include/asm/system.h    |    1 -
 include/linux/hardirq.h           |    2 ++
 4 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/asm/system.h b/arch/ia64/include/asm/system.h
index 927a381..1ff461e 100644
--- a/arch/ia64/include/asm/system.h
+++ b/arch/ia64/include/asm/system.h
@@ -281,10 +281,6 @@ void cpu_idle_wait(void);
 
 void default_idle(void);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index bb8e006..094a12a 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -540,10 +540,6 @@ extern void reloc_got2(unsigned long);
 
 #define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 extern struct dentry *powerpc_debugfs_root;
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
index 379661d2..6b3a2e2 100644
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -97,7 +97,6 @@ static inline void restore_access_regs(unsigned int *acrs)
 
 extern void account_vtime(struct task_struct *, struct task_struct *);
 extern void account_tick_vtime(struct task_struct *);
-extern void account_system_vtime(struct task_struct *);
 
 #ifdef CONFIG_PFAULT
 extern void pfault_irq_init(void);
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index fa20e76..a1c732a 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -141,6 +141,8 @@ struct task_struct;
 static inline void account_system_vtime(struct task_struct *tsk)
 {
 }
+#else
+extern void account_system_vtime(struct task_struct *tsk);
 #endif
 
 #if defined(CONFIG_NO_HZ)
-- 
1.7.4


