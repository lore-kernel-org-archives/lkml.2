Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0JZAaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:30:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:53603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0JZAaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:30:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/5] perf python scripting: Improve the syscalls-counts script
Date: Mon, 25 Oct 2010 22:29:14 -0200
Message-Id: <1288052957-14087-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1288052957-14087-1-git-send-email-acme@infradead.org>
References: <1288052957-14087-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

