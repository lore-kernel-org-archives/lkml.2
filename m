Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358Ab2J3SSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:18:23 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17694 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965344Ab2J3SSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:18:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/oZxz1Vpwk2xW/hYCIH58O
Date: Tue, 30 Oct 2012 11:17:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: [PATCH] i2c: pinctrl-ify i2c-omap.c
Message-ID: <20121030181756.GL11908@atomide.com>
References: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [121030 11:04]:
> Enable pinctrl for i2c-omap.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Looks good to me:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/i2c/busses/i2c-omap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index db31eae..4c38aa0 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -44,6 +44,8 @@
>  #include <linux/i2c-omap.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pm_qos.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>
>  
>  /* I2C controller revisions */
>  #define OMAP_I2C_OMAP1_REV_2		0x20
> @@ -1064,6 +1066,7 @@ omap_i2c_probe(struct platform_device *pdev)
>  	const struct of_device_id *match;
>  	int irq;
>  	int r;
> +	struct pinctrl *pinctrl;
>  
>  	/* NOTE: driver uses the static register mapping */
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1202,6 +1205,13 @@ omap_i2c_probe(struct platform_device *pdev)
>  
>  	of_i2c_register_devices(adap);
>  
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(dev->dev, "unable to select pin group\n");
> +
> +	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", adap->nr,
> +		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
> +
>  	pm_runtime_mark_last_busy(dev->dev);
>  	pm_runtime_put_autosuspend(dev->dev);
>  
> -- 
> 1.7.12
> 
