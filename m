Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab0IGOdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:33:03 -0400
Received: from www.tglx.de ([62.245.132.106]:43721 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab0IGOc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:32:57 -0400
Message-Id: <20100907125055.175750769@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:10 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [patch 05/30] net: 3c527: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-net-3c527-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/3c527.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/3c527.c
===================================================================
--- linux-2.6.orig/drivers/net/3c527.c
+++ linux-2.6/drivers/net/3c527.c
@@ -522,7 +522,7 @@ static int __init mc32_probe1(struct net
 	lp->tx_len 		= lp->exec_box->data[9];   /* Transmit list count */
 	lp->rx_len 		= lp->exec_box->data[11];  /* Receive list count */
 
-	init_MUTEX_LOCKED(&lp->cmd_mutex);
+	sema_init(&lp->cmd_mutex, 0);
 	init_completion(&lp->execution_cmd);
 	init_completion(&lp->xceiver_cmd);
 


