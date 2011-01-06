Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1AFXuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:50:35 -0500
Received: from kroah.org ([198.145.64.141]:43876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab1AFXu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:50:26 -0500
Date: Thu, 6 Jan 2011 15:50:16 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB merge for .38
Message-ID: <20110106235016.GA2212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big USB merge for your .38 tree.

Nothing radical here at all, lots of musb changes, which touched a bunch
of arch-specific code, and some new drivers, mostly gadget ones.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-next

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/usb/power-management.txt       |  113 +-
 arch/arm/mach-davinci/usb.c                  |    6 +-
 arch/arm/mach-omap2/Kconfig                  |    1 +
 arch/arm/mach-omap2/Makefile                 |    6 +-
 arch/arm/mach-omap2/board-4430sdp.c          |   35 +-
 arch/arm/mach-omap2/board-n8x0.c             |    5 +-
 arch/arm/mach-omap2/board-omap4panda.c       |   14 +-
 arch/arm/mach-omap2/clock2420_data.c         |    2 +-
 arch/arm/mach-omap2/clock2430_data.c         |    2 +-
 arch/arm/mach-omap2/clock3xxx_data.c         |   13 +-
 arch/arm/mach-omap2/clock44xx_data.c         |    7 +-
 arch/arm/mach-omap2/omap_phy_internal.c      |  149 ++
 arch/arm/mach-omap2/usb-ehci.c               |  144 ++-
 arch/arm/mach-omap2/usb-musb.c               |  104 +-
 arch/arm/mach-omap2/usb-tusb6010.c           |    2 +-
 arch/arm/plat-omap/include/plat/omap44xx.h   |    5 +
 arch/arm/plat-omap/include/plat/usb.h        |   10 +
 arch/blackfin/mach-bf527/boards/ad7160eval.c |    2 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |    4 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c      |    4 +-
 arch/blackfin/mach-bf527/boards/ezkit.c      |    4 +-
 arch/blackfin/mach-bf527/boards/tll6527m.c   |    2 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c   |    4 +-
 arch/blackfin/mach-bf548/boards/ezkit.c      |    4 +-
 arch/sh/Kconfig                              |    5 +
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c       |   35 +-
 drivers/hid/hid-core.c                       |    1 +
 drivers/hid/hid-ids.h                        |    2 +
 drivers/media/video/tlg2300/pd-main.c        |    3 +-
 drivers/mfd/twl-core.c                       |   44 +-
 drivers/mfd/twl6030-irq.c                    |    9 +-
 drivers/net/wimax/i2400m/usb.c               |    2 +-
 drivers/staging/bcm/InterfaceInit.c          |    2 +-
 drivers/usb/Kconfig                          |    9 +-
 drivers/usb/core/driver.c                    |  150 +--
 drivers/usb/core/hcd-pci.c                   |    1 -
 drivers/usb/core/hcd.c                       |    1 -
 drivers/usb/core/hub.c                       |   11 +-
 drivers/usb/core/message.c                   |    1 +
 drivers/usb/core/quirks.c                    |   15 -
 drivers/usb/core/sysfs.c                     |   84 +-
 drivers/usb/core/usb.c                       |    3 +-
 drivers/usb/core/usb.h                       |    2 -
 drivers/usb/gadget/Kconfig                   |   77 +-
 drivers/usb/gadget/Makefile                  |    8 +-
 drivers/usb/gadget/amd5536udc.c              |    1 -
 drivers/usb/gadget/atmel_usba_udc.c          |    4 +-
 drivers/usb/gadget/ci13xxx_msm.c             |  134 ++
 drivers/usb/gadget/ci13xxx_pci.c             |  176 ++
 drivers/usb/gadget/ci13xxx_udc.c             |  421 ++--
 drivers/usb/gadget/ci13xxx_udc.h             |   20 +
 drivers/usb/gadget/composite.c               |   10 +-
 drivers/usb/gadget/dummy_hcd.c               |  251 ++-
 drivers/usb/gadget/f_fs.c                    |  437 ++--
 drivers/usb/gadget/f_mass_storage.c          |  524 +++---
 drivers/usb/gadget/f_ncm.c                   | 1407 ++++++++++++
 drivers/usb/gadget/file_storage.c            |   29 +-
 drivers/usb/gadget/g_ffs.c                   |   41 +-
 drivers/usb/gadget/gadget_chips.h            |   25 +-
 drivers/usb/gadget/imx_udc.c                 |    8 +-
 drivers/usb/gadget/imx_udc.h                 |    3 -
 drivers/usb/gadget/langwell_udc.c            |   23 +
 drivers/usb/gadget/mass_storage.c            |    2 +-
 drivers/usb/gadget/mv_udc.h                  |  294 +++
 drivers/usb/gadget/mv_udc_core.c             | 2149 +++++++++++++++++++
 drivers/usb/gadget/mv_udc_phy.c              |  214 ++
 drivers/usb/gadget/ncm.c                     |  248 +++
 drivers/usb/gadget/pch_udc.c                 | 2947 ++++++++++++++++++++++++++
 drivers/usb/gadget/u_audio.c                 |   10 +-
 drivers/usb/gadget/u_ether.c                 |   14 +-
 drivers/usb/gadget/u_ether.h                 |    5 +
 drivers/usb/host/Kconfig                     |   19 +
 drivers/usb/host/ehci-atmel.c                |    3 +
 drivers/usb/host/ehci-dbg.c                  |    2 +-
 drivers/usb/host/ehci-hcd.c                  |   30 +-
 drivers/usb/host/ehci-msm.c                  |  345 +++
 drivers/usb/host/ehci-mxc.c                  |   29 +-
 drivers/usb/host/ehci-omap.c                 |  320 +++-
 drivers/usb/host/ehci-pci.c                  |   39 +
 drivers/usb/host/ehci-sched.c                |   79 +
 drivers/usb/host/ehci-sh.c                   |  243 +++
 drivers/usb/host/ehci-spear.c                |  212 ++
 drivers/usb/host/ehci-vt8500.c               |  172 ++
 drivers/usb/host/ehci-w90x900.c              |    3 +
 drivers/usb/host/ehci-xilinx-of.c            |    1 +
 drivers/usb/host/ehci.h                      |    1 +
 drivers/usb/host/ohci-hcd.c                  |    5 +
 drivers/usb/host/ohci-omap3.c                |    2 +-
 drivers/usb/host/ohci-sh.c                   |    2 +-
 drivers/usb/host/ohci-spear.c                |  240 +++
 drivers/usb/host/uhci-hcd.c                  |    2 +-
 drivers/usb/host/uhci-q.c                    |   12 +-
 drivers/usb/host/whci/hcd.c                  |    2 +-
 drivers/usb/misc/usbled.c                    |  118 +-
 drivers/usb/mon/mon_bin.c                    |   34 +-
 drivers/usb/musb/Kconfig                     |   77 +-
 drivers/usb/musb/Makefile                    |   21 +-
 drivers/usb/musb/am35x.c                     |  410 +++--
 drivers/usb/musb/blackfin.c                  |  181 ++-
 drivers/usb/musb/cppi_dma.c                  |    2 +-
 drivers/usb/musb/da8xx.c                     |  170 ++-
 drivers/usb/musb/davinci.c                   |  174 ++-
 drivers/usb/musb/musb_core.c                 |  193 +--
 drivers/usb/musb/musb_core.h                 |  190 +-
 drivers/usb/musb/musb_gadget.c               |   13 +-
 drivers/usb/musb/musb_io.h                   |    4 +-
 drivers/usb/musb/musb_regs.h                 |    4 +-
 drivers/usb/musb/musb_virthub.c              |    2 +-
 drivers/usb/musb/musbhsdma.c                 |    2 +-
 drivers/usb/musb/omap2430.c                  |  378 +++-
 drivers/usb/musb/tusb6010.c                  |  181 ++-
 drivers/usb/musb/ux500.c                     |  216 ++
 drivers/usb/otg/Kconfig                      |   32 +
 drivers/usb/otg/Makefile                     |    3 +
 drivers/usb/otg/ab8500-usb.c                 |  585 +++++
 drivers/usb/otg/msm72k_otg.c                 | 1125 ++++++++++
 drivers/usb/otg/twl4030-usb.c                |    3 +-
 drivers/usb/otg/twl6030-usb.c                |  493 +++++
 drivers/usb/serial/ftdi_sio.c                |   27 +
 drivers/usb/serial/option.c                  |    1 +
 drivers/usb/serial/ssu100.c                  |   56 +-
 drivers/usb/serial/usb-wwan.h                |    2 +
 drivers/usb/serial/usb_wwan.c                |   79 +
 drivers/usb/storage/uas.c                    |   82 +-
 drivers/uwb/i1480/i1480-est.c                |    2 +-
 drivers/uwb/umc-dev.c                        |    7 +-
 drivers/uwb/whc-rc.c                         |    2 +-
 include/linux/i2c/twl.h                      |    7 +
 include/linux/usb.h                          |    7 +-
 include/linux/usb/ch11.h                     |   47 +
 include/linux/usb/ch9.h                      |   10 +
 include/linux/usb/hcd.h                      |    4 +
 include/linux/usb/msm_hsusb.h                |  112 +
 include/linux/usb/msm_hsusb_hw.h             |   59 +
 include/linux/usb/musb.h                     |    8 +-
 include/linux/usb/otg.h                      |    2 +-
 136 files changed, 15391 insertions(+), 2001 deletions(-)
 create mode 100644 arch/arm/mach-omap2/omap_phy_internal.c
 create mode 100644 drivers/usb/gadget/ci13xxx_msm.c
 create mode 100644 drivers/usb/gadget/ci13xxx_pci.c
 create mode 100644 drivers/usb/gadget/f_ncm.c
 create mode 100644 drivers/usb/gadget/mv_udc.h
 create mode 100644 drivers/usb/gadget/mv_udc_core.c
 create mode 100644 drivers/usb/gadget/mv_udc_phy.c
 create mode 100644 drivers/usb/gadget/ncm.c
 create mode 100644 drivers/usb/gadget/pch_udc.c
 create mode 100644 drivers/usb/host/ehci-msm.c
 create mode 100644 drivers/usb/host/ehci-sh.c
 create mode 100644 drivers/usb/host/ehci-spear.c
 create mode 100644 drivers/usb/host/ehci-vt8500.c
 create mode 100644 drivers/usb/host/ohci-spear.c
 create mode 100644 drivers/usb/musb/ux500.c
 create mode 100644 drivers/usb/otg/ab8500-usb.c
 create mode 100644 drivers/usb/otg/msm72k_otg.c
 create mode 100644 drivers/usb/otg/twl6030-usb.c
 create mode 100644 include/linux/usb/msm_hsusb.h
 create mode 100644 include/linux/usb/msm_hsusb_hw.h

---------------

Ajay Kumar Gupta (1):
      musb: am35x: fix compile error due to control apis

Alan Stern (4):
      USB: use sysfs_merge_group for power attributes
      USB: use the runtime-PM autosuspend implementation
      USB: improve uses of usb_mark_last_busy
      USB: fix leftover references to udev->autosuspend_delay

Alex He (1):
      USB: EHCI: ASPM quirk of ISOC on AMD SB800

Alexey Charkov (1):
      usb: Add support for VIA VT8500 and compatibles in EHCI HCD

Anand Gadiyar (9):
      omap: clock: add clkdev aliases for EHCI clocks
      usb: ehci-omap: use clkdev aliases for functional clocks
      usb: ehci-omap: add helpers for checking port mode
      omap: usb: ehci: introduce HSIC mode
      usb: ehci-omap: Add OMAP4 support
      arm: omap4: add USBHOST and related base addresses
      arm: omap4: usb: add platform init code for EHCI
      arm: omap4: select USB_ARCH_HAS_EHCI
      usb: ehci-omap: fix tll channel enable mask

Artem Leonenko (4):
      USB: gadgets: ci13xxx: fix probing of compiled-in gadget drivers
      USB: gadget: update ci13xxx to work with g_ether
      USB: gadget: ci13xxx: fix complete() callback for no_interrupt rq's
      USB: gadget: ci13xxx: don't assume that PAGE_SIZE is 4096

Bill Pemberton (1):
      USB: ssu100: remove max_packet_size calculation

Dan Williams (1):
      usb-wwan: implement TIOCGSERIAL and TIOCSSERIAL to avoid blocking close(2)

Deepak Sikri (1):
      USB host: Adding USB ehci & ohci support for spear platform

Dirk Brandewie (1):
      USB: ce4100: Add support for CE4100 EHCI IP block to EHCI driver

Fabio Estevam (1):
      USB: ehci-mxc: Setup portsc register prior to accessing OTG viewport

Felipe Balbi (32):
      usb: musb: gadget: prevent a NULL pointer dereference
      usb: musb: introduce struct musb_platform_ops
      usb: musb: make all glue layer export struct musb_platform_ops
      arm: omap4: panda: initialize musb
      usb: musb: hold context on musb structure
      usb: musb: add Kconfig options for each glue layer
      usb: musb: trivial search and replace patch
      usb: musb: split omap2430 to its own platform_driver
      usb: musb: split am35x to its own platform_driver
      usb: musb: split tusb6010 to its own platform_driver
      usb: musb: split davinci to its own platform_driver
      usb: musb: split da8xx to its own platform_driver
      usb: musb: split blackfin to its own platform_driver
      usb: musb: omap2430: give it a context structure
      usb: musb: am35x: give it a context structure
      usb: musb: tusb6010: give it a context structure
      usb: musb: davinci: give it a context structure
      usb: musb: da8xx: give it a context structure
      usb: musb: blackfin: give it a context structure
      usb: musb: pass platform_ops via platform_data
      usb: musb: mark ->set_clock deprecated
      usb: musb: move clock handling to glue layer
      usb: musb: drop the set_clock magic
      usb: musb: drop musb_platform_save/restore_context
      usb: musb: mark musb_save/restore_context static
      usb: musb: omap2430: drop the nops
      usb: musb: omap2430: use dev_pm_ops structure
      usb: musb: am35x: usb dev_pm_ops structure
      usb: musb: blackfin: usb dev_pm_ops structure
      usb: musb: drop musb_platform_suspend/resume
      usb: musb: drop board_set_vbus
      arm: omap4: enable usb on 4430sdp

Greg Kroah-Hartman (3):
      Revert "USB: musb: blackfin: pm: make it work"
      Revert "USB: musb: pm: don't rely fully on clock support"
      USB: serial: ftdi_sio: add support for TIOCSERGETLSR

Guennadi Liakhovetski (1):
      USB: otg: fix link breakage, when the NOP USB Xceiver is a module

Hao Wu (1):
      usb: composite gadget: set vbus_draw current limitation during suspend

Hema HK (8):
      mfd: TWL6030: USBOTG VBUS event generation on
      usb: otg: Adding twl6030-usb transceiver driver for OMAP4430
      usb: otg: Kconfig: Add Kconfig option for TWL6030 transceiver.
      usb: musb: TWL6030: Selecting TWL6030_USB transceiver
      mfd: TWL6030: OMAP4: Registering the TWL6030-usb device
      usb: otg: TWL6030: Add twl6030_usb file for compilation
      usb: musb: Adding musb support for OMAP4430
      arm: OMAP4430: musb: Configure musb to OTG mode

Hema Kalliguddi (2):
      usb: musb: remove board_data parameter from musb_platform_init()
      usb: musb: add names for IRQs in structure resource

Jarkko Nikula (1):
      usb: otg: twl4030-usb: Fix unbalanced regulator disables at module removal

Jesper Juhl (1):
      USB: Remove unnecessary casts of void ptr returning alloc function return values

Joe Perches (3):
      drivers/usb/host/uhci-hcd.c: Remove unnecessary casts of pci_get_drvdata
      drivers/usb/gadget: Remove unnecessary semicolons
      drivers/uwb: Use printf extension %pR for struct resource

Julia Lawall (1):
      USB: gadget: amd5536udc.c: delete double assignment

Keshava Munegowda (5):
      usb: ehci-omap: update clock names to be more generic
      usb: ehci-omap: don't hard-code TLL channel count
      usb: ehci: introduce CONFIG_USB_EHCI_HCD_OMAP
      omap4: 4430sdp: enable the ehci port on 4430SDP
      usb: ohci-omap3: fix trivial typo

Luo Andy (1):
      usb: gadget: langwell_udc: add usb test mode support

Marek Belisko (1):
      USB: gadget: composite: Typo fix.

Matthew Wilcox (5):
      USB: uas: Fix up the Sense IU
      USB: uas: Use kzalloc instead of kmalloc
      USB: uas: Rename sense pipe and sense urb to status pipe and status urb
      USB: uas: Ensure we only bind to a UAS interface
      USB: uas: Use GFP_NOIO instead of GFP_KERNEL in I/O submission path

Melchior FRANZ (1):
      USB: add support for Dream Cheeky DL100B Webmail Notifier (1d34:0004)

Mian Yousaf Kaukab (2):
      usb: musb: add support for ux500 platform
      usb: add ab8500 usb transceiver driver

Michal Nazarewicz (8):
      USB: gadget: file_storage: put_device() in error recovery
      USB: gadget: f_mass_storage: use ?: instead of a macro
      USB: gadget: f_mass_storage: drop START_TRANSFER() macro
      USB: gadget: f_mass_storage: remove needless complete()
      USB: gadget: f_mass_storage: code style clean ups
      usb: gadget: FunctionFS: fix typos and coding style
      usb: gadget: f_fs: remove custom printk() wrappers
      usb: gadget: g_fs: Fix compilation warning

Ming Lei (2):
      USB: use the no_callbacks flag for interfaces
      USB: make usb_mark_last_busy use pm_runtime_mark_last_busy

Namhyung Kim (3):
      uwb: fix compiler warning on whcrc_id_table
      uwb: fix compiler warning on i1480_est_id_table
      USB: whci-hcd: fix compiler warning

Paul Mundt (7):
      usb: ohci-sh: Set IRQ as shared.
      usb: ehci-hcd: Add support for SuperH EHCI.
      sh: Add EHCI support for SH7786.
      usb: ehci-sh: Fix up fault in shutdown path.
      usb: ehci-sh: Add missing ehci helpers.
      usb: Add in missing EHCI helpers.
      sh: Convert to USB_ARCH_HAS_OHCI/EHCI selects.

Pavankumar Kondeti (11):
      USB: Add MSM OTG Controller driver
      USB: EHCI: Add MSM Host Controller driver
      USB: EHCI: msm: Add support for power management
      USB: OTG: msm: Add support for power management
      USB: gadget: Separate out PCI bus code from ci13xxx_udc
      USB: gadget: Fix "scheduling while atomic" bugs in ci13xxx_udc
      USB: gadget: Initialize ci13xxx gadget device's coherent DMA mask
      USB: gadget: Introduce ci13xxx_udc_driver struct
      USB: gadget: Add USB controller driver for MSM SoC
      USB: gadget: Implement runtime PM for ci13xxx gadget
      USB: gadget: Implement runtime PM for MSM bus glue driver

Pete Zaitcev (1):
      usbmon: correct length for isochronous

Peter Huewe (1):
      USB: serial: usb_wwan: Add missing uaccess.h / fix build failure

Rahul Ruikar (1):
      USB: gadget: f_mass_storage: put_device() in error recovery

Richard Röjfors (3):
      usb: g_audio: Fix crash at driver removal
      usb: pch_udc: Fix compile error, warnings and checkpatch warnings
      usb: pch_udc: Fix setup transfers with data out

Rob Emanuele (1):
      USB: atmel_usba_udc: fix freeing irq in usba_udc_remove()

Sergei Shtylyov (2):
      DA8xx: assign name to MUSB IRQ resource
      usb: musb: core: kill unneeded #include's

Tatyana Brokhman (2):
      usb: USB3.0 ch11 definitions
      usb: dummy_hcd code simplification

Tobias Klauser (1):
      usb: gadget: f_fs: Remove redundant unlikely()

Tobias Ollmann (1):
      USB: host: uhci-q: Fixed minor coding style issues

Toshiharu Okada (1):
      USB device driver of Topcliff PCH

Uwe Kleine-König (2):
      usb: gadget/imx-udc: remove usage of deprecated symbol USBD_INT0
      usb: gadget/imx-udc: fix interrupt name again

Yauheni Kaliuta (3):
      usb: gadget: u_ether: prepare for NCM
      usb: gadget: f_ncm.c added
      usb: gadget: g_ncm added

cxie4 (1):
      USB: pxa: Add USB client support for Marvell PXA9xx/PXA168 chips

