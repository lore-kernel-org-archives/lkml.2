Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2JIR3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:29:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2JIR3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:29:22 -0400
Date: Tue, 9 Oct 2012 10:28:47 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-6e92349d5a814a3f633a43d9d6bd3b199ef3ad72@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1349448287-18919-9-git-send-email-jolsa@redhat.com>
References: <1349448287-18919-9-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Display empty space for non paired samples
Git-Commit-ID: 6e92349d5a814a3f633a43d9d6bd3b199ef3ad72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:28:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e92349d5a814a3f633a43d9d6bd3b199ef3ad72
Gitweb:     http://git.kernel.org/tip/6e92349d5a814a3f633a43d9d6bd3b199ef3ad72
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 5 Oct 2012 16:44:47 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 14:15:19 -0300

perf diff: Display empty space for non paired samples

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
 1 files changed, 8 insertions(+), 2 deletions(-)

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
