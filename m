Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2IRTYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:24:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42420 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab2IRTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:24:24 -0400
Message-ID: <5058CA65.5080408@ti.com>
Date: Tue, 18 Sep 2012 14:24:21 -0500
From: a0919096 <b-cousson@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/3] i2c: OMAP fix driver initialization message
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com> <1348070841-23354-4-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1348070841-23354-4-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Panto,

That patch is good, but a similar one was already posted by Florian.
https://patchwork.kernel.org/patch/1392671/

Checking the email thread it seems that Wolfram	pulled it.

Regards,
Benoit

On 9/19/2012 11:07 AM, Pantelis Antoniou wrote:
> The message spit out when the i2c-omap driver load is printing
> the platform device's id as a bus number. However when booting
> from OF id is -1, which is not so nice.
>
> Fix it by printing the adapter number.
>
> [    0.210467] omap_i2c 44e0b000.i2c: bus -1 rev2.4.0 at 400 kHz
> 	vs
> [    0.210467] omap_i2c 44e0b000.i2c: bus 0 rev2.4.0 at 400 kHz
>
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>   drivers/i2c/busses/i2c-omap.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index f722478..87bb705 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -1178,9 +1178,6 @@ omap_i2c_probe(struct platform_device *pdev)
>   		goto err_unuse_clocks;
>   	}
>
> -	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", pdev->id,
> -		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
> -
>   	adap = &dev->adapter;
>   	i2c_set_adapdata(adap, dev);
>   	adap->owner = THIS_MODULE;
> @@ -1204,6 +1201,9 @@ omap_i2c_probe(struct platform_device *pdev)
>   	if (IS_ERR(pinctrl))
>   		dev_warn(dev->dev, "pins are not configured from the driver\n");
>
> +	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", adap->nr,
> +		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
> +
>   	pm_runtime_mark_last_busy(dev->dev);
>   	pm_runtime_put_autosuspend(dev->dev);
>
>

