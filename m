Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162083Ab2CST5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:57:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55288 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030574Ab2CST5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:57:22 -0400
Date: Mon, 19 Mar 2012 12:57:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 3.4-rc1
Message-ID: <20120319195718.GE9883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit fde7d9049e55ab85a390be7f415d74c9f62dd0f9:

  Linux 3.3-rc7 (2012-03-10 13:49:52 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.3

for you to fetch changes up to 11207b6fe05438b2e87a26435cd98db3d55e6fa7:

  net: qmi_wwan: add support for ZTE MF820D (2012-03-16 13:38:45 -0700)

----------------------------------------------------------------
USB merge for 3.4-rc1

Here's the big USB merge for the 3.4-rc1 merge window.

Lots of gadget driver reworks here, driver updates, xhci changes, some
new drivers added, usb-serial core reworking to fix some bugs, and other
various minor things.

There are some patches touching arch code, but they have all been acked
by the various arch maintainers.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (13):
      USB: debugging code shouldn't alter control flow
      SCSI: fix typo in definition of struct scsi_target
      SCSI & usb-storage: add flags for VPD pages and REPORT LUNS
      usb-storage: reorganize target-specific code
      usb-serial: new API for driver registration
      usb-serial: use new registration API in [a-c]* drivers
      usb-serial: use new registration API in [d-h]* drivers
      usb-serial: use new registration API in [i-j]* drivers
      usb-serial: use new registration API in [k-m]* drivers
      usb-serial: use new registration API in [n-p]* drivers
      usb-serial: use new registration API in [q-s]* drivers
      usb-serial: use new registration API in [t-z]* drivers
      usb-serial: use new registration API in staging drivers

Aleksey Babahin (1):
      USB: serial: add metro-usb driver to the tree

Anatolij Gustschin (1):
      usb: ehci-fsl: set INCR8 mode for system bus interface on MPC512x

Andi Kleen (1):
      usb: gadget: f_fs: Remove lock is held before freeing checks

Andiry Xu (10):
      xHCI: BESL calculation based on USB2.0 LPM errata
      xHCI: store ring's type
      xHCI: store ring's last segment and segment numbers
      xHCI: count free TRBs on transfer ring
      xHCI: factor out segments allocation and free function
      xHCI: set cycle state when allocate rings
      xHCI: dynamic ring expansion
      xHCI: Allocate 2 segments for transfer ring
      xHCI: check enqueue pointer advance into dequeue seg
      xHCI: update sg tablesize

Anton Tikhomirov (2):
      usb: dwc3: Add Exynos Specific Glue layer
      usb: dwc3: use proper function for setting endpoint name

Ben Hutchings (2):
      cdc-wdm: Fix more races on the read path
      cdc-wdm: Don't clear WDM_READ unless entire read buffer is emptied

Bjørn Mork (17):
      USB: cdc-wdm: no need to fill the in request URB every time it's submitted
      USB: cdc-wdm: better allocate a buffer that is at least as big as we tell the USB core
      USB: cdc-wdm: no need to use usb_alloc_coherent
      USB: cdc-wdm: kill the now unnecessary bMaxPacketSize0 field and udev variable
      USB: cdc-wdm: Avoid hanging on interface with no USB_CDC_DMM_TYPE
      USB: cdc-wdm: avoid printing odd-looking "cdc-wdm-176" names
      usb: cdc-wdm: Add device-id for Huawei 3G/LTE modems
      usb: cdc-wdm: make reset work with blocking IO
      usb: cdc-wdm: split out reusable parts of probe
      usb: cdc-wdm: adding list lookup indirection
      usb: cdc-wdm: adding usb_cdc_wdm_register subdriver support
      net: usb: qmi_wwan: New driver for Huawei QMI based WWAN devices
      net: qmi_wwan: support devices having a shared QMI/wwan interface
      net: qmi_wwan: add Gobi and Pantech UML290 device IDs
      USB: option: make interface blacklist work again
      USB: option: add ZTE MF820D
      net: qmi_wwan: add support for ZTE MF820D

Bruno Thomsen (1):
      USB: Microchip VID mislabeled as Hornby VID in ftdi_sio.

Chanho Park (1):
      usb: dwc3: use devm_xxx functions

Cyril Roelandt (6):
      usb: amd5536udc: Fix brace coding style issues.
      usb: amd5536udc: Fix coding style issues.
      usb: amd5536udc: Fix indentation
      usb: amd5536udc: use the DEFINE_PCI_DEVICE_TABLE macro
      usb: amd5536udc: Fix the type of ep_string
      usb: amd5536udc: Remove old CVS markers

Dan Carpenter (4):
      usb: gadget: mv_udc: remove unneeded NULL check
      usb: dwc3: make dwc3_get_device_id() return the id
      usb: gadget: dummy_hcd: signedness bug in transfer()
      usb: otg: ab8500-usb: make probe() work again

Dan Williams (1):
      USB: qcserial: don't grab QMI port on Gobi 1000 devices

Daniele Palmas (1):
      USB: option driver: adding support for Telit CC864-SINGLE, CC864-DUAL and DE910-DUAL modems

Danny Kukawka (2):
      usb: at91_udc: linux/prefetch.h included twice
      usb: dwc3: linux/module.h included twice

David Daney (1):
      usb: Don't make USB_ARCH_HAS_{XHCI,OHCI,EHCI} depend on USB_SUPPORT.

Deepak Sikri (1):
      USB: ehci-spear: Add PM support

Donald Lee (1):
      USB: serial: mos7840: Fixed MCS7820 device attach problem

Fabio Baltieri (1):
      usb: gadget: Kconfig: fix typo for 'different'

Felipe Balbi (30):
      usb: musb: make modules behave better
      usb: musb: debugfs: fix error check
      usb: dwc3: gadget: re-factor USB2 test mode to a function
      usb: dwc3: gadget: allow testmodes changes via debugfs
      usb: dwc3: gadget: re-factor Link state change to a function
      usb: dwc3: gadget: allow Link state changes via debugfs
      usb: dwc3: gadget: fix XferNotReady debug print
      usb: dwc3: gadget: use the descriptor pointer we hold
      usb: dwc3: ep0: move to CONFIGURED also on delayed status
      usb: dwc3: gadget: dynamically re-size TxFifos
      usb: dwc3: gadget: start core on Rx.Detect
      usb: dwc3: omap: convert pdata to of property
      usb: dwc3: debugfs: fix error check
      usb: dwc3: host: align on host device name
      usb: dwc3: gadget: avoid memcpy()ing event buffer
      usb: dwc3: gadget: allocate 3 packets for bulk and isoc endpoints
      usb: dwc3: convert TRBs into bitshifts
      usb: host: ehci: allow ehci_* symbols to be unused
      usb: gadget: add generic map/unmap request utilities
      usb: dwc3: gadget: use generic map/unmap routines
      usb: gadget: langwell: use generic map/unmap functions
      usb: renesas: gadget: use generic map/unmap routines
      usb: gadget: amd5536: use generic map/unmap routines
      usb: gadget: r8a66597: use generic map/unmap routines
      usb: gadget: net2272: use generic map/umap routines
      usb: gadget: net2280: use generic map/unmap routines
      usb: gadget: goku: use generic map/unmap routines
      usb: core: hcd: make hcd->irq unsigned
      usb: host: xhci: use __ffs() instead of hardcoding shift
      usb: dwc3: pci: fix another failure path in dwc3_pci_probe()

Gerard Cauvy (2):
      usb: dwc3: debugfs: fix off by one when entering testmode
      usb: dwc3: ep0: fix SetFeature(TEST)

Grazvydas Ignotas (1):
      usb: musb: drop superfluous pm_runtime calls around musb_shutdown

Greg KH (1):
      USB: create module_usb_serial_driver macro

Greg Kroah-Hartman (69):
      Merge tag 'for-uas-next-2012-02-02' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge tag 'usb-3.3-rc3' into usb-next
      Merge branch 'usb-linus' into usb-next
      Merge tag 'for-usb-next-2012-02-14' of git://git.kernel.org/.../sarah/xhci into usb-next
      Merge branch 'usb-3.3-rc4' into usb-next
      usb-serial: use new registration API in keyspan_pda.c
      USB: serial: remove usb_serial_register and usb_serial_deregister
      USB: ftdi_sio: fix problem when the manufacture is a NULL string
      USB: serial: quatech_usb2.c: use module_usb_serial_driver
      USB: serial: serqt_usb2.c: use module_usb_serial_driver
      USB: serial: aircable.c: use module_usb_serial_driver
      USB: serial: ark3116.c: use module_usb_serial_driver
      USB: serial: belkin_sa.c: use module_usb_serial_driver
      USB: serial: ch341.c: use module_usb_serial_driver
      USB: serial: cp210x.c: use module_usb_serial_driver
      USB: serial: cyberjack.c: use module_usb_serial_driver
      USB: serial: cypress_m8.c: use module_usb_serial_driver
      USB: serial: digi_acceleport.c: use module_usb_serial_driver
      USB: serial: empeg.c: use module_usb_serial_driver
      USB: serial: funsoft.c: use module_usb_serial_driver
      USB: serial: garmin_gps.c: use module_usb_serial_driver
      USB: serial: hp4x.c: use module_usb_serial_driver
      USB: serial: io_edgeport.c: use module_usb_serial_driver
      USB: serial: io_ti.c: use module_usb_serial_driver
      USB: serial: ipw.c: use module_usb_serial_driver
      USB: serial: iuu_phoenix.c: use module_usb_serial_driver
      USB: serial: keyspan.c: use module_usb_serial_driver
      USB: serial: keyspan_pda.c: use module_usb_serial_driver
      USB: serial: kl5kusb105.c: use module_usb_serial_driver
      USB: serial: kobil_sct.c: use module_usb_serial_driver
      USB: serial: mct_u232.c: use module_usb_serial_driver
      USB: serial: mos7720.c: use module_usb_serial_driver
      USB: serial: mos7840.c: use module_usb_serial_driver
      USB: serial: moto_modem.c: use module_usb_serial_driver
      USB: serial: navman.c: use module_usb_serial_driver
      USB: serial: omninet.c: use module_usb_serial_driver
      USB: serial: opticon.c: use module_usb_serial_driver
      USB: serial: option.c: use module_usb_serial_driver
      USB: serial: oti6858.c: use module_usb_serial_driver
      USB: serial: qcaux.c: use module_usb_serial_driver
      USB: serial: qcserial.c: use module_usb_serial_driver
      USB: serial: siemens_mpi.c: use module_usb_serial_driver
      USB: serial: sierra.c: use module_usb_serial_driver
      USB: serial: spcp8x5.c: use module_usb_serial_driver
      USB: serial: ssu100.c: use module_usb_serial_driver
      USB: serial: symbolserial.c: use module_usb_serial_driver
      USB: serial: usb_debug.c: use module_usb_serial_driver
      USB: serial: vivopay-serial.c: use module_usb_serial_driver
      USB: serial: whiteheat.c: use module_usb_serial_driver
      USB: serial: zio.c: use module_usb_serial_driver
      USB: serial: add Fintek F81232 usb to serial driver
      Revert "powerpc/usb: fix usb CTRL_PHY_CLK_VALID breaks on some platform"
      Merge tag 'musb-for-v3.4' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'xceiv-for-v3.4' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'gadget-for-v3.4' of git://git.kernel.org/.../balbi/usb into usb-next
      Merge tag 'dwc3-for-v3.4' of git://git.kernel.org/.../balbi/usb into usb-next
      USB: serial: metro-usb: fix up usb_serial_register calls
      USB: serial: metro-usb: add to the build
      USB: serial: metro-usb: remove vendor and product module parameters
      USB: serial: metro-usb: convert to use module_usb_serial_driver
      USB: serial: metro-usb: remove the .h file
      USB: serial: metro-usb: fix up coding style errors
      USB: serial: metro-usb: remove function prototypes
      USB: serial: metro-usb: remove function header comments
      USB: serial: metro-usb: remove unneeded cast and function call
      USB: serial: metro-usb: move to use dev_dbg() instead of dbg()
      USB: serial: use module_driver() macro
      Merge 3.3-rc7 into usb-next
      Merge tag 'for-usb-next-2012-03-13' of git://git.kernel.org/.../sarah/xhci into usb-next

Guennadi Liakhovetski (2):
      usb: renesas_usbhs: (cosmetic) simplify list operations
      usb: renesas: fix scheduling in atomic context bug

Hauke Mehrtens (3):
      USB: OHCI: Add a generic platform device driver
      USB: EHCI: Add a generic platform device driver
      USB: use generic platform driver on ath79

Heikki Krogerus (19):
      usb: otg: Rename otg_transceiver to usb_phy
      usb: otg: Rename usb_xceiv_event to usb_phy_event
      usb: otg: Separate otg members from usb_phy
      usb: otg: ab8500: Start using struct usb_otg
      usb: otg: fsl: Start using struct usb_otg
      usb: otg: gpio_vbus: Start using struct usb_otg
      usb: otg: isp1301_omap: Start using struct usb_otg
      usb: otg: msm: Start using struct usb_otg
      usb: otg: nop: Start using struct usb_otg
      usb: otg: twl4030: Start using struct usb_otg
      usb: otg: twl6030: Start using struct usb_otg
      usb: otg: ulpi: Start using struct usb_otg
      arm: imx: Start using struct usb_otg
      usb: musb: Start using struct usb_otg
      power_supply: Convert all users to new usb_phy
      usb: otg: mv_otg: Start using struct usb_otg
      usb: Convert all users to new usb_phy
      usb: otg: Remove OTG specific members from usb_phy
      usb: otg: Convert all users to pass struct usb_otg for OTG functions

Heiko Stübner (2):
      usb: s3c-hsudc: Use helper functions instead of generic container_of
      usb: s3c-hsudc: add basic runtime_pm calls

Huajun Li (3):
      usb: Disable dynamic id of USB storage subdrivers
      usb: Re-enable usb-storage support dynamic id
      USB: dynamically allocate usb_device children pointers instead of using a fix array

Ido Shayevitz (1):
      usb: gadget: Clear usb_endpoint_descriptor inside the struct usb_ep on disable

Jassi Brar (4):
      usb: gadget: Rename audio function to uac1
      usb: uac2: Add ACHeader and FormatType descriptor
      usb: gadget: audio: Move string IDs to audio.c
      usb: gadget: Add Audio Class 2.0 Driver

Jesper Juhl (1):
      Allocate correct size (portably) in drivers/usb/gadget/f_midi.c::f_midi_bind()

Jim Paris (1):
      USB: ftdi_sio: add support for FT-X series devices

Jingoo Han (2):
      USB: ohci-exynos: replace hcd->state with ohci->rh_state
      USB: ehci-s5p: add DMA burst support

Johan Hovold (5):
      USB: cp210x: fix debug output
      USB: serial: add macro for console error reporting
      USB: serial: fix console error reporting
      USB: serial: use dev_err_console in generic write
      USB: serial: use dev_err_console in custom write paths

Kelvin Cheung (1):
      USB: Add EHCI bus glue for Loongson1x SoCs (UPDATED)

Kuninori Morimoto (1):
      usb: renesas_usbhs: bugfix: add .release function to gpriv->gadget.dev

Lars-Peter Clausen (1):
      driver-core: Allow additional parameters for module_driver

Lothar Waßmann (1):
      usb gadget: fix a section mismatch when compiling g_ffs with CONFIG_USB_FUNCTIONFS_ETH

Masanari Iida (2):
      usb: Fix typo in imx21-dbg.c
      usb: Fix typo in ehci-dbg.c

Matthew Garrett (2):
      usb: Add support for indicating whether a port is removable
      usb: Use hub port data to determine whether a port is removable

Meng Zhang (1):
      USB: option: Add MediaTek MT6276M modem&app interfaces

Michal Nazarewicz (1):
      usb: gadget: update Michal Nazarewicz's email address

Michał Wróbel (2):
      USB: ftdi_sio: new PID: Distortec JTAG-lock-pick
      USB: ftdi_sio: new PID: LUMEL PD12

Neil Zhang (2):
      usb: host: remove ehci-pxa168.c
      usb: host: add dependence for USB_EHCI_MV

Oliver Neukum (3):
      USB: code cleanup in suspend/resume path (3rd try)
      USB: cleanup the handling of the PM complete call
      USB: allow users to run setserial with cdc-acm

Orjan Friberg (1):
      USB: gadget: Make g_hid device class conform to spec.

Pan Jiafei (1):
      USB: ehci-fsl: Turn on cache snooping on MPC8xxx

Paul Gortmaker (1):
      usb: fix defined but not used warnings in hcd-pci.c

Paul Zimmerman (8):
      usb: dwc3: clean up whitespace damage, typos, missing parens, etc.
      usb: dwc3: gadget: don't wrap around the TRB poll on non-ISOC
      usb: dwc3: fix bogus test in dwc3_gadget_start_isoc
      usb: dwc3: replace hard-coded constant in DWC3_GCTL_SCALEDOWN(3)
      usb: dwc3: pci: fix failure path in dwc3_pci_probe()
      usb: dwc3: shorten long delay in dwc3_gadget_set_link_state()
      usb: dwc3: take lock while modifying flags
      usb: dwc3: clear 'res_trans_idx' as soon as it becomes invalid

Peter Chen (2):
      usb: fsl_udc_core: Fix scheduling while atomic dump message
      usb: Fix build error due to dma_mask is not at pdev_archdata at ARM

Peter Korsgaard (1):
      USB: ftdi_sio: add support for BeagleBone rev A5+

Philipp Zabel (1):
      USB: ohci-pxa27x: add clk_prepare/clk_unprepare calls

Praveena Nadahally (1):
      usb: gadget: Add Interface Association Descriptor to ECM

Preston Fick (1):
      usb: cp210x: Update to support CP2105 and multiple interface devices

Rob Herring (1):
      usb: ohci-pxa27x: add explicit include of hardware.h

Roland Stigge (4):
      USB: OHCI-HCD: Rename ohci-pnx4008 to ohci-nxp
      USB: ohci-nxp: Rename symbols from pnx4008 to nxp
      USB: ohci-nxp: Support for LPC32xx
      USB: ohci-nxp: Remove i2c_write(), use smbus

Sarah Sharp (12):
      UAS: Re-add workqueue items if submission fails.
      UAS: Use unique tags on non-streams devices.
      UAS: Free status URB when we can't find the SCSI tag.
      Merge tag 'uas_for_sarah' of git://linutronix.de/users/bigeasy/linux into for-uas-next
      xHCI: Kick khubd when USB3 resume really completes.
      USB/xhci: Enable remote wakeup for USB3 devices.
      USB: Suspend functions before putting dev into U3.
      USB/xHCI: Enable USB 3.0 hub remote wakeup.
      USB: Refactor hub remote wake handling.
      USB/xHCI: Support device-initiated USB 3.0 resume.
      USB: Set wakeup bits for all children hubs.
      USB: Turn on auto-suspend for USB 3.0 hubs.

Scott Dial (1):
      usb-serial: Add support for the Sealevel SeaLINK+8 2038-ROHS device

Sebastian Andrzej Siewior (28):
      usb/uas: use unique tags for all LUNs
      usb/uas: use scsi_host_find_tag() to find command from a tag
      usb/uas: one only one status URB/host on stream-less connection
      usb: gadget: dummy_hcd: initialize max_streams early
      usb: gadget: dummy_hcd: move the transfer part into its own function
      usb: gadget: dummy_hcd: add sg support
      usb: gadget: dummy_hcd: rename dummy_udc_udpate_ep0() to dummy_udc_update_ep0()
      usb: gadget: dummy_hcd: make alloc/free streams static
      usb: gadget: dummy_hcd: complete stream support
      usb: dummy_hcd: use usb_endpoint_type()
      usb: gadget: dummy_hcd: clean up checkpatch
      usb: gadget: f_mass_storage: remove one FSG_NO_INTR_EP
      usb/uhci: initialize sg_table properly
      usb/uas: only bind if the hcd supports SG
      usb/uas: move UAS structs / defines into a header file
      usb/uas: add usb_pipe_usage_descriptor
      usb/uas: make sure data urb is gone if we receive status before that
      usb: gadget: dummy_hcd: don't assign ->desc on error case
      usb: gadget: dummy_hcd: fix null-deref free req
      usb: gadget: clean the ep in autoconf before returning it.
      usb: gadget: add usb3.0 descriptors to serial gadgets
      usb/storage: a couple defines from drivers/usb/storage/transport.h to include/linux/usb/storage.h
      usb/storage: redefine US_BULK_FLAG_IN and use it
      usb/gadget: use common defines within the storage gadget
      usb/storage: remove Filler member from struct bulk_cs_wrap
      usb/core: remove "always" from usb_unlink_urb() kernel doc entry
      usb: host: xhci: add platform driver support
      usb/ub: deprecate & schedule for removal the "Low Performance USB Block" driver

Shengzhou Liu (2):
      powerpc/usb: fix bug of kernel hang when initializing usb
      powerpc/usb: fix usb CTRL_PHY_CLK_VALID breaks on some platform

Shimoda, Yoshihiro (2):
      usb: renesas_usbhs: add IRQ resource decoding for IRQF_SHARED
      usb: renesas_usbhs: add support for SUDMAC

Supriya Karanth (1):
      usb: musb: Reselect index reg in interrupt context

Thomas Faber (1):
      usb: gadgetfs: return number of bytes on ep0 read request

Tobias Klauser (5):
      usb: isp1362-hcd: Convert to module_platform_driver
      usb: dwc3: core: Convert to module_platform_driver
      usb: isp116x-hcd: Convert to module_platform_driver
      usb: r8a66597-hcd: Convert to module_platform_driver
      usb: sl811-hcd: Convert to module_platform_driver

Tomoya MORINAGA (9):
      usb: gadget: pch_udc: Fix disconnect issue
      usb: gadget: pch_udc: Fix wrong return value
      usb: gadget: pch_udc: Fix USB suspend issue
      usb: gadget: pch_udc: Fix usb/gadget/pch_udc: Fix ether gadget connect/disconnect issue
      usb: gadget: pch_udc: Reduce redundant interrupt
      usb: gadget: pch_udc: Add debug message
      usb: gadget: pch_udc: Detecting VBUS through GPIO
      usb: gadget: pch_udc: Detecting VBUS through GPIO with interrupt
      usb/gadget/pch_udc: Fix compile error

jwboyer@redhat.com (1):
      USB: ums_realtek: do not use stack memory for DMA in __do_config_autodelink

 Documentation/ABI/testing/sysfs-bus-usb         |   11 +
 Documentation/feature-removal-schedule.txt      |   11 +
 Documentation/i2c/instantiating-devices         |    6 +-
 arch/arm/mach-imx/mx31moboard-devboard.c        |   24 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c         |   24 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c                 |   20 +-
 arch/arm/mach-tegra/include/mach/usb_phy.h      |    2 +-
 arch/arm/mach-tegra/usb_phy.c                   |    4 +-
 arch/arm/plat-mxc/include/mach/mxc_ehci.h       |    2 +-
 arch/arm/plat-mxc/include/mach/ulpi.h           |    6 +-
 arch/arm/plat-mxc/ulpi.c                        |    8 +-
 arch/mips/ath79/dev-usb.c                       |   31 +-
 drivers/block/Kconfig                           |    2 +-
 drivers/block/ub.c                              |   39 +-
 drivers/net/usb/Kconfig                         |   22 +
 drivers/net/usb/Makefile                        |    1 +
 drivers/net/usb/qmi_wwan.c                      |  478 ++++++++
 drivers/power/isp1704_charger.c                 |  106 +-
 drivers/power/pda_power.c                       |   10 +-
 drivers/power/twl4030_charger.c                 |   20 +-
 drivers/scsi/scsi_scan.c                        |    4 +
 drivers/scsi/sd.c                               |    2 +-
 drivers/staging/keucr/transport.h               |   37 -
 drivers/staging/quatech_usb2/quatech_usb2.c     |   40 +-
 drivers/staging/serqt_usb2/serqt_usb2.c         |   40 +-
 drivers/usb/Kconfig                             |   43 +-
 drivers/usb/class/cdc-acm.c                     |   30 +-
 drivers/usb/class/cdc-wdm.c                     |  352 ++++--
 drivers/usb/core/driver.c                       |  120 +-
 drivers/usb/core/hcd-pci.c                      |    2 +
 drivers/usb/core/hcd.c                          |    6 +-
 drivers/usb/core/hub.c                          |  212 +++-
 drivers/usb/core/sysfs.c                        |   23 +
 drivers/usb/core/urb.c                          |   32 +-
 drivers/usb/core/usb.c                          |    2 +-
 drivers/usb/core/usb.h                          |    1 +
 drivers/usb/dwc3/Makefile                       |   13 +
 drivers/usb/dwc3/core.c                         |  122 +-
 drivers/usb/dwc3/core.h                         |  200 ++--
 drivers/usb/dwc3/debugfs.c                      |  214 +++-
 drivers/usb/dwc3/dwc3-exynos.c                  |  151 +++
 drivers/usb/dwc3/dwc3-omap.c                    |  116 +-
 drivers/usb/dwc3/dwc3-pci.c                     |   53 +-
 drivers/usb/dwc3/ep0.c                          |   98 +-
 drivers/usb/dwc3/gadget.c                       |  429 ++++---
 drivers/usb/dwc3/gadget.h                       |    5 +-
 drivers/usb/dwc3/host.c                         |    2 +-
 drivers/usb/gadget/Kconfig                      |   27 +-
 drivers/usb/gadget/amd5536udc.c                 |  147 +--
 drivers/usb/gadget/at91_udc.c                   |    2 +-
 drivers/usb/gadget/atmel_usba_udc.c             |    1 +
 drivers/usb/gadget/audio.c                      |   47 +-
 drivers/usb/gadget/ci13xxx_msm.c                |    4 +-
 drivers/usb/gadget/ci13xxx_udc.c                |   18 +-
 drivers/usb/gadget/ci13xxx_udc.h                |    2 +-
 drivers/usb/gadget/dummy_hcd.c                  |  755 +++++++-----
 drivers/usb/gadget/epautoconf.c                 |   16 +-
 drivers/usb/gadget/f_acm.c                      |   52 +-
 drivers/usb/gadget/f_ecm.c                      |   25 +
 drivers/usb/gadget/f_fs.c                       |    6 +-
 drivers/usb/gadget/f_mass_storage.c             |   29 +-
 drivers/usb/gadget/f_midi.c                     |    2 +-
 drivers/usb/gadget/f_rndis.c                    |    2 +-
 drivers/usb/gadget/f_serial.c                   |   42 +
 drivers/usb/gadget/f_subset.c                   |   34 +-
 drivers/usb/gadget/{f_audio.c => f_uac1.c}      |   25 +-
 drivers/usb/gadget/f_uac2.c                     | 1449 +++++++++++++++++++++++
 drivers/usb/gadget/file_storage.c               |   26 +-
 drivers/usb/gadget/fsl_qe_udc.c                 |    1 +
 drivers/usb/gadget/fsl_udc_core.c               |   28 +-
 drivers/usb/gadget/fsl_usb2_udc.h               |    2 +-
 drivers/usb/gadget/g_ffs.c                      |    2 +-
 drivers/usb/gadget/goku_udc.c                   |   19 +-
 drivers/usb/gadget/hid.c                        |    6 +-
 drivers/usb/gadget/inode.c                      |    2 +
 drivers/usb/gadget/langwell_udc.c               |   52 +-
 drivers/usb/gadget/langwell_udc.h               |    2 +-
 drivers/usb/gadget/mass_storage.c               |    2 +-
 drivers/usb/gadget/multi.c                      |    2 +-
 drivers/usb/gadget/mv_udc.h                     |    2 +-
 drivers/usb/gadget/mv_udc_core.c                |    9 +-
 drivers/usb/gadget/net2272.c                    |   18 +-
 drivers/usb/gadget/net2280.c                    |   19 +-
 drivers/usb/gadget/omap_udc.c                   |   26 +-
 drivers/usb/gadget/omap_udc.h                   |    2 +-
 drivers/usb/gadget/pch_udc.c                    |  323 ++++-
 drivers/usb/gadget/pxa25x_udc.c                 |   15 +-
 drivers/usb/gadget/pxa25x_udc.h                 |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                 |   11 +-
 drivers/usb/gadget/pxa27x_udc.h                 |    2 +-
 drivers/usb/gadget/r8a66597-udc.c               |   10 +-
 drivers/usb/gadget/s3c-hsudc.c                  |   34 +-
 drivers/usb/gadget/s3c2410_udc.c                |    2 +
 drivers/usb/gadget/serial.c                     |    2 +-
 drivers/usb/gadget/storage_common.c             |   42 +-
 drivers/usb/gadget/{u_audio.c => u_uac1.c}      |    4 +-
 drivers/usb/gadget/{u_audio.h => u_uac1.h}      |    2 +-
 drivers/usb/gadget/udc-core.c                   |   52 +
 drivers/usb/host/Kconfig                        |   45 +-
 drivers/usb/host/Makefile                       |    4 +
 drivers/usb/host/ehci-ath79.c                   |  208 ----
 drivers/usb/host/ehci-dbg.c                     |    2 +-
 drivers/usb/host/ehci-fsl.c                     |   47 +-
 drivers/usb/host/ehci-fsl.h                     |    4 +
 drivers/usb/host/ehci-hcd.c                     |   20 +-
 drivers/usb/host/ehci-hub.c                     |   10 +-
 drivers/usb/host/ehci-ls1x.c                    |  159 +++
 drivers/usb/host/ehci-msm.c                     |   14 +-
 drivers/usb/host/ehci-mv.c                      |   12 +-
 drivers/usb/host/ehci-mxc.c                     |   12 +-
 drivers/usb/host/ehci-platform.c                |  198 ++++
 drivers/usb/host/ehci-pxa168.c                  |  363 ------
 drivers/usb/host/ehci-s5p.c                     |   15 +
 drivers/usb/host/ehci-spear.c                   |   83 +-
 drivers/usb/host/ehci-tegra.c                   |   14 +-
 drivers/usb/host/ehci.h                         |    2 +-
 drivers/usb/host/fsl-mph-dr-of.c                |    1 -
 drivers/usb/host/imx21-dbg.c                    |    2 +-
 drivers/usb/host/isp116x-hcd.c                  |   23 +-
 drivers/usb/host/isp1362-hcd.c                  |   20 +-
 drivers/usb/host/ohci-ath79.c                   |  151 ---
 drivers/usb/host/ohci-exynos.c                  |    6 +-
 drivers/usb/host/ohci-hcd.c                     |   18 +-
 drivers/usb/host/{ohci-pnx4008.c => ohci-nxp.c} |  253 ++--
 drivers/usb/host/ohci-omap.c                    |    8 +-
 drivers/usb/host/ohci-platform.c                |  194 +++
 drivers/usb/host/ohci-pxa27x.c                  |    5 +-
 drivers/usb/host/ohci.h                         |    2 +-
 drivers/usb/host/r8a66597-hcd.c                 |   21 +-
 drivers/usb/host/sl811-hcd.c                    |   21 +-
 drivers/usb/host/uhci-hcd.c                     |    3 +
 drivers/usb/host/xhci-hub.c                     |   41 +
 drivers/usb/host/xhci-mem.c                     |  241 +++-
 drivers/usb/host/xhci-plat.c                    |  205 ++++
 drivers/usb/host/xhci-ring.c                    |  333 ++++--
 drivers/usb/host/xhci.c                         |   72 +-
 drivers/usb/host/xhci.h                         |   34 +-
 drivers/usb/musb/am35x.c                        |   20 +-
 drivers/usb/musb/blackfin.c                     |   15 +-
 drivers/usb/musb/da8xx.c                        |   20 +-
 drivers/usb/musb/davinci.c                      |   24 +-
 drivers/usb/musb/musb_core.c                    |   77 +-
 drivers/usb/musb/musb_core.h                    |    2 +-
 drivers/usb/musb/musb_debugfs.c                 |   14 +-
 drivers/usb/musb/musb_gadget.c                  |   39 +-
 drivers/usb/musb/musb_virthub.c                 |    9 +-
 drivers/usb/musb/omap2430.c                     |   46 +-
 drivers/usb/musb/tusb6010.c                     |   33 +-
 drivers/usb/musb/ux500.c                        |   19 +-
 drivers/usb/otg/Kconfig                         |    2 +-
 drivers/usb/otg/ab8500-usb.c                    |   95 +-
 drivers/usb/otg/fsl_otg.c                       |  113 +-
 drivers/usb/otg/fsl_otg.h                       |    2 +-
 drivers/usb/otg/gpio_vbus.c                     |   61 +-
 drivers/usb/otg/isp1301_omap.c                  |  234 ++--
 drivers/usb/otg/msm_otg.c                       |  398 ++++---
 drivers/usb/otg/mv_otg.c                        |  110 +-
 drivers/usb/otg/mv_otg.h                        |    2 +-
 drivers/usb/otg/nop-usb-xceiv.c                 |   66 +-
 drivers/usb/otg/otg.c                           |   38 +-
 drivers/usb/otg/otg_fsm.c                       |   22 +-
 drivers/usb/otg/otg_fsm.h                       |    2 +-
 drivers/usb/otg/twl4030-usb.c                   |   83 +-
 drivers/usb/otg/twl6030-usb.c                   |  119 +-
 drivers/usb/otg/ulpi.c                          |  116 +-
 drivers/usb/otg/ulpi_viewport.c                 |    6 +-
 drivers/usb/renesas_usbhs/common.c              |   11 +-
 drivers/usb/renesas_usbhs/common.h              |    1 +
 drivers/usb/renesas_usbhs/fifo.c                |   29 +-
 drivers/usb/renesas_usbhs/fifo.h                |    3 +-
 drivers/usb/renesas_usbhs/mod.c                 |    2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c          |   79 +-
 drivers/usb/serial/Kconfig                      |   17 +
 drivers/usb/serial/Makefile                     |    2 +
 drivers/usb/serial/aircable.c                   |   30 +-
 drivers/usb/serial/ark3116.c                    |   30 +-
 drivers/usb/serial/belkin_sa.c                  |   35 +-
 drivers/usb/serial/ch341.c                      |   27 +-
 drivers/usb/serial/cp210x.c                     |   77 +-
 drivers/usb/serial/cyberjack.c                  |   36 +-
 drivers/usb/serial/cypress_m8.c                 |   64 +-
 drivers/usb/serial/digi_acceleport.c            |   45 +-
 drivers/usb/serial/empeg.c                      |   34 +-
 drivers/usb/serial/f81232.c                     |  405 +++++++
 drivers/usb/serial/ftdi_sio.c                   |   58 +-
 drivers/usb/serial/ftdi_sio.h                   |    3 +-
 drivers/usb/serial/ftdi_sio_ids.h               |   19 +-
 drivers/usb/serial/funsoft.c                    |   25 +-
 drivers/usb/serial/garmin_gps.c                 |   40 +-
 drivers/usb/serial/generic.c                    |   19 +-
 drivers/usb/serial/hp4x.c                       |   31 +-
 drivers/usb/serial/io_edgeport.c                |   66 +-
 drivers/usb/serial/io_tables.h                  |   10 +-
 drivers/usb/serial/io_ti.c                      |   44 +-
 drivers/usb/serial/ipaq.c                       |   28 +-
 drivers/usb/serial/ipw.c                        |   32 +-
 drivers/usb/serial/ir-usb.c                     |   30 +-
 drivers/usb/serial/iuu_phoenix.c                |   31 +-
 drivers/usb/serial/keyspan.c                    |   48 +-
 drivers/usb/serial/keyspan.h                    |   10 +-
 drivers/usb/serial/keyspan_pda.c                |   62 +-
 drivers/usb/serial/kl5kusb105.c                 |   37 +-
 drivers/usb/serial/kobil_sct.c                  |   35 +-
 drivers/usb/serial/mct_u232.c                   |   34 +-
 drivers/usb/serial/metro-usb.c                  |  402 +++++++
 drivers/usb/serial/mos7720.c                    |   46 +-
 drivers/usb/serial/mos7840.c                    |  142 +--
 drivers/usb/serial/moto_modem.c                 |   26 +-
 drivers/usb/serial/navman.c                     |   25 +-
 drivers/usb/serial/omninet.c                    |   38 +-
 drivers/usb/serial/opticon.c                    |   25 +-
 drivers/usb/serial/option.c                     |   53 +-
 drivers/usb/serial/oti6858.c                    |   36 +-
 drivers/usb/serial/pl2303.c                     |   31 +-
 drivers/usb/serial/qcaux.c                      |   26 +-
 drivers/usb/serial/qcserial.c                   |  134 ++-
 drivers/usb/serial/safe_serial.c                |   24 +-
 drivers/usb/serial/siemens_mpi.c                |   30 +-
 drivers/usb/serial/sierra.c                     |   37 +-
 drivers/usb/serial/spcp8x5.c                    |   31 +-
 drivers/usb/serial/ssu100.c                     |   40 +-
 drivers/usb/serial/symbolserial.c               |   25 +-
 drivers/usb/serial/ti_usb_3410_5052.c           |   40 +-
 drivers/usb/serial/usb-serial.c                 |   77 +-
 drivers/usb/serial/usb_debug.c                  |   26 +-
 drivers/usb/serial/visor.c                      |   37 +-
 drivers/usb/serial/vivopay-serial.c             |   31 +-
 drivers/usb/serial/whiteheat.c                  |   47 +-
 drivers/usb/serial/zio.c                        |   26 +-
 drivers/usb/storage/alauda.c                    |    1 +
 drivers/usb/storage/cypress_atacb.c             |    1 +
 drivers/usb/storage/datafab.c                   |    1 +
 drivers/usb/storage/ene_ub6250.c                |   27 +-
 drivers/usb/storage/freecom.c                   |    1 +
 drivers/usb/storage/isd200.c                    |    1 +
 drivers/usb/storage/jumpshot.c                  |    1 +
 drivers/usb/storage/karma.c                     |    1 +
 drivers/usb/storage/onetouch.c                  |    1 +
 drivers/usb/storage/realtek_cr.c                |   13 +-
 drivers/usb/storage/scsiglue.c                  |   55 +-
 drivers/usb/storage/sddr09.c                    |    1 +
 drivers/usb/storage/sddr55.c                    |    1 +
 drivers/usb/storage/shuttle_usbat.c             |    1 +
 drivers/usb/storage/transport.c                 |    3 +-
 drivers/usb/storage/transport.h                 |   39 -
 drivers/usb/storage/uas.c                       |  328 +++--
 drivers/usb/storage/usb.c                       |   21 +-
 include/linux/device.h                          |    7 +-
 include/linux/platform_data/dwc3-exynos.h       |   24 +
 include/linux/usb.h                             |   10 +-
 include/linux/usb/audio-v2.h                    |   21 +
 include/linux/usb/cdc-wdm.h                     |   19 +
 include/linux/usb/ch11.h                        |    5 +
 include/linux/usb/ch9.h                         |    5 +
 include/linux/usb/ehci_pdriver.h                |   46 +
 include/linux/usb/gadget.h                      |   10 +
 include/linux/usb/hcd.h                         |    4 +-
 include/linux/usb/intel_mid_otg.h               |    6 +-
 include/linux/usb/msm_hsusb.h                   |    2 +-
 include/linux/usb/ohci_pdriver.h                |   38 +
 include/linux/usb/otg.h                         |  164 +--
 include/linux/usb/renesas_usbhs.h               |    1 +
 include/linux/usb/serial.h                      |   36 +-
 include/linux/usb/storage.h                     |   38 +
 include/linux/usb/uas.h                         |   69 ++
 include/linux/usb/ulpi.h                        |    4 +-
 include/scsi/scsi_device.h                      |    7 +-
 tools/usb/ffs-test.c                            |    2 +-
 tools/usb/testusb.c                             |    2 +-
 269 files changed, 9689 insertions(+), 5607 deletions(-)
 create mode 100644 drivers/net/usb/qmi_wwan.c
 create mode 100644 drivers/usb/dwc3/dwc3-exynos.c
 rename drivers/usb/gadget/{f_audio.c => f_uac1.c} (97%)
 create mode 100644 drivers/usb/gadget/f_uac2.c
 rename drivers/usb/gadget/{u_audio.c => u_uac1.c} (99%)
 rename drivers/usb/gadget/{u_audio.h => u_uac1.h} (94%)
 delete mode 100644 drivers/usb/host/ehci-ath79.c
 create mode 100644 drivers/usb/host/ehci-ls1x.c
 create mode 100644 drivers/usb/host/ehci-platform.c
 delete mode 100644 drivers/usb/host/ehci-pxa168.c
 delete mode 100644 drivers/usb/host/ohci-ath79.c
 rename drivers/usb/host/{ohci-pnx4008.c => ohci-nxp.c} (57%)
 create mode 100644 drivers/usb/host/ohci-platform.c
 create mode 100644 drivers/usb/host/xhci-plat.c
 create mode 100644 drivers/usb/serial/f81232.c
 create mode 100644 drivers/usb/serial/metro-usb.c
 create mode 100644 include/linux/platform_data/dwc3-exynos.h
 create mode 100644 include/linux/usb/cdc-wdm.h
 create mode 100644 include/linux/usb/ehci_pdriver.h
 create mode 100644 include/linux/usb/ohci_pdriver.h
 create mode 100644 include/linux/usb/uas.h
