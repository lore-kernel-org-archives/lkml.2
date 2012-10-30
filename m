Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391Ab2J3S0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:26:32 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:33666 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933952Ab2J3S0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:26:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/cQZEu/VZeb2zdI27VtaxL
Date: Tue, 30 Oct 2012 11:26:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] w1-gpio: Pinctrl-fy
Message-ID: <20121030182625.GP11908@atomide.com>
References: <1351699058-4576-1-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351699058-4576-1-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [121030 11:17]:
> Enable pinctrl for w1-gpio.
>
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/w1/masters/w1-gpio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> index 6012c4e..aec35bd 100644
> --- a/drivers/w1/masters/w1-gpio.c
> +++ b/drivers/w1/masters/w1-gpio.c
> @@ -16,6 +16,8 @@
>  #include <linux/gpio.h>
>  #include <linux/of_platform.h>
>  #include <linux/of_gpio.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>
>  
>  #include "../w1.h"
>  #include "../w1_int.h"
> @@ -85,8 +87,13 @@ static int __init w1_gpio_probe(struct platform_device *pdev)
>  {
>  	struct w1_bus_master *master;
>  	struct w1_gpio_platform_data *pdata;
> +	struct pinctrl *pinctrl;
>  	int err;
>  
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(&pdev->dev, "unable to select pin group\n");
> +
>  	err = w1_gpio_probe_dt(pdev);
>  	if (err < 0)
>  		return err;
> -- 
> 1.7.12
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
