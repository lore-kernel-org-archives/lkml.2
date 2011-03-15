Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab1COUm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 16:42:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41387 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab1COUmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 16:42:25 -0400
Date: Tue, 15 Mar 2011 21:42:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug for v2.6.39
Message-ID: <20110315204212.GA1437@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-debug-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (2):
      x86: Don't call dump_stack() from arch_trigger_all_cpu_backtrace_handler()
      x86: Combine printk()s in show_regs_common()


 arch/x86/kernel/apic/hw_nmi.c |    1 -
 arch/x86/kernel/process.c     |    9 +++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 79fd43c..c4e557a 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -83,7 +83,6 @@ arch_trigger_all_cpu_backtrace_handler(struct notifier_block *self,
 		arch_spin_lock(&lock);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
-		dump_stack();
 		arch_spin_unlock(&lock);
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 		return NOTIFY_STOP;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ff45541..99fa3ad 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -110,12 +110,9 @@ void show_regs_common(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	printk(KERN_CONT " ");
-	printk(KERN_CONT "%s %s", vendor, product);
-	if (board) {
-		printk(KERN_CONT "/");
-		printk(KERN_CONT "%s", board);
-	}
+	printk(KERN_CONT " %s %s", vendor, product);
+	if (board)
+		printk(KERN_CONT "/%s", board);
 	printk(KERN_CONT "\n");
 }
 
