Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2IUH22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:28:28 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59207 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755761Ab2IUH20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:28:26 -0400
Message-ID: <505C1751.50501@ti.com>
Date: Fri, 21 Sep 2012 10:29:21 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2/3] OMAP i2c: pinctrl-ify i2c-omap.c
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com> <1348070841-23354-3-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1348070841-23354-3-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:07 PM, Pantelis Antoniou wrote:
> Add support for pinctrl mux settings in the OMAP I2C driver.
> If no such pinctl bindings are found a warning message is printed.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
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

Can you use &pdev->dev for the dev_warn() here?
the dev->dev is quite confusing especially since you used &pdev->dev for the
pinctrl call.

> +
>  	pm_runtime_mark_last_busy(dev->dev);
>  	pm_runtime_put_autosuspend(dev->dev);
>  
> 


-- 
Péter
