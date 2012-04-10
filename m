Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab2DJCAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 22:00:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59893 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2DJCAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 22:00:16 -0400
Message-ID: <1334023210.16328.3.camel@phoenix>
Subject: [PATCH] mmc: pxamci: Use DIV_ROUND_UP at appropriate places
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Ball <cjb@laptop.org>, Anton Vorontsov <cbouatmailru@gmail.com>,
        Viresh Kumar <viresh.kumar@st.com>,
        David Brown <davidb@codeaurora.org>, linux-mmc@vger.kernel.org
Date: Tue, 10 Apr 2012 10:00:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mmc/host/pxamci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index cb2dc0e..4b89e73 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -190,7 +190,7 @@ static void pxamci_setup_data(struct pxamci_host *host, struct mmc_data *data)
 	clks = (unsigned long long)data->timeout_ns * host->clkrate;
 	do_div(clks, 1000000000UL);
 	timeout = (unsigned int)clks + (data->timeout_clks << host->clkrt);
-	writel((timeout + 255) / 256, host->base + MMC_RDTO);
+	writel(DIV_ROUND_UP(timeout, 256), host->base + MMC_RDTO);
 
 	if (data->flags & MMC_DATA_READ) {
 		host->dma_dir = DMA_FROM_DEVICE;
@@ -636,7 +636,7 @@ static int pxamci_probe(struct platform_device *pdev)
 	/*
 	 * Calculate minimum clock rate, rounding up.
 	 */
-	mmc->f_min = (host->clkrate + 63) / 64;
+	mmc->f_min = DIV_ROUND_UP(host->clkrate, 64);
 	mmc->f_max = (mmc_has_26MHz()) ? 26000000 : host->clkrate;
 
 	pxamci_init_ocr(host);
-- 
1.7.5.4



