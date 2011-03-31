Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546Ab1CaPyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:54:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56593 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab1CaPyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:54:11 -0400
Date: Thu, 31 Mar 2011 09:54:08 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 5/5] mmc: sdhci: merge two sdhci-pltfm.h into one
Message-ID: <20110331155408.GD26709@ponder.secretlab.ca>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-6-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301042931-4869-6-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 04:48:51PM +0800, Shawn Guo wrote:
> The structure sdhci_pltfm_data is not necessarily to be in a public
> header like include/linux/mmc/sdhci-pltfm.h, so the patch moves it
> into drivers/mmc/host/sdhci-pltfm.h and eliminates the former one.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>

Looks good to me.

> ---
>  drivers/mmc/host/sdhci-cns3xxx.c |    1 -
>  drivers/mmc/host/sdhci-esdhc.c   |    1 -
>  drivers/mmc/host/sdhci-pltfm.h   |    6 +++++-
>  include/linux/mmc/sdhci-pltfm.h  |   29 -----------------------------
>  4 files changed, 5 insertions(+), 32 deletions(-)
>  delete mode 100644 include/linux/mmc/sdhci-pltfm.h
> 
> diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
> index 95b9080..2238d34 100644
> --- a/drivers/mmc/host/sdhci-cns3xxx.c
> +++ b/drivers/mmc/host/sdhci-cns3xxx.c
> @@ -15,7 +15,6 @@
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/mmc/host.h>
> -#include <linux/mmc/sdhci-pltfm.h>
>  #include <mach/cns3xxx.h>
>  #include "sdhci.h"
>  #include "sdhci-pltfm.h"
> diff --git a/drivers/mmc/host/sdhci-esdhc.c b/drivers/mmc/host/sdhci-esdhc.c
> index b3d1bc1..fd041d9 100644
> --- a/drivers/mmc/host/sdhci-esdhc.c
> +++ b/drivers/mmc/host/sdhci-esdhc.c
> @@ -20,7 +20,6 @@
>  #include <linux/err.h>
>  #include <linux/clk.h>
>  #include <linux/mmc/host.h>
> -#include <linux/mmc/sdhci-pltfm.h>
>  #ifdef CONFIG_MMC_SDHCI_ESDHC_IMX
>  #include <mach/hardware.h>
>  #endif
> diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
> index 05fe25d..e2d143c 100644
> --- a/drivers/mmc/host/sdhci-pltfm.h
> +++ b/drivers/mmc/host/sdhci-pltfm.h
> @@ -14,9 +14,13 @@
>  #include <linux/clk.h>
>  #include <linux/types.h>
>  #include <linux/platform_device.h>
> -#include <linux/mmc/sdhci-pltfm.h>
>  #include <linux/mmc/sdhci.h>
>  
> +struct sdhci_pltfm_data {
> +	struct sdhci_ops *ops;
> +	unsigned int quirks;
> +};
> +
>  struct sdhci_pltfm_host {
>  	struct clk *clk;
>  	u32 scratchpad; /* to handle quirks across io-accessor calls */
> diff --git a/include/linux/mmc/sdhci-pltfm.h b/include/linux/mmc/sdhci-pltfm.h
> deleted file mode 100644
> index f1c2ac3..0000000
> --- a/include/linux/mmc/sdhci-pltfm.h
> +++ /dev/null
> @@ -1,29 +0,0 @@
> -/*
> - * Platform data declarations for the sdhci-pltfm driver.
> - *
> - * Copyright (c) 2010 MontaVista Software, LLC.
> - *
> - * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or (at
> - * your option) any later version.
> - */
> -
> -#ifndef _SDHCI_PLTFM_H
> -#define _SDHCI_PLTFM_H
> -
> -struct sdhci_ops;
> -
> -/**
> - * struct sdhci_pltfm_data - SDHCI platform-specific information & hooks
> - * @ops: optional pointer to the platform-provided SDHCI ops
> - * @quirks: optional SDHCI quirks
> - */
> -struct sdhci_pltfm_data {
> -	struct sdhci_ops *ops;
> -	unsigned int quirks;
> -};
> -
> -#endif /* _SDHCI_PLTFM_H */
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
