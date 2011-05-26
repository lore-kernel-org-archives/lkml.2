Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab1EZPkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:40:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1EZPkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:40:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Barry Song <21cnbao@gmail.com>
Subject: Re: CSR ARM SoC Subarchitecture preview
Date: Thu, 26 May 2011 17:40:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <BANLkTikfje67KyyD+7Pn0D=afTyEde0euw@mail.gmail.com> <201105250851.03665.arnd@arndb.de> <BANLkTikOyo9g1GD_dOxb5As2Yr0rBc+hyA@mail.gmail.com>
In-Reply-To: <BANLkTikOyo9g1GD_dOxb5As2Yr0rBc+hyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261740.05985.arnd@arndb.de>
X-Provags-ID: V02:K0:jHP4h0/X+Ekyc30O6/zBsJE785bbkm5LziQfakKIsFP
 L+dQ1C1WoMTopQJB9qdWpT1P/TOXIKSbRQgk1DoQ9DXpYw3YYe
 SEbqySSVRqy0Gd9PXZ5RwTwcAeMfJl/FoL5gPcZptF8rcy4hVw
 Z/XAsBWzvIYGHS5lshJm7nNa8/FY3BQuUh9ETP7rc8MVx4bIsB
 3Sne1G5p3SIFNWEC/GS5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, Barry Song wrote:
> 2011/5/25 Arnd Bergmann <arnd@arndb.de>:
> > On Wednesday 25 May 2011 04:15:12 Barry Song wrote:
> >
> > Regarding platform data, the ideal case would be to not pass any,
> > and have the driver itself enquire the settings by looking at device
> > tree properties. There may be a few cases where that is not possible,
> > or where a callback into platform code ends up simplifying things
> > significantly, but that should stay the exception.
> really. some hardware-related callbacks are now in arch and make
> driver codes simpler and better to cross platform without considering
> trivial hardware details.
> if they are moved to drivers, the drivers will be very ugly with things like:
> #ifdef BOARD_X
> ....
> #elif defined(BOARD_Y)
> ...
> #endif
> that is not what people want.
> 
> so a temp way is maybe providing funtions in arch as exported symbols
> which will be called by drivers. different boards implement them in
> different codes.

We really need to look at this case-by-case. The #ifdef mess you cited
is of course not acceptable, but that my feeling is that in most cases
we can find a much nicer solution. It depends of course on what code
gets run in the board specific fixup.

> > From the little I know about GPS, the controllers have a fairly standardized
> > serial port interface even across vendors. It would be good to be
> > compatible with the existing ones there, e.g. bluetooth or serial GPS that
> > all provide a tty interface. If your's is very different and has a
> > high-level API, you might want to create a new drivers/gps/ subsystem
> > with an architected user interface that works with both your own
> > implementation and the serial ones.
> > Turning a tty into a high-level interface is normally done using a new tty
> > line discipline, similar to how PPP or CAN work over serial lines.
> 
> yes. gps generally is an external module connected to SoC's uart.
> actually, the char device we are talking is more like firmware inside
> a common gps module. it is in lower level than an external interface.
> anyway, csr is a company with gps technology. i'd like to figure out
> whether we can provide a generic framework.

Great! I think many people would appreciate that.

This may actually be as easy as providing a new line discipline with
very simple ioctls (e.g. GPSIO_GET_CURRENT_POSSITION).

	Arnd
