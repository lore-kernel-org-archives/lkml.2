Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1GOFZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:25:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:1598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1GOFZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:25:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,533,1304319600"; 
   d="scan'208";a="27934892"
Subject: [PATCH] ftrace: Fix building warning with !CONFIG_FUNCTION_TRACER
From: Lin Ming <ming.m.lin@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 13:32:42 +0800
Message-ID: <1310707962.18875.349.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 43dd61c(ftrace: Fix regression of :mod:module function enabling)
causes below warning because ‘struct ftrace_hash’ is not declared with
!CONFIG_FUNCTION_TRACER.

In file included from /linux-2.6/include/linux/perf_event.h:508:0,
                 from /linux-2.6/include/linux/ftrace_event.h:8,
                 from /linux-2.6/include/trace/syscall.h:6,
                 from /linux-2.6/include/linux/syscalls.h:77,
                 from /linux-2.6/arch/x86/ia32/ipc32.c:4:
/linux-2.6/include/linux/ftrace.h:128:6: warning: ‘struct ftrace_hash’
declared inside parameter list [enabled by default]
/linux-2.6/include/linux/ftrace.h:128:6: warning: its scope is only this
definition or declaration, which is probably not what you want [enabled
by default]

Fixed it by declaring "struct ftrace_hash" outside of
#ifdef CONFIG_FUNCTION_TRACER

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ed0eb52..f0c0e8a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -19,6 +19,8 @@
 
 #include <asm/ftrace.h>
 
+struct ftrace_hash;
+
 #ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
@@ -29,8 +31,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
-struct ftrace_hash;
-
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,


