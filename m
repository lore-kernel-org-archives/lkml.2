Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0JVB60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:58:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:50561 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab0JVB5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:57:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/7] perf probe: Function style fix
Date: Thu, 21 Oct 2010 23:57:02 -0200
Message-Id: <1287712624-27540-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1287712624-27540-1-git-send-email-acme@infradead.org>
References: <1287712624-27540-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Just change the order of function arguments for ease of read; moving optional
bool flag to the last.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101021101329.3542.51200.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c    |    4 ++--
 tools/perf/util/probe-event.c |    2 +-
 tools/perf/util/probe-event.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 91bb6cf..c777bec 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -305,8 +305,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	if (params.nevents) {
 		ret = add_perf_probe_events(params.events, params.nevents,
-					    params.force_add,
-					    params.max_probe_points);
+					    params.max_probe_points,
+					    params.force_add);
 		if (ret < 0) {
 			pr_err("  Error: Failed to add events. (%d)\n", ret);
 			return ret;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 288ebe8..83192a5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1668,7 +1668,7 @@ struct __event_package {
 };
 
 int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
-			  bool force_add, int max_tevs)
+			  int max_tevs, bool force_add)
 {
 	int i, j, ret;
 	struct __event_package *pkgs;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 727a7fe..83130f6 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -117,7 +117,7 @@ extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
 
 extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
-				 bool force_add, int max_probe_points);
+				 int max_probe_points, bool force_add);
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
-- 
1.6.2.5

