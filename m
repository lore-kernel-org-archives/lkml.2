Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab2AFXZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 18:25:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51903 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab2AFXZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 18:25:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 3.3
Date: Sat, 7 Jan 2012 00:28:51 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201070028.52228.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates (on top of commit
4962516b2309d76964f9df0d33e74f43b624a42d) for 3.3 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-linus

with top-most commit c233523b3d392e530033a7587d7970dc62a02361
(Merge branch 'pm-sleep' into pm-for-linus).

They include:

* Freezer updates from Tejun.

* Suspend and hiberante fixes and cleanups from Srivatsa S. Bhat.

* Introduction of PM QoS into generic PM domains.

* Rework of the PM core making it execute driver callbacks directly if the corresponding
  subsystem ones are not present.

* One more ACPI sleep DMI blacklist entry.

* Changes to make the freezer play better with NFS and sunrpc from Jeff Layton.

* devfreq updates.

* Assorted PM fixes.

Thanks!


 Documentation/feature-removal-schedule.txt   |   11 -
 Documentation/power/devices.txt              |   37 +-
 Documentation/power/freezing-of-tasks.txt    |   39 +-
 Documentation/power/runtime_pm.txt           |  130 ++--
 arch/alpha/include/asm/thread_info.h         |    2 -
 arch/arm/include/asm/thread_info.h           |    2 -
 arch/arm/mach-s3c64xx/Kconfig                |    1 +
 arch/arm/mach-s3c64xx/mach-crag6410.c        |    2 +-
 arch/arm/mach-s3c64xx/pm.c                   |  176 ++++-
 arch/arm/mach-shmobile/include/mach/common.h |    4 +-
 arch/arm/mach-shmobile/include/mach/sh7372.h |    6 +-
 arch/arm/mach-shmobile/intc-sh7372.c         |   50 ++
 arch/arm/mach-shmobile/pm-sh7372.c           |  196 ++++--
 arch/arm/mach-shmobile/setup-sh7372.c        |    6 +-
 arch/arm/mach-shmobile/sleep-sh7372.S        |   21 +-
 arch/arm/plat-samsung/include/plat/pm.h      |    6 +
 arch/avr32/include/asm/thread_info.h         |    2 -
 arch/blackfin/include/asm/thread_info.h      |    2 -
 arch/cris/include/asm/thread_info.h          |    2 -
 arch/frv/include/asm/thread_info.h           |    2 -
 arch/h8300/include/asm/thread_info.h         |    2 -
 arch/ia64/include/asm/thread_info.h          |    2 -
 arch/m32r/include/asm/thread_info.h          |    2 -
 arch/m68k/include/asm/thread_info.h          |    1 -
 arch/microblaze/include/asm/thread_info.h    |    2 -
 arch/mips/include/asm/thread_info.h          |    2 -
 arch/mn10300/include/asm/thread_info.h       |    2 -
 arch/parisc/include/asm/thread_info.h        |    2 -
 arch/powerpc/include/asm/thread_info.h       |    2 -
 arch/powerpc/kernel/vio.c                    |    1 -
 arch/s390/include/asm/thread_info.h          |    2 -
 arch/sh/include/asm/thread_info.h            |    2 -
 arch/sparc/include/asm/thread_info_32.h      |    2 -
 arch/sparc/include/asm/thread_info_64.h      |    2 -
 arch/um/include/asm/thread_info.h            |    2 -
 arch/unicore32/include/asm/thread_info.h     |    2 -
 arch/x86/include/asm/thread_info.h           |    2 -
 arch/xtensa/include/asm/thread_info.h        |    2 -
 drivers/acpi/sleep.c                         |   16 +
 drivers/amba/bus.c                           |  136 +---
 drivers/base/firmware_class.c                |    4 +
 drivers/base/platform.c                      |  115 ---
 drivers/base/power/Makefile                  |    2 +-
 drivers/base/power/domain.c                  |  539 +++++++++----
 drivers/base/power/domain_governor.c         |  156 ++++
 drivers/base/power/generic_ops.c             |   91 +--
 drivers/base/power/main.c                    |  375 ++++-----
 drivers/base/power/qos.c                     |   49 +-
 drivers/base/power/runtime.c                 |  157 +++-
 drivers/bluetooth/btmrvl_main.c              |    2 -
 drivers/devfreq/Kconfig                      |   13 +
 drivers/devfreq/Makefile                     |    3 +
 drivers/devfreq/devfreq.c                    |   15 +-
 drivers/devfreq/exynos4_bus.c                | 1135 ++++++++++++++++++++++++++
 drivers/dma/dmatest.c                        |   46 +-
 drivers/input/touchscreen/st1232.c           |   13 +-
 drivers/mfd/twl6030-irq.c                    |    2 -
 drivers/net/irda/stir4200.c                  |    2 +-
 drivers/platform/x86/thinkpad_acpi.c         |   15 +-
 drivers/sh/intc/core.c                       |    8 +
 drivers/sh/intc/internals.h                  |    1 +
 drivers/staging/rts_pstor/rtsx.c             |    2 -
 drivers/usb/storage/usb.c                    |   13 +-
 fs/btrfs/async-thread.c                      |    2 +-
 fs/btrfs/disk-io.c                           |    8 +-
 fs/ext4/super.c                              |    3 +-
 fs/fs-writeback.c                            |    4 +-
 fs/gfs2/log.c                                |    4 +-
 fs/gfs2/quota.c                              |    4 +-
 fs/jbd/journal.c                             |    2 +-
 fs/jbd2/journal.c                            |    2 +-
 fs/jfs/jfs_logmgr.c                          |    2 +-
 fs/jfs/jfs_txnmgr.c                          |    4 +-
 fs/nfs/inode.c                               |    3 +-
 fs/nfs/nfs3proc.c                            |    3 +-
 fs/nfs/nfs4proc.c                            |    5 +-
 fs/nfs/proc.c                                |    3 +-
 fs/nilfs2/segment.c                          |    2 +-
 fs/xfs/xfs_buf.c                             |    2 +-
 include/linux/freezer.h                      |  159 ++--
 include/linux/kmod.h                         |    2 +
 include/linux/kthread.h                      |    1 +
 include/linux/platform_device.h              |   30 +-
 include/linux/pm.h                           |   15 +-
 include/linux/pm_domain.h                    |  103 +++-
 include/linux/pm_qos.h                       |    8 +
 include/linux/pm_runtime.h                   |    5 +
 include/linux/sched.h                        |    4 +-
 include/linux/sh_intc.h                      |    1 +
 include/linux/suspend.h                      |   35 +-
 kernel/cgroup_freezer.c                      |   63 +-
 kernel/cpu.c                                 |    4 +-
 kernel/exit.c                                |    3 +-
 kernel/fork.c                                |    1 -
 kernel/freezer.c                             |  203 +++---
 kernel/kexec.c                               |    4 +-
 kernel/kmod.c                                |   27 +-
 kernel/kthread.c                             |   27 +-
 kernel/power/hibernate.c                     |   92 +--
 kernel/power/main.c                          |   10 +-
 kernel/power/power.h                         |    2 +
 kernel/power/process.c                       |   77 +-
 kernel/power/suspend.c                       |   12 +-
 kernel/power/user.c                          |  184 ++---
 mm/backing-dev.c                             |    8 +-
 mm/oom_kill.c                                |    2 +-
 net/sunrpc/sched.c                           |    3 +-
 107 files changed, 3249 insertions(+), 1530 deletions(-)

---------------

Axel Lin (1):
      PM / devfreq: separate error paths from successful path

Ben Hutchings (1):
      PM / Hibernate: Implement compat_ioctl for /dev/snapshot

Fenghua Yu (1):
      CPU: Add right qualifiers for alloc_frozen_cpus() and cpu_hotplug_pm_sync_init()

Guennadi Liakhovetski (1):
      PM / Domains: fix compilation failure for CONFIG_PM_GENERIC_DOMAINS unset

Jeff Layton (2):
      Freezer / sunrpc / NFS: don't allow TASK_KILLABLE sleeps to block the freezer
      PM / Freezer: fix return value of freezable_schedule_timeout_killable()

Keng-Yu Lin (1):
      ACPI / PM: Do not save/restore NVS on Asus K54C/K54HR

Magnus Damm (1):
      PM / shmobile: Add support for the sh7372 A4S power domain / sleep mode

Mark Brown (3):
      PM / Domains: Provide an always on power domain governor
      PM / shmobile: Use common always on power domain governor
      ARM: S3C64XX: Implement basic power domain support

MyungJoo Ham (1):
      PM/Devfreq: Add Exynos4-bus device DVFS driver for Exynos4210/4212/4412.

Oleg Nesterov (1):
      freezer: fix wait_event_freezable/__thaw_task races

Rafael J. Wysocki (24):
      PM / Sleep: Remove unnecessary label and jumps to it form PM core code
      PM / Sleep: Simplify device_suspend_noirq()
      PM / Runtime: Use device PM QoS constraints (v2)
      PM / Domains: Make it possible to use per-device domain callbacks
      PM / Domains: Introduce "save/restore state" device callbacks
      PM / Domains: Rework system suspend callback routines (v2)
      PM / Domains: Add device stop governor function (v4)
      PM / Domains: Add default power off governor function (v4)
      PM / Domains: Automatically update overoptimistic latency information
      PM / Sleep: Unify diagnostic messages from device suspend/resume
      PM / Domains: Make it possible to assign names to generic PM domains
      PM / Domains: Fix default system suspend/resume operations
      PM / Sleep: Simplify generic system suspend callbacks
      PM / Sleep: Merge internal functions in generic_ops.c
      PM / Sleep: Make pm_op() and pm_noirq_op() return callback pointers
      PM: Run the driver callback directly if the subsystem one is not there
      PM / Sleep: Remove forward-only callbacks from platform bus type
      PM / Sleep: Remove forward-only callbacks from AMBA bus type
      PM: Drop generic_subsys_pm_ops
      PM / shmobile: Don't include SH7372's INTCS in syscore suspend/resume
      PM / shmobile: Remove the stay_on flag from SH7372's PM domains
      PM / QoS: Introduce dev_pm_qos_add_ancestor_request()
      PM / input / touchscreen: Make st1232 use device PM QoS constraints
      PM / shmobile: Allow the A4R domain to be turned off at run time

Srivatsa S. Bhat (15):
      PM: Fix indentation and remove extraneous whitespaces in kernel/power/main.c
      PM / Memory-hotplug: Avoid task freezing failures
      PM / Hibernate: Refactor and simplify hibernation_snapshot() code
      PM / Usermodehelper: Cleanup remnants of usermodehelper_pm_callback()
      PM / Hibernate: Enable usermodehelpers in software_resume() error path
      PM / Hibernate: Thaw processes in SNAPSHOT_CREATE_IMAGE ioctl test path
      PM / Hibernate: Remove deprecated hibernation test modes
      PM / Hibernate: Replace unintuitive 'if' condition in kernel/power/user.c with 'else'
      PM / Freezer: Remove the "userspace only" constraint from freezer[_do_not]_count()
      PM / Sleep: Use the freezer_count() functions in [un]lock_system_sleep() APIs
      PM / Sleep: Make [un]lock_system_sleep() generic
      PM / Sleep: Replace mutex_[un]lock(&pm_mutex) with [un]lock_system_sleep()
      PM / Sleep: Recommend [un]lock_system_sleep() over using pm_mutex directly
      PM / Sleep: Fix freezer failures due to racy usermodehelper_is_disabled()
      PM / Hibernate: Remove deprecated hibernation snapshot ioctls

Stephen Rothwell (1):
      Freezer: fix more fallout from the thaw_process rename

Tejun Heo (23):
      freezer: fix current->state restoration race in refrigerator()
      freezer: don't unnecessarily set PF_NOFREEZE explicitly
      freezer: unexport refrigerator() and update try_to_freeze() slightly
      freezer: implement and use kthread_freezable_should_stop()
      freezer: rename thaw_process() to __thaw_task() and simplify the implementation
      freezer: remove racy clear_freeze_flag() and set PF_NOFREEZE on dead tasks
      freezer: don't distinguish nosig tasks on thaw
      freezer: use dedicated lock instead of task_lock() + memory barrier
      freezer: make freezing indicate freeze condition in effect
      freezer: test freezable conditions while holding freezer_lock
      freezer: kill PF_FREEZING
      freezer: clean up freeze_processes() failure path
      cgroup_freezer: prepare for removal of TIF_FREEZE
      freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE
      freezer: remove now unused TIF_FREEZE
      freezer: remove should_send_signal() and update frozen()
      freezer: fix set_freezable[_with_signal]() race
      freezer: restructure __refrigerator()
      freezer: use lock_task_sighand() in fake_signal_wake_up()
      freezer: remove unused @sig_only from freeze_task()
      usb_storage: don't use set_freezable_with_signal()
      dmatest: don't use set_freezable_with_signal()
      freezer: kill unused set_freezable_with_signal()

