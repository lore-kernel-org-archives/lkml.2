Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965743Ab2FAWQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:16:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:59506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2FAWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/15] perf: Remove duplicate invocation on perf_event_for_each
Date: Fri,  1 Jun 2012 19:16:38 -0300
Message-Id: <1338588999-32509-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The @func callback was invoked twice for group leader when
perf_event_for_each() called. It seems the commit 75f937f24bd9
("perf_counter: Fix ctx->mutex vs counter ->mutex inversion") made the
mistake during the change.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338443506-25009-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5b06cbb..f85c015 100644
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
1.7.1

