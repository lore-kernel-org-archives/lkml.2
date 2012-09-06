Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab2IFTch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:32:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:50918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612Ab2IFTbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:31:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/8] perf evlist: Add fprintf method
Date: Thu,  6 Sep 2012 16:31:19 -0300
Message-Id: <1346959881-22427-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346959881-22427-1-git-send-email-acme@infradead.org>
References: <1346959881-22427-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For debugging, etc.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-fjimge1ovgh976qlt8dtmlp0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |   13 +++++++++++++
 tools/perf/util/evlist.h |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4774ac1..8923537 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -889,3 +889,16 @@ int perf_evlist__parse_sample(struct perf_evlist *evlist, union perf_event *even
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
 	return perf_evsel__parse_sample(evsel, event, sample, swapped);
 }
+
+size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
+{
+	struct perf_evsel *evsel;
+	size_t printed = 0;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		printed += fprintf(fp, "%s%s", evsel->idx ? ", " : "",
+				   perf_evsel__name(evsel));
+	}
+
+	return printed + fprintf(fp, "\n");;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2ed2557..3f2e1e4 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -143,4 +143,6 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 {
 	return list_entry(evlist->entries.prev, struct perf_evsel, node);
 }
+
+size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 #endif /* __PERF_EVLIST_H */
-- 
1.7.9.2.358.g22243

