Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0HMV0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:26:36 -0400
Received: from kroah.org ([198.145.64.141]:41137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab0HMV0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:26:24 -0400
Date: Fri, 13 Aug 2010 14:25:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.34.4
Message-ID: <20100813212557.GG22102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.4 kernel.

All users of the 2.6.34 kernel series must upgrade.  Actually, you
should switch to the .35 kernel releases, as there is only going to be
one more .34-stable kernel release after this one.

The updated 2.6.34.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.34.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm/Kconfig                            |   12 +++
 arch/arm/include/asm/tlbflush.h             |    8 ++
 arch/arm/mach-pxa/cm-x300.c                 |    3 
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 
 arch/powerpc/Makefile                       |   16 +++-
 arch/x86/include/asm/cmpxchg_32.h           |   68 ++++++++++----------
 arch/x86/include/asm/cmpxchg_64.h           |   40 ++++++------
 arch/x86/kernel/cpu/vmware.c                |    9 ++
 arch/x86/mm/fault.c                         |    4 -
 arch/x86/mm/kmmio.c                         |   16 +++-
 arch/x86/mm/testmmiotrace.c                 |   22 ++++++
 arch/x86/pci/acpi.c                         |    9 ++
 drivers/ata/ata_piix.c                      |    8 ++
 drivers/atm/solos-pci.c                     |    7 +-
 drivers/bluetooth/btusb.c                   |    3 
 drivers/char/nozomi.c                       |    4 -
 drivers/gpu/drm/drm_edid.c                  |    4 -
 drivers/gpu/drm/i915/dvo_tfp410.c           |    2 
 drivers/gpu/drm/i915/intel_dp.c             |   27 +++++++-
 drivers/ide/ide-cd.c                        |   14 +++-
 drivers/md/bitmap.c                         |    4 -
 drivers/md/bitmap.h                         |    1 
 drivers/md/raid1.c                          |   25 +++++--
 drivers/md/raid10.c                         |   18 +++++
 drivers/mtd/nand/plat_nand.c                |    2 
 drivers/net/smsc911x.c                      |   92 +++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 
 drivers/net/xen-netfront.c                  |    1 
 drivers/pci/quirks.c                        |    4 +
 drivers/scsi/ibmvscsi/ibmvfc.c              |    8 ++
 drivers/scsi/ibmvscsi/ibmvfc.h              |    1 
 drivers/staging/line6/Kconfig               |    1 
 drivers/staging/panel/panel.c               |    2 
 drivers/staging/rt2860/usb_main_dev.c       |    1 
 drivers/usb/core/hub.c                      |    6 +
 drivers/usb/core/quirks.c                   |    3 
 drivers/usb/core/urb.c                      |   50 ++++++---------
 drivers/usb/host/ehci-pci.c                 |    1 
 drivers/usb/host/ehci-sched.c               |   10 +--
 drivers/usb/host/ehci.h                     |    1 
 drivers/usb/misc/usbtest.c                  |    6 +
 drivers/usb/mon/mon_bin.c                   |    2 
 drivers/usb/serial/cp210x.c                 |    4 +
 drivers/usb/serial/ftdi_sio.c               |    4 +
 drivers/usb/serial/ftdi_sio_ids.h           |   10 +++
 drivers/usb/serial/option.c                 |   13 +++
 drivers/video/w100fb.c                      |    4 -
 drivers/xen/events.c                        |    1 
 fs/block_dev.c                              |   10 +--
 fs/ecryptfs/file.c                          |   60 +++++++++++-------
 fs/ecryptfs/inode.c                         |    5 -
 fs/jfs/xattr.c                              |   87 +++++++++++---------------
 fs/signalfd.c                               |    2 
 fs/splice.c                                 |   12 ---
 include/linux/fs.h                          |    6 -
 include/linux/interrupt.h                   |    7 +-
 include/linux/netdevice.h                   |    2 
 include/linux/notifier.h                    |    1 
 include/linux/usb/quirks.h                  |    4 +
 kernel/irq/manage.c                         |    2 
 mm/memory.c                                 |   25 +++++++
 mm/swapfile.c                               |    6 +
 net/ipv4/devinet.c                          |    1 
 net/sched/sch_generic.c                     |   18 +++++
 65 files changed, 541 insertions(+), 263 deletions(-)

Adam Jackson (1):
      drm/edid: Fix the HDTV hack sync adjustment

Alan Stern (1):
      USB: EHCI: remove PCI assumption

Alessio Igor Bogani (1):
      USB: cp210x: Add four new device IDs

Alok Kataria (1):
      x86, vmware: Preset lpj values when on VMware.

Andrew Bird (1):
      USB: option: add huawei k3765 k4505 devices to work properly

Bjorn Helgaas (1):
      x86/PCI: use host bridge _CRS info on ASRock ALiveSATA2-GLAN

Borislav Petkov (1):
      ide-cd: Do not access completed requests in the irq handler

Brian King (2):
      ibmvfc: Fix command completion handling
      ibmvfc: Reduce error recovery timeout

Catalin Marinas (1):
      smsc911x: Add spinlocks around registers access

Chris Wright (1):
      blkdev: cgroup whitelist permission fix

Christian Lamparter (1):
      USB: fix thread-unsafe anchor utiliy routines

Cyril Lacoux (1):
      Bluetooth: Added support for controller shipped with iMac i5

Dave Airlie (1):
      i915: fix ironlake edp panel setup (v4)

Dave Kleikamp (1):
      jfs: don't allow os2 xattr namespace overlap with others

Dave Müller (1):
      drm/i915: Use RSEN instead of HTPLG for tfp410 monitor detection.

David S. Miller (1):
      net: Fix NETDEV_NOTIFY_PEERS to not conflict with NETDEV_BONDING_DESLAVE.

David Woodhouse (1):
      solos-pci: Fix race condition in tasklet RX handling

Greg Kroah-Hartman (1):
      Linux 2.6.34.4

H. Peter Anvin (1):
      x86: Add memory modify constraints to xchg() and cmpxchg()

Ian Campbell (4):
      arp_notify: allow drivers to explicitly request a notification event.
      xen: netfront: explicitly generate arp_notify event after migration.
      irq: Add new IRQ flag IRQF_NO_SUSPEND
      xen: Do not suspend IPI IRQs.

Igor Grinberg (1):
      pxa/cm-x300: fix ffuart registration

Jiri Slaby (2):
      Char: nozomi, fix tty->count counting
      Char: nozomi, set tty->driver_data appropriately

Johannes Berg (1):
      iwlwifi: fix TX tracer

John G. Rogers (1):
      USB: serial: enabling support for Segway RMP in ftdi_sio

Julia Lawall (1):
      fs/ecryptfs/file.c: introduce missing free

KAMEZAWA Hiroyuki (1):
      mm: fix corruption of hibernation caused by reusing swap during image saving

Larry Finger (1):
      staging: rt2870: Add USB ID for Belkin F6D4050 v2

Lino Sanfilippo (1):
      ecryptfs: release reference to lower mount if interpose fails

Linus Torvalds (3):
      mm: keep a guard page below a grow-down stack segment
      mm: fix missing page table unmap for stack guard page failure case
      x86: don't send SIGBUS for kernel page faults

Marcin Slusarz (1):
      x86, kmmio/mmiotrace: Fix double free of kmmio_fault_pages

Marek Vasut (1):
      mtd: gen_nand: fix support for multiple chips

Miklos Szeredi (1):
      splice: fix misuse of SPLICE_F_NONBLOCK

Ming Lei (1):
      USB: usbtest: avoid to free coherent buffer in atomic context

Nathan Lynch (1):
      signalfd: fill in ssi_int for posix timers and message queues

NeilBrown (2):
      md/raid10: fix deadlock with unaligned read during resync
      md/raid1: delay reads that could overtake behind-writes.

Pavel Kazlou (1):
      USB: option: Huawei ETS 1220 support added

Peter Huewe (2):
      Staging: panel: Prevent double-calling of parport_release - fix oops.
      drivers/video/w100fb.c: ignore void return value / fix build failure

Phil Dibowitz (1):
      USB delay init quirk for logitech Harmony 700-series devices

Rafael J. Wysocki (1):
      PCI: Do not run NVidia quirks related to MSI with MSI disabled

Randy Dunlap (1):
      Staging: line6: needs to select SND_PCM

Sam Ravnborg (1):
      powerpc: fix build with make 3.82

Steven Robertson (1):
      USB: resizing usbmon binary interface buffer causes protection faults

Tejun Heo (3):
      ata_piix: fix locking around SIDPR access
      PCI: disable MSI on VIA K8M800
      bio, fs: update RWA_MASK, READA and SWRITE to match the corresponding BIO_RW_* bits

Tyler Hicks (1):
      eCryptfs: Handle ioctl calls with unlocked and compat functions

Uwe Kleine-König (1):
      ARM: 6280/1: imx: Fix build failure when including <mach/gpio.h> without <linux/spinlock.h>

Will Deacon (1):
      ARM: 6299/1: errata: TLBIASIDIS and TLBIMVAIS operations can broadcast a faulty ASID

dranch@trinnet.net (1):
      USB: ftdi_sio: device id for Navitator

