Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2IRSYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:24:04 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:42592 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753566Ab2IRSYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OwSrLiciWmusKGhWGXK8T
Date: Tue, 18 Sep 2012 11:23:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: [PATCH 2/3] OMAP i2c: pinctrl-ify i2c-omap.c
Message-ID: <20120918182358.GZ11762@atomide.com>
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com>
 <1348070841-23354-3-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348070841-23354-3-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [120918 11:13]:
> Add support for pinctrl mux settings in the OMAP I2C driver.
> If no such pinctl bindings are found a warning message is printed.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>
> ---
>  drivers/i2c/busses/i2c-omap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index b149e32..f722478 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -43,6 +43,8 @@
>  #include <linux/slab.h>
>  #include <linux/i2c-omap.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>
>  
>  /* I2C controller revisions */
>  #define OMAP_I2C_OMAP1_REV_2		0x20
> @@ -1057,6 +1059,7 @@ omap_i2c_probe(struct platform_device *pdev)
>  	const struct of_device_id *match;
>  	int irq;
>  	int r;
> +	struct pinctrl *pinctrl;
>  
>  	/* NOTE: driver uses the static register mapping */
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1197,6 +1200,10 @@ omap_i2c_probe(struct platform_device *pdev)
>  
>  	of_i2c_register_devices(adap);
>  
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(dev->dev, "pins are not configured from the driver\n");
> +
>  	pm_runtime_mark_last_busy(dev->dev);
>  	pm_runtime_put_autosuspend(dev->dev);

This must be just a warning here as otherwise things will break
badly for drivers doing pinmuxing in bootloader only. Other than
that:

Acked-by: Tony Lindgren <tony@atomide.com>
