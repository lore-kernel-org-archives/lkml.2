Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1IRACY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 20:02:24 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40984 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab1IRACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 20:02:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] iommu/omap: Fix build error with !IOMMU_SUPPORT
Date: Sun, 18 Sep 2011 02:02:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.1; x86_64; ; )
Cc: linux-omap@vger.kernel.org, "Ohad Ben-Cohen" <ohad@wizery.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1316009259-18052-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109180202.23123.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Wednesday 14 September 2011 16:07:39 Joerg Roedel wrote:
> Without this patch it is possible to select the VIDEO_OMAP3
> driver which then selects OMAP_IOVMM. But the omap iommu
> driver is not compiled without IOMMU_SUPPORT enabled. Fix
> that by forcing OMAP_IOMMU and OMAP_IOVMM are enabled before
> VIDEO_OMAP3 can be selected.

What about making VIDEO_OMAP3 select IOMMU_SUPPORT instead then ? Your patch 
would make the OMAP3 ISP driver disappear from the menu until IOMMU_SUPPORT 
gets turned on, which can confuse users.

> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: iommu@lists.linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/iommu/Kconfig       |    4 ++--
>  drivers/media/video/Kconfig |    3 +--
>  2 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index d901930..ae46776 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -114,8 +114,8 @@ config OMAP_IOMMU
>  	select IOMMU_API
> 
>  config OMAP_IOVMM
> -	tristate
> -	select OMAP_IOMMU
> +	tristate "OMAP IO Virtual Memory Manager Support"
> +	depends on OMAP_IOMMU
> 
>  config OMAP_IOMMU_DEBUG
>         tristate "Export OMAP IOMMU/IOVMM internals in DebugFS"
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 6a25fad..6201069 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -763,8 +763,7 @@ source "drivers/media/video/m5mols/Kconfig"
> 
>  config VIDEO_OMAP3
>  	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
> -	select OMAP_IOVMM
> -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3 &&
> EXPERIMENTAL
> +	depends on OMAP_IOVMM && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API &&
> ARCH_OMAP3 && EXPERIMENTAL
> ---help---
>  	  Driver for an OMAP 3 camera controller.

-- 
Regards,

Laurent Pinchart
