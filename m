Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668Ab0HEVfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:35:43 -0400
Received: from kroah.org ([198.145.64.141]:40169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814Ab0HEVfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:35:33 -0400
Date: Thu, 5 Aug 2010 14:33:14 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for .36
Message-ID: <20100805213314.GB13744@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big driver core merge for the .36 merge window.

Nothing major here, lot of little things around the driver-core
area.  Biggest is the firmware code rework to make things simpler and
the addition of a stable place to mount cgroupfs that everyone has
now agreed on (acked by the cgroup maintainers.)

Full details as to what is included is below in the shortlog.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 Documentation/DocBook/device-drivers.tmpl   |    1 +
 Documentation/filesystems/sysfs.txt         |   46 +++--
 Documentation/firmware_class/hotplug-script |   17 +-
 arch/powerpc/sysdev/mv64x60_pci.c           |    1 -
 drivers/base/bus.c                          |    2 +-
 drivers/base/core.c                         |    2 +-
 drivers/base/dd.c                           |    4 +
 drivers/base/dma-coherent.c                 |    2 +-
 drivers/base/firmware_class.c               |  262 +++++++++++++--------------
 drivers/base/platform.c                     |  110 +++--------
 drivers/firmware/dcdbas.c                   |    5 +-
 drivers/firmware/dmi-id.c                   |    4 +-
 drivers/leds/leds-bd2802.c                  |    4 +-
 drivers/regulator/core.c                    |    1 -
 drivers/scsi/arcmsr/arcmsr_attr.c           |    3 -
 drivers/scsi/lpfc/lpfc_attr.c               |    1 -
 drivers/uio/uio_cif.c                       |    2 +-
 drivers/uio/uio_pdrv_genirq.c               |    1 -
 drivers/uio/uio_sercos3.c                   |    2 +-
 fs/sysfs/file.c                             |    3 +-
 include/linux/device.h                      |   15 +-
 include/linux/platform_device.h             |   62 ++++++-
 include/linux/sysfs.h                       |   12 +-
 kernel/cgroup.c                             |   13 ++-
 kernel/sysctl.c                             |    2 +-
 lib/Kconfig.debug                           |    1 -
 26 files changed, 288 insertions(+), 290 deletions(-)

---------------

Axel Lin (2):
      dmi-id: fix a memory leak in dmi_id_init error path
      dcdbas: remove a redundant smi_data_buf_free in dcdbas_exit

Bart Van Assche (1):
      sysfs: fix discrepancies between implementation and documentation

Dmitry Torokhov (2):
      firmware loader: use statically initialized data attribute
      firmware loader: embed device into firmware_priv structure

Greg Kroah-Hartman (1):
      cgroupfs: create /sys/fs/cgroup to mount cgroupfs on

Guenter Roeck (6):
      scsi: Remove owner field from attribute initialization in LPFC driver
      scsi: Remove owner field from attribute initialization in ARCMSR driver
      leds: Remove owner field from attribute initialization in bd2802 driver
      regulator: Remove owner field from attribute initialization in regulator core driver
      powerpc/pci: Remove owner field from attribute initialization in PCI bridge init
      sysfs: Remove owner field from sysfs struct attribute

Hans J. Koch (3):
      uio: Remove IRQF_DISABLED flag from uio_pdrv_genirq.c
      uio: Remove IRQF_DISABLED from uio_sercos3.c
      uio: Remove IRQF_DISABLED flag from uio_cif.c

Ian Abbott (1):
      hotplug: Support kernel/hotplug sysctl variable when !CONFIG_NET

Ira Weiny (1):
      sysfs: Fix one more signature discrepancy between sysfs implementation and docs.

Jean Delvare (2):
      Driver core: Drop __must_check from bus_for_each_drv()
      sysfs: sysfs_chmod_file's attr can be const

Jike Song (1):
      driver core: fix memory leak on one error path in bus_register()

Johannes Berg (1):
      driver core: device_rename's new_name can be const

Magnus Damm (2):
      firmware: Update hotplug script
      Driver core: Add BUS_NOTIFY_BIND_DRIVER

Marin Mitov (1):
      Driver core: internal struct dma_coherent_mem, change type of a member.

Randy Dunlap (1):
      debugfs: no longer needs to depend on SYSFS

Uwe Kleine-König (3):
      Driver core: use kmemdup in platform_device_add_resources
      Driver core: reduce duplicated code for platform_device creation
      Driver core: move platform device creation helpers to .init.text (if MODULE=n)

