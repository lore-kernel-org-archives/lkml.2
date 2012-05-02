Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2EBTZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:25:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47242 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2EBTZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/15] perf test: Make the rdpmc test honour 'verbose' mode
Date: Wed,  2 May 2012 16:24:49 -0300
Message-Id: <1335986702-9408-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was unconditionally printing debug stuff when in non -v mode we
should just print the name and result of the test.

Now:

[root@sandy ~]# perf test rdpmc
 6: x86 rdpmc test: Ok
[root@sandy ~]# perf test -v rdpmc
 6: x86 rdpmc test:
--- start ---
             0:           6030
             1:          60030
             2:         600050
             3:        6000056
             4:       60000070
             5:      600000266
   ---- end ----
x86 rdpmc test: Ok
[root@sandy ~]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-0tjedaozsy9oarq30nvzg74b@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c5b980..5502a4a 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1549,8 +1549,6 @@ static int __test__rdpmc(void)
 	sa.sa_sigaction = segfault_handler;
 	sigaction(SIGSEGV, &sa, NULL);
 
-	fprintf(stderr, "\n\n");
-
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 	if (fd < 0) {
 		die("Error: sys_perf_event_open() syscall returned "
@@ -1575,7 +1573,7 @@ static int __test__rdpmc(void)
 		loops *= 10;
 
 		delta = now - stamp;
-		fprintf(stderr, "%14d: %14Lu\n", n, (long long)delta);
+		pr_debug("%14d: %14Lu\n", n, (long long)delta);
 
 		delta_sum += delta;
 	}
@@ -1583,7 +1581,7 @@ static int __test__rdpmc(void)
 	munmap(addr, page_size);
 	close(fd);
 
-	fprintf(stderr, "   ");
+	pr_debug("   ");
 
 	if (!delta_sum)
 		return -1;
-- 
1.7.9.2.358.g22243

