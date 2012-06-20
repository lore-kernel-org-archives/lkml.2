Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab2FTQ71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:59:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab2FTQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:59:26 -0400
Date: Wed, 20 Jun 2012 09:59:06 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-pi267j1aqqjti9rqh9qy4g58@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Reconstruct raw event with modifiers from perf_event_attr
Git-Commit-ID: 6eef3d9c2bcf52b7a3c18e609f5838c007b989a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:59:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6eef3d9c2bcf52b7a3c18e609f5838c007b989a4
Gitweb:     http://git.kernel.org/tip/6eef3d9c2bcf52b7a3c18e609f5838c007b989a4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 13 Jun 2012 11:53:37 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:21 -0300

perf evsel: Reconstruct raw event with modifiers from perf_event_attr

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
