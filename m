Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2HVHh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:37:59 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:13547
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757053Ab2HVHh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:37:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dh2a8h668h839hd24he5bhf0ah107ah1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>,
        <paul.liu@linaro.org>
Subject: [PATCH 0/7] add imx-syscon driver for general registers access
Date: Wed, 22 Aug 2012 15:18:41 +0800
Message-ID: <1345619928-15446-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series mainly adds an imx-syscon driver which is used to access
general system controller registers like IOMUXC GPR and ANATOP,
after that, we convert all the exist private access general registers code to use
standard API from imx-syscon to access registers.
Finally we remove the old mfd anatop driver which is only for anatop register
access.

The patch series is based on linus's tree since commit 9160338.

Dong Aisheng (7):
  mfd: add imx syscon driver based on regmap
  ARM: imx6q: add iomuxc gpr support into imx-syscon
  ARM: imx6q: add anatop support into imx-syscon
  regulator: anatop-regulator: convert to use imx-syscon to access
    anatop register
  ARM: imx6q: convert to use imx-syscon to access anatop registers
  ARM: dts: imx6q: add simple-bus compatible string for anatop
  mfd: anatop-mfd: remove anatop driver

 .../devicetree/bindings/mfd/imx-syscon.txt         |   11 +
 arch/arm/boot/dts/imx6q.dtsi                       |   15 +-
 arch/arm/mach-imx/Kconfig                          |    2 +-
 arch/arm/mach-imx/mach-imx6q.c                     |   25 +--
 drivers/mfd/Kconfig                                |   14 +-
 drivers/mfd/Makefile                               |    2 +-
 drivers/mfd/anatop-mfd.c                           |  124 --------
 drivers/mfd/imx-syscon.c                           |  193 ++++++++++++
 drivers/regulator/Kconfig                          |    2 +-
 drivers/regulator/anatop-regulator.c               |   17 +-
 include/linux/fsl/imx6q-iomuxc-gpr.h               |  319 ++++++++++++++++++++
 include/linux/mfd/anatop.h                         |   40 ---
 include/linux/mfd/imx-syscon.h                     |   22 ++
 13 files changed, 585 insertions(+), 201 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/imx-syscon.txt
 delete mode 100644 drivers/mfd/anatop-mfd.c
 create mode 100644 drivers/mfd/imx-syscon.c
 create mode 100644 include/linux/fsl/imx6q-iomuxc-gpr.h
 delete mode 100644 include/linux/mfd/anatop.h
 create mode 100644 include/linux/mfd/imx-syscon.h


