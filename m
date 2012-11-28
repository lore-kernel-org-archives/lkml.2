Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2K1NyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:54:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab2K1NyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:54:09 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 12/14] perf diff: Display data file info ahead of the diff output
Date: Wed, 28 Nov 2012 14:52:47 +0100
Message-Id: <1354110769-2998-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Data files are referenced through the index of the file
on the command line. Adding list of data files for each
index to ease up navigation.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 81f7529..50e1ea3 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -632,6 +632,19 @@ static void hists__process(struct hists *hists)
 	hists__fprintf(hists, true, 0, 0, stdout);
 }
 
+static void data_fprintf(void)
+{
+	struct diff_data *d;
+	int i;
+
+	fprintf(stdout, "# Data files:\n");
+
+	for_each_data(i, d)
+		fprintf(stdout, "#  [%d] %s\n", d->idx, d->file);
+
+	fprintf(stdout, "#\n");
+}
+
 static int data_process(void)
 {
 	struct perf_evlist *evlist_base = data[0].session->evlist;
@@ -662,6 +675,9 @@ static int data_process(void)
 		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
 			perf_evsel__name(evsel_base));
 
+		if (data_cnt > 2)
+			data_fprintf();
+
 		hists__process(&evsel_base->hists);
 
 		first = false;
-- 
1.7.11.7

