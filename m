Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1HYOpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:45:32 -0400
Received: from lunge.queued.net ([173.255.254.236]:39677 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1HYOp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:45:29 -0400
Date: Thu, 25 Aug 2011 07:45:27 -0700
From: Andres Salomon <dilinger@queued.net>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Belisko <marek.belisko@open-nandra.com>,
        Jean Delvare <khali@linux-fr.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/olpc_dcon: Remove obsolete cleanup for
 clientdata
Message-ID: <20110825074527.59252f56@queued.net>
In-Reply-To: <1314269628-18325-1-git-send-email-w.sang@pengutronix.de>
References: <1314269628-18325-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

Acked-by: Andres Salomon <dilinger@queued.net>

On Thu, 25 Aug 2011 12:53:30 +0200
Wolfram Sang <w.sang@pengutronix.de> wrote:

> A few new i2c-drivers came into the kernel which clear the
> clientdata-pointer on exit or error. This is obsolete meanwhile, the
> core will do it.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Andres Salomon <dilinger@queued.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Marek Belisko <marek.belisko@open-nandra.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c
> b/drivers/staging/olpc_dcon/olpc_dcon.c index 750fe50..a235330 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -712,7 +712,6 @@ static int dcon_probe(struct i2c_client *client,
> const struct i2c_device_id *id) eirq:
>  	free_irq(DCON_IRQ, dcon);
>   einit:
> -	i2c_set_clientdata(client, NULL);
>  	kfree(dcon);
>  	return rc;
>  }
> @@ -721,8 +720,6 @@ static int dcon_remove(struct i2c_client *client)
>  {
>  	struct dcon_priv *dcon = i2c_get_clientdata(client);
>  
> -	i2c_set_clientdata(client, NULL);
> -
>  	fb_unregister_client(&dcon->fbevent_nb);
>  	unregister_reboot_notifier(&dcon->reboot_nb);
>  	atomic_notifier_chain_unregister(&panic_notifier_list,
> &dcon_panic_nb);
