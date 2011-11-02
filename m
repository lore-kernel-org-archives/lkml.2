Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab1KBCZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:25:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab1KBCXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 11/13] arm-soc device tree conversions
Date: Wed, 2 Nov 2011 03:03:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111020303.05784.arnd@arndb.de>
X-Provags-ID: V02:K0:O4VHeqwcSkGThqJAJ1zCLYdtO+wfnvxfyf5HstEep6z
 88fWcQhWyaiXRx5Ruz3wTE9wTJNRmROPdLw58YUAUxbL3Af7bP
 x6l0sD/xy5S8H62y1E366r85sQd+FV4XmBUvfcPsVwugqTR5xT
 lyYF6kmMctDn3n+dVhRijsu830A9hFz61hVc7YIn2olQsmACl7
 tToNkLSpkbIQ5BrDugr4sJ3Mz54ETv2gogONd9rflmdjVYwltI
 TopTweYL1ox4iHUj5L/SpSp2yGuhprW5p7j1G5K0Gd35Ywfc94
 BfL405lV00zwUTdmhMCFgRcHK1mmTecdvn/lw52xLiANPKHL5i
 Q14f5hMDJKSsowwKCWV8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch adds support for device tree based probing in the msm, imx, 
at91, and omap subarchitectures, moving us closer to obsoleting board
specific files in those platforms.

	Arnd

The following changes since commit 38b9c2164fc27127d4a3347c4774c70085b2a77e:

  Merge branch 'next/cleanup2' into for-linus (2011-11-01 17:09:10 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/dt

Arnd Bergmann (5):
      Merge branches 'msm/dt', 'imx/dt' and 'at91/dt' into next/dt
      Merge branch 'omap/dt' into next/dt
      Merge branch 'dt/gic' into next/dt
      ARM: gic: use module.h instead of export.h
      Merge branch 'imx/devel' into next/dt

David Brown (3):
      msm_serial: Use relative resources for iomem
      msm_serial: Add devicetree support
      ARM: msm: Add devicetree support for msm8660-surf

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: add at91sam9g20 and Calao USB A9G20 DT support

Nicolas Ferre (1):
      ARM: at91: dt: at91sam9g45 family and board device tree files

Rob Herring (6):
      Merge remote-tracking branch 'rmk/devel-stable' into HEAD
      of/irq: introduce of_irq_init
      irq: support domains with non-zero hwirq base
      ARM: gic: add irq_domain support
      ARM: gic: add OF based initialization
      ARM: gic: fix irq_alloc_descs handling for sparse irq

Shawn Guo (2):
      arm/mx5: add device tree support for imx53 boards
      arm/mx5: add device tree support for imx51 babbage

 Documentation/devicetree/bindings/arm/fsl.txt      |   19 ++
 Documentation/devicetree/bindings/arm/gic.txt      |   55 ++++
 .../devicetree/bindings/tty/serial/msm_serial.txt  |   27 ++
 arch/arm/boot/dts/at91sam9g20.dtsi                 |  119 ++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi                 |  106 +++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |   35 +++
 arch/arm/boot/dts/imx51-babbage.dts                |  135 +++++++++
 arch/arm/boot/dts/imx51.dtsi                       |  246 ++++++++++++++++
 arch/arm/boot/dts/imx53-ard.dts                    |  113 ++++++++
 arch/arm/boot/dts/imx53-evk.dts                    |  120 ++++++++
 arch/arm/boot/dts/imx53-qsb.dts                    |  125 ++++++++
 arch/arm/boot/dts/imx53-smd.dts                    |  169 +++++++++++
 arch/arm/boot/dts/imx53.dtsi                       |  301 ++++++++++++++++++++
 arch/arm/boot/dts/msm8660-surf.dts                 |   24 ++
 arch/arm/boot/dts/usb_a9g20.dts                    |   30 ++
 arch/arm/common/Kconfig                            |    1 +
 arch/arm/common/gic.c                              |  188 ++++++++----
 arch/arm/include/asm/hardware/gic.h                |   10 +-
 arch/arm/mach-at91/Kconfig                         |   11 +
 arch/arm/mach-at91/Makefile                        |    3 +
 arch/arm/mach-at91/Makefile.boot                   |    2 +
 arch/arm/mach-at91/at91sam9260.c                   |    8 +
 arch/arm/mach-at91/at91sam9g45.c                   |    6 +
 arch/arm/mach-at91/board-dt.c                      |  123 ++++++++
 arch/arm/mach-msm/board-msm8x60.c                  |   58 ++++-
 arch/arm/mach-mx5/Kconfig                          |   21 ++
 arch/arm/mach-mx5/Makefile                         |    3 +
 arch/arm/mach-mx5/board-mx51_babbage.c             |    9 +-
 arch/arm/mach-mx5/board-mx53_ard.c                 |   12 +-
 arch/arm/mach-mx5/board-mx53_evk.c                 |    9 +-
 arch/arm/mach-mx5/board-mx53_loco.c                |    9 +-
 arch/arm/mach-mx5/board-mx53_smd.c                 |    9 +-
 arch/arm/mach-mx5/clock-mx51-mx53.c                |   39 +++
 arch/arm/mach-mx5/imx51-dt.c                       |  116 ++++++++
 arch/arm/mach-mx5/imx53-dt.c                       |  126 ++++++++
 arch/arm/plat-mxc/include/mach/common.h            |    7 +
 drivers/of/irq.c                                   |  107 +++++++
 drivers/tty/serial/msm_serial.c                    |   30 ++-
 include/linux/irqdomain.h                          |   16 +-
 include/linux/of_irq.h                             |    3 +
 kernel/irq/irqdomain.c                             |   12 +-
 41 files changed, 2461 insertions(+), 101 deletions(-)
