Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1EWReb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:34:31 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:43940 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1EWRea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:34:30 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1306172069!5895059!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mika Westerberg <mika.westerberg@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 May 2011 12:34:28 -0500
Subject: RE: [PATCH 0/5] ep93xx DMA patches
Thread-Topic: [PATCH 0/5] ep93xx DMA patches
Thread-Index: AcwYoqdmCG7IFeEORLGWrbOwuP7DWAAzILIg
Message-ID: <0D753D10438DA54287A00B027084269764D315F675@AUSP01VMBX24.collaborationhost.net>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 22, 2011 10:03 AM, Mika Westerberg wrote:
>
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

Mika,

Thanks for posting this.  I'll try to do some testing and feedback later this
week.

One positive, it looks like this will result in a small reduction in the LOC
for arch/arm/mach-ep93xx.  That might help in getting this merged.  ;-)

Regards,
Hartley
