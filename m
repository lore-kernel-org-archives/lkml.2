Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1K2DES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:04:18 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41386 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1K2DER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:04:17 -0500
From: Shan Hai <haishan.bai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, tglx@linutronix.de,
        Shan Hai <haishan.bai@gmail.com>
Subject: [PATCH 1/1] sched/rt: code cleanup, remove a redundant function call
Date: Tue, 29 Nov 2011 11:03:56 +0800
Message-Id: <1322535836-13590-2-git-send-email-haishan.bai@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1322535836-13590-1-git-send-email-haishan.bai@gmail.com>
References: <1322535836-13590-1-git-send-email-haishan.bai@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second time call to sched_rt_period is redundant, because the value of the
rt_runtime was already read and it was protected by the rurt_runtime_lock.

Signed-off-by: Shan Hai <haishan.bai@gmail.com>
---
 kernel/sched_rt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 056cbd2..2171ac8 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -645,7 +645,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
-	if (sched_rt_runtime(rt_rq) >= sched_rt_period(rt_rq))
+	if (runtime >= sched_rt_period(rt_rq))
 		return 0;
 
 	balance_runtime(rt_rq);
-- 
1.7.4.1

