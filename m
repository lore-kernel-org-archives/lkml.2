Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab1BPBz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:55:58 -0500
Received: from kroah.org ([198.145.64.141]:49323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594Ab1BPBvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:04 2011
Message-Id: <20110216014704.162331701@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:46:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [099/115] sched: Consolidate account_system_vtime extern declaration
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

Commit: e1e10a265d28273ab8c70be19d43dcbdeead6c5a upstream

Just a minor cleanup patch that makes things easier to the following patches.
No functionality change in this patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
--- a/arch/s390/include/asm/system.h
+++ b/arch/s390/include/asm/system.h
@@ -97,7 +97,6 @@ static inline void restore_access_regs(u
 
 extern void account_vtime(struct task_struct *, struct task_struct *);
 extern void account_tick_vtime(struct task_struct *);
-extern void account_system_vtime(struct task_struct *);
 
 #ifdef CONFIG_PFAULT
 extern void pfault_irq_init(void);
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


