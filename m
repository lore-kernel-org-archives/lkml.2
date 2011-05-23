Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab1EWUK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:10:28 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:55429 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756702Ab1EWUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:10:27 -0400
Message-ID: <4DDABF2C.2010708@bluewatersys.com>
Date: Tue, 24 May 2011 08:10:20 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
Reply-To: rmallon@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: linux-arm-kernel@lists.infradead.org, hsweeten@visionengravers.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ep93xx DMA patches
References: <cover.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/11 05:03, Mika Westerberg wrote:
> Hello all,
> 
> Motivation of this series was to add DMA support for the ep93xx SPI driver.
> However, current platform DMA code didn't support the M2M channels which were
> required for SPI (and IDE) peripherals.
> 
> Ryan Mallon suggested that maybe we should integrate both M2M and M2P code
> under the dmaengine API. The purpose of this series is to do just that and
> convert all the existing users to use that new API.
> 
> Patches 1-4 add dmaengine driver and convert the existing users to dmaengine
> API. The last patch adds DMA support for the SPI driver.
> 
> I've been testing these on TS-7260 (ep9302) connected to SPI EEPROM, and
> Sim.One (ep9307) with mmc_spi and AC'97 audio.
> 
> memcpy() testing has been done by running drivers/dma/dmatest.ko.
> 
> Regards,
> MW

Hi Mika,

I've had a quick look through the patch series, and I can't see any
problems with it. Thanks especially for the thorough documentation in
the code. Unfortunately I don't have access to any ep93xx hardware at
the moment to do testing. Does anybody else have hardware with I2S audio
to test? It sounds like the SPI code is pretty well tested already?

Like Hartley said, it looks like this reduces the size of
arch/arm/mach-ep93xx and gets rid of our custom DMA implementation, so
we would really like this to get merged.

Also, can you please update my email in the patches to
"rmallon@gmail.com" (add my Signed-off-by if you want).

Thanks,
~Ryan

> 
> Mika Westerberg (5):
>   dmaengine: add ep93xx DMA support
>   ep93xx: add dmaengine platform code
>   ASoC: ep93xx: convert to use the DMA engine API
>   ep93xx: remove the old M2P DMA code
>   spi/ep93xx: add DMA support
> 
>  Documentation/spi/ep93xx_spi                   |   10 +
>  arch/arm/mach-ep93xx/Makefile                  |    2 +-
>  arch/arm/mach-ep93xx/core.c                    |    6 +-
>  arch/arm/mach-ep93xx/dma-m2p.c                 |  411 -------
>  arch/arm/mach-ep93xx/dma.c                     |  108 ++
>  arch/arm/mach-ep93xx/include/mach/dma.h        |  190 ++---
>  arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |    2 +
>  drivers/dma/Kconfig                            |    7 +
>  drivers/dma/Makefile                           |    1 +
>  drivers/dma/ep93xx_dma.c                       | 1356 ++++++++++++++++++++++++
>  drivers/spi/ep93xx_spi.c                       |  303 +++++-
>  sound/soc/ep93xx/ep93xx-ac97.c                 |    4 +-
>  sound/soc/ep93xx/ep93xx-i2s.c                  |    4 +-
>  sound/soc/ep93xx/ep93xx-pcm.c                  |  137 ++--
>  14 files changed, 1929 insertions(+), 612 deletions(-)
>  delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c
>  create mode 100644 arch/arm/mach-ep93xx/dma.c
>  create mode 100644 drivers/dma/ep93xx_dma.c
> 

