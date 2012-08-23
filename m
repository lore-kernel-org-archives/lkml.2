Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab2HWM0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:26:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46065 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755377Ab2HWM0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:26:06 -0400
Date: Thu, 23 Aug 2012 13:25:49 +0100
From: Will Deacon <will.deacon@arm.com>
To: Tixy <tixy@yxit.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Leif Lindholm <Leif.Lindholm@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/4] ARM: kprobes: make more tests conditional
Message-ID: <20120823122549.GD13622@mudshark.cambridge.arm.com>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
 <201208221519.12056.arnd@arndb.de>
 <alpine.LFD.2.02.1208221136180.1754@xanadu.home>
 <201208221841.29645.arnd@arndb.de>
 <1345679461.3601.20.camel@computer5.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345679461.3601.20.camel@computer5.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 12:51:01AM +0100, Tixy wrote:
> On Wed, 2012-08-22 at 18:41 +0000, Arnd Bergmann wrote:
> > On Wednesday 22 August 2012, Nicolas Pitre wrote:
> > > On Wed, 22 Aug 2012, Arnd Bergmann wrote:
> > > > > 
> > > > > The ldrex/strex instructions are available on ARMv6.  It's only the d 
> > > > > variants (strexd/ldrexd) which are only available from ARMv6k.
> > > > 
> > > > Ok. How is the version below then? I haven't tested this one yet.
> > > 
> > > In fact, I think the b variants are ARMv6k+ as well.  Only the plain 
> > > (non b non d) variants are available on ARMv6.
> > 
> > Ok, third attempt then. This leaves ldrex for ARMv6 but marks
> > {st,ld}rex{b,h,d} as V6K specific (which includes ARMv7).
> 
> ARMv7 does set CPU_32v6K, because arch/arm/mm/Kconfig has
> 
> config CPU_V7
> 	bool "Support ARM V7 processor" if ARCH_INTEGRATOR || MACH_REALVIEW_EB || MACH_REALVIEW_PBX
> 	select CPU_32v6K
> 	select CPU_32v7
> 
> but this seems more for peripheral reasons not because all the various
> CPU configs systematically select the earlier architecture variants,
> e.g. CPU_V7 doesn't select CPU_32v6.
> 
> So I would have been inclined to test for
> 
> #if defined(CONFIG_CPU_32v6K) || (__LINUX_ARM_ARCH__ >= 7) 

FWIW, the selection of the optimised atomic64 implementation for ARM (which
uses the double-word exclusive instructions) boils down to CONFIG_CPU_32v6K,
so I think the additional __LINUX_ARM_ARCH__ check is probably overkill.

Will
