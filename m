Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2GRJHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:07:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43568 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab2GRJHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:07:37 -0400
Date: Wed, 18 Jul 2012 10:07:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120718090727.GB25929@mudshark.cambridge.arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <50065E6B.3060602@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50065E6B.3060602@jonmasters.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 07:57:47AM +0100, Jon Masters wrote:
> On 07/06/2012 05:05 PM, Catalin Marinas wrote:
> 
> > +- CPU mode
> > +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
> > +  IRQ and FIQ).
> > +  The CPU must be in either EL2 (RECOMMENDED) or non-secure EL1.
> 
> Even though this stuff is likely to be replaced with the result of some
> of the other standardization, I'd like it if you'd strongly consider
> removing the "or non-secure EL1". If you give an inch, someone will take
> a mile and build a system that enters other than in EL2. Or, something
> to the effect of "the highest non-secure exception level implemented"
> would be my preference if you don't want to specify.

The reason we allow kernels to boot at non-secure EL1 is because we require
that for booting Linux as a guest OS under a hypervisor.

> > diff --git a/arch/aarch64/include/asm/setup.h b/arch/aarch64/include/asm/setup.h
> 
> > +#define COMMAND_LINE_SIZE 1024
> 
> Suggest at least the same size as x86 (2048) for command line params, or
> we'll just be coming back later to change it :)

If you like, I'm not sure it really matters though -- plenty of
architectures are using <=512 for the limit.

Will
