Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0DVTTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:19:25 -0400
Received: from kroah.org ([198.145.64.141]:53739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0DVTTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:19:13 -0400
Date: Thu, 22 Apr 2010 12:18:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/197] 2.6.32.12-stable review
Message-ID: <20100422191857.GA13268@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.32.12 release.
There are 197 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Saturday, April 24, 15:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.32.12-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Documentation/i2c/busses/i2c-i801           |    3 +-
 Documentation/laptops/thinkpad-acpi.txt     |   55 +---
 Makefile                                    |    2 +-
 arch/arm/boot/compressed/head.S             |    2 +-
 arch/ia64/kvm/kvm-ia64.c                    |    9 +-
 arch/mips/mm/tlbex.c                        |   22 +-
 arch/mips/mm/uasm.c                         |    4 +-
 arch/mips/mm/uasm.h                         |    1 +
 arch/sh/include/asm/elf.h                   |    6 +-
 arch/sh/kernel/smp.c                        |    1 +
 arch/um/sys-x86_64/Makefile                 |    3 +-
 arch/x86/Kconfig.cpu                        |    2 +-
 arch/x86/include/asm/cpufeature.h           |    1 +
 arch/x86/include/asm/kvm_emulate.h          |   15 +-
 arch/x86/include/asm/kvm_host.h             |   11 +-
 arch/x86/include/asm/msr-index.h            |    1 +
 arch/x86/include/asm/rwsem.h                |   81 +++--
 arch/x86/include/asm/smp.h                  |    9 +
 arch/x86/kernel/amd_iommu.c                 |    4 +-
 arch/x86/kernel/amd_iommu_init.c            |    6 +-
 arch/x86/kernel/aperture_64.c               |   15 +-
 arch/x86/kernel/apic/apic.c                 |    2 +
 arch/x86/kernel/cpu/amd.c                   |   53 +---
 arch/x86/kernel/cpu/intel_cacheinfo.c       |  250 ++++++++++------
 arch/x86/kernel/cpu/perf_event.c            |  104 +++++++-
 arch/x86/kernel/crash.c                     |    6 -
 arch/x86/kernel/hpet.c                      |   25 ++-
 arch/x86/kernel/pci-gart_64.c               |    3 +
 arch/x86/kvm/emulate.c                      |  192 ++++++++++---
 arch/x86/kvm/mmu.c                          |   28 +-
 arch/x86/kvm/mmu.h                          |    6 +
 arch/x86/kvm/paging_tmpl.h                  |   11 +-
 arch/x86/kvm/svm.c                          |   34 ++-
 arch/x86/kvm/vmx.c                          |   43 ++-
 arch/x86/kvm/x86.c                          |  366 +++++++++++++++++------
 arch/x86/lib/Makefile                       |    3 +-
 arch/x86/lib/cache-smp.c                    |   19 ++
 arch/x86/lib/rwsem_64.S                     |   81 +++++
 arch/x86/pci/irq.c                          |    2 +
 arch/x86/power/hibernate_asm_32.S           |   15 +-
 drivers/acpi/acpica/exprep.c                |   17 +
 drivers/acpi/ec.c                           |   35 +--
 drivers/ata/ahci.c                          |    6 +
 drivers/ata/ata_piix.c                      |    8 +
 drivers/ata/libata-core.c                   |    3 +
 drivers/ata/pata_ali.c                      |    4 +-
 drivers/ata/pata_via.c                      |    1 +
 drivers/char/agp/hp-agp.c                   |    3 +-
 drivers/char/agp/intel-agp.c                |   15 +-
 drivers/char/raw.c                          |    1 +
 drivers/char/tpm/tpm_tis.c                  |    1 +
 drivers/char/tty_io.c                       |    2 +
 drivers/gpu/drm/drm_crtc_helper.c           |    1 +
 drivers/gpu/drm/drm_edid.c                  |   11 +-
 drivers/gpu/drm/drm_fops.c                  |   16 +-
 drivers/gpu/drm/i915/intel_lvds.c           |    8 +
 drivers/gpu/drm/radeon/r300.c               |    5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c  |    7 +-
 drivers/gpu/drm/radeon/radeon_cp.c          |   10 +-
 drivers/gpu/drm/radeon/radeon_cs.c          |    3 +-
 drivers/gpu/drm/radeon/radeon_encoders.c    |    8 +-
 drivers/gpu/drm/radeon/radeon_legacy_tv.c   |   29 ++-
 drivers/gpu/drm/radeon/rs600.c              |    2 +-
 drivers/gpu/vga/vgaarb.c                    |   27 ++-
 drivers/hid/hid-gyration.c                  |    5 +-
 drivers/hwmon/lis3lv02d.c                   |   24 +-
 drivers/hwmon/lis3lv02d.h                   |    1 +
 drivers/hwmon/sht15.c                       |   13 +-
 drivers/i2c/busses/Kconfig                  |    5 +-
 drivers/i2c/busses/i2c-i801.c               |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c     |    2 +
 drivers/infiniband/ulp/iser/iser_memory.c   |  122 ++++----
 drivers/input/tablet/wacom_sys.c            |   10 +-
 drivers/md/dm.c                             |   21 +-
 drivers/md/linear.c                         |   12 +-
 drivers/md/multipath.c                      |   20 +-
 drivers/md/raid0.c                          |   13 +-
 drivers/md/raid10.c                         |   28 +-
 drivers/md/raid5.c                          |   19 +-
 drivers/message/fusion/mptctl.c             |    5 +-
 drivers/message/fusion/mptscsih.c           |   86 +++++-
 drivers/net/e1000e/netdev.c                 |    2 +
 drivers/net/igb/e1000_82575.c               |    1 +
 drivers/net/igb/e1000_hw.h                  |    1 +
 drivers/net/igb/igb_main.c                  |    1 +
 drivers/net/r8169.c                         |   29 ++-
 drivers/net/wireless/ath/ar9170/usb.c       |    2 +-
 drivers/net/wireless/b43/Kconfig            |    6 +-
 drivers/net/wireless/b43/Makefile           |    2 +-
 drivers/net/wireless/b43/b43.h              |   28 +--
 drivers/net/wireless/b43/dma.c              |    2 -
 drivers/net/wireless/b43/main.c             |   10 +-
 drivers/net/wireless/b43/pio.c              |   79 +++--
 drivers/net/wireless/b43/pio.h              |   40 ---
 drivers/net/wireless/b43/xmit.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   11 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   27 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 drivers/pci/pci.c                           |   24 ++-
 drivers/pci/pcie/aer/aer_inject.c           |   20 ++-
 drivers/platform/x86/Kconfig                |   10 +-
 drivers/platform/x86/eeepc-laptop.c         |  110 +++++++
 drivers/platform/x86/thinkpad_acpi.c        |  439 +++++++++++++++------------
 drivers/scsi/libiscsi.c                     |    5 +-
 drivers/scsi/scsi_ioctl.c                   |    3 +
 drivers/scsi/scsi_transport_fc.c            |    5 +-
 drivers/staging/comedi/drivers/usbdux.c     |   20 +-
 drivers/usb/class/cdc-acm.c                 |   43 ++--
 drivers/usb/class/cdc-acm.h                 |    1 -
 drivers/video/backlight/mbp_nvidia_bl.c     |   45 +++
 drivers/watchdog/hpwdt.c                    |    2 +-
 drivers/watchdog/iTCO_wdt.c                 |   99 ++++++-
 fs/9p/vfs_file.c                            |    2 +-
 fs/block_dev.c                              |    3 +-
 fs/cifs/cifssmb.c                           |   19 ++-
 fs/ecryptfs/inode.c                         |  108 ++++----
 fs/ecryptfs/super.c                         |    1 -
 fs/ext3/super.c                             |    2 -
 fs/ext3/xattr.c                             |    7 +-
 fs/ext4/ext4.h                              |    6 +-
 fs/ext4/extents.c                           |    2 +-
 fs/ext4/inode.c                             |   13 +-
 fs/fat/namei_vfat.c                         |    6 +-
 fs/fs-writeback.c                           |   17 +
 fs/nfs/client.c                             |    3 +-
 fs/nfs/dir.c                                |    2 +-
 fs/nfs/nfs4proc.c                           |    4 +-
 fs/nfsd/nfs4xdr.c                           |   12 +-
 fs/ocfs2/acl.c                              |   77 +++++-
 fs/ocfs2/suballoc.c                         |   13 +-
 fs/proc/base.c                              |    5 +-
 fs/quota/dquot.c                            |   12 +-
 fs/xfs/linux-2.6/xfs_acl.c                  |    3 +-
 fs/xfs/linux-2.6/xfs_aops.c                 |  118 +++++---
 fs/xfs/linux-2.6/xfs_iops.c                 |    6 +-
 fs/xfs/linux-2.6/xfs_super.c                |   60 ++++-
 fs/xfs/linux-2.6/xfs_sync.c                 |  194 ++++++-------
 fs/xfs/linux-2.6/xfs_sync.h                 |    3 +-
 fs/xfs/quota/xfs_qm_bhv.c                   |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c              |    2 +-
 fs/xfs/xfs_alloc.c                          |   52 ++--
 fs/xfs/xfs_dfrag.c                          |  106 ++++++-
 fs/xfs/xfs_fsops.c                          |    2 +-
 fs/xfs/xfs_iget.c                           |   31 ++-
 fs/xfs/xfs_inode.c                          |   17 +-
 fs/xfs/xfs_iomap.c                          |    9 +-
 fs/xfs/xfs_log_recover.c                    |   24 +-
 fs/xfs/xfs_mount.c                          |    2 +-
 fs/xfs/xfs_mount.h                          |    1 +
 fs/xfs/xfs_rw.h                             |    7 -
 fs/xfs/xfs_trans.c                          |    7 +-
 fs/xfs/xfs_trans.h                          |    2 +-
 fs/xfs/xfs_vnodeops.c                       |  179 ++++-------
 fs/xfs/xfs_vnodeops.h                       |    1 -
 include/drm/drm_pciids.h                    |    2 +
 include/linux/freezer.h                     |    7 +-
 include/linux/fs.h                          |    1 +
 include/linux/kvm_host.h                    |    7 +-
 include/linux/module.h                      |    2 +-
 include/linux/nfs_fs_sb.h                   |    1 +
 include/linux/pci.h                         |    5 +
 include/linux/pci_ids.h                     |    3 +
 include/linux/resource.h                    |    8 +-
 include/linux/writeback.h                   |    1 +
 include/scsi/scsi_bsg_fc.h                  |    2 +-
 kernel/cgroup_freezer.c                     |    9 +-
 kernel/irq/manage.c                         |   10 +
 kernel/lockdep.c                            |    6 +-
 kernel/module.c                             |    2 +-
 kernel/power/process.c                      |    2 +-
 kernel/sched.c                              |   19 +-
 mm/readahead.c                              |    2 +-
 net/ipv4/tcp_input.c                        |    6 +-
 net/mac80211/scan.c                         |   18 +-
 net/mac80211/tx.c                           |    6 +
 net/mac80211/util.c                         |   20 +-
 net/sunrpc/svc_xprt.c                       |   13 +-
 net/sunrpc/svcauth_unix.c                   |   53 ++--
 net/sunrpc/svcsock.c                        |    1 +
 sound/pci/hda/hda_intel.c                   |    8 +
 sound/pci/hda/patch_analog.c                |    8 +
 sound/pci/hda/patch_realtek.c               |   11 +-
 sound/pci/mixart/mixart.c                   |   24 +-
 sound/usb/usbmidi.c                         |   24 ++-
 virt/kvm/kvm_main.c                         |   13 +-
 187 files changed, 3063 insertions(+), 1557 deletions(-)
