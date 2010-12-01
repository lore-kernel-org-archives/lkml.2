Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0LAB6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56724 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab0LAB6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OHuAy/hdrP0RPr9TcyrNdDsxH16ueDLINbQn4gvF6+QqCBxHnsXcFzk/dS9kvWVPz0
         bmNH87zkKvol/HwigpCSDXSmBp6v0L69Iv1KNhhxhaOPK2wp0HGKo1mJiglqdB3+i+IW
         Or9I0/rUPQtXXKXlBaZmMs+TyJaZsKgVCLLRI=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 09/14] perf: Document missing report options
Date: Tue, 30 Nov 2010 19:57:17 -0600
Message-Id: <1291168642-11402-10-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
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
1.7.3.2

