Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2KNH15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:27:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2KNH1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:27:55 -0500
Date: Tue, 13 Nov 2012 23:27:11 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-45e4089bc6398da2cf0609b614bc519970cb8442@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1352130579-13451-4-git-send-email-jolsa@redhat.com>
References: <1352130579-13451-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix attr watermark field name typo
Git-Commit-ID: 45e4089bc6398da2cf0609b614bc519970cb8442
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:27:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45e4089bc6398da2cf0609b614bc519970cb8442
Gitweb:     http://git.kernel.org/tip/45e4089bc6398da2cf0609b614bc519970cb8442
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 5 Nov 2012 16:49:38 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:59 -0300

perf tests: Fix attr watermark field name typo

Currently the 'watermark' field is coded as 'watermask'.

As the type is global through the framework and tests, the typo spawned
no error.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352130579-13451-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c           |    2 +-
 tools/perf/tests/attr.py          |    2 +-
 tools/perf/tests/attr/base-record |    2 +-
 tools/perf/tests/attr/base-stat   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 1389d69..6fa84b7 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -110,7 +110,7 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	WRITE_ASS(inherit_stat,   "d");
 	WRITE_ASS(enable_on_exec, "d");
 	WRITE_ASS(task,           "d");
-	WRITE_ASS(watermask,      "d");
+	WRITE_ASS(watermark,      "d");
 	WRITE_ASS(precise_ip,     "d");
 	WRITE_ASS(mmap_data,      "d");
 	WRITE_ASS(sample_id_all,  "d");
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index e98c726..28c0481 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -45,7 +45,7 @@ class Event(dict):
         'inherit_stat',
         'enable_on_exec',
         'task',
-        'watermask',
+        'watermark',
         'precise_ip',
         'mmap_data',
         'sample_id_all',
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index 07beef5..8262794 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -22,7 +22,7 @@ freq=1
 inherit_stat=0
 enable_on_exec=1
 task=0
-watermask=0
+watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=1
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 6e1bb8e..46f8851 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -22,7 +22,7 @@ freq=0
 inherit_stat=0
 enable_on_exec=1
 task=0
-watermask=0
+watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=0
