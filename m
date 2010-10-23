Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0JWTmM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:42:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:42100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758292Ab0JWTmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:42:10 -0400
Date: Sat, 23 Oct 2010 19:41:40 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101021101329.3542.51200.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101329.3542.51200.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Function style fix
Message-ID: <tip-c82ec0a2bd7725a2d2ac3065d8cde13e1f717d3c@git.kernel.org>
Git-Commit-ID: c82ec0a2bd7725a2d2ac3065d8cde13e1f717d3c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 19:41:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c82ec0a2bd7725a2d2ac3065d8cde13e1f717d3c
Gitweb:     http://git.kernel.org/tip/c82ec0a2bd7725a2d2ac3065d8cde13e1f717d3c
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 21 Oct 2010 19:13:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Oct 2010 16:00:42 -0200

perf probe: Function style fix

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
