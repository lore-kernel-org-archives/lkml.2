Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab1CNNlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:41:35 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50591 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab1CNNlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:41:32 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:05:50 +0530
Message-Id: <20110314133550.27435.62287.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 9/20]  9: x86: architecture specific task information.
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
