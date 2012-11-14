Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab2KNH0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:26:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44041 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2KNH0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:26:11 -0500
Date: Tue, 13 Nov 2012 23:25:12 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-df4c6de857774252702acc20d4b0eddb329d8808@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1352130579-13451-2-git-send-email-jolsa@redhat.com>
References: <1352130579-13451-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add missing attr stat basic test
Git-Commit-ID: df4c6de857774252702acc20d4b0eddb329d8808
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:25:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df4c6de857774252702acc20d4b0eddb329d8808
Gitweb:     http://git.kernel.org/tip/df4c6de857774252702acc20d4b0eddb329d8808
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 5 Nov 2012 16:49:36 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:59 -0300

perf tests: Add missing attr stat basic test

Adding test to validate perf_event_attr data for command:
  'stat -e cycles'

Reported-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352130579-13451-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/{base-record => base-stat}   |   16 ++++++++--------
 .../attr/{test-stat-no-inherit => test-stat-basic} |    3 +--
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-stat
similarity index 81%
copy from tools/perf/tests/attr/base-record
copy to tools/perf/tests/attr/base-stat
index 07beef5..6e1bb8e 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-stat
@@ -2,12 +2,12 @@
 fd=1
 group_fd=-1
 flags=0
-type=0|1
+type=0
 size=96
 config=0
-sample_period=4000
-sample_type=263
-read_format=7
+sample_period=0
+sample_type=0
+read_format=3
 disabled=1
 inherit=1
 pinned=0
@@ -16,16 +16,16 @@ exclude_user=0
 exclude_kernel=0
 exclude_hv=0
 exclude_idle=0
-mmap=1
-comm=1
-freq=1
+mmap=0
+comm=0
+freq=0
 inherit_stat=0
 enable_on_exec=1
 task=0
 watermask=0
 precise_ip=0
 mmap_data=0
-sample_id_all=1
+sample_id_all=0
 exclude_host=0
 exclude_guest=1
 exclude_callchain_kernel=0
diff --git a/tools/perf/tests/attr/test-stat-no-inherit b/tools/perf/tests/attr/test-stat-basic
similarity index 50%
copy from tools/perf/tests/attr/test-stat-no-inherit
copy to tools/perf/tests/attr/test-stat-basic
index d54b2a1e..74e1788 100644
--- a/tools/perf/tests/attr/test-stat-no-inherit
+++ b/tools/perf/tests/attr/test-stat-basic
@@ -1,7 +1,6 @@
 [config]
 command = stat
-args    = -i -e cycles kill >/dev/null 2>&1
+args    = -e cycles kill >/dev/null 2>&1
 ret     = 1
 
 [event:base-stat]
-inherit=0
