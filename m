Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2GFIMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:12:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:38380 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2GFIMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <1341559940.15918.1.camel@phoenix>
References: <1341559940.15918.1.camel@phoenix>
Date: Fri, 6 Jul 2012 17:12:31 +0900
X-Google-Sender-Auth: kW7jG8nDTttgmHzIurYz6CCBJ6E
Message-ID: <CAH9JG2XQ-5bj8mgop7HfDKmpx=SEiSKOLcvz3T3e0Uz1jty59A@mail.gmail.com>
Subject: Re: [PATCH] mfd: max77686: Remove unused iolock mutex
From: Kyungmin Park <kmpark@infradead.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: SamuelOrtiz <sameo@linux.intel.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Fri, Jul 6, 2012 at 4:32 PM, Axel Lin <axel.lin@gmail.com> wrote:
> Now this driver is using regmap API, the iolock mutex is not used and can be
> removed.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/max77686.c               |    3 ---
>  include/linux/mfd/max77686-private.h |    1 -
>  2 files changed, 4 deletions(-)
>
> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 11e5601..9e7e1d3 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -27,7 +27,6 @@
>  #include <linux/i2c.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/module.h>
> -#include <linux/mutex.h>
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/max77686.h>
>  #include <linux/mfd/max77686-private.h>
> @@ -79,8 +78,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>         max77686->wakeup = pdata->wakeup;
>         max77686->irq_gpio = pdata->irq_gpio;
>
> -       mutex_init(&max77686->iolock);
> -
>         if (regmap_read(max77686->regmap,
>                          MAX77686_REG_DEVICE_ID, &data) < 0) {
>                 dev_err(max77686->dev,
> diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
> index 962f65e..d327d49 100644
> --- a/include/linux/mfd/max77686-private.h
> +++ b/include/linux/mfd/max77686-private.h
> @@ -219,7 +219,6 @@ struct max77686_dev {
>         struct device *dev;
>         struct i2c_client *i2c; /* 0xcc / PMIC, Battery Control, and FLASH */
>         struct i2c_client *rtc; /* slave addr 0x0c */
> -       struct mutex iolock;
>
>         int type;
>
> --
> 1.7.9.5
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
