Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2AaB0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:26:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:44363 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab2AaBYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 9/9] perf python: Use attr.watermark in twatch.py
Date: Mon, 30 Jan 2012 23:24:39 -0200
Message-Id: <1327973079-29426-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We want to be woken up for every PERF_RECORD_ event, attr.wakeup_events
is only for PERF_RECORD_SAMPLE, so also use attr.watermark = 1 to fix
that.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-v3lnpwgrr8mllcr3ntduuqvc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/python/twatch.py |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/python/twatch.py b/tools/perf/python/twatch.py
index df638c4..b11cca5 100755
--- a/tools/perf/python/twatch.py
+++ b/tools/perf/python/twatch.py
@@ -19,7 +19,7 @@ def main():
 	cpus = perf.cpu_map()
 	threads = perf.thread_map()
 	evsel = perf.evsel(task = 1, comm = 1, mmap = 0,
-			   wakeup_events = 1, sample_period = 1,
+			   wakeup_events = 1, watermark = 1,
 			   sample_id_all = 1,
 			   sample_type = perf.SAMPLE_PERIOD | perf.SAMPLE_TID | perf.SAMPLE_CPU | perf.SAMPLE_TID)
 	evsel.open(cpus = cpus, threads = threads);
-- 
1.7.9.rc2.1.g69204

