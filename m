Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1FCNhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:37:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:57812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1FCNhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:37:21 -0400
Date: Fri, 3 Jun 2011 13:37:06 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-e95cc02880947e9f77540b03e166470e8ac14cbc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
        daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        tzanussi@gmail.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <1301588863-20210-1-git-send-email-fweisbec@gmail.com>
References: <1301588863-20210-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Fix argument name list of read_on_cpu()
Git-Commit-ID: e95cc02880947e9f77540b03e166470e8ac14cbc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Jun 2011 13:37:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e95cc02880947e9f77540b03e166470e8ac14cbc
Gitweb:     http://git.kernel.org/tip/e95cc02880947e9f77540b03e166470e8ac14cbc
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 31 Mar 2011 18:27:42 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 2 Jun 2011 13:21:07 -0300

perf python: Fix argument name list of read_on_cpu()

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
