Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2HUPFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:05:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2HUPFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:05:44 -0400
Date: Tue, 21 Aug 2012 08:01:03 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-28fb5dfa783c25dbeeb25a72663f8066a3a517f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20120612225424.942411318@goodmis.org>
References: <20120612225424.942411318@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86_32:
  Push ftrace_ops in as 3rd parameter to function tracer
Git-Commit-ID: 28fb5dfa783c25dbeeb25a72663f8066a3a517f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:01:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28fb5dfa783c25dbeeb25a72663f8066a3a517f5
Gitweb:     http://git.kernel.org/tip/28fb5dfa783c25dbeeb25a72663f8066a3a517f5
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Wed, 10 Aug 2011 22:00:55 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 19 Jul 2012 13:19:27 -0400

ftrace/x86_32: Push ftrace_ops in as 3rd parameter to function tracer

Add support of passing the current ftrace_ops into the 3rd parameter
of the callback to the function tracer.

Link: http://lkml.kernel.org/r/20120612225424.942411318@goodmis.org

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/entry_32.S    |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 783b107..b3bb1f3 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -32,7 +32,7 @@
 #define MCOUNT_ADDR		((long)(mcount))
 #define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
 
-#if defined(CONFIG_DYNAMIC_FTRACE) && defined(CONFIG_X86_64)
+#ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
 #endif
 
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 623f288..e3e17a0 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1111,6 +1111,7 @@ ENTRY(ftrace_caller)
 	pushl %edx
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
+	leal function_trace_op, %ecx
 	subl $MCOUNT_INSN_SIZE, %eax
 
 .globl ftrace_call
