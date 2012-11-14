Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2KNG4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:56:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2KNG4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:56:09 -0500
Date: Tue, 13 Nov 2012 22:55:45 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-76062f61ff934ac9f22183c10494228852d26d47@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-7-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-7-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add attr record event syntax group test
Git-Commit-ID: 76062f61ff934ac9f22183c10494228852d26d47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:55:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  76062f61ff934ac9f22183c10494228852d26d47
Gitweb:     http://git.kernel.org/tip/76062f61ff934ac9f22183c10494228852d26d47
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:47 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 1 Nov 2012 17:06:48 -0300

perf tests: Add attr record event syntax group test

Adding test to validate perf_event_attr data for command:
  'record group -e {cycles,instructions}'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-group1 |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr/test-record-group1 b/tools/perf/tests/attr/test-record-group1
new file mode 100644
index 0000000..39bf860
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-group1
@@ -0,0 +1,20 @@
+[config]
+command = record
+args    = -e '{cycles,instructions}' kill >/tmp/krava 2>&1
+
+[event-1:base-record]
+fd=1
+group_fd=-1
+sample_type=327
+
+[event-2:base-record]
+fd=2
+group_fd=1
+type=0
+config=1
+sample_type=327
+mmap=0
+comm=0
+# TODO this is disabled for --group option, enabled otherwise
+#      check why..
+enable_on_exec=1
