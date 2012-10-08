Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2JHRSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:18:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2JHRSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:24 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/12] perf top: move CONSOLE_CLEAR to header file
Date: Mon,  8 Oct 2012 11:17:29 -0600
Message-Id: <1349716656-48165-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For use with kvm-live mode.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-top.c |    2 --
 tools/perf/util/top.h    |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fb9da71..a053812 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -263,8 +263,6 @@ out_unlock:
 	pthread_mutex_unlock(&notes->lock);
 }
 
-static const char		CONSOLE_CLEAR[] = "[H[2J";
-
 static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 						     struct addr_location *al,
 						     struct perf_sample *sample)
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 86ff1b1..8630570 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -47,6 +47,8 @@ struct perf_top {
 	const char	   *sym_filter;
 };
 
+#define CONSOLE_CLEAR "[H[2J"
+
 size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size);
 void perf_top__reset_sample_counters(struct perf_top *top);
 #endif /* __PERF_TOP_H */
-- 
1.7.10.1

