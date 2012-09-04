Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2IDDmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:42:31 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:50784
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494Ab2IDDmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:42:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz154dMzz1202h1082kzzz2dh2a8h668h839hd24he5bhf0ah107ah1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <richard.zhao@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>
Subject: [PATCH v5 0/4] add syscon driver based on regmap for general registers access
Date: Tue, 4 Sep 2012 11:20:07 +0800
Message-ID: <1346728811-25788-1-git-send-email-b29396@freescale.com>
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

ChangeLog v4->v5:
 * change syscon driver depends on OF
 * do not call of_node_put in syscon_node_to_regmap
 * renamed: include/linux/fsl/imx6q-iomuxc-gpr.h ->
	    include/linux/mfd/syscon/imx6q-iomuxc-gpr.h

ChangeLog v3->v4:
Only '[PATCH v4 1/7] mfd: add syscon driver based on regmap' is changed.

Dong Aisheng (4):
  mfd: add syscon driver based on regmap
  ARM: imx6q: add iomuxc gpr support into syscon
  regulator: anatop-regulator: convert to use syscon to access anatop
    register
  mfd: anatop-mfd: remove anatop driver

 Documentation/devicetree/bindings/mfd/syscon.txt |   20 ++
 arch/arm/boot/dts/imx6q.dtsi                     |    9 +-
 arch/arm/mach-imx/Kconfig                        |    2 +-
 arch/arm/mach-imx/mach-imx6q.c                   |   47 ++--
 drivers/mfd/Kconfig                              |   12 +-
 drivers/mfd/Makefile                             |    2 +-
 drivers/mfd/anatop-mfd.c                         |  124 ---------
 drivers/mfd/syscon.c                             |  176 ++++++++++++
 drivers/regulator/Kconfig                        |    2 +-
 drivers/regulator/anatop-regulator.c             |   30 ++-
 include/linux/mfd/anatop.h                       |   40 ---
 include/linux/mfd/syscon.h                       |   23 ++
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h      |  319 ++++++++++++++++++++++
 13 files changed, 592 insertions(+), 214 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/syscon.txt
 delete mode 100644 drivers/mfd/anatop-mfd.c
 create mode 100644 drivers/mfd/syscon.c
 delete mode 100644 include/linux/mfd/anatop.h
 create mode 100644 include/linux/mfd/syscon.h
 create mode 100644 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h


