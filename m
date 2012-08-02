Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2HBDqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 23:46:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62808 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2HBDqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 23:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <201208012304.46593.linux@rainbow-software.org>
References: <201208012304.46593.linux@rainbow-software.org>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 2 Aug 2012 11:45:41 +0800
X-Google-Sender-Auth: -omD8z2tngxSPnEw1KSj4NTcuxw
Message-ID: <CAK5ve-+EpxSqNOLUAYN+Dm36t4BYfVeVYVrx1OrJ4PkLqZ_dDg@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds-clevo-mail: add MODULE_DEVICE_TABLE
To: Ondrej Zary <linux@rainbow-software.org>
Cc: =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 5:04 AM, Ondrej Zary <linux@rainbow-software.org> wrote:
> Enable autoloading of leds-clevo-mail by using MODULE_DEVICE_TABLE.
>

Thanks, applied to my for-next branch
-Bryan

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>
> --- a/drivers/leds/leds-clevo-mail.c
> +++ b/drivers/leds/leds-clevo-mail.c
> @@ -31,7 +31,7 @@ static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *id)
>  }
>
>  /*
> - * struct mail_led_whitelist - List of known good models
> + * struct clevo_mail_led_dmi_table - List of known good models
>   *
>   * Contains the known good models this driver is compatible with.
>   * When adding a new model try to be as strict as possible. This
> @@ -39,7 +39,7 @@ static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *id)
>   * detected as working, but in reality it is not) as low as
>   * possible.
>   */
> -static struct dmi_system_id __initdata mail_led_whitelist[] = {
> +static struct dmi_system_id __initdata clevo_mail_led_dmi_table[] = {
>         {
>                 .callback = clevo_mail_led_dmi_callback,
>                 .ident = "Clevo D410J",
> @@ -89,6 +89,7 @@ static struct dmi_system_id __initdata mail_led_whitelist[] = {
>         },
>         { }
>  };
> +MODULE_DEVICE_TABLE(dmi, clevo_mail_led_dmi_table);
>
>  static void clevo_mail_led_set(struct led_classdev *led_cdev,
>                                 enum led_brightness value)
> @@ -180,7 +181,7 @@ static int __init clevo_mail_led_init(void)
>
>         /* Check with the help of DMI if we are running on supported hardware */
>         if (!nodetect) {
> -               count = dmi_check_system(mail_led_whitelist);
> +               count = dmi_check_system(clevo_mail_led_dmi_table);
>         } else {
>                 count = 1;
>                 printk(KERN_ERR KBUILD_MODNAME ": Skipping DMI detection. "
>
>
>
>
> --
> Ondrej Zary



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
