Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0HLAHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:07:44 -0400
Received: from kroah.org ([198.145.64.141]:60422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab0HLAHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:07:40 -0400
Date: Wed, 11 Aug 2010 17:06:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/67] 2.6.35.2 stable review
Message-ID: <20100812000641.GA6348@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.35.2 release.
There are 67 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, August 13, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    2 +-
 arch/arm/Kconfig                            |   12 ++++
 arch/arm/include/asm/tlbflush.h             |    8 +++
 arch/arm/mach-pxa/cm-x300.c                 |    3 +-
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 +
 arch/powerpc/Makefile                       |   16 ++++-
 arch/powerpc/kernel/perf_event_fsl_emb.c    |    1 +
 arch/x86/include/asm/cmpxchg_32.h           |   68 ++++++++++----------
 arch/x86/include/asm/cmpxchg_64.h           |   40 ++++++------
 arch/x86/kernel/cpu/mtrr/main.c             |   56 +++++++++++++----
 arch/x86/kernel/cpu/vmware.c                |    9 +++-
 arch/x86/kernel/smpboot.c                   |    7 ++
 arch/x86/mm/kmmio.c                         |   16 ++++-
 arch/x86/mm/testmmiotrace.c                 |   22 +++++++
 arch/x86/pci/acpi.c                         |    9 +++
 crypto/Kconfig                              |    8 +++
 crypto/algboss.c                            |    4 +
 crypto/testmgr.c                            |   14 ++++
 drivers/ata/ata_piix.c                      |    8 +++
 drivers/atm/solos-pci.c                     |    7 ++-
 drivers/block/drbd/drbd_main.c              |   27 ++++++---
 drivers/bluetooth/btusb.c                   |    3 +
 drivers/char/ipmi/ipmi_si_intf.c            |    8 +++
 drivers/char/nozomi.c                       |    4 +-
 drivers/dma/ioat/dma.h                      |    1 +
 drivers/dma/ioat/dma_v2.c                   |   24 +++++++-
 drivers/dma/ioat/dma_v3.c                   |    5 +-
 drivers/ide/ide-cd.c                        |   14 +++-
 drivers/md/md.c                             |   37 ++++++-----
 drivers/md/md.h                             |    4 +
 drivers/md/raid10.c                         |   18 +++++
 drivers/mtd/nand/mxc_nand.c                 |    2 +-
 drivers/mtd/nand/plat_nand.c                |    2 +-
 drivers/net/e100.c                          |    2 +
 drivers/net/e1000/e1000_main.c              |    3 +
 drivers/net/e1000e/netdev.c                 |    4 +
 drivers/net/igb/igb_main.c                  |    2 +
 drivers/net/igbvf/netdev.c                  |    2 +
 drivers/net/ixgb/ixgb_main.c                |    2 +
 drivers/net/ixgbe/ixgbe_main.c              |    1 +
 drivers/net/ixgbevf/ixgbevf_main.c          |    2 +
 drivers/net/smsc911x.c                      |   92 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    2 +
 drivers/pci/intel-iommu.c                   |   28 ++++++++
 drivers/pci/quirks.c                        |    4 +
 drivers/pcmcia/pcmcia_resource.c            |    5 +-
 drivers/serial/8250_pci.c                   |   13 ++++
 drivers/staging/hv/Kconfig                  |    2 +-
 drivers/staging/line6/Kconfig               |    1 +
 drivers/staging/panel/panel.c               |    2 +
 drivers/staging/rt2860/usb_main_dev.c       |    1 +
 drivers/usb/core/hub.c                      |    6 ++-
 drivers/usb/core/quirks.c                   |    3 +
 drivers/usb/core/urb.c                      |   50 ++++++---------
 drivers/usb/host/ehci-pci.c                 |    1 +
 drivers/usb/host/ehci-sched.c               |   10 +--
 drivers/usb/host/ehci.h                     |    1 +
 drivers/usb/misc/usbtest.c                  |    6 ++-
 drivers/usb/mon/mon_bin.c                   |    2 +-
 drivers/usb/musb/musb_debugfs.c             |   32 +++++-----
 drivers/usb/serial/cp210x.c                 |    4 +
 drivers/usb/serial/ftdi_sio.c               |    4 +
 drivers/usb/serial/ftdi_sio_ids.h           |   10 +++
 drivers/usb/serial/generic.c                |   15 +++--
 drivers/usb/serial/option.c                 |   13 ++++
 drivers/video/w100fb.c                      |    4 +-
 drivers/xen/events.c                        |    1 +
 fs/block_dev.c                              |   10 ++-
 fs/ecryptfs/file.c                          |   60 +++++++++++-------
 fs/ecryptfs/inode.c                         |    5 +-
 fs/ext4/super.c                             |    4 +-
 fs/jfs/xattr.c                              |   87 +++++++++++--------------
 fs/namespace.c                              |    2 +-
 fs/signalfd.c                               |    2 +
 fs/super.c                                  |    6 ++
 include/linux/Kbuild                        |    1 +
 include/linux/fs.h                          |    7 +-
 include/linux/interrupt.h                   |    7 ++-
 include/linux/notifier.h                    |    2 +-
 include/linux/sched.h                       |    6 --
 include/linux/usb/quirks.h                  |    4 +
 kernel/irq/manage.c                         |    2 +-
 kernel/sched.c                              |   10 ---
 kernel/time/tick-sched.c                    |    2 +-
 mm/swapfile.c                               |    6 +-
 sound/pci/hda/patch_realtek.c               |    1 +
 87 files changed, 695 insertions(+), 321 deletions(-)
