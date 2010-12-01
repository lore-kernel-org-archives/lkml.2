Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab0LAJL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:11:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:54092 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0LAJLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:11:25 -0500
Date: Wed, 1 Dec 2010 09:10:55 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101130163819.969462809@linutronix.de>
References: <20101130163819.969462809@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Use appropriate pointer type instead of silly typecasting
Message-ID: <tip-28990f75e66b36faf6ce56747890009d4e250243@git.kernel.org>
Git-Commit-ID: 28990f75e66b36faf6ce56747890009d4e250243
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:10:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28990f75e66b36faf6ce56747890009d4e250243
Gitweb:     http://git.kernel.org/tip/28990f75e66b36faf6ce56747890009d4e250243
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 30 Nov 2010 17:49:35 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 19:55:26 -0200

perf session: Use appropriate pointer type instead of silly typecasting

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
