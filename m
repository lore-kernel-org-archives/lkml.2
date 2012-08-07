Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2HGM47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 08:56:59 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14211 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab2HGM4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 08:56:09 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 2/4] perf: synthesize_sample gets evsel instead of session
Date: Tue,  7 Aug 2012 16:56:03 +0400
Message-Id: <1344344165-369636-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344344165-369636-1-git-send-email-avagin@openvz.org>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same thing was done for perf_evsel__parse_sample

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/util/event.h |    4 ----
 tools/perf/util/evsel.c |    4 +++-
 tools/perf/util/evsel.h |    5 +++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index d84870b..1ab3141 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -197,10 +197,6 @@ int perf_event__preprocess_sample(const union perf_event *self,
 
 const char *perf_event__name(unsigned int id);
 
-int perf_event__synthesize_sample(union perf_event *event, u64 type,
-				  const struct perf_sample *sample,
-				  bool swapped);
-
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2eaae14..7547203 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -872,10 +872,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	return 0;
 }
 
-int perf_event__synthesize_sample(union perf_event *event, u64 type,
+int perf_evsel__synthesize_sample(struct perf_evsel *evsel,
+				  union perf_event *event,
 				  const struct perf_sample *sample,
 				  bool swapped)
 {
+	u64 type = evsel->attr.sample_type;
 	u64 *array;
 
 	/*
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a56c457..62cdd5d 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -183,4 +183,9 @@ void hists__init(struct hists *hists);
 
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample, bool swapped);
+
+int perf_evsel__synthesize_sample(struct perf_evsel *evsel,
+				  union perf_event *event,
+				  const struct perf_sample *sample,
+				  bool swapped);
 #endif /* __PERF_EVSEL_H */
-- 
1.7.1

