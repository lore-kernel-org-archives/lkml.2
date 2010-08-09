Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0HIMIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:08:11 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:41506 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756326Ab0HIMIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:08:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/14] DMAENGINE: ste_dma40: No need reading, masking and setting a set register
Date: Mon, 9 Aug 2010 14:07:54 +0200
Message-ID: <1281355674-13105-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Removes an unnecessary register read and a few lines of code.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 8aff865..538c35d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -915,7 +915,6 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 
 	int i;
 	u32 regs[ARRAY_SIZE(il)];
-	u32 tmp;
 	u32 idx;
 	u32 row;
 	long chan = -1;
@@ -942,9 +941,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 		idx = chan & (BITS_PER_LONG - 1);
 
 		/* ACK interrupt */
-		tmp = readl(base->virtbase + il[row].clr);
-		tmp |= 1 << idx;
-		writel(tmp, base->virtbase + il[row].clr);
+		writel(1 << idx, base->virtbase + il[row].clr);
 
 		if (il[row].offset == D40_PHY_CHAN)
 			d40c = base->lookup_phy_chans[idx];
-- 
1.6.3.3

