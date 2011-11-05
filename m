Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab1KEXe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 19:34:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52445 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1KEXe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 19:34:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] More power management updates for 3.2
Date: Sun, 6 Nov 2011 00:37:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111060037.02477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull more power management updates (on top of commit
1583171492eb514e267c7b51e96846b38de0f544) for 3.2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-linus

with top-most commit d6cc76856d353a3a9c43bead33210b9216dce332
(PM / Freezer: Revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
TASK_KILLABLE tasks too").

All of them are either bug fixes or simple cleanups that didn't make it to my
previous pull request.

They include:

* New entry for the ACPI suspend blacklist from Dave Jones.

* Fixes and cleanups related to the interactions between suspend/hibernation
  and CPU hotplug from Srivatsa Bhat.

* Runtime PM core fix for accounting_timestamp computations (some results
  were wrong due to using int instead of unsigned long) from Venu Byravarasu.

* OPP build fix from Tony Lindgren.

* PM QoS cleanup from Guennadi Liakhovetski.

* Autosuspend fixes from Alan Stern.

* Freezer fixes from Tejun and Oleg Nesterov.

[No patches from me this time, how weird.]

Thanks!


 Documentation/power/freezing-of-tasks.txt |    8 ++--
 Documentation/power/runtime_pm.txt        |   10 ++++
 drivers/acpi/sleep.c                      |    8 +++
 drivers/base/power/runtime.c              |   23 +++++++--
 drivers/usb/core/driver.c                 |    5 ++
 include/linux/cpu.h                       |    4 --
 include/linux/freezer.h                   |   11 +---
 include/linux/opp.h                       |    4 +-
 kernel/cpu.c                              |   74 +++++++++++++++++++++++++++++
 kernel/freezer.c                          |    2 +-
 kernel/power/qos.c                        |    3 +-
 11 files changed, 125 insertions(+), 27 deletions(-)

---------------

Alan Stern (2):
      PM / Runtime: Automatically retry failed autosuspends
      USB: Update last_busy time after autosuspend fails

Dave Jones (1):
      ACPI / PM: Add Sony VPCEB17FX to nonvs blacklist

Guennadi Liakhovetski (1):
      PM / QoS: Remove redundant check

Oleg Nesterov (1):
      PM / Freezer: Reimplement wait_event_freezekillable using freezer_do_not_count/freezer_count

Srivatsa S. Bhat (3):
      PM / Sleep: Fix race between CPU hotplug and freezer
      PM / Sleep: Remove unused symbol 'suspend_cpu_hotplug'
      PM / Sleep: Update freezer documentation

Tejun Heo (1):
      PM / Freezer: Revert 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too"

Tony Lindgren (1):
      PM / OPP: Fix build when CONFIG_PM_OPP is not set

venu byravarasu (1):
      PM / Runtime: Fix runtime accounting calculation error

