Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab0I0Ak7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:40:59 -0400
Received: from kroah.org ([198.145.64.141]:41347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0I0Ak6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:40:58 -0400
Date: Sun, 26 Sep 2010 17:36:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.6
Message-ID: <20100927003608.GA20395@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.6 kernel.

All users of the 2.6.35 kernel series must upgrade.

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                 |    2 
 arch/alpha/kernel/err_marvel.c           |    6 
 arch/alpha/kernel/proto.h                |    3 
 arch/alpha/kernel/sys_cabriolet.c        |   19 +
 arch/alpha/kernel/sys_takara.c           |   11 -
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 
 arch/ia64/kernel/fsys.S                  |   30 ++
 arch/sparc/include/asm/oplib_64.h        |   27 --
 arch/sparc/prom/cif.S                    |   16 -
 arch/sparc/prom/console_64.c             |   48 +++-
 arch/sparc/prom/devops_64.c              |   36 +++
 arch/sparc/prom/misc_64.c                |  314 +++++++++++++++++++++----------
 arch/sparc/prom/p1275.c                  |  102 ----------
 arch/sparc/prom/tree_64.c                |  210 +++++++++++++++-----
 arch/x86/kvm/emulate.c                   |    4 
 arch/x86/kvm/mmu.c                       |    8 
 arch/x86/kvm/paging_tmpl.h               |   28 ++
 arch/x86/kvm/vmx.c                       |    4 
 arch/x86/kvm/x86.c                       |    7 
 arch/x86/lib/atomic64_386_32.S           |   38 +--
 arch/x86/oprofile/nmi_int.c              |    4 
 drivers/base/power/main.c                |    1 
 drivers/char/agp/intel-agp.c             |   44 +++-
 drivers/char/agp/intel-agp.h             |   19 +
 drivers/char/agp/intel-gtt.c             |   47 ++++
 drivers/char/mem.c                       |    3 
 drivers/char/virtio_console.c            |    6 
 drivers/gpu/drm/i915/i915_drv.c          |    6 
 drivers/gpu/drm/i915/intel_display.c     |    8 
 drivers/gpu/drm/nouveau/nv50_instmem.c   |    2 
 drivers/message/fusion/mptscsih.c        |    2 
 drivers/net/bonding/bond_3ad.c           |    3 
 drivers/net/bonding/bond_alb.c           |    3 
 drivers/net/cxgb3/cxgb3_main.c           |    2 
 drivers/net/eql.c                        |    2 
 drivers/net/usb/hso.c                    |    2 
 drivers/pci/intel-iommu.c                |   90 ++++----
 drivers/platform/x86/dell-wmi.c          |    2 
 drivers/platform/x86/hp-wmi.c            |   51 +++--
 drivers/rtc/rtc-s3c.c                    |   13 -
 drivers/staging/vt6655/wpactl.c          |   11 -
 drivers/usb/musb/musb_debugfs.c          |    5 
 drivers/usb/serial/mos7720.c             |    3 
 drivers/usb/serial/mos7840.c             |    3 
 drivers/video/sis/sis_main.c             |    3 
 drivers/video/via/ioctl.c                |    2 
 fs/aio.c                                 |   13 +
 fs/char_dev.c                            |    4 
 fs/compat.c                              |    2 
 fs/gfs2/log.c                            |    2 
 fs/notify/inotify/inotify_user.c         |    7 
 fs/proc/vmcore.c                         |    2 
 fs/xfs/linux-2.6/xfs_ioctl.c             |    2 
 include/linux/ksm.h                      |   20 -
 include/linux/kvm_host.h                 |    1 
 include/linux/mm.h                       |    8 
 include/linux/mmzone.h                   |   13 +
 include/linux/vmstat.h                   |   22 ++
 include/net/sock.h                       |    1 
 include/net/tcp.h                        |   36 ++-
 include/net/udp.h                        |    1 
 kernel/exit.c                            |    5 
 kernel/hw_breakpoint.c                   |    3 
 kernel/power/snapshot.c                  |   85 ++++++--
 kernel/sched.c                           |    8 
 kernel/sys.c                             |    2 
 mm/backing-dev.c                         |    2 
 mm/ksm.c                                 |    3 
 mm/memory.c                              |   56 ++++-
 mm/mmap.c                                |    4 
 mm/mmzone.c                              |   21 ++
 mm/page_alloc.c                          |   33 ++-
 mm/percpu.c                              |    2 
 mm/vmscan.c                              |   43 +++-
 mm/vmstat.c                              |   15 +
 net/Kconfig                              |    2 
 net/bridge/br_netfilter.c                |    6 
 net/core/skbuff.c                        |    6 
 net/ipv4/datagram.c                      |    5 
 net/ipv4/route.c                         |    7 
 net/ipv4/tcp.c                           |   32 ---
 net/ipv4/tcp_timer.c                     |    8 
 net/ipv4/udp.c                           |   44 ++++
 net/ipv6/datagram.c                      |    7 
 net/ipv6/udp.c                           |   10 
 net/irda/af_irda.c                       |    4 
 net/l2tp/l2tp_eth.c                      |    2 
 net/llc/af_llc.c                         |    3 
 net/rds/recv.c                           |    2 
 net/sctp/output.c                        |    1 
 net/unix/af_unix.c                       |   15 +
 security/keys/keyctl.c                   |    6 
 sound/pci/hda/patch_sigmatel.c           |   12 +
 virt/kvm/kvm_main.c                      |    1 
 94 files changed, 1264 insertions(+), 577 deletions(-)

Alexey Kuznetsov (1):
      tcp: Prevent overzealous packetization by SWS logic.

Amit Shah (1):
      virtio: console: Prevent userspace from submitting NULL buffers

Andrea Arcangeli (3):
      mm: fix swapin race condition
      mmap: call unlink_anon_vmas() in __split_vma() in case of error
      KVM: MMU: fix mmu notifier invalidate handler for huge spte

Andrew Morton (1):
      drivers/pci/intel-iommu.c: fix build with older gcc's

Andy Gospodarek (1):
      bonding: correctly process non-linear skbs

Arnd Bergmann (1):
      /proc/vmcore: fix seeking

Avi Kivity (3):
      KVM: Keep slot ID in memory slot structure
      KVM: Prevent internal slots from being COWed
      KVM: VMX: Fix host GDT.LIMIT corruption

Chris Wilson (2):
      drm/i915,agp/intel: Add second set of PCI-IDs for B43
      drm/i915: Ensure that the crtcinfo is populated during mode_fixup()

Christoph Lameter (1):
      mm: page allocator: calculate a better estimate of NR_FREE_PAGES when memory is low and kswapd is awake

Colin Cross (1):
      PM: Prevent waiting forever on asynchronous resume after failing suspend

Dan Carpenter (2):
      Staging: vt6655: fix buffer overflow
      net/llc: make opt unsigned in llc_ui_setsockopt()

Dan Rosenberg (8):
      USB: serial/mos*: prevent reading uninitialized stack memory
      drivers/net/usb/hso.c: prevent reading uninitialized memory
      drivers/net/cxgb3/cxgb3_main.c: prevent reading uninitialized stack memory
      drivers/net/eql.c: prevent reading uninitialized stack memory
      drivers/video/sis/sis_main.c: prevent reading uninitialized stack memory
      Prevent freeing uninitialized pointer in compat_do_readv_writev
      xfs: prevent reading uninitialized stack memory
      drivers/video/via/ioctl.c: prevent reading uninitialized stack memory

Daniel J Blueman (2):
      ALSA: hda - Fix beep frequency on IDT 92HD73xx and 92HD71Bxx codecs
      Fix unprotected access to task credentials in waitid()

David Howells (2):
      KEYS: Fix RCU no-lock warning in keyctl_session_to_parent()
      KEYS: Fix bug in keyctl_session_to_parent() if parent has no session keyring

David S. Miller (5):
      bridge: Clear INET control block of SKBs passed into ip_fragment().
      irda: Correctly clean up self->ias_obj on irda_bind() failure.
      net: RPS needs to depend upon USE_GENERIC_SMP_HELPERS
      tcp: Combat per-cpu skew in orphan tests.
      sparc64: Get rid of indirect p1275 PROM call buffer.

Eric Dumazet (5):
      gro: fix different skb headrooms
      rds: fix a leak of kernel memory
      tcp: fix three tcp sysctls tuning
      udp: add rehash on connect()
      l2tp: test for ethernet header in l2tp_eth_dev_recv()

Eric Paris (1):
      inotify: send IN_UNMOUNT events

Gleb Natapov (1):
      KVM: x86: emulator: inc/dec can have lock prefix

Greg Kroah-Hartman (1):
      Linux 2.6.35.6

Hans de Goede (1):
      virtio: console: Fix poll blocking even though there is data to read

Hugh Dickins (1):
      mm: further fix swapin race condition

Islam Amer (1):
      dell-wmi: Add support for eject key on Dell Studio 1555

Jan Kara (3):
      bdi: Initialize noop_backing_dev_info properly
      char: Mark /dev/zero and /dev/kmem as not capable of writeback
      aio: do not return ERESTARTSYS as a result of AIO

Jarek Poplawski (1):
      gro: Re-fix different skb headrooms

Jeff Moyer (1):
      aio: check for multiplication overflow in do_io_submit

Jianzhao Wang (1):
      net: blackhole route should always be recalculated

KOSAKI Motohiro (1):
      tcp: select(writefds) don't hang up when a peer close connection

Luca Barbieri (1):
      x86, asm: Use a lower case name for the end macro in atomic64_386_32.S

Marcin Slusarz (1):
      drm/nv50: initialize ramht_refs list for faked 0 channel

Mathias Nyman (1):
      usb: musb_debugfs: don't use the struct file private_data field with seq_files

Matt Helsley (1):
      hw breakpoints: Fix pid namespace bug

Mel Gorman (2):
      mm: page allocator: drain per-cpu lists after direct reclaim allocation fails
      mm: page allocator: update free page counters after pages are placed on the free list

Michael Cree (1):
      alpha: Fix printk format errors

Minchan Kim (1):
      vmscan: check all_unreclaimable in direct reclaim path

Morten H. Larsen (1):
      Fix call to replaced SuperIO functions

Nicolas Ferre (1):
      AT91: change dma resource index

Patrick Simmons (1):
      oprofile: Add Support for Intel CPU Family 6 / Model 22 (Intel Celeron 540)

Paul E. McKenney (1):
      pid: make setpgid() system call use RCU read-side critical section

Petr Tesarik (1):
      IA64: Optimize ticket spinlocks in fsys_rt_sigprocmask

Rafael J. Wysocki (1):
      PM / Hibernate: Avoid hitting OOM during preallocation of memory

Ryan Kuester (1):
      SCSI: mptsas: fix hangs caused by ATA pass-through

Stanislaw Gruszka (1):
      sched: Fix user time incorrectly accounted as system time on 32-bit

Steven Whitehouse (1):
      GFS2: gfs2_logd should be using interruptible waits

Tejun Heo (1):
      percpu: fix pcpu_last_unit_cpu

Tetsuo Handa (1):
      UNIX: Do not loop forever at unix_autobind().

Thomas Renninger (1):
      x86 platform drivers: hp-wmi Reorder event id processing

Tony Luck (2):
      IA64: fix siglock
      guard page for stacks that grow upwards

Vlad Yasevich (1):
      sctp: Do not reset the packet during sctp_packet_config().

Vladimir Zapolskiy (1):
      rtc: s3c: balance state changes of wakeup flag

Xiao Guangrong (1):
      KVM: MMU: fix direct sp's access corrupted

Zhenyu Wang (3):
      intel_agp, drm/i915: Add all sandybridge graphics devices support
      agp/intel: fix physical address mask bits for sandybridge
      agp/intel: fix dma mask bits on sandybridge

