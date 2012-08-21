Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2HUOjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 10:39:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:45731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2HUOjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 10:39:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/1] perf tools: Add missing files to build the python binding
Date: Tue, 21 Aug 2012 11:39:21 -0300
Message-Id: <1345559961-7964-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345559961-7964-1-git-send-email-acme@infradead.org>
References: <1345559961-7964-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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

Reported-by: Jérôme Carretero <cJ-ko@zougloub.eu>
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
 1 file changed, 2 insertions(+)

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
-- 
1.7.9.2.358.g22243

