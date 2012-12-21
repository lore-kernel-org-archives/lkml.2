Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2LUUsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 15:48:25 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:61670 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab2LUUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 15:48:23 -0500
From: Stefan Hasko <hasko.stevo@gmail.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Hasko <hasko.stevo@gmail.com>
Subject: [PATCH] net: sched: integer overflow fix
Date: Fri, 21 Dec 2012 21:39:24 +0100
Message-Id: <1356122364-1418-1-git-send-email-hasko.stevo@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed integer overflow in function htb_dequeue

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
---
 net/sched/sch_htb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index d2922c0..1bd3faa 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -919,7 +919,7 @@ ok:
 	q->now = ktime_to_ns(ktime_get());
 	start_at = jiffies;
 
-	next_event = q->now + 5 * NSEC_PER_SEC;
+	next_event = q->now + (u32)5 * NSEC_PER_SEC;
 
 	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
 		/* common case optimization - skip event handler quickly */
-- 
1.7.10.4

