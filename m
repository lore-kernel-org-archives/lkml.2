Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2CNHgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:36:04 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:37006 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754184Ab2CNHgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:36:00 -0400
Date: Wed, 14 Mar 2012 08:23:43 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Dong Aisheng <b29396@freescale.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vinod.koul@linux.intel.com, s.hauer@pengutronix.de,
        rob.herring@calxeda.com, rdunlap@xenotime.net, kernel@pengutronix.de,
        cjb@laptop.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Message-ID: <20120314072343.GG18320@game.jcrosoft.org>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-3-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331628428-24017-3-git-send-email-b29396@freescale.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5352246683862215527
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehsphhinhhitghsrdhnvghtnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrfeejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpehsphhinhhitghsrdhnvghtnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:47 Tue 13 Mar     , Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> ---
> The patch is still using a private way for dma part binding
> since the common dma binding is still under discussion.
> http://www.spinics.net/lists/linux-omap/msg65528.html
> 
> Will update to use common dma binding when it hits mainline.
> ---
>  .../devicetree/bindings/mmc/fsl-mxs-mmc.txt        |   23 ++++++
>  drivers/mmc/host/mxs-mmc.c                         |   82 +++++++++++++++++++-
>  2 files changed, 102 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> new file mode 100644
> index 0000000..adc1142
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> @@ -0,0 +1,23 @@
> +* FREESCALE MXS MMC peripheral
> +
> +Required properties:
> +- compatible : Should be "fsl,<chip>-mmc"
> +- reg : Should contain registers location and length
> +- interrupts : Should contain interrupt.
> +  The format is <irq_err irq_dma>.
> +- dma_channel: Should contain the dma channel it uses
> +
> +Optional properties:
> +- wp-gpios : Specify GPIOs for write protection
> +- slot-4bit: Specify 4 bit mode support
> +- slot-8bit: Specify 8 bit and 4 bit mode support
> +
> +Examples:
> +mmc1: ssp@80010000 {
> +	compatible = "fsl,imx28-mmc";
> +	reg = <0x80010000 2000>;
> +	/* <irq_err irq_dma> */
> +	interrupts = <96 82>;
> +	dma_channel = <0>;
> +	slot-8bit;
> +};
> diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> index 382c835..6cf2d17 100644
> --- a/drivers/mmc/host/mxs-mmc.c
> +++ b/drivers/mmc/host/mxs-mmc.c
> @@ -38,6 +38,10 @@
>  #include <linux/gpio.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_gpio.h>
> +#include <linux/slab.h>
>  
>  #include <mach/mxs.h>
>  #include <mach/common.h>
> @@ -673,17 +677,79 @@ static bool mxs_mmc_dma_filter(struct dma_chan *chan, void *param)
>  	return true;
>  }
>  
> +#ifdef CONFIG_OF
> +static struct resource * __devinit mxs_mmc_get_of_dmares(
> +				struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct resource *dmares;
> +	int ret;
> +
> +	if (!np)
> +		return NULL;
> +
> +	dmares = kzalloc(sizeof(*dmares), GFP_KERNEL);
> +	dmares->flags = IORESOURCE_DMA;
> +	ret = of_property_read_u32(np, "dma_channel", &dmares->start);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to get dmares from dt\n");
> +		return NULL;
> +	}
> +	dmares->end = dmares->start;
> +
> +	return dmares;
> +}
> +
> +static int __devinit mxs_mmc_get_of_property(struct platform_device *pdev,
> +				struct mxs_mmc_platform_data **ppdata)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct mxs_mmc_platform_data *pdata = *ppdata;
> +
> +	if (!np)
> +		return -ENODEV;
> +
> +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> +
> +	if (of_get_property(np, "slot-8bit", NULL))
> +		pdata->flags |= SLOTF_8_BIT_CAPABLE;
> +
> +	if (of_get_property(np, "slot-4bit", NULL))
> +		pdata->flags |= SLOTF_4_BIT_CAPABLE;
it will conflit if both binding are set use a number instead

Best Regards,
J.
