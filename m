Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab2CONkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:40:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41400 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2CONkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <1331757790-10583-7-git-send-email-marc@cpdesign.com.au>
References: <1331757790-10583-1-git-send-email-marc@cpdesign.com.au>
	<1331757790-10583-7-git-send-email-marc@cpdesign.com.au>
Date: Thu, 15 Mar 2012 19:10:42 +0530
Message-ID: <CAM=Q2cssNF2TSWHjcbG4wsABBXhquYoKq_scC6bDcq8kdoosyQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] mfd: mc13xxx: Add i2c driver
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        spi-devel-general@lists.sourceforge.net, oskar@scara.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Thu, Mar 15, 2012 at 2:13 AM, Marc Reilly <marc@cpdesign.com.au> wrote:
> Adds support for mc13xxx family ICs connected via i2c.
>
> Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
> ---
<snip>

> +static int mc13xxx_i2c_probe(struct i2c_client *client,
> +               const struct i2c_device_id *id)
> +{
> +       const struct of_device_id *of_id;
> +       struct i2c_driver *idrv = to_i2c_driver(client->dev.driver);
> +       struct mc13xxx *mc13xxx;
> +       struct mc13xxx_platform_data *pdata = dev_get_platdata(&client->dev);
> +       int ret;
> +
> +       of_id = of_match_device(mc13xxx_dt_ids, &client->dev);
> +       if (of_id)
> +               idrv->id_table =
> +                       &mc13xxx_i2c_device_id[(enum mc13xxx_id) of_id->data];
> +
> +       mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
> +       if (!mc13xxx)
> +               return -ENOMEM;
> +
> +       dev_set_drvdata(&client->dev, mc13xxx);
> +
> +       mc13xxx->dev = &client->dev;
> +       mutex_init(&mc13xxx->lock);
> +
> +       mc13xxx->regmap = regmap_init_i2c(client, &mc13xxx_regmap_i2c_config);
> +       if (IS_ERR(mc13xxx->regmap)) {
> +               ret = PTR_ERR(mc13xxx->regmap);
> +               dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
> +                               ret);
> +               dev_set_drvdata(&client->dev, NULL);
Are we  leaking mc13xxx here
May be you can consider using devm* functions ?

>  +               return ret;
> +       }
> +
