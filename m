Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0DVUHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:07:42 -0400
Received: from kroah.org ([198.145.64.141]:47853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab0DVUHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:07:33 -0400
Date: Thu, 22 Apr 2010 12:57:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/139] 2.6.33.3-stable review
Message-ID: <20100422195715.GA25490@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.3 release.
There are 139 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Saturday, April 24, 15:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/i2c/busses/i2c-i801               |    3 +-
 Makefile                                        |    2 +-
 arch/arm/boot/compressed/head.S                 |    2 +-
 arch/ia64/kvm/kvm-ia64.c                        |    9 +-
 arch/mips/mm/tlbex.c                            |   22 ++-
 arch/powerpc/kvm/book3s.c                       |    5 +-
 arch/powerpc/platforms/pseries/offline_states.h |   22 ++-
 arch/s390/mm/vmem.c                             |   11 +-
 arch/sh/include/asm/elf.h                       |    6 +-
 arch/sh/kernel/smp.c                            |    1 +
 arch/sparc/kernel/ptrace_32.c                   |    4 +
 arch/sparc/kernel/ptrace_64.c                   |    4 +
 arch/um/sys-x86_64/Makefile                     |    3 +-
 arch/x86/Kconfig.cpu                            |    2 +-
 arch/x86/include/asm/rwsem.h                    |   81 +++++---
 arch/x86/include/asm/smp.h                      |    9 +
 arch/x86/kernel/amd_iommu.c                     |    6 +-
 arch/x86/kernel/amd_iommu_init.c                |    5 +-
 arch/x86/kernel/aperture_64.c                   |   15 ++-
 arch/x86/kernel/apic/apic.c                     |    2 +
 arch/x86/kernel/cpu/intel_cacheinfo.c           |  250 ++++++++++++++---------
 arch/x86/kernel/cpu/perf_event.c                |  104 ++++++++++-
 arch/x86/kernel/crash.c                         |    6 -
 arch/x86/kernel/hpet.c                          |    8 +-
 arch/x86/kernel/kgdb.c                          |    2 +-
 arch/x86/kernel/mpparse.c                       |    4 +-
 arch/x86/kernel/pci-gart_64.c                   |    3 +
 arch/x86/kvm/mmu.c                              |   11 +-
 arch/x86/kvm/svm.c                              |   25 ++-
 arch/x86/kvm/vmx.c                              |   37 +++-
 arch/x86/kvm/x86.c                              |   45 ++---
 arch/x86/lib/Makefile                           |    3 +-
 arch/x86/lib/cache-smp.c                        |   19 ++
 arch/x86/lib/rwsem_64.S                         |   81 ++++++++
 arch/x86/pci/irq.c                              |    2 +
 arch/x86/power/hibernate_asm_32.S               |   15 +-
 drivers/acpi/acpica/exprep.c                    |   17 ++
 drivers/acpi/ec.c                               |   35 +---
 drivers/ata/ahci.c                              |    6 +
 drivers/ata/ata_piix.c                          |    8 +
 drivers/ata/libata-core.c                       |    3 +
 drivers/ata/pata_via.c                          |    1 +
 drivers/char/agp/intel-agp.c                    |   15 +-
 drivers/char/raw.c                              |    1 +
 drivers/char/tty_io.c                           |    2 +
 drivers/gpu/drm/drm_crtc_helper.c               |    1 +
 drivers/gpu/drm/drm_edid.c                      |   11 +-
 drivers/gpu/drm/drm_fops.c                      |   16 +-
 drivers/gpu/drm/i915/intel_lvds.c               |    8 +
 drivers/gpu/drm/radeon/atom.c                   |   10 +
 drivers/gpu/drm/radeon/r300.c                   |    5 +-
 drivers/gpu/drm/radeon/radeon_combios.c         |   20 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c      |    7 +-
 drivers/gpu/drm/radeon/radeon_cp.c              |   10 +-
 drivers/gpu/drm/radeon/radeon_cs.c              |   15 +-
 drivers/gpu/drm/radeon/radeon_device.c          |    8 +
 drivers/gpu/drm/radeon/radeon_encoders.c        |    8 +-
 drivers/gpu/drm/radeon/radeon_legacy_tv.c       |   29 +++-
 drivers/gpu/drm/radeon/rs600.c                  |    2 +-
 drivers/hid/hid-gyration.c                      |    5 +-
 drivers/hwmon/sht15.c                           |   13 +-
 drivers/i2c/busses/Kconfig                      |    5 +-
 drivers/i2c/busses/i2c-i801.c                   |    5 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c         |    2 +
 drivers/input/sparse-keymap.c                   |    2 +-
 drivers/input/tablet/wacom_sys.c                |   12 +-
 drivers/md/dm-ioctl.c                           |   19 +-
 drivers/md/dm.c                                 |    7 +-
 drivers/md/dm.h                                 |    4 +-
 drivers/md/linear.c                             |   12 +-
 drivers/md/multipath.c                          |   20 +-
 drivers/md/raid0.c                              |   13 +-
 drivers/md/raid10.c                             |   28 ++-
 drivers/md/raid5.c                              |   19 +-
 drivers/net/e1000e/netdev.c                     |    2 +
 drivers/net/wireless/ath/ar9170/usb.c           |    2 +-
 drivers/net/wireless/ath/ath9k/main.c           |    3 +-
 drivers/net/wireless/b43/Kconfig                |    6 +-
 drivers/net/wireless/b43/Makefile               |    2 +-
 drivers/net/wireless/b43/b43.h                  |   12 +-
 drivers/net/wireless/b43/dma.c                  |    2 -
 drivers/net/wireless/b43/main.c                 |   11 +-
 drivers/net/wireless/b43/pio.h                  |   40 ----
 drivers/net/wireless/iwlwifi/iwl-4965.c         |   11 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c         |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c         |   27 +--
 drivers/net/wireless/iwlwifi/iwl3945-base.c     |    4 +-
 drivers/pci/pci.c                               |   24 ++-
 drivers/scsi/libiscsi.c                         |    5 +-
 drivers/usb/class/cdc-acm.c                     |   43 ++--
 drivers/usb/class/cdc-acm.h                     |    1 -
 drivers/video/backlight/mbp_nvidia_bl.c         |   45 ++++
 drivers/video/sunxvr500.c                       |   24 ++-
 drivers/watchdog/hpwdt.c                        |    2 +-
 drivers/watchdog/iTCO_wdt.c                     |   99 +++++++++-
 fs/9p/vfs_file.c                                |    2 +-
 fs/block_dev.c                                  |    3 +-
 fs/cifs/cifssmb.c                               |   19 ++-
 fs/ecryptfs/inode.c                             |  108 +++++-----
 fs/ecryptfs/super.c                             |    1 -
 fs/ext4/ext4.h                                  |    6 +-
 fs/ext4/extents.c                               |    2 +-
 fs/ext4/inode.c                                 |    2 +-
 fs/fat/namei_vfat.c                             |    6 +-
 fs/nfs/client.c                                 |    3 +-
 fs/nfs/dir.c                                    |    2 +-
 fs/nfs/nfs4proc.c                               |    4 +-
 fs/nfsd/nfs4xdr.c                               |   12 +-
 fs/ocfs2/acl.c                                  |   77 +++++++-
 fs/ocfs2/suballoc.c                             |   13 +-
 fs/proc/base.c                                  |    5 +-
 fs/quota/dquot.c                                |   12 +-
 fs/reiserfs/super.c                             |   10 +-
 fs/xfs/linux-2.6/xfs_aops.c                     |   93 +++++----
 fs/xfs/linux-2.6/xfs_sync.c                     |   10 +-
 fs/xfs/xfs_iget.c                               |   19 ++-
 include/drm/drm_pciids.h                        |    2 +
 include/linux/dm-ioctl.h                        |    9 +-
 include/linux/freezer.h                         |    7 +-
 include/linux/fs.h                              |    1 +
 include/linux/kfifo.h                           |    3 +-
 include/linux/kvm_host.h                        |    7 +-
 include/linux/module.h                          |    2 +-
 include/linux/nfs_fs_sb.h                       |    1 +
 include/linux/pci.h                             |    5 +
 include/linux/pci_ids.h                         |    3 +
 kernel/cgroup_freezer.c                         |    9 +-
 kernel/irq/manage.c                             |   10 +
 kernel/lockdep.c                                |    6 +-
 kernel/module.c                                 |    2 +-
 kernel/power/process.c                          |    2 +-
 kernel/sched.c                                  |   10 +-
 mm/readahead.c                                  |    2 +-
 net/mac80211/mesh.c                             |    3 -
 net/mac80211/mesh_hwmp.c                        |    4 +-
 net/mac80211/rx.c                               |    5 +
 net/mac80211/tx.c                               |    6 +
 net/mac80211/util.c                             |   20 ++-
 sound/pci/hda/hda_intel.c                       |   10 +
 sound/pci/hda/patch_analog.c                    |    8 +
 sound/pci/hda/patch_realtek.c                   |    1 +
 sound/pci/mixart/mixart.c                       |   24 ++-
 sound/usb/usbmidi.c                             |   24 ++-
 virt/kvm/kvm_main.c                             |   13 +-
 145 files changed, 1513 insertions(+), 697 deletions(-)
