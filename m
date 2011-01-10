Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1AJS0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:26:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52413 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1AJS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:26:40 -0500
Date: Mon, 10 Jan 2011 18:26:35 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] X86 platform drivers pull request
Message-ID: <20110110182635.GA29160@srcf.ucam.org>
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

A driver for the Lenovo ideapad laptops, a pile of Eee driver fixes and 
some miscellaneous tweaks. Nothing hugely exciting this cycle.

The following changes since commit 3e5b08cbbf78bedd316904ab0cf3b27119433ee5:

  Merge branch 'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6 (2011-01-07 13:16:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Albert Astals Cid (1):
      Support KHLB2 in the compal laptop driver

Colin King (1):
      WMI: Cater for multiple events with same GUID

Corentin Chary (10):
      eeepc-wmi: rework eeepc_wmi_init and eeepc_wmi_exit
      eeepc-wmi: add touchpad led support
      eeepc-wmi: add rfkill support for wlan, bluetooth and 3g
      eeepc-wmi: use attribute group to manage attributes
      eeepc-wmi: add debugfs entries
      eeepc-wmi: fix confusion between ctrl_param and retval
      eeepc-wmi: claim eeepc-wmi maintainership
      eeepc-wmi: remove unneeded static
      eeepc-laptop: add a getter for touchpad led
      eeepc-wmi: never load if legacy device is enabled

Dan Carpenter (1):
      WMI: return error if wmi_create_device() fails

Feng Tang (1):
      intel_pmic_gpio: modify EOI handling following change of kernel irq subsystem

From: Lee, Chun-Yi (1):
      acer-wmi: Enabled Acer Launch Manager mode

Herton Ronaldo Krzesinski (2):
      classmate-laptop: little optimization for cmpc_rfkill_block
      classmate-laptop: add missing input_sync call

Ike Panhc (6):
      ideapad: add platform driver for ideapad
      ideapad: let camera power control entry under platform driver
      ideapad: add hotkey support
      ideapad: add markups, unify comments and return result when init
      ideapad: pass ideapad_priv as argument (part 1)
      ideapad: pass ideapad_priv as argument (part 2)

Jesper Juhl (1):
      ACPI Thinkpad: We must always call va_end() after va_start() but do not do so in thinkpad_acpi.c::acpi_evalf()

Joe Perches (1):
      drivers/platform/x86: Remove unnecessary semicolons

Lee, Chun-Yi (4):
      acer-wmi: Add acer wmi hotkey events support
      acer-wmi: Add 3G rfkill sysfs file
      acer-wmi: Detect the WiFi/Bluetooth/3G devices available
      acer-wmi: Initialize wlan/bluetooth/wwan rfkill software block state

Mark Brown (1):
      platform/x86: Consistently select LEDS Kconfig options

Mattia Dongili (1):
      sony-laptop: support new hotkeys on the P, Z and EC series

Namhyung Kim (1):
      fujitsu-laptop: fix compiler warning on pnp_ids

Randy Dunlap (2):
      intel_ips: fix sparse non-ANSI function warning
      sony-laptop: fix sparse non-ANSI function warning

Sedat Dilek (1):
      platform/x86: Kconfig: Replace select by depends on ACPI_WMI

Sreedhara DS (1):
      intel_scu_ipc: Utility driver for intel scu ipc

 .../ABI/testing/sysfs-platform-ideapad-laptop      |    6 +
 MAINTAINERS                                        |    8 +
 drivers/platform/x86/Kconfig                       |   27 +-
 drivers/platform/x86/Makefile                      |    1 +
 drivers/platform/x86/acer-wmi.c                    |  429 ++++++++++++++-
 drivers/platform/x86/classmate-laptop.c            |   19 +-
 drivers/platform/x86/compal-laptop.c               |    8 +
 drivers/platform/x86/eeepc-laptop.c                |   11 +
 drivers/platform/x86/eeepc-wmi.c                   |  609 +++++++++++++++++---
 drivers/platform/x86/fujitsu-laptop.c              |    2 +-
 drivers/platform/x86/ideapad-laptop.c              |  259 ++++++---
 drivers/platform/x86/intel_ips.c                   |    2 +-
 drivers/platform/x86/intel_pmic_gpio.c             |    6 +-
 drivers/platform/x86/intel_scu_ipc.c               |    4 +-
 drivers/platform/x86/intel_scu_ipcutil.c           |  133 +++++
 drivers/platform/x86/sony-laptop.c                 |   12 +-
 drivers/platform/x86/thinkpad_acpi.c               |    3 +-
 drivers/platform/x86/wmi.c                         |  135 +++--
 include/linux/sonypi.h                             |    1 +
 19 files changed, 1432 insertions(+), 243 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ideapad-laptop
 create mode 100644 drivers/platform/x86/intel_scu_ipcutil.c

-- 
Matthew Garrett | mjg59@srcf.ucam.org
