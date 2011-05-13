Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1EMGwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:52:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:54670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab1EMGwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:52:38 -0400
Date: Fri, 13 May 2011 06:52:03 GMT
From: tip-bot for Richard Weinberger <richard@nod.at>
Message-ID: <tip-449a66fd1fa75d36dca917704827c40c8f416bca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        mingo@redhat.com, richard@nod.at, lethal@linux-sh.org,
        namhyung@gmail.com, ssp@redhat.com, ying.huang@intel.com,
        fweisbec@gmail.com, robert.richter@amd.com, akpm@linux-foundation.org,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, richard@nod.at, lethal@linux-sh.org,
        namhyung@gmail.com, ssp@redhat.com, ying.huang@intel.com,
        robert.richter@amd.com, fweisbec@gmail.com, akpm@linux-foundation.org,
        oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <1305205872-10321-2-git-send-email-richard@nod.at>
References: <1305205872-10321-2-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Remove warning and warning_symbol from struct stacktrace_ops
Git-Commit-ID: 449a66fd1fa75d36dca917704827c40c8f416bca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 13 May 2011 06:52:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  449a66fd1fa75d36dca917704827c40c8f416bca
Gitweb:     http://git.kernel.org/tip/449a66fd1fa75d36dca917704827c40c8f416bca
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Thu, 12 May 2011 15:11:12 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 12 May 2011 15:31:28 +0200

x86: Remove warning and warning_symbol from struct stacktrace_ops

Both warning and warning_symbol are nowhere used.
Let's get rid of them.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Soeren Sandmann Pedersen <ssp@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: x86 <x86@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/1305205872-10321-2-git-send-email-richard@nod.at
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/stacktrace.h |    3 ---
 arch/x86/kernel/cpu/perf_event.c  |   13 -------------
 arch/x86/kernel/dumpstack.c       |   16 ----------------
 arch/x86/kernel/stacktrace.c      |   13 -------------
 arch/x86/oprofile/backtrace.c     |   13 -------------
 5 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/stacktrace.h b/arch/x86/include/asm/stacktrace.h
index d7e89c8..70bbe39 100644
--- a/arch/x86/include/asm/stacktrace.h
+++ b/arch/x86/include/asm/stacktrace.h
@@ -37,9 +37,6 @@ print_context_stack_bp(struct thread_info *tinfo,
 /* Generic stack tracer with callbacks */
 
 struct stacktrace_ops {
-	void (*warning)(void *data, char *msg);
-	/* msg must contain %s for the symbol */
-	void (*warning_symbol)(void *data, char *msg, unsigned long symbol);
 	void (*address)(void *data, unsigned long address, int reliable);
 	/* On negative return stop dumping */
 	int (*stack)(void *data, char *name);
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 0de6b2b..3a0338b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1773,17 +1773,6 @@ static struct pmu pmu = {
  * callchain support
  */
 
-static void
-backtrace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	return 0;
@@ -1797,8 +1786,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops backtrace_ops = {
-	.warning		= backtrace_warning,
-	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
 	.walk_stack		= print_context_stack_bp,
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index e2a3f06..f478ff6 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -135,20 +135,6 @@ print_context_stack_bp(struct thread_info *tinfo,
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);
 
-
-static void
-print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-	printk(data);
-	print_symbol(msg, symbol);
-	printk("\n");
-}
-
-static void print_trace_warning(void *data, char *msg)
-{
-	printk("%s%s\n", (char *)data, msg);
-}
-
 static int print_trace_stack(void *data, char *name)
 {
 	printk("%s <%s> ", (char *)data, name);
@@ -166,8 +152,6 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning		= print_trace_warning,
-	.warning_symbol		= print_trace_warning_symbol,
 	.stack			= print_trace_stack,
 	.address		= print_trace_address,
 	.walk_stack		= print_context_stack,
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index 6515733..55d9bc0 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -9,15 +9,6 @@
 #include <linux/uaccess.h>
 #include <asm/stacktrace.h>
 
-static void save_stack_warning(void *data, char *msg)
-{
-}
-
-static void
-save_stack_warning_symbol(void *data, char *msg, unsigned long symbol)
-{
-}
-
 static int save_stack_stack(void *data, char *name)
 {
 	return 0;
@@ -53,16 +44,12 @@ save_stack_address_nosched(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops save_stack_ops = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address,
 	.walk_stack	= print_context_stack,
 };
 
 static const struct stacktrace_ops save_stack_ops_nosched = {
-	.warning	= save_stack_warning,
-	.warning_symbol	= save_stack_warning_symbol,
 	.stack		= save_stack_stack,
 	.address	= save_stack_address_nosched,
 	.walk_stack	= print_context_stack,
diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 2d49d4e..a5b64ab 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -16,17 +16,6 @@
 #include <asm/stacktrace.h>
 #include <linux/compat.h>
 
-static void backtrace_warning_symbol(void *data, char *msg,
-				     unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
-
 static int backtrace_stack(void *data, char *name)
 {
 	/* Yes, we want all stacks */
@@ -42,8 +31,6 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 }
 
 static struct stacktrace_ops backtrace_ops = {
-	.warning	= backtrace_warning,
-	.warning_symbol	= backtrace_warning_symbol,
 	.stack		= backtrace_stack,
 	.address	= backtrace_address,
 	.walk_stack	= print_context_stack,
