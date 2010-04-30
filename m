Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258Ab0D3THb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:07:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab0D3RBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:01:06 -0400
Date: Fri, 30 Apr 2010 08:47:02 GMT
From: tip-bot for Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, chase.douglas@canonical.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, chase.douglas@canonical.com
In-Reply-To: <1272045759-32018-1-git-send-email-chase.douglas@canonical.com>
References: <1272045759-32018-1-git-send-email-chase.douglas@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Add documentation for trace commands mod, traceon/traceoff
Message-ID: <tip-07271aa42d13378e67ebd79ea9ca1c4a5e2ad46f@git.kernel.org>
Git-Commit-ID: 07271aa42d13378e67ebd79ea9ca1c4a5e2ad46f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 08:47:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07271aa42d13378e67ebd79ea9ca1c4a5e2ad46f
Gitweb:     http://git.kernel.org/tip/07271aa42d13378e67ebd79ea9ca1c4a5e2ad46f
Author:     Chase Douglas <chase.douglas@canonical.com>
AuthorDate: Fri, 23 Apr 2010 14:02:39 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 27 Apr 2010 16:51:49 -0400

tracing: Add documentation for trace commands mod, traceon/traceoff

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
 
