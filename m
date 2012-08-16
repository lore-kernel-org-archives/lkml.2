Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2HPI5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:57:11 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:61322 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753222Ab2HPI5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:57:07 -0400
From: Roland Stigge <stigge@antcom.de>
To: artem.bityutskiy@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com,
        dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] dma: amba-pl08x: Export pl08x_filter_id
Date: Thu, 16 Aug 2012 10:56:36 +0200
Message-Id: <1345107396-27079-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following when compiling a driver module that uses
amba-pl08x:

ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_slc.ko] undefined!
ERROR: "pl08x_filter_id" [drivers/mtd/nand/lpc32xx_mlc.ko] undefined!

(drivers/mtd/nand/lpc32xx_* are still in l2-mtd.git)

Done as in:

drivers/dma/coh901318.c
drivers/dma/sirf-dma.c

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 6fbeebb..8c2e9b6 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1608,6 +1608,7 @@ bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
 
 	return false;
 }
+EXPORT_SYMBOL(pl08x_filter_id);
 
 /*
  * Just check that the device is there and active
