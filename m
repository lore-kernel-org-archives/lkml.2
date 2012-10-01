Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2JAW7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:16 -0400
Received: from 1wt.eu ([62.212.114.60]:34927 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2JAW7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:14 -0400
Message-Id: <20121001225157.587062710@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:51:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 000/180] 2.6.32.60-longterm review
Message-ID: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.60 release.

It contains a collection of fixes gathered from 3.0-stable, 2.6.34-stable
as well as a few pointed out by individuals.

I particularly want to thank John Stultz, Moritz Muehlenhoff from debian,
and Brad Spengler from grsecurity for taking the time to provide backports
with detailed dependencies.

Some significant patch series were merged, mainly for the NTP and random
issues. Other areas well affected by fixes include KVM, futex, epoll, and
eCryptfs.

This kernel was built on 2 architectures with allmodconfig (i386/x86_64)
and 1 architecture with a hardware-specific config (arm). It has been
tested on one machine (my laptop from which I'm typing this e-mail currently
runs on it).

All patches will be posted as a response to this one. If anyone has any
issue with these being applied, please let me know. If anyone is a
maintainer of the proper subsystem, and wants to add a Signed-off-by: line
to the patch, please respond with it.

Responses should be made within 72 hours. Anything received after that time
might be too late.

Please note that the whole -rc patch is not provided anymore, only individual
patches are provided so that their authors and subsystem maintainers can spot
issues. If this is a problem for you, please report it so that we try to find
a solution.

The diffstat is appended below.

 Documentation/kernel-parameters.txt     |    5 +
 Documentation/stable_kernel_rules.txt   |    6 +
 MAINTAINERS                             |    2 +-
 arch/arm/kernel/sys_arm.c               |    2 +-
 arch/ia64/include/asm/unistd.h          |    3 +-
 arch/ia64/kernel/entry.S                |   13 +
 arch/ia64/kernel/irq_ia64.c             |    1 -
 arch/ia64/kvm/kvm-ia64.c                |    5 +
 arch/mips/include/asm/thread_info.h     |    4 +-
 arch/mips/kernel/vmlinux.lds.S          |    3 +-
 arch/parisc/include/asm/atomic.h        |    4 +-
 arch/powerpc/include/asm/reg.h          |    3 +-
 arch/powerpc/kernel/ftrace.c            |   12 +-
 arch/powerpc/kernel/module_32.c         |   11 +-
 arch/powerpc/platforms/powermac/smp.c   |    2 +-
 arch/sparc/Makefile                     |    2 +-
 arch/sparc/kernel/ds.c                  |    2 +-
 arch/sparc/kernel/rtrap_64.S            |    7 -
 arch/x86/Kconfig                        |    9 +
 arch/x86/include/asm/cpufeature.h       |    2 +
 arch/x86/include/asm/k8.h               |    2 +
 arch/x86/include/asm/kvm_emulate.h      |   15 ++
 arch/x86/include/asm/timer.h            |    8 +-
 arch/x86/kernel/cpu/Makefile            |    1 +
 arch/x86/kernel/cpu/common.c            |    2 +
 arch/x86/kernel/k8.c                    |   31 +++
 arch/x86/kernel/tls.c                   |    4 +-
 arch/x86/kernel/tsc.c                   |    3 +-
 arch/x86/kvm/emulate.c                  |   57 +++++-
 arch/x86/kvm/i8254.c                    |   10 +-
 arch/x86/kvm/irq.h                      |    6 +-
 arch/x86/kvm/x86.c                      |   61 +++++-
 arch/x86/lib/delay.c                    |    4 +-
 arch/x86/mm/fault.c                     |   10 +-
 arch/x86/mm/pageattr.c                  |   18 +-
 arch/x86/mm/pgtable.c                   |   11 +-
 arch/x86/oprofile/backtrace.c           |    4 +-
 arch/x86/pci/amd_bus.c                  |   43 +---
 arch/x86/xen/enlighten.c                |    3 +
 arch/x86/xen/mmu.c                      |   10 +-
 arch/x86/xen/xen-asm.S                  |    2 +-
 block/blk-ioc.c                         |   12 +-
 crypto/sha512_generic.c                 |    2 +-
 drivers/acpi/ac.c                       |    4 +-
 drivers/block/cciss_scsi.c              |   12 +-
 drivers/block/sx8.c                     |    2 +-
 drivers/bluetooth/btusb.c               |    9 +-
 drivers/bluetooth/hci_ldisc.c           |    6 +-
 drivers/char/random.c                   |  375 ++++++++++++++++++++-----------
 drivers/char/tty_audit.c                |    4 +-
 drivers/dma/ioat/dma_v2.c               |   34 +--
 drivers/dma/ioat/dma_v2.h               |    2 -
 drivers/firmware/dmi_scan.c             |    3 +
 drivers/firmware/pcdp.c                 |    4 +-
 drivers/gpu/drm/i915/intel_display.c    |   11 +-
 drivers/mfd/wm831x-otp.c                |    8 +
 drivers/mtd/nand/cafe_nand.c            |    2 +-
 drivers/net/atlx/atl1.c                 |   12 +-
 drivers/net/atlx/atl1.h                 |    3 +-
 drivers/net/atlx/atlx.c                 |    2 +-
 drivers/net/bonding/bond_3ad.c          |    7 +-
 drivers/net/dl2k.c                      |  157 +++++--------
 drivers/net/dl2k.h                      |  117 +----------
 drivers/net/ks8851_mll.c                |    2 +-
 drivers/net/netxen/netxen_nic.h         |    7 +-
 drivers/net/netxen/netxen_nic_ctx.c     |   15 ++
 drivers/net/netxen/netxen_nic_ethtool.c |   62 ++----
 drivers/net/tun.c                       |    6 +-
 drivers/net/usb/kaweth.c                |    2 +-
 drivers/net/usb/usbnet.c                |   10 +-
 drivers/pci/quirks.c                    |   34 +++
 drivers/pnp/quirks.c                    |    6 +-
 drivers/rtc/rtc-wm831x.c                |   24 ++-
 drivers/scsi/libsas/sas_expander.c      |   47 ++---
 drivers/scsi/scsi_error.c               |   14 ++
 drivers/scsi/scsi_lib.c                 |   11 +
 drivers/scsi/scsi_wait_scan.c           |    1 +
 drivers/usb/class/cdc-acm.c             |    3 +-
 drivers/usb/class/cdc-wdm.c             |    2 +
 drivers/usb/core/devio.c                |   10 +-
 drivers/usb/core/hub.c                  |   40 +++-
 drivers/usb/early/ehci-dbgp.c           |    2 +-
 drivers/usb/host/pci-quirks.c           |   10 +-
 drivers/usb/host/xhci-ext-caps.h        |    5 +-
 drivers/usb/host/xhci-hcd.c             |    2 +-
 drivers/usb/host/xhci-mem.c             |   10 +-
 drivers/usb/serial/ftdi_sio.c           |    3 +-
 drivers/usb/serial/mos7840.c            |    9 +-
 drivers/usb/serial/usb-serial.c         |    8 +
 drivers/video/uvesafb.c                 |   11 +-
 fs/btrfs/async-thread.c                 |    9 +-
 fs/compat.c                             |   10 +-
 fs/ecryptfs/crypto.c                    |   68 +++++-
 fs/ecryptfs/ecryptfs_kernel.h           |   11 +
 fs/ecryptfs/inode.c                     |    5 +
 fs/ecryptfs/keystore.c                  |    9 +-
 fs/ecryptfs/kthread.c                   |    2 +-
 fs/ecryptfs/super.c                     |   18 ++-
 fs/eventpoll.c                          |  272 ++++++++++++++++++++---
 fs/ext3/ialloc.c                        |    8 +-
 fs/ext3/inode.c                         |   17 ++-
 fs/ext4/extents.c                       |    2 +
 fs/ext4/ialloc.c                        |    8 +-
 fs/ext4/inode.c                         |    9 +
 fs/fuse/dir.c                           |    1 +
 fs/fuse/file.c                          |    2 +-
 fs/fuse/fuse_i.h                        |    3 +
 fs/fuse/inode.c                         |   17 ++-
 fs/hfsplus/catalog.c                    |    4 +
 fs/hfsplus/dir.c                        |   11 +
 fs/hugetlbfs/inode.c                    |   54 ++---
 fs/jbd2/transaction.c                   |    2 +
 fs/locks.c                              |    6 +-
 fs/nfs/nfs3proc.c                       |    2 +-
 fs/nfs/nfs4proc.c                       |    1 +
 fs/nfs/super.c                          |    2 +
 fs/nfsd/nfs4xdr.c                       |    2 +-
 fs/nilfs2/the_nilfs.c                   |    1 +
 fs/signalfd.c                           |   15 ++
 fs/udf/file.c                           |   35 +++-
 fs/udf/super.c                          |   97 +++++---
 fs/xfs/xfs_log_recover.c                |   33 +--
 fs/xfs/xfs_vnodeops.c                   |   15 +-
 include/asm-generic/poll.h              |    2 +
 include/linux/eventpoll.h               |    1 +
 include/linux/fs.h                      |    1 +
 include/linux/hrtimer.h                 |    9 +-
 include/linux/hugetlb.h                 |   14 +-
 include/linux/iocontext.h               |    5 +-
 include/linux/irq.h                     |    1 -
 include/linux/kernel.h                  |   13 +
 include/linux/ktime.h                   |    7 -
 include/linux/kvm_host.h                |    7 +
 include/linux/random.h                  |   19 ++-
 include/linux/signalfd.h                |    5 +-
 include/linux/skbuff.h                  |   10 +
 include/linux/time.h                    |   29 +++-
 include/linux/timex.h                   |    2 +-
 include/net/rose.h                      |    8 +-
 kernel/cred.c                           |    2 +
 kernel/exit.c                           |    2 +-
 kernel/fork.c                           |    8 +-
 kernel/futex.c                          |   45 +++--
 kernel/hrtimer.c                        |   52 +++--
 kernel/irq/handle.c                     |    7 +-
 kernel/irq/manage.c                     |   17 --
 kernel/sched_fair.c                     |    3 +
 kernel/time/ntp.c                       |  130 ++++-------
 kernel/time/timekeeping.c               |  112 ++++++++--
 kernel/workqueue.c                      |    1 +
 mm/hugetlb.c                            |  135 +++++++++---
 mm/madvise.c                            |   16 +-
 mm/mempolicy.c                          |    2 +-
 mm/mmu_notifier.c                       |   45 ++--
 net/core/dev.c                          |    3 +
 net/core/rtnetlink.c                    |    1 +
 net/core/skbuff.c                       |    4 +-
 net/core/sock.c                         |    7 +-
 net/dccp/ccid.h                         |    4 +-
 net/ipv4/cipso_ipv4.c                   |    6 +-
 net/ipv4/tcp.c                          |    3 +-
 net/ipv4/tcp_input.c                    |    6 +-
 net/ipv4/tcp_ipv4.c                     |    8 +-
 net/ipv4/xfrm4_mode_beet.c              |    5 +-
 net/ipv4/xfrm4_mode_tunnel.c            |    6 +-
 net/ipv6/xfrm6_mode_beet.c              |    6 +-
 net/ipv6/xfrm6_mode_tunnel.c            |    6 +-
 net/netlink/af_netlink.c                |   24 +-
 net/phonet/pep.c                        |    3 +
 net/rose/af_rose.c                      |    8 +-
 net/rose/rose_loopback.c                |   13 +-
 net/rose/rose_route.c                   |   20 +-
 net/rose/rose_subr.c                    |   91 +++++---
 net/sched/sch_gred.c                    |    7 +-
 net/sched/sch_netem.c                   |   10 +-
 net/sctp/input.c                        |    7 +-
 net/sctp/socket.c                       |   12 +-
 net/sunrpc/cache.c                      |    2 +
 net/sunrpc/sched.c                      |   15 +-
 net/sunrpc/svc_xprt.c                   |   10 +-
 net/wanrouter/wanmain.c                 |   51 ++---
 security/commoncap.c                    |    6 +
 sound/drivers/mpu401/mpu401_uart.c      |    1 +
 sound/pci/echoaudio/echoaudio_dsp.c     |    2 +-
 sound/pci/hda/hda_proc.c                |    2 +-
 virt/kvm/kvm_main.c                     |   97 +++++++-
 186 files changed, 2260 insertions(+), 1194 deletions(-)


