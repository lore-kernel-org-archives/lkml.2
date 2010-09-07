Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0IGOcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:32:48 -0400
Received: from www.tglx.de ([62.245.132.106]:43676 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033Ab0IGOcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:32:42 -0400
Message-Id: <20100907125054.888438853@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:31:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 02/30] input: misc/hp_sdc_rtc: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-input-misc-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>

---
 drivers/input/misc/hp_sdc_rtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/input/misc/hp_sdc_rtc.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/hp_sdc_rtc.c
+++ linux-2.6/drivers/input/misc/hp_sdc_rtc.c
@@ -104,7 +104,7 @@ static int hp_sdc_rtc_do_read_bbrtc (str
 	t.endidx =		91;
 	t.seq =			tseq;
 	t.act.semaphore =	&tsem;
-	init_MUTEX_LOCKED(&tsem);
+	sema_init(&tsem, 0);
 	
 	if (hp_sdc_enqueue_transaction(&t)) return -1;
 	
@@ -698,7 +698,7 @@ static int __init hp_sdc_rtc_init(void)
 		return -ENODEV;
 #endif
 
-	init_MUTEX(&i8042tregs);
+	sema_init(&i8042tregs, 1);
 
 	if ((ret = hp_sdc_request_timer_irq(&hp_sdc_rtc_isr)))
 		return ret;


