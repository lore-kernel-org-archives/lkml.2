Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2IXIXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:23:36 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42779 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab2IXIXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:23:35 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-e0-506018865d37
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/6] perf header: Add struct perf_session_env
Date: Mon, 24 Sep 2012 17:14:58 +0900
Message-Id: <1348474503-15070-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
References: <1348474503-15070-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The struct perf_session_env will preserve environment information at
the time of perf record.  It can be accessed anytime after parsing a
perf.data file if needed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 58de08b21bce..5867c7d74f97 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -58,6 +58,29 @@ struct perf_header;
 int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd);
 
+struct perf_session_env {
+	char			*hostname;
+	char			*os_release;
+	char			*version;
+	char			*arch;
+	int			nr_cpus_online;
+	int			nr_cpus_avail;
+	char			*cpu_desc;
+	char			*cpuid;
+	unsigned long long	total_mem;
+
+	int			nr_cmdline;
+	char			*cmdline;
+	int			nr_sibling_cores;
+	char			*sibling_cores;
+	int			nr_sibling_threads;
+	char			*sibling_threads;
+	int			nr_numa_nodes;
+	char			*numa_nodes;
+	int			nr_pmu_mappings;
+	char			*pmu_mappings;
+};
+
 struct perf_header {
 	int			frozen;
 	bool			needs_swap;
@@ -67,6 +90,7 @@ struct perf_header {
 	u64			event_offset;
 	u64			event_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+	struct perf_session_env env;
 };
 
 struct perf_evlist;
-- 
1.7.11.4

