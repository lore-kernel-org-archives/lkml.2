Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966392Ab0CPOtG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:49:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:49066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966317Ab0CPOtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:49:01 -0400
Date: Tue, 16 Mar 2010 14:47:53 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mail@dieterries.net, efault@gmx.de, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, hirofumi@mail.parknet.co.jp,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, acme@redhat.com, mail@dieterries.net,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, hirofumi@mail.parknet.co.jp,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, mingo@elte.hu
In-Reply-To: <20100315170054.31593.3153.stgit@localhost6.localdomain6>
References: <20100315170054.31593.3153.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Hide CONFIG_OPTPROBES and set if arch supports optimized kprobes
Message-ID: <tip-5cc718b9dad682329a60e73547c6e708faa5bbe4@git.kernel.org>
Git-Commit-ID: 5cc718b9dad682329a60e73547c6e708faa5bbe4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:47:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cc718b9dad682329a60e73547c6e708faa5bbe4
Gitweb:     http://git.kernel.org/tip/5cc718b9dad682329a60e73547c6e708faa5bbe4
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 15 Mar 2010 13:00:54 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 11:07:23 +0100

kprobes: Hide CONFIG_OPTPROBES and set if arch supports optimized kprobes

Hide CONFIG_OPTPROBES and set if the arch supports optimized
kprobes (IOW, HAVE_OPTPROBES=y), since this option doesn't
change the major behavior of kprobes, and workarounds for minor
changes are documented.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Dieter Ries <mail@dieterries.net>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100315170054.31593.3153.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kprobes.txt |   10 ++--------
 arch/Kconfig              |    9 ++-------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 2f9115c..61c291c 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -165,8 +165,8 @@ the user entry_handler invocation is also skipped.
 
 1.4 How Does Jump Optimization Work?
 
-If you configured your kernel with CONFIG_OPTPROBES=y (currently
-this option is supported on x86/x86-64, non-preemptive kernel) and
+If your kernel is built with CONFIG_OPTPROBES=y (currently this flag
+is automatically set 'y' on x86/x86-64, non-preemptive kernel) and
 the "debug.kprobes_optimization" kernel parameter is set to 1 (see
 sysctl(8)), Kprobes tries to reduce probe-hit overhead by using a jump
 instruction instead of a breakpoint instruction at each probepoint.
@@ -271,8 +271,6 @@ tweak the kernel's execution path, you need to suppress optimization,
 using one of the following techniques:
 - Specify an empty function for the kprobe's post_handler or break_handler.
  or
-- Config CONFIG_OPTPROBES=n.
- or
 - Execute 'sysctl -w debug.kprobes_optimization=n'
 
 2. Architectures Supported
@@ -307,10 +305,6 @@ it useful to "Compile the kernel with debug info" (CONFIG_DEBUG_INFO),
 so you can use "objdump -d -l vmlinux" to see the source-to-object
 code mapping.
 
-If you want to reduce probing overhead, set "Kprobes jump optimization
-support" (CONFIG_OPTPROBES) to "y". You can find this option under the
-"Kprobes" line.
-
 4. API Reference
 
 The Kprobes API includes a "register" function and an "unregister"
diff --git a/arch/Kconfig b/arch/Kconfig
index e5eb133..f06010f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -42,15 +42,10 @@ config KPROBES
 	  If in doubt, say "N".
 
 config OPTPROBES
-	bool "Kprobes jump optimization support (EXPERIMENTAL)"
-	default y
-	depends on KPROBES
+	def_bool y
+	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
-	depends on HAVE_OPTPROBES
 	select KALLSYMS_ALL
-	help
-	  This option will allow kprobes to optimize breakpoint to
-	  a jump for reducing its overhead.
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
