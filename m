Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1HRUK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:10:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46744 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1HRUK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:10:27 -0400
Date: Thu, 18 Aug 2011 20:10:08 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-77e57297b4ff3f602ba5105398d342a4b4a54774@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110523123917.GA31060@quad>
References: <20110523123917.GA31060@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list: Fix exit value
Git-Commit-ID: 77e57297b4ff3f602ba5105398d342a4b4a54774
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:10:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77e57297b4ff3f602ba5105398d342a4b4a54774
Gitweb:     http://git.kernel.org/tip/77e57297b4ff3f602ba5105398d342a4b4a54774
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 23 May 2011 14:39:17 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:19:15 -0300

perf list: Fix exit value

This patch fixes an issue with the exit value of perf list:

$ perf list; echo $?
129

perf list returns an error exit code even though there is no error.

There was a stray exit(129) in print_events(). This patch removes this
exit().

$ perf list; echo $?
0

$ perf list hw sw
  cpu-cycles OR cycles                               [Hardware event]
  stalled-cycles-frontend OR idle-cycles-frontend    [Hardware event]
  stalled-cycles-backend OR idle-cycles-backend      [Hardware event]
  instructions                                       [Hardware event]
  cache-references                                   [Hardware event]
  cache-misses                                       [Hardware event]
  branch-instructions OR branches                    [Hardware event]
  branch-misses                                      [Hardware event]
  bus-cycles                                         [Hardware event]

  cpu-clock                                          [Software event]
  task-clock                                         [Software event]
  page-faults OR faults                              [Software event]
  minor-faults                                       [Software event]
  major-faults                                       [Software event]
  context-switches OR cs                             [Software event]
  cpu-migrations OR migrations                       [Software event]
  alignment-faults                                   [Software event]
  emulation-faults                                   [Software event]
$ echo $?
0

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20110523123917.GA31060@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4ea7e19..d93f3ce 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1097,6 +1097,4 @@ void print_events(const char *event_glob)
 	printf("\n");
 
 	print_tracepoint_events(NULL, NULL);
-
-	exit(129);
 }
