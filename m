Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab1ADUob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:44:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:63402 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1ADUoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:44:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,274,1291622400"; 
   d="scan'208";a="693537687"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tom.zanussi@intel.com>
Subject: [PATCH 2/3] trace-cmd: move trace-usage to lib objects
Date: Tue,  4 Jan 2011 12:43:39 -0800
Message-Id: <1294173820-7043-3-git-send-email-dvhart@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294173820-7043-1-git-send-email-dvhart@linux.intel.com>
References: <1294173820-7043-1-git-send-email-dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the usage function available to shared objects, such as the python
ctracecmd.so module built by the SWIG mechanism.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Tom Zanussi <tom.zanussi@intel.com>
---
 Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 41f0d43..74f2c44 100644
--- a/Makefile
+++ b/Makefile
@@ -261,8 +261,7 @@ $(obj)/%.o: $(src)/%.c
 
 TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-hash.o trace-dialog.o \
 		trace-xml.o
-TRACE_CMD_OBJS = trace-cmd.o trace-usage.o trace-read.o trace-split.o trace-listen.o \
-	trace-stack.o
+TRACE_CMD_OBJS = trace-cmd.o trace-read.o trace-split.o trace-listen.o trace-stack.o
 TRACE_VIEW_OBJS = trace-view.o trace-view-store.o
 TRACE_GRAPH_OBJS = trace-graph.o trace-plot.o trace-plot-cpu.o trace-plot-task.o
 TRACE_VIEW_MAIN_OBJS = trace-view-main.o $(TRACE_VIEW_OBJS) $(TRACE_GUI_OBJS)
@@ -272,7 +271,7 @@ KERNEL_SHARK_OBJS = $(TRACE_VIEW_OBJS) $(TRACE_GRAPH_OBJS) $(TRACE_GUI_OBJS) \
 
 PEVENT_LIB_OBJS = parse-events.o trace-seq.o parse-filter.o parse-utils.o
 TCMD_LIB_OBJS = $(PEVENT_LIB_OBJS) trace-util.o trace-input.o trace-ftrace.o \
-			trace-output.o trace-record.o trace-restore.o
+			trace-output.o trace-record.o trace-restore.o trace-usage.o
 
 PLUGIN_OBJS = plugin_hrtimer.o plugin_kmem.o plugin_sched_switch.o \
 	plugin_mac80211.o plugin_jbd2.o plugin_function.o plugin_kvm.o
-- 
1.7.1

