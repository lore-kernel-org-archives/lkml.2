Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1DAPum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:50:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1DAPuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:50:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Detlef Vollmann <dv@vollmann.ch>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 17:50:17 +0200
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
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011659.40443.arnd@arndb.de> <4D95EF8E.9080902@vollmann.ch>
In-Reply-To: <4D95EF8E.9080902@vollmann.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011750.17344.arnd@arndb.de>
X-Provags-ID: V02:K0:gr9k8EoUyuVVpA1fVkEJMZ1N9CcMrfGd+3TPWEnUDcU
 gRx1gX38udt8TEGJ65ZHRfD7oPzxLL7Faxxy1oHKSMvJcN8l/L
 2zeHgE5wG2shHsRKeigg4VE0B0fWh8KAJN6ATGoIK6qt7fK1Zb
 wqGlE/HSASzkOvPdZ+Bi+HkOXs2jN7qZhUKgguXd17dCQCsQsq
 EHbWKRo4CNOYr9kbZhonA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011, Detlef Vollmann wrote:
> On 04/01/11 16:59, Arnd Bergmann wrote:
> > On Friday 01 April 2011, Detlef Vollmann wrote:
> >> On 04/01/11 15:54, Arnd Bergmann wrote:
> >
> >>> 9. All interesting work is going into a handful of platforms, all of which
> >>>      are ARMv7 based.
> >> Define interesting.
> >
> > The ones that are causing the churn that we're talking about.
> > Platforms that have been working forever and only need to get
> > the occasional bug fix are boring, i.e. not the problem.
> In the ARM tree I only know mach-at91.
> Atmel still introduces new SOCs based on ARM926EJ-S, and that makes
> perfect sense for lots of applications.

I thought new ones were generally Cortex-M3 based. Either way, even
if there are exceptions, focusing on ARMv7 at first should give
a good representation of the new development.

> >>> 12. Supporting many different boards with a single kernel binary is a
> >>>       useful goal.
> >> Generally not for embedded systems (for me, a mobile PDA/phone is just a
> >> small computer with a crappy keyboard, but not an embedded system).
> >
> > True. For embedded, this would not be an important thing to do, but
> > also not hurt.
> It costs you flash space.

Well, the idea was not to force everyone to enable all options. When this
is done right, the kernel would not be any bigger.

> >>> * Strictly no crap
> >>>    * No board files
> >> Where do you put code that needs to run very early (e.g. pinging the
> >> watchdog)?
> >
> > Don't know. I'd hope we can get fast enough to the phase where device
> > drivers get initialized.
> Nope, never happened for me :-(
> (Watchdog timeouts are often 1s or less.)

1s is a long time. Most of the boot process is drivers anyway, so we
just need to make sure that the watchdog is early enough.

> > I believe that rule is generally accepted today, but we don't always
> > enforce it.
> Without device tree, Kconfig option is the only way that really
> works today (no runtime HW detection, and same board ID with different
> setups).

I believe that has never been an accepted way of doing things, you are
supposed to get a new board ID for every new board, hence the name ;-).

	ARnd
