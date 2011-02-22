Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1BVU6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:58:06 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13967 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1BVU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:58:04 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [RFC PATCH 00/10] MIPS: Octeon: Use Device Tree.
Date: Tue, 22 Feb 2011 12:57:44 -0800
Message-Id: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 22 Feb 2011 20:58:03.0738 (UTC) FILETIME=[32801BA0:01CBD2D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Background: The Octeon family of SOCs has a variety of on-chip
controllers for Ethernet, MDIO, I2C, and several other I/O devices.
These chips are used on boards with a great variety of different
configurations.  To date, the configuration and bus topology
information has been hard coded in the drivers and support code.

To facilitate supporting new chips and boards, we would like to make
use use the Device Tree to encode the configuration information.

I would like to get some feedback on the current code I am working
with.  The migration approach is as follows:

o Several device tree templates are statically linked into the kernel
  image.  Based on SOC type and board type one of these is selected in
  early boot.  Legacy configuration probing code is used to prune and
  patch the device tree template.

o New SOCs and boards will directly use a device tree passed by the
  bootloader (This patch set doesn't actually implement this, but it
  is trivial to add).



01/10 - Move configuration code to common place for use by Device Tree
        pruning and patching code.

02/10 - Add the statically linked Device Tree templates.

03/10 - Remove unused arch/mips/prom.c code that conflicts with
        following patches.

04/10 - irq_create_of_mapping() function.

05/10 - Rearrange legacy configuration code for following patch.

06/10 - Fix up Device Tree template for current environment.

07/10 - Convert I2C driver to use Device Tree.

08/10 - Convert MDIO driver to use Device Tree.

09/10 - Convert Ethernet mgmt driver to use Device Tree.

10/10 - Convert Octeon Ethernet driver to use Device Tree.


David Daney (10):
  MIPS: Octeon: Move some Ethernet support files out of staging.
  MIPS: Octeon: Add device tree source files.
  MIPS: Prune some target specific code out of prom.c
  MIPS: Octeon: Add a irq_create_of_mapping() implementation.
  MIPS: Octeon: Rearrance CVMX files in preperation for device tree
  MIPS: Octeon: Initialize and fixup device tree.
  i2c: Convert i2c-octeon.c to use device tree.
  netdev: mdio-octeon.c: Convert to use device tree.
  netdev: octeon_mgmt: Convert to use device tree.
  staging: octeon_ethernet: Convert to use device tree.

 arch/mips/Kconfig                                  |    2 +
 arch/mips/cavium-octeon/.gitignore                 |    2 +
 arch/mips/cavium-octeon/Makefile                   |   13 +
 arch/mips/cavium-octeon/executive/Makefile         |    5 +
 .../mips/cavium-octeon/executive}/cvmx-cmd-queue.c |    8 +-
 .../mips/cavium-octeon/executive}/cvmx-fpa.c       |    0
 .../cavium-octeon/executive}/cvmx-helper-board.c   |   18 +-
 .../cavium-octeon/executive}/cvmx-helper-fpa.c     |    0
 .../cavium-octeon/executive}/cvmx-helper-loop.c    |    6 +-
 .../cavium-octeon/executive}/cvmx-helper-npi.c     |    6 +-
 .../cavium-octeon/executive}/cvmx-helper-rgmii.c   |   17 +-
 .../cavium-octeon/executive}/cvmx-helper-sgmii.c   |   18 +-
 .../cavium-octeon/executive}/cvmx-helper-spi.c     |   20 +-
 .../cavium-octeon/executive}/cvmx-helper-util.c    |   16 +-
 .../cavium-octeon/executive}/cvmx-helper-xaui.c    |   32 +-
 .../mips/cavium-octeon/executive}/cvmx-helper.c    |  120 ++++--
 .../executive}/cvmx-interrupt-decodes.c            |   10 +-
 .../cavium-octeon/executive}/cvmx-interrupt-rsl.c  |    4 +-
 .../mips/cavium-octeon/executive}/cvmx-pko.c       |    6 +-
 .../mips/cavium-octeon/executive}/cvmx-spi.c       |   12 +-
 arch/mips/cavium-octeon/octeon-irq.c               |   25 ++
 arch/mips/cavium-octeon/octeon-platform.c          |  456 ++++++++++++--------
 arch/mips/cavium-octeon/octeon_3xxx.dts            |  314 ++++++++++++++
 arch/mips/cavium-octeon/octeon_68xx.dts            |   99 +++++
 arch/mips/cavium-octeon/setup.c                    |   17 +
 .../mips/include/asm}/octeon/cvmx-address.h        |    0
 .../mips/include/asm}/octeon/cvmx-asxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-cmd-queue.h      |    0
 .../mips/include/asm}/octeon/cvmx-config.h         |    0
 .../mips/include/asm}/octeon/cvmx-dbg-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-fau.h            |    0
 .../mips/include/asm}/octeon/cvmx-fpa-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-fpa.h            |    0
 .../mips/include/asm}/octeon/cvmx-gmxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-helper-board.h   |    0
 .../mips/include/asm}/octeon/cvmx-helper-fpa.h     |    0
 .../mips/include/asm}/octeon/cvmx-helper-loop.h    |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-npi.h     |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-rgmii.h   |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-sgmii.h   |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-spi.h     |    1 +
 .../mips/include/asm}/octeon/cvmx-helper-util.h    |    0
 .../mips/include/asm}/octeon/cvmx-helper-xaui.h    |    1 +
 .../mips/include/asm}/octeon/cvmx-helper.h         |    1 +
 .../mips/include/asm}/octeon/cvmx-ipd.h            |    0
 .../mips/include/asm}/octeon/cvmx-mdio.h           |    0
 .../mips/include/asm}/octeon/cvmx-pcsx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-pcsxx-defs.h     |    0
 .../mips/include/asm}/octeon/cvmx-pip-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-pip.h            |    0
 .../mips/include/asm}/octeon/cvmx-pko-defs.h       |    0
 .../mips/include/asm}/octeon/cvmx-pko.h            |    0
 .../mips/include/asm}/octeon/cvmx-pow.h            |    0
 .../mips/include/asm}/octeon/cvmx-scratch.h        |    0
 .../mips/include/asm}/octeon/cvmx-spi.h            |    0
 .../mips/include/asm}/octeon/cvmx-spxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-srxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-stxx-defs.h      |    0
 .../mips/include/asm}/octeon/cvmx-wqe.h            |    0
 arch/mips/include/asm/octeon/octeon.h              |    5 -
 arch/mips/kernel/prom.c                            |   49 ---
 drivers/i2c/busses/i2c-octeon.c                    |   88 ++--
 drivers/net/octeon/octeon_mgmt.c                   |  265 +++++++-----
 drivers/net/phy/mdio-octeon.c                      |   73 ++--
 drivers/staging/octeon/Makefile                    |    5 -
 drivers/staging/octeon/cvmx-packet.h               |   65 ---
 drivers/staging/octeon/cvmx-smix-defs.h            |  178 --------
 drivers/staging/octeon/ethernet-defines.h          |    2 +-
 drivers/staging/octeon/ethernet-mdio.c             |   31 +-
 drivers/staging/octeon/ethernet-mem.c              |    2 +-
 drivers/staging/octeon/ethernet-rgmii.c            |    4 +-
 drivers/staging/octeon/ethernet-rx.c               |   14 +-
 drivers/staging/octeon/ethernet-rx.h               |    2 +-
 drivers/staging/octeon/ethernet-sgmii.c            |    4 +-
 drivers/staging/octeon/ethernet-spi.c              |    6 +-
 drivers/staging/octeon/ethernet-tx.c               |   12 +-
 drivers/staging/octeon/ethernet-xaui.c             |    4 +-
 drivers/staging/octeon/ethernet.c                  |  115 +++--
 drivers/staging/octeon/octeon-ethernet.h           |    3 +
 79 files changed, 1308 insertions(+), 852 deletions(-)
 create mode 100644 arch/mips/cavium-octeon/.gitignore
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-cmd-queue.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-fpa.c (100%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-board.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-fpa.c (100%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-loop.c (95%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-npi.c (96%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-rgmii.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-sgmii.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-spi.c (94%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-util.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper-xaui.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-helper.c (93%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-interrupt-decodes.c (98%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-interrupt-rsl.c (97%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-pko.c (99%)
 rename {drivers/staging/octeon => arch/mips/cavium-octeon/executive}/cvmx-spi.c (99%)
 create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
 create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-address.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-asxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-cmd-queue.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-config.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-dbg-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-fau.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-fpa-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-fpa.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-gmxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-board.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-fpa.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-loop.h (96%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-npi.h (96%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-rgmii.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-sgmii.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-spi.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-util.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper-xaui.h (98%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-helper.h (99%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-ipd.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-mdio.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pcsx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pcsxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pip-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pip.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pko-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pko.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-pow.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-scratch.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-spi.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-spxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-srxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-stxx-defs.h (100%)
 rename {drivers/staging => arch/mips/include/asm}/octeon/cvmx-wqe.h (100%)
 delete mode 100644 drivers/staging/octeon/cvmx-packet.h
 delete mode 100644 drivers/staging/octeon/cvmx-smix-defs.h

-- 
1.7.2.3

