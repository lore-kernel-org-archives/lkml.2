Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2KIU4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:56:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43815 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2KIU4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:56:07 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 11/11] ARM: delete struct sys_timer
Date: Fri,  9 Nov 2012 13:55:56 -0700
Message-Id: <1352494556-7244-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
References: <1352408516-21988-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Now that the only field in struct sys_timer is .init, delete the struct,
and replace the machine descriptor .timer field with the initialization
function itself.

This will enable moving timer drivers into drivers/clocksource without
having to place a public prototype of each struct sys_timer object into
include/linux; the intent is to create a single of_clocksource_init()
function that determines which timer driver to initialize by scanning
the device dtree, much like the proposed irqchip_init() at:
http://www.spinics.net/lists/arm-kernel/msg203686.html

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Converted all platforms, not just Tegra.

This is based on next-20121107, so would need to be rebased to actually
apply. Arnd, Olof, what do you think the best plan for merging this into
arm-soc would be?

The patch is very large, so I've trimmed it for the mailing list, leaving
only the core ARM changes, changes outside arch/arm, and a couple platforms
which had slightly less routine changes. The full series can be found at:

git://nv-tegra.nvidia.com/user/swarren/linux-2.6 arm_timer_rework

It'd be great if maintainers could test this on their boards to make sure
I didn't make any silly mistakes, although there are far too many to Cc.

---
 arch/arm/include/asm/mach/arch.h               |    3 +--
 arch/arm/include/asm/mach/time.h               |   16 ----------------
 arch/arm/kernel/time.c                         |    9 +--------
 arch/arm/mach-at91/at91rm9200_time.c           |    5 -----
 arch/arm/mach-at91/at91sam926x_time.c          |    6 +-----
 arch/arm/mach-at91/at91x40_time.c              |    5 -----
 arch/arm/mach-at91/board-1arm.c                |    2 +-
 arch/arm/mach-at91/board-afeb-9260v1.c         |    2 +-
 arch/arm/mach-at91/board-cam60.c               |    2 +-
 arch/arm/mach-at91/board-carmeva.c             |    2 +-
 arch/arm/mach-at91/board-cpu9krea.c            |    2 +-
 arch/arm/mach-at91/board-cpuat91.c             |    2 +-
 arch/arm/mach-at91/board-csb337.c              |    2 +-
 arch/arm/mach-at91/board-csb637.c              |    2 +-
 arch/arm/mach-at91/board-dt.c                  |    2 +-
 arch/arm/mach-at91/board-eb01.c                |    2 +-
 arch/arm/mach-at91/board-eb9200.c              |    2 +-
 arch/arm/mach-at91/board-ecbat91.c             |    2 +-
 arch/arm/mach-at91/board-eco920.c              |    2 +-
 arch/arm/mach-at91/board-flexibity.c           |    2 +-
 arch/arm/mach-at91/board-foxg20.c              |    2 +-
 arch/arm/mach-at91/board-gsia18s.c             |    2 +-
 arch/arm/mach-at91/board-kafa.c                |    2 +-
 arch/arm/mach-at91/board-kb9202.c              |    2 +-
 arch/arm/mach-at91/board-neocore926.c          |    2 +-
 arch/arm/mach-at91/board-pcontrol-g20.c        |    2 +-
 arch/arm/mach-at91/board-picotux200.c          |    2 +-
 arch/arm/mach-at91/board-qil-a9260.c           |    2 +-
 arch/arm/mach-at91/board-rm9200dk.c            |    2 +-
 arch/arm/mach-at91/board-rm9200ek.c            |    2 +-
 arch/arm/mach-at91/board-rsi-ews.c             |    2 +-
 arch/arm/mach-at91/board-sam9-l9260.c          |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c           |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c           |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c           |    2 +-
 arch/arm/mach-at91/board-sam9g20ek.c           |    4 ++--
 arch/arm/mach-at91/board-sam9m10g45ek.c        |    2 +-
 arch/arm/mach-at91/board-sam9rlek.c            |    2 +-
 arch/arm/mach-at91/board-snapper9260.c         |    2 +-
 arch/arm/mach-at91/board-stamp9g20.c           |    4 ++--
 arch/arm/mach-at91/board-usb-a926x.c           |    6 +++---
 arch/arm/mach-at91/board-yl-9200.c             |    2 +-
 arch/arm/mach-at91/generic.h                   |    7 +++----
 arch/arm/mach-bcm2835/bcm2835.c                |    2 +-
 arch/arm/mach-clps711x/autcpu12.c              |    2 +-
 arch/arm/mach-clps711x/cdb89712.c              |    2 +-
 arch/arm/mach-clps711x/clep7312.c              |    2 +-
 arch/arm/mach-clps711x/common.c                |    6 +-----
 arch/arm/mach-clps711x/common.h                |    4 +---
 arch/arm/mach-clps711x/edb7211.c               |    2 +-
 arch/arm/mach-clps711x/fortunet.c              |    2 +-
 arch/arm/mach-clps711x/p720t.c                 |    2 +-
 arch/arm/mach-cns3xxx/cns3420vb.c              |    2 +-
 arch/arm/mach-cns3xxx/core.c                   |    6 +-----
 arch/arm/mach-cns3xxx/core.h                   |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c        |    2 +-
 arch/arm/mach-davinci/board-da850-evm.c        |    2 +-
 arch/arm/mach-davinci/board-dm355-evm.c        |    2 +-
 arch/arm/mach-davinci/board-dm355-leopard.c    |    2 +-
 arch/arm/mach-davinci/board-dm365-evm.c        |    2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c       |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c       |    4 ++--
 arch/arm/mach-davinci/board-mityomapl138.c     |    2 +-
 arch/arm/mach-davinci/board-neuros-osd2.c      |    2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c    |    2 +-
 arch/arm/mach-davinci/board-sffsdr.c           |    2 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c    |    2 +-
 arch/arm/mach-davinci/include/mach/common.h    |    4 +---
 arch/arm/mach-davinci/time.c                   |    7 +------
 arch/arm/mach-dove/cm-a510.c                   |    2 +-
 arch/arm/mach-dove/common.c                    |    8 ++------
 arch/arm/mach-dove/common.h                    |    2 +-
 arch/arm/mach-dove/dove-db-setup.c             |    2 +-
 arch/arm/mach-ebsa110/core.c                   |    8 ++------
 arch/arm/mach-ep93xx/adssphere.c               |    2 +-
 arch/arm/mach-ep93xx/core.c                    |    6 +-----
 arch/arm/mach-ep93xx/edb93xx.c                 |   16 ++++++++--------
 arch/arm/mach-ep93xx/gesbc9312.c               |    2 +-
 arch/arm/mach-ep93xx/include/mach/platform.h   |    2 +-
 arch/arm/mach-ep93xx/micro9.c                  |    8 ++++----
 arch/arm/mach-ep93xx/simone.c                  |    2 +-
 arch/arm/mach-ep93xx/snappercl15.c             |    2 +-
 arch/arm/mach-ep93xx/ts72xx.c                  |    2 +-
 arch/arm/mach-ep93xx/vision_ep9307.c           |    2 +-
 arch/arm/mach-exynos/common.h                  |    2 +-
 arch/arm/mach-exynos/mach-armlex4210.c         |    2 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c         |    2 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c         |    2 +-
 arch/arm/mach-exynos/mach-nuri.c               |    2 +-
 arch/arm/mach-exynos/mach-origen.c             |    2 +-
 arch/arm/mach-exynos/mach-smdk4x12.c           |    4 ++--
 arch/arm/mach-exynos/mach-smdkv310.c           |    4 ++--
 arch/arm/mach-exynos/mach-universal_c210.c     |    2 +-
 arch/arm/mach-exynos/mct.c                     |    6 +-----
 arch/arm/mach-footbridge/cats-hw.c             |    2 +-
 arch/arm/mach-footbridge/common.h              |    4 ++--
 arch/arm/mach-footbridge/dc21285-timer.c       |    6 +-----
 arch/arm/mach-footbridge/ebsa285.c             |    2 +-
 arch/arm/mach-footbridge/isa-timer.c           |    6 +-----
 arch/arm/mach-footbridge/netwinder-hw.c        |    2 +-
 arch/arm/mach-footbridge/personal.c            |    2 +-
 arch/arm/mach-gemini/board-nas4220b.c          |    6 +-----
 arch/arm/mach-gemini/board-rut1xx.c            |    6 +-----
 arch/arm/mach-gemini/board-wbd111.c            |    6 +-----
 arch/arm/mach-gemini/board-wbd222.c            |    6 +-----
 arch/arm/mach-h720x/common.h                   |    4 ++--
 arch/arm/mach-h720x/cpu-h7201.c                |    6 +-----
 arch/arm/mach-h720x/cpu-h7202.c                |    6 +-----
 arch/arm/mach-h720x/h7201-eval.c               |    2 +-
 arch/arm/mach-h720x/h7202-eval.c               |    2 +-
 arch/arm/mach-highbank/highbank.c              |    6 +-----
 arch/arm/mach-imx/imx27-dt.c                   |   16 ++++++----------
 arch/arm/mach-imx/imx31-dt.c                   |   11 +----------
 arch/arm/mach-imx/imx51-dt.c                   |   16 ++++++----------
 arch/arm/mach-imx/mach-apf9328.c               |    6 +-----
 arch/arm/mach-imx/mach-armadillo5x0.c          |    6 +-----
 arch/arm/mach-imx/mach-bug.c                   |    6 +-----
 arch/arm/mach-imx/mach-cpuimx27.c              |    6 +-----
 arch/arm/mach-imx/mach-cpuimx35.c              |    6 +-----
 arch/arm/mach-imx/mach-cpuimx51sd.c            |    6 +-----
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c       |    6 +-----
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c    |    6 +-----
 arch/arm/mach-imx/mach-imx27ipcam.c            |    6 +-----
 arch/arm/mach-imx/mach-imx27lite.c             |    6 +-----
 arch/arm/mach-imx/mach-imx53.c                 |   16 ++++++----------
 arch/arm/mach-imx/mach-imx6q.c                 |    6 +-----
 arch/arm/mach-imx/mach-kzm_arm11_01.c          |    6 +-----
 arch/arm/mach-imx/mach-mx1ads.c                |    8 ++------
 arch/arm/mach-imx/mach-mx21ads.c               |    6 +-----
 arch/arm/mach-imx/mach-mx25_3ds.c              |    6 +-----
 arch/arm/mach-imx/mach-mx27_3ds.c              |    6 +-----
 arch/arm/mach-imx/mach-mx27ads.c               |    6 +-----
 arch/arm/mach-imx/mach-mx31_3ds.c              |    6 +-----
 arch/arm/mach-imx/mach-mx31ads.c               |    6 +-----
 arch/arm/mach-imx/mach-mx31lilly.c             |    6 +-----
 arch/arm/mach-imx/mach-mx31lite.c              |    6 +-----
 arch/arm/mach-imx/mach-mx31moboard.c           |    6 +-----
 arch/arm/mach-imx/mach-mx35_3ds.c              |    6 +-----
 arch/arm/mach-imx/mach-mx50_rdp.c              |    6 +-----
 arch/arm/mach-imx/mach-mx51_3ds.c              |    6 +-----
 arch/arm/mach-imx/mach-mx51_babbage.c          |    6 +-----
 arch/arm/mach-imx/mach-mxt_td60.c              |    6 +-----
 arch/arm/mach-imx/mach-pca100.c                |    6 +-----
 arch/arm/mach-imx/mach-pcm037.c                |    6 +-----
 arch/arm/mach-imx/mach-pcm038.c                |    6 +-----
 arch/arm/mach-imx/mach-pcm043.c                |    6 +-----
 arch/arm/mach-imx/mach-qong.c                  |    6 +-----
 arch/arm/mach-imx/mach-scb9328.c               |    6 +-----
 arch/arm/mach-imx/mach-vpr200.c                |    6 +-----
 arch/arm/mach-integrator/integrator_ap.c       |   16 ++++------------
 arch/arm/mach-integrator/integrator_cp.c       |   16 ++++------------
 arch/arm/mach-iop13xx/iq81340mc.c              |    6 +-----
 arch/arm/mach-iop13xx/iq81340sc.c              |    6 +-----
 arch/arm/mach-iop32x/em7210.c                  |    6 +-----
 arch/arm/mach-iop32x/glantank.c                |    6 +-----
 arch/arm/mach-iop32x/iq31244.c                 |    8 ++------
 arch/arm/mach-iop32x/iq80321.c                 |    6 +-----
 arch/arm/mach-iop32x/n2100.c                   |    6 +-----
 arch/arm/mach-iop33x/iq80331.c                 |    6 +-----
 arch/arm/mach-iop33x/iq80332.c                 |    6 +-----
 arch/arm/mach-ixp4xx/avila-setup.c             |    4 ++--
 arch/arm/mach-ixp4xx/common.c                  |    4 ----
 arch/arm/mach-ixp4xx/coyote-setup.c            |    4 ++--
 arch/arm/mach-ixp4xx/dsmg600-setup.c           |    6 +-----
 arch/arm/mach-ixp4xx/fsg-setup.c               |    2 +-
 arch/arm/mach-ixp4xx/gateway7001-setup.c       |    2 +-
 arch/arm/mach-ixp4xx/goramo_mlr.c              |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-setup.c          |    2 +-
 arch/arm/mach-ixp4xx/include/mach/platform.h   |    3 ---
 arch/arm/mach-ixp4xx/ixdp425-setup.c           |    8 ++++----
 arch/arm/mach-ixp4xx/nas100d-setup.c           |    2 +-
 arch/arm/mach-ixp4xx/nslu2-setup.c             |    6 +-----
 arch/arm/mach-ixp4xx/omixp-setup.c             |    6 +++---
 arch/arm/mach-ixp4xx/vulcan-setup.c            |    2 +-
 arch/arm/mach-ixp4xx/wg302v2-setup.c           |    2 +-
 arch/arm/mach-kirkwood/board-dt.c              |    2 +-
 arch/arm/mach-kirkwood/common.c                |    6 +-----
 arch/arm/mach-kirkwood/common.h                |    2 +-
 arch/arm/mach-kirkwood/d2net_v2-setup.c        |    2 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c    |    2 +-
 arch/arm/mach-kirkwood/dockstar-setup.c        |    2 +-
 arch/arm/mach-kirkwood/guruplug-setup.c        |    2 +-
 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c |    2 +-
 arch/arm/mach-kirkwood/netspace_v2-setup.c     |    6 +++---
 arch/arm/mach-kirkwood/netxbig_v2-setup.c      |    4 ++--
 arch/arm/mach-kirkwood/openrd-setup.c          |    6 +++---
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c   |    2 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c       |    2 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c      |    4 ++--
 arch/arm/mach-kirkwood/t5325-setup.c           |    2 +-
 arch/arm/mach-kirkwood/ts219-setup.c           |    2 +-
 arch/arm/mach-kirkwood/ts41x-setup.c           |    2 +-
 arch/arm/mach-ks8695/board-acs5k.c             |    2 +-
 arch/arm/mach-ks8695/board-dsm320.c            |    2 +-
 arch/arm/mach-ks8695/board-micrel.c            |    2 +-
 arch/arm/mach-ks8695/board-og.c                |   10 +++++-----
 arch/arm/mach-ks8695/board-sg.c                |    6 +++---
 arch/arm/mach-ks8695/generic.h                 |    2 +-
 arch/arm/mach-ks8695/time.c                    |    6 +-----
 arch/arm/mach-lpc32xx/common.h                 |    2 +-
 arch/arm/mach-lpc32xx/phy3250.c                |    2 +-
 arch/arm/mach-lpc32xx/timer.c                  |    7 +------
 arch/arm/mach-mmp/aspenite.c                   |    4 ++--
 arch/arm/mach-mmp/avengers_lite.c              |    2 +-
 arch/arm/mach-mmp/brownstone.c                 |    2 +-
 arch/arm/mach-mmp/common.h                     |    2 --
 arch/arm/mach-mmp/flint.c                      |    2 +-
 arch/arm/mach-mmp/gplugd.c                     |    2 +-
 arch/arm/mach-mmp/include/mach/mmp2.h          |    4 +---
 arch/arm/mach-mmp/include/mach/pxa168.h        |    4 +---
 arch/arm/mach-mmp/include/mach/pxa910.h        |    4 +---
 arch/arm/mach-mmp/jasper.c                     |    2 +-
 arch/arm/mach-mmp/mmp-dt.c                     |    8 ++------
 arch/arm/mach-mmp/mmp2-dt.c                    |    6 +-----
 arch/arm/mach-mmp/mmp2.c                       |    6 +-----
 arch/arm/mach-mmp/pxa168.c                     |    6 +-----
 arch/arm/mach-mmp/pxa910.c                     |    6 +-----
 arch/arm/mach-mmp/tavorevb.c                   |    2 +-
 arch/arm/mach-mmp/teton_bga.c                  |    2 +-
 arch/arm/mach-mmp/ttc_dkb.c                    |    2 +-
 arch/arm/mach-msm/board-dt-8660.c              |    2 +-
 arch/arm/mach-msm/board-dt-8960.c              |    2 +-
 arch/arm/mach-msm/board-halibut.c              |    2 +-
 arch/arm/mach-msm/board-mahimahi.c             |    4 ++--
 arch/arm/mach-msm/board-msm7x30.c              |    6 +++---
 arch/arm/mach-msm/board-qsd8x50.c              |    4 ++--
 arch/arm/mach-msm/board-sapphire.c             |    4 ++--
 arch/arm/mach-msm/board-trout.c                |    2 +-
 arch/arm/mach-msm/common.h                     |    8 ++++----
 arch/arm/mach-msm/timer.c                      |   24 ++++--------------------
 arch/arm/mach-mv78xx0/buffalo-wxl-setup.c      |    2 +-
 arch/arm/mach-mv78xx0/common.c                 |    6 +-----
 arch/arm/mach-mv78xx0/common.h                 |    2 +-
 arch/arm/mach-mv78xx0/db78x00-bp-setup.c       |    2 +-
 arch/arm/mach-mv78xx0/rd78x00-masa-setup.c     |    2 +-
 arch/arm/mach-mvebu/armada-370-xp.c            |    6 +-----
 arch/arm/mach-mxs/mach-mxs.c                   |   12 ++----------
 arch/arm/mach-netx/generic.h                   |    3 +--
 arch/arm/mach-netx/nxdb500.c                   |    2 +-
 arch/arm/mach-netx/nxdkn.c                     |    2 +-
 arch/arm/mach-netx/nxeb500hmi.c                |    2 +-
 arch/arm/mach-netx/time.c                      |    6 +-----
 arch/arm/mach-nomadik/board-nhk8815.c          |    6 +-----
 arch/arm/mach-omap1/board-ams-delta.c          |    2 +-
 arch/arm/mach-omap1/board-fsample.c            |    2 +-
 arch/arm/mach-omap1/board-generic.c            |    2 +-
 arch/arm/mach-omap1/board-h2.c                 |    2 +-
 arch/arm/mach-omap1/board-h3.c                 |    2 +-
 arch/arm/mach-omap1/board-htcherald.c          |    2 +-
 arch/arm/mach-omap1/board-innovator.c          |    2 +-
 arch/arm/mach-omap1/board-nokia770.c           |    2 +-
 arch/arm/mach-omap1/board-osk.c                |    2 +-
 arch/arm/mach-omap1/board-palmte.c             |    2 +-
 arch/arm/mach-omap1/board-palmtt.c             |    2 +-
 arch/arm/mach-omap1/board-palmz71.c            |    2 +-
 arch/arm/mach-omap1/board-perseus2.c           |    2 +-
 arch/arm/mach-omap1/board-sx1.c                |    2 +-
 arch/arm/mach-omap1/board-voiceblue.c          |    2 +-
 arch/arm/mach-omap1/common.h                   |    2 +-
 arch/arm/mach-omap1/time.c                     |    6 +-----
 arch/arm/mach-omap2/board-2430sdp.c            |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c            |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c            |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c            |    2 +-
 arch/arm/mach-omap2/board-am3517crane.c        |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c          |    2 +-
 arch/arm/mach-omap2/board-apollon.c            |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c             |    4 ++--
 arch/arm/mach-omap2/board-cm-t3517.c           |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c         |    2 +-
 arch/arm/mach-omap2/board-generic.c            |   12 ++++++------
 arch/arm/mach-omap2/board-h4.c                 |    2 +-
 arch/arm/mach-omap2/board-igep0020.c           |    4 ++--
 arch/arm/mach-omap2/board-ldp.c                |    2 +-
 arch/arm/mach-omap2/board-n8x0.c               |    6 +++---
 arch/arm/mach-omap2/board-omap3beagle.c        |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c           |    2 +-
 arch/arm/mach-omap2/board-omap3logic.c         |    4 ++--
 arch/arm/mach-omap2/board-omap3pandora.c       |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c       |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c     |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c         |    2 +-
 arch/arm/mach-omap2/board-overo.c              |    2 +-
 arch/arm/mach-omap2/board-rm680.c              |    4 ++--
 arch/arm/mach-omap2/board-rx51.c               |    2 +-
 arch/arm/mach-omap2/board-ti8168evm.c          |    4 ++--
 arch/arm/mach-omap2/board-zoom.c               |    4 ++--
 arch/arm/mach-omap2/common.h                   |   12 ++++++------
 arch/arm/mach-omap2/timer.c                    |   17 +++--------------
 arch/arm/mach-orion5x/common.c                 |    6 +-----
 arch/arm/mach-orion5x/common.h                 |    2 +-
 arch/arm/mach-orion5x/d2net-setup.c            |    4 ++--
 arch/arm/mach-orion5x/db88f5281-setup.c        |    2 +-
 arch/arm/mach-orion5x/dns323-setup.c           |    2 +-
 arch/arm/mach-orion5x/edmini_v2-setup.c        |    2 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c      |    4 ++--
 arch/arm/mach-orion5x/ls-chl-setup.c           |    2 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c           |    2 +-
 arch/arm/mach-orion5x/lsmini-setup.c           |    2 +-
 arch/arm/mach-orion5x/mss2-setup.c             |    2 +-
 arch/arm/mach-orion5x/mv2120-setup.c           |    2 +-
 arch/arm/mach-orion5x/net2big-setup.c          |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c   |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c    |    2 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c        |    2 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c   |    2 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c |    2 +-
 arch/arm/mach-orion5x/ts209-setup.c            |    2 +-
 arch/arm/mach-orion5x/ts409-setup.c            |    2 +-
 arch/arm/mach-orion5x/ts78xx-setup.c           |    2 +-
 arch/arm/mach-orion5x/wnr854t-setup.c          |    2 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c       |    2 +-
 arch/arm/mach-picoxcell/common.c               |    2 +-
 arch/arm/mach-picoxcell/common.h               |    2 +-
 arch/arm/mach-prima2/common.c                  |    2 +-
 arch/arm/mach-prima2/common.h                  |    2 +-
 arch/arm/mach-prima2/timer.c                   |    8 ++------
 arch/arm/mach-pxa/balloon3.c                   |    2 +-
 arch/arm/mach-pxa/capc7117.c                   |    2 +-
 arch/arm/mach-pxa/cm-x2xx.c                    |    2 +-
 arch/arm/mach-pxa/cm-x300.c                    |    2 +-
 arch/arm/mach-pxa/colibri-pxa270.c             |    4 ++--
 arch/arm/mach-pxa/colibri-pxa300.c             |    2 +-
 arch/arm/mach-pxa/colibri-pxa320.c             |    2 +-
 arch/arm/mach-pxa/corgi.c                      |    6 +++---
 arch/arm/mach-pxa/csb726.c                     |    2 +-
 arch/arm/mach-pxa/em-x270.c                    |    4 ++--
 arch/arm/mach-pxa/eseries.c                    |   12 ++++++------
 arch/arm/mach-pxa/ezx.c                        |   12 ++++++------
 arch/arm/mach-pxa/generic.h                    |    3 +--
 arch/arm/mach-pxa/gumstix.c                    |    2 +-
 arch/arm/mach-pxa/h5000.c                      |    2 +-
 arch/arm/mach-pxa/himalaya.c                   |    2 +-
 arch/arm/mach-pxa/hx4700.c                     |    2 +-
 arch/arm/mach-pxa/icontrol.c                   |    2 +-
 arch/arm/mach-pxa/idp.c                        |    2 +-
 arch/arm/mach-pxa/littleton.c                  |    2 +-
 arch/arm/mach-pxa/lpd270.c                     |    2 +-
 arch/arm/mach-pxa/lubbock.c                    |    2 +-
 arch/arm/mach-pxa/magician.c                   |    2 +-
 arch/arm/mach-pxa/mainstone.c                  |    2 +-
 arch/arm/mach-pxa/mioa701.c                    |    2 +-
 arch/arm/mach-pxa/mp900.c                      |    2 +-
 arch/arm/mach-pxa/palmld.c                     |    2 +-
 arch/arm/mach-pxa/palmt5.c                     |    2 +-
 arch/arm/mach-pxa/palmtc.c                     |    2 +-
 arch/arm/mach-pxa/palmte2.c                    |    2 +-
 arch/arm/mach-pxa/palmtreo.c                   |    4 ++--
 arch/arm/mach-pxa/palmtx.c                     |    2 +-
 arch/arm/mach-pxa/palmz72.c                    |    2 +-
 arch/arm/mach-pxa/pcm027.c                     |    2 +-
 arch/arm/mach-pxa/poodle.c                     |    2 +-
 arch/arm/mach-pxa/pxa-dt.c                     |    2 +-
 arch/arm/mach-pxa/raumfeld.c                   |    6 +++---
 arch/arm/mach-pxa/saar.c                       |    2 +-
 arch/arm/mach-pxa/saarb.c                      |    2 +-
 arch/arm/mach-pxa/spitz.c                      |    6 +++---
 arch/arm/mach-pxa/stargate2.c                  |    4 ++--
 arch/arm/mach-pxa/tavorevb.c                   |    2 +-
 arch/arm/mach-pxa/tavorevb3.c                  |    2 +-
 arch/arm/mach-pxa/time.c                       |    6 +-----
 arch/arm/mach-pxa/tosa.c                       |    2 +-
 arch/arm/mach-pxa/trizeps4.c                   |    4 ++--
 arch/arm/mach-pxa/viper.c                      |    2 +-
 arch/arm/mach-pxa/vpac270.c                    |    2 +-
 arch/arm/mach-pxa/xcep.c                       |    2 +-
 arch/arm/mach-pxa/z2.c                         |    2 +-
 arch/arm/mach-pxa/zeus.c                       |    2 +-
 arch/arm/mach-pxa/zylonite.c                   |    2 +-
 arch/arm/mach-realview/realview_eb.c           |    6 +-----
 arch/arm/mach-realview/realview_pb1176.c       |    6 +-----
 arch/arm/mach-realview/realview_pb11mp.c       |    6 +-----
 arch/arm/mach-realview/realview_pba8.c         |    6 +-----
 arch/arm/mach-realview/realview_pbx.c          |    6 +-----
 arch/arm/mach-rpc/riscpc.c                     |    4 ++--
 arch/arm/mach-rpc/time.c                       |    7 +------
 arch/arm/mach-s3c24xx/mach-amlm5900.c          |    2 +-
 arch/arm/mach-s3c24xx/mach-anubis.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c         |    2 +-
 arch/arm/mach-s3c24xx/mach-bast.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-gta02.c             |    2 +-
 arch/arm/mach-s3c24xx/mach-h1940.c             |    2 +-
 arch/arm/mach-s3c24xx/mach-jive.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c          |    2 +-
 arch/arm/mach-s3c24xx/mach-n30.c               |    4 ++--
 arch/arm/mach-s3c24xx/mach-nexcoder.c          |    2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-otom.c              |    2 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c          |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c          |    6 +++---
 arch/arm/mach-s3c24xx/mach-smdk2416.c          |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c          |    2 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c          |    2 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c        |    2 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-vstms.c             |    2 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c           |    2 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c          |    2 +-
 arch/arm/mach-s3c64xx/mach-hmt.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c          |    2 +-
 arch/arm/mach-s3c64xx/mach-ncp.c               |    2 +-
 arch/arm/mach-s3c64xx/mach-real6410.c          |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq5.c           |    2 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c           |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c          |    2 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c          |    2 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c          |    2 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c          |    2 +-
 arch/arm/mach-s5pc100/mach-smdkc100.c          |    2 +-
 arch/arm/mach-s5pv210/mach-aquila.c            |    2 +-
 arch/arm/mach-s5pv210/mach-goni.c              |    2 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c          |    2 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c          |    2 +-
 arch/arm/mach-s5pv210/mach-torbreck.c          |    2 +-
 arch/arm/mach-sa1100/assabet.c                 |    2 +-
 arch/arm/mach-sa1100/badge4.c                  |    2 +-
 arch/arm/mach-sa1100/cerf.c                    |    2 +-
 arch/arm/mach-sa1100/collie.c                  |    2 +-
 arch/arm/mach-sa1100/generic.h                 |    4 +---
 arch/arm/mach-sa1100/h3100.c                   |    2 +-
 arch/arm/mach-sa1100/h3600.c                   |    2 +-
 arch/arm/mach-sa1100/hackkit.c                 |    2 +-
 arch/arm/mach-sa1100/jornada720.c              |    2 +-
 arch/arm/mach-sa1100/lart.c                    |    2 +-
 arch/arm/mach-sa1100/nanoengine.c              |    2 +-
 arch/arm/mach-sa1100/pleb.c                    |    2 +-
 arch/arm/mach-sa1100/shannon.c                 |    2 +-
 arch/arm/mach-sa1100/simpad.c                  |    2 +-
 arch/arm/mach-sa1100/time.c                    |    6 +-----
 arch/arm/mach-shark/core.c                     |    6 +-----
 arch/arm/mach-shmobile/board-ag5evm.c          |    2 +-
 arch/arm/mach-shmobile/board-ap4evb.c          |    2 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c |    5 +----
 arch/arm/mach-shmobile/board-bonito.c          |    5 +----
 arch/arm/mach-shmobile/board-kota2.c           |    2 +-
 arch/arm/mach-shmobile/board-kzm9d.c           |    2 +-
 arch/arm/mach-shmobile/board-kzm9g.c           |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c        |    2 +-
 arch/arm/mach-shmobile/board-marzen.c          |    2 +-
 arch/arm/mach-shmobile/include/mach/common.h   |    5 ++++-
 arch/arm/mach-shmobile/setup-emev2.c           |    2 +-
 arch/arm/mach-shmobile/setup-r8a7740.c         |   11 +----------
 arch/arm/mach-shmobile/setup-r8a7779.c         |    5 +----
 arch/arm/mach-shmobile/setup-sh7372.c          |    7 ++-----
 arch/arm/mach-shmobile/setup-sh73a0.c          |    5 +----
 arch/arm/mach-shmobile/timer.c                 |    6 +-----
 arch/arm/mach-socfpga/socfpga.c                |    2 +-
 arch/arm/mach-spear13xx/include/mach/generic.h |    2 +-
 arch/arm/mach-spear13xx/spear1310.c            |    2 +-
 arch/arm/mach-spear13xx/spear1340.c            |    2 +-
 arch/arm/mach-spear13xx/spear13xx.c            |    6 +-----
 arch/arm/mach-spear3xx/include/mach/generic.h  |    2 +-
 arch/arm/mach-spear3xx/spear300.c              |    2 +-
 arch/arm/mach-spear3xx/spear310.c              |    2 +-
 arch/arm/mach-spear3xx/spear320.c              |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c              |    6 +-----
 arch/arm/mach-spear6xx/spear6xx.c              |    8 ++------
 arch/arm/mach-tegra/board-dt-tegra20.c         |    2 +-
 arch/arm/mach-tegra/board-dt-tegra30.c         |    2 +-
 arch/arm/mach-tegra/board.h                    |    2 +-
 arch/arm/mach-tegra/timer.c                    |    6 +-----
 arch/arm/mach-u300/core.c                      |    2 +-
 arch/arm/mach-u300/timer.c                     |   10 +---------
 arch/arm/mach-u300/timer.h                     |    2 +-
 arch/arm/mach-ux500/board-mop500.c             |    8 ++++----
 arch/arm/mach-ux500/cpu-db8500.c               |    2 +-
 arch/arm/mach-ux500/include/mach/setup.h       |    3 +--
 arch/arm/mach-ux500/timer.c                    |    6 +-----
 arch/arm/mach-versatile/core.c                 |    7 +------
 arch/arm/mach-versatile/core.h                 |    2 +-
 arch/arm/mach-versatile/versatile_ab.c         |    2 +-
 arch/arm/mach-versatile/versatile_dt.c         |    2 +-
 arch/arm/mach-versatile/versatile_pb.c         |    2 +-
 arch/arm/mach-vexpress/v2m.c                   |   12 ++----------
 arch/arm/mach-vt8500/vt8500.c                  |    6 +-----
 arch/arm/mach-w90x900/mach-nuc910evb.c         |    2 +-
 arch/arm/mach-w90x900/mach-nuc950evb.c         |    2 +-
 arch/arm/mach-w90x900/mach-nuc960evb.c         |    2 +-
 arch/arm/mach-w90x900/nuc9xx.h                 |    3 +--
 arch/arm/mach-w90x900/time.c                   |    6 +-----
 arch/arm/mach-zynq/common.c                    |    2 +-
 arch/arm/mach-zynq/common.h                    |    2 +-
 arch/arm/mach-zynq/timer.c                     |    9 +--------
 arch/arm/plat-samsung/include/plat/cpu.h       |    3 +--
 arch/arm/plat-samsung/include/plat/s5p-time.h  |    2 +-
 arch/arm/plat-samsung/s5p-time.c               |    6 +-----
 arch/arm/plat-samsung/time.c                   |    6 +-----
 drivers/clocksource/bcm2835_timer.c            |    6 +-----
 drivers/clocksource/dw_apb_timer_of.c          |    6 +-----
 include/linux/bcm2835_timer.h                  |    2 +-
 include/linux/dw_apb_timer.h                   |    2 +-
 494 files changed, 624 insertions(+), 1201 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 917d4fc..308ad7d 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -12,7 +12,6 @@
 
 struct tag;
 struct meminfo;
-struct sys_timer;
 struct pt_regs;
 struct smp_operations;
 #ifdef CONFIG_SMP
@@ -48,7 +47,7 @@ struct machine_desc {
 	void			(*map_io)(void);/* IO mapping function	*/
 	void			(*init_early)(void);
 	void			(*init_irq)(void);
-	struct sys_timer	*timer;		/* system tick timer	*/
+	void			(*init_time)(void);
 	void			(*init_machine)(void);
 	void			(*init_late)(void);
 #ifdef CONFIG_MULTI_IRQ_HANDLER
diff --git a/arch/arm/include/asm/mach/time.h b/arch/arm/include/asm/mach/time.h
index d316d76..90c12e1 100644
--- a/arch/arm/include/asm/mach/time.h
+++ b/arch/arm/include/asm/mach/time.h
@@ -10,22 +10,6 @@
 #ifndef __ASM_ARM_MACH_TIME_H
 #define __ASM_ARM_MACH_TIME_H
 
-/*
- * This is our kernel timer structure.
- *
- * - init
- *   Initialise the kernels jiffy timer source, claim interrupt
- *   using setup_irq.  This is called early on during initialisation
- *   while interrupts are still disabled on the local CPU.
- * - offset
- *   Return the timer offset in microseconds since the last timer
- *   interrupt.  Note: this must take account of any unprocessed
- *   timer interrupt which may be pending.
- */
-struct sys_timer {
-	void			(*init)(void);
-};
-
 extern void timer_tick(void);
 
 struct timespec;
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 0b51a7c..955d92d 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -30,11 +30,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
 
-/*
- * Our system timer.
- */
-static struct sys_timer *system_timer;
-
 #if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE) || \
     defined(CONFIG_NVRAM) || defined(CONFIG_NVRAM_MODULE)
 /* this needs a better home */
@@ -120,8 +115,6 @@ int __init register_persistent_clock(clock_access_fn read_boot,
 
 void __init time_init(void)
 {
-	system_timer = machine_desc->timer;
-	system_timer->init();
+	machine_desc->init_time();
 	sched_clock_postinit();
 }
-
diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index a8fce3c..3d2aa6f 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -628,6 +628,6 @@ MACHINE_START(AMS_DELTA, "Amstrad E3 (Delta)")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= ams_delta_init,
 	.init_late	= ams_delta_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-fsample.c b/arch/arm/mach-omap1/board-fsample.c
index 8b5800a..7a0f1f9 100644
--- a/arch/arm/mach-omap1/board-fsample.c
+++ b/arch/arm/mach-omap1/board-fsample.c
@@ -365,6 +365,6 @@ MACHINE_START(OMAP_FSAMPLE, "OMAP730 F-Sample")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_fsample_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-generic.c b/arch/arm/mach-omap1/board-generic.c
index 608e7d2..e1d9171 100644
--- a/arch/arm/mach-omap1/board-generic.c
+++ b/arch/arm/mach-omap1/board-generic.c
@@ -84,6 +84,6 @@ MACHINE_START(OMAP_GENERIC, "Generic OMAP1510/1610/1710")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 9134b64..a7ed0ff 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -462,6 +462,6 @@ MACHINE_START(OMAP_H2, "TI-H2")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= h2_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index bf213d1..ed08d75 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -455,6 +455,6 @@ MACHINE_START(OMAP_H3, "TI OMAP1710 H3 board")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= h3_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-htcherald.c b/arch/arm/mach-omap1/board-htcherald.c
index 356f816..35a2379 100644
--- a/arch/arm/mach-omap1/board-htcherald.c
+++ b/arch/arm/mach-omap1/board-htcherald.c
@@ -603,6 +603,6 @@ MACHINE_START(HERALD, "HTC Herald")
 	.init_irq       = omap1_init_irq,
 	.init_machine   = htcherald_init,
 	.init_late	= omap1_init_late,
-	.timer          = &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-innovator.c b/arch/arm/mach-omap1/board-innovator.c
index c66334f..04513f5 100644
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -459,6 +459,6 @@ MACHINE_START(OMAP_INNOVATOR, "TI-Innovator")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= innovator_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-nokia770.c b/arch/arm/mach-omap1/board-nokia770.c
index 3e8ead6..d9fdb8a 100644
--- a/arch/arm/mach-omap1/board-nokia770.c
+++ b/arch/arm/mach-omap1/board-nokia770.c
@@ -254,6 +254,6 @@ MACHINE_START(NOKIA770, "Nokia 770")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_nokia770_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-osk.c b/arch/arm/mach-omap1/board-osk.c
index 872ea47..a7ce692 100644
--- a/arch/arm/mach-omap1/board-osk.c
+++ b/arch/arm/mach-omap1/board-osk.c
@@ -609,6 +609,6 @@ MACHINE_START(OMAP_OSK, "TI-OSK")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= osk_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index 584b6fa..9337ffc 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -268,6 +268,6 @@ MACHINE_START(OMAP_PALMTE, "OMAP310 based Palm Tungsten E")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_palmte_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-palmtt.c b/arch/arm/mach-omap1/board-palmtt.c
index fbc986b..a9a88f9 100644
--- a/arch/arm/mach-omap1/board-palmtt.c
+++ b/arch/arm/mach-omap1/board-palmtt.c
@@ -314,6 +314,6 @@ MACHINE_START(OMAP_PALMTT, "OMAP1510 based Palm Tungsten|T")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_palmtt_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 60d917a..e51b12c 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -330,6 +330,6 @@ MACHINE_START(OMAP_PALMZ71, "OMAP310 based Palm Zire71")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_palmz71_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-perseus2.c b/arch/arm/mach-omap1/board-perseus2.c
index 030bd48..f354f48 100644
--- a/arch/arm/mach-omap1/board-perseus2.c
+++ b/arch/arm/mach-omap1/board-perseus2.c
@@ -327,6 +327,6 @@ MACHINE_START(OMAP_PERSEUS2, "OMAP730 Perseus2")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_perseus2_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
index 1ebc7e0..d6c0c07 100644
--- a/arch/arm/mach-omap1/board-sx1.c
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -407,6 +407,6 @@ MACHINE_START(SX1, "OMAP310 based Siemens SX1")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= omap_sx1_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= omap1_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/board-voiceblue.c b/arch/arm/mach-omap1/board-voiceblue.c
index abf705f..6c116e1 100644
--- a/arch/arm/mach-omap1/board-voiceblue.c
+++ b/arch/arm/mach-omap1/board-voiceblue.c
@@ -289,6 +289,6 @@ MACHINE_START(VOICEBLUE, "VoiceBlue OMAP5910")
 	.init_irq	= omap1_init_irq,
 	.init_machine	= voiceblue_init,
 	.init_late	= omap1_init_late,
-	.timer		= &omap1_timer,
+	.init_time	= omap1_timer_init,
 	.restart	= voiceblue_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap1/common.h b/arch/arm/mach-omap1/common.h
index d6ac18d..933016b 100644
--- a/arch/arm/mach-omap1/common.h
+++ b/arch/arm/mach-omap1/common.h
@@ -76,7 +76,7 @@ extern void __init omap_check_revision(void);
 extern void omap1_nand_cmd_ctl(struct mtd_info *mtd, int cmd,
 			       unsigned int ctrl);
 
-extern struct sys_timer omap1_timer;
+extern void omap1_timer_init(void);
 #ifdef CONFIG_OMAP_32K_TIMER
 extern int omap_32k_timer_init(void);
 #else
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 4d4816f..1d4512f 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -236,12 +236,8 @@ static inline void omap_mpu_timer_init(void)
  * Timer initialization
  * ---------------------------------------------------------------------------
  */
-static void __init omap1_timer_init(void)
+void __init omap1_timer_init(void)
 {
 	if (omap_32k_timer_init() != 0)
 		omap_mpu_timer_init();
 }
-
-struct sys_timer omap1_timer = {
-	.init		= omap1_timer_init,
-};
diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index 3fc6d83..717c5b0 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -285,6 +285,6 @@ MACHINE_START(OMAP_2430SDP, "OMAP2430 sdp2430 board")
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= omap_2430sdp_init,
 	.init_late	= omap2430_init_late,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index 79fd904..d11c1d8 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -596,6 +596,6 @@ MACHINE_START(OMAP_3430SDP, "OMAP3430 3430SDP board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_3430sdp_init,
 	.init_late	= omap3430_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-3630sdp.c b/arch/arm/mach-omap2/board-3630sdp.c
index 81871b1..d819935 100644
--- a/arch/arm/mach-omap2/board-3630sdp.c
+++ b/arch/arm/mach-omap2/board-3630sdp.c
@@ -211,6 +211,6 @@ MACHINE_START(OMAP_3630SDP, "OMAP 3630SDP board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_sdp_init,
 	.init_late	= omap3630_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index fd80d97..45086a4 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -880,6 +880,6 @@ MACHINE_START(OMAP_4430SDP, "OMAP4430 4430SDP board")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap_4430sdp_init,
 	.init_late	= omap4430_init_late,
-	.timer		= &omap4_timer,
+	.init_time	= omap4_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 603503c..95012fd 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -92,6 +92,6 @@ MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= am3517_crane_init,
 	.init_late	= am35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
index 96d6c5a..4994f9f 100644
--- a/arch/arm/mach-omap2/board-am3517evm.c
+++ b/arch/arm/mach-omap2/board-am3517evm.c
@@ -392,6 +392,6 @@ MACHINE_START(OMAP3517EVM, "OMAP3517/AM3517 EVM")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= am3517_evm_init,
 	.init_late	= am35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index 64cf1bd..ee7b610 100644
--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -337,6 +337,6 @@ MACHINE_START(OMAP_APOLLON, "OMAP24xx Apollon")
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= omap_apollon_init,
 	.init_late	= omap2420_init_late,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index cf9449b..5fbd927 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -752,7 +752,7 @@ MACHINE_START(CM_T35, "Compulab CM-T35")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= cm_t35_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
 
@@ -765,6 +765,6 @@ MACHINE_START(CM_T3730, "Compulab CM-T3730")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine   = cm_t3730_init,
 	.init_late     = omap3630_init_late,
-	.timer          = &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-cm-t3517.c b/arch/arm/mach-omap2/board-cm-t3517.c
index 2786647..b3baf67 100644
--- a/arch/arm/mach-omap2/board-cm-t3517.c
+++ b/arch/arm/mach-omap2/board-cm-t3517.c
@@ -297,6 +297,6 @@ MACHINE_START(CM_T3517, "Compulab CM-T3517")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= cm_t3517_init,
 	.init_late	= am35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index 933479e..ee5e61f 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -642,6 +642,6 @@ MACHINE_START(DEVKIT8000, "OMAP3 Devkit8000")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= devkit8000_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_secure_timer,
+	.init_time	= omap3_secure_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 601ecdf..2787cb6 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -55,7 +55,7 @@ DT_MACHINE_START(OMAP242X_DT, "Generic OMAP2420 (Flattened Device Tree)")
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= omap_generic_init,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.dt_compat	= omap242x_boards_compat,
 	.restart	= omap_prcm_restart,
 MACHINE_END
@@ -74,7 +74,7 @@ DT_MACHINE_START(OMAP243X_DT, "Generic OMAP2430 (Flattened Device Tree)")
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= omap_generic_init,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.dt_compat	= omap243x_boards_compat,
 	.restart	= omap_prcm_restart,
 MACHINE_END
@@ -93,7 +93,7 @@ DT_MACHINE_START(OMAP3_DT, "Generic OMAP3 (Flattened Device Tree)")
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.dt_compat	= omap3_boards_compat,
 	.restart	= omap_prcm_restart,
 MACHINE_END
@@ -112,7 +112,7 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
-	.timer		= &omap3_am33xx_timer,
+	.init_time	= omap3_am33xx_timer_init,
 	.dt_compat	= am33xx_boards_compat,
 MACHINE_END
 #endif
@@ -132,7 +132,7 @@ DT_MACHINE_START(OMAP4_DT, "Generic OMAP4 (Flattened Device Tree)")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap_generic_init,
 	.init_late	= omap4430_init_late,
-	.timer		= &omap4_timer,
+	.init_time	= omap4_timer_init,
 	.dt_compat	= omap4_boards_compat,
 	.restart	= omap_prcm_restart,
 MACHINE_END
@@ -152,7 +152,7 @@ DT_MACHINE_START(OMAP5_DT, "Generic OMAP5 (Flattened Device Tree)")
 	.init_irq	= omap_gic_of_init,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap_generic_init,
-	.timer		= &omap5_timer,
+	.init_time	= omap5_timer_init,
 	.dt_compat	= omap5_boards_compat,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-h4.c b/arch/arm/mach-omap2/board-h4.c
index bd11b0a..c87df7a 100644
--- a/arch/arm/mach-omap2/board-h4.c
+++ b/arch/arm/mach-omap2/board-h4.c
@@ -385,6 +385,6 @@ MACHINE_START(OMAP_H4, "OMAP2420 H4 board")
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= omap_h4_init,
 	.init_late	= omap2420_init_late,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index dbc705a..d524d61 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -650,7 +650,7 @@ MACHINE_START(IGEP0020, "IGEP v2 board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= igep_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
 
@@ -663,6 +663,6 @@ MACHINE_START(IGEP0030, "IGEP OMAP3 module")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= igep_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index 1164b10..95d546f 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -435,6 +435,6 @@ MACHINE_START(OMAP_LDP, "OMAP LDP board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_ldp_init,
 	.init_late	= omap3430_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index e3efcb8..5dbc236 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -689,7 +689,7 @@ MACHINE_START(NOKIA_N800, "Nokia N800")
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= n8x0_init_machine,
 	.init_late	= omap2420_init_late,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
 
@@ -702,7 +702,7 @@ MACHINE_START(NOKIA_N810, "Nokia N810")
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= n8x0_init_machine,
 	.init_late	= omap2420_init_late,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
 
@@ -715,6 +715,6 @@ MACHINE_START(NOKIA_N810_WIMAX, "Nokia N810 WiMAX")
 	.handle_irq	= omap2_intc_handle_irq,
 	.init_machine	= n8x0_init_machine,
 	.init_late	= omap2420_init_late,
-	.timer		= &omap2_timer,
+	.init_time	= omap2_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 5a3800d..c11ce03 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -544,6 +544,6 @@ MACHINE_START(OMAP3_BEAGLE, "OMAP3 Beagle Board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3_beagle_init,
 	.init_late	= omap3_init_late,
-	.timer		= &omap3_secure_timer,
+	.init_time	= omap3_secure_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 3c0b9a9..cffca23 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -756,6 +756,6 @@ MACHINE_START(OMAP3EVM, "OMAP3 EVM")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3_evm_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap3logic.c b/arch/arm/mach-omap2/board-omap3logic.c
index e84e2a8..21062e7 100644
--- a/arch/arm/mach-omap2/board-omap3logic.c
+++ b/arch/arm/mach-omap2/board-omap3logic.c
@@ -231,7 +231,7 @@ MACHINE_START(OMAP3_TORPEDO, "Logic OMAP3 Torpedo board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3logic_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
 
@@ -244,6 +244,6 @@ MACHINE_START(OMAP3530_LV_SOM, "OMAP Logic 3530 LV SOM board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3logic_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index ce31bd3..559580a 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -618,6 +618,6 @@ MACHINE_START(OMAP3_PANDORA, "Pandora Handheld Console")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3pandora_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index ba11245..0502d80 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -426,6 +426,6 @@ MACHINE_START(SBC3530, "OMAP3 STALKER")
 	.handle_irq		= omap3_intc_handle_irq,
 	.init_machine		= omap3_stalker_init,
 	.init_late		= omap35xx_init_late,
-	.timer			= &omap3_secure_timer,
+	.init_time	= omap3_secure_timer_init,
 	.restart		= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index a225d81..fc6a322 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -386,6 +386,6 @@ MACHINE_START(TOUCHBOOK, "OMAP3 touchbook Board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap3_touchbook_init,
 	.init_late	= omap3430_init_late,
-	.timer		= &omap3_secure_timer,
+	.init_time	= omap3_secure_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 8c00b99..c7cfed5 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -523,6 +523,6 @@ MACHINE_START(OMAP4_PANDA, "OMAP4 Panda board")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= omap4_panda_init,
 	.init_late	= omap4430_init_late,
-	.timer		= &omap4_timer,
+	.init_time	= omap4_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 1cfb037..a3914ab 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -552,6 +552,6 @@ MACHINE_START(OVERO, "Gumstix Overo")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= overo_init,
 	.init_late	= omap35xx_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-rm680.c b/arch/arm/mach-omap2/board-rm680.c
index 1997e0e..a79d140 100644
--- a/arch/arm/mach-omap2/board-rm680.c
+++ b/arch/arm/mach-omap2/board-rm680.c
@@ -147,7 +147,7 @@ MACHINE_START(NOKIA_RM680, "Nokia RM-680 board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= rm680_init,
 	.init_late	= omap3630_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
 
@@ -160,6 +160,6 @@ MACHINE_START(NOKIA_RM696, "Nokia RM-696 board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= rm680_init,
 	.init_late	= omap3630_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-rx51.c b/arch/arm/mach-omap2/board-rx51.c
index c388aec..4904da8 100644
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@ -126,6 +126,6 @@ MACHINE_START(NOKIA_RX51, "Nokia RX-51 board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= rx51_init,
 	.init_late	= omap3430_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/board-ti8168evm.c b/arch/arm/mach-omap2/board-ti8168evm.c
index 5e672c2..36460e1 100644
--- a/arch/arm/mach-omap2/board-ti8168evm.c
+++ b/arch/arm/mach-omap2/board-ti8168evm.c
@@ -43,7 +43,7 @@ MACHINE_START(TI8168EVM, "ti8168evm")
 	.map_io		= ti81xx_map_io,
 	.init_early	= ti81xx_init_early,
 	.init_irq	= ti81xx_init_irq,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.init_machine	= ti81xx_evm_init,
 	.init_late	= ti81xx_init_late,
 	.restart	= omap_prcm_restart,
@@ -55,7 +55,7 @@ MACHINE_START(TI8148EVM, "ti8148evm")
 	.map_io		= ti81xx_map_io,
 	.init_early	= ti81xx_init_early,
 	.init_irq	= ti81xx_init_irq,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.init_machine	= ti81xx_evm_init,
 	.init_late	= ti81xx_init_late,
 	.restart	= omap_prcm_restart,
diff --git a/arch/arm/mach-omap2/board-zoom.c b/arch/arm/mach-omap2/board-zoom.c
index 8feb4d9..b716f05 100644
--- a/arch/arm/mach-omap2/board-zoom.c
+++ b/arch/arm/mach-omap2/board-zoom.c
@@ -137,7 +137,7 @@ MACHINE_START(OMAP_ZOOM2, "OMAP Zoom2 board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_zoom_init,
 	.init_late	= omap3430_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
 
@@ -150,6 +150,6 @@ MACHINE_START(OMAP_ZOOM3, "OMAP Zoom3 board")
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_zoom_init,
 	.init_late	= omap3630_init_late,
-	.timer		= &omap3_timer,
+	.init_time	= omap3_timer_init,
 	.restart	= omap_prcm_restart,
 MACHINE_END
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index c925c80..24df338 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -137,12 +137,12 @@ static inline void omap5_map_common_io(void)
 
 extern void omap2_init_common_infrastructure(void);
 
-extern struct sys_timer omap2_timer;
-extern struct sys_timer omap3_timer;
-extern struct sys_timer omap3_secure_timer;
-extern struct sys_timer omap3_am33xx_timer;
-extern struct sys_timer omap4_timer;
-extern struct sys_timer omap5_timer;
+extern void omap2_timer_init(void);
+extern void omap3_timer_init(void);
+extern void omap3_secure_timer_init(void);
+extern void omap3_am33xx_timer_init(void);
+extern void omap4_timer_init(void);
+extern void omap5_timer_init(void);
 
 void omap2420_init_early(void);
 void omap2430_init_early(void);
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 565e575..6291bbf 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -435,33 +435,24 @@ static inline void __init realtime_counter_init(void)
 
 #define OMAP_SYS_TIMER_INIT(name, clkev_nr, clkev_src,			\
 				clksrc_nr, clksrc_src)			\
-static void __init omap##name##_timer_init(void)			\
+void __init omap##name##_timer_init(void)				\
 {									\
 	omap2_gp_clockevent_init((clkev_nr), clkev_src);		\
 	omap2_clocksource_init((clksrc_nr), clksrc_src);		\
 }
 
-#define OMAP_SYS_TIMER(name)						\
-struct sys_timer omap##name##_timer = {					\
-	.init	= omap##name##_timer_init,				\
-};
-
 #ifdef CONFIG_ARCH_OMAP2
 OMAP_SYS_TIMER_INIT(2, 1, OMAP2_CLKEV_SOURCE, 2, OMAP2_MPU_SOURCE)
-OMAP_SYS_TIMER(2)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP3
 OMAP_SYS_TIMER_INIT(3, 1, OMAP3_CLKEV_SOURCE, 2, OMAP3_MPU_SOURCE)
-OMAP_SYS_TIMER(3)
 OMAP_SYS_TIMER_INIT(3_secure, OMAP3_SECURE_TIMER, OMAP3_CLKEV_SOURCE,
 			2, OMAP3_MPU_SOURCE)
-OMAP_SYS_TIMER(3_secure)
 #endif
 
 #ifdef CONFIG_SOC_AM33XX
 OMAP_SYS_TIMER_INIT(3_am33xx, 1, OMAP4_MPU_SOURCE, 2, OMAP4_MPU_SOURCE)
-OMAP_SYS_TIMER(3_am33xx)
 #endif
 
 #ifdef CONFIG_ARCH_OMAP4
@@ -470,7 +461,7 @@ static DEFINE_TWD_LOCAL_TIMER(twd_local_timer,
 			      OMAP44XX_LOCAL_TWD_BASE, 29);
 #endif
 
-static void __init omap4_timer_init(void)
+void __init omap4_timer_init(void)
 {
 	omap2_gp_clockevent_init(1, OMAP4_CLKEV_SOURCE);
 	omap2_clocksource_init(2, OMAP4_MPU_SOURCE);
@@ -490,11 +481,10 @@ static void __init omap4_timer_init(void)
 	}
 #endif
 }
-OMAP_SYS_TIMER(4)
 #endif
 
 #ifdef CONFIG_SOC_OMAP5
-static void __init omap5_timer_init(void)
+void __init omap5_timer_init(void)
 {
 	int err;
 
@@ -506,7 +496,6 @@ static void __init omap5_timer_init(void)
 	if (err)
 		pr_err("%s: arch_timer_register failed %d\n", __func__, err);
 }
-OMAP_SYS_TIMER(5)
 #endif
 
 /**
diff --git a/arch/arm/mach-shmobile/board-ag5evm.c b/arch/arm/mach-shmobile/board-ag5evm.c
index 25eb88a..2809ce1 100644
--- a/arch/arm/mach-shmobile/board-ag5evm.c
+++ b/arch/arm/mach-shmobile/board-ag5evm.c
@@ -657,5 +657,5 @@ MACHINE_START(AG5EVM, "ag5evm")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= ag5evm_init,
 	.init_late	= shmobile_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= sh73a0_earlytimer_init,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 790dc68..2deda6c 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -1489,5 +1489,5 @@ MACHINE_START(AP4EVB, "ap4evb")
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= ap4evb_init,
 	.init_late	= sh7372_pm_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= sh7372_earlytimer_init,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index 499e6e3..95b20e9 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -1224,9 +1224,6 @@ static void __init eva_earlytimer_init(void)
 static void __init eva_add_early_devices(void)
 {
 	r8a7740_add_early_devices();
-
-	/* override timer setup with board-specific code */
-	shmobile_timer.init = eva_earlytimer_init;
 }
 
 #define RESCNT2 IOMEM(0xe6188020)
@@ -1248,7 +1245,7 @@ DT_MACHINE_START(ARMADILLO800EVA_DT, "armadillo800eva")
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= eva_init,
 	.init_late	= shmobile_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= eva_earlytimer_init,
 	.dt_compat	= eva_boards_compat_dt,
 	.restart	= eva_restart,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-bonito.c b/arch/arm/mach-shmobile/board-bonito.c
index cb8c994..331b7ce 100644
--- a/arch/arm/mach-shmobile/board-bonito.c
+++ b/arch/arm/mach-shmobile/board-bonito.c
@@ -499,9 +499,6 @@ static void __init bonito_earlytimer_init(void)
 static void __init bonito_add_early_devices(void)
 {
 	r8a7740_add_early_devices();
-
-	/* override timer setup with board-specific code */
-	shmobile_timer.init = bonito_earlytimer_init;
 }
 
 MACHINE_START(BONITO, "bonito")
@@ -511,5 +508,5 @@ MACHINE_START(BONITO, "bonito")
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= bonito_init,
 	.init_late	= shmobile_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= bonito_earlytimer_init,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-kota2.c b/arch/arm/mach-shmobile/board-kota2.c
index bf88f9a..2f24994 100644
--- a/arch/arm/mach-shmobile/board-kota2.c
+++ b/arch/arm/mach-shmobile/board-kota2.c
@@ -553,5 +553,5 @@ MACHINE_START(KOTA2, "kota2")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= kota2_init,
 	.init_late	= shmobile_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= sh73a0_earlytimer_init,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-kzm9d.c b/arch/arm/mach-shmobile/board-kzm9d.c
index b52bc0d..59be864 100644
--- a/arch/arm/mach-shmobile/board-kzm9d.c
+++ b/arch/arm/mach-shmobile/board-kzm9d.c
@@ -92,6 +92,6 @@ DT_MACHINE_START(KZM9D_DT, "kzm9d")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= kzm9d_add_standard_devices,
 	.init_late	= shmobile_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= shmobile_timer_init,
 	.dt_compat	= kzm9d_boards_compat_dt,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-kzm9g.c b/arch/arm/mach-shmobile/board-kzm9g.c
index f63f2ee..8fd59e3 100644
--- a/arch/arm/mach-shmobile/board-kzm9g.c
+++ b/arch/arm/mach-shmobile/board-kzm9g.c
@@ -795,7 +795,7 @@ DT_MACHINE_START(KZM9G_DT, "kzm9g")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= kzm_init,
 	.init_late	= shmobile_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= sh73a0_earlytimer_init,
 	.restart	= kzm9g_restart,
 	.dt_compat	= kzm9g_boards_compat_dt,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index 39b8f2e..b61bfef 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -1663,6 +1663,6 @@ DT_MACHINE_START(MACKEREL_DT, "mackerel")
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= mackerel_init,
 	.init_late	= sh7372_pm_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= sh7372_earlytimer_init,
 	.dt_compat  = mackerel_boards_compat_dt,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/board-marzen.c b/arch/arm/mach-shmobile/board-marzen.c
index 69f7f46..e6ed68d 100644
--- a/arch/arm/mach-shmobile/board-marzen.c
+++ b/arch/arm/mach-shmobile/board-marzen.c
@@ -201,5 +201,5 @@ MACHINE_START(MARZEN, "marzen")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= marzen_init,
 	.init_late	= shmobile_init_late,
-	.timer		= &shmobile_timer,
+	.init_time	= r8a7779_earlytimer_init,
 MACHINE_END
diff --git a/arch/arm/mach-shmobile/include/mach/common.h b/arch/arm/mach-shmobile/include/mach/common.h
index dfeca79..a57439e 100644
--- a/arch/arm/mach-shmobile/include/mach/common.h
+++ b/arch/arm/mach-shmobile/include/mach/common.h
@@ -2,7 +2,7 @@
 #define __ARCH_MACH_COMMON_H
 
 extern void shmobile_earlytimer_init(void);
-extern struct sys_timer shmobile_timer;
+extern void shmobile_timer_init(void);
 extern void shmobile_setup_delay(unsigned int max_cpu_core_mhz,
 			 unsigned int mult, unsigned int div);
 struct twd_local_timer;
@@ -20,6 +20,7 @@ extern void shmobile_cpuidle_set_driver(struct cpuidle_driver *drv);
 
 extern void sh7372_init_irq(void);
 extern void sh7372_map_io(void);
+extern void sh7372_earlytimer_init(void);
 extern void sh7372_add_early_devices(void);
 extern void sh7372_add_standard_devices(void);
 extern void sh7372_clock_init(void);
@@ -32,6 +33,7 @@ extern struct clk sh7372_extal2_clk;
 
 extern void sh73a0_init_irq(void);
 extern void sh73a0_map_io(void);
+extern void sh73a0_earlytimer_init(void);
 extern void sh73a0_add_early_devices(void);
 extern void sh73a0_add_standard_devices(void);
 extern void sh73a0_clock_init(void);
@@ -50,6 +52,7 @@ extern void r8a7740_pinmux_init(void);
 
 extern void r8a7779_init_irq(void);
 extern void r8a7779_map_io(void);
+extern void r8a7779_earlytimer_init(void);
 extern void r8a7779_add_early_devices(void);
 extern void r8a7779_add_standard_devices(void);
 extern void r8a7779_clock_init(void);
diff --git a/arch/arm/mach-shmobile/setup-emev2.c b/arch/arm/mach-shmobile/setup-emev2.c
index a47beeb..ea61cb6 100644
--- a/arch/arm/mach-shmobile/setup-emev2.c
+++ b/arch/arm/mach-shmobile/setup-emev2.c
@@ -467,7 +467,7 @@ DT_MACHINE_START(EMEV2_DT, "Generic Emma Mobile EV2 (Flattened Device Tree)")
 	.init_irq	= emev2_init_irq_dt,
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= emev2_add_standard_devices_dt,
-	.timer		= &shmobile_timer,
+	.init_time	= shmobile_timer_init,
 	.dt_compat	= emev2_boards_compat_dt,
 MACHINE_END
 
diff --git a/arch/arm/mach-shmobile/setup-r8a7740.c b/arch/arm/mach-shmobile/setup-r8a7740.c
index 6ac242c..c5b4003 100644
--- a/arch/arm/mach-shmobile/setup-r8a7740.c
+++ b/arch/arm/mach-shmobile/setup-r8a7740.c
@@ -711,12 +711,6 @@ void __init r8a7740_add_standard_devices(void)
 	rmobile_add_device_to_domain("A3SP",	&i2c1_device);
 }
 
-static void __init r8a7740_earlytimer_init(void)
-{
-	r8a7740_clock_init(0);
-	shmobile_earlytimer_init();
-}
-
 void __init r8a7740_add_early_devices(void)
 {
 	early_platform_add_devices(r8a7740_early_devices,
@@ -724,9 +718,6 @@ void __init r8a7740_add_early_devices(void)
 
 	/* setup early console here as well */
 	shmobile_setup_console();
-
-	/* override timer setup with soc-specific code */
-	shmobile_timer.init = r8a7740_earlytimer_init;
 }
 
 #ifdef CONFIG_USE_OF
@@ -769,7 +760,7 @@ DT_MACHINE_START(R8A7740_DT, "Generic R8A7740 (Flattened Device Tree)")
 	.init_irq	= r8a7740_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= r8a7740_add_standard_devices_dt,
-	.timer		= &shmobile_timer,
+	.init_time	= shmobile_timer_init,
 	.dt_compat	= r8a7740_boards_compat_dt,
 MACHINE_END
 
diff --git a/arch/arm/mach-shmobile/setup-r8a7779.c b/arch/arm/mach-shmobile/setup-r8a7779.c
index 7a1ad4f..a181ced 100644
--- a/arch/arm/mach-shmobile/setup-r8a7779.c
+++ b/arch/arm/mach-shmobile/setup-r8a7779.c
@@ -339,7 +339,7 @@ void __init r8a7779_add_standard_devices(void)
 /* do nothing for !CONFIG_SMP or !CONFIG_HAVE_TWD */
 void __init __weak r8a7779_register_twd(void) { }
 
-static void __init r8a7779_earlytimer_init(void)
+void __init r8a7779_earlytimer_init(void)
 {
 	r8a7779_clock_init();
 	shmobile_earlytimer_init();
@@ -366,7 +366,4 @@ void __init r8a7779_add_early_devices(void)
 	 * As a final step pass earlyprint=sh-sci.2,115200 on the kernel
 	 * command line in case of the marzen board.
 	 */
-
-	/* override timer setup with soc-specific code */
-	shmobile_timer.init = r8a7779_earlytimer_init;
 }
diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index a360111..0437471 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -1060,7 +1060,7 @@ void __init sh7372_add_standard_devices(void)
 				       ARRAY_SIZE(domain_devices));
 }
 
-static void __init sh7372_earlytimer_init(void)
+void __init sh7372_earlytimer_init(void)
 {
 	sh7372_clock_init();
 	shmobile_earlytimer_init();
@@ -1073,9 +1073,6 @@ void __init sh7372_add_early_devices(void)
 
 	/* setup early console here as well */
 	shmobile_setup_console();
-
-	/* override timer setup with soc-specific code */
-	shmobile_timer.init = sh7372_earlytimer_init;
 }
 
 #ifdef CONFIG_USE_OF
@@ -1119,7 +1116,7 @@ DT_MACHINE_START(SH7372_DT, "Generic SH7372 (Flattened Device Tree)")
 	.init_irq	= sh7372_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= sh7372_add_standard_devices_dt,
-	.timer		= &shmobile_timer,
+	.init_time	= shmobile_timer_init,
 	.dt_compat	= sh7372_boards_compat_dt,
 MACHINE_END
 
diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
index db99a4a..8c2d642 100644
--- a/arch/arm/mach-shmobile/setup-sh73a0.c
+++ b/arch/arm/mach-shmobile/setup-sh73a0.c
@@ -796,7 +796,7 @@ void __init sh73a0_add_standard_devices(void)
 /* do nothing for !CONFIG_SMP or !CONFIG_HAVE_TWD */
 void __init __weak sh73a0_register_twd(void) { }
 
-static void __init sh73a0_earlytimer_init(void)
+void __init sh73a0_earlytimer_init(void)
 {
 	sh73a0_clock_init();
 	shmobile_earlytimer_init();
@@ -810,7 +810,4 @@ void __init sh73a0_add_early_devices(void)
 
 	/* setup early console here as well */
 	shmobile_setup_console();
-
-	/* override timer setup with soc-specific code */
-	shmobile_timer.init = sh73a0_earlytimer_init;
 }
diff --git a/arch/arm/mach-shmobile/timer.c b/arch/arm/mach-shmobile/timer.c
index a689197..fdbe54a 100644
--- a/arch/arm/mach-shmobile/timer.c
+++ b/arch/arm/mach-shmobile/timer.c
@@ -60,10 +60,6 @@ void __init shmobile_earlytimer_init(void)
 	late_time_init = shmobile_late_time_init;
 }
 
-static void __init shmobile_timer_init(void)
+void __init shmobile_timer_init(void)
 {
 }
-
-struct sys_timer shmobile_timer = {
-	.init		= shmobile_timer_init,
-};
diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index bc19f12..7f796d8 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -101,7 +101,7 @@ static struct of_device_id bcm2835_time_match[] __initconst = {
 	{}
 };
 
-static void __init bcm2835_time_init(void)
+void __init bcm2835_timer_init(void)
 {
 	struct device_node *node;
 	void __iomem *base;
@@ -155,7 +155,3 @@ static void __init bcm2835_time_init(void)
 
 	pr_info("bcm2835: system timer (irq = %d)\n", irq);
 }
-
-struct sys_timer bcm2835_timer = {
-	.init = bcm2835_time_init,
-};
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index f7dba5b..ab09ed3 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -107,7 +107,7 @@ static const struct of_device_id osctimer_ids[] __initconst = {
 	{},
 };
 
-static void __init timer_init(void)
+void __init dw_apb_timer_init(void)
 {
 	struct device_node *event_timer, *source_timer;
 
@@ -125,7 +125,3 @@ static void __init timer_init(void)
 
 	init_sched_clock();
 }
-
-struct sys_timer dw_apb_timer = {
-	.init = timer_init,
-};
diff --git a/include/linux/bcm2835_timer.h b/include/linux/bcm2835_timer.h
index 25680fe..ca17aa8 100644
--- a/include/linux/bcm2835_timer.h
+++ b/include/linux/bcm2835_timer.h
@@ -17,6 +17,6 @@
 
 #include <asm/mach/time.h>
 
-extern struct sys_timer bcm2835_timer;
+extern void bcm2835_timer_init(void);
 
 #endif
diff --git a/include/linux/dw_apb_timer.h b/include/linux/dw_apb_timer.h
index 1148575..dd755ce 100644
--- a/include/linux/dw_apb_timer.h
+++ b/include/linux/dw_apb_timer.h
@@ -53,5 +53,5 @@ void dw_apb_clocksource_start(struct dw_apb_clocksource *dw_cs);
 cycle_t dw_apb_clocksource_read(struct dw_apb_clocksource *dw_cs);
 void dw_apb_clocksource_unregister(struct dw_apb_clocksource *dw_cs);
 
-extern struct sys_timer dw_apb_timer;
+extern void dw_apb_timer_init(void);
 #endif /* __DW_APB_TIMER_H__ */
-- 
1.7.0.4

