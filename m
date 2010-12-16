Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0LPKBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:01:41 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37707 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0LPKBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:01:36 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:28:58 +0530
Message-Id: <20101216095858.23751.59998.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 9/20]  9: x86: architecture specific task information.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On X86_64, we need to support rip relative instructions.
Rip relative instructions are handled by saving the scratch register
on probe hit and then retrieving the previously saved scratch register
after single-step. This value stored at probe hit is specific to each
task. Hence this is implemented as part of uprobe_task_arch_info.

Since x86_32 has no support for rip relative instructions, we dont need to
bother for x86_32.

Signed-off-by: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/include/asm/uprobes.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 0063207..e38950f 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -34,8 +34,13 @@ typedef u8 uprobe_opcode_t;
 struct uprobe_arch_info {
 	unsigned long rip_rela_target_address;
 };
+
+struct uprobe_task_arch_info {
+	unsigned long saved_scratch_register;
+};
 #else
 struct uprobe_arch_info {};
+struct uprobe_task_arch_info {};
 #endif
 struct uprobe;
 extern int analyze_insn(struct task_struct *tsk, struct uprobe *uprobe);
