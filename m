Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2BGTb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:31:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2BGTbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:31:55 -0500
Date: Tue, 7 Feb 2012 11:31:25 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0529bc1fe1e3e509a2fc06fe887b0c76b1eb01f9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1327674868-10486-2-git-send-email-jolsa@redhat.com>
References: <1327674868-10486-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Make splice_list_tail method public
Git-Commit-ID: 0529bc1fe1e3e509a2fc06fe887b0c76b1eb01f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:31:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0529bc1fe1e3e509a2fc06fe887b0c76b1eb01f9
Gitweb:     http://git.kernel.org/tip/0529bc1fe1e3e509a2fc06fe887b0c76b1eb01f9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 27 Jan 2012 15:34:20 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Feb 2012 15:29:53 -0200

perf evlist: Make splice_list_tail method public

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
