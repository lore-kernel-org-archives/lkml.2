Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab0JZKXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:23:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:34399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681Ab0JZKX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:23:29 -0400
Date: Tue, 26 Oct 2010 10:22:57 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, davem@davemloft.net,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, davem@davemloft.net,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf python scripting: print the syscall name on sctop
Message-ID: <tip-2e7d1e3fb8043380a2fc5d759eb357bf05acf935@git.kernel.org>
Git-Commit-ID: 2e7d1e3fb8043380a2fc5d759eb357bf05acf935
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 10:22:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e7d1e3fb8043380a2fc5d759eb357bf05acf935
Gitweb:     http://git.kernel.org/tip/2e7d1e3fb8043380a2fc5d759eb357bf05acf935
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 25 Oct 2010 18:39:20 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Oct 2010 18:47:27 -0200

perf python scripting: print the syscall name on sctop

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
