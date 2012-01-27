Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2A0Oew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:34:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab2A0Oet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:34:49 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/9] perf, tool: Make perf_evlist__splice_list_tail global
Date: Fri, 27 Jan 2012 15:34:20 +0100
Message-Id: <1327674868-10486-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1327674868-10486-1-git-send-email-jolsa@redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making perf_evlist__splice_list_tail globaly accessible.
It is used in the upcomming paches.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.4.4

