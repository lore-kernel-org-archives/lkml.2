Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2HZS0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:26:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2HZSZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:25:02 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 4/7] perf stat: remove use of die/exit and handle errors
Date: Sun, 26 Aug 2012 12:24:44 -0600
Message-Id: <1346005487-62961-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1346005487-62961-1-git-send-email-dsahern@gmail.com>
References: <1346005487-62961-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows perf to clean up properly on program termination.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-stat.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
-- 
1.7.10.1

