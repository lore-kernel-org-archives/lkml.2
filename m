Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1FOT0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:26:01 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6999 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1FOT0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:26:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 15 Jun 2011 12:25:51 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erik Gilling <konkers@android.com>
Date: Wed, 15 Jun 2011 12:25:49 -0700
Subject: RE: [PATCH] spi/tegra: add devicetree support
Thread-Topic: [PATCH] spi/tegra: add devicetree support
Thread-Index: Acwrj4o39AZswFKySeqpBfukwPGwjgAAjnLQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04992C060C@HQMAIL01.nvidia.com>
References: <20110615190754.11693.26335.stgit@ponder>
In-Reply-To: <20110615190754.11693.26335.stgit@ponder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5FJQHaD021460

Grant Likely wrote at Wednesday, June 15, 2011 1:08 PM:
> Allow the tegra spi driver to obtain populate the spi bus with devices

Remote "obtain"?

> from the device tree.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  .../devicetree/bindings/spi/spi_nvidia.txt         |    5 +++++
>  drivers/spi/spi-tegra.c                            |   12 ++++++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi_nvidia.txt
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi_nvidia.txt b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
> new file mode 100644
> index 0000000..bde450b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/spi_nvidia.txt
> @@ -0,0 +1,5 @@
> +NVIDIA Tegra 2 SPI device
> +
> +Required properties:
> +- compatible : should be "nvidia,tegra250-spi".
> +- gpios : should specify GPIOs used for chipselect.

Are things like reg, interrupts, and other general stuff implicit?
I notice that fsl-spi.txt does specify those, but spi_altera.txt
and spi_oc_tiny.txt don't.

Otherwise, LGTM.

> diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
> index 8e30727..a43ceeb 100644
> --- a/drivers/spi/spi-tegra.c
> +++ b/drivers/spi/spi-tegra.c
> @@ -546,6 +546,7 @@ static int __init spi_tegra_probe(struct
> platform_device *pdev)
>  	tspi->rx_dma_req.req_sel = spi_tegra_req_sels[pdev->id];
>  	tspi->rx_dma_req.dev = tspi;
> 
> +	master->dev.of_node = pdev->dev.of_node;
>  	ret = spi_register_master(master);
> 
>  	if (ret < 0)
> @@ -595,10 +596,21 @@ static int __devexit spi_tegra_remove(struct
> platform_device *pdev)
> 
>  MODULE_ALIAS("platform:spi_tegra");
> 
> +#ifdef CONFIG_OF
> +static struct of_device_id spi_tegra_of_match_table[] __devinitdata = {
> +	{ .compatible = "nvidia,tegra250-spi", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, spi_tegra_of_match_table);
> +#else /* CONFIG_OF */
> +#define spi_tegra_of_match_table NULL
> +#endif /* CONFIG_OF */
> +
>  static struct platform_driver spi_tegra_driver = {
>  	.driver = {
>  		.name =		"spi_tegra",
>  		.owner =	THIS_MODULE,
> +		.of_match_table = spi_tegra_of_match_table,
>  	},
>  	.remove =	__devexit_p(spi_tegra_remove),
>  };

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
