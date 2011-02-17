Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab1BQPqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:46:48 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:35248 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab1BQPqq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Thu, 17 Feb 2011 10:46:46 -0500
Message-Id: <4D5D512902000078000326EE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 17 Feb 2011 15:47:37 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: don't call dump_stack() from
	 arch_trigger_all_cpu_backtrace_handler()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show_regs() already prints two(!) stack traces, no need for a third one.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/apic/hw_nmi.c |    1 -
 1 file changed, 1 deletion(-)

--- 2.6.38-rc5/arch/x86/kernel/apic/hw_nmi.c
+++ 2.6.38-rc5-x86-backtrace-all-no-dump_stack/arch/x86/kernel/apic/hw_nmi.c
@@ -83,7 +83,6 @@ arch_trigger_all_cpu_backtrace_handler(s
 		arch_spin_lock(&lock);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
-		dump_stack();
 		arch_spin_unlock(&lock);
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 		return NOTIFY_STOP;



