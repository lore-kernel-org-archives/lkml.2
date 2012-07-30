Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab2G3P6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:58:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46968 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2G3P6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:58:45 -0400
Date: Mon, 30 Jul 2012 16:58:41 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT] x86 platform driver updates for 3.6
Message-ID: <20120730155841.GA11539@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing overly dramatic here - improved support for the Classmate, some 
random small fixes and a rework of backlight management to deal with 
some of the more awkward cases.

The following changes since commit f948ad0787de7b393c325803014fd7d5f1b501b1:

  Merge tag 'gpio-for-v3.6' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2012-07-26 13:56:38 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git linux-next

for you to fetch changes up to 00d39597e825a2b09ec88d4dd429ff72fe60d9d4:

  thinkpad_acpi: Free hotkey_keycode_map after unregistering tpacpi_inputdev (2012-07-28 00:28:57 -0400)

----------------------------------------------------------------
AceLan Kao (5):
      asus-wmi: control backlight power through WMI, not ACPI
      asus-wmi: enable resume on lid open
      asus-nb-wmi: add wapf quirk for ASUS machines
      asus-nb-wmi: add some video toggle keys
      dell-laptop: Add 6 machines to touchpad led quirk

Alex Hung (1):
      asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.

Corentin Chary (5):
      acpi: add a way to promote/demote vendor backlight drivers
      drivers-platform-x86: use acpi_video_dmi_promote_vendor()
      samsung-laptop: X360 ACPI backlight device is broken
      acpi/video_detect: blacklist samsung x360
      samsung-laptop: support R40/R41

Li Dongyang (3):
      thinkpad_acpi: Flush the workqueue before freeing tpacpi_leds
      thinkpad_acpi: Fix a memory leak during module exit
      thinkpad_acpi: Free hotkey_keycode_map after unregistering tpacpi_inputdev

Marek Vasut (3):
      ACER: Add support for accelerometer sensor
      ACER: Fix up sparse warning
      ACER: Fix Smatch double-free issue

Miguel Gómez (2):
      classmate-laptop: Add support for Classmate V4 accelerometer.
      classmate-laptop: Fix extra keys hardware id.

 Documentation/ABI/testing/sysfs-platform-asus-wmi |    7 +
 drivers/acpi/video_detect.c                       |   60 ++-
 drivers/platform/x86/acer-wmi.c                   |  153 +++++++-
 drivers/platform/x86/apple-gmux.c                 |    6 +
 drivers/platform/x86/asus-nb-wmi.c                |  108 +++++-
 drivers/platform/x86/asus-wmi.c                   |   23 +-
 drivers/platform/x86/asus-wmi.h                   |    1 +
 drivers/platform/x86/classmate-laptop.c           |  405 ++++++++++++++++++++-
 drivers/platform/x86/dell-laptop.c                |   54 +++
 drivers/platform/x86/eeepc-wmi.c                  |   25 +-
 drivers/platform/x86/samsung-laptop.c             |   41 ++-
 drivers/platform/x86/thinkpad_acpi.c              |    5 +-
 include/linux/acpi.h                              |   10 +
 13 files changed, 864 insertions(+), 34 deletions(-)


-- 
Matthew Garrett | mjg59@srcf.ucam.org
