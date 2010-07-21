Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab0GUXjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:39:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35567 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab0GUXjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:39:53 -0400
Subject: [PATCH 0/5] Eliminate of_platform_bus_type
To: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:39:49 -0600
Message-ID: <20100721232817.7782.23410.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series eliminates the OF platform bus type and moves all users over
to the platform bus.  There is still work to be done to remove the
of_platform_driver references the affected drivers and then remove the
transitional code, but with this series those changes can be done piecewise.

These changes have been tested on PowerPC and UltraSparc.  Microblaze
has only been compile tested (at least by me, but they've been in my test
branch for a long time now, so Michal may have given them a spin.

This series depends on my next-devicetree[1] branch which is also in
linux-next.  I'm pushing them out to my experimental[2] branch for testing
now, and I'll add them to next-devicetree next week unless I hear
otherwise.

David, you'll also want to take a look at patches 4 & 5 to see if you
agree with my decisions on where I move symbols in the header files.

Cheers,
g.

---

Grant Likely (5):
      drivercore/of: Add OF style matching to platform bus
      of: Merge of_platform_bus_type with platform_bus_type
      of/platform: remove all of_bus_type and of_platform_bus_type references
      of: remove asm/of_platform.h
      of: remove asm/of_device.h


 arch/microblaze/include/asm/of_device.h   |   13 ------
 arch/microblaze/include/asm/of_platform.h |   19 --------
 arch/microblaze/kernel/of_platform.c      |   14 ------
 arch/microblaze/kernel/setup.c            |    6 ---
 arch/powerpc/include/asm/of_device.h      |    3 -
 arch/powerpc/include/asm/of_platform.h    |   16 -------
 arch/powerpc/include/asm/prom.h           |    2 +
 arch/powerpc/kernel/dma-swiotlb.c         |    8 ---
 arch/powerpc/kernel/of_platform.c         |   15 ------
 arch/powerpc/kernel/setup-common.c        |    7 ---
 arch/powerpc/platforms/cell/beat_iommu.c  |    2 -
 arch/powerpc/platforms/cell/iommu.c       |    2 -
 arch/powerpc/sysdev/mv64x60_dev.c         |    7 ---
 arch/sparc/include/asm/device.h           |    2 +
 arch/sparc/include/asm/of_device.h        |   19 --------
 arch/sparc/include/asm/of_platform.h      |   18 --------
 arch/sparc/include/asm/parport.h          |    4 --
 arch/sparc/include/asm/prom.h             |    4 ++
 arch/sparc/kernel/apc.c                   |    2 -
 arch/sparc/kernel/auxio_64.c              |    2 -
 arch/sparc/kernel/central.c               |    4 +-
 arch/sparc/kernel/chmc.c                  |    4 +-
 arch/sparc/kernel/of_device_32.c          |   21 ++-------
 arch/sparc/kernel/of_device_64.c          |   21 ++-------
 arch/sparc/kernel/of_device_common.c      |    5 --
 arch/sparc/kernel/pci_fire.c              |    2 -
 arch/sparc/kernel/pci_psycho.c            |    2 -
 arch/sparc/kernel/pci_sabre.c             |    2 -
 arch/sparc/kernel/pci_schizo.c            |    2 -
 arch/sparc/kernel/pci_sun4v.c             |    2 -
 arch/sparc/kernel/pmc.c                   |    2 -
 arch/sparc/kernel/power.c                 |    2 -
 arch/sparc/kernel/time_32.c               |    2 -
 arch/sparc/kernel/time_64.c               |    6 +--
 drivers/atm/fore200e.c                    |    6 +--
 drivers/base/platform.c                   |   11 +++++
 drivers/char/hw_random/n2-drv.c           |    4 +-
 drivers/crypto/n2_core.c                  |   10 ++--
 drivers/hwmon/ultra45_env.c               |    4 +-
 drivers/input/misc/sparcspkr.c            |   12 ++---
 drivers/input/serio/i8042-sparcio.h       |    5 +-
 drivers/mtd/maps/sun_uflash.c             |    4 +-
 drivers/net/ibm_newemac/core.c            |    4 +-
 drivers/net/myri_sbus.c                   |    4 +-
 drivers/net/niu.c                         |    6 +--
 drivers/net/sunbmac.c                     |    4 +-
 drivers/net/sunhme.c                      |    4 +-
 drivers/net/sunlance.c                    |    4 +-
 drivers/net/sunqe.c                       |    4 +-
 drivers/of/device.c                       |    5 ++
 drivers/of/platform.c                     |   67 ++++++++++++++++++++++++++++-
 drivers/parport/parport_sunbpp.c          |    4 +-
 drivers/sbus/char/bbc_i2c.c               |    4 +-
 drivers/sbus/char/display7seg.c           |    4 +-
 drivers/sbus/char/envctrl.c               |    4 +-
 drivers/sbus/char/flash.c                 |    4 +-
 drivers/sbus/char/uctrl.c                 |    4 +-
 drivers/scsi/qlogicpti.c                  |    4 +-
 drivers/scsi/sun_esp.c                    |    4 +-
 drivers/serial/sunhv.c                    |    4 +-
 drivers/serial/sunsab.c                   |    4 +-
 drivers/serial/sunsu.c                    |    2 -
 drivers/serial/sunzilog.c                 |    6 +--
 drivers/video/bw2.c                       |    4 +-
 drivers/video/cg14.c                      |    4 +-
 drivers/video/cg3.c                       |    4 +-
 drivers/video/cg6.c                       |    4 +-
 drivers/video/ffb.c                       |    4 +-
 drivers/video/leo.c                       |    4 +-
 drivers/video/p9100.c                     |    4 +-
 drivers/video/sunxvr1000.c                |    4 +-
 drivers/video/tcx.c                       |    4 +-
 drivers/watchdog/cpwd.c                   |    4 +-
 drivers/watchdog/riowd.c                  |    4 +-
 include/linux/of_device.h                 |    8 +++
 include/linux/of_platform.h               |   23 ++--------
 sound/sparc/amd7930.c                     |    4 +-
 sound/sparc/cs4231.c                      |    4 +-
 sound/sparc/dbri.c                        |    4 +-
 79 files changed, 222 insertions(+), 313 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/of_device.h
 delete mode 100644 arch/microblaze/include/asm/of_platform.h
 delete mode 100644 arch/powerpc/include/asm/of_device.h
 delete mode 100644 arch/powerpc/include/asm/of_platform.h
 delete mode 100644 arch/sparc/include/asm/of_device.h
 delete mode 100644 arch/sparc/include/asm/of_platform.h

-- 
Signature
