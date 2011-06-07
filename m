Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1FGNJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:09:56 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:44588 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1FGNJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:09:54 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 07 Jun 2011 18:32:41 +0530
Message-Id: <20110607130241.28590.87063.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v4 3.0-rc2-tip 22/22] 22: perf: Documentation for perf uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modify perf-probe.txt to include uprobe documentation

Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 tools/perf/Documentation/perf-probe.txt |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 02bafce..3db8d25 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -76,6 +76,8 @@ OPTIONS
 -F::
 --funcs::
 	Show available functions in given module or kernel.
+	With -x/--exe, can also list functions in a user space executable /
+	shared library.
 
 --filter=FILTER::
 	(Only for --vars and --funcs) Set filter. FILTER is a combination of glob
@@ -96,12 +98,21 @@ OPTIONS
 --max-probes::
 	Set the maximum number of probe points for an event. Default is 128.
 
+-u::
+--uprobes::
+	Specify a uprobe based probe point.
+
+-x::
+--exe=PATH::
+	Specify path to the executable or shared library file for user
+	space tracing. Used with --funcs option only.
+
 PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
 
     1) Define event based on function name
-     [EVENT=]FUNC[@SRC][:RLN|+OFFS|%return|;PTN] [ARG ...]
+     [EVENT=]FUNC[@EXE][@SRC][:RLN|+OFFS|%return|;PTN] [ARG ...]
 
     2) Define event based on source file with line number
      [EVENT=]SRC:ALN [ARG ...]
@@ -112,6 +123,7 @@ Probe points are defined by following syntax.
 
 'EVENT' specifies the name of new event, if omitted, it will be set the name of the probed function. Currently, event group name is set as 'probe'.
 'FUNC' specifies a probed function name, and it may have one of the following options; '+OFFS' is the offset from function entry address in bytes, ':RLN' is the relative-line number from function entry line, and '%return' means that it probes function return. And ';PTN' means lazy matching pattern (see LAZY MATCHING). Note that ';PTN' must be the end of the probe point definition.  In addition, '@SRC' specifies a source file which has that function.
+'EXE' specifies the absolute or relative path of the user space executable or user space shared library.
 It is also possible to specify a probe point by the source line number or lazy matching by using 'SRC:ALN' or 'SRC;PTN' syntax, where 'SRC' is the source file path, ':ALN' is the line number and ';PTN' is the lazy matching pattern.
 'ARG' specifies the arguments of this probe point, (see PROBE ARGUMENT).
 
@@ -180,6 +192,13 @@ Delete all probes on schedule().
 
  ./perf probe --del='schedule*'
 
+Add probes at zfree() function on /bin/zsh
+
+ ./perf probe -u zfree@/bin/zsh
+
+Add probes at malloc() function on libc
+
+ ./perf probe -u malloc@/lib/libc.so.6
 
 SEE ALSO
 --------
