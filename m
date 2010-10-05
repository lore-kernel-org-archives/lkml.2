Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab0JEAFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:05:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32551 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab0JEADx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:03:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=byDdOdmt6A65fVj797SQZrXqI6Q23uHNSU+cp64gDqp26bZyTN5S6zirv7QvM5LZ8o
         PrWt7B1wvXx4+mPlO9Hw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 2/8] Consolidate account_system_vtime extern declaration -v4
Date: Mon,  4 Oct 2010 17:03:17 -0700
Message-Id: <1286237003-12406-3-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286237003-12406-1-git-send-email-venki@google.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a minor cleanup patch that makes things easier to the following patches.
No functionality change in this patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
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
-- 
1.7.1

