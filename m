Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2E1D26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:28:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51794 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab2E1D2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:55 -0400
Message-Id: <20120528031202.829379252@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/117] 3.2.19-stable review
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.19 release.
There are 117 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed May 30 03:11:59 UTC 2012.
Anything received after that time might be too late.

A combined patch relative to 3.2.18 will be posted as an additional
response to this, and the diffstat can be found below.

Ben.

-------------
 Documentation/HOWTO                            |   32 +-
 Makefile                                       |   12 +-
 arch/arm/include/asm/cacheflush.h              |    2 +-
 arch/arm/kernel/traps.c                        |    4 +-
 arch/ia64/kvm/kvm-ia64.c                       |    5 +
 arch/parisc/include/asm/prefetch.h             |    7 +-
 arch/parisc/kernel/entry.S                     |    4 +
 arch/parisc/kernel/pacache.S                   |   38 +-
 arch/s390/kvm/intercept.c                      |   20 +-
 arch/s390/kvm/kvm-s390.c                       |    2 +-
 arch/s390/mm/fault.c                           |   14 +-
 arch/sparc/Kconfig                             |    3 +
 arch/sparc/kernel/systbls_64.S                 |    2 +-
 arch/tile/Kconfig                              |    3 +-
 arch/tile/include/asm/bitops.h                 |   12 +-
 arch/um/include/asm/pgtable.h                  |   10 +-
 arch/x86/Makefile                              |    4 +
 arch/x86/boot/compressed/Makefile              |    9 +-
 arch/x86/boot/compressed/relocs.c              |  680 --------------------
 arch/x86/kernel/cpu/mcheck/mce-severity.c      |   16 +-
 arch/x86/kernel/cpu/mcheck/mce.c               |    8 +
 arch/x86/kernel/cpu/perf_event_amd.c           |   11 +-
 arch/x86/kvm/vmx.c                             |    4 +-
 arch/x86/kvm/x86.c                             |    8 +
 arch/x86/pci/xen.c                             |    4 +
 arch/x86/tools/.gitignore                      |    1 +
 arch/x86/tools/Makefile                        |    3 +
 arch/x86/tools/relocs.c                        |  820 ++++++++++++++++++++++++
 block/genhd.c                                  |   10 +-
 drivers/acpi/sleep.c                           |    8 +
 drivers/ata/ahci.c                             |    2 +
 drivers/gpio/gpio-mpc8xxx.c                    |    3 +-
 drivers/gpu/drm/i915/i915_irq.c                |    9 +-
 drivers/gpu/drm/i915/i915_reg.h                |   15 +
 drivers/gpu/drm/i915/intel_display.c           |   19 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c           |    2 +-
 drivers/hid/hid-logitech-dj.c                  |    5 +-
 drivers/hid/hid-wiimote.c                      |   16 +-
 drivers/i2c/busses/i2c-davinci.c               |    2 +-
 drivers/i2c/busses/i2c-eg20t.c                 |    2 +-
 drivers/i2c/busses/i2c-tegra.c                 |   13 +-
 drivers/infiniband/core/umem.c                 |    2 +-
 drivers/infiniband/hw/cxgb4/cm.c               |   11 +-
 drivers/input/tablet/wacom_wac.c               |    7 +-
 drivers/iommu/dmar.c                           |    4 +-
 drivers/iommu/intel-iommu.c                    |   17 +-
 drivers/isdn/gigaset/capi.c                    |   26 +-
 drivers/isdn/gigaset/ev-layer.c                |    4 +-
 drivers/md/md.c                                |    2 +-
 drivers/media/dvb/siano/smsusb.c               |    2 +
 drivers/media/video/uvc/uvc_v4l2.c             |    2 +-
 drivers/mmc/core/sdio.c                        |    2 +-
 drivers/mmc/core/sdio_irq.c                    |   11 +-
 drivers/mtd/sm_ftl.c                           |    2 +-
 drivers/net/ethernet/dlink/dl2k.c              |   52 +-
 drivers/net/ethernet/dlink/dl2k.h              |    7 -
 drivers/net/ethernet/emulex/benet/be_ethtool.c |    6 +-
 drivers/net/wireless/b43legacy/main.c          |    2 -
 drivers/net/wireless/rtlwifi/usb.c             |   34 +-
 drivers/net/wireless/rtlwifi/wifi.h            |    6 +-
 drivers/platform/x86/sony-laptop.c             |    2 +-
 drivers/regulator/core.c                       |    2 +
 drivers/rtc/rtc-pl031.c                        |   18 +
 drivers/scsi/hpsa.c                            |   38 +-
 drivers/scsi/isci/init.c                       |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c            |    6 +-
 drivers/spi/spi-fsl-spi.c                      |    2 +-
 drivers/staging/comedi/comedi_fops.c           |    2 +-
 drivers/tty/serial/8250.c                      |    9 +-
 drivers/tty/serial/8250_pci.c                  |   18 +
 drivers/tty/serial/mxs-auart.c                 |    2 +
 drivers/tty/serial/serial_core.c               |    1 +
 drivers/usb/class/cdc-wdm.c                    |   21 +-
 drivers/usb/core/devio.c                       |   33 +-
 drivers/usb/core/hub.c                         |    4 +
 drivers/usb/core/quirks.c                      |    3 +
 drivers/usb/core/usb.h                         |   14 -
 drivers/usb/gadget/fsl_udc_core.c              |    2 +
 drivers/usb/host/ehci-pci.c                    |    4 +-
 drivers/usb/host/ohci-at91.c                   |   11 +-
 drivers/usb/host/pci-quirks.c                  |   32 +-
 drivers/usb/host/xhci-mem.c                    |   27 +
 drivers/usb/host/xhci-pci.c                    |    1 +
 drivers/usb/host/xhci-ring.c                   |   21 +-
 drivers/usb/host/xhci.h                        |    1 +
 drivers/usb/misc/usbtest.c                     |   17 +-
 drivers/usb/serial/ftdi_sio.c                  |    1 +
 drivers/usb/serial/ftdi_sio_ids.h              |    8 +
 drivers/usb/serial/ti_usb_3410_5052.c          |    6 +-
 drivers/usb/serial/ti_usb_3410_5052.h          |    1 +
 drivers/usb/storage/unusual_devs.h             |    7 +
 drivers/video/omap2/dss/venc.c                 |    5 +
 drivers/xen/events.c                           |    5 +-
 fs/aio.c                                       |   30 +-
 fs/bio.c                                       |    9 +-
 fs/block_dev.c                                 |    6 +-
 fs/buffer.c                                    |    4 +-
 fs/cifs/cifsfs.c                               |    2 +-
 fs/ext3/ialloc.c                               |    8 +-
 fs/ext4/ialloc.c                               |    8 +-
 fs/nfs/nfs4proc.c                              |   30 +-
 fs/nfs/nfs4xdr.c                               |   18 +-
 fs/super.c                                     |    2 +
 include/linux/fs.h                             |    1 +
 include/linux/genhd.h                          |    6 -
 include/linux/kvm_host.h                       |    7 +
 include/linux/mmc/host.h                       |    2 +
 include/linux/usb.h                            |   13 +
 include/xen/events.h                           |    3 +
 init/do_mounts.c                               |    2 +-
 init/main.c                                    |    7 +-
 kernel/compat.c                                |   63 +-
 kernel/workqueue.c                             |    9 +-
 mm/memcontrol.c                                |    6 +
 mm/mempolicy.c                                 |   41 +-
 mm/swapfile.c                                  |    2 +-
 net/core/ethtool.c                             |    2 +
 net/wireless/reg.c                             |   10 +
 scripts/Makefile                               |    2 +
 security/selinux/selinuxfs.c                   |    1 +
 tools/usb/ffs-test.c                           |    2 +-
 virt/kvm/iommu.c                               |   23 +-
 virt/kvm/kvm_main.c                            |   23 +-
 123 files changed, 1606 insertions(+), 1105 deletions(-)

-- 
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

