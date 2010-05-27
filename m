Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0E0PCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:02:44 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:35710 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0E0PCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:02:43 -0400
Date: Thu, 27 May 2010 17:02:38 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch,
       grant.likely@secretlab.ca, xiao-lizhang@freescale.com
Subject: Re: [PATCHv2 2.6.34 1/2] mx5: Add i2c to Freescale MX51 Babbage HW
Message-ID: <20100527150238.GH2695@buzzloop.caiaq.de>
References: <1274972269-6946-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274972269-6946-1-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 09:57:48AM -0500, Dinh.Nguyen@freescale.com wrote:
> This patch adds I2C functionality to the Freescale MX51 Babbage HW.
> The patch adds device structures, i2c board slave device defines,
> IOMUX pin defines, and clocks.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/clock-mx51.c              |   11 +++++
>  arch/arm/mach-mx5/devices.c                 |   58 +++++++++++++++++++++++++++
>  arch/arm/mach-mx5/devices.h                 |    3 +
>  arch/arm/plat-mxc/include/mach/iomux-mx51.h |   18 ++++++---
>  4 files changed, 84 insertions(+), 6 deletions(-)
> 

[...]

>  static struct resource usbotg_resources[] = {
> diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
> index 0494d6b..d0451bf 100644
> --- a/arch/arm/mach-mx5/devices.h
> +++ b/arch/arm/mach-mx5/devices.h
> @@ -5,3 +5,6 @@ extern struct platform_device mxc_fec_device;
>  extern struct platform_device mxc_usbdr_host_device;
>  extern struct platform_device mxc_usbh1_device;
>  extern struct platform_device mxc_usbdr_udc_device;
> +extern struct platform_device mxc_i2c_device0;
> +extern struct platform_device mxc_i2c_device1;
> +extern struct platform_device mxc_hsi2c_device;
> diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> index ab0f95d..6ea6861 100644
> --- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> +++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
> @@ -38,6 +38,8 @@ typedef enum iomux_config {
>  				PAD_CTL_SRE_FAST)
>  #define MX51_UART3_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_DSE_HIGH | \
>  				PAD_CTL_SRE_FAST)
> +#define MX51_I2C_PAD_CTRL		(PAD_CTL_SRE_FAST | PAD_CTL_ODE | \
> ++				PAD_CTL_DSE_HIGH | PAD_CTL_PUS_100K_UP | PAD_CTL_HYS)
   ^
I believe something went wrong here.

Daniel

