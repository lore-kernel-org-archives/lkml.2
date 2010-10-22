Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab0JVRwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:52:10 -0400
Received: from kroah.org ([198.145.64.141]:36260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758071Ab0JVRvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:51:35 -0400
Date: Fri, 22 Oct 2010 10:51:07 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core merge for .37-rc1
Message-ID: <20101022175107.GB13489@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big driver-core merge for .37-rc1

The largest thing in here is a new misc driver, which seemed to make
sense to go through this tree.  Other than that, it's a number of small
things, all described below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while now.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 Documentation/ABI/testing/sysfs-module |   12 +
 Documentation/dynamic-debug-howto.txt  |   22 +-
 Documentation/kernel-parameters.txt    |   16 +-
 MAINTAINERS                            |    4 +-
 block/genhd.c                          |    7 +-
 drivers/base/Kconfig                   |    1 -
 drivers/base/Makefile                  |    4 +-
 drivers/base/bus.c                     |   22 -
 drivers/base/class.c                   |   23 +-
 drivers/base/core.c                    |  208 ++--------
 drivers/base/memory.c                  |   94 +++--
 drivers/base/node.c                    |    8 +-
 drivers/base/platform.c                |   80 +++-
 drivers/base/sys.c                     |    8 +-
 drivers/misc/Kconfig                   |   22 +-
 drivers/misc/Makefile                  |    1 +
 drivers/misc/hpilo.c                   |    2 +-
 drivers/misc/pch_phub.c                |  717 ++++++++++++++++++++++++++++++++
 drivers/scsi/hosts.c                   |    2 -
 drivers/scsi/scsi_scan.c               |    2 -
 drivers/uio/uio.c                      |  163 +++-----
 drivers/uio/uio_pci_generic.c          |   13 +-
 fs/partitions/check.c                  |   19 +-
 fs/sysfs/bin.c                         |   68 ++--
 include/linux/device.h                 |    7 +
 include/linux/kobject.h                |    2 +
 include/linux/memory.h                 |    4 +
 include/linux/platform_device.h        |    3 +
 include/linux/uio_driver.h             |    2 +-
 include/sound/core.h                   |    6 -
 init/Kconfig                           |   64 ++--
 lib/dynamic_debug.c                    |   98 ++++--
 lib/kobject.c                          |   39 ++
 sound/core/init.c                      |   11 +-
 34 files changed, 1238 insertions(+), 516 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-module
 create mode 100644 drivers/misc/pch_phub.c

---------------

Andi Kleen (1):
      SYSFS: Allow boot time switching between deprecated and modern sysfs layout

Anton Vorontsov (2):
      base/platform: Safe handling for NULL platform data and resources
      base/platform: Simplifications for NULL platform data/resources handling

Eric W. Biederman (7):
      uio: Fix lack of locking in init_uio_class
      uio: Don't clear driver data
      uio: Cleanup irq handling.
      uio: Support 2^MINOR_BITS minors
      uio: Statically allocate uio_class and use class .dev_attrs.
      sysfs: Fail bin file mmap if vma close is implemented.
      sysfs: only access bin file vm_ops with the active lock

Greg Kroah-Hartman (2):
      pch_phub: fix build warnings
      debugfs: mark me as the maintainer

Kay Sievers (1):
      driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices

Kevin Hilman (1):
      driver core: platform_bus: allow runtime override of dev_pm_ops

Kulikov Vasiliy (1):
      uio: do not use PCI resources before pci_enable_device()

Mark Brown (1):
      driver core: Display error codes when class suspend fails

Masayuki Ohtak (1):
      add Packet hub driver for Topcliff Platform controller hub

Nathan Fontenot (3):
      Driver core: Move find_memory_block routine
      Driver core: Add mutex for adding/removing memory blocks
      Driver core: Add section count to memory_block struct

Patrick Pannuto (1):
      driver core: platform: Use drv->driver.bus instead of assuming platform_bus_type

Randy Dunlap (2):
      FW_LOADER: fix kconfig dependency warning on HOTPLUG
      driver core: fix build for CONFIG_BLOCK not enabled

Robin Holt (3):
      kobject: Introduce kset_find_obj_hinted.
      driver core: Introduce find_memory_block_hinted which utilizes kset_find_obj_hinted.
      driver core: Convert link_mem_sections to use find_memory_block_hinted.

Thomas Renninger (3):
      Dynamic Debug: Split out query string parsing/setup from proc_write
      Dynamic Debug: Introduce ddebug_query= boot parameter
      Dynamic Debug: Initialize dynamic debug earlier via arch_initcall

dann frazier (1):
      hpilo: Despecificate driver from iLO generation

matt mooney (1):
      driver-core: base: change to new flag variable

