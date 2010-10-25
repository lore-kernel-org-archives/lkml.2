Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0JYM6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:58:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65027 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0JYM6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:58:07 -0400
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 13:58:05 +0100
X-Google-Sender-Auth: fRXjE7cRIF_BpATKGj7AQ1V9p_g
Message-ID: <AANLkTiki8LEkQFhRryduGyvr6M769pW7CMJAJz6AL8wu@mail.gmail.com>
Subject: [git pull] device tree changes for 2.6.37
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andres Salomon <dilinger@queued.net>,
        David Daney <ddaney@caviumnetworks.com>,
        "Dezhong Diao (dediao)" <dediao@cisco.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Michal Simek <monstr@monstr.eu>, Mingkai Hu <Mingkai.hu@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4429f608abde89e8bc1e24b43cd503feb95c496:

  Merge branch 'next' of
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-10-21
21:19:54 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-devicetree

Andres Salomon (8):
      sparc: stop exporting openprom.h header
      of/sparc: convert various prom_* functions to use phandle
      sparc: break out some PROM device-tree building code out into drivers/of
      of/promtree: make drivers/of/pdt.c no longer sparc-only
      of/promtree: no longer call prom_ functions directly; use an ops structure
      of/promtree: add of_pdt namespace to pdt code
      of/promtree: add package-to-path support to pdt
      of/irq: remove references to NO_IRQ in drivers/of/platform.c

David Daney (1):
      of/mips: Cleanup some include directives/files.

Dezhong Diao (1):
      of/mips: Add device tree support to MIPS

Grant Likely (3):
      of/device: Rework to use common platform_device_alloc() for
allocating devices
      of/flattree: Eliminate need to provide early_init_dt_scan_chosen_arch
      of/irq: of_irq.c needs to include linux/irq.h

Ian Munsie (1):
      powerpc, of_serial: Endianness issues setting up the serial ports

Jeremy Kerr (1):
      of: use __be32 types for big-endian device tree data

Michal Simek (3):
      of: GPIO: Fix OF probing on little-endian systems
      of: MTD: Fix OF probing on little-endian systems
      of/xsysace: Fix OF probing on little-endian systems

Mingkai Hu (1):
      mtd/m25p80: add support to parse the partitions by OF node

 arch/microblaze/kernel/prom.c       |    5 -
 arch/mips/Kconfig                   |    7 +
 arch/mips/include/asm/irq.h         |    5 +
 arch/mips/include/asm/prom.h        |   31 ++++
 arch/mips/kernel/Makefile           |    2 +
 arch/mips/kernel/prom.c             |  112 ++++++++++++++
 arch/mips/kernel/setup.c            |    2 +
 arch/powerpc/kernel/ibmebus.c       |   11 +-
 arch/powerpc/kernel/legacy_serial.c |   22 ++--
 arch/powerpc/kernel/prom.c          |   12 ++-
 arch/sparc/Kconfig                  |    1 +
 arch/sparc/include/asm/Kbuild       |    1 -
 arch/sparc/include/asm/floppy_32.h  |    3 +-
 arch/sparc/include/asm/openprom.h   |   16 +-
 arch/sparc/include/asm/oplib_32.h   |   44 +++---
 arch/sparc/include/asm/oplib_64.h   |   39 +++---
 arch/sparc/include/asm/prom.h       |    5 +-
 arch/sparc/kernel/auxio_32.c        |    4 +-
 arch/sparc/kernel/btext.c           |    4 +-
 arch/sparc/kernel/devices.c         |   23 ++--
 arch/sparc/kernel/leon_kernel.c     |    2 +-
 arch/sparc/kernel/pcic.c            |    4 +-
 arch/sparc/kernel/prom.h            |    6 -
 arch/sparc/kernel/prom_common.c     |  202 ++++----------------------
 arch/sparc/kernel/setup_64.c        |    2 +-
 arch/sparc/kernel/starfire.c        |    2 +-
 arch/sparc/kernel/tadpole.c         |    2 +-
 arch/sparc/mm/init_64.c             |    2 +-
 arch/sparc/mm/srmmu.c               |    8 +-
 arch/sparc/mm/sun4c.c               |    2 +-
 arch/sparc/prom/init_32.c           |    2 +-
 arch/sparc/prom/init_64.c           |    4 +-
 arch/sparc/prom/memory.c            |    3 +-
 arch/sparc/prom/misc_64.c           |    6 +-
 arch/sparc/prom/ranges.c            |    6 +-
 arch/sparc/prom/tree_32.c           |   58 ++++----
 arch/sparc/prom/tree_64.c           |   62 ++++----
 drivers/base/platform.c             |    1 +
 drivers/block/xsysace.c             |    3 +-
 drivers/gpio/xilinx_gpio.c          |    6 +-
 drivers/mtd/devices/m25p80.c        |    7 +
 drivers/mtd/maps/physmap_of.c       |    2 +-
 drivers/mtd/ofpart.c                |    4 +-
 drivers/of/Kconfig                  |    5 +-
 drivers/of/Makefile                 |    1 +
 drivers/of/address.c                |    2 +-
 drivers/of/base.c                   |    4 +-
 drivers/of/device.c                 |   27 +---
 drivers/of/fdt.c                    |    2 -
 drivers/of/irq.c                    |   39 +++++
 drivers/of/of_i2c.c                 |    1 +
 drivers/of/pdt.c                    |  276 +++++++++++++++++++++++++++++++++++
 drivers/of/platform.c               |   34 ++---
 drivers/sbus/char/jsflash.c         |    2 +-
 drivers/serial/of_serial.c          |   12 +-
 drivers/video/aty/atyfb_base.c      |    3 +-
 include/linux/of_device.h           |   13 +-
 include/linux/of_fdt.h              |    2 +-
 include/linux/of_irq.h              |    4 +
 include/linux/of_pdt.h              |   45 ++++++
 60 files changed, 800 insertions(+), 417 deletions(-)
 create mode 100644 arch/mips/include/asm/prom.h
 create mode 100644 arch/mips/kernel/prom.c
 create mode 100644 drivers/of/pdt.c
 create mode 100644 include/linux/of_pdt.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
