Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665Ab2C3QKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:10:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42825 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761056Ab2C3QJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:09:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 7/9] perf tools: Add missing ref-cycles event back to event parser
Date: Fri, 30 Mar 2012 13:09:22 -0300
Message-Id: <1333123764-15662-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333123764-15662-1-git-send-email-acme@infradead.org>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 89812fc81f8d ("perf tools: Add parser generator for events
parsing") changed event parsing engine but missed the ref-cycles event.
Add it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333016517-10591-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.l |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index ab9eca1..05d766e 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -67,6 +67,7 @@ cache-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_CACHE_MISSES); }
 branch-instructions|branches			{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_INSTRUCTIONS); }
 branch-misses					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BRANCH_MISSES); }
 bus-cycles					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_BUS_CYCLES); }
+ref-cycles					{ return sym(PERF_TYPE_HARDWARE, PERF_COUNT_HW_REF_CPU_CYCLES); }
 cpu-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_CPU_CLOCK); }
 task-clock					{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_TASK_CLOCK); }
 page-faults|faults				{ return sym(PERF_TYPE_SOFTWARE, PERF_COUNT_SW_PAGE_FAULTS); }
-- 
1.7.9.2.358.g22243

