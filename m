Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0LFWFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:22 -0500
Received: from mail.perches.com ([173.55.12.10]:2324 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0LFWFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:20 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/29] trivial: WARN cleanups
Date: Mon,  6 Dec 2010 14:04:50 -0800
Message-Id: <cover.1291670104.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri.

Resubmitting unapplied WARN cleanups originally sent October 30.
https://lkml.org/lkml/2010/10/30/176

All previously submitted to appropriate MAINTAINERS and mailing lists.
Not resending to those MAINTAINERS and mailing lists, just trivial.

Joe Perches (29):
  include/asm-generic/bug.h: Update WARN macros
  arch/alpha: Update WARN uses
  arch/arm: Update WARN uses
  arch/powerpc: Update WARN uses
  arch/x86: Update WARN uses
  drivers/acpi: Update WARN uses
  drivers/base: Update WARN uses
  drivers/block: Update WARN uses
  drivers/cpuidle: Update WARN uses
  drivers/firmware: Update WARN uses
  drivers/gpio: Update WARN uses
  drivers/net/wireless/iwlwifi: Update WARN uses
  drivers/scsi/fcoe: Update WARN uses
  drivers/usb/musb: Update WARN uses
  drivers/video/omap2/dss: Update WARN uses
  fs/nfsd: Update WARN uses
  fs/notify/inotify: Update WARN uses
  fs/sysfs: Update WARN uses
  fs/proc: Update WARN uses
  fs: Update WARN uses
  include/linux/device.h: Update WARN uses
  kernel/irq: Update WARN uses
  kernel/panic.c: Update warn_slowpath to use %pV
  kernel: Update WARN uses
  lib: Update WARN uses
  mm: Update WARN uses
  net/mac80211: Update WARN uses
  net/rfkill/input.c: Update WARN uses
  drivers/regulator: Update WARN uses

 arch/alpha/kernel/pci-sysfs.c               |   14 ++--
 arch/arm/mach-davinci/clock.c               |    4 +-
 arch/arm/mach-davinci/da830.c               |    2 +-
 arch/arm/mach-davinci/da850.c               |   12 ++--
 arch/arm/mach-omap2/clkt_clksel.c           |   12 ++--
 arch/arm/mach-omap2/clock.c                 |   16 ++--
 arch/arm/mach-omap2/devices.c               |    4 +-
 arch/arm/mach-omap2/omap_hwmod.c            |   47 ++++++++-----
 arch/arm/mach-omap2/pm34xx.c                |    7 +-
 arch/arm/mach-omap2/serial.c                |    2 +-
 arch/arm/mach-omap2/timer-gp.c              |    3 +-
 arch/arm/mach-tegra/clock.c                 |    3 +-
 arch/arm/mach-tegra/timer.c                 |    2 +-
 arch/arm/mach-u300/padmux.c                 |   14 +---
 arch/arm/plat-omap/omap-pm-noop.c           |   10 ++--
 arch/powerpc/kernel/hw_breakpoint.c         |    4 +-
 arch/x86/kernel/acpi/boot.c                 |    2 +-
 arch/x86/kernel/apic/apic.c                 |    2 +-
 arch/x86/kernel/apic/es7000_32.c            |    2 +-
 arch/x86/kernel/cpu/perf_event.c            |    4 +-
 arch/x86/kernel/pci-calgary_64.c            |    4 +-
 arch/x86/kernel/tsc_sync.c                  |    4 +-
 arch/x86/kernel/xsave.c                     |    2 +-
 arch/x86/mm/ioremap.c                       |    5 +-
 arch/x86/mm/pageattr-test.c                 |    2 +-
 arch/x86/mm/pageattr.c                      |    5 +-
 arch/x86/platform/sfi/sfi.c                 |    4 +-
 drivers/acpi/ec.c                           |    4 +-
 drivers/base/class.c                        |    4 +-
 drivers/base/core.c                         |    5 +-
 drivers/base/memory.c                       |    4 +-
 drivers/base/sys.c                          |   10 +--
 drivers/block/floppy.c                      |    2 +-
 drivers/cpuidle/driver.c                    |    2 +-
 drivers/firmware/dmi_scan.c                 |    2 +-
 drivers/gpio/gpiolib.c                      |    4 +-
 drivers/gpio/it8761e_gpio.c                 |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/regulator/core.c                    |    3 +-
 drivers/scsi/fcoe/libfcoe.c                 |    2 +-
 drivers/usb/musb/musb_host.c                |    6 +-
 drivers/video/omap2/dss/core.c              |    3 +-
 fs/bio.c                                    |    2 +-
 fs/buffer.c                                 |    2 +-
 fs/nfsd/nfs4state.c                         |    3 +-
 fs/notify/inotify/inotify_fsnotify.c        |    4 +-
 fs/proc/generic.c                           |    9 +--
 fs/super.c                                  |    5 +-
 fs/sysfs/dir.c                              |    3 +-
 fs/sysfs/file.c                             |    4 +-
 fs/sysfs/group.c                            |    4 +-
 fs/sysfs/symlink.c                          |   10 +--
 include/asm-generic/bug.h                   |  101 ++++++++++++++++-----------
 include/linux/device.h                      |    2 +-
 kernel/irq/chip.c                           |    2 +-
 kernel/irq/manage.c                         |    2 +-
 kernel/notifier.c                           |    2 +-
 kernel/panic.c                              |   40 +++++------
 kernel/pm_qos_params.c                      |    6 +-
 lib/debugobjects.c                          |   21 +++---
 lib/iomap.c                                 |    2 +-
 lib/kobject.c                               |    9 +--
 lib/kobject_uevent.c                        |    4 +-
 lib/list_debug.c                            |   24 +++----
 lib/plist.c                                 |   12 ++--
 mm/percpu.c                                 |    4 +-
 mm/vmalloc.c                                |    5 +-
 net/mac80211/agg-tx.c                       |    5 +-
 net/mac80211/iface.c                        |    4 +-
 net/mac80211/mlme.c                         |    2 +-
 net/mac80211/rx.c                           |    4 +-
 net/mac80211/tx.c                           |    4 +-
 net/mac80211/util.c                         |    4 +-
 net/mac80211/work.c                         |    4 +-
 net/rfkill/input.c                          |    5 +-
 78 files changed, 284 insertions(+), 292 deletions(-)

-- 
1.7.3.2.245.g03276.dirty

