Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0LBLrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:47:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:32773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429Ab0LBLrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:47:52 -0500
Date: Thu, 2 Dec 2010 11:47:23 GMT
From: tip-bot for Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        shawn.bohrer@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1291168642-11402-12-git-send-email-shawn.bohrer@gmail.com>
References: <1291168642-11402-12-git-send-email-shawn.bohrer@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Document missing options
Message-ID: <tip-8c207692fc8fa3ea1a5ff97ad698efb09a81975a@git.kernel.org>
Git-Commit-ID: 8c207692fc8fa3ea1a5ff97ad698efb09a81975a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Dec 2010 11:47:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c207692fc8fa3ea1a5ff97ad698efb09a81975a
Gitweb:     http://git.kernel.org/tip/8c207692fc8fa3ea1a5ff97ad698efb09a81975a
Author:     Shawn Bohrer <shawn.bohrer@gmail.com>
AuthorDate: Tue, 30 Nov 2010 19:57:19 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Dec 2010 18:22:49 -0200

perf stat: Document missing options

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
 
