Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2IXQAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58895 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2IXQAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/30] perf header: Add struct perf_session_env
Date: Mon, 24 Sep 2012 12:59:25 -0300
Message-Id: <1348502384-14442-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The struct perf_session_env will preserve environment information at the
time of perf record.  It can be accessed anytime after parsing a
perf.data file if needed.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1348474503-15070-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 58de08b..5867c7d 100644
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
1.7.1

