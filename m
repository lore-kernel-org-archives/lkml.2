Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0JYNSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 09:18:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56159 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0JYNR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 09:17:59 -0400
Date: Mon, 25 Oct 2010 14:17:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] x86 platform drivers for 2.6.37
Message-ID: <20101025131749.GA15662@srcf.ucam.org>
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

Nothing hugely exciting here - some cleanups, a pile of bugfixes in the 
WMI code and an update of the ideapad driver so it works on a wider 
range of hardware. The IBM SMI-disabling driver might prove to be 
interesting to some, though.

The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Alan Cox (1):
      scu_ipc: Fix warning caused by include changes

Alek Du (1):
      intel_pmic_gpio: swap the bits and mask args for intel_scu_ipc_update_register

Andy Shevchenko (1):
      platform: x86: throw away custom methods

Axel Lin (1):
      intel_pmic_gpio: fix off-by-one value range checking

Chris Bagwell (2):
      eeepc-wmi: add additional hotkeys
      eeepc-wmi: Add cpufv sysfs interface

Corentin Chary (3):
      platform-x86: sync eeepc-laptop and asus-laptop
      asus-laptop: Add key found on Asus N61JQ
      asus-laptop: fix gps rfkill

Daniel Drake (1):
      Add OLPC XO-1 rfkill driver

Dmitry Torokhov (17):
      topstar-laptop - switch to using sparse keymap library
      panasonic-laptop - switch to using sparse keymap library
      Input: dell-wmi - switch to using sparse keymap library
      Input: hp-wmi - switch to using sparse keymap library
      toshiba-acpi - switch to using sparse keymap
      asus-laptop: remove no longer used keycode_map field
      asus-laptop: use attribute group to manage attributes
      WMI: remove EC region handler when _WDG parsing fails
      WMI: free wmi blocks when parse_wdg() fails
      WMI: fix wmi_gtoa() to actully terminate the string
      WMI: do not leak memory in parse_wdg()
      WMI: fix potential NULL pointer dereference
      WMI: simplify handling of returned WMI blocks in parse_wdg()
      WMI: use separate list head for storing wmi blocks
      WMI: use pr_err() and friends
      WMI: make use of class device's attributres
      WMI: embed struct device directly into wmi_block

Ike Panhc (9):
      ideapad: add ACPI helpers
      ideapad: check VPC bit before sync rfkill hw status
      ideapad: make sure we bind on the correct device
      ideapad: use return value of _CFG to tell if device exist or not
      ideapad: use EC command to control camera
      ideapad: rewrite the hw rfkill notify
      ideapad: rewrite the sw rfkill set
      ideapad: Change the driver name to ideapad-laptop
      ideapad: Add param: no_bt_rfkill

Jean Delvare (3):
      Move hdaps driver to platform/x86
      panasonic-laptop: Handle errors properly if they happen
      panasonic-laptop: Simplify calls to acpi_pcc_retrieve_biosdata

Keng-Yu Lin (1):
      dell-laptop: Add debugfs support

Matthew Garrett (1):
      ideapad-laptop: Fix Makefile

Pascal de Bruijn (1):
      Don't show error if Acer WMI is not found

Randy Dunlap (1):
      acpi_toshiba: fix kconfig error

Vernon Mauery (1):
      IBM Real-Time "SMI Free" mode driver -v7

 .../ABI/testing/sysfs-devices-system-ibm-rtl       |   22 ++
 MAINTAINERS                                        |    4 +-
 arch/x86/include/asm/olpc.h                        |    2 +
 drivers/hwmon/Kconfig                              |   20 --
 drivers/hwmon/Makefile                             |    1 -
 drivers/platform/x86/Kconfig                       |   53 +++-
 drivers/platform/x86/Makefile                      |    6 +-
 drivers/platform/x86/acer-wmi.c                    |    2 +-
 drivers/platform/x86/asus-laptop.c                 |  171 +++++------
 drivers/platform/x86/dell-laptop.c                 |   77 +++++
 drivers/platform/x86/dell-wmi.c                    |  256 ++++++---------
 drivers/platform/x86/eeepc-laptop.c                |   16 +-
 drivers/platform/x86/eeepc-wmi.c                   |   56 ++++
 drivers/{hwmon => platform/x86}/hdaps.c            |    2 +-
 drivers/platform/x86/hp-wmi.c                      |  172 +++-------
 drivers/platform/x86/ibm_rtl.c                     |  341 ++++++++++++++++++++
 .../x86/{ideapad_acpi.c => ideapad-laptop.c}       |  238 ++++++++++-----
 drivers/platform/x86/intel_pmic_gpio.c             |   26 +-
 drivers/platform/x86/intel_scu_ipc.c               |    1 +
 drivers/platform/x86/panasonic-laptop.c            |  194 +++++-------
 drivers/platform/x86/topstar-laptop.c              |  161 +++------
 drivers/platform/x86/toshiba_acpi.c                |  191 ++++--------
 drivers/platform/x86/wmi.c                         |  308 +++++++-----------
 drivers/platform/x86/xo1-rfkill.c                  |   85 +++++
 24 files changed, 1370 insertions(+), 1035 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-system-ibm-rtl
 rename drivers/{hwmon => platform/x86}/hdaps.c (99%)
 create mode 100644 drivers/platform/x86/ibm_rtl.c
 rename drivers/platform/x86/{ideapad_acpi.c => ideapad-laptop.c} (53%)
 create mode 100644 drivers/platform/x86/xo1-rfkill.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org
