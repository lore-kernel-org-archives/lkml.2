Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0LAB6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:58:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50599 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0LAB6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:58:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fiPOUpQu4FI757eiWOyzJMsAj85IR09BtGkpO79m9qyQd+PWXCbxh7ZO45ioCEZSCx
         phxJl6qrDT93jp9M7XU4EQEMYeNsfgESE1+4u2aswnhYlmdt6Mfh1ieV31KOGmeo7lmp
         367nhARPqVh65cgMhdu6Xgjz5n24/sQ67/dJw=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 11/14] perf: Document missing stat options
Date: Tue, 30 Nov 2010 19:57:19 -0600
Message-Id: <1291168642-11402-12-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 tools/perf/Documentation/perf-stat.txt |   34 +++++++++++++++++++++++++------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 4b3a2d4..aa3133c 100644
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
@@ -33,26 +33,46 @@ OPTIONS
 -i::
 --no-inherit::
         child tasks do not inherit counters
+
 -p::
 --pid=<pid>::
-        stat events on existing pid
+        stat events on existing process id
+
+-t::
+--tid=<tid>::
+        stat events on existing thread id
 
 -a::
-        system-wide collection
+--all-cpus::
+        system-wide collection from all CPUs
 
 -c::
-        scale counter values
+--scale::
+        scale/normalize counter values
+
+-r::
+--repeat=<n>::
+        repeat command and print average + stddev (max: 100)
 
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
1.7.3.2

