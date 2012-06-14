Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2FNQvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:51:41 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:31166 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932114Ab2FNQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:32 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 00/23] ARM: LPC32xx specific updates for next
Date: Thu, 14 Jun 2012 18:50:50 +0200
Message-Id: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set includes various updates for mach-lpc32xx, including DT binding
for serial, and dts updates. A new reference board is supported (EA3250). The
board support file phy3250.c is updated to become more general, useable for
other boards also. There is still board specific stuff in it, though (some
devicetree auxdata).

Further, clock updates, DMA support, MMC support and a defconfig update for
LPC32xx is included.

Signed-off-by: Roland Stigge <stigge@antcom.de>

--
Applies to v3.5-rc2

Changes since v1:
* Don't use pointers to functions in dma init struct (Patch 4)
* Adjusted DT property status: "disable" -> "disabled" (Patch 15)
* defconfig: Added MTD_M25P80 (Patch 9)
* Fixed USB PHY I2C address for EA3250 (Patch 6)
* Added patches 16 through 23 by Alexandre Pereira da Silva

You can also pull from

  git://git.antcom.de/linux-2.6.git lpc32xx-next

Roland Stigge (15):
 ARM: LPC32xx: Add NAND flash timing to PHY3250 board dts
 ARM: LPC32xx: Clock initialization for NAND controllers
 ARM: LPC32xx: Remove SLC controller initialization from platform init
 ARM: LPC32xx: Add DMA configuration to platform data
 ARM: LPC32xx: Adjust dtsi file for MLC controller configuration
 ARM: LPC32xx: Add dts for EA3250 reference board
 ARM: LPC32xx: DTS adjustment for key matrix controller
 ARM: LPC32xx: Clock adjustment for key matrix controller
 ARM: LPC32xx: Defconfig update
 ARM: LPC32xx: Add MMC controller support
 ARM: LPC32xx: DTS adjustment for using pl18x primecell
 ARM: LPC32xx: DT conversion of Standard UARTs
 ARM: LPC32xx: High Speed UART configuration via DT
 ARM: LPC32xx: Remove mach specific ARCH_NR_GPIOS, use default
 ARM: LPC32xx: Fix lpc32xx.dtsi status property: "disable" -> "disabled"
Alexandre Pereira da Silva (8):
 ARM: LPC32XX: Build arch dtbs
 ARM: LPC32xx: Add dt settings to the at25 node
 ARM: LPC32xx: Remove spi chipselect request from board
 ARM: LPC32xx: Remove spi chip definitions
 ARM: LPC32xx: Cleanup board init, remove duplicate
 ARM: LPC32xx: Move uart6 irda disable to serial.c
 ARM: LPC32xx: Move i2s1 dma enabling to clock.c
 ARM: LPC32xx: Remove duplicate usb host clock init

 arch/arm/Kconfig                          |    2 
 arch/arm/boot/dts/ea3250.dts              |  157 +++++++++++++++++++++++++++
 arch/arm/boot/dts/lpc32xx.dtsi            |   74 ++++++++----
 arch/arm/boot/dts/phy3250.dts             |   61 ++++++++++
 arch/arm/configs/lpc32xx_defconfig        |   24 +++-
 arch/arm/mach-lpc32xx/Kconfig             |   32 -----
 arch/arm/mach-lpc32xx/Makefile.boot       |    1 
 arch/arm/mach-lpc32xx/clock.c             |   24 +++-
 arch/arm/mach-lpc32xx/include/mach/gpio.h |    2 
 arch/arm/mach-lpc32xx/phy3250.c           |  174 ++++++++++++------------------
 arch/arm/mach-lpc32xx/serial.c            |   90 +--------------
 11 files changed, 383 insertions(+), 258 deletions(-)

