Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab2J0PuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:50:06 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45626 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2J0PuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:50:03 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
Subject: [PATCH] dma: ste_dma40: use for_each_set_bit
Date: Sun, 28 Oct 2012 00:49:30 +0900
Message-Id: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded loop with for_each_set_bit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
---
 drivers/dma/ste_dma40.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ae55091..08f5bfe 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1487,7 +1487,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	u32 regs[ARRAY_SIZE(il)];
 	u32 idx;
 	u32 row;
-	long chan = -1;
+	long chan;
 	struct d40_chan *d40c;
 	unsigned long flags;
 	struct d40_base *base = data;
@@ -1498,15 +1498,8 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 	for (i = 0; i < ARRAY_SIZE(il); i++)
 		regs[i] = readl(base->virtbase + il[i].src);
 
-	for (;;) {
-
-		chan = find_next_bit((unsigned long *)regs,
-				     BITS_PER_LONG * ARRAY_SIZE(il), chan + 1);
-
-		/* No more set bits found? */
-		if (chan == BITS_PER_LONG * ARRAY_SIZE(il))
-			break;
-
+	for_each_set_bit(chan, (unsigned long *)regs,
+			BITS_PER_LONG * ARRAY_SIZE(il)) {
 		row = chan / BITS_PER_LONG;
 		idx = chan & (BITS_PER_LONG - 1);
 
-- 
1.7.11.7

