Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0LBLqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:46:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:53704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0LBLqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:46:00 -0500
Date: Thu, 2 Dec 2010 11:45:39 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-10-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-10-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Document missing options
Message-ID: <tip-e04fffc321aeebab4962cfc120952272f2d1df98@git.kernel.org>
Git-Commit-ID: e04fffc321aeebab4962cfc120952272f2d1df98
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:45:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e04fffc321aeebab4962cfc120952272f2d1df98
Gitweb:     http://git.kernel.org/tip/e04fffc321aeebab4962cfc120952272f2d1df98
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:17 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:47 -0200

perf report: Document missing options

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
