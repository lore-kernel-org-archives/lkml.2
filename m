Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2HVOzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:55:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57362 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2HVOzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:55:52 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0C47@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0C47@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 22 Aug 2012 22:55:30 +0800
X-Google-Sender-Auth: jUo15Jv75zeXfKS2bZf4ohJm8js
Message-ID: <CAK5ve-LtWsnKRbDCdsCfnNOKOZXWgfXij0yP6kn_mD4DuB7npg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] leds-lp5523: set the brightness to 0 forcely on
 removing the driver
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 3:32 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> Turning off the brightness of each channel is required
> when removing the driver.
>
> So use flush_work() rather than cancel_work_sync() to execute
> remaining brightness works.
>

Thanks, merged to my for-next
-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 9fd9a92..2fd5689 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -974,7 +974,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
>  fail2:
>         for (i = 0; i < chip->num_leds; i++) {
>                 led_classdev_unregister(&chip->leds[i].cdev);
> -               cancel_work_sync(&chip->leds[i].brightness_work);
> +               flush_work(&chip->leds[i].brightness_work);
>         }
>  fail1:
>         if (pdata->enable)
> @@ -993,7 +993,7 @@ static int lp5523_remove(struct i2c_client *client)
>
>         for (i = 0; i < chip->num_leds; i++) {
>                 led_classdev_unregister(&chip->leds[i].cdev);
> -               cancel_work_sync(&chip->leds[i].brightness_work);
> +               flush_work(&chip->leds[i].brightness_work);
>         }
>
>         if (chip->pdata->enable)
> --
> 1.7.2.5
>
>
> Best Regards,
> Milo
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
