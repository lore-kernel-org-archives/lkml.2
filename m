Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2CMTca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:32:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42969 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab2CMTcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:32:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] Renesas SoC updates for v3.4, take 2
Date: Tue, 13 Mar 2012 20:36:22 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>, Paul Mundt <lethal@linux-sh.org>
References: <201203092155.04731.rjw@sisk.pl> <201203122353.30182.rjw@sisk.pl> <201203131026.08495.arnd@arndb.de>
In-Reply-To: <201203131026.08495.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132036.22991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 13, 2012, Arnd Bergmann wrote:
> On Monday 12 March 2012, Rafael J. Wysocki wrote:
> > Please pull Renesas SoC updates for v3.4 since commit
> > fde7d9049e55ab85a390be7f415d74c9f62dd0f9
> > 
> >     Linux 3.3-rc7
> > 
> > with top-most commit 2854903ad1329d09d7ec35639fff0949e45d496d
> > 
> >     ARM: mach-shmobile: default to no earlytimer
> > 
> > from the git repository at:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/renesas.git soc
> > 
> > They include:
> > 
> > * The rename of shmobile struct clk_ops to struct sh_clk_ops to avoid
> >   possible future name space collision with common struct clk code.
> > 
> >   This also affects drivers that are shared with the sh architecture,
> >   so the branch containing this part of the material, clk_ops-rename,
> >   will be merged into the Paul Mundt's sh tree if necessary.
> > 
> > * Introduction of L2 Cache support for r8a7779.
> > 
> > * Conversion of the mach-shmobile subarch to properly use a per-SoC
> >   map_io and separate init_early callback for early serial console
> >   support on platforms where that is possible.
> > 
> > Magnus Damm is the author of all the changes.
> > 
> 
> Thanks for rebasing this, Olof will merge this soon.

Thanks!

> Note that the __io() issue has turned out to be more urgent than I first
> thought when we discussed it, so it would be good to apply the patch below
> on top of your series.

Do you want me to apply it now or will you do that in your tree?

Rafael


> 8<-----
> ARM: shmobile: remove additional __io() macro use
> 
> setup-r8a7779.c has grown a new user of the __io() macro. Rob Herring's
> PIO cleanup series already gets rid of all other uses in shmobile, so
> we should ensure that this one gets removed as well.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/arch/arm/mach-shmobile/setup-r8a7779.c b/arch/arm/mach-shmobile/setup-r8a7779.c
> index ce57d90..9545d82 100644
> --- a/arch/arm/mach-shmobile/setup-r8a7779.c
> +++ b/arch/arm/mach-shmobile/setup-r8a7779.c
> @@ -246,7 +246,7 @@ void __init r8a7779_add_standard_devices(void)
>  {
>  #ifdef CONFIG_CACHE_L2X0
>  	/* Early BRESP enable, Shared attribute override enable, 64K*16way */
> -	l2x0_init(__io(0xf0100000), 0x40470000, 0x82000fff);
> +	l2x0_init((void __iomem __force *)(0xf0100000), 0x40470000, 0x82000fff);
>  #endif
>  	r8a7779_pm_init();
>  
> 
> 

