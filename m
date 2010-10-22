Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab0JVTYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:24:41 -0400
Received: from kroah.org ([198.145.64.141]:33909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab0JVSzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:53 -0400
Date: Fri, 22 Oct 2010 11:54:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [000/103] 2.6.35.8-stable review
Message-ID: <20101022185455.GA9114@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:
   There will only be 1 other .35-stable release after this one.
   Everyone should be moving to the .36 kernel already.

This is the start of the stable review cycle for the 2.6.35.8 release.
There are 103 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, October 25, 2010 16:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 Makefile                                     |    2 +-
 arch/arm/Kconfig                             |    1 -
 arch/arm/mach-vexpress/ct-ca9x4.c            |    2 +-
 arch/arm/oprofile/common.c                   |    7 ++-
 arch/powerpc/kernel/head_64.S                |   18 +++++--
 arch/um/drivers/ubd_kern.c                   |    9 ++--
 arch/x86/include/asm/amd_iommu_proto.h       |    6 ++
 arch/x86/include/asm/amd_iommu_types.h       |   12 +++++
 arch/x86/include/asm/pgtable_32.h            |    1 +
 arch/x86/include/asm/trampoline.h            |    5 ++-
 arch/x86/kernel/Makefile                     |    2 +
 arch/x86/kernel/amd_iommu.c                  |    4 +-
 arch/x86/kernel/amd_iommu_init.c             |   67 +++++++++++++++++--------
 arch/x86/kernel/apic/io_apic.c               |   11 +++-
 arch/x86/kernel/cpu/common.c                 |    4 +-
 arch/x86/kernel/cpu/cpu.h                    |    1 +
 arch/x86/kernel/cpu/intel.c                  |    1 +
 arch/x86/kernel/cpu/mcheck/mce_amd.c         |    9 +--
 arch/x86/kernel/head_32.S                    |    8 +++-
 arch/x86/kernel/hpet.c                       |    2 +-
 arch/x86/kernel/setup.c                      |    2 +
 arch/x86/kernel/smpboot.c                    |   32 +++++-------
 arch/x86/kernel/trampoline.c                 |   17 +++++++
 arch/x86/kvm/irq.h                           |    2 +-
 arch/x86/kvm/svm.c                           |    2 +-
 arch/x86/mm/srat_64.c                        |    8 ++-
 arch/x86/oprofile/nmi_int.c                  |    1 +
 block/bsg.c                                  |    2 +-
 drivers/acpi/acpica/aclocal.h                |    1 +
 drivers/acpi/blacklist.c                     |   16 ++++++
 drivers/acpi/bus.c                           |   14 +----
 drivers/acpi/processor_core.c                |    7 +--
 drivers/acpi/sleep.c                         |   22 ++++++++
 drivers/ata/ahci.c                           |    4 ++
 drivers/ata/ahci.h                           |   12 ++++-
 drivers/ata/ahci_platform.c                  |    6 ++-
 drivers/ata/libahci.c                        |   16 ++-----
 drivers/block/virtio_blk.c                   |    6 ++-
 drivers/char/agp/intel-agp.c                 |    1 +
 drivers/char/agp/intel-agp.h                 |    6 ++
 drivers/char/agp/intel-gtt.c                 |   50 +++++++++++++++----
 drivers/char/virtio_console.c                |   17 +++++-
 drivers/dma/ioat/dma_v2.c                    |    2 +-
 drivers/dma/mv_xor.c                         |    2 +-
 drivers/edac/i7core_edac.c                   |    1 +
 drivers/firewire/ohci.c                      |   19 +-------
 drivers/firewire/ohci.h                      |    8 ---
 drivers/gpu/drm/drm_gem.c                    |   31 +++---------
 drivers/gpu/drm/drm_vm.c                     |   28 +++++++----
 drivers/gpu/drm/i915/i915_dma.c              |    9 ++-
 drivers/gpu/drm/i915/i915_gem.c              |   31 +++++++++---
 drivers/gpu/drm/radeon/evergreen.c           |    4 +-
 drivers/gpu/drm/radeon/r600.c                |    3 +-
 drivers/gpu/drm/radeon/radeon_atombios.c     |    9 ++++
 drivers/gpu/drm/radeon/radeon_cursor.c       |   28 +++++------
 drivers/gpu/drm/radeon/radeon_display.c      |    2 +
 drivers/hid/hidraw.c                         |   11 ++++
 drivers/hwmon/lis3lv02d.c                    |    4 +-
 drivers/i2c/busses/i2c-pca-isa.c             |   12 +++--
 drivers/i2c/busses/i2c-pca-platform.c        |   11 +++--
 drivers/infiniband/hw/cxgb3/iwch_cm.c        |    6 ++-
 drivers/input/joydev.c                       |    3 +
 drivers/input/tablet/wacom_wac.c             |    4 +-
 drivers/media/IR/ir-keytable.c               |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c  |   55 ++++++++++++++++++++-
 drivers/media/dvb/frontends/dib7000p.c       |    2 +
 drivers/media/dvb/frontends/dib7000p.h       |    3 +
 drivers/media/video/cx231xx/Makefile         |    1 +
 drivers/media/video/cx231xx/cx231xx-cards.c  |   17 ++++--
 drivers/media/video/gspca/gspca.c            |    1 +
 drivers/media/video/gspca/sn9c20x.c          |    3 +-
 drivers/media/video/v4l2-compat-ioctl32.c    |   32 ++++++++----
 drivers/mfd/wm831x-irq.c                     |    9 +++-
 drivers/mmc/core/core.c                      |   13 +++++
 drivers/mmc/host/sdhci-s3c.c                 |    6 ++-
 drivers/net/atlx/atl1.c                      |    5 +-
 drivers/net/b44.c                            |    4 +-
 drivers/net/r8169.c                          |   12 ++--
 drivers/net/skge.c                           |   18 +++++++-
 drivers/pci/quirks.c                         |   20 ++++++++
 drivers/scsi/scsi.c                          |    4 +-
 drivers/usb/core/file.c                      |   35 ++++++-------
 drivers/usb/core/message.c                   |    1 +
 drivers/usb/musb/musb_gadget.c               |   22 +++++++--
 drivers/usb/musb/musb_gadget.h               |    2 +
 drivers/usb/musb/musb_gadget_ep0.c           |    9 ++++
 fs/exec.c                                    |   14 +++++
 fs/ocfs2/symlink.c                           |    2 +-
 fs/proc/task_mmu.c                           |    3 +-
 fs/reiserfs/ioctl.c                          |    7 ++-
 fs/xfs/linux-2.6/xfs_sync.c                  |   16 +++++--
 fs/xfs/linux-2.6/xfs_sync.h                  |    1 +
 fs/xfs/xfs_iget.c                            |    1 +
 include/drm/drmP.h                           |   11 +++--
 include/drm/drm_pciids.h                     |    2 +-
 include/linux/intel-gtt.h                    |   20 ++++++++
 include/linux/mm.h                           |    6 ++
 include/linux/pci_ids.h                      |    3 +
 kernel/hrtimer.c                             |   13 ++++-
 kernel/trace/ring_buffer.c                   |    2 +-
 lib/list_sort.c                              |    2 +-
 mm/ksm.c                                     |    6 ++-
 mm/mlock.c                                   |    6 --
 net/mac80211/rx.c                            |    4 --
 net/rds/page.c                               |   27 +++--------
 net/wireless/wext-priv.c                     |    2 +-
 sound/core/control.c                         |    5 ++
 sound/core/rawmidi.c                         |    4 +-
 sound/oss/soundcard.c                        |    4 +-
 sound/pci/hda/patch_analog.c                 |    1 +
 sound/pci/hda/patch_conexant.c               |   20 ++++++++
 sound/pci/oxygen/oxygen.c                    |    4 ++
 sound/pci/rme9652/hdsp.c                     |    1 +
 sound/pci/rme9652/hdspm.c                    |    1 +
 virt/kvm/eventfd.c                           |    3 +-
 virt/kvm/kvm_main.c                          |    4 +-
 117 files changed, 773 insertions(+), 343 deletions(-)
