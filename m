Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab2FVNcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:32:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33228 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762055Ab2FVNco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:32:44 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <hvaibhav@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [RFC PATCH 00/10] omap: musb: Add device tree support
Date: Fri, 22 Jun 2012 19:02:09 +0530
Message-ID: <1340371939-23572-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds device tree support for MUSB and device
tree support for all the related modules to get MUSB working in
OMAP platform.

A new omap-usb2 phy driver has been added (with only dt suppport)
to perform phy configurations. Previously this configuration was
performed by twl6030, using pdata function pointers.

With the addition of omap-usb2 to perform phy configurations,
twl6030 is made as a comparator driver to detect VBUS and ID events
and notify it to the glue layer.

musb core is _NOT_ yet converted to support device tree support as it
would need lot of driver re-design because of its enormous use of
function pointers. That will be in _TO DO_ list.

This series was developed on
http://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-next

However to test this patch series, the following patch series is needed
[PATCH v7 0/3] usb: multi-phy support
[PATCH v3 0/5] usb: musb: cleanup
[RFC PATCH 00/11] OMAP System Control Module
[RFC PATCH v2 0/2] omap: add ocp2scp as a misc driver

Performed device mode testing on OMAP4 panda and OMAP3 beagle.

Kishon Vijay Abraham I (10):
  drivers: usb: otg: add a new driver for omap usb2 phy
  arm/dts: omap: Add omap-usb2 dt data
  drivers: usb: otg: make twl6030_usb as a comparator driver to
    omap_usb2
  drivers: usb: twl6030: Add dt support for twl6030 usb
  arm/dts: Add twl6030-usb data
  drivers: usb: twl4030: Add device tree support for twl4030 usb
  arm/dts: Add twl4030-usb data
  drivers: usb: musb: Add device tree support for omap musb glue
  arm/dts: omap: Add usb_otg and glue data
  arm: omap: phy: remove unused functions from omap-phy-internal.c

 .../devicetree/bindings/misc/omap-ocp2scp.txt      |    3 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   46 ++++
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |   37 +++
 arch/arm/boot/dts/omap3-beagle.dts                 |    6 +
 arch/arm/boot/dts/omap3-evm.dts                    |    6 +
 arch/arm/boot/dts/omap3.dtsi                       |    8 +
 arch/arm/boot/dts/omap4-panda.dts                  |    6 +
 arch/arm/boot/dts/omap4-sdp.dts                    |    6 +
 arch/arm/boot/dts/omap4.dtsi                       |   12 +
 arch/arm/boot/dts/twl4030.dtsi                     |   21 ++
 arch/arm/boot/dts/twl6030.dtsi                     |    7 +
 arch/arm/mach-omap2/omap_phy_internal.c            |  138 -----------
 arch/arm/mach-omap2/twl-common.c                   |    5 -
 drivers/usb/musb/omap2430.c                        |   86 +++++++-
 drivers/usb/otg/Kconfig                            |   17 +-
 drivers/usb/otg/Makefile                           |    1 +
 drivers/usb/otg/omap-usb2.c                        |  239 ++++++++++++++++++++
 drivers/usb/otg/twl4030-usb.c                      |   26 ++-
 drivers/usb/otg/twl6030-usb.c                      |  153 ++++---------
 include/linux/usb/omap_usb.h                       |   43 ++++
 include/linux/usb/phy_companion.h                  |   34 +++
 21 files changed, 627 insertions(+), 273 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
 create mode 100644 drivers/usb/otg/omap-usb2.c
 create mode 100644 include/linux/usb/omap_usb.h
 create mode 100644 include/linux/usb/phy_companion.h

-- 
1.7.5.4

