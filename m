Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab1HTQbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 12:31:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54575 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab1HTQby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 12:31:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm-next] freezer: fix various bugs and simplify implementation
Date: Sat, 20 Aug 2011 18:33:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        arnd@arndb.de, oleg@redhat.com, lizf@cn.fujitsu.com,
        paul@paulmenage.org, Matt Helsley <matthltc@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20110820094434.GA24151@htj.dyndns.org>
In-Reply-To: <20110820094434.GA24151@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108201833.39089.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, August 20, 2011, Tejun Heo wrote:
> Hello, Rafael.
> 
> Please consider pulling from the following branch to receive freezer
> fixes and simplifications patchset[1].  The only changes from the
> posting are addition of acked-by's, minor patch description updates
> and rebase on top of pm-next (af0fa9cb79 "PM / Hibernate: Include
> storage keys in hibernation image on s390").
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer
> 
> The HEAD should be 7b5b95b3f51a28ec008a295e5247436637220f41.  If
> git.korg doesn't show it yet.  Please pull from master.korg.
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer

Pulled and stored in the pm-freezer branch in my tree, and merged into
the linux-next branch.

> FYI, this patchset will cause a conflict with s390 TIF flag fix patch.
> The conflict is trivial and Stephen should be able to handle it
> without any problem.  Also, I'm planning on doing some further work on
> cgroup freezer and then will try to bridge it with job control.  If
> that plan fans out, I might ask Oleg to pull from the pm tree.

I'm not sure if Linus likes it.  He generally doesn't want the trees
that he pulls from to be entangled this way.

> This shouldn't matter too much either way but it *might* be a good idea to
> keep this line of patches in a separate branch.

I'm going to keep it in the pm-freezer branch anyway (there may be patches
on top of it, though)

Thanks,
Rafael

 
> [1] http://thread.gmane.org/gmane.linux.kernel/1181594
> 
> Tejun Heo (16):
>       freezer: fix current->state restoration race in refrigerator()
>       freezer: don't unnecessarily set PF_NOFREEZE explicitly
>       freezer: unexport refrigerator() and update try_to_freeze() slightly
>       freezer: implement and use kthread_freezable_should_stop()
>       freezer: rename thaw_process() to __thaw_task() and simplify the implementation
>       freezer: make exiting tasks properly unfreezable
>       freezer: don't distinguish nosig tasks on thaw
>       freezer: use dedicated lock instead of task_lock() + memory barrier
>       freezer: make freezing indicate freeze condition in effect
>       freezer: fix set_freezable[_with_signal]() race
>       freezer: kill PF_FREEZING
>       freezer: clean up freeze_processes() failure path
>       cgroup_freezer: prepare for removal of TIF_FREEZE
>       freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE
>       freezer: remove now unused TIF_FREEZE
>       freezer: remove should_send_signal() and update frozen()
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
>  fs/xfs/linux-2.6/xfs_buf.c                |    2 +-
>  include/linux/freezer.h                   |   78 +++++--------
>  include/linux/kthread.h                   |    1 +
>  include/linux/sched.h                     |    3 +-
>  kernel/cgroup_freezer.c                   |   51 ++++-----
>  kernel/exit.c                             |    8 +-
>  kernel/fork.c                             |    1 -
>  kernel/freezer.c                          |  179 +++++++++++++++++------------
>  kernel/kthread.c                          |   25 ++++
>  kernel/power/hibernate.c                  |   15 +--
>  kernel/power/process.c                    |   65 ++++-------
>  kernel/power/user.c                       |    4 +-
>  mm/backing-dev.c                          |    8 +-
>  54 files changed, 247 insertions(+), 315 deletions(-)
> 
> --
> tejun
> 
> 

