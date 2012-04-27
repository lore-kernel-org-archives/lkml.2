Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2D0WbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:31:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35132 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2D0WbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:31:22 -0400
Date: Fri, 27 Apr 2012 17:31:18 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Eric =?utf-8?Q?B=C3=A9nard?= <eric@eukrea.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Chris Ball <cjb@laptop.org>
Subject: Re: [ 14/62] mmc: unbreak sdhci-esdhc-imx on i.MX25
Message-ID: <20120427223118.GE2821@burratino>
References: <20120424223305.GA7748@kroah.com>
 <20120424223243.200037983@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120424223243.200037983@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg KH wrote:

> 3.3-stable review patch.
[...]
> commit b89152824f993a9572b47eb31f4579feadeac34c upstream.
>
> This was broken by me in 37865fe91582582a6f6c00652f6a2b1ff71f8a78
> ("mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci") where more
> extensive tests would have shown that read or write of data to the
> card were failing (even if the partition table was correctly read).

37865fe91582 is v2.6.37-rc4~24^2~7 so it sounds like this patch
should also be applied to 3.0.y.

Here's a straightforward backport to account for the lack of
v3.1-rc1~321^2~77 ("mmc: sdhci: make sdhci-pltfm device drivers self
registered") and v3.1-rc1~125^2^2~5 ("mmc: sdhci-esdhc-imx: get rid of
the uses of cpu_is_mx").  Sensible?

-- >8 --
From: Eric Bénard <eric@eukrea.com>
Date: Wed, 18 Apr 2012 02:30:20 +0200

commit b89152824f993a9572b47eb31f4579feadeac34c upstream.

This was broken by me in 37865fe91582582a6f6c00652f6a2b1ff71f8a78
("mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci") where more
extensive tests would have shown that read or write of data to the
card were failing (even if the partition table was correctly read).

Signed-off-by: Eric Bénard <eric@eukrea.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Thanks,
Jonathan

 drivers/mmc/host/sdhci-esdhc-imx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 92e543701836..6fe8cede4179 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -245,8 +245,7 @@ static int esdhc_pltfm_init(struct sdhci_host *host, struct sdhci_pltfm_data *pd
 	}
 	pltfm_host->priv = imx_data;
 
-	if (!cpu_is_mx25())
-		host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
+	host->quirks |= SDHCI_QUIRK_BROKEN_TIMEOUT_VAL;
 
 	if (cpu_is_mx25() || cpu_is_mx35()) {
 		/* Fix errata ENGcm07207 present on i.MX25 and i.MX35 */
-- 
1.7.10

