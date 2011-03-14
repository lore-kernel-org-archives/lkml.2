Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1CNPnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:43:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60881 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1CNPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EWW5t6OCwYJNSk55r+H72vb+5o3BYRwFwEC4rr4YPX3OTesWF3g8dS0LP/cjzC7JuN
         QydM4z3SXK1G96oTazsAqOfqrPRw4EESmTe7x+0S/EHem17zcS1XsUcAOpiVZUKoACEe
         jqzCbZWi1Z4BvFUyKL1O/kihSACz/PhmY1IO4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf: Provide support for filters in perf stat
Date: Mon, 14 Mar 2011 16:40:30 +0100
Message-Id: <1300117230-8404-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the --filter option is usable with perf stat too.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 21c0252..e2109f9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -333,6 +333,12 @@ static int run_perf_stat(int argc __used, const char **argv)
 		}
 	}
 
+	if (perf_evlist__set_filters(evsel_list)) {
+		error("failed to set filter with %d (%s)\n", errno,
+			strerror(errno));
+		return -1;
+	}
+
 	/*
 	 * Enable counters and exec the command:
 	 */
@@ -634,6 +640,8 @@ static const struct option options[] = {
 	OPT_CALLBACK('e', "event", &evsel_list, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events),
+	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
+		     "event filter", parse_filter),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
 	OPT_INTEGER('p', "pid", &target_pid,
-- 
1.7.3.2

