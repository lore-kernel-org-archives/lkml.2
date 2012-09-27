Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2I0OEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:04:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50017 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2I0OEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:04:32 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v2 0/2] usb: phy: add usb3 phy driver
Date: Thu, 27 Sep 2012 19:34:06 +0530
Message-ID: <1348754648-8315-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a driver for usb3 phy that handles the interaction between usb phy
device and dwc3 controller. Currently writing to control module register
is taken care in this driver which will be removed once the control
module driver is in place.

Changes from v1:
* Added missing clk_put()
* Remove the patches usb: dwc3: Fix gadget pullup in SS mode and
usb: phy: omap-usb3: Decrease the number of transitions to recovery. Those
are actually WA for hw issues which will be fixed in ES2.
* Removed the *has960mhzclk* property

This patch series was rebased on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
However the dependent modules are not yet upstreamed and hence only compile
tested in this tree

Kishon Vijay Abraham I (2):
  usb: phy: add a new driver for usb3 phy
  usb: phy: omap-usb2: enable 960Mhz clock for omap5

 Documentation/devicetree/bindings/usb/usb-phy.txt |   18 +
 drivers/usb/phy/Kconfig                           |    9 +
 drivers/usb/phy/Makefile                          |    1 +
 drivers/usb/phy/omap-usb2.c                       |   18 +-
 drivers/usb/phy/omap-usb3.c                       |  412 +++++++++++++++++++++
 include/linux/usb/omap_usb.h                      |   33 ++
 6 files changed, 489 insertions(+), 2 deletions(-)
 create mode 100644 drivers/usb/phy/omap-usb3.c

-- 
1.7.9.5

