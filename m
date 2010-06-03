Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0FCQLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:11:44 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:54078 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0FCQLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:11:41 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/L0CT2HL/crWAvHNrCO3wJ
Date: Thu, 3 Jun 2010 19:11:05 +0300
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <michael@ellerman.id.au>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
Message-ID: <20100603161104.GK30622@atomide.com>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>
 <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
 <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
 <87d3w9582z.fsf@deeprootsystems.com>
 <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
 <1275536698.22020.81.camel@concordia>
 <alpine.LFD.2.00.1006022112320.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006022112320.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [100603 07:25]:
> 
> 
> On Thu, 3 Jun 2010, Michael Ellerman wrote:
> > 
> > You can sort of do that today, by just storing a delta, but oldconfig
> > will silently turn off things you have enabled if prereqs change, so
> > that doesn't really work I think.
> 
> I think you can do it today with various hacks. Up to and including 
> basically doing something that just selects the options you want.
> 
> IOW, you could likely have a human-written Kconfig.<platform> file that 
> just does 
> 
> 	define_bool MYPLATFORM y
> 		select .. everything I need ..
> 
> 	include Kconfig.main
> 
> or a number of other tricks.

I agree all the defconfigs are a pain just for the omaps alone.

If this is of any help we could now just keep omap3_defconfig for
arch/arm/mach-omap2 and get rid of 23 config files:

$ egrep "CONFIG_ARCH_OMAP[2|3|4]=y" arch/arm/configs/* | grep -v omap3_defconfig | wc -l
23

It needs some more work for omap2 though to boot to userspace as
there are still some known issues with ARMv6 vs ARMv7 support and
VFP2 vs 3 support. Will try to look at fixing those again when
I have a chance.

Then making the multi-omap thing work on all omap1 boards would
cut down another 15 defconfigs, that should be also doable.

To be able to compile in multiple arm architectures we would have
to get rid of the Makefile.boot files and NR_IRQS and then have
some kind of common clock framework at least.

I did some experiments compiling in both mach-omap1 and mach-omap2
a few years back using ARMv5 flags, there were probably other issues
too like some conflicting defines.

Cheers,

Tony
