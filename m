Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2FKLCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:02:35 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:54883 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753215Ab2FKLCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:02:33 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 0/14] ARM: LPC32xx specific updates for next
Date: Mon, 11 Jun 2012 13:02:03 +0200
Message-Id: <1339412537-24485-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set includes various updates for mach-lpc32xx, including DT binding
for serial and dts updates. A new reference board is supported (EA3250). The
board support file phy3250.c is updated to become more general, useable for
other boards also. There is still board specific stuff in it, though (some
devicetree auxdata).

Further, clock updates, DMA support, MMC support and a defconfig update for
LPC32xx is included.

Signed-off-by: Roland Stigge <stigge@antcom.de>

--
Applies to v3.5-rc2

You can also pull from

  git://git.antcom.de/linux-2.6.git lpc32xx-next

Roland Stigge (14):
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

 arch/arm/Kconfig                          |    2 
 arch/arm/boot/dts/ea3250.dts              |  157 ++++++++++++++++++++++++++++++
 arch/arm/boot/dts/lpc32xx.dtsi            |   60 ++++++++---
 arch/arm/boot/dts/phy3250.dts             |   40 +++++++
 arch/arm/configs/lpc32xx_defconfig        |   22 +++-
 arch/arm/mach-lpc32xx/Kconfig             |   32 ------
 arch/arm/mach-lpc32xx/clock.c             |   18 ++-
 arch/arm/mach-lpc32xx/include/mach/gpio.h |    2 
 arch/arm/mach-lpc32xx/phy3250.c           |   77 +++++++++++++-
 arch/arm/mach-lpc32xx/serial.c            |   85 ----------------
 10 files changed, 343 insertions(+), 152 deletions(-)

