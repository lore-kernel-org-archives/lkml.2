Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0KIVSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:18:38 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45811 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0KIVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:18:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oqrgWqNbpL4wknkvsQDH+MZ+6KQI/WcxGyz0tqi9rJqFp+XkpjCVPEnsVEe4L7ePqY
         lUn4VdW83T3sbTishDudJXMkduaViKPKKKG97Hw3KbY6d3Ny/K81pSesYWEWuHs+nXWE
         VBuPXWSAiFjd3LVuroSrFzamUcpHBZxZYfQSQ=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 2/7] perf trace scripting: remove system-wide param from shell scripts
Date: Tue,  9 Nov 2010 15:18:17 -0600
Message-Id: <1289337502-2492-3-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
References: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Including -a unconditionally when recording doesn't allow for the
option of running scripts without it.  Future patches will add add it
back if needed at run-time.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
 tools/perf/scripts/perl/bin/rw-by-file-record      |    2 +-
 tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
 tools/perf/scripts/perl/bin/rwtop-record           |    2 +-
 tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
 tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
 .../python/bin/failed-syscalls-by-pid-record       |    2 +-
 .../scripts/python/bin/futex-contention-record     |    2 +-
 tools/perf/scripts/python/bin/netdev-times-record  |    2 +-
 .../perf/scripts/python/bin/sched-migration-record |    2 +-
 tools/perf/scripts/python/bin/sctop-record         |    2 +-
 .../python/bin/syscall-counts-by-pid-record        |    2 +-
 .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-record b/tools/perf/scripts/perl/bin/failed-syscalls-record
index eb5846b..8104895 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-record
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_exit $@
+perf record -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/perl/bin/rw-by-file-record b/tools/perf/scripts/perl/bin/rw-by-file-record
index 5bfaae5..33efc86 100644
--- a/tools/perf/scripts/perl/bin/rw-by-file-record
+++ b/tools/perf/scripts/perl/bin/rw-by-file-record
@@ -1,3 +1,3 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_read -e syscalls:sys_enter_write $@
+perf record -e syscalls:sys_enter_read -e syscalls:sys_enter_write $@
 
diff --git a/tools/perf/scripts/perl/bin/rw-by-pid-record b/tools/perf/scripts/perl/bin/rw-by-pid-record
index 6e0b2f7..7cb9db2 100644
--- a/tools/perf/scripts/perl/bin/rw-by-pid-record
+++ b/tools/perf/scripts/perl/bin/rw-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
+perf record -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/rwtop-record b/tools/perf/scripts/perl/bin/rwtop-record
index 6e0b2f7..7cb9db2 100644
--- a/tools/perf/scripts/perl/bin/rwtop-record
+++ b/tools/perf/scripts/perl/bin/rwtop-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
+perf record -e syscalls:sys_enter_read -e syscalls:sys_exit_read -e syscalls:sys_enter_write -e syscalls:sys_exit_write $@
diff --git a/tools/perf/scripts/perl/bin/wakeup-latency-record b/tools/perf/scripts/perl/bin/wakeup-latency-record
index 9f2acaa..464251a 100644
--- a/tools/perf/scripts/perl/bin/wakeup-latency-record
+++ b/tools/perf/scripts/perl/bin/wakeup-latency-record
@@ -1,5 +1,5 @@
 #!/bin/bash
-perf record -a -e sched:sched_switch -e sched:sched_wakeup $@
+perf record -e sched:sched_switch -e sched:sched_wakeup $@
 
 
 
diff --git a/tools/perf/scripts/perl/bin/workqueue-stats-record b/tools/perf/scripts/perl/bin/workqueue-stats-record
index 85301f2..8edda90 100644
--- a/tools/perf/scripts/perl/bin/workqueue-stats-record
+++ b/tools/perf/scripts/perl/bin/workqueue-stats-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
+perf record -e workqueue:workqueue_creation -e workqueue:workqueue_destruction -e workqueue:workqueue_execution -e workqueue:workqueue_insertion $@
diff --git a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
index eb5846b..8104895 100644
--- a/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
+++ b/tools/perf/scripts/python/bin/failed-syscalls-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_exit $@
+perf record -e raw_syscalls:sys_exit $@
diff --git a/tools/perf/scripts/python/bin/futex-contention-record b/tools/perf/scripts/python/bin/futex-contention-record
index 5ecbb43..b1495c9 100644
--- a/tools/perf/scripts/python/bin/futex-contention-record
+++ b/tools/perf/scripts/python/bin/futex-contention-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e syscalls:sys_enter_futex -e syscalls:sys_exit_futex $@
+perf record -e syscalls:sys_enter_futex -e syscalls:sys_exit_futex $@
diff --git a/tools/perf/scripts/python/bin/netdev-times-record b/tools/perf/scripts/python/bin/netdev-times-record
index d931a82..558754b 100644
--- a/tools/perf/scripts/python/bin/netdev-times-record
+++ b/tools/perf/scripts/python/bin/netdev-times-record
@@ -1,5 +1,5 @@
 #!/bin/bash
-perf record -a -e net:net_dev_xmit -e net:net_dev_queue		\
+perf record -e net:net_dev_xmit -e net:net_dev_queue		\
 		-e net:netif_receive_skb -e net:netif_rx		\
 		-e skb:consume_skb -e skb:kfree_skb			\
 		-e skb:skb_copy_datagram_iovec -e napi:napi_poll	\
diff --git a/tools/perf/scripts/python/bin/sched-migration-record b/tools/perf/scripts/python/bin/sched-migration-record
index 17a3e9b..7493fdd 100644
--- a/tools/perf/scripts/python/bin/sched-migration-record
+++ b/tools/perf/scripts/python/bin/sched-migration-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -m 16384 -a -e sched:sched_wakeup -e sched:sched_wakeup_new -e sched:sched_switch -e sched:sched_migrate_task $@
+perf record -m 16384 -e sched:sched_wakeup -e sched:sched_wakeup_new -e sched:sched_switch -e sched:sched_migrate_task $@
diff --git a/tools/perf/scripts/python/bin/sctop-record b/tools/perf/scripts/python/bin/sctop-record
index 1fc5998..4efbfaa 100644
--- a/tools/perf/scripts/python/bin/sctop-record
+++ b/tools/perf/scripts/python/bin/sctop-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_enter $@
+perf record -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
index 1fc5998..4efbfaa 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-by-pid-record
@@ -1,2 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_enter $@
+perf record -e raw_syscalls:sys_enter $@
diff --git a/tools/perf/scripts/python/bin/syscall-counts-record b/tools/perf/scripts/python/bin/syscall-counts-record
index 1fc5998..4efbfaa 100644
--- a/tools/perf/scripts/python/bin/syscall-counts-record
+++ b/tools/perf/scripts/python/bin/syscall-counts-record
@@ -1,3 +1,2 @@
 #!/bin/bash
-perf record -a -e raw_syscalls:sys_enter $@
+perf record -e raw_syscalls:sys_enter $@
-- 
Tom Zanussi, Intel Open Source Technology Center

