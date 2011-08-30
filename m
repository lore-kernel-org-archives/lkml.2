Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab1H3Ar7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 20:47:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55484 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1H3Ar5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 20:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <1314269645-18607-1-git-send-email-w.sang@pengutronix.de>
References: <1314269645-18607-1-git-send-email-w.sang@pengutronix.de>
Date: Tue, 30 Aug 2011 09:47:56 +0900
X-Google-Sender-Auth: scNlcKFOhiaFRcvntjs2YLM7EOM
Message-ID: <CAH9JG2XD_8_Vj9t-yN57VsPtCgo84FDLD7VmVwTM3+cNzKvAug@mail.gmail.com>
Subject: Re: [PATCH] misc: Remove obsolete cleanup for clientdata
From: Kyungmin Park <kmpark@infradead.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Minkyu Kang <mk7.kang@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Thu, Aug 25, 2011 at 7:54 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit or error. This is obsolete meanwhile, the core will do it.
>
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Minkyu Kang <mk7.kang@samsung.com>
> Cc: Donggeun Kim <dg77.kim@samsung.com>
> ---
>  drivers/misc/fsa9480.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
> index 5325a7e..22e22ad 100644
> --- a/drivers/misc/fsa9480.c
> +++ b/drivers/misc/fsa9480.c
> @@ -457,7 +457,6 @@ fail2:
>        if (client->irq)
>                free_irq(client->irq, NULL);
>  fail1:
> -       i2c_set_clientdata(client, NULL);
>        kfree(usbsw);
>        return ret;
>  }
> @@ -467,7 +466,6 @@ static int __devexit fsa9480_remove(struct i2c_client *client)
>        struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
>        if (client->irq)
>                free_irq(client->irq, NULL);
> -       i2c_set_clientdata(client, NULL);
>
>        sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
>        device_init_wakeup(&client->dev, 0);
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
