Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab1LFKdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:33:09 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:50407
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933235Ab1LFKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:33:03 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVS2MS-02-F8J-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 09/10] perf tools: Improve macros for struct feature_ops
Date: Tue, 6 Dec 2011 11:32:39 +0100
Message-ID: <1323167560-2282-10-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reducing duplication and line size by extending function names for
print and write from a single name.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/util/header.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 5cfe06a..915a5f7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1311,26 +1311,30 @@ struct feature_ops {
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
1.7.7


