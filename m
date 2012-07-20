Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2GTNsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:48:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61902 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab2GTNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:48:49 -0400
Date: Fri, 20 Jul 2012 14:48:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Jon Masters <jonathan@jonmasters.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120720134824.GC6947@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
 <50065E6B.3060602@jonmasters.org>
 <5008445B.2010109@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5008445B.2010109@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 06:31:07PM +0100, Christopher Covington wrote:
> On 07/18/2012 02:57 AM, Jon Masters wrote:
> > On 07/06/2012 05:05 PM, Catalin Marinas wrote:
> > 
> >> +- CPU mode
> >> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
> >> +  IRQ and FIQ).
> >> +  The CPU must be in either EL2 (RECOMMENDED) or non-secure EL1.
> 
> Why not secure EL1?

Because the secure side does not have virtualisation extensions so you
won't be able to run something like KVM.

> > Even though this stuff is likely to be replaced with the result of some
> > of the other standardization, I'd like it if you'd strongly consider
> > removing the "or non-secure EL1". If you give an inch, someone will take
> > a mile and build a system that enters other than in EL2. Or, something
> > to the effect of "the highest non-secure exception level implemented"
> > would be my preference if you don't want to specify.
> 
> I think it would be best to list the technical limitations, from the
> kernel's perspective, of the unsupported exception levels and the
> advantages of the supported exception levels here. If you want to guide
> system builders towards EL2, I think it'd be more convincing to document
> the relevant technical aspects (perhaps KVM needs facilities only
> available in EL2) than just providing an unexplained requirement.

That's not meant to be an official document for SoC designers. It just
states the requirements from the Linux kernel perspective. But ARM is
producing platform design documents covering hardware and firmware
requirements and these will be made available.

In short, AArch64 (unlike previously) comes at EL3 out of reset. You
will have firmware running here doing hardware various initialisation
and initialise the secure software if there is one. It then gives
control to the non-secure side (can be UEFI, some boot loader, Linux
etc).

-- 
Catalin
