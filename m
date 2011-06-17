Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1FQAtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:49:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62054 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950Ab1FQAtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:49:47 -0400
Date: Thu, 16 Jun 2011 18:49:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] spi-topcliff-pch: Support new device ML7223 IOH
Message-ID: <20110617004944.GA10160@ponder.secretlab.ca>
References: <1308270865-18878-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308270865-18878-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 09:34:25AM +0900, Tomoya MORINAGA wrote:
> Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
> The ML7223 IOH is for MP(Media Phone) use.
> The ML7223 is companion chip for Intel Atom E6xx series.
> The ML7223 is completely compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-topcliff-pch.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index 1b8030b..5b574cf 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -95,11 +95,13 @@
>  /* Definition for ML7213 by OKI SEMICONDUCTOR */
>  #define PCI_VENDOR_ID_ROHM		0x10DB
>  #define PCI_DEVICE_ID_ML7213_SPI	0x802c
> +#define PCI_DEVICE_ID_ML7223_SPI	0x800F
>  
>  /*
>   * Set the number of SPI instance max
>   * Intel EG20T PCH :		1ch
>   * OKI SEMICONDUCTOR ML7213 IOH :	2ch
> + * OKI SEMICONDUCTOR ML7223 IOH :	1ch
>  */
>  #define PCH_SPI_MAX_DEV			2
>  
> @@ -212,6 +214,7 @@ struct pch_pd_dev_save {
>  static struct pci_device_id pch_spi_pcidev_id[] = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_GE_SPI),    1, },
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_SPI), 2, },
> +	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7223_SPI), 1, },
>  	{ }
>  };
>  
> @@ -1711,4 +1714,4 @@ MODULE_PARM_DESC(use_dma,
>  		 "to use DMA for data transfers pass 1 else 0; default 1");
>  
>  MODULE_LICENSE("GPL");
> -MODULE_DESCRIPTION("Intel EG20T PCH/OKI SEMICONDUCTOR ML7213 IOH SPI Driver");
> +MODULE_DESCRIPTION("Intel EG20T PCH / OKI SEMICONDUCTOR ML7xxx IOH SPI Driver");
> -- 
> 1.7.4
> 
