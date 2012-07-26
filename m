Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2GZRrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:47:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55496 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2GZRrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:47:43 -0400
Date: Thu, 26 Jul 2012 10:47:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: [GIT PATCH] Driver core merge for 3.6-rc1
Message-ID: <20120726174738.GA29539@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:

  Linux 3.5-rc7 (2012-07-14 15:40:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.6-rc1

for you to fetch changes up to 6791457a090d9a234a40b501c2536f0aefaeae4b:

  printk: Export struct log size and member offsets through vmcoreinfo (2012-07-19 17:14:18 -0700)

----------------------------------------------------------------
Driver core merge for 3.6-rc1

Here's the big driver core pull request for 3.6-rc1.

Unlike 3.5, this kernel should be a lot tamer, with the printk changes now
settled down.  All we have here is some extcon driver updates, w1 driver
updates, a few printk cleanups that weren't needed for 3.5, but are good to
have now, and some other minor fixes/changes in the driver core.

All of these have been in the linux-next releases for a while now.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Andrew Morton (1):
      sysfs: fail dentry revalidation after namespace change fix

Arend van Spriel (1):
      debugfs: change parameter check in debugfs_remove() functions

Axel Lin (2):
      extcon: Set platform drvdata in gpio_extcon_probe() and fix irq leak
      extcon: Convert extcon_gpio to devm_gpio_request_one

Chanwoo Choi (1):
      extcon: MAX77693: Add extcon-max77693 driver to support Maxim MAX77693 MUIC device

Devendra Naga (1):
      w1: cleanup w1_uevent

Glauber Costa (1):
      sysfs: fail dentry revalidation after namespace change

Greg Kroah-Hartman (3):
      Revert "w1: introduce a slave mutex for serializing IO"
      Merge v3.5-rc5 into driver-core-next
      Merge 3.5-rc7 into driver-core-next

Hans de Goede (1):
      device-core: Ensure drvdata = NULL when no driver is bound

K. Y. Srinivasan (1):
      Drivers: hv: Change the hex constant to a decimal constant

Kay Sievers (4):
      kmsg - properly print over-long continuation lines
      kmsg - avoid warning for CONFIG_PRINTK=n compilations
      kmsg - export "continuation record" flag to /dev/kmsg
      kmsg - do not flush partial lines when the console is busy

Lars-Peter Clausen (2):
      driver-core: Move kobj_to_dev from genhd.h to device.h
      driver-core: Use kobj_to_dev instead of re-implementing it

Mark Brown (5):
      Extcon: Staticise extcon_class
      Extcon: Arizona: Add driver for Wolfson Arizona class devices
      driver core: Move deferred devices to the end of dpm_list before probing
      extcon: arizona: Update cable reporting calls and split headset
      extcon: arizona: Stop microphone detection if we give up on it

Markus Franke (1):
      w1: Add 1-wire slave device driver for DS28E04-100

Mel Gorman (1):
      stable: Allow merging of backports for serious user-visible performance issues

Ming Lei (1):
      driver core: fix shutdown races with probe/remove(v3)

MyungJoo Ham (1):
      MAINTAINERS: Add entries for extcon (external connector) subsystem.

NeilBrown (4):
      w1: introduce a slave mutex for serializing IO
      w1: omap_hdq: Fix some error/debug handling.
      w1: omap_hdq: use wait_event_timeout to wait for read to complete.
      W1: split master mutex to avoid deadlocks.

Otavio Salvador (1):
      w1: Fix a typo in 'hardware' word

Paul Gortmaker (1):
      stable: update references to older 2.6 versions for 3.x

Peter Meerwald (1):
      extcon: spelling of detach in function doc

Rabin Vincent (1):
      driver core: always handle dpm_order

Rafael J. Wysocki (1):
      PM / Runtime: Do not increment device usage counts before probing

Randy Dunlap (1):
      driver core: fix some kernel-doc warnings in dma*.c

Sebastian Ott (2):
      driver core: move uevent call to driver_register
      driver core: don't trigger uevent after failure

Vivek Goyal (1):
      printk: Export struct log size and member offsets through vmcoreinfo

 Documentation/ABI/stable/sysfs-driver-w1_ds28e04 |   15 +
 Documentation/ABI/testing/dev-kmsg               |   29 +-
 Documentation/stable_kernel_rules.txt            |   19 +-
 Documentation/w1/slaves/w1_ds28e04               |   36 +
 MAINTAINERS                                      |    8 +
 drivers/base/bus.c                               |    1 -
 drivers/base/core.c                              |   71 +-
 drivers/base/dd.c                                |   20 +-
 drivers/base/dma-buf.c                           |    1 +
 drivers/base/dma-coherent.c                      |    1 +
 drivers/base/driver.c                            |    6 +-
 drivers/base/firmware_class.c                    |    6 +-
 drivers/extcon/Kconfig                           |   18 +
 drivers/extcon/Makefile                          |    2 +
 drivers/extcon/extcon-arizona.c                  |  490 ++++++++++++++
 drivers/extcon/extcon-max77693.c                 |  779 ++++++++++++++++++++++
 drivers/extcon/extcon_class.c                    |    2 +-
 drivers/extcon/extcon_gpio.c                     |   17 +-
 drivers/hv/hyperv_vmbus.h                        |    2 +-
 drivers/power/ds2780_battery.c                   |   11 +-
 drivers/power/ds2781_battery.c                   |   12 +-
 drivers/w1/masters/ds1wm.c                       |    4 +
 drivers/w1/masters/omap_hdq.c                    |   30 +-
 drivers/w1/slaves/Kconfig                        |   13 +
 drivers/w1/slaves/Makefile                       |    1 +
 drivers/w1/slaves/w1_bq27000.c                   |    4 +-
 drivers/w1/slaves/w1_ds2408.c                    |   24 +-
 drivers/w1/slaves/w1_ds2423.c                    |    4 +-
 drivers/w1/slaves/w1_ds2431.c                    |    8 +-
 drivers/w1/slaves/w1_ds2433.c                    |    8 +-
 drivers/w1/slaves/w1_ds2760.c                    |    8 +-
 drivers/w1/slaves/w1_ds2780.c                    |   22 +-
 drivers/w1/slaves/w1_ds2780.h                    |    2 -
 drivers/w1/slaves/w1_ds2781.c                    |   22 +-
 drivers/w1/slaves/w1_ds2781.h                    |    2 -
 drivers/w1/slaves/w1_ds28e04.c                   |  469 +++++++++++++
 drivers/w1/slaves/w1_therm.c                     |   10 +-
 drivers/w1/w1.c                                  |   23 +-
 drivers/w1/w1.h                                  |    1 +
 drivers/w1/w1_family.h                           |    1 +
 drivers/w1/w1_int.c                              |    3 +-
 fs/debugfs/inode.c                               |    4 +-
 fs/sysfs/dir.c                                   |   10 +
 include/linux/device.h                           |    5 +
 include/linux/extcon/extcon_gpio.h               |    2 +-
 include/linux/genhd.h                            |    1 -
 kernel/printk.c                                  |  159 +++--
 47 files changed, 2159 insertions(+), 227 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-w1_ds28e04
 create mode 100644 Documentation/w1/slaves/w1_ds28e04
 create mode 100644 drivers/extcon/extcon-arizona.c
 create mode 100644 drivers/extcon/extcon-max77693.c
 create mode 100644 drivers/w1/slaves/w1_ds28e04.c
