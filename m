Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2CHKSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:18:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2CHKSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:18:52 -0500
Date: Thu, 8 Mar 2012 02:18:06 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-c7e23289a6aa95048a78b252b462f24ca6cf7f96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4F58889202000078000770E7@nat28.tlf.novell.com>
References: <4F58889202000078000770E7@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/32:
  Print control and debug registers for kerenel context
Git-Commit-ID: c7e23289a6aa95048a78b252b462f24ca6cf7f96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Mar 2012 02:18:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7e23289a6aa95048a78b252b462f24ca6cf7f96
Gitweb:     http://git.kernel.org/tip/c7e23289a6aa95048a78b252b462f24ca6cf7f96
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 8 Mar 2012 09:23:14 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Mar 2012 10:57:35 +0100

x86/32: Print control and debug registers for kerenel context

While for a user mode register dump it may be reasonable to skip
those (albeit x86-64 doesn't do so), for kernel mode dumps these
should be printed to make sure all information possibly
necessary for analysis is available.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F58889202000078000770E7@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/dumpstack_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index c99f9ed..88ec912 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -87,7 +87,7 @@ void show_registers(struct pt_regs *regs)
 	int i;
 
 	print_modules();
-	__show_regs(regs, 0);
+	__show_regs(regs, !user_mode_vm(regs));
 
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
 		TASK_COMM_LEN, current->comm, task_pid_nr(current),
