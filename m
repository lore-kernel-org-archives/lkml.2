Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab0JLPwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:52:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40335 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842Ab0JLPwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:52:17 -0400
Date: Tue, 12 Oct 2010 15:51:59 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org,
        davem@davemloft.net
In-Reply-To: <20100907125055.651362456@linutronix.de>
References: <20100907125055.651362456@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] irda: Semaphore cleanup
Message-ID: <tip-db7f859ec53c0bfaf3520afe2feafd18a27e48fb@git.kernel.org>
Git-Commit-ID: db7f859ec53c0bfaf3520afe2feafd18a27e48fb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:51:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db7f859ec53c0bfaf3520afe2feafd18a27e48fb
Gitweb:     http://git.kernel.org/tip/db7f859ec53c0bfaf3520afe2feafd18a27e48fb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:30 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:09 +0200

irda: Semaphore cleanup

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: "David S. Miller" <davem@davemloft.net>
LKML-Reference: <20100907125055.651362456@linutronix.de>

---
 drivers/net/irda/sir_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 1b051da..51d7444 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -909,7 +909,7 @@ struct sir_dev * sirdev_get_instance(const struct sir_driver *drv, const char *n
 	dev->tx_skb = NULL;
 
 	spin_lock_init(&dev->tx_lock);
-	init_MUTEX(&dev->fsm.sem);
+	sema_init(&dev->fsm.sem, 1);
 
 	dev->drv = drv;
 	dev->netdev = ndev;
