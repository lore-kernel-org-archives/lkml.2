Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab0J0LBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:01:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:45543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0J0LBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:01:40 -0400
Date: Wed, 27 Oct 2010 11:01:05 GMT
From: tip-bot for Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, matt@console-pimps.org, tglx@linutronix.de,
        acme@felicio.ghostprotocols.net, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        fweisbec@gmail.com, matt@console-pimps.org, tglx@linutronix.de,
        acme@felicio.ghostprotocols.net, mingo@elte.hu
In-Reply-To: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org>
References: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Remove newline character from perror() argument
Message-ID: <tip-0ab7368f8dad561b6164b3e942cab00f9565bd37@git.kernel.org>
Git-Commit-ID: 0ab7368f8dad561b6164b3e942cab00f9565bd37
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 11:01:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ab7368f8dad561b6164b3e942cab00f9565bd37
Gitweb:     http://git.kernel.org/tip/0ab7368f8dad561b6164b3e942cab00f9565bd37
Author:     Matt Fleming <matt@console-pimps.org>
AuthorDate: Sat, 28 Aug 2010 16:46:19 +0100
Committer:  Arnaldo Carvalho de Melo <acme@felicio.ghostprotocols.net>
CommitDate: Tue, 26 Oct 2010 13:03:09 -0200

perf record: Remove newline character from perror() argument

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
 
