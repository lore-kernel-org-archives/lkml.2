Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2F0Pvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:51:54 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:46416 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969Ab2F0Pvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:51:51 -0400
From: Roland Stigge <stigge@antcom.de>
To: dedekind1@gmail.com, linux-mtd@lists.infradead.org, aletes.xgr@gmail.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dwmw2@infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/4] mtd: lpc32xx_slc: Use of_get_named_gpio()
Date: Wed, 27 Jun 2012 17:51:14 +0200
Message-Id: <1340812275-1197-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1340812275-1197-1-git-send-email-stigge@antcom.de>
References: <1340812275-1197-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the lpc32xx_slc driver use of_get_named_gpio() instead of
of_get_named_gpio_flags() whose flags are discarded anyway.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/mtd/nand/lpc32xx_slc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index ab72aca..4e8db3a 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -770,7 +770,7 @@ static struct lpc32xx_nand_cfg_slc *lpc32xx_parse_dt(struct device *dev)
 	}
 
 	pdata->use_bbt = of_get_nand_on_flash_bbt(np);
-	pdata->wp_gpio = of_get_named_gpio_flags(np, "gpios", 0, NULL);
+	pdata->wp_gpio = of_get_named_gpio(np, "gpios", 0);
 
 	return pdata;
 }
-- 
1.7.10.4

