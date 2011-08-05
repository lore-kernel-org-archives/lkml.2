Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab1HETef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 15:34:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43590 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab1HETeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 15:34:31 -0400
Date: Fri, 5 Aug 2011 20:34:27 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86 platform driver updates
Message-ID: <20110805193427.GA24146@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Various cleanups from Axel, a pile of patches for the asus and acer 
drivers and a few odds and ends. Most of this has been baking in next 
for a while, and the newer stuff is Obviously Correct(tm).

The following changes since commit de96355c111679dd6e2c5c73e25e814c72510c58:

  Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-08-05 06:44:38 -1000)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Andy Lutomirski (1):
      Add KEY_MICMUTE and enable it on Lenovo X220

Anton V. Boyarshinov (1):
      acerhdf.c: spaces in aliased changed to *

Axel Lin (8):
      platform-drivers-x86: dell-laptop: Remove unneeded mutex_init() for buffer_mutex
      platform-drivers-x86: msi-wmi: add missing sparse_keymap_free in msi_wmi_init error path
      platform-drivers-x86: intel_mid_thermal: fix memory leak
      platform-drivers-x86: intel_menlow: add missing return AE_OK for intel_menlow_register_sensor()
      platform-drivers-x86: intel_rar_register: convert to DEFINE_PCI_DEVICE_TABLE
      platform-drivers-x86: intel_scu_ipc: convert to DEFINE_PCI_DEVICE_TABLE
      platform-drivers-x86: samsung-q10: make dmi_check_callback return 1
      platform-drivers-x86: ideapad-laptop: add missing ideapad_input_exit in ideapad_acpi_add error path

Corentin Chary (12):
      asus-wmi: fix hwmon/pwm1
      asus-wmi: second part of the version starts at 16 not 8
      asus-wmi: add keyboard backlight support
      asus-wmi: fix section mismatch
      asus-wmi: fix keyboard backlight detection
      asus-wmi: add some device ids
      asus-wmi: add thermal sensor
      asus-wmi: check for temp1 presence
      asus-wmi: return proper value in store_cpufv()
      asus-wmi: add CWAP support and clarify the meaning of WAPF bits
      asus-wmi: add gps rfkill support
      asus-wmi: add uwb rfkill support

Frederick van der Wyck (1):
      Platform: Samsung Q10 backlight driver

Ike Panhc (3):
      ideapad: define cfg bits and create sysfs node for cfg
      ideapad: let camera_power node invisiable if no camera
      ideapad: add backlight driver

J Witteveen (1):
      Samsung Laptop platform driver: support N510

Jesse Barnes (1):
      x86 driver: fix typo in TDP override enabling

Julien Valroff (1):
      acerhdf: add support for Aspire 1810TZ BIOS v1.3314

Lee, Chun-Yi (3):
      acer-wmi: schedule threeg and interface sysfs for feature removal
      msi-laptop: add MSI U270 netbook to module alias and scm list
      acer-wmi: support Lenovo ideapad S205 wifi switch

Seth Forshee (5):
      acer-wmi: Add support for Aspire 1830 wlan hotkey
      asus-wmi: Add callback for hotkey filtering
      eeepc-wmi: Add support for T101MT Home/Express Gate key
      asus-wmi: Enable autorepeat for hotkey input device
      dell-wmi: Add keys for Dell XPS L502X

Thomas Courbon (1):
      Platform: fix samsung-laptop DMI identification for N150/N210/220/N230

 .../ABI/testing/sysfs-platform-ideapad-laptop      |   17 ++
 Documentation/feature-removal-schedule.txt         |   11 +
 drivers/platform/x86/Kconfig                       |    8 +
 drivers/platform/x86/Makefile                      |    1 +
 drivers/platform/x86/acer-wmi.c                    |   40 +++-
 drivers/platform/x86/acerhdf.c                     |   13 +-
 drivers/platform/x86/asus-laptop.c                 |    9 +-
 drivers/platform/x86/asus-nb-wmi.c                 |   27 ++-
 drivers/platform/x86/asus-wmi.c                    |  239 +++++++++++++++++---
 drivers/platform/x86/asus-wmi.h                    |    7 +
 drivers/platform/x86/dell-laptop.c                 |    1 -
 drivers/platform/x86/dell-wmi.c                    |   10 +
 drivers/platform/x86/eeepc-wmi.c                   |   27 +++
 drivers/platform/x86/ideapad-laptop.c              |  195 ++++++++++++++--
 drivers/platform/x86/intel_ips.c                   |    4 +-
 drivers/platform/x86/intel_menlow.c                |    2 +
 drivers/platform/x86/intel_mid_thermal.c           |   26 ++-
 drivers/platform/x86/intel_rar_register.c          |    4 +-
 drivers/platform/x86/intel_scu_ipc.c               |    2 +-
 drivers/platform/x86/msi-laptop.c                  |   10 +
 drivers/platform/x86/msi-wmi.c                     |    1 +
 drivers/platform/x86/samsung-laptop.c              |   20 ++
 drivers/platform/x86/samsung-q10.c                 |  196 ++++++++++++++++
 drivers/platform/x86/thinkpad_acpi.c               |   11 +-
 include/linux/input.h                              |    2 +
 25 files changed, 799 insertions(+), 84 deletions(-)
 create mode 100644 drivers/platform/x86/samsung-q10.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org
