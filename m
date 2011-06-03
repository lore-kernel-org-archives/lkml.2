Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1FCNh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:37:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:57840 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1FCNhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:37:55 -0400
Date: Fri, 3 Jun 2011 13:37:32 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-64348153c63b8c1f99f19f14a9c3cbd5df70c9d3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
        daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        tzanussi@gmail.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <1301588863-20210-2-git-send-email-fweisbec@gmail.com>
References: <1301588863-20210-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Cleanup useless double NULL termination in method arg names
Git-Commit-ID: 64348153c63b8c1f99f19f14a9c3cbd5df70c9d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 13:37:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  64348153c63b8c1f99f19f14a9c3cbd5df70c9d3
Gitweb:     http://git.kernel.org/tip/64348153c63b8c1f99f19f14a9c3cbd5df70c9d3
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 31 Mar 2011 18:27:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Jun 2011 13:21:26 -0300

perf python: Cleanup useless double NULL termination in method arg names

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
