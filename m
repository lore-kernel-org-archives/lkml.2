Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab1D0QA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:00:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59399 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772Ab1D0QAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:00:25 -0400
Date: Wed, 27 Apr 2011 16:00:12 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-omcm3edjjtx83a4kh2e244se@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf tools: Accept case-insensitive symbolic event variants
Git-Commit-ID: b908debd4eef91471016138569f7a9e292be682e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:00:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b908debd4eef91471016138569f7a9e292be682e
Gitweb:     http://git.kernel.org/tip/b908debd4eef91471016138569f7a9e292be682e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 03:55:40 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:55 +0200

perf tools: Accept case-insensitive symbolic event variants

We currently fail on something like '-e CPU-migrations', with:

  invalid or unsupported event: 'CPU-migrations'

While 'CPU-migrations' is how we actually print out the event
in the default perf stat output:

 Performance counter stats for 'true':

          0.202204 task-clock-msecs         #      0.282 CPUs
                 0 context-switches         #      0.000 M/sec
                 0 CPU-migrations           #      0.000 M/sec

So change the matching to be case-insensitive.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-omcm3edjjtx83a4kh2e244se@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1869e4c..8e54bdb 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -649,13 +649,15 @@ static int check_events(const char *str, unsigned int i)
 	int n;
 
 	n = strlen(event_symbols[i].symbol);
-	if (!strncmp(str, event_symbols[i].symbol, n))
+	if (!strncasecmp(str, event_symbols[i].symbol, n))
 		return n;
 
 	n = strlen(event_symbols[i].alias);
-	if (n)
-		if (!strncmp(str, event_symbols[i].alias, n))
+	if (n) {
+		if (!strncasecmp(str, event_symbols[i].alias, n))
 			return n;
+	}
+
 	return 0;
 }
 
