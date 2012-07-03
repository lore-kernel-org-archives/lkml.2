Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab2GCWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319Ab2GCWBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:23 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/10] perf, test: Use ARRAY_SIZE in parse events tests
Date: Wed,  4 Jul 2012 00:00:47 +0200
Message-Id: <1341352848-11833-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
References: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ARRAY_SIZE instead of defining the sizes separately for
each test arrays.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events-test.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index a0f61a2..ef5cce0 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -587,8 +587,6 @@ static struct test__event_st test__events[] = {
 	},
 };
 
-#define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
-
 static struct test__event_st test__events_pmu[] = {
 	[0] = {
 		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
@@ -600,9 +598,6 @@ static struct test__event_st test__events_pmu[] = {
 	},
 };
 
-#define TEST__EVENTS_PMU_CNT (sizeof(test__events_pmu) / \
-			      sizeof(struct test__event_st))
-
 struct test__term {
 	const char *str;
 	__u32 type;
@@ -718,21 +713,17 @@ int parse_events__test(void)
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
1.7.10.4

