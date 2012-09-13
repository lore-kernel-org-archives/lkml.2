Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2IMPmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:42:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2IMPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:42:05 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 00/10] pinctrl: mvebu: pinctrl driver
Date: Thu, 13 Sep 2012 17:41:42 +0200
Message-Id: <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a core pinctrl driver for Marvell MVEBU SoCs and
SoC specific stubs for Armada 370, Armada XP, Dove, and Kirkwood.
The SoC specific stubs use the pinctrl-mvebu core driver that handles
pinctrl API and register accesses for common pinctrl registers.

As especially Dove has some pinctrl registers that do not match the
common pinctrl register layout the core driver has been extended by
some callbacks to allow uncommon Dove pinctrl registers.

DT binding documentation is added for all supported SoCs but as
Dove and Kirkwood are not yet ready for full DT support, the pinctrl
driver is only activated for Armada 370 and XP.

The driver of latest patch v4 has been tested on Dove, Armada 370, 
Armada XP, and 88f6281 variant of Kirkwood.

Changelog:
v2:
- rebased on git://git.infradead.org/users/jcooper/linux.git boards-for-3.7
- removed arch/arm/*/Kconfig patches that enable PINCTRL_ on MACH_MVEBU
  (those will be sent as a different patch set)
- reworked patches wrt reviews from Andrew Lunn and Linus Walleij

v3:
- parse functions from SoC specific pin groups instead of DT node
- move kirkwood variants to DT match data
- respect Armada XP variant in DTs
- cleaned whitespaces in DTs
- rebased to jcooper/boards-for-v3.7-v2

v4:
- fix bogus v3 patch set with respect to pinctrl-mvebu, and pinctrl-kirkwood
  (my deep appologies to all reviewers that wasted their time with reviewing v3)
- mark internal functions in pinctrl-mvebu as static
- split up Kconfig of Armada 370 and XP
- enable pinctrl drivers for Armada 370 and XP

Sebastian Hesselbarth (3):
  pinctrl: mvebu: pinctrl driver core
  pinctrl: mvebu: dove pinctrl driver
  pinctrl: mvebu: kirkwood pinctrl driver

Thomas Petazzoni (7):
  pinctrl: mvebu: add pinctrl driver for Armada 370
  pinctrl: mvebu: add pinctrl driver for Armada XP
  ARM: mvebu: Add pinctrl support to Armada XP SoCs
  ARM: mvebu: Add pinctrl support to Armada 370 SoC
  ARM: mvebu: adjust Armada XP evaluation board DTS
  arm: mvebu: split Kconfig options for Armada 370 and XP
  arm: mvebu: select the pinctrl drivers for Armada 370 and Armada XP
    platforms

 .../pinctrl/marvell,armada-370-pinctrl.txt         |   95 +++
 .../bindings/pinctrl/marvell,armada-xp-pinctrl.txt |  100 +++
 .../bindings/pinctrl/marvell,dove-pinctrl.txt      |   72 ++
 .../bindings/pinctrl/marvell,kirkwood-pinctrl.txt  |  279 ++++++++
 .../bindings/pinctrl/marvell,mvebu-pinctrl.txt     |   46 ++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/armada-370.dtsi                  |    7 +
 arch/arm/boot/dts/armada-xp-db.dts                 |    4 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |   30 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |   30 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           |   30 +
 arch/arm/mach-mvebu/Kconfig                        |   18 +-
 drivers/pinctrl/Kconfig                            |   22 +
 drivers/pinctrl/Makefile                           |    5 +
 drivers/pinctrl/pinctrl-armada-370.c               |  421 +++++++++++
 drivers/pinctrl/pinctrl-armada-xp.c                |  468 ++++++++++++
 drivers/pinctrl/pinctrl-dove.c                     |  620 ++++++++++++++++
 drivers/pinctrl/pinctrl-kirkwood.c                 |  472 ++++++++++++
 drivers/pinctrl/pinctrl-mvebu.c                    |  754 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-mvebu.h                    |  192 +++++
 20 files changed, 3661 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,armada-370-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,armada-xp-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78230.dtsi
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78260.dtsi
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78460.dtsi
 create mode 100644 drivers/pinctrl/pinctrl-armada-370.c
 create mode 100644 drivers/pinctrl/pinctrl-armada-xp.c
 create mode 100644 drivers/pinctrl/pinctrl-dove.c
 create mode 100644 drivers/pinctrl/pinctrl-kirkwood.c
 create mode 100644 drivers/pinctrl/pinctrl-mvebu.c
 create mode 100644 drivers/pinctrl/pinctrl-mvebu.h
---
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
-- 
1.7.10.4

