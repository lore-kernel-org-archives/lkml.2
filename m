Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0IGOg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:36:58 -0400
Received: from www.tglx.de ([62.245.132.106]:43821 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab0IGOd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:29 -0400
Message-Id: <20100907125055.743613774@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [patch 11/30] parport: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-parport-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 drivers/parport/share.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/parport/share.c
===================================================================
--- linux-2.6.orig/drivers/parport/share.c
+++ linux-2.6/drivers/parport/share.c
@@ -306,7 +306,7 @@ struct parport *parport_register_port(un
 	spin_lock_init(&tmp->pardevice_lock);
 	tmp->ieee1284.mode = IEEE1284_MODE_COMPAT;
 	tmp->ieee1284.phase = IEEE1284_PH_FWD_IDLE;
-	init_MUTEX_LOCKED (&tmp->ieee1284.irq); /* actually a semaphore at 0 */
+	sema_init(&tmp->ieee1284.irq, 0);
 	tmp->spintime = parport_default_spintime;
 	atomic_set (&tmp->ref_count, 1);
 	INIT_LIST_HEAD(&tmp->full_list);


