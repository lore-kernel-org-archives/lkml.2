Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1GFNSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 09:18:09 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:41530 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab1GFNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 09:18:07 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKtfFE5tg3wf/2dsb2JhbABTqAJ4iHoCwz0OhigEmlqIJQ
Date: Wed, 6 Jul 2011 15:18:00 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vitaly Kuzmichev <vkuzmichev@mvista.com>,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, arm@kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH V2 3/6] mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Message-ID: <20110706131800.GJ29245@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> > According to the include/linux/watchdog.h WDIOC_SETOPTIONS is
> > classified as 'read from device' ioctl call:
> >   #define WDIOC_SETOPTIONS        _IOR(WATCHDOG_IOCTL_BASE, 4, int)
> > 
> > However, the driver 'mpcore_wdt' performs 'copy_from_user' only if
> > _IOC_WRITE is set, thus the local variable 'uarg' which is used in
> > WDIOC_SETOPTIONS handling remains uninitialized.
> > 
> > The proper way to fix this is to bind WDIOC_SETOPTIONS to _IOW,
> > but this will break compatibility.
> > So adding additional condition for performing 'copy_from_user'.
> > 
> > Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
> 
> Is the new watchdog driver core ready for 3.1? If so, the best
> solution would be to get rid of the entire ioctl function in
> the mpcore_wdt driver and just use the core for that.
> 
> Otherwise, this patch is probably the best solution in the meantime.

Might be a correct fix in the mean time.
But goal is to have core ready for inclusion in 3.1 .
Wolfram is doing conversion of 3 drivers and writing a Howto for doing the conversions.
I'm improving the core based on what Wolfram finds during the conversions.
You may expect a (hopefully) last series of the patches this week.

Kind regards,
Wim.

