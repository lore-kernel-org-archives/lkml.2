Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2H1Jai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 05:30:38 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:16695 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab2H1Jah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 05:30:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: [PATCH v3 0/7] add syscon driver based on regmap for general registers access
Date: Tue, 28 Aug 2012 17:09:58 +0800
Message-ID: <1346145005-17961-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series mainly adds an syscon driver which is used to access
general system controller registers like FSL IOMUXC GPR and ANATOP,
after that, we convert all the exist private access general registers code to use
standard API from regmap to access registers.
Finally we remove the old mfd anatop driver which is only for anatop register
access.

The patch series is based on linus's tree 3.6-rc3 since commit 9160338.

Dong Aisheng (7):
  mfd: add syscon driver based on regmap
  ARM: imx6q: add iomuxc gpr support into syscon
  ARM: imx6q: add anatop support into syscon
  regulator: anatop-regulator: convert to use syscon to access anatop
    register
  ARM: imx6q: convert to use syscon to access anatop registers
  ARM: dts: imx6q: add simple-bus compatible string for anatop
  mfd: anatop-mfd: remove anatop driver

 Documentation/devicetree/bindings/mfd/syscon.txt |   11 +
 arch/arm/boot/dts/imx6q.dtsi                     |    9 +-
 arch/arm/mach-imx/Kconfig                        |    2 +-
 arch/arm/mach-imx/mach-imx6q.c                   |   47 ++--
 drivers/mfd/Kconfig                              |   13 +-
 drivers/mfd/Makefile                             |    2 +-
 drivers/mfd/anatop-mfd.c                         |  124 ---------
 drivers/mfd/syscon.c                             |  172 ++++++++++++
 drivers/regulator/Kconfig                        |    2 +-
 drivers/regulator/anatop-regulator.c             |   30 ++-
 include/linux/fsl/imx6q-iomuxc-gpr.h             |  319 ++++++++++++++++++++++
 include/linux/mfd/anatop.h                       |   40 ---
 include/linux/mfd/syscon.h                       |   23 ++
 13 files changed, 579 insertions(+), 215 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/syscon.txt
 delete mode 100644 drivers/mfd/anatop-mfd.c
 create mode 100644 drivers/mfd/syscon.c
 create mode 100644 include/linux/fsl/imx6q-iomuxc-gpr.h
 delete mode 100644 include/linux/mfd/anatop.h
 create mode 100644 include/linux/mfd/syscon.h


