Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0JLPuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:50:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:40094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab0JLPuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:50:23 -0400
Date: Tue, 12 Oct 2010 15:50:05 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org,
        davem@davemloft.net
In-Reply-To: <20100907125055.175750769@linutronix.de>
References: <20100907125055.175750769@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] net: 3c527: semaphore cleanup
Message-ID: <tip-50948ee8124c2125d833e8889002aa12a948b4e9@git.kernel.org>
Git-Commit-ID: 50948ee8124c2125d833e8889002aa12a948b4e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:50:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50948ee8124c2125d833e8889002aa12a948b4e9
Gitweb:     http://git.kernel.org/tip/50948ee8124c2125d833e8889002aa12a948b4e9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:10 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:08 +0200

net: 3c527: semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: David Miller <davem@davemloft.net>
LKML-Reference: <20100907125055.175750769@linutronix.de>
---
 drivers/net/3c527.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index 70705d1..eca55c5 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -522,7 +522,7 @@ static int __init mc32_probe1(struct net_device *dev, int slot)
 	lp->tx_len 		= lp->exec_box->data[9];   /* Transmit list count */
 	lp->rx_len 		= lp->exec_box->data[11];  /* Receive list count */
 
-	init_MUTEX_LOCKED(&lp->cmd_mutex);
+	sema_init(&lp->cmd_mutex, 0);
 	init_completion(&lp->execution_cmd);
 	init_completion(&lp->xceiver_cmd);
 
