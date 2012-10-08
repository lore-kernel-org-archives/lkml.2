Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab2JHWeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:34:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:41437 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2JHWdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/25] perf diff: Display empty space for non paired samples
Date: Mon,  8 Oct 2012 19:32:36 -0300
Message-Id: <1349735570-19339-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently in 'Baseline' and 'Period Base' columns zero values are
displayed in case no pair is found for the sample. This might be
confusing, using empty space instead.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349448287-18919-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 305eb79..4f5f475 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -179,7 +179,10 @@ static int hpp__color_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 {
 	double percent = baseline_percent(he);
 
-	return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+	if (he->pair)
+		return percent_color_snprintf(hpp->buf, hpp->size, " %6.2f%%", percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "        ");
 }
 
 static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
@@ -187,7 +190,10 @@ static int hpp__entry_baseline(struct perf_hpp *hpp, struct hist_entry *he)
 	double percent = baseline_percent(he);
 	const char *fmt = symbol_conf.field_sep ? "%.2f" : " %6.2f%%";
 
-	return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	if (he->pair || symbol_conf.field_sep)
+		return scnprintf(hpp->buf, hpp->size, fmt, percent);
+	else
+		return scnprintf(hpp->buf, hpp->size, "            ");
 }
 
 static int hpp__header_samples(struct perf_hpp *hpp)
-- 
1.7.9.2.358.g22243

