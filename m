Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1KCCW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:22:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35435 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1KCCWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 22:22:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133917970"
Date: Wed, 2 Nov 2011 19:22:52 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, Linus <torvalds@linux-foundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20111103022252.GA23489@huya.qualcomm.com>
References: <20110912120501.764336af05069fa23a371b5e@canb.auug.org.au>
 <4E6D6C0D.60100@codeaurora.org>
 <20110913115533.403d4fe6d961ccc8ba9b58b7@canb.auug.org.au>
 <20111103130924.5811caec6db378f467006fc3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103130924.5811caec6db378f467006fc3@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 01:09:24PM +1100, Stephen Rothwell wrote:
> Hi Arnd,
> 
> On Tue, 13 Sep 2011 11:55:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > On Sun, 11 Sep 2011 19:18:53 -0700 Stephen Boyd <sboyd@codeaurora.org> wrote:
> > >
> > > The device tree machine description also needs to have the .fixup and
> > > .reserve callbacks added to it so that the device tree machines boot
> > > properly. Perhaps the soc tree needs to pull in Russell's tree at some
> > > point to resolve this subtle logical conflict or when the trees are
> > > merged together someone will need to do an evil merge and add the
> > > callbacks in the merge commit.
> > 
> > Ah, right.  I have added this merge fixup for today and can carry it as
> > necessary.
> 
> I am still applying this patch to the arm-soc merge.  I assume that it is
> needed in Linus' tree now.

I can look more into this tomorrow.  When I was testing linux-next
last week, the fixups weren't working with device tree anyway, so I
might need to come up with another solution.

The fixups are called with the ATAGS, which aren't available with DT.
The meminfo is passed to the fixup, but it hasn't been initialized
from the old ATAG information, so there isn't anything to fix up.

I think I'm just going to have to convince our bootloader people to
actually pass in the right memory information in the first place.

David

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 13 Sep 2011 11:51:48 +1000
> Subject: [PATCH] arm-soc: merge fixup for fixup/reserve being added to MACHINE descriptions
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/mach-msm/board-msm8x60.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
> index 328df27..4ad2afb 100644
> --- a/arch/arm/mach-msm/board-msm8x60.c
> +++ b/arch/arm/mach-msm/board-msm8x60.c
> @@ -153,6 +153,8 @@ MACHINE_END
>  #ifdef CONFIG_OF
>  /* TODO: General device tree support for all MSM. */
>  DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
> +	.fixup = msm8x60_fixup,
> +	.reserve = msm8x60_reserve,
>  	.map_io = msm8x60_map_io,
>  	.init_irq = msm8x60_init_irq,
>  	.init_machine = msm8x60_dt_init,
> -- 
> 1.7.5.4
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
