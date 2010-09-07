Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0IGOft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:35:49 -0400
Received: from www.tglx.de ([62.245.132.106]:43974 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280Ab0IGOeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:34:14 -0400
Message-Id: <20100907125057.371771121@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:33:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Leo Chen <leochen@broadcom.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [patch 28/30] arm: bcmring: semaphore cleanup
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=arm-bcmring-semaphore-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Leo Chen <leochen@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org

---
 arch/arm/mach-bcmring/dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/arm/mach-bcmring/dma.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-bcmring/dma.c
+++ linux-2.6/arch/arm/mach-bcmring/dma.c
@@ -691,7 +691,7 @@ int dma_init(void)
 
 	memset(&gDMA, 0, sizeof(gDMA));
 
-	init_MUTEX_LOCKED(&gDMA.lock);
+	sema_init(&gDMA.lock, 0);
 	init_waitqueue_head(&gDMA.freeChannelQ);
 
 	/* Initialize the Hardware */
@@ -1574,7 +1574,7 @@ int dma_init_mem_map(DMA_MemMap_t *memMa
 {
 	memset(memMap, 0, sizeof(*memMap));
 
-	init_MUTEX(&memMap->lock);
+	sema_init(&memMap->lock, 1);
 
 	return 0;
 }


