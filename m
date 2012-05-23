Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab2EWPZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:25:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2EWPZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:25:08 -0400
Date: Wed, 23 May 2012 08:24:49 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-e40ee742d4542b4c046ac5426654b1494d87ad73@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1337564527-9367-1-git-send-email-namhyung.kim@lge.com>
References: <1337564527-9367-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target:
  Add cpu flag to sample_type if target has cpu
Git-Commit-ID: e40ee742d4542b4c046ac5426654b1494d87ad73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:24:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e40ee742d4542b4c046ac5426654b1494d87ad73
Gitweb:     http://git.kernel.org/tip/e40ee742d4542b4c046ac5426654b1494d87ad73
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 21 May 2012 10:42:07 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:37:12 -0300

perf target: Add cpu flag to sample_type if target has cpu

Add PERF_SAMPLE_CPU flag into attr->sample_type if an user specified any
of cpu target (either system-wide or cpu list).

It will show correct values when cpu sort key is given for perf top and
perf report.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337564527-9367-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    3 +++
 tools/perf/util/evsel.c  |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3e981a7..18bd226 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -900,6 +900,9 @@ static void perf_top__start_counters(struct perf_top *top)
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
+		if (perf_target__has_cpu(&top->target))
+			attr->sample_type |= PERF_SAMPLE_CPU;
+
 		if (symbol_conf.use_callchain)
 			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f4f427c..9abd8ac 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -108,7 +108,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	if (opts->call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (opts->target.system_wide)
+	if (perf_target__has_cpu(&opts->target))
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
 	if (opts->period)
