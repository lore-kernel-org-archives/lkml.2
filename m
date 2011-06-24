Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab1FXT1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:27:47 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:31678 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691Ab1FXT1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:27:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIbjBE5tgxor/2dsb2JhbABTpz54iHMCwSAOhh8Eog8
Date: Fri, 24 Jun 2011 21:27:42 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110624192742.GY23305@infomag.iguana.be>
References: <20110618171946.GB3441@infomag.iguana.be> <201106182058.14702.arnd@arndb.de> <20110622195024.GA26745@infomag.iguana.be> <201106241559.16416.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106241559.16416.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> > > > +#include <linux/platform_device.h>
> > > > +
> > > > +/* Hardware heartbeat in seconds */
> > > > +#define WDT_HW_HEARTBEAT 2
> > > > +
> > > > +/* Timer heartbeat (500ms) */
> > > > +#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
> > > > +
> > > > +/* User land timeout */
> > > > +#define WDT_TIMEOUT 15
> > > > +static int timeout = WDT_TIMEOUT;
> > > > +module_param(timeout, int, 0);
> > > > +MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
> > > > +	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
> > > 
> > > Should the module parameter really be part of each individual driver?
> > > It would be nice if that can be moved into the core as well.
> > 
> > Yes, the module parameter is needed for each individual driver.
> > If we go for supporting multiple watchdog devices, then we will have to support
> > different timeout values. The timeout ranges also differ for different devices.
> 
> Ok, but you'd still have to worry about a single driver supporting multiple
> distinct devices that each want a separate timeout, right?

If it's a single driver that supports different devices (say an SuperIO controller
with several watchdog timers and different GPIO output's), then I still presume that
the timeout range for these different devices will be the same. But I can indeed
imagine that these timers will be used for monitoring different "processes" that
will have different latency and timeout values.

> OTOH, we can still find a solution when it ever gets to the point of
> supporting multiple devices.

Yep, if we support different watchdog devices, then we will need something
to change the default value anyway (like the ioctl does now for a single instance).

Kind regards,
Wim.

