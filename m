Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2CHJWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:22:31 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:55227 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2CHJW2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 8 Mar 2012 04:22:28 -0500
Message-Id: <4F58889202000078000770E7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 08 Mar 2012 09:23:14 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: in kernel context print control and debug
 registers too
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While for a user mode register dump it may be reasonable to skip those
(albeit x86-64 doesn't do so), for kernel mode dumps these should be
printed to make sure all information possibly necessary for analysis is
available.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/dumpstack_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.3-rc6/arch/x86/kernel/dumpstack_32.c
+++ 3.3-rc6-ix86-kernel-show-all-regs/arch/x86/kernel/dumpstack_32.c
@@ -87,7 +87,7 @@ void show_registers(struct pt_regs *regs
 	int i;
 
 	print_modules();
-	__show_regs(regs, 0);
+	__show_regs(regs, !user_mode_vm(regs));
 
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),



