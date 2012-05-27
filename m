Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2E0AwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:52:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44656 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2E0AwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:52:10 -0400
Date: Sun, 27 May 2012 09:52:03 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/55] 3.0.33-stable review
Message-ID: <20120527005203.GA2146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.33 release.
There are 56 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue May 29 00:26:11 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.33-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/HOWTO                       | 32 ++++++++++++------------
 Makefile                                  |  4 +--
 arch/arm/include/asm/cacheflush.h         |  2 +-
 arch/arm/kernel/traps.c                   |  4 ++-
 arch/parisc/include/asm/prefetch.h        |  7 +++++-
 arch/parisc/kernel/entry.S                |  4 +++
 arch/parisc/kernel/pacache.S              | 38 ++++++++++++++--------------
 arch/s390/mm/fault.c                      | 14 +++++++++--
 arch/sparc/Kconfig                        |  3 +++
 arch/sparc/kernel/systbls_64.S            |  2 +-
 arch/tile/Kconfig                         |  1 +
 arch/tile/include/asm/bitops.h            | 12 ++++-----
 arch/um/include/asm/pgtable.h             | 10 ++++++--
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 16 +++++++-----
 arch/x86/kernel/cpu/perf_event_amd.c      | 11 ++++++++-
 block/genhd.c                             | 10 +++++---
 drivers/ata/ahci.c                        |  2 ++
 drivers/gpu/drm/i915/i915_irq.c           |  9 +++----
 drivers/gpu/drm/i915/i915_reg.h           | 15 +++++++++++
 drivers/gpu/drm/i915/intel_display.c      | 19 ++++++++++++--
 drivers/gpu/drm/nouveau/nouveau_bo.c      |  2 +-
 drivers/i2c/busses/i2c-davinci.c          |  2 +-
 drivers/infiniband/hw/cxgb4/cm.c          |  6 +++++
 drivers/isdn/gigaset/capi.c               | 22 +++++++----------
 drivers/md/md.c                           |  2 +-
 drivers/media/dvb/siano/smsusb.c          |  2 ++
 drivers/media/video/uvc/uvc_v4l2.c        |  2 +-
 drivers/mmc/core/sdio.c                   |  2 +-
 drivers/mmc/core/sdio_irq.c               | 11 ++++++---
 drivers/mtd/sm_ftl.c                      |  2 +-
 drivers/rtc/rtc-pl031.c                   | 18 ++++++++++++++
 drivers/scsi/hpsa.c                       | 34 +++++++++++--------------
 drivers/scsi/isci/init.c                  |  2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c       |  6 ++---
 drivers/staging/comedi/comedi_fops.c      |  2 +-
 drivers/tty/serial/mxs-auart.c            |  2 ++
 drivers/tty/serial/serial_core.c          |  1 +
 drivers/usb/class/cdc-wdm.c               |  2 +-
 drivers/usb/core/devio.c                  | 33 +++++++++++++++++++------
 drivers/usb/core/quirks.c                 |  3 +++
 drivers/usb/gadget/fsl_udc_core.c         |  2 ++
 drivers/usb/host/ehci-pci.c               |  4 ++-
 drivers/usb/host/pci-quirks.c             | 18 +++++++++++++-
 drivers/usb/host/xhci-mem.c               |  1 +
 drivers/usb/host/xhci-pci.c               |  1 +
 drivers/usb/host/xhci-ring.c              | 21 +++++++++++++---
 drivers/usb/host/xhci.h                   |  1 +
 drivers/usb/misc/usbtest.c                | 17 +++++++++----
 drivers/usb/serial/ftdi_sio.c             |  1 +
 drivers/usb/serial/ftdi_sio_ids.h         |  8 ++++++
 drivers/usb/serial/ti_usb_3410_5052.c     |  6 +++--
 drivers/usb/serial/ti_usb_3410_5052.h     |  1 +
 drivers/usb/storage/unusual_devs.h        |  7 ++++++
 fs/aio.c                                  | 30 +++++++++++-----------
 fs/block_dev.c                            |  6 ++---
 fs/buffer.c                               |  4 ++-
 include/linux/fs.h                        |  1 +
 include/linux/genhd.h                     |  6 -----
 include/linux/mmc/host.h                  |  2 ++
 init/main.c                               |  7 +++---
 kernel/workqueue.c                        |  9 +++++--
 mm/mempolicy.c                            | 41 +++++++++++++------------------
 net/wireless/reg.c                        | 10 ++++++++
 security/selinux/selinuxfs.c              |  1 +
 tools/usb/ffs-test.c                      |  2 +-
 65 files changed, 385 insertions(+), 193 deletions(-)

