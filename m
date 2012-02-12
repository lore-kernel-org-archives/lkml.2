Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab2BLUvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 15:51:09 -0500
Received: from 1wt.eu ([62.212.114.60]:62386 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab2BLUvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 15:51:06 -0500
Date: Sun, 12 Feb 2012 21:51:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.27.60
Message-ID: <20120212205103.GA30616@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.27.60.

Note that a build failure was reported for i386 just after the release and
before this announcement. I'm preparing 2.6.27.61 with the faulty patch
reverted. Other users are unaffected.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.60.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.60.xz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/patch-2.6.27.60.gz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/2.6.27/ChangeLog-2.6.27.60

The updated 2.6.27.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.27.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.27.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.27.y


  Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
        x86_64 |    build:OK            -
          i386 |    build:FAIL          -

Thanks to all reviewers, to Greg for the final packaging, and to
Stefan Cososchi for reporting the build failure.

Willy

---------
 Documentation/kbuild/makefiles.txt         |   12 ++++++
 MAINTAINERS                                |    2 +-
 Makefile                                   |    7 ++-
 arch/alpha/kernel/osf_sys.c                |   11 +++--
 arch/arm/kernel/sys_oabi-compat.c          |    2 +-
 arch/parisc/mm/init.c                      |    4 +-
 arch/powerpc/kernel/crash.c                |    6 +--
 arch/powerpc/kernel/prom_init.c            |    6 +-
 arch/powerpc/oprofile/op_model_power4.c    |   24 +++++++++++-
 arch/powerpc/platforms/pseries/hvconsole.c |    2 +-
 arch/powerpc/platforms/pseries/lpar.c      |    2 +-
 arch/s390/kvm/kvm-s390.c                   |   14 +++++--
 arch/um/drivers/ubd_kern.c                 |   31 +++++++++++++++-
 arch/x86/kernel/amd_iommu_init.c           |    8 ++--
 arch/x86/kernel/reboot.c                   |    8 ++++
 arch/x86/lib/copy_user_64.S                |    4 +-
 arch/x86/mm/gup.c                          |   56 ++++++++++++++++++++++++++++
 arch/x86/mm/mmap.c                         |    4 +-
 arch/x86/oprofile/backtrace.c              |   46 +++++++++++++++++++++--
 arch/x86/oprofile/init.c                   |    7 ++-
 block/cfq-iosched.c                        |    8 +++-
 block/elevator.c                           |    3 +-
 block/scsi_ioctl.c                         |   54 +++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c                  |   24 +++++++++---
 drivers/ata/sata_via.c                     |   15 +++++++
 drivers/block/cciss.c                      |    6 +-
 drivers/block/ub.c                         |    3 +-
 drivers/block/virtio_blk.c                 |    3 +-
 drivers/cdrom/cdrom.c                      |    3 +-
 drivers/char/agp/generic.c                 |   19 +++++++--
 drivers/char/i8k.c                         |   11 +++--
 drivers/char/tpm/tpm.c                     |    9 ++++-
 drivers/ide/ide-floppy.c                   |    3 +-
 drivers/md/dm-linear.c                     |   10 ++++-
 drivers/md/dm-mpath.c                      |    6 +++
 drivers/md/md.c                            |    2 +-
 drivers/media/video/uvc/uvc_queue.c        |    2 +
 drivers/mmc/host/sdhci-pci.c               |    1 +
 drivers/mmc/host/sdhci.c                   |    9 ++++-
 drivers/mtd/ubi/cdev.c                     |    3 +
 drivers/net/bonding/bond_3ad.c             |    7 +++
 drivers/net/bonding/bond_alb.c             |    7 +++
 drivers/net/bonding/bond_main.c            |    4 ++
 drivers/net/rionet.c                       |    4 +-
 drivers/net/wireless/libertas/cmd.c        |    6 ++-
 drivers/scsi/aacraid/commsup.c             |    2 +
 drivers/scsi/device_handler/scsi_dh.c      |    7 +++-
 drivers/scsi/hosts.c                       |    9 +++-
 drivers/scsi/libsas/sas_expander.c         |   13 ++++--
 drivers/scsi/scsi_lib.c                    |   18 +++++++-
 drivers/scsi/scsi_sysfs.c                  |   16 ++++----
 drivers/scsi/sd.c                          |   13 +++++-
 drivers/scsi/sym53c8xx_2/sym_glue.c        |    4 ++
 drivers/usb/musb/musb_core.c               |    1 +
 drivers/usb/serial/ftdi_sio.c              |   14 +++++-
 drivers/usb/storage/usb.c                  |    1 +
 drivers/video/carminefb.c                  |    6 +-
 drivers/video/offb.c                       |   52 ++++++++++++--------------
 fs/cifs/cifssmb.c                          |    3 +-
 fs/ext3/namei.c                            |   13 +++++-
 fs/ext3/xattr.c                            |   12 +++++-
 fs/ext4/extents.c                          |    1 +
 fs/ext4/inode.c                            |    2 +-
 fs/hfs/btree.c                             |   15 +++++++
 fs/hfs/trans.c                             |    2 +
 fs/jbd/journal.c                           |    8 ++++
 fs/jbd2/journal.c                          |    8 ++++
 fs/lockd/clntproc.c                        |    8 +++-
 fs/nfsd/export.c                           |    2 +-
 fs/nfsd/vfs.c                              |    9 ++++-
 fs/partitions/efi.c                        |    6 +++
 fs/partitions/ldm.c                        |   21 ++++++++--
 fs/partitions/osf.c                        |   12 +++++-
 fs/ubifs/recovery.c                        |   26 +++++++++++++
 include/asm-x86/uaccess.h                  |    2 +-
 include/linux/blkdev.h                     |    3 +
 include/linux/if_packet.h                  |    2 +
 include/linux/mm.h                         |    6 +++
 include/linux/seqlock.h                    |    4 +-
 include/linux/sunrpc/sched.h               |    4 +-
 kernel/taskstats.c                         |    1 +
 kernel/time/timekeeping.c                  |   11 ++++-
 mm/util.c                                  |   13 ++++++
 net/bluetooth/l2cap.c                      |    2 +-
 net/ipv4/af_inet.c                         |    3 +
 net/packet/af_packet.c                     |    2 +
 net/sched/sch_api.c                        |   14 +++---
 net/sunrpc/clnt.c                          |    3 +
 net/sunrpc/rpcb_clnt.c                     |    2 +-
 net/sunrpc/sched.c                         |    1 +
 net/sunrpc/svc.c                           |    3 +
 net/sunrpc/svc_xprt.c                      |   11 +++--
 net/sunrpc/xprtsock.c                      |   28 +++++++++++---
 net/unix/af_unix.c                         |   16 +++++++-
 scripts/Kbuild.include                     |    5 ++
 sound/core/timer.c                         |    2 +
 sound/pci/ice1712/amp.c                    |    7 ++-
 97 files changed, 751 insertions(+), 176 deletions(-)

Summary of changes from 2.6.27.59 to 2.6.27.60
==============================================
Alexandre Bounine (1):
      drivers/net/rionet.c: fix ethernet address macros for LE platforms

Andrea Arcangeli (1):
      ext4: avoid hangs in ext4_da_should_update_i_disksize()

Andrew Worsley (1):
      USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c

Andy Chittenden (1):
      SUNRPC: fix NFS client over TCP hangs due to packet loss (Bug 16494)

Andy Gospodarek (1):
      bonding: correctly process non-linear skbs

Anton Blanchard (3):
      powerpc/pseries/hvconsole: Fix dropped console output
      powerpc: Fix device tree claim code
      powerpc: pseries: Fix kexec on machines with more than 4TB of RAM

Artem Bityutskiy (1):
      UBIFS: fix master node recovery

Bart Hartgers (1):
      sata_via: Delay on vt6420 when starting ATAPI DMA write

Bart Van Assche (1):
      Make scsi_free_queue() kill pending SCSI commands

Ben Dooks (1):
      mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Ben Greear (1):
      SUNRPC: Fix use of static variable in rpcb_getport_async

Benjamin Herrenschmidt (2):
      offb: Fix setting of the pseudo-palette for >8bpp
      offb: Fix bug in calculating requested vram size

Carsten Otte (1):
      KVM: s390: check cpu_id prior to using it

Chris Ball (2):
      mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
      mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Dan Carpenter (1):
      hfs: add sanity check for file name length

Dan Rosenberg (3):
      ARM: 6891/1: prevent heap corruption in OABI semtimedop
      alpha: fix several security issues
      Bluetooth: Prevent buffer overflow in l2cap config request

Daniel J Blueman (1):
      x86: Make Dell Latitude E5420 use reboot=pci

Dave Jones (1):
      kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0

David Rientjes (1):
      set memory ranges in N_NORMAL_MEMORY when onlined

Eric B Munson (1):
      powerpc/oprofile: Handle events that raise an exception without overflowing

Eric Dumazet (2):
      net_sched: Fix qdisc_notify()
      af_packet: prevent information leak

Eric W. Biederman (1):
      af_unix: Only allow recv on connected seqpacket sockets.

Eryu Guan (1):
      jbd/jbd2: validate sb->s_first in journal_get_superblock()

Felipe Balbi (1):
      usb: musb: core: set has_tt flag

Hannes Reinecke (1):
      SCSI: Silencing 'killing requests for dead queue'

Huajun Li (1):
      usb: usb-storage doesn't support dynamic id currently, the patch disables the feature to fix an oops

J. Bruce Fields (2):
      svcrpc: fix list-corrupting race on nfsd shutdown
      svcrpc: fix double-free on shutdown of nfsd after changing pool mode

James Bottomley (2):
      put stricter guards on queue dead checks
      block: add proper state guards to __elv_next_request

Jan Kara (2):
      ext3: Fix fs corruption when make_indexed_dir() fails
      ext3: Fix oops in ext3_try_to_allocate_with_rsv()

Jean Delvare (1):
      carminefb: Fix module parameters permissions

Jeff Layton (1):
      cifs: fix possible memory corruption in CIFSFindNext

Jens Axboe (1):
      cfq-iosched: fix locking around ioc->ioc_data assignment

Jim Bos (2):
      i8k: Tell gcc that *regs gets clobbered
      Fix gcc 4.5.1 miscompiling drivers/char/i8k.c (again)

Jiri Olsa (1):
      x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit

Jiri Slaby (1):
      SCSI: scsi_lib: fix potential NULL dereference

Joe Perches (1):
      MAINTAINERS: stable: Update address

Joerg Roedel (1):
      x86/amd-iommu: Fix 3 possible endless loops

Linus Torvalds (1):
      Make TASKSTATS require root access

Luben Tuikov (1):
      libsas: remove expander from dev list on error

Luca Tettamanti (1):
      i8k: Avoid lahf in 64-bit code

Ludwig Nussel (1):
      x86: Fix mmap random address range

Marcus Meissner (1):
      net/ipv4: Check for mistakenly passed in non-IPv4 address

Mark Salyzyn (1):
      libsas: fix panic when single phy is disabled on a wide port

Michael Neuling (1):
      powerpc/kdump: Fix timeout in crash_kexec_wait_realmode

Michal Marek (1):
      kbuild: Fix passing -Wno-* options to gcc 4.4+

Milton Miller (1):
      seqlock: Don't smp_rmb in seqlock reader spin loop

Moger, Babu (1):
      SCSI: scsi_dh: check queuedata pointer before proceeding further

Namhyung Kim (1):
      md: check ->hot_remove_disk when removing disk

Neil Horman (1):
      bonding: Ensure that we unshare skbs prior to calling pskb_may_pull

Paolo Bonzini (3):
      block: add and use scsi_blk_cmd_ioctl
      block: fail SCSI passthrough ioctls on partition devices
      dm: do not forward ioctls from logical volumes to the underlying device

Paul Fox (1):
      libertas: fix cmdpendingq locking

Pavel Hofman (1):
      ALSA: ice1724 - Check for ac97 to avoid kernel oops

Peter Huewe (2):
      TPM: Call tpm_transmit with correct size
      TPM: Zero buffer after copying to userspace

Peter Zijlstra (1):
      x86, mm: Add __get_user_pages_fast()

Phillip Lougher (1):
      hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops

Richard Weinberger (2):
      um: fix ubd cow size
      UBI: fix nameless volumes handling

Robert Richter (2):
      oprofile, x86: Fix crash when unloading module (nmi timer mode)
      oprofile, x86: Fix nmi-unsafe callgraph support

Sachin Prabhu (1):
      Open with O_CREAT flag set fails to open existing files on non writable directories

Sasha Levin (1):
      nfsd: Fix oops when parsing a 0 length export

Shaohua Li (1):
      cfq-iosched: fix a rcu warning

Sjoerd Simons (1):
      uvcvideo: Remove buffers from the queues when freeing

Stratos Psomadakis (1):
      sym53c8xx: Fix NULL pointer dereference in slave_destroy

Takashi Iwai (1):
      ALSA: timer - Fix Oops at closing slave timer

Tejun Heo (1):
      libata: set queue DMA alignment to sector size for ATAPI too

Timo Warns (4):
      fs/partitions/ldm.c: fix oops caused by corrupted partition table
      Fix corrupted OSF partition table parsing
      Validate size of EFI GUID partition entries.
      Fix for buffer overflow in ldm_frag_add not sufficient

Trond Myklebust (1):
      NLM: Don't hang forever on NLM unlock requests

Vasiliy Kulikov (2):
      agp: fix arbitrary kernel memory writes
      agp: fix OOM and buffer overflow

Vasily Averin (1):
      aacraid: reset should disable MSI interrupt

Willy Tarreau (1):
      Linux 2.6.27.60

Xiao Guangrong (1):
      export __get_user_pages_fast() function

Zheng Liu (1):
      ext4: fix BUG_ON() in ext4_ext_insert_extent()

john stultz (1):
      Fix time() inconsistencies caused by intermediate xtime_cache values being read

