Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1FBVxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:53:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43214 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab1FBVxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:53:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <daahern@cisco.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf python: Cleanup useless double NULL termination in method arg names
Date: Thu,  2 Jun 2011 17:56:32 -0300
Message-Id: <1307048196-16387-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1307048196-16387-1-git-send-email-acme@infradead.org>
References: <1307048196-16387-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

The list of methods argument names only needs to be NULL terminated
once. Remove the second ones.

Cc: David Ahern <daahern@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/r/1301588863-20210-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a9ac050..8e0b5a3 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -247,7 +247,7 @@ struct pyrf_cpu_map {
 static int pyrf_cpu_map__init(struct pyrf_cpu_map *pcpus,
 			      PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = { "cpustr", NULL, NULL, };
+	static char *kwlist[] = { "cpustr", NULL };
 	char *cpustr = NULL;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|s",
@@ -316,7 +316,7 @@ struct pyrf_thread_map {
 static int pyrf_thread_map__init(struct pyrf_thread_map *pthreads,
 				 PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = { "pid", "tid", NULL, NULL, };
+	static char *kwlist[] = { "pid", "tid", NULL };
 	int pid = -1, tid = -1;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii",
@@ -418,7 +418,9 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 		"wakeup_events",
 		"bp_type",
 		"bp_addr",
-		"bp_len", NULL, NULL, };
+		"bp_len",
+		 NULL
+	};
 	u64 sample_period = 0;
 	u32 disabled = 0,
 	    inherit = 0,
@@ -499,7 +501,7 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	struct thread_map *threads = NULL;
 	PyObject *pcpus = NULL, *pthreads = NULL;
 	int group = 0, inherit = 0;
-	static char *kwlist[] = {"cpus", "threads", "group", "inherit", NULL, NULL};
+	static char *kwlist[] = { "cpus", "threads", "group", "inherit", NULL };
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist,
 					 &pcpus, &pthreads, &group, &inherit))
@@ -582,8 +584,7 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-	static char *kwlist[] = {"pages", "overwrite",
-				  NULL, NULL};
+	static char *kwlist[] = { "pages", "overwrite", NULL };
 	int pages = 128, overwrite = false;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii", kwlist,
@@ -603,7 +604,7 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-	static char *kwlist[] = {"timeout", NULL, NULL};
+	static char *kwlist[] = { "timeout", NULL };
 	int timeout = -1, n;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i", kwlist, &timeout))
@@ -674,7 +675,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	struct perf_evlist *evlist = &pevlist->evlist;
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
-	static char *kwlist[] = {"cpu", "sample_id_all", NULL, NULL};
+	static char *kwlist[] = { "cpu", "sample_id_all", NULL };
 	int err;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
-- 
1.6.2.5

