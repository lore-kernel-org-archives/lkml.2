Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474Ab2INLop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:44:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2INLok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:44:40 -0400
Date: Fri, 14 Sep 2012 04:44:23 -0700
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-47d5a5f88b9d25d6464c9b60c28f391e84e3ed65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        rostedt@goodmis.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20120905143118.10329.5078.stgit@localhost.localdomain>
References: <20120905143118.10329.5078.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86-64: Allow to change RIP in handlers
Git-Commit-ID: 47d5a5f88b9d25d6464c9b60c28f391e84e3ed65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 14 Sep 2012 04:44:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47d5a5f88b9d25d6464c9b60c28f391e84e3ed65
Gitweb:     http://git.kernel.org/tip/47d5a5f88b9d25d6464c9b60c28f391e84e3ed65
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Wed, 5 Sep 2012 23:31:18 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 13 Sep 2012 22:52:10 -0400

ftrace/x86-64: Allow to change RIP in handlers

Allow ftrace handlers to change RIP register (regs->ip)
in handlers. This will allow handlers to call another
function instead of original function.

Link: http://lkml.kernel.org/r/20120905143118.10329.5078.stgit@localhost.localdomain

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
