Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0KUXnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:43:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982Ab0KUXnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:43:40 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Nov 2010 15:43:18 -0800
Message-ID: <AANLkTi=Di4UQMYyJ_wpZ6N=NZt1+3EeXL7FUsBX004YL@mail.gmail.com>
Subject: Linux 2.6.37-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

And I have to say, I'm pretty happy with how quiet things have been.
Of course,  maybe people are just lying low, waiting to ambush me next
week with a flood of patches when I'm gone in Japan, all in order to
try to be inconvenient. Because that's the kind of people kernel
developers are.

But I'm going to just keep my fingers crossed, and hope that this
means a calm release schedule. The fairly small ShortLog is appended,
and looking at the dirstat, about 75% of the changes are to drivers
(which is fairly normal), and over half of that is the DRM updates
(which is higher than normal, and apparently brought on by everybody
else being so quiet).

The remains are a random smattering in architecture code and some
filesystem (ceph stands out, but again mainly because nothing else
does) and some small network updates.

So give it a test.

  Thanks,
         Linus

---
Alessio Igor Bogani (1):
      powerpc: Update a BKL related comment

Alex Deucher (13):
      drm/radeon/kms: fix and unify tiled buffer alignment checking for r6xx/7xx
      drm/radeon/kms: fix and unify tiled buffer alignment checking for r6xx/7xx
      drm/radeon/kms: fix typo in r600 cs checker
      drm/radeon/kms: turn the backlight off explicitly for dpms
      drm/radeon/kms/atom: set sane defaults in atombios_get_encoder_mode()
      drm/radeon/kms: properly power up/down the eDP panel as needed (v4)
      drm/radeon/kms/atom: cleanup and unify DVO handling
      drm/radeon/kms/atom: add proper external encoders support
      drm/radeon/kms: register an i2c adapter name for the dp aux bus
      drm/radeon/kms: fix alignment when allocating buffers
      drm/radeon/kms: fix tiling info on evergreen
      drm/radeon/kms: fix i2c pad masks on rs4xx
      drm/radeon/kms: i2c s/sprintf/snprintf/g for safety

Alex Shi (1):
      drm/i915: Disable FBC on Ironlake to save 1W

Andres Salomon (2):
      Documentation/development-process: use -next trees instead of staging
      Documentation/development-process: more staging info

Andy Lutomirski (1):
      nouveau: Acknowledge HPD irq in handler, not bottom half

Andy Whitcroft (1):
      net: rtnetlink.h -- only include linux/netdevice.h when used by the kernel

Arnd Bergmann (3):
      staging/stradis: mark as "depends on BKL"
      BKL: remove extraneous #include <smp_lock.h>
      BKL: remove references to lock_kernel from comments

Arnd Hannemann (1):
      b43legacy: Fix compile on ARM architecture

Avi Kivity (2):
      KVM: Correct ordering of ldt reload wrt fs/gs reload
      KVM: VMX: Fix host userspace gsbase corruption

Ben Skeggs (3):
      drm/nva3: fix overflow in fixed point math used for pll calculation
      drm/nv50: implement possible workaround for NV86 PGRAPH TLB flush hang
      drm/nouveau: don't expose backlight control when available through ACPI

Benjamin Herrenschmidt (1):
      powerpc: Fix div64 in bootloader

Bernhard Walle (1):
      Documentation/gpio.txt: explain poll/select usage

Catalin Marinas (1):
      nfs: Ignore kmemleak false positive in nfs_readdir_make_qstr

Chris Wilson (3):
      drm/i915: Retire any pending operations on the old scanout when switching
      drm/i915: Do not hold mutex when faulting in user addresses
      drm/i915/crt: Introduce struct intel_crt

Christian Lamparter (1):
      carl9170: fix usb anchor wait timeout

Colin Cross (1):
      PM / PM QoS: Fix reversed min and max

Dan Carpenter (2):
      ext4: missing unlock in ext4_clear_request_list()
      Documentation: make configfs example code simpler, clearer

Dan Rosenberg (1):
      rds: Integer overflow in RDS cmsg handling

Darren Hart (1):
      futex: Address compiler warnings in exit_robust_list

Darrick J. Wong (2):
      PCI: fix offset check for sysfs mmapped files
      ext4: ext4_fill_super shouldn't return 0 on corruption

Dmitry Torokhov (2):
      Input: sysrq - pass along lone Alt + SysRq
      Input: aiptek - tighten up permissions on sysfs attributes

Dongdong Deng (1):
      kgdb,ppc: Fix regression in evr register handling

Eric Dumazet (1):
      bonding: fix a race in IGMP handling

Francisco Jerez (17):
      drm/nouveau: Fix sleep while atomic in the semaphore code.
      drm/nouveau: Reject modes exceeding the integrated TMDS maximum bandwidth.
      drm/nv04-nv40: Fall back to panel rescaling if we have no usable
native mode.
      drm/nv11: Fix bad PLL detection false positive.
      drm/nouveau: Some random cleanups.
      drm/nouveau: Avoid lock dependency between ramht and ramin spinlocks.
      drm/nouveau: Reduce severity of the unknown getparam error.
      drm/nouveau: Expose some BO usage flags to userspace.
      drm/nv10: Balance RTs expected to be accessed simultaneously by
the 3d engine.
      drm/nv04: Fix scanout over the 16MB mark.
      drm/nouveau: Use "force" to decide if analog load detection is ok or not.
      drm/nouveau: Don't poll LVDS outputs.
      drm/nv10-nv20: Fix instability after MPLL changes.
      drm/nouveau: Don't use load detection for connector polling.
      drm/nouveau: Return error from nouveau_gpuobj_new if we're out of RAMIN.
      drm/nouveau: Make PCIE GART size depend on the available RAMIN space.
      drm/nouveau: Fix a few confusions between "chipset" and "card_type".

Giuseppe Cavallaro (1):
      MAINTAINERS: Add stmmac maintainer

Hans J. Koch (1):
      Documentation: change email address for Hans Koch

Heiko Carstens (1):
      [S390] ftrace: build without frame pointers on s390

Hendrik Brueckner (1):
      [S390] mm: add devmem_is_allowed() for STRICT_DEVMEM checking

Jason Wessel (1):
      kgdb,x86: fix regression in detach handling

Jean Delvare (1):
      drm/i915: Fix I2C adapter registration

Jeff Garzik (2):
      SCSI host lock push-down
      [libata] remove SCSI host lock and serial number usage from
ata_scsi_queuecmd

Jeff Layton (1):
      nfs: trivial: remove unused nfs_wait_event macro

Jesper Juhl (1):
      SUNRPC: Simplify rpc_alloc_iostats by removing pointless local variable

Jiri Slaby (1):
      drm/nouveau: ratelimit IRQ messages

Joe Perches (1):
      kernel/sysctl.c: Fix build failure with !CONFIG_PRINTK

John Fastabend (1):
      net: zero kobject in rx_queue_release

Jovi Zhang (2):
      kdb: fix memory leak in kdb_main.c
      kdb: fix crash when KDB_BASE_CMD_MAX is exceeded

Jussi Kivilinna (1):
      cfg80211: fix WIPHY_FLAG_IBSS_RSN bit

Keith Packard (1):
      drm/i915: Take advantage of auto-polling CRT hotplug detection
on PCH hardware

Ken Kawasaki (1):
      ipg.c: remove id [SUNDANCE, 0x1021]

Kumar Gala (2):
      powerpc/mm: Fix build error in setup_initial_memory_limit
      powerpc/mm: Fix module instruction tlb fault handling on Book-E 64

Linus Torvalds (5):
      Fix build failure due to hwirq.h needing smp_lock.h
      hardirq.h: remove now-empty #ifdef/#endif pair
      hardirq.h: needs sched.h if using BKL
      Revert "kernel: make /proc/kallsyms mode 400 to reduce ease of attacking"
      Linux 2.6.37-rc3

Lucas Stach (1):
      drm/nouveau: fix nv40 pcie gart size

Luis R. Rodriguez (1):
      cfg80211: fix extension channel checks to initiate communication

Lukas Czerner (2):
      fs: Do not dispatch FITRIM through separate super_operation
      ext4: Add EXT4_IOC_TRIM ioctl to handle batched discard

Marcus Meissner (1):
      kernel: make /proc/kallsyms mode 400 to reduce ease of attacking

Mark Brown (1):
      PM / OPP: Hide OPP configuration when SoCs do not provide an
implementation

Mark Mentovai (1):
      cfg80211: fix can_beacon_sec_chan, reenable HT40

Markus Trippelsdorf (1):
      ext4: fix setting random pages PageUptodate

Martin Peres (1):
      drm/nouveau: Fix compilation issues in nouveau_pm when
CONFIG_HWMON is not set

Martin Schwidefsky (4):
      [S390] fix get_user_pages_fast
      [S390] tape: add medium state notifications
      [S390] kprobes: disable interrupts throughout
      [S390] kprobes: Fix the return address of multiple kretprobes

Mattia Dongili (1):
      Input: fix typo in keycode validation supporting large scancodes

Michael Neuling (1):
      powerpc: Fix call to subpage_protection()

Namhyung Kim (1):
      3c59x: fix build failure on !CONFIG_PCI

Nicolas Kaiser (1):
      gianfar: fix signedness issue

Nishanth Aravamudan (1):
      powerpc/pseries: Don't override CONFIG_PPC_PSERIES_DEBUG

Patrick McHardy (1):
      netfilter: fix IP_VS dependencies

Paulius Zaleckas (1):
      Regression: fix mounting NFS when NFSv3 support is not compiled

Peter Zijlstra (2):
      sched: Fix runnable condition for stoptask
      sched: Fix cross-sched-class wakeup preemption

Rafael J. Wysocki (1):
      PM: Allow devices to be removed during late suspend and early resume

Rajkumar Manoharan (4):
      ath9k_htc: Update usb device ID list
      ath9k_htc: Add new devices into AR7010
      ath9k_hw: Set proper eeprom offset for AR9287 HTC devices
      ath9k_htc: Avoid setting QoS control for non-QoS frames

Randy Dunlap (3):
      kernel-doc: escape xml for structs
      MAINTAINERS: update documentation entries
      net: fix kernel-doc for sk_filter_rcu_release

Roy Spliet (1):
      drm/nouveau/pm: improve memtiming mappings

Sage Weil (16):
      Revert "ceph: update issue_seq on cap grant"
      ceph: fix small seq message skipping
      ceph: fix bad pointer dereference in ceph_fill_trace
      ceph: fix open for write on clustered mds
      ceph: only let auth caps update max_size
      ceph: re-request max_size if cap auth changes
      ceph: fix rdcache_gen usage and invalidate
      ceph: fix uid/gid on resent mds requests
      ceph: fix version check on racing inode updates
      ceph: fix update of ctime from MDS
      ceph: fix comment, remove extraneous args
      ceph: make page alignment explicit in osd interface
      ceph: explicitly specify page alignment in network messages
      ceph: fix dangling pointer
      ceph: fix frag offset for non-leftmost frags
      ceph: fix readdir EOVERFLOW on 32-bit archs

Sarveshwar Bandi (1):
      be2net: Fix to avoid firmware update when interface is not open.

Sebastian Ott (1):
      [S390] cio: fix incorrect ccw_device_init_count

Shan Wei (2):
      r8169: fix checksum broken
      8139cp: fix checksum broken

Stefan Weinhuber (1):
      [S390] vmlogrdr: purge after recording is switched off

Suresh Siddha (1):
      sched: Use group weight, idle cpu metrics to fix imbalances during idle

Tejun Heo (1):
      sata_via: apply magic FIFO fix to vt6420 too

Tetsuo Handa (1):
      net: Fix duplicate volatile warning.

Thomas Graf (2):
      ipv6: Expose IFLA_PROTINFO timer values in msecs instead of jiffies
      ipv6: Expose reachable and retrans timer values as msecs

Thomas Hellstrom (2):
      drm/vmwgfx: Fix up an error path during bo creation
      drm/ttm: Fix up a theoretical deadlock

Trond Myklebust (4):
      NLM: Fix a regression in lockd
      Revert "NFSv4: Fall back to ordinary lookup if
nfs4_atomic_open() returns EISDIR"
      NFS: Fix a couple of regressions in readdir.
      NFS: readdir shouldn't read beyond the reply returned by the server

Ulrich Weber (1):
      xfrm: update flowi saddr in icmp_send if unset

Vasiliy Kulikov (4):
      drm: radeon: fix error value sign
      net: bnx2x: fix error value sign
      drm: radeon: fix error value sign
      net: caif: spi: fix potential NULL dereference

Vivek Natarajan (1):
      ath9k: Remove pm_qos request after hw unregister.

Wolfram Sang (2):
      irda: irttp: allow zero byte packets
      net: irda: irttp: sync error paths of data- and udata-requests

Youquan Song (1):
      Fix build failure at cx25821-video driver

kerstin jonsson (1):
      powerpc: Set CONFIG_32BIT on ppc32

yangsheng (1):
      jbd2: fix /proc/fs/jbd2/<dev> when using an external journal
