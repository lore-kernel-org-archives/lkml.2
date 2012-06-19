Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2FSSDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:03:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:43336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/20] perf evsel: Reconstruct raw event with modifiers from perf_event_attr
Date: Tue, 19 Jun 2012 14:50:18 -0300
Message-Id: <1340128221-17348-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

I forgot to add the modifiers to raw events too, fix it.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pi267j1aqqjti9rqh9qy4g58@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 236bdf2..8f0e9dd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -252,6 +252,12 @@ static int perf_evsel__hw_cache_name(struct perf_evsel *evsel, char *bf, size_t
 	return ret + perf_evsel__add_modifiers(evsel, bf + ret, size - ret);
 }
 
+static int perf_evsel__raw_name(struct perf_evsel *evsel, char *bf, size_t size)
+{
+	int ret = scnprintf(bf, size, "raw 0x%" PRIx64, evsel->attr.config);
+	return ret + perf_evsel__add_modifiers(evsel, bf + ret, size - ret);
+}
+
 const char *perf_evsel__name(struct perf_evsel *evsel)
 {
 	char bf[128];
@@ -261,7 +267,7 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 
 	switch (evsel->attr.type) {
 	case PERF_TYPE_RAW:
-		scnprintf(bf, sizeof(bf), "raw 0x%" PRIx64, evsel->attr.config);
+		perf_evsel__raw_name(evsel, bf, sizeof(bf));
 		break;
 
 	case PERF_TYPE_HARDWARE:
-- 
1.7.1

