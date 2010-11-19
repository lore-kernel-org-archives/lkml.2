Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0KSVaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:30:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:45795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab0KSVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:30:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@felicio.ghostprotocols.net>
Subject: [PATCH 1/4] perf record: Remove newline character from perror() argument
Date: Fri, 19 Nov 2010 19:29:40 -0200
Message-Id: <1290202186-25352-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290202186-25352-1-git-send-email-acme@infradead.org>
References: <1290202186-25352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt@console-pimps.org>

If we include a newline character in the string argument to perror()
then the output will be split across two lines like so,

    Unable to read perf file descriptor
    : No space left on device

Deleting the newline character prints a much more readable error,

    Unable to read perf file descriptor: No space left on device

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org>
Signed-off-by: Matt Fleming <matt@console-pimps.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@felicio.ghostprotocols.net>
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
1.6.2.5

