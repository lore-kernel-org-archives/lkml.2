Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931Ab2HWR0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:26:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63519 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2HWR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:26:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] [RFC] ARM: treewide: manually change more mach-*/*.h includes
Date: Thu, 23 Aug 2012 17:26:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
References: <201208221253.07278.arnd@arndb.de> <20120822214323.GA12255@n2100.arm.linux.org.uk> <201208231135.11688.arnd@arndb.de>
In-Reply-To: <201208231135.11688.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208231726.11293.arnd@arndb.de>
X-Provags-ID: V02:K0:sKHz8XZDQbyu4GPsVnA+nt3AiEnIjUXlrfiMQp/svW1
 7ltSQX1TmkSOT1MQuSF2upthS8hOK0HaZyveeBTCFMCouevrVK
 04aZGRljPVqSJekPMo9vqrNTyM1rKRx0QcALrrEK/WMe6KGxQJ
 UjpIVWp5cffuqUxcogULeVWmtis5/8kVRZ8rMjQm9LdNzRxudu
 ZB232hh3YDOQcXuv8diaV5OYh9PC85VzilkHuqI5RnKbLg0hzp
 o8+tc0hEu1pFFbWbMnj9gCWI0N3l1te7M938uNVMdNeJpxi+nu
 E6xNB7I3mDasX46tnB+TDMUJ5Q1eMkigFyOyWnL6/edyRK/aGr
 wNTF8LUsr8m8RPpA90tg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012, Arnd Bergmann wrote:
> On Wednesday 22 August 2012, Russell King - ARM Linux wrote:
> > In any case, what we should be doing here as well is moving the headers
> > included by drivers for platform data out of the arch/arm/mach/ subtrees
> > and into include/linux/platform_data.  That will substantially reduce the
> > amount of mach/ headers to deal with.
> 
> I've just looked at the {mach,plat}/*.h files that get included in ARM
> specific drivers. Out of the 342 header files that get used in this way,
> I found 93 that are practically just platform data, and a few that
> are platform_data mixed with something else.
> 
> How about I move all the pure platform data definition files now and
> rebase the other patches on top of that. Here is a list of suggested
> file names in include/linux/platform_data/:

I've just scripted this and am running my build testsuite over it now.

Please let me know what you think about it.

	Arnd

The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git 

for you to fetch changes up to 25296e032db173e8376123c2801cd233c9dc9b78:

  ARM: spear: move platform_data definitions (2012-08-23 19:15:49 +0200)

----------------------------------------------------------------
Arnd Bergmann (16):
      ARM: at91: move platform_data definitions
      ARM: davinci: move platform_data definitions
      ARM: ep93xx: move platform_data definitions
      ARM: imx: move platform_data definitions
      ARM: msm: move platform_data definitions
      ARM: netx: move platform_data definitions
      ARM: pxa: move platform_data definitions
      ARM: sa1100: move platform_data definitions
      ARM: tegra: move platform_data definitions
      ARM: vt8500: move platform_data definitions
      ARM: w90x900: move platform_data definitions
      ARM: nomadik: move platform_data definitions
      ARM: omap: move platform_data definitions
      ARM: orion: move platform_data definitions
      ARM: samsung: move platform_data definitions
      ARM: spear: move platform_data definitions

 Documentation/spi/ep93xx_spi                       |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    2 +-
 arch/arm/mach-at91/include/mach/atmel-mci.h        |    2 +-
 arch/arm/mach-davinci/aemif.c                      |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c            |    8 ++++----
 arch/arm/mach-davinci/board-da850-evm.c            |    6 +++---
 arch/arm/mach-davinci/board-dm355-evm.c            |    8 ++++----
 arch/arm/mach-davinci/board-dm355-leopard.c        |    8 ++++----
 arch/arm/mach-davinci/board-dm365-evm.c            |    8 ++++----
 arch/arm/mach-davinci/board-dm644x-evm.c           |   10 +++++-----
 arch/arm/mach-davinci/board-dm646x-evm.c           |    6 +++---
 arch/arm/mach-davinci/board-mityomapl138.c         |    4 ++--
 arch/arm/mach-davinci/board-neuros-osd2.c          |    8 ++++----
 arch/arm/mach-davinci/board-sffsdr.c               |    4 ++--
 arch/arm/mach-davinci/davinci.h                    |    4 ++--
 arch/arm/mach-davinci/devices.c                    |    4 ++--
 arch/arm/mach-davinci/dm355.c                      |    4 ++--
 arch/arm/mach-davinci/dm365.c                      |    6 +++---
 arch/arm/mach-davinci/dm644x.c                     |    2 +-
 arch/arm/mach-davinci/dm646x.c                     |    2 +-
 arch/arm/mach-davinci/include/mach/da8xx.h         |   10 +++++-----
 arch/arm/mach-davinci/include/mach/tnetv107x.h     |    4 ++--
 arch/arm/mach-davinci/usb.c                        |    2 +-
 arch/arm/mach-dove/common.c                        |    2 +-
 arch/arm/mach-ep93xx/core.c                        |    6 +++---
 arch/arm/mach-ep93xx/dma.c                         |    2 +-
 arch/arm/mach-ep93xx/edb93xx.c                     |    4 ++--
 arch/arm/mach-ep93xx/simone.c                      |    2 +-
 arch/arm/mach-ep93xx/snappercl15.c                 |    2 +-
 arch/arm/mach-ep93xx/vision_ep9307.c               |    4 ++--
 arch/arm/mach-exynos/dev-audio.c                   |    2 +-
 arch/arm/mach-exynos/dev-ohci.c                    |    2 +-
 arch/arm/mach-exynos/mach-nuri.c                   |    6 +++---
 arch/arm/mach-exynos/mach-origen.c                 |    6 +++---
 arch/arm/mach-exynos/mach-smdk4x12.c               |    2 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |    6 +++---
 arch/arm/mach-exynos/mach-universal_c210.c         |    4 ++--
 arch/arm/mach-exynos/setup-i2c0.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c1.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c2.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c3.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c4.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c5.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c6.c                  |    2 +-
 arch/arm/mach-exynos/setup-i2c7.c                  |    2 +-
 arch/arm/mach-kirkwood/board-dreamplug.c           |    2 +-
 arch/arm/mach-kirkwood/board-goflexnet.c           |    2 +-
 arch/arm/mach-kirkwood/common.c                    |   10 +++++-----
 arch/arm/mach-kirkwood/d2net_v2-setup.c            |    2 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c        |    2 +-
 arch/arm/mach-kirkwood/dockstar-setup.c            |    2 +-
 arch/arm/mach-kirkwood/guruplug-setup.c            |    2 +-
 arch/arm/mach-kirkwood/netspace_v2-setup.c         |    2 +-
 arch/arm/mach-kirkwood/netxbig_v2-setup.c          |    2 +-
 arch/arm/mach-kirkwood/openrd-setup.c              |    2 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c           |    2 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c          |    2 +-
 arch/arm/mach-mmp/aspenite.c                       |    2 +-
 arch/arm/mach-mmp/include/mach/mmp2.h              |    2 +-
 arch/arm/mach-mmp/include/mach/pxa168.h            |    4 ++--
 arch/arm/mach-mmp/include/mach/pxa910.h            |    2 +-
 arch/arm/mach-mmp/sram.c                           |    2 +-
 arch/arm/mach-mmp/teton_bga.c                      |    2 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |    2 +-
 arch/arm/mach-msm/board-trout-mmc.c                |    2 +-
 arch/arm/mach-msm/board-trout-panel.c              |    2 +-
 arch/arm/mach-msm/devices-msm7x00.c                |    2 +-
 arch/arm/mach-msm/devices-msm7x30.c                |    2 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |    2 +-
 arch/arm/mach-msm/include/mach/board.h             |    2 +-
 arch/arm/mach-mv78xx0/common.c                     |    4 ++--
 arch/arm/mach-netx/nxdb500.c                       |    2 +-
 arch/arm/mach-netx/nxdkn.c                         |    2 +-
 arch/arm/mach-netx/nxeb500hmi.c                    |    2 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |    2 +-
 arch/arm/mach-omap1/board-ams-delta.c              |    2 +-
 arch/arm/mach-omap1/board-fsample.c                |    2 +-
 arch/arm/mach-omap1/board-h2.c                     |    2 +-
 arch/arm/mach-omap1/board-h3.c                     |    2 +-
 arch/arm/mach-omap1/board-htcherald.c              |    2 +-
 arch/arm/mach-omap1/board-innovator.c              |    2 +-
 arch/arm/mach-omap1/board-nokia770.c               |    4 ++--
 arch/arm/mach-omap1/board-osk.c                    |    2 +-
 arch/arm/mach-omap1/board-palmte.c                 |    2 +-
 arch/arm/mach-omap1/board-palmtt.c                 |    2 +-
 arch/arm/mach-omap1/board-palmz71.c                |    2 +-
 arch/arm/mach-omap1/board-perseus2.c               |    2 +-
 arch/arm/mach-omap1/board-sx1.c                    |    2 +-
 arch/arm/mach-omap1/mcbsp.c                        |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |    4 ++--
 arch/arm/mach-omap2/board-cm-t3517.c               |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c             |    4 ++--
 arch/arm/mach-omap2/board-flash.c                  |    4 ++--
 arch/arm/mach-omap2/board-igep0020.c               |    2 +-
 arch/arm/mach-omap2/board-ldp.c                    |    2 +-
 arch/arm/mach-omap2/board-n8x0.c                   |    4 ++--
 arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c               |    4 ++--
 arch/arm/mach-omap2/board-omap3pandora.c           |    4 ++--
 arch/arm/mach-omap2/board-omap3stalker.c           |    4 ++--
 arch/arm/mach-omap2/board-omap3touchbook.c         |    4 ++--
 arch/arm/mach-omap2/board-overo.c                  |    4 ++--
 arch/arm/mach-omap2/board-rm680.c                  |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    4 ++--
 arch/arm/mach-omap2/board-rx51-video.c             |    2 +-
 arch/arm/mach-omap2/board-rx51.c                   |    2 +-
 arch/arm/mach-omap2/board-zoom-display.c           |    2 +-
 arch/arm/mach-omap2/common-board-devices.c         |    4 ++--
 arch/arm/mach-omap2/devices.c                      |    2 +-
 arch/arm/mach-omap2/dsp.c                          |    2 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |    2 +-
 arch/arm/mach-omap2/gpmc-onenand.c                 |    2 +-
 arch/arm/mach-omap2/mcbsp.c                        |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |    4 ++--
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |    4 ++--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    4 ++--
 arch/arm/mach-omap2/voltage.h                      |    2 +-
 arch/arm/mach-orion5x/common.c                     |    4 ++--
 arch/arm/mach-orion5x/db88f5281-setup.c            |    2 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |    2 +-
 arch/arm/mach-pxa/am200epd.c                       |    2 +-
 arch/arm/mach-pxa/am300epd.c                       |    2 +-
 arch/arm/mach-pxa/balloon3.c                       |    8 ++++----
 arch/arm/mach-pxa/cm-x270.c                        |    4 ++--
 arch/arm/mach-pxa/cm-x2xx.c                        |    2 +-
 arch/arm/mach-pxa/cm-x300.c                        |   10 +++++-----
 arch/arm/mach-pxa/colibri-evalboard.c              |    4 ++--
 arch/arm/mach-pxa/colibri-pxa270-income.c          |    6 +++---
 arch/arm/mach-pxa/colibri-pxa300.c                 |    4 ++--
 arch/arm/mach-pxa/colibri-pxa320.c                 |    4 ++--
 arch/arm/mach-pxa/colibri-pxa3xx.c                 |    6 +++---
 arch/arm/mach-pxa/corgi.c                          |    4 ++--
 arch/arm/mach-pxa/csb726.c                         |    4 ++--
 arch/arm/mach-pxa/devices.c                        |   16 ++++++++--------
 arch/arm/mach-pxa/em-x270.c                        |   10 +++++-----
 arch/arm/mach-pxa/eseries.c                        |    4 ++--
 arch/arm/mach-pxa/ezx.c                            |    8 ++++----
 arch/arm/mach-pxa/gumstix.c                        |    2 +-
 arch/arm/mach-pxa/hx4700.c                         |    2 +-
 arch/arm/mach-pxa/idp.c                            |    4 ++--
 arch/arm/mach-pxa/littleton.c                      |    8 ++++----
 arch/arm/mach-pxa/lpd270.c                         |    8 ++++----
 arch/arm/mach-pxa/lubbock.c                        |    6 +++---
 arch/arm/mach-pxa/magician.c                       |    8 ++++----
 arch/arm/mach-pxa/mainstone.c                      |   10 +++++-----
 arch/arm/mach-pxa/mioa701.c                        |    8 ++++----
 arch/arm/mach-pxa/mxm8x10.c                        |    8 ++++----
 arch/arm/mach-pxa/palm27x.c                        |    8 ++++----
 arch/arm/mach-pxa/palmld.c                         |   10 +++++-----
 arch/arm/mach-pxa/palmt5.c                         |   10 +++++-----
 arch/arm/mach-pxa/palmtc.c                         |    6 +++---
 arch/arm/mach-pxa/palmte2.c                        |    8 ++++----
 arch/arm/mach-pxa/palmtreo.c                       |   14 +++++++-------
 arch/arm/mach-pxa/palmtx.c                         |   10 +++++-----
 arch/arm/mach-pxa/palmz72.c                        |   12 ++++++------
 arch/arm/mach-pxa/pcm990-baseboard.c               |    8 ++++----
 arch/arm/mach-pxa/poodle.c                         |    6 +++---
 arch/arm/mach-pxa/pxa27x.c                         |    2 +-
 arch/arm/mach-pxa/pxa2xx.c                         |    2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c                    |    2 +-
 arch/arm/mach-pxa/pxa3xx.c                         |    2 +-
 arch/arm/mach-pxa/raumfeld.c                       |    8 ++++----
 arch/arm/mach-pxa/saar.c                           |    2 +-
 arch/arm/mach-pxa/spitz.c                          |    8 ++++----
 arch/arm/mach-pxa/stargate2.c                      |    2 +-
 arch/arm/mach-pxa/tavorevb.c                       |    4 ++--
 arch/arm/mach-pxa/tosa.c                           |    4 ++--
 arch/arm/mach-pxa/trizeps4.c                       |    8 ++++----
 arch/arm/mach-pxa/viper.c                          |    4 ++--
 arch/arm/mach-pxa/vpac270.c                        |    8 ++++----
 arch/arm/mach-pxa/z2.c                             |    6 +++---
 arch/arm/mach-pxa/zeus.c                           |    8 ++++----
 arch/arm/mach-pxa/zylonite.c                       |   10 +++++-----
 arch/arm/mach-s3c24xx/common-smdk.c                |    4 ++--
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-anubis.c                |    6 +++---
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |    6 +++---
 arch/arm/mach-s3c24xx/mach-bast.c                  |    8 ++++----
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   10 +++++-----
 arch/arm/mach-s3c24xx/mach-h1940.c                 |    8 ++++----
 arch/arm/mach-s3c24xx/mach-jive.c                  |    6 +++---
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   10 +++++-----
 arch/arm/mach-s3c24xx/mach-n30.c                   |    8 ++++----
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |    4 ++--
 arch/arm/mach-s3c24xx/mach-otom.c                  |    2 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c                |    8 ++++----
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   10 +++++-----
 arch/arm/mach-s3c24xx/mach-rx3715.c                |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |    4 ++--
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |    8 ++++----
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |    6 +++---
 arch/arm/mach-s3c24xx/mach-vstms.c                 |    4 ++--
 arch/arm/mach-s3c24xx/setup-i2c.c                  |    2 +-
 arch/arm/mach-s3c24xx/simtec-audio.c               |    2 +-
 arch/arm/mach-s3c24xx/simtec-usb.c                 |    2 +-
 arch/arm/mach-s3c64xx/dev-audio.c                  |    2 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |    4 ++--
 arch/arm/mach-s3c64xx/mach-hmt.c                   |    4 ++--
 arch/arm/mach-s3c64xx/mach-mini6410.c              |    4 ++--
 arch/arm/mach-s3c64xx/mach-ncp.c                   |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |    4 ++--
 arch/arm/mach-s3c64xx/mach-smartq.c                |    8 ++++----
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |    6 +++---
 arch/arm/mach-s3c64xx/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s3c64xx/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s3c64xx/setup-ide.c                  |    2 +-
 arch/arm/mach-s5p64x0/dev-audio.c                  |    2 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |    4 ++--
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |    4 ++--
 arch/arm/mach-s5p64x0/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s5p64x0/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s5pc100/dev-audio.c                  |    2 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c              |    8 ++++----
 arch/arm/mach-s5pc100/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s5pc100/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s5pv210/dev-audio.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |    2 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |    4 ++--
 arch/arm/mach-s5pv210/mach-smdkv210.c              |    6 +++---
 arch/arm/mach-s5pv210/mach-torbreck.c              |    2 +-
 arch/arm/mach-s5pv210/setup-i2c0.c                 |    2 +-
 arch/arm/mach-s5pv210/setup-i2c1.c                 |    2 +-
 arch/arm/mach-s5pv210/setup-i2c2.c                 |    2 +-
 arch/arm/mach-sa1100/assabet.c                     |    2 +-
 arch/arm/mach-sa1100/cerf.c                        |    2 +-
 arch/arm/mach-sa1100/collie.c                      |    2 +-
 arch/arm/mach-sa1100/lart.c                        |    2 +-
 arch/arm/mach-sa1100/shannon.c                     |    2 +-
 arch/arm/mach-sa1100/simpad.c                      |    2 +-
 arch/arm/mach-tegra/board-harmony.c                |    4 ++--
 arch/arm/mach-tegra/board-paz00.c                  |    2 +-
 arch/arm/mach-tegra/board-trimslice.c              |    2 +-
 arch/arm/mach-u300/core.c                          |    2 +-
 arch/arm/mach-ux500/board-mop500.c                 |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |    2 +-
 arch/arm/mach-ux500/devices-common.h               |    2 +-
 arch/arm/mach-ux500/usb.c                          |    2 +-
 arch/arm/mach-vt8500/devices.c                     |    2 +-
 arch/arm/mach-w90x900/dev.c                        |    6 +++---
 arch/arm/mach-w90x900/mach-nuc950evb.c             |    2 +-
 arch/arm/plat-omap/common.c                        |    2 +-
 arch/arm/plat-orion/common.c                       |    4 ++--
 arch/arm/plat-samsung/devs.c                       |   20 ++++++++++----------
 drivers/ata/pata_ep93xx.c                          |    2 +-
 drivers/ata/pata_pxa.c                             |    2 +-
 drivers/ata/pata_samsung_cf.c                      |    2 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    2 +-
 drivers/crypto/ux500/hash/hash_core.c              |    2 +-
 drivers/dma/at_hdmac_regs.h                        |    2 +-
 drivers/dma/ep93xx_dma.c                           |    2 +-
 drivers/dma/mmp_tdma.c                             |    2 +-
 drivers/dma/mv_xor.c                               |    2 +-
 drivers/hwmon/s3c-hwmon.c                          |    2 +-
 drivers/i2c/busses/i2c-davinci.c                   |    2 +-
 drivers/i2c/busses/i2c-nuc900.c                    |    2 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |    2 +-
 drivers/input/keyboard/davinci_keyscan.c           |    2 +-
 drivers/input/keyboard/ep93xx_keypad.c             |    2 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |    2 +-
 drivers/input/keyboard/omap-keypad.c               |    2 +-
 drivers/input/keyboard/pxa27x_keypad.c             |    2 +-
 drivers/input/keyboard/pxa930_rotary.c             |    2 +-
 drivers/input/keyboard/spear-keyboard.c            |    2 +-
 drivers/input/keyboard/tegra-kbc.c                 |    2 +-
 drivers/input/keyboard/w90p910_keypad.c            |    2 +-
 drivers/input/mouse/pxa930_trkball.c               |    2 +-
 drivers/input/touchscreen/s3c2410_ts.c             |    2 +-
 drivers/leds/leds-netxbig.c                        |    2 +-
 drivers/leds/leds-ns2.c                            |    2 +-
 drivers/leds/leds-s3c24xx.c                        |    2 +-
 drivers/media/video/davinci/vpbe_venc.c            |    2 +-
 drivers/media/video/pxa_camera.c                   |    2 +-
 drivers/media/video/s5p-fimc/mipi-csis.c           |    2 +-
 drivers/mfd/mcp-sa11x0.c                           |    2 +-
 drivers/mmc/host/davinci_mmc.c                     |    2 +-
 drivers/mmc/host/msm_sdcc.c                        |    2 +-
 drivers/mmc/host/mvsdio.c                          |    2 +-
 drivers/mmc/host/pxamci.c                          |    2 +-
 drivers/mmc/host/s3cmci.c                          |    2 +-
 drivers/mmc/host/sdhci-tegra.c                     |    2 +-
 drivers/mtd/nand/davinci_nand.c                    |    4 ++--
 drivers/mtd/nand/nomadik_nand.c                    |    2 +-
 drivers/mtd/nand/omap2.c                           |    2 +-
 drivers/mtd/nand/orion_nand.c                      |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/mtd/onenand/omap2.c                        |    2 +-
 drivers/net/ethernet/netx-eth.c                    |    2 +-
 drivers/net/irda/pxaficp_ir.c                      |    2 +-
 drivers/pcmcia/pxa2xx_viper.c                      |    2 +-
 drivers/pinctrl/pinctrl-coh901.c                   |    2 +-
 drivers/remoteproc/omap_remoteproc.c               |    2 +-
 drivers/spi/spi-davinci.c                          |    2 +-
 drivers/spi/spi-ep93xx.c                           |    4 ++--
 drivers/spi/spi-nuc900.c                           |    2 +-
 drivers/spi/spi-omap2-mcspi.c                      |    2 +-
 drivers/spi/spi-s3c64xx.c                          |    2 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    2 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |    2 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +-
 drivers/usb/gadget/s3c2410_udc.c                   |    2 +-
 drivers/usb/host/ehci-orion.c                      |    2 +-
 drivers/usb/host/ehci-s5p.c                        |    2 +-
 drivers/usb/host/ohci-da8xx.c                      |    2 +-
 drivers/usb/host/ohci-exynos.c                     |    2 +-
 drivers/usb/host/ohci-pxa27x.c                     |    4 ++--
 drivers/usb/host/ohci-s3c2410.c                    |    2 +-
 drivers/usb/musb/da8xx.c                           |    2 +-
 drivers/usb/musb/ux500_dma.c                       |    2 +-
 drivers/video/ep93xx-fb.c                          |    2 +-
 drivers/video/msm/mddi.c                           |    2 +-
 drivers/video/msm/mddi_client_dummy.c              |    2 +-
 drivers/video/msm/mddi_client_nt35399.c            |    2 +-
 drivers/video/msm/mddi_client_toshiba.c            |    2 +-
 drivers/video/msm/mdp.c                            |    2 +-
 drivers/video/msm/mdp_hw.h                         |    2 +-
 drivers/video/msm/mdp_ppp.c                        |    2 +-
 drivers/video/msm/msm_fb.c                         |    2 +-
 drivers/video/nuc900fb.c                           |    2 +-
 drivers/video/nuc900fb.h                           |    2 +-
 drivers/video/omap/lcd_mipid.c                     |    2 +-
 drivers/video/pxafb.c                              |    2 +-
 drivers/video/vt8500lcdfb.c                        |    2 +-
 drivers/video/wm8505fb.c                           |    2 +-
 .../linux/platform_data/asoc-davinci-evm.h         |    0
 .../linux/platform_data/asoc-imx-ssi.h             |    0
 .../linux/platform_data/asoc-kirkwood.h            |    0
 .../linux/platform_data/asoc-palm27x.h             |    0
 .../linux/platform_data/asoc-s3c.h                 |    0
 .../linux/platform_data/asoc-s3c24xx_simtec.h      |    0
 .../linux/platform_data/asoc-tegra_wm8903.h        |    0
 .../linux/platform_data/ata-pxa.h                  |    0
 .../linux/platform_data/ata-samsung_cf.h           |    0
 include/linux/platform_data/atmel-aes.h            |    2 +-
 .../linux/platform_data/camera-mx1.h               |    0
 .../linux/platform_data/camera-mx2.h               |    0
 .../linux/platform_data/camera-mx3.h               |    0
 .../linux/platform_data/camera-pxa.h               |    0
 .../linux/platform_data}/crypto-ux500.h            |    0
 .../linux/platform_data/dma-atmel.h                |    0
 .../linux/platform_data/dma-ep93xx.h               |    0
 .../linux/platform_data/dma-imx-sdma.h             |    0
 .../dma.h => include/linux/platform_data/dma-imx.h |    0
 .../linux/platform_data/dma-mmp_tdma.h             |    0
 .../linux/platform_data/dma-mv_xor.h               |    0
 .../linux/platform_data/dsp-mcbsp.h                |    0
 .../linux/platform_data/dsp-omap.h                 |    0
 .../linux/platform_data/eth-netx.h                 |    0
 .../linux/platform_data/hwmon-s3c.h                |    0
 .../linux/platform_data/i2c-davinci.h              |    0
 .../i2c.h => include/linux/platform_data/i2c-imx.h |    0
 .../linux/platform_data/i2c-nuc900.h               |    0
 .../linux/platform_data/i2c-s3c2410.h              |    0
 .../linux/platform_data/irda-pxaficp.h             |    0
 .../linux/platform_data/keyboard-pxa930_rotary.h   |    0
 .../linux/platform_data/keyboard-spear.h           |    0
 .../linux/platform_data/keyboard-tegra-kbc.h       |    0
 .../linux/platform_data/keypad-ep93xx.h            |    0
 .../linux/platform_data/keypad-nomadik-ske.h       |    0
 .../linux/platform_data/keypad-omap.h              |    0
 .../linux/platform_data/keypad-pxa27x.h            |    0
 .../linux/platform_data/keypad-w90p910.h           |    0
 .../linux/platform_data/keyscan-davinci.h          |    0
 .../linux/platform_data/lcd-mipid.h                |    0
 .../linux/platform_data/leds-kirkwood-netxbig.h    |    0
 .../linux/platform_data/leds-kirkwood-ns2.h        |    0
 .../linux/platform_data/leds-s3c24xx.h             |    0
 .../linux/platform_data/mfd-mcp-sa11x0.h           |    0
 .../linux/platform_data/mipi-csis.h                |    0
 .../linux/platform_data/mmc-davinci.h              |    0
 .../linux/platform_data/mmc-esdhc-imx.h            |    0
 .../linux/platform_data/mmc-msm_sdcc.h             |    0
 .../linux/platform_data/mmc-mvsdio.h               |    0
 .../linux/platform_data/mmc-mxcmmc.h               |    0
 .../linux/platform_data/mmc-pxamci.h               |    0
 .../linux/platform_data/mmc-s3cmci.h               |    0
 .../linux/platform_data/mmc-sdhci-tegra.h          |    0
 .../linux/platform_data/mouse-pxa930_trkball.h     |    0
 .../linux/platform_data/mtd-davinci-aemif.h        |    0
 .../linux/platform_data/mtd-davinci.h              |    0
 .../linux/platform_data/mtd-mxc_nand.h             |    0
 .../linux/platform_data/mtd-nand-omap2.h           |    0
 .../linux/platform_data/mtd-nand-pxa3xx.h          |    0
 .../linux/platform_data/mtd-nand-s3c2410.h         |    0
 .../linux/platform_data/mtd-nomadik-nand.h         |    0
 .../linux/platform_data/mtd-onenand-omap2.h        |    0
 .../linux/platform_data/mtd-orion_nand.h           |    0
 .../linux/platform_data/pcmcia-pxa2xx_viper.h      |    0
 .../linux/platform_data/pinctrl-coh901.h           |    0
 .../linux/platform_data/remoteproc-omap.h          |    0
 .../linux/platform_data/serial-imx.h               |    0
 .../linux/platform_data/smartreflex-omap.h         |    0
 .../linux/platform_data/spi-davinci.h              |    0
 .../linux/platform_data/spi-ep93xx.h               |    0
 .../linux/platform_data/spi-nuc900.h               |    0
 .../linux/platform_data/spi-omap2-mcspi.h          |    0
 .../linux/platform_data/spi-s3c64xx.h              |    0
 .../linux/platform_data/touchscreen-s3c2410.h      |    0
 .../linux/platform_data/usb-davinci.h              |    0
 .../linux/platform_data/usb-ehci-mxc.h             |    0
 .../linux/platform_data/usb-ehci-orion.h           |    0
 .../linux/platform_data/usb-ehci-s5p.h             |    0
 .../linux/platform_data/usb-exynos.h               |    0
 .../linux/platform_data/usb-imx_udc.h              |    0
 .../linux/platform_data/usb-musb-ux500.h           |    0
 .../linux/platform_data/usb-mx2.h                  |    0
 .../linux/platform_data/usb-ohci-pxa27x.h          |    0
 .../linux/platform_data/usb-ohci-s3c2410.h         |    0
 .../linux/platform_data/usb-pxa3xx-ulpi.h          |    0
 .../linux/platform_data/usb-s3c2410_udc.h          |    0
 .../linux/platform_data/video-ep93xx.h             |    0
 .../linux/platform_data/video-imxfb.h              |    0
 .../linux/platform_data/video-msm_fb.h             |    0
 .../linux/platform_data/video-mx3fb.h              |    0
 .../linux/platform_data/video-nuc900fb.h           |    0
 .../linux/platform_data/video-pxafb.h              |    0
 .../linux/platform_data/video-vt8500lcdfb.h        |    0
 include/linux/power/smartreflex.h                  |    2 +-
 sound/soc/davinci/davinci-evm.c                    |    2 +-
 sound/soc/davinci/davinci-i2s.c                    |    2 +-
 sound/soc/davinci/davinci-mcasp.h                  |    2 +-
 sound/soc/davinci/davinci-pcm.h                    |    2 +-
 sound/soc/ep93xx/ep93xx-ac97.c                     |    2 +-
 sound/soc/ep93xx/ep93xx-i2s.c                      |    2 +-
 sound/soc/ep93xx/ep93xx-pcm.c                      |    2 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |    2 +-
 sound/soc/kirkwood/kirkwood-openrd.c               |    2 +-
 sound/soc/kirkwood/kirkwood-t5325.c                |    2 +-
 sound/soc/omap/am3517evm.c                         |    2 +-
 sound/soc/omap/ams-delta.c                         |    2 +-
 sound/soc/omap/igep0020.c                          |    2 +-
 sound/soc/omap/mcbsp.c                             |    2 +-
 sound/soc/omap/n810.c                              |    2 +-
 sound/soc/omap/omap-mcbsp.c                        |    2 +-
 sound/soc/omap/omap3beagle.c                       |    2 +-
 sound/soc/omap/omap3evm.c                          |    2 +-
 sound/soc/omap/omap3pandora.c                      |    2 +-
 sound/soc/omap/osk5912.c                           |    2 +-
 sound/soc/omap/overo.c                             |    2 +-
 sound/soc/omap/rx51.c                              |    2 +-
 sound/soc/omap/sdp3430.c                           |    2 +-
 sound/soc/omap/zoom2.c                             |    2 +-
 sound/soc/pxa/palm27x.c                            |    2 +-
 sound/soc/samsung/ac97.c                           |    2 +-
 sound/soc/samsung/i2s.c                            |    2 +-
 sound/soc/samsung/pcm.c                            |    2 +-
 sound/soc/samsung/s3c24xx_simtec.c                 |    2 +-
 sound/soc/samsung/spdif.c                          |    2 +-
 sound/soc/tegra/tegra_wm8903.c                     |    2 +-
 463 files changed, 625 insertions(+), 625 deletions(-)
 rename arch/arm/mach-davinci/include/mach/asp.h => include/linux/platform_data/asoc-davinci-evm.h (100%)
 rename arch/arm/plat-mxc/include/mach/ssi.h => include/linux/platform_data/asoc-imx-ssi.h (100%)
 rename arch/arm/plat-orion/include/plat/audio.h => include/linux/platform_data/asoc-kirkwood.h (100%)
 rename arch/arm/mach-pxa/include/mach/palmasoc.h => include/linux/platform_data/asoc-palm27x.h (100%)
 rename arch/arm/plat-samsung/include/plat/audio.h => include/linux/platform_data/asoc-s3c.h (100%)
 rename arch/arm/plat-samsung/include/plat/audio-simtec.h => include/linux/platform_data/asoc-s3c24xx_simtec.h (100%)
 rename arch/arm/mach-tegra/include/mach/tegra_wm8903_pdata.h => include/linux/platform_data/asoc-tegra_wm8903.h (100%)
 rename arch/arm/mach-pxa/include/mach/pata_pxa.h => include/linux/platform_data/ata-pxa.h (100%)
 rename arch/arm/plat-samsung/include/plat/ata.h => include/linux/platform_data/ata-samsung_cf.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx1_camera.h => include/linux/platform_data/camera-mx1.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx2_cam.h => include/linux/platform_data/camera-mx2.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx3_camera.h => include/linux/platform_data/camera-mx3.h (100%)
 rename arch/arm/mach-pxa/include/mach/camera.h => include/linux/platform_data/camera-pxa.h (100%)
 rename {arch/arm/mach-ux500/include/mach => include/linux/platform_data}/crypto-ux500.h (100%)
 rename arch/arm/mach-at91/include/mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/dma.h => include/linux/platform_data/dma-ep93xx.h (100%)
 rename arch/arm/plat-mxc/include/mach/sdma.h => include/linux/platform_data/dma-imx-sdma.h (100%)
 rename arch/arm/plat-mxc/include/mach/dma.h => include/linux/platform_data/dma-imx.h (100%)
 rename arch/arm/mach-mmp/include/mach/sram.h => include/linux/platform_data/dma-mmp_tdma.h (100%)
 rename arch/arm/plat-orion/include/plat/mv_xor.h => include/linux/platform_data/dma-mv_xor.h (100%)
 rename arch/arm/plat-omap/include/plat/mcbsp.h => include/linux/platform_data/dsp-mcbsp.h (100%)
 rename arch/arm/plat-omap/include/plat/dsp.h => include/linux/platform_data/dsp-omap.h (100%)
 rename arch/arm/mach-netx/include/mach/eth.h => include/linux/platform_data/eth-netx.h (100%)
 rename arch/arm/plat-samsung/include/plat/hwmon.h => include/linux/platform_data/hwmon-s3c.h (100%)
 rename arch/arm/mach-davinci/include/mach/i2c.h => include/linux/platform_data/i2c-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/i2c.h => include/linux/platform_data/i2c-imx.h (100%)
 rename arch/arm/mach-w90x900/include/mach/i2c.h => include/linux/platform_data/i2c-nuc900.h (100%)
 rename arch/arm/plat-samsung/include/plat/iic.h => include/linux/platform_data/i2c-s3c2410.h (100%)
 rename arch/arm/mach-pxa/include/mach/irda.h => include/linux/platform_data/irda-pxaficp.h (100%)
 rename arch/arm/mach-pxa/include/mach/pxa930_rotary.h => include/linux/platform_data/keyboard-pxa930_rotary.h (100%)
 rename arch/arm/plat-spear/include/plat/keyboard.h => include/linux/platform_data/keyboard-spear.h (100%)
 rename arch/arm/mach-tegra/include/mach/kbc.h => include/linux/platform_data/keyboard-tegra-kbc.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h => include/linux/platform_data/keypad-ep93xx.h (100%)
 rename arch/arm/plat-nomadik/include/plat/ske.h => include/linux/platform_data/keypad-nomadik-ske.h (100%)
 rename arch/arm/plat-omap/include/plat/keypad.h => include/linux/platform_data/keypad-omap.h (100%)
 rename arch/arm/plat-pxa/include/plat/pxa27x_keypad.h => include/linux/platform_data/keypad-pxa27x.h (100%)
 rename arch/arm/mach-w90x900/include/mach/w90p910_keypad.h => include/linux/platform_data/keypad-w90p910.h (100%)
 rename arch/arm/mach-davinci/include/mach/keyscan.h => include/linux/platform_data/keyscan-davinci.h (100%)
 rename arch/arm/plat-omap/include/plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h (100%)
 rename arch/arm/mach-kirkwood/include/mach/leds-netxbig.h => include/linux/platform_data/leds-kirkwood-netxbig.h (100%)
 rename arch/arm/mach-kirkwood/include/mach/leds-ns2.h => include/linux/platform_data/leds-kirkwood-ns2.h (100%)
 rename arch/arm/mach-s3c24xx/include/mach/leds-gpio.h => include/linux/platform_data/leds-s3c24xx.h (100%)
 rename arch/arm/mach-sa1100/include/mach/mcp.h => include/linux/platform_data/mfd-mcp-sa11x0.h (100%)
 rename arch/arm/plat-samsung/include/plat/mipi_csis.h => include/linux/platform_data/mipi-csis.h (100%)
 rename arch/arm/mach-davinci/include/mach/mmc.h => include/linux/platform_data/mmc-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/esdhc.h => include/linux/platform_data/mmc-esdhc-imx.h (100%)
 rename arch/arm/mach-msm/include/mach/mmc.h => include/linux/platform_data/mmc-msm_sdcc.h (100%)
 rename arch/arm/plat-orion/include/plat/mvsdio.h => include/linux/platform_data/mmc-mvsdio.h (100%)
 rename arch/arm/plat-mxc/include/mach/mmc.h => include/linux/platform_data/mmc-mxcmmc.h (100%)
 rename arch/arm/mach-pxa/include/mach/mmc.h => include/linux/platform_data/mmc-pxamci.h (100%)
 rename arch/arm/plat-samsung/include/plat/mci.h => include/linux/platform_data/mmc-s3cmci.h (100%)
 rename arch/arm/mach-tegra/include/mach/sdhci.h => include/linux/platform_data/mmc-sdhci-tegra.h (100%)
 rename arch/arm/mach-pxa/include/mach/pxa930_trkball.h => include/linux/platform_data/mouse-pxa930_trkball.h (100%)
 rename arch/arm/mach-davinci/include/mach/aemif.h => include/linux/platform_data/mtd-davinci-aemif.h (100%)
 rename arch/arm/mach-davinci/include/mach/nand.h => include/linux/platform_data/mtd-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/mxc_nand.h => include/linux/platform_data/mtd-mxc_nand.h (100%)
 rename arch/arm/plat-omap/include/plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h (100%)
 rename arch/arm/plat-pxa/include/plat/pxa3xx_nand.h => include/linux/platform_data/mtd-nand-pxa3xx.h (100%)
 rename arch/arm/plat-samsung/include/plat/nand.h => include/linux/platform_data/mtd-nand-s3c2410.h (100%)
 rename arch/arm/mach-nomadik/include/mach/nand.h => include/linux/platform_data/mtd-nomadik-nand.h (100%)
 rename arch/arm/plat-omap/include/plat/onenand.h => include/linux/platform_data/mtd-onenand-omap2.h (100%)
 rename arch/arm/plat-orion/include/plat/orion_nand.h => include/linux/platform_data/mtd-orion_nand.h (100%)
 rename arch/arm/mach-pxa/include/mach/arcom-pcmcia.h => include/linux/platform_data/pcmcia-pxa2xx_viper.h (100%)
 rename arch/arm/mach-u300/include/mach/gpio-u300.h => include/linux/platform_data/pinctrl-coh901.h (100%)
 rename arch/arm/plat-omap/include/plat/remoteproc.h => include/linux/platform_data/remoteproc-omap.h (100%)
 rename arch/arm/plat-mxc/include/mach/imx-uart.h => include/linux/platform_data/serial-imx.h (100%)
 rename arch/arm/plat-omap/include/plat/voltage.h => include/linux/platform_data/smartreflex-omap.h (100%)
 rename arch/arm/mach-davinci/include/mach/spi.h => include/linux/platform_data/spi-davinci.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h => include/linux/platform_data/spi-ep93xx.h (100%)
 rename arch/arm/mach-w90x900/include/mach/nuc900_spi.h => include/linux/platform_data/spi-nuc900.h (100%)
 rename arch/arm/plat-omap/include/plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h (100%)
 rename arch/arm/plat-samsung/include/plat/s3c64xx-spi.h => include/linux/platform_data/spi-s3c64xx.h (100%)
 rename arch/arm/plat-samsung/include/plat/ts.h => include/linux/platform_data/touchscreen-s3c2410.h (100%)
 rename arch/arm/mach-davinci/include/mach/usb.h => include/linux/platform_data/usb-davinci.h (100%)
 rename arch/arm/plat-mxc/include/mach/mxc_ehci.h => include/linux/platform_data/usb-ehci-mxc.h (100%)
 rename arch/arm/plat-orion/include/plat/ehci-orion.h => include/linux/platform_data/usb-ehci-orion.h (100%)
 rename arch/arm/plat-samsung/include/plat/ehci.h => include/linux/platform_data/usb-ehci-s5p.h (100%)
 rename arch/arm/mach-exynos/include/mach/ohci.h => include/linux/platform_data/usb-exynos.h (100%)
 rename arch/arm/plat-mxc/include/mach/usb.h => include/linux/platform_data/usb-imx_udc.h (100%)
 rename arch/arm/mach-ux500/include/mach/usb.h => include/linux/platform_data/usb-musb-ux500.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx21-usbhost.h => include/linux/platform_data/usb-mx2.h (100%)
 rename arch/arm/mach-pxa/include/mach/ohci.h => include/linux/platform_data/usb-ohci-pxa27x.h (100%)
 rename arch/arm/plat-samsung/include/plat/usb-control.h => include/linux/platform_data/usb-ohci-s3c2410.h (100%)
 rename arch/arm/mach-pxa/include/mach/pxa3xx-u2d.h => include/linux/platform_data/usb-pxa3xx-ulpi.h (100%)
 rename arch/arm/plat-samsung/include/plat/udc.h => include/linux/platform_data/usb-s3c2410_udc.h (100%)
 rename arch/arm/mach-ep93xx/include/mach/fb.h => include/linux/platform_data/video-ep93xx.h (100%)
 rename arch/arm/plat-mxc/include/mach/imxfb.h => include/linux/platform_data/video-imxfb.h (100%)
 rename arch/arm/mach-msm/include/mach/msm_fb.h => include/linux/platform_data/video-msm_fb.h (100%)
 rename arch/arm/plat-mxc/include/mach/mx3fb.h => include/linux/platform_data/video-mx3fb.h (100%)
 rename arch/arm/mach-w90x900/include/mach/fb.h => include/linux/platform_data/video-nuc900fb.h (100%)
 rename arch/arm/mach-pxa/include/mach/pxafb.h => include/linux/platform_data/video-pxafb.h (100%)
 rename arch/arm/mach-vt8500/include/mach/vt8500fb.h => include/linux/platform_data/video-vt8500lcdfb.h (100%)
