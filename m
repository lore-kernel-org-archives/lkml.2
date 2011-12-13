Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1LMK0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:26:20 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59128 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1LMK0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:26:19 -0500
MIME-Version: 1.0
X-Google-Sender-Delegation: marcus.folkesson@gmail.com
In-Reply-To: <1323770273-21222-1-git-send-email-afzal@ti.com>
References: <1323770273-21222-1-git-send-email-afzal@ti.com>
Date: Tue, 13 Dec 2011 11:26:18 +0100
X-Google-Sender-Auth: ljixXyjPXB6S3Ot8g6w6g6hTBB4
Message-ID: <CAJ4dqQvJy5EHnkfp2Yf2bBg0LG7e3i9=3qL_S09Sn6oTxPc0XQ@mail.gmail.com>
Subject: Re: [PATCH v2-rebased] mfd: TPS65910: Make usable even if interrupt unused
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Afzal Mohammed <afzal@ti.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, nsekhar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any potential issue when calling free_irq on a non-requested irq?
If it is, there should be a !irq check in tps65910_irq_exit or
tps65910_i2c_remove.

/Marcus

2011/12/13 Afzal Mohammed <afzal@ti.com>:
> TPS65910 can be used even if interrupt is unused.
> Hence let probe succeed in case interrupt can't be
> configured and let Kernel only to complain about it
>
> Signed-off-by: Afzal Mohammed <afzal@ti.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> Hi Samuel,
>
> I sent this yesterday, but did not reach LKML,
> so assumed you also may not have recieved it;
> resending.
>
> Regards
> Afzal
>
>  drivers/mfd/tps65910.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 6f5b8cf..2fa0178 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -172,15 +172,12 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>
>        tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
>
> -       ret = tps65910_irq_init(tps65910, init_data->irq, init_data);
> -       if (ret < 0)
> -               goto err;
> +       tps65910_irq_init(tps65910, init_data->irq, init_data);
>
>        kfree(init_data);
>        return ret;
>
>  err:
> -       mfd_remove_devices(tps65910->dev);
>        kfree(tps65910);
>        kfree(init_data);
>        return ret;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
