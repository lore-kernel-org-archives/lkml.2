Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2IXQAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58839 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab2IXQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/30] perf header: Remove unused @feat arg from ->process callback
Date: Mon, 24 Sep 2012 12:59:28 -0300
Message-Id: <1348502384-14442-15-git-send-email-acme@infradead.org>
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

As the @feat arg is not used anywhere, get rid of it from the signature.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1348474503-15070-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   70 +++++++++++++++++++++++-----------------------
 1 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b2929d7..4b028df 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1580,18 +1580,16 @@ out:
 	return err;
 }
 
-static int process_tracing_data(struct perf_file_section *section
-				__maybe_unused,
-			      struct perf_header *ph __maybe_unused,
-			      int feat __maybe_unused, int fd, void *data)
+static int process_tracing_data(struct perf_file_section *section __maybe_unused,
+				struct perf_header *ph __maybe_unused,
+				int fd, void *data)
 {
 	trace_report(fd, data, false);
 	return 0;
 }
 
 static int process_build_id(struct perf_file_section *section,
-			    struct perf_header *ph,
-			    int feat __maybe_unused, int fd,
+			    struct perf_header *ph, int fd,
 			    void *data __maybe_unused)
 {
 	if (perf_header__read_build_ids(ph, fd, section->offset, section->size))
@@ -1600,40 +1598,40 @@ static int process_build_id(struct perf_file_section *section,
 }
 
 static int process_hostname(struct perf_file_section *section __maybe_unused,
-			    struct perf_header *ph, int feat __maybe_unused,
-			    int fd, void *data __maybe_unused)
+			    struct perf_header *ph, int fd,
+			    void *data __maybe_unused)
 {
 	ph->env.hostname = do_read_string(fd, ph);
 	return ph->env.hostname ? 0 : -ENOMEM;
 }
 
 static int process_osrelease(struct perf_file_section *section __maybe_unused,
-			     struct perf_header *ph, int feat __maybe_unused,
-			     int fd, void *data __maybe_unused)
+			     struct perf_header *ph, int fd,
+			     void *data __maybe_unused)
 {
 	ph->env.os_release = do_read_string(fd, ph);
 	return ph->env.os_release ? 0 : -ENOMEM;
 }
 
 static int process_version(struct perf_file_section *section __maybe_unused,
-			   struct perf_header *ph, int feat __maybe_unused,
-			   int fd, void *data __maybe_unused)
+			   struct perf_header *ph, int fd,
+			   void *data __maybe_unused)
 {
 	ph->env.version = do_read_string(fd, ph);
 	return ph->env.version ? 0 : -ENOMEM;
 }
 
 static int process_arch(struct perf_file_section *section __maybe_unused,
-			struct perf_header *ph, int feat __maybe_unused,
-			int fd, void *data __maybe_unused)
+			struct perf_header *ph,	int fd,
+			void *data __maybe_unused)
 {
 	ph->env.arch = do_read_string(fd, ph);
 	return ph->env.arch ? 0 : -ENOMEM;
 }
 
 static int process_nrcpus(struct perf_file_section *section __maybe_unused,
-			  struct perf_header *ph, int feat __maybe_unused,
-			  int fd, void *data __maybe_unused)
+			  struct perf_header *ph, int fd,
+			  void *data __maybe_unused)
 {
 	size_t ret;
 	u32 nr;
@@ -1659,24 +1657,24 @@ static int process_nrcpus(struct perf_file_section *section __maybe_unused,
 }
 
 static int process_cpudesc(struct perf_file_section *section __maybe_unused,
-			   struct perf_header *ph, int feat __maybe_unused,
-			   int fd, void *data __maybe_unused)
+			   struct perf_header *ph, int fd,
+			   void *data __maybe_unused)
 {
 	ph->env.cpu_desc = do_read_string(fd, ph);
 	return ph->env.cpu_desc ? 0 : -ENOMEM;
 }
 
 static int process_cpuid(struct perf_file_section *section __maybe_unused,
-			 struct perf_header *ph, int feat __maybe_unused,
-			 int fd, void *data __maybe_unused)
+			 struct perf_header *ph,  int fd,
+			 void *data __maybe_unused)
 {
 	ph->env.cpuid = do_read_string(fd, ph);
 	return ph->env.cpuid ? 0 : -ENOMEM;
 }
 
 static int process_total_mem(struct perf_file_section *section __maybe_unused,
-			     struct perf_header *ph, int feat __maybe_unused,
-			     int fd, void *data __maybe_unused)
+			     struct perf_header *ph, int fd,
+			     void *data __maybe_unused)
 {
 	uint64_t mem;
 	size_t ret;
@@ -1711,7 +1709,8 @@ perf_evlist__find_by_index(struct perf_evlist *evlist, int idx)
 }
 
 static void
-perf_evlist__set_event_name(struct perf_evlist *evlist, struct perf_evsel *event)
+perf_evlist__set_event_name(struct perf_evlist *evlist,
+			    struct perf_evsel *event)
 {
 	struct perf_evsel *evsel;
 
@@ -1730,15 +1729,16 @@ perf_evlist__set_event_name(struct perf_evlist *evlist, struct perf_evsel *event
 
 static int
 process_event_desc(struct perf_file_section *section __maybe_unused,
-		   struct perf_header *header, int feat __maybe_unused, int fd,
+		   struct perf_header *header, int fd,
 		   void *data __maybe_unused)
 {
-	struct perf_session *session = container_of(header, struct perf_session, header);
+	struct perf_session *session;
 	struct perf_evsel *evsel, *events = read_event_desc(header, fd);
 
 	if (!events)
 		return 0;
 
+	session = container_of(header, struct perf_session, header);
 	for (evsel = events; evsel->attr.size; evsel++)
 		perf_evlist__set_event_name(session->evlist, evsel);
 
@@ -1748,8 +1748,8 @@ process_event_desc(struct perf_file_section *section __maybe_unused,
 }
 
 static int process_cmdline(struct perf_file_section *section __maybe_unused,
-			   struct perf_header *ph, int feat __maybe_unused,
-			   int fd, void *data __maybe_unused)
+			   struct perf_header *ph, int fd,
+			   void *data __maybe_unused)
 {
 	size_t ret;
 	char *str;
@@ -1784,8 +1784,8 @@ error:
 }
 
 static int process_cpu_topology(struct perf_file_section *section __maybe_unused,
-				struct perf_header *ph, int feat __maybe_unused,
-				int fd, void *data __maybe_unused)
+				struct perf_header *ph, int fd,
+				void *data __maybe_unused)
 {
 	size_t ret;
 	u32 nr, i;
@@ -1840,8 +1840,8 @@ error:
 }
 
 static int process_numa_topology(struct perf_file_section *section __maybe_unused,
-				 struct perf_header *ph, int feat __maybe_unused,
-				 int fd, void *data __maybe_unused)
+				 struct perf_header *ph, int fd,
+				 void *data __maybe_unused)
 {
 	size_t ret;
 	u32 nr, node, i;
@@ -1900,8 +1900,8 @@ error:
 }
 
 static int process_pmu_mappings(struct perf_file_section *section __maybe_unused,
-				struct perf_header *ph, int feat __maybe_unused,
-				int fd, void *data __maybe_unused)
+				struct perf_header *ph, int fd,
+				void *data __maybe_unused)
 {
 	size_t ret;
 	char *name;
@@ -1954,7 +1954,7 @@ struct feature_ops {
 	void (*print)(struct perf_header *h, int fd, FILE *fp);
 	char *(*read)(struct perf_header *h, int fd);
 	int (*process)(struct perf_file_section *section,
-		       struct perf_header *h, int feat, int fd, void *data);
+		       struct perf_header *h, int fd, void *data);
 	const char *name;
 	bool full_only;
 };
@@ -2520,7 +2520,7 @@ static int perf_file_section__process(struct perf_file_section *section,
 	if (!feat_ops[feat].process)
 		return 0;
 
-	return feat_ops[feat].process(section, ph, feat, fd, data);
+	return feat_ops[feat].process(section, ph, fd, data);
 }
 
 static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
-- 
1.7.1

