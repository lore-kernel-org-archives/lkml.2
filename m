Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1KSWMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 17:12:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134Ab1KSWMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 17:12:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] More power management fixes for 3.2
Date: Sat, 19 Nov 2011 23:15:32 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111192315.32660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull additional power management fixes (on top of commit
19e0bafc36abd84a5b4d7c7745b78a6f4626e944) for 3.2 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-fixes

with top-most commit 501a708f18ef911328ffd39f39738b8a7862aa8e
(PM / Suspend: Fix bug in suspend statistics update).

They include:

* PM QoS and shmobile PM cleanups from Guennadi Liakhovetski.

* PM clocks management and shmobile PM fixes from Magnus Damm.

* devfreq fixes from MyungJoo Ham and Axel Lin.

* shmobile PM fix to avoid restoring INTCS state from random data
  during initialization.

* Driver core fix to disable device runtime PM during shutdown from Peter Chen.

* PM core fix to prevent devices with ignore_children set from blocking power
  removal from their power domains unnecessarily (which is a power regression
  with respect to 3.1 on some systems).

* Hibernation test modes and suspend statistics fixes from Srivatsa S. Bhat.

Thanks!


 arch/arm/mach-shmobile/pm-sh7372.c |   33 ++++++++++++++++++++++------
 drivers/base/core.c                |    3 ++
 drivers/base/power/clock_ops.c     |    3 +-
 drivers/base/power/main.c          |    3 +-
 drivers/base/power/qos.c           |   18 +++++----------
 drivers/devfreq/Kconfig            |   41 +++++++++++++++---------------------
 drivers/devfreq/devfreq.c          |   10 +++++++-
 include/linux/device.h             |    5 ++++
 include/linux/pm.h                 |    2 +-
 include/linux/pm_runtime.h         |    6 -----
 kernel/power/hibernate.c           |   23 +++++++++++++++-----
 kernel/power/main.c                |    3 +-
 12 files changed, 89 insertions(+), 61 deletions(-)

---------------

Axel Lin (1):
      PM / devfreq: fix use after free in devfreq_remove_device

Guennadi Liakhovetski (2):
      PM / shmobile: Don't skip debugging output in pd_power_up()
      PM / QoS: Properly use the WARN() macro in dev_pm_qos_add_request()

Magnus Damm (2):
      ARM: mach-shmobile: sh7372 A3SP no_suspend_console fix
      PM / Clocks: Only disable enabled clocks in pm_clk_suspend()

MyungJoo Ham (2):
      PM / devfreq: Remove compiler error after irq.h update
      PM / devfreq: correct Kconfig dependency

Peter Chen (1):
      PM / driver core: disable device's runtime PM during shutdown

Rafael J. Wysocki (3):
      PM / shmobile: Avoid restoring the INTCS state during initialization
      PM Sleep: Do not extend wakeup paths to devices with ignore_children set
      PM / shmobile: Fix build of sh7372_pm_init() for CONFIG_PM unset

Srivatsa S. Bhat (2):
      PM / Hibernate: Fix the early termination of test modes
      PM / Suspend: Fix bug in suspend statistics update

