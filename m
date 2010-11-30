Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0K3UNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:13:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:33362 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0K3ULG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/11] perf session: Use appropriate pointer type instead of silly typecasting
Date: Tue, 30 Nov 2010 18:10:48 -0200
Message-Id: <1291147856-17459-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

There is no reason to use a struct sample_event pointer in struct sample_queue
and type cast it when flushing the queue.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20101130163819.969462809@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index daca557..525bcf6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -386,7 +386,7 @@ static event__swap_op event__swap_ops[] = {
 
 struct sample_queue {
 	u64			timestamp;
-	struct sample_event	*event;
+	event_t			*event;
 	struct list_head	list;
 };
 
@@ -406,7 +406,7 @@ static void flush_sample_queue(struct perf_session *s,
 		if (iter->timestamp > limit)
 			break;
 
-		ops->sample((event_t *)iter->event, s);
+		ops->sample(iter->event, s);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
-- 
1.6.2.5

