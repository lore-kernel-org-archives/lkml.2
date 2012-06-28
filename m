Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2F1Lvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:51:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55372 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2F1Lvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:51:46 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: <hvaibhav@ti.com>
Subject: [PATCH v1 00/11] omap: musb: Add device tree support
Date: Thu, 28 Jun 2012 17:20:56 +0530
Message-ID: <1340884267-28908-1-git-send-email-kishon@ti.com>
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

Changes from RFC:
Removed the dependency on [RFC PATCH 00/11] OMAP System Control Module.
Writing to control module register is now handled in otg driver itself.
Once the system control module driver get upstreamed, I'll send a patch
to make use of API's in control module driver to write to control
module register.

This series was developed on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv

This patch series depends on
[RFC PATCH v2 0/2] omap: add ocp2scp as a misc driver.
there is still some discussion on where to place the ocp2scp driver.
Once that gets finalized, I'll resend this patch series again with that
adaptaion.

Performed MUSB device mode testing on OMAP4 panda, OMAP4 SDP
and OMAP3 beagle.

Kishon Vijay Abraham I (11):
  drivers: usb: otg: add a new driver for omap usb2 phy
  arm/dts: omap: Add omap-usb2 dt data
  drivers: usb: otg: make twl6030_usb as a comparator driver to
    omap_usb2
  arm: omap: hwmod: add a new addr space in otg for writing to control
    module
  drivers: usb: twl6030: Add dt support for twl6030 usb
  arm/dts: Add twl6030-usb data
  drivers: usb: twl4030: Add device tree support for twl4030 usb
  arm/dts: Add twl4030-usb data
  drivers: usb: musb: Add device tree support for omap musb glue
  arm/dts: omap: Add usb_otg and glue data
  arm: omap: phy: remove unused functions from omap-phy-internal.c

 .../devicetree/bindings/misc/omap-ocp2scp.txt      |    3 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   48 ++++
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |   37 +++
 arch/arm/boot/dts/omap3-beagle.dts                 |    6 +
 arch/arm/boot/dts/omap3-evm.dts                    |    6 +
 arch/arm/boot/dts/omap3.dtsi                       |    8 +
 arch/arm/boot/dts/omap4-panda.dts                  |    6 +
 arch/arm/boot/dts/omap4-sdp.dts                    |    6 +
 arch/arm/boot/dts/omap4.dtsi                       |   13 +
 arch/arm/boot/dts/twl4030.dtsi                     |   21 ++
 arch/arm/boot/dts/twl6030.dtsi                     |    7 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    5 +
 arch/arm/mach-omap2/omap_phy_internal.c            |  138 ----------
 arch/arm/mach-omap2/twl-common.c                   |    5 -
 arch/arm/mach-omap2/usb-musb.c                     |    3 -
 drivers/usb/musb/omap2430.c                        |  104 +++++++-
 drivers/usb/musb/omap2430.h                        |    9 +
 drivers/usb/otg/Kconfig                            |   10 +
 drivers/usb/otg/Makefile                           |    1 +
 drivers/usb/otg/omap-usb2.c                        |  273 ++++++++++++++++++++
 drivers/usb/otg/twl4030-usb.c                      |   28 ++-
 drivers/usb/otg/twl6030-usb.c                      |  157 ++++--------
 include/linux/usb/omap_usb.h                       |   45 ++++
 include/linux/usb/phy_companion.h                  |   34 +++
 24 files changed, 701 insertions(+), 272 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
 create mode 100644 drivers/usb/otg/omap-usb2.c
 create mode 100644 include/linux/usb/omap_usb.h
 create mode 100644 include/linux/usb/phy_companion.h

-- 
1.7.5.4

