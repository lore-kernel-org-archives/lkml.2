Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2IZH4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:56:17 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54410 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab2IZH4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:10 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-4d-5062b51630c6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 10/16] perf report: Make another loop for output resorting
Date: Wed, 26 Sep 2012 16:47:37 +0900
Message-Id: <1348645663-25303-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
References: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
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
 tools/perf/builtin-report.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1da243dfbc3e..7729c1c290e6 100644
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
1.7.11.4

