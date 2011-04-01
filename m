Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1DAO7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:59:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64097 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab1DAO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:59:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Detlef Vollmann <dv@vollmann.ch>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 16:59:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, david@lang.hm,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011554.07924.arnd@arndb.de> <4D95E112.4020400@vollmann.ch>
In-Reply-To: <4D95E112.4020400@vollmann.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011659.40443.arnd@arndb.de>
X-Provags-ID: V02:K0:XdU/OT+JE06YDPoNCbicJbudOimDso5E63T4kbSeIdW
 sy5gMqEHChRBDJR0GPKyIXvFRY5/KReufghPqe1aezSCpqKcsY
 jMN3FaFM31wQZ1DXed9LafXN182PxdAVKopRfSzGUe2MKaRqhD
 OTnNb3PSumotPu3DNF1mRKm1umMSWSQy/495n0u+02nbT4eX5Z
 ZhYZHDc2KkZNnSo7TO2tw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011, Detlef Vollmann wrote:
> On 04/01/11 15:54, Arnd Bergmann wrote:

> > 9. All interesting work is going into a handful of platforms, all of which
> >     are ARMv7 based.
> Define interesting.

The ones that are causing the churn that we're talking about.
Platforms that have been working forever and only need to get
the occasional bug fix are boring, i.e. not the problem.
 
> > 12. Supporting many different boards with a single kernel binary is a
> >      useful goal.
> Generally not for embedded systems (for me, a mobile PDA/phone is just a
> small computer with a crappy keyboard, but not an embedded system).

True. For embedded, this would not be an important thing to do, but
also not hurt. For anything that a user might want to put a new
kernel on, this would be helpful though.

> >
> > Based on these assumptions, my preferred strategy would be to a new
> > mach-nocrap directory with a documented set of rules (to be adapted when
> > necessary):
> >
> > * Strictly no crap
> >   * No board files
> Where do you put code that needs to run very early (e.g. pinging the
> watchdog)?

Don't know. I'd hope we can get fast enough to the phase where device
drivers get initialized.
 
> >   * No hardcoded memory maps
> >   * No lists of interrupts and GPIOs
> > * All infrastructure added must be portable to all ARMv7 based SoCs.
> >    (ARMv6 can be added later)
> > * 64 bit safe code only.
> > * SMP safe code only.
> > * All board specific information must come from a device tree and
> >    be run-time detected.
> What do you mean by "run-time detected"?
> For powerpc, we currently have the device tree as DTS in the kernel
> and compile and bundle it together with the kernel.
> As you wrote above: "Discoverable hardware [...] is not going to happen"

I mean writing

	if (device_is_compatible(dev, SOMETHING))
		do_something();

instead of

#ifdef CONFIG_SOMETHING
	do_something();
#endif

The run-time information could come from anywhere (device tree, hardware
registers, today one might use the board number), the important point is
not to assume that hardware is present just because someone enabled
a Kconfig option.

I believe that rule is generally accepted today, but we don't always
enforce it.

> > * Must use the same device drivers as existing platforms
> > * Should share platform drivers (interrupt controller, gpio, timer, ...)
> >    with existing platforms where appropriate.
> > * Code quality takes priority over stability in mach-nocrap, but must not
> >    break other platforms.
> 
> I agree with the general idea, but nailing down the details in a world
> as diverse as the ARM world will not be easy...

Absolutely, I did not claim to have the single solution that everyone else
couldn't see. Please see this more as an RFC.

	Arnd
