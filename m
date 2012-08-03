Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2HCOB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:01:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48828 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2HCOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:01:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/18] perf session: Remove no longer used synthesize_sample method
Date: Fri,  3 Aug 2012 11:01:02 -0300
Message-Id: <1344002470-5965-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jd8tqbx8o8bs4t4g50vyhoc2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    8 --------
 tools/perf/util/session.h |    4 ----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7d07324..2437fb0 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -16,14 +16,6 @@
 #include "cpumap.h"
 #include "event-parse.h"
 
-int perf_session__synthesize_sample(struct perf_session *session,
-				    union perf_event *event,
-				    const struct perf_sample *sample)
-{
-	return perf_event__synthesize_sample(event, perf_evlist__sample_type(session->evlist),
-					     sample, session->header.needs_swap);
-}
-
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7389fb1..1f7ec87 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -126,10 +126,6 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self,
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp);
 
-int perf_session__synthesize_sample(struct perf_session *session,
-				    union perf_event *event,
-				    const struct perf_sample *sample);
-
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-- 
1.7.1

