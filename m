Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030942Ab2HQJqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:46:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56971 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756417Ab2HQJqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:46:35 -0400
Date: Fri, 17 Aug 2012 10:46:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 30/31] arm64: Build infrastructure
Message-ID: <20120817094602.GC24389@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-31-git-send-email-catalin.marinas@arm.com>
 <20120817093213.GT11011@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120817093213.GT11011@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:32:13AM +0100, Tony Lindgren wrote:
> * Catalin Marinas <catalin.marinas@arm.com> [120814 11:00]:
> > --- /dev/null
> > +++ b/arch/arm64/Kconfig
> > @@ -0,0 +1,261 @@
> > +config ARM64
> > +	def_bool y
> > +	select OF
> > +	select OF_EARLY_FLATTREE
> > +	select IRQ_DOMAIN
> > +	select HAVE_AOUT
> > +	select HAVE_DMA_ATTRS
> > +	select HAVE_DMA_API_DEBUG
> > +	select HAVE_IDE
> > +	select HAVE_MEMBLOCK
> > +	select RTC_LIB
> > +	select SYS_SUPPORTS_APM_EMULATION
> > +	select HAVE_GENERIC_DMA_COHERENT
> > +	select GENERIC_IOMAP
> > +	select HAVE_IRQ_WORK
> > +	select HAVE_PERF_EVENTS
> > +	select HAVE_ARCH_TRACEHOOK
> > +	select PERF_USE_VMALLOC
> > +	select HAVE_HW_BREAKPOINT if PERF_EVENTS
> > +	select HAVE_GENERIC_HARDIRQS
> > +	select GENERIC_HARDIRQS_NO_DEPRECATED
> > +	select HAVE_SPARSE_IRQ
> > +	select SPARSE_IRQ
> > +	select GENERIC_IRQ_SHOW
> > +	select GENERIC_SMP_IDLE_THREAD
> > +	select NO_BOOTMEM
> > +	help
> > +	  ARM 64-bit (AArch64) Linux support.
> 
> Anything we should select here for ARM generic timers and
> interrupts assuming we can always expect to boot using those?

There is an entry in drivers/clocksource/Kconfig:

config CLKSRC_ARM_GENERIC
	def_bool y if ARM64

I will have something similar for the GIC but the model does not
currently support GICv3 to be able to test. I'll publish a branch with
example SoC code (for the model) and that adds GIC support into
drivers/irqchip/ with the address information from FDT. The per-CPU GIC
initialisation is done via a CPU notifier to decouple this from the SoC
code (I think even on 32-bit ARM it could be done in the same way,
gic_secondary_init() always takes 0 as argument.

-- 
Catalin
