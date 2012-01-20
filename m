Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2ATBEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:04:44 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61987 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2ATBEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:04:42 -0500
X-AuditID: 9c93016f-b7c20ae000005067-70-4f18bd611682
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf: Call perf_cgroup_event_time directly
Date: Fri, 20 Jan 2012 10:12:46 +0900
Message-Id: <1327021966-27688-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9.rc1.dirty
In-Reply-To: <1327021966-27688-1-git-send-email-namhyung.kim@lge.com>
References: <1327021966-27688-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event_time() will call perf_cgroup_event_time()
if @event is a cgroup event. Just do it directly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/events/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a8f4ac001a00..32b48c889711 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -815,7 +815,7 @@ static void update_event_times(struct perf_event *event)
 	 * here.
 	 */
 	if (is_cgroup_event(event))
-		run_end = perf_event_time(event);
+		run_end = perf_cgroup_event_time(event);
 	else if (ctx->is_active)
 		run_end = ctx->time;
 	else
-- 
1.7.9.rc1.dirty

