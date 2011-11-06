Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1KEX6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 19:58:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1KEX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 19:58:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm/for-next] pm: freezer updates
Date: Sun, 6 Nov 2011 01:01:26 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20111103223113.GR4417@google.com>
In-Reply-To: <20111103223113.GR4417@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111060101.26814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 03, 2011, Tejun Heo wrote:
> Hello, Rafael.
> 
> This is pull request for the following pending patches[ets].
> 
>  [1] freezer: fix various bugs and simplify implementation, take#2
>  [2] usb_storage: don't use set_freezable_with_signal()
>  [3] freezer: kill unused set_freezable_with_signal()
>  [4] freezer: fix wait_event_freezable/__thaw_task races
> 
> The patches are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer

I pulled this to linux-pm/pm-freezer, but there were merge conflicts that
I'm not 100% have been resolved correctly.  Please double check if the
resulting branch is OK.

Thanks,
Rafael


> 
> Oleg Nesterov (1):
>       freezer: fix wait_event_freezable/__thaw_task races
> 
> Tejun Heo (22):
>       freezer: fix current->state restoration race in refrigerator()
>       freezer: don't unnecessarily set PF_NOFREEZE explicitly
>       freezer: unexport refrigerator() and update try_to_freeze() slightly
>       freezer: implement and use kthread_freezable_should_stop()
>       freezer: rename thaw_process() to __thaw_task() and simplify the implementation
>       freezer: remove racy clear_freeze_flag() and set PF_NOFREEZE on dead tasks
>       freezer: don't distinguish nosig tasks on thaw
>       freezer: use dedicated lock instead of task_lock() + memory barrier
>       freezer: make freezing indicate freeze condition in effect
>       freezer: test freezable conditions while holding freezer_lock
>       freezer: kill PF_FREEZING
>       freezer: clean up freeze_processes() failure path
>       cgroup_freezer: prepare for removal of TIF_FREEZE
>       freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE
>       freezer: remove now unused TIF_FREEZE
>       freezer: remove should_send_signal() and update frozen()
>       freezer: fix set_freezable[_with_signal]() race
>       freezer: restructure __refrigerator()
>       freezer: use lock_task_sighand() in fake_signal_wake_up()
>       freezer: remove unused @sig_only from freeze_task()
>       usb_storage: don't use set_freezable_with_signal()
>       freezer: kill unused set_freezable_with_signal()
> 
>  Documentation/power/freezing-of-tasks.txt |   14 +-
>  arch/alpha/include/asm/thread_info.h      |    2 -
>  arch/arm/include/asm/thread_info.h        |    2 -
>  arch/avr32/include/asm/thread_info.h      |    2 -
>  arch/blackfin/include/asm/thread_info.h   |    2 -
>  arch/cris/include/asm/thread_info.h       |    2 -
>  arch/frv/include/asm/thread_info.h        |    2 -
>  arch/h8300/include/asm/thread_info.h      |    2 -
>  arch/ia64/include/asm/thread_info.h       |    2 -
>  arch/m32r/include/asm/thread_info.h       |    2 -
>  arch/m68k/include/asm/thread_info.h       |    1 -
>  arch/microblaze/include/asm/thread_info.h |    2 -
>  arch/mips/include/asm/thread_info.h       |    2 -
>  arch/mn10300/include/asm/thread_info.h    |    2 -
>  arch/parisc/include/asm/thread_info.h     |    2 -
>  arch/powerpc/include/asm/thread_info.h    |    2 -
>  arch/s390/include/asm/thread_info.h       |    2 -
>  arch/sh/include/asm/thread_info.h         |    2 -
>  arch/sparc/include/asm/thread_info_32.h   |    2 -
>  arch/sparc/include/asm/thread_info_64.h   |    2 -
>  arch/um/include/asm/thread_info.h         |    2 -
>  arch/unicore32/include/asm/thread_info.h  |    2 -
>  arch/x86/include/asm/thread_info.h        |    2 -
>  arch/xtensa/include/asm/thread_info.h     |    2 -
>  drivers/bluetooth/btmrvl_main.c           |    2 -
>  drivers/mfd/twl4030-irq.c                 |    3 -
>  drivers/mfd/twl6030-irq.c                 |    2 -
>  drivers/net/irda/stir4200.c               |    2 +-
>  drivers/platform/x86/thinkpad_acpi.c      |   15 +--
>  drivers/staging/rts_pstor/rtsx.c          |    2 -
>  drivers/usb/storage/usb.c                 |   13 +-
>  fs/btrfs/async-thread.c                   |    2 +-
>  fs/btrfs/disk-io.c                        |    8 +-
>  fs/ext4/super.c                           |    3 +-
>  fs/fs-writeback.c                         |    4 +-
>  fs/gfs2/log.c                             |    4 +-
>  fs/gfs2/quota.c                           |    4 +-
>  fs/jbd/journal.c                          |    2 +-
>  fs/jbd2/journal.c                         |    2 +-
>  fs/jfs/jfs_logmgr.c                       |    2 +-
>  fs/jfs/jfs_txnmgr.c                       |    4 +-
>  fs/nilfs2/segment.c                       |    2 +-
>  fs/xfs/xfs_buf.c                          |    2 +-
>  include/linux/freezer.h                   |  117 ++++++-----------
>  include/linux/kthread.h                   |    1 +
>  include/linux/sched.h                     |    4 +-
>  kernel/cgroup_freezer.c                   |   63 ++++-----
>  kernel/exit.c                             |    3 +-
>  kernel/fork.c                             |    1 -
>  kernel/freezer.c                          |  203 +++++++++++++++--------------
>  kernel/kthread.c                          |   27 ++++-
>  kernel/power/hibernate.c                  |   15 +--
>  kernel/power/process.c                    |   77 +++++-------
>  kernel/power/suspend.c                    |    8 +-
>  kernel/power/user.c                       |    4 +-
>  mm/backing-dev.c                          |    8 +-
>  56 files changed, 279 insertions(+), 389 deletions(-)
> 
> 

