Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab1J2XtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:49:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41362 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab1J2XtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:49:11 -0400
Date: Sat, 29 Oct 2011 17:12:15 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/2] pch_gpio: Support new device LAPIS Semiconductor
 ML7831 IOH
Message-ID: <20111029151215.GB10954@ponder.secretlab.ca>
References: <1319761413-6438-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319761413-6438-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 09:23:32AM +0900, Tomoya MORINAGA wrote:
> ML7831 is companion chip for Intel Atom E6xx series.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

Applied for 3.3, thanks.

g.

> ---
>  drivers/gpio/Kconfig    |   11 ++++++-----
>  drivers/gpio/gpio-pch.c |    1 +
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index a107d44..82c4496 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -387,7 +387,7 @@ config GPIO_LANGWELL
>  	  Say Y here to support Intel Langwell/Penwell GPIO.
>  
>  config GPIO_PCH
> -	bool "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GPIO"
> +	bool "Intel EG20T PCH/LAPIS Semiconductor IOH(ML7223/ML7831) GPIO"
>  	depends on PCI && X86
>  	select GENERIC_IRQ_CHIP
>  	help
> @@ -395,11 +395,12 @@ config GPIO_PCH
>  	  which is an IOH(Input/Output Hub) for x86 embedded processor.
>  	  This driver can access PCH GPIO device.
>  
> -	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
> -	  Output Hub), ML7223.
> +	  This driver also can be used for LAPIS Semiconductor IOH(Input/
> +	  Output Hub), ML7223 and ML7831.
>  	  ML7223 IOH is for MP(Media Phone) use.
> -	  ML7223 is companion chip for Intel Atom E6xx series.
> -	  ML7223 is completely compatible for Intel EG20T PCH.
> +	  ML7831 IOH is for general purpose use.
> +	  ML7223/ML7831 is companion chip for Intel Atom E6xx series.
> +	  ML7223/ML7831 is completely compatible for Intel EG20T PCH.
>  
>  config GPIO_ML_IOH
>  	bool "OKI SEMICONDUCTOR ML7213 IOH GPIO support"
> diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
> index 64b0e39..8d9116f 100644
> --- a/drivers/gpio/gpio-pch.c
> +++ b/drivers/gpio/gpio-pch.c
> @@ -524,6 +524,7 @@ static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8043) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8803) },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
> -- 
> 1.7.4.4
> 
