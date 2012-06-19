Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2FSSDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:03:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/20] perf tools: Don't access evsel->name directly
Date: Tue, 19 Jun 2012 14:50:16 -0300
Message-Id: <1340128221-17348-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

One needs to use perf_evsel__name() so that if needed the name gets
synthesized and stored in evsel->name, from where perf_evsel__name()
will serve from them on.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ml7zbenjmri9bghmrea0jm0d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c          |    2 +-
 tools/perf/util/parse-events-test.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b125e07..9fe77b1 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1601,7 +1601,7 @@ static int perf_sched__process_tracepoint_sample(struct perf_tool *tool,
 
 	if (thread == NULL) {
 		pr_debug("problem processing %s event, skipping it.\n",
-			 evsel->name);
+			 perf_evsel__name(evsel));
 		return -1;
 	}
 
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 76b98e2..d0cf7c1 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -418,14 +418,14 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "krava"));
+	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "krava"));
 
 	/* cpu/config=2/" */
 	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name", !strcmp(evsel->name, "raw 0x2"));
+	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "raw 0x2"));
 
 	return 0;
 }
-- 
1.7.1

