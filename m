Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab1EWTEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:04:37 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46983 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573Ab1EWTEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:04:35 -0400
X-Sasl-enc: Baec5FOCIfZjNV/puMvyt/VxT6pr6Qsfsjp/NXgmOZv+ 1306177474
Date: Mon, 23 May 2011 11:55:23 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for .40
Message-ID: <20110523185523.GA16854@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big USB pull request for the .40 merge window.

Lots of little things, mostly all host controller driver work (xhci and
lots of platform specific ones) Other than that, nothing really major at
all.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/ usb-next

All of these patches have been in the -next and -mm releases for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt                |    4 +
 Documentation/usb/callbacks.txt                    |    8 +-
 Documentation/usb/linux-cdc-acm.inf                |    4 +-
 Documentation/usb/linux.inf                        |    6 +-
 MAINTAINERS                                        |    3 +-
 arch/arm/mach-exynos4/Kconfig                      |    1 +
 arch/arm/mach-exynos4/Makefile                     |    2 +
 arch/arm/mach-exynos4/cpu.c                        |    7 +-
 arch/arm/mach-exynos4/include/mach/map.h           |    4 +
 arch/arm/mach-exynos4/include/mach/regs-pmu.h      |    3 +
 arch/arm/mach-exynos4/include/mach/regs-usb-phy.h  |   64 +
 arch/arm/mach-exynos4/mach-nuri.c                  |   16 +
 arch/arm/mach-exynos4/usb-phy.c                    |  136 ++
 arch/arm/mach-s3c2410/include/mach/map.h           |    4 +
 .../mach-s3c2410/include/mach/regs-s3c2443-clock.h |   25 +
 arch/arm/mach-s3c2416/mach-smdk2416.c              |   27 +
 arch/arm/plat-s3c24xx/devs.c                       |   41 +
 arch/arm/plat-s3c24xx/include/plat/udc.h           |   17 +
 arch/arm/plat-s5p/Kconfig                          |    5 +
 arch/arm/plat-s5p/Makefile                         |    1 +
 arch/arm/plat-s5p/dev-ehci.c                       |   57 +
 arch/arm/plat-s5p/include/plat/ehci.h              |   21 +
 arch/arm/plat-s5p/include/plat/map-s5p.h           |    2 +-
 arch/arm/plat-s5p/include/plat/usb-phy.h           |   22 +
 arch/arm/plat-samsung/include/plat/devs.h          |    3 +
 arch/mips/ath79/Kconfig                            |    5 +
 arch/sparc/include/asm/io.h                        |   13 +
 drivers/Makefile                                   |    5 +-
 drivers/hid/hid-core.c                             |   20 +-
 drivers/hid/hid-ids.h                              |   21 +-
 drivers/usb/Kconfig                                |    4 +
 drivers/usb/Makefile                               |    6 +
 drivers/usb/class/cdc-acm.c                        |  479 +++----
 drivers/usb/class/cdc-acm.h                        |   24 +-
 drivers/usb/class/cdc-wdm.c                        |   14 +
 drivers/usb/core/config.c                          |    2 +-
 drivers/usb/core/devices.c                         |   22 +-
 drivers/usb/core/file.c                            |    8 -
 drivers/usb/core/hcd.c                             |    6 +-
 drivers/usb/core/hub.c                             |  131 ++-
 drivers/usb/core/sysfs.c                           |   13 +-
 drivers/usb/core/usb.c                             |    3 +-
 drivers/usb/core/usb.h                             |    2 +-
 drivers/usb/early/ehci-dbgp.c                      |    5 +-
 drivers/usb/gadget/Kconfig                         |   35 +
 drivers/usb/gadget/Makefile                        |    1 +
 drivers/usb/gadget/at91_udc.c                      |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c                   |   75 +-
 drivers/usb/gadget/composite.c                     |   62 +-
 drivers/usb/gadget/dbgp.c                          |   14 +-
 drivers/usb/gadget/dummy_hcd.c                     |   21 +-
 drivers/usb/gadget/f_audio.c                       |    2 +-
 drivers/usb/gadget/f_mass_storage.c                |   68 +-
 drivers/usb/gadget/f_rndis.c                       |    3 +-
 drivers/usb/gadget/file_storage.c                  |   55 +-
 drivers/usb/gadget/fsl_qe_udc.h                    |    2 +-
 drivers/usb/gadget/fsl_udc_core.c                  |  438 +++++-
 drivers/usb/gadget/fsl_usb2_udc.h                  |    6 +
 drivers/usb/gadget/gadget_chips.h                  |   17 +
 drivers/usb/gadget/printer.c                       |    2 +
 drivers/usb/gadget/s3c-hsotg.c                     |  235 ++--
 drivers/usb/gadget/s3c-hsudc.c                     | 1349 ++++++++++++++++
 drivers/usb/gadget/storage_common.c                |   18 +-
 drivers/usb/host/Kconfig                           |   57 +-
 drivers/usb/host/ehci-ath79.c                      |  202 +++
 drivers/usb/host/ehci-atmel.c                      |    2 +-
 drivers/usb/host/ehci-au1xxx.c                     |   12 +-
 drivers/usb/host/ehci-cns3xxx.c                    |    2 +-
 drivers/usb/host/ehci-dbg.c                        |    2 +-
 drivers/usb/host/ehci-fsl.c                        |  221 +++-
 drivers/usb/host/ehci-fsl.h                        |    4 +
 drivers/usb/host/ehci-grlib.c                      |  242 +++
 drivers/usb/host/ehci-hcd.c                        |   21 +-
 drivers/usb/host/ehci-hub.c                        |   10 +-
 drivers/usb/host/ehci-ixp4xx.c                     |    2 +-
 drivers/usb/host/ehci-msm.c                        |    2 +-
 drivers/usb/host/ehci-mxc.c                        |    2 +-
 drivers/usb/host/ehci-octeon.c                     |    2 +-
 drivers/usb/host/ehci-omap.c                       |    2 +-
 drivers/usb/host/ehci-orion.c                      |    2 +-
 drivers/usb/host/ehci-pci.c                        |    2 +-
 drivers/usb/host/ehci-pmcmsp.c                     |    2 +-
 drivers/usb/host/ehci-ppc-of.c                     |    2 +-
 drivers/usb/host/ehci-ps3.c                        |    2 +-
 drivers/usb/host/ehci-q.c                          |    5 +
 drivers/usb/host/ehci-s5p.c                        |  202 +++
 drivers/usb/host/ehci-sched.c                      |   22 +-
 drivers/usb/host/ehci-sh.c                         |    2 +-
 drivers/usb/host/ehci-spear.c                      |    2 +-
 drivers/usb/host/ehci-tegra.c                      |   74 +-
 drivers/usb/host/ehci-vt8500.c                     |    3 +-
 drivers/usb/host/ehci-w90x900.c                    |    2 +-
 drivers/usb/host/ehci-xilinx-of.c                  |    2 +-
 drivers/usb/host/ehci.h                            |   13 +
 drivers/usb/host/isp116x-hcd.c                     |    1 +
 drivers/usb/host/isp1760-hcd.c                     | 1638 +++++++++-----------
 drivers/usb/host/isp1760-hcd.h                     |   78 +-
 drivers/usb/host/octeon2-common.c                  |   45 +-
 drivers/usb/host/ohci-ath79.c                      |  151 ++
 drivers/usb/host/ohci-hcd.c                        |    9 +-
 drivers/usb/host/ohci-pci.c                        |   12 +-
 drivers/usb/host/ohci-s3c2410.c                    |   58 +-
 drivers/usb/host/oxu210hp-hcd.c                    |    6 +-
 drivers/usb/host/pci-quirks.c                      |  151 +-
 drivers/usb/host/sl811-hcd.c                       |    8 +-
 drivers/usb/host/u132-hcd.c                        |    3 +-
 drivers/usb/host/uhci-debug.c                      |   88 +-
 drivers/usb/host/uhci-grlib.c                      |  208 +++
 drivers/usb/host/uhci-hcd.c                        |  458 +++----
 drivers/usb/host/uhci-hcd.h                        |  248 +++-
 drivers/usb/host/uhci-hub.c                        |   41 +-
 drivers/usb/host/uhci-pci.c                        |  301 ++++
 drivers/usb/host/uhci-q.c                          |  131 +-
 drivers/usb/host/xhci-dbg.c                        |   51 +-
 drivers/usb/host/xhci-hub.c                        |  231 ++--
 drivers/usb/host/xhci-mem.c                        |  144 +-
 drivers/usb/host/xhci-pci.c                        |    1 +
 drivers/usb/host/xhci-ring.c                       |  509 ++++--
 drivers/usb/host/xhci.c                            |  145 ++-
 drivers/usb/host/xhci.h                            |  145 +-
 drivers/usb/misc/ftdi-elan.c                       |    3 +-
 drivers/usb/misc/ldusb.c                           |   52 +-
 drivers/usb/misc/usbtest.c                         |  131 ++-
 drivers/usb/musb/Kconfig                           |   35 +-
 drivers/usb/musb/Makefile                          |    7 +-
 drivers/usb/musb/am35x.c                           |   17 +-
 drivers/usb/musb/blackfin.c                        |   16 +-
 drivers/usb/musb/cppi_dma.c                        |   34 +-
 drivers/usb/musb/da8xx.c                           |   21 +-
 drivers/usb/musb/davinci.c                         |   13 +-
 drivers/usb/musb/musb_core.c                       |  151 +-
 drivers/usb/musb/musb_debug.h                      |   14 -
 drivers/usb/musb/musb_gadget.c                     |  178 ++-
 drivers/usb/musb/musb_gadget_ep0.c                 |   22 +-
 drivers/usb/musb/musb_host.c                       |  157 +-
 drivers/usb/musb/musb_virthub.c                    |   25 +-
 drivers/usb/musb/musbhsdma.c                       |   11 +-
 drivers/usb/musb/omap2430.c                        |   25 +-
 drivers/usb/musb/tusb6010.c                        |   62 +-
 drivers/usb/musb/tusb6010_omap.c                   |   32 +-
 drivers/usb/musb/ux500_dma.c                       |  422 +++++
 drivers/usb/otg/Kconfig                            |    8 +
 drivers/usb/otg/Makefile                           |    2 +
 drivers/usb/otg/fsl_otg.c                          | 1169 ++++++++++++++
 drivers/usb/otg/fsl_otg.h                          |  406 +++++
 drivers/usb/otg/gpio_vbus.c                        |   14 +-
 drivers/usb/otg/isp1301_omap.c                     |   26 +-
 drivers/usb/otg/langwell_otg.c                     |   40 +-
 drivers/usb/otg/msm_otg.c                          |  671 ++++++++-
 drivers/usb/otg/otg.c                              |   35 +
 drivers/usb/otg/otg_fsm.c                          |  349 +++++
 drivers/usb/otg/otg_fsm.h                          |  154 ++
 drivers/usb/otg/twl4030-usb.c                      |    9 +-
 drivers/usb/otg/twl6030-usb.c                      |   17 +-
 drivers/usb/renesas_usbhs/Kconfig                  |   16 +
 drivers/usb/renesas_usbhs/Makefile                 |    9 +
 drivers/usb/renesas_usbhs/common.c                 |  437 ++++++
 drivers/usb/renesas_usbhs/common.h                 |  230 +++
 drivers/usb/renesas_usbhs/mod.c                    |  328 ++++
 drivers/usb/renesas_usbhs/mod.h                    |  137 ++
 drivers/usb/renesas_usbhs/mod_gadget.c             | 1384 +++++++++++++++++
 drivers/usb/renesas_usbhs/pipe.c                   |  874 +++++++++++
 drivers/usb/renesas_usbhs/pipe.h                   |  104 ++
 drivers/usb/serial/Kconfig                         |    9 -
 drivers/usb/serial/Makefile                        |    1 -
 drivers/usb/serial/cp210x.c                        |    6 +-
 drivers/usb/serial/ftdi_sio.c                      |    1 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    5 +
 drivers/usb/serial/garmin_gps.c                    |   20 +-
 drivers/usb/serial/moto_modem.c                    |    1 +
 drivers/usb/serial/opticon.c                       |    7 +-
 drivers/usb/serial/option.c                        |   10 +-
 drivers/usb/serial/sam-ba.c                        |  206 ---
 drivers/usb/storage/unusual_realtek.h              |   10 +-
 drivers/usb/storage/usb.c                          |    9 +-
 include/linux/fsl_devices.h                        |   16 +
 include/linux/usb.h                                |    6 +-
 include/linux/usb/ch9.h                            |    2 +-
 include/linux/usb/composite.h                      |   16 +-
 include/linux/usb/ehci_def.h                       |   15 +-
 include/linux/usb/gadget.h                         |    4 +-
 include/linux/usb/msm_hsusb.h                      |   79 +-
 include/linux/usb/msm_hsusb_hw.h                   |    2 +
 include/linux/usb/otg.h                            |    6 +
 include/linux/usb/renesas_usbhs.h                  |  156 ++
 185 files changed, 14686 insertions(+), 3402 deletions(-)
 create mode 100644 arch/arm/mach-exynos4/include/mach/regs-usb-phy.h
 create mode 100644 arch/arm/mach-exynos4/usb-phy.c
 create mode 100644 arch/arm/plat-s5p/dev-ehci.c
 create mode 100644 arch/arm/plat-s5p/include/plat/ehci.h
 create mode 100644 arch/arm/plat-s5p/include/plat/usb-phy.h
 create mode 100644 drivers/usb/gadget/s3c-hsudc.c
 create mode 100644 drivers/usb/host/ehci-ath79.c
 create mode 100644 drivers/usb/host/ehci-grlib.c
 create mode 100644 drivers/usb/host/ehci-s5p.c
 create mode 100644 drivers/usb/host/ohci-ath79.c
 create mode 100644 drivers/usb/host/uhci-grlib.c
 create mode 100644 drivers/usb/host/uhci-pci.c
 create mode 100644 drivers/usb/musb/ux500_dma.c
 create mode 100644 drivers/usb/otg/fsl_otg.c
 create mode 100644 drivers/usb/otg/fsl_otg.h
 create mode 100644 drivers/usb/otg/otg_fsm.c
 create mode 100644 drivers/usb/otg/otg_fsm.h
 create mode 100644 drivers/usb/renesas_usbhs/Kconfig
 create mode 100644 drivers/usb/renesas_usbhs/Makefile
 create mode 100644 drivers/usb/renesas_usbhs/common.c
 create mode 100644 drivers/usb/renesas_usbhs/common.h
 create mode 100644 drivers/usb/renesas_usbhs/mod.c
 create mode 100644 drivers/usb/renesas_usbhs/mod.h
 create mode 100644 drivers/usb/renesas_usbhs/mod_gadget.c
 create mode 100644 drivers/usb/renesas_usbhs/pipe.c
 create mode 100644 drivers/usb/renesas_usbhs/pipe.h
 delete mode 100644 drivers/usb/serial/sam-ba.c
 create mode 100644 include/linux/usb/renesas_usbhs.h

---------------

Alan Stern (10):
      USB: g_file_storage: don't send padding when stall=n
      USB: UHCI: remove uses of hcd->state
      USB: UHCI: don't try to revive a dead controller
      USB: documentation update for the pre_reset method
      USB: add queued-unlinks test case to usbtest driver
      OHCI: fix regression caused by nVidia shutdown workaround
      EHCI: don't rescan interrupt QHs needlessly
      usb-storage: fix up the unusual_realtek device list
      USB: remove remaining usages of hcd->state from usbcore and fix regression
      USB: UHCI: Use ACCESS_ONCE rather than using a full compiler barrier

Alex He (1):
      xHCI 1.0: Max Exit Latency Too Large Error

Anatolij Gustschin (7):
      usb: factor out state_string() on otg drivers
      USB: ehci-fsl: add MPC5121E specific suspend and resume
      USB: fix build of FSL MPH DR OF platform driver
      USB: fsl_udc_core: prepare for SoCs with BE registers and descriptors
      USB: fsl_udc_core: support device mode of MPC5121E DR USB Controller
      USB: extend ehci-fsl and fsl_udc_core driver for OTG operation
      usb: fix building musb drivers

Andiry Xu (11):
      xHCI: warm reset support
      xHCI: Clear link state change support
      xHCI: Set link state support
      xHCI: report USB3.0 portstatus comply with USB3.0 specification
      usbcore: Refine USB3.0 device suspend and resume
      usbcore: warm reset USB3 port in SS.Inactive state
      xHCI 1.0: Setup Stage TRB Transfer Type flag
      xHCI 1.0: Control endpoint average TRB length field set
      xHCI 1.0: Isoch endpoint CErr field set
      xHCI 1.0: Block Interrupts for Isoch transfer
      xHCI 1.0: TT_THINK_TIME set

Andy Ross (2):
      ehci: pci quirk cleanup
      ehci: workaround for pci quirk timeout on ExoPC

Anji jonnala (3):
      USB: gadget: Initialize ep0 once while registering gadget in ci13xxx_udc
      USB: OTG: msm: vote for dayatona fabric clock
      USB: OTG: msm: Configure PHY Analog and Digital voltage domains

Anton Tikhomirov (6):
      USB: s3c-hsotg: Fix core reset
      USB: s3c-hsotg: Fix interrupt cleaning code
      USB: s3c-hsotg: Fix control request processing
      USB: s3c-hsotg: Fix stall condition processing
      USB: s3c-hsotg: Fix hang up after reset
      USB: s3c-hsotg: Add copyright string

Arvid Brodin (7):
      usb/isp1760: Remove false error printout
      usb/isp1760: Clean up urb enqueueing
      usb/isp1760: Remove unneeded OR map and HcBufferStatus code
      usb/isp1760: Report correct urb status after unlink
      usb/isp1760: Improve urb queueing, get rid of BUG():s in normal code paths
      usb/isp1760: Move function isp1760_endpoint_disable() within file.
      usb/isp1760: Fix possible unlink problems

Ben Hutchings (1):
      xhci-hcd: Include <linux/slab.h> in xhci-pci.c

Benedek László (1):
      USB: serial: ftdi_sio: adding support for TavIR STK500

Craig Shelley (1):
      USB: CP210x Add 4 Device IDs for AC-Services Devices

David Daney (3):
      USB: octeon2-common: Don't reinitialize the clocks.
      usb: octeon2-common.c: Configure ports for proper electrical characteristics.
      usb: Configure octeon2 glue logic for proper uSOF cycle period.

Dmitry Eremin-Solenikov (1):
      USB: gpio-vbus: ask for vbus_draw regulator before registering xceiv

Dmitry Torokhov (1):
      USB: change the way we initialize format strings

Elizabeth Jennifer Myers (1):
      USB: moto_modem: Add USB identifier for the Motorola VE240.

Erik Slagter (1):
      USB: cdc_acm: Fix oops when Droids MuIn LCD is connected

Fabio Estevam (1):
      USB: Mark ehci_adjust_port_wakeup_flags as __maybe_unused

Felipe Balbi (7):
      usb: don't enter usb subdirectories directly
      usb: musb: drop unneeded musb_debug trickery
      usb: musb: allow musb and glue layers to be modules
      usb: musb: export musb_interrupt symbol
      MAINTAINERS: tree moved to kernel.org
      usb: gadget: rndis: don't test against req->length
      usb: musb: fix compile error

Florian Fainelli (1):
      USB: cp210x: fix typo, Telegesys should have been Telegesis

Gabor Juhos (3):
      USB: ehci: add bus glue for the Atheros AR71XX/AR724X/AR91XX SoCs
      USB: ehci: add workaround for Synopsys HC bug
      USB: ohci: add bus glue for the Atheros AR71XX/AR7240 SoCs

Greg Dietsche (1):
      usb: fix warning in usbtest module v2

Greg Kroah-Hartman (1):
      Revert "usb: usb_storage: do not align length of request for CBW to maxp size"

Hema HK (2):
      usb: otg: TWL6030: OMAP4430: Adding SRP VBUS pulsing API
      usb: musb: Calling VBUS pulsing API when SRP is initiated.

Hermann Kneissel (1):
      USB: gamin_gps: Fix for data transfer problems in native mode

Jan Andersson (14):
      USB: EHCI: Support controllers with big endian capability regs
      USB: EHCI: Add bus glue for GRLIB GRUSBHC controller
      USB: UHCI: Remove PCI dependencies from uhci-hub
      USB: UHCI: Allow dynamic assignment of bus specific functions
      USB: UHCI: Codingstyle fixes
      USB: UHCI: Move PCI specific functions to uhci-pci.c
      USB: UHCI: Wrap I/O register accesses
      USB: UHCI: Support non-PCI host controllers
      USB: UHCI: Add support for GRLIB GRUSBHC controller
      USB: UHCI: Add support for big endian mmio
      USB: UHCI: Add support for big endian descriptors
      sparc: add {read,write}*_be routines
      USB: UHCI: Support big endian GRUSBHC HC
      USB: EHCI: Remove SPARC_LEON {read,write}_be definitions from ehci.h

Jean-Christophe PLAGNIOL-VILLARD (1):
      usb/gadget: at91sam9g20 fix end point max packet size

Jim Lin (1):
      USB: ehci: tegra: fix USB1 port reset issue

Jingoo Han (9):
      USB: ohci-s3c2410: use __devinit and __devexit macros for probe and remove
      USB: ohci-s3c2410: use resource_size()
      USB: ohci-s3c2410: fix checkpatch errors and warnings
      USB: ohci-s3c2410: return proper error if clk_get fails
      USB: ehci-s5p : use __devinit and __devexit macros for probe and remove
      USB: s3c-hsudc: use IS_ERR() instead of NULL check
      USB: s3c-hsudc: fix checkpatch error and warning
      USB: s3c-hsotg: fix checkpatch warnings
      USB: s3c-hsotg: return proper error if clk_get fails

Johan Hovold (14):
      USB: cdc-acm: add missing newlines to dev_dbg and dev_err
      USB: cdc-acm: use dev_err to report failed allocations
      USB: cdc-acm: clean up dev_err and dev_dbg
      USB: cdc-acm: replace dbg macros with dev_dbg
      USB: cdc-acm: clean up verbose debug
      USB: cdc-acm: use dev_vdbg in read/write paths
      USB: cdc-acm: remove version information and changelog
      USB: cdc-acm: remove superfluous prototype
      USB: cdc-acm: remove unused drain-delay code
      USB: cdc-acm: clean up rx_buflimit references
      USB: cdc-acm: clean up open error handling
      USB: cdc-acm: clean up read urb allocation
      USB: cdc-acm: re-write read processing
      Revert "USB: sam-ba: add driver for Atmel SAM Boot Assistant (SAM-BA)"

Jonas Andersson (1):
      USB: g_printer required set interface request

Joonyoung Shim (4):
      ARM: S5P: Add usb ehci device
      ARM: EXYNOS4: Add usb host phy control
      USB: Add initial S5P EHCI driver
      ARM: EXYNOS4: Add usb ehci device to the NURI board

Julia Lawall (1):
      drivers/usb/serial/opticon.c: Release resources on kmalloc failure

Karl Relton (1):
      usb-storage: Correct adjust_quirks to include latest flags

Kuninori Morimoto (17):
      usb: renesas_usbhs: Add Renesas USBHS common code
      usb: renesas_usbhs: Add Renesas USBHS Gadget
      usb: renesas_usbhs: fixup cast warning
      usb: renesas_usbhs: Driver is depend on SuperH
      usb: renesas_usbhs: modify fifo clear timing
      usb: renesas_usbhs: don't re-allocation pipe buffer
      usb: renesas_usbhs: modify spinlock method
      usb: renesas_usbhs: return error if wrong recip request
      usb: renesas_usbhs: remove callback when module removed.
      usb: renesas_usbhs: add error reason for usbhs_pipe_malloc
      usb: renesas_usbhs: move pdev_to_priv to global
      usb: renesas_usbhs: add power control function
      usb: renesas_usbhs: prevent NULL pointer crash
      usb: renesas_usbhs: use delayed_work instead of work_struct
      usb: renesas_usbhs: add autonomy mode
      usb: renesas_usbhs: fixup fifo disable
      usb: renesas_usbhs: fixup error processing on probe/remove

Li Yang (1):
      USB: add Freescale USB OTG Transceiver driver

Libor Pechacek (1):
      USB: remove dead code from usb_deregister_dev()

Manuel Lauss (1):
      USB: ehci-au1xxx: fix suspend callback

Marcin Gałczyński (1):
      USB: option: add support for Huawei E353 device

Marius B. Kotsbak (1):
      Bind only modem AT command endpoint to option module.

Mark Brown (2):
      USB: OTG: msm: Allow the widest possible range for VDDCX when removing
      USB: OTG: msm: Free VCCCX regulator even if we can't set the voltage

Martin Jackson (1):
      USB: gadget: f_audio: Fix invalid dereference of initdata

Matt Evans (4):
      xhci: Make xHCI driver endian-safe
      xhci: Add rmb() between reading event validity & event data access.
      xhci: Add an assertion to check for virt_dev=0 bug.
      xhci: Remove recursive call to xhci_handle_event

Matthias Kaehlcke (1):
      USB: twl4030-usb: Report correct vbus value for accessory charger adapters1

Maxin B John (1):
      usb: gadget: Remove the LUN checks which are always true

Mian Yousaf Kaukab (5):
      usb: usb_storage: do not align length of request for CBW to maxp size
      usb: musb: ux500: add ux500 specific code for gadget side
      usb: musb: ux500: add dma name for ux500
      usb: musb: ux500: add dma glue layer for ux500
      usb: musb: ux500: add configuration and build options for ux500 dma

Michael Hund (1):
      USB: ldusb: add several new devices

Michal Marek (2):
      usb: ftdi-elan: Drop __TIME__ usage
      usb: u132-hcd: Drop __TIME__ usage

Michal Nazarewicz (4):
      usb: gadget: storage_common: use kstrto*()
      USB: gadget: g_multi: fixed vendor and product ID in inf files
      usb: gadget: storage_common: use kstrto*() [bug fix]
      usb: core: Change usb_create_sysfs_intf_files()' return type to void

Mike Frysinger (1):
      USB: sl811: add Kconfig option for ISOCHRONOUS mode

Oliver Neukum (1):
      USB: cdc-wdm: reset handling according to new requirements

Pavankumar Kondeti (8):
      USB: gadget: Fix typo (s/EBUSY/-EBUSY) in ci13xxx_udc
      USB: gadget: Use bitwise AND operator to test flags in ci13xxx_udc
      USB: gadget: Fix unused variable warning in ci13xxx_udc
      USB: gadget: Fix bug in endpoint feature request processing in ci13xxx_udc
      USB: gadget: Use ep0out for control OUT data phase in ci13xxx_udc
      USB: OTG: msm: Clear in_lpm flag before enabling the IRQ in resume
      USB: OTG: msm: Implement charger detection
      USB: OTG: msm: Add PHY suspend support for MSM8960

Rabin Vincent (1):
      USB: ehci: remove structure packing from ehci_def

Ramneek Mehresh (1):
      fsl/usb: Unused endpoint failure for USB gadget

Randy Dunlap (2):
      usb gadget: fix all Section mismatch warnings
      usb/otg: fix twl6030 macro

Roger Quadros (4):
      usb: gadget: f_mass_storage: Fix Bulk-only RESET handling
      usb: gadget: f_mass_storage: If 'ro'/'cdrom' specified, open file as read-only
      usb: gadget: composite: Allow function drivers to pause control transfers
      usb: gadget: f_mass_storage: Make us pass USBCV MSC Compliance tests

Sarah Sharp (9):
      xhci: Remove sparse warning about cmd_status.
      xhci 1.0: Only interrupt on short packet for IN EPs.
      xhci 1.0: Update TD size field format.
      xhci 1.0: Set transfer burst count field.
      xhci 1.0: Set transfer burst last packet count field.
      xhci: Fix bug in control transfer cancellation.
      xhci: Fix full speed bInterval encoding.
      xhci: Fix memory leak in ring cache deallocation.
      xhci: Fix memory leak bug when dropping endpoints

Sebastian Andrzej Siewior (5):
      usb/hcd: don't return 0 on error in usb_add_hcd()
      usb/dummy_hcd: don't probe for udc if hcd failed
      usb/usbtest: print super on super speed
      usb/usbtest: fix test10 on superpseed
      usb/ch9: use proper endianess for wBytesPerInterval

Sergei Shtylyov (1):
      usb: musb: host: remove duplicate check in musb_ep_program()

Sven Schnelle (3):
      USB: dbgp gadget: fix return value of dbgp_setup
      USB: dbgp gadget: set MaxpacketSize0
      USB: dbpg gadget: dont mask out direction bit

Thomas Abraham (4):
      ARM: S3C2416: Add USB Phy register definitions
      ARM: S3C24XX: Add plaform device definition for USB High-Speed gadget controller.
      ARM: S3C2416: Add support for USB 2.0 High-Speed gadget controller
      USB: Gadget: Add Samsung S3C24XX USB High-Speed controller driver

Weiping Pan(潘卫平) (1):
      usb: fix a typo in a comment

huajun li (1):
      xhci: move the common code to a function to get max ports and port array

