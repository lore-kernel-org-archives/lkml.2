Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2EIFwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38692 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138Ab2EIFwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:44 -0400
Message-Id: <20120509055030.851970163@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Chris Ball <cjb@laptop.org>
Subject: [ 009/167] [PATCH] mmc: unbreak sdhci-esdhc-imx on i.MX25
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>

commit b89152824f993a9572b47eb31f4579feadeac34c upstream.

This was broken by me in 37865fe91582582a6f6c00652f6a2b1ff71f8a78
("mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci") where more
extensive tests would have shown that read or write of data to the
card were failing (even if the partition table was correctly read).

Signed-off-by: Eric Bénard <eric@eukrea.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sdhci-esdhc-imx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux.orig/drivers/mmc/host/sdhci-esdhc-imx.c
+++ linux/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -467,8 +467,7 @@
 	clk_enable(clk);
 	pltfm_host->clk = clk;
 
-	if (!is_imx25_esdhc(imx_data))
-		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+	host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
 	if (is_imx25_esdhc(imx_data) || is_imx35_esdhc(imx_data))
 		/* Fix errata ENGcm07207 present on i.MX25 and i.MX35 */


