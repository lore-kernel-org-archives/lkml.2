Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab2FFX2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:28:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50120 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2FFX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:28:39 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v3 0/5] MIPS: OCTEON: Convert some device to use Device Tree.
Date: Wed,  6 Jun 2012 16:28:29 -0700
Message-Id: <1339025314-24216-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This patch set depends on the previous set to add Device Tree to
OCTEON.  That set can be found among other places here:

http://www.linux-mips.org/archives/linux-mips/2012-06/msg00081.html

For v3:

No functional changes, Added more Acked-bys, rebased to avoid merge
conflicts.

For v2:

No functional changes, but minor clean-ups to use some new device tree
helper functions.

Some Acked-bys added.

I am suggesting that all these go via Ralf's linux-mips.org tree as
they depend on other patches in that tree.

>From v1:

The patches are for drivers scattered throughout the tree, but there
is an order dependency as well as the dependency mentioned above, so
it may be preferable to merge them all via Ralf's linux-mips.org tree
rather that separately via the various device sub-system maintainers.

The mdio-octeon.c and octeon_mgmt patches were already Acked-by davem.

The i2c has been seen before, but to my knowledge was never acked.

The octeon_ethernet patch is in staging and has also been seen before.

The serial patch is new.

David Daney (5):
  i2c: Convert i2c-octeon.c to use device tree.
  netdev: mdio-octeon.c: Convert to use device tree.
  netdev: octeon_mgmt: Convert to use device tree.
  staging: octeon_ethernet: Convert to use device tree.
  MIPS: Octeon: Use device tree to register serial ports.

 arch/mips/cavium-octeon/octeon-irq.c      |    8 -
 arch/mips/cavium-octeon/octeon-platform.c |  176 ----------------
 arch/mips/cavium-octeon/serial.c          |  134 +++++--------
 arch/mips/include/asm/octeon/octeon.h     |    5 -
 drivers/i2c/busses/i2c-octeon.c           |   92 +++++----
 drivers/net/ethernet/octeon/octeon_mgmt.c |  312 +++++++++++++++++++----------
 drivers/net/phy/mdio-octeon.c             |   92 ++++++---
 drivers/staging/octeon/ethernet-mdio.c    |   28 ++--
 drivers/staging/octeon/ethernet.c         |  153 +++++++++-----
 drivers/staging/octeon/octeon-ethernet.h  |    3 +
 10 files changed, 484 insertions(+), 519 deletions(-)

-- 
1.7.2.3

