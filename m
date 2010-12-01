Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab0LASCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:02:30 -0500
Received: from canuck.infradead.org ([134.117.69.58]:58874 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab0LASBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/15] perf report: Document missing options
Date: Wed,  1 Dec 2010 16:00:59 -0200
Message-Id: <1291226465-26337-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-10-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-report.txt |   49 +++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 12052c9..59a1f57 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -20,6 +20,11 @@ OPTIONS
 -i::
 --input=::
         Input file name. (default: perf.data)
+
+-v::
+--verbose::
+        Be more verbose. (show symbol address, etc)
+
 -d::
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
@@ -27,6 +32,10 @@ OPTIONS
 -n::
 --show-nr-samples::
 	Show the number of samples for each symbol
+
+--showcpuutilization::
+        Show sample percentage for different cpu modes.
+
 -T::
 --threads::
 	Show per-thread event counters
@@ -39,12 +48,24 @@ OPTIONS
 	Only consider these symbols. CSV that understands
 	file://filename entries.
 
+-U::
+--hide-unresolved::
+        Only display entries resolved to a symbol.
+
 -s::
 --sort=::
 	Sort by key(s): pid, comm, dso, symbol, parent.
 
+-p::
+--parent=<regex>::
+        regex filter to identify parent, see: '--sort parent'
+
+-x::
+--exclude-other::
+        Only display entries with parent-match.
+
 -w::
---field-width=::
+--column-widths=<width[,width...]>::
 	Force each column width to the provided list, for large terminal
 	readability.
 
@@ -52,19 +73,26 @@ OPTIONS
 --field-separator=::
 
 	Use a special separator character and don't pad with spaces, replacing
-	all occurances of this separator in symbol names (and other output)
+	all occurrences of this separator in symbol names (and other output)
 	with a '.' character, that thus it's the only non valid separator.
 
+-D::
+--dump-raw-trace::
+        Dump raw trace in ASCII.
+
 -g [type,min]::
 --call-graph::
-        Display callchains using type and min percent threshold.
+        Display call chains using type and min percent threshold.
 	type can be either:
-	- flat: single column, linear exposure of callchains.
+	- flat: single column, linear exposure of call chains.
 	- graph: use a graph tree, displaying absolute overhead rates.
 	- fractal: like graph, but displays relative rates. Each branch of
 		 the tree is considered as a new profiled object. +
 	Default: fractal,0.5.
 
+--pretty=<key>::
+        Pretty printing style.  key: normal, raw
+
 --stdio:: Use the stdio interface.
 
 --tui:: Use the TUI interface, that is integrated with annotate and allows
@@ -72,6 +100,19 @@ OPTIONS
 	requires a tty, if one is not present, as when piping to other
 	commands, the stdio interface is used.
 
+-k::
+--vmlinux=<file>::
+        vmlinux pathname
+
+-m::
+--modules::
+        Load module symbols. WARNING: This should only be used with -k and
+        a LIVE kernel.
+
+-f::
+--force::
+        Don't complain, do it.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1]
-- 
1.6.2.5

