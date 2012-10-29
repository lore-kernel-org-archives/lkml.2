Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab2J2PJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:09:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:42144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2J2PJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:09:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/14] perf python: Initialize 'page_size' variable
Date: Mon, 29 Oct 2012 13:09:13 -0200
Message-Id: <1351523353-27982-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351523353-27982-1-git-send-email-acme@infradead.org>
References: <1351523353-27982-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The commit 0c1fe6b:

 'perf tools: Have the page size value available for all tools'

Broke the python binding because the global variable 'page_size' is
initialized on the main() routine, that is not called when using
just the python binding, causing evlist.mmap() to fail because it
expects that variable to be initialized to the system's page size.

Fix it by initializing it on the binding init routine.

Reported-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vrvp3azmbfzexnpmkhmvtzzc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 9181bf2..a2657fd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1015,6 +1015,8 @@ PyMODINIT_FUNC initperf(void)
 	    pyrf_cpu_map__setup_types() < 0)
 		return;
 
+	page_size = sysconf(_SC_PAGE_SIZE);
+
 	Py_INCREF(&pyrf_evlist__type);
 	PyModule_AddObject(module, "evlist", (PyObject*)&pyrf_evlist__type);
 
-- 
1.7.9.2.358.g22243

