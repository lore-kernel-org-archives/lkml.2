Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0DZTjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:39:44 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:48097 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab0DZTjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XaOg3sFYwnelrE7JJs3BL2/rY8obFm7HJ2dnk3Brwk9/bNIDxVq3aHS0zq95shLmp2
         AcCwMA8CsbRAak9/pv1TehccL0bpJnTeyIoMZHrs1tn20AVeAlx786hR0Qnv6OHOJnW3
         hyr5QbNgNvYsqvbFm+55J8HOL10evkVUIX1oY=
MIME-Version: 1.0
In-Reply-To: <20100426182200.GA18024@oksana.dev.rtsoft.ru>
References: <1272279925-3122-1-git-send-email-mike@compulab.co.il>
	 <20100426182200.GA18024@oksana.dev.rtsoft.ru>
Date: Mon, 26 Apr 2010 22:39:41 +0300
Message-ID: <p2qf870da181004261239r42aef5b1h2ae416712b465e2d@mail.gmail.com>
Subject: Re: [PATCH v3] ds2782_battery: add support for ds2786 battery gas 
	gauge
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Ryan Mallon <ryan@bluewatersys.com>,
       linux-kernel@vger.kernel.org, Yulia Vilensky <vilensky@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 9:22 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
>
> Btw, I don't quite like the 'if (id->driver_data == 1)' stuff.
> How about the following patch on top?
>
> From acf917d3880465b76875f671ee450a8fdff62c9f Mon Sep 17 00:00:00 2001
> From: Anton Vorontsov <cbouatmailru@gmail.com>
> Date: Mon, 26 Apr 2010 22:10:52 +0400
> Subject: [PATCH] ds2782_battery: Get rid of magic numbers in driver_data
>
> Constructions like 'if (id->driver_data == 1)' look quite weird.
> This patch introduces 'enum ds278x_num_id', which makes things
> much more understandable, i.e. 'if (id->driver_data == DS2786)'.

agree

> Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> ---
>  drivers/power/ds2782_battery.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index c665e80..d762a0c 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -300,13 +300,18 @@ static int ds278x_battery_remove(struct i2c_client *client)
>        return 0;
>  }
>
> +enum ds278x_num_id {
> +       DS2782 = 0,
> +       DS2786,
> +};
> +
>  static struct ds278x_battery_ops ds278x_ops[] = {
> -       [0] = {
> +       [DS2782] = {
>                .get_current  = ds2782_get_current,
>                .get_voltage  = ds2782_get_voltage,
>                .get_capacity = ds2782_get_capacity,
>        },
> -       [1] = {
> +       [DS2786] = {
>                .get_current  = ds2786_get_current,
>                .get_voltage  = ds2786_get_voltage,
>                .get_capacity = ds2786_get_capacity,
> @@ -325,7 +330,7 @@ static int ds278x_battery_probe(struct i2c_client *client,
>         * ds2786 should have the sense resistor value set
>         * in the platform data
>         */
> -       if (id->driver_data == 1 && !pdata) {
> +       if (id->driver_data == DS2786 && !pdata) {
>                dev_err(&client->dev, "missing platform data for ds2786\n");
>                return -EINVAL;
>        }
> @@ -355,7 +360,7 @@ static int ds278x_battery_probe(struct i2c_client *client,
>                goto fail_name;
>        }
>
> -       if (id->driver_data == 1)
> +       if (id->driver_data == DS2786)
>                info->rsns = pdata->rsns;
>
>        i2c_set_clientdata(client, info);
> @@ -385,8 +390,8 @@ fail_id:
>  }
>
>  static const struct i2c_device_id ds278x_id[] = {
> -       {"ds2782", 0},
> -       {"ds2786", 1},
> +       {"ds2782", DS2782},
> +       {"ds2786", DS2786},
>        {},
>  };
>
> --
> 1.7.0.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
	Sincerely Yours,
		Mike.
