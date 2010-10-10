Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0JJPK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:10:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45139 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab0JJPK0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:10:26 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 10 Oct 2010 16:10:03 +0100
Message-ID: <1286723403.2955.205.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/2] perf: Use $PERF_EXEC_PATH in canned report scripts
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set $PERF_EXEC_PATH before starting the record and report scripts, and
make them use it where necessary.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/builtin-trace.c                         |    6 +++---
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-report           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 tools/perf/scripts/python/bin/netdev-times-report  |    2 +-
 .../perf/scripts/python/bin/sched-migration-report |    2 +-
 tools/perf/scripts/python/bin/sctop-report         |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 13 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 40a6a29..3ea6219 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -46,9 +46,6 @@ static struct scripting_ops	*scripting_ops;
 
 static void setup_scripting(void)
 {
-	/* make sure PERF_EXEC_PATH is set for scripts */
-	perf_set_argv_exec_path(perf_exec_path());
-
 	setup_perl_scripting();
 	setup_python_scripting();
 
@@ -593,6 +590,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 		suffix = REPORT_SUFFIX;
 	}
 
+	/* make sure PERF_EXEC_PATH is set for scripts */
+	perf_set_argv_exec_path(perf_exec_path());
+
 	if (!suffix && argc >= 2 && strncmp(argv[1], "-", strlen("-")) != 0) {
 		char *record_script_path, *report_script_path;
 		int live_pipe[2];
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-report b/tools/perf/scripts/perl/bin/failed-syscalls-report
index e3a5e55..4028d92 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-report
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/failed-syscalls.pl $comm
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/failed-syscalls.pl $comm
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index d83070b..ba25f4d 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -7,7 +7,7 @@ if [ $# -lt 1 ] ; then
 fi
 comm=$1
 shift
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-file.pl $comm
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/rw-by-file.pl $comm
 


diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
index 7ef4698..641a3f5 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-report
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide r/w activity
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rw-by-pid.pl
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/rw-by-pid.pl
 


diff --git a/tools/perf/scripts/perl/bin/rwtop-report b/tools/perf/scripts/perl/bin/rwtop-report
index 93e698c..4918dba 100644
--- a/tools/perf/scripts/perl/bin/rwtop-report
+++ b/tools/perf/scripts/perl/bin/rwtop-report
@@ -17,7 +17,7 @@ if [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/rwtop.pl $interval
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/rwtop.pl $interval
 


diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
index a0d898f..49052eb 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-report
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: system-wide min/max/avg wakeup latency
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/wakeup-latency.pl
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/wakeup-latency.pl
 


diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
index 3508113..df0c65f 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -1,6 +1,6 @@
 #!/bin/bash
 # description: workqueue stats (ins/exe/create/destroy)
-perf trace $@ -s ~/libexec/perf-core/scripts/perl/workqueue-stats.pl
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/workqueue-stats.pl
 


diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
index 3029354..0358702 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/failed-syscalls-by-pid.py $comm
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/failed-syscalls-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/netdev-times-report b/tools/perf/scripts/python/bin/netdev-times-report
index c3d0a63..4ad361b 100644
--- a/tools/perf/scripts/python/bin/netdev-times-report
+++ b/tools/perf/scripts/python/bin/netdev-times-report
@@ -2,4 +2,4 @@
 # description: display a process of packet and processing time
 # args: [tx] [rx] [dev=] [debug]
 
-perf trace -s ~/libexec/perf-core/scripts/python/netdev-times.py $@
+perf trace -s "$PERF_EXEC_PATH"/scripts/python/netdev-times.py $@
diff --git a/tools/perf/scripts/python/bin/sched-migration-report b/tools/perf/scripts/python/bin/sched-migration-report
index 61d05f7..df1791f 100644
--- a/tools/perf/scripts/python/bin/sched-migration-report
+++ b/tools/perf/scripts/python/bin/sched-migration-report
@@ -1,3 +1,3 @@
 #!/bin/bash
 # description: sched migration overview
-perf trace $@ -s ~/libexec/perf-core/scripts/python/sched-migration.py
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/sched-migration.py
diff --git a/tools/perf/scripts/python/bin/sctop-report b/tools/perf/scripts/python/bin/sctop-report
index b01c842..36b409c 100644
--- a/tools/perf/scripts/python/bin/sctop-report
+++ b/tools/perf/scripts/python/bin/sctop-report
@@ -21,4 +21,4 @@ elif [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/sctop.py $comm $interval
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/sctop.py $comm $interval
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
index 9e9d8dd..4eb88c9 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts-by-pid.py $comm
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/syscall-counts-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/syscall-counts-report b/tools/perf/scripts/python/bin/syscall-counts-report
index dc076b6..cb2f9c5 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s ~/libexec/perf-core/scripts/python/syscall-counts.py $comm
+perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/syscall-counts.py $comm
-- 
1.7.1



