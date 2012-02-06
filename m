Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab2BFWKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:10:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:56449 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2BFWKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:10:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/8] perf evlist: Make splice_list_tail method public
Date: Mon,  6 Feb 2012 20:10:16 -0200
Message-Id: <1328566223-27218-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328566223-27218-1-git-send-email-acme@infradead.org>
References: <1328566223-27218-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Making perf_evlist__splice_list_tail globaly accessible.

It is used in the upcomming paches.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1327674868-10486-2-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    6 +++---
 tools/perf/util/evlist.h |    5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a6d50e3..a57a8cf 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -97,9 +97,9 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 	++evlist->nr_entries;
 }
 
-static void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
-					  struct list_head *list,
-					  int nr_entries)
+void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
+				   struct list_head *list,
+				   int nr_entries)
 {
 	list_splice_tail(list, &evlist->entries);
 	evlist->nr_entries += nr_entries;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9c51660..1b4282b 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -117,4 +117,9 @@ u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
+
+void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
+				   struct list_head *list,
+				   int nr_entries);
+
 #endif /* __PERF_EVLIST_H */
-- 
1.7.9.123.g65da0

