Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab1KIJRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:17:21 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52078 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1KIJRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:17:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 4/5] ARM: OMAP3: bind omap3isp_device to its iommu device
Date: Wed, 9 Nov 2011 10:17:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com> <1316948337-7924-5-git-send-email-ohad@wizery.com>
In-Reply-To: <1316948337-7924-5-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111091017.18860.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Sunday 25 September 2011 12:58:56 Ohad Ben-Cohen wrote:
> Bind OMAP3's isp device to the isp's dedicated iommu, by setting
> the device's archdata iommu member.
> 
> This way omap3isp will be able to use the generic IOMMU API without
> having to call any omap-specific binding method.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm/mach-omap2/devices.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 1077ad6..44122f7 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -28,6 +28,7 @@
>  #include <plat/mcbsp.h>
>  #include <mach/gpio.h>
>  #include <plat/mmc.h>
> +#include <plat/iommu.h>
>  #include <plat/dma.h>
>  #include <plat/omap_hwmod.h>
>  #include <plat/omap_device.h>
> @@ -207,9 +208,15 @@ static struct platform_device omap3isp_device = {
>  	.resource	= omap3isp_resources,
>  };
> 
> +static struct omap_iommu_arch_data omap3_isp_iommu = {
> +	.name = "isp",
> +};
> +
>  int omap3_init_camera(struct isp_platform_data *pdata)
>  {
>  	omap3isp_device.dev.platform_data = pdata;
> +	omap3isp_device.dev.archdata.iommu = &omap3_isp_iommu;
> +
>  	return platform_device_register(&omap3isp_device);
>  }

-- 
Regards,

Laurent Pinchart
