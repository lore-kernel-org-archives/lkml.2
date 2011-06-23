Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab1FWWa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:30:58 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49887 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760081Ab1FWWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:30:55 -0400
X-Sasl-enc: V4JPjmar2pEcw7NAAVq3wb0JWTH2cxkG8y/m5+C6Ctg3 1308868252
Date: Thu, 23 Jun 2011 15:30:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.42
Message-ID: <20110623223026.GA25866@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.42 kernel.

All users of the 2.6.32 series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 
 arch/powerpc/kernel/misc_64.S           |   13 +++---
 arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++
 arch/x86/include/asm/uaccess.h          |    2 
 arch/x86/kernel/amd_iommu_init.c        |    8 +--
 arch/x86/kernel/cpu/amd.c               |   16 +++++--
 arch/x86/kernel/process_32.c            |    1 
 arch/x86/kernel/process_64.c            |    1 
 arch/x86/lib/copy_user_64.S             |    4 -
 arch/x86/xen/mmu.c                      |    2 
 arch/x86/xen/multicalls.c               |   12 ++---
 block/blk-core.c                        |    2 
 block/blk.h                             |    3 -
 drivers/acpi/scan.c                     |   12 ++---
 drivers/ata/pata_cmd64x.c               |   66 +++++++++++++++++++++-----------
 drivers/ata/pata_hpt366.c               |    8 ---
 drivers/ata/pata_hpt37x.c               |   21 ++++------
 drivers/ata/pata_hpt3x2n.c              |   15 ++-----
 drivers/ata/pata_sil680.c               |    6 --
 drivers/block/brd.c                     |   11 +++--
 drivers/block/loop.c                    |   11 +++--
 drivers/block/nbd.c                     |    6 ++
 drivers/char/i8k.c                      |    4 -
 drivers/cpufreq/cpufreq.c               |   20 ++++++++-
 drivers/cpufreq/cpufreq_stats.c         |   22 +++++++++-
 drivers/cpuidle/governors/menu.c        |    4 +
 drivers/gpu/drm/i915/intel_lvds.c       |    8 +++
 drivers/gpu/drm/radeon/radeon_device.c  |    1 
 drivers/md/dm-table.c                   |   17 ++++++++
 drivers/md/md.c                         |    2 
 drivers/md/raid5.c                      |    8 +--
 drivers/mtd/mtdconcat.c                 |    4 -
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 
 drivers/net/wireless/p54/p54usb.c       |    1 
 drivers/pci/hotplug/pcihp_slot.c        |   45 +++++++++++++++++++++
 drivers/pci/pci.c                       |    8 ++-
 drivers/pci/quirks.c                    |   10 ++++
 drivers/scsi/scsi_scan.c                |   11 ++---
 drivers/scsi/scsi_sysfs.c               |   19 +++------
 drivers/scsi/ultrastor.c                |    2 
 drivers/staging/usbip/usbip_common.c    |    2 
 drivers/usb/class/cdc-acm.c             |    2 
 drivers/usb/core/hub.c                  |    6 +-
 drivers/usb/gadget/at91_udc.c           |    2 
 drivers/usb/gadget/f_rndis.c            |    3 -
 drivers/usb/host/ohci-pci.c             |   12 ++++-
 drivers/usb/host/xhci-mem.c             |   18 ++++++--
 drivers/usb/serial/cp210x.c             |    4 +
 drivers/usb/serial/ftdi_sio.c           |    2 
 drivers/usb/serial/ftdi_sio_ids.h       |    6 ++
 drivers/usb/serial/garmin_gps.c         |   20 ++++++---
 drivers/usb/serial/moto_modem.c         |    1 
 drivers/xen/events.c                    |    9 ----
 fs/block_dev.c                          |   27 ++++++++-----
 fs/dcookies.c                           |    3 +
 fs/ecryptfs/keystore.c                  |   46 ++++++++++------------
 fs/exec.c                               |    5 --
 fs/ext3/namei.c                         |   13 +++++-
 fs/ext4/mballoc.c                       |    2 
 fs/fat/file.c                           |    2 
 fs/jbd/commit.c                         |    9 +++-
 fs/jbd/journal.c                        |   16 ++++++-
 fs/partitions/ldm.c                     |    5 ++
 fs/ubifs/journal.c                      |    1 
 fs/ubifs/sb.c                           |    3 -
 fs/ubifs/shrinker.c                     |    6 ++
 fs/ubifs/super.c                        |    1 
 fs/xfs/linux-2.6/xfs_sync.c             |   16 +++++--
 fs/xfs/linux-2.6/xfs_sync.h             |    1 
 fs/xfs/xfs_iget.c                       |    1 
 include/linux/interrupt.h               |    3 -
 include/linux/pci_ids.h                 |    2 
 include/linux/seqlock.h                 |    4 -
 kernel/irq/manage.c                     |   11 ++++-
 kernel/irq/pm.c                         |    3 -
 kernel/lockdep.c                        |    2 
 kernel/time/timekeeping.c               |    9 +++-
 kernel/trace/ftrace.c                   |   12 +++--
 lib/locking-selftest.c                  |    2 
 mm/hugetlb.c                            |    4 -
 mm/kmemleak.c                           |    7 ++-
 mm/page_alloc.c                         |    2 
 net/atm/atm_sysfs.c                     |   10 ++++
 net/ipv6/netfilter/ip6t_REJECT.c        |    4 +
 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 ---
 net/netfilter/xt_DSCP.c                 |    2 
 net/sunrpc/xprtsock.c                   |   16 ++++++-
 net/wireless/nl80211.c                  |    2 
 sound/pci/hda/patch_realtek.c           |    1 
 sound/pci/hda/patch_sigmatel.c          |    2 
 sound/soc/codecs/wm_hubs.c              |   24 ++++++-----
 91 files changed, 552 insertions(+), 256 deletions(-)

Alan Stern (4):
      OHCI: fix regression caused by nVidia shutdown workaround
      fix memory leak in scsi_report_lun_scan
      fix refcounting bug in scsi_get_host_dev
      fix duplicate removal on error path in scsi_sysfs_add_sdev

Andrew Barry (1):
      mm/page_alloc.c: prevent unending loop in __alloc_pages_slowpath()

Artem Bityutskiy (3):
      UBIFS: fix a rare memory leak in ro to rw remounting path
      UBIFS: fix shrinker object count reports
      UBIFS: fix memory leak on error path

Bartlomiej Zolnierkiewicz (3):
      pata_cmd64x: fix PIO setup
      pata_cmd64x: cmd648_bmdma_stop() fix
      pata_cmd64x: remove unused definitions

Benedek László (1):
      USB: serial: ftdi_sio: adding support for TavIR STK500

Bjorn Helgaas (1):
      ACPI: use _HID when supplied by root-level devices

Boris Ostrovsky (1):
      x86, amd: Do not enable ARAT feature on AMD processors below family 0x12

Catalin Marinas (1):
      kmemleak: Do not return a pointer to an object that kmemleak did not get

Christian Lamparter (1):
      p54usb: add zoom 4410 usbid

Craig Shelley (1):
      USB: CP210x Add 4 Device IDs for AC-Services Devices

Dan Carpenter (1):
      xen: off by one errors in multicalls.c

Dan Williams (1):
      atm: expose ATM device index in sysfs

Daniel Haid (1):
      drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

Daniel T Chen (1):
      ALSA: hda: Fix quirk for Dell Inspiron 910

Dave Jones (1):
      CPUFREQ: Remove cpufreq_stats sysfs entries on module unload.

David Chang (1):
      staging: usbip: fix wrong endian conversion

David Henningsson (1):
      ALSA: HDA: Use one dmic only for Dell Studio 1558

Dmitry Torokhov (1):
      USB: xhci - fix interval calculation for FS isoc endpoints

Elizabeth Jennifer Myers (1):
      USB: moto_modem: Add USB identifier for the Motorola VE240.

Eric B Munson (1):
      powerpc/oprofile: Handle events that raise an exception without overflowing

Felipe Balbi (1):
      usb: gadget: rndis: don't test against req->length

Felix Radensky (1):
      mtd: mtdconcat: fix NAND OOB write

Fernando Luis Vazquez Cao (2):
      netfilter: IPv6: initialize TOS field in REJECT target module
      netfilter: IPv6: fix DSCP mangle code

Frederic Weisbecker (1):
      rcu: Fix unpaired rcu_irq_enter() from locking selftests

Greg Kroah-Hartman (2):
      Revert "iwlagn: Support new 5000 microcode."
      Linux 2.6.32.42

Hans de Goede (1):
      drm/i915: Add a no lvds quirk for the Asus EeeBox PC EB1007

Hemant Pedanekar (1):
      PCI: Add quirk for setting valid class for TI816X Endpoint

Hermann Kneissel (1):
      USB: gamin_gps: Fix for data transfer problems in native mode

Hugh Dickins (1):
      mm: fix ENOSPC returned by handle_mm_fault()

Ian Campbell (1):
      xen: events: do not unmask event channels on resume

Jacob Shin (1):
      CPU hotplug, re-create sysfs directory and symlinks

James Bottomley (3):
      block: add proper state guards to __elv_next_request
      Fix oops caused by queue refcounting failure
      pata_cm64x: fix boot crash on parisc

Jan Kara (2):
      ext3: Fix fs corruption when make_indexed_dir() fails
      jbd: Fix forever sleeping process in do_get_write_access()

Jean-Christophe PLAGNIOL-VILLARD (1):
      usb/gadget: at91sam9g20 fix end point max packet size

Jens Axboe (1):
      block: export blk_{get,put}_queue()

Jiri Olsa (1):
      x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit

Joerg Roedel (1):
      x86/amd-iommu: Fix 3 possible endless loops

Johannes Weiner (1):
      xfs: properly account for reclaimed inodes

Jordan_Hargrave@Dell.com (1):
      PCI: Set PCIE maxpayload for card during hotplug insertion

Kasper Pedersen (1):
      time: Compensate for rounding on odd-frequency clocksources

Libor Pechacek (1):
      USB: core: Tolerate protocol stall during hub and port status read

Linus Torvalds (1):
      PCI: allow matching of prefetchable resources to non-prefetchable windows

Luca Tettamanti (1):
      i8k: Avoid lahf in 64-bit code

Luciano Coelho (1):
      nl80211: fix check for valid SSID size in scan operations

Mark Brown (2):
      ASoC: Ensure output PGA is enabled for line outputs in wm_hubs
      ASoC: Add some missing volume update bit sets for wm_hubs devices

Mathias Krause (1):
      exec: delay address limit change until point of no return

Milan Broz (1):
      dm table: reject devices without request fns

Milton Miller (2):
      powerpc/kexec: Fix memory corruption from unallocated slaves
      seqlock: Don't smp_rmb in seqlock reader spin loop

Namhyung Kim (8):
      loop: limit 'max_part' module param to DISK_MAX_PARTS
      loop: handle on-demand devices correctly
      brd: limit 'max_part' module param to DISK_MAX_PARTS
      brd: handle on-demand devices correctly
      nbd: limit module parameters to a sane value
      md: check ->hot_remove_disk when removing disk
      md/raid5: fix raid5_set_bi_hw_segments
      md/raid5: fix FUA request handling in ops_run_io()

OGAWA Hirofumi (1):
      fat: Fix corrupt inode flags when remove ATTR_SYS flag

Patrick McHardy (1):
      netfilter: nf_conntrack_reasm: properly handle packets fragmented into a single fragment

Peter Zijlstra (1):
      lockdep: Fix lock_is_held() on recursion

Robert Richter (1):
      oprofile, dcookies: Fix possible circular locking dependency

Roedel, Joerg (1):
      x86, amd: Use _safe() msr access for GartTlbWlk disable code

Samuel Thibault (1):
      Fix Ultrastor asm snippet

Sarah Sharp (1):
      xhci: Fix full speed bInterval encoding.

Sergei Shtylyov (1):
      ata: use pci_dev->revision

Steffen Sledz (1):
      USB: serial: add another 4N-GALAXY.DE PID to ftdi_sio driver

Steven Rostedt (1):
      ftrace: Only update the function code on write to filter files

Ted Ts'o (1):
      jbd: fix fsync() tid wraparound bug

Tejun Heo (1):
      block: rescan partitions on invalidated devices on -ENOMEDIA too

Tero Kristo (1):
      cpuidle: menu: fixed wrapping timers at 4.294 seconds

Thomas Gleixner (2):
      genirq: Add IRQF_FORCE_RESUME
      xen: Use IRQF_FORCE_RESUME

Tian, Kevin (1):
      xen mmu: fix a race window causing leave_mm BUG()

Timo Warns (1):
      Fix for buffer overflow in ldm_frag_add not sufficient

Toby Gray (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia E7 and C7

Trond Myklebust (1):
      SUNRPC: Deal with the lack of a SYN_SENT sk->sk_state_change callback...

Tyler Hicks (1):
      eCryptfs: Allow 2 scatterlist entries for encrypted filenames

Yang Ruirui (1):
      ext4: release page cache in ext4_mb_load_buddy error path

steven finney (1):
      Fix memory leak in cpufreq_stat

