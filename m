Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab0DZO71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:59:27 -0400
Received: from kroah.org ([198.145.64.141]:57761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab0DZO7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:59:13 -0400
Date: Mon, 26 Apr 2010 07:58:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.33.3
Message-ID: <20100426145803.GC17560@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.33.3 kernel.

All users of the 2.6.33 kernel series should upgrade.

Many thanks to maximilian attems for all of his work in submitting
patches for this release, it is much appreciated.

The updated 2.6.33.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.33.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.33.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/i2c/busses/i2c-i801               |    3 
 Makefile                                        |    2 
 arch/arm/boot/compressed/head.S                 |    2 
 arch/ia64/kvm/kvm-ia64.c                        |    9 
 arch/powerpc/kvm/book3s.c                       |    5 
 arch/powerpc/platforms/pseries/offline_states.h |   22 ++
 arch/s390/mm/vmem.c                             |   11 -
 arch/sh/include/asm/elf.h                       |    6 
 arch/sh/kernel/smp.c                            |    1 
 arch/sparc/kernel/ptrace_32.c                   |    4 
 arch/sparc/kernel/ptrace_64.c                   |    4 
 arch/um/sys-x86_64/Makefile                     |    3 
 arch/x86/Kconfig.cpu                            |    2 
 arch/x86/include/asm/rwsem.h                    |   81 ++++---
 arch/x86/include/asm/smp.h                      |    9 
 arch/x86/kernel/amd_iommu.c                     |    6 
 arch/x86/kernel/amd_iommu_init.c                |    5 
 arch/x86/kernel/aperture_64.c                   |   15 +
 arch/x86/kernel/apic/apic.c                     |    2 
 arch/x86/kernel/cpu/intel_cacheinfo.c           |  250 ++++++++++++++----------
 arch/x86/kernel/cpu/perf_event.c                |  104 +++++++++
 arch/x86/kernel/crash.c                         |    6 
 arch/x86/kernel/hpet.c                          |    8 
 arch/x86/kernel/kgdb.c                          |    2 
 arch/x86/kernel/mpparse.c                       |    4 
 arch/x86/kernel/pci-gart_64.c                   |    3 
 arch/x86/kvm/mmu.c                              |   11 -
 arch/x86/kvm/svm.c                              |   25 +-
 arch/x86/kvm/vmx.c                              |   37 ++-
 arch/x86/kvm/x86.c                              |   45 +---
 arch/x86/lib/Makefile                           |    3 
 arch/x86/lib/cache-smp.c                        |   19 +
 arch/x86/lib/rwsem_64.S                         |   81 +++++++
 arch/x86/pci/irq.c                              |    2 
 arch/x86/power/hibernate_asm_32.S               |   15 -
 drivers/acpi/acpica/exprep.c                    |   17 +
 drivers/acpi/ec.c                               |   35 ---
 drivers/ata/ahci.c                              |    6 
 drivers/ata/ata_piix.c                          |    8 
 drivers/ata/libata-core.c                       |    3 
 drivers/ata/pata_via.c                          |    1 
 drivers/char/agp/intel-agp.c                    |   15 -
 drivers/char/raw.c                              |    1 
 drivers/char/tty_io.c                           |    2 
 drivers/gpu/drm/drm_crtc_helper.c               |    1 
 drivers/gpu/drm/drm_edid.c                      |   11 -
 drivers/gpu/drm/drm_fops.c                      |   16 -
 drivers/gpu/drm/i915/intel_lvds.c               |    8 
 drivers/gpu/drm/radeon/atom.c                   |   10 
 drivers/gpu/drm/radeon/r300.c                   |    5 
 drivers/gpu/drm/radeon/radeon_combios.c         |   20 +
 drivers/gpu/drm/radeon/radeon_connectors.c      |    7 
 drivers/gpu/drm/radeon/radeon_cp.c              |   10 
 drivers/gpu/drm/radeon/radeon_cs.c              |   15 -
 drivers/gpu/drm/radeon/radeon_device.c          |    8 
 drivers/gpu/drm/radeon/radeon_encoders.c        |    8 
 drivers/gpu/drm/radeon/radeon_legacy_tv.c       |   29 ++
 drivers/gpu/drm/radeon/rs600.c                  |    2 
 drivers/hid/hid-gyration.c                      |    5 
 drivers/hwmon/sht15.c                           |   13 -
 drivers/i2c/busses/Kconfig                      |    5 
 drivers/i2c/busses/i2c-i801.c                   |    5 
 drivers/infiniband/ulp/ipoib/ipoib_cm.c         |    2 
 drivers/input/sparse-keymap.c                   |    2 
 drivers/input/tablet/wacom_sys.c                |   12 -
 drivers/md/dm-ioctl.c                           |   19 +
 drivers/md/dm.c                                 |    7 
 drivers/md/dm.h                                 |    4 
 drivers/md/linear.c                             |   12 -
 drivers/md/multipath.c                          |   20 +
 drivers/md/raid0.c                              |   13 -
 drivers/md/raid10.c                             |   28 +-
 drivers/net/e1000e/netdev.c                     |    2 
 drivers/net/r8169.c                             |    4 
 drivers/net/wireless/ath/ar9170/usb.c           |    2 
 drivers/net/wireless/ath/ath9k/main.c           |    3 
 drivers/net/wireless/b43/Kconfig                |    6 
 drivers/net/wireless/b43/Makefile               |    2 
 drivers/net/wireless/b43/b43.h                  |   12 -
 drivers/net/wireless/b43/dma.c                  |    2 
 drivers/net/wireless/b43/main.c                 |   11 -
 drivers/net/wireless/b43/pio.h                  |   40 ---
 drivers/net/wireless/iwlwifi/iwl-4965.c         |   11 -
 drivers/net/wireless/iwlwifi/iwl-5000.c         |    2 
 drivers/net/wireless/iwlwifi/iwl-agn.c          |    2 
 drivers/net/wireless/iwlwifi/iwl-scan.c         |   27 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    4 
 drivers/pci/pci.c                               |   24 ++
 drivers/scsi/libiscsi.c                         |    5 
 drivers/usb/class/cdc-acm.c                     |   43 ++--
 drivers/usb/class/cdc-acm.h                     |    1 
 drivers/video/backlight/mbp_nvidia_bl.c         |   45 ++++
 drivers/video/sunxvr500.c                       |   24 +-
 drivers/watchdog/hpwdt.c                        |    2 
 drivers/watchdog/iTCO_wdt.c                     |   99 ++++++++-
 fs/9p/vfs_file.c                                |    2 
 fs/block_dev.c                                  |    3 
 fs/cifs/cifssmb.c                               |   19 +
 fs/ecryptfs/inode.c                             |  108 +++++-----
 fs/ecryptfs/super.c                             |    1 
 fs/ext4/ext4.h                                  |    6 
 fs/ext4/extents.c                               |    2 
 fs/ext4/inode.c                                 |    2 
 fs/fat/namei_vfat.c                             |    6 
 fs/nfs/client.c                                 |    3 
 fs/nfs/dir.c                                    |    2 
 fs/nfs/nfs4proc.c                               |    4 
 fs/nfsd/nfs4xdr.c                               |   12 -
 fs/ocfs2/acl.c                                  |   77 ++++++-
 fs/ocfs2/suballoc.c                             |   13 -
 fs/proc/base.c                                  |    5 
 fs/quota/dquot.c                                |   12 -
 fs/reiserfs/super.c                             |   10 
 fs/xfs/linux-2.6/xfs_aops.c                     |   93 +++++---
 fs/xfs/linux-2.6/xfs_sync.c                     |   10 
 fs/xfs/xfs_iget.c                               |   19 +
 include/drm/drm_pciids.h                        |    2 
 include/linux/dm-ioctl.h                        |    9 
 include/linux/freezer.h                         |    7 
 include/linux/fs.h                              |    1 
 include/linux/kfifo.h                           |    3 
 include/linux/kvm_host.h                        |    7 
 include/linux/module.h                          |    2 
 include/linux/nfs_fs_sb.h                       |    1 
 include/linux/pci.h                             |    5 
 include/linux/pci_ids.h                         |    3 
 kernel/cgroup_freezer.c                         |    9 
 kernel/irq/manage.c                             |   10 
 kernel/lockdep.c                                |    6 
 kernel/module.c                                 |    2 
 kernel/power/process.c                          |    2 
 kernel/sched.c                                  |   10 
 mm/readahead.c                                  |    2 
 net/mac80211/mesh.c                             |    3 
 net/mac80211/mesh_hwmp.c                        |    4 
 net/mac80211/rx.c                               |    5 
 net/mac80211/tx.c                               |    6 
 net/mac80211/util.c                             |   20 +
 sound/pci/hda/hda_intel.c                       |   10 
 sound/pci/hda/patch_analog.c                    |    8 
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/pci/mixart/mixart.c                       |   24 +-
 sound/usb/usbmidi.c                             |   24 +-
 virt/kvm/kvm_main.c                             |   13 -
 144 files changed, 1492 insertions(+), 681 deletions(-)

Adam Jackson (1):
      drm/edid/quirks: Envision EN2028

Adam Lackorzynski (1):
      powerpc: Fix SMP build with disabled CPU hotplugging.

Al Viro (1):
      fix NFS4 handling of mountpoint stat

Alex Deucher (8):
      drm/radeon: add new RS880 pci id
      drm/radeon/kms: never treat rs4xx as AGP
      drm/radeon/kms: fix pal tv-out support on legacy IGP chips
      drm/radeon/kms: fix washed out image on legacy tv dac
      drm/radeon/kms/combios: verify dac_adj values are valid
      drm/radeon/kms: more atom parser fixes (v2)
      drm/radeon/kms: disable the tv encoder when tv/cv is not in use
      drm/radeon/kms: fix tv dac conflict resolver

Alexey Starikovskiy (2):
      ACPI: EC: Allow multibyte access to EC
      ACPI: EC: Limit burst to 64 bits

Andi Kleen (1):
      x86: Handle overlapping mptables

Andre Przywara (1):
      KVM: allow bit 10 to be cleared in MSR_IA32_MC4_CTL

Andrew Perepechko (1):
      quota: Fix possible dq_flags corruption

Andrew Stubbs (1):
      sh: Fix FDPIC binary loader

Anton Blanchard (2):
      raw: fsync method is now required
      sched: Fix sched_getaffinity()

Avi Kivity (3):
      x86-64, rwsem: Avoid store forwarding hazard in __downgrade_write
      KVM: Don't spam kernel log when injecting exceptions due to bad cr writes
      KVM: VMX: Save/restore rflags.vm correctly in real mode

Ben Skeggs (1):
      drm/edid: allow certain bogus edids to hit a fixup path rather than fail

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

Chris Wright (3):
      x86/amd-iommu: Pt mode fix for domain_destroy
      x86/amd-iommu: enable iommu before attaching devices
      Revert "x86: disable IOMMUs on kernel crash"

Christian Borntraeger (1):
      s390: disable change bit override

Christian Pulvermacher (1):
      ecryptfs: fix error code for missing xattrs in lower fs

Christoph Hellwig (1):
      xfs: fix locking for inode cache radix tree tag updates

Dan Carpenter (2):
      iwlwifi: range checking issue
      ALSA: mixart: range checking proc file

Daniel T Chen (1):
      ALSA: hda: Fix 0 dB offset for Lenovo Thinkpad models using AD1981

Dave Airlie (2):
      drm/radeon/kms: don't print error on -ERESTARTSYS.
      drm/radeon/kms: add FireMV 2400 PCI ID.

Dave Chinner (2):
      xfs: Non-blocking inode locking in IO completion
      xfs: check for more work before sleeping in xfssyncd

David Härdeman (1):
      include/linux/kfifo.h: fix INIT_KFIFO()

David S. Miller (2):
      sparc: Fix regset register window handling.
      sunxvr500: Ignore secondary output PCI devices.

Eli Cohen (1):
      IPoIB: Fix TX queue lockup with mixed UD/CM traffic

Eric Sandeen (1):
      ext4: fix async i/o writes beyond 4GB to a sparse file

Evan McClain (1):
      backlight: mbp_nvidia_bl - add five more MacBook variants

Felix Fietkau (1):
      ath9k: fix double calls to ath_radio_enable

Greg Kroah-Hartman (1):
      Linux 2.6.33.3

H. Peter Anvin (1):
      x86-64, rwsem: 64-bit xadd rwsem implementation

Jan Kiszka (2):
      KVM: VMX: Update instruction length on intercepted BP
      KVM: x86: Fix TSS size check for 16-bit tasks

Jason Wessel (1):
      x86,kgdb: Always initialize the hw breakpoint attribute

Javier Cardona (1):
      mac80211: Handle mesh action frames in ieee80211_rx_h_action

Jean Delvare (1):
      hwmon: (sht15) Properly handle the case CONFIG_REGULATOR=n

Jeff Mahoney (2):
      reiserfs: Fix locking BUG during mount failure
      ecryptfs: fix use with tmpfs by removing d_drop from ecryptfs_destroy_inode

Jerome Glisse (1):
      drm/radeon/kms: fix rs600 tlb flush

Jerome Oufella (1):
      hwmon: (sht15) Fix sht15_calc_temp interpolation function

Jiri Kosina (1):
      HID: fix oops in gyration_event()

Joerg Roedel (2):
      x86/amd-iommu: Use helper function to destroy domain
      x86/gart: Disable GART explicitly before initialization

Joerg Schirottke (1):
      ALSA: hda - add a quirk for Clevo M570U laptop

Johannes Berg (1):
      mac80211: move netdev queue enabling to correct spot

JosephChan@via.com.tw (1):
      pata_via: Add VIA VX900 support

KOSAKI Motohiro (2):
      sched: sched_getaffinity(): Allow less than NR_CPUS length
      sched: Use proper type in sched_getaffinity()

Larry Finger (1):
      b43: Allow PIO mode to be selected at module load

Linus Torvalds (5):
      x86-32: clean up rwsem inline asm statements
      x86: clean up rwsem type system
      x86-64: support native xadd rwsem implementation
      x86: Fix breakage of UML from the changes in the rwsem system
      b43: fall back gracefully to PIO mode after fatal DMA errors

Mark Fasheh (1):
      ocfs2: set i_mode on disk during acl operations

Mathieu Desnoyers (3):
      modules: fix incorrect percpu usage
      lockdep: fix incorrect percpu usage
      module: fix __module_ref_addr()

Matt Fleming (1):
      sh: Enable the mmu in start_secondary()

Matt Helsley (1):
      Freezer: Fix buggy resume test for tasks frozen with cgroup freezer

Michel Dänzer (1):
      drm/radeon: R300 AD only has one quad pipe.

Michele Ballabio (1):
      ALSA: hda - Add ASRock mobo to MSI blacklist

Mike Christie (1):
      libiscsi: Fix recovery slowdown regression

Mike Travis (1):
      pci: Update pci_set_vga_state() to call arch functions

Neil Horman (1):
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

Pallipadi, Venkatesh (1):
      x86, hpet: Erratum workaround for read after write of HPET comparator

Paul Mundt (1):
      PCI: kill off pci_register_set_vga_state() symbol export.

Peter Rajnoha (1):
      dm ioctl: introduce flag indicating uevent was generated

Peter Zijlstra (1):
      perf_events, x86: Implement Intel Westmere/Nehalem-EX support

Ping Cheng (1):
      Input: wacom - switch mode upon system resume

Porsch, Marco (1):
      mac80211: fix PREQ processing and one small bug

Rabin Vincent (1):
      ARM: 6031/1: fix Thumb-2 decompressor

Reinette Chatre (2):
      iwlwifi: fix regulatory
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

Sridhar Samudrala (1):
      KVM: Increase NR_IOBUS_DEVS limit to 200

Stefan Bader (1):
      drm/i915: Add no_lvds entry for the Clientron U800

Stefan Lippers-Hollmann (1):
      drm/radeon/kms: Fix NULL pointer dereference if memory allocation failed in a simple way

Steve French (1):
      CIFS: initialize nbytes at the beginning of CIFSSMBWrite()

Suresh Jayaraman (1):
      cifs: Fix a kernel BUG with remote OS/2 server (try #3)

Suresh Siddha (1):
      x86: Fix double enable_IR_x2apic() call on SMP kernel on !SMP boards

Takashi Iwai (3):
      ALSA: hda - Add MSI blacklist for Aopen MZ915-M
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

Thomas Gleixner (1):
      genirq: Force MSI irq handlers to run with interrupts disabled

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

Yong Wang (1):
      Input: sparse-keymap - free the right keymap on error

Zhao Yakui (1):
      drm: remove the EDID blob stored in the EDID property when it is disconnected

