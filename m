Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814Ab2FDPel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:34:41 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36418 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab2FDPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:34:40 -0400
Message-ID: <4FCCD58B.30000@kernel.org>
Date: Mon, 04 Jun 2012 11:34:35 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI & Power Management Patches for Linux-3.5-rc1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Power Management bug fixes.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to d3514abcf5b896a3a66d8b7c960a0018a52ebc2c:

  Merge branches 'bugfix-battery', 'bugfix-misc', 'bugfix-rafael', 'bugfix-turbostat', 'bugfix-video' and 'workaround-pss' into release (2012-06-04 00:48:41 -0400)

----------------------------------------------------------------

Alan Cox (3):
      acpi_video: fix leaking PCI references
      acpi_video: Intel video is not always i915
      gma500: don't register the ACPI video bus

Andy Whitcroft (1):
      ACPI battery: only refresh the sysfs files when pertinent information changes

Dan Carpenter (1):
      ACPI video: use after input_unregister_device()

Daniel Drake (2):
      ACPI / PM: Generate wakeup events on fixed power button
      rtc-cmos / PM: report wakeup event on ACPI RTC alarm

Fabio Estevam (1):
      drivers: acpi: Fix dependency for ACPI_HOTPLUG_CPU

Len Brown (5):
      tools/power turbostat: fix un-intended affinity of forked program
      tools/power turbostat: fix IVB support
      ACPI: fix acpi_bus.h build warnings when ACPI is not enabled
      Merge branch 'upstream' into bugfix-video
      Merge branches 'bugfix-battery', 'bugfix-misc', 'bugfix-rafael', 'bugfix-turbostat', 'bugfix-video' and 'workaround-pss' into release

Marco Aurelio da Costa (1):
      ACPI: Ignore invalid _PSS entries, but use valid ones

Rafael J. Wysocki (3):
      ACPI / PM: Fix error messages in drivers/acpi/bus.c
      ACPI / PM: Make __acpi_bus_get_power() cover D3cold correctly
      ACPI / PM: Make acpi_pm_device_sleep_state() follow the specification

 drivers/acpi/Kconfig                  |  2 +-
 drivers/acpi/battery.c                | 10 +++-
 drivers/acpi/bus.c                    | 88 +++++++++++++++++++++++------------
 drivers/acpi/power.c                  |  2 +-
 drivers/acpi/processor_perflib.c      | 30 ++++++++++--
 drivers/acpi/scan.c                   |  1 +
 drivers/acpi/sleep.c                  | 49 +++++++++++++++++--
 drivers/acpi/video.c                  | 33 ++++++++-----
 drivers/gpu/drm/gma500/psb_drv.c      |  3 +-
 drivers/rtc/rtc-cmos.c                |  9 ++--
 include/acpi/acpi_bus.h               |  4 +-
 tools/power/x86/turbostat/turbostat.c | 30 +++++++++++-
 12 files changed, 199 insertions(+), 62 deletions(-)
