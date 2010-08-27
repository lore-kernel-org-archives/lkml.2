Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0H0OPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:15:25 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54060 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0H0OPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:15:22 -0400
Date: Fri, 27 Aug 2010 19:40:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: [PATCHv11a 2.6.36-rc2-tip 10/15] 10: tracing: config option to
 enable both kprobe-tracer and uprobe-tracer.
Message-ID: <20100827141011.GD5444@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
 <20100825134315.5447.96501.sendpatchset@localhost6.localdomain6>
 <4C76038A.40400@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4C76038A.40400@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting CONFIG_PROBE_EVENTS enables both kprobe-based and
uprobes-based dynamic events. However kprobe-tracer or uprobe-tracer
can still be individually selected or disabled.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
---

Changelog from V10: Fixed few erroneous changes: missing s at eol.
	reported by Masami Hiramatsu.
 
 kernel/trace/Kconfig |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 55ba474..77e04b0 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -351,9 +351,8 @@ config BLK_DEV_IO_TRACE
 config KPROBE_EVENT
 	depends on KPROBES
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
+	depends on PROBE_EVENTS
 	bool "Enable kprobes-based dynamic events"
-	select TRACING
-	select PROBE_EVENTS
 	default y
 	help
 	  This allows the user to add tracing events (similar to tracepoints)
@@ -370,10 +369,9 @@ config UPROBE_EVENT
 	bool "Enable uprobes-based dynamic events"
 	depends on ARCH_SUPPORTS_UPROBES
 	depends on MMU
+	depends on PROBE_EVENTS
 	select UPROBES
-	select PROBE_EVENTS
-	select TRACING
-	default n
+	default y
 	help
 	  This allows the user to add tracing events on top of userspace dynamic
 	  events (similar to tracepoints) on the fly via the traceevents interface.
@@ -383,7 +381,18 @@ config UPROBE_EVENT
 	  tools on user space applications.
 
 config PROBE_EVENTS
-	def_bool n
+	bool "Enable kprobes and uprobe based dynamic events"
+	select TRACING
+	default n
+	help
+	  This allows a user to add dynamic tracing events in
+	  kernel using kprobe-tracer and in userspace using
+	  uprobe-tracer. However users can still selectively
+	  disable one of these events.
+
+	  For more information on kprobe-tracer and uprobe-tracer
+	  please refer help under KPROBE_EVENT and UPROBE_EVENT
+	  respectively.
 
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
