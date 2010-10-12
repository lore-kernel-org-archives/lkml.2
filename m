Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab0JLPxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:53:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:40426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab0JLPxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 11:53:47 -0400
Date: Tue, 12 Oct 2010 15:53:30 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        leochen@broadcom.com, peterz@infradead.org, tglx@linutronix.de,
        hch@infradead.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        leochen@broadcom.com, peterz@infradead.org, tglx@linutronix.de,
        hch@infradead.org
In-Reply-To: <20100907125057.371771121@linutronix.de>
References: <20100907125057.371771121@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] arm: Bcmring: semaphore cleanup
Message-ID: <tip-5356d94872502e77317f82e8fcae2a0b162af07c@git.kernel.org>
Git-Commit-ID: 5356d94872502e77317f82e8fcae2a0b162af07c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 15:53:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5356d94872502e77317f82e8fcae2a0b162af07c
Gitweb:     http://git.kernel.org/tip/5356d94872502e77317f82e8fcae2a0b162af07c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 7 Sep 2010 14:33:52 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 12 Oct 2010 17:36:10 +0200

arm: Bcmring: semaphore cleanup

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Leo Chen <leochen@broadcom.com>
LKML-Reference: <20100907125057.371771121@linutronix.de>

---
 arch/arm/mach-bcmring/dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index 29c0a91..77eb35c 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -691,7 +691,7 @@ int dma_init(void)
 
 	memset(&gDMA, 0, sizeof(gDMA));
 
-	init_MUTEX_LOCKED(&gDMA.lock);
+	sema_init(&gDMA.lock, 0);
 	init_waitqueue_head(&gDMA.freeChannelQ);
 
 	/* Initialize the Hardware */
@@ -1574,7 +1574,7 @@ int dma_init_mem_map(DMA_MemMap_t *memMap)
 {
 	memset(memMap, 0, sizeof(*memMap));
 
-	init_MUTEX(&memMap->lock);
+	sema_init(&memMap->lock, 1);
 
 	return 0;
 }
