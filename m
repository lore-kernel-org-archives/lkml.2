Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2IDI0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 04:26:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54382 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2IDI0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 04:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF210D@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF210D@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 4 Sep 2012 16:25:39 +0800
X-Google-Sender-Auth: S64Ha6o3dSJQUkVeNzqhNpgi0U0
Message-ID: <CAK5ve-+xH5KreRaeigGk7zk--gCYfXuzQ3eXvmXDZmWobCRRUw@mail.gmail.com>
Subject: Re: [PATCH 3/3] leds-lp5523: use the i2c device id rather than fixed name
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 3:06 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>  LP5523 driver supports both LP5523 and LP55231.
>  The i2c device id is one of the two - lp5523 or lp55231.
>  So it's better to use matching i2c device id while enumerating the device
>  and naming LED channels.
>
Applied, thanks.

-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index e69e72a..3d60428 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -833,7 +833,8 @@ static int __init lp5523_init_engine(struct lp5523_engine *engine, int id)
>  }
>
>  static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
> -                          int chan, struct lp5523_platform_data *pdata)
> +                          int chan, struct lp5523_platform_data *pdata,
> +                          const char *chip_name)
>  {
>         char name[32];
>         int res;
> @@ -856,7 +857,7 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
>                         led->cdev.name = pdata->led_config[chan].name;
>                 } else {
>                         snprintf(name, sizeof(name), "%s:channel%d",
> -                               pdata->label ?: "lp5523", chan);
> +                               pdata->label ? : chip_name, chan);
>                         led->cdev.name = name;
>                 }
>
> @@ -927,7 +928,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
>         if (ret)
>                 goto fail1;
>
> -       dev_info(&client->dev, "LP5523 Programmable led chip found\n");
> +       dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
>
>         /* Initialize engines */
>         for (i = 0; i < ARRAY_SIZE(chip->engines); i++) {
> @@ -955,7 +956,8 @@ static int __devinit lp5523_probe(struct i2c_client *client,
>                 INIT_WORK(&chip->leds[led].brightness_work,
>                         lp5523_led_brightness_work);
>
> -               ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata);
> +               ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata,
> +                               id->name);
>                 if (ret) {
>                         dev_err(&client->dev, "error initializing leds\n");
>                         goto fail2;
> --
> 1.7.9.5
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
