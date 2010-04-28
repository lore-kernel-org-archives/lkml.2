Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab0D1Biq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:38:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab0D1BiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:09 -0400
X-Authority-Analysis: v=1.1 cv=2/WNtoURsBD4grC4Rqfj62/w1mAETqRJkFX1sgq41IM= c=1 sm=0 a=TU592cpDSk8A:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=DfNHnWVPAAAA:8 a=meVymXHHAAAA:8 a=JRR6_YSBfnic31WGZdgA:9 a=MoLAZqSmqW0N1pnzkOkA:7 a=H8n1ywaWgTQ7Y50O3jL-88Nst-QA:4 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428013806.994023607@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH 6/8] tracing: Add documentation for trace commands mod, traceon/traceoff
References: <20100428012723.119106602@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Add-documentation-for-trace-commands-mod-tra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@canonical.com>

The mod command went in as commit
64e7c440618998fd69eee6ab490b042d12248021

The traceon/traceoff commands went in as commit
23b4ff3aa479c9e3bb23cb6b2d0a97878399784a

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
LKML-Reference: <1272045759-32018-1-git-send-email-chase.douglas@canonical.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |   44 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 5201181..557c1ed 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -155,6 +155,9 @@ of ftrace. Here is a list of some of the key files:
 	to be traced. Echoing names of functions into this file
 	will limit the trace to only those functions.
 
+	This interface also allows for commands to be used. See the
+	"Filter commands" section for more details.
+
   set_ftrace_notrace:
 
 	This has an effect opposite to that of
@@ -1824,6 +1827,47 @@ this special filter via:
  echo > set_graph_function
 
 
+Filter commands
+---------------
+
+A few commands are supported by the set_ftrace_filter interface.
+Trace commands have the following format:
+
+<function>:<command>:<parameter>
+
+The following commands are supported:
+
+- mod
+  This command enables function filtering per module. The
+  parameter defines the module. For example, if only the write*
+  functions in the ext3 module are desired, run:
+
+   echo 'write*:mod:ext3' > set_ftrace_filter
+
+  This command interacts with the filter in the same way as
+  filtering based on function names. Thus, adding more functions
+  in a different module is accomplished by appending (>>) to the
+  filter file. Remove specific module functions by prepending
+  '!':
+
+   echo '!writeback*:mod:ext3' >> set_ftrace_filter
+
+- traceon/traceoff
+  These commands turn tracing on and off when the specified
+  functions are hit. The parameter determines how many times the
+  tracing system is turned on and off. If unspecified, there is
+  no limit. For example, to disable tracing when a schedule bug
+  is hit the first 5 times, run:
+
+   echo '__schedule_bug:traceoff:5' > set_ftrace_filter
+
+  These commands are cumulative whether or not they are appended
+  to set_ftrace_filter. To remove a command, prepend it by '!'
+  and drop the parameter:
+
+   echo '!__schedule_bug:traceoff' > set_ftrace_filter
+
+
 trace_pipe
 ----------
 
-- 
1.7.0


