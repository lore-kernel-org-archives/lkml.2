Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2K1Nzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:55:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240Ab2K1Nzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:55:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 10/14] perf tool: Centralize default columns init in perf_hpp__init
Date: Wed, 28 Nov 2012 14:52:45 +0100
Message-Id: <1354110769-2998-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when diff command is separated from other standard outputs,
we can use perf_hpp__init to initialize all standard columns.

Moving PERF_HPP__OVERHEAD column init back to perf_hpp__init,
and removing extra enable calls.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    | 1 -
 tools/perf/ui/browsers/hists.c | 2 --
 tools/perf/ui/gtk/browser.c    | 2 --
 tools/perf/ui/hist.c           | 2 ++
 tools/perf/ui/setup.c          | 1 -
 5 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5134acf..fc25100 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -692,7 +692,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		setup_browser(true);
 	else {
 		use_browser = 0;
-		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 		perf_hpp__init();
 	}
 
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 4e06ba5..9463280 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -589,8 +589,6 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void hist_browser__init_hpp(void)
 {
-	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
-
 	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index c4aac7b..489a053 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -74,8 +74,6 @@ HPP__COLOR_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
-
 	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index a004f57..bec5299 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -253,6 +253,8 @@ LIST_HEAD(perf_hpp__list);
 
 void perf_hpp__init(void)
 {
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
+
 	if (symbol_conf.show_cpu_utilization) {
 		perf_hpp__column_enable(PERF_HPP__OVERHEAD_SYS);
 		perf_hpp__column_enable(PERF_HPP__OVERHEAD_US);
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 166f13d..ebb4cc1 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -30,7 +30,6 @@ void setup_browser(bool fallback_to_pager)
 		if (fallback_to_pager)
 			setup_pager();
 
-		perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 		perf_hpp__init();
 		break;
 	}
-- 
1.7.11.7

