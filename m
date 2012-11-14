Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2KNHS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:18:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2KNHS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:18:27 -0500
Date: Tue, 13 Nov 2012 23:18:00 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-28ae79cfb622cf471d45f1b3f38609d8766e8a95@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-22-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-22-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr stat event syntax group test
Git-Commit-ID: 28ae79cfb622cf471d45f1b3f38609d8766e8a95
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:18:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28ae79cfb622cf471d45f1b3f38609d8766e8a95
Gitweb:     http://git.kernel.org/tip/28ae79cfb622cf471d45f1b3f38609d8766e8a95
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:02:02 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:57 -0300

perf tests: Add attr stat event syntax group test

Adding test to validate perf_event_attr data for command:
  'stat -e {cycles,instructions}'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-22-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-stat-group1 |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr/test-stat-group1 b/tools/perf/tests/attr/test-stat-group1
new file mode 100644
index 0000000..5ae2718
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-group1
@@ -0,0 +1,17 @@
+[config]
+command = stat
+args    = -e '{cycles,instructions}' kill >/dev/null 2>&1
+ret     = 1
+
+[event-1:base-stat]
+fd=1
+group_fd=-1
+
+[event-2:base-stat]
+fd=2
+group_fd=1
+config=1
+# TODO both disabled and enable_on_exec are disabled for --group option,
+#      enabled otherwise, check why..
+disabled=1
+enable_on_exec=1
