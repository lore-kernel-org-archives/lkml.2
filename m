Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965465Ab0COQyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:54:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965416Ab0COQyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:54:43 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3] kprobes: Hide CONFIG_OPTPROBES and set if arch
	support optimized kprobes
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Dieter Ries <mail@dieterries.net>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 15 Mar 2010 13:00:54 -0400
Message-ID: <20100315170054.31593.3153.stgit@localhost6.localdomain6>
In-Reply-To: <20100313072738.GB4892@elte.hu>
References: <20100313072738.GB4892@elte.hu>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide CONFIG_OPTPROBES and set if the arch supports optimized kprobes
(IOW, HAVE_OPTPROBES=y), since this option doesn't change the major
behavior of kprobes, and workarounds for minor changes are documented.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Dieter Ries <mail@dieterries.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
