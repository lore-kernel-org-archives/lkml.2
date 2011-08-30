Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1H3Mv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:51:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:35680 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1H3MvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:51:25 -0400
Date: Tue, 30 Aug 2011 14:51:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Minkyu Kang <mk7.kang@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: Remove obsolete cleanup for clientdata
Message-ID: <20110830145117.4bc67f02@endymion.delvare>
In-Reply-To: <1314269645-18607-1-git-send-email-w.sang@pengutronix.de>
References: <1314269645-18607-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 12:54:04 +0200, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit or error. This is obsolete meanwhile, the core will do it.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Minkyu Kang <mk7.kang@samsung.com>
> Cc: Donggeun Kim <dg77.kim@samsung.com>
> ---
>  drivers/misc/fsa9480.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
> index 5325a7e..22e22ad 100644
> --- a/drivers/misc/fsa9480.c
> +++ b/drivers/misc/fsa9480.c
> @@ -457,7 +457,6 @@ fail2:
>  	if (client->irq)
>  		free_irq(client->irq, NULL);
>  fail1:
> -	i2c_set_clientdata(client, NULL);
>  	kfree(usbsw);
>  	return ret;
>  }
> @@ -467,7 +466,6 @@ static int __devexit fsa9480_remove(struct i2c_client *client)
>  	struct fsa9480_usbsw *usbsw = i2c_get_clientdata(client);
>  	if (client->irq)
>  		free_irq(client->irq, NULL);
> -	i2c_set_clientdata(client, NULL);
>  
>  	sysfs_remove_group(&client->dev.kobj, &fsa9480_group);
>  	device_init_wakeup(&client->dev, 0);

You'll have to refresh this one, as the context was changed by
b89d5f17d4b02ae9f3a691c2cb260e1929c6261b.

-- 
Jean Delvare
