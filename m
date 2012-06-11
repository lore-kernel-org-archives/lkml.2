Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2FKG7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:59:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2FKG7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <1339391690.6612.1.camel@phoenix>
References: <1339391690.6612.1.camel@phoenix>
Date: Mon, 11 Jun 2012 12:29:38 +0530
Message-ID: <CAKew6eV306Wu6v_AYgvBMeLce4ymZ-9pm=2wrZQ5KmV5XYcOeA@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Return correct delay time in regulator_set_voltage_time_sel
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:44 AM, Axel Lin <axel.lin@gmail.com> wrote:
> rdev->desc->uV_step * abs(new_selector - old_selector) returns uV.
> The unit of ramp_delay is mV/us.
>
> Current code multiples 1000 at wrong place.
>

I am moving ramp_delay to constraints, so i have to modify this line again.
It will be corrected their.

Thanks,
Yadwinder.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index f4c056a..63507a5 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -2308,7 +2308,7 @@ int regulator_set_voltage_time_sel(struct regulator_dev *rdev,
>        if (rdev->desc->ramp_delay && rdev->desc->uV_step)
>                return DIV_ROUND_UP(rdev->desc->uV_step *
>                        abs(new_selector - old_selector),
> -                       rdev->desc->ramp_delay) * 1000;
> +                       rdev->desc->ramp_delay * 1000);
>        return 0;
>  }
>
> --
> 1.7.9.5
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
