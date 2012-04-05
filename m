Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2DERTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 13:19:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52173 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab2DERTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 13:19:19 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: use module_pci_driver
To: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <1333549772.5856.3.camel@phoenix>
References: <1333549772.5856.3.camel@phoenix>
Date: Thu, 05 Apr 2012 10:19:16 -0700
Message-Id: <20120405171916.134173E044B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2012 22:29:32 +0800, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/spi/* to use module_pci_driver()
> macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-dw-pci.c     |   13 +------------
>  drivers/spi/spi-pxa2xx-pci.c |   12 +-----------
>  2 files changed, 2 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw-pci.c b/drivers/spi/spi-dw-pci.c
> index 14f7cc9..ff81abb 100644
> --- a/drivers/spi/spi-dw-pci.c
> +++ b/drivers/spi/spi-dw-pci.c
> @@ -164,18 +164,7 @@ static struct pci_driver dw_spi_driver = {
>  	.resume	=	spi_resume,
>  };
>  
> -static int __init mrst_spi_init(void)
> -{
> -	return pci_register_driver(&dw_spi_driver);
> -}
> -
> -static void __exit mrst_spi_exit(void)
> -{
> -	pci_unregister_driver(&dw_spi_driver);
> -}
> -
> -module_init(mrst_spi_init);
> -module_exit(mrst_spi_exit);
> +module_pci_driver(dw_spi_driver);
>  
>  MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
>  MODULE_DESCRIPTION("PCI interface driver for DW SPI Core");
> diff --git a/drivers/spi/spi-pxa2xx-pci.c b/drivers/spi/spi-pxa2xx-pci.c
> index 3fb44af..9f6ba34 100644
> --- a/drivers/spi/spi-pxa2xx-pci.c
> +++ b/drivers/spi/spi-pxa2xx-pci.c
> @@ -164,17 +164,7 @@ static struct pci_driver ce4100_spi_driver = {
>  	.remove         = __devexit_p(ce4100_spi_remove),
>  };
>  
> -static int __init ce4100_spi_init(void)
> -{
> -	return pci_register_driver(&ce4100_spi_driver);
> -}
> -module_init(ce4100_spi_init);
> -
> -static void __exit ce4100_spi_exit(void)
> -{
> -	pci_unregister_driver(&ce4100_spi_driver);
> -}
> -module_exit(ce4100_spi_exit);
> +module_pci_driver(ce4100_spi_driver);
>  
>  MODULE_DESCRIPTION("CE4100 PCI-SPI glue code for PXA's driver");
>  MODULE_LICENSE("GPL v2");
> -- 
> 1.7.5.4
> 
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
