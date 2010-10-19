Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab0JSLP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:15:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:29516 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758333Ab0JSLP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:15:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="848621491"
Date: Tue, 19 Oct 2010 13:15:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Factor out WM831x I2C I/O from the core driver
Message-ID: <20101019111553.GO2736@sortiz-mobl>
References: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Oct 08, 2010 at 02:23:22PM -0700, Mark Brown wrote:
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index 1e4d78a..546db5c 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -185,6 +185,7 @@ config SMDK6410_WM1192_EV1
>  	select REGULATOR_WM831X
>  	select S3C24XX_GPIO_EXTRA64
>  	select MFD_WM831X
> +	select MFD_WM831X_I2C
>  	help
>  	  The Wolfson Microelectronics 1192-EV1 is a WM831x based PMIC
>  	  daughtercard for the Samsung SMDK6410 reference platform.
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 6c6b9f0..608a277 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -315,14 +315,18 @@ config MFD_WM8400
>  	  the functionality of the device.
>  
>  config MFD_WM831X
> -	bool "Support Wolfson Microelectronics WM831x/2x PMICs"
> +	bool
> +	depends on GENERIC_HARDIRQS
> +
> +config MFD_WM831X_I2C
> +	bool "Support Wolfson Microelectronics WM831x/2x PMICs with I2C"
>  	select MFD_CORE
I think we should select MFD_WM831X here as well otherwise there's nothing
preventing us from building the I2C or the SPI part without the core one. And
that leads to a build breakage.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
