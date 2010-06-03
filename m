Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0FCQqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:46:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65317 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0FCQqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:46:45 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19f9w8W+mRqzcHB9NUGujHc
Date: Thu, 3 Jun 2010 19:46:23 +0300
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603164623.GM30622@atomide.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [100603 17:48]:
> 
> So I _think_ whatever "mach-xyz" file _should_ do something like
> 
> 	# Kconfig file for OMAP4ABCXYZ chip
> 
> 	.. set the particulars for this _particular_ chip,
> 	   ie select the particular drivers on this chip ..
> 
> 	include "chip-family-details" (ie maybe "base OMAP details")
> 
> 	include "architecture-family-details" (ie ARM Kconfig)
> 
> see? Not one flat file, and very much not something generated.
> 
> And I actually suspect we could do it with our current Kconfig file model. 
> IOW, in the arch/arm/Kconfig file, I think it should be doable to have 
> basically a
> 
> 	choice
> 		prompt "ARM platform"
> 
> 	config ARM_PLATFORM_OMAP
> 		bool PLATFORM_OMAP
> 
> 	config ARM_PLATFORM_MSM
> 		bool PLATFORM_MSM
> 	...
> 	endchoice
> 
> 	if ARK_PLATFORM_OMAP
> 	 include "Kconfig.omap"	# this will further have choices for OMAP versions
> 	elif ARM_PLATFORM_...
> 
> and then the individual "Kconfig.platform" files could select certain 
> options, and then do a "include Kconfig.cpu" which would actually be the 
> _current_ top-level arch/arm/Kconfig.

Some of this work has been already done like I responded in the other
thread. So we could use the current omap3_defconfig for omap2, 3 & 4
with some more work. Then do the same thing for omap1. That would cut
it down by total of 38 defconfigs.

Compiling in multiple ARM platforms is trickier, we would have to get
rid of the duplicate defines like NR_IRQS, then have some common clock
framework etc. Then figure out some way to get rid of Makefile.boot.
Russell probably has some other things in mind that would have to be
changed to make this happen.
 
> And I don't think we can get there from here unless I at some point say "I 
> just removed the xyz_defconfig files", at which point people will curse me 
> and stumble about until they actually come up with something better.
> 
> Of course, if the ARM people do something proactive like the above 
> _before_ I remove the defconfig files, I won't complain.

Whenever you feel like it, please just go ahead and do:

$ egrep "CONFIG_ARCH_OMAP[2|3|4]=y" arch/arm/configs/* | grep -v omap3_defconfig | cut -d: -f1 | xargs rm

That way maybe you can wait a bit longer for the other defconfigs
and as an extra bonus I won't get flamed for removing these omap
defconfigs ;)

Tony
