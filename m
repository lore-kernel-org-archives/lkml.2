Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1CPNyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:54:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:33008 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab1CPNxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:53:54 -0400
Date: Wed, 16 Mar 2011 13:53:22 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1300117230-8404-1-git-send-email-fweisbec@gmail.com>
References: <1300117230-8404-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat: Provide support for filters
Message-ID: <tip-cfd748ae066e776d45bdce550b47cd00c67d55de@git.kernel.org>
Git-Commit-ID: cfd748ae066e776d45bdce550b47cd00c67d55de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 13:53:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfd748ae066e776d45bdce550b47cd00c67d55de
Gitweb:     http://git.kernel.org/tip/cfd748ae066e776d45bdce550b47cd00c67d55de
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 14 Mar 2011 16:40:30 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Mar 2011 13:37:52 -0300

perf stat: Provide support for filters

Now the --filter option is usable with perf stat too.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1300117230-8404-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
