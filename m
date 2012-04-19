Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2DSNEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:04:21 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:59615 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755248Ab2DSNBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:01:13 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, thierry.reding@avionic-design.de, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v4 0/10] Second patchset for LPC32xx device tree conversion
Date: Thu, 19 Apr 2012 15:00:05 +0200
Message-Id: <1334840415-14287-1-git-send-email-stigge@antcom.de>
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

Changes since v3:
* phy3250.c, clock.c: Cleaned up auxdata table by using generated device
  names in clock table
* common.c: Removed trailing newline
* lpc32xx.dtsi: Documented SLC vs. MLC activation

Thanks to Arnd Bergmann for reviewing!

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
