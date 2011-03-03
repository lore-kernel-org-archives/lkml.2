Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab1CCKoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:44:21 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:56751 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786Ab1CCKoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:44:20 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL//bk1R8KK1/2dsb2JhbACmdHW+Xw2FVAQ
Date: Thu, 3 Mar 2011 11:44:18 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jamie Iles <jamie@jamieiles.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 6/10] Generic Watchdog Timer Driver
Message-ID: <20110303104418.GC3790@infomag.iguana.be>
References: <20110223204350.GA7433@infomag.iguana.be> <20110224100204.GC15118@pulham.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224100204.GC15118@pulham.picochip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

> I don't fully understand why the module refcounting is done in the open 
> and release though.  If you moved it into the registration and 
> unregistration then doesn't that remove the need for WDOG_ORPHAN?

Hmm, nice suggestion. Will look into that.

> > diff --git a/drivers/watchdog/core/watchdog_core.c b/drivers/watchdog/core/watchdog_core.c
> > index 52bc520..d1a824e 100644
> > --- a/drivers/watchdog/core/watchdog_core.c
> > +++ b/drivers/watchdog/core/watchdog_core.c
> > @@ -60,6 +60,10 @@ int register_watchdogdevice(struct watchdog_device *wdd)
> >  	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
> >  		return -ENODATA;
> >  
> > +	/* Make sure that the owner of the watchdog operations exists */
> > +	if (wdd->ops->owner == NULL)
> > +		return -ENODATA;
> 
> Won't this be effectively NULL if the module is builtin?  It looks like 
> if it is builtin then THIS_MODULE would be defined as (struct module 
> *)0.

Same for this: I will look into this.

Thanks,
Wim.

