Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1AGVR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:17:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40478 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab1AGVR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:17:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 2.6.38
Date: Fri, 7 Jan 2011 22:16:58 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101072216.58606.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.38 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Runtime PM framework update from Alan Stern.

* Modification of core suspend/resume routines to avoid aborting suspend on wakeup
  events when we aren't supposed to take wakeup events during suspend into account.

* Modification of core suspend/resume routines to use a different list of devices
  for each stage of device suspend (and simplifications resulting from that).

* Addition of pm_generic_ functions prototypes and update of the SPI bus type
  subsystem-level PM routines from Mark Brown.

* PM-related fixes.


 Documentation/power/drivers-testing.txt |    8 +-
 Documentation/power/runtime_pm.txt      |   31 ++++++
 drivers/base/power/generic_ops.c        |    6 +-
 drivers/base/power/main.c               |  174 +++++++++++--------------------
 drivers/base/power/runtime.c            |   47 +++++++--
 drivers/base/power/wakeup.c             |   20 ++--
 drivers/spi/spi.c                       |   92 +++++++++++++++--
 drivers/usb/core/driver.c               |    7 +-
 include/linux/device.h                  |    4 +-
 include/linux/pm.h                      |   51 ++-------
 include/linux/pm_runtime.h              |   13 +++
 include/linux/suspend.h                 |    4 +-
 kernel/freezer.c                        |    9 ++-
 kernel/power/Makefile                   |    5 +-
 kernel/power/hibernate.c                |    7 +-
 kernel/power/process.c                  |    8 ++-
 kernel/power/suspend.c                  |    2 +-
 17 files changed, 282 insertions(+), 206 deletions(-)

---------------

Aaro Koskinen (1):
      PM / Runtime: Fix comments to match runtime callback code

Alan Stern (1):
      PM / Runtime: Add synchronous runtime interface for interrupt handlers (v3)

Jon Mason (1):
      PM: Fix references to basic-pm-debugging.txt in drivers-testing.txt

Mark Brown (2):
      PM: Prototype the pm_generic_ operations
      spi / PM: Support dev_pm_ops

MyungJoo Ham (2):
      PM / Hibernate: hibernation_ops->leave should be checked too
      PM / Hibernate: When failed, in_suspend should be reset

Rafael J. Wysocki (10):
      PM: Prevent dpm_prepare() from returning errors unnecessarily
      PM / Wakeup: Replace pm_check_wakeup_events() with pm_wakeup_pending()
      PM: Use pm_wakeup_pending() in __device_suspend()
      PM: Avoid compiler warning in pm_noirq_op()
      PM: Use a different list of devices for each stage of device suspend
      PM: Remove redundant checks from core device resume routines
      PM: Replace the device power.status field with a bit field
      PM: Permit registration of parentless devices during system suspend
      PM: Use dev_name() in core device suspend and resume routines
      PM / Runtime: Generic resume shouldn't set RPM_ACTIVE unconditionally

Tejun Heo (1):
      Freezer: Fix a race during freezing of TASK_STOPPED tasks

Tracey Dent (1):
      PM: Use proper ccflag flag in kernel/power/Makefile

