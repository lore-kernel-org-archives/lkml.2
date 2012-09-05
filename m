Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2IEFKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:10:38 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47884 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2IEFKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:10:24 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-4b-5046debd5089
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 7/7] perf header: Remove unused @feat arg from ->process callback
Date: Wed,  5 Sep 2012 14:02:53 +0900
Message-Id: <1346821373-31621-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
References: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As the @feat arg is not used anywhere, get rid of it from the signature.

Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 59 ++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 34 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2cc0954d984c..06ecd577d1b8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1541,16 +1541,15 @@ out:
 }
 
 static int process_tracing_data(struct perf_file_section *section __unused,
-			      struct perf_header *ph __unused,
-			      int feat __unused, int fd, void *data)
+				struct perf_header *ph __unused, int fd,
+				void *data)
 {
 	trace_report(fd, data, false);
 	return 0;
 }
 
 static int process_build_id(struct perf_file_section *section,
-			    struct perf_header *ph,
-			    int feat __unused, int fd, void *data __used)
+			    struct perf_header *ph, int fd, void *data __used)
 {
 	if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
 		pr_debug("Failed to read buildids, continuing...\n");
@@ -1558,40 +1557,35 @@ static int process_build_id(struct perf_file_section *section,
 }
 
 static int process_hostname(struct perf_file_section *section __unused,
-			    struct perf_header *ph,
-			    int feat __unused, int fd, void *data __used)
+			    struct perf_header *ph, int fd, void *data __used)
 {
 	ph->info.hostname = do_read_string(fd, ph);
 	return ph->info.hostname ? 0 : -ENOMEM;
 }
 
 static int process_osrelease(struct perf_file_section *section __unused,
-			     struct perf_header *ph,
-			     int feat __unused, int fd, void *data __used)
+			     struct perf_header *ph, int fd, void *data __used)
 {
 	ph->info.os_release = do_read_string(fd, ph);
 	return ph->info.os_release ? 0 : -ENOMEM;
 }
 
 static int process_version(struct perf_file_section *section __unused,
-			   struct perf_header *ph,
-			   int feat __unused, int fd, void *data __used)
+			   struct perf_header *ph, int fd, void *data __used)
 {
 	ph->info.version = do_read_string(fd, ph);
 	return ph->info.version ? 0 : -ENOMEM;
 }
 
 static int process_arch(struct perf_file_section *section __unused,
-			struct perf_header *ph,
-			int feat __unused, int fd, void *data __used)
+			struct perf_header *ph, int fd, void *data __used)
 {
 	ph->info.arch = do_read_string(fd, ph);
 	return ph->info.arch ? 0 : -ENOMEM;
 }
 
 static int process_nrcpus(struct perf_file_section *section __unused,
-			  struct perf_header *ph,
-			  int feat __unused, int fd, void *data __used)
+			  struct perf_header *ph, int fd, void *data __used)
 {
 	size_t ret;
 	u32 nr;
@@ -1617,24 +1611,21 @@ static int process_nrcpus(struct perf_file_section *section __unused,
 }
 
 static int process_cpudesc(struct perf_file_section *section __unused,
-			   struct perf_header *ph,
-			   int feat __unused, int fd, void *data __used)
+			   struct perf_header *ph, int fd, void *data __used)
 {
 	ph->info.cpu_desc = do_read_string(fd, ph);
 	return ph->info.cpu_desc ? 0 : -ENOMEM;
 }
 
 static int process_cpuid(struct perf_file_section *section __unused,
-			 struct perf_header *ph,
-			 int feat __unused, int fd, void *data __used)
+			 struct perf_header *ph, int fd, void *data __used)
 {
 	ph->info.cpuid = do_read_string(fd, ph);
 	return ph->info.cpuid ? 0 : -ENOMEM;
 }
 
 static int process_total_mem(struct perf_file_section *section __unused,
-			     struct perf_header *ph,
-			     int feat __unused, int fd, void *data __used)
+			     struct perf_header *ph, int fd, void *data __used)
 {
 	uint64_t mem;
 	size_t ret;
@@ -1664,7 +1655,8 @@ perf_evlist__find_by_index(struct perf_evlist *evlist, int idx)
 }
 
 static void
-perf_evlist__set_event_name(struct perf_evlist *evlist, struct perf_evsel *event)
+perf_evlist__set_event_name(struct perf_evlist *evlist,
+			    struct perf_evsel *event)
 {
 	struct perf_evsel *evsel;
 
@@ -1683,15 +1675,15 @@ perf_evlist__set_event_name(struct perf_evlist *evlist, struct perf_evsel *event
 
 static int
 process_event_desc(struct perf_file_section *section __unused,
-		   struct perf_header *header, int feat __unused, int fd,
-		   void *data __used)
+		   struct perf_header *header, int fd, void *data __used)
 {
-	struct perf_session *session = container_of(header, struct perf_session, header);
+	struct perf_session *session;
 	struct perf_evsel *evsel, *events = read_event_desc(header, fd);
 
 	if (!events)
 		return 0;
 
+	session = container_of(header, struct perf_session, header);
 	for (evsel = events; evsel->attr.size; evsel++)
 		perf_evlist__set_event_name(session->evlist, evsel);
 
@@ -1701,8 +1693,7 @@ process_event_desc(struct perf_file_section *section __unused,
 }
 
 static int process_cmdline(struct perf_file_section *section __unused,
-			   struct perf_header *ph,
-			   int feat __unused, int fd, void *data __used)
+			   struct perf_header *ph, int fd, void *data __used)
 {
 	size_t ret;
 	char *str;
@@ -1737,8 +1728,8 @@ error:
 }
 
 static int process_cpu_topology(struct perf_file_section *section __unused,
-				struct perf_header *ph,
-				int feat __unused, int fd, void *data __used)
+				struct perf_header *ph, int fd,
+				void *data __used)
 {
 	size_t ret;
 	u32 nr, i;
@@ -1793,8 +1784,8 @@ error:
 }
 
 static int process_numa_topology(struct perf_file_section *section __unused,
-				 struct perf_header *ph,
-				 int feat __unused, int fd, void *data __used)
+				 struct perf_header *ph, int fd,
+				 void *data __used)
 {
 	size_t ret;
 	u32 nr, node, i;
@@ -1853,8 +1844,8 @@ error:
 }
 
 static int process_pmu_mappings(struct perf_file_section *section __unused,
-				struct perf_header *ph,
-				int feat __unused, int fd, void *data __used)
+				struct perf_header *ph, int fd,
+				void *data __used)
 {
 	size_t ret;
 	char *name;
@@ -1906,7 +1897,7 @@ struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
 	int (*process)(struct perf_file_section *section,
-		       struct perf_header *h, int feat, int fd, void *data);
+		       struct perf_header *h, int fd, void *data);
 	const char *name;
 	bool full_only;
 };
@@ -2420,7 +2411,7 @@ static int perf_file_section__process(struct perf_file_section *section,
 	if (!feat_ops[feat].process)
 		return 0;
 
-	return feat_ops[feat].process(section, ph, feat, fd, data);
+	return feat_ops[feat].process(section, ph, fd, data);
 }
 
 static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
-- 
1.7.11.4

