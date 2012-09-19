Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2ISPXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:23:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab2ISPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:23:45 -0400
Date: Wed, 19 Sep 2012 08:23:15 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-59cbea229473350168930941986ebe5bf685cc23@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1347007349-3102-4-git-send-email-feng.tang@intel.com>
References: <1347007349-3102-4-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf scripts: Add event_analyzing_sample-record/
 report
Git-Commit-ID: 59cbea229473350168930941986ebe5bf685cc23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:23:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59cbea229473350168930941986ebe5bf685cc23
Gitweb:     http://git.kernel.org/tip/59cbea229473350168930941986ebe5bf685cc23
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Fri, 7 Sep 2012 16:42:25 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:11:15 -0300

perf scripts: Add event_analyzing_sample-record/report

So that event_analyzing_sample.py can be shown by "perf script -l"

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347007349-3102-4-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../python/bin/event_analyzing_sample-record       |    8 ++++++++
 .../python/bin/event_analyzing_sample-report       |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/scripts/python/bin/event_analyzing_sample-record b/tools/perf/scripts/python/bin/event_analyzing_sample-record
new file mode 100644
index 0000000..5ce652d
--- /dev/null
+++ b/tools/perf/scripts/python/bin/event_analyzing_sample-record
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+#
+# event_analyzing_sample.py can cover all type of perf samples including
+# the tracepoints, so no special record requirements, just record what
+# you want to analyze.
+#
+perf record $@
diff --git a/tools/perf/scripts/python/bin/event_analyzing_sample-report b/tools/perf/scripts/python/bin/event_analyzing_sample-report
new file mode 100644
index 0000000..0941fc9
--- /dev/null
+++ b/tools/perf/scripts/python/bin/event_analyzing_sample-report
@@ -0,0 +1,3 @@
+#!/bin/bash
+# description: analyze all perf samples
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/event_analyzing_sample.py
