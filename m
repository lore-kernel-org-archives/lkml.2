Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2FTQ5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:57:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab2FTQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:57:39 -0400
Date: Wed, 20 Jun 2012 09:57:20 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ml7zbenjmri9bghmrea0jm0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don't access evsel->name directly
Git-Commit-ID: 22c8b84320ecf9ecbb6587d46a259b828e9ece5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:57:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22c8b84320ecf9ecbb6587d46a259b828e9ece5e
Gitweb:     http://git.kernel.org/tip/22c8b84320ecf9ecbb6587d46a259b828e9ece5e
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 12 Jun 2012 13:55:13 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:21 -0300

perf tools: Don't access evsel->name directly

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
