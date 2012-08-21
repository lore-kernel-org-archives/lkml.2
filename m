Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2HUPKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:10:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59406 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2HUPKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:10:14 -0400
Date: Tue, 21 Aug 2012 08:04:37 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-5767cfeaa9ec7b67c802143394f3ad9f8b174eb8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20120711195745.588538769@goodmis.org>
References: <20120711195745.588538769@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ftrace/x86:
  Remove function_trace_stop check from graph caller
Git-Commit-ID: 5767cfeaa9ec7b67c802143394f3ad9f8b174eb8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:04:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5767cfeaa9ec7b67c802143394f3ad9f8b174eb8
Gitweb:     http://git.kernel.org/tip/5767cfeaa9ec7b67c802143394f3ad9f8b174eb8
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 3 Jul 2012 16:16:09 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 31 Jul 2012 10:29:51 -0400

ftrace/x86: Remove function_trace_stop check from graph caller

The graph caller is called by the mcount callers, which already does
the check against the function_trace_stop variable. No reason to
check it again.

Link: http://lkml.kernel.org/r/20120711195745.588538769@goodmis.org

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    3 ---
 arch/x86/kernel/entry_64.S |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 4dc3017..061ac17 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1241,9 +1241,6 @@ END(mcount)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	cmpl $0, function_trace_stop
-	jne ftrace_stub
-
 	pushl %eax
 	pushl %ecx
 	pushl %edx
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 52bda2e..38308fa 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -213,9 +213,6 @@ END(mcount)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
-	cmpl $0, function_trace_stop
-	jne ftrace_stub
-
 	MCOUNT_SAVE_FRAME
 
 	leaq 8(%rbp), %rdi
