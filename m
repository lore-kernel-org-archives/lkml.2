Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595Ab1C3WIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:08:24 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:27543 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1C3WIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:08:18 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/YG4PkxqUF/rYUAGo3eOsm
Date: Wed, 30 Mar 2011 15:08:06 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110330220806.GJ18334@atomide.com>
References: <20110317183048.GW7258@atomide.com>
 <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
 <20110318101512.GA15375@n2100.arm.linux.org.uk>
 <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Pitre <nico@fluxnic.net> [110330 13:39]:
> 
> Trying to rely on bootloaders doing things right is like saying that x86 
> should always rely on the BIOS doing things right.  We have this chance 
> in the OMAP case to have a manufacturer who is smart enough to document 
> all those things so that the kernel can be autonomous and more reliable, 
> and the BIOS joke avoided entirely. When something needs fixing it is 
> much easier to update the kernel ourselves than waiting after any 
> bootloader updates which are themselves much more risky to perform.
> 
> Granted, things could be structured in a better way so to minimize the 
> risk of conflicts when clocks for unrelated drivers are updated at the 
> same time.  Something like initcall tables or the like.

We are hitting a problem with these data files for omap2+ already
where the size of the kernel gets too bloated. So the device tree
approach would help making more distro friendly kernel.

If we want to keep the data in the kernel, they should be loadable
kernel modules except for the few core clocks etc needed to bring
up the system.

I guess an alternative to device thee could be place them under
drivers/firmware or something similar. That does not help with
per-board data though, it would only help with the clocks needed
by device drivers.

> There is on-going work to bring device tree support to ARM.  Maybe that 
> will be the way to go to move those clock details out of the kernel.  
> And maybe that will become another unfixable PC BIOS fiasco. We'll see.  
> I don't particularly like the idea of _more_ APIs between bootloaders 
> and the kernel.  Keeping everything fixable in only one place is way 
> more convenient than the burden of the occasional merge conflict.
>
> Sure, something has to be done to minimize the pain, your pain, but not 
> by increasing the pain elsewhere.  I think that you know pretty well 
> already how painful dealing with BIOS data, or ACPI, or any other vendor 
> controlled (sometimes closed source) config tables might be.  We've 
> sidestepped that pain entirely on ARM so far and that really feels good.

Yeah the syncing up with the bootloader and patching kernel around
bootloader bugs is an issue. But the bloat issue might be hard to
work around otherwise.

Regards,

Tony
