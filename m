Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab1H3QRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:17:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19510 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1H3QRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:17:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 30 Aug 2011 09:17:32 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Marc Dietich <marvin24@gmx.de>
CC: Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Aug 2011 09:17:31 -0700
Subject: RE: [PATCH 1/2] sdhci/tegra: Add Device Tree probing support
Thread-Topic: [PATCH 1/2] sdhci/tegra: Add Device Tree probing support
Thread-Index: Acxm6cVqaZrAQzhXRYuSo0H69MoFBgARkEag
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04B3279D49@HQMAIL01.nvidia.com>
References: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
 <201108300952.02418.marvin24@gmx.de>
In-Reply-To: <201108300952.02418.marvin24@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Dietich wrote at Tuesday, August 30, 2011 1:52 AM:
...
> > diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
...
> > @@ -95,12 +94,10 @@ static irqreturn_t carddetect_irq(int irq, void *data)
> >
> >  static int tegra_sdhci_8bit(struct sdhci_host *host, int bus_width)
> >  {
> > -	struct platform_device *pdev = to_platform_device(mmc_dev(host->mmc));
> > -	struct tegra_sdhci_platform_data *plat;
> > +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> > +	struct tegra_sdhci_platform_data *plat = pltfm_host->priv;
> >  	u32 ctrl;
> >
> > -	plat = pdev->dev.platform_data;
> > -
> >  	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
> >  	if (plat->is_8bit && bus_width == MMC_BUS_WIDTH_8) {
> >  		ctrl &= ~SDHCI_CTRL_4BITBUS;
> 
> what about 8 bit support?

I didn't understand the question at first; I assume you're asking about
8-bit support in the device-tree binding/parsing.

Yes, that's a missing feature, and I should add it. Thanks for pointing
that out.

(I'll also fix the binding docs issue that Shawn pointed out while I'm
at it).

-- 
nvpublic

