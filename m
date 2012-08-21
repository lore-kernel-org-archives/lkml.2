Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2HUQOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:14:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60806 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab2HUQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:13:53 -0400
Date: Tue, 21 Aug 2012 09:13:32 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-gmq82zp5blin9aml9g5tzokr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add missing files to build the python binding
Git-Commit-ID: a619183672aace2ce3de15728da922d303c0eef9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:13:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a619183672aace2ce3de15728da922d303c0eef9
Gitweb:     http://git.kernel.org/tip/a619183672aace2ce3de15728da922d303c0eef9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 14 Aug 2012 14:17:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Aug 2012 14:17:30 -0300

perf tools: Add missing files to build the python binding

Changeset 0f6a3015:
"perf tools: Support user regs and stack in sample parsing"

uses hweight_long in evsel.c, so we need to drag util/hweight.c
to the python binding.

Ditto for ee8dd3c:
"perf tools: Change strlist to use the new rblist"

where we need to add util/rblist.c.

Now twatch.py works again:

 # export PYTHONPATH=~acme/git/build/perf/python/
 # ~acme/git/linux/tools/perf/python/twatch.py
 cpu:  4, pid: 23639, tid: 23639 { type: fork, pid: 30659, ppid: 23639, tid: 30659, ptid: 23639, time: 36287872076780}
 cpu:  5, pid: 30659, tid: 30659 { type: comm, pid: 30659, tid: 30659, comm: ls }
 cpu:  5, pid: 30659, tid: 30659 { type: exit, pid: 30659, ppid: 30659, tid: 30659, ptid: 30659, time: 36287873681539}
 cpu:  4, pid: 23639, tid: 23639 { type: fork, pid: 30660, ppid: 23639, tid: 30660, ptid: 23639, time: 36291720420480}
 cpu:  5, pid: 30659, tid: 30659 { type: exit, pid: 30659, ppid: 30659, tid: 30659, ptid: 30659, time: 36287873685714}
 cpu:  5, pid: 30660, tid: 30660 { type: comm, pid: 30660, tid: 30660, comm: git }
 ^C
 KeyboardInterrupt

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gmq82zp5blin9aml9g5tzokr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python-ext-sources |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 2884e67..2133628 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -10,10 +10,12 @@ util/ctype.c
 util/evlist.c
 util/evsel.c
 util/cpumap.c
+util/hweight.c
 util/thread_map.c
 util/util.c
 util/xyarray.c
 util/cgroup.c
 util/debugfs.c
+util/rblist.c
 util/strlist.c
 ../../lib/rbtree.c
