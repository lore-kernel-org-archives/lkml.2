Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2DRNhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:37:31 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36291 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752828Ab2DRNh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:37:28 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, dan.carpenter@oracle.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3 0/10] Second patchset for LPC32xx device tree conversion
Date: Wed, 18 Apr 2012 15:36:05 +0200
Message-Id: <1334756176-25144-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second patch set for device tree conversion of mach-lpc32xx. It
builds upon and requires the previously posted first set of 8 plus the GPIO
patch.

It touches different subsystems (USB/OHCI, input/touchscreen, iio/adc and
mach-lpc32) to be picked by the respective subsystem maintainer and probably
applied separately. (?)

Signed-off-by: Roland Stigge <stigge@antcom.de>

--

Applies to v3.4-rc3

Changes since v2:
* ohci-nxp: Fixed hcd->rsrc_start physical address
* ohci-nxp: Remove USB host initialization hunk (USB_DEV_NEED_CLK_EN bit
  already cleared)
* ohci-nxp: Remove gratuitous parentheses
* clock.c: Separated out dma clock adjustment (new patch)
* lpc32xx.dtsi: Moved interrupt-parent property to top-level node
* lpc32xx.dtsi: Removed chosen/bootargs
* phy3250.dts: Added SLC NAND partitioning according to layout as shipped
  previously
* phy3250.c: Moved lpc32xx_display_uid() to common.c (leaving the rest in
  phy3250 for now due to temporary platform_data passed via auxdata) - new
  patch

Thanks to Arnd Bergmann, Dan Carpenter and Thierry Reding for reviewing!

Roland Stigge (10):
ohci-nxp: Driver cleanup
ohci-nxp: Device tree support
ARM: LPC32xx: clock.c cleanup
ARM: LPC32xx: clock.c dma adjustment
ARM: LPC32xx: Remove obsolete platform Kconfig
input: Device tree support for LPC32xx touchscreen
iio: lpc32xx-adc: Remove driver conflict due to device tree
ARM: LPC32xx: DTS files for device tree conversion
ARM: LPC32xx: Device tree support
ARM: LPC32xx: Move common code to common.c

 Documentation/devicetree/bindings/arm/lpc32xx-mic.txt               |   38 +
 Documentation/devicetree/bindings/arm/lpc32xx.txt                   |    8 
 Documentation/devicetree/bindings/input/touchscreen/lpc32xx-tsc.txt |   16 
 Documentation/devicetree/bindings/usb/ohci-nxp.txt                  |   16 
 arch/arm/Kconfig                                                    |    1 
 arch/arm/boot/dts/lpc32xx.dtsi                                      |  303 ++++++++++
 arch/arm/boot/dts/phy3250.dts                                       |  115 +++
 arch/arm/mach-lpc32xx/Kconfig                                       |   26 
 arch/arm/mach-lpc32xx/clock.c                                       |   77 +-
 arch/arm/mach-lpc32xx/common.c                                      |  192 ------
 arch/arm/mach-lpc32xx/common.h                                      |   14 
 arch/arm/mach-lpc32xx/irq.c                                         |   78 +-
 arch/arm/mach-lpc32xx/phy3250.c                                     |  146 ++--
 drivers/input/touchscreen/lpc32xx_ts.c                              |   10 
 drivers/staging/iio/adc/Kconfig                                     |    8 
 drivers/usb/host/ohci-nxp.c                                         |   55 +
 16 files changed, 704 insertions(+), 399 deletions(-)
