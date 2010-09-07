Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab0IGOcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:32:55 -0400
Received: from www.tglx.de ([62.245.132.106]:43701 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab0IGOcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:32:48 -0400
Message-Id: <20100907125054.985090435@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 03/30] input: serio/hil_mlc: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-input-hil-mlc-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>

---
 drivers/input/serio/hil_mlc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/input/serio/hil_mlc.c
===================================================================
--- linux-2.6.orig/drivers/input/serio/hil_mlc.c
+++ linux-2.6/drivers/input/serio/hil_mlc.c
@@ -915,15 +915,15 @@ int hil_mlc_register(hil_mlc *mlc)
 	mlc->ostarted = 0;
 
 	rwlock_init(&mlc->lock);
-	init_MUTEX(&mlc->osem);
+	sema_init(&mlc->osem, 1);
 
-	init_MUTEX(&mlc->isem);
+	sema_init(&mlc->isem, 1);
 	mlc->icount = -1;
 	mlc->imatch = 0;
 
 	mlc->opercnt = 0;
 
-	init_MUTEX_LOCKED(&(mlc->csem));
+	sema_init(&(mlc->csem), 0);
 
 	hil_mlc_clear_di_scratch(mlc);
 	hil_mlc_clear_di_map(mlc, 0);


