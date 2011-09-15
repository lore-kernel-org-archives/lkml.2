Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246Ab1IORQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:16:41 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34524 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab1IORQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:16:39 -0400
Date: Thu, 15 Sep 2011 11:16:34 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Luciano Coelho <coelho@ti.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, matti.j.aaltonen@nokia.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] mfd: Combine MFD_SUPPORT and MFD_CORE
Message-ID: <20110915171634.GD3523@ponder.secretlab.ca>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
 <1314643307-17780-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314643307-17780-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 09:41:47PM +0300, Luciano Coelho wrote:
> ---
> @@ -417,7 +417,6 @@ config GPIO_TIMBERDALE
>  config GPIO_RDC321X
>  	tristate "RDC R-321x GPIO support"
>  	depends on PCI
> -	select MFD_SUPPORT
>  	select MFD_CORE
>  	select MFD_RDC321X
>  	help
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 21574bd..1836cdf 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -2,10 +2,9 @@
>  # Multifunction miscellaneous devices
>  #
>  
> -menuconfig MFD_SUPPORT
> -	bool "Multifunction device drivers"
> +menuconfig MFD_CORE
> +	tristate "Multifunction device drivers"
>  	depends on HAS_IOMEM
> -	default y

Looks like there is a bug here.  Kconfig symbols with dependencies
(HAS_IOMEM) must not ever be selected by other symbols because Kconfig
doesn't implement a way to resolve them.  This patch means that every
"select MFD_CORE" just assumes that HAS_IOMEM is also selected.

g.

