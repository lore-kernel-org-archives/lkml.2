Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab0HMK4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:56:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44510 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934171Ab0HMK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:56:12 -0400
Message-ID: <4C65246E.1000906@ru.mvista.com>
Date: Fri, 13 Aug 2010 14:54:38 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Igor Grinberg <grinberg@compulab.co.il>,
        Mike Rapoport <mike@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] ARM: imx: fix build failure concerning otg/ulpi
References: <1275464450-23003-2-git-send-email-grinberg@compulab.co.il> <1281694891-7527-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1281694891-7527-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Uwe Kleine-König wrote:

> The build failure was introduced by
> 
> 	13dd0c9 (USB: otg/ulpi: extend the generic ulpi driver.)

> Cc: Igor Grinberg <grinberg@compulab.co.il>
> Cc: Mike Rapoport <mike@compulab.co.il>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

    Signoff is missing.


> diff --git a/arch/arm/mach-imx/mach-cpuimx27.c b/arch/arm/mach-imx/mach-cpuimx27.c
> index 575ff1a..339150a 100644
> --- a/arch/arm/mach-imx/mach-cpuimx27.c
> +++ b/arch/arm/mach-imx/mach-cpuimx27.c
> @@ -279,13 +279,13 @@ static void __init eukrea_cpuimx27_init(void)
>  #if defined(CONFIG_USB_ULPI)
>  	if (otg_mode_host) {
>  		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
>  
>  		mxc_register_device(&mxc_otg_host, &otg_pdata);
>  	}
>  
>  	usbh2_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
>  
>  	mxc_register_device(&mxc_usbh2, &usbh2_pdata);
>  #endif
> diff --git a/arch/arm/mach-imx/mach-pca100.c b/arch/arm/mach-imx/mach-pca100.c
> index a389d11..23c9e1f 100644
> --- a/arch/arm/mach-imx/mach-pca100.c
> +++ b/arch/arm/mach-imx/mach-pca100.c
> @@ -419,13 +419,13 @@ static void __init pca100_init(void)
>  #if defined(CONFIG_USB_ULPI)
>  	if (otg_mode_host) {
>  		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
>  
>  		mxc_register_device(&mxc_otg_host, &otg_pdata);
>  	}
>  
>  	usbh2_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
>  
>  	mxc_register_device(&mxc_usbh2, &usbh2_pdata);
>  #endif
> diff --git a/arch/arm/mach-mx25/mach-cpuimx25.c b/arch/arm/mach-mx25/mach-cpuimx25.c
> index 56b2e26..0134fb8 100644
> --- a/arch/arm/mach-mx25/mach-cpuimx25.c
> +++ b/arch/arm/mach-mx25/mach-cpuimx25.c
> @@ -138,7 +138,7 @@ static void __init eukrea_cpuimx25_init(void)
>  #if defined(CONFIG_USB_ULPI)
>  	if (otg_mode_host) {
>  		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				USB_OTG_DRV_VBUS | ULPI_OTG_DRVVBUS_EXT);

    Not ULPI_OTG_DRVVBUS, like in other cases?

>  
>  		mxc_register_device(&mxc_otg, &otg_pdata);
>  	}
> diff --git a/arch/arm/mach-mx3/mach-cpuimx35.c b/arch/arm/mach-mx3/mach-cpuimx35.c
> index 63f970f..117f90e 100644
> --- a/arch/arm/mach-mx3/mach-cpuimx35.c
> +++ b/arch/arm/mach-mx3/mach-cpuimx35.c
> @@ -192,7 +192,7 @@ static void __init mxc_board_init(void)
>  #if defined(CONFIG_USB_ULPI)
>  	if (otg_mode_host) {
>  		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				USB_OTG_DRV_VBUS | ULPI_OTG_DRVVBUS_EXT);

    Same question here...

WBR, Sergei

