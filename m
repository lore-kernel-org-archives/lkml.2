Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2HFNrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:47:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43841 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074Ab2HFNre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:47:34 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <b-cousson@ti.com>,
        <rnayak@ti.com>, <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <balbi@ti.com>, <arnd@arndb.de>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <ohad@wizery.com>,
        <linus.walleij@linaro.org>, <myungjoo.ham@samsung.com>,
        <rusty@rustcorp.com.au>, <swarren@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH v4 0/2] omap: add ocp2scp as a bus driver
Date: Mon, 6 Aug 2012 19:16:29 +0530
Message-ID: <1344260791-6402-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is done as a preparatory step for adding phy drivers
for dwc3 and musb.

This series adds a new driver for ocp2scp (only dt) to which phy
drivers are connected.

Since currently there is no generic way to create a child device along
with doing a pm_runtime_enable (the exact requirement for ocp2scp), I'm
creating a separate driver for ocp2scp.

Changes from v3:
No functional changes. Fixed few comments on filling *module* details.

Changes from v2:
Fixed Felipe's comments to avoid using arch_initcall and make dependent
drivers return -EPROBE_DEFER case this isn't ready yet.

Changes from v1:
Fixed Sergei's comments to remove the address in the node name of ocp2scp
since the ocp2scp node doesn't have a reg property.

Changes from [RFC PATCH v2 0/2] omap: add ocp2scp as a misc driver:
Created a new folder drivers/bus and moved ocp2scp driver from misc to
drivers/bus.

This patch was developed and tested on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git

Kishon Vijay Abraham I (2):
  drivers: bus: add a new driver for omap-ocp2scp
  arm/dts: omap4: Add ocp2scp data

 .../devicetree/bindings/bus/omap-ocp2scp.txt       |   10 +++
 arch/arm/boot/dts/omap4.dtsi                       |    8 ++
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    2 +
 drivers/bus/Kconfig                                |   15 ++++
 drivers/bus/Makefile                               |    5 ++
 drivers/bus/omap-ocp2scp.c                         |   88 ++++++++++++++++++++
 7 files changed, 130 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
 create mode 100644 drivers/bus/Kconfig
 create mode 100644 drivers/bus/Makefile
 create mode 100644 drivers/bus/omap-ocp2scp.c

-- 
1.7.9.5

