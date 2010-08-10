Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab0HJVod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:44:33 -0400
Received: from kroah.org ([198.145.64.141]:48807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0HJVoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:44:30 -0400
Date: Tue, 10 Aug 2010 14:44:19 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.36
Message-ID: <20100810214419.GA17385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big USB patchset for .36.  I was waiting for the PCI tree to
be merged first as there was one dependancy on it.

There are a number of USB powermanagement patches in here, a few new
drivers, and lots of other fixes all over the place.  The changes in the
ARM directories are for a dependancy on one of the usb drivers and is
acked by the proper subsystem maintainers there.

And there are some very nice USB 3.0 speed improvements here as well,
which are always nice to see.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 .../testing/sysfs-devices-platform-_UDC_-gadget    |   12 +
 Documentation/usb/ehci.txt                         |    2 +-
 Documentation/usb/gadget_multi.txt                 |  150 ++
 Documentation/usb/gadget_serial.txt                |   87 +-
 Documentation/usb/hotplug.txt                      |    4 +-
 Documentation/usb/linux-cdc-acm.inf                |  107 ++
 Documentation/usb/linux.inf                        |  228 +---
 arch/arm/mach-mx3/mach-armadillo5x0.c              |    4 +-
 arch/arm/mach-mx3/mach-mx31lilly.c                 |    4 +-
 arch/arm/mach-mx3/mach-mx31lite.c                  |    2 +-
 arch/arm/mach-mx3/mach-mx31moboard.c               |    2 +-
 arch/arm/mach-mx3/mach-pcm037.c                    |    4 +-
 arch/arm/mach-mx3/mach-pcm043.c                    |    2 +-
 arch/arm/mach-mx3/mx31moboard-smartbot.c           |    2 +-
 .../arm/plat-samsung/include/plat/regs-usb-hsotg.h |    2 +
 drivers/staging/usbip/vhci_hcd.c                   |    6 +-
 drivers/usb/Makefile                               |    2 +-
 drivers/usb/atm/cxacru.c                           |   11 +-
 drivers/usb/atm/speedtch.c                         |   10 +-
 drivers/usb/atm/ueagle-atm.c                       |    5 +-
 drivers/usb/atm/usbatm.c                           |   23 +-
 drivers/usb/atm/usbatm.h                           |   22 +-
 drivers/usb/atm/xusbatm.c                          |   10 +-
 drivers/usb/c67x00/c67x00-hcd.c                    |    4 +-
 drivers/usb/class/usblp.c                          |  371 +++---
 drivers/usb/core/devio.c                           |    7 +-
 drivers/usb/core/driver.c                          |   11 +-
 drivers/usb/core/endpoint.c                        |    9 +-
 drivers/usb/core/generic.c                         |    4 +-
 drivers/usb/core/hcd-pci.c                         |  202 ++-
 drivers/usb/core/hcd.c                             |   79 +-
 drivers/usb/core/hub.c                             |   13 +-
 drivers/usb/core/inode.c                           |    4 -
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/core/urb.c                             |   50 +-
 drivers/usb/core/usb.c                             |    6 +-
 drivers/usb/gadget/Kconfig                         |   52 +-
 drivers/usb/gadget/Makefile                        |    3 +-
 drivers/usb/gadget/audio.c                         |    4 +-
 drivers/usb/gadget/cdc2.c                          |    4 +-
 drivers/usb/gadget/composite.c                     |   73 +-
 drivers/usb/gadget/dbgp.c                          |  434 ++++++
 drivers/usb/gadget/dummy_hcd.c                     |    6 +-
 drivers/usb/gadget/ether.c                         |    6 +-
 drivers/usb/gadget/f_fs.c                          |   38 +-
 drivers/usb/gadget/f_hid.c                         |    6 +-
 drivers/usb/gadget/f_loopback.c                    |    4 +-
 drivers/usb/gadget/f_mass_storage.c                |  125 ++-
 drivers/usb/gadget/f_sourcesink.c                  |    2 +-
 drivers/usb/gadget/file_storage.c                  |  104 ++-
 drivers/usb/gadget/g_ffs.c                         |  176 +--
 drivers/usb/gadget/gmidi.c                         |    2 +-
 drivers/usb/gadget/hid.c                           |    4 +-
 drivers/usb/gadget/inode.c                         |   16 +-
 drivers/usb/gadget/langwell_udc.c                  |    6 +-
 drivers/usb/gadget/mass_storage.c                  |   24 +-
 drivers/usb/gadget/multi.c                         |  262 ++--
 drivers/usb/gadget/printer.c                       |    9 +-
 drivers/usb/gadget/s3c-hsotg.c                     |  153 ++-
 drivers/usb/gadget/serial.c                        |    4 +-
 drivers/usb/gadget/storage_common.c                |  105 ++-
 drivers/usb/gadget/u_ether.c                       |   15 +-
 drivers/usb/gadget/u_serial.c                      |    1 +
 drivers/usb/gadget/webcam.c                        |    4 +-
 drivers/usb/gadget/zero.c                          |    2 +-
 drivers/usb/host/Kconfig                           |   11 +-
 drivers/usb/host/ehci-au1xxx.c                     |    2 +-
 drivers/usb/host/ehci-dbg.c                        |  196 ++-
 drivers/usb/host/ehci-fsl.c                        |    3 +-
 drivers/usb/host/ehci-hcd.c                        |   49 +-
 drivers/usb/host/ehci-hub.c                        |   25 +-
 drivers/usb/host/ehci-lpm.c                        |   83 ++
 drivers/usb/host/ehci-omap.c                       |   36 +
 drivers/usb/host/ehci-pci.c                        |   26 +-
 drivers/usb/host/ehci-q.c                          |    3 +-
 drivers/usb/host/ehci-sched.c                      |  182 ++--
 drivers/usb/host/ehci.h                            |   18 +-
 drivers/usb/host/hwa-hc.c                          |    4 +-
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/host/isp1362.h                         |   24 +-
 drivers/usb/host/isp1760-hcd.c                     |    3 +-
 drivers/usb/host/ohci-dbg.c                        |    4 +-
 drivers/usb/host/ohci-hcd.c                        |    6 +-
 drivers/usb/host/ohci-hub.c                        |   23 +-
 drivers/usb/host/ohci-pci.c                        |    2 +-
 drivers/usb/host/ohci-ssb.c                        |   52 +-
 drivers/usb/host/oxu210hp-hcd.c                    |    7 +-
 drivers/usb/host/sl811-hcd.c                       |    5 +-
 drivers/usb/host/uhci-debug.c                      |   23 +-
 drivers/usb/host/uhci-hcd.c                        |   87 +-
 drivers/usb/host/uhci-hcd.h                        |    7 +-
 drivers/usb/host/uhci-hub.c                        |    6 +-
 drivers/usb/host/uhci-q.c                          |    4 +-
 drivers/usb/host/whci/hcd.c                        |    2 +-
 drivers/usb/host/whci/qset.c                       |    2 +-
 drivers/usb/host/xhci-mem.c                        |  101 +-
 drivers/usb/host/xhci-pci.c                        |    9 +
 drivers/usb/host/xhci-ring.c                       | 1466 ++++++++++++++------
 drivers/usb/host/xhci.c                            |  344 +++--
 drivers/usb/host/xhci.h                            |   30 +-
 drivers/usb/misc/ftdi-elan.c                       |    4 +-
 drivers/usb/misc/iowarrior.c                       |   23 +-
 drivers/usb/misc/legousbtower.c                    |    6 +-
 drivers/usb/misc/rio500.c                          |   15 +-
 drivers/usb/misc/sisusbvga/sisusb.c                |   10 +-
 drivers/usb/misc/usblcd.c                          |   24 +-
 drivers/usb/misc/usbtest.c                         |   14 +-
 drivers/usb/mon/mon_bin.c                          |   24 +-
 drivers/usb/musb/musb_core.c                       |    7 +-
 drivers/usb/musb/musb_debugfs.c                    |   32 +-
 drivers/usb/musb/musb_gadget_ep0.c                 |    3 +
 drivers/usb/musb/musb_virthub.c                    |    2 +-
 drivers/usb/musb/musbhsdma.c                       |    5 +-
 drivers/usb/musb/omap2430.c                        |    6 -
 drivers/usb/otg/Kconfig                            |    2 -
 drivers/usb/otg/ulpi.c                             |  134 ++-
 drivers/usb/serial/Kconfig                         |    9 +
 drivers/usb/serial/Makefile                        |    1 +
 drivers/usb/serial/cp210x.c                        |    4 +
 drivers/usb/serial/ftdi_sio.c                      |    4 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   10 +
 drivers/usb/serial/generic.c                       |   15 +-
 drivers/usb/serial/io_ti.c                         |    4 +-
 drivers/usb/serial/ipaq.c                          |    1 -
 drivers/usb/serial/iuu_phoenix.c                   |   54 +-
 drivers/usb/serial/option.c                        |   17 +-
 drivers/usb/serial/ssu100.c                        |  698 ++++++++++
 drivers/usb/serial/usb-serial.c                    |   32 +-
 drivers/usb/storage/freecom.c                      |   23 +-
 drivers/usb/storage/isd200.c                       |    3 +-
 drivers/usb/storage/usb.c                          |    4 +
 drivers/usb/usb-skeleton.c                         |    8 +-
 include/linux/usb.h                                |    5 +-
 include/linux/usb/composite.h                      |    6 +
 include/linux/usb/ehci_def.h                       |   23 +
 include/linux/usb/functionfs.h                     |    6 +-
 include/linux/usb/hcd.h                            |   31 +-
 include/linux/usb/otg.h                            |   11 +-
 include/linux/usb/quirks.h                         |    4 +
 include/linux/usb/ulpi.h                           |   40 +
 140 files changed, 5086 insertions(+), 2193 deletions(-)
 create mode 100644 Documentation/usb/gadget_multi.txt
 create mode 100644 Documentation/usb/linux-cdc-acm.inf
 create mode 100644 drivers/usb/gadget/dbgp.c
 create mode 100644 drivers/usb/host/ehci-lpm.c
 create mode 100644 drivers/usb/serial/ssu100.c

---------------

Ajay Kumar Gupta (3):
      USB: musb: fix compilation warning in host only mode
      USB: ulpi: fix compilation warning
      USB: ehci_omap: fix device detect issue with modules

Alan Stern (21):
      USB: fix failure path in usb_add_hcd()
      USB: don't stop root-hub status polls too soon
      USB: add check to detect host controller hardware removal
      USB: UHCI: acquire spinlock before calling start_rh()
      USB: EHCI: make CONFIG_USB_EHCI_TT_NEWSCHED default to Y
      USB: convert usb_hcd bitfields into atomic flags
      USB: refactor the powermac-specific ASIC clock code
      USB: move PCI HCD resume routine
      USB: add do_wakeup parameter for PCI HCD suspend
      USB: controller resume should check the root hub
      USB: fix race between root-hub wakeup & controller suspend
      USB: UHCI: add support for Intel's wakeup flags
      USB: add runtime PM for PCI-based host controllers
      USB: EHCI: remove PCI assumption
      USB: EHCI: simplify remainder computations
      USB: EHCI: add missing frame -> microframe conversion
      USB: EHCI: reorganize isochronous scheduler routine
      USB: EHCI: remove dead code in the periodic scheduler
      USB: accept RNDIS configs if there's no alternative
      USB: usb-storage: implement autosuspend
      USB: remove fake "address-of" expressions

Alek Du (3):
      USB: EHCI: EHCI 1.1 addendum: preparation
      USB: EHCI: EHCI 1.1 addendum: Basic LPM feature support
      USB: EHCI: EHCI 1.1 addendum: Enable Per-port change detect bits

Alessio Igor Bogani (1):
      USB: cp210x: Add four new device IDs

Anand Gadiyar (3):
      USB: musb: use correct register widths in register dumps
      USB: musb: Kill board specific pinmux from driver file
      USB: musb: do not override DMA mode in channel program

Andi Kleen (4):
      USB-BKL: Remove lock_kernel in usbfs update_sb()
      USB-BKL: Convert usb_driver ioctl to unlocked_ioctl
      USB-BKL: Remove BKL use for usb serial driver probing
      USB-BKL: Remove BKL use in uhci-debug

Andiry Xu (10):
      USB: xHCI: handle_tx_event() refactor: finish_td
      USB: xHCI: handle_tx_event() refactor: process_ctrl_td
      USB xHCI: handle_tx_event() refactor: process_bulk_intr_td
      USB: xHCI: remove redundant print messages
      USB: xHCI: adds new cases to trb_comp_code switch
      USB: xHCI: Missed Service Error Event process
      USB: xHCI: Introduce urb_priv structure
      USB: xHCI: Isochronous transfer implementation
      USB: xHCI: allocate bigger ring for isochronous endpoint
      USB: xHCI: Isoc urb enqueue

Andrea Gelmini (3):
      USB: Documentation/usb/ehci.txt: Checkpatch cleanup
      USB: Documentation/usb/hotplug.txt: Checkpatch cleanup
      USB: Documentation/usb/linux.inf: Checkpatch cleanup

Andrea Righi (1):
      USB: EHCI: fix NULL pointer dererence in HCDs that use HCD_LOCAL_MEM

Andrew Bird (1):
      USB: option: add huawei k3765 k4505 devices to work properly

Andy Shevchenko (3):
      usb: throw away custom hex digit methods
      usb: gadget: storage: strict coversion of 'ro' parameter
      USB: gadget: storage: optional SCSI WRITE FUA bit

Arnd Bergmann (3):
      usb: gadget: Do not take BKL for gadget->ops->ioctl
      USB: mon: kill BKL usage
      USB: autoconvert trivial BKL users to private mutex

Ben Dooks (10):
      USB: s3c-hsotg: Increase TX fifo limit
      USB: s3c-hsotg: The NPTX/PTX FIFO sizes are in words, not bytes
      USB: s3c-hsotg: Avoid overwriting contents of perodic in 'fifo'
      USB: s3c-hsotg: Re-initialise all FIFOs on USB bus reset
      USB: s3c-hsotg: Add initial detection and setup for dedicated FIFO mode
      USB: s3c-hsotg: Only load packet per fifo write
      USB: s3c-hsotg: Check for new request before enqueing new setup
      USB: s3c-hsotg: Fix max EP0 IN request length
      USB: s3c-hsotg: Fix the OUT EP0 limit
      USB: s3c-hsotg: Fix OUT packet request retry

Bill Pemberton (1):
      USB: add USB serial ssu100 driver

Christian Dietrich (1):
      USB: host: Remove dead CONFIG_ARCH_KARO

Christian Lamparter (1):
      USB: fix thread-unsafe anchor utiliy routines

Dong Nguyen (1):
      USB: xHCI: Supporting MSI/MSI-X

Eric Bénard (1):
      USB: otg/ulpi.c : fix register write

Hauke Mehrtens (1):
      USB: Add USB 2.0 to ssb ohci driver

Igor Grinberg (4):
      USB: otg.h: Fix the mixup in parameters order.
      USB: otg/ulpi: remove unused macro
      USB: otg/ulpi: add support for SMSC USB3319 ulpi phy
      USB: otg/ulpi: extend the generic ulpi driver.

James Courtier-Dutton (1):
      USB: iuu_phoenix: Add support for different baud rates.

Joe Perches (5):
      USB: isd200.c: Remove unnecessary kmalloc cast
      USB: gadget: langwell_udc.c: printk needs a (unsigned long long) cast for a dma_t
      USB: usb-skeleton: Remove unnecessary casts of private_data
      USB: misc: Remove unnecessary casts of private_data
      USB: gadget: Remove unnecessary casts of private_data

Johan Hovold (1):
      USB: serial: fix stalled writes

John G. Rogers (1):
      USB: serial: enabling support for Segway RMP in ftdi_sio

Julia Lawall (2):
      USB: gadget: Use memdup_user
      USB: host: Eliminate NULL dereference

Kulikov Vasiliy (4):
      USB: xhci: trivial: use ARRAY_SIZE
      USB: core: hcd-pci: use for_each_pci_dev()
      usb: host: sl811-hcd: check kzalloc() result
      usb: imx21-hcd: set task state with schedule_timeout_uninterruptible()

Leann Ogasawara (2):
      USB: option: Remove duplicate AMOI_VENDOR_ID
      Revert "USB: Adding support for HTC Smartphones to ipaq"

Marek Szyprowski (3):
      USB: s3c-hsotg: fix compilation problem
      USB: s3c-hsotg: modify only selected bits in S3C_PHYPWR register
      USB: s3c-hsotg: add support for clock gating

Martin Enderleit (1):
      usb: storage: freecom: Fixed several coding style issues.

Maurus Cuelenaere (1):
      USB: s3c-hsotg: Add support for external USB clock

Michal Nazarewicz (17):
      USB: gadget: g_mass_storage: static data instead of dynamic allocation
      USB: gadget: f_mass_storage: fsg_add() renamed to fsg_bind_config()
      USB: gadget: f_fs: functionfs_add() renamed to functionfs_bind_config()
      USB: gadget: composite: usb_string_ids_*() functions added
      USB: gadget: f_fs: use usb_string_ids_n()
      USB: gadget: f_mass_storage: dead code removed
      USB: gadget: g_multi: code clean up and refactoring
      USB: gadget: g_ether: updated INF file
      USB: gadget: g_serial: INF file updated
      USB: gadget: g_multi: added documentation and INF files
      USB: gadget: composite: added disconnect callback
      USB: gadget: f_mass_storage: added eject callback
      USB: gadget: section mismatch warning fixed
      USB: gadget: g_fs: code cleanup
      USB: gadget: storage_common: comments updated
      USB: gadget: functionfs: stale Makefile entry removed
      USB: gadget: file_storage: serial parameter even if not test mode

Ming Lei (4):
      USB: serial: enable async suspend for usb serial port device
      USB: ehci: fix remove of ehci debugfs dir
      USB: usbtest: avoid to free coherent buffer in atomic context
      USB: usbtest: support test device with only one iso-in or iso-out endpoint

Nicolas Kaiser (6):
      USB: speedtouch: fixed brace and spacing coding style issues
      USB: speedtouch: fixed more brace and spacing coding style issues
      usb: conexant: fixed spacing and brace coding style issues
      usb: atm: fixed spacing and indentation coding style issues
      USB: usblp: fixed switch, brace, whitespace and spacing coding style issues
      USB: drivers/usb/Makefile: conditionally descend to 'early'

Pavel Kazlou (1):
      USB: option: Huawei ETS 1220 support added

Phil Dibowitz (1):
      USB delay init quirk for logitech Harmony 700-series devices

Randy Dunlap (1):
      USB:: fix linux/usb.h kernel-doc warnings

Roel Kluin (2):
      USB: serial: io_ti: Don't return 0 if writing the download record failed
      USB: io_ti.c: don't return 0 if writing the download record failed

Sarah Sharp (11):
      USB: xhci: Remove obsolete debugging printk.
      USB: xhci: Performance - move functions that find ep ring.
      USB: xhci: Performance - move interrupt handlers into xhci-ring.c
      USB: xhci: Performance - move xhci_work() into xhci_irq()
      USB: xhci: Remove unnecessary reads of IRQ_PENDING register.
      USB: xhci: Make xhci_handle_event() static.
      USB: xhci: Minimize HW event ring dequeue pointer writes.
      USB: xhci: Make xhci_set_hc_event_deq() static.
      USB: xhci: Reduce reads and writes of interrupter registers.
      USB: xhci: Don't flush doorbell writes.
      USB: xhci: Set DMA mask for host.

Steven Robertson (1):
      USB: resizing usbmon binary interface buffer causes protection faults

Yann Cantin (1):
      USB: Add a serial number parameter to g_file_storage module

csanchez@neurowork.net (2):
      USB: core driver: Fix Coding Styles
      USB: core endpoint: Fix Coding Styles

dranch@trinnet.net (1):
      USB: ftdi_sio: device id for Navitator

stephane duverger (3):
      USB: gadget: compilation issue: missing TASK_INTERRUPTIBLE
      USB: EHCI Debug Port Device Gadget
      USB: musb: forward debug mode feature to gadget

