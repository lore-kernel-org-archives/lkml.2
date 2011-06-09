Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1FIRR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:17:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:47333 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1FIRRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:17:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,342,1304319600"; 
   d="scan'208";a="16250163"
Subject: Re: [PATCH v2 5/5] spi/ep93xx: add DMA support
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mika Westerberg <mika.westerberg@iki.fi>,
        linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        rmallon@gmail.com, dan.j.williams@intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110608215356.GA17138@ponder.secretlab.ca>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
	 <4b27fc93b7df900943e7c12084a8340cbc5fe1a8.1306662317.git.mika.westerberg@iki.fi>
	 <20110603204400.GH17972@ponder.secretlab.ca> <20110607171403.GA3011@acer>
	 <BANLkTikKOcc2Vg1p3kG4ZSLjJ0RTZWS=2A@mail.gmail.com>
	 <20110607190607.GB3011@acer> <20110607191824.GA2035@ponder.secretlab.ca>
	 <20110607192945.GC3011@acer> <20110607194034.GC2035@ponder.secretlab.ca>
	 <1307505512.10976.91.camel@vkoul-udesk3>
	 <20110608215356.GA17138@ponder.secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 22:12:37 +0530
Message-ID: <1307637757.10976.93.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 15:53 -0600, Grant Likely wrote:
> On Wed, Jun 08, 2011 at 09:28:32AM +0530, Koul, Vinod wrote:
> > On Tue, 2011-06-07 at 13:40 -0600, Grant Likely wrote:
> > > On Tue, Jun 07, 2011 at 10:29:45PM +0300, Mika Westerberg wrote:
> > > > On Tue, Jun 07, 2011 at 01:18:24PM -0600, Grant Likely wrote:
> > > > > On Tue, Jun 07, 2011 at 10:06:07PM +0300, Mika Westerberg wrote:
> > > > > > On Tue, Jun 07, 2011 at 12:45:26PM -0600, Grant Likely wrote:
> > > > > > > On Tue, Jun 7, 2011 at 11:14 AM, Mika Westerberg <mika.westerberg@iki.fi> wrote:
> > > > > > > >
> > > > > > > > I just realized that once the SPI driver renaming patch (spi: reorganize
> > > > > > > > drivers) enters linux-next, this patch (which sits on Vinod's tree) will cause
> > > > > > > > a merge conflict. Any ideas how to avoid it beforehand?
> > > > > > > 
> > > > > > > Yes, put the whole series into a separate branch all by itself.  Merge
> > > > > > > that branch into Vinod's tree and I'll also merge it into spi/next,
> > > > > > > and I'll fix up the merge conflict when I do.
> > > > > > 
> > > > > > More stupid questions: Do you mean that I create a branch in my public
> > > > > > repository somewhere? If that is the case, then there is a problem that I
> > > > > > don't have any public repository and I doubt that I get such before linux-next
> > > > > > is rebuilt.
> > > > > 
> > > > > It doesn't have to be your repo.  Vinod could do it, or I could.
> > > > 
> > > > Ah, I see.
> > > > 
> > > > Would it then be possible that you could do it? Please let me and Vinod know
> > > > what is needed from us.
> > > > 
> > > > And sorry for this mess.
> > > 
> > > I'll need an ack from Vinod first for the series so that I can add it
> > > before I make the commits, but other than that I have no problem doing
> > > so.
> > Acked-by: Vinod Koul <vinod.koul@intel.com>
> > 
> > Let me know which branch you have pushed and I will merge that to my
> > tree
> 
> Just pushed out to the branch below.  Take a look, make sure it is
> correct, and if it looks good to you then go ahead and merge it, and I
> ll also merge it into spi/next.
> 
> The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:
> 
>   Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)
> 
> are available in the git repository at:
>   git://git.secretlab.ca/git/linux-2.6 ep93xx-dma
> 
> Geert Uytterhoeven (1):
>       spi/rtc-m41t93: Use spi_get_drvdata() for SPI devices
> 
> Govindraj.R (1):
>       spi/omap2: fix uninitialized variable
> 
> Grant Likely (1):
>       Merge remote-tracking branch 'origin' into spi/merge
> 
> Mika Westerberg (5):
>       dmaengine: add ep93xx DMA support
>       ep93xx: add dmaengine platform code
>       ASoC: ep93xx: convert to use the DMA engine API
>       ep93xx: remove the old M2P DMA code
>       spi/ep93xx: add DMA support
> 
>  Documentation/spi/ep93xx_spi                   |   10 +
>  arch/arm/mach-ep93xx/Makefile                  |    4 +-
>  arch/arm/mach-ep93xx/core.c                    |    6 +-
>  arch/arm/mach-ep93xx/dma-m2p.c                 |  411 -------
>  arch/arm/mach-ep93xx/dma.c                     |  108 ++
>  arch/arm/mach-ep93xx/include/mach/dma.h        |  190 ++---
>  arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |    2 +
>  drivers/dma/Kconfig                            |    7 +
>  drivers/dma/Makefile                           |    1 +
>  drivers/dma/ep93xx_dma.c                       | 1355 ++++++++++++++++++++++++
>  drivers/rtc/rtc-m41t93.c                       |    2 +-
>  drivers/spi/ep93xx_spi.c                       |  303 +++++-
>  drivers/spi/omap2_mcspi.c                      |    2 +-
>  sound/soc/ep93xx/ep93xx-ac97.c                 |    4 +-
>  sound/soc/ep93xx/ep93xx-i2s.c                  |    4 +-
>  sound/soc/ep93xx/ep93xx-pcm.c                  |  137 ++--
>  16 files changed, 1932 insertions(+), 614 deletions(-)
>  delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c
>  create mode 100644 arch/arm/mach-ep93xx/dma.c
>  create mode 100644 drivers/dma/ep93xx_dma.c
Thanks, I have merged them into my slave-dma next.


-- 
~Vinod

