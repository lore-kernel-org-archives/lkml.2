Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1ALKSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:18:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab1ALKSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 05:18:17 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] dmaengine i.MX SDMA: Fix firmware loading
Date: Wed, 12 Jan 2011 11:18:14 +0100
Message-Id: <1294827494-15092-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294827494-15092-1-git-send-email-s.hauer@pengutronix.de>
References: <1294827494-15092-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When loading the microcode to the SDMA engine we have to use
the ram_code_start_addr found in the firmware image. The copy
in the sdma engine is not initialized correctly. This is broken
since:
5b28aa3 dmaengine i.MX SDMA: Allow to run without firmware

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index d5a5d4d..75df8b9 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1135,7 +1135,7 @@ static int __init sdma_get_firmware(struct sdma_engine *sdma,
 	/* download the RAM image for SDMA */
 	sdma_load_script(sdma, ram_code,
 			header->ram_code_size,
-			sdma->script_addrs->ram_code_start_addr);
+			addr->ram_code_start_addr);
 	clk_disable(sdma->clk);
 
 	sdma_add_scripts(sdma, addr);
-- 
1.7.2.3

