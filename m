Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab2E0BNu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:13:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38960 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab2E0BNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:13:44 -0400
Date: Sun, 27 May 2012 10:09:03 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/91] 3.4.1-stable review
Message-ID: <20120527010903.GA18244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, I've tested this release a bit differently than I have in the
past.  For this release, I've only tested it on one machine, my laptop,
with a pretty minimal configuration to save on build times.  That means,
while this release works for me, it might not for you, and it might not
even build at all for you.  Please test to verify that I haven't messed
anything up.  I'll give everyone at least an extra day than "normal" for
this review cycle before I cut a final 3.4.1 release.

--------------

This is the start of the stable review cycle for the 3.4.1 release.
There are 92 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed May 30 00:30:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/HOWTO                       | 32 ++++++++--------
 Makefile                                  |  4 +-
 arch/arm/boot/dts/tegra-cardhu.dts        |  2 +-
 arch/arm/include/asm/cacheflush.h         |  2 +-
 arch/arm/kernel/traps.c                   |  4 +-
 arch/powerpc/kernel/idle.c                | 14 +++----
 arch/s390/mm/fault.c                      | 14 ++++++-
 arch/sparc/Kconfig                        |  3 ++
 arch/sparc/kernel/systbls_64.S            |  2 +-
 arch/tile/include/asm/bitops.h            | 12 +++---
 arch/um/include/asm/pgtable.h             | 10 ++++-
 arch/x86/Makefile                         |  1 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 16 +++++---
 arch/x86/kernel/cpu/mcheck/mce.c          |  8 ++++
 arch/x86/kernel/cpu/perf_event_amd.c      | 11 +++++-
 arch/x86/pci/xen.c                        |  4 ++
 arch/x86/tools/relocs.c                   | 12 ++++++
 drivers/gpio/gpio-mpc8xxx.c               |  3 +-
 drivers/gpu/drm/gma500/psb_device.c       |  6 ++-
 drivers/gpu/drm/i915/i915_irq.c           |  9 ++---
 drivers/gpu/drm/i915/i915_reg.h           | 15 ++++++++
 drivers/gpu/drm/i915/intel_display.c      | 19 +++++++++-
 drivers/gpu/drm/nouveau/nouveau_bo.c      |  2 +-
 drivers/hid/hid-logitech-dj.c             |  5 ++-
 drivers/hid/hid-wiimote-core.c            | 16 +++-----
 drivers/hid/usbhid/hid-core.c             | 61 ++++++++++++++++++++++++++++---
 drivers/i2c/busses/i2c-davinci.c          |  2 +-
 drivers/i2c/busses/i2c-tegra.c            | 13 +++----
 drivers/infiniband/core/umem.c            |  2 +-
 drivers/infiniband/hw/cxgb4/cm.c          | 13 ++++---
 drivers/iommu/dmar.c                      |  4 +-
 drivers/iommu/intel-iommu.c               | 17 ++++++---
 drivers/isdn/gigaset/capi.c               | 26 ++++++-------
 drivers/isdn/gigaset/ev-layer.c           |  4 +-
 drivers/md/md.c                           |  2 +-
 drivers/media/dvb/siano/smsusb.c          |  2 +
 drivers/media/video/uvc/uvc_v4l2.c        |  2 +-
 drivers/mmc/core/cd-gpio.c                |  3 ++
 drivers/mmc/core/sdio.c                   |  2 +-
 drivers/mmc/core/sdio_irq.c               | 11 ++++--
 drivers/mmc/host/omap_hsmmc.c             |  2 +-
 drivers/net/wireless/b43legacy/main.c     |  2 -
 drivers/net/wireless/ipw2x00/ipw2200.c    | 21 +++--------
 drivers/net/wireless/iwlwifi/iwl-6000.c   |  4 +-
 drivers/regulator/core.c                  |  2 +
 drivers/scsi/isci/init.c                  |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c       |  6 +--
 drivers/spi/spi-fsl-spi.c                 |  2 +-
 drivers/staging/android/persistent_ram.c  | 19 +---------
 drivers/staging/comedi/comedi_fops.c      |  2 +-
 drivers/tty/hvc/hvc_xen.c                 |  4 +-
 drivers/tty/serial/8250/8250.c            |  9 +++--
 drivers/tty/serial/8250/8250_pci.c        | 18 +++++++++
 drivers/tty/serial/mxs-auart.c            |  2 +
 drivers/tty/serial/serial_core.c          |  1 +
 drivers/usb/class/cdc-wdm.c               | 31 +++++++++++-----
 drivers/usb/core/devio.c                  | 33 +++++++++++++----
 drivers/usb/core/hub.c                    |  4 ++
 drivers/usb/core/quirks.c                 |  3 ++
 drivers/usb/core/urb.c                    | 21 +++++++++++
 drivers/usb/gadget/fsl_udc_core.c         |  2 +
 drivers/usb/host/ehci-omap.c              | 18 ++++-----
 drivers/usb/host/ehci-pci.c               |  4 +-
 drivers/usb/host/ehci-platform.c          |  2 -
 drivers/usb/host/ohci-at91.c              | 11 +++++-
 drivers/usb/host/pci-quirks.c             | 32 +++++++++++++++-
 drivers/usb/host/xhci-hub.c               | 22 ++++++-----
 drivers/usb/host/xhci-mem.c               | 27 ++++++++++++++
 drivers/usb/host/xhci-pci.c               |  1 +
 drivers/usb/host/xhci-ring.c              | 22 +++++++++--
 drivers/usb/host/xhci.c                   | 12 +++++-
 drivers/usb/host/xhci.h                   |  3 ++
 drivers/usb/misc/usbtest.c                | 17 ++++++---
 drivers/usb/otg/gpio_vbus.c               |  8 ++--
 drivers/usb/serial/ftdi_sio.c             |  1 +
 drivers/usb/serial/ftdi_sio_ids.h         |  8 ++++
 drivers/usb/serial/ti_usb_3410_5052.c     |  6 ++-
 drivers/usb/serial/ti_usb_3410_5052.h     |  1 +
 drivers/usb/serial/usb-serial.c           |  9 ++++-
 drivers/usb/storage/unusual_devs.h        |  7 ++++
 drivers/video/sh_mobile_lcdcfb.c          |  5 ++-
 drivers/video/sh_mobile_lcdcfb.h          |  1 +
 drivers/xen/events.c                      |  5 ++-
 fs/aio.c                                  | 30 +++++++--------
 include/linux/mmc/host.h                  |  2 +
 include/linux/usb.h                       |  3 ++
 include/xen/events.h                      |  3 ++
 init/main.c                               |  7 ++--
 kernel/workqueue.c                        |  9 ++++-
 mm/mempolicy.c                            | 41 +++++++++------------
 net/wireless/reg.c                        | 10 +++++
 security/selinux/selinuxfs.c              |  1 +
 tools/usb/ffs-test.c                      |  2 +-
 93 files changed, 629 insertions(+), 281 deletions(-)

