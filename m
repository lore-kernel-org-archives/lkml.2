Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1FGNGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:06:37 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37606 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1FGNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:06:35 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 07 Jun 2011 18:29:41 +0530
Message-Id: <20110607125941.28590.20538.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v4 3.0-rc2-tip 8/22]  8: x86: architecture specific task information.
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
index 4295ce0..2f3c64d 100644
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
