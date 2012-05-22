Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075Ab2EVSAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:00:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59025 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598Ab2EVR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:59:57 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andy Fleming <afleming@freescale.com>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 0/5] netdev/phy: 10G PHY support.
Date: Tue, 22 May 2012 10:59:47 -0700
Message-Id: <1337709592-23347-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The existing PHY driver infrastructure supports IEEE 802.3 Clause 22
PHYs used with 10/100/1000MB Ethernet.  For 10G Ethernet, many PHYs
use 802.3 Clause 45.  These patches attempt to add core support for
this as well as drivers for several different 10G PHY devices.

This is reworked from patches I send about 9 months ago:

http://marc.info/?l=linux-netdev&m=131844282403852

Several of the patches have device tree bindings in them, so the
device tree people get to enjoy them too.


David Daney (5):
  netdev/phy: Handle IEEE802.3 clause 45 Ethernet PHYs
  netdev/phy/of: Handle IEEE802.3 clause 45 Ethernet PHYs in
    of_mdiobus_register()
  netdev/phy/of: Add more methods for binding PHY devices to drivers.
  netdev/phy: Add driver for Broadcom BCM87XX 10G Ethernet PHYs
  netdev/phy: Add driver for Cortina cs4321 quad 10G PHY.

 .../devicetree/bindings/net/broadcom-bcm87xx.txt   |   29 +
 .../devicetree/bindings/net/cortina-cs4321.txt     |   27 +
 Documentation/devicetree/bindings/net/phy.txt      |   12 +-
 drivers/net/phy/Kconfig                            |   11 +
 drivers/net/phy/Makefile                           |    2 +
 drivers/net/phy/bcm87xx.c                          |  237 ++
 drivers/net/phy/cs4321-ucode.h                     | 4378 ++++++++++++++++++++
 drivers/net/phy/cs4321.c                           | 1147 +++++
 drivers/net/phy/mdio_bus.c                         |    7 +
 drivers/net/phy/phy_device.c                       |  110 +-
 drivers/of/of_mdio.c                               |   14 +-
 include/linux/phy.h                                |   32 +-
 12 files changed, 5993 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
 create mode 100644 Documentation/devicetree/bindings/net/cortina-cs4321.txt
 create mode 100644 drivers/net/phy/bcm87xx.c
 create mode 100644 drivers/net/phy/cs4321-ucode.h
 create mode 100644 drivers/net/phy/cs4321.c

-- 
1.7.2.3

