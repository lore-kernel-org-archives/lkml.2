Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0LFKKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:10:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58630 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab0LFKKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:10:02 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/2] dmaengine i.MX SDMA: initialize on module_init
Date: Mon,  6 Dec 2010 11:09:57 +0100
Message-Id: <1291630198-9690-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291630198-9690-1-git-send-email-s.hauer@pengutronix.de>
References: <1291630198-9690-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firmware framework gets initialized during fs_initcall time, so
we are not allowed to call request_firmware earlier.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 0834323..01c4a5f 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1385,7 +1385,7 @@ static int __init sdma_module_init(void)
 {
 	return platform_driver_probe(&sdma_driver, sdma_probe);
 }
-subsys_initcall(sdma_module_init);
+module_init(sdma_module_init);
 
 MODULE_AUTHOR("Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("i.MX SDMA driver");
-- 
1.7.2.3

