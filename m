Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1GVTY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:24:28 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:22945 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167Ab1GVTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:24:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACTMKU5tgwKe/2dsb2JhbABTp0l4iHwCuz8OhjEEo08
Date: Fri, 22 Jul 2011 21:24:25 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 01/11] watchdog: WatchDog Timer Driver Core - Add basic
	framework
Message-ID: <20110722192425.GJ31767@infomag.iguana.be>
References: <20110711135056.GT29245@infomag.iguana.be> <1310392522-9949-1-git-send-email-wim@iguana.be> <20110711213224.GC5811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711213224.GC5811@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> > diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> > index 372bc64..edb0f1b 100644
> > --- a/drivers/watchdog/Kconfig
> > +++ b/drivers/watchdog/Kconfig
> > @@ -28,6 +28,17 @@ menuconfig WATCHDOG
> >  
> >  if WATCHDOG
> >  
> > +config WATCHDOG_CORE
> > +	tristate "WatchDog Timer Driver Core"
> 
> What about the idea of making this bool and let it always be compiled as soon
> as WATCHDOG is selected?

This should indeed have been bool. For this merge window it will stay as WATCHDOG_CORE.
In a futue release WATCHDOG_CORE will disappear and the watchdog core will be dependant
on CONFIG_WATCHDOG. Goal is that we only have 1 lower-level API and that all other drivers
use that.

> > +int watchdog_register_device(struct watchdog_device *wdd)
> > +{
> > +	int ret;
> > +
> > +	/* Make sure we have a valid watchdog_device structure */
> > +	if (wdd == NULL || wdd->info == NULL || wdd->ops == NULL)
> > +		return -EINVAL;
> > +
> > +	/* Make sure that the mandatory operations are supported */
> > +	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
> > +		return -EINVAL;
> 
> Check also for wdd->ops->owner? Should we mark it as mandatory?

No, see other comments also (if built-in owner is NULL).

All other comments have been incorporated.
It's allready in the linux-2.6-watchdog-next tree. Will try to sent out the new series as soon as possible.

Kind regards,
Wim.

