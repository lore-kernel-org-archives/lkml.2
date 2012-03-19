Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab2CSXNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:13:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607Ab2CSXNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:13:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 3.4
Date: Tue, 20 Mar 2012 00:17:18 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mmc@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203200017.19074.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 3.4 since commit
192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

    Linux 3.3-rc6

with top-most commit 98e8bdafeb4728a6af7bbcbcc3984967d1cf2bc1

    Merge branch 'pm-domains'

from the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.4

They include:

* Introduction of early/late suspend/hibernation device callbacks.

* Generic PM domains extensions and fixes.

* devfreq updates from Axel Lin and MyungJoo Ham.

* Device PM QoS updates.

* Fixes of concurrency problems with wakeup sources.

* System suspend and hibernation fixes.

Thanks!


 Documentation/ABI/testing/sysfs-devices-power      |   18 ++
 .../bindings/arm/exynos/power_domain.txt           |   21 ++
 Documentation/power/devices.txt                    |   93 +++++---
 Documentation/power/freezing-of-tasks.txt          |   21 ++
 arch/arm/mach-exynos/Kconfig                       |   10 +-
 arch/arm/mach-exynos/Makefile                      |    2 +-
 arch/arm/mach-exynos/dev-pd.c                      |  139 -----------
 arch/arm/mach-exynos/mach-nuri.c                   |   11 -
 arch/arm/mach-exynos/mach-origen.c                 |   14 -
 arch/arm/mach-exynos/mach-smdkv310.c               |   12 -
 arch/arm/mach-exynos/mach-universal_c210.c         |   17 --
 arch/arm/mach-exynos/pm_domains.c                  |  195 +++++++++++++++
 arch/arm/mach-shmobile/setup-sh7372.c              |    2 +
 arch/x86/kernel/apm_32.c                           |   11 +-
 drivers/base/power/domain.c                        |  253 +++++++++++++++-----
 drivers/base/power/generic_ops.c                   |  157 ++++++++----
 drivers/base/power/main.c                          |  247 +++++++++++++++++--
 drivers/base/power/power.h                         |    4 +
 drivers/base/power/qos.c                           |   61 +++++
 drivers/base/power/sysfs.c                         |   47 ++++
 drivers/base/power/wakeup.c                        |   85 +++++--
 drivers/clocksource/sh_cmt.c                       |    4 +
 drivers/clocksource/sh_mtu2.c                      |    4 +
 drivers/clocksource/sh_tmu.c                       |    4 +
 drivers/devfreq/devfreq.c                          |  112 +++++++++-
 drivers/devfreq/exynos4_bus.c                      |   23 +-
 drivers/devfreq/governor_performance.c             |    5 +-
 drivers/devfreq/governor_powersave.c               |    2 +-
 drivers/devfreq/governor_simpleondemand.c          |   12 +-
 drivers/devfreq/governor_userspace.c               |   15 +-
 drivers/mmc/host/sh_mmcif.c                        |    5 +
 drivers/mmc/host/tmio_mmc_pio.c                    |    5 +
 drivers/xen/manage.c                               |    6 +-
 fs/jbd/journal.c                                   |    2 +
 fs/jbd2/journal.c                                  |    2 +
 include/linux/devfreq.h                            |   25 ++-
 include/linux/pm.h                                 |   59 ++++-
 include/linux/pm_domain.h                          |   25 ++-
 include/linux/pm_qos.h                             |   64 ++----
 include/linux/pm_wakeup.h                          |   22 ++-
 include/linux/suspend.h                            |    4 +
 kernel/exit.c                                      |    2 +-
 kernel/freezer.c                                   |    6 +-
 kernel/kexec.c                                     |    8 +-
 kernel/power/Makefile                              |    3 +-
 kernel/power/hibernate.c                           |   47 ++--
 kernel/power/main.c                                |   20 +-
 kernel/power/power.h                               |    7 +-
 kernel/power/process.c                             |   24 +-
 kernel/power/qos.c                                 |   23 +-
 kernel/power/snapshot.c                            |    7 +-
 kernel/power/suspend.c                             |   84 ++++----
 kernel/power/user.c                                |   12 +-
 53 files changed, 1452 insertions(+), 611 deletions(-)

---------------

Alex Frid (1):
      PM / QoS: Simplify PM QoS expansion/merge

Axel Lin (2):
      devfreq: exynos4_bus: Use dev_get_drvdata at appropriate places
      devfreq: Remove MODULE_ALIAS for exynos4 busfreq driver

Bjorn Helgaas (1):
      PM / Hibernate: print physical addresses consistently with other parts of kernel

Guennadi Liakhovetski (1):
      PM / Domains: Provide a dummy dev_gpd_data() when generic domains are not used

Jean Pihet (1):
      PM / QoS: unconditionally build the feature

Magnus Damm (1):
      PM / Domains: Fix include for PM_GENERIC_DOMAINS=n case

Marcos Paulo de Souza (2):
      PM / Suspend: Avoid code duplication in suspend statistics update
      PM / Freezer: Remove references to TIF_FREEZE in comments

MyungJoo Ham (3):
      PM / devfreq: fixed syntax errors.
      PM / devfreq: add min/max_freq limit requested by users.
      PM / devfreq: add relation of recommended frequency.

Nigel Cunningham (1):
      PM / Sleep: JBD and JBD2 missing set_freezable()

Rafael J. Wysocki (24):
      PM / Sleep: Introduce "late suspend" and "early resume" of devices
      PM / Sleep: Introduce generic callbacks for new device PM phases
      PM / Domains: Run late/early device suspend callbacks at the right time
      PM / Sleep: Initialize wakeup source locks in wakeup_source_add()
      PM / Sleep: Do not check wakeup too often in try_to_freeze_tasks()
      PM / Sleep: Remove unnecessary label from suspend_freeze_processes()
      PM / Sleep: Unify kerneldoc comments in kernel/power/suspend.c
      PM / Sleep: Make enter_state() in kernel/power/suspend.c static
      PM / Sleep: Drop suspend_stats_update()
      PM: Add comment describing relationships between PM callbacks to pm.h
      PM / Sleep: Fix possible infinite loop during wakeup source destruction
      PM / Sleep: Fix race conditions related to wakeup source timer function
      PM / Sleep: Make __pm_stay_awake() delete wakeup source timers
      PM / Sleep: Add more wakeup source initialization routines
      PM / QoS: Make it possible to expose PM QoS latency constraints
      tmio_mmc / PM: Use PM QoS latency constraint
      sh_mmcif / PM: Use PM QoS latency constraint
      PM / Domains: Fix handling of wakeup devices during system resume
      PM / Domains: Fix hibernation restore of devices, v2
      PM / Domains: Introduce "always on" device flag
      PM / shmobile: Make TMU driver use pm_genpd_dev_always_on()
      PM / shmobile: Make CMT driver use pm_genpd_dev_always_on()
      PM / shmobile: Make MTU2 driver use pm_genpd_dev_always_on()
      PM / Domains: Check domain status during hibernation restore of devices

Srivatsa S. Bhat (4):
      PM / Freezer / Docs: Document the beauty of freeze/thaw semantics
      PM / Hibernate: Thaw kernel threads in hibernation_snapshot() in error/test path
      PM / Hibernate: Refactor and simplify freezer_test_done
      PM / Hibernate: Enable usermodehelpers in hibernate() error path

Thomas Abraham (2):
      PM / Domains: Add OF support
      ARM: EXYNOS: Hook up power domains to generic power domain infrastructure

