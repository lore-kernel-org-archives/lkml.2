Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2HFNIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:08:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43323 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab2HFNIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:08:30 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <b-cousson@ti.com>, <rnayak@ti.com>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v7 0/7] omap: musb: Add device tree support
Date: Mon, 6 Aug 2012 18:37:53 +0530
Message-ID: <1344258480-4304-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
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

Changes from v6:
* Removed the dt data part of the patch series. It'll be sent as a
separate series.
* Replaced arch initcall in omap-usb2 phy driver with a module
platform driver. Dependent drivers should use -EPROBE_DEFER. 

Changes from v5:
minor cleanups like checking for return value in get_sync and few changes
in the documentation has been done.

Changes from v4:
duplicate getting of 'mode' property is removed in omap-musb glue.

Changes from v3:
remove the address in the node name of usb_otg_hs since the usb_otg_hs
node doesn't have a reg property. Thanks Ajay Gupta for finding this.

Changes from v2:
Fixed Sergei's comment to remove *0x* prefix in usb2phy@0x4a0ad080

Changes from v1:
* Fixed Rajendra Nayak comments (regulator naming, compatible naming of
musb and other minor cleanups.)
* It's agreed to have ocp2scp in drivers/bus and usb2 phy is a child of
ocp2scp, the documentation is updated accordingly.

Changes from RFC:
Removed the dependency on [RFC PATCH 00/11] OMAP System Control Module.
Writing to control module register is now handled in otg driver itself.
Once the system control module driver get upstreamed, I'll send a patch
to make use of API's in control module driver to write to control
module register.

This series was developed on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv

This patch series depends on
[PATCH v3 0/2] omap: add ocp2scp as a bus driver

Performed MUSB device mode testing on OMAP4 panda, OMAP4 SDP
and OMAP3 beagle.

Kishon Vijay Abraham I (7):
  drivers: usb: phy: add a new driver for omap usb2 phy
  arm: omap: hwmod: add a new addr space in otg for writing to control
    module
  drivers: usb: otg: make twl6030_usb as a comparator driver to
    omap_usb2
  drivers: usb: twl6030: Add dt support for twl6030 usb
  drivers: usb: twl4030: Add device tree support for twl4030 usb
  drivers: usb: musb: Add device tree support for omap musb glue
  arm: omap: phy: remove unused functions from omap-phy-internal.c

 .../devicetree/bindings/bus/omap-ocp2scp.txt       |    3 +
 Documentation/devicetree/bindings/usb/omap-usb.txt |   49 ++++
 .../devicetree/bindings/usb/twlxxxx-usb.txt        |   40 +++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    5 +
 arch/arm/mach-omap2/omap_phy_internal.c            |  138 ----------
 arch/arm/mach-omap2/twl-common.c                   |    5 -
 arch/arm/mach-omap2/usb-musb.c                     |    3 -
 drivers/usb/musb/omap2430.c                        |  106 +++++++-
 drivers/usb/musb/omap2430.h                        |    9 +
 drivers/usb/otg/twl4030-usb.c                      |   26 +-
 drivers/usb/otg/twl6030-usb.c                      |  157 ++++--------
 drivers/usb/phy/Kconfig                            |   10 +
 drivers/usb/phy/Makefile                           |    1 +
 drivers/usb/phy/omap-usb2.c                        |  271 ++++++++++++++++++++
 include/linux/usb/omap_usb.h                       |   46 ++++
 include/linux/usb/phy_companion.h                  |   34 +++
 16 files changed, 631 insertions(+), 272 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
 create mode 100644 drivers/usb/phy/omap-usb2.c
 create mode 100644 include/linux/usb/omap_usb.h
 create mode 100644 include/linux/usb/phy_companion.h

-- 
1.7.9.5

