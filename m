Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab2GFLXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:23:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2GFLXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:23:16 -0400
Date: Fri, 6 Jul 2012 04:22:44 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ebf124ffab59e9e1c6179347fe95fe5baf32dcd7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1341352848-11833-10-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-10-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Use ARRAY_SIZE in parse events tests
Git-Commit-ID: ebf124ffab59e9e1c6179347fe95fe5baf32dcd7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:22:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebf124ffab59e9e1c6179347fe95fe5baf32dcd7
Gitweb:     http://git.kernel.org/tip/ebf124ffab59e9e1c6179347fe95fe5baf32dcd7
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 4 Jul 2012 00:00:47 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Jul 2012 11:31:26 -0300

perf test: Use ARRAY_SIZE in parse events tests

Use ARRAY_SIZE instead of defining the sizes separately for each test
arrays.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1341352848-11833-10-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events-test.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index dd0c306..1b997d2 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -634,8 +634,6 @@ static struct test__event_st test__events[] = {
 	},
 };
 
-#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
-
 static struct test__event_st test__events_pmu[] = {
 	[0] = {
 		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
@@ -647,9 +645,6 @@ static struct test__event_st test__events_pmu[] = {
 	},
 };
 
-#define TEST__EVENTS_PMU_CNT (sizeof(test__events_pmu) / \
-			      sizeof(struct test__event_st))
-
 struct test__term {
 	const char *str;
 	__u32 type;
@@ -765,21 +760,17 @@ int parse_events__test(void)
 {
 	int ret;
 
-	do {
-		ret = test_events(test__events, TEST__EVENTS_CNT);
-		if (ret)
-			break;
-
-		if (test_pmu()) {
-			ret = test_events(test__events_pmu,
-					  TEST__EVENTS_PMU_CNT);
-			if (ret)
-				break;
-		}
+#define TEST_EVENTS(tests)				\
+do {							\
+	ret = test_events(tests, ARRAY_SIZE(tests));	\
+	if (ret)					\
+		return ret;				\
+} while (0)
 
-		ret = test_terms(test__terms, TEST__TERMS_CNT);
+	TEST_EVENTS(test__events);
 
-	} while (0);
+	if (test_pmu())
+		TEST_EVENTS(test__events_pmu);
 
-	return ret;
+	return test_terms(test__terms, ARRAY_SIZE(test__terms));
 }
