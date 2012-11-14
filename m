Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab2KNHWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:22:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305Ab2KNHWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:22:31 -0500
Date: Tue, 13 Nov 2012 23:21:10 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-b84800a31502ab75c0032192de01e61a0d517f38@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-26-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-26-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add documentation for attr tests
Git-Commit-ID: b84800a31502ab75c0032192de01e61a0d517f38
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:21:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b84800a31502ab75c0032192de01e61a0d517f38
Gitweb:     http://git.kernel.org/tip/b84800a31502ab75c0032192de01e61a0d517f38
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:02:06 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:58 -0300

perf tests: Add documentation for attr tests

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
 1 files changed, 64 insertions(+), 0 deletions(-)

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
