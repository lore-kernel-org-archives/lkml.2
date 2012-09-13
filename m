Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2IMH1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:27:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46467 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab2IMH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:27:09 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-15-50518ac8aea5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 14/15] perf ui/gtk: Add support to accumulated hist stat
Date: Thu, 13 Sep 2012 16:20:10 +0900
Message-Id: <1347520811-28150-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Print accumulated stat of a hist entry if requested.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 7107edc6c08d..2fdd2f675194 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -53,6 +53,9 @@ static int perf_gtk__hpp_color_ ## _name(struct perf_hpp *hpp,			\
 	const char *markup;							\
 	int ret = 0;								\
 										\
+	if (symbol_conf.cumulate_callchain)					\
+		percent = 100.0 * he->stat_acc->_field / hpp->total_period;	\
+										\
 	markup = perf_gtk__get_percent_color(percent);				\
 	if (markup)								\
 		ret += scnprintf(hpp->buf, hpp->size, "%s", markup);		\
-- 
1.7.11.4

