Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2GEPpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:59137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030232Ab2GEPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/20] perf test: Use ARRAY_SIZE in parse events tests
Date: Thu,  5 Jul 2012 12:45:15 -0300
Message-Id: <1341503118-13198-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
 1 file changed, 10 insertions(+), 19 deletions(-)

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
-- 
1.7.9.2.358.g22243

