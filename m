Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1F3E72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:59:28 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51252 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1F3E7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:59:22 -0400
Subject: [PATCH] mmc: tmio: fix build error if CONFIG_MMC_SDHI is not
 configured
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <spyro@f2s.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 12:59:16 +0800
Message-ID: <1309409956.10500.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:

  CC      drivers/mmc/host/tmio_mmc_dma.o
drivers/mmc/host/tmio_mmc_dma.c:192: error: redefinition of 'tmio_mmc_start_dma'
drivers/mmc/host/tmio_mmc.h:111: error: previous definition of 'tmio_mmc_start_dma' was here
drivers/mmc/host/tmio_mmc_dma.c:257: error: redefinition of 'tmio_mmc_request_dma'
drivers/mmc/host/tmio_mmc.h:116: error: previous definition of 'tmio_mmc_request_dma' was here
drivers/mmc/host/tmio_mmc_dma.c:305: error: redefinition of 'tmio_mmc_release_dma'
drivers/mmc/host/tmio_mmc.h:122: error: previous definition of 'tmio_mmc_release_dma' was here
make[3]: *** [drivers/mmc/host/tmio_mmc_dma.o] Error 1
make[2]: *** [drivers/mmc/host] Error 2
make[1]: *** [drivers/mmc] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mmc/host/tmio_mmc_dma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc_dma.c b/drivers/mmc/host/tmio_mmc_dma.c
index a40fdba..4dc563a 100644
--- a/drivers/mmc/host/tmio_mmc_dma.c
+++ b/drivers/mmc/host/tmio_mmc_dma.c
@@ -189,6 +189,7 @@ pio:
 		desc, cookie);
 }
 
+#if defined(CONFIG_MMC_SDHI) || defined(CONFIG_MMC_SDHI_MODULE)
 void tmio_mmc_start_dma(struct tmio_mmc_host *host,
 			       struct mmc_data *data)
 {
@@ -200,6 +201,7 @@ void tmio_mmc_start_dma(struct tmio_mmc_host *host,
 			tmio_mmc_start_dma_tx(host);
 	}
 }
+#endif
 
 static void tmio_mmc_issue_tasklet_fn(unsigned long priv)
 {
@@ -254,6 +256,7 @@ static bool tmio_mmc_filter(struct dma_chan *chan, void *arg)
 	return true;
 }
 
+#if defined(CONFIG_MMC_SDHI) || defined(CONFIG_MMC_SDHI_MODULE)
 void tmio_mmc_request_dma(struct tmio_mmc_host *host, struct tmio_mmc_data *pdata)
 {
 	/* We can only either use DMA for both Tx and Rx or not use it at all */
@@ -319,3 +322,4 @@ void tmio_mmc_release_dma(struct tmio_mmc_host *host)
 		host->bounce_buf = NULL;
 	}
 }
+#endif
-- 
1.7.4.1



