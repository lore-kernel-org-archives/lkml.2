Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1BRKkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:40:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:50694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab1BRKkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:40:02 -0500
Date: Fri, 18 Feb 2011 10:39:37 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D5D512902000078000326EE@vpn.id2.novell.com>
References: <4D5D512902000078000326EE@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Don't call dump_stack() from arch_trigger_all_cpu_backtrace_handler()
Message-ID: <tip-bb3e6251a69e67d7620373ee18e35b404964273e@git.kernel.org>
Git-Commit-ID: bb3e6251a69e67d7620373ee18e35b404964273e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:39:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb3e6251a69e67d7620373ee18e35b404964273e
Gitweb:     http://git.kernel.org/tip/bb3e6251a69e67d7620373ee18e35b404964273e
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 17 Feb 2011 15:47:37 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Feb 2011 08:52:29 +0100

x86: Don't call dump_stack() from arch_trigger_all_cpu_backtrace_handler()

show_regs() already prints two(!) stack traces, no need for a third one.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D5D512902000078000326EE@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
