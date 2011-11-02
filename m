Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1KBXAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:00:40 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3428 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab1KBW7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:59:52 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH 4/4] perf: add scripts for profiling sleep times
Date: Thu,  3 Nov 2011 01:59:44 +0300
Message-Id: <1320274784-2463901-5-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1320274784-2463901-1-git-send-email-avagin@openvz.org>
References: <1320274784-2463901-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

E.g.:
 # ./perf script record sched-stat -- -e sched:sched_stat_sleep &
 # ./foo;
 # killall -SIGINT perf
 ./perf script report sched-stat

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 tools/perf/scripts/python/bin/sched-stat-record |    2 ++
 tools/perf/scripts/python/bin/sched-stat-report |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-report

diff --git a/tools/perf/scripts/python/bin/sched-stat-record b/tools/perf/scripts/python/bin/sched-stat-record
new file mode 100644
index 0000000..b9873d9
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sched-stat-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -ag -e sched:sched_switch --filter "prev_state == 1 || prev_state == 2" -e sched:sched_process_exit ${@/--/}
diff --git a/tools/perf/scripts/python/bin/sched-stat-report b/tools/perf/scripts/python/bin/sched-stat-report
new file mode 100644
index 0000000..d225a37
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sched-stat-report
@@ -0,0 +1,6 @@
+#!/bin/bash
+# description: profiling sleep times
+# args: -e sched:sched_stat_[smth]
+perf inject -s -i perf.data -o perf.data.d || exit
+perf report -i perf.data.d || exit
+unlink perf.data.d
-- 
1.7.1

