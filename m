Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2LLQch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:32:37 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:32832
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272Ab2LLQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:31:17 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MEXF80-02-CDL-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 5/5] perf tools: Add breakpoint address mask test case to tests/parse-events
Date: Wed, 12 Dec 2012 10:30:43 -0600
Message-ID: <1355329843-25842-6-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
References: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 tools/perf/tests/parse-events.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 32ee478..394e16c 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -369,6 +369,32 @@ static int test__checkevent_breakpoint_rw_modifier(struct perf_evlist *evlist)
 	return test__checkevent_breakpoint_rw(evlist);
 }
 
+static int test__checkevent_breakpoint_rw_addrmsk(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong bp_addr_mask",
+			0 == evsel->attr.bp_addr_mask);
+
+	return test__checkevent_breakpoint_rw(evlist);
+}
+
+static int test__checkevent_breakpoint_x_addrmsk_modifier(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
+
+	TEST_ASSERT_VAL("wrong exclude_user", evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "mem:0:x:0:k"));
+	TEST_ASSERT_VAL("wrong bp_addr_mask",
+			0 == evsel->attr.bp_addr_mask);
+
+	return test__checkevent_breakpoint_x(evlist);
+}
+
 static int test__checkevent_pmu(struct perf_evlist *evlist)
 {
 
@@ -921,6 +947,14 @@ static struct test__event_st test__events[] = {
 		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
 		.check = test__group5,
 	},
+	[33] = {
+		.name  = "mem:0:rw:0",
+		.check = test__checkevent_breakpoint_rw_addrmsk,
+	},
+	[34] = {
+		.name  = "mem:0:x:0:k",
+		.check = test__checkevent_breakpoint_x_addrmsk_modifier,
+	},
 };
 
 static struct test__event_st test__events_pmu[] = {
-- 
1.7.9.5


