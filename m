Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab1FVUFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:05:17 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:34078 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758244Ab1FVUFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:05:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIVKAk5tgwPS/2dsb2JhbABTpxB4iHMCwH0Ohh8EoXg
Date: Wed, 22 Jun 2011 22:05:14 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 9/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110622200513.GD26745@infomag.iguana.be>
References: <20110618172727.GJ3441@infomag.iguana.be> <201106182117.49026.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106182117.49026.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> > watchdog: WatchDog Timer Driver Core - Part 9
> > 
> > Add support for extra ioctl calls by adding a
> > ioctl watchdog operation. This operation will be
> > called before we do our own handling of ioctl
> > commands. This way we can override the internal
> > ioctl command handling and we can also add
> > extra ioctl commands. The ioctl watchdog operation
> > should return the appropriate error codes or
> > -ENOIOCTLCMD if the ioctl command should be handled
> > through the internal ioctl handling of the framework.
> > 
> > Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> Hmm, I'm not sure about this one. It does make the conversion
> of existing drivers easier but doesn't encourage doing a good
> job there.

That's why we also have a maintainer and a mailing list to review
patches... I can understand your concerns, but prefer the flexibility
and simpleness here.

> How about instead providing a compatibility helper module that
> provides helper functions like this:
> 
> int watchdog_compat_getstatus(struct watchdog_device *wdd)
> {
> 	int __user *tmp = compat_alloc_userspace(sizeof (int));
> 	int ret;
> 
> 	ret = wdd->ops->ioctl(wdd, WDIOC_GETSTATUS, tmp);
> 	if (ret)
> 		return ret;
> 
> 	__get_user(ret, tmp);
> 	return ret;
> }
> EXPORT_SYMBOL_GPL(watchdog_compat_getstatus);
> 
> This would let you use the common ioctl implementation for all
> watchdogs without the option of an individual driver overriding
> it, but a driver could still provide an ioctl method that only
> gets called by the watchdog_compat_* functions.

Hmmm, not really in favour of that, this will creat a lot more overhead.

Kind regards,
Wim.

