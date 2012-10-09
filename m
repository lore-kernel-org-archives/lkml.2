Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2JIJpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:45:03 -0400
Received: from 1wt.eu ([62.212.114.60]:36042 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab2JIJo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:44:58 -0400
Date: Tue, 9 Oct 2012 11:44:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Linux 2.6.32.60
Message-ID: <20121009094453.GA4289@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.6.32.60.

This release contains, among others, a number of fixes for random and NTP,
including for the NTP leap second bug. Users should upgrade.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.60.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.60.xz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/patch-2.6.32.60.gz
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.32/ChangeLog-2.6.32.60

The updated 2.6.32.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y
  http://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.32.y

The tree can be browsed on the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.32.y


  Testing status (build/boot, OK/FAIL, otherwise not tested) :

         ARCH  |         CONFIGURATION
       --------+-----------------------------------
               |  allmodconfig     other-config
           arm |    build:OK            -
        x86_64 |    build:OK            -
          i386 |    build:OK         boot:OK

Thanks to all reviewers, especially Ben for his long careful review,
and to Greg for the final packaging.

Willy

---------
 Documentation/kernel-parameters.txt     |   5 +
 Documentation/stable_kernel_rules.txt   |   6 +
 MAINTAINERS                             |   2 +-
 Makefile                                |   2 +-
 arch/arm/kernel/sys_arm.c               |   2 +-
 arch/ia64/include/asm/unistd.h          |   3 +-
 arch/ia64/kernel/entry.S                |  13 ++
 arch/ia64/kernel/irq_ia64.c             |   1 -
 arch/ia64/kvm/kvm-ia64.c                |   5 +
 arch/mips/include/asm/thread_info.h     |   4 +-
 arch/mips/kernel/vmlinux.lds.S          |   3 +-
 arch/parisc/include/asm/atomic.h        |   4 +-
 arch/powerpc/include/asm/reg.h          |   3 +-
 arch/powerpc/kernel/ftrace.c            |  12 +-
 arch/powerpc/kernel/module_32.c         |  11 +-
 arch/powerpc/platforms/powermac/smp.c   |   2 +-
 arch/sparc/Makefile                     |   2 +-
 arch/sparc/kernel/ds.c                  |   2 +-
 arch/sparc/kernel/rtrap_64.S            |   7 -
 arch/x86/Kconfig                        |   9 +
 arch/x86/include/asm/archrandom.h       |  75 +++++++
 arch/x86/include/asm/cpufeature.h       |   2 +
 arch/x86/include/asm/k8.h               |   2 +
 arch/x86/include/asm/kvm_emulate.h      |  15 ++
 arch/x86/include/asm/timer.h            |   8 +-
 arch/x86/kernel/cpu/Makefile            |   1 +
 arch/x86/kernel/cpu/common.c            |   2 +
 arch/x86/kernel/cpu/rdrand.c            |  73 +++++++
 arch/x86/kernel/k8.c                    |  31 +++
 arch/x86/kernel/tls.c                   |   4 +-
 arch/x86/kernel/tsc.c                   |   3 +-
 arch/x86/kvm/emulate.c                  |  57 ++++-
 arch/x86/kvm/i8254.c                    |  10 +-
 arch/x86/kvm/irq.h                      |   6 +-
 arch/x86/kvm/x86.c                      |  61 +++++-
 arch/x86/lib/delay.c                    |   4 +-
 arch/x86/mm/fault.c                     |  10 +-
 arch/x86/mm/pageattr.c                  |  18 +-
 arch/x86/mm/pgtable.c                   |  11 +-
 arch/x86/oprofile/backtrace.c           |   4 +-
 arch/x86/pci/amd_bus.c                  |  43 +---
 arch/x86/xen/enlighten.c                |   3 +
 arch/x86/xen/mmu.c                      |  10 +-
 arch/x86/xen/xen-asm.S                  |   2 +-
 block/blk-ioc.c                         |  12 +-
 crypto/sha512_generic.c                 |   2 +-
 drivers/acpi/ac.c                       |   4 +-
 drivers/block/cciss_scsi.c              |  12 +-
 drivers/block/sx8.c                     |   2 +-
 drivers/bluetooth/btusb.c               |   9 +-
 drivers/bluetooth/hci_ldisc.c           |   6 +-
 drivers/char/random.c                   | 375 +++++++++++++++++++++-----------
 drivers/char/tty_audit.c                |   4 +-
 drivers/dma/ioat/dma_v2.c               |  34 +--
 drivers/dma/ioat/dma_v2.h               |   2 -
 drivers/firmware/dmi_scan.c             |   3 +
 drivers/firmware/pcdp.c                 |   4 +-
 drivers/gpu/drm/i915/intel_display.c    |  11 +-
 drivers/mfd/wm831x-otp.c                |   8 +
 drivers/mtd/nand/cafe_nand.c            |   2 +-
 drivers/net/atlx/atl1.c                 |  12 +-
 drivers/net/atlx/atl1.h                 |   3 +-
 drivers/net/atlx/atlx.c                 |   2 +-
 drivers/net/bonding/bond_3ad.c          |   7 +-
 drivers/net/dl2k.c                      | 157 +++++--------
 drivers/net/dl2k.h                      | 117 +---------
 drivers/net/ks8851_mll.c                |   2 +-
 drivers/net/netxen/netxen_nic.h         |   7 +-
 drivers/net/netxen/netxen_nic_ctx.c     |  15 ++
 drivers/net/netxen/netxen_nic_ethtool.c |  58 ++---
 drivers/net/tun.c                       |   6 +-
 drivers/net/usb/kaweth.c                |   2 +-
 drivers/net/usb/usbnet.c                |  10 +-
 drivers/pci/quirks.c                    |  34 +++
 drivers/pnp/quirks.c                    |   6 +-
 drivers/rtc/rtc-wm831x.c                |  24 +-
 drivers/scsi/libsas/sas_expander.c      |  47 ++--
 drivers/scsi/scsi_error.c               |  14 ++
 drivers/scsi/scsi_lib.c                 |  11 +
 drivers/scsi/scsi_priv.h                |   1 +
 drivers/scsi/scsi_wait_scan.c           |   1 +
 drivers/usb/class/cdc-acm.c             |   3 +-
 drivers/usb/class/cdc-wdm.c             |   2 +
 drivers/usb/core/devio.c                |  10 +-
 drivers/usb/core/hub.c                  |  40 +++-
 drivers/usb/early/ehci-dbgp.c           |   2 +-
 drivers/usb/host/pci-quirks.c           |  10 +-
 drivers/usb/host/xhci-ext-caps.h        |   5 +-
 drivers/usb/host/xhci-hcd.c             |   2 +-
 drivers/usb/host/xhci-mem.c             |  10 +-
 drivers/usb/serial/ftdi_sio.c           |   3 +-
 drivers/usb/serial/mos7840.c            |   9 +-
 drivers/usb/serial/usb-serial.c         |   8 +
 drivers/video/uvesafb.c                 |  11 +-
 fs/btrfs/async-thread.c                 |   9 +-
 fs/compat.c                             |  10 +-
 fs/ecryptfs/inode.c                     |   5 +
 fs/ecryptfs/kthread.c                   |   2 +-
 fs/eventpoll.c                          | 272 ++++++++++++++++++++---
 fs/ext3/ialloc.c                        |   8 +-
 fs/ext3/inode.c                         |  17 +-
 fs/ext4/extents.c                       |   2 +
 fs/ext4/ialloc.c                        |   8 +-
 fs/ext4/inode.c                         |   9 +
 fs/fuse/dir.c                           |   1 +
 fs/fuse/file.c                          |   2 +-
 fs/fuse/fuse_i.h                        |   3 +
 fs/fuse/inode.c                         |  17 +-
 fs/hfsplus/catalog.c                    |   4 +
 fs/hfsplus/dir.c                        |  11 +
 fs/hugetlbfs/inode.c                    |  54 ++---
 fs/jbd2/transaction.c                   |   2 +
 fs/locks.c                              |   6 +-
 fs/nfs/nfs3proc.c                       |   2 +-
 fs/nfs/nfs4proc.c                       |   1 +
 fs/nfs/super.c                          |   2 +
 fs/nfsd/nfs4xdr.c                       |   2 +-
 fs/nilfs2/the_nilfs.c                   |   1 +
 fs/signalfd.c                           |  15 ++
 fs/udf/file.c                           |  35 ++-
 fs/udf/super.c                          |  98 ++++++---
 fs/xfs/xfs_log_recover.c                |  33 +--
 fs/xfs/xfs_vnodeops.c                   |  16 +-
 include/asm-generic/poll.h              |   2 +
 include/linux/eventpoll.h               |   1 +
 include/linux/fs.h                      |   1 +
 include/linux/hrtimer.h                 |   9 +-
 include/linux/hugetlb.h                 |  14 +-
 include/linux/iocontext.h               |   5 +-
 include/linux/irq.h                     |   1 -
 include/linux/kernel.h                  |  13 ++
 include/linux/ktime.h                   |   7 -
 include/linux/kvm_host.h                |   7 +
 include/linux/random.h                  |  19 +-
 include/linux/signalfd.h                |   5 +-
 include/linux/skbuff.h                  |  10 +
 include/linux/time.h                    |  29 ++-
 include/linux/timex.h                   |   2 +-
 include/net/rose.h                      |   8 +-
 kernel/cred.c                           |   2 +
 kernel/exit.c                           |   2 +-
 kernel/fork.c                           |   8 +-
 kernel/futex.c                          |  45 ++--
 kernel/hrtimer.c                        |  52 +++--
 kernel/irq/handle.c                     |   7 +-
 kernel/irq/manage.c                     |  17 --
 kernel/sched_fair.c                     |   3 +
 kernel/time/ntp.c                       | 130 ++++-------
 kernel/time/timekeeping.c               | 112 ++++++++--
 kernel/workqueue.c                      |   1 +
 mm/hugetlb.c                            | 135 +++++++++---
 mm/madvise.c                            |  16 +-
 mm/mempolicy.c                          |   2 +-
 mm/mmu_notifier.c                       |  45 ++--
 net/core/dev.c                          |   3 +
 net/core/rtnetlink.c                    |   1 +
 net/core/skbuff.c                       |   4 +-
 net/core/sock.c                         |   7 +-
 net/dccp/ccid.h                         |   4 +-
 net/ipv4/cipso_ipv4.c                   |   6 +-
 net/ipv4/tcp.c                          |   3 +-
 net/ipv4/tcp_input.c                    |   6 +-
 net/ipv4/tcp_ipv4.c                     |   8 +-
 net/ipv4/xfrm4_mode_beet.c              |   5 +-
 net/ipv4/xfrm4_mode_tunnel.c            |   6 +-
 net/ipv6/xfrm6_mode_beet.c              |   6 +-
 net/ipv6/xfrm6_mode_tunnel.c            |   6 +-
 net/netlink/af_netlink.c                |  24 +-
 net/phonet/pep.c                        |   3 +
 net/rose/af_rose.c                      |   8 +-
 net/rose/rose_loopback.c                |  13 +-
 net/rose/rose_route.c                   |  20 +-
 net/rose/rose_subr.c                    |  91 +++++---
 net/sched/sch_gred.c                    |   7 +-
 net/sched/sch_netem.c                   |  10 +-
 net/sctp/input.c                        |   7 +-
 net/sctp/socket.c                       |  12 +-
 net/sunrpc/cache.c                      |   2 +
 net/sunrpc/sched.c                      |  15 +-
 net/sunrpc/svc_xprt.c                   |  10 +-
 net/wanrouter/wanmain.c                 |  51 ++---
 security/commoncap.c                    |   6 +
 sound/drivers/mpu401/mpu401_uart.c      |   1 +
 sound/pci/echoaudio/echoaudio_dsp.c     |   2 +-
 sound/pci/hda/hda_proc.c                |   2 +-
 virt/kvm/kvm_main.c                     |  97 ++++++++-
 186 files changed, 2319 insertions(+), 1178 deletions(-)

Summary of changes from 2.6.32.59 to 2.6.32.60
==============================================
Adam Jackson (1):
      drm/i915: Attempt to fix watermark setup on 85x (v2)

Al Viro (1):
      vfs: missed source of ->f_pos races

Alan Cox (1):
      wanmain: comparing array with NULL

Alex He (1):
      xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI

Alex Williamson (2):
      KVM: Remove ability to assign a device without iommu support
      KVM: Device assignment permission checks

Andy Lutomirski (1):
      mm: Hold a file reference in madvise_remove

Avi Kivity (2):
      KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
      KVM: ia64: fix build due to typo

Bart Van Assche (1):
      SCSI: Avoid dangling pointer in scsi_requeue_command()

Ben Hutchings (1):
      rose: Add length checks to CALL_REQUEST parsing

Benjamin Herrenschmidt (1):
      powerpc/pmac: Fix SMP kernels on pre-core99 UP machines

Bing Zhao (1):
      Bluetooth: btusb: fix bInterval for high/super speed isochronous endpoints

Bjorn Helgaas (1):
      x86/PCI: amd: factor out MMCONFIG discovery

Bjørn Mork (1):
      USB: cdc-wdm: fix lockup on error in wdm_read

Brian Foster (1):
      ext4: don't let i_reserved_meta_blocks go negative

Carlos Maiolino (1):
      xfs: Fix possible memory corruption in xfs_readlink

Chris Mason (1):
      Btrfs: call the ordered free operation without any locks held

Colin Ian King (3):
      eCryptfs: Copy up lower inode attrs after setting lower xattr
      eCryptfs: Clear ECRYPTFS_NEW_FILE flag during truncate
      USB: echi-dbgp: increase the controller wait time to come out of halt.

Dan Carpenter (5):
      block, sx8: fix pointer math issue getting fw version
      nfsd: don't allow zero length strings in cache_parse()
      USB: kaweth.c: use GFP_ATOMIC under spin_lock
      x86, tls: Off by one limit check
      mtd: cafe_nand: fix an & vs | mistake

Dan Williams (4):
      ioat2: kill pending flag
      SCSI: libsas: continue revalidation
      SCSI: libsas: fix sas_discover_devices return code handling
      SCSI: fix eh wakeup (scsi_schedule_eh vs scsi_restart_operations)

Darren Hart (3):
      futex: Test for pi_mutex on fault in futex_wait_requeue_pi()
      futex: Fix bug in WARN_ON for NULL q.pi_state
      futex: Forbid uaddr == uaddr2 in futex_wait_requeue_pi()

Dave Jones (1):
      Remove user-triggerable BUG from mpol_to_str

David Daney (1):
      MIPS: Properly align the .data..init_task section.

David Gibson (1):
      hugepages: fix use after free bug in "quota" handling

David Miller (1):
      Fix sparc build with newer tools.

David S. Miller (2):
      tcp: Don't change unlocked socket state in tcp_v4_err().
      sparc64: Fix bootup crash on sun4v.

David Vrabel (1):
      xen: correctly check for pending events when restoring irq flags

David Ward (1):
      net_sched: gred: Fix oops in gred_dump() in WRED mode

Davide Ciminaghi (1):
      net/ethernet: ks8851_mll fix rx frame buffer overflow

Eric Dumazet (5):
      ipsec: be careful of non existing mac headers
      netlink: fix races after skb queueing
      net: fix a race in sock_queue_err_skb()
      netem: fix possible skb leak
      tcp: drop SYN+FIN messages

Eric Paris (1):
      fcaps: clear the same personality flags as suid when fcaps are used

Eric Sandeen (1):
      jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer

Francois Romieu (1):
      dl2k: use standard #defines from mii.h.

Greg Kroah-Hartman (2):
      hfsplus: Fix potential buffer overflows
      USB: ftdi_sio: fix problem when the manufacture is a NULL string

Greg Pearson (1):
      pcdp: use early_ioremap/early_iounmap to access pcdp table

H. Peter Anvin (6):
      x86, cpu: Add CPU flags for F16C and RDRND
      random: Add support for architectural random hooks
      x86, random: Architectural inlines to get random integers with RDRAND
      x86, random: Verify RDRAND functionality and allow it to be disabled
      random: Adjust the number of loops when initializing
      random: mix in architectural randomness in extract_buf()

Hans de Goede (1):
      usbdevfs: Correct amount of data copied to user in processcompl_compat

Hugh Dickins (1):
      futex: Fix uninterruptible loop due to gate_area

J. Bruce Fields (4):
      locks: fix checking of fcntl_setlease argument
      nfsd4: our filesystems are normally case sensitive
      svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping
      svcrpc: sends on closed socket should stop immediately

James Bottomley (1):
      SCSI: fix scsi_wait_scan

Jan Kara (9):
      xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()
      xfs: Fix oops on IO error during xlog_recover_process_iunlinks()
      ext3: Fix error handling on inode bitmap corruption
      ext4: fix error handling on inode bitmap corruption
      udf: Avoid run away loop when partition table length is corrupted
      udf: Improve table length check to avoid possible overflow
      udf: Fix data corruption for files in ICB
      ext3: Fix fdatasync() for files with only i_size changes
      udf: Fortify loading of sparing table

Jan Kiszka (1):
      KVM: x86: Prevent starting PIT timers in the absence of irqchip support

Jarod Wilson (1):
      random: update interface comments to reflect reality

Jason Baron (3):
      epoll: limit paths
      Don't limit non-nested epoll paths
      epoll: clear the tfile_check_list on -ELOOP

Jason Wang (1):
      net: sock: validate data_len before allocating skb in sock_alloc_send_pskb()

Jeff Mahoney (1):
      dl2k: Clean up rio_ioctl

Jiri Bohac (1):
      bonding: 802.3ad - fix agg_device_up

Jiri Kosina (1):
      tcp: perform DMA to userspace only if there is a task waiting for it

Johan Hovold (2):
      Bluetooth: hci_ldisc: fix NULL-pointer dereference on tty_close
      USB: serial: fix race between probe and open

John Stultz (9):
      ntp: Fix leap-second hrtimer livelock
      timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
      hrtimer: Provide clock_was_set_delayed()
      timekeeping: Fix leapsecond triggered load spike issue
      hrtimer: Update hrtimer base offsets each hrtimer_interrupt
      time: Improve sanity checking of timekeeping inputs
      time: Avoid making adjustments if we haven't accumulated anything
      time: Move ktime_t overflow checking into timespec_valid_strict
      ntp: Fix STA_INS/DEL clearing bug

Jonathan Nieder (1):
      NFSv4: Revalidate uid/gid after open

Jonghwan Choi (1):
      security: fix compile error in commoncap.c

Jun Nie (1):
      Bluetooth: add NULL pointer check in HCI

Junxiao Bi (1):
      oprofile: use KM_NMI slot for kmap_atomic

Kees Cook (1):
      x86, cpufeature: Update CPU feature RDRND to RDRAND

Kent Yoder (1):
      crypto: sha512 - Fix byte counter overflow in SHA-512

Konrad Rzeszutek Wilk (1):
      x86, amd, xen: Avoid NULL pointer paravirt references

Lan Tianyu (1):
      ACPI/AC: prevent OOPS on some boxes due to missing check power_supply_register() return value check

Linus Torvalds (2):
      random: Use arch_get_random_int instead of cycle counter if avail
      random: create add_device_randomness() interface

Louis Rilling (2):
      block: Fix io_context leak after clone with CLONE_IO
      block: Fix io_context leak after failure of clone with CLONE_IO

Luck, Tony (1):
      fix typo/thinko in get_random_bytes()

Marcelo Tosatti (1):
      KVM: x86: disallow multiple KVM_CREATE_IRQCHIP

Mark Brown (2):
      rtc: wm831x: Feed the write counter into device_add_randomness()
      mfd: wm831x: Feed the device UUID into device_add_randomness()

Mark Ferrell (1):
      usb: serial: mos7840: Fixup mos7840_chars_in_buffer()

Mark Hills (1):
      ALSA: echoaudio: Remove incorrect part of assertion

Mathias Krause (2):
      net/tun: fix ioctl() based info leaks
      dccp: check ccid before dereferencing

Mathieu Desnoyers (1):
      drivers/char/random.c: fix boot id uniqueness race

Matt Mackall (1):
      random: simplify fips mode

Mel Gorman (2):
      stable: Allow merging of backports for serious user-visible performance issues
      PARISC: Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Mike Galbraith (1):
      sched: Fix signed unsigned comparison in check_preempt_tick()

Neil Horman (1):
      sctp: Fix list corruption resulting from freeing an association on a list

Nikola Pajkovsky (1):
      udf: fix retun value on error path in udf_load_logicalvol

Oleg Nesterov (3):
      cred: copy_process() should clear child->replacement_session_keyring
      epoll: introduce POLLFREE to flush ->signalfd_wqh before kfree()
      epoll: ep_unregister_pollwait() can use the freed pwq->whead

Paul E. McKenney (1):
      sparc64: Eliminate obsolete __handle_softirq() function

Paul Moore (1):
      cipso: don't follow a NULL pointer when setsockopt() is called

Pavel Shilovsky (1):
      fuse: fix stat call on 32 bit platforms

Philipp Hahn (1):
      fix pgd_lock deadlock

Richard Cochran (1):
      ntp: Correct TAI offset during leap second

Richard Kennedy (1):
      random: Reorder struct entropy_store to remove padding on 64bits

Ryusuke Konishi (1):
      nilfs2: fix NULL pointer dereference in nilfs_load_super_block()

Salman Qazi (1):
      sched/x86: Fix overflow in cyc2ns_offset

Sarah Sharp (3):
      xhci: Don't write zeroed pointers to xHC registers.
      xhci: Reset reserved command ring TRBs on cleanup.
      xhci: Increase reset timeout for Renesas 720201 host.

Sasha Levin (2):
      ntp: Fix integer overflow when setting time
      phonet: Check input from user before allocating

Sony Chacko (1):
      netxen: support for GbE port settings

Steffen Rumler (1):
      powerpc: Fix kernel panic during kernel module load

Stephan Bärwolf (2):
      KVM: x86: extend "struct x86_emulate_ops" with "get_cpuid"
      KVM: x86: fix missing checks in syscall emulation

Stephen M. Cameron (1):
      cciss: fix incorrect scsi status reporting

Stuart Hayes (1):
      usb: Fix deadlock in hid_reset when Dell iDRAC is reset

Sven Schnelle (1):
      USB: CDC ACM: Fix NULL pointer dereference

Takashi Iwai (1):
      ALSA: mpu401: Fix missing initialization of irq field

Theodore Ts'o (10):
      ext4: check for zero length extent
      random: Use arch-specific RNG to initialize the entropy store
      random: make 'add_interrupt_randomness()' do something sane
      random: use lockless techniques in the interrupt path
      random: use the arch-specific rng in xfer_secondary_pool
      random: add new get_random_bytes_arch() function
      MAINTAINERS: Theodore Ts'o is taking over the random driver
      usb: feed USB device information to the /dev/random driver
      net: feed /dev/random with the MAC address when registering a device
      random: remove rand_initialize_irq()

Thomas Gleixner (6):
      time: Move common updates to a function
      timekeeping: Maintain ktime_t based offsets for hrtimers
      hrtimers: Move lock held region in hrtimer_interrupt()
      timekeeping: Provide hrtimer update function
      timekeeping: Add missing update call in timekeeping_resume()
      x86: Derandom delay_tsc for 64 bit

Thomas Jarosch (1):
      PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs

Tiejun Chen (1):
      powerpc: Add "memory" attribute for mfmsr()

Tim Bird (1):
      ARM: 7410/1: Add extra clobber registers for assembly in kernel_execve

Tony Luck (2):
      random: Add comment to random_initialize()
      dmi: Feed DMI table to /dev/random driver

Tony Zelenoff (1):
      atl1: fix kernel panic in case of DMA errors

Trond Myklebust (2):
      SUNRPC: We must not use list_for_each_entry_safe() in rpc_wake_up()
      NFSv3: Ensure that do_proc_get_root() reports errors correctly

Tyler Hicks (1):
      eCryptfs: Properly check for O_RDONLY flag before doing privileged open

Wang Xingchao (1):
      ALSA: hda - fix Copyright debug message

Wang YanQing (1):
      video:uvesafb: Fix oops that uvesafb try to execute NX-protected page

Willy Tarreau (3):
      PNP: fix "work around Dell 1536/1546 BIOS MMCONFIG bug that breaks USB"
      tcp: do_tcp_sendpages() must try to push data out on oom conditions
      Linux 2.6.32.60

Xiao Guangrong (1):
      mm: mmu_notifier: fix freed page still mapped in secondary MMU

Xiaotian Feng (1):
      tty_audit: fix tty_audit_add_data live lock on audit disabled

Zach Brown (1):
      fuse: verify all ioctl retry iov elements

bjschuma@gmail.com (1):
      NFS: Alias the nfs module to nfs4

roger blofeld (1):
      powerpc/ftrace: Fix assembly trampoline register usage

tom.leiming@gmail.com (2):
      usbnet: increase URB reference count before usb_unlink_urb
      usbnet: don't clear urb->dev in tx_complete

Ã‰meric Maschino (1):
      ia64: Add accept4() syscall

