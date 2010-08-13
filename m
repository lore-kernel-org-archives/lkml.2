Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437Ab0HMKBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:01:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50223 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761390Ab0HMKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ozCa/3jwynvvgqFxwc8mS33jmLcgHmJJg+Ki/CBvV39PvIGnezeFkc8t8xsARRZyr/
         TKEP/tmr263R+EaZSTnPOAW71/8Z5lEiY+uxJYLMcR4UHbTzp4ffL8BpnuySrllkyMuX
         OtjQTCkEfEYCp8iP+df6sJucMQMyJelbrQFL0=
Subject: Re: [PATCH] mmc: build fix: mmc_pm_notify is only available with
 CONFIG_PM=y
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1281691473-15481-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1276809814-28683-1-git-send-email-maximlevitsky@gmail.com>
	 <1281691473-15481-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Aug 2010 13:01:07 +0300
Message-ID: <1281693667.4160.0.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 11:24 +0200, Uwe Kleine-König wrote: 
> This fixes a build breakage introduced by
> 
> 	4c2ef25 (mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume)
> 
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: linux-mmc@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mmc/core/host.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 0efe631..d80cfdc 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -86,7 +86,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
>  	init_waitqueue_head(&host->wq);
>  	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
>  	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
> +#ifdef CONFIG_PM
>  	host->pm_notify.notifier_call = mmc_pm_notify;
> +#endif
>  
>  	/*
>  	 * By default, hosts do not support SGIO or large requests.

Hi,

Sorry about that!

Best regards,
Maxim Levitsky

