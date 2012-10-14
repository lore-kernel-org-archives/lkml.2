Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab2JNTXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:23:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50480 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2JNTXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:23:39 -0400
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, oleg@redhat.com,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 1/9] uprobes: move function declarations out of arch
Date: Sun, 14 Oct 2012 21:23:05 +0200
Message-Id: <1350242593-17761-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems odd to keep the function declarations in the arch header where
they will need to be copy/pasted verbatim across arches.  Move them to
the common header.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/x86/include/asm/uprobes.h |    6 ------
 include/linux/uprobes.h        |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 8ff8be7..b20b4d6 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -49,10 +49,4 @@ struct arch_uprobe_task {
 	unsigned int			saved_tf;
 };
 
-extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long addr);
-extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
-extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
-extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
-extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 #endif	/* _ASM_UPROBES_H */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index e6f0331..ac90704 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -30,6 +30,7 @@
 struct vm_area_struct;
 struct mm_struct;
 struct inode;
+struct notifier_block;
 
 #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
 # include <asm/uprobes.h>
@@ -120,6 +121,13 @@ extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
 extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void uprobe_clear_state(struct mm_struct *mm);
+extern void uprobe_reset_state(struct mm_struct *mm);
+extern int  arch_uprobe_analyze_insn(struct arch_uprobe *aup, struct mm_struct *mm,unsigned long addr);
+extern int  arch_uprobe_pre_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
+extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
+extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
+extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
-- 
1.7.9.5

