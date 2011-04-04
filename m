Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1DDFZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 01:25:00 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:35468 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752469Ab1DDFY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 01:24:58 -0400
Date: Mon, 4 Apr 2011 07:16:23 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Detlef Vollmann <dv@vollmann.ch>
Cc: Arnd Bergmann <arnd@arndb.de>, david@lang.hm,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110404051623.GJ7420@game.jcrosoft.org>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <201104011554.07924.arnd@arndb.de>
 <4D95E112.4020400@vollmann.ch>
 <201104011659.40443.arnd@arndb.de>
 <4D95EF8E.9080902@vollmann.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D95EF8E.9080902@vollmann.ch>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 6190760638664452955
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:30 Fri 01 Apr     , Detlef Vollmann wrote:
> On 04/01/11 16:59, Arnd Bergmann wrote:
> >On Friday 01 April 2011, Detlef Vollmann wrote:
> >>On 04/01/11 15:54, Arnd Bergmann wrote:
> >
> >>>9. All interesting work is going into a handful of platforms, all of which
> >>>     are ARMv7 based.
> >>Define interesting.
> >
> >The ones that are causing the churn that we're talking about.
> >Platforms that have been working forever and only need to get
> >the occasional bug fix are boring, i.e. not the problem.
> In the ARM tree I only know mach-at91.
> Atmel still introduces new SOCs based on ARM926EJ-S, and that makes
> perfect sense for lots of applications.
> And if they add support for a new SOC, they just copy an existing one,
> change some GPIOs, and submit it as new files (sorry, I'm over-
> simplifying here).
at SoC level quite a lot as we do the necessarly to factorise as much as we
can you can take a look when we add the g20, g10 of g45, etc...
> And if you happen to wire your board a bit differently than they do,
> you have to patch theur generic file (in addidtion to add your own
> board file).
> And though I only know the mach-at91 closely, I'm pretty sure quite
> a number of other mach-* are not better.
> So this is actually why the ARM tree has such a bad reputation:
> lot's of code repetition, and still more of that.
On AT91 it's not anymore the case now we do start reduce the number of machine
and we not allow this anymore
> 
> >>>12. Supporting many different boards with a single kernel binary is a
> >>>      useful goal.
> >>Generally not for embedded systems (for me, a mobile PDA/phone is just a
> >>small computer with a crappy keyboard, but not an embedded system).
> >
> >True. For embedded, this would not be an important thing to do, but
> >also not hurt.
> It costs you flash space.
I disagree have a single kernel with mutliple board is very usefull as it can
allow you to have one firmware for multiple version of product. It will really
simplify the maintanance

And it's also allow to simplify kernel maintanance
> 
> >>>* Strictly no crap
> >>>   * No board files
> >>Where do you put code that needs to run very early (e.g. pinging the
> >>watchdog)?
> >
> >Don't know. I'd hope we can get fast enough to the phase where device
> >drivers get initialized.
> Nope, never happened for me :-(
> (Watchdog timeouts are often 1s or less.)
you can do a lot in 1s
you start the board dowload the code from nfs and jump in the kernel
as I do on at91sam9261ek with barebox
> 
> >>>* All board specific information must come from a device tree and
> >>>    be run-time detected.
> >>What do you mean by "run-time detected"?
> >>For powerpc, we currently have the device tree as DTS in the kernel
> >>and compile and bundle it together with the kernel.
> >>As you wrote above: "Discoverable hardware [...] is not going to happen"
> >
> >I mean writing
> >
> >	if (device_is_compatible(dev, SOMETHING))
> >		do_something();
> >
> >instead of
> >
> >#ifdef CONFIG_SOMETHING
> >	do_something();
> >#endif
> >
> >The run-time information could come from anywhere (device tree, hardware
> >registers, today one might use the board number), the important point is
> >not to assume that hardware is present just because someone enabled
> >a Kconfig option.
> Understood and I agree.
> 
> >I believe that rule is generally accepted today, but we don't always
> >enforce it.
> Without device tree, Kconfig option is the only way that really
> works today (no runtime HW detection, and same board ID with different
> setups).
you can do it already today with system_rev DTS will allow to make it more
generic and pass more information and on at91 we could easly have only few
boards. Except for few case such as really short boottime requirement this
will not impact the system on contrary

Best Regards,
J.
> Device tree in my world is just one big Kconfig option instead of
> many small...
> 
>   Detlef
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
