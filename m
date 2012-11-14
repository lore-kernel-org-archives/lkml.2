Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab2KNHRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:17:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2KNHRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:17:33 -0500
Date: Tue, 13 Nov 2012 23:16:59 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-a6d3476c58763b35104d815757faed5bdf040cea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-21-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-21-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr stat group test
Git-Commit-ID: a6d3476c58763b35104d815757faed5bdf040cea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:17:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6d3476c58763b35104d815757faed5bdf040cea
Gitweb:     http://git.kernel.org/tip/a6d3476c58763b35104d815757faed5bdf040cea
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:02:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:02:37 -0300

perf tests: Add attr stat group test

Adding test to validate perf_event_attr data for command:
  'stat --group -e cycles,instructions'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-21-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../attr/{test-record-group => test-stat-group}    |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/attr/test-record-group b/tools/perf/tests/attr/test-stat-group
similarity index 55%
copy from tools/perf/tests/attr/test-record-group
copy to tools/perf/tests/attr/test-stat-group
index b945f77..fdc1596 100644
--- a/tools/perf/tests/attr/test-record-group
+++ b/tools/perf/tests/attr/test-stat-group
@@ -1,17 +1,15 @@
 [config]
-command = record
+command = stat
 args    = --group -e cycles,instructions kill >/dev/null 2>&1
+ret     = 1
 
-[event-1:base-record]
+[event-1:base-stat]
 fd=1
 group_fd=-1
-sample_type=327
 
-[event-2:base-record]
+[event-2:base-stat]
 fd=2
 group_fd=1
 config=1
-sample_type=327
-mmap=0
-comm=0
+disabled=0
 enable_on_exec=0
