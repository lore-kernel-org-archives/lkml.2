Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0HCOJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:09:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39596 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab0HCOI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:08:59 -0400
Date: Tue, 3 Aug 2010 15:08:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86 platform drivers for 2.6.36
Message-ID: <20100803140855.GA26161@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A huge number of cleanup patches from Axel Lin, who's ploughed through 
these drivers unstoppably. A few updates to Moorestown-specific code, 
various misc bugfixes, Jesse's IPS driver and a couple of functional 
improvements for some of the drivers.

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  
git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for-linus

Alan Cox (2):
      rar: Move the RAR driver into the right place as its now clean
      intel_scu_ipc: Use the new cpu identification function

Alek Du (1):
      gpio: Add PMIC GPIO block support

Andy Ross (1):
      Clean up command packing on MRST.

Arjan van de Ven (2):
      Fix stack buffer size for IPC writev messages
      zero the stack buffer before giving random garbage to the SCU

Axel Lin (34):
      intel_menlow: fix memory leaks in error path
      hp-wmi: add error handling for hp_wmi_init
      acer-wmi: fix resource reclaim in acer_wmi_init error path
      wmi: fix memory leak in parse_wdg
      acer-wmi/hp-wmi: use platform_device_unregister instead of platform_device_del in module_exit
      wmi: fix a memory leak in wmi_notify_debug
      asus-laptop: fix a memory leak in asus_laptop_get_info error path
      acer-wmi: set permissions on interface file to S_IRUGO
      acer-wmi: make dmi_matched to return 1 instead of 0
      dell-wmi: fix a memory leak
      sony-laptop: use platform_device_unregister in sony_pf_remove
      fujitsu-laptop: remove unnecessary input_free_device calls
      compal-laptop/fujitsu-laptop/msi-laptop: make dmi_check_cb to return 1 instead of 0
      asus_acpi: fix a memory leak in asus_hotk_get_info()
      asus_acpi: fix coding style to improve readability
      acerhdf: make needlessly global symbols static
      classmate-laptop: make needlessly global symbols static
      fujitsu-laptop: make needlessly global symbols static
      msi-laptop: make struct rfkill_ops const
      asus-laptop: fix incorrect return value for write_acpi_int_ret if handle is NULL
      asus-laptop: return proper error for store_ledd if write_acpi_int fail
      acerhdf: fix resource reclaim in error path
      toshiba_acpi: make remove_device() and add_device() void
      hp-wmi: add return value checking for input_allocate_device()
      toshiba_acpi: rename add_device() and remove_device() to create_toshiba_proc_entries() and remove_toshiba_proc_entries()
      acer-wmi: fix memory leaks in WMID_set_capabilities and get_wmid_devices
      acer-wmi: fix memory leaks in wmab_execute error path
      acer-wmi: remove non-used acer_quirks struct definition
      asus-laptop: fix wapf, wlan_status and bluetooth_status module_param permissions
      eeepc-laptop: fix hotplug_disabled module_param permissions
      panasonic-laptop: fix acpi_pcc_write_sset return value
      msi-wmi: make needlessly global symbols static
      asus-laptop: fix asus_input_init error path
      dell-laptop: make dell_laptop_i8042_filter() static

Feng Tang (1):
      intel_scu_ipc: add definitions for vRTC related command

Hong Liu (3):
      intel_scu_ipc: fix data packing of PMIC command on Moorestown
      intel_scu_ipc: return -EIO for error condition in busy_loop
      intel_scu_ipc: fix size field for intel_scu_ipc_command

Islam Amer (1):
      dell-wmi: Add support for eject key on Dell Studio 1555

Jan Engelhardt (1):
      x86 plat: limit x86 platform driver menu to X86

Jesse Barnes (3):
      timer: add on-stack deferrable timer interfaces
      x86 platform driver: intelligent power sharing driver
      IPS driver: add GPU busy and turbo checking

Jiri Slaby (1):
      X86: intel_ips, check for kzalloc properly

Julia Lawall (1):
      drivers/platform/x86: Eliminate a NULL pointer dereference

Matthew Garrett (1):
      toshiba-acpi: Add an extra couple of keys

Peter Feuerer (3):
      acerhdf: add new BIOS versions
      acerhdf: remove "chk_off" as it was only needed for T31 netbooks
      acerhdf: add AO531 and many BIOS versions for 1410, 1810xx and packard bell netbooks

Pierre Ducroquet (1):
      toshiba-acpi: Add support for Toshiba Illumination.

Rahul Chaturvedi (1):
      acerhdf: driver didn't verify the pointers in which it got product information

Randy Dunlap (3):
      platform/x86: msi-laptop depends on SERIO_I8042
      compal-laptop: uses hwmon interfaces, depends on HWMON
      compal-laptop: depends on POWER_SUPPLY

Rezwanul Kabir (1):
      dell-laptop: Add another Dell laptop family to the DMI whitelist

Roald Frederickx (1):
      compal-laptop: add JHL90, battery & hwmon interface

Sreedhara DS (4):
      intel_scu_ipc: detect CPU type automatically
      intel_scu_ipc: Support Medfield processors
      Remove indirect read write api support.
      intel_scu_ipc: tidy up unused bits

Thadeu Lima de Souza Cascardo (2):
      classmate-laptop: depends on RFKILL or RFKILL=n
      classmate-laptop: should check for NULL as retval for rfkill_alloc

Thomas Renninger (19):
      x86 platform drivers: hp-wmi Reorder event id processing
      x86 platform drivers: hp-wmi Catch and log unkown event and key codes correctly
      x86 platform drivers: hp-wmi Use consistent prefix string for messages.
      x86 platform drivers: hp-wmi Add media key 0x20e8
      x86 platform drivers: hp-wmi Set placeholder for unimplemented events
      x86 platform drivers: hp-wmi fix buffer size depending on ACPI version
      X86 platform: hp-wmi Better match the HP WMI query interface
      hp-wmi: return -ENODEV if BIOS does not export any supported hp wmi guid
      ACPI: Remove /proc/acpi/embedded_controller/..
      X86 platform drivers: Remove EC dump from thinkpad_acpi
      X86 platform driver: Fix section mismatch in wmi.c
      Documentation: Add new /sys/kernel/debug/ec/* files to ABI
      ACPI: Provide /sys/kernel/debug/ec/...
      ACPI: Provide /sys/kernel/debug//ec/ec0/io for binary access to the EC
      ACPI: Register EC io ports in /proc/ioports
      hp-wmi: Fix mixing up of and/or directive
      hp-wmi: acpi_drivers.h is already included through acpi.h two lines below
      acpi ec: Fix possible double io port registration
      acpi ec_sys: Be more cautious about ec write access

 Documentation/ABI/testing/debugfs-ec               |   20 +
 Documentation/laptops/thinkpad-acpi.txt            |   71 +-
 arch/x86/include/asm/intel_scu_ipc.h               |   20 +-
 drivers/acpi/Kconfig                               |   18 +
 drivers/acpi/Makefile                              |    1 +
 drivers/acpi/ec.c                                  |  107 +--
 drivers/acpi/ec_sys.c                              |  160 ++
 drivers/acpi/internal.h                            |   24 +
 drivers/platform/x86/Kconfig                       |   44 +
 drivers/platform/x86/Makefile                      |    4 +
 drivers/platform/x86/acer-wmi.c                    |   79 +-
 drivers/platform/x86/acerhdf.c                     |  151 ++-
 drivers/platform/x86/asus-laptop.c                 |   29 +-
 drivers/platform/x86/asus_acpi.c                   |    7 +-
 drivers/platform/x86/classmate-laptop.c            |   13 +-
 drivers/platform/x86/compal-laptop.c               |  929 ++++++++++--
 drivers/platform/x86/dell-laptop.c                 |    9 +-
 drivers/platform/x86/dell-wmi.c                    |   11 +-
 drivers/platform/x86/eeepc-laptop.c                |    2 +-
 drivers/platform/x86/fujitsu-laptop.c              |   16 +-
 drivers/platform/x86/hp-wmi.c                      |  281 +++-
 drivers/platform/x86/intel_ips.c                   | 1660 ++++++++++++++++++++
 drivers/platform/x86/intel_menlow.c                |   33 +-
 drivers/platform/x86/intel_pmic_gpio.c             |  340 ++++
 .../x86/intel_rar_register.c}                      |    8 +-
 drivers/platform/x86/intel_scu_ipc.c               |  180 +--
 drivers/platform/x86/msi-laptop.c                  |    8 +-
 drivers/platform/x86/msi-wmi.c                     |    2 +-
 drivers/platform/x86/panasonic-laptop.c            |    7 +-
 drivers/platform/x86/sony-laptop.c                 |   13 +-
 drivers/platform/x86/thinkpad_acpi.c               |   73 -
 drivers/platform/x86/toshiba_acpi.c                |  135 ++-
 drivers/platform/x86/wmi.c                         |   28 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/memrar/memrar_handler.c            |    3 +-
 drivers/staging/rar_register/Kconfig               |   30 -
 drivers/staging/rar_register/Makefile              |    2 -
 include/drm/i915_drm.h                             |    9 +
 include/linux/intel_pmic_gpio.h                    |   15 +
 .../rar_register => include/linux}/rar_register.h  |    0
 include/linux/timer.h                              |   15 +
 kernel/timer.c                                     |   13 +
 43 files changed, 3830 insertions(+), 743 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-ec
 create mode 100644 drivers/acpi/ec_sys.c
 create mode 100644 drivers/platform/x86/intel_ips.c
 create mode 100644 drivers/platform/x86/intel_pmic_gpio.c
 rename drivers/{staging/rar_register/rar_register.c => platform/x86/intel_rar_register.c} (99%)
 delete mode 100644 drivers/staging/rar_register/Kconfig
 delete mode 100644 drivers/staging/rar_register/Makefile
 create mode 100644 include/linux/intel_pmic_gpio.h
 rename {drivers/staging/rar_register => include/linux}/rar_register.h (100%)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
