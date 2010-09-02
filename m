Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0IBFDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:03:21 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33719 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0IBFC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ECoC7ZTg914o4kBHkf7tqZM1t3OQJN3o+vGr5HhmNdUjI9cDcqyorE0jk5MHfG/BI1
         GP+wZtahGrFV3bjKEMYK4vlX+NoAoOovGdHJqHMlvvIEA4O+Uc1VGCunj96CO3p3JbvW
         KqxLrhxvxEMQfvRfGM7nB42+MiSPY+NxPmWnI=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/5] kprobes: make functions static
Date: Thu,  2 Sep 2010 14:02:36 +0900
Message-Id: <1283403758-3827-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
References: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make following (internal) functions static to make sparse happier :-)

 * get_optimized_kprobe: only called from static functions
 * kretprobe_table_unlock: _lock function is static
 * kprobes_optinsn_template_holder: never called but holding asm code

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/kprobes.c |    2 +-
 kernel/kprobes.c          |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 770ebfb..05c20a4 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1129,7 +1129,7 @@ static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr,
 	*(unsigned long *)addr = val;
 }
 
-void __kprobes kprobes_optinsn_template_holder(void)
+static void __used __kprobes kprobes_optinsn_template_holder(void)
 {
 	asm volatile (
 			".global optprobe_template_entry\n"
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 1b0dbe0..c53aad5 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -399,7 +399,7 @@ static inline int kprobe_optready(struct kprobe *p)
  * Return an optimized kprobe whose optimizing code replaces
  * instructions including addr (exclude breakpoint).
  */
-struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
+static struct kprobe *__kprobes get_optimized_kprobe(unsigned long addr)
 {
 	int i;
 	struct kprobe *p = NULL;
@@ -857,7 +857,8 @@ void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
 	spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
-void __kprobes kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
+static void __kprobes kretprobe_table_unlock(unsigned long hash,
+       unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_unlock_irqrestore(hlist_lock, *flags);
-- 
1.7.2.2

