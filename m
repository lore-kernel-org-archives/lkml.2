Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2HJUhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 16:37:08 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:33329 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2HJUhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 16:37:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.6-rc2
Date: Fri, 10 Aug 2012 22:42:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sameer Nanda <snanda@chromium.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, NeilBrown <neilb@suse.de>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208102242.56112.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.6-rc2

to receive power management fixes for v3.6-rc2 with top-most commit
07368d32f1a67e797def08cf2ee3ea1647b204b6

  tpm_tis / PM: Fix unused function warning for CONFIG_PM_SLEEP

on top of commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee

  Linux 3.6-rc1

Included are:

* Fix for two recent regressions in the generic PM domains framework.

* Revert of a commit that introduced a resume regression and is conceptually
  incorrect in my opinion.

* Fix for a return value in pcc-cpufreq.c from Julia Lawall.

* RTC wakeup signaling fix from Neil Brown.

* Suppression of compiler warnings for CONFIG_PM_SLEEP unset in ACPI,
  platform/x86 and TPM drivers.

Thanks!


 drivers/acpi/ac.c                        |  4 ++++
 drivers/acpi/battery.c                   |  2 ++
 drivers/acpi/button.c                    |  4 ++++
 drivers/acpi/fan.c                       |  4 ++++
 drivers/acpi/power.c                     |  4 ++++
 drivers/acpi/sbs.c                       |  2 ++
 drivers/acpi/thermal.c                   |  4 ++++
 drivers/base/power/clock_ops.c           |  3 +--
 drivers/base/power/common.c              |  4 +---
 drivers/char/tpm/tpm_tis.c               |  2 ++
 drivers/cpufreq/pcc-cpufreq.c            |  1 +
 drivers/platform/x86/classmate-laptop.c  |  4 ++++
 drivers/platform/x86/fujitsu-tablet.c    |  2 ++
 drivers/platform/x86/hdaps.c             |  2 ++
 drivers/platform/x86/hp_accel.c          |  2 +-
 drivers/platform/x86/msi-laptop.c        |  4 ++++
 drivers/platform/x86/panasonic-laptop.c  |  4 ++++
 drivers/platform/x86/sony-laptop.c       | 12 +++++++++++-
 drivers/platform/x86/thinkpad_acpi.c     |  2 ++
 drivers/platform/x86/toshiba_acpi.c      |  2 ++
 drivers/platform/x86/toshiba_bluetooth.c |  4 ++++
 drivers/platform/x86/xo15-ebook.c        |  2 ++
 drivers/rtc/interface.c                  |  2 ++
 drivers/rtc/rtc-cmos.c                   |  1 -
 include/linux/sched.h                    |  8 --------
 kernel/power/suspend.c                   |  3 ---
 kernel/watchdog.c                        | 21 ++-------------------
 27 files changed, 71 insertions(+), 38 deletions(-)

---------------

Julia Lawall (1):
      drivers/cpufreq/pcc-cpufreq.c: fix error return code

NeilBrown (1):
      RTC: Avoid races between RTC alarm wakeup and suspend.

Rafael J. Wysocki (5):
      PM: Make dev_pm_get_subsys_data() always return 0 on success
      Revert "NMI watchdog: fix for lockup detector breakage on resume"
      ACPI / PM: Fix unused function warnings for CONFIG_PM_SLEEP
      platform / x86 / PM: Fix unused function warnings for CONFIG_PM_SLEEP
      tpm_tis / PM: Fix unused function warning for CONFIG_PM_SLEEP

