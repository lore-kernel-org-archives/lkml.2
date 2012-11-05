Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab2KERZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:25:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:33360 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab2KERSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/32] perf tests: Add documentation for attr tests
Date: Mon,  5 Nov 2012 14:18:06 -0300
Message-Id: <1352135893-7564-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding documentation for attr tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-26-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/README |   64 ++++++++++++++++++++++++++++++++++++++++++
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
1.7.9.2.358.g22243

