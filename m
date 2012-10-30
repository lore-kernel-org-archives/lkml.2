Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab2J3UOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:14:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44183 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab2J3UOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:14:50 -0400
Message-ID: <50903520.5050108@ti.com>
Date: Tue, 30 Oct 2012 21:14:24 +0100
From: Sebastien Guiriec <s-guiriec@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Tony Lindgren <tony@atomide.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: [PATCH] i2c: pinctrl-ify i2c-omap.c
References: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis,

Can you look at the early thread?
   https://patchwork.kernel.org/patch/1601331/

I send a similar patch earlier with defer probe usage.

Best regards,

Sebastien
On 10/31/2012 04:55 PM, Pantelis Antoniou wrote:
> Enable pinctrl for i2c-omap.
>
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>   drivers/i2c/busses/i2c-omap.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index db31eae..4c38aa0 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -44,6 +44,8 @@
>   #include <linux/i2c-omap.h>
>   #include <linux/pm_runtime.h>
>   #include <linux/pm_qos.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/err.h>
>
>   /* I2C controller revisions */
>   #define OMAP_I2C_OMAP1_REV_2		0x20
> @@ -1064,6 +1066,7 @@ omap_i2c_probe(struct platform_device *pdev)
>   	const struct of_device_id *match;
>   	int irq;
>   	int r;
> +	struct pinctrl *pinctrl;
>
>   	/* NOTE: driver uses the static register mapping */
>   	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1202,6 +1205,13 @@ omap_i2c_probe(struct platform_device *pdev)
>
>   	of_i2c_register_devices(adap);
>
> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
> +	if (IS_ERR(pinctrl))
> +		dev_warn(dev->dev, "unable to select pin group\n");
> +
> +	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", adap->nr,
> +		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
> +
>   	pm_runtime_mark_last_busy(dev->dev);
>   	pm_runtime_put_autosuspend(dev->dev);
>
>

