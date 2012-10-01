Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2JASbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:31:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44841 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab2JASbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:31:43 -0400
X-Sasl-enc: TWX1rsGu7eJ1B9W0GXx7QJPYrTF5jKjt4x+gmFjHaU3f 1349116302
Date: Mon, 1 Oct 2012 11:31:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.7-rc1
Message-ID: <20121001183141.GA13100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.6

for you to fetch changes up to 70c048a238c780c226eb4b115ebaa908cb3b34ec:

  USB: ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc (2012-09-26 14:20:28 -0700)

----------------------------------------------------------------
USB merge for 3.7-rc1

Here is the big USB pull request for 3.7-rc1

There are lots of gadget driver changes (including copying a bunch of
files into the drivers/staging/ccg/ directory so that the other gadget
drivers can be fixed up properly without breaking that driver), and we
remove the old obsolete ub.c driver from the tree.  There are also the
usual XHCI set of updates, and other various driver changes and updates.
We also are trying hard to remove the old dbg() macro, but the final
bits of that removal will be coming in through the networking tree
before we can delete it for good.

All of these patches have been in the linux-next tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Ajay Kumar Gupta (7):
      usb: musb: host: don't program dma for zero byte tx
      usb: musb: gadget: don't program dma for zero byte tx
      usb: musb: check for zero byte in musb_read/write_fifo
      usb: musb: NAK timeout scheme on bulk TX endpoint
      usb: musb: kill global and static for multi instance
      usb: musb: dsps: add dt support
      usb: musb: dsps: remove explicit NOP device creation

Alan Cox (2):
      usb: remove junk from store_remove_id
      USB: sierra_ms: don't keep unused variable

Alan Stern (4):
      usb: gadget: dummy-hcd: remember to update driver pointer
      USB: EHCI: remove useless test
      USB: EHCI: convert warning messages to debug-level
      USB: Fix race condition when removing host controllers

Alexander Shishkin (1):
      usb: move children deallocation after quiescing the hub

Alexey Khoroshilov (3):
      wusb: Fix potential memory leak in wusb_dev_sec_add()
      USB: whci-hcd: Fix potential memory leak in qset_add_urb_sg()
      USB: omninet: fix potential tty NULL dereference

Andrew Lunn (1):
      USB: PLAT_ORION fulfils USB_ARCH_HAS_EHCI

Andy Shevchenko (2):
      usb: gadget: use native print_hex_dump_bytes()
      usb: gadget: use %pm to print mac addresses

Antonio Ospite (1):
      USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support

B, Ravi (2):
      usb: musb: add musb_ida for multi instance support
      usb: musb: am335x: add support for dual instance

Bjørn Mork (2):
      USB: option: blacklist QMI interface on ZTE MF683
      USB: qcaux: add Pantech vendor class match

Brian Downing (1):
      usb: musb: Fix bad call to kfree() in musb_free

Chanho Park (1):
      usb: dwc3: set up burst size only superspeed mode

Chao Xie (1):
      usb: gadget: mv_udc: add iso support

Chuansheng Liu (1):
      USB/host: Cleanup unneccessary irq disable code

Cong Wang (1):
      block: remove the deprecated ub driver

Dan Carpenter (2):
      USB: legousbtower.c: remove a bogus NULL check
      USB: whci-hcd: fix NULL dereference on allocation failure

Dan Williams (1):
      USB: qcserial: fix port handling on Gobi 1K and 2K+

Daniel Mack (1):
      USB: ohci-pxa27x: add DT bindings

Du, Changbin (1):
      usb: gadget: s3c-hsotg: fix core reset timeout failure

Elric Fu (4):
      xHCI: add cmd_ring_state
      xHCI: add aborting command ring function
      xHCI: cancel command after command timeout
      xHCI: handle command after aborting the command ring

Fabio Porcedda (1):
      usb: gadget: at91_udc: fix dt support

Felipe Balbi (21):
      usb: dwc3: gadget: set Ignore Sequence Number bit from ConnectDone Event
      usb: dwc3: ep0: drop unnecessary variable
      usb: dwc3: ep0: split the special cases on ep0_queue
      usb: dwc3: ep0: drop dead code
      usb: dwc3: ep0: ignore XferNotReady(STATUS) when we're not expecting it
      usb: dwc3: ep0: move DATA phase away from on-demand
      usb: dwc3: ep0: drop XferNotReady(DATA) support
      usb: dwc3: ep0: fix status phase delayed status direction
      usb: dwc3: ep0: make sure to reinitilize ep1 on STALL
      usb: xceiv: create nop-usb-xceiv.h and avoid pollution on otg.h
      usb: xceiv: nop: let it work as USB2 and USB3 phy
      usb: musb: fix sparse warnings
      usb: musb: drop useless board_mode usage
      usb: musb: drop is_host_capable() and is_peripheral_capable()
      usb: dwc3: core: use devm_iremap_nocache() version
      usb: dwc3: gadget: warn about endpoint already enabled before changing ep name
      usb: dwc3: pci: add nop transceiver support
      usb: dwc3: omap: add nop transceiver support
      usb: dwc3: exynos: add nop transceiver support
      usb: dwc3: add basic PHY support
      usb: host: xhci: sparse fixes

Gerd Hoffmann (7):
      USB: uas: keep track of command urbs
      USB: uas: fix task management
      USB: uas: remove aborted field, replace with status bit.
      USB: uas: fix abort
      USB: uas: add locking
      USB: uas: fix locking
      USB: uas: fix gcc warning

Greg Kroah-Hartman (107):
      Merge v3.6-rc3 into usb-next
      Merge tag 'gadget-for-v3.7' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'xceiv-for-v3.7' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'dwc3-for-v3.7' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'musb-for-v3.7' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge branch 'chipidea-stable' into usb-next
      USB: serial: move usb_serial_debug_data to use %*ph
      USB: serial: add zte_ev.c driver
      USB: atm: usbatm: fix up debug printing code
      USB: core: remove unused dbg() call in message.c
      USB: serial: core: remove some trace debugging calls
      USB: serial: core: clean up dbg and printk usage.
      Merge tag 'for-usb-next-2012-09-13' of git://git.kernel.org/.../sarah/xhci into usb-next
      USB: serial: ch341.c: remove dbg() usage
      USB: serial: cp210x.c: remove dbg() usage
      USB: serial: cyberjack.c: remove dbg() usage
      USB: serial: ipw.c: remove dbg() usage
      USB: serial: opticon.c: remove dbg() usage
      USB: serial: option.c: remove dbg() usage
      USB: serial: omninet.c: remove dbg() usage
      USB: serial: usb_wwan.c: remove dbg() usage
      USB: serial: cypress_m8.c: remove dbg() usage
      USB: serial: digi_acceleport.c: remove dbg() usage
      USB: serial: ftdi_sio.c: remove dbg() usage
      USB: serial: kl5kusb105.c: remove dbg() usage
      USB: serial: garmin_gps.c: remove dbg() usage
      USB: serial: oti6858.c: remove dbg() usage
      USB: serial: ssu100.c: remove dbg() usage
      USB: serial: whiteheat.c: remove dbg() usage
      USB: serial: keyspan_pda.c: remove dbg() usage
      USB: serial: kobil_sct.c: remove dbg() usage
      USB: serial: aircable.c: remove debug module parameter
      USB: serial: cp210x.c: remove debug module parameter
      USB: serial: digi_acceleport.c: remove debug module parameter
      USB: serial: empeg.c: remove debug module parameter
      USB: serial: ftdi_sio.c: remove debug module parameter
      USB: serial: funsoft.c: remove debug module parameter
      USB: serial: ipaq.c: remove debug module parameter
      USB: serial: ipw.c: remove debug module parameter
      USB: serial: ir-usb.c: remove debug module parameter
      USB: serial: keyspan_pda.c: remove debug module parameter
      USB: serial: kl5kusb105.c: remove debug module parameter
      USB: serial: metro-usb.c: remove debug module parameter
      USB: serial: option.c: remove debug module parameter
      USB: serial: oti6858.c: remove debug module parameter
      USB: serial: qcserial.c: remove debug module parameter
      USB: serial: quatech2.c: remove debug module parameter
      USB: serial: safe_serial.c: remove debug module parameter
      USB: serial: spcp8x5.c: remove debug module parameter
      USB: serial: ssu100.c: remove debug module parameter
      USB: serial: usb_wwan.c: remove debug module parameter
      USB: serial: iuu_phoenix.c: remove dbg() usage
      USB: serial: mct_u232.c: remove dbg() usage
      USB: serial: mos7720.c: remove dbg() usage
      USB: serial: ti_usb_3410_5052.c: remove dbg() usage
      USB: serial: mos7840.c: remove dbg() usage
      USB: serial: keyspan: remove dbg() usage
      USB: serial: keyspan: fix up some compiler warnings
      USB: serial: io_ti.c: remove dbg() usage
      Merge 3.6-rc6 into usb-next
      USB: serial: add vizzini driver
      USB: remove CONFIG_EXPERIMENTAL dependancies
      USB: serial: io_edgeport.c: remove dbg() usage
      USB: serial: serqt_usb2: remove dbg() usage
      USB: serial: remove dbg() from usb/serial.h
      USB: serial: remove debug parameter from usb_serial_debug_data()
      USB: Serial: serqt_usb2.c: remove debug module parameter
      USB: Serial: ark3116.c: remove debug module parameter
      USB: Serial: belkin_sa.c: remove debug module parameter
      USB: Serial: ch341.c: remove debug module parameter
      USB: Serial: cyberjack.c: remove debug module parameter
      USB: Serial: cypress_m8.c: remove debug module parameter
      USB: Serial: f81232.c: remove debug module parameter
      USB: Serial: garmin_gps.c: remove debug module parameter
      USB: Serial: io_edgeport.c: remove debug module parameter
      USB: Serial: io_ti.c: remove debug module parameter
      USB: Serial: iuu_phoenix.c: remove debug module parameter
      USB: Serial: keyspan.c: remove debug module parameter
      USB: Serial: kobil_sct.c: remove debug module parameter
      USB: Serial: mct_u232.c: remove debug module parameter
      USB: Serial: mos7720.c: remove debug module parameter
      USB: Serial: mos7840.c: remove debug module parameter
      USB: Serial: navman.c: remove debug module parameter
      USB: Serial: omninet.c: remove debug module parameter
      USB: Serial: opticon.c: remove debug module parameter
      USB: Serial: pl2303.c: remove debug module parameter
      USB: Serial: sierra.c: remove debug module parameter
      USB: Serial: symbolserial.c: remove debug module parameter
      USB: Serial: ti_usb_3410_5052.c: remove debug module parameter
      USB: Serial: visor.c: remove debug module parameter
      USB: Serial: whiteheat.c: remove debug module parameter
      USB: Serial: omninet: Fix compiler warning.
      USB: Serial: usb-serial: remove debug module parameter
      USB: serial: ezusb: remove last printk() call
      USB: serial: ftdi_sio: remove startup message
      USB: serial: io_ti: remove some remaining printk() calls
      USB: serial: ir-usb: remove startup noise
      USB: serial: kobil_sct: switch 4 remaining printk() calls to use dev_dbg
      USB: serial: quatech2: fix up unneeded printk() call
      USB: serial: safe-serial: fix up printk() usage
      USB: serial: ti_usb_3410_5052: fix up noisy printk() usage
      USB: serial: core: fix up printk() usage
      USB: serial: fix up bug with missing {}
      USB: serial: vizzini: remove outdated comment
      USB: serial: remove vizzini driver
      Revert "usb : Add sysfs files to control port power."
      Merge tag 'for-usb-next-2012-09-25' of git://git.kernel.org/.../sarah/xhci into usb-next

Hans de Goede (1):
      usbfs: Add a new disconnect-and-claim ioctl (v2)

Jan Beulich (1):
      USB EHCI/Xen: propagate controller reset information to hypervisor

Jim Lin (1):
      USB: EHCI: Tegra: Fix wrong register definition

Joachim Eastwood (1):
      USB: ohci-at91: fix null pointer in ohci_hcd_at91_overcurrent_irq

Julia Lawall (23):
      drivers/usb/host/ehci-atmel.c: use devm_ functions
      drivers/usb/host/ehci-au1xxx.c: use devm_ functions
      drivers/usb/host/ehci-cns3xxx.c: use devm_ functions
      drivers/usb/host/ehci-grlib.c: use devm_ functions
      drivers/usb/host/ehci-ixp4xx.c: use devm_ functions
      drivers/usb/host/ehci-ls1x.c: use devm_ functions
      drivers/usb/host/ehci-msm.c: use devm_ functions
      drivers/usb/host/ehci-mv.c: use devm_ functions
      drivers/usb/host/ehci-mxc.c: use devm_ functions
      drivers/usb/host/ehci-ppc-of.c: use devm_ functions
      drivers/usb/host/ehci-s5p.c: use devm_ functions
      drivers/usb/host/ehci-sead3.c: use devm_ functions
      drivers/usb/host/ehci-sh.c: use devm_ functions
      drivers/usb/host/ehci-tegra.c: use devm_ functions
      drivers/usb/host/ehci-vt8500.c: use devm_ functions
      drivers/usb/host/ehci-xilinx-of.c: use devm_ functions
      drivers/usb/host/ehci-platform.c: fix error return code
      drivers/usb/host/ohci-platform.c: fix error return code
      drivers/usb/wusbcore/wa-hc.c: fix error return code
      drivers/usb/gadget/s3c-hsotg.c: fix error return code
      usb: gadget: lpc32xx_udc.c: adjust inconsistent IS_ERR and PTR_ERR
      drivers/usb/host/ohci-nxp.c: adjust inconsistent IS_ERR and PTR_ERR
      drivers/usb/gadget/lpc32xx_udc.c: adjust inconsistent IS_ERR and PTR_ERR

Kevin Cernekee (2):
      usb: gadget: udc-core: Race between disconnect/unbind and setup
      usb: gadget: bcm63xx UDC driver

Kishon Vijay Abraham I (10):
      usb: musb: cleanup while removing musb omap glue driver
      usb: hcd: use *resource_size_t* for specifying resource data
      usb: phy: add a new driver for omap usb2 phy
      usb: otg: make twl6030_usb as a comparator driver to omap_usb2
      usb: twl6030: Add dt support for twl6030 usb
      usb: twl4030: Add device tree support for twl4030 usb
      arm: omap: phy: remove unused functions from omap-phy-internal.c
      arm: omap: hwmod: add a new addr space in otg for writing to control module
      usb: musb: omap: write directly to mailbox instead of using phy
      usb: musb: omap: Add device tree support for omap musb glue

Kuninori Morimoto (6):
      usb: host: ehci-platform: BUG_ON() to WARN_ON() on probe
      usb: host: ohci-platform: BUG_ON() to WARN_ON() on probe
      usb: host: ehci-platform: add platform specific power callback
      usb: host: ohci-platform: add platform specific power callback
      usb: renesas_usbhs: fixup DMA transport data alignment
      usb: renesas_usbhs: convert to devm_xxx()

Lan Tianyu (14):
      usb: Rename temp variable "config" to "val" in the set_avoid_reset_quirk()
      usb: add decriptor of persist fail for some morph usb devices
      usb/endpoint: Set release callback in the struct device_type instead of in the device itself directly
      usb: convert USB_QUIRK_RESET_MORPHS to USB_QUIRK_RESET
      usb: redefine DeviceRemovable and wHubDelay as _le16
      usb: make usb port a real device
      usb: move children to struct usb_port
      usb/acpi: Bind ACPI node to USB port, not usb_device.
      usb/acpi: Store info on device removability.
      xhci: Handle clear PORT_POWER feature.
      usb/acpi: Use ACPI methods to power off ports.
      usb: Fail a get config when the port is powered off.
      usb : Add sysfs files to control port power.
      usb: add little-endian transform for DeviceRemovable of usb3.0 hub

Matthias Brugger (1):
      usb: musb: omap2430.c delete unused variable.

Michael Grzeschik (1):
      usb composite: fix locking in usb_function_activate

Michael Spang (1):
      Increase XHCI suspend timeout to 16ms

Michal Nazarewicz (1):
      usb: gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED

Mike Thompson (1):
      usb: otg: mxs-phy: Fix mx23 operation

Moiz Sonasath (1):
      usb: dwc3: gadget: Fix sparse warnings

Neil Zhang (5):
      usb: gadget: mv_udc: reduce the delay interval
      usb: gadget: mv_udc: remove unused code
      usb: gadget: mv_udc: avoid sleeping on spinlock
      usb: gadget: mv_udc: enable stream mode
      usb: gadget: mv_udc: fix boot up hang

NeilBrown (1):
      usb: musb: omap2430: don't loop indefinitely in interrupt.

Oliver Neukum (1):
      usb: dwc3: core: memory ordering fix in close

Peter Meerwald (2):
      usb: musb: fix spelling of families in Kconfig
      usb host: fix spelling of provides in Kconfig

Peter Senna Tschudin (3):
      drivers/usb/host/xhci-ring.c: removes unnecessary semicolon
      drivers/usb/host/sl811-hcd.c: removes unnecessary semicolon
      drivers/usb/misc/rio500.c: removes unnecessary semicolon

Pratyush Anand (2):
      usb: dwc3: gadget: correct missed isoc when endpoint is busy
      usb: dwc3: gadget: Fix dwc3_stop_active_transfer for synchronization delay

Ramneek Mehresh (1):
      fsl/usb: Add support for USB controller version 2.4

Rene Buergel (4):
      USB: ezusb: remove dependancy on usb_serial
      USB: ezusb: add support for Cypress FX2LP
      USB: ezusb: add functions for firmware download
      USB: ezusb: move ezusb.c from drivers/usb/serial to drivers/usb/misc

Richard Zhao (7):
      USB: chipidea: add imx usbmisc support
      USB: chipidea: imx: add pinctrl support
      USB: chipidea: delay 2ms before read ID status at probe time
      USB: chipidea: acknowledge ID change interrupt in irq handler
      USB: chipidea: add vbus detect for udc
      USB: chipidea: add -DDEBUG if debugging is enabled
      USB: chipidea: re-order irq handling to avoid unhandled irqs

Roger Quadros (2):
      usb: musb: use DMA mode 1 whenever possible
      usb: musb: Remove redundant if statement

Roland Stigge (6):
      usb: phy: isp1301: Remove unused static array and define
      usb: gadget: lpc32xx_udc: Port to new start/stop interface
      usb: gadget: lpc32xx_udc: Remove usb_endpoint_descriptor
      usb: gadget: lpc32xx_udc: Support multiple controllers
      USB: isp1301: Remove unused static array and define
      usb: ohci: Fix Kconfig dependency on USB_ISP1301

Sachin Kamat (9):
      usb: gadget: s3c2410_udc: Replace <asm/io.h> with <linux/io.h>
      usb: gadget: s3c2410_udc: Use pr_* and dev_err functions
      usb: gadget: s3c2410_udc: Silence checkpatch errors and warnings
      usb: gadget: s3c2410_udc: Move assignment outside if condition
      usb: gadget: s3c2410_udc: Do not use integer for NULL
      usb: gadget: s3c-hsudc: Use devm_* functions
      usb: gadget: s3c-hsudc: Add missing braces around sizeof
      usb: gadget: s3c-hsudc: Replace 0 with NULL for pointers
      usb: gadget: s3c-hsotg: Use devm_clk_get function

Sarah Sharp (1):
      xhci: Intel Panther Point BEI quirk.

Sebastian Andrzej Siewior (36):
      usb: remove libusual
      staging: ccg: Add a note about compatibility issues.
      usb: gadget: move bind callback into driver struct usb_composite_driver
      usb: gadget: remove __devexit in f_uac2
      usb: gadget: push all usb_composite_driver structs into __refdata
      usb: gadget: move bind() callback back to struct usb_composite_driver
      usb: gadget: move bind() callback back to struct usb_gadget_driver
      staging: ccg: include all sourced files
      usb: gadget: remove global variable composite in composite.c
      usb: gadget: pxa25x: make it compile with debug again
      usb: gadget: start with libcomposite
      usb: gadget: libcomposite: move config.c into libcomposite
      usb: gadget: move global vars from epautoconf into struct usb_gadget
      usb: gadget: libcomposite: add epautoconf.c to libcomposite
      usb: gadget: move USB_BUFSIZ into global composite.h
      usb: gadget: remove bufsiz from struct usb_composite_dev
      usb: gadget: make composite module options readonly only
      usb: gadget: use usb_string_ids_tab instead multiple usb_string_id()
      usb: gadget: make g_printer enumerate again
      usb: gadget: initialize the strings in tcm_usb_gadget properly
      usb: gadget: move usb_gadget_controller_number() into a .c file and libcomposite
      usb: gadget: push VID/PID/USB BCD module option into gadgets
      usb: gadget: make sure each gadget is using same index for Product, Serial,…
      usb: gadget: push iSerialNumber into gadgets
      usb: gadget: push iManufacturer into gadgets
      usb: gadget: push iProduct into gadgets
      usb: gadget: remove string override from struct usb_composite_driver
      usb: gadget: Provide a default implementation of default manufacturer string
      usb: gadget: libcomposite: move composite.c into libcomposite
      usb: gadget: libcomposite: move MODULE_VERSION to composite.c
      usb: gadget: remove usb_gadget_controller_number()
      usb: gadget: add module.h to u_ether.c
      usb: gadget serial: don't shift bcd version left by 16
      tools/usb: remove last USBFS user
      usb/core: use bin2bcd() for bcdDevice in RH
      usb/xhci: update a comment regarding the BOS descriptor to reflect the code

Sergei Shtylyov (2):
      usb: musb: gadget: use variables according to their names in rxstate()
      usb: musb: core: fix kernel-doc of musb_init_controller()

Shengzhou Liu (2):
      powerpc/usb: fix bug of CPU hang when missing USB PHY clock
      powerpc/usb: remove checking PHY_CLK_VALID for UTMI PHY

Shimoda, Yoshihiro (2):
      usb: renesas_usbhs: modify the irq handler for sharing irq
      usb: renesas_usbhs: modify the irq handler for sharing irq

Shubhrajyoti D (3):
      usb: otg: Remove the unneeded NULL check
      usb: musb: Prevent the masking of the return value
      usb: musb: Make dma_controller_create __devinit

Tim Gardner (2):
      USB: storage: ene_ub6250: Use macros for firmware names
      USB: atm: ueagle-atm: Declare MODULE_FIRMWARE usage

Tony Prisk (2):
      ARM: vt8500: Update vt8500-ehci driver to support device tree.
      ARM: vt8500: Add support for UHCI companion controller

Venu Byravarasu (3):
      usb: otg: Move phy interface to separate file.
      usb: move phy driver from mach-tegra to drivers/usb
      usb: phy: fix build break

Virupax Sadashivpetimath (1):
      usb: musb: host: Handle highmem in PIO mode

Vivek Gautam (1):
      usb: host: xhci: Fix Null pointer dereferencing with 71c731a for non-x86 systems

Wei Yongjun (7):
      usb: gadget: remove duplicated include from pxa25x_udc.c
      USB: mos7720: fix to use list_for_each_entry_safe() when delete items
      usb: cdc-acm: remove duplicated include from cdc-acm.c
      USB: FHCI: use list_move_tail instead of list_del/list_add_tail
      USB: cp210x: remove useless set memory to zero use memset()
      usb: gadget: at91_udc: move the dereference below the NULL test
      usb: otg: move the dereference below the NULL test

Ying Xue (1):
      USB: ftdi_sio: Quiet sparse noise about using plain integer was NULL pointer

Yu Xu (1):
      usb: phy: mv_u3d: Add usb phy driver for mv_u3d

Yunfan Zhang (1):
      usb: gadget: mv_udc: fix hang when shutdown

 Documentation/ABI/testing/sysfs-bus-usb                                     |    7 +
 Documentation/devicetree/bindings/usb/am33xx-usb.txt                        |   14 +
 Documentation/devicetree/bindings/usb/ci13xxx-imx.txt                       |    5 +
 Documentation/devicetree/bindings/usb/omap-usb.txt                          |   33 +
 Documentation/devicetree/bindings/usb/platform-uhci.txt                     |   12 +
 Documentation/devicetree/bindings/usb/pxa-usb.txt                           |   31 +
 Documentation/devicetree/bindings/usb/twlxxxx-usb.txt                       |   40 +
 Documentation/devicetree/bindings/usb/usb-phy.txt                           |   17 +
 Documentation/devicetree/bindings/usb/usbmisc-imx.txt                       |   14 +
 Documentation/devicetree/bindings/usb/vt8500-ehci.txt                       |   12 +
 Documentation/feature-removal-schedule.txt                                  |   11 -
 Documentation/usb/persist.txt                                               |    3 +
 arch/arm/mach-omap2/board-omap3evm.c                                        |    1 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c                                  |    6 +
 arch/arm/mach-omap2/omap_phy_internal.c                                     |  138 --
 arch/arm/mach-omap2/twl-common.c                                            |    5 -
 arch/arm/mach-omap2/usb-musb.c                                              |    3 -
 arch/arm/mach-tegra/Makefile                                                |    1 -
 arch/arm/mach-tegra/devices.c                                               |    2 +-
 arch/arm/mach-tegra/devices.h                                               |    2 +-
 arch/arm/mach-vt8500/bv07.c                                                 |    1 +
 arch/arm/mach-vt8500/devices-vt8500.c                                       |    5 +
 arch/arm/mach-vt8500/devices-wm8505.c                                       |    4 +
 arch/arm/mach-vt8500/devices.c                                              |   11 +
 arch/arm/mach-vt8500/devices.h                                              |    1 +
 arch/arm/mach-vt8500/wm8505_7in.c                                           |    1 +
 drivers/block/Kconfig                                                       |   12 -
 drivers/block/Makefile                                                      |    1 -
 drivers/block/ub.c                                                          | 2474 ---------------------------
 drivers/staging/ccg/Kconfig                                                 |    5 +
 drivers/staging/ccg/Makefile                                                |    2 -
 drivers/staging/ccg/ccg.c                                                   |   29 +-
 drivers/staging/ccg/composite.c                                             | 1688 ++++++++++++++++++
 drivers/staging/ccg/composite.h                                             |  395 +++++
 drivers/staging/ccg/config.c                                                |  158 ++
 drivers/staging/ccg/epautoconf.c                                            |  393 +++++
 drivers/staging/ccg/f_acm.c                                                 |  814 +++++++++
 drivers/staging/ccg/f_fs.c                                                  | 2455 ++++++++++++++++++++++++++
 drivers/staging/ccg/f_mass_storage.c                                        | 3135 ++++++++++++++++++++++++++++++++++
 drivers/staging/ccg/f_rndis.c                                               |  918 ++++++++++
 drivers/staging/ccg/gadget_chips.h                                          |  150 ++
 drivers/staging/ccg/ndis.h                                                  |   47 +
 drivers/staging/ccg/rndis.c                                                 | 1175 +++++++++++++
 drivers/staging/ccg/rndis.h                                                 |  222 +++
 drivers/staging/ccg/storage_common.c                                        |  893 ++++++++++
 drivers/staging/ccg/u_ether.c                                               |  986 +++++++++++
 drivers/staging/ccg/u_ether.h                                               |  154 ++
 drivers/staging/ccg/u_serial.c                                              | 1341 +++++++++++++++
 drivers/staging/ccg/u_serial.h                                              |   65 +
 drivers/staging/ccg/usbstring.c                                             |   71 +
 drivers/staging/keucr/usb.c                                                 |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c                                     |  158 +-
 drivers/staging/usbip/usbip_common.c                                        |    3 +-
 drivers/usb/Kconfig                                                         |    1 +
 drivers/usb/atm/ueagle-atm.c                                                |   79 +-
 drivers/usb/atm/usbatm.c                                                    |   46 +-
 drivers/usb/chipidea/Kconfig                                                |    1 -
 drivers/usb/chipidea/Makefile                                               |    4 +-
 drivers/usb/chipidea/ci.h                                                   |    1 +
 drivers/usb/chipidea/ci13xxx_imx.c                                          |   71 +
 drivers/usb/chipidea/ci13xxx_imx.h                                          |   28 +
 drivers/usb/chipidea/core.c                                                 |   24 +-
 drivers/usb/chipidea/udc.c                                                  |   39 +-
 drivers/usb/chipidea/usbmisc_imx6q.c                                        |  162 ++
 drivers/usb/class/cdc-acm.c                                                 |    1 -
 drivers/usb/core/Kconfig                                                    |    2 +-
 drivers/usb/core/config.c                                                   |    2 +
 drivers/usb/core/devices.c                                                  |    9 +-
 drivers/usb/core/devio.c                                                    |   35 +
 drivers/usb/core/driver.c                                                   |   11 +-
 drivers/usb/core/endpoint.c                                                 |   10 +-
 drivers/usb/core/hcd.c                                                      |   28 +-
 drivers/usb/core/hub.c                                                      |  214 ++-
 drivers/usb/core/message.c                                                  |    2 -
 drivers/usb/core/quirks.c                                                   |    2 +-
 drivers/usb/core/sysfs.c                                                    |   12 +-
 drivers/usb/core/usb-acpi.c                                                 |  205 ++-
 drivers/usb/core/usb.h                                                      |   13 +
 drivers/usb/dwc3/Kconfig                                                    |    2 -
 drivers/usb/dwc3/core.c                                                     |   18 +-
 drivers/usb/dwc3/core.h                                                     |    7 +-
 drivers/usb/dwc3/dwc3-exynos.c                                              |   66 +
 drivers/usb/dwc3/dwc3-omap.c                                                |   66 +
 drivers/usb/dwc3/dwc3-pci.c                                                 |   67 +
 drivers/usb/dwc3/ep0.c                                                      |  217 +--
 drivers/usb/dwc3/gadget.c                                                   |  101 +-
 drivers/usb/early/ehci-dbgp.c                                               |   17 +-
 drivers/usb/gadget/Kconfig                                                  |   78 +-
 drivers/usb/gadget/Makefile                                                 |    4 +
 drivers/usb/gadget/acm_ms.c                                                 |   55 +-
 drivers/usb/gadget/amd5536udc.c                                             |    6 +-
 drivers/usb/gadget/at91_udc.c                                               |    5 +-
 drivers/usb/gadget/audio.c                                                  |   62 +-
 drivers/usb/gadget/bcm63xx_udc.c                                            | 2464 ++++++++++++++++++++++++++
 drivers/usb/gadget/cdc2.c                                                   |   56 +-
 drivers/usb/gadget/composite.c                                              |  290 ++--
 drivers/usb/gadget/config.c                                                 |    6 +-
 drivers/usb/gadget/dbgp.c                                                   |   11 +-
 drivers/usb/gadget/dummy_hcd.c                                              |    2 +
 drivers/usb/gadget/epautoconf.c                                             |   33 +-
 drivers/usb/gadget/ether.c                                                  |   61 +-
 drivers/usb/gadget/f_ecm.c                                                  |    5 +-
 drivers/usb/gadget/f_hid.c                                                  |    2 +-
 drivers/usb/gadget/f_mass_storage.c                                         |   16 +-
 drivers/usb/gadget/f_midi.c                                                 |    1 -
 drivers/usb/gadget/f_ncm.c                                                  |    5 +-
 drivers/usb/gadget/f_sourcesink.c                                           |    2 +-
 drivers/usb/gadget/f_subset.c                                               |    5 +-
 drivers/usb/gadget/f_uac2.c                                                 |    2 +-
 drivers/usb/gadget/file_storage.c                                           |   38 +-
 drivers/usb/gadget/fsl_udc_core.c                                           |    6 +-
 drivers/usb/gadget/fusb300_udc.c                                            |    4 +-
 drivers/usb/gadget/g_ffs.c                                                  |   26 +-
 drivers/usb/gadget/gadget_chips.h                                           |   96 +-
 drivers/usb/gadget/gmidi.c                                                  |   61 +-
 drivers/usb/gadget/goku_udc.c                                               |    6 +-
 drivers/usb/gadget/hid.c                                                    |   52 +-
 drivers/usb/gadget/inode.c                                                  |   29 +-
 drivers/usb/gadget/lpc32xx_udc.c                                            |  129 +-
 drivers/usb/gadget/m66592-udc.c                                             |    4 +-
 drivers/usb/gadget/mass_storage.c                                           |   39 +-
 drivers/usb/gadget/multi.c                                                  |   42 +-
 drivers/usb/gadget/mv_udc_core.c                                            |   91 +-
 drivers/usb/gadget/ncm.c                                                    |   62 +-
 drivers/usb/gadget/nokia.c                                                  |   58 +-
 drivers/usb/gadget/omap_udc.c                                               |    6 +-
 drivers/usb/gadget/pch_udc.c                                                |    6 +-
 drivers/usb/gadget/printer.c                                                |  173 +-
 drivers/usb/gadget/pxa25x_udc.c                                             |    7 +-
 drivers/usb/gadget/pxa25x_udc.h                                             |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                                             |    6 +-
 drivers/usb/gadget/rndis.c                                                  |   22 +-
 drivers/usb/gadget/s3c-hsotg.c                                              |    8 +-
 drivers/usb/gadget/s3c-hsudc.c                                              |   51 +-
 drivers/usb/gadget/s3c2410_udc.c                                            |  148 +-
 drivers/usb/gadget/serial.c                                                 |   72 +-
 drivers/usb/gadget/tcm_usb_gadget.c                                         |   49 +-
 drivers/usb/gadget/tcm_usb_gadget.h                                         |   11 +-
 drivers/usb/gadget/u_ether.c                                                |    8 +-
 drivers/usb/gadget/udc-core.c                                               |   13 +-
 drivers/usb/gadget/usbstring.c                                              |    3 +-
 drivers/usb/gadget/webcam.c                                                 |   42 +-
 drivers/usb/gadget/zero.c                                                   |   73 +-
 drivers/usb/host/Kconfig                                                    |   40 +-
 drivers/usb/host/ehci-atmel.c                                               |   30 +-
 drivers/usb/host/ehci-au1xxx.c                                              |   20 +-
 drivers/usb/host/ehci-cns3xxx.c                                             |   16 +-
 drivers/usb/host/ehci-dbg.c                                                 |    6 +-
 drivers/usb/host/ehci-fsl.c                                                 |   57 +-
 drivers/usb/host/ehci-fsl.h                                                 |    1 +
 drivers/usb/host/ehci-grlib.c                                               |   18 +-
 drivers/usb/host/ehci-hcd.c                                                 |    4 +-
 drivers/usb/host/ehci-hub.c                                                 |    4 +-
 drivers/usb/host/ehci-ixp4xx.c                                              |   19 +-
 drivers/usb/host/ehci-ls1x.c                                                |   20 +-
 drivers/usb/host/ehci-msm.c                                                 |   13 +-
 drivers/usb/host/ehci-mv.c                                                  |   51 +-
 drivers/usb/host/ehci-mxc.c                                                 |   45 +-
 drivers/usb/host/ehci-platform.c                                            |   50 +-
 drivers/usb/host/ehci-ppc-of.c                                              |   28 +-
 drivers/usb/host/ehci-s5p.c                                                 |    7 +-
 drivers/usb/host/ehci-sead3.c                                               |   15 +-
 drivers/usb/host/ehci-sh.c                                                  |   35 +-
 drivers/usb/host/ehci-tegra.c                                               |   57 +-
 drivers/usb/host/ehci-timer.c                                               |    6 +-
 drivers/usb/host/ehci-vt8500.c                                              |   24 +-
 drivers/usb/host/ehci-xilinx-of.c                                           |   20 +-
 drivers/usb/host/fhci-sched.c                                               |    3 +-
 drivers/usb/host/fsl-mph-dr-of.c                                            |    2 +
 drivers/usb/host/ohci-at91.c                                                |    3 +-
 drivers/usb/host/ohci-nxp.c                                                 |    2 +-
 drivers/usb/host/ohci-platform.c                                            |   46 +-
 drivers/usb/host/ohci-pxa27x.c                                              |   68 +
 drivers/usb/host/ohci-xls.c                                                 |    2 +-
 drivers/usb/host/r8a66597-hcd.c                                             |    5 +-
 drivers/usb/host/sl811-hcd.c                                                |    2 +-
 drivers/usb/host/uhci-hcd.c                                                 |    5 +
 drivers/usb/host/uhci-platform.c                                            |  157 ++
 drivers/usb/host/whci/hcd.c                                                 |    8 +-
 drivers/usb/host/whci/qset.c                                                |   11 +-
 drivers/usb/host/xhci-hub.c                                                 |   20 +-
 drivers/usb/host/xhci-mem.c                                                 |    7 +
 drivers/usb/host/xhci-pci.c                                                 |    1 +
 drivers/usb/host/xhci-ring.c                                                |  290 +++-
 drivers/usb/host/xhci.c                                                     |   43 +-
 drivers/usb/host/xhci.h                                                     |   20 +
 drivers/usb/misc/Kconfig                                                    |    5 +
 drivers/usb/misc/Makefile                                                   |    1 +
 drivers/usb/misc/ezusb.c                                                    |  160 ++
 drivers/usb/misc/legousbtower.c                                             |    3 -
 drivers/usb/misc/rio500.c                                                   |    2 +-
 drivers/usb/musb/Kconfig                                                    |    3 +-
 drivers/usb/musb/am35x.c                                                    |   67 +-
 drivers/usb/musb/blackfin.c                                                 |   64 +-
 drivers/usb/musb/cppi_dma.c                                                 |    2 +-
 drivers/usb/musb/da8xx.c                                                    |   59 +-
 drivers/usb/musb/davinci.c                                                  |   67 +-
 drivers/usb/musb/musb_core.c                                                |  331 ++--
 drivers/usb/musb/musb_core.h                                                |   17 +-
 drivers/usb/musb/musb_debugfs.c                                             |    8 +-
 drivers/usb/musb/musb_dma.h                                                 |    2 +-
 drivers/usb/musb/musb_dsps.c                                                |  194 ++-
 drivers/usb/musb/musb_gadget.c                                              |  172 +-
 drivers/usb/musb/musb_host.c                                                |  264 ++-
 drivers/usb/musb/musb_host.h                                                |    3 +
 drivers/usb/musb/musb_virthub.c                                             |   13 +-
 drivers/usb/musb/musbhsdma.c                                                |    2 +-
 drivers/usb/musb/omap2430.c                                                 |  156 +-
 drivers/usb/musb/omap2430.h                                                 |    9 +
 drivers/usb/musb/tusb6010.c                                                 |   57 +-
 drivers/usb/musb/tusb6010_omap.c                                            |    2 +-
 drivers/usb/musb/ux500.c                                                    |   33 +-
 drivers/usb/musb/ux500_dma.c                                                |    2 +-
 drivers/usb/otg/Kconfig                                                     |    2 +-
 drivers/usb/otg/fsl_otg.c                                                   |   34 +-
 drivers/usb/otg/mxs-phy.c                                                   |   38 +-
 drivers/usb/otg/nop-usb-xceiv.c                                             |    8 +-
 drivers/usb/otg/otg.c                                                       |    2 +-
 drivers/usb/otg/twl4030-usb.c                                               |   26 +-
 drivers/usb/otg/twl6030-usb.c                                               |  157 +-
 drivers/usb/phy/Kconfig                                                     |   17 +
 drivers/usb/phy/Makefile                                                    |    3 +
 drivers/usb/phy/isp1301.c                                                   |    6 -
 drivers/usb/phy/mv_u3d_phy.c                                                |  345 ++++
 drivers/usb/phy/mv_u3d_phy.h                                                |  105 ++
 drivers/usb/phy/omap-usb2.c                                                 |  271 +++
 arch/arm/mach-tegra/usb_phy.c => drivers/usb/phy/tegra_usb_phy.c            |  152 +-
 drivers/usb/renesas_usbhs/common.c                                          |   15 +-
 drivers/usb/renesas_usbhs/mod.c                                             |   25 +-
 drivers/usb/serial/Kconfig                                                  |   21 +-
 drivers/usb/serial/Makefile                                                 |    2 +-
 drivers/usb/serial/aircable.c                                               |    5 -
 drivers/usb/serial/ark3116.c                                                |    7 +-
 drivers/usb/serial/belkin_sa.c                                              |    8 +-
 drivers/usb/serial/ch341.c                                                  |   49 +-
 drivers/usb/serial/console.c                                                |   23 +-
 drivers/usb/serial/cp210x.c                                                 |  141 +-
 drivers/usb/serial/cyberjack.c                                              |   77 +-
 drivers/usb/serial/cypress_m8.c                                             |  157 +-
 drivers/usb/serial/digi_acceleport.c                                        |   50 +-
 drivers/usb/serial/empeg.c                                                  |    5 -
 drivers/usb/serial/ezusb.c                                                  |   59 -
 drivers/usb/serial/f81232.c                                                 |    8 +-
 drivers/usb/serial/ftdi_sio.c                                               |  138 +-
 drivers/usb/serial/ftdi_sio_ids.h                                           |    5 +
 drivers/usb/serial/funsoft.c                                                |    5 -
 drivers/usb/serial/garmin_gps.c                                             |  129 +-
 drivers/usb/serial/generic.c                                                |   11 +-
 drivers/usb/serial/io_edgeport.c                                            |  616 +++----
 drivers/usb/serial/io_ti.c                                                  |  408 ++---
 drivers/usb/serial/ipaq.c                                                   |    4 -
 drivers/usb/serial/ipw.c                                                    |   66 +-
 drivers/usb/serial/ir-usb.c                                                 |   16 +-
 drivers/usb/serial/iuu_phoenix.c                                            |  134 +-
 drivers/usb/serial/keyspan.c                                                |  338 ++--
 drivers/usb/serial/keyspan.h                                                |   17 +-
 drivers/usb/serial/keyspan_pda.c                                            |   73 +-
 drivers/usb/serial/kl5kusb105.c                                             |   41 +-
 drivers/usb/serial/kobil_sct.c                                              |   98 +-
 drivers/usb/serial/mct_u232.c                                               |  104 +-
 drivers/usb/serial/metro-usb.c                                              |    7 -
 drivers/usb/serial/mos7720.c                                                |  231 +--
 drivers/usb/serial/mos7840.c                                                |  478 ++----
 drivers/usb/serial/navman.c                                                 |    8 +-
 drivers/usb/serial/omninet.c                                                |   43 +-
 drivers/usb/serial/opticon.c                                                |   30 +-
 drivers/usb/serial/option.c                                                 |   23 +-
 drivers/usb/serial/oti6858.c                                                |   77 +-
 drivers/usb/serial/pl2303.c                                                 |    8 +-
 drivers/usb/serial/qcaux.c                                                  |   10 +-
 drivers/usb/serial/qcserial.c                                               |    5 -
 drivers/usb/serial/quatech2.c                                               |    7 +-
 drivers/usb/serial/safe_serial.c                                            |   12 +-
 drivers/usb/serial/sierra.c                                                 |   11 +-
 drivers/usb/serial/spcp8x5.c                                                |    5 -
 drivers/usb/serial/ssu100.c                                                 |   37 +-
 drivers/usb/serial/symbolserial.c                                           |    8 +-
 drivers/usb/serial/ti_usb_3410_5052.c                                       |  150 +-
 drivers/usb/serial/usb-serial.c                                             |  176 +-
 drivers/usb/serial/usb_wwan.c                                               |   56 +-
 drivers/usb/serial/visor.c                                                  |   13 +-
 drivers/usb/serial/whiteheat.c                                              |  135 +-
 drivers/usb/serial/zte_ev.c                                                 |  307 ++++
 drivers/usb/storage/Kconfig                                                 |   14 -
 drivers/usb/storage/Makefile                                                |    9 +-
 drivers/usb/storage/alauda.c                                                |    2 +-
 drivers/usb/storage/cypress_atacb.c                                         |    2 +-
 drivers/usb/storage/datafab.c                                               |    2 +-
 drivers/usb/storage/ene_ub6250.c                                            |   30 +-
 drivers/usb/storage/freecom.c                                               |    2 +-
 drivers/usb/storage/isd200.c                                                |    5 +-
 drivers/usb/storage/jumpshot.c                                              |    2 +-
 drivers/usb/storage/karma.c                                                 |    2 +-
 drivers/usb/storage/libusual.c                                              |  243 ---
 drivers/usb/storage/onetouch.c                                              |    2 +-
 drivers/usb/storage/realtek_cr.c                                            |    2 +-
 drivers/usb/storage/sddr09.c                                                |    2 +-
 drivers/usb/storage/sddr55.c                                                |    2 +-
 drivers/usb/storage/shuttle_usbat.c                                         |    2 +-
 drivers/usb/storage/sierra_ms.c                                             |    3 +-
 drivers/usb/storage/transport.c                                             |    2 +-
 drivers/usb/storage/uas.c                                                   |  107 +-
 drivers/usb/storage/unusual_devs.h                                          |   36 +-
 drivers/usb/storage/usb.c                                                   |   17 +-
 drivers/usb/storage/usual-tables.c                                          |   18 +-
 drivers/usb/wusbcore/Kconfig                                                |    3 +-
 drivers/usb/wusbcore/security.c                                             |    7 +-
 drivers/usb/wusbcore/wa-hc.c                                                |    4 +-
 drivers/xen/Makefile                                                        |    2 +-
 drivers/xen/dbgp.c                                                          |   48 +
 include/linux/bcd.h                                                         |   17 +-
 include/linux/fsl_devices.h                                                 |    2 +
 include/linux/usb.h                                                         |   32 +-
 include/linux/usb/ch11.h                                                    |    4 +-
 include/linux/usb/composite.h                                               |   97 +-
 include/linux/usb/ehci_def.h                                                |   35 +-
 include/linux/usb/ehci_pdriver.h                                            |    8 +
 include/linux/usb/ezusb.h                                                   |   16 +
 include/linux/usb/gadget.h                                                  |   33 +-
 include/linux/usb/hcd.h                                                     |    4 +-
 include/linux/usb/nop-usb-xceiv.h                                           |   24 +
 include/linux/usb/ohci_pdriver.h                                            |    8 +
 include/linux/usb/omap_usb.h                                                |   46 +
 include/linux/usb/otg.h                                                     |  236 +--
 include/linux/usb/phy.h                                                     |  233 +++
 include/linux/usb/phy_companion.h                                           |   34 +
 include/linux/usb/quirks.h                                                  |    4 +-
 include/linux/usb/serial.h                                                  |   32 +-
 .../mach-tegra/include/mach/usb_phy.h => include/linux/usb/tegra_usb_phy.h  |   16 +-
 include/linux/usb_usual.h                                                   |   24 -
 include/linux/usbdevice_fs.h                                                |   14 +
 include/xen/interface/physdev.h                                             |   16 +
 lib/bcd.c                                                                   |    8 +-
 tools/usb/testusb.c                                                         |   25 +-
 334 files changed, 25613 insertions(+), 9065 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/am33xx-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/platform-uhci.txt
 create mode 100644 Documentation/devicetree/bindings/usb/pxa-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usb-phy.txt
 create mode 100644 Documentation/devicetree/bindings/usb/usbmisc-imx.txt
 create mode 100644 Documentation/devicetree/bindings/usb/vt8500-ehci.txt
 delete mode 100644 drivers/block/ub.c
 create mode 100644 drivers/staging/ccg/composite.c
 create mode 100644 drivers/staging/ccg/composite.h
 create mode 100644 drivers/staging/ccg/config.c
 create mode 100644 drivers/staging/ccg/epautoconf.c
 create mode 100644 drivers/staging/ccg/f_acm.c
 create mode 100644 drivers/staging/ccg/f_fs.c
 create mode 100644 drivers/staging/ccg/f_mass_storage.c
 create mode 100644 drivers/staging/ccg/f_rndis.c
 create mode 100644 drivers/staging/ccg/gadget_chips.h
 create mode 100644 drivers/staging/ccg/ndis.h
 create mode 100644 drivers/staging/ccg/rndis.c
 create mode 100644 drivers/staging/ccg/rndis.h
 create mode 100644 drivers/staging/ccg/storage_common.c
 create mode 100644 drivers/staging/ccg/u_ether.c
 create mode 100644 drivers/staging/ccg/u_ether.h
 create mode 100644 drivers/staging/ccg/u_serial.c
 create mode 100644 drivers/staging/ccg/u_serial.h
 create mode 100644 drivers/staging/ccg/usbstring.c
 create mode 100644 drivers/usb/chipidea/ci13xxx_imx.h
 create mode 100644 drivers/usb/chipidea/usbmisc_imx6q.c
 create mode 100644 drivers/usb/gadget/bcm63xx_udc.c
 create mode 100644 drivers/usb/host/uhci-platform.c
 create mode 100644 drivers/usb/misc/ezusb.c
 create mode 100644 drivers/usb/phy/mv_u3d_phy.c
 create mode 100644 drivers/usb/phy/mv_u3d_phy.h
 create mode 100644 drivers/usb/phy/omap-usb2.c
 rename arch/arm/mach-tegra/usb_phy.c => drivers/usb/phy/tegra_usb_phy.c (94%)
 delete mode 100644 drivers/usb/serial/ezusb.c
 create mode 100644 drivers/usb/serial/zte_ev.c
 delete mode 100644 drivers/usb/storage/libusual.c
 create mode 100644 drivers/xen/dbgp.c
 create mode 100644 include/linux/usb/ezusb.h
 create mode 100644 include/linux/usb/nop-usb-xceiv.h
 create mode 100644 include/linux/usb/omap_usb.h
 create mode 100644 include/linux/usb/phy.h
 create mode 100644 include/linux/usb/phy_companion.h
 rename arch/arm/mach-tegra/include/mach/usb_phy.h => include/linux/usb/tegra_usb_phy.h (86%)
