Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1JBOrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:47:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51979 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab1JBOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:46:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/30] ARM/omap: omap specific randconfig fixes
Date: Sun,  2 Oct 2011 16:45:30 +0200
Message-Id: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
X-Provags-ID: V02:K0:M+kTWmH7xMrmdtaBFP9uAJymNKTiyKBwPimJVo42s6Q
 ozyI7Hb2uYzLx0HZk/25w60HICo3e/RzeZ+z9BVg1DJ8LuXQTr
 030NVt0d1HalFwBd00neVUrMvICDAYIROAJCLYUJNKiS2lgmYm
 vrpAJg3psYc9VJwUWFgIYbPrxSbNX5TXwRBcoaQ01IhdLNS7NT
 2hkEVUpVe3jvrJD6r8Xm5SHbafH2/YS8TbDfdi36/hruuuz3jg
 Wjx1HT9SwB62BALvTqi7Ki719A7rCOC8CQu8oMcpLTrqxu5Wnn
 s2W/crKoJt/G6ZcJiCZQNYPf0rp6APnlNReBgZfAPQ+MZ4LIC1
 epgnct+cmZMaBN/bsOVJoyeFAgZ8eI0vzHfGmJlzKWKYVMmAV/
 SBrjakJrtQTAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

I've mentioned these patches before, and now I've managed to
go through them again and clean them enough for submission.

If nobody has any objections, I would like to send them to
Linus in the coming merge window, otherwise it would be nice
if you could pick the ones that look good to you and send
me a pull request. If any of these look like they should be
backported to stable kernels, please tell me and I'll add
a cc:stable@k.o tag.

The entire set is also available from
 git pull git://git.linaro.org/people/arnd/arm-soc.git randconfig/omap

but I have not yet pulled them into the for-next branch.

	Arnd

Arnd Bergmann (30):
  sound/omap: omap_mcpdm_remove cannot be __devexit
  video/omap: fix dependencies
  video/omap: fix build dependencies
  ARM: omap: add missing __devexit_p() annotations
  ARM: omap: enable building omap2 without omap2420/2430
  ARM: omap: fix build with CONFIG_I2C_OMAP disabled
  ARM: omap: fix visibility of omap2_mbox_iva_priv
  ARM: omap2+: fix building without i2c
  ARM: omap2: export functions used by nand driver
  ARM: omap/iommu: always provide iommu debug code
  ARM: omap2/n8x0: work around modular omap mmc
  ARM: omap4: always build omap_phy_internal
  ARM: omap2+: fix omap_hdq_init compilation
  ARM: omap2: irq.c is always needed
  usb/musb: use a Kconfig choice to pick the right DMA method
  usb/musb: HDRC depends on TWL4030_CORE for OMAP3/4
  usb/musb: allow building USB_MUSB_TUSB6010 as a module
  omap-usb: automatically select MFD_OMAP_USB_HOST
  tty/serial/omap: console can only be built-in
  media/omap_vout: disable driver for now
  sound/soc/omap: limit to omap2plus
  mfd: build twl6030 only on omap2
  ARM: omap2: select twl4030 support on boards that need it
  ARM: omap2+: ensure that one of omap2/3/4 is selected
  ARM: OMAP depends on MMU
  ARM: omap: add board autoselection
  ARM: omap: select L2X0 cache on omap4
  ARM: omap: select CPU_FREQ_TABLE where needed
  ARM: omap: select USB_ARCH_HAS_EHCI only when USB is enabled
  ARM: omap2: select ARM_AMBA for OMAP3_EMU

 arch/arm/Kconfig                           |    1 +
 arch/arm/mach-omap2/Kconfig                |   61 +++++++++++++++++++++++++-
 arch/arm/mach-omap2/Makefile               |   12 ++---
 arch/arm/mach-omap2/board-n8x0.c           |    7 ++-
 arch/arm/mach-omap2/devices.c              |   10 +++--
 arch/arm/mach-omap2/gpmc.c                 |    2 +
 arch/arm/mach-omap2/mailbox.c              |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    2 +-
 arch/arm/mach-omap2/smartreflex.c          |    2 +-
 arch/arm/plat-omap/Kconfig                 |    5 ++
 arch/arm/plat-omap/dma.c                   |    2 +-
 arch/arm/plat-omap/include/plat/i2c.h      |    6 +-
 arch/arm/plat-omap/include/plat/multi.h    |    5 ++
 arch/arm/plat-omap/iommu.c                 |    2 +-
 drivers/media/video/omap/Kconfig           |    1 +
 drivers/mfd/Kconfig                        |    6 +-
 drivers/tty/serial/Kconfig                 |    2 +-
 drivers/usb/musb/Kconfig                   |   58 +++++++++++++++----------
 drivers/usb/musb/Makefile                  |   26 ++----------
 drivers/usb/musb/musb_core.c               |    3 +-
 drivers/usb/musb/musb_io.h                 |    2 +-
 drivers/usb/musb/tusb6010.c                |    1 +
 drivers/video/omap/Kconfig                 |   41 ++++++++++++++++--
 drivers/video/omap/Makefile                |   64 +++++++++++++---------------
 drivers/video/omap2/displays/Kconfig       |    7 ++-
 sound/soc/omap/Kconfig                     |    2 +-
 sound/soc/omap/mcpdm.c                     |    2 +-
 sound/soc/omap/mcpdm.h                     |    2 +-
 31 files changed, 221 insertions(+), 121 deletions(-)

-- 
1.7.5.4

