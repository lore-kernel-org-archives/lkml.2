Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1FEIVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 04:21:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43907 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab1FEIVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 04:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PH6rGbUNvOkOmr8izOFniWEVmiVn/f0mrJkbqteF8+M25adroFip8pMqvCk1NCIxJW
         E+LszvysbrjDY4drLE1JTUL1Bjj5RdaFUJk1yWORMvYS0fo572vKaWh8NqBLCU8YE1SV
         QV0Y/C4SduY2dqUwZbL/I7rgZEdeMbpXGB8r4=
Date: Sun, 5 Jun 2011 11:19:04 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: vinod.koul@intel.com
Cc: hsweeten@visionengravers.com, rmallon@gmail.com, dan.j.williams@intel.com,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/5] ep93xx DMA patches
Message-ID: <20110605081904.GA16018@acer>
References: <cover.1306662317.git.mika.westerberg@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1306662317.git.mika.westerberg@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vinod,

As this series has acks for all the subsystem maintainers, would it be ok for
you to take the entire series via your tree? Or do you have any idea how to
get it merged?

On Sun, May 29, 2011 at 01:10:01PM +0300, Mika Westerberg wrote:
> This is an updated version of the ep93xx DMA patches. Previous version can be
> found here: https://lkml.org/lkml/2011/5/22/86.
> 
> Changes to v1:
>  * removed unnecessary header
>  * corrected SPI driver documentation
>  * DMA driver platform code is only compiled when CONFIG_EP93XX_DMA is
>    enabled
> 
> I tried to put all the acks in place, hope I got them right.
> 
> There is a dependency between patch 1 and patch 4 which I'm not entirely sure
> how to solve. Basically it is required that we have patch 1 applied before
> patch 4 or merge conflict results.
> 
> Otherwise it shouldn't matter in which order the patches arrive to the
> mainline.
> 
> Unless someone has a better idea, I suggest that these patches will go through
> their respective subsystem trees. All the maintainers should be copied.
> 
> Thanks,
> MW
> 
> Mika Westerberg (5):
>   dmaengine: add ep93xx DMA support
>   ep93xx: add dmaengine platform code
>   ASoC: ep93xx: convert to use the DMA engine API
>   ep93xx: remove the old M2P DMA code
>   spi/ep93xx: add DMA support
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
>  drivers/spi/ep93xx_spi.c                       |  303 +++++-
>  sound/soc/ep93xx/ep93xx-ac97.c                 |    4 +-
>  sound/soc/ep93xx/ep93xx-i2s.c                  |    4 +-
>  sound/soc/ep93xx/ep93xx-pcm.c                  |  137 ++--
>  14 files changed, 1930 insertions(+), 612 deletions(-)
>  delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c
>  create mode 100644 arch/arm/mach-ep93xx/dma.c
>  create mode 100644 drivers/dma/ep93xx_dma.c
> 
> -- 
> 1.7.4.4
