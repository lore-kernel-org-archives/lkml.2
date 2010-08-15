Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0HOGGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 02:06:15 -0400
Received: from compulab.co.il ([67.18.134.219]:45582 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab0HOGGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 02:06:14 -0400
Message-ID: <4C6783C7.1030604@compulab.co.il>
Date: Sun, 15 Aug 2010 09:05:59 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.1.9) Gecko/20100504 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Sergei Shtylyov <sshtylyov@mvista.com>,
        Mike Rapoport <mike@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH v2] ARM: imx: fix build failure concerning otg/ulpi
References: <4C65246E.1000906@ru.mvista.com> <1281701210-27776-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1281701210-27776-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/10 15:06, Uwe Kleine-König wrote:
> The build failure was introduced by
>
> 	13dd0c9 (USB: otg/ulpi: extend the generic ulpi driver.)
>
> Cc: Igor Grinberg <grinberg@compulab.co.il>
> Cc: Mike Rapoport <mike@compulab.co.il>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>   

I've based my patches on v2.6.35-rc6, so I could not patch
those imx variants, sorry...
But I did deal with mach-pca100.c, so I think moving it from
mach-mx2 to mach-imx is what made it miss my patch.

Anyway, this looks like the right addition.

Thanks

> ---
>  arch/arm/mach-imx/mach-cpuimx27.c  |    4 ++--
>  arch/arm/mach-imx/mach-pca100.c    |    4 ++--
>  arch/arm/mach-mx25/mach-cpuimx25.c |    2 +-
>  arch/arm/mach-mx3/mach-cpuimx35.c  |    2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
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
> index 56b2e26..a5f0174 100644
> --- a/arch/arm/mach-mx25/mach-cpuimx25.c
> +++ b/arch/arm/mach-mx25/mach-cpuimx25.c
> @@ -138,7 +138,7 @@ static void __init eukrea_cpuimx25_init(void)
>  #if defined(CONFIG_USB_ULPI)
>  	if (otg_mode_host) {
>  		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
>  
>  		mxc_register_device(&mxc_otg, &otg_pdata);
>  	}
> diff --git a/arch/arm/mach-mx3/mach-cpuimx35.c b/arch/arm/mach-mx3/mach-cpuimx35.c
> index 63f970f..9770a6a 100644
> --- a/arch/arm/mach-mx3/mach-cpuimx35.c
> +++ b/arch/arm/mach-mx3/mach-cpuimx35.c
> @@ -192,7 +192,7 @@ static void __init mxc_board_init(void)
>  #if defined(CONFIG_USB_ULPI)
>  	if (otg_mode_host) {
>  		otg_pdata.otg = otg_ulpi_create(&mxc_ulpi_access_ops,
> -				USB_OTG_DRV_VBUS | USB_OTG_DRV_VBUS_EXT);
> +				ULPI_OTG_DRVVBUS | ULPI_OTG_DRVVBUS_EXT);
>  
>  		mxc_register_device(&mxc_otg_host, &otg_pdata);
>  	}
>   

-- 
Regards,
Igor.

