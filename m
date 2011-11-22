Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1KVTBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:01:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57183 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1KVTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:01:44 -0500
Date: Tue, 22 Nov 2011 11:01:46 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
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
Subject: Re: [PATCH 06/10] arm/tegra: prepare pinmux code for multiple tegra
 variants
Message-ID: <20111122190146.GA31361@quad.lixom.net>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-7-git-send-email-pdeschrijver@nvidia.com>
 <20111118214116.GC31678@quad.lixom.net>
 <20111121142919.GN19069@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121142919.GN19069@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 04:29:19PM +0200, Peter De Schrijver wrote:
> On Fri, Nov 18, 2011 at 10:41:16PM +0100, Olof Johansson wrote:
> > On Thu, Nov 17, 2011 at 06:19:20PM +0200, Peter De Schrijver wrote:
> > > This patch modifies the pinmux code to be useable for multiple tegra variants.
> > > Some tegra20 specific constants will be replaced by variables which will be
> > > initialized to the appropriate value at runtime.
> > >
> > > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > > ---
> > >  arch/arm/mach-tegra/board-harmony-pcie.c     |    1 +
> > >  arch/arm/mach-tegra/board-harmony-pinmux.c   |    1 +
> > >  arch/arm/mach-tegra/board-paz00-pinmux.c     |    1 +
> > >  arch/arm/mach-tegra/board-trimslice-pinmux.c |    1 +
> > >  arch/arm/mach-tegra/include/mach/pinmux.h    |   25 +++----
> > >  arch/arm/mach-tegra/pinmux-tegra20-tables.c  |   15 +++-
> > >  arch/arm/mach-tegra/pinmux.c                 |  105 ++++++++++++++-----------
> > >  7 files changed, 86 insertions(+), 63 deletions(-)
> > >
> > > diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
> > > index 6db7d69..bd402d0 100644
> > > --- a/arch/arm/mach-tegra/board-harmony-pcie.c
> > > +++ b/arch/arm/mach-tegra/board-harmony-pcie.c
> > > @@ -23,6 +23,7 @@
> > >  #include <asm/mach-types.h>
> > >
> > >  #include <mach/pinmux.h>
> > > +#include <mach/pinmux-tegra20.h>
> > 
> > Boards shouldn't have to include this. The idea is that you should only
> > have to do board code against the pinmux.h interface, which internally
> > abstracts it for tegra 20 vs tegra 30.
> 
> The pinmux naming is still SoC specific. Unless we move this to devicetree
> (which should be part of a different patchset), I don't see how we can solve
> this, except by renaming all the pingroups. That would cause a lot more
> changes though.

If the pinmux naming and numbering is unique per SoC then sharing
namespace for them could be a source of confusion. If we need to keep
them around much longer, then doing that rename would be a good idea. But
we can do that separately from this change. So the include change is ok
for now.

My other comments about the code changes still stands though, so please
address those.


-Olof
