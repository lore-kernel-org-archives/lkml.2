Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2JDRVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:21:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36125 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984Ab2JDRVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:21:24 -0400
X-Sasl-enc: JKg2DZhuAwZfF8ypVaUxKh7NUNryqW6rWAN0iqmXuQ6/ 1349371282
Date: Thu, 4 Oct 2012 10:21:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: nsekhar@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@ti.com, balbi@ti.com,
        miguel.aguilar@ridgerun.com, kernel-mentors@selenic.com
Subject: Re: [PATCH v4] Enable USB peripheral on dm365 EVM
Message-ID: <20121004172121.GB11478@kroah.com>
References: <1349367753-6725-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349367753-6725-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 06:22:33PM +0200, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
> ---
> 
> Note:
> 
> USBPHY_CTL_PADDR and USBPHY_CLKFREQ_24MHZ are defined in board-dm365-evm.c because davinci.h can't be included from drivers/usb/musb/. May be davinci.h should be renamed and moved to arch/arm/mach-davinci/include/mach/usb.h like arch/arm/plat-omap/include/plat/usb.h
> 
> Tested with usb gadget g_zero.
> 
> Changelog 
> 
> Changes since v3 http://www.spinics.net/lists/kernel/msg1412544.html:
> - removed optional altering of pr_info
> 
> Changes since v2 http://article.gmane.org/gmane.linux.kernel/1159868/
> - reordered code
> - removed alternation of GPIO33, which is multiplexed with DRVVBUS, because is not need for peripheral USB
> 
> Changes since v1 http://marc.info/?l=linux-kernel&m=130894150803661&w=2:
> - removed optional code and reordered
> 
> This patch is based on code from Arago, Angstom, and RidgeRun projects.
> Original patch by miguel.aguilar@ridgerun.com is three years ago:
> - http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14741.html

Almost all of the information you put below the --- line here, should be
above it, saying where the code originally came from, and most
importantly, what exactly this patch does, and for what hardware.  Your
one-line Subject really isn't that descriptive at all.

> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -2051,9 +2051,17 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
>  	dev_info(dev, "USB %s mode controller at %p using %s, IRQ %d\n",
>  			({char *s;
>  			 switch (musb->board_mode) {
> -			 case MUSB_HOST:		s = "Host"; break;
> -			 case MUSB_PERIPHERAL:	s = "Peripheral"; break;
> -			 default:		s = "OTG"; break;
> +			 case MUSB_HOST:
> +				s = "Host";
> +			 break;
> +			 case MUSB_PERIPHERAL:
> +				s = "Peripheral";
> +			 break;
> +			 case MUSB_OTG:
> +				s = "OTG";
> +			 break;
> +			 default:
> +				s = "Undefined";

Is this change really needed to get your hardware working?  Shouldn't it
be a separate patch?

greg k-h
