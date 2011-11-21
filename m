Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1KUO3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:29:51 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6907 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1KUO3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:29:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Nov 2011 06:29:22 -0800
Date: Mon, 21 Nov 2011 16:29:19 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 06/10] arm/tegra: prepare pinmux code for multiple
 tegra variants
Message-ID: <20111121142919.GN19069@tbergstrom-lnx.Nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-7-git-send-email-pdeschrijver@nvidia.com>
 <20111118214116.GC31678@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111118214116.GC31678@quad.lixom.net>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 10:41:16PM +0100, Olof Johansson wrote:
> On Thu, Nov 17, 2011 at 06:19:20PM +0200, Peter De Schrijver wrote:
> > This patch modifies the pinmux code to be useable for multiple tegra variants.
> > Some tegra20 specific constants will be replaced by variables which will be
> > initialized to the appropriate value at runtime.
> >
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/board-harmony-pcie.c     |    1 +
> >  arch/arm/mach-tegra/board-harmony-pinmux.c   |    1 +
> >  arch/arm/mach-tegra/board-paz00-pinmux.c     |    1 +
> >  arch/arm/mach-tegra/board-trimslice-pinmux.c |    1 +
> >  arch/arm/mach-tegra/include/mach/pinmux.h    |   25 +++----
> >  arch/arm/mach-tegra/pinmux-tegra20-tables.c  |   15 +++-
> >  arch/arm/mach-tegra/pinmux.c                 |  105 ++++++++++++++-----------
> >  7 files changed, 86 insertions(+), 63 deletions(-)
> >
> > diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
> > index 6db7d69..bd402d0 100644
> > --- a/arch/arm/mach-tegra/board-harmony-pcie.c
> > +++ b/arch/arm/mach-tegra/board-harmony-pcie.c
> > @@ -23,6 +23,7 @@
> >  #include <asm/mach-types.h>
> >
> >  #include <mach/pinmux.h>
> > +#include <mach/pinmux-tegra20.h>
> 
> Boards shouldn't have to include this. The idea is that you should only
> have to do board code against the pinmux.h interface, which internally
> abstracts it for tegra 20 vs tegra 30.

The pinmux naming is still SoC specific. Unless we move this to devicetree
(which should be part of a different patchset), I don't see how we can solve
this, except by renaming all the pingroups. That would cause a lot more
changes though.

Cheers,

Peter.
