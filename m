Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238Ab2J3WDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934869Ab2J3WDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 25/25] perf tests: Add documentation for attr tests
Date: Tue, 30 Oct 2012 23:02:06 +0100
Message-Id: <1351634526-1516-26-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding documentation for attr tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/README | 64 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 tools/perf/tests/attr/README

diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
new file mode 100644
index 0000000..d102957
--- /dev/null
+++ b/tools/perf/tests/attr/README
@@ -0,0 +1,64 @@
+The struct perf_event_attr test (attr tests) support
+====================================================
+This testing support is embedded into perf directly and is governed
+by the PERF_TEST_ATTR environment variable and hook inside the
+sys_perf_event_open function.
+
+The general idea is to store 'struct perf_event_attr' details for
+each event created within single perf command. Each event details
+are stored into separate text file. Once perf command is finished
+these files are checked for values we expect for command.
+
+The attr tests consist of following parts:
+
+tests/attr.c
+------------
+This is the sys_perf_event_open hook implementation. The hook
+is triggered when the PERF_TEST_ATTR environment variable is
+defined. It must contain name of existing directory with access
+and write permissions.
+
+For each sys_perf_event_open call event details are stored in
+separate file. Besides 'struct perf_event_attr' values we also
+store 'fd' and 'group_fd' values to allow checking for groups.
+
+tests/attr.py
+-------------
+This is the python script that does all the hard work. It reads
+the test definition, executes it and checks results.
+
+tests/attr/
+-----------
+Directory containing all attr test definitions.
+Following tests are defined (with perf commands):
+
+  perf record kill                              (test-record-basic)
+  perf record -b kill                           (test-record-branch-any)
+  perf record -j any kill                       (test-record-branch-filter-any)
+  perf record -j any_call kill                  (test-record-branch-filter-any_call)
+  perf record -j any_ret kill                   (test-record-branch-filter-any_ret)
+  perf record -j hv kill                        (test-record-branch-filter-hv)
+  perf record -j ind_call kill                  (test-record-branch-filter-ind_call)
+  perf record -j k kill                         (test-record-branch-filter-k)
+  perf record -j u kill                         (test-record-branch-filter-u)
+  perf record -c 123 kill                       (test-record-count)
+  perf record -d kill                           (test-record-data)
+  perf record -F 100 kill                       (test-record-freq)
+  perf record -g -- kill                        (test-record-graph-default)
+  perf record -g dwarf -- kill                  (test-record-graph-dwarf)
+  perf record -g fp kill                        (test-record-graph-fp)
+  perf record --group -e cycles,instructions kill (test-record-group)
+  perf record -e '{cycles,instructions}' kill   (test-record-group1)
+  perf record -D kill                           (test-record-no-delay)
+  perf record -i kill                           (test-record-no-inherit)
+  perf record -n kill                           (test-record-no-samples)
+  perf record -c 100 -P kill                    (test-record-period)
+  perf record -R kill                           (test-record-raw)
+  perf stat -e cycles kill                      (test-stat-basic)
+  perf stat kill                                (test-stat-default)
+  perf stat -d kill                             (test-stat-detailed-1)
+  perf stat -dd kill                            (test-stat-detailed-2)
+  perf stat -ddd kill                           (test-stat-detailed-3)
+  perf stat --group -e cycles,instructions kill (test-stat-group)
+  perf stat -e '{cycles,instructions}' kill     (test-stat-group1)
+  perf stat -i -e cycles kill                   (test-stat-no-inherit)
-- 
1.7.11.7

