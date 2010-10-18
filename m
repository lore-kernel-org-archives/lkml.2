Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0JRTZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:25:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:58744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879Ab0JRTZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:25:27 -0400
Date: Mon, 18 Oct 2010 19:24:58 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1286237003-12406-3-git-send-email-venki@google.com>
References: <1286237003-12406-3-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Consolidate account_system_vtime extern declaration
Message-ID: <tip-e1e10a265d28273ab8c70be19d43dcbdeead6c5a@git.kernel.org>
Git-Commit-ID: e1e10a265d28273ab8c70be19d43dcbdeead6c5a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:24:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1e10a265d28273ab8c70be19d43dcbdeead6c5a
Gitweb:     http://git.kernel.org/tip/e1e10a265d28273ab8c70be19d43dcbdeead6c5a
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Mon, 4 Oct 2010 17:03:17 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 20:52:21 +0200

sched: Consolidate account_system_vtime extern declaration

Just a minor cleanup patch that makes things easier to the following patches.
No functionality change in this patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1286237003-12406-3-git-send-email-venki@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/include/asm/system.h    |    4 ----
 arch/powerpc/include/asm/system.h |    4 ----
 arch/s390/include/asm/system.h    |    1 -
 include/linux/hardirq.h           |    2 ++
 4 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/asm/system.h b/arch/ia64/include/asm/system.h
index 9f342a5..dd028f2 100644
--- a/arch/ia64/include/asm/system.h
+++ b/arch/ia64/include/asm/system.h
@@ -272,10 +272,6 @@ void cpu_idle_wait(void);
 
 void default_idle(void);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index 6c294ac..9c3d160 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -542,10 +542,6 @@ extern void reloc_got2(unsigned long);
 
 #define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_system_vtime(struct task_struct *);
-#endif
-
 extern struct dentry *powerpc_debugfs_root;
 
 #endif /* __KERNEL__ */
diff --git a/arch/s390/include/asm/system.h b/arch/s390/include/asm/system.h
index cef6621..38ddd8a 100644
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -97,7 +97,6 @@ static inline void restore_access_regs(unsigned int *acrs)
 
 extern void account_vtime(struct task_struct *, struct task_struct *);
 extern void account_tick_vtime(struct task_struct *);
-extern void account_system_vtime(struct task_struct *);
 
 #ifdef CONFIG_PFAULT
 extern void pfault_irq_init(void);
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index e37a77c..41367c5 100644
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
