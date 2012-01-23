Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2AWXna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:43:30 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35966 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab2AWXn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:43:28 -0500
X-Sasl-enc: mRuHzXUIf1inhE1vWHlD8vqlMBQ81/zHUBAScoxh4hqf 1327362207
Date: Mon, 23 Jan 2012 15:42:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/90] 3.0.18-stable review
Message-ID: <20120123234211.GA19504@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.18 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wednesday, January 25, 2012, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.18-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                     |    4 +-
 arch/ia64/kernel/acpi.c                      |   10 +-
 arch/score/kernel/entry.S                    |    2 +-
 arch/x86/include/asm/amd_nb.h                |    2 +
 arch/x86/kernel/amd_nb.c                     |   31 ++++++
 arch/x86/kernel/apic/x2apic_uv_x.c           |    7 +-
 arch/x86/mm/mmap.c                           |    4 +-
 arch/x86/mm/srat.c                           |    4 +
 arch/x86/pci/Makefile                        |    3 +-
 arch/x86/pci/acpi.c                          |   18 +++-
 arch/x86/pci/amd_bus.c                       |   42 ++------
 arch/x86/platform/uv/tlb_uv.c                |   13 ++-
 block/scsi_ioctl.c                           |   52 +++++++++
 drivers/acpi/acpica/dsargs.c                 |   24 ++++
 drivers/acpi/numa.c                          |    6 +
 drivers/acpi/processor_core.c                |   26 ++++-
 drivers/block/cciss.c                        |    6 +-
 drivers/block/ub.c                           |    3 +-
 drivers/block/virtio_blk.c                   |    4 +-
 drivers/cdrom/cdrom.c                        |    3 +-
 drivers/gpu/drm/radeon/r100.c                |    5 +-
 drivers/gpu/drm/radeon/r600_hdmi.c           |    7 ++
 drivers/gpu/drm/radeon/radeon_device.c       |    5 +-
 drivers/gpu/drm/radeon/rs600.c               |    4 +-
 drivers/hid/hid-core.c                       |   14 ++-
 drivers/hid/hid-ids.h                        |   14 ++-
 drivers/hid/hid-multitouch.c                 |   32 ++++--
 drivers/i2c/busses/i2c-ali1535.c             |   11 ++-
 drivers/i2c/busses/i2c-eg20t.c               |    2 +-
 drivers/i2c/busses/i2c-nforce2.c             |    2 +-
 drivers/i2c/busses/i2c-omap.c                |    2 +-
 drivers/i2c/busses/i2c-sis5595.c             |    4 +-
 drivers/i2c/busses/i2c-sis630.c              |    6 +-
 drivers/i2c/busses/i2c-viapro.c              |    7 +-
 drivers/ide/ide-floppy_ioctl.c               |    3 +-
 drivers/idle/intel_idle.c                    |    9 +-
 drivers/md/dm-flakey.c                       |   11 ++-
 drivers/md/dm-linear.c                       |   12 ++-
 drivers/md/dm-mpath.c                        |    6 +
 drivers/media/video/uvc/uvc_v4l2.c           |    9 ++
 drivers/media/video/uvc/uvcvideo.h           |    1 +
 drivers/media/video/v4l2-ioctl.c             |    4 +
 drivers/mmc/core/mmc.c                       |    2 +-
 drivers/mmc/host/sdhci.c                     |    6 +-
 drivers/mtd/mtd_blkdevs.c                    |    3 +-
 drivers/mtd/mtdoops.c                        |    5 +-
 drivers/mtd/tests/mtd_stresstest.c           |    7 ++
 drivers/mtd/ubi/cdev.c                       |    3 +
 drivers/mtd/ubi/debug.h                      |    5 +-
 drivers/mtd/ubi/eba.c                        |    6 +-
 drivers/mtd/ubi/ubi.h                        |    2 +
 drivers/mtd/ubi/wl.c                         |   12 ++-
 drivers/net/phy/mdio-gpio.c                  |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    3 +
 drivers/net/wireless/rt2x00/rt2800pci.c      |   28 ++----
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c  |    4 +
 drivers/pci/msi.c                            |   10 ++
 drivers/pnp/quirks.c                         |   42 ++++++++
 drivers/rtc/interface.c                      |    4 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   83 +++++----------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |   11 +-
 drivers/scsi/sd.c                            |   13 ++-
 drivers/scsi/sym53c8xx_2/sym_glue.c          |    4 +
 drivers/target/target_core_cdb.c             |   12 ++
 drivers/target/target_core_transport.c       |   14 +++
 drivers/xen/xenbus/xenbus_xs.c               |    6 +
 fs/dcache.c                                  |   14 ++-
 fs/ext4/super.c                              |    7 +-
 fs/nfs/callback_proc.c                       |    2 +-
 fs/nfs/objlayout/objio_osd.c                 |    3 +-
 fs/nfs/objlayout/objlayout.c                 |   10 ++-
 fs/nfs/pnfs.c                                |   12 ++
 fs/nfs/pnfs.h                                |    1 +
 fs/nfs/super.c                               |   43 ++++----
 fs/nfsd/export.c                             |    2 +-
 fs/notify/mark.c                             |    8 +-
 fs/proc/base.c                               |  145 +++++++-------------------
 fs/proc/task_mmu.c                           |    3 +
 fs/proc/uptime.c                             |    9 ++-
 fs/ubifs/debug.h                             |   17 ++--
 include/acpi/acpi_numa.h                     |    1 +
 include/linux/blkdev.h                       |    3 +
 include/linux/dcache.h                       |    1 +
 include/linux/memcontrol.h                   |    6 +
 include/linux/pci_regs.h                     |    2 +-
 include/linux/sunrpc/svcsock.h               |    2 +-
 include/linux/videodev2.h                    |    1 +
 include/target/target_core_base.h            |    1 +
 include/xen/interface/io/xs_wire.h           |    3 +
 init/do_mounts.c                             |   35 ++++++-
 kernel/kprobes.c                             |    2 +-
 mm/filemap.c                                 |   18 +---
 mm/memcontrol.c                              |   44 ++++++++
 mm/page_alloc.c                              |   11 ++
 net/ipv4/ah4.c                               |    6 +-
 net/ipv6/ah6.c                               |    6 +-
 net/mac80211/wpa.c                           |    2 +-
 net/sunrpc/svc.c                             |   20 +++--
 net/sunrpc/svc_xprt.c                        |   53 +++++++---
 scripts/kconfig/streamline_config.pl         |   52 +++++++--
 scripts/recordmcount.h                       |    2 +-
 security/integrity/ima/ima_api.c             |    4 +-
 security/integrity/ima/ima_queue.c           |   17 ++-
 sound/pci/hda/hda_local.h                    |    7 +-
 sound/pci/hda/hda_proc.c                     |    2 +
 sound/pci/hda/patch_sigmatel.c               |    2 +-
 sound/pci/ice1712/amp.c                      |    7 +-
 sound/pci/oxygen/xonar_wm87x6.c              |    1 +
 sound/usb/usx2y/usb_stream.c                 |    6 +-
 111 files changed, 870 insertions(+), 454 deletions(-)
