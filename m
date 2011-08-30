Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1H3DcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 23:32:03 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:19233
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751036Ab1H3DcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 23:32:00 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz14e0M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 30 Aug 2011 11:40:36 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Chris Ball <cjb@laptop.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] sdhci/tegra: Add Device Tree probing support
Message-ID: <20110830034035.GC19294@S2100-06.ap.freescale.net>
References: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314123334-23133-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 12:15:33PM -0600, Stephen Warren wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> Add hooks to read gpio configuration out of the device tree node.
> 
> [grant.likely: Rewrite of original patch from John Bonesio]
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> [swarren: Fixed tegra_sdhci_get_ro() to retrieve pdata correctly]
> [swarren: Reworked to avoid #ifdef CONFIG_OF]
> [swarren: Reworked binding based on fsl-imx-esdhc.txt]
> [swarren: Documented binding]
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Theoretically, these two patches should be merged in order in one place,
> since the 2nd logically depends on the first. However, it's really just
> a documentation dependency, so I think it's fine to merge them into the
> MMC and DT trees separately and let them meet in linux-next.
> 
>  .../devicetree/bindings/mmc/nvidia-sdhci.txt       |   25 ++++++++++
>  drivers/mmc/host/sdhci-tegra.c                     |   51 +++++++++++++++----
>  2 files changed, 65 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
> 
> diff --git a/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
> new file mode 100644
> index 0000000..c87f667
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/nvidia-sdhci.txt
> @@ -0,0 +1,25 @@
> +* NVIDIA Tegra Secure Digital Host Controller
> +
> +This controller on Tegra family SoCs provides an interface for MMC, SD,
> +and SDIO types of memory cards.
> +
> +Required properties:
> +- compatible : Should be "nvidia,<chip>-sdhci"
> +- reg : Should contain eSDHC registers location and length
> +- interrupts : Should contain eSDHC interrupt

You may want to replace eSDHC with something Tegra specific.

-- 
Regards,
Shawn

