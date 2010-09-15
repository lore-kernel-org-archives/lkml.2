Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab0IOKFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:05:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:40011 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0IOKFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:05:20 -0400
Date: Wed, 15 Sep 2010 10:04:54 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1284512670-2369-4-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-4-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Make functions static
Message-ID: <tip-6376b2297502e72255b7eb2893c6044ad5a7b5f4@git.kernel.org>
Git-Commit-ID: 6376b2297502e72255b7eb2893c6044ad5a7b5f4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:04:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6376b2297502e72255b7eb2893c6044ad5a7b5f4
Gitweb:     http://git.kernel.org/tip/6376b2297502e72255b7eb2893c6044ad5a7b5f4
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 15 Sep 2010 10:04:28 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:44:01 +0200

kprobes: Make functions static

Make following (internal) functions static to make sparse
happier :-)

 * get_optimized_kprobe: only called from static functions
 * kretprobe_table_unlock: _lock function is static
 * kprobes_optinsn_template_holder: never called but holding asm code

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1284512670-2369-4-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
