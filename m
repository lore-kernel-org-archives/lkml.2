Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab2JDMwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:52:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843Ab2JDMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:52:01 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 14/20] perf report: Make another loop for output resorting
Date: Thu,  4 Oct 2012 21:49:48 +0900
Message-Id: <1349354994-17853-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now the event grouping viewing requires collapsing all members in a
group to the leader.  Thus hists__output_resort should be called after
collapsing all entries in evlist.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a61725d89d3e..b7e250d63892 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -416,6 +416,11 @@ static int __cmd_report(struct perf_report *rep)
 			hists->symbol_filter_str = rep->symbol_filter_str;
 
 		hists__collapse_resort(hists);
+	}
+
+	list_for_each_entry(pos, &session->evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+
 		hists__output_resort(hists);
 		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
 	}
-- 
1.7.9.2

