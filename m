Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab0DWQRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:17:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55022 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0DWQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:17:51 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Add documentation for trace commands mod, traceon/traceoff
Date: Fri, 23 Apr 2010 12:17:47 -0400
Message-Id: <1272039467-27413-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mod command went in as commit
64e7c440618998fd69eee6ab490b042d12248021

The traceon/traceoff commands when in as commit
23b4ff3aa479c9e3bb23cb6b2d0a97878399784a

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 Documentation/trace/ftrace.txt |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 03485bf..64e08d5 100644
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
@@ -1822,6 +1825,38 @@ this special filter via:
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
+  functions in the ext3 module are useful in a trace, echo
+  'write*:mod:ext3' > set_ftrace_filter. This command interacts
+  with the filter in the same way as filtering based on function
+  names. Thus, adding more functions in a different module is
+  accomplished by appending (>>) to the filter file. Remove
+  specific module functions by prepending '!'
+  (!writeback*:mod:ext3).
+
+- traceon/traceoff
+  These commands turn tracing on and off when the specified
+  functions are hit. The parameter determines how many times the
+  tracing system is turned on and off. If unspecified, there is
+  no limit. For example, to disable tracing when a schedule bug
+  is hit the first 5 times, use '__schedule_bug:traceoff:5'.
+  These commands are cumulative whether or not they are appended
+  to set_ftrace_filter. To remove a command, prepend it by '!'
+  and drop the parameter (!__schedule_bug:traceoff).
+
+
 trace_pipe
 ----------
 
-- 
1.7.0

