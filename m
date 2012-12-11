Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2LKUMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:12:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38327 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2LKUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:12:05 -0500
Date: Tue, 11 Dec 2012 12:12:01 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.8-rc1
Message-ID: <20121211201201.GA19578@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.8-rc1

for you to fetch changes up to fb37ef98015f864d22be223a0e0d93547cd1d4ef:

  USB: mark uas driver as BROKEN (2012-11-28 13:28:54 -0800)

----------------------------------------------------------------
USB patches for 3.8-rc1

Here's the big set of USB patches for 3.8-rc1.

Lots of USB host driver cleanups in here, and a bit of a reorg of the
EHCI driver to make it easier for the different EHCI platform drivers to
all work together nicer, which was a reduction in overall code.  We also
deleted some unused firmware files, and got rid of the very old
file_storage usb gadget driver that had been broken for a long time.
This means we ended up removing way more code than added, always a nice
thing to see:
	 310 files changed, 3028 insertions(+), 10754 deletions(-)

Other than that, the usual set of new device ids, driver fixes, gadget
driver and controller updates and the like.

All of these have been in the linux-next tree for a number of weeks.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Afzal Mohammed (5):
      usb: musb: dsps: remove platform callback
      usb: musb: dsps: reduce musb instance to one
      usb: musb: dsps: get resources by index
      Revert "usb: musb: dsps: remove explicit NOP device creation"
      usb: musb: dsps: document dt bindings properly

Alan Stern (26):
      EHCI: improved logic for isochronous scheduling
      EHCI: use the isochronous scheduling threshold
      EHCI: replace mult/div with bit-mask operation
      USB: update documentation for URB_ISO_ASAP
      EHCI: implement new semantics for URB_ISO_ASAP
      UHCI: implement new semantics for URB_ISO_ASAP
      OHCI: implement new semantics for URB_ISO_ASAP
      USB: EHCI: move logging macros to ehci.h
      USB: EHCI: make ehci_read_frame_index platform independent
      USB: EHCI: move ehci_update_device() to ehci-lpm.c
      USB: hub_for_each_child should skip unconnected ports
      USB: speed up usb_bus_resume()
      USB: remove iteration limit in hub_tt_work()
      USB: EHCI: remove unused Link Power Management code
      USB: EHCI: remove ehci_port_power() routine
      USB: EHCI: prepare to make ehci-hcd a library module
      USB: EHCI: make ehci-pci a separate driver
      USB: EHCI: make ehci-platform a separate driver
      USB: EHCI: fix build error in ehci-platform.c under PowerPC
      USB: EHCI: fix build error by making ChipIdea host a normal EHCI driver
      USB: EHCI: fix build error in ChipIdea host driver
      USB: fix endpoint-disabling for failed config changes
      USB: EHCI: miscellaneous cleanups for the library conversion
      USB: EHCI: bugfix: urb->hcpriv should not be NULL
      USB: report submission of active URBs
      USB: OHCI: workaround for hardware bug: retired TDs not added to the Done Queue

Alexandre Pereira da Silva (1):
      usb: gadget: lpc32xx_udc: Disable setup request error

Alexey Khoroshilov (1):
      uwb: fix uwb_dev_unlock() missed at an error path in uwb_rc_cmd_async()

Alexis R. Cortes (1):
      usb: host: xhci: Stricter conditional for Z1 system models for Compliance Mode Patch

Amardeep Rai (1):
      usb: spear-ehci/ohci: Do clk_get using dev-id

Bill Pemberton (6):
      usb-core: remove CONFIG_HOTPLUG ifdefs
      usb: remove use of __devexit_p
      usb: remove use of __devinit
      usb: remove use of __devinitdata
      usb: remove use of __devinitconst
      usb: remove use of __devexit

Bjørn Mork (5):
      USB: option: never bind to a usb-storage interface
      USB: add USB_DEVICE_INTERFACE_CLASS macro
      USB: option: replace vendor probe rule with match flags
      USB: option: idVendor and idProduct are __le16
      USB: option: blacklist network interface on Huawei E173

Boyan Nedeltchev (1):
      usb: misc: usbtest: send ISO packets for g_zero

Cesar Eduardo Barros (1):
      MAINTAINERS: remove drivers/block/ub.c

Claudio Scordino (1):
      umc-bus.c: fix usage of device_trylock

Constantine Shulyupin (1):
      USB: usb-skeleton.c: fix compilation error and restored kref_put on fail in skel_open

Dan Carpenter (2):
      WUSB: remove an unnused variable
      USB: usbtest: prevent a divide by zero bug

Dan Williams (1):
      cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)

Dmytro Milinevskyy (1):
      usb: gadget: ncm: correct endianess conversion

Fabio Estevam (1):
      usb: ehci-mxc: Remove unused 'echi' variable

Felipe Balbi (5):
      usb: dwc3: core: switch event buffer allocation to devm_kzalloc()
      usb: dwc3: core: move event buffer allocation out of dwc3_core_init()
      usb: dwc3: drop HAVE_CLK dependency from Exynos glue layer
      usb: dwc3: core: don't kfree() devm_kzalloc()'ed memory
      usb: host: xhci: move HC_STATE_SUSPENDED check to xhci_suspend()

Florian Fainelli (34):
      USB: EHCI: remove IXP4xx EHCI driver
      USB: OHCI: remove ohci-pcc-soc driver.
      MIPS: Loongson 1B: use ehci-platform instead of ehci-ls1x.
      USB: EHCI: remove Loongson 1B EHCI driver.
      MIPS: Netlogic: use ehci-platform driver
      USB: EHCI: remove Netlogic XLS EHCI driver
      USB: EHCI: add no_io_watchdog platform_data parameter to ehci-platform
      MIPS: Alchemy: use the ehci platform driver
      USB: EHCI: remove Alchemy EHCI driver
      ARM: cns3xxx: use ehci platform driver
      USB: EHCI: remove CNS3xxx EHCI platform driver
      USB: ohci: allow platform driver to specify the number of ports
      USB: ohci: move ohci_pci_{suspend,resume} to ohci-hcd.c
      USB: ohci: remove check for RH already suspended in ohci_suspend
      USB: ohci: merge ohci_finish_controller_resume with ohci_resume
      MIPS: PNX8550: use OHCI platform driver
      USB: OHCI: remove PNX8550 OHCI driver
      ARM: cns3xxx: use OHCI platform driver
      USB: OHCI: remove CNS3xxx OHCI platform driver
      MIPS: Netlogic: convert to use OHCI platform driver
      USB: OHCI: remove Netlogic XLS OHCI platform driver
      sh: convert boards to use the OHCI platform driver
      USB: OHCI: remove OHCI SH platform driver
      MIPS: Alchemy: use the OHCI platform driver
      USB: OHCI: remove Alchemy OHCI platform driver.
      USB: move common alchemy USB routines to arch/mips/alchemy/common.c
      USB: EHCI: make ehci-platform use dev_err() instead of pr_err()
      USB: OHCI: make ohci-platform use dev_err() instead of pr_err()
      USB: EHCI: fix typo in ehci-platform driver on the word "resource"
      USB: OHCI: fix typo in ohci-platform driver on the word "resource"
      USB: EHCI: make ehci-platform use devm_request_and_ioremap helper
      USB: OHCI: make ohci-platform use devm_request_and_ioremap helper
      MIPS: Alchemy: update development boards defconfigs with USB platform drivers
      USB: OHCI: sm501: fix build failure after ohci_finish_controller_resume removal

Greg KH (1):
      USB: mark uas driver as BROKEN

Greg Kroah-Hartman (10):
      USB: ezusb: unexport some functions that aren't being used
      Merge 3.7-rc3 into usb-next.
      Merge tag 'xceiv-for-v3.8' of git://git.kernel.org/.../balbi/usb into USB-next
      Merge tag 'musb-for-v3.8' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'dwc3-for-v3.8' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'gadget-for-v3.8' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'for-usb-next-2012-11-12' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge 3.7-rc5 into usb-next
      Merge 3.7-rc6 into usb-next.
      Merge tag 'for-usb-next-2012-11-28' of git://git.kernel.org/.../sarah/xhci into usb-next

Hindin Joseph (1):
      USB: fix authorization and claimed port logic

Ian Coolidge (1):
      usb: gadget: g_ether: fix frame size check

Jan Beulich (2):
      USB: fix build with XEN and EARLY_PRINTK_DBGP enabled but USB_SUPPORT disabled
      fix build of EHCI debug port code when USB_CHIPIDEA but !USB_EHCI_HCD

Jarkko Huijts (1):
      usb: serial: ftdi_sio: Add missing chars_in_buffer function

Jingoo Han (4):
      USB: ohci-exynos: use devm_clk_get()
      USB: ohci-s3c2410: use devm_ functions
      USB: iuu_phoenix: replace strict_strtoul() with kstrtoul()
      USB: ums_realtek: fix build warning

Joe Perches (1):
      usb: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

Johan Hovold (27):
      USB: cp210x: fix whitespace issues
      USB: ftdi_sio: remove unnecessary memset
      USB: ftdi_sio: remove unused private port-data
      USB: ftdi_sio: fix tiocmget indentation
      USB: ftdi_sio: fix tiocmget and tiocmset return values
      USB: ftdi_sio: refactor modem-control status retrieval
      USB: serial: export usb_serial_generic_chars_in_buffer
      USB: ftdi_sio: use generic chars_in_buffer
      USB: ftdi_sio: optimise chars_in_buffer
      USB: ftdi_sio: use ftdi_get_modem_status in chars_in_buffer
      USB: serial: remove driver version information
      USB: opticon: remove redundant bulk urb fill
      USB: opticon: move private urb initialisation to attach
      USB: opticon: use port device for error and debug
      USB: opticon: remove private serial-device data
      USB: opticon: remove redundant initialisation
      USB: opticon: remove private usb-serial data
      USB: opticon: simplify bulk-in discovery in attach
      USB: opticon: move read-urb deallocation to release
      USB: opticon: remove disconnect
      USB: opticon: make private data port specific
      USB: opticon: pass port to get_serial_info
      USB: opticon: use port as urb context
      USB: opticon: increase bulk-in size
      USB: opticon: use usb-serial bulk-in urb
      USB: opticon: refactor reab-urb processing
      USB: opticon: switch to generic read implementation

Julius Werner (1):
      xhci: fix null-pointer dereference when destroying half-built segment rings

Justin P. Mattock (1):
      usb: "ehci-w90x900" Fix a typo and add some whitespace.

Kees Cook (1):
      drivers/uwb: remove depends on CONFIG_EXPERIMENTAL

Kishon Vijay Abraham I (1):
      usb: dwc3: core: move dwc3_cache_hwparams before dwc3_alloc_event_buffers

Kuninori Morimoto (8):
      usb: renesas_usbhs: gadget: add usb_gadget_ops :: pullup support
      usb: renesas_usbhs: use devm_request_irq()
      usb: renesas_usbhs: fixup unreadable macro
      usb: renesas_usbhs: add DMAEngine support on mod_host
      usb: phy: add R-Car USB phy driver
      usb: renesas_usbhs: remove debug information from usbhsh_hub_status_data()
      usb: renesas_usbhs: host: add endpoint user counter
      usb: renesas_usbhs: use transfer counter if IN direction bulk pipe

Lothar Waßmann (1):
      USB: chipidea: fix use after free bug

Markus Becker (1):
      USB: cp210x: add Virtenio Preon32 device id

Martin Teichmann (1):
      USB: ftdi_sio: Add support for Newport AGILIS motor drivers

Masanari Iida (1):
      usb: fix typo in drivers/usb

Michal Nazarewicz (6):
      arch: Change defconfigs to point to g_mass_storage.
      usb: gadget: Remove File-backed Storage Gadget (g_file_storage).
      usb: gadget: storage_common: Remove FSG specific definitions.
      usb: gadget: storage_common: Drop #ifdefs used for the sake of FSG.
      usb: gadget: storage_common: Make fsg_lun_is_open() a function.
      usb: gadget: Remove reference to is_dualspeed from sysfs.

Ming Lei (2):
      USB: check port changes before hub runtime suspend for some bug device
      USB: set hub's default autosuspend delay as 0

Nobuhiro Iwamatsu (1):
      USB: isp1760-if: Change to use irq_of_parse_and_map

Peter Chen (5):
      USB: EHCI: add condition for delay during the resume
      Revert "usb: otg: mxs-phy: Fix mx23 operation"
      usb: mxs-phy: re-init phy during the connection is useless
      usb: refine phy notify operation during connection and disconnection
      usb: phy: change phy notify connect/disconnect API

Peter Korsgaard (1):
      usb: ftdi_sio: fixup BeagleBone A5+ quirk

Peter Ujfalusi (1):
      usb: otg: twl4030: Change TWL4030_MODULE_* ids to TWL_MODULE_*

Philippe De Swert (1):
      usb: musb: remove generic_interrupt

Rene Buergel (1):
      ezusb: add dependency to USB

Russell Webb (1):
      xhci: Add Lynx Point LP to list of Intel switchable hosts

Sachin Kamat (1):
      USB: core: Free the allocated memory before exiting on error

Santhapuri, Damodar (1):
      usb: musb: dsps: control module handling (quirk)

Sarah Sharp (4):
      xhci: Avoid global symbol pollution with handshake.
      xhci: Fix conditional check in bandwidth calculation.
      xHCI: Fix TD Size calculation on 1.0 hosts.
      xhci: Extend Fresco Logic MSI quirk.

Sebastian Andrzej Siewior (25):
      usb: gadget: ecm: Add IAD descriptor in SS mode
      usb: gadget: tcm_usb_gadget: NULL terminate the FS descriptor list
      usb: gadget: use a computation macro for INT endpoint interval
      usb: gadget storage: use a computation macro for INT endpoint interval
      usb: gadget: uac2: add some error recovery in afunc_bind()
      usb: gadget: network: fix bind() error path
      usb: gadget: audio: remove c->highpseed = true from f_midi and uac1
      usb: gadget: midi: free hs descriptors
      usb: gadget: midi: make FS and HS available
      usb: gadget: phonet: free requests in pn_bind()'s error path
      usb: gadget: uvc: fix error path in uvc_function_bind()
      usb: gadget: always update HS/SS descriptors and create a copy of them
      usb: gadget: remove DMA_ADDR_INVALID from f_uac2 and gadgetfs
      usb: gadget: uac2: provide a variable for interface and alt settings
      usb: gadget: uac2: use the strings directly
      usb: gadget: let f_* use usb_string_ids_tab() where it makes sense
      usb: gadget: dummy_hdc: prepare for multiple instances
      usb: gadget: dummy_hcd: add setup / cleanup of multiple HW intances
      usb: gadget: dummy_hcd: remove global the_controller variable
      usb: dwc3: remove custom unique id handling
      usb: musb: read MUSB_POWER register only when required.
      usb: musb: avoid FADDR read access
      usb: musb: Perform only write access on MUSB_INTRRXE
      usb: musb: Perform only write access on MUSB_INTRTXE
      usb: musb: remove hand-crafted id handling

Sergei Shtylyov (1):
      usb: musb: cppi_dma: export cppi_interrupt()

Srinivas Kandagatla (7):
      usb: musb: am35x: use module_platform_driver macro
      usb: musb: blackfin: use module_platform_driver macro
      usb: musb: da8xx: use module_platform_driver macro
      usb: musb: davinci: use module_platform_driver macro
      usb: musb: tusb6010: use module_platform_driver macro
      usb: musb: ux500: use module_platform_driver macro
      usb: phy: mv_otg: use module_platform_driver macro

Stephen Warren (3):
      usb: phy: tegra remove include of <mach/iomap.h>
      usb: host: tegra remove include of <mach/iomap.h>
      usb: phy: tegra remove include of <mach/iomap.h>

Thomas Abraham (2):
      usb: ehci-s5p: use clk_prepare_enable and clk_disable_unprepare
      usb: ohci-exynos: use clk_prepare_enable and clk_disable_unprepare

Tim Gardner (1):
      firmware: remove last vestiges of dabusb

Vincent Palatin (1):
      USB: ohci-exynos: initialize registers pointer earlier

Viresh Kumar (1):
      usb: spear-ehci/ohci: Use devm_*() routines

Vivek Gautam (2):
      usb: dwc3: exynos: add support for device tree
      usb: dwc3: exynos: remove platform data support

Wei Yongjun (8):
      usb: musb: am35x: use platform_device_unregister in am35x_remove()
      usb: musb: blackfin: use platform_device_unregister in bfin_remove()
      usb: musb: da8xx: use platform_device_unregister in da8xx_remove()
      usb: musb: davinci: use platform_device_unregister in davinci_remove()
      usb: musb: dsps: use platform_device_unregister in dsps_delete_musb_pdev()
      usb: musb: tusb6010: use platform_device_unregister in tusb_remove()
      usb: musb: ux500: use platform_device_unregister in ux500_remove()
      usb: host: tegra: remove pointless NULL check in tegra_ehci_remove()

Yan Hong (1):
      usb: storage: remove redundant memset() in usb_probe_stor1()

Yuanhan Liu (1):
      USB: use bus_to_hdc instead of container_of

li.rui27@zte.com.cn (1):
      USB: add new zte 3g-dongle's pid to option.c

 Documentation/DocBook/gadget.tmpl                                   |    2 +-
 Documentation/devices.txt                                           |    3 -
 Documentation/devicetree/bindings/usb/am33xx-usb.txt                |    8 +-
 Documentation/usb/error-codes.txt                                   |    7 +-
 Documentation/usb/mass-storage.txt                                  |   15 +-
 MAINTAINERS                                                         |    6 -
 arch/arm/configs/afeb9260_defconfig                                 |    2 +-
 arch/arm/configs/at91sam9260_defconfig                              |    2 +-
 arch/arm/configs/at91sam9261_defconfig                              |    2 +-
 arch/arm/configs/at91sam9263_defconfig                              |    2 +-
 arch/arm/configs/at91sam9g20_defconfig                              |    2 +-
 arch/arm/configs/corgi_defconfig                                    |    2 +-
 arch/arm/configs/davinci_all_defconfig                              |    2 +-
 arch/arm/configs/h7202_defconfig                                    |    3 +-
 arch/arm/configs/magician_defconfig                                 |    2 +-
 arch/arm/configs/mini2440_defconfig                                 |    2 +-
 arch/arm/configs/omap1_defconfig                                    |    3 +-
 arch/arm/configs/prima2_defconfig                                   |    1 -
 arch/arm/configs/spitz_defconfig                                    |    2 +-
 arch/arm/configs/stamp9g20_defconfig                                |    2 +-
 arch/arm/configs/viper_defconfig                                    |    2 +-
 arch/arm/configs/zeus_defconfig                                     |    2 +-
 arch/arm/mach-cns3xxx/cns3420vb.c                                   |   53 +-
 arch/avr32/configs/atngw100_defconfig                               |    2 +-
 arch/avr32/configs/atngw100_evklcd100_defconfig                     |    2 +-
 arch/avr32/configs/atngw100_evklcd101_defconfig                     |    2 +-
 arch/avr32/configs/atngw100_mrmt_defconfig                          |    2 +-
 arch/avr32/configs/atngw100mkii_defconfig                           |    2 +-
 arch/avr32/configs/atngw100mkii_evklcd100_defconfig                 |    2 +-
 arch/avr32/configs/atngw100mkii_evklcd101_defconfig                 |    2 +-
 arch/avr32/configs/atstk1002_defconfig                              |    2 +-
 arch/avr32/configs/atstk1003_defconfig                              |    2 +-
 arch/avr32/configs/atstk1004_defconfig                              |    2 +-
 arch/avr32/configs/atstk1006_defconfig                              |    2 +-
 arch/avr32/configs/favr-32_defconfig                                |    2 +-
 arch/avr32/configs/hammerhead_defconfig                             |    2 +-
 arch/blackfin/configs/CM-BF527_defconfig                            |    2 +-
 arch/blackfin/configs/CM-BF548_defconfig                            |    2 +-
 arch/blackfin/configs/CM-BF561_defconfig                            |    2 +-
 arch/mips/alchemy/common/Makefile                                   |    2 +-
 arch/mips/alchemy/common/platform.c                                 |   58 +-
 drivers/usb/host/alchemy-common.c => arch/mips/alchemy/common/usb.c |    0
 arch/mips/ath79/dev-usb.c                                           |    2 -
 arch/mips/configs/bcm47xx_defconfig                                 |    2 +-
 arch/mips/configs/db1000_defconfig                                  |    1 +
 arch/mips/configs/db1235_defconfig                                  |    2 +
 arch/mips/configs/gpr_defconfig                                     |    1 +
 arch/mips/configs/ls1b_defconfig                                    |    1 +
 arch/mips/configs/mtx1_defconfig                                    |    3 +-
 arch/mips/loongson1/common/platform.c                               |    7 +-
 arch/mips/netlogic/xlr/platform.c                                   |   17 +-
 arch/mips/pnx8550/common/platform.c                                 |   31 +-
 arch/sh/configs/ecovec24_defconfig                                  |    2 +-
 arch/sh/configs/se7724_defconfig                                    |    2 +-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c                               |    6 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c                              |    6 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c                              |    6 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c                              |    6 +-
 drivers/usb/c67x00/c67x00-drv.c                                     |    6 +-
 drivers/usb/chipidea/Kconfig                                        |    1 +
 drivers/usb/chipidea/ci13xxx_imx.c                                  |    8 +-
 drivers/usb/chipidea/ci13xxx_msm.c                                  |    6 +-
 drivers/usb/chipidea/ci13xxx_pci.c                                  |    6 +-
 drivers/usb/chipidea/core.c                                         |    9 +-
 drivers/usb/chipidea/debug.c                                        |    3 -
 drivers/usb/chipidea/host.c                                         |   67 +-
 drivers/usb/chipidea/usbmisc_imx6q.c                                |    6 +-
 drivers/usb/class/cdc-acm.c                                         |   38 +
 drivers/usb/core/devices.c                                          |   18 +-
 drivers/usb/core/driver.c                                           |   25 -
 drivers/usb/core/generic.c                                          |    7 +-
 drivers/usb/core/hcd.c                                              |   19 +-
 drivers/usb/core/hub.c                                              |   97 +-
 drivers/usb/core/message.c                                          |   66 +-
 drivers/usb/core/urb.c                                              |   29 +-
 drivers/usb/core/usb.c                                              |   13 +-
 drivers/usb/dwc3/Makefile                                           |   14 +-
 drivers/usb/dwc3/core.c                                             |   96 +-
 drivers/usb/dwc3/core.h                                             |    3 -
 drivers/usb/dwc3/debugfs.c                                          |    4 +-
 drivers/usb/dwc3/dwc3-exynos.c                                      |   57 +-
 drivers/usb/dwc3/dwc3-omap.c                                        |   24 +-
 drivers/usb/dwc3/dwc3-pci.c                                         |   24 +-
 drivers/usb/dwc3/gadget.c                                           |    4 +-
 drivers/usb/early/ehci-dbgp.c                                       |    4 +-
 drivers/usb/gadget/Kconfig                                          |   29 +-
 drivers/usb/gadget/Makefile                                         |    2 -
 drivers/usb/gadget/at91_udc.c                                       |    4 +-
 drivers/usb/gadget/bcm63xx_udc.c                                    |    6 +-
 drivers/usb/gadget/composite.c                                      |    8 +-
 drivers/usb/gadget/config.c                                         |   39 +-
 drivers/usb/gadget/dummy_hcd.c                                      |  170 +++-
 drivers/usb/gadget/f_acm.c                                          |   79 +-
 drivers/usb/gadget/f_ecm.c                                          |  112 +--
 drivers/usb/gadget/f_eem.c                                          |   51 +-
 drivers/usb/gadget/f_fs.c                                           |    4 +-
 drivers/usb/gadget/f_hid.c                                          |   30 +-
 drivers/usb/gadget/f_loopback.c                                     |   28 +-
 drivers/usb/gadget/f_mass_storage.c                                 |   63 +-
 drivers/usb/gadget/f_midi.c                                         |   14 +-
 drivers/usb/gadget/f_ncm.c                                          |   94 +-
 drivers/usb/gadget/f_obex.c                                         |   42 +-
 drivers/usb/gadget/f_phonet.c                                       |   21 +-
 drivers/usb/gadget/f_rndis.c                                        |   94 +-
 drivers/usb/gadget/f_serial.c                                       |   38 +-
 drivers/usb/gadget/f_sourcesink.c                                   |  104 +--
 drivers/usb/gadget/f_subset.c                                       |   75 +-
 drivers/usb/gadget/f_uac1.c                                         |   23 +-
 drivers/usb/gadget/f_uac2.c                                         |  222 ++---
 drivers/usb/gadget/f_uvc.c                                          |  138 ++-
 drivers/usb/gadget/file_storage.c                                   | 3656 -------------------------------------------------------------------------
 drivers/usb/gadget/fsl_qe_udc.c                                     |   14 +-
 drivers/usb/gadget/fsl_udc_core.c                                   |    2 +-
 drivers/usb/gadget/hid.c                                            |    4 +-
 drivers/usb/gadget/inode.c                                          |    3 -
 drivers/usb/gadget/lpc32xx_udc.c                                    |    6 +-
 drivers/usb/gadget/mv_u3d_core.c                                    |    2 +-
 drivers/usb/gadget/mv_udc_core.c                                    |    4 +-
 drivers/usb/gadget/net2272.c                                        |   29 +-
 drivers/usb/gadget/net2280.c                                        |    2 +-
 drivers/usb/gadget/omap_udc.c                                       |   10 +-
 drivers/usb/gadget/printer.c                                        |   12 +-
 drivers/usb/gadget/pxa27x_udc.h                                     |    2 +-
 drivers/usb/gadget/s3c-hsotg.c                                      |   12 +-
 drivers/usb/gadget/s3c-hsudc.c                                      |    2 +-
 drivers/usb/gadget/storage_common.c                                 |  165 +---
 drivers/usb/gadget/tcm_usb_gadget.c                                 |   13 +-
 drivers/usb/gadget/udc-core.c                                       |   11 -
 drivers/usb/host/Kconfig                                            |   35 +-
 drivers/usb/host/Makefile                                           |    4 +-
 drivers/usb/host/bcma-hcd.c                                         |   15 +-
 drivers/usb/host/ehci-atmel.c                                       |   15 +-
 drivers/usb/host/ehci-au1xxx.c                                      |  184 ----
 drivers/usb/host/ehci-cns3xxx.c                                     |  155 ----
 drivers/usb/host/ehci-dbg.c                                         |  112 ---
 drivers/usb/host/ehci-fsl.c                                         |    1 -
 drivers/usb/host/ehci-grlib.c                                       |   20 +-
 drivers/usb/host/ehci-hcd.c                                         |  204 ++---
 drivers/usb/host/ehci-hub.c                                         |   47 +-
 drivers/usb/host/ehci-ixp4xx.c                                      |  139 ---
 drivers/usb/host/ehci-lpm.c                                         |   84 --
 drivers/usb/host/ehci-ls1x.c                                        |  147 ---
 drivers/usb/host/ehci-msm.c                                         |    5 +-
 drivers/usb/host/ehci-mxc.c                                         |   10 +-
 drivers/usb/host/ehci-octeon.c                                      |    3 -
 drivers/usb/host/ehci-omap.c                                        |    3 -
 drivers/usb/host/ehci-orion.c                                       |   20 +-
 drivers/usb/host/ehci-pci.c                                         |  132 +--
 drivers/usb/host/ehci-platform.c                                    |  102 +--
 drivers/usb/host/ehci-pmcmsp.c                                      |    1 -
 drivers/usb/host/ehci-ppc-of.c                                      |    4 +-
 drivers/usb/host/ehci-ps3.c                                         |    2 +-
 drivers/usb/host/ehci-q.c                                           |   12 +-
 drivers/usb/host/ehci-s5p.c                                         |   16 +-
 drivers/usb/host/ehci-sched.c                                       |  136 ++-
 drivers/usb/host/ehci-sh.c                                          |    9 +-
 drivers/usb/host/ehci-spear.c                                       |   59 +-
 drivers/usb/host/ehci-tegra.c                                       |   18 +-
 drivers/usb/host/ehci-vt8500.c                                      |   21 -
 drivers/usb/host/ehci-w90x900.c                                     |   10 +-
 drivers/usb/host/ehci-xilinx-of.c                                   |    2 +-
 drivers/usb/host/ehci-xls.c                                         |  142 ---
 drivers/usb/host/ehci.h                                             |   45 +-
 drivers/usb/host/fhci-hcd.c                                         |    8 +-
 drivers/usb/host/fsl-mph-dr-of.c                                    |   16 +-
 drivers/usb/host/imx21-hcd.c                                        |    2 +-
 drivers/usb/host/isp116x-hcd.c                                      |    2 +-
 drivers/usb/host/isp1362-hcd.c                                      |    6 +-
 drivers/usb/host/isp1760-if.c                                       |   15 +-
 drivers/usb/host/ohci-at91.c                                        |   22 +-
 drivers/usb/host/ohci-au1xxx.c                                      |  234 -----
 drivers/usb/host/ohci-cns3xxx.c                                     |  166 ----
 drivers/usb/host/ohci-ep93xx.c                                      |    4 +-
 drivers/usb/host/ohci-exynos.c                                      |   38 +-
 drivers/usb/host/ohci-hcd.c                                         |  139 ++-
 drivers/usb/host/ohci-hub.c                                         |   42 -
 drivers/usb/host/ohci-jz4740.c                                      |    6 +-
 drivers/usb/host/ohci-nxp.c                                         |    4 +-
 drivers/usb/host/ohci-octeon.c                                      |    2 +-
 drivers/usb/host/ohci-omap.c                                        |    2 +-
 drivers/usb/host/ohci-omap3.c                                       |    6 +-
 drivers/usb/host/ohci-pci.c                                         |   49 +-
 drivers/usb/host/ohci-platform.c                                    |   34 +-
 drivers/usb/host/ohci-pnx8550.c                                     |  243 -----
 drivers/usb/host/ohci-ppc-of.c                                      |    4 +-
 drivers/usb/host/ohci-ppc-soc.c                                     |  216 -----
 drivers/usb/host/ohci-ps3.c                                         |    4 +-
 drivers/usb/host/ohci-pxa27x.c                                      |    8 +-
 drivers/usb/host/ohci-q.c                                           |   23 +-
 drivers/usb/host/ohci-s3c2410.c                                     |   41 +-
 drivers/usb/host/ohci-sa1111.c                                      |    2 +-
 drivers/usb/host/ohci-sh.c                                          |  141 ---
 drivers/usb/host/ohci-sm501.c                                       |    2 +-
 drivers/usb/host/ohci-spear.c                                       |   50 +-
 drivers/usb/host/ohci-tmio.c                                        |    8 +-
 drivers/usb/host/ohci-xls.c                                         |  152 ---
 drivers/usb/host/pci-quirks.c                                       |   20 +-
 drivers/usb/host/r8a66597-hcd.c                                     |   12 +-
 drivers/usb/host/sl811-hcd.c                                        |    6 +-
 drivers/usb/host/ssb-hcd.c                                          |   19 +-
 drivers/usb/host/u132-hcd.c                                         |    6 +-
 drivers/usb/host/uhci-grlib.c                                       |    2 +-
 drivers/usb/host/uhci-platform.c                                    |    2 +-
 drivers/usb/host/uhci-q.c                                           |   73 +-
 drivers/usb/host/xhci-mem.c                                         |    9 +-
 drivers/usb/host/xhci-pci.c                                         |   16 +-
 drivers/usb/host/xhci-ring.c                                        |   34 +-
 drivers/usb/host/xhci.c                                             |   32 +-
 drivers/usb/host/xhci.h                                             |    2 +-
 drivers/usb/misc/Kconfig                                            |    1 +
 drivers/usb/misc/ezusb.c                                            |   38 +-
 drivers/usb/misc/usbtest.c                                          |    4 +
 drivers/usb/musb/am35x.c                                            |   40 +-
 drivers/usb/musb/blackfin.c                                         |   38 +-
 drivers/usb/musb/cppi_dma.c                                         |    4 +-
 drivers/usb/musb/da8xx.c                                            |   40 +-
 drivers/usb/musb/davinci.c                                          |   40 +-
 drivers/usb/musb/musb_core.c                                        |  137 +--
 drivers/usb/musb/musb_core.h                                        |    5 +-
 drivers/usb/musb/musb_debugfs.c                                     |    2 +-
 drivers/usb/musb/musb_dma.h                                         |    3 +-
 drivers/usb/musb/musb_dsps.c                                        |  141 +--
 drivers/usb/musb/musb_gadget.c                                      |   36 +-
 drivers/usb/musb/musb_gadget_ep0.c                                  |    6 +-
 drivers/usb/musb/musb_host.c                                        |    2 +-
 drivers/usb/musb/musbhsdma.c                                        |    3 +-
 drivers/usb/musb/musbhsdma.h                                        |    4 -
 drivers/usb/musb/omap2430.c                                         |   52 +-
 drivers/usb/musb/tusb6010.c                                         |   40 +-
 drivers/usb/musb/tusb6010_omap.c                                    |    3 +-
 drivers/usb/musb/ux500.c                                            |   62 +-
 drivers/usb/musb/ux500_dma.c                                        |    3 +-
 drivers/usb/otg/ab8500-usb.c                                        |    6 +-
 drivers/usb/otg/fsl_otg.c                                           |    6 +-
 drivers/usb/otg/isp1301_omap.c                                      |    2 +-
 drivers/usb/otg/msm_otg.c                                           |    4 +-
 drivers/usb/otg/mv_otg.c                                            |   14 +-
 drivers/usb/otg/mxs-phy.c                                           |   59 +-
 drivers/usb/otg/nop-usb-xceiv.c                                     |    6 +-
 drivers/usb/otg/twl4030-usb.c                                       |   48 +-
 drivers/usb/otg/twl6030-usb.c                                       |    2 +-
 drivers/usb/phy/Kconfig                                             |   12 +
 drivers/usb/phy/Makefile                                            |    1 +
 drivers/usb/phy/mv_u3d_phy.c                                        |    4 +-
 drivers/usb/phy/omap-usb2.c                                         |    6 +-
 drivers/usb/phy/rcar-phy.c                                          |  220 +++++
 drivers/usb/phy/tegra_usb_phy.c                                     |    4 +-
 drivers/usb/renesas_usbhs/common.c                                  |    9 +-
 drivers/usb/renesas_usbhs/common.h                                  |    1 +
 drivers/usb/renesas_usbhs/fifo.c                                    |   14 +-
 drivers/usb/renesas_usbhs/mod.c                                     |    3 +-
 drivers/usb/renesas_usbhs/mod_gadget.c                              |   11 +
 drivers/usb/renesas_usbhs/mod_host.c                                |   45 +-
 drivers/usb/renesas_usbhs/pipe.c                                    |  101 ++
 drivers/usb/renesas_usbhs/pipe.h                                    |    1 +
 drivers/usb/serial/aircable.c                                       |    5 -
 drivers/usb/serial/ark3116.c                                        |    5 -
 drivers/usb/serial/belkin_sa.c                                      |    5 -
 drivers/usb/serial/bus.c                                            |   10 -
 drivers/usb/serial/cp210x.c                                         |   37 +-
 drivers/usb/serial/cyberjack.c                                      |    5 -
 drivers/usb/serial/cypress_m8.c                                     |    5 -
 drivers/usb/serial/digi_acceleport.c                                |    4 -
 drivers/usb/serial/empeg.c                                          |    4 -
 drivers/usb/serial/ftdi_sio.c                                       |   82 +-
 drivers/usb/serial/ftdi_sio_ids.h                                   |    6 +
 drivers/usb/serial/generic.c                                        |    1 +
 drivers/usb/serial/hp4x.c                                           |    5 -
 drivers/usb/serial/io_edgeport.c                                    |    4 -
 drivers/usb/serial/io_ti.c                                          |    4 -
 drivers/usb/serial/ipaq.c                                           |    5 -
 drivers/usb/serial/ipw.c                                            |    4 -
 drivers/usb/serial/iuu_phoenix.c                                    |    8 +-
 drivers/usb/serial/keyspan.c                                        |    4 -
 drivers/usb/serial/keyspan_pda.c                                    |    4 -
 drivers/usb/serial/kl5kusb105.c                                     |    4 -
 drivers/usb/serial/kobil_sct.c                                      |    2 -
 drivers/usb/serial/mct_u232.c                                       |    4 -
 drivers/usb/serial/metro-usb.c                                      |    2 -
 drivers/usb/serial/mos7720.c                                        |    4 -
 drivers/usb/serial/mos7840.c                                        |    4 -
 drivers/usb/serial/omninet.c                                        |    4 -
 drivers/usb/serial/opticon.c                                        |  351 ++-----
 drivers/usb/serial/option.c                                         |  113 ++-
 drivers/usb/serial/oti6858.c                                        |    2 -
 drivers/usb/serial/quatech2.c                                       |    2 -
 drivers/usb/serial/siemens_mpi.c                                    |    2 -
 drivers/usb/serial/sierra.c                                         |    3 +-
 drivers/usb/serial/spcp8x5.c                                        |    4 -
 drivers/usb/serial/ssu100.c                                         |    2 -
 drivers/usb/serial/usb_wwan.c                                       |    2 -
 drivers/usb/serial/vivopay-serial.c                                 |    3 -
 drivers/usb/storage/Kconfig                                         |    2 +-
 drivers/usb/storage/realtek_cr.c                                    |    2 +-
 drivers/usb/storage/usb.c                                           |    1 -
 drivers/usb/usb-skeleton.c                                          |   13 +-
 drivers/usb/wusbcore/devconnect.c                                   |   13 -
 drivers/uwb/Kconfig                                                 |    3 +-
 drivers/uwb/reset.c                                                 |    1 +
 drivers/uwb/umc-bus.c                                               |    2 +-
 firmware/Makefile                                                   |    1 -
 firmware/dabusb/bitstream.bin.ihex                                  |  761 ---------------
 firmware/dabusb/firmware.HEX                                        |  649 -------------
 include/linux/usb.h                                                 |   50 +-
 include/linux/usb/composite.h                                       |    4 +-
 include/linux/usb/ehci_pdriver.h                                    |    5 +-
 include/linux/usb/ezusb.h                                           |    8 -
 include/linux/usb/gadget.h                                          |    7 +
 include/linux/usb/ohci_pdriver.h                                    |    2 +
 include/linux/usb/phy.h                                             |   15 +-
 310 files changed, 3028 insertions(+), 10754 deletions(-)
 rename drivers/usb/host/alchemy-common.c => arch/mips/alchemy/common/usb.c (100%)
 delete mode 100644 drivers/usb/gadget/file_storage.c
 delete mode 100644 drivers/usb/host/ehci-au1xxx.c
 delete mode 100644 drivers/usb/host/ehci-cns3xxx.c
 delete mode 100644 drivers/usb/host/ehci-ixp4xx.c
 delete mode 100644 drivers/usb/host/ehci-lpm.c
 delete mode 100644 drivers/usb/host/ehci-ls1x.c
 delete mode 100644 drivers/usb/host/ehci-xls.c
 delete mode 100644 drivers/usb/host/ohci-au1xxx.c
 delete mode 100644 drivers/usb/host/ohci-cns3xxx.c
 delete mode 100644 drivers/usb/host/ohci-pnx8550.c
 delete mode 100644 drivers/usb/host/ohci-ppc-soc.c
 delete mode 100644 drivers/usb/host/ohci-sh.c
 delete mode 100644 drivers/usb/host/ohci-xls.c
 create mode 100644 drivers/usb/phy/rcar-phy.c
 delete mode 100644 firmware/dabusb/bitstream.bin.ihex
 delete mode 100644 firmware/dabusb/firmware.HEX
