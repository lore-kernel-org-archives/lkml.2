Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0JRNfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:35:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55615 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab0JRNfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:35:40 -0400
Date: Mon, 18 Oct 2010 14:35:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
Message-ID: <20101018133502.GA12449@n2100.arm.linux.org.uk>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <1287406015.29097.1579.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287406015.29097.1579.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 02:46:55PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-10-18 at 09:44 +0200, Ohad Ben-Cohen wrote:
> > OMAP4 introduces a Spinlock hardware module, which provides hardware
> > assistance for synchronization and mutual exclusion between heterogeneous
> > processors and those not operating under a single, shared operating system
> > (e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP). 
> 
> I just have to ask... was it really easier to build silicon than to
> agree on a spinlock ABI?

I'm not really sure what point you're trying to make, but if you're
suggesting that Linux's spinlock should be exposed to these other
processors, you're completely off your rocker.

Doing so would set the kernels spinlock API in stone, which is really
something you don't want to do.  Not only that, but it would mean that
software written for the M3 and DSP would have to know about the GPL'd
spinlock layout, and I suspect that would cause major licencing headaches.

In any case, Linux's spinlock API (or more accurately, the ARM exclusive
access instructions) relies upon hardware coherency support (a piece of
hardware called an exclusive monitor) which isn't present on the M3 nor
DSP processors.  So there's no way to ensure that updates from the M3
and DSP are atomic wrt the A9 updates.
