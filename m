Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab0JZKX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:23:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:34391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab0JZKX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:23:27 -0400
Date: Tue, 26 Oct 2010 10:22:34 GMT
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
Subject: [tip:perf/urgent] perf python scripting: Improve the syscalls-counts script
Message-ID: <tip-6545aaa561b5678c497e94dea22cb2d1af1d6859@git.kernel.org>
Git-Commit-ID: 6545aaa561b5678c497e94dea22cb2d1af1d6859
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 10:22:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6545aaa561b5678c497e94dea22cb2d1af1d6859
Gitweb:     http://git.kernel.org/tip/6545aaa561b5678c497e94dea22cb2d1af1d6859
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 25 Oct 2010 17:11:25 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 25 Oct 2010 18:47:11 -0200

perf python scripting: Improve the syscalls-counts script

. Print message at script start telling how to get te summary
. Print the syscall name

Now it looks like this:

[root@emilia ~]# perf trace syscall-counts
Press control+C to stop and show the summary
^C
syscall events:

event                                          count
----------------------------------------  -----------
read                                          102752
open                                            1293
close                                            878
write                                            319
stat                                             185
fstat                                            149
getdents                                         116
mmap                                              98
brk                                               80
rt_sigaction                                      66
munmap                                            42
mprotect                                          24
lseek                                             21
lstat                                              7
rt_sigprocmask                                     4
futex                                              3
statfs                                             3
ioctl                                              3
readlink                                           2
select                                             2
getegid                                            1
geteuid                                            1
getgid                                             1
getuid                                             1
getrlimit                                          1
fcntl                                              1
uname                                              1
[root@emilia ~]#

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
 tools/perf/scripts/python/syscall-counts.py |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scripts/python/syscall-counts.py
index f977e85..ea183dc 100644
--- a/tools/perf/scripts/python/syscall-counts.py
+++ b/tools/perf/scripts/python/syscall-counts.py
@@ -13,6 +13,7 @@ sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 
 from perf_trace_context import *
 from Core import *
+from Util import syscall_name
 
 usage = "perf trace -s syscall-counts.py [comm]\n";
 
@@ -27,7 +28,7 @@ if len(sys.argv) > 1:
 syscalls = autodict()
 
 def trace_begin():
-	pass
+	print "Press control+C to stop and show the summary"
 
 def trace_end():
 	print_syscall_totals()
@@ -55,4 +56,4 @@ def print_syscall_totals():
 
     for id, val in sorted(syscalls.iteritems(), key = lambda(k, v): (v, k), \
 				  reverse = True):
-	    print "%-40d  %10d\n" % (id, val),
+	    print "%-40s  %10d\n" % (syscall_name(id), val),
