Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1L2UwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:52:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1L2UwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:52:02 -0500
Date: Thu, 29 Dec 2011 12:51:34 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-8cdfa78a885d94a79205d183a611ebc4876d6f33@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        robert.richter@amd.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1323248577-11268-7-git-send-email-robert.richter@amd.com>
References: <1323248577-11268-7-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Improve macros for struct feature_ops
Git-Commit-ID: 8cdfa78a885d94a79205d183a611ebc4876d6f33
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:51:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cdfa78a885d94a79205d183a611ebc4876d6f33
Gitweb:     http://git.kernel.org/tip/8cdfa78a885d94a79205d183a611ebc4876d6f33
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 7 Dec 2011 10:02:56 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 16:56:27 -0200

perf tools: Improve macros for struct feature_ops

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
