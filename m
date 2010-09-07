Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab0IGOdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:33:17 -0400
Received: from www.tglx.de ([62.245.132.106]:43749 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab0IGOdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:08 -0400
Message-Id: <20100907125055.368389976@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [patch 07/30] hamradio: mkiss: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-net-hamradio-mkiss-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org

---
 drivers/net/hamradio/mkiss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/net/hamradio/mkiss.c
===================================================================
--- linux-2.6.orig/drivers/net/hamradio/mkiss.c
+++ linux-2.6/drivers/net/hamradio/mkiss.c
@@ -747,7 +747,7 @@ static int mkiss_open(struct tty_struct 
 
 	spin_lock_init(&ax->buflock);
 	atomic_set(&ax->refcnt, 1);
-	init_MUTEX_LOCKED(&ax->dead_sem);
+	sema_init(&ax->dead_sem, 0);
 
 	ax->tty = tty;
 	tty->disc_data = ax;


