Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2JVQbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:31:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:56260 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2JVQbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:31:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf test: Fix exclude_guest parse events tests
Date: Mon, 22 Oct 2012 14:30:25 -0200
Message-Id: <1350923425-15400-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350923425-15400-1-git-send-email-acme@infradead.org>
References: <1350923425-15400-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Event parsing tests are broken by following commit:

  perf tool: Precise mode requires exclude_guest
  commit 1342798cc13e3b48d9b5738f0c8fa812ccea8101
  Author: David Ahern <dsahern@gmail.com>
  Date:   Thu Sep 13 14:59:13 2012 -0600

which enables 'exclude_guest' modifier any time the 'precise'
modifier is detected.

Fixing related tests and adding special comment.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events-test.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 28c18d1..516ecd9 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -513,7 +513,8 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
@@ -599,7 +600,8 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
@@ -662,7 +664,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
@@ -676,7 +679,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
-	TEST_ASSERT_VAL("wrong exclude guest", !evsel->attr.exclude_guest);
+	/* use of precise requires exclude_guest */
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
-- 
1.7.1

