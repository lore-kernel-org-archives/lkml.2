Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab0HLADZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:03:25 -0400
Received: from kroah.org ([198.145.64.141]:60052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab0HLADX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:03:23 -0400
Date: Wed, 11 Aug 2010 17:02:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/54] 2.6.34.4 -stable review
Message-ID: <20100812000249.GA30948@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.34.4 release.
There are 54 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Friday, August 13, 2010, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.34.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                    |    2 +-
 arch/arm/Kconfig                            |   12 ++++
 arch/arm/include/asm/tlbflush.h             |    8 +++
 arch/arm/mach-pxa/cm-x300.c                 |    3 +-
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 +
 arch/powerpc/Makefile                       |   16 ++++-
 arch/x86/include/asm/cmpxchg_32.h           |   68 ++++++++++----------
 arch/x86/include/asm/cmpxchg_64.h           |   40 ++++++------
 arch/x86/kernel/cpu/vmware.c                |    9 +++-
 arch/x86/mm/kmmio.c                         |   16 ++++-
 arch/x86/mm/testmmiotrace.c                 |   22 +++++++
 arch/x86/pci/acpi.c                         |    9 +++
 drivers/ata/ata_piix.c                      |    8 +++
 drivers/atm/solos-pci.c                     |    7 ++-
 drivers/bluetooth/btusb.c                   |    3 +
 drivers/char/nozomi.c                       |    4 +-
 drivers/gpu/drm/drm_edid.c                  |    4 +-
 drivers/gpu/drm/i915/dvo_tfp410.c           |    2 +-
 drivers/gpu/drm/i915/intel_dp.c             |   27 +++++++-
 drivers/ide/ide-cd.c                        |   14 +++-
 drivers/md/bitmap.c                         |    4 +-
 drivers/md/bitmap.h                         |    1 +
 drivers/md/raid1.c                          |   25 +++++--
 drivers/md/raid10.c                         |   18 +++++
 drivers/mtd/nand/plat_nand.c                |    2 +-
 drivers/net/smsc911x.c                      |   92 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 +-
 drivers/net/xen-netfront.c                  |    1 +
 drivers/pci/quirks.c                        |    4 +
 drivers/scsi/ibmvscsi/ibmvfc.c              |    8 ++-
 drivers/scsi/ibmvscsi/ibmvfc.h              |    1 +
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
 drivers/usb/serial/cp210x.c                 |    4 +
 drivers/usb/serial/ftdi_sio.c               |    4 +
 drivers/usb/serial/ftdi_sio_ids.h           |   10 +++
 drivers/usb/serial/option.c                 |   13 ++++
 drivers/video/w100fb.c                      |    4 +-
 drivers/xen/events.c                        |    1 +
 fs/block_dev.c                              |   10 ++-
 fs/ecryptfs/file.c                          |   60 +++++++++++-------
 fs/ecryptfs/inode.c                         |    5 +-
 fs/jfs/xattr.c                              |   87 +++++++++++--------------
 fs/signalfd.c                               |    2 +
 fs/splice.c                                 |   12 +---
 include/linux/fs.h                          |    6 +-
 include/linux/interrupt.h                   |    7 ++-
 include/linux/netdevice.h                   |    2 +
 include/linux/notifier.h                    |    1 +
 include/linux/usb/quirks.h                  |    4 +
 kernel/irq/manage.c                         |    2 +-
 mm/swapfile.c                               |    6 +-
 net/ipv4/devinet.c                          |    1 +
 net/sched/sch_generic.c                     |   18 +++++
 63 files changed, 513 insertions(+), 262 deletions(-)
