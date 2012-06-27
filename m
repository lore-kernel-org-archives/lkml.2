Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab2F0Rej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:34:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46797 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849Ab2F0Rdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:33:47 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, David Daney <david.daney@cavium.com>
Subject: [PATCH v2 0/4] netdev/phy: 10G PHY support.
Date: Wed, 27 Jun 2012 10:33:34 -0700
Message-Id: <1340818418-10382-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

The only non-cosmetic change from v1 is to pass an additional argument
to get_phy_device() that indicates that the PHY uses 802.3 clause 45
signaling, previously I had been using a high order bit of the addr
parameter for this.

There are also changes from v1 in the code and comment formatting.
These should now be closer to what David Miller prefers.

>From v1:

The existing PHY driver infrastructure supports IEEE 802.3 Clause 22
PHYs used with 10/100/1000MB Ethernet.  For 10G Ethernet, many PHYs
use 802.3 Clause 45.  These patches attempt to add core support for
this as well as a driver for BCM87XX 10G PHY devices.

This is reworked from patches I send about 9 months ago:

http://marc.info/?l=linux-netdev&m=131844282403852

Several of the patches have device tree bindings in them, so the
device tree people get to enjoy them too.

David Daney (4):
  netdev/phy: Handle IEEE802.3 clause 45 Ethernet PHYs
  netdev/phy/of: Handle IEEE802.3 clause 45 Ethernet PHYs in
    of_mdiobus_register()
  netdev/phy/of: Add more methods for binding PHY devices to drivers.
  netdev/phy: Add driver for Broadcom BCM87XX 10G Ethernet PHYs

 .../devicetree/bindings/net/broadcom-bcm87xx.txt   |   29 +++
 Documentation/devicetree/bindings/net/phy.txt      |   12 +-
 drivers/net/phy/Kconfig                            |    5 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/bcm87xx.c                          |  238 ++++++++++++++++++++
 drivers/net/phy/mdio_bus.c                         |    9 +-
 drivers/net/phy/phy_device.c                       |  105 ++++++++-
 drivers/of/of_mdio.c                               |   16 +-
 include/linux/phy.h                                |   24 ++-
 9 files changed, 424 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
 create mode 100644 drivers/net/phy/bcm87xx.c

-- 
1.7.2.3

