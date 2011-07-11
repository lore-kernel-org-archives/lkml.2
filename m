Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1GKLHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:07:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44791 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754229Ab1GKLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:07:22 -0400
Date: Mon, 11 Jul 2011 12:06:41 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 0/6] arm_smp_twd: mpcore_wdt: Fix MPCORE watchdog
 setup
Message-ID: <20110711110641.GC11247@e102109-lin.cambridge.arm.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
 <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com>
 <4E14337F.1050101@arm.com>
 <20110706101456.GN8286@n2100.arm.linux.org.uk>
 <20110706110548.GA31936@1n450.cable.virginmedia.net>
 <20110706111603.GS8286@n2100.arm.linux.org.uk>
 <20110711094343.GB11247@e102109-lin.cambridge.arm.com>
 <20110711095424.GD3239@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711095424.GD3239@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:54:24AM +0100, Russell King - ARM Linux wrote:
> On Mon, Jul 11, 2011 at 10:43:43AM +0100, Catalin Marinas wrote:
> > On Wed, Jul 06, 2011 at 12:16:03PM +0100, Russell King - ARM Linux wrote:
> > > On Wed, Jul 06, 2011 at 12:05:48PM +0100, Catalin Marinas wrote:
> > > > On Wed, Jul 06, 2011 at 11:14:56AM +0100, Russell King - ARM Linux wrote:
> > > > > Do we know why the calibration was initially introduced?  FWIR, it came
> > > > > from the SMP group in ARM, so I guess they had a reason for it rather
> > > > > than copying x86.
> > > > 
> > > > I think it was introduced because the TWD frequency is half of the CPU
> > > > frequency but the latter may not be known - boot monitor configuration
> > > > could change it.
> > > 
> > > Okay, that implies we can't have a fixed frequency built into the kernel
> > > then.  For such platforms like the ARM dev boards (realview + vexpress),
> > > I expect we can read the CPU frequency from somewhere like one of the
> > > ICST PLLs.
> >  
> > That's highly platform dependent and it's not just ARM dev boards. Any
> > board with ARM11MPCore, Cortex-A9 or Cortex-A5 would need to find a way
> > to retrieve such information. If anyone is prepared to go through each
> > board and figure out how to get the information, it's fine by me.
> 
> So, these patches are blocked until we find some way to resolve the
> clocking issues on all platforms with TWD and the MPcore watchdog.
 
A way would be to mark TWD as broken on those platforms (you can still
use the global timer, with its drawbacks) and push the platform
maintainers to change their code. Once that's sorted and we know for
sure that no platform requires the TWD calibration, you can merge these
patches.

-- 
Catalin
