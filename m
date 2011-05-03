Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab1ECTw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:52:57 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38813 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1ECTw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:52:56 -0400
Subject: [PATCH 01/16] cciss: add readl after writel in interrupt mask setting
	code
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:52:54 -0500
Message-ID: <20110503195254.5154.17753.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to ensure the board interrupts are really off when
these functions return.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index 554bbd9..9b49439 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -239,11 +239,13 @@ static void SA5_intr_mask(ctlr_info_t *h, unsigned long val)
 	{ /* Turn interrupts on */
 		h->interrupts_enabled = 1;
 		writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	} else /* Turn them off */
 	{
 		h->interrupts_enabled = 0;
         	writel( SA5_INTR_OFF, 
 			h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	}
 }
 /*
@@ -257,11 +259,13 @@ static void SA5B_intr_mask(ctlr_info_t *h, unsigned long val)
         { /* Turn interrupts on */
 		h->interrupts_enabled = 1;
                 writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
         } else /* Turn them off */
         {
 		h->interrupts_enabled = 0;
                 writel( SA5B_INTR_OFF,
                         h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
         }
 }
 
@@ -271,10 +275,12 @@ static void SA5_performant_intr_mask(ctlr_info_t *h, unsigned long val)
 	if (val) { /* turn on interrupts */
 		h->interrupts_enabled = 1;
 		writel(0, h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	} else {
 		h->interrupts_enabled = 0;
 		writel(SA5_PERF_INTR_OFF,
 				h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
+		(void) readl(h->vaddr + SA5_REPLY_INTR_MASK_OFFSET);
 	}
 }
 

