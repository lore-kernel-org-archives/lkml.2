Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab1LFJrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:47:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:46:59 -0500
Date: Tue, 6 Dec 2011 01:46:34 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-yv4o74vh90suyghccgykbnry@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove superfluous arguments
Git-Commit-ID: 1d9b482e78d3b16f97f85a82849f82db7eed3102
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:46:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d9b482e78d3b16f97f85a82849f82db7eed3102
Gitweb:     http://git.kernel.org/tip/1d9b482e78d3b16f97f85a82849f82db7eed3102
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 23 Nov 2011 12:34:20 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:33:59 +0100

perf: Remove superfluous arguments

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-yv4o74vh90suyghccgykbnry@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b3fed52..eeda540 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1667,8 +1667,7 @@ retry:
  * Note: this works for group members as well as group leaders
  * since the non-leader members' sibling_lists will be empty.
  */
-static void __perf_event_mark_enabled(struct perf_event *event,
-					struct perf_event_context *ctx)
+static void __perf_event_mark_enabled(struct perf_event *event)
 {
 	struct perf_event *sub;
 	u64 tstamp = perf_event_time(event);
@@ -1706,7 +1705,7 @@ static int __perf_event_enable(void *info)
 	 */
 	perf_cgroup_set_timestamp(current, ctx);
 
-	__perf_event_mark_enabled(event, ctx);
+	__perf_event_mark_enabled(event);
 
 	if (!event_filter_match(event)) {
 		if (is_cgroup_event(event))
@@ -1787,7 +1786,7 @@ void perf_event_enable(struct perf_event *event)
 
 retry:
 	if (!ctx->is_active) {
-		__perf_event_mark_enabled(event, ctx);
+		__perf_event_mark_enabled(event);
 		goto out;
 	}
 
@@ -2466,7 +2465,7 @@ static int event_enable_on_exec(struct perf_event *event,
 	if (event->state >= PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	__perf_event_mark_enabled(event, ctx);
+	__perf_event_mark_enabled(event);
 
 	return 1;
 }
