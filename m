Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2CFQZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:25:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2CFQTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:47 -0500
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=bu2qT21EAA8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=VS46ld75Jx8_NhBPcfcA:9 a=z1i0dDrnTo2bxsrv0XcA:7 a=U62fhAwekXMA:10 a=ti60F2ljaY6_uBwE:21 a=RRZBVoGdXotm8HMn:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161636.491172179@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 00/25][RFC 3.0.23-rt39-rc1] [ANNOUNCE] 3.0.23-rt39-rc1 release cycle
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.23-rt39-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candidate).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 3/9/2012.

Enjoy,

-- Steve


To build 3.0.23-rt39-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.23.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.23-rt39-rc1.patch.xz

You can also build from 3.0.23-rt38 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.23-rt38-rt39-rc1.patch.xz


Changes from 3.0.23-rt38:

---


Andy Lutomirski (2):
      x86-64-remove-vsyscall-number-3
      x86-64-emulate-legacy-vsyscalls

Steven Rostedt (11):
      revert-convert-xtime_lock-to-raw_seqlock
      revert-seqlock-create-raw_seqlock
      revert-seqlock-use-seqcount
      revert-seqlock-remove-unused-functions
      timer: Fix hotplug for -rt
      futex/rt: Fix possible lockup when taking pi_lock in proxy handler
      ring-buffer/rt: Check for irqs disabled before grabbing reader lock
      sched/rt: Fix wait_task_interactive() to test rt_spin_lock state
      lglock/rt: Use non-rt for_each_cpu() in -rt code
      cpu: Make hotplug.lock a "sleeping" spinlock on RT
      Linux 3.0.23-rt39-rc1

Thomas Gleixner (12):
      x86: vdso: Remove bogus locking in update_vsyscall_tz()
      x86: vdso: Use seqcount instead of seqlock
      ia64: vsyscall: Use seqcount instead of seqlock
      seqlock: Remove unused functions
      seqlock: Use seqcount
      seqlock: Provide seq_spin_* functions
      fs: fs_struct use seqlock
      fs: dentry use seqlock
      timekeeping: Split xtime_lock
      seqlock: Prevent rt starvation
      fs: Protect open coded isize seqcount
      net: u64_stat: Protect seqcount

----
 arch/ia64/kernel/asm-offsets.c            |    4 +-
 arch/ia64/kernel/fsys.S                   |    2 +-
 arch/ia64/kernel/fsyscall_gtod_data.h     |    2 +-
 arch/ia64/kernel/time.c                   |   10 +-
 arch/powerpc/platforms/cell/spufs/inode.c |    6 +-
 arch/x86/include/asm/irq_vectors.h        |    6 +-
 arch/x86/include/asm/traps.h              |    4 +
 arch/x86/include/asm/vgtod.h              |    2 +-
 arch/x86/include/asm/vsyscall.h           |   12 ++
 arch/x86/kernel/Makefile                  |    1 +
 arch/x86/kernel/entry_64.S                |    2 +
 arch/x86/kernel/traps.c                   |    6 +
 arch/x86/kernel/vmlinux.lds.S             |    4 -
 arch/x86/kernel/vsyscall_64.c             |  289 ++++++++++++-----------------
 arch/x86/kernel/vsyscall_emu_64.S         |   27 +++
 arch/x86/vdso/vclock_gettime.c            |   16 +-
 drivers/infiniband/hw/ipath/ipath_fs.c    |    6 +-
 drivers/infiniband/hw/qib/qib_fs.c        |    6 +-
 drivers/usb/core/inode.c                  |   12 +-
 fs/9p/vfs_dir.c                           |    4 +-
 fs/afs/dir.c                              |    4 +-
 fs/autofs4/autofs_i.h                     |   24 ++--
 fs/autofs4/expire.c                       |   44 +++---
 fs/autofs4/root.c                         |   38 ++--
 fs/btrfs/export.c                         |    4 +-
 fs/ceph/caps.c                            |    8 +-
 fs/ceph/debugfs.c                         |    8 +-
 fs/ceph/dir.c                             |   26 ++--
 fs/ceph/inode.c                           |   20 +-
 fs/ceph/mds_client.c                      |   16 +-
 fs/cifs/dir.c                             |    6 +-
 fs/coda/cache.c                           |    4 +-
 fs/configfs/configfs_internal.h           |    4 +-
 fs/configfs/inode.c                       |    6 +-
 fs/dcache.c                               |  269 +++++++++++++--------------
 fs/dcookies.c                             |    8 +-
 fs/exec.c                                 |    4 +-
 fs/exportfs/expfs.c                       |   12 +-
 fs/fat/inode.c                            |    4 +-
 fs/fat/namei_vfat.c                       |    4 +-
 fs/fhandle.c                              |    4 +-
 fs/fs-writeback.c                         |    4 +-
 fs/fs_struct.c                            |   46 ++---
 fs/fuse/inode.c                           |    4 +-
 fs/gfs2/export.c                          |    4 +-
 fs/isofs/export.c                         |    4 +-
 fs/libfs.c                                |   36 ++--
 fs/namei.c                                |   56 +++---
 fs/namespace.c                            |    8 +-
 fs/ncpfs/dir.c                            |    6 +-
 fs/ncpfs/ncplib_kernel.h                  |    8 +-
 fs/nfs/dir.c                              |    6 +-
 fs/nfs/getroot.c                          |   12 +-
 fs/nfs/namespace.c                        |   16 +-
 fs/nfs/unlink.c                           |   20 +-
 fs/nilfs2/namei.c                         |    4 +-
 fs/notify/fsnotify.c                      |    8 +-
 fs/notify/vfsmount_mark.c                 |   24 ++--
 fs/ocfs2/dcache.c                         |    6 +-
 fs/ocfs2/export.c                         |    4 +-
 fs/reiserfs/inode.c                       |    4 +-
 fs/udf/namei.c                            |    4 +-
 fs/xfs/linux-2.6/xfs_export.c             |    8 +-
 include/linux/dcache.h                    |   15 +-
 include/linux/fs.h                        |    6 +-
 include/linux/fs_struct.h                 |   16 +-
 include/linux/fsnotify_backend.h          |    6 +-
 include/linux/lglock.h                    |   35 ++++-
 include/linux/seccomp.h                   |   10 +
 include/linux/seqlock.h                   |  142 +++++++++------
 include/linux/u64_stats_sync.h            |    2 +
 include/net/neighbour.h                   |    2 +-
 kernel/cgroup.c                           |   22 +-
 kernel/cpu.c                              |   35 +++-
 kernel/fork.c                             |   10 +-
 kernel/rtmutex.c                          |    6 +-
 kernel/sched.c                            |    6 +-
 kernel/time/jiffies.c                     |    4 +-
 kernel/time/ntp.c                         |   24 ++-
 kernel/time/tick-common.c                 |   10 +-
 kernel/time/tick-internal.h               |    3 +-
 kernel/time/tick-sched.c                  |   16 +-
 kernel/time/timekeeping.c                 |   89 +++++----
 kernel/timer.c                            |   16 +-
 kernel/trace/ring_buffer.c                |    2 +-
 localversion-rt                           |    2 +-
 net/sunrpc/rpc_pipe.c                     |    6 +-
 security/selinux/selinuxfs.c              |   14 +-
 88 files changed, 919 insertions(+), 810 deletions(-)
