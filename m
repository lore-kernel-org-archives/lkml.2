Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2KEJ3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:29:23 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48148 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2KEJ3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:29:21 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 0/8] Support for AM33xx PWM Susbsytem
Date: Mon, 5 Nov 2012 14:42:21 +0530
Message-ID: <1352106749-9437-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In AM33xx PWM sub modules like ECAP, EHRPWM & EQEP are  integrated to
PWM subsystem. All these submodules shares the resources (clock) & has
a clock gating register in PWM Subsystem. This patch series creates a
parent PWM Subsystem driver to handle access synchronization of shared
resources & clock gating from PWM Subsystem configuration space.
Also Device tree nodes populated to support parent child relation
between PWMSS, ECAP & EHRPWM submodules.
In addition EHRPWM module requires explicit clock gating from control
module & is handled by patch #2 & 6.

Patch #4 & 5 submitted is a second revision as suggested by  Thierry
for handling clock gating with a global function . This requires config
space handling done independent from driver and is done at parent driver.
So the parent<->child relation adopted to handle
1. pm runtime synchronization
2. PWM subsystem common config space clock gating for PWM submodules.

Patches supports
- Driver support for parent child relation handled patch #1
- Optional EHRPWM tb clock in patch #2
- Parent child in HWMOD handled at patch #3
- Device tree binding support handled in patch #4-6
- DT node populated in patch #7-8.

This patch series based on linux-next/20121102 and tested on AM335x-evm.
It depends on [1]

1. https://lkml.org/lkml/2012/10/29/589
pwm: Device tree support for PWM polarity

Philip, Avinash (8):
  PWMSS: Add PWM Subsystem driver for parent<->child relationship
  ARM: am33xx: clk: Add optional clock for EHRPWM
  ARM: OMAP: AM33xx hwmod: Add parent-child relationship for PWM
    subsystem
  pwm: pwm-tiecap: Add device-tree binding support for APWM driver
  pwm: pwm-tiehrpwm: Add device-tree binding support for EHRPWM driver
  pwm: pwm-tiehrpwm: Adding TBCLK gating support.
  ARM: dts: AM33XX: Add PWMSS device tree nodes
  ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm

 .../devicetree/bindings/pwm/pwm-tiecap.txt         |   22 +
 .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   25 ++
 Documentation/devicetree/bindings/pwm/tipwmss.txt  |   30 ++
 arch/arm/boot/dts/am335x-evm.dts                   |   21 +
 arch/arm/boot/dts/am33xx.dtsi                      |   90 +++++
 arch/arm/mach-omap2/clock33xx_data.c               |   37 ++
 arch/arm/mach-omap2/control.h                      |    8 +
 arch/arm/mach-omap2/omap_hwmod_33xx_data.c         |  414 +++++++++++++-------
 drivers/pwm/Kconfig                                |   11 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-tiecap.c                           |   36 ++-
 drivers/pwm/pwm-tiehrpwm.c                         |   53 +++-
 drivers/pwm/tipwmss.c                              |  136 +++++++
 drivers/pwm/tipwmss.h                              |    8 +
 14 files changed, 754 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tiecap.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/tipwmss.txt
 create mode 100644 drivers/pwm/tipwmss.c
 create mode 100644 drivers/pwm/tipwmss.h

