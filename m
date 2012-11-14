Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2KNGxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:53:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2KNGxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:53:11 -0500
Date: Tue, 13 Nov 2012 22:52:42 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-bf779746f928de99eba84de0a72a5bbfa87ca680@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-5-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record basic test
Git-Commit-ID: bf779746f928de99eba84de0a72a5bbfa87ca680
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:52:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf779746f928de99eba84de0a72a5bbfa87ca680
Gitweb:     http://git.kernel.org/tip/bf779746f928de99eba84de0a72a5bbfa87ca680
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:45 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 1 Nov 2012 17:00:31 -0300

perf tests: Add attr record basic test

Adding test to validate perf_event_attr data for command:
  'record'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-record       |   40 +++++++++++++++++++++++++++++++
 tools/perf/tests/attr/test-record-basic |    5 ++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
new file mode 100644
index 0000000..07beef5
--- /dev/null
+++ b/tools/perf/tests/attr/base-record
@@ -0,0 +1,40 @@
+[event]
+fd=1
+group_fd=-1
+flags=0
+type=0|1
+size=96
+config=0
+sample_period=4000
+sample_type=263
+read_format=7
+disabled=1
+inherit=1
+pinned=0
+exclusive=0
+exclude_user=0
+exclude_kernel=0
+exclude_hv=0
+exclude_idle=0
+mmap=1
+comm=1
+freq=1
+inherit_stat=0
+enable_on_exec=1
+task=0
+watermask=0
+precise_ip=0
+mmap_data=0
+sample_id_all=1
+exclude_host=0
+exclude_guest=1
+exclude_callchain_kernel=0
+exclude_callchain_user=0
+wakeup_events=0
+bp_type=0
+config1=0
+config2=0
+branch_sample_type=0
+sample_regs_user=0
+sample_stack_user=0
+optional=0
diff --git a/tools/perf/tests/attr/test-record-basic b/tools/perf/tests/attr/test-record-basic
new file mode 100644
index 0000000..55c0428
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-basic
@@ -0,0 +1,5 @@
+[config]
+command = record
+args    = kill >/dev/null 2>&1
+
+[event:base-record]
