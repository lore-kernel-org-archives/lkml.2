Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0HPHvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:51:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38354 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0HPHvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xnr8XY9GY2g2rQGGVCDw/cftzrhyWr8sPyxxUpc2x1102FzZ/TuvbvwggFUtkCUbDG
         ruohBZQS4vlelI2a0sufCV9AGtvoaeaBsZCJ7PBgvezq9kTlkEhj7wycOhkHBSLiiQSD
         uj5yzjvP3R/GsEbegEV9mC6QhCtODk3ZFXbjM=
Subject: Re: [PATCH] mmc: build fix: mmc_pm_notify is only available with
 CONFIG_PM=y
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1281693667.4160.0.camel@maxim-laptop>
References: <1276809814-28683-1-git-send-email-maximlevitsky@gmail.com>
	 <1281691473-15481-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1281693667.4160.0.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 10:51:11 +0300
Message-ID: <1281945071.3449.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 13:01 +0300, Maxim Levitsky wrote: 
> On Fri, 2010-08-13 at 11:24 +0200, Uwe Kleine-König wrote: 
> > This fixes a build breakage introduced by
> > 
> > 	4c2ef25 (mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume)
> > 
> > Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> > Cc: David Brownell <david-b@pacbell.net>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: linux-mmc@vger.kernel.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/mmc/core/host.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> > index 0efe631..d80cfdc 100644
> > --- a/drivers/mmc/core/host.c
> > +++ b/drivers/mmc/core/host.c
> > @@ -86,7 +86,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
> >  	init_waitqueue_head(&host->wq);
> >  	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
> >  	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
> > +#ifdef CONFIG_PM
> >  	host->pm_notify.notifier_call = mmc_pm_notify;
> > +#endif
> >  
> >  	/*
> >  	 * By default, hosts do not support SGIO or large requests.
> 
> Hi,
> 
> Sorry about that!


Hi folks,

Sorry again for this bug.
>From now on I will test compilation rigorously. 

If you need it,
Acked-by: Maxim Levitsky <maximlevitsky@gmail.com>

Best regards,
Maxim Levitsky

