Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2IEOcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:32:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37644 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2IEOcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:32:43 -0400
X-AuditID: b753bd60-900c0ba0000047ca-45-50476289813c
X-AuditID: b753bd60-900c0ba0000047ca-45-50476289813c
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  3/4] ftrace/x86-64: Allow to change RIP in handlers
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        yrl.pp-manager.tt@hitachi.com, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 05 Sep 2012 23:31:18 +0900
Message-ID: <20120905143118.10329.5078.stgit@localhost.localdomain>
In-Reply-To: <20120905143045.10329.64502.stgit@localhost.localdomain>
References: <20120905143045.10329.64502.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Allow ftrace handlers to change RIP register (regs->ip)
in handlers. This will allow handlers to call another
function instead of original function.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kernel/entry_64.S |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ed767b7..e9cc2b3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -165,6 +165,10 @@ GLOBAL(ftrace_regs_call)
 	movq EFLAGS(%rsp), %rax
 	movq %rax, SS(%rsp)
 
+	/* Handlers can change the RIP */
+	movq RIP(%rsp), %rax
+	movq %rax, SS+8(%rsp)
+
 	/* restore the rest of pt_regs */
 	movq R15(%rsp), %r15
 	movq R14(%rsp), %r14

