Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1BIAnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:43:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:41010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab1BIAnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:43:21 -0500
Date: Wed, 9 Feb 2011 00:42:52 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix --stdio rendering
Message-ID: <tip-e3087b80aa0bceda9863f33307460f3ba79f2b15@git.kernel.org>
Git-Commit-ID: e3087b80aa0bceda9863f33307460f3ba79f2b15
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Feb 2011 00:42:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3087b80aa0bceda9863f33307460f3ba79f2b15
Gitweb:     http://git.kernel.org/tip/e3087b80aa0bceda9863f33307460f3ba79f2b15
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 8 Feb 2011 15:01:39 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 8 Feb 2011 15:01:39 -0200

perf annotate: Fix --stdio rendering

The checks for not using a max_lines parameter were b0rked, problem
introduced in 3653246.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 1012841..6db4351 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -132,7 +132,7 @@ static int objdump_line__print(struct objdump_line *oline,
 		if (percent < min_pcnt)
 			return -1;
 
-		if (printed >= max_lines)
+		if (max_lines && printed >= max_lines)
 			return 1;
 
 		color = get_percent_color(percent);
@@ -154,7 +154,7 @@ static int objdump_line__print(struct objdump_line *oline,
 		color_fprintf(stdout, color, " %7.2f", percent);
 		printf(" :	");
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", oline->line);
-	} else if (printed >= max_lines)
+	} else if (max_lines && printed >= max_lines)
 		return 1;
 	else {
 		if (!*oline->line)
