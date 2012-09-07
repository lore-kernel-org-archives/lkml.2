Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab2IGF7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:59:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54959 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab2IGF7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:59:16 -0400
Date: Thu, 6 Sep 2012 22:58:59 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-fceda7feb4a7822feee9662bc64968230d8f37bf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346005487-62961-5-git-send-email-dsahern@gmail.com>
References: <1346005487-62961-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Remove use of die/
 exit and handle errors
Git-Commit-ID: fceda7feb4a7822feee9662bc64968230d8f37bf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 22:59:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fceda7feb4a7822feee9662bc64968230d8f37bf
Gitweb:     http://git.kernel.org/tip/fceda7feb4a7822feee9662bc64968230d8f37bf
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 26 Aug 2012 12:24:44 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:20:24 -0300

perf stat: Remove use of die/exit and handle errors

Allows perf to clean up properly on program termination.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d53d8ab..02f49eb 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -428,7 +428,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
-		exit(1);
+		return -1;
 	}
 
 	if (forks) {
@@ -510,7 +510,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 			}
 			if (child_pid != -1)
 				kill(child_pid, SIGTERM);
-			die("Not all events could be opened.\n");
+
+			pr_err("Not all events could be opened.\n");
 			return -1;
 		}
 		counter->supported = true;
@@ -1189,7 +1190,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		output = fopen(output_name, mode);
 		if (!output) {
 			perror("failed to create output file");
-			exit(-1);
+			return -1;
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
