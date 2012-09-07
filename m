Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab2IGGQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab2IGGQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:16:05 -0400
Date: Thu, 6 Sep 2012 23:15:45 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-fjimge1ovgh976qlt8dtmlp0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Add fprintf method
Git-Commit-ID: 78f067b38bed1adce6a2fa7868cf8ea37d61f537
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:15:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78f067b38bed1adce6a2fa7868cf8ea37d61f537
Gitweb:     http://git.kernel.org/tip/78f067b38bed1adce6a2fa7868cf8ea37d61f537
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 6 Sep 2012 14:54:11 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Sep 2012 14:54:11 -0300

perf evlist: Add fprintf method

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
 2 files changed, 15 insertions(+), 0 deletions(-)

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
