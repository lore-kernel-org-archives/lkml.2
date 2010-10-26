Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0JZA3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:29:31 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33991 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0JZA33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:29:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/5] perf python scripting: print the syscall name on sctop
Date: Mon, 25 Oct 2010 22:29:15 -0200
Message-Id: <1288052957-14087-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1288052957-14087-1-git-send-email-acme@infradead.org>
References: <1288052957-14087-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[root@emilia tmp]# perf trace sctop 1
syscall events:

event                                          count
----------------------------------------  ----------
read                                          215400
futex                                           4029
write                                            376
brk                                               33
rt_sigprocmask                                    24
select                                            17
lseek                                              2
fsync                                              1
^C[root@emilia tmp]#

Cc: David S. Miller <davem@davemloft.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/python/sctop.py |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
index 6cafad4..547cbe9 100644
--- a/tools/perf/scripts/python/sctop.py
+++ b/tools/perf/scripts/python/sctop.py
@@ -8,10 +8,7 @@
 # will be refreshed every [interval] seconds.  The default interval is
 # 3 seconds.
 
-import thread
-import time
-import os
-import sys
+import os, sys, thread, time
 
 sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
@@ -71,7 +68,7 @@ def print_syscall_totals(interval):
 		for id, val in sorted(syscalls.iteritems(), key = lambda(k, v): (v, k), \
 					      reverse = True):
 			try:
-				print "%-40d  %10d\n" % (id, val),
+				print "%-40s  %10d\n" % (syscall_name(id), val),
 			except TypeError:
 				pass
 		syscalls.clear()
-- 
1.6.2.5

