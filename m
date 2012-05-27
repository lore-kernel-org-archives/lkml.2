Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2E0BDn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:03:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58723 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2E0BDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:03:38 -0400
Date: Sun, 27 May 2012 10:03:32 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/94] 3.3.8-stable review
Message-ID: <20120527010332.GA11170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.3.8 release.
There are 95 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May 29 01:02:37 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.3.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/HOWTO                       |  32 +-
 Makefile                                  |  13 +-
 arch/arm/include/asm/cacheflush.h         |   2 +-
 arch/arm/kernel/traps.c                   |   4 +-
 arch/parisc/include/asm/prefetch.h        |   7 +-
 arch/parisc/kernel/entry.S                |   4 +
 arch/parisc/kernel/pacache.S              |  38 +-
 arch/powerpc/kernel/idle.c                |  14 +-
 arch/s390/mm/fault.c                      |  14 +-
 arch/sparc/Kconfig                        |   3 +
 arch/sparc/kernel/systbls_64.S            |   2 +-
 arch/tile/Kconfig                         |   1 +
 arch/tile/include/asm/bitops.h            |  12 +-
 arch/um/include/asm/pgtable.h             |  10 +-
 arch/x86/Makefile                         |   4 +
 arch/x86/boot/compressed/Makefile         |   9 +-
 arch/x86/boot/compressed/relocs.c         | 680 -------------------------
 arch/x86/kernel/cpu/mcheck/mce-severity.c |  16 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |   8 +
 arch/x86/kernel/cpu/perf_event_amd.c      |  11 +-
 arch/x86/pci/xen.c                        |   4 +
 arch/x86/tools/.gitignore                 |   1 +
 arch/x86/tools/Makefile                   |   4 +
 arch/x86/tools/relocs.c                   | 818 ++++++++++++++++++++++++++++++
 block/genhd.c                             |  10 +-
 drivers/ata/ahci.c                        |   2 +
 drivers/ata/libata-transport.c            |   1 +
 drivers/gpio/gpio-mpc8xxx.c               |   3 +-
 drivers/gpu/drm/gma500/psb_device.c       |   6 +-
 drivers/gpu/drm/i915/i915_irq.c           |   9 +-
 drivers/gpu/drm/i915/i915_reg.h           |  15 +
 drivers/gpu/drm/i915/intel_display.c      |  19 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c      |   2 +-
 drivers/hid/hid-logitech-dj.c             |   5 +-
 drivers/hid/hid-wiimote-core.c            |  16 +-
 drivers/hid/usbhid/hid-core.c             |  61 ++-
 drivers/i2c/busses/i2c-davinci.c          |   2 +-
 drivers/i2c/busses/i2c-tegra.c            |  13 +-
 drivers/infiniband/core/umem.c            |   2 +-
 drivers/infiniband/hw/cxgb4/cm.c          |  13 +-
 drivers/iommu/dmar.c                      |   4 +-
 drivers/iommu/intel-iommu.c               |  17 +-
 drivers/isdn/gigaset/capi.c               |  22 +-
 drivers/md/md.c                           |   2 +-
 drivers/media/dvb/siano/smsusb.c          |   2 +
 drivers/media/video/uvc/uvc_v4l2.c        |   2 +-
 drivers/mmc/core/cd-gpio.c                |   3 +
 drivers/mmc/core/sdio.c                   |   2 +-
 drivers/mmc/core/sdio_irq.c               |  11 +-
 drivers/mmc/host/omap_hsmmc.c             |   2 +-
 drivers/mtd/sm_ftl.c                      |   2 +-
 drivers/net/wireless/b43legacy/main.c     |   2 -
 drivers/net/wireless/ipw2x00/ipw2200.c    |  21 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   4 +-
 drivers/net/wireless/rtlwifi/pci.c        |  17 +-
 drivers/net/wireless/rtlwifi/usb.c        |  12 +-
 drivers/regulator/core.c                  |   2 +
 drivers/rtc/rtc-pl031.c                   |  18 +
 drivers/scsi/hpsa.c                       |  34 +-
 drivers/scsi/isci/init.c                  |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   6 +-
 drivers/spi/spi-fsl-spi.c                 |   2 +-
 drivers/staging/comedi/comedi_fops.c      |   2 +-
 drivers/tty/serial/8250/8250_pci.c        |  18 +
 drivers/tty/serial/mxs-auart.c            |   2 +
 drivers/tty/serial/serial_core.c          |   1 +
 drivers/usb/class/cdc-wdm.c               |   4 +-
 drivers/usb/core/devio.c                  |  33 +-
 drivers/usb/core/hub.c                    |   4 +
 drivers/usb/core/quirks.c                 |   3 +
 drivers/usb/core/urb.c                    |  21 +
 drivers/usb/gadget/fsl_udc_core.c         |   2 +
 drivers/usb/host/ehci-pci.c               |   4 +-
 drivers/usb/host/ohci-at91.c              |  11 +-
 drivers/usb/host/pci-quirks.c             |  32 +-
 drivers/usb/host/xhci-mem.c               |  27 +
 drivers/usb/host/xhci-pci.c               |   1 +
 drivers/usb/host/xhci-ring.c              |  21 +-
 drivers/usb/host/xhci.h                   |   1 +
 drivers/usb/misc/usbtest.c                |  17 +-
 drivers/usb/serial/ftdi_sio.c             |   1 +
 drivers/usb/serial/ftdi_sio_ids.h         |   8 +
 drivers/usb/serial/ti_usb_3410_5052.c     |   6 +-
 drivers/usb/serial/ti_usb_3410_5052.h     |   1 +
 drivers/usb/storage/unusual_devs.h        |   7 +
 drivers/video/udlfb.c                     | 146 +++---
 drivers/xen/events.c                      |   5 +-
 fs/aio.c                                  |  30 +-
 fs/bio.c                                  |   7 +-
 fs/block_dev.c                            |   6 +-
 fs/buffer.c                               |   4 +-
 include/linux/fs.h                        |   1 +
 include/linux/genhd.h                     |   6 -
 include/linux/mmc/host.h                  |   2 +
 include/linux/usb.h                       |   3 +
 include/video/udlfb.h                     |   1 +
 include/xen/events.h                      |   3 +
 init/main.c                               |   7 +-
 kernel/workqueue.c                        |   9 +-
 mm/mempolicy.c                            |  41 +-
 mm/swapfile.c                             |   2 +-
 net/wireless/reg.c                        |  10 +
 scripts/Makefile                          |   2 +
 security/selinux/selinuxfs.c              |   1 +
 tools/usb/ffs-test.c                      |   2 +-
 105 files changed, 1554 insertions(+), 1040 deletions(-)

