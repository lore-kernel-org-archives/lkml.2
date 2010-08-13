Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0HMVYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:24:18 -0400
Received: from kroah.org ([198.145.64.141]:41105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab0HMVYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:24:16 -0400
Date: Fri, 13 Aug 2010 14:23:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.35.2
Message-ID: <20100813212313.GA22102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.35.2 kernel.

All users of the 2.6.35 kernel series must upgrade.

I'm tired of people trying to parse my words like I'm the Federal
Reserve Chairman, just go update already.  If you use a kernel.org-based
kernel, and you aren't updating to the latest -stable updates, well, why
are you using a kernel.org kernel in the first place?

The updated 2.6.35.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.35.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.35.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 arch/arm/Kconfig                            |   12 +++
 arch/arm/include/asm/tlbflush.h             |    8 ++
 arch/arm/mach-pxa/cm-x300.c                 |    3 
 arch/arm/plat-mxc/include/mach/gpio.h       |    1 
 arch/powerpc/Makefile                       |   16 +++-
 arch/powerpc/kernel/perf_event_fsl_emb.c    |    1 
 arch/x86/include/asm/cmpxchg_32.h           |   68 ++++++++++----------
 arch/x86/include/asm/cmpxchg_64.h           |   40 ++++++------
 arch/x86/kernel/cpu/mtrr/main.c             |   56 +++++++++++++----
 arch/x86/kernel/cpu/vmware.c                |    9 ++
 arch/x86/kernel/smpboot.c                   |    7 ++
 arch/x86/mm/fault.c                         |    4 -
 arch/x86/mm/kmmio.c                         |   16 +++-
 arch/x86/mm/testmmiotrace.c                 |   22 ++++++
 arch/x86/pci/acpi.c                         |    9 ++
 crypto/Kconfig                              |    8 ++
 crypto/algboss.c                            |    4 +
 crypto/testmgr.c                            |   14 ++++
 drivers/ata/ata_piix.c                      |    8 ++
 drivers/atm/solos-pci.c                     |    7 +-
 drivers/block/drbd/drbd_main.c              |   27 +++++---
 drivers/bluetooth/btusb.c                   |    3 
 drivers/char/ipmi/ipmi_si_intf.c            |    8 ++
 drivers/char/nozomi.c                       |    4 -
 drivers/dma/ioat/dma.h                      |    1 
 drivers/dma/ioat/dma_v2.c                   |   24 ++++++-
 drivers/dma/ioat/dma_v3.c                   |    5 +
 drivers/ide/ide-cd.c                        |   14 +++-
 drivers/md/md.c                             |   37 ++++++-----
 drivers/md/md.h                             |    4 +
 drivers/md/raid10.c                         |   18 +++++
 drivers/mtd/nand/mxc_nand.c                 |    2 
 drivers/mtd/nand/plat_nand.c                |    2 
 drivers/net/e100.c                          |    2 
 drivers/net/e1000/e1000_main.c              |    3 
 drivers/net/e1000e/netdev.c                 |    4 +
 drivers/net/igb/igb_main.c                  |    2 
 drivers/net/igbvf/netdev.c                  |    2 
 drivers/net/ixgb/ixgb_main.c                |    2 
 drivers/net/ixgbe/ixgbe_main.c              |    1 
 drivers/net/ixgbevf/ixgbevf_main.c          |    2 
 drivers/net/smsc911x.c                      |   92 +++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 
 drivers/net/wireless/rtl818x/rtl8180_dev.c  |    2 
 drivers/pci/intel-iommu.c                   |   28 ++++++++
 drivers/pci/quirks.c                        |    4 +
 drivers/pcmcia/pcmcia_resource.c            |    5 +
 drivers/serial/8250_pci.c                   |   13 +++
 drivers/staging/hv/Kconfig                  |    2 
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
 drivers/usb/musb/musb_debugfs.c             |   32 ++++-----
 drivers/usb/serial/cp210x.c                 |    4 +
 drivers/usb/serial/ftdi_sio.c               |    4 +
 drivers/usb/serial/ftdi_sio_ids.h           |   10 +++
 drivers/usb/serial/generic.c                |   15 +++-
 drivers/usb/serial/option.c                 |   13 +++
 drivers/video/w100fb.c                      |    4 -
 drivers/xen/events.c                        |    1 
 fs/block_dev.c                              |   10 +--
 fs/ecryptfs/file.c                          |   60 +++++++++++-------
 fs/ecryptfs/inode.c                         |    5 -
 fs/ext4/super.c                             |    4 -
 fs/jfs/xattr.c                              |   87 +++++++++++---------------
 fs/namespace.c                              |    2 
 fs/signalfd.c                               |    2 
 fs/super.c                                  |    6 +
 include/linux/Kbuild                        |    1 
 include/linux/fs.h                          |    7 +-
 include/linux/interrupt.h                   |    7 +-
 include/linux/notifier.h                    |    2 
 include/linux/sched.h                       |    6 -
 include/linux/usb/quirks.h                  |    4 +
 kernel/irq/manage.c                         |    2 
 kernel/sched.c                              |   10 ---
 kernel/time/tick-sched.c                    |    2 
 mm/memory.c                                 |   25 +++++++
 mm/swapfile.c                               |    6 +
 sound/pci/hda/patch_realtek.c               |    1 
 89 files changed, 723 insertions(+), 322 deletions(-)

Al Viro (1):
      Fix sget() race with failing mount

Alan Stern (1):
      USB: EHCI: remove PCI assumption

Alessio Igor Bogani (1):
      USB: cp210x: Add four new device IDs

Alexander Shishkin (1):
      crypto: testmgr - add an option to disable cryptoalgos' self-tests

Alok Kataria (1):
      x86, vmware: Preset lpj values when on VMware.

Anand Gadiyar (1):
      USB: musb: use correct register widths in register dumps

Andrew Bird (1):
      USB: option: add huawei k3765 k4505 devices to work properly

Bjorn Helgaas (1):
      x86/PCI: use host bridge _CRS info on ASRock ALiveSATA2-GLAN

Borislav Petkov (1):
      ide-cd: Do not access completed requests in the irq handler

Catalin Marinas (1):
      smsc911x: Add spinlocks around registers access

Chris Wright (1):
      blkdev: cgroup whitelist permission fix

Christian Lamparter (1):
      USB: fix thread-unsafe anchor utiliy routines

Cyril Lacoux (1):
      Bluetooth: Added support for controller shipped with iMac i5

Dan Williams (2):
      md: move revalidate_disk() back outside open_mutex
      ioat2: catch and recover from broken vtd configurations v6

Dave Kleikamp (1):
      jfs: don't allow os2 xattr namespace overlap with others

David S. Miller (1):
      net: Fix NETDEV_NOTIFY_PEERS to not conflict with NETDEV_BONDING_DESLAVE.

David Woodhouse (1):
      solos-pci: Fix race condition in tasklet RX handling

Dominik Brodowski (1):
      pcmcia: avoid buffer overflow in pcmcia_setup_isa_irq

Eric Bénard (1):
      mtd: mxc_nand: fix unbalanced enable for IRQ

Eric Sandeen (1):
      ext4: fix freeze deadlock under IO

Greg Kroah-Hartman (1):
      Linux 2.6.35.2

H. Peter Anvin (1):
      x86: Add memory modify constraints to xchg() and cmpxchg()

Haiyang Zhang (1):
      staging: hv: Fix Kconfig dependency of hv_blkvsc

Ian Campbell (2):
      irq: Add new IRQ flag IRQF_NO_SUSPEND
      xen: Do not suspend IPI IRQs.

Igor Grinberg (1):
      pxa/cm-x300: fix ffuart registration

James Chapman (1):
      l2tp: fix export of header file for userspace

Jeff Kirsher (1):
      e100/e1000*/igb*/ixgb*: Add missing read memory barrier

Jiri Slaby (2):
      Char: nozomi, fix tty->count counting
      Char: nozomi, set tty->driver_data appropriately

Johan Hovold (1):
      USB: serial: fix stalled writes

Johannes Berg (1):
      iwlwifi: fix TX tracer

John G. Rogers (1):
      USB: serial: enabling support for Segway RMP in ftdi_sio

John W. Linville (1):
      rtl8180: avoid potential NULL deref in rtl8180_beacon_work

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

Lytochkin Boris (1):
      serial: add support for OX16PCI958 card

Marcin Slusarz (1):
      x86, kmmio/mmiotrace: Fix double free of kmmio_fault_pages

Marek Vasut (1):
      mtd: gen_nand: fix support for multiple chips

Ming Lei (1):
      USB: usbtest: avoid to free coherent buffer in atomic context

Nathan Lynch (1):
      signalfd: fill in ssi_int for posix timers and message queues

NeilBrown (2):
      md: fix another deadlock with removing sysfs attributes.
      md/raid10: fix deadlock with unaligned read during resync

Pavel Kazlou (1):
      USB: option: Huawei ETS 1220 support added

Peter Huewe (2):
      Staging: panel: Prevent double-calling of parport_release - fix oops.
      drivers/video/w100fb.c: ignore void return value / fix build failure

Peter Zijlstra (1):
      sched: Revert nohz_ratelimit() for now

Phil Dibowitz (1):
      USB delay init quirk for logitech Harmony 700-series devices

Philipp Reisner (2):
      drbd: Initialize all members of sync_conf to their defaults [Bugz 315]
      drbd: Disable delay probes for the upcomming release

Rafael J. Wysocki (1):
      PCI: Do not run NVidia quirks related to MSI with MSI disabled

Randy Dunlap (1):
      Staging: line6: needs to select SND_PCM

Sam Ravnborg (1):
      powerpc: fix build with make 3.82

Scott Wood (1):
      perf, powerpc: fsl_emb: Restore setting perf_sample_data.period

Steven Robertson (1):
      USB: resizing usbmon binary interface buffer causes protection faults

Suresh Siddha (1):
      x86, mtrr: Use stop machine context to rendezvous all the cpu's

Takashi Iwai (1):
      ALSA: hda - Add PC-beep whitelist for an Intel board

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

Yinghai Lu (1):
      ipmi: fix ACPI detection with regspacing

dranch@trinnet.net (1):
      USB: ftdi_sio: device id for Navitator

