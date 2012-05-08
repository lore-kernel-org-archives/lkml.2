Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2EHMvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:51:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55245 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2EHMvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:51:15 -0400
Date: Tue, 8 May 2012 05:49:27 -0700
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-ec83db0f78cd44c3b586ec1c3a348d1a8a389797@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, hch@infradead.org, anton@redhat.com,
        ananth@in.ibm.com, masami.hiramatsu.pt@hitachi.com, acme@infradead.org,
        rostedt@goodmis.org, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, hch@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        acme@infradead.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
References: <20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/uprobes] tracing: Fix kconfig warning due to a typo
Git-Commit-ID: ec83db0f78cd44c3b586ec1c3a348d1a8a389797
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:49:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec83db0f78cd44c3b586ec1c3a348d1a8a389797
Gitweb:     http://git.kernel.org/tip/ec83db0f78cd44c3b586ec1c3a348d1a8a389797
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Tue, 8 May 2012 16:41:26 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 8 May 2012 14:17:25 +0200

tracing: Fix kconfig warning due to a typo

Commit f3f096cfe ("tracing: Provide trace events interface for
uprobes") throws a warning about unmet dependencies.

The exact warning message is:
	warning: (UPROBE_EVENT) selects UPROBES which has unmet direct dependencies (UPROBE_EVENTS && PERF_EVENTS)

This is due to a typo in arch/Kconfig file. Fix similar typos in
the uprobetracer documentation.

Also add sample format of a uprobe event in the uprobetracer
documentation as suggested by Masami Hiramatsu.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120508111126.21004.38285.sendpatchset@srdronam.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/trace/uprobetracer.txt |   22 ++++++++++++++++++++--
 arch/Kconfig                         |    2 +-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index eae40a0..24ce682 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -5,7 +5,7 @@
 Overview
 --------
 Uprobe based trace events are similar to kprobe based trace events.
-To enable this feature, build your kernel with CONFIG_UPROBE_EVENTS=y.
+To enable this feature, build your kernel with CONFIG_UPROBE_EVENT=y.
 
 Similar to the kprobe-event tracer, this doesn't need to be activated via
 current_tracer. Instead of that, add probe points via
@@ -68,7 +68,25 @@ in the object. We can see the events that are registered by looking at the
 uprobe_events file.
 
     # cat uprobe_events
-    p:uprobes/p_zsh_0x46420 /bin/zsh:0x0000000000046420
+    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
+
+The format of events can be seen by viewing the file events/uprobes/p_zsh_0x46420/format
+
+    # cat events/uprobes/p_zsh_0x46420/format
+    name: p_zsh_0x46420
+    ID: 922
+    format:
+	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
+	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
+	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
+	field:int common_pid;	offset:4;	size:4;	signed:1;
+	field:int common_padding;	offset:8;	size:4;	signed:1;
+
+	field:unsigned long __probe_ip;	offset:12;	size:4;	signed:0;
+	field:u32 arg1;	offset:16;	size:4;	signed:0;
+	field:u32 arg2;	offset:20;	size:4;	signed:0;
+
+    print fmt: "(%lx) arg1=%lx arg2=%lx", REC->__probe_ip, REC->arg1, REC->arg2
 
 Right after definition, each event is disabled by default. For tracing these
 events, you need to enable it by:
diff --git a/arch/Kconfig b/arch/Kconfig
index 0f8f968..2880abf 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -78,7 +78,7 @@ config OPTPROBES
 
 config UPROBES
 	bool "Transparent user-space probes (EXPERIMENTAL)"
-	depends on UPROBE_EVENTS && PERF_EVENTS
+	depends on UPROBE_EVENT && PERF_EVENTS
 	default n
 	help
 	  Uprobes is the user-space counterpart to kprobes: they
