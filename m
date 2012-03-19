Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032789Ab2CSTzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:55:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47234 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030416Ab2CSTzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:55:00 -0400
Date: Mon, 19 Mar 2012 12:54:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 3.4-rc1
Message-ID: <20120319195456.GB9883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

  Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.3

for you to fetch changes up to adc80ae60eae24a43a357bf5b30fb496f34aa605:

  Tools: hv: Support enumeration from all the pools (2012-03-16 13:36:04 -0700)

----------------------------------------------------------------
driver core merge for 3.4-rc1

Here's the big driver core merge for 3.4-rc1.

Lots of various things here, sysfs fixes/tweaks (with the nlink breakage
reverted), dynamic debugging updates, w1 drivers, hyperv driver updates,
and a variety of other bits and pieces, full information in the
shortlog.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      cpufreq/gx: Fix the compile error

Alan Stern (6):
      Driver core: driver_find() drops reference before returning
      Dynamic ID addition doesn't need get_driver()
      Remove useless get_driver()/put_driver() calls
      Eliminate get_driver() and put_driver()
      USB/PCI/PCMCIA: Clean up new_id and remove_id sysfs attribute routines
      PCI/XEN: Fix bug introduced by a recent change

Andi Kleen (8):
      Add driver auto probing for x86 features v4
      crypto: Add support for x86 cpuid auto loading for x86 crypto drivers
      intel-idle: convert to x86_cpu_id auto probing
      ACPI: Load acpi-cpufreq from processor driver automatically
      HWMON: Convert via-cputemp to x86 cpuid autoprobing
      HWMON: Convert coretemp to x86 cpuid autoprobing
      cpufreq: Add support for x86 cpuinfo auto loading v4
      x86: autoload microcode driver on Intel and AMD systems v2

Andrew Vagin (1):
      uevent: send events in correct order according to seqnum (v3)

Ben Hutchings (6):
      x86/cpu: Fix overrun check in arch_print_cpu_modalias()
      x86/cpu: Clean up modalias feature matching
      intel_idle: Fix ID for Nehalem-EX Xeon in device ID table
      powernow-k7: Fix CPU family number
      powernow-k6: Really enable auto-loading
      intel_idle: Revert change of auto_demotion_disable_flags for Nehalem

Eric W. Biederman (5):
      sysfs: Add s_hash to sysfs_dirent and order directory entries by hash
      sysfs: Reduce s_flags to an unsinged short so it packs well with s_mode
      sysfs: Store the sysfs inode in an unsigned int.
      sysfs: Kill nlink counting.
      sysfs: Update the name hash when renaming sysfs entries

Grant Likely (1):
      drivercore: Add driver probe deferral mechanism

Greg Kroah-Hartman (8):
      Merge 3.3-rc2 into the driver-core-next branch.
      PCI: Add helper macro for pci_register_driver boilerplate
      DWC3: use module_pci_driver
      driver-core: documentation: fix up Greg's email address
      driver core: move the deferred probe pointer into the private area
      driver core: minor comment formatting cleanups
      Revert "sysfs: Kill nlink counting."
      Merge 3.3-rc6 into driver-core-next

Jim Cromie (16):
      dynamic_debug: fix whitespace complaints from scripts/cleanfile
      dynamic_debug: drop enabled field from struct _ddebug, use _DPRINTK_FLAGS_PRINT
      dynamic_debug: make dynamic-debug supersede DEBUG ccflag
      dynamic_debug: change verbosity at runtime
      dynamic_debug: replace strcpy with strlcpy, in ddebug_setup_query()
      dynamic_debug: pr_err() call should not depend upon verbosity
      dynamic_debug: drop explicit !=NULL checks
      dynamic_debug: describe_flags with '=[pmflt_]*'
      dynamic_debug: tighten up error checking on debug queries
      dynamic_debug: early return if _ddebug table is empty
      dynamic_debug: reduce lineno field to a saner 18 bits
      dynamic_debug: chop off comments in ddebug_tokenize
      dynamic_debug: enlarge command/query write buffer
      dynamic_debug: add trim_prefix() to provide source-root relative paths
      dynamic_debug: factor vpr_info_dq out of ddebug_parse_query
      dynamic_debug: process multiple debug-queries on a line

Jonghwan Choi (1):
      driver-core: Fix possible null reference in subsys_interface_unregister

K. Y. Srinivasan (11):
      drivers: hv: Get rid of some unnecessary code
      drivers: hv: kvp: Add/cleanup connector defines
      drivers: hv: kvp: Move the contents of hv_kvp.h to hyperv.h
      drivers: hv: Cleanup the kvp related state in hyperv.h
      tools: hv: Use hyperv.h to get the KVP definitions
      drivers: hv: kvp: Cleanup the kernel/user protocol
      drivers: hv: Increase the number of VCPUs supported in the guest
      Drivers: hv: Add new message types to enhance KVP
      Drivers: hv: Support the newly introduced KVP messages in the driver
      Tools: hv: Fully support the new KVP verbs in the user level daemon
      Tools: hv: Support enumeration from all the pools

Lee Jones (2):
      drivers/base: add bus for System-on-Chip devices
      Documentation: add information for new sysfs soc bus functionality

Ludwig Nussel (1):
      debugfs: add mode, uid and gid options

Mark Brown (2):
      w1: Use linux/gpio.h rather than asm/gpio.h
      regulator: Support driver probe deferral

Masami Ichikawa (1):
      sysfs: Fix memory leak in sysfs_sd_setsecdata().

NeilBrown (4):
      w1: Fix w1_bq27000
      w1_bq27000: remove unnecessary NULL test.
      w1_bq27000 - remove w1_bq27000_write
      w1_bq27000: Only one thread can access the bq27000 at a time.

Renata Sayakhova (1):
      DS2781 Maxim Stand-Alone Fuel Gauge battery and w1 slave drivers

Sebastian Ott (1):
      cio: remove {get,put}_driver

Thomas Renninger (2):
      X86: Introduce HW-Pstate scattered cpuid feature
      CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86 parts

Vitaly Kuznetsov (1):
      sysfs: change permissions for /sys from 0755 to 0555

Yinghai Lu (1):
      ACPI: remove duplicated lines of merging problems with acpi_processor_start

 Documentation/ABI/removed/devfs                    |    2 +-
 Documentation/ABI/stable/sysfs-driver-usb-usbtmc   |   10 +-
 Documentation/ABI/testing/sysfs-class              |    2 +-
 Documentation/ABI/testing/sysfs-devices            |    2 +-
 Documentation/ABI/testing/sysfs-devices-soc        |   58 ++
 .../ABI/testing/sysfs-driver-samsung-laptop        |    2 +-
 Documentation/dynamic-debug-howto.txt              |   30 +-
 Documentation/filesystems/debugfs.txt              |    5 +-
 Documentation/ioctl/ioctl-number.txt               |    2 +-
 Documentation/ko_KR/HOWTO                          |    2 +-
 Documentation/kobject.txt                          |    2 +-
 Documentation/zh_CN/HOWTO                          |    2 +-
 arch/x86/Kconfig                                   |    3 +
 arch/x86/crypto/aesni-intel_glue.c                 |   12 +-
 arch/x86/crypto/crc32c-intel.c                     |   11 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c         |   12 +-
 arch/x86/include/asm/cpu_device_id.h               |   13 +
 arch/x86/include/asm/cpufeature.h                  |    1 +
 arch/x86/kernel/cpu/Makefile                       |    1 +
 arch/x86/kernel/cpu/match.c                        |   91 ++
 arch/x86/kernel/cpu/scattered.c                    |    1 +
 arch/x86/kernel/microcode_core.c                   |   15 +
 drivers/acpi/processor_driver.c                    |    1 +
 drivers/acpi/processor_perflib.c                   |   22 +
 drivers/base/Kconfig                               |    3 +
 drivers/base/Makefile                              |    1 +
 drivers/base/base.h                                |    6 +
 drivers/base/bus.c                                 |    6 +-
 drivers/base/core.c                                |    2 +
 drivers/base/cpu.c                                 |   11 +
 drivers/base/dd.c                                  |  148 +++-
 drivers/base/driver.c                              |   35 +-
 drivers/base/soc.c                                 |  183 ++++
 drivers/cpufreq/cpufreq-nforce2.c                  |    8 +
 drivers/cpufreq/e_powersaver.c                     |   20 +-
 drivers/cpufreq/elanfreq.c                         |   14 +-
 drivers/cpufreq/gx-suspmod.c                       |    9 +-
 drivers/cpufreq/longhaul.c                         |    8 +-
 drivers/cpufreq/longrun.c                          |   13 +-
 drivers/cpufreq/p4-clockmod.c                      |   17 +-
 drivers/cpufreq/powernow-k6.c                      |   12 +-
 drivers/cpufreq/powernow-k7.c                      |   14 +-
 drivers/cpufreq/powernow-k8.c                      |   19 +-
 drivers/cpufreq/sc520_freq.c                       |   14 +-
 drivers/cpufreq/speedstep-centrino.c               |   24 +-
 drivers/cpufreq/speedstep-ich.c                    |   15 +
 drivers/cpufreq/speedstep-lib.c                    |    1 +
 drivers/cpufreq/speedstep-smi.c                    |   15 +
 drivers/crypto/padlock-aes.c                       |    9 +-
 drivers/crypto/padlock-sha.c                       |   16 +-
 drivers/hid/hid-core.c                             |    6 +-
 drivers/hv/channel_mgmt.c                          |   87 --
 drivers/hv/hv.c                                    |    4 +-
 drivers/hv/hv_kvp.c                                |  253 ++++--
 drivers/hv/hv_kvp.h                                |  184 -----
 drivers/hv/hv_util.c                               |    3 -
 drivers/hv/hyperv_vmbus.h                          |    5 +-
 drivers/hwmon/coretemp.c                           |   17 +-
 drivers/hwmon/via-cputemp.c                        |   16 +-
 drivers/idle/intel_idle.c                          |  112 +--
 drivers/input/gameport/gameport.c                  |    1 -
 drivers/input/serio/serio.c                        |    1 -
 drivers/media/video/cx18/cx18-alsa-main.c          |    1 -
 drivers/media/video/ivtv/ivtvfb.c                  |    2 -
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |    5 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    1 -
 drivers/net/phy/phy_device.c                       |    6 +-
 drivers/pci/pci-driver.c                           |   52 +-
 drivers/pci/xen-pcifront.c                         |    3 +-
 drivers/pcmcia/ds.c                                |   11 +-
 drivers/power/Kconfig                              |   14 +
 drivers/power/Makefile                             |    1 +
 drivers/power/ds2781_battery.c                     |  874 ++++++++++++++++++++
 drivers/regulator/core.c                           |    4 +-
 drivers/s390/cio/ccwgroup.c                        |    2 -
 drivers/s390/cio/device.c                          |    8 +-
 drivers/s390/net/smsgiucv_app.c                    |    9 +-
 drivers/ssb/main.c                                 |   20 +-
 drivers/usb/core/driver.c                          |   66 +-
 drivers/usb/dwc3/dwc3-pci.c                        |   12 +-
 drivers/w1/masters/w1-gpio.c                       |    3 +-
 drivers/w1/slaves/Kconfig                          |   13 +
 drivers/w1/slaves/Makefile                         |    1 +
 drivers/w1/slaves/w1_bq27000.c                     |   36 +-
 drivers/w1/slaves/w1_ds2781.c                      |  201 +++++
 drivers/w1/slaves/w1_ds2781.h                      |  136 +++
 drivers/w1/w1_family.h                             |    1 +
 fs/debugfs/inode.c                                 |  149 +++-
 fs/sysfs/dir.c                                     |  224 ++---
 fs/sysfs/inode.c                                   |   11 +-
 fs/sysfs/mount.c                                   |    2 +-
 fs/sysfs/sysfs.h                                   |   17 +-
 include/acpi/processor.h                           |    1 +
 include/linux/connector.h                          |    1 +
 include/linux/cpu.h                                |    7 +
 include/linux/device.h                             |   10 +-
 include/linux/dynamic_debug.h                      |   19 +-
 include/linux/errno.h                              |    1 +
 include/linux/hyperv.h                             |  173 ++++
 include/linux/mod_devicetable.h                    |   21 +
 include/linux/netdevice.h                          |    8 +-
 include/linux/pci.h                                |   13 +
 include/linux/printk.h                             |    8 +-
 include/linux/sys_soc.h                            |   37 +
 lib/dma-debug.c                                    |    3 +-
 lib/dynamic_debug.c                                |  270 ++++--
 lib/kobject_uevent.c                               |   19 +-
 scripts/mod/file2alias.c                           |   25 +
 tools/hv/hv_kvp_daemon.c                           |  458 ++++++++--
 109 files changed, 3568 insertions(+), 1005 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-soc
 create mode 100644 arch/x86/include/asm/cpu_device_id.h
 create mode 100644 arch/x86/kernel/cpu/match.c
 create mode 100644 drivers/base/soc.c
 delete mode 100644 drivers/hv/hv_kvp.h
 create mode 100644 drivers/power/ds2781_battery.c
 create mode 100644 drivers/w1/slaves/w1_ds2781.c
 create mode 100644 drivers/w1/slaves/w1_ds2781.h
 create mode 100644 include/linux/sys_soc.h
