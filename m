Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2LCQv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:51:28 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48897 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2LCQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:51:27 -0500
Date: Mon, 3 Dec 2012 11:51:24 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Armando Visconti <armando.visconti@st.com>
cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] nommu: Enable the strict alignment (CR_A) bit only if
 ARCH < v6
In-Reply-To: <50BCD6DB.2030200@st.com>
Message-ID: <alpine.LFD.2.02.1212031150580.4576@xanadu.home>
References: <1354187042-28568-1-git-send-email-armando.visconti@st.com> <50BCD6DB.2030200@st.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2012, Armando Visconti wrote:

> On 11/29/2012 12:04 PM, Armando VISCONTI wrote:
> > This patch keeps disabled the strict alignment CP15 bit for
> > all armv6 and armv7 processor without the mmu. This behaviour
> > is now same as in the mmu case.
> > 
> > Signed-off-by: Armando Visconti<armando.visconti@st.com>
> > ---
> >   arch/arm/kernel/head-nommu.S |    2 +-
> >   1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
> > index 278cfc1..2c228a0 100644
> > --- a/arch/arm/kernel/head-nommu.S
> > +++ b/arch/arm/kernel/head-nommu.S
> > @@ -68,7 +68,7 @@ __after_proc_init:
> >   	 * CP15 system control register value returned in r0 from
> >   	 * the CPU init function.
> >   	 */
> > -#ifdef CONFIG_ALIGNMENT_TRAP
> > +#if defined(CONFIG_ALIGNMENT_TRAP)&&  __LINUX_ARM_ARCH__<  6
> >   	orr	r0, r0, #CR_A
> >   #else
> >   	bic	r0, r0, #CR_A
> 
> Any feedback on this simple patch?

Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas
