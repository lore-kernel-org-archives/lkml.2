Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2DXWej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:34:39 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab2DXWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:36 -0400
Message-Id: <20120424223243.200037983@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Chris Ball <cjb@laptop.org>
Subject: [ 14/62] mmc: unbreak sdhci-esdhc-imx on i.MX25
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Bénard <eric@eukrea.com>

commit b89152824f993a9572b47eb31f4579feadeac34c upstream.

This was broken by me in 37865fe91582582a6f6c00652f6a2b1ff71f8a78
("mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci") where more
extensive tests would have shown that read or write of data to the
card were failing (even if the partition table was correctly read).

Signed-off-by: Eric Bénard <eric@eukrea.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-esdhc-imx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -467,8 +467,7 @@ static int __devinit sdhci_esdhc_imx_pro
 	clk_enable(clk);
 	pltfm_host->clk = clk;
 
-	if (!is_imx25_esdhc(imx_data))
-		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+	host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
 	if (is_imx25_esdhc(imx_data) || is_imx35_esdhc(imx_data))
 		/* Fix errata ENGcm07207 present on i.MX25 and i.MX35 */


