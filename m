Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab1CaKt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:49:26 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:41245 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133Ab1CaKtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:49:25 -0400
Date: Thu, 31 Mar 2011 13:49:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: david@lang.hm, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110331104918.GI2267@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <20110331080954.GA14323@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331080954.GA14323@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 31, 2011 at 09:09:54AM +0100, Russell King - ARM Linux wrote:
> > what's more, you seem to be saying that
> >
> > arm7+IPblock1
> >
> > and
> >
> > arm7+IPblock1
> >
> > are different architectures if the wiring between the arm core and  
> > IPblock1 are different (they are different 'boards' or different chip  
> > models, possibly from different manufacturers)

This is utter BS, see e.g. that the same MUSB driver is re-used on OMAP,
on an external discrete chip TUSB6010, on DaVinci, on Blackfin, on
UX500, etc. The exact same driver is re-used on all those situations
with a little platform glue layer. We can't live without that small glue
layer for each different platform though and they sum up to 2600+ lines
of code (all different platform glues).

It's a pain to keep the core code generic enough so that it's useful on
all those cases, specially because between OMAP and AM35x, even the
register file that particular IP block is different. Still, we have
people working to keep the IP block drivers generic enough to be re-used
on several situations.

> Over the years which I was overseeing platform support I tried to ensure
> as much sharing of code across different platforms.  I no longer oversee
> platform specific stuff, and so its entirely possible that several SoCs
> have the same IP block but their own code to drive it.
> 
> That's where Thomas is right - we need a team of people to provide
> review of that to catch it and get it consolidated.  Such a team would
> need funding.  Where does that funding come from?  I've no idea.

Fully agree with you Russell.

> We also need the various SoC designers and ARM architecture people to
> realise that what the hardware situation is rediculous; I have commented
> about this lack of standardisation to ARM in past years.  ARM have had
> a standard set of peripherals for ten years, but the SoC people haven't
> really taken them up - and when they do, they seem to always introduce
> their own tweaks, sometimes with no way to detect those tweaks.

For sure that's happening, but should we prevent ARM vendors to add
their tweaks ? Like Nicolas said, that's fuel to innovation.

-- 
balbi
