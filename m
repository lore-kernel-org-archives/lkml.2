Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab2BZV47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 16:56:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41274 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2BZV46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 16:56:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of olof@lixom.net designates 10.68.130.34 as permitted sender) smtp.mail=olof@lixom.net
Date: Sun, 26 Feb 2012 13:57:00 -0800
From: Olof Johansson <olof@lixom.net>
To: Colin Cross <ccross@android.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 05/10] ARM: tegra: rework Tegra secondary CPU core
 bringup
Message-ID: <20120226215700.GC11189@quad.lixom.net>
References: <1328831277-21002-1-git-send-email-pdeschrijver@nvidia.com>
 <1328831277-21002-6-git-send-email-pdeschrijver@nvidia.com>
 <CAMbhsRRkkjfymL=uDt+phM2sLunbypQRUhjZ=DHSO4y9Ko4NJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRRkkjfymL=uDt+phM2sLunbypQRUhjZ=DHSO4y9Ko4NJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 20, 2012 at 03:04:57PM -0800, Colin Cross wrote:
> On Thu, Feb 9, 2012 at 3:47 PM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> > Prepare the Tegra secondary CPU core bringup code for other Tegra variants.
> > The reset handler is also generalized to allow for future introduction of
> > powersaving modes which turn off the CPU cores.
> >
> > Based on work by:
> >
> > Scott Williams <scwilliams@nvidia.com>
> > Chris Johnson <cwj@nvidia.com>
> > Colin Cross <ccross@android.com>
> >
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> <snip>
> 
> > diff --git a/arch/arm/mach-tegra/headsmp.S b/arch/arm/mach-tegra/headsmp.S
> > index b5349b2..7973f1c 100644
> > --- a/arch/arm/mach-tegra/headsmp.S
> > +++ b/arch/arm/mach-tegra/headsmp.S
> 
> <snip>
> 
> > @@ -47,15 +64,116 @@ ENTRY(v7_invalidate_l1)
> >         mov     pc, lr
> >  ENDPROC(v7_invalidate_l1)
> >
> > +
> >  ENTRY(tegra_secondary_startup)
> > -       msr     cpsr_fsxc, #0xd3
> >         bl      v7_invalidate_l1
> > -       mrc     p15, 0, r0, c0, c0, 5
> > -        and    r0, r0, #15
> > -        ldr     r1, =0x6000f100
> > -        str     r0, [r1]
> > -1:      ldr     r2, [r1]
> > -        cmp     r0, r2
> > -        beq     1b
> > +       mov32   r0, 0xC5ACCE55
> > +       mcr     p14, 0, r0, c7, c12, 6
> 
> One minor nit, you should comment that this is enabling coresight.

Since it's trivial, I did it when I applied the patch here instead of having
Peter respin or add it separately.


-Olof
