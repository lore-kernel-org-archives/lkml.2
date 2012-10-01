Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2JAS1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:27:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52012 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab2JAS1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:27:48 -0400
X-Sasl-enc: pmWV8Kp8RIhF01ia+q9hw1kmDEn2oJr8hhHmDXIc9gzT 1349116067
Date: Mon, 1 Oct 2012 11:27:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.7-rc1
Message-ID: <20121001182746.GA12041@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.6

for you to fetch changes up to e0f21e6d52cc245e7d4f7e02ca4b7b6571660ec2:

  memory: tegra{20,30}-mc: Fix reading incorrect register in mc_readl() (2012-09-26 14:04:09 -0700)

----------------------------------------------------------------
Driver core merge for 3.7-rc1

Here is the big driver core update for 3.7-rc1.

A number of firmware_class.c updates (as you saw a month or so ago), and
some hyper-v updates and some printk fixes as well.  All patches that
are outside of the drivers/base area have been acked by the respective
maintainers, and have all been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aneesh V (1):
      memory: emif: add device tree support to emif driver

Axel Lin (2):
      memory: emif: Add ifdef CONFIG_DEBUG_FS guard for emif_debugfs_[init|exit]
      memory: tegra{20,30}-mc: Fix reading incorrect register in mc_readl()

Ben Hutchings (4):
      tools/hv: Fix file handle leak
      tools/hv: Fix exit() error code
      tools/hv: Check for read/write errors
      tools/hv: Parse /etc/os-release

Chris Wright (1):
      debugfs: make __create_file static

Fengguang Wu (1):
      extcon: use IRQF_ONESHOT

Greg Kroah-Hartman (6):
      Revert "Extcon: adc_jack: adc-jack driver to support 3.5 pi or simliar devices"
      Merge 3.6-rc3 into driver-core-next
      xtensa: remove duplicate CONFIG_HOTPLUG definition
      tile: remove duplicate CONFIG_HOTPLUG definition
      CONFIG_HOTPLUG should be always on
      Merge 3.6-rc7 into driver-core-next

Hiroshi Doyu (1):
      driver-core: Shut up dev_dbg_reatelimited() without DEBUG

Jason Wang (2):
      hv: fail the probing immediately when we are not in hyperv platform
      hv: vmbus_drv: detect hyperv through x86_hyper

Jean Delvare (1):
      platform: Add support for automatic device IDs

Joe Perches (6):
      dev_dbg/dynamic_debug: Update to use printk_emit, optimize stack
      netdev_printk/dynamic_netdev_dbg: Directly call printk_emit
      netdev_printk/netif_printk: Remove a superfluous logging colon
      dev: Add dev_vprintk_emit and dev_printk_emit
      device and dynamic_debug: Use dev_vprintk_emit and dev_printk_emit
      device.h: Add missing inline to #ifndef CONFIG_PRINTK dev_vprintk_emit

K. Y. Srinivasan (23):
      Drivers: hv: Cleanup the guest ID computation
      Drivers: hv: vmbus: Use the standard format string to format GUIDs
      Drivers: hv: Add KVP definitions for IP address injection
      Drivers: hv: kvp: Cleanup error handling in KVP
      Drivers: hv: Explicitly size elements of protocol structures
      Drivers: hv: kvp: Support the new IP injection messages
      Tools: hv: Prepare to expand kvp_get_ip_address() functionality
      Tools: hv: Further refactor kvp_get_ip_address()
      Tools: hv: Gather address family information
      Tools: hv: Gather subnet information
      Tools: hv: Represent the ipv6 mask using CIDR notation
      Tools: hv: Gather ipv[4,6] gateway information
      Tools: hv: Get rid of some unused variables
      Tools: hv: Correctly type string variables
      Tools: hv: Add an example script to retrieve DNS entries
      Tools: hv: Gather DNS information
      Drivers: hv: kvp: Copy the address family information
      Tools: hv: Add an example script to retrieve dhcp state
      Tools: hv: Gather DHCP information
      Tools: hv: Add an example script to configure an interface
      Tools: hv: Implement the KVP verb - KVP_OP_SET_IP_INFO
      Tools: hv: Rename the function kvp_get_ip_address()
      Tools: hv: Implement the KVP verb - KVP_OP_GET_IP_INFO

Kees Cook (1):
      debugfs: more tightly restrict default mount mode

Khalid Aziz (1):
      firmware: Add missing attributes to EFI variable attribute print out from sysfs

Mark Brown (3):
      extcon: arizona: Implement button detection support
      extcon: Ensure dynamically allocated sysfs attributes are initialised
      extcon: arizona: Free MICDET IRQ on error during probe

Ming Lei (22):
      driver core: free devres in device_release
      firmware loader: simplify pages ownership transfer
      firmware loader: fix races during loading firmware
      firmware loader: remove unnecessary wmb()
      firmware loader: fix creation failure of fw loader device
      firmware loader: introduce firmware_buf
      firmware loader: always let firmware_buf own the pages buffer
      firmware loader: introduce cache_firmware and uncache_firmware
      firmware loader: fix device lifetime
      firmware loader: fix comments on request_firmware_nowait
      firmware loader: store firmware name into devres list
      driver core: devres: introduce devres_for_each_res
      firmware: introduce device_cache/uncache_fw_images
      firmware loader: use small timeout for cache device firmware
      firmware loader: cache devices firmware during suspend/resume cycle
      firmware loader: fix compile failure if !PM
      PM / Sleep: introduce dpm_for_each_dev
      firmware loader: fix build failure if FW_LOADER is m
      firmware loader: fix firmware -ENOENT situations
      firmware loader: let caching firmware piggyback on loading firmware
      MAINTAINERS: update maintain status of FIRMWARE LOADER
      firmware loader: fix compile warning when CONFIG_PM=n

MyungJoo Ham (1):
      Extcon: renamed files to comply with the standard naming.

Ninja Tekkaman (4):
      Chinese translation of Documentation/gpio.txt
      Documentation: Chinese translation of Documentation/filesystems/sysfs.txt
      Documentation: Chinese translation of Documentation/video4linux/v4l2-framework.txt
      Documentation: Chinese translation of Documentation/arm/Booting

Peter Meerwald (4):
      extcon: fix typos in sys-class-extcon
      extcon: fix typos in max77693 driver
      extcon: fix typos in extcon-arizona
      extcon: fixing typos

Peter Ujfalusi (1):
      driver core: Check if r->name is valid in platform_get_resource_byname()

Randy Dunlap (1):
      extcon: extcon-arizona depends on INPUT

Robert P. J. Day (2):
      Documentation: Fix "struct kobj_type" to include newer members.
      sysfs: Fix comment typo "sysf_create_link".

Stephen Warren (1):
      memory: fix build when CONFIG_OF && !CONFIG_DDR

Tekkaman Ninja (3):
      Documentation: Chinese translation of Documentation/video4linux/omap3isp.txt
      Documentation: Remove 3 byte redundant code at the head of the Documentation/zh_CN/arm/booting
      Documentation: Fixes some translation error in Documentation/zh_CN/gpio.txt

Wei Yongjun (2):
      vme: vme_tsi148.c: fix to use list_for_each_safe() when delete list items
      vme: vme_ca91cx42.c: use list_for_each_safe() when delete list items

anish kumar (2):
      Extcon: adc_jack: adc-jack driver to support 3.5 pi or simliar devices
      extcon: adc_jack: adc-jack driver to support 3.5 pi or simliar devices

liang xie (1):
      Document:add Chinese translation of basic_profiling.txt

 Documentation/ABI/testing/sysfs-class-extcon       |   22 +-
 Documentation/filesystems/debugfs.txt              |    4 +-
 Documentation/kobject.txt                          |    6 +-
 Documentation/zh_CN/arm/Booting                    |  175 ++++++++++
 Documentation/zh_CN/basic_profiling.txt            |   71 ++++
 Documentation/zh_CN/filesystems/sysfs.txt          |  372 +++++++++++++++++++++
 Documentation/zh_CN/gpio.txt                       |  658 +++++++++++++++++++++++++++++++++++++
 Documentation/zh_CN/video4linux/omap3isp.txt       |  277 ++++++++++++++++
 Documentation/zh_CN/video4linux/v4l2-framework.txt |  983 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 MAINTAINERS                                        |    4 +-
 arch/tile/Kconfig                                  |    8 -
 arch/xtensa/Kconfig                                |   18 --
 drivers/base/core.c                                |  105 +++---
 drivers/base/devres.c                              |   42 +++
 drivers/base/firmware_class.c                      |  838 +++++++++++++++++++++++++++++++++++++++++------
 drivers/base/platform.c                            |   41 ++-
 drivers/base/power/main.c                          |   22 ++
 drivers/extcon/Kconfig                             |    8 +-
 drivers/extcon/Makefile                            |    5 +-
 drivers/extcon/extcon-adc-jack.c                   |  198 ++++++++++++
 drivers/extcon/extcon-arizona.c                    |   78 ++++-
 drivers/extcon/{extcon_class.c => extcon-class.c}  |   12 +-
 drivers/extcon/{extcon_gpio.c => extcon-gpio.c}    |    0
 drivers/extcon/extcon-max77693.c                   |    8 +-
 drivers/firmware/efivars.c                         |   17 +-
 drivers/hv/hv.c                                    |   34 +-
 drivers/hv/hv_kvp.c                                |  253 +++++++++++++--
 drivers/hv/hv_util.c                               |    4 +-
 drivers/hv/hyperv_vmbus.h                          |   47 ++-
 drivers/hv/vmbus_drv.c                             |   42 +--
 drivers/memory/Makefile                            |    3 +
 drivers/memory/emif.c                              |  205 +++++++++++-
 drivers/memory/of_memory.c                         |  153 +++++++++
 drivers/memory/of_memory.h                         |   36 +++
 drivers/memory/tegra20-mc.c                        |   10 +-
 drivers/memory/tegra30-mc.c                        |   22 +-
 drivers/vme/bridges/vme_ca91cx42.c                 |   20 +-
 drivers/vme/bridges/vme_tsi148.c                   |   10 +-
 fs/debugfs/inode.c                                 |    8 +-
 fs/sysfs/symlink.c                                 |    2 +-
 include/linux/device.h                             |   85 +++--
 include/linux/extcon.h                             |   18 +-
 include/linux/extcon/extcon-adc-jack.h             |   71 ++++
 include/linux/firmware.h                           |   15 +
 include/linux/hyperv.h                             |  101 +++++-
 include/linux/netdevice.h                          |    3 -
 include/linux/platform_device.h                    |    4 +
 include/linux/pm.h                                 |    5 +
 init/Kconfig                                       |    8 +-
 lib/dynamic_debug.c                                |   56 +++-
 net/core/dev.c                                     |   20 +-
 tools/hv/hv_get_dhcp_info.sh                       |   28 ++
 tools/hv/hv_get_dns_info.sh                        |   13 +
 tools/hv/hv_kvp_daemon.c                           | 1036 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 tools/hv/hv_set_ifconfig.sh                        |   68 ++++
 55 files changed, 5807 insertions(+), 545 deletions(-)
 create mode 100644 Documentation/zh_CN/arm/Booting
 create mode 100644 Documentation/zh_CN/basic_profiling.txt
 create mode 100644 Documentation/zh_CN/filesystems/sysfs.txt
 create mode 100644 Documentation/zh_CN/gpio.txt
 create mode 100644 Documentation/zh_CN/video4linux/omap3isp.txt
 create mode 100644 Documentation/zh_CN/video4linux/v4l2-framework.txt
 create mode 100644 drivers/extcon/extcon-adc-jack.c
 rename drivers/extcon/{extcon_class.c => extcon-class.c} (98%)
 rename drivers/extcon/{extcon_gpio.c => extcon-gpio.c} (100%)
 create mode 100644 drivers/memory/of_memory.c
 create mode 100644 drivers/memory/of_memory.h
 create mode 100644 include/linux/extcon/extcon-adc-jack.h
 create mode 100755 tools/hv/hv_get_dhcp_info.sh
 create mode 100755 tools/hv/hv_get_dns_info.sh
 create mode 100755 tools/hv/hv_set_ifconfig.sh
