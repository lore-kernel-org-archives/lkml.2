Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab0EACyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:54:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41533 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab0EACx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=bqmFXTErpa6d9i1wFO8QEKxwK9MeNdfJqnMFcYJfELT4StafWQ8mhukXf+jvFlEaG2
         9y6QV/Zuad8BZvhuvkoRsqZc9jweZGGAJe4rUTWA+I3bnDNXODo1EYtkDbU/yDIu+KMp
         713yLcpTLdv1wUo/VD/+QA6Nf3gRrqPd3yRBs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/8] perf: Remove leftover useless options to record trace events from scripts
Date: Sat,  1 May 2010 04:53:48 +0200
Message-Id: <1272682436-10682-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-f, -c 1, -R are now useless for trace events recording, moreover
-M is useless and event hurts.

Remove them from the documentation examples and from record scripts.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Documentation/perf-trace-perl.txt       |    6 ++----
 tools/perf/Documentation/perf-trace-python.txt     |   10 ++++------
 .../perf/scripts/perl/bin/check-perf-trace-record  |    2 +-
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 tools/perf/scripts/python/bin/sctop-record         |    2 +-
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 13 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace-perl.txt b/tools/perf/Documentation/perf-trace-perl.txt
index d729cee..ee6525e 100644
--- a/tools/perf/Documentation/perf-trace-perl.txt
+++ b/tools/perf/Documentation/perf-trace-perl.txt
@@ -49,12 +49,10 @@ available as calls back into the perf executable (see below).
 As an example, the following perf record command can be used to record
 all sched_wakeup events in the system:
 
- # perf record -c 1 -f -a -M -R -e sched:sched_wakeup
+ # perf record -a -e sched:sched_wakeup
 
 Traces meant to be processed using a script should be recorded with
-the above options: -c 1 says to sample every event, -a to enable
-system-wide collection, -M to multiplex the output, and -R to collect
-raw samples.
+the above option: -a to enable system-wide collection.
 
 The format file for the sched_wakep event defines the following fields
 (see /sys/kernel/debug/tracing/events/sched/sched_wakeup/format):
diff --git a/tools/perf/Documentation/perf-trace-python.txt b/tools/perf/Documentation/perf-trace-python.txt
index a241aca..16a8650 100644
--- a/tools/perf/Documentation/perf-trace-python.txt
+++ b/tools/perf/Documentation/perf-trace-python.txt
@@ -93,7 +93,7 @@ don't care how it exited, so we'll use 'perf record' to record only
 the sys_enter events:
 
 ----
-# perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter
+# perf record -a -e raw_syscalls:sys_enter
 
 ^C[ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 56.545 MB perf.data (~2470503 samples) ]
@@ -359,7 +359,7 @@ your script:
 # cat kernel-source/tools/perf/scripts/python/bin/syscall-counts-record
 
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter
+perf record -a -e raw_syscalls:sys_enter
 ----
 
 The 'report' script is also a shell script with the same base name as
@@ -449,12 +449,10 @@ available as calls back into the perf executable (see below).
 As an example, the following perf record command can be used to record
 all sched_wakeup events in the system:
 
- # perf record -c 1 -f -a -M -R -e sched:sched_wakeup
+ # perf record -a -e sched:sched_wakeup
 
 Traces meant to be processed using a script should be recorded with
-the above options: -c 1 says to sample every event, -a to enable
-system-wide collection, -M to multiplex the output, and -R to collect
-raw samples.
+the above option: -a to enable system-wide collection.
 
 The format file for the sched_wakep event defines the following fields
 (see /sys/kernel/debug/tracing/events/sched/sched_wakeup/format):
diff --git a/tools/perf/scripts/perl/bin/check-perf-trace-record b/tools/perf/scripts/perl/bin/check-perf-trace-record
index e6cb147..423ad6a 100644
--- a/tools/perf/scripts/perl/bin/check-perf-trace-record
+++ b/tools/perf/scripts/perl/bin/check-perf-trace-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e kmem:kmalloc -e irq:softirq_entry -e kmem:kfree
+perf record -a -e kmem:kmalloc -e irq:softirq_entry -e kmem:kfree
diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-record b/tools/perf/scripts/perl/bin/failed-syscalls-record
index 6ad9b8f..eb5846b 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-record
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit $@
+perf record -a -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-record b/tools/perf/scripts/perl/bin/rw-by-file-record
index a828679..5bfaae5 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-record
+++ b/tools/perf/scripts/perl/bin/rw-by-file-record
@@ -1,3 +1,3 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_enter_write $@
+perf record -a -e syscalls:sys_enter_read -e syscalls:sys_enter_write $@
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-record b/tools/perf/scripts/perl/bin/rw-by-pid-record
index 63976bf..6e0b2f7 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-record
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
+perf record -a -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/rwtop-record b/tools/perf/scripts/perl/bin/rwtop-record
index 63976bf..6e0b2f7 100644
--- a/tools/perf/scripts/perl/bin/rwtop-record
+++ b/tools/perf/scripts/perl/bin/rwtop-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
+perf record -a -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-record b/tools/perf/scripts/perl/bin/wakeup-latency-record
index 9c0cf58..9f2acaa 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-record
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-record
@@ -1,5 +1,5 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e sched:sched_switch -e sched:sched_wakeup $@
+perf record -a -e sched:sched_switch -e sched:sched_wakeup $@
 
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-record b/tools/perf/scripts/perl/bin/workqueue-stats-record
index c2a1a94..85301f2 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-record
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
+perf record -a -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
index 6ad9b8f..eb5846b 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_exit $@
+perf record -a -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
index 27ccffa..1fc5998 100644
--- a/tools/perf/scripts/python/bin/sctop-record
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter $@
+perf record -a -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
index 27ccffa..1fc5998 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter $@
+perf record -a -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
index 27ccffa..1fc5998 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -c 1 -f -a -M -R -e raw_syscalls:sys_enter $@
+perf record -a -e raw_syscalls:sys_enter $@
-- 
1.6.2.3

