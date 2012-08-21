Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2HUSDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:03:47 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:15696
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758257Ab2HUSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:03:43 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah11b5h1155h)
X-WSS-ID: 0M94A60-02-IPR-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 1/2] perf test: Update event names in test cases
Date: Tue, 21 Aug 2012 20:03:14 +0200
Message-ID: <1345572195-23857-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20120820174247.GD1176@krava.brq.redhat.com>
References: <20120820174247.GD1176@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Event names are now generated from the command line specification.
Update event names in test cases accordingly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/parse-events-test.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index bf055ce..74be1bf 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -301,12 +301,13 @@ static int test__checkevent_breakpoint_modifier(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
+
 	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
 	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0x0:rw:u"));
+			!strcmp(perf_evsel__name(evsel), "mem:0:u"));
 
 	return test__checkevent_breakpoint(evlist);
 }
@@ -320,7 +321,7 @@ static int test__checkevent_breakpoint_x_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0x0:x:k"));
+			!strcmp(perf_evsel__name(evsel), "mem:0:x:k"));
 
 	return test__checkevent_breakpoint_x(evlist);
 }
@@ -334,7 +335,7 @@ static int test__checkevent_breakpoint_r_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0x0:r:hp"));
+			!strcmp(perf_evsel__name(evsel), "mem:0:r:hp"));
 
 	return test__checkevent_breakpoint_r(evlist);
 }
@@ -348,7 +349,7 @@ static int test__checkevent_breakpoint_w_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0x0:w:up"));
+			!strcmp(perf_evsel__name(evsel), "mem:0:w:up"));
 
 	return test__checkevent_breakpoint_w(evlist);
 }
@@ -362,7 +363,7 @@ static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "mem:0x0:rw:kp"));
+			!strcmp(perf_evsel__name(evsel), "mem:0:rw:kp"));
 
 	return test__checkevent_breakpoint_rw(evlist);
 }
@@ -437,7 +438,7 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong name",
-			!strcmp(perf_evsel__name(evsel), "raw 0x2:u"));
+			!strcmp(perf_evsel__name(evsel), "cpu/config=2/u"));
 
 	return 0;
 }
-- 
1.7.8.6


