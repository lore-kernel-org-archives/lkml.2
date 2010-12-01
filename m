Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0LASBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:01:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:52311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0LASBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/15] perf stat: Document missing options
Date: Wed,  1 Dec 2010 16:01:04 -0200
Message-Id: <1291226465-26337-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1291168642-11402-12-git-send-email-shawn.bohrer@gmail.com>
Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt |   34 +++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c405bca..c469ba5 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -8,8 +8,8 @@ perf-stat - Run a command and gather performance counter statistics
 SYNOPSIS
 --------
 [verse]
-'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] <command>
-'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] -- <command> [<options>]
+'perf stat' [-e <EVENT> | --event=EVENT] [-a] <command>
+'perf stat' [-e <EVENT> | --event=EVENT] [-a] -- <command> [<options>]
 
 DESCRIPTION
 -----------
@@ -35,21 +35,33 @@ OPTIONS
         child tasks do not inherit counters
 -p::
 --pid=<pid>::
-        stat events on existing pid
+        stat events on existing process id
+
+-t::
+--tid=<tid>::
+        stat events on existing thread id
+
 
 -a::
-        system-wide collection
+--all-cpus::
+        system-wide collection from all CPUs
 
 -c::
-        scale counter values
+--scale::
+	scale/normalize counter values
+
+-r::
+--repeat=<n>::
+	repeat command and print average + stddev (max: 100)
 
 -B::
+--big-num::
         print large numbers with thousands' separators according to locale
 
 -C::
 --cpu=::
-Count only on the list of cpus provided. Multiple CPUs can be provided as a
-comma-sperated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
+Count only on the list of CPUs provided. Multiple CPUs can be provided as a
+comma-separated list with no space: 0,1. Ranges of CPUs are specified with -: 0-2.
 In per-thread mode, this option is ignored. The -a option is still necessary
 to activate system-wide monitoring. Default is to count on all CPUs.
 
@@ -58,6 +70,14 @@ to activate system-wide monitoring. Default is to count on all CPUs.
 Do not aggregate counts across all monitored CPUs in system-wide mode (-a).
 This option is only valid in system-wide mode.
 
+-n::
+--null::
+        null run - don't start any counters
+
+-v::
+--verbose::
+        be more verbose (show counter open errors, etc)
+
 EXAMPLES
 --------
 
-- 
1.6.2.5

