Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2AXCky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:40:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50806 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755485Ab2AXCkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:40:52 -0500
X-Sasl-enc: YEtKLAO4YrVzS8x/gAfMF+ZIJ1PuCvN+wWOmpfBZ0NPC 1327372850
Date: Mon, 23 Jan 2012 18:40:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [000/129] 3.2.2-stable review
Message-ID: <20120124024041.GA18422@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

#include <stable/formletter.h>
#define RELEASE		3.2.2-rc1
#define NUM_PATCHES	129
#define RESPONSE_DATE	"Wed, Jan 25, 2012 20:00:00 +0000"
#define LOCATION	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.2-rc1.gz

diffstat below, no one really reads these things anyway...

greg k-h

--------------


 Makefile                                     |    4 +-
 arch/ia64/kernel/acpi.c                      |   10 +-
 arch/score/kernel/entry.S                    |    2 +-
 arch/x86/include/asm/amd_nb.h                |    2 +
 arch/x86/include/asm/uv/uv_bau.h             |  106 +++++++-
 arch/x86/kernel/amd_nb.c                     |   31 +++
 arch/x86/kernel/apic/x2apic_uv_x.c           |    7 +-
 arch/x86/mm/mmap.c                           |    4 +-
 arch/x86/mm/srat.c                           |    4 +
 arch/x86/pci/Makefile                        |    3 +-
 arch/x86/pci/acpi.c                          |   18 ++-
 arch/x86/pci/amd_bus.c                       |   42 +---
 arch/x86/platform/uv/tlb_uv.c                |  363 ++++++++++++++++++++++----
 block/scsi_ioctl.c                           |   52 ++++
 drivers/acpi/acpica/dsargs.c                 |   24 ++
 drivers/acpi/numa.c                          |    6 +
 drivers/acpi/processor_core.c                |   26 ++-
 drivers/bcma/host_pci.c                      |    3 +
 drivers/block/cciss.c                        |    6 +-
 drivers/block/ub.c                           |    3 +-
 drivers/block/virtio_blk.c                   |    4 +-
 drivers/cdrom/cdrom.c                        |    3 +-
 drivers/gpu/drm/radeon/r100.c                |    5 +-
 drivers/gpu/drm/radeon/r600_hdmi.c           |    7 +
 drivers/gpu/drm/radeon/radeon_device.c       |    5 +-
 drivers/gpu/drm/radeon/rs600.c               |    4 +-
 drivers/hid/Kconfig                          |    3 +
 drivers/hid/hid-core.c                       |   24 ++-
 drivers/hid/hid-ids.h                        |   31 ++-
 drivers/hid/hid-multitouch.c                 |   71 +++++-
 drivers/i2c/busses/i2c-ali1535.c             |   11 +-
 drivers/i2c/busses/i2c-eg20t.c               |    2 +-
 drivers/i2c/busses/i2c-nforce2.c             |    2 +-
 drivers/i2c/busses/i2c-omap.c                |    2 +-
 drivers/i2c/busses/i2c-sis5595.c             |    4 +-
 drivers/i2c/busses/i2c-sis630.c              |    6 +-
 drivers/i2c/busses/i2c-viapro.c              |    7 +-
 drivers/ide/ide-floppy_ioctl.c               |    3 +-
 drivers/idle/intel_idle.c                    |    9 +-
 drivers/md/dm-flakey.c                       |   11 +-
 drivers/md/dm-linear.c                       |   12 +-
 drivers/md/dm-mpath.c                        |    6 +
 drivers/md/raid1.c                           |   11 +-
 drivers/media/video/cx23885/cx23885-dvb.c    |    5 +
 drivers/media/video/cx88/cx88-cards.c        |   24 +-
 drivers/media/video/uvc/uvc_v4l2.c           |    9 +
 drivers/media/video/uvc/uvcvideo.h           |    1 +
 drivers/media/video/v4l2-ioctl.c             |    4 +
 drivers/mmc/core/mmc.c                       |    2 +-
 drivers/mmc/host/sdhci.c                     |    6 +-
 drivers/mtd/mtd_blkdevs.c                    |    3 +-
 drivers/mtd/mtdoops.c                        |    5 +-
 drivers/mtd/tests/mtd_stresstest.c           |    7 +
 drivers/mtd/ubi/cdev.c                       |    3 +
 drivers/mtd/ubi/debug.h                      |    5 +-
 drivers/mtd/ubi/eba.c                        |    6 +-
 drivers/mtd/ubi/ubi.h                        |    2 +
 drivers/mtd/ubi/vtbl.c                       |    2 +-
 drivers/mtd/ubi/wl.c                         |   12 +-
 drivers/net/usb/asix.c                       |   15 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c  |    5 +-
 drivers/net/wireless/ath/ath9k/calib.c       |    1 +
 drivers/net/wireless/ath/ath9k/mac.c         |    5 +-
 drivers/net/wireless/ath/ath9k/main.c        |    8 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    3 +
 drivers/net/wireless/rt2x00/rt2800pci.c      |   28 +--
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c  |    4 +
 drivers/pci/msi.c                            |   10 +
 drivers/pnp/quirks.c                         |   42 +++
 drivers/rtc/interface.c                      |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   83 ++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |   11 +-
 drivers/scsi/sd.c                            |   13 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c          |    4 +
 drivers/target/target_core_cdb.c             |   12 +
 drivers/target/target_core_transport.c       |   14 +
 drivers/xen/xenbus/xenbus_xs.c               |    6 +
 fs/aio.c                                     |   11 +-
 fs/cifs/connect.c                            |   23 ++-
 fs/dcache.c                                  |   78 +++----
 fs/ext4/ioctl.c                              |   28 ++-
 fs/ext4/super.c                              |    7 +-
 fs/nfs/blocklayout/blocklayout.c             |   28 +-
 fs/nfs/blocklayout/extents.c                 |   11 +-
 fs/nfs/callback_proc.c                       |    2 +-
 fs/nfs/file.c                                |    4 +-
 fs/nfs/nfs4proc.c                            |   96 ++++---
 fs/nfs/nfs4xdr.c                             |   31 ++-
 fs/nfs/objlayout/objio_osd.c                 |    3 +-
 fs/nfs/objlayout/objlayout.c                 |    4 +
 fs/nfs/pnfs.c                                |   12 +
 fs/nfs/pnfs.h                                |    1 +
 fs/nfs/super.c                               |   43 ++--
 fs/nfsd/export.c                             |    2 +-
 fs/nfsd/nfs4state.c                          |   17 +-
 fs/notify/mark.c                             |    8 +-
 fs/proc/base.c                               |  145 +++--------
 fs/proc/task_mmu.c                           |    3 +
 fs/proc/uptime.c                             |    9 +-
 fs/ubifs/debug.h                             |   17 +-
 fs/xfs/xfs_discard.c                         |    4 +-
 include/acpi/acpi_numa.h                     |    1 +
 include/linux/blkdev.h                       |    3 +
 include/linux/crash_dump.h                   |    1 +
 include/linux/dcache.h                       |    1 +
 include/linux/memcontrol.h                   |    6 +
 include/linux/nfs_xdr.h                      |    5 +
 include/linux/pci_regs.h                     |    2 +-
 include/linux/shmem_fs.h                     |    1 +
 include/linux/sunrpc/svcsock.h               |    2 +-
 include/linux/sunrpc/xdr.h                   |    2 +
 include/linux/swap.h                         |    2 +-
 include/linux/videodev2.h                    |    1 +
 include/media/tuner.h                        |    3 +-
 include/target/target_core_base.h            |    1 +
 include/xen/interface/io/xs_wire.h           |    3 +
 init/do_mounts.c                             |   35 +++-
 ipc/shm.c                                    |   37 ++-
 kernel/kprobes.c                             |    2 +-
 kernel/trace/ftrace.c                        |   27 +-
 kernel/tracepoint.c                          |    7 +-
 mm/filemap.c                                 |   18 +--
 mm/memcontrol.c                              |   44 +++
 mm/page_alloc.c                              |   11 +
 mm/shmem.c                                   |   53 +++-
 mm/slub.c                                    |    5 +
 mm/vmscan.c                                  |  118 +++------
 net/mac80211/ieee80211_i.h                   |   13 +-
 net/mac80211/main.c                          |   58 +----
 net/mac80211/offchannel.c                    |   68 +++---
 net/mac80211/rx.c                            |   10 +-
 net/mac80211/scan.c                          |   77 ++----
 net/mac80211/tx.c                            |    3 +-
 net/mac80211/work.c                          |   77 +-----
 net/mac80211/wpa.c                           |    2 +-
 net/sunrpc/svc.c                             |   20 +-
 net/sunrpc/svc_xprt.c                        |   53 +++--
 net/sunrpc/xdr.c                             |    3 +-
 scripts/kconfig/streamline_config.pl         |   52 +++-
 scripts/recordmcount.h                       |    2 +-
 security/integrity/ima/ima_api.c             |    4 +-
 security/integrity/ima/ima_queue.c           |   17 +-
 security/tomoyo/util.c                       |    6 +-
 sound/pci/hda/hda_intel.c                    |    1 +
 sound/pci/hda/hda_local.h                    |    7 +-
 sound/pci/hda/hda_proc.c                     |    2 +
 sound/pci/hda/patch_cirrus.c                 |   27 +--
 sound/pci/hda/patch_conexant.c               |    2 -
 sound/pci/hda/patch_sigmatel.c               |   38 ++-
 sound/pci/hda/patch_via.c                    |    5 +-
 sound/pci/ice1712/amp.c                      |    7 +-
 sound/pci/oxygen/xonar_wm87x6.c              |    1 +
 sound/usb/endpoint.c                         |    5 +-
 sound/usb/usx2y/usb_stream.c                 |    6 +-
 156 files changed, 1838 insertions(+), 1039 deletions(-)
