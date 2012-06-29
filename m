Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2F2QRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:17:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2F2QQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:16:59 -0400
Date: Fri, 29 Jun 2012 09:16:38 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-7a25b2d32b9cb0b813d56ee6109acf90f3c9f1e5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1340274316-5161-1-git-send-email-jolsa@redhat.com>
References: <1340274316-5161-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Fix parse events test to follow proper raw event name
Git-Commit-ID: 7a25b2d32b9cb0b813d56ee6109acf90f3c9f1e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 29 Jun 2012 09:16:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a25b2d32b9cb0b813d56ee6109acf90f3c9f1e5
Gitweb:     http://git.kernel.org/tip/7a25b2d32b9cb0b813d56ee6109acf90f3c9f1e5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 21 Jun 2012 12:25:16 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Jun 2012 14:55:24 -0300

perf test: Fix parse events test to follow proper raw event name

Following commit changed raw event names to carry event modificator.

  perf evsel: Reconstruct raw event with modifiers from perf_event_attr
  commit 6eef3d9c2bcf52b7a3c18e609f5838c007b989a4
  Author: Arnaldo Carvalho de Melo <acme@redhat.com>

The perf_evsel__name function now returns ':mod' suffix for raw events,
so we need to follow that in current tests.

All tests pass now for 'perf test parse' suite.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1340274316-5161-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events-test.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 229af6d..a0f61a2 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -413,19 +413,20 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 
-	/* cpu/config=1,name=krava1/u */
+	/* cpu/config=1,name=krava/u */
 	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  1 == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "krava"));
 
-	/* cpu/config=2/" */
+	/* cpu/config=2/u" */
 	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
-	TEST_ASSERT_VAL("wrong name", !strcmp(perf_evsel__name(evsel), "raw 0x2"));
+	TEST_ASSERT_VAL("wrong name",
+			!strcmp(perf_evsel__name(evsel), "raw 0x2:u"));
 
 	return 0;
 }
