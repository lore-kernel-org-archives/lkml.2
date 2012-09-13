Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2IMDu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 23:50:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65187 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2IMDuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 23:50:01 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF49CB@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF49CB@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 13 Sep 2012 11:49:39 +0800
X-Google-Sender-Auth: cVvsZF5b8eCvWejcjbljAzIQJ6s
Message-ID: <CAK5ve-J3TCJehSja8eRg58ZHqFMFDRx7T2O_EQH-kT=_zRXRHw@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds-lp5523: turn off the LED engines on unloading
 the driver
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 8:16 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>  The LP5523 has 3 engines which are used for running LED patterns.
>  These engines should be off while unloading the driver.
>  Obviously, LP5523 platform data are used for releasing the resource
>  such like enable()/release_resource(), but these are not mandatory.
>  Therefore this patch is required without the platform data dependency.
>

Thanks, merged into my for-next branch
-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 3d60428..5ebdc92 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -997,6 +997,9 @@ static int lp5523_remove(struct i2c_client *client)
>         struct lp5523_chip *chip = i2c_get_clientdata(client);
>         int i;
>
> +       /* Disable engine mode */
> +       lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
> +
>         lp5523_unregister_sysfs(client);
>
>         for (i = 0; i < chip->num_leds; i++) {
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
