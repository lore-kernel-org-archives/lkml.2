Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab1CaQ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:28:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49522 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965017Ab1CaQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:27:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=I/oHSQbwgyewfIRW5bVckPgdkEHHQW+Bw/Xs8arFiRFvJBHVt5sedF7kcgrBY34KWg
         3URAADTntg80y705OTy3KBuLKQax5OKv9aPP/3KFNQSVRy7eGsT27BNgu2JnivsKdlMF
         EgFdnWfrFuxu0w4BNOvH79v4YHEvEKc8BKFxQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <daahern@cisco.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf: Cleanup useless double NULL termination in python method arg names
Date: Thu, 31 Mar 2011 18:27:43 +0200
Message-Id: <1301588863-20210-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1301588863-20210-1-git-send-email-fweisbec@gmail.com>
References: <1301588863-20210-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The list of methods argument names only needs to be NULL terminated
once. Remove the second ones.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <daahern@cisco.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/python.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 2914221..5a49810 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -247,7 +247,7 @@ struct pyrf_cpu_map {
 static int pyrf_cpu_map__init(struct pyrf_cpu_map *pcpus,
 			      PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = { "cpustr", NULL, NULL, };
+	static char *kwlist[] = { "cpustr", NULL};
 	char *cpustr = NULL;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|s",
@@ -316,7 +316,7 @@ struct pyrf_thread_map {
 static int pyrf_thread_map__init(struct pyrf_thread_map *pthreads,
 				 PyObject *args, PyObject *kwargs)
 {
-	static char *kwlist[] = { "pid", "tid", NULL, NULL, };
+	static char *kwlist[] = { "pid", "tid", NULL};
 	int pid = -1, tid = -1;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii",
@@ -418,7 +418,7 @@ static int pyrf_evsel__init(struct pyrf_evsel *pevsel,
 		"wakeup_events",
 		"bp_type",
 		"bp_addr",
-		"bp_len", NULL, NULL, };
+		"bp_len", NULL};
 	u64 sample_period = 0;
 	u32 disabled = 0,
 	    inherit = 0,
@@ -499,7 +499,7 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	struct thread_map *threads = NULL;
 	PyObject *pcpus = NULL, *pthreads = NULL;
 	int group = 0, overwrite = 0;
-	static char *kwlist[] = {"cpus", "threads", "group", "overwrite", NULL, NULL};
+	static char *kwlist[] = {"cpus", "threads", "group", "overwrite", NULL};
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist,
 					 &pcpus, &pthreads, &group, &overwrite))
@@ -581,8 +581,7 @@ static PyObject *pyrf_evlist__mmap(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-	static char *kwlist[] = {"pages", "overwrite",
-				  NULL, NULL};
+	static char *kwlist[] = {"pages", "overwrite", NULL};
 	int pages = 128, overwrite = false;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|ii", kwlist,
@@ -602,7 +601,7 @@ static PyObject *pyrf_evlist__poll(struct pyrf_evlist *pevlist,
 				   PyObject *args, PyObject *kwargs)
 {
 	struct perf_evlist *evlist = &pevlist->evlist;
-	static char *kwlist[] = {"timeout", NULL, NULL};
+	static char *kwlist[] = {"timeout", NULL};
 	int timeout = -1, n;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|i", kwlist, &timeout))
@@ -673,7 +672,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	struct perf_evlist *evlist = &pevlist->evlist;
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
-	static char *kwlist[] = {"cpu", "sample_id_all", NULL, NULL};
+	static char *kwlist[] = {"cpu", "sample_id_all", NULL};
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
 					 &cpu, &sample_id_all))
-- 
1.7.3.2

