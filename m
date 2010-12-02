Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0LBGZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:25:16 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42991 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab0LBGZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:25:14 -0500
Date: Thu, 2 Dec 2010 11:55:40 +0530
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: srinath@mistralsolutions.com
Cc: linux-omap@vger.kernel.org, jdk@ti.com, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, khilman@deeprootsystems.com,
        nm@ti.com, nagendra@mistralsolutions.com, umeshk@mistralsolutions.com
Subject: Re: [Patch v3] AM35xx: Craneboard: Add USB EHCI support
Message-ID: <20101202062539.GB5645@GLPP-machine>
References: <1291222730-17614-1-git-send-email-srinath@mistralsolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291222730-17614-1-git-send-email-srinath@mistralsolutions.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* srinath@mistralsolutions.com <srinath@mistralsolutions.com> [2010-12-01 22:28:50 +0530]:

> From: Srinath <srinath@mistralsolutions.com>
> 
> AM3517/05 Craneboard has one EHCI interface on board using port1.
> 
> GPIO35 is used as power enable.
> GPIO38 is used as port1 PHY reset.
> 
> History:
> http://marc.info/?l=linux-omap&w=2&r=1&s=Craneboard%3A+Add+USB+EHCI+support&q=t
> 
> Signed-off-by: Srinath <srinath@mistralsolutions.com>
> ---
>  arch/arm/mach-omap2/board-am3517crane.c |   40 +++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
> index 13ead33..6fd5dfe 100644
> --- a/arch/arm/mach-omap2/board-am3517crane.c
> +++ b/arch/arm/mach-omap2/board-am3517crane.c
> @@ -28,8 +28,13 @@
>  
[...]
>  static void __init am3517_crane_init(void)
>  {
> +	int ret;
> +
>  	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
>  	omap_serial_init();
> +
> +	/* Configure GPIO for EHCI port */
> +	omap_mux_init_gpio(GPIO_USB_POWER, OMAP_PIN_OUTPUT);

This is non void function. You can consider return value for further
processing.

> +
> +	ret = gpio_request(GPIO_USB_POWER, "usb_ehci_enable");
> +	if (ret < 0) {
> +		pr_err("Cannot request GPIO %d\n", GPIO_USB_POWER);
> +		return;
> +	}
> +
> +	ret = gpio_direction_output(GPIO_USB_POWER, 1);
> +	if (ret < 0)
> +		goto err;
> +
> +	omap_mux_init_gpio(GPIO_USB_NRESET, OMAP_PIN_OUTPUT);

-Ditto-

Also, why there is no gpio_request for "GPIO_USB_NRESET"

-Manjunath

[...]
