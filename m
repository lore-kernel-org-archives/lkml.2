Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab2EKG0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:26:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2EKG0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:26:39 -0400
Date: Thu, 10 May 2012 23:26:19 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-0tjedaozsy9oarq30nvzg74b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Make the rdpmc test honour 'verbose'
  mode
Git-Commit-ID: 23080e4cd224013c06444e7850fe0bcb55c129ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:26:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23080e4cd224013c06444e7850fe0bcb55c129ff
Gitweb:     http://git.kernel.org/tip/23080e4cd224013c06444e7850fe0bcb55c129ff
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 26 Apr 2012 16:22:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 15:14:12 -0300

perf test: Make the rdpmc test honour 'verbose' mode

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
 1 files changed, 2 insertions(+), 4 deletions(-)

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
