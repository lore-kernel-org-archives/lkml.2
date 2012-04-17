Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2DQBDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:03:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59471 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DQBDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:03:41 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v3 0/3] netdev/of/phy: MDIO bus multiplexer support.
Date: Mon, 16 Apr 2012 18:03:25 -0700
Message-Id: <1334624608-26667-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This code has been working well for about six months on a couple of
different configurations (boards), so I thought it would be a good
time to send it out again, and I hope get it on the path towards
merging.


v3: Update binding to use "mdio-mux-gpio" compatible property.
    Cleanups suggested by Grant Likely.  Now uses the driver probe
    deferral mechanism if GPIOs or parent bus not available.

v2: Update bindings to use "reg" and "mdio-parent-bus" instead of
    "cell-index" and "parent-bus"

v1:

We have several different boards with a multiplexer in the MDIO bus.
There is an MDIO bus controller connected to a switching device with
several child MDIO busses.

Everything is wired up using device tree bindings.

 1/3 - New of_mdio_find_bus() function used to help configuring the
       driver topology.

 2/3 - MDIO bus multiplexer framework.

 3/3 - A driver for a GPIO controlled multiplexer.

David Daney (3):
  netdev/of/phy: New function: of_mdio_find_bus().
  netdev/of/phy: Add MDIO bus multiplexer support.
  netdev/of/phy: Add MDIO bus multiplexer driven by GPIO lines.

 .../devicetree/bindings/net/mdio-mux-gpio.txt      |  127 +++++++++++++
 Documentation/devicetree/bindings/net/mdio-mux.txt |  136 ++++++++++++++
 drivers/net/phy/Kconfig                            |   18 ++
 drivers/net/phy/Makefile                           |    2 +
 drivers/net/phy/mdio-mux-gpio.c                    |  142 +++++++++++++++
 drivers/net/phy/mdio-mux.c                         |  192 ++++++++++++++++++++
 drivers/net/phy/mdio_bus.c                         |   32 ++++
 drivers/of/of_mdio.c                               |    2 +
 include/linux/mdio-mux.h                           |   21 ++
 include/linux/of_mdio.h                            |    2 +
 10 files changed, 674 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux.txt
 create mode 100644 drivers/net/phy/mdio-mux-gpio.c
 create mode 100644 drivers/net/phy/mdio-mux.c
 create mode 100644 include/linux/mdio-mux.h

-- 
1.7.2.3

