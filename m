Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab2IEXJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51598 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750Ab2IEXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/17] perf stat: Remove use of die/exit and handle errors
Date: Wed,  5 Sep 2012 20:08:45 -0300
Message-Id: <1346886537-11621-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
-- 
1.7.1

