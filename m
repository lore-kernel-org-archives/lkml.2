Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0DZO7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:59:11 -0400
Received: from kroah.org ([198.145.64.141]:57752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab0DZO7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:59:09 -0400
Date: Mon, 26 Apr 2010 07:57:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.12
Message-ID: <20100426145711.GA17560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.12 kernel.

All users of the 2.6.32 kernel series should upgrade.

Many thanks to maximilian attems for all of his hard work in digging out
patches from the various vendor kernel trees for this release.  It is
much appreciated.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/busses/i2c-i801           |    3 
 Documentation/laptops/thinkpad-acpi.txt     |   55 +--
 Makefile                                    |    2 
 arch/arm/boot/compressed/head.S             |    2 
 arch/ia64/kvm/kvm-ia64.c                    |    9 
 arch/sh/include/asm/elf.h                   |    6 
 arch/sh/kernel/smp.c                        |    1 
 arch/um/sys-x86_64/Makefile                 |    3 
 arch/x86/Kconfig.cpu                        |    2 
 arch/x86/include/asm/cpufeature.h           |    1 
 arch/x86/include/asm/kvm_emulate.h          |   15 
 arch/x86/include/asm/kvm_host.h             |   11 
 arch/x86/include/asm/msr-index.h            |    1 
 arch/x86/include/asm/rwsem.h                |   81 +++--
 arch/x86/include/asm/smp.h                  |    9 
 arch/x86/kernel/amd_iommu.c                 |    4 
 arch/x86/kernel/amd_iommu_init.c            |    6 
 arch/x86/kernel/aperture_64.c               |   15 
 arch/x86/kernel/apic/apic.c                 |    2 
 arch/x86/kernel/cpu/amd.c                   |   53 ---
 arch/x86/kernel/cpu/intel_cacheinfo.c       |  250 +++++++++------
 arch/x86/kernel/cpu/perf_event.c            |  104 ++++++
 arch/x86/kernel/crash.c                     |    6 
 arch/x86/kernel/hpet.c                      |   25 +
 arch/x86/kernel/pci-gart_64.c               |    3 
 arch/x86/kvm/emulate.c                      |  192 +++++++++---
 arch/x86/kvm/mmu.c                          |   28 -
 arch/x86/kvm/mmu.h                          |    6 
 arch/x86/kvm/paging_tmpl.h                  |   11 
 arch/x86/kvm/svm.c                          |   34 +-
 arch/x86/kvm/vmx.c                          |   43 ++
 arch/x86/kvm/x86.c                          |  366 +++++++++++++++++------
 arch/x86/lib/Makefile                       |    3 
 arch/x86/lib/cache-smp.c                    |   19 +
 arch/x86/lib/rwsem_64.S                     |   81 +++++
 arch/x86/pci/irq.c                          |    2 
 arch/x86/power/hibernate_asm_32.S           |   15 
 drivers/acpi/acpica/exprep.c                |   17 +
 drivers/acpi/ec.c                           |   35 --
 drivers/ata/ahci.c                          |    6 
 drivers/ata/ata_piix.c                      |    8 
 drivers/ata/libata-core.c                   |    3 
 drivers/ata/pata_ali.c                      |    4 
 drivers/ata/pata_via.c                      |    1 
 drivers/char/agp/hp-agp.c                   |    3 
 drivers/char/agp/intel-agp.c                |   15 
 drivers/char/raw.c                          |    1 
 drivers/char/tpm/tpm_tis.c                  |    1 
 drivers/char/tty_io.c                       |    2 
 drivers/gpu/drm/drm_crtc_helper.c           |    1 
 drivers/gpu/drm/drm_edid.c                  |   11 
 drivers/gpu/drm/drm_fops.c                  |   16 -
 drivers/gpu/drm/i915/intel_lvds.c           |    8 
 drivers/gpu/drm/radeon/r300.c               |    5 
 drivers/gpu/drm/radeon/radeon_connectors.c  |    7 
 drivers/gpu/drm/radeon/radeon_cp.c          |   10 
 drivers/gpu/drm/radeon/radeon_cs.c          |    3 
 drivers/gpu/drm/radeon/radeon_encoders.c    |    8 
 drivers/gpu/drm/radeon/radeon_legacy_tv.c   |   29 +
 drivers/gpu/drm/radeon/rs600.c              |    2 
 drivers/gpu/vga/vgaarb.c                    |   27 +
 drivers/hid/hid-gyration.c                  |    5 
 drivers/hwmon/lis3lv02d.c                   |   24 +
 drivers/hwmon/lis3lv02d.h                   |    1 
 drivers/hwmon/sht15.c                       |   13 
 drivers/i2c/busses/Kconfig                  |    5 
 drivers/i2c/busses/i2c-i801.c               |    5 
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |    2 
 drivers/infiniband/ulp/iser/iser_memory.c   |  122 +++----
 drivers/input/tablet/wacom_sys.c            |   10 
 drivers/md/dm.c                             |   21 +
 drivers/md/linear.c                         |   12 
 drivers/md/multipath.c                      |   20 -
 drivers/md/raid0.c                          |   13 
 drivers/md/raid10.c                         |   28 +
 drivers/message/fusion/mptctl.c             |    5 
 drivers/message/fusion/mptscsih.c           |   86 +++++
 drivers/net/e1000e/netdev.c                 |    2 
 drivers/net/igb/e1000_82575.c               |    1 
 drivers/net/igb/e1000_hw.h                  |    1 
 drivers/net/igb/igb_main.c                  |    1 
 drivers/net/r8169.c                         |   29 +
 drivers/net/wireless/ath/ar9170/usb.c       |    2 
 drivers/net/wireless/b43/Kconfig            |    6 
 drivers/net/wireless/b43/Makefile           |    2 
 drivers/net/wireless/b43/b43.h              |   28 -
 drivers/net/wireless/b43/dma.c              |    2 
 drivers/net/wireless/b43/main.c             |   10 
 drivers/net/wireless/b43/pio.c              |   79 ++---
 drivers/net/wireless/b43/pio.h              |   40 --
 drivers/net/wireless/b43/xmit.c             |    2 
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   11 
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   27 -
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    1 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 
 drivers/pci/pci.c                           |   24 +
 drivers/pci/pcie/aer/aer_inject.c           |   20 +
 drivers/platform/x86/Kconfig                |   10 
 drivers/platform/x86/eeepc-laptop.c         |  110 +++++++
 drivers/platform/x86/thinkpad_acpi.c        |  439 +++++++++++++++-------------
 drivers/scsi/libiscsi.c                     |    5 
 drivers/scsi/scsi_ioctl.c                   |    3 
 drivers/scsi/scsi_transport_fc.c            |    5 
 drivers/staging/comedi/drivers/usbdux.c     |   20 -
 drivers/usb/class/cdc-acm.c                 |   43 +-
 drivers/usb/class/cdc-acm.h                 |    1 
 drivers/video/backlight/mbp_nvidia_bl.c     |   45 ++
 drivers/watchdog/hpwdt.c                    |    2 
 drivers/watchdog/iTCO_wdt.c                 |   99 +++++-
 fs/9p/vfs_file.c                            |    2 
 fs/block_dev.c                              |    3 
 fs/cifs/cifssmb.c                           |   19 +
 fs/ecryptfs/inode.c                         |  108 +++---
 fs/ecryptfs/super.c                         |    1 
 fs/ext3/super.c                             |    2 
 fs/ext3/xattr.c                             |    7 
 fs/ext4/ext4.h                              |    6 
 fs/ext4/extents.c                           |    2 
 fs/ext4/inode.c                             |   13 
 fs/fat/namei_vfat.c                         |    6 
 fs/fs-writeback.c                           |   17 +
 fs/nfs/client.c                             |    3 
 fs/nfs/dir.c                                |    2 
 fs/nfs/nfs4proc.c                           |    4 
 fs/nfsd/nfs4xdr.c                           |   12 
 fs/ocfs2/acl.c                              |   77 ++++
 fs/ocfs2/suballoc.c                         |   13 
 fs/proc/base.c                              |    5 
 fs/quota/dquot.c                            |   12 
 fs/xfs/linux-2.6/xfs_acl.c                  |    3 
 fs/xfs/linux-2.6/xfs_aops.c                 |  118 +++++--
 fs/xfs/linux-2.6/xfs_iops.c                 |    6 
 fs/xfs/linux-2.6/xfs_super.c                |   60 +++
 fs/xfs/linux-2.6/xfs_sync.c                 |  194 +++++-------
 fs/xfs/linux-2.6/xfs_sync.h                 |    3 
 fs/xfs/quota/xfs_qm_bhv.c                   |    2 
 fs/xfs/quota/xfs_qm_syscalls.c              |    2 
 fs/xfs/xfs_alloc.c                          |   52 +--
 fs/xfs/xfs_dfrag.c                          |  106 +++++-
 fs/xfs/xfs_fsops.c                          |    2 
 fs/xfs/xfs_iget.c                           |   31 +
 fs/xfs/xfs_inode.c                          |   17 -
 fs/xfs/xfs_iomap.c                          |    9 
 fs/xfs/xfs_log_recover.c                    |   24 -
 fs/xfs/xfs_mount.c                          |    2 
 fs/xfs/xfs_mount.h                          |    1 
 fs/xfs/xfs_rw.h                             |    7 
 fs/xfs/xfs_trans.c                          |    7 
 fs/xfs/xfs_trans.h                          |    2 
 fs/xfs/xfs_vnodeops.c                       |  179 ++++-------
 fs/xfs/xfs_vnodeops.h                       |    1 
 include/drm/drm_pciids.h                    |    2 
 include/linux/freezer.h                     |    7 
 include/linux/fs.h                          |    1 
 include/linux/kvm_host.h                    |    7 
 include/linux/module.h                      |    2 
 include/linux/nfs_fs_sb.h                   |    1 
 include/linux/pci.h                         |    5 
 include/linux/pci_ids.h                     |    3 
 include/linux/resource.h                    |    8 
 include/linux/writeback.h                   |    1 
 include/scsi/scsi_bsg_fc.h                  |    2 
 kernel/cgroup_freezer.c                     |    9 
 kernel/irq/manage.c                         |   10 
 kernel/lockdep.c                            |    6 
 kernel/module.c                             |    2 
 kernel/power/process.c                      |    2 
 kernel/sched.c                              |   19 -
 mm/readahead.c                              |    2 
 net/ipv4/tcp_input.c                        |    6 
 net/mac80211/scan.c                         |   18 -
 net/mac80211/tx.c                           |    6 
 net/mac80211/util.c                         |   20 -
 net/sunrpc/svc_xprt.c                       |   13 
 net/sunrpc/svcauth_unix.c                   |   53 +--
 net/sunrpc/svcsock.c                        |    1 
 sound/pci/hda/hda_intel.c                   |    8 
 sound/pci/hda/patch_analog.c                |    8 
 sound/pci/hda/patch_realtek.c               |   11 
 sound/pci/mixart/mixart.c                   |   24 -
 sound/usb/usbmidi.c                         |   24 +
 virt/kvm/kvm_main.c                         |   13 
 183 files changed, 3036 insertions(+), 1538 deletions(-)

Adam Jackson (1):
      drm/edid/quirks: Envision EN2028

Al Viro (1):
      fix NFS4 handling of mountpoint stat

Alan Cox (1):
      pata_ali: Fix regression with old devices

Alan Jenkins (2):
      eeepc-laptop: disable cpu speed control on EeePC 701
      eeepc-laptop: disable wireless hotplug for 1005PE

Alex Deucher (5):
      drm/radeon: add new RS880 pci id
      drm/radeon/kms: fix pal tv-out support on legacy IGP chips
      drm/radeon/kms: fix washed out image on legacy tv dac
      drm/radeon/kms: disable the tv encoder when tv/cv is not in use
      drm/radeon/kms: fix tv dac conflict resolver

Alexander Duyck (1):
      igb: add support for 82576NS SerDes adapter

Alexey Dobriyan (1):
      thinkpad-acpi: convert to seq_file

Alexey Starikovskiy (2):
      ACPI: EC: Allow multibyte access to EC
      ACPI: EC: Limit burst to 64 bits

Andre Przywara (1):
      KVM: allow bit 10 to be cleared in MSR_IA32_MC4_CTL

Andreas Herrmann (1):
      x86, amd: Get multi-node CPU info from NodeId MSR instead of PCI config space

Andrew Patterson (1):
      PCI: fix nested spinlock hang in aer_inject

Andrew Perepechko (1):
      quota: Fix possible dq_flags corruption

Andrew Stubbs (1):
      sh: Fix FDPIC binary loader

Andy Poling (1):
      xfs: Wrapped journal record corruption on read at recovery

Anton Blanchard (2):
      raw: fsync method is now required
      sched: Fix sched_getaffinity()

Avi Kivity (3):
      x86-64, rwsem: Avoid store forwarding hazard in __downgrade_write
      KVM: Don't spam kernel log when injecting exceptions due to bad cr writes
      KVM: VMX: Save/restore rflags.vm correctly in real mode

Ben Skeggs (1):
      drm/edid: allow certain bogus edids to hit a fixup path rather than fail

Bernd Porr (2):
      Staging: comedi: fix usbdux timeout bug
      Staging: comedi: usbdux.c: fix locking up of the driver when the comedi ringbuffer runs empty

Bjorn Helgaas (1):
      agp/hp: fixup hp agp after ACPI changes

Borislav Petkov (7):
      x86, lib: Add wbinvd smp helpers
      x86, cacheinfo: Fix disabling of L3 cache indices
      intel-agp: Switch to wbinvd_on_all_cpus
      x86, cacheinfo: Add cache index disable sysfs attrs only to L3 caches
      x86, cacheinfo: Calculate L3 indices
      x86, cacheinfo: Remove NUMA dependency, fix for AMD Fam10h rev D1
      x86, cacheinfo: Enable L3 CID only on AMD

Chris Wilson (1):
      drm: Return ENODEV if the inode mapping changes

Chris Wright (2):
      x86/amd-iommu: enable iommu before attaching devices
      Revert "x86: disable IOMMUs on kernel crash"

Christian Pulvermacher (1):
      ecryptfs: fix error code for missing xattrs in lower fs

Christoph Hellwig (8):
      xfs: simplify inode teardown
      xfs: fix mmap_sem/iolock inversion in xfs_free_eofblocks
      xfs: I/O completion handlers must use NOFS allocations
      xfs: check for not fully initialized inodes in xfs_ireclaim
      xfs: fix timestamp handling in xfs_setattr
      xfs: quota limit statvfs available blocks
      xfs: remove invalid barrier optimization from xfs_fsync
      xfs: fix locking for inode cache radix tree tag updates

Corentin Chary (3):
      eeepc-laptop: dmi blacklist to disable pci hotplug code
      eeepc-laptop: add hotplug_disable parameter
      eeepc-laptop: disable wireless hotplug for 1201N

Damian Lukowski (1):
      tcp: fix ICMP-RTO war

Dan Carpenter (2):
      iwlwifi: range checking issue
      ALSA: mixart: range checking proc file

Daniel T Chen (2):
      ALSA: hda: Fix 0 dB offset for Lenovo Thinkpad models using AD1981
      ALSA: hda: Set Front Mic to input vref 50% for Lenovo 3000 Y410

Dave Airlie (2):
      drm/radeon/kms: don't print error on -ERESTARTSYS.
      drm/radeon/kms: add FireMV 2400 PCI ID.

Dave Chinner (9):
      xfs: Don't flush stale inodes
      xfs: Ensure we force all busy extents in range to disk
      xfs: reclaim inodes under a write lock
      xfs: Avoid inodes in reclaim when flushing from inode cache
      xfs: reclaim all inodes by background tree walks
      xfs: fix stale inode flush avoidance
      xfs: xfs_swap_extents needs to handle dynamic fork offsets
      xfs: don't hold onto reserved blocks on remount, ro
      xfs: Non-blocking inode locking in IO completion

Eduardo Habkost (2):
      KVM: VMX: Use macros instead of hex value on cr0 initialization
      KVM: SVM: Reset cr0 properly on vcpu reset

Eli Cohen (1):
      IPoIB: Fix TX queue lockup with mixed UD/CM traffic

Eric Sandeen (5):
      ext3: Don't update the superblock in ext3_statfs()
      ext3: journal all modifications in ext3_xattr_set_handle
      fs-writeback: Add helper function to start writeback if idle
      ext4: flush delalloc blocks when space is low
      ext4: fix async i/o writes beyond 4GB to a sparse file

Eugene Teo (1):
      vgaarb: fix "target=default" passing

Evan McClain (1):
      backlight: mbp_nvidia_bl - add five more MacBook variants

Gleb Natapov (5):
      KVM: x86 emulator: Add Virtual-8086 mode of emulation
      KVM: x86 emulator: fix memory access during x86 emulation
      KVM: x86 emulator: Check IOPL level during io instruction emulation
      KVM: x86 emulator: Fix popf emulation
      KVM: Fix segment descriptor loading

Greg Kroah-Hartman (1):
      Linux 2.6.32.12

H. Peter Anvin (1):
      x86-64, rwsem: 64-bit xadd rwsem implementation

Harish Zunjarrao (1):
      SCSI: fc-transport: Use packed modifier for fc_bsg_request structure.

Henrique de Moraes Holschuh (10):
      thinkpad-acpi: fix some version quirks
      thinkpad-acpi: issue backlight class events
      thinkpad-acpi: silence bogus complain during rmmod
      thinkpad-acpi: adopt input device
      thinkpad-acpi: expose module parameters
      thinkpad-acpi: log temperatures on termal alarm (v2)
      thinkpad-acpi: use input_set_capability
      thinkpad-acpi: sync input device EV_SW initial state
      thinkpad-acpi: log initial state of rfkill switches
      thinkpad-acpi: lock down video output state access

J. Bruce Fields (3):
      nfsd4: don't try to map gid's in generic rpc code
      Revert "sunrpc: fix peername failed on closed listener"
      Revert "sunrpc: move the close processing after do recvfrom method"

Jan Kiszka (2):
      KVM: VMX: Update instruction length on intercepted BP
      KVM: x86: Fix TSS size check for 16-bit tasks

Jason Gunthorpe (1):
      xfs: Fix error return for fallocate() on XFS

Jean Delvare (1):
      hwmon: (sht15) Properly handle the case CONFIG_REGULATOR=n

Jeff Mahoney (1):
      ecryptfs: fix use with tmpfs by removing d_drop from ecryptfs_destroy_inode

Jerome Glisse (1):
      drm/radeon/kms: fix rs600 tlb flush

Jerome Oufella (1):
      hwmon: (sht15) Fix sht15_calc_temp interpolation function

Jiri Kosina (1):
      HID: fix oops in gyration_event()

Jiri Slaby (1):
      resource: move kernel function inside __KERNEL__

Joerg Roedel (2):
      x86/amd-iommu: Use helper function to destroy domain
      x86/gart: Disable GART explicitly before initialization

Joerg Schirottke (1):
      ALSA: hda - add a quirk for Clevo M570U laptop

Johannes Berg (2):
      mac80211: move netdev queue enabling to correct spot
      mac80211: fix deferred hardware scan requests

John Wright (1):
      sched: Fix a race between ttwu() and migrate_task()

JosephChan@via.com.tw (1):
      pata_via: Add VIA VX900 support

KOSAKI Motohiro (2):
      sched: sched_getaffinity(): Allow less than NR_CPUS length
      sched: Use proper type in sched_getaffinity()

Kashyap, Desai (2):
      mptctl : Remove printk which floods unnecessary messages to var/log/message
      mptspi: Fix for incorrect data underrun errata

Kiyoshi Ueda (1):
      dm mpath: fix stall when requeueing io

Larry Finger (2):
      b43: Remove reset after fatal DMA error
      b43: Allow PIO mode to be selected at module load

Linus Torvalds (5):
      x86-32: clean up rwsem inline asm statements
      x86: clean up rwsem type system
      x86-64: support native xadd rwsem implementation
      x86: Fix breakage of UML from the changes in the rwsem system
      b43: fall back gracefully to PIO mode after fatal DMA errors

Marcelo Tosatti (1):
      KVM: x86: disable paravirt mmu reporting

Mark Fasheh (1):
      ocfs2: set i_mode on disk during acl operations

Mathieu Desnoyers (3):
      modules: fix incorrect percpu usage
      lockdep: fix incorrect percpu usage
      module: fix __module_ref_addr()

Matt Domsch (1):
      tpm: autoload tpm_tis based on system PnP IDs

Matt Fleming (1):
      sh: Enable the mmu in start_secondary()

Matt Helsley (1):
      Freezer: Fix buggy resume test for tasks frozen with cgroup freezer

Michael Buesch (1):
      b43: Optimize PIO scratchbuffer usage

Michel Dänzer (1):
      drm/radeon: R300 AD only has one quad pipe.

Mike Christie (3):
      libiscsi: Fix recovery slowdown regression
      fc class: fail fast bsg requests
      SCSI: add scsi target reset support to scsi ioctl

Mike Travis (2):
      vgaarb: Fix VGA arbiter to accept PCI domains other than 0
      pci: Update pci_set_vga_state() to call arch functions

Neil Brown (1):
      nfsd: ensure sockets are closed on error

Neil Horman (2):
      r8169: offical fix for CVE-2009-4537 (overlength frame DMAs)
      r8169: clean up my printk uglyness

NeilBrown (1):
      md: deal with merge_bvec_fn in component devices better.

Nikolaus Schulz (1):
      fat: fix buffer overflow in vfat_create_shortname()

Oleg Nesterov (2):
      oom: fix the unsafe usage of badness() in proc_oom_score()
      tty: release_one_tty() forgets to put pids

Oliver Neukum (2):
      USB: cdc-acm: Update to new autopm API
      USB: cdc-acm: Fix stupid NULL pointer in resume()

Or Gerlitz (1):
      IB/iser: Rewrite SG handling for RDMA logic

Pallipadi, Venkatesh (1):
      x86, hpet: Erratum workaround for read after write of HPET comparator

Paul Mundt (1):
      PCI: kill off pci_register_set_vga_state() symbol export.

Peter Zijlstra (1):
      perf_events, x86: Implement Intel Westmere/Nehalem-EX support

Ping Cheng (1):
      Input: wacom - switch mode upon system resume

Rabin Vincent (1):
      ARM: 6031/1: fix Thumb-2 decompressor

Reinette Chatre (1):
      iwlwifi: fix scan race

Sachin Prabhu (1):
      9p: Skip check for mandatory locks when unlocking

Seth Heasley (7):
      WATCHDOG: iTCO_wdt: TCO Watchdog patch for additional Intel Cougar Point DeviceIDs
      x86/PCI: irq and pci_ids patch for Intel Cougar Point DeviceIDs
      ALSA: hda_intel: ALSA HD Audio patch for Intel Cougar Point DeviceIDs
      ALSA: hda - enable snoop for Intel Cougar Point
      ata_piix: IDE Mode SATA patch for Intel Cougar Point DeviceIDs
      ahci: AHCI and RAID mode SATA patch for Intel Cougar Point DeviceIDs
      i2c-i801: Add Intel Cougar Point device IDs

Shaohua Li (1):
      x86-32, resume: do a global tlb flush in S4 resume

Sheng Yang (1):
      KVM: VMX: Disable unrestricted guest when EPT disabled

Sridhar Samudrala (1):
      KVM: Increase NR_IOBUS_DEVS limit to 200

Stanislaw Gruszka (1):
      iwlwifi: fix nfreed--

Stefan Bader (1):
      drm/i915: Add no_lvds entry for the Clientron U800

Steve French (1):
      CIFS: initialize nbytes at the beginning of CIFSSMBWrite()

Suresh Jayaraman (1):
      cifs: Fix a kernel BUG with remote OS/2 server (try #3)

Suresh Siddha (1):
      x86: Fix double enable_IR_x2apic() call on SMP kernel on !SMP boards

Takashi Iwai (2):
      ALSA: usb - Fix Oops after usb-midi disconnection
      ALSA: hda - Add position_fix quirk for Biostar mobo

Takuya Yoshikawa (2):
      KVM: SVM: Fix memory leaks that happen when svm_create_vcpu() fails
      KVM: fix the handling of dirty bitmaps to avoid overflows

Tao Ma (1):
      ocfs2: Change bg_chain check for ocfs2_validate_gd_parent.

Tejun Heo (1):
      libata: disable NCQ on Crucial C300 SSD

Terry Loftin (1):
      e1000e: stop cleaning when we reach tx_ring->next_to_use

Thomas Gleixner (2):
      genirq: Force MSI irq handlers to run with interrupts disabled
      x86: hpet: Make WARN_ON understandable

Thomas Mingarelli (1):
      WATCHDOG: hpwdt - fix lower timeout limit

Trond Myklebust (2):
      NFSv4: Fall back to ordinary lookup if nfs4_atomic_open() returns EISDIR
      NFSv4: fix delegated locking

Tyler Hicks (1):
      eCryptfs: Decrypt symlink target for stat size

Valentin Longchamp (1):
      setup correct int pipe type in ar9170_usb_exec_cmd

Wey-Yi Guy (4):
      iwlwifi: counting number of tfds can be free for 4965
      mac80211: tear down all agg queues when restart/reconfig hw
      iwlwifi: need check for valid qos packet before free
      iwlwifi: clear all tx queues when firmware ready

Wu Fengguang (1):
      readahead: fix NULL filp dereference

Xiao Guangrong (1):
      KVM: MMU: fix kvm_mmu_zap_page() and its calling path

Youquan Song (1):
      PCIe AER: prevent AER injection if hardware masks error reporting

Zhao Yakui (1):
      drm: remove the EDID blob stored in the EDID property when it is disconnected

Éric Piel (1):
      lis3: fix show rate for 8 bits chips

