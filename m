Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab1LWV40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 16:56:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57952 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab1LWVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 16:53:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/15] perf tools: Improve macros for struct feature_ops
Date: Fri, 23 Dec 2011 19:53:11 -0200
Message-Id: <1324677198-5191-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324677198-5191-1-git-send-email-acme@infradead.org>
References: <1324677198-5191-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@amd.com>

Reducing duplication and line size by extending function names for
print and write from a single name.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1323248577-11268-7-git-send-email-robert.richter@amd.com
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5b01449..4c48be8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1065,26 +1065,30 @@ struct feature_ops {
 	bool full_only;
 };
 
-#define FEAT_OPA(n, w, p) \
-	[n] = { .name = #n, .write = w, .print = p }
-#define FEAT_OPF(n, w, p) \
-	[n] = { .name = #n, .write = w, .print = p, .full_only = true }
+#define FEAT_OPA(n, func) \
+	[n] = { .name = #n, .write = write_##func, .print = print_##func }
+#define FEAT_OPF(n, func) \
+	[n] = { .name = #n, .write = write_##func, .print = print_##func, .full_only = true }
+
+/* feature_ops not implemented: */
+#define print_trace_info		NULL
+#define print_build_id			NULL
 
 static const struct feature_ops feat_ops[HEADER_LAST_FEATURE] = {
-	FEAT_OPA(HEADER_TRACE_INFO, write_trace_info, NULL),
-	FEAT_OPA(HEADER_BUILD_ID, write_build_id, NULL),
-	FEAT_OPA(HEADER_HOSTNAME, write_hostname, print_hostname),
-	FEAT_OPA(HEADER_OSRELEASE, write_osrelease, print_osrelease),
-	FEAT_OPA(HEADER_VERSION, write_version, print_version),
-	FEAT_OPA(HEADER_ARCH, write_arch, print_arch),
-	FEAT_OPA(HEADER_NRCPUS, write_nrcpus, print_nrcpus),
-	FEAT_OPA(HEADER_CPUDESC, write_cpudesc, print_cpudesc),
-	FEAT_OPA(HEADER_CPUID, write_cpuid, print_cpuid),
-	FEAT_OPA(HEADER_TOTAL_MEM, write_total_mem, print_total_mem),
-	FEAT_OPA(HEADER_EVENT_DESC, write_event_desc, print_event_desc),
-	FEAT_OPA(HEADER_CMDLINE, write_cmdline, print_cmdline),
-	FEAT_OPF(HEADER_CPU_TOPOLOGY, write_cpu_topology, print_cpu_topology),
-	FEAT_OPF(HEADER_NUMA_TOPOLOGY, write_numa_topology, print_numa_topology),
+	FEAT_OPA(HEADER_TRACE_INFO,	trace_info),
+	FEAT_OPA(HEADER_BUILD_ID,	build_id),
+	FEAT_OPA(HEADER_HOSTNAME,	hostname),
+	FEAT_OPA(HEADER_OSRELEASE,	osrelease),
+	FEAT_OPA(HEADER_VERSION,	version),
+	FEAT_OPA(HEADER_ARCH,		arch),
+	FEAT_OPA(HEADER_NRCPUS,		nrcpus),
+	FEAT_OPA(HEADER_CPUDESC,	cpudesc),
+	FEAT_OPA(HEADER_CPUID,		cpuid),
+	FEAT_OPA(HEADER_TOTAL_MEM,	total_mem),
+	FEAT_OPA(HEADER_EVENT_DESC,	event_desc),
+	FEAT_OPA(HEADER_CMDLINE,	cmdline),
+	FEAT_OPF(HEADER_CPU_TOPOLOGY,	cpu_topology),
+	FEAT_OPF(HEADER_NUMA_TOPOLOGY,	numa_topology),
 };
 
 struct header_print_data {
-- 
1.7.8.rc0.35.gee6df

