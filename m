Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab1LTR3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 12:29:30 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:32745
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab1LTR3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 12:29:24 -0500
X-SpamScore: 4
X-BigFish: VS4(zzzz1202h1082kzzz2dh2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <cjb@laptop.org>, <w.sang@pengutronix.de>
Subject: [RFC PATCH v3 0/5] pinctrl: imx: add pinnmux support
Date: Wed, 21 Dec 2011 01:40:35 +0800
Message-ID: <1324402840-32451-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main changes of this new patch series are add dt binding
support in pinctrl core for pinmux mappings and shows an example
on using the standard API provided by pinctrl core to register
pinmux mappings from dts file.
Then we can remove the old board specifc pinmux mappings from
generic soc specific code (e.g. mach-imx6q.c).

Change v2->v3:
- change the name from of_get_child_number to of_get_child_count
- pinctrl: add dt binding support for pinmux mappings
- Add phandle for pinmux mappings for imx6q
- binding pinmux mappings via pinctrl core API
- follow the dt convention to use dash '-' for property name

Changes v1->v2:
- add a cover letter
- remove the pin functon and group defines out of driver
- parsing data from device tree for imx6q support
- a few minor fixes suggested by Shawn

Dong Aisheng (5):
  dt: add of_get_child_count helper function
  pinctrl: add dt binding support for pinmux mappings
  pinctrl: imx: add pinctrl imx driver
  ARM: imx6q: using pinmux subsystem
  mmc: sdhci-esdhc-imx: using pinmux subsystem

 .../devicetree/bindings/pinctrl/pinctrl-imx.txt    |   59 +++
 .../devicetree/bindings/pinctrl/pinctrl.txt        |   33 ++
 arch/arm/boot/dts/imx6q-sabreauto.dts              |   32 ++
 arch/arm/boot/dts/imx6q.dtsi                       |    1 +
 arch/arm/mach-imx/Kconfig                          |    1 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   20 +
 drivers/pinctrl/Kconfig                            |   20 +
 drivers/pinctrl/Makefile                           |    3 +
 drivers/pinctrl/pinctrl-imx-core.c                 |  450 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-imx-core.h                 |   86 ++++
 drivers/pinctrl/pinctrl-imx53.c                    |  443 +++++++++++++++++++
 drivers/pinctrl/pinctrl-imx6q.c                    |  433 +++++++++++++++++++
 drivers/pinctrl/pinmux.c                           |  101 +++++
 include/linux/of.h                                 |   16 +
 include/linux/pinctrl/machine.h                    |    6 +
 15 files changed, 1704 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-imx.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-imx-core.c
 create mode 100644 drivers/pinctrl/pinctrl-imx-core.h
 create mode 100644 drivers/pinctrl/pinctrl-imx53.c
 create mode 100644 drivers/pinctrl/pinctrl-imx6q.c


