Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2HVNCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:02:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2HVNB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:01:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] [RFC] ARM: multiplatform: rename all mach headers
Date: Wed, 22 Aug 2012 12:53:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221253.07278.arnd@arndb.de>
X-Provags-ID: V02:K0:PqYxkbQwVMmOIEhICKKut45NEge6KwfFCZgclX3I8QB
 q2rETWN+bo6gVVH/YM2VDxRaT7jo9PgfBo6QtgS/8SfQhbVtSA
 ZgvgVbjis0gSerhMK/jNRUhSiP/Uwq74Wx5GmnGXVp+io80Gk+
 09mztZZ/Z73JgmD4gKOuMDCF+1pQLAHxAuqE5LKUBMFd8zlMAG
 U3x/B+lFsQoFB6ZMhEJ4QronE7oFCCItzsRbI7ypufk/bzUwDY
 mGXOJV6p9u2rDU4zIUpp+W2Cyi8UQKCCkb51050Pkt9Qj6eygG
 hISXSaf/+jQ9/0xQf5UDttarAVM8gLvQB/cVeTzxoDEvOusmNd
 +2paKCok6jzCSvBm9ad4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've created this series some time ago, and updated it now to
v3.6-rc1. The idea is to get us a big step closer to the
single zImage kernel across multiple ARM platforms by
untangling the duplicate header file names.

There are two branches available in the arm-soc tree:

1. This series,
   http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=shortlog;h=refs/heads/testing/mach-headers
   This just moves header files around and changes most of the
   files including them. There are a few remaining drivers
   and platform files that keep including a generic file name
   like <mach/uncompress.h>. It remains possible to do that,
   and I've run extensive tests to ensure I did not break
   anything with this. However, each of these instances means
   that there is something that stops working when you get to
   the real multiplatform kernel and we still need to deal
   with them one by one.

2. Actually enabling CONFIG_ARCH_MULTIPLATFORM
   http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=shortlog;h=refs/heads/testing/multiplatform
   This builds on top of the first series, but is much more
   experimental. It shows how a multiplatform kernel can look
   like, by allowing to build vexpress, ux500, imx and omap2
   together in one kernel, but at the same time breaking some of
   their features.

I would like to get the first series merged in v3.7 if we can agree
on the general approach. So far, feedback in Linaro internal
meetings has been very positive, but Russell had concerns when
we first discussed it a few months ago.

A patch set this large means a lot of churn, and there are a few
ways we could deal with this:

a) Put the branch into linux-next now, and have everyone who
encounters conflicts pull it into their own branch to resolve
the conflicts. This can be a lot of work, and it means we
cannot rebase this branch any more.

b) Involve Linus Torvalds in the process and get him to
take the series at the end of the v3.7 merge window, after
rebasing it on top of all the other branches he merged.
This means it happens pretty much ad-hoc and there is little
testing on the patches that actually get merged.

c) Split the series and submit the first two branches at
the start of the merge window, and do the changes to all
the drivers either at the end of the v3.7 merge window
(after rebasing) or merge them through the subsystem
maintainer trees in small chunks for v3.8. This can minimize
the problems of the other two approaches, but means the process
takes longer to get to the same result.

        Arnd

[second attempt to send these patches, the first one was rejected by
lists.infradead.org, this one uses a different smtp setup]

Arnd Bergmann (4):
  [RFC] ARM: autogenerate mach-foo/* and plat-foo/* header redirects
  [RFC] ARM: mass move of mach-*/plat-* header files
  [RFC] ARM: treewide: scripted conversion to mach-*/*.h
  [RFC] ARM: treewide: manually change more mach-*/*.h includes

   0.0% Documentation/spi/
   0.0% arch/arm/boot/compressed/
   2.0% arch/arm/mach-at91/include/mach-at91/
   2.0% arch/arm/mach-at91/include/mach/
   0.1% arch/arm/mach-at91/
   0.0% arch/arm/mach-bcmring/csp/chipc/
   0.0% arch/arm/mach-bcmring/csp/dmac/
   0.0% arch/arm/mach-bcmring/csp/tmr/
   0.0% arch/arm/mach-bcmring/include/csp/
   3.0% arch/arm/mach-bcmring/include/mach-bcmring/csp/
   0.6% arch/arm/mach-bcmring/include/mach-bcmring/
   3.0% arch/arm/mach-bcmring/include/mach/csp/
   0.6% arch/arm/mach-bcmring/include/mach/
   0.0% arch/arm/mach-bcmring/
   0.3% arch/arm/mach-clps711x/include/mach-clps711x/
   0.3% arch/arm/mach-clps711x/include/mach/
   0.0% arch/arm/mach-clps711x/
   0.3% arch/arm/mach-cns3xxx/include/mach-cns3xxx/
   0.3% arch/arm/mach-cns3xxx/include/mach/
   0.0% arch/arm/mach-cns3xxx/
   1.2% arch/arm/mach-davinci/include/mach-davinci/
   1.2% arch/arm/mach-davinci/include/mach/
   0.1% arch/arm/mach-davinci/
   0.1% arch/arm/mach-dove/include/mach-dove/
   0.1% arch/arm/mach-dove/include/mach/
   0.0% arch/arm/mach-dove/
   0.0% arch/arm/mach-ebsa110/include/mach-ebsa110/
   0.0% arch/arm/mach-ebsa110/include/mach/
   0.0% arch/arm/mach-ebsa110/
   0.2% arch/arm/mach-ep93xx/include/mach-ep93xx/
   0.2% arch/arm/mach-ep93xx/include/mach/
   0.0% arch/arm/mach-ep93xx/
   1.0% arch/arm/mach-exynos/include/mach-exynos/
   1.0% arch/arm/mach-exynos/include/mach/
   0.1% arch/arm/mach-exynos/
   0.1% arch/arm/mach-footbridge/include/mach-footbridge/
   0.1% arch/arm/mach-footbridge/include/mach/
   0.0% arch/arm/mach-footbridge/
   0.1% arch/arm/mach-gemini/include/mach-gemini/
   0.1% arch/arm/mach-gemini/include/mach/
   0.0% arch/arm/mach-gemini/
   0.2% arch/arm/mach-h720x/include/mach-h720x/
   0.2% arch/arm/mach-h720x/include/mach/
   0.0% arch/arm/mach-h720x/
   0.0% arch/arm/mach-highbank/include/mach-highbank/
   0.0% arch/arm/mach-highbank/include/mach/
   7.2% arch/arm/mach-imx/include/mach-imx/
   0.0% arch/arm/mach-imx/include/mach/
   0.1% arch/arm/mach-imx/
   0.3% arch/arm/mach-integrator/include/mach-integrator/
   0.3% arch/arm/mach-integrator/include/mach/
   0.0% arch/arm/mach-integrator/
   0.6% arch/arm/mach-iop13xx/include/mach-iop13xx/
   0.6% arch/arm/mach-iop13xx/include/mach/
   0.0% arch/arm/mach-iop13xx/
   0.0% arch/arm/mach-iop32x/include/mach-iop32x/
   0.0% arch/arm/mach-iop32x/include/mach/
   0.0% arch/arm/mach-iop32x/
   0.0% arch/arm/mach-iop33x/include/mach-iop33x/
   0.0% arch/arm/mach-iop33x/include/mach/
   0.0% arch/arm/mach-iop33x/
   0.7% arch/arm/mach-ixp4xx/include/mach-ixp4xx/
   0.7% arch/arm/mach-ixp4xx/include/mach/
   0.0% arch/arm/mach-ixp4xx/
   0.1% arch/arm/mach-kirkwood/include/mach-kirkwood/
   0.1% arch/arm/mach-kirkwood/include/mach/
   0.0% arch/arm/mach-kirkwood/
   0.4% arch/arm/mach-ks8695/include/mach-ks8695/
   0.4% arch/arm/mach-ks8695/include/mach/
   0.0% arch/arm/mach-ks8695/
   0.0% arch/arm/mach-l7200/include/mach-l7200/
   0.0% arch/arm/mach-l7200/include/mach/
   0.4% arch/arm/mach-lpc32xx/include/mach-lpc32xx/
   0.4% arch/arm/mach-lpc32xx/include/mach/
   0.0% arch/arm/mach-lpc32xx/
   1.0% arch/arm/mach-mmp/include/mach-mmp/
   1.0% arch/arm/mach-mmp/include/mach/
   0.0% arch/arm/mach-mmp/
   1.9% arch/arm/mach-msm/include/mach-msm/
   1.9% arch/arm/mach-msm/include/mach/
   0.0% arch/arm/mach-msm/
   0.1% arch/arm/mach-mv78xx0/include/mach-mv78xx0/
   0.1% arch/arm/mach-mv78xx0/include/mach/
   0.0% arch/arm/mach-mv78xx0/
   0.0% arch/arm/mach-mvebu/include/mach-mvebu/
   0.0% arch/arm/mach-mvebu/include/mach/
   0.0% arch/arm/mach-mvebu/
   0.0% arch/arm/mach-mxs/devices/
   1.1% arch/arm/mach-mxs/include/mach-mxs/
   1.1% arch/arm/mach-mxs/include/mach/
   0.0% arch/arm/mach-mxs/
   0.3% arch/arm/mach-netx/include/mach-netx/
   0.3% arch/arm/mach-netx/include/mach/
   0.0% arch/arm/mach-netx/
   0.1% arch/arm/mach-nomadik/include/mach-nomadik/
   0.1% arch/arm/mach-nomadik/include/mach/
   0.0% arch/arm/mach-nomadik/
   0.2% arch/arm/mach-omap1/include/mach-omap1/
   0.2% arch/arm/mach-omap1/include/mach/
   0.1% arch/arm/mach-omap1/
   1.2% arch/arm/mach-omap2/include/mach-omap2/
   1.2% arch/arm/mach-omap2/include/mach/
   0.3% arch/arm/mach-omap2/
   0.1% arch/arm/mach-orion5x/include/mach-orion5x/
   0.1% arch/arm/mach-orion5x/include/mach/
   0.0% arch/arm/mach-orion5x/
   0.0% arch/arm/mach-picoxcell/include/mach-picoxcell/
   0.0% arch/arm/mach-picoxcell/include/mach/
   0.0% arch/arm/mach-picoxcell/
   0.4% arch/arm/mach-pnx4008/include/mach-pnx4008/
   0.4% arch/arm/mach-pnx4008/include/mach/
   0.0% arch/arm/mach-pnx4008/
   0.0% arch/arm/mach-prima2/include/mach-prima2/
   0.0% arch/arm/mach-prima2/include/mach/
   0.0% arch/arm/mach-prima2/
   4.0% arch/arm/mach-pxa/include/mach-pxa/
   4.0% arch/arm/mach-pxa/include/mach/
   0.3% arch/arm/mach-pxa/
   0.7% arch/arm/mach-realview/include/mach-realview/
   0.7% arch/arm/mach-realview/include/mach/
   0.0% arch/arm/mach-realview/
   0.1% arch/arm/mach-rpc/include/mach-rpc/
   0.1% arch/arm/mach-rpc/include/mach/
   0.0% arch/arm/mach-rpc/
   0.0% arch/arm/mach-s3c2410/
   0.0% arch/arm/mach-s3c2412/
   0.0% arch/arm/mach-s3c2440/
   1.4% arch/arm/mach-s3c24xx/include/mach-s3c24xx/
   1.4% arch/arm/mach-s3c24xx/include/mach/
   0.4% arch/arm/mach-s3c24xx/
   0.5% arch/arm/mach-s3c64xx/include/mach-s3c64xx/
   0.5% arch/arm/mach-s3c64xx/include/mach/
   0.1% arch/arm/mach-s3c64xx/
   0.3% arch/arm/mach-s5p64x0/include/mach-s5p64x0/
   0.3% arch/arm/mach-s5p64x0/include/mach/
   0.0% arch/arm/mach-s5p64x0/
   0.2% arch/arm/mach-s5pc100/include/mach-s5pc100/
   0.2% arch/arm/mach-s5pc100/include/mach/
   0.0% arch/arm/mach-s5pc100/
   0.3% arch/arm/mach-s5pv210/include/mach-s5pv210/
   0.3% arch/arm/mach-s5pv210/include/mach/
   0.0% arch/arm/mach-s5pv210/
   1.9% arch/arm/mach-sa1100/include/mach-sa1100/
   1.9% arch/arm/mach-sa1100/include/mach/
   0.0% arch/arm/mach-sa1100/
   0.0% arch/arm/mach-shark/include/mach-shark/
   0.0% arch/arm/mach-shark/include/mach/
   1.5% arch/arm/mach-shmobile/include/mach-shmobile/
   1.5% arch/arm/mach-shmobile/include/mach/
   0.0% arch/arm/mach-shmobile/
   0.0% arch/arm/mach-socfpga/include/mach-socfpga/
   0.0% arch/arm/mach-socfpga/include/mach/
   0.1% arch/arm/mach-spear13xx/include/mach-spear13xx/
   0.1% arch/arm/mach-spear13xx/include/mach/
   0.0% arch/arm/mach-spear13xx/
   0.0% arch/arm/mach-spear3xx/include/mach-spear3xx/
   0.0% arch/arm/mach-spear3xx/include/mach/
   0.0% arch/arm/mach-spear3xx/
   0.0% arch/arm/mach-spear6xx/include/mach-spear6xx/
   0.0% arch/arm/mach-spear6xx/include/mach/
   0.0% arch/arm/mach-spear6xx/
   0.5% arch/arm/mach-tegra/include/mach-tegra/
   0.5% arch/arm/mach-tegra/include/mach/
   0.0% arch/arm/mach-tegra/
   0.5% arch/arm/mach-u300/include/mach-u300/
   0.5% arch/arm/mach-u300/include/mach/
   0.0% arch/arm/mach-u300/
   0.3% arch/arm/mach-ux500/include/mach-ux500/
   0.3% arch/arm/mach-ux500/include/mach/
   0.0% arch/arm/mach-ux500/
   0.3% arch/arm/mach-versatile/include/mach-versatile/
   0.3% arch/arm/mach-versatile/include/mach/
   0.0% arch/arm/mach-versatile/
   0.1% arch/arm/mach-vexpress/include/mach-vexpress/
   0.1% arch/arm/mach-vexpress/include/mach/
   0.0% arch/arm/mach-vexpress/
   0.2% arch/arm/mach-vt8500/include/mach-vt8500/
   0.2% arch/arm/mach-vt8500/include/mach/
   0.0% arch/arm/mach-vt8500/
   0.3% arch/arm/mach-w90x900/include/mach-w90x900/
   0.3% arch/arm/mach-w90x900/include/mach/
   0.0% arch/arm/mach-w90x900/
   0.0% arch/arm/mach-zynq/include/mach-zynq/
   0.0% arch/arm/mach-zynq/include/mach/
   0.0% arch/arm/mach-zynq/
   0.0% arch/arm/mm/
   0.0% arch/arm/plat-mxc/devices/
   7.2% arch/arm/plat-mxc/include/mach/
   0.0% arch/arm/plat-mxc/
   0.1% arch/arm/plat-nomadik/include/plat-nomadik/
   0.1% arch/arm/plat-nomadik/include/plat/
   3.4% arch/arm/plat-omap/include/plat-omap/
   3.4% arch/arm/plat-omap/include/plat/
   0.0% arch/arm/plat-omap/
   0.1% arch/arm/plat-orion/include/plat-orion/
   0.1% arch/arm/plat-orion/include/plat/
   0.0% arch/arm/plat-orion/
   0.2% arch/arm/plat-pxa/include/plat-pxa/
   0.2% arch/arm/plat-pxa/include/plat/
   0.0% arch/arm/plat-pxa/
   0.0% arch/arm/plat-s3c24xx/
   2.7% arch/arm/plat-samsung/include/plat-samsung/
   2.7% arch/arm/plat-samsung/include/plat/
   0.0% arch/arm/plat-samsung/
   0.1% arch/arm/plat-spear/include/plat-spear/
   0.1% arch/arm/plat-spear/include/plat/
   0.0% arch/arm/plat-spear/
   0.0% arch/arm/plat-versatile/include/plat-versatile/
   0.0% arch/arm/plat-versatile/include/plat/
   0.0% arch/arm/plat-versatile/
   0.0% arch/arm/tools/
   0.0% arch/arm/
   0.0% drivers/ata/
   0.0% drivers/char/hw_random/
   0.0% drivers/char/
   0.0% drivers/clk/mxs/
   0.0% drivers/clk/
   0.0% drivers/clocksource/
   0.0% drivers/cpufreq/
   0.0% drivers/crypto/ux500/cryp/
   0.0% drivers/crypto/ux500/hash/
   0.0% drivers/crypto/
   0.0% drivers/devfreq/
   0.0% drivers/dma/ipu/
   0.0% drivers/dma/
   0.0% drivers/gpio/
   0.0% drivers/gpu/drm/exynos/
   0.0% drivers/hwmon/
   0.0% drivers/i2c/busses/
   0.0% drivers/iio/adc/
   0.0% drivers/input/keyboard/
   0.0% drivers/input/misc/
   0.0% drivers/input/mouse/
   0.0% drivers/input/serio/
   0.0% drivers/input/touchscreen/
   0.0% drivers/iommu/
   0.0% drivers/leds/
   0.0% drivers/media/video/davinci/
   0.0% drivers/media/video/omap/
   0.0% drivers/media/video/omap3isp/
   0.0% drivers/media/video/s5p-fimc/
   0.0% drivers/media/video/s5p-tv/
   0.0% drivers/media/video/
   0.0% drivers/mfd/
   0.0% drivers/misc/
   0.0% drivers/mmc/host/
   0.0% drivers/mtd/maps/
   0.0% drivers/mtd/nand/
   0.0% drivers/mtd/onenand/
   0.0% drivers/net/can/
   0.0% drivers/net/ethernet/amd/
   0.0% drivers/net/ethernet/cadence/
   0.0% drivers/net/ethernet/cirrus/
   0.0% drivers/net/ethernet/micrel/
   0.0% drivers/net/ethernet/nxp/
   0.0% drivers/net/ethernet/smsc/
   0.0% drivers/net/ethernet/xscale/
   0.0% drivers/net/ethernet/
   0.0% drivers/net/irda/
   0.0% drivers/net/wan/
   0.0% drivers/pcmcia/
   0.0% drivers/pinctrl/
   0.0% drivers/power/avs/
   0.0% drivers/power/
   0.0% drivers/ptp/
   0.0% drivers/pwm/
   0.0% drivers/remoteproc/
   0.0% drivers/rtc/
   0.0% drivers/scsi/arm/
   0.0% drivers/spi/
   0.0% drivers/staging/nvec/
   0.0% drivers/staging/omapdrm/
   0.0% drivers/staging/ste_rmi4/
   0.0% drivers/staging/tidspbridge/core/
   0.0% drivers/staging/tidspbridge/include/dspbridge/
   0.0% drivers/staging/tidspbridge/rmgr/
   0.0% drivers/tty/serial/
   0.0% drivers/uio/
   0.0% drivers/usb/gadget/
   0.0% drivers/usb/host/
   0.0% drivers/usb/musb/
   0.0% drivers/usb/otg/
   0.0% drivers/video/backlight/
   0.0% drivers/video/exynos/
   0.0% drivers/video/msm/
   0.0% drivers/video/omap/
   0.0% drivers/video/omap2/dss/
   0.0% drivers/video/omap2/omapfb/
   0.0% drivers/video/omap2/
   0.0% drivers/video/pnx4008/
   0.0% drivers/video/
   0.0% drivers/w1/masters/
   0.0% drivers/watchdog/
   0.0% include/linux/mfd/
   0.0% include/linux/platform_data/
   0.0% include/linux/power/
   0.0% include/linux/spi/
   0.0% include/linux/
   0.0% sound/arm/
   0.0% sound/atmel/
   0.0% sound/oss/
   0.0% sound/soc/atmel/
   0.0% sound/soc/davinci/
   0.0% sound/soc/ep93xx/
   0.0% sound/soc/fsl/
   0.0% sound/soc/kirkwood/
   0.0% sound/soc/mxs/
   0.0% sound/soc/nuc900/
   0.0% sound/soc/omap/
   0.0% sound/soc/pxa/
   0.0% sound/soc/samsung/
   0.0% sound/soc/tegra/
   0.0% sound/soc/ux500/

