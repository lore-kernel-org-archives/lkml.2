Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0IGOdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:33:41 -0400
Received: from www.tglx.de ([62.245.132.106]:43775 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0IGOdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:17 -0400
Message-Id: <20100907125055.557578360@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [patch 09/30] net: wan/cosa.c: Convert "mutex" to semaphore
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-net-wan-cosa-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org

---
 drivers/net/wan/cosa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/wan/cosa.c
===================================================================
--- linux-2.6.orig/drivers/net/wan/cosa.c
+++ linux-2.6/drivers/net/wan/cosa.c
@@ -575,7 +575,7 @@ static int cosa_probe(int base, int irq,
 
 		/* Initialize the chardev data structures */
 		mutex_init(&chan->rlock);
-		init_MUTEX(&chan->wsem);
+		sema_init(&chan->wsem, 1);
 
 		/* Register the network interface */
 		if (!(chan->netdev = alloc_hdlcdev(chan))) {


