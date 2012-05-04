Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2EDUt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:49:27 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:38140 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759922Ab2EDUtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:22 -0400
Message-Id: <20120504204246.606929528@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Eric=20B=E9nard?= <eric@eukrea.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wolfram Sang <w.sang@pengutronix.de>,
        Chris Ball <cjb@laptop.org>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 20/47] mmc: unbreak sdhci-esdhc-imx on i.MX25
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Bénard <eric@eukrea.com>

commit b89152824f993a9572b47eb31f4579feadeac34c upstream.

This was broken by me in 37865fe91582582a6f6c00652f6a2b1ff71f8a78
("mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci") where more
extensive tests would have shown that read or write of data to the
card were failing (even if the partition table was correctly read).

Signed-off-by: Eric BÃ©nard <eric@eukrea.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Thanks,
Jonathan

 drivers/mmc/host/sdhci-esdhc-imx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -245,8 +245,7 @@ static int esdhc_pltfm_init(struct sdhci
 	}
 	pltfm_host->priv = imx_data;
 
-	if (!cpu_is_mx25())
-		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+	host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
 	if (cpu_is_mx25() || cpu_is_mx35()) {
 		/* Fix errata ENGcm07207 present on i.MX25 and i.MX35 */


