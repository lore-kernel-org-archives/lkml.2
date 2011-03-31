Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033Ab1CaQ1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:27:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964977Ab1CaQ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p4wNBKrv1QIdXiFjbAdxyLpm+vNCre7683PXsnLdomZM0Mr+fL7X5UiPIHHAaVvzDm
         1GY5oqJ6fKKEiDdWJ4PuU8oh413gZx4EVgaummChiOlz+HeQXWvkQNoqbComj02JMCU8
         LtZJhoJ1vNcJX5P9pA/HB3SWBjzQViQO3FyCM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <daahern@cisco.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/2] perf: Fix python argument name list of read_on_cpu()
Date: Thu, 31 Mar 2011 18:27:42 +0200
Message-Id: <1301588863-20210-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandatory arguments need to be present in the argument name
list, as well as optional arguments, otherwise python barfs:

	# ./python/twatch.py
	Traceback (most recent call last):
	  File "./python/twatch.py", line 41, in <module>
	    main()
	  File "./python/twatch.py", line 32, in main
	    event = evlist.read_on_cpu(cpu)
	RuntimeError: more argument specifiers than keyword list entries

Hence, add cpu to the name list.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <daahern@cisco.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/python.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a9f2d7e..2914221 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -673,7 +673,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	struct perf_evlist *evlist = &pevlist->evlist;
 	union perf_event *event;
 	int sample_id_all = 1, cpu;
-	static char *kwlist[] = {"sample_id_all", NULL, NULL};
+	static char *kwlist[] = {"cpu", "sample_id_all", NULL, NULL};
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "i|i", kwlist,
 					 &cpu, &sample_id_all))
-- 
1.7.3.2

