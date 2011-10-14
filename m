Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab1JNSDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:03:24 -0400
Received: from relais.videotron.ca ([24.201.245.36]:13855 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1JNSDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:03:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 14 Oct 2011 14:03:21 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Subject: Re: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
In-reply-to: <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
Message-id: <alpine.LFD.2.02.1110141402150.17040@xanadu.home>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <201110141729.41515.arnd@arndb.de>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
 <201110141827.53906.arnd@arndb.de>
 <CAOesGMgDwMeVmwo1WJ3tU+ZdjCSJ6F8mY42e_KwTmzAkGQsqmg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Olof Johansson wrote:

> On Fri, Oct 14, 2011 at 9:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 14 October 2011, Stephen Warren wrote:
> >> Arnd Bergmann wrote at Friday, October 14, 2011 9:30 AM:
> >> ...
> >> > You mention that tegra30 will require AUTO_ZRELADDR.
> >>
> >> Well, just to be clear, here's the situation I think:
> >>
> >> Tegra20's SDRAM starts at physical address 0.
> >>
> >> Tegra30's SDRAM starts at physical address 2G.
> >>
> >> To support that, we could either:
> >>
> >> a) Introduce a new Kconfig variable for Tegra30, make T20/T30 mutually
> >> exclusive, and update arch/arm/mach-tegra/Makefile.boot to set zreladdr
> >> etc. based on the new Tegra30 config variable too. Then, there's no need
> >> for AUTO_ZRELADDR anywhere.
> >>
> >> b) Have no new config variable, build a unified T20/T30 kernel, leave
> >> Makefile.boot untouched, and rely on using AUTO_ZRELADDR for Tegra30 to
> >> account for the different SDRAM physical addresses.
> >
> > Ok, thanks for the explanation, that makes it much clearer. For
> > completeness, you could also do both of the above and make T20/T30 mutually
> > exclusive unless AUTO_ZRELADDR is set. That might be more complex than
> > necessary, I don't know.
> 
> That is likely to get messy.
> 
> Seems like there could be some use for a (silent) option for a
> platform to indicate that it can do XIP kernel (or zImage), and thus
> not able to use AUTO_ZRELADDR (or other options that require rewriting
> text segment of zImage or kernel).
> 
> Language gets awkard though, since it'd be a negative option (or all
> platforms would need to add it). MACH_XIP_UNSUPPORTED perhaps?

Please hold on -- I'm on it.


Nicolas
