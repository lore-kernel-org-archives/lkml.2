Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab0JRPcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:32:35 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43390 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab0JRPce convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:32:34 -0400
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <tnxeibnh67q.fsf@e102109-lin.cambridge.arm.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
	 <1287406015.29097.1579.camel@twins>
	 <20101018133502.GA12449@n2100.arm.linux.org.uk>
	 <1287409417.29097.1598.camel@twins>
	 <tnxeibnh67q.fsf@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 17:32:09 +0200
Message-ID: <1287415929.29097.1616.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 16:27 +0100, Catalin Marinas wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2010-10-18 at 14:35 +0100, Russell King - ARM Linux wrote:
> >> In any case, Linux's spinlock API (or more accurately, the ARM exclusive
> >> access instructions) relies upon hardware coherency support (a piece of
> >> hardware called an exclusive monitor) which isn't present on the M3 nor
> >> DSP processors.  So there's no way to ensure that updates from the M3
> >> and DSP are atomic wrt the A9 updates.
> >
> > Right, so the problem is that there simply is no way to do atomic memory
> > access from these auxiliary processing units wrt the main CPU? Seeing as
> > they operate on the same memory space, wouldn't it make sense to have
> > them cache-coherent and thus provide atomicy guarantees through that?
> 
> With cache coherency you may get atomicity of writes or reads but
> usually not atomic modifications.

Sure, but you can 'easily' extend your coherency protocols with support
for things like ll/sc (or larger transactions).

Have ll bring the cacheline into exclusive state and tag it, then
anything that demotes the cacheline will clear the tag and make sc fail.


