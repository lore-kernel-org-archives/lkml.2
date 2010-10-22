Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab0JVRvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 13:51:36 -0400
Received: from kroah.org ([198.145.64.141]:36258 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab0JVRve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 13:51:34 -0400
Date: Fri, 22 Oct 2010 10:51:02 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for .37-rc1
Message-ID: <20101022175102.GA13489@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big USB patchset for .37-rc1.

Nothing major here, just some new drivers, new device ids, and of
course, more xhci fixes/speedups for all to enjoy.

There are a few patches here outside of the drivers/usb/ tree, for
platform specific code, that has been acked by the proper people and
asked to go through this tree as it affects USB driver stuff.

There's also some scsi changes, which have been discussed by the scsi
developers and agreed to go through this tree as they are related to the
usb-storage driver changes at the same time.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/devices.txt                      |    5 +-
 Documentation/powerpc/dts-bindings/fsl/usb.txt |   22 +
 Documentation/usb/proc_usb_info.txt            |   34 +-
 MAINTAINERS                                    |    8 +
 arch/arm/mach-mx3/mach-cpuimx35.c              |    1 +
 arch/arm/mach-omap2/board-am3517evm.c          |   30 +
 arch/arm/mach-omap2/usb-musb.c                 |    4 +
 arch/arm/plat-omap/include/plat/usb.h          |   21 +
 arch/powerpc/sysdev/fsl_soc.c                  |  163 --
 drivers/block/ub.c                             |    2 +-
 drivers/hid/hid-core.c                         |    1 +
 drivers/hid/hid-ids.h                          |    3 +
 drivers/scsi/sd.c                              |   12 +
 drivers/scsi/sr.c                              |    8 +-
 drivers/usb/Kconfig                            |    1 +
 drivers/usb/atm/Makefile                       |    6 +-
 drivers/usb/c67x00/Makefile                    |    6 +-
 drivers/usb/class/cdc-acm.c                    |    2 +-
 drivers/usb/core/Makefile                      |   21 +-
 drivers/usb/core/devices.c                     |   11 +-
 drivers/usb/core/driver.c                      |    2 +-
 drivers/usb/core/endpoint.c                    |    2 +-
 drivers/usb/core/hcd-pci.c                     |    4 +-
 drivers/usb/core/hcd.c                         |   19 +-
 drivers/usb/core/hub.c                         |   41 +-
 drivers/usb/core/message.c                     |   14 +-
 drivers/usb/core/urb.c                         |    5 +-
 drivers/usb/early/Makefile                     |    2 +-
 drivers/usb/gadget/Kconfig                     |   22 +-
 drivers/usb/gadget/Makefile                    |   41 +-
 drivers/usb/gadget/amd5536udc.c                |   15 +-
 drivers/usb/gadget/at91_udc.c                  |   11 +-
 drivers/usb/gadget/atmel_usba_udc.c            |   10 +-
 drivers/usb/gadget/audio.c                     |   10 +-
 drivers/usb/gadget/cdc2.c                      |   10 +-
 drivers/usb/gadget/ci13xxx_udc.c               |   18 +-
 drivers/usb/gadget/composite.c                 |  139 +-
 drivers/usb/gadget/dbgp.c                      |   19 +-
 drivers/usb/gadget/dummy_hcd.c                 |   18 +-
 drivers/usb/gadget/ether.c                     |   16 +-
 drivers/usb/gadget/f_acm.c                     |    2 +-
 drivers/usb/gadget/f_loopback.c                |    7 +-
 drivers/usb/gadget/f_mass_storage.c            |   88 +-
 drivers/usb/gadget/f_sourcesink.c              |    5 +-
 drivers/usb/gadget/file_storage.c              |  128 +-
 drivers/usb/gadget/fsl_mxc_udc.c               |   15 +
 drivers/usb/gadget/fsl_qe_udc.c                |   12 +-
 drivers/usb/gadget/fsl_udc_core.c              |   10 +-
 drivers/usb/gadget/g_ffs.c                     |   91 +-
 drivers/usb/gadget/gmidi.c                     |    5 +-
 drivers/usb/gadget/goku_udc.c                  |   35 +-
 drivers/usb/gadget/hid.c                       |   10 +-
 drivers/usb/gadget/imx_udc.c                   |    9 +-
 drivers/usb/gadget/inode.c                     |    6 +-
 drivers/usb/gadget/langwell_udc.c              | 1058 +++++++-----
 drivers/usb/gadget/langwell_udc.h              |   15 +-
 drivers/usb/gadget/lh7a40x_udc.c               |   10 +-
 drivers/usb/gadget/m66592-udc.c                |    9 +-
 drivers/usb/gadget/mass_storage.c              |   82 +-
 drivers/usb/gadget/multi.c                     |   36 +-
 drivers/usb/gadget/net2280.c                   |   10 +-
 drivers/usb/gadget/nokia.c                     |   11 +-
 drivers/usb/gadget/omap_udc.c                  |   10 +-
 drivers/usb/gadget/printer.c                   |    7 +-
 drivers/usb/gadget/pxa25x_udc.c                |    9 +-
 drivers/usb/gadget/pxa27x_udc.c                |   12 +-
 drivers/usb/gadget/r8a66597-udc.c              |   14 +-
 drivers/usb/gadget/r8a66597-udc.h              |    2 +-
 drivers/usb/gadget/rndis.c                     |  492 +++---
 drivers/usb/gadget/s3c-hsotg.c                 |    9 +-
 drivers/usb/gadget/s3c2410_udc.c               |   17 +-
 drivers/usb/gadget/serial.c                    |   11 +-
 drivers/usb/gadget/storage_common.c            |   49 +-
 drivers/usb/gadget/webcam.c                    |   11 +-
 drivers/usb/gadget/zero.c                      |    5 +-
 drivers/usb/host/Kconfig                       |   10 +-
 drivers/usb/host/Makefile                      |   24 +-
 drivers/usb/host/ehci-fsl.c                    |  105 +-
 drivers/usb/host/ehci-fsl.h                    |   14 +-
 drivers/usb/host/ehci-hcd.c                    |   15 +
 drivers/usb/host/ehci-mem.c                    |    2 +-
 drivers/usb/host/ehci-mxc.c                    |   13 +-
 drivers/usb/host/fsl-mph-dr-of.c               |  308 +++
 drivers/usb/host/imx21-hcd.c                   |  284 +++-
 drivers/usb/host/imx21-hcd.h                   |    8 +-
 drivers/usb/host/isp116x-hcd.c                 |    6 +-
 drivers/usb/host/isp1362-hcd.c                 |   25 +-
 drivers/usb/host/ohci-hcd.c                    |   12 +-
 drivers/usb/host/ohci-pci.c                    |   18 +
 drivers/usb/host/ohci-sh.c                     |    3 +-
 drivers/usb/host/ohci-sm501.c                  |    4 +-
 drivers/usb/host/ohci.h                        |    1 +
 drivers/usb/host/oxu210hp-hcd.c                |    2 +-
 drivers/usb/host/pci-quirks.c                  |   18 +-
 drivers/usb/host/r8a66597.h                    |    2 +-
 drivers/usb/host/uhci-q.c                      |   33 +-
 drivers/usb/host/whci/Kbuild                   |    2 +-
 drivers/usb/host/xhci-hub.c                    |  419 ++++-
 drivers/usb/host/xhci-mem.c                    |    5 +
 drivers/usb/host/xhci-pci.c                    |   38 +-
 drivers/usb/host/xhci-ring.c                   |  101 +-
 drivers/usb/host/xhci.c                        |  343 +++-
 drivers/usb/host/xhci.h                        |   65 +-
 drivers/usb/misc/Kconfig                       |   13 +
 drivers/usb/misc/Makefile                      |   45 +-
 drivers/usb/misc/ftdi-elan.c                   |    2 +-
 drivers/usb/misc/iowarrior.c                   |    2 +-
 drivers/usb/misc/sisusbvga/Makefile            |    3 +-
 drivers/usb/misc/usbtest.c                     |  667 ++++----
 drivers/usb/misc/yurex.c                       |  563 ++++++
 drivers/usb/mon/Makefile                       |    2 +-
 drivers/usb/musb/Kconfig                       |   16 +-
 drivers/usb/musb/Makefile                      |   71 +-
 drivers/usb/musb/am35x.c                       |  524 +++++
 drivers/usb/musb/blackfin.c                    |    7 +-
 drivers/usb/musb/cppi_dma.c                    |    2 +-
 drivers/usb/musb/da8xx.c                       |  469 +++++
 drivers/usb/musb/davinci.c                     |    2 +
 drivers/usb/musb/musb_core.c                   |   57 +-
 drivers/usb/musb/musb_core.h                   |    2 +
 drivers/usb/musb/musb_debug.h                  |   11 +-
 drivers/usb/musb/musb_gadget.c                 |  132 +-
 drivers/usb/musb/musb_gadget.h                 |    2 +
 drivers/usb/musb/musb_host.c                   |   11 +-
 drivers/usb/musb/musbhsdma.c                   |    2 +-
 drivers/usb/musb/omap2430.c                    |    1 +
 drivers/usb/musb/tusb6010.c                    |    4 +
 drivers/usb/otg/Kconfig                        |   14 +
 drivers/usb/otg/Makefile                       |    8 +-
 drivers/usb/otg/langwell_otg.c                 | 2408 ++++++++++++++++++++++++
 drivers/usb/otg/ulpi.c                         |   60 +-
 drivers/usb/serial/Kconfig                     |    9 +
 drivers/usb/serial/Makefile                    |   10 +-
 drivers/usb/serial/cp210x.c                    |    2 +
 drivers/usb/serial/ftdi_sio.c                  |   42 +-
 drivers/usb/serial/ftdi_sio_ids.h              |   39 +-
 drivers/usb/serial/mct_u232.c                  |    7 +-
 drivers/usb/serial/opticon.c                   |   44 +-
 drivers/usb/serial/option.c                    |   30 +-
 drivers/usb/serial/qcserial.c                  |   33 +-
 drivers/usb/serial/sam-ba.c                    |  206 ++
 drivers/usb/serial/visor.c                     |   11 +-
 drivers/usb/storage/Kconfig                    |   13 +
 drivers/usb/storage/Makefile                   |   35 +-
 drivers/usb/storage/scsiglue.c                 |   16 +-
 drivers/usb/storage/sddr09.c                   |    2 +-
 drivers/usb/storage/transport.c                |   10 +-
 drivers/usb/storage/uas.c                      |  751 ++++++++
 drivers/usb/storage/unusual_alauda.h           |    4 +-
 drivers/usb/storage/unusual_cypress.h          |    4 +-
 drivers/usb/storage/unusual_datafab.h          |   20 +-
 drivers/usb/storage/unusual_devs.h             |  580 +++---
 drivers/usb/storage/unusual_freecom.h          |    2 +-
 drivers/usb/storage/unusual_isd200.h           |   12 +-
 drivers/usb/storage/unusual_jumpshot.h         |    2 +-
 drivers/usb/storage/unusual_karma.h            |    2 +-
 drivers/usb/storage/unusual_onetouch.h         |    4 +-
 drivers/usb/storage/unusual_sddr09.h           |   12 +-
 drivers/usb/storage/unusual_sddr55.h           |    8 +-
 drivers/usb/storage/unusual_usbat.h            |    8 +-
 drivers/usb/storage/usb.c                      |   30 +-
 drivers/usb/wusbcore/Makefile                  |   19 +-
 drivers/uwb/address.c                          |    5 +-
 drivers/uwb/wlp/wss-lc.c                       |    7 +-
 include/linux/fsl_devices.h                    |   18 +
 include/linux/init.h                           |   13 +-
 include/linux/usb/cdc.h                        |   79 +-
 include/linux/usb/ch9.h                        |   68 +-
 include/linux/usb/composite.h                  |   40 +-
 include/linux/usb/gadget.h                     |   20 +-
 include/linux/usb/hcd.h                        |    2 +
 include/linux/usb/intel_mid_otg.h              |  180 ++
 include/linux/usb/langwell_otg.h               |  139 ++
 include/linux/usb/ncm.h                        |  114 --
 include/linux/usb/otg.h                        |   11 +
 include/linux/usb/storage.h                    |   48 +
 include/linux/usb_usual.h                      |   43 +-
 include/scsi/scsi.h                            |    2 +
 include/scsi/scsi_device.h                     |    2 +
 179 files changed, 9945 insertions(+), 2874 deletions(-)
 create mode 100644 drivers/usb/host/fsl-mph-dr-of.c
 create mode 100644 drivers/usb/misc/yurex.c
 create mode 100644 drivers/usb/musb/am35x.c
 create mode 100644 drivers/usb/musb/da8xx.c
 create mode 100644 drivers/usb/otg/langwell_otg.c
 create mode 100644 drivers/usb/serial/sam-ba.c
 create mode 100644 drivers/usb/storage/uas.c
 create mode 100644 include/linux/usb/intel_mid_otg.h
 create mode 100644 include/linux/usb/langwell_otg.h
 delete mode 100644 include/linux/usb/ncm.h
 create mode 100644 include/linux/usb/storage.h

---------------

Ajay Kumar Gupta (3):
      USB: AM35x: Add musb support
      USB: musb: add musb support for AM35x
      USB: musb: AM35x: Workaround for fifo read issue

Alan Stern (5):
      USB: g_file_storage: don't generate automatic serial string
      OHCI: work around for nVidia shutdown problem
      USB: teach "devices" file about Wireless and SuperSpeed USB
      USB: disable endpoints after unbinding interfaces, not before
      USB: accept some invalid ep0-maxpacket values

Alon Ziv (3):
      USB: opticon: Fix long-standing bugs in opticon driver
      USB: opticon: Add Opticon OPN2001 write support
      USB: opticon: Whitespace fixes in opticon driver

Anatolij Gustschin (2):
      USB: add platform glue driver for FSL USB DR controller
      USB: add USB EHCI support for MPC5121 SoC

Anders Larsen (1):
      USB: cp210x: Add WAGO 750-923 Service Cable device ID

Andiry Xu (7):
      USB: xHCI: Add pointer to udev in struct xhci_virt_device
      USB: xHCI: change xhci_reset_device() to allocate new device
      USB: core: use kernel assigned address for devices under xHCI
      USB: xHCI: port power management implementation
      USB: xHCI: port remote wakeup implementation
      USB: xHCI: bus power management implementation
      USB: xHCI: PCI power management implementation

Andy Shevchenko (1):
      uwb: use '%pM' format to print MAC address

Anil Shetty (1):
      usb: musb: musbhsdma: increase max_len to 1MB

Axel Lin (4):
      USB: isp116x-hcd - use resource_size instead of defining its own resource_len macro
      USB: isp1362-hcd - use resource_size instead of defining its own resource_len macro
      USB: ohci-sh - use resource_size instead of defining its own resource_len macro
      USB: imx21-hcd - fix off by one resource size calculation

Bob Liu (1):
      usb: musb: Change to direct addr in context save/restore

Christophe Lebouc (1):
      usb: langwell_udc: fix big file transfer issue.

DJ Delorie (1):
      USB: cp210x: Add Renesas RX-Stick device ID

Dan Carpenter (3):
      USB: gadget: dbgp: cleanup: remove unneeded check
      USB: ohci-sm501: add iounmap on error path
      usb: gadget: goku_udc: Fix error path

Daniel Suchy (1):
      USB: ftdi_sio: new VID/PIDs for various Papouch devices

Enrico Mioso (1):
      USB: option: Add new ONDA vendor id and product id for ONDA MT825UP

Eric Bénard (1):
      mxc_udc: add workaround for ENGcm09152 for i.MX35

Felipe Balbi (1):
      usb: musb: gadget: only enable AUTOCLEAR in double buffered case

Felipe Contreras (1):
      usb: gadget: fix Kconfig warning

Grazvydas Ignotas (1):
      USB: Add more empty functions in otg.h

Greg Kroah-Hartman (2):
      USB: yurex: assign a real minor number to the driver
      USB: ftdi_sio: add device ids for ScienceScope

Hans de Goede (4):
      scsi/sr: add no_read_disc_info scsi_device flag
      usb-storage: add new no_read_disc_info quirk
      scsi/sd: add a no_read_capacity_16 scsi_device flag
      usb-storage: add new no_read_capacity_16 quirk

Hao Wu (3):
      usb: Add Intel Langwell USB OTG Transceiver Driver
      USB OTG: Add common data structure for Intel MID Platform (Langwell/Penwell)
      USB OTG Langwell: Update OTG Kconfig and driver version.

Heikki Krogerus (1):
      usb: musb: ignore spurious SESSREQ interrupts

Igor Grinberg (2):
      USB: otg/ulpi: improve ulpi phy detection.
      USB: otg/ulpi: extend id's table.

Javier Martinez Canillas (2):
      USB: r8a66597-udc: Initialize uninitialized variable, fix compile warning
      USB: isp1362-hcd: Removes CONFIG_USB_OTG dependent code, fix build breakage

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled

JiebingLi (5):
      USB: langwell: USB Client driver code cleanup
      USB: langwell: USB Client Endpoint initialization
      USB: langwell: USB Client PHY low power mode setting
      USB: langwell: USB Client Remote Wakeup Support
      USB: langwell: USB Client driver memory handling

Joe Perches (3):
      USB: langwell: Remove unnecessary return's from void functions
      USB: gadget: Remove pr_<level> uses of KERN_<level>
      usb: host: oxu210hp-hcd: Use static const char * const where possible

Johan Hovold (5):
      USB: sam-ba: add driver for Atmel SAM Boot Assistant (SAM-BA)
      USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"
      USB: visor: fix initialisation of UX50/TH55 devices
      USB: ftdi_sio: set device latency timeout at port probe
      USB: mct_u232: fix broken close

Jon Povey (1):
      USB: musb: suppress warning about unused flags

Julia Lawall (1):
      USB: gadget: amd5536udc.c: Remove double test

Kees Cook (1):
      usb: iowarrior: don't trust report_size for buffer size

Keshava Munegowda (1):
      usb: omap: ohci: Missing driver unregister in module exit

Martin Fuzzey (7):
      USB: usbtest fix coding style
      USB: usbtest - ensure correct isoc data length
      USB: imx21-hcd: remove unused variable
      USB: imx21-hcd: refactor hardware data memory management
      USB: imx21-hcd: Fix isochronous endpoint idle
      USB: introduce unmap_urb_setup_for_dma()
      USB: imx21-hcd accept arbitary transfer buffer alignement.

Matthew Garrett (1):
      USB: serial: Enable USB autosuspend by default on qcserial

Matthew Wilcox (2):
      USB: Move USB Storage definitions to their own header file
      USB: Add UAS driver

Matthias G. Eckermann (1):
      USB: qcserial: Enable Diagnostics Monitor and GPS ports on Gobi 2000

Matthieu CASTET (1):
      USB: ehci tdi : let's tdi_reset set host mode

Maulik Mankad (1):
      usb: musb: host: unmap the buffer for PIO data transfers

Mauro Carvalho Chehab (1):
      USB: option: Add more ZTE modem USB id's

Michael Prokop (1):
      USB: Kconfig: fix typos in USB_FUNCTIONFS* description

Michal Nazarewicz (14):
      USB: gadget: g_multi: fixed vendor and product ID
      USB: gadget: g_ffs: fixed vendor and product ID
      usb: gadget: storage: remove nofua file when unbinding
      usb: gadget: mass_storage: optional SCSI WRITE FUA bit
      USB: gadget: functionfs: code cleanup
      USB: gadget: composite: Better string override handling
      USB: gadget: mass_storage: moved strings handling code to composite
      USB: gadget: g_multi: moved strings handling code to composite
      USB: Revert "USB: gadget: section mismatch warning fixed"
      usb gadget: don't save bind callback in struct usb_composite_driver
      init.h: add some more documentation to __ref* tags
      USB: storage: Use USB_ prefix instead of US_ prefix
      USB: gadget: file_storage: reuse definitions from a header file
      USB: gadget: storage: reuse definitions from scsi.h header file

Mihai Donțu (1):
      USB: gadget: rndis: fix up coding style issues in the file

Ming Lei (3):
      usb: musb: support ISO high bandwidth for gadget mode
      usb: musb: gadget: fix ZLP sending in musb_g_tx(v1)
      USB: UHCI: add native scatter-gather support(v1)

Nobuhiro Iwamatsu (1):
      usb: r8a66597-hcd: Change mistake of the outsw function

Otavio Salvador (1):
      USB: cdc-acm: fix code indentation

Parirajan Muthalagu (1):
      USB Gadget: Verify VBUS current before setting the device self-powered bit

Peter Chen (1):
      USB: do not print -ESHUTDOWN message if usb at otg device mode

Philippe Skowronski (1):
      usb: langwell_udc: cancel pending requests when controller is suspended.

Praveena Nadahally (1):
      USB: Change acm_iad_descriptor bFunctionProtocol to USB_CDC_ACM_PROTO_AT_V25TER

Rahul Ruikar (3):
      usb: core: endpoint: Fix error path
      usb: gadget: dummy_hcd: Fix error path
      USB: gadget: amd5536udc.c: fix error path

Rainer Keller (1):
      USB: add PID for FTDI based OpenDCC hardware

Rich Mattes (1):
      USB: ftdi_sio: Add PID for accesio products

Roger Quadros (1):
      usb gadget: composite: prevent OOPS for non-standard control request

Sarah Sharp (3):
      usb: Fix issue with USB 3.0 devices after system resume
      USB: xhci: Fix compile error when CONFIG_PM=n
      usb: Fix linker errors with CONFIG_PM=n

Sergei Shtylyov (6):
      USB: musb: make DBG() calls actually depend on CONFIG_USB_MUSB_DEBUG
      usb: musb: introduce DA8xx/OMAP-L1x glue layer
      usb: musb: gadget: kill unreachable code in musb_g_rx()
      USB: MUSB: fix kernel WARNING/oops when unloading module in OTG mode
      usb: musb: blackfin: call usb_nop_xceiv_unregister() in musb_platform_exit()
      usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()

Simon Arlott (1):
      USB: output an error message when the pipe type doesn't match the endpoint type

T. S., Anil Kumar (1):
      usb: musb: host: support DMA transfers greater than max channel length

Tatyana Brokhman (1):
      usb: usb3.0 ch9 definitions

Thomas Gleixner (1):
      usb: ftdi-elan: Convert "mutex" to semaphore

Tomoki Sekiyama (2):
      USB: add driver for Meywa-Denki & Kayac YUREX
      USB: yurex: fix memory leak and corrupted messages

Uwe Kleine-König (2):
      usb gadget: don't save bind callback in struct usb_gadget_driver
      usb gadget: don't save bind callback in struct usb_configuration

Wolfram Sang (1):
      USB: core: update comment to match current function name

Yauheni Kaliuta (4):
      USB: cdc.h: ncm: typo and style fixes
      Revert "USB: ncm: added ncm.h with auxiliary definitions"
      USB: cdc.h: ncm: add missed constants and structures
      USB: cdc.h: ncm: fix one more typo

Yusuke Goda (1):
      usb: r8a66597-udc: Add processing when USB was removed.

matt mooney (2):
      usb: change to new flag variable
      usb: makefile cleanup

