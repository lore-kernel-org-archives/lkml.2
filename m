Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0HIC7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 22:59:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52300 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0HIC7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 22:59:30 -0400
X-User-Agent: K-9 Mail for Android
References: <20100809120509.be36a4fa.sfr@canb.auug.org.au>
In-Reply-To: <20100809120509.be36a4fa.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: manual merge of the spi tree with the devicetree tree
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 08 Aug 2010 20:59:51 -0600
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>
Message-ID: <1aa23ac2-1958-47e9-9697-1ec47baab366@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



"Stephen Rothwell" <sfr@canb.auug.org.au> wrote:

>Hi Grant,
>
>Today's linux-next merge of the spi tree got a conflict in
>drivers/spi/mpc512x_psc_spi.c between commit
>2dc11581376829303b98eadb2de253bee065a56a ("of/device: Replace struct
>of_device with struct platform_device") from the devicetree tree and
>commit cf40f082f8d3a98e28af02af20d00d2500eb6a65 ("spi/mpc5121: change
>annotations for probe and remove functions") from the spi tree.
>
>I fixed it up (as suggested by you - see below) and can carry the fix as
>necessary.
>
>I also added this merge fix patch (as suggest by you):

Thanks Stephen.

g.

>
>From: Stephen Rothwell <sfr@canb.auug.org.au>
>Date: Mon, 9 Aug 2010 12:02:19 +1000
>Subject: [PATCH] spi: update for of_device to platform_device replacement
>
>Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>---
> drivers/ata/sata_dwc_460ex.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
>index ea24c1e..2673a3d 100644
>--- a/drivers/ata/sata_dwc_460ex.c
>+++ b/drivers/ata/sata_dwc_460ex.c
>@@ -1588,7 +1588,7 @@ static const struct ata_port_info sata_dwc_port_info[] = {
> 	},
> };
> 
>-static int sata_dwc_probe(struct of_device *ofdev,
>+static int sata_dwc_probe(struct platform_device *ofdev,
> 			const struct of_device_id *match)
> {
> 	struct sata_dwc_device *hsdev;
>@@ -1702,7 +1702,7 @@ error_out:
> 	return err;
> }
> 
>-static int sata_dwc_remove(struct of_device *ofdev)
>+static int sata_dwc_remove(struct platform_device *ofdev)
> {
> 	struct device *dev = &ofdev->dev;
> 	struct ata_host *host = dev_get_drvdata(dev);
>-- 
>1.7.1
>
>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>
>diff --cc drivers/spi/mpc512x_psc_spi.c
>index cddbfce,c8d69fc..0000000
>--- a/drivers/spi/mpc512x_psc_spi.c
>+++ b/drivers/spi/mpc512x_psc_spi.c
>@@@ -507,8 -505,8 +507,8 @@@ static int __devexit mpc512x_psc_spi_do
>  	return 0;
>  }
>  
>- static int __init mpc512x_psc_spi_of_probe(struct platform_device *op,
> -static int __devinit mpc512x_psc_spi_of_probe(struct of_device *op,
> -					      const struct of_device_id *match)
>++static int __devinit mpc512x_psc_spi_of_probe(struct platform_device *op,
> +					   const struct of_device_id *match)
>  {
>  	const u32 *regaddr_p;
>  	u64 regaddr64, size64;
>@@@ -539,7 -537,7 +539,7 @@@
>  				irq_of_parse_and_map(op->dev.of_node, 0), id);
>  }
>  
>- static int __exit mpc512x_psc_spi_of_remove(struct platform_device *op)
> -static int __devexit mpc512x_psc_spi_of_remove(struct of_device *op)
>++static int __devexit mpc512x_psc_spi_of_remove(struct platform_device *op)
>  {
>  	return mpc512x_psc_spi_do_remove(&op->dev);
>  }

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
