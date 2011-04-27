Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab1D0QB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:01:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab1D0QBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:01:24 -0400
Date: Wed, 27 Apr 2011 16:01:03 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-lexrnbzy09asscgd4f7oac4i@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Make all displayed event names parseable as well
Git-Commit-ID: 749141d926faf23ef811686a8050e7cf13dc223f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 16:01:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  749141d926faf23ef811686a8050e7cf13dc223f
Gitweb:     http://git.kernel.org/tip/749141d926faf23ef811686a8050e7cf13dc223f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Apr 2011 04:24:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 Apr 2011 20:04:55 +0200

perf stat: Make all displayed event names parseable as well

Right now we display this by default:

          0.202204 task-clock-msecs         #      0.282 CPUs
                 0 context-switches         #      0.000 M/sec
                 0 CPU-migrations           #      0.000 M/sec
                85 page-faults              #      0.420 M/sec

The task-clock-msecs event cannot actually be passed back as an
event name, the event name we recognize is 'task-clock'.

So change the output of the cpu-clock and task-clock events
to be idempotent.

( Units should be printed out in the right-side column, if needed. )

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-lexrnbzy09asscgd4f7oac4i@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b686269..b5bfef1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -70,8 +70,8 @@ static const char *hw_event_names[] = {
 };
 
 static const char *sw_event_names[] = {
-	"cpu-clock-msecs",
-	"task-clock-msecs",
+	"cpu-clock",
+	"task-clock",
 	"page-faults",
 	"context-switches",
 	"CPU-migrations",
