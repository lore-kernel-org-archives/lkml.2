Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab2LCRqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:46:33 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48399 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794Ab2LCRqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:46:32 -0500
Date: Mon, 3 Dec 2012 17:46:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Armando Visconti <armando.visconti@st.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "nico@linaro.org" <nico@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] nommu: Enable the strict alignment (CR_A) bit only if
 ARCH < v6
Message-ID: <20121203174617.GL20074@mudshark.cambridge.arm.com>
References: <1354187042-28568-1-git-send-email-armando.visconti@st.com>
 <50BCD6DB.2030200@st.com>
 <20121203172553.GC14363@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203172553.GC14363@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 05:25:53PM +0000, Russell King - ARM Linux wrote:
> On Mon, Dec 03, 2012 at 05:44:11PM +0100, Armando Visconti wrote:
> > On 11/29/2012 12:04 PM, Armando VISCONTI wrote:
> >> This patch keeps disabled the strict alignment CP15 bit for
> >> all armv6 and armv7 processor without the mmu. This behaviour
> >> is now same as in the mmu case.
> >>
> >> Signed-off-by: Armando Visconti<armando.visconti@st.com>
> >> ---
> >>   arch/arm/kernel/head-nommu.S |    2 +-
> >>   1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
> >> index 278cfc1..2c228a0 100644
> >> --- a/arch/arm/kernel/head-nommu.S
> >> +++ b/arch/arm/kernel/head-nommu.S
> >> @@ -68,7 +68,7 @@ __after_proc_init:
> >>   	 * CP15 system control register value returned in r0 from
> >>   	 * the CPU init function.
> >>   	 */
> >> -#ifdef CONFIG_ALIGNMENT_TRAP
> >> +#if defined(CONFIG_ALIGNMENT_TRAP)&&  __LINUX_ARM_ARCH__<  6
> >>   	orr	r0, r0, #CR_A
> >>   #else
> >>   	bic	r0, r0, #CR_A
> >
> > Any feedback on this simple patch?
> 
> Well, it brings the nommu version into line with the mmu version, so
> it's sensible.  Please put it in the patch system, thanks.

In which case, I'll definitely dust-off the patches to prevent unaligned
accesses to strongly-ordered memory because that results in good ol'
UNPREDICTABLE behaviour.

I think Uwe also requires some of the stuff there for his M3 port.

Will
