Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1ADITr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:19:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:50055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1ADITo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:19:44 -0500
Date: Tue, 4 Jan 2011 08:19:04 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, edwintorok@gmail.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, edwintorok@gmail.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Finish the rename from trace to script
Message-ID: <tip-765532c8aaac624b5f8687af6d319c6a1138a257@git.kernel.org>
Git-Commit-ID: 765532c8aaac624b5f8687af6d319c6a1138a257
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:19:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  765532c8aaac624b5f8687af6d319c6a1138a257
Gitweb:     http://git.kernel.org/tip/765532c8aaac624b5f8687af6d319c6a1138a257
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 23 Dec 2010 13:10:22 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 25 Dec 2010 11:29:02 -0200

perf script: Finish the rename from trace to script

The scripts have calls to 'perf trace' that need to be converted to 'perf script', do it.

This problem was introduced in 133dc4c.

Reported-by: Torok Edwin <edwintorok@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Torok Edwin <edwintorok@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    2 +-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    4 ++--
 tools/perf/scripts/perl/Perf-Trace-Util/README     |    4 ++--
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm |    2 +-
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm    |    4 ++--
 .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    4 ++--
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-report      |    5 +----
 tools/perf/scripts/perl/bin/rw-by-pid-report       |    5 +----
 tools/perf/scripts/perl/bin/rwtop-report           |    5 +----
 tools/perf/scripts/perl/bin/wakeup-latency-report  |    5 +----
 tools/perf/scripts/perl/bin/workqueue-stats-report |    6 +-----
 tools/perf/scripts/perl/check-perf-trace.pl        |    2 +-
 tools/perf/scripts/perl/rw-by-file.pl              |    2 +-
 tools/perf/scripts/perl/workqueue-stats.pl         |    2 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |    2 +-
 .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |    2 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    2 +-
 .../python/bin/failed-syscalls-by-pid-report       |    2 +-
 .../scripts/python/bin/futex-contention-report     |    2 +-
 tools/perf/scripts/python/bin/netdev-times-report  |    2 +-
 .../perf/scripts/python/bin/sched-migration-report |    2 +-
 tools/perf/scripts/python/bin/sctop-report         |    2 +-
 .../python/bin/syscall-counts-by-pid-report        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-report  |    2 +-
 tools/perf/scripts/python/check-perf-trace.py      |    2 +-
 .../perf/scripts/python/failed-syscalls-by-pid.py  |    2 +-
 tools/perf/scripts/python/sched-migration.py       |    2 +-
 tools/perf/scripts/python/sctop.py                 |    2 +-
 tools/perf/scripts/python/syscall-counts-by-pid.py |    2 +-
 tools/perf/scripts/python/syscall-counts.py        |    2 +-
 31 files changed, 35 insertions(+), 51 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index 01a64ad..790ceba 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -8,7 +8,7 @@
 
 #line 1 "Context.xs"
 /*
- * Context.xs.  XS interfaces for perf trace.
+ * Context.xs.  XS interfaces for perf script.
  *
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  *
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index 549cf04..c1e2ed1 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -1,5 +1,5 @@
 /*
- * Context.xs.  XS interfaces for perf trace.
+ * Context.xs.  XS interfaces for perf script.
  *
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  *
@@ -23,7 +23,7 @@
 #include "perl.h"
 #include "XSUB.h"
 #include "../../../perf.h"
-#include "../../../util/trace-event.h"
+#include "../../../util/script-event.h"
 
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/README b/tools/perf/scripts/perl/Perf-Trace-Util/README
index 9a97076..2f0c7f3 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/README
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/README
@@ -1,7 +1,7 @@
 Perf-Trace-Util version 0.01
 ============================
 
-This module contains utility functions for use with perf trace.
+This module contains utility functions for use with perf script.
 
 Core.pm and Util.pm are pure Perl modules; Core.pm contains routines
 that the core perf support for Perl calls on and should always be
@@ -33,7 +33,7 @@ After you do that:
 
 INSTALLATION
 
-Building perf with perf trace Perl scripting should install this
+Building perf with perf script Perl scripting should install this
 module in the right place.
 
 You should make sure libperl and ExtUtils/Embed.pm are installed first
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
index 6c7f365..4e2f6039 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Context.pm
@@ -34,7 +34,7 @@ Perf::Trace::Context - Perl extension for accessing functions in perf.
 
 =head1 SEE ALSO
 
-Perf (trace) documentation
+Perf (script) documentation
 
 =head1 AUTHOR
 
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
index 9df376a..9158458 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Core.pm
@@ -163,7 +163,7 @@ sub dump_symbolic_fields
 __END__
 =head1 NAME
 
-Perf::Trace::Core - Perl extension for perf trace
+Perf::Trace::Core - Perl extension for perf script
 
 =head1 SYNOPSIS
 
@@ -171,7 +171,7 @@ Perf::Trace::Core - Perl extension for perf trace
 
 =head1 SEE ALSO
 
-Perf (trace) documentation
+Perf (script) documentation
 
 =head1 AUTHOR
 
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
index d94b40c..0535001 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm
@@ -65,7 +65,7 @@ sub clear_term
 __END__
 =head1 NAME
 
-Perf::Trace::Util - Perl extension for perf trace
+Perf::Trace::Util - Perl extension for perf script
 
 =head1 SYNOPSIS
 
@@ -73,7 +73,7 @@ Perf::Trace::Util - Perl extension for perf trace
 
 =head1 SEE ALSO
 
-Perf (trace) documentation
+Perf (script) documentation
 
 =head1 AUTHOR
 
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-report b/tools/perf/scripts/perl/bin/failed-syscalls-report
index 4028d92..9f83cc1 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-report
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/failed-syscalls.pl $comm
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/perl/failed-syscalls.pl $comm
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-report b/tools/perf/scripts/perl/bin/rw-by-file-report
index ba25f4d..77200b3 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-report
+++ b/tools/perf/scripts/perl/bin/rw-by-file-report
@@ -7,7 +7,4 @@ if [ $# -lt 1 ] ; then
 fi
 comm=$1
 shift
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/rw-by-file.pl $comm
-
-
-
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/perl/rw-by-file.pl $comm
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-report b/tools/perf/scripts/perl/bin/rw-by-pid-report
index 641a3f5..a27b9f3 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-report
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-report
@@ -1,6 +1,3 @@
 #!/bin/bash
 # description: system-wide r/w activity
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/rw-by-pid.pl
-
-
-
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/perl/rw-by-pid.pl
diff --git a/tools/perf/scripts/perl/bin/rwtop-report b/tools/perf/scripts/perl/bin/rwtop-report
index 4918dba..83e11ec 100644
--- a/tools/perf/scripts/perl/bin/rwtop-report
+++ b/tools/perf/scripts/perl/bin/rwtop-report
@@ -17,7 +17,4 @@ if [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/rwtop.pl $interval
-
-
-
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/perl/rwtop.pl $interval
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-report b/tools/perf/scripts/perl/bin/wakeup-latency-report
index 49052eb..889e813 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-report
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-report
@@ -1,6 +1,3 @@
 #!/bin/bash
 # description: system-wide min/max/avg wakeup latency
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/wakeup-latency.pl
-
-
-
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/perl/wakeup-latency.pl
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-report b/tools/perf/scripts/perl/bin/workqueue-stats-report
index df0c65f..6d91411 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-report
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-report
@@ -1,7 +1,3 @@
 #!/bin/bash
 # description: workqueue stats (ins/exe/create/destroy)
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/perl/workqueue-stats.pl
-
-
-
-
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/perl/workqueue-stats.pl
diff --git a/tools/perf/scripts/perl/check-perf-trace.pl b/tools/perf/scripts/perl/check-perf-trace.pl
index 4e7dc0a..4e7076c 100644
--- a/tools/perf/scripts/perl/check-perf-trace.pl
+++ b/tools/perf/scripts/perl/check-perf-trace.pl
@@ -1,4 +1,4 @@
-# perf trace event handlers, generated by perf trace -g perl
+# perf script event handlers, generated by perf script -g perl
 # (c) 2009, Tom Zanussi <tzanussi@gmail.com>
 # Licensed under the terms of the GNU GPL License version 2
 
diff --git a/tools/perf/scripts/perl/rw-by-file.pl b/tools/perf/scripts/perl/rw-by-file.pl
index 2a39097..74844ee 100644
--- a/tools/perf/scripts/perl/rw-by-file.pl
+++ b/tools/perf/scripts/perl/rw-by-file.pl
@@ -18,7 +18,7 @@ use lib "./Perf-Trace-Util/lib";
 use Perf::Trace::Core;
 use Perf::Trace::Util;
 
-my $usage = "perf trace -s rw-by-file.pl <comm>\n";
+my $usage = "perf script -s rw-by-file.pl <comm>\n";
 
 my $for_comm = shift or die $usage;
 
diff --git a/tools/perf/scripts/perl/workqueue-stats.pl b/tools/perf/scripts/perl/workqueue-stats.pl
index b84b126..a8eaff5 100644
--- a/tools/perf/scripts/perl/workqueue-stats.pl
+++ b/tools/perf/scripts/perl/workqueue-stats.pl
@@ -10,7 +10,7 @@
 #     workqueue:workqueue_destruction -e workqueue:workqueue_execution
 #     -e workqueue:workqueue_insertion
 #
-#   perf trace -p -s tools/perf/scripts/perl/workqueue-stats.pl
+#   perf script -p -s tools/perf/scripts/perl/workqueue-stats.pl
 
 use 5.010000;
 use strict;
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
index aad7525..de7211e 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
@@ -1,4 +1,4 @@
-# Core.py - Python extension for perf trace, core functions
+# Core.py - Python extension for perf script, core functions
 #
 # Copyright (C) 2010 by Tom Zanussi <tzanussi@gmail.com>
 #
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py
index ae9a56e..fdd92f6 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py
@@ -1,4 +1,4 @@
-# SchedGui.py - Python extension for perf trace, basic GUI code for
+# SchedGui.py - Python extension for perf script, basic GUI code for
 #		traces drawing and overview.
 #
 # Copyright (C) 2010 by Frederic Weisbecker <fweisbec@gmail.com>
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
index 13cc02b..15c8400 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Util.py
@@ -1,4 +1,4 @@
-# Util.py - Python extension for perf trace, miscellaneous utility code
+# Util.py - Python extension for perf script, miscellaneous utility code
 #
 # Copyright (C) 2010 by Tom Zanussi <tzanussi@gmail.com>
 #
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
index 0358702..fda5096 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/failed-syscalls-by-pid.py $comm
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/failed-syscalls-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/futex-contention-report b/tools/perf/scripts/python/bin/futex-contention-report
index c826813..6c44271 100644
--- a/tools/perf/scripts/python/bin/futex-contention-report
+++ b/tools/perf/scripts/python/bin/futex-contention-report
@@ -1,4 +1,4 @@
 #!/bin/bash
 # description: futext contention measurement
 
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/futex-contention.py
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/futex-contention.py
diff --git a/tools/perf/scripts/python/bin/netdev-times-report b/tools/perf/scripts/python/bin/netdev-times-report
index 4ad361b..8f75929 100644
--- a/tools/perf/scripts/python/bin/netdev-times-report
+++ b/tools/perf/scripts/python/bin/netdev-times-report
@@ -2,4 +2,4 @@
 # description: display a process of packet and processing time
 # args: [tx] [rx] [dev=] [debug]
 
-perf trace -s "$PERF_EXEC_PATH"/scripts/python/netdev-times.py $@
+perf script -s "$PERF_EXEC_PATH"/scripts/python/netdev-times.py $@
diff --git a/tools/perf/scripts/python/bin/sched-migration-report b/tools/perf/scripts/python/bin/sched-migration-report
index df1791f..68b037a 100644
--- a/tools/perf/scripts/python/bin/sched-migration-report
+++ b/tools/perf/scripts/python/bin/sched-migration-report
@@ -1,3 +1,3 @@
 #!/bin/bash
 # description: sched migration overview
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/sched-migration.py
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/sched-migration.py
diff --git a/tools/perf/scripts/python/bin/sctop-report b/tools/perf/scripts/python/bin/sctop-report
index 36b409c..c32db29 100644
--- a/tools/perf/scripts/python/bin/sctop-report
+++ b/tools/perf/scripts/python/bin/sctop-report
@@ -21,4 +21,4 @@ elif [ "$n_args" -gt 0 ] ; then
     interval=$1
     shift
 fi
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/sctop.py $comm $interval
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/sctop.py $comm $interval
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
index 4eb88c9..16eb8d6 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/syscall-counts-by-pid.py $comm
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/syscall-counts-by-pid.py $comm
diff --git a/tools/perf/scripts/python/bin/syscall-counts-report b/tools/perf/scripts/python/bin/syscall-counts-report
index cb2f9c5..0f0e9d4 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-report
+++ b/tools/perf/scripts/python/bin/syscall-counts-report
@@ -7,4 +7,4 @@ if [ $# -gt 0 ] ; then
 	shift
     fi
 fi
-perf trace $@ -s "$PERF_EXEC_PATH"/scripts/python/syscall-counts.py $comm
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/syscall-counts.py $comm
diff --git a/tools/perf/scripts/python/check-perf-trace.py b/tools/perf/scripts/python/check-perf-trace.py
index d9f7893..4647a76 100644
--- a/tools/perf/scripts/python/check-perf-trace.py
+++ b/tools/perf/scripts/python/check-perf-trace.py
@@ -1,4 +1,4 @@
-# perf trace event handlers, generated by perf trace -g python
+# perf script event handlers, generated by perf script -g python
 # (c) 2010, Tom Zanussi <tzanussi@gmail.com>
 # Licensed under the terms of the GNU GPL License version 2
 #
diff --git a/tools/perf/scripts/python/failed-syscalls-by-pid.py b/tools/perf/scripts/python/failed-syscalls-by-pid.py
index acd7848..85805fa 100644
--- a/tools/perf/scripts/python/failed-syscalls-by-pid.py
+++ b/tools/perf/scripts/python/failed-syscalls-by-pid.py
@@ -15,7 +15,7 @@ from perf_trace_context import *
 from Core import *
 from Util import *
 
-usage = "perf trace -s syscall-counts-by-pid.py [comm|pid]\n";
+usage = "perf script -s syscall-counts-by-pid.py [comm|pid]\n";
 
 for_comm = None
 for_pid = None
diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index b934383..74d55ec 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -4,7 +4,7 @@
 #
 # Copyright (C) 2010 Frederic Weisbecker <fweisbec@gmail.com>
 #
-# perf trace event handlers have been generated by perf trace -g python
+# perf script event handlers have been generated by perf script -g python
 #
 # This software is distributed under the terms of the GNU General
 # Public License ("GPL") version 2 as published by the Free Software
diff --git a/tools/perf/scripts/python/sctop.py b/tools/perf/scripts/python/sctop.py
index 7a6ec2c..42c267e 100644
--- a/tools/perf/scripts/python/sctop.py
+++ b/tools/perf/scripts/python/sctop.py
@@ -17,7 +17,7 @@ from perf_trace_context import *
 from Core import *
 from Util import *
 
-usage = "perf trace -s sctop.py [comm] [interval]\n";
+usage = "perf script -s sctop.py [comm] [interval]\n";
 
 for_comm = None
 default_interval = 3
diff --git a/tools/perf/scripts/python/syscall-counts-by-pid.py b/tools/perf/scripts/python/syscall-counts-by-pid.py
index d1ee3ec..c64d1c5 100644
--- a/tools/perf/scripts/python/syscall-counts-by-pid.py
+++ b/tools/perf/scripts/python/syscall-counts-by-pid.py
@@ -14,7 +14,7 @@ from perf_trace_context import *
 from Core import *
 from Util import syscall_name
 
-usage = "perf trace -s syscall-counts-by-pid.py [comm]\n";
+usage = "perf script -s syscall-counts-by-pid.py [comm]\n";
 
 for_comm = None
 for_pid = None
diff --git a/tools/perf/scripts/python/syscall-counts.py b/tools/perf/scripts/python/syscall-counts.py
index ea183dc..b435d3f 100644
--- a/tools/perf/scripts/python/syscall-counts.py
+++ b/tools/perf/scripts/python/syscall-counts.py
@@ -15,7 +15,7 @@ from perf_trace_context import *
 from Core import *
 from Util import syscall_name
 
-usage = "perf trace -s syscall-counts.py [comm]\n";
+usage = "perf script -s syscall-counts.py [comm]\n";
 
 for_comm = None
 
