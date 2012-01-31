Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab2AaNXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:23:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2AaNXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:23:36 -0500
Date: Tue, 31 Jan 2012 05:23:18 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-v3lnpwgrr8mllcr3ntduuqvc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Use attr.watermark in twatch.py
Git-Commit-ID: cfeb1d90a1b1db96383b48888cb7a5f10ca12e12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:23:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfeb1d90a1b1db96383b48888cb7a5f10ca12e12
Gitweb:     http://git.kernel.org/tip/cfeb1d90a1b1db96383b48888cb7a5f10ca12e12
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 30 Jan 2012 14:43:21 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 18:38:23 -0200

perf python: Use attr.watermark in twatch.py

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
