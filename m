Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1FCQ0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:26:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44982 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193Ab1FCQ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:26:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <daahern@cisco.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf python: Fix argument name list of read_on_cpu()
Date: Fri,  3 Jun 2011 13:26:03 -0300
Message-Id: <1307118363-24092-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1307118363-24092-1-git-send-email-acme@infradead.org>
References: <1307118363-24092-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Mandatory arguments need to be present in the argument name list, as
well as optional arguments, otherwise python barfs:

	# ./python/twatch.py
	Traceback (most recent call last):
	  File "./python/twatch.py", line 41, in <module>
	    main()
	  File "./python/twatch.py", line 32, in main
	    event = evlist.read_on_cpu(cpu)
	RuntimeError: more argument specifiers than keyword list entries

Hence, add cpu to the name list.

Cc: David Ahern <daahern@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/r/1301588863-20210-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 24063b4..a9ac050 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -674,7 +674,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	struct perf_evlist *evlist = &pevlist->evlist;
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
-	static char *kwlist[] = {"sample_id_all", NULL, NULL};
+	static char *kwlist[] = {"cpu", "sample_id_all", NULL, NULL};
 	int err;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
-- 
1.6.2.5

