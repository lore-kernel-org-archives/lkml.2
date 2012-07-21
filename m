Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2GUQrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:47:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2GUQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:46:53 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/5] perf header: Remove unused @fd arg from ->print callback
Date: Sun, 22 Jul 2012 01:45:34 +0900
Message-Id: <1342889135-14825-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342889135-14825-1-git-send-email-namhyung@kernel.org>
References: <1342889135-14825-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we don't need the @fd in the ->print any more, get rid of it from
the signature.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 9ab1803d601d..4484a80c20ba 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -973,38 +973,38 @@ static int write_branch_stack(int fd __used, struct perf_header *h __used,
 	return 0;
 }
 
-static void print_hostname(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_hostname(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# hostname : %s\n", ph->hostname);
 }
 
-static void print_osrelease(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_osrelease(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# os release : %s\n", ph->os_release);
 }
 
-static void print_arch(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_arch(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# arch : %s\n", ph->arch);
 }
 
-static void print_cpudesc(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_cpudesc(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# cpudesc : %s\n", ph->cpu_desc);
 }
 
-static void print_nrcpus(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_nrcpus(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# nrcpus online : %u\n", ph->nr_cpus_online);
 	fprintf(fp, "# nrcpus avail : %u\n", ph->nr_cpus_avail);
 }
 
-static void print_version(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_version(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# perf version : %s\n", ph->version);
 }
 
-static void print_cmdline(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_cmdline(struct perf_header *ph, FILE *fp)
 {
 	char *str;
 	int i;
@@ -1023,7 +1023,7 @@ static void print_cmdline(struct perf_header *ph, int fd __used, FILE *fp)
 #define TOPO_STR_DELIM ':'
 
 /* For string formatting, see process_cpu_topology() */
-static void print_cpu_topology(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_cpu_topology(struct perf_header *ph, FILE *fp)
 {
 	u32 nr, i;
 	char *str;
@@ -1074,7 +1074,7 @@ static void print_cpu_topology(struct perf_header *ph, int fd __used, FILE *fp)
 	}
 }
 
-static void print_event_desc(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_event_desc(struct perf_header *ph, FILE *fp)
 {
 	struct perf_session *session;
 	struct perf_evsel *evsel;
@@ -1113,13 +1113,13 @@ static void print_event_desc(struct perf_header *ph, int fd __used, FILE *fp)
 	}
 }
 
-static void print_total_mem(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_total_mem(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# total memory : %"PRIu64" kB\n", ph->total_mem);
 }
 
 /* For string formatting, see process_numa_topology() */
-static void print_numa_topology(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_numa_topology(struct perf_header *ph, FILE *fp)
 {
 	u32 nr, i, node;
 	u64 mem_total, mem_free;
@@ -1165,13 +1165,12 @@ static void print_numa_topology(struct perf_header *ph, int fd __used, FILE *fp)
 	}
 }
 
-static void print_cpuid(struct perf_header *ph, int fd __used, FILE *fp)
+static void print_cpuid(struct perf_header *ph, FILE *fp)
 {
 	fprintf(fp, "# cpuid : %s\n", ph->cpuid);
 }
 
-static void print_branch_stack(struct perf_header *ph __used, int fd __used,
-			       FILE *fp)
+static void print_branch_stack(struct perf_header *ph __used, FILE *fp)
 {
 	fprintf(fp, "# contains samples with branch stack\n");
 }
@@ -1684,7 +1683,7 @@ static int process_total_mem(struct perf_file_section *section __used,
 
 struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
-	void (*print)(struct perf_header *h, int fd, FILE *fp);
+	void (*print)(struct perf_header *h, FILE *fp);
 	int (*process)(struct perf_file_section *section,
 		       struct perf_header *h, int feat, int fd, void *data);
 	const char *name;
@@ -1746,7 +1745,7 @@ static int perf_file_section__fprintf_info(struct perf_file_section *section,
 		return 0;
 
 	if (!feat_ops[feat].full_only || hd->full)
-		feat_ops[feat].print(ph, fd, hd->fp);
+		feat_ops[feat].print(ph, hd->fp);
 	else
 		fprintf(hd->fp, "# %s info available, use -I to display\n",
 			feat_ops[feat].name);
-- 
1.7.9.2

