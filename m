Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab2LMNJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:09:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579Ab2LMNJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:09:47 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 08/14] perf diff: Display data file info ahead of the diff output
Date: Thu, 13 Dec 2012 14:09:06 +0100
Message-Id: <1355404152-16523-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
References: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Data files are referenced through the index of the file
on the command line. Adding list of data files for each
index to ease up navigation for user.

It's displayed only if in verbose mode.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a3e3f7a..15a68fb 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -482,6 +482,21 @@ static void hists__process(struct hists *base, struct hists *new)
 	hists__fprintf(base, true, 0, 0, stdout);
 }
 
+static void data__fprintf(void)
+{
+	struct data__file *d;
+	int i;
+
+	fprintf(stdout, "# Data files:\n");
+
+	data__for_each_file(i, d)
+		fprintf(stdout, "#  [%d] %s %s\n",
+			d->idx, d->file,
+			!d->idx ? "(Baseline)" : "");
+
+	fprintf(stdout, "#\n");
+}
+
 static void data_process(void)
 {
 	struct perf_evlist *evlist_old = data__files[0].session->evlist;
@@ -501,6 +516,9 @@ static void data_process(void)
 
 		first = false;
 
+		if (verbose)
+			data__fprintf();
+
 		hists__process(&evsel_old->hists, &evsel_new->hists);
 	}
 }
-- 
1.7.11.7

