Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1CPVkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:40:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62459 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab1CPVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:40:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Total BKL removal, finally
Date: Wed, 16 Mar 2011 22:39:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103162239.37299.arnd@arndb.de>
X-Provags-ID: V02:K0:irqF1FbmCD7Ve+7TcBPiJwQVtuUTFCEAo1sMtlGX8K9
 ZEhVUoNGySxi5ibHUtdYTP1N6Gn4J0BFLM3VYowHCRQNhOe/Sh
 Sm5D9+0QtYEA6qfRAtFpwjHlFAKEZUQ1zh67C1i3TcFigxHyPW
 oIlFJ7IJM/lWIBX+B2LoBFH+LUs4p8kY+KLbtIaI/3MO7ao3zw
 kaikBPEbVTbz5OsGEcedg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the missing pieces of the BKL removal, aside from the
bits that are in the staging and drm trees. You can pull the
trees in any order, there should be no interdependencies.

There was one conflict between this tree and the nfs tree
a few days ago, because an #include <linux/smp_lock.h> was
accidentally added back there, but the file removed here.
If that happens with any other tree, the fix should be to
just remove the offending #include. All patches that are
in linux-next today are fine in this regard.

Thanks,

	Arnd

8<-------------------------------------------------------------------

The following changes since commit f5412be599602124d2bdd49947b231dd77c0bf99:

  Linux 2.6.38-rc6 (2011-02-21 17:25:52 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git config

Arnd Bergmann (9):
      adfs: remove the big kernel lock
      tracing: don't trace the BKL
      drivers: remove extraneous includes of smp_lock.h
      hpfs: remove the BKL
      ufs: remove the BKL
      x25: remove the BKL
      appletalk: remove the BKL
      ipx: remove the BKL
      BKL: That's all, folks

Matt Fleming (1):
      fs/locks.c: Remove stale FIXME left over from BKL conversion

8<-------------------------------------------------------------------

commit 4ba8216cd90560bc402f52076f64d8546e8aefcb
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jan 25 22:52:22 2011 +0100

    BKL: That's all, folks
    
    This removes the implementation of the big kernel lock,
    at last. A lot of people have worked on this in the
    past, I so the credit for this patch should be with
    everyone who participated in the hunt.
    
    The names on the Cc list are the people that were the
    most active in this, according to the recorded git
    history, in alphabetical order.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Alan Cox <alan@linux.intel.com>
    Cc: Alessio Igor Bogani <abogani@texware.it>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Andrew Hendry <andrew.hendry@gmail.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Christoph Hellwig <hch@infradead.org>
    Cc: Eric W. Biederman <ebiederm@xmission.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Hans Verkuil <hverkuil@xs4all.nl>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Cc: Jan Blunck <jblunck@infradead.org>
    Cc: John Kacur <jkacur@redhat.com>
    Cc: Jonathan Corbet <corbet@lwn.net>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Matthew Wilcox <matthew@wil.cx>
    Cc: Oliver Neukum <oliver@neukum.org>
    Cc: Paul Menage <menage@google.com>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>

 include/linux/hardirq.h  |    9 +---
 include/linux/smp_lock.h |   65 ----------------------
 init/Kconfig             |    5 --
 kernel/sched.c           |    9 +---
 lib/Kconfig.debug        |    9 ---
 lib/Makefile             |    1 -
 lib/kernel_lock.c        |  136 ----------------------------------------------
 7 files changed, 2 insertions(+), 232 deletions(-)

commit ae7eb8979ccfa5e9e888101b9c940f20bd0f4115
Author: Matt Fleming <matt.fleming@linux.intel.com>
Date:   Sun Feb 27 13:58:00 2011 +0000

    fs/locks.c: Remove stale FIXME left over from BKL conversion
    
    The comment is no longer true as (now that the BKL conversion is
    finished) a spinlock _is_ now used to protect file_lock_list,
    blocked_list and inode->i_flock.
    
    Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 fs/locks.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

commit b0d0d915d1d1a0fe486849f3e41333c66df620c4
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jan 25 21:49:56 2011 +0100

    ipx: remove the BKL
    
    This replaces all instances of lock_kernel in the
    IPX code with lock_sock. As far as I can tell, this
    is safe to do, because there is no global state
    that needs to be locked in IPX, and the code does
    not recursively take the lock or sleep indefinitely
    while holding it.
    
    Compile-tested only.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: David S. Miller <davem@davemloft.net>
    Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
    Cc: netdev@vger.kernel.org

 net/ipx/Kconfig  |    1 -
 net/ipx/af_ipx.c |   52 ++++++++++++++++++++--------------------------------
 2 files changed, 20 insertions(+), 33 deletions(-)

commit 60d9f461a20ba59219fdcdc30cbf8e3a4ad3f625
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sun Jan 23 00:21:11 2011 +0100

    appletalk: remove the BKL
    
    This changes appletalk to use lock_sock instead of
    lock_kernel for serialization. I tried to make sure
    that we don't hold the socket lock during sleeping
    functions, but I did not try to prove whether the
    locks are necessary in the first place.
    
    Compile-tested only.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: David S. Miller <davem@davemloft.net>
    Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
    Cc: David Miller <davem@davemloft.net>
    Cc: netdev@vger.kernel.org

 drivers/net/appletalk/Kconfig |    1 -
 net/appletalk/ddp.c           |   40 ++++++++++++++++------------------------
 2 files changed, 16 insertions(+), 25 deletions(-)

commit 77b2283604bdd7053494a97b0e2fee97148206c6
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Jan 22 23:44:59 2011 +0100

    x25: remove the BKL
    
    This replaces all instances of lock_kernel in x25
    with lock_sock, taking care to release the socket
    lock around sleeping functions (sock_alloc_send_skb
    and skb_recv_datagram). It is not clear whether
    this is a correct solution, but it seem to be what
    other protocols do in the same situation.
    
    Includes a fix suggested by Eric Dumazet.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: David S. Miller <davem@davemloft.net>
    Tested-by: Andrew Hendry <andrew.hendry@gmail.com>
    Cc: linux-x25@vger.kernel.org
    Cc: netdev@vger.kernel.org
    Cc: Eric Dumazet <eric.dumazet@gmail.com>

 net/x25/Kconfig   |    1 -
 net/x25/af_x25.c  |   58 ++++++++++++++++------------------------------------
 net/x25/x25_out.c |    7 ++++-
 3 files changed, 23 insertions(+), 43 deletions(-)

commit 788257d6101d986ac8f2741aaa35974af47f574c
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Mon Jan 24 10:14:12 2011 +0100

    ufs: remove the BKL
    
    This introduces a new per-superblock mutex in UFS to replace
    the big kernel lock. I have been careful to avoid nested
    calls to lock_ufs and to get the lock order right with
    respect to other mutexes, in particular lock_super.
    
    I did not make any attempt to prove that the big kernel
    lock is not needed in a particular place in the code,
    which is very possible.
    
    The mutex has a significant performance impact, so it is only
    used on SMP or PREEMPT configurations.
    
    As Nick Piggin noticed, any allocation inside of the lock
    may end up deadlocking when we get to ufs_getfrag_block
    in the reclaim task, so we now use GFP_NOFS.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Tested-by: Nick Bowler <nbowler@elliptictech.com>
    Cc: Evgeniy Dushistov <dushistov@mail.ru>
    Cc: Nick Piggin <npiggin@gmail.com>

 fs/ufs/Kconfig    |    1 -
 fs/ufs/inode.c    |   78 ++++++++++++++--------------------------------------
 fs/ufs/namei.c    |   35 +++++++++++------------
 fs/ufs/super.c    |   64 +++++++++++++++++++++++++------------------
 fs/ufs/truncate.c |    5 +--
 fs/ufs/ufs.h      |    6 +++-
 fs/ufs/util.c     |    2 +-
 7 files changed, 83 insertions(+), 108 deletions(-)

commit 9a311b96c3065f362e3348cb5d7af1a57ca6bff9
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Jan 22 20:26:12 2011 +0100

    hpfs: remove the BKL
    
    This removes the BKL in hpfs in a rather awful
    way, by making the code only work on uniprocessor
    systems without kernel preemption, as suggested
    by Andi Kleen.
    
    The HPFS code probably has close to zero remaining
    users on current kernels, all archeological uses of
    the file system can probably be done with the significant
    restrictions.
    
    The hpfs_lock/hpfs_unlock functions are left in the
    code, sincen Mikulas has indicated that he is still
    interested in fixing it in a better way.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Andi Kleen <ak@linux.intel.com>
    Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
    Cc: linux-fsdevel@vger.kernel.org

 fs/hpfs/Kconfig   |    2 +-
 fs/hpfs/dir.c     |   23 +++++++++++------------
 fs/hpfs/file.c    |    9 ++++-----
 fs/hpfs/hpfs_fn.h |   22 ++++++++++++++++++++++
 fs/hpfs/inode.c   |    9 ++++-----
 fs/hpfs/namei.c   |   49 ++++++++++++++++++++++++-------------------------
 fs/hpfs/super.c   |   23 +++++++++--------------
 7 files changed, 75 insertions(+), 62 deletions(-)

commit 5edc341313a188d94cde7ef87ac31647cea8601a
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jan 25 22:08:05 2011 +0100

    drivers: remove extraneous includes of smp_lock.h
    
    These were missed the last time I cleaned this up
    globally, because of code moving around or new code
    getting merged.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

 drivers/scsi/megaraid/megaraid_sas_fp.c     |    1 -
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    1 -
 drivers/staging/easycap/easycap_ioctl.c     |    1 -
 drivers/target/target_core_device.c         |    1 -
 drivers/target/target_core_fabric_lib.c     |    1 -
 drivers/target/target_core_file.c           |    1 -
 drivers/target/target_core_hba.c            |    1 -
 drivers/target/target_core_iblock.c         |    1 -
 drivers/target/target_core_pscsi.c          |    1 -
 drivers/target/target_core_rd.c             |    1 -
 drivers/target/target_core_tpg.c            |    1 -
 drivers/target/target_core_transport.c      |    1 -
 drivers/tty/n_hdlc.c                        |    1 -
 drivers/tty/n_r3964.c                       |    1 -
 drivers/tty/pty.c                           |    1 -
 drivers/tty/tty_io.c                        |    1 -
 drivers/tty/tty_ldisc.c                     |    2 --
 drivers/tty/vt/selection.c                  |    1 -
 drivers/tty/vt/vc_screen.c                  |    1 -
 drivers/tty/vt/vt.c                         |    1 -
 drivers/tty/vt/vt_ioctl.c                   |    1 -
 21 files changed, 0 insertions(+), 22 deletions(-)

commit f51b452bed4ae5c20e1f8a790e4ed8663d909a40
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jan 25 21:54:50 2011 +0100

    tracing: don't trace the BKL
    
    No reason to trace it when the last user is gone.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

 include/trace/events/bkl.h |   61 --------------------------------------------
 lib/kernel_lock.c          |    7 -----
 2 files changed, 0 insertions(+), 68 deletions(-)

commit 4688a066ecf60086ea82f68edb3b036b567d2c08
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Jan 22 20:05:05 2011 +0100

    adfs: remove the big kernel lock
    
    According to Russell King, adfs was written to not require the big
    kernel lock, and all inode updates are done under adfs_dir_lock.
    
    All other metadata in adfs is read-only and does not require locking.
    The use of the BKL is the result of various pushdowns from the VFS
    operations.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Russell King <rmk@arm.linux.org.uk>
    Cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>

 fs/adfs/Kconfig |    1 -
 fs/adfs/dir.c   |    6 ------
 fs/adfs/inode.c |    6 ------
 fs/adfs/super.c |   13 +------------
 4 files changed, 1 insertions(+), 25 deletions(-)
