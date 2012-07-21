Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2GUQq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 12:46:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2GUQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 12:46:56 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/5] perf header: Remove unused @feat arg from ->process callback
Date: Sun, 22 Jul 2012 01:45:35 +0900
Message-Id: <1342889135-14825-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1342889135-14825-1-git-send-email-namhyung@kernel.org>
References: <1342889135-14825-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the @feat arg is not used anywhere, get rid of it from the signature.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c |   48 ++++++++++++++++++----------------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4484a80c20ba..0efbaa3c5a6b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1325,17 +1325,16 @@ out:
 	return err;
 }
 
-static int process_tracing_data(struct perf_file_section *section __unused,
-			      struct perf_header *ph __unused,
-			      int feat __unused, int fd, void *data)
+static int process_tracing_data(struct perf_file_section *section __used,
+				struct perf_header *ph __used, int fd,
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
@@ -1343,16 +1342,14 @@ static int process_build_id(struct perf_file_section *section,
 }
 
 static int process_hostname(struct perf_file_section *section __used,
-			    struct perf_header *ph, int feat __used, int fd,
-			    void *data __used)
+			    struct perf_header *ph, int fd, void *data __used)
 {
 	ph->hostname = do_read_string(fd, ph);
 	return ph->hostname ? 0 : -ENOMEM;
 }
 
 static int process_osrelease(struct perf_file_section *section __used,
-			     struct perf_header *ph, int feat __used, int fd,
-			     void *data __used)
+			     struct perf_header *ph, int fd, void *data __used)
 {
 
 	ph->os_release = do_read_string(fd, ph);
@@ -1360,24 +1357,21 @@ static int process_osrelease(struct perf_file_section *section __used,
 }
 
 static int process_arch(struct perf_file_section *section __used,
-			struct perf_header *ph, int feat __used, int fd,
-			void *data __used)
+			struct perf_header *ph, int fd, void *data __used)
 {
 	ph->arch = do_read_string(fd, ph);
 	return ph->arch ? 0 : -ENOMEM;
 }
 
 static int process_cpudesc(struct perf_file_section *section __used,
-			   struct perf_header *ph, int feat __used, int fd,
-			   void *data __used)
+			   struct perf_header *ph, int fd, void *data __used)
 {
 	ph->cpu_desc = do_read_string(fd, ph);
 	return ph->cpu_desc ? 0 : -ENOMEM;
 }
 
 static int process_nrcpus(struct perf_file_section *section __used,
-			  struct perf_header *ph, int feat __used, int fd,
-			  void *data __used)
+			  struct perf_header *ph, int fd, void *data __used)
 {
 	ssize_t ret;
 	u32 nr;
@@ -1404,8 +1398,7 @@ static int process_nrcpus(struct perf_file_section *section __used,
 }
 
 static int process_version(struct perf_file_section *section __used,
-			   struct perf_header *ph, int feat __used, int fd,
-			   void *data __used)
+			   struct perf_header *ph, int fd, void *data __used)
 {
 	ph->version = do_read_string(fd, ph);
 	return ph->version ? 0 : -ENOMEM;
@@ -1413,8 +1406,7 @@ static int process_version(struct perf_file_section *section __used,
 
 /* Each argv would be separated by a NULL character */
 static int process_cmdline(struct perf_file_section *section __used,
-			   struct perf_header *ph, int feat __used, int fd,
-			   void *data __used)
+			   struct perf_header *ph, int fd, void *data __used)
 {
 	ssize_t ret;
 	char *str, *tmp;
@@ -1476,8 +1468,8 @@ error:
  *	"NR_THREAD_SIBLINGS(M):SIBLING[0]:SIBLING[1]:...:SIBLING[M-1]\n"
  */
 static int process_cpu_topology(struct perf_file_section *section __used,
-				struct perf_header *ph, int feat __used,
-				int fd,	void *data __used)
+				struct perf_header *ph, int fd,
+				void *data __used)
 {
 	ssize_t ret;
 	u32 nr, i;
@@ -1566,8 +1558,8 @@ error:
  *	"NODE_NUM(N-1):MEM_TOTAL:MEM_FREE:CPULIST\n"
  */
 static int process_numa_topology(struct perf_file_section *section __used,
-				 struct perf_header *ph, int feat __used,
-				 int fd, void *data __used)
+				 struct perf_header *ph, int fd,
+				 void *data __used)
 {
 	ssize_t ret;
 	u32 nr, node, i;
@@ -1656,16 +1648,14 @@ error:
 }
 
 static int process_cpuid(struct perf_file_section *section __used,
-			 struct perf_header *ph, int feat __used, int fd,
-			 void *data __used)
+			 struct perf_header *ph, int fd, void *data __used)
 {
 	ph->cpuid = do_read_string(fd, ph);
 	return ph->cpuid ? 0 : -ENOMEM;
 }
 
 static int process_total_mem(struct perf_file_section *section __used,
-			     struct perf_header *ph, int feat __used, int fd,
-			     void *data __used)
+			     struct perf_header *ph, int fd, void *data __used)
 {
 	uint64_t mem;
 	ssize_t ret;
@@ -1685,7 +1675,7 @@ struct feature_ops {
 	int (*write)(int fd, struct perf_header *h, struct perf_evlist *evlist);
 	void (*print)(struct perf_header *h, FILE *fp);
 	int (*process)(struct perf_file_section *section,
-		       struct perf_header *h, int feat, int fd, void *data);
+		       struct perf_header *h, int fd, void *data);
 	const char *name;
 	bool full_only;
 };
@@ -2196,7 +2186,7 @@ static int perf_file_section__process(struct perf_file_section *section,
 	if (!feat_ops[feat].process)
 		return 0;
 
-	return feat_ops[feat].process(section, ph, feat, fd, data);
+	return feat_ops[feat].process(section, ph, fd, data);
 }
 
 static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
-- 
1.7.9.2

