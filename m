Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2HEQyz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:54:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:54:54 -0400
Date: Sun, 5 Aug 2012 09:51:18 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-jd8tqbx8o8bs4t4g50vyhoc2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Remove no longer used synthesize_sample method
Git-Commit-ID: 7405ed10f6adcdd556d59c360b5b216fccada3d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:51:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7405ed10f6adcdd556d59c360b5b216fccada3d9
Gitweb:     http://git.kernel.org/tip/7405ed10f6adcdd556d59c360b5b216fccada3d9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 2 Aug 2012 21:01:17 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Aug 2012 21:02:02 -0300

perf session: Remove no longer used synthesize_sample method

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jd8tqbx8o8bs4t4g50vyhoc2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    8 --------
 tools/perf/util/session.h |    4 ----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7d07324..2437fb0 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -16,14 +16,6 @@
 #include "cpumap.h"
 #include "event-parse.h"
 
-int perf_session__synthesize_sample(struct perf_session *session,
-				    union perf_event *event,
-				    const struct perf_sample *sample)
-{
-	return perf_event__synthesize_sample(event, perf_evlist__sample_type(session->evlist),
-					     sample, session->header.needs_swap);
-}
-
 static int perf_session__open(struct perf_session *self, bool force)
 {
 	struct stat input_stat;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7389fb1..1f7ec87 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -126,10 +126,6 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self,
 
 size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp);
 
-int perf_session__synthesize_sample(struct perf_session *session,
-				    union perf_event *event,
-				    const struct perf_sample *sample);
-
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
