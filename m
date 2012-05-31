Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2EaFyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:54:24 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54050 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2EaFyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:54:22 -0400
X-AuditID: 9c93016f-b7c3cae000001954-02-4fc7078c0d15
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] perf: Remove duplicate invocation on perf_event_for_each
Date: Thu, 31 May 2012 14:51:44 +0900
Message-Id: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @func callback was invoked twice for group leader
when perf_event_for_each() called. It seems the commit
75f937f24bd9 ("perf_counter: Fix ctx->mutex vs counter
->mutex inversion") made the mistake during the change.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 kernel/events/core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5b06cbbf6931..f85c0154b333 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3181,7 +3181,6 @@ static void perf_event_for_each(struct perf_event *event,
 	event = event->group_leader;
 
 	perf_event_for_each_child(event, func);
-	func(event);
 	list_for_each_entry(sibling, &event->sibling_list, group_entry)
 		perf_event_for_each_child(sibling, func);
 	mutex_unlock(&ctx->mutex);
-- 
1.7.10.2

