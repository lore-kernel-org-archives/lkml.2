Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1LNPwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:52:21 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:3347
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193Ab1LNPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:52:20 -0500
X-SpamScore: -1
X-BigFish: VS-1(zz1521Mzz1202h1082kzzz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>
Subject: [RFC PATCH v2 0/4] pinctrl: imx: add pinnmux support
Date: Thu, 15 Dec 2011 00:03:38 +0800
Message-ID: <1323878622-26602-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new patch series shows the basic idea of parsing data from device tree.
The implementation bases on the assumption that board knows the function uses
which pin group and it only passes one group per one function to ease the parsing
effort. The core driver will construct the structure dynamically by parsing
the data from dts file in probe.

For DT support, there's still one issue that for pinmux_map,
since it's board specific, i wonder if it can be parsed by pinctrl
subsystem via dt rather than by each driver.
but pinctrl still does not supported that, i still only called
it in mach-imx6q.c which seems not a correct place.

The patch still has a few other work to do like add pinconf, gpio support and
one know issue is that when add pinconf support, the trick that using pin->id
to calculate the reg offset may not work since pin config registers are not
layout regularly and we may find a better way to do that.

So it's mainly for discussion on the visiable issues.

Changes since v1:
 * add a cover letter
 * remove the pin functon and group defines out of driver
 * parsing data from device tree for imx6q support
 * a few minor fixes suggested by Shawn

Dong Aisheng (4):
  dt: add of_get_child_number helper function
  pinctrl: imx: add pinmux imx driver
  ARM: imx6q: using pinmux subsystem
  mmc: sdhci-esdhc-imx: using pinmux subsystem

 arch/arm/boot/dts/imx6q-sabreauto.dts |   22 ++
 arch/arm/boot/dts/imx6q.dtsi          |    1 +
 arch/arm/mach-imx/Kconfig             |    1 +
 arch/arm/mach-imx/mach-imx6q.c        |    8 +-
 drivers/mmc/host/sdhci-esdhc-imx.c    |   20 ++
 drivers/pinctrl/Kconfig               |   20 ++
 drivers/pinctrl/Makefile              |    3 +
 drivers/pinctrl/pinmux-imx-core.c     |  435 ++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-imx-core.h     |   86 +++++++
 drivers/pinctrl/pinmux-imx53.c        |  443 +++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinmux-imx6q.c        |  433 ++++++++++++++++++++++++++++++++
 include/linux/of.h                    |   17 ++
 12 files changed, 1488 insertions(+), 1 deletions(-)
 create mode 100644 drivers/pinctrl/pinmux-imx-core.c
 create mode 100644 drivers/pinctrl/pinmux-imx-core.h
 create mode 100644 drivers/pinctrl/pinmux-imx53.c
 create mode 100644 drivers/pinctrl/pinmux-imx6q.c


