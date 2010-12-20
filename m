Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0LTKsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:48:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38920 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab0LTKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:48:51 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        liu.y.victor@gmail.com, B02280@freescale.com
Subject: [PATCH v2] i.MX51 Framebuffer support
Date: Mon, 20 Dec 2010 11:48:38 +0100
Message-Id: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds i.MX51 framebuffer support based on the IPUv3. It
is not perfect but I decided it is good enough to open it for a wider audience
and collect first reviews. I tested this on a babbage board using both outputs
(VGA/DVI) with different resolutions up to 1680x1050 and different colour depths.
I also tested it on one custom board using a fixed display setting.

Changes since v1:

- added full overlay support for i.MX51
- more data structures protection
- IPU clock now gets disabled when unused
- many minor cleanups due to comments received from the first round.


The following changes since commit 28a4f908acb342350b9ecbfcdf0a999cb83e05aa:

  ARM: mx5: check for error in ioremap (2010-12-14 09:55:53 +0100)

are available in the git repository at:
  git://git.pengutronix.de/git/imx/linux-2.6.git ipuv3

Sascha Hauer (9):
      ARM i.MX51: Add ipu clock support
      ARM i.MX51: rename IPU irqs
      Add a mfd IPUv3 driver
      fb: export fb mode db table
      Add i.MX5 framebuffer driver
      ARM i.MX51: Add IPU device support
      ARM i.MX5: Allow to increase max zone order
      ARM i.MX5: increase dma consistent size for IPU support
      ARM i.MX51 babbage: Add framebuffer support

 arch/arm/Kconfig                                |    4 +-
 arch/arm/mach-mx5/Kconfig                       |    1 +
 arch/arm/mach-mx5/board-mx51_babbage.c          |   74 ++
 arch/arm/mach-mx5/clock-mx51-mx53.c             |  140 ++++
 arch/arm/mach-mx5/devices-imx51.h               |    4 +
 arch/arm/plat-mxc/devices/Kconfig               |    4 +
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-imx_ipuv3.c  |   47 ++
 arch/arm/plat-mxc/include/mach/devices-common.h |   10 +
 arch/arm/plat-mxc/include/mach/ipu-v3.h         |   49 ++
 arch/arm/plat-mxc/include/mach/memory.h         |    3 +-
 arch/arm/plat-mxc/include/mach/mx51.h           |    4 +-
 drivers/mfd/Kconfig                             |    7 +
 drivers/mfd/Makefile                            |    1 +
 drivers/mfd/imx-ipu-v3/Makefile                 |    3 +
 drivers/mfd/imx-ipu-v3/ipu-common.c             |  708 +++++++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-cpmem.c              |  612 +++++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-dc.c                 |  364 +++++++++
 drivers/mfd/imx-ipu-v3/ipu-di.c                 |  550 +++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-dmfc.c               |  355 +++++++++
 drivers/mfd/imx-ipu-v3/ipu-dp.c                 |  476 ++++++++++++
 drivers/mfd/imx-ipu-v3/ipu-prv.h                |  216 ++++++
 drivers/video/Kconfig                           |   11 +
 drivers/video/Makefile                          |    1 +
 drivers/video/modedb.c                          |    7 +-
 drivers/video/mx5fb.c                           |  934 +++++++++++++++++++++++
 include/linux/fb.h                              |    3 +
 include/linux/mfd/imx-ipu-v3.h                  |  219 ++++++
 28 files changed, 4802 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-imx_ipuv3.c
 create mode 100644 arch/arm/plat-mxc/include/mach/ipu-v3.h
 create mode 100644 drivers/mfd/imx-ipu-v3/Makefile
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-common.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-cpmem.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-dc.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-di.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-dmfc.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-dp.c
 create mode 100644 drivers/mfd/imx-ipu-v3/ipu-prv.h
 create mode 100644 drivers/video/mx5fb.c
 create mode 100644 include/linux/mfd/imx-ipu-v3.h

