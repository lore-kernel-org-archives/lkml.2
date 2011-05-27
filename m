Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510Ab1E0HJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:09:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41368 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1E0HJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:09:14 -0400
Date: Fri, 27 May 2011 01:09:13 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] pch_gpio: Support new device ML7223
Message-ID: <20110527070913.GB31953@ponder.secretlab.ca>
References: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304938729-10609-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 07:58:49PM +0900, Tomoya MORINAGA wrote:
> Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
> The ML7223 IOH is for MP(Media Phone) use.
> The ML7223 is companion chip for Intel Atom E6xx series.
> The ML7223 is completely compatible for Intel EG20T PCH.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

I merged this version.  Since the device ids are local only to this
driver, there is no need to add them to pci_ids.h

Thanks,
g.

> ---
>  drivers/gpio/Kconfig    |    8 +++++++-
>  drivers/gpio/pch_gpio.c |    2 ++
>  2 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d3b2953..c0326da 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -329,13 +329,19 @@ config GPIO_LANGWELL
>  	  Say Y here to support Intel Langwell/Penwell GPIO.
>  
>  config GPIO_PCH
> -	tristate "PCH GPIO of Intel Topcliff"
> +	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GPIO"
>  	depends on PCI && X86
>  	help
>  	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
>  	  which is an IOH(Input/Output Hub) for x86 embedded processor.
>  	  This driver can access PCH GPIO device.
>  
> +	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
> +	  Output Hub), ML7223.
> +	  ML7223 IOH is for MP(Media Phone) use.
> +	  ML7223 is companion chip for Intel Atom E6xx series.
> +	  ML7223 is completely compatible for Intel EG20T PCH.
> +
>  config GPIO_ML_IOH
>  	tristate "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
>  	depends on PCI
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> index f970a5f..36919e7 100644
> --- a/drivers/gpio/pch_gpio.c
> +++ b/drivers/gpio/pch_gpio.c
> @@ -283,8 +283,10 @@ static int pch_gpio_resume(struct pci_dev *pdev)
>  #define pch_gpio_resume NULL
>  #endif
>  
> +#define PCI_VENDOR_ID_ROHM             0x10DB
>  static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
> -- 
> 1.7.4
> 
