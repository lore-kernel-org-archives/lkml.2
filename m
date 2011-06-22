Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab1FVT4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:56:07 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:11903 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758244Ab1FVT4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:56:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPBHAk5tgwPS/2dsb2JhbABTpxB4iHMCwH4Ohh8EoXg
Date: Wed, 22 Jun 2011 21:56:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110622195602.GB26745@infomag.iguana.be>
References: <20110618172537.GH3441@infomag.iguana.be> <201106182107.45682.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106182107.45682.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> On Saturday 18 June 2011 19:25:37 Wim Van Sebroeck wrote:
> > diff -urN linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c
> > --- linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c 2011-06-16 21:04:06.283940741 +0200
> > +++ linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c 2011-06-17 09:52:32.866632635 +0200
> > @@ -45,6 +45,11 @@
> >  MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
> >         "(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
> >  
> > +static int nowayout = WATCHDOG_NOWAYOUT;
> > +module_param(nowayout, int, 0);
> > +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started. "
> > +       "(default = " __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> > +
> >  static struct watchdog_device wdt_dev;
> >  static void wdt_timer_tick(unsigned long data);
> >  static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> > @@ -152,6 +157,8 @@
> >  
> >         /* Set watchdog_device parameters */
> >         wdt_dev.timeout = timeout;
> > +       if (nowayout)
> > +               set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);
> >  
> >         /* Register the watchdog timer device */
> >         res = watchdog_register_device(&wdt_dev);
> 
> Why is this a feature of the individual drivers and not of the core?

Some drivers/devices will need it (like Alan allready explained), where
others don't.

> Maybe it can be in both, so existing drivers don't need to change the user
> interface, but new drivers don't have to provide the option individually
> when you can simply set it for the base module.

the CONFIG_WATCHDOG_NOWAYOUT option in Kconfig allready stores the default
behaviour for all your drivers. the module param is initialized with it
during compilation ans allows to have it changed when you load the module.

Kind regards,
Wim.

