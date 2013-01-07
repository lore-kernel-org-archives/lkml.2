Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3AGLZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:25:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55630 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab3AGLZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:25:46 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 16/16] dmaengine: set_dma40: balance clock in probe fail code
Date: Mon,  7 Jan 2013 12:21:58 +0100
Message-Id: <1357557718-15676-17-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock code was changed to use clk_prepare_enable in:

b707c65 dma/ste_dma40: Fixup clock usage during probe

but clk_disable on probe fail path was not updated.  This patch fix this
by using clk_disable_unprepare in place of clk_disable.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index a97bbd3..d77d41d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3634,7 +3634,7 @@ failure:
 			release_mem_region(base->phy_start,
 					   base->phy_size);
 		if (base->clk) {
-			clk_disable(base->clk);
+			clk_disable_unprepare(base->clk);
 			clk_put(base->clk);
 		}
 
-- 
1.7.12.1

