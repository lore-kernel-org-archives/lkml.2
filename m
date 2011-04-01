Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1DALX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:23:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1DALX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:23:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 13:22:44 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Nicolas Pitre <nico@fluxnic.net>,
        david@lang.hm, Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <201103301906.42429.arnd@arndb.de> <201103311723.02301.arnd@arndb.de> <1301643157.3393.17.camel@deskari>
In-Reply-To: <1301643157.3393.17.camel@deskari>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011322.44729.arnd@arndb.de>
X-Provags-ID: V02:K0:xG28IINi0DsGgOyb3hE47xws5OB9ZXrpxbQG5ovJKZ0
 r0V2CzHIxDOmpYHZNzrh2lyGUNkOXcnm6m9CAy6VJQZmLAuLX2
 w9STxekVFKyBRqXdKlz/eKOkFFepAMoyj3lfaFu/VD76KmaZjk
 HFLU8aO1J1IHtjijMqCBi06LEVD19ZZZX8BhlotAQoO4HCaSxc
 l9hv0Y3sk/5AjJB+t1Wmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011, Tomi Valkeinen wrote:
> On Thu, 2011-03-31 at 17:23 +0200, Arnd Bergmann wrote:
> 
> > * The DSS display drivers introduce new infrastructure include new bus
> >   types that have the complexity to make them completely generic, but
> >   in practice can only work on OMAP, and are clearly not written with
> >   cross-vendor abstractions in mind.
> 
> If you mean the panel drivers, then I disagree. They are currently OMAP
> specific, but they are designed so that making them generic shouldn't be
> too difficult. It's been my aim for a long time already to make the
> panel drivers generic, but I've never had time and it's never been quite
> clear to me what would be the best way to do that.
> 
> The core DSS driver is OMAP specific, and while the DSS IP could in
> theory be used in some other platform, that is not currently the case
> and I wouldn't want to needlessly start abstracting things for just the
> sake of abstracting.

Ok, fair enough. I haven't looked at the OMAP DSS code in detail, so
I apologise if I did it injustice. What I did review is the ST Ericsson
MCDE code which was written by taking the OMAP code as an example.

The symptom I'm describing is that infrastructure is getting added
to platform specific code without making clear that it is mean to
be generic. I.e. the code is hidded away in the drivers/video/omap
directory, where other people would not go looking for it.

What I would have hoped you to do is to tell the ST Ericsson people
when they posted their code that they should instead work with you
to integrate the two implementations. As far as I remember (I may be
wrong again), that did not happen.

	Arnd
