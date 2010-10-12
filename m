Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0JLPvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:51:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:40309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757305Ab0JLPvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:51:50 -0400
Date: Tue, 12 Oct 2010 15:51:35 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, davem@davemloft.net,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, hch@infradead.org,
        davem@davemloft.net
In-Reply-To: <20100907125055.557578360@linutronix.de>
References: <20100907125055.557578360@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] net: Wan/cosa.c: Convert "mutex" to semaphore
Message-ID: <tip-d1985508320ad40a68375bdbafa8a5d6c56d2114@git.kernel.org>
Git-Commit-ID: d1985508320ad40a68375bdbafa8a5d6c56d2114
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:51:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1985508320ad40a68375bdbafa8a5d6c56d2114
Gitweb:     http://git.kernel.org/tip/d1985508320ad40a68375bdbafa8a5d6c56d2114
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:32:25 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:09 +0200

net: Wan/cosa.c: Convert "mutex" to semaphore

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: "David S. Miller" <davem@davemloft.net>
LKML-Reference: <20100907125055.557578360@linutronix.de>

---
 drivers/net/wan/cosa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 04c6cd4..10bafd5 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -575,7 +575,7 @@ static int cosa_probe(int base, int irq, int dma)
 
 		/* Initialize the chardev data structures */
 		mutex_init(&chan->rlock);
-		init_MUTEX(&chan->wsem);
+		sema_init(&chan->wsem, 1);
 
 		/* Register the network interface */
 		if (!(chan->netdev = alloc_hdlcdev(chan))) {
