Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab0H1PqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:46:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58946 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699Ab0H1PqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:46:20 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH] perf: Remove newline character from perror() argument
Date: Sat, 28 Aug 2010 16:46:19 +0100
Message-Id: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we include a newline character in the string argument to perror()
then the output will be split across two lines like so,

    Unable to read perf file descriptor
    : No space left on device

Deleting the newline character prints a much more readable error,

    Unable to read perf file descriptor: No space left on device

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 tools/perf/builtin-record.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ff77b80..b530bee 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -353,7 +353,7 @@ try_again:
 		}
 
 		if (read(fd[nr_cpu][counter][thread_index], &read_data, sizeof(read_data)) == -1) {
-			perror("Unable to read perf file descriptor\n");
+			perror("Unable to read perf file descriptor");
 			exit(-1);
 		}
 
@@ -626,7 +626,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	nr_cpus = read_cpu_map(cpu_list);
 	if (nr_cpus < 1) {
-		perror("failed to collect number of CPUs\n");
+		perror("failed to collect number of CPUs");
 		return -1;
 	}
 
-- 
1.7.1

