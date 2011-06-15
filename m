Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1FOTJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:09:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56419 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1FOTJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:09:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110615190754.11693.26335.stgit@ponder>
References: <20110615190754.11693.26335.stgit@ponder>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Jun 2011 13:08:48 -0600
X-Google-Sender-Auth: 9joi1qurpWbba9U3aJJPUglN5-w
Message-ID: <BANLkTikg=rzB3R3Gwed3+y1V8OXQhmm1Lg@mail.gmail.com>
Subject: Re: [PATCH] spi/tegra: add devicetree support
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Erik Gilling <konkers@android.com>
Cc: Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 1:07 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Allow the tegra spi driver to obtain populate the spi bus with devices
> from the device tree.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

I'll commit this to spi/next in a few days if nobody objects.

g.

> ---
>  .../devicetree/bindings/spi/spi_nvidia.txt         |    5 +++++
>  drivers/spi/spi-tegra.c                            |   12 ++++++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi_nvidia.txt
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
> diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
> index 8e30727..a43ceeb 100644
> --- a/drivers/spi/spi-tegra.c
> +++ b/drivers/spi/spi-tegra.c
> @@ -546,6 +546,7 @@ static int __init spi_tegra_probe(struct platform_device *pdev)
>        tspi->rx_dma_req.req_sel = spi_tegra_req_sels[pdev->id];
>        tspi->rx_dma_req.dev = tspi;
>
> +       master->dev.of_node = pdev->dev.of_node;
>        ret = spi_register_master(master);
>
>        if (ret < 0)
> @@ -595,10 +596,21 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
>
>  MODULE_ALIAS("platform:spi_tegra");
>
> +#ifdef CONFIG_OF
> +static struct of_device_id spi_tegra_of_match_table[] __devinitdata = {
> +       { .compatible = "nvidia,tegra250-spi", },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, spi_tegra_of_match_table);
> +#else /* CONFIG_OF */
> +#define spi_tegra_of_match_table NULL
> +#endif /* CONFIG_OF */
> +
>  static struct platform_driver spi_tegra_driver = {
>        .driver = {
>                .name =         "spi_tegra",
>                .owner =        THIS_MODULE,
> +               .of_match_table = spi_tegra_of_match_table,
>        },
>        .remove =       __devexit_p(spi_tegra_remove),
>  };
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
