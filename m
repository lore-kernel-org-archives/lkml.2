Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2C2N3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:29:54 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:25121 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2C2N14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:56 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 00/12] at91: 3.4-rc1 fixes
Date: Thu, 29 Mar 2012 15:27:11 +0200
Message-Id: <cover.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a bunch of fixes for AT91 that will go on top of material already
included in linus' tree.
Some modifications are related to certain drivers (USB ohci-at91 for instance)
but are touching the core AT91 devices/board files and Device Tree files.
The modification of "vbus_pin_active_low" in particular cannot be separated
from the modification of .dts[i] and devices/board files.

I will have to collect "Acked-by" from USB people on the ohci-at91
modifications (Greg?).

Best regards,

Nicolas Ferre (12):
  ARM: at91/at91sam9x5: add clkdev entries for DMA controllers
  USB: ohci-at91: fix vbus_pin_active_low handling
  ARM: at91/USB host: specify and handle properly vbus_pin_active_low
  ARM: at91/dts: USB host vbus is active low
  USB: ohci-at91: rework and fix initialization
  USB: ohci-at91: change maximum number of ports
  USB: ohci-at91: coding style modifications with one-line ifs
  USB: ohci-at91: trivial return code name change
  ARM: at91/at91sam9x5.dtsi: fix NAND ale/cle in DT file
  ARM: at91/NAND DT bindings: add comments
  USB: ehci-atmel: add needed of.h header file
  ARM: at91: fix check of valid GPIO for SPI and USB

 .../devicetree/bindings/mtd/atmel-nand.txt         |   10 +-
 arch/arm/boot/dts/at91sam9g25ek.dts                |    4 +-
 arch/arm/boot/dts/at91sam9m10g45ek.dts             |    4 +-
 arch/arm/boot/dts/at91sam9x5.dtsi                  |    4 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |    3 +
 arch/arm/mach-at91/at91sam9261_devices.c           |    3 +
 arch/arm/mach-at91/at91sam9263_devices.c           |    6 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   11 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |    3 +
 arch/arm/mach-at91/at91sam9x5.c                    |    2 +
 arch/arm/mach-at91/board-sam9263ek.c               |    1 +
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    1 +
 arch/arm/mach-at91/include/mach/board.h            |   13 +-
 drivers/usb/host/ehci-atmel.c                      |    1 +
 drivers/usb/host/ohci-at91.c                       |  129 ++++++++++----------
 15 files changed, 111 insertions(+), 84 deletions(-)

-- 
1.7.9.4

