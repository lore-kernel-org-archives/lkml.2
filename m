Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0IGOdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:33:05 -0400
Received: from www.tglx.de ([62.245.132.106]:43712 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090Ab0IGOcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:32:53 -0400
Message-Id: <20100907125055.079737758@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 04/30] input: serio/hp_sdc: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-input-hp-sdc-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>

---
 drivers/input/serio/hp_sdc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/input/serio/hp_sdc.c
===================================================================
--- linux-2.6.orig/drivers/input/serio/hp_sdc.c
+++ linux-2.6/drivers/input/serio/hp_sdc.c
@@ -905,7 +905,7 @@ static int __init hp_sdc_init(void)
 	ts_sync[1]	= 0x0f;
 	ts_sync[2] = ts_sync[3]	= ts_sync[4] = ts_sync[5] = 0;
 	t_sync.act.semaphore = &s_sync;
-	init_MUTEX_LOCKED(&s_sync);
+	sema_init(&s_sync, 0);
 	hp_sdc_enqueue_transaction(&t_sync);
 	down(&s_sync); /* Wait for t_sync to complete */
 
@@ -1039,7 +1039,7 @@ static int __init hp_sdc_register(void)
 		return hp_sdc.dev_err;
 	}
 
-	init_MUTEX_LOCKED(&tq_init_sem);
+	sema_init(&tq_init_sem, 0);
 
 	tq_init.actidx		= 0;
 	tq_init.idx		= 1;


