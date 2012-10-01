Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2JASa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:30:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43841 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab2JASaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:30:21 -0400
X-Sasl-enc: 7uDSpNDNliY9ggXxYvauKoHg4L+IU+7PALrwjPkLLvzG 1349116219
Date: Mon, 1 Oct 2012 11:30:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] staging patches for 3.7-rc1
Message-ID: <20121001183018.GA12584@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.6

for you to fetch changes up to e1878957b4676a17cf398f7f5723b365e9a2ca48:

  staging: comedi: jr3_pci: fix iomem dereference (2012-09-27 10:06:36 -0700)

----------------------------------------------------------------
Staging tree update for 3.7-rc1

Here is the big staging tree update for the 3.7-rc1 merge window.

There are a few patches in here that are outside of the staging area,
namely HID and IIO patches, but all of them have been acked by the
relevant subsystem maintainers.  The IIO stuff is still coming in
through this tree as it hasn't entirely moved out of the staging tree,
but is almost there.

Other than that, there wa a ton of work on the comedi drivers to make
them more readable and the correct style.  Doing that removed a lot of
code, but we added a new driver to the staging tree, so we didn't end up
with a net reduction this time around:
 662 files changed, 51649 insertions(+), 26582 deletions(-)

All of these patches have been in the linux-next tree already.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (25):
      staging: xgifb: document some LVDS data delay values
      staging: xgifb: replace XGI_XG21SetPanelDelay() with mdelay()
      staging: xgifb: delete IF_DEF_ExpLink
      staging: xgifb: delete IF_DEF_LCDA
      staging: xgifb: delete some unused #defines
      staging: xgifb: delete redundant chip type check
      staging: xgifb: avoid copy-pasting LCD data
      staging: xgifb: XGI_GetTVPtr: drop the table parameter
      staging: xgifb: delete Chrontel TV data
      staging: xgifb: use proper typing for TV data
      staging: xgifb: use a real pointer for TV DATAPTR
      staging: xgifb: delete Chrontel 7017 LCD data
      staging: xgifb: XGI_GetLcdPtr: delete dead code
      staging: xgifb: delete LCDLenList
      staging: xgifb: delete XGI_LCDDataTablStruct
      staging: xgifb: use "else if"
      staging: xgifb: access static data tables directly
      staging: xgifb: mark constant data with const
      staging: xgifb: delete ISXPDOS
      staging: xgifb: use correct type for VBVCLKData
      staging: xgifb: delete redundant casts
      staging: xgifb: validate the mode against video memory size
      staging: xgifb: prevent video RAM size exceeding PCI window size
      staging: xgifb: setup initial video RAM size for systems without BIOS
      staging: xgifb: delete bogus video RAM configuration

Adam Buchbinder (2):
      staging: Fix misspellings of "whether".
      staging: Fix spelling of "asynchronous" in comments.

Alan Cox (2):
      staging: gdm72xx: Fix bogus test
      staging: rts_pstor: Fix invalid check

Alexey Khoroshilov (3):
      staging: bcm: fix error handling in bcm_init()
      staging: bcm: use pr_info and pr_err rather than printk
      staging: sbe-2t3e3: fix error handling in t3e3_init_channel()

Alois Schlögl (1):
      Staging: add ced1401 USB driver

Andre Renaud (1):
      staging: omapdrm: Expose the OMAP Z-Order property through DRM

Andy Gross (1):
      staging: omapdrm: Fix DMM sparse warnings

Andy Shevchenko (11):
      staging: rts5139: substitute rts51x_dump by print_hex_dump
      staging: rts_pstor: substitute rtsx_dump by print_hex_dump
      staging: csr: print mac address with %pM
      staging: csr: use %*ph[C] to hexdump small buffers
      staging: tidspbridge: eliminate uuid_uuid_to_string
      staging: vt6656: print small buffers with %*ph
      staging: vt6655: print small buffers with %*ph
      staging: xgifb: print small buffers via %*ph
      staging: nvec: use %*ph to dump small buffers
      staging: bcm: print small buffers with %*ph
      staging: wlan-ng: use %*phC to hexdump small buffers

Axel Lin (2):
      HID: hid-sensor-hub: Remove hdev->claimed setting
      HID: hid-sensor-hub: Fix sensor_hub_probe error handling

Ben Chan (2):
      staging: gdm72xx: fix reference counting in gdm_wimax_event_init
      staging: gdm72xx: simplify alloc_tx_struct and alloc_rx_struct

Ben Hutchings (1):
      staging: speakup_soft: Fix reading of init string

Bernard Blackham (1):
      staging: usbip: avoid deadlock in vhci_device_unlink_cleanup()

Bryan Freed (1):
      iio: isl29018: Support fractional ALS scaling.

Chandrabhanu Mahapatra (1):
      staging: drm/omap: remove reclaim_buffers callback

Cruz Julian Bishop (3):
      staging: android: ashmem: Fix comment/license formatting
      staging: android: logger.h: Complete documentation of logger_entry
      staging: android: logger: Finish documentation of two structs

Dae S. Kim (1):
      Staging: android: Alarm driver cleanups

Dan Carpenter (10):
      Staging: xgifb: fix bitwise vs logical bug
      staging: ramster: fix range checks in zcache_autocreate_pool()
      Staging: silicom: remove S_IWOTH from proc declaration
      Staging: silicom: add some range checks to proc functions
      Staging: silicom: use kstrtoint_from_user()
      HID: sensors: use GFP_ATOMIC under spinlock
      HID: sensors: remove some unneeded checks
      Staging: ced1401: fix a couple off by one checks
      iio: dac/ad5755: signedness bug in ad5755_setup_pdata()
      staging: rts5139: use kzalloc() to close an info leak

Dan Magenheimer (4):
      staging: ramster: remove old driver to prep for new base
      staging: ramster: move to new zcache2 codebase
      staging: ramster: place ramster codebase on top of new zcache2 codebase
      staging: ramster: fix build warnings

Daniel Cotey (28):
      Staging: silicom: checkpatch: cleanup macros
      Staging: silicom: minor cleanup: remove unused define
      Staging: silicom: checkpatch cleanup: header tabs n spaces
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bp_mod.h: checkpatch tab and space cleanup
      Staging: silicom: bypass.h: checkpatch whitespace
      Staging: silicom: bypass.h: checkpatch whitespace
      Staging: silicom: checkpatch cleanup: header file whitespace
      Staging: silicom: checkpatch cleanup: header file whitespace
      Staging: silicom: checkpatch cleanup: fix includes
      Staging: silicom: checkpatch.pl cleanup: pretty pointers
      Staging: silicom: checkpatch.pl cleanup: pretty pointers
      Staging: silicom: checkpatch.pl cleanup: pretty pointers
      Staging: silicom: checkpatch.pl cleanup: pretty pointers
      Staging: silicom: checkpatch.pl cleanup: pretty pointers
      Staging: silicom: checkpatch.pl cleanup: pretty pointers
      Staging: silicom: bp_mod.c: checkpatch cleanup: fix returns
      Staging: silicom: bp_mod.c: checkpatch cleanups: C99 comments

DanielC (6):
      staging: add Silicom Bypass driver
      Staging: silicom: C99 cleanup of bp_ioctl.h
      Staging: silicom: C99 cleanup of bypass.h
      Staging: silicom: C99 cleanup of libbp_sd.h
      Staging: silicom: Force depend on module
      Staging: silicom: Header-cleanup

Davidlohr Bueso (1):
      staging: keucr: remove String func prototypes

Devendra Naga (73):
      staging/csr: coding style fixes in CsrTimeGet
      staging/csr: coding style fixes at sdio_linux_remove_irq and at install_irq
      staging/csr: remove firmware pointer check before giving to release_firmware
      staging/csr: clean coding style in uf_start_thread
      staging/csr: fix coding style problems in uf_stop_thread
      staging/csr: fix coding style problems in uf_wait_for_thread_to_stop
      staging/csr: remove the initialisation of interfaceTag and its comment in handle_bh_error
      staging/csr: fix coding style problems in handle_bh_error
      staging/android: use module_platform_driver
      staging/tidspbridge: use module_platform_driver
      staging/crystalhd: assign PTR_ERR at fail cases to rc in chd_dec_init_chdev
      staging/crystalhd: unregister chardev when class_create fails in chd_dec_init_chdev
      staging/iio: use module_platform_driver macro
      staging: serqt_usb2: remove unneeded return in qt_unthrottle
      staging: serqt_usb2: remove unneeded return in qt_throttle
      staging: serqt_usb2: remove retval initialisation in qt_tiocmget and qt_tiocmset
      staging: serqt_usb2: remove return in ProcessLineStatus and ProcessModemStatus
      staging:csr: remove usage of CsrSnprintf and use scnprintf
      staging: gdm72xx: use kzalloc to allocate usb_tx structure
      staging: wlags49_h2: coding style fix at wl_wds_netif_carrier_off
      staging: wlags49_h2: remove unneded return in wl_wds_netif_carrier_off
      staging: wlags49_h2: style fix in w1_wds_netif_carrier_off
      staging: wlagn49_h2: fix the checkpatch warning about the space after the open paranthesis
      staging: wlags49_h2: remove return statements at the end of all void functions
      staging: wlagn49_h2: move open brace of if from below to beside of if statement
      staging: rtl8192u: use kzalloc to allocate firmware pointer
      staging: rtl8192e: remove casting of returned pointer from kmalloc
      staging: sbe-2t3e3: fix sparse warnings
      staging: sbe-2t3e3: fix sparse warnings
      staging: cptm1217: use module_i2c_driver macro
      staging: serqt_usb2: fix dbg print when kzalloc failed to allocate qt_port
      staging: slicoss: return early before calling request_firmware with empty firmware filename
      staging: slicoss: release firmware before returning
      staging: sm7xxfb: copy device name before we pass to the smtc_alloc_fb_info
      staging: cxt1e1: use kernel's way of returning error codes
      staging: cxt1e1: solve coding style problem
      staging: csr: remove casting of return value from kmalloc
      staging: csr: replace calls to kmalloc and memset with kzalloc
      staging: slicoss: remove default case after we done with request_firmware
      staging: slicoss: clean the spinlock code in slic_entry_open
      staging: slicoss: remove return statement at the end of slic_mcast_set_list
      staging: slicoss: fix a null deref when pci_alloc_consistent fail
      staging: vt6655: fix coding style warnings
      staging: vt6655: fix coding style issues in device_get_options
      staging: vt6655: fix coding style problem at assigning netdev_ops
      staging: vt6655: return ENOMEM rather than ENODEV when alloc_etherdev fail
      staging: vt6655: vt6655_init_info function must be void type
      staging:wlan-ng: slove sparse warnings
      staging:wlan-ng: fix sparse warnings
      staging:wlan-ng: cleanup hfa384x_usbctlx_resptimerfn
      staging:wlan-ng: cleanup hfa384x_ctlxout_callback
      staging:wlan-ng: remove default case in the p80211req_handlemsg
      staging:wlan-ng: clean p80211req_handlemsg
      staging:wlan-ng: p80211req_mibset_mibget should be void
      staging:wlan-ng: clean coding style problems in p80211req_mibset_mibget
      staging:wlan-ng: cleanup p80211skb_free and p80211skb_rxmeta_detach
      staging:wlan-ng: cleanup prism2sta_commsqual_defer and hfa384x_drvr_getconfig
      staging:wlan-ng: clean register_wlandev function
      staging:wlan-ng: clean some more functions
      staging:ccg: fix a class_destroy when kmalloc fails after the class_create
      staging:ccg: cleanup a bit of binding
      staging:wlan-ng: make wlan_unsetup void
      staging:wlan-ng: clean hfa384x_usbctlx_submit
      staging:wlan-ng: remove all the return statements at the end of functions
      staging:wlan-ng: remove the remaining return at the end of void function
      staging: ft1000: replace c99 comments with c88
      staging: silicom: fix a comparing proc_dir_entry pointer against 0
      staging:ced1401: use module_usb_driver macro
      staging:ced1401: remove read write callbacks from fops
      staging: sbe-2t3e3: use -ve error return codes in dc_init_descriptor_list
      staging: rtl8712: remove assignment of 0 to a static global variable
      staging: rtl8712: fix a foo * bar errors reported by checkpatch
      staging: rtl8712: fix foo* bar (foo*) errors reported by checkpatch

Eduardo Valentin (3):
      staging: omap-thermal: remove checkpatch.pl warnings on data files
      staging: omap-thermal: fix polling period settings
      staging: omap-thermal: improve conf data handling and initialization

Emil Goode (2):
      staging: drm/omap: Add error handling
      staging: wlan-ng: Fix dereference before NULL check

Fengguang Wu (2):
      Staging: panel: fix spinlock trylock failure on UP
      staging: ozwpan: compare pointer to NULL rather than 0

Greg Kroah-Hartman (16):
      Merge tag 'iio-for-v3.7a' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.6-rc3 into staging-next
      Merge branch 'staging-linus' into staging-next
      Merge branch 'staging-linus' into staging-next
      Merge tag 'iio-for-v3.7b' of git://git.kernel.org/.../jic23/iio into work-next
      staging: comedi: vmk80xx: fix compiler warning
      Merge tag 'iio-for-3.7c' of git://git.kernel.org/.../jic23/iio into work-next
      Merge 3.6-rc6 into staging-next
      Merge tag 'iio-for-v3.7d' of git://git.kernel.org/.../jic23/iio into staging-next
      Staging: ced1401: usb1401: fix build errors.
      Staging: ced1401: add TODO file
      Staging: ced1401: add driver to the build
      Staging ced1401: cleanup coding style issues.
      Staging: ced1401: fix copy_from/to_user warning messages
      Staging: remove CONFIG_EXPERIMENTAL dependancies
      Merge tag 'iio-for-v3.7e' of git://git.kernel.org/.../jic23/iio into staging-next

Güngör Erseymen (2):
      Staging: comedi: ssv_dnp: fix checkpatch.pl warning
      staging: comedi: fix brace coding style issues

H Hartley Sweeten (416):
      staging: comedi: new adl_pci7x3x driver
      staging: comedi: remove adl_pci7230 and adl_pci7432 drivers
      staging: comedi: update adl_pci7296 driver
      staging: comedi: adl_pci6208: use attach_pci callback
      staging: comedi: adl_pci6208: add support for the PCI-6216 card
      staging: comedi: adl_pci6208: split the digital i/o subdevice
      staging: comedi: adl_pci6208: use the 'board_name' for the resource name
      staging: comedi: adl_pci7x3x: fix pointer-to-int-cast warning
      staging: comedi: dnya_pci10xx: remove thisboard and devpriv macros
      staging: comedi: dnya_pci10xx: use attach_pci callback
      staging: comedi: dnya_pci10xx: cleanup the analog output range
      staging: comedi: dnya_pci10xx: remove unused fields in the boardinfo
      staging: comedi: dnya_pci10xx: move boardinfo values into subdevice setup
      staging: comedi: dnya_pci10xx: remove unneeded boardinfo code
      staging: comedi: dnya_pci10xx: remove unused DRV_NAME
      staging: comedi: contec_pci_dio: remove thisboard macro
      staging: comedi: contec_pci_dio: remove function trace messages
      staging: comedi: contec_pci_dio: remove unused fields in the boardinfo
      staging: comedi: contec_pci_dio: define register map for board
      staging: comedi: contec_pci_dio: remove unneeded boardinfo code
      staging: comedi: contec_pci_dio: use attach_pci callback
      staging: comedi: contec_pci_dio: cleanup contec_do_insn_bits
      staging: comedi: adl_pci6208: remove manual legacy attach
      staging: comedi: adl_pci7296: remove manual legacy attach
      staging: comedi: adl_pci7x3x: remove manual legacy attach
      staging: comedi: adl_pci8164: use attach_pci callback
      staging: comedi: cb_pcidas: use attach_pci callback
      staging: comedi: cb_pcidio: remove thisboard macro
      staging: comedi: cb_pcidio: use attach_pci callback
      staging: comedi: cb_pcidda: remove thisboard and devpriv macros
      staging: comedi: cb_pcidda: remove forward declarations
      staging: comedi: cb_pcidda: use attach_pci callback
      staging: comedi: cb_pcimdas: remove thisboard and devpriv macros
      staging: comedi: cb_pcimdas: remove forward declarations
      staging: comedi: cb_pcimdas: use attach_pci callback
      staging: comedi: cb_pcimdda: remove REG_SZ and REGS_BARINDEX macros
      staging: comedi: cb_pcimdda: remove thisboard and devpriv macros
      staging: comedi: cb_pcimdda: remove forward declarations
      staging: comedi: cb_pcimdda: add namespace to the driver
      staging: comedi: cb_pcimdda: cleanup pci probe
      staging: comedi: cb_pcimdda: use dev->iobase
      staging: comedi: cb_pcimdda: store the pci_dev in the comedi_device
      staging: comedi: cb_pcimdda: cleanup the 8255 subdevice init
      staging: comedi: cb_pcimdda: remove the DIO_METHODS
      staging: comedi: cb_pcimdda: remove dio_chans from the private data
      staging: comedi: cb_pcimdda: define the register map
      staging: comedi: cb_pcimdda: remove dio_offset from the boardinfo
      staging: comedi: cb_pcimdda: remove regs_badrindex and reg_sz from boardinfo
      staging: comedi: cb_pcimdda: remove ao_chans and ao_bits from boardinfo
      staging: comedi: cb_pcimdda: remove boardinfo
      staging: comedi: cb_pcimdda: remove attached_to_8255 from private data
      staging: comedi: cb_pcimdda: fix bug in call to subdev_8255_cleanup
      staging: comedi: cb_pcimdda: minor cleanup of the private data
      staging: comedi: cb_pcimdda: cleanup the analog out read/write
      staging: comedi: cb_pcimdda: use attach_pci callback
      staging: comedi: dyna_pci10xx: remove manual legacy attach
      staging: comedi: ke_counter: use attach_pci callback
      staging: comedi: contec_pci: remove manual legacy attach
      staging: comedi: adv_pci1710: remove function trace messages
      staging: comedi: adv_pci1710: remove devpriv and this_board macros
      staging: comedi: adv_pci1710: convert boardinfo initialization to C99 format
      staging: comedi: adv_pci1710: remove '0' and 'NULL' boardinfo data
      staging: comedi: adv_pci1710: remove forward declarations
      staging: comedi: adv_pci1723: remove function trace messages
      staging: comedi: adv_pci1723: remove devpriv and this_board macros
      staging: comedi: adv_pci1723: remove range_pci1723
      staging: comedi: adv_pci1723: fix initial dio subdevice state and io_bits
      staging: comedi: adv_pci1723: remove boardinfo
      staging: comedi: adv_pci1723: use attach_pci callback
      staging: comedi: adv_pci1723: cleanup card reset
      staging: comedi: adv_pci_dio: remove function trace messages
      staging: comedi: adv_pci_dio: remove devpriv and this_board macros
      staging: comedi: adv_pci_dio: use attach_pci callback
      staging: comedi: adv_pci_dio: convert boardinfo initialization to C99 format
      staging: comedi: adv_pci_dio: remove '0' boardinfo data
      staging: comedi: adv_pci_dio: add the number of subdevices to the boardinfo
      staging: comedi: adv_pci_dio: simplify the 'detach'
      staging: comedi: adv_pci_dio: fix bug in 'detach'
      staging: comedi: aio_aio12_8: remove devpriv macro
      staging: comedi: aio_aio12_8: add ai and ao only card versions
      staging: comedi: aio_aio12_8: document the register map
      staging: comedi: aio_aio12_8: fix i/o region size
      staging: comedi: comedi_bond: remove boardinfo
      staging: comedi: comedi_bond: remove devpriv macro
      staging: comedi: comedi_bond: remove private printk macros
      staging: comedi: comedi_bond: remove the STR macro
      staging: comedi: comedi_bond: remove MODULE_NAME macro
      staging: comedi: comedi_parport: remove devpriv macro
      staging: comedi: comedi_parport: cleanup dev->board_name
      staging: comedi: comedi_parport: cleanup 'attach' printk's
      staging: comedi: comedi_parport: remove the printk noise
      staging: comedi: comedi_test: remove devpriv macro
      staging: comedi: comedi_test: remove boardinfo
      staging: comedi: comedi_test: convert attach message to dev_info
      staging: comedi: addi_apci_all.c: remove unused file
      staging: comedi: amcc_s5933_58.h: remove unused file
      staging: comedi: addi_amcc_S5920.[ch]: remove unnecessary files
      staging: comedi: comedi_fops: remove subdevice pointer math
      staging: comedi: drivers: remove subdevice pointer math
      staging: comedi: 8255: remove subdevice pointer math
      staging: comedi: acl7225b: remove subdevice pointer math
      staging: comedi: addi_common: remove subdevice pointer math
      staging: comedi: hwdrv_APCI1710: remove subdevice pointer math
      staging: comedi: hwdrv_apci3120: remove subdevice pointer math
      staging: comedi: hwdrv_apci3200: remove subdevice pointer math
      staging: comedi: adl_pci6208: remove subdevice pointer math
      staging: comedi: adl_pci7296: remove subdevice pointer math
      staging: comedi: adl_pci7x3x: remove subdevice pointer math
      staging: comedi: adl_pci8164: remove subdevice pointer math
      staging: comedi: adl_pci9111: rename 'subdevice' variable to 's'
      staging: comedi: adl_pci9111: remove subdevice pointer math
      staging: comedi: adl_pci9118: remove subdevice pointer math
      staging: comedi: adq12b: remove subdevice pointer math
      staging: comedi: adv_pci1710: remove subdevice pointer math
      staging: comedi: adv_pci1723: remove subdevice pointer math
      staging: comedi: adv_pci_dio: remove subdevice pointer math
      staging: comedi: adv_pci_dio: clarify subdevice index in pci1760_attach()
      staging: comedi: adv_pci_dio: remove 'subdev' param from pci_dio_add_*()
      staging: comedi: aio_aio12_8: remove subdevice pointer math
      staging: comedi: aio_iiro_16: remove subdevice pointer math
      staging: comedi: amplc_dio200: remove subdevice pointer math
      staging: comedi: amplc_pc236: remove subdevice pointer math
      staging: comedi: amplc_pc263: remove subdevice pointer math
      staging: comedi: amplc_pci224: remove subdevice pointer math
      staging: comedi: amplc_pci230: remove subdevice pointer math
      staging: comedi: c6xdigio: remove subdevice pointer math
      staging: comedi: cb_das16_cs: remove subdevice pointer math
      staging: comedi: cb_pcidas: remove subdevice pointer math
      staging: comedi: cb_pcidas64: remove subdevice pointer math
      staging: comedi: cb_pcidda: remove subdevice pointer math
      staging: comedi: cb_pcidio: remove subdevice pointer math
      staging: comedi: cb_pcimdas: remove subdevice pointer math
      staging: comedi: cb_pcimdda: remove subdevice pointer math
      staging: comedi: comedi_bond: remove subdevice pointer math
      staging: comedi: comedi_parport: remove subdevice pointer math
      staging: comedi: comedi_test: remove subdevice pointer math
      staging: comedi: contec_pci_dio: remove subdevice pointer math
      staging: comedi: daqboard2000: remove subdevice pointer math
      staging: comedi: das08: remove subdevice pointer math
      staging: comedi: das16: remove subdevice pointer math
      staging: comedi: das16m1: remove subdevice pointer math
      staging: comedi: das1800: remove subdevice pointer math
      staging: comedi: das6402: remove subdevice pointer math
      staging: comedi: das800: 'dev->subdevices + 0' is already known
      staging: comedi: das800: remove subdevice pointer math
      staging: comedi: dmm32at: remove subdevice pointer math
      staging: comedi: dt2801: fix access to 2nd dio subdevice
      staging: comedi: dt2801: remove subdevice pointer math
      staging: comedi: dt2811: remove subdevice pointer math
      staging: comedi: dt2814: remove subdevice pointer math
      staging: comedi: dt2815: remove subdevice pointer math
      staging: comedi: dt2817: remove subdevice pointer math
      staging: comedi: dt282x: remove subdevice pointer math
      staging: comedi: dt3000: remove subdevice pointer math
      staging: comedi: dt9812: remove subdevice pointer math
      staging: comedi: dyna_pci10xx: remove subdevice pointer math
      staging: comedi: fl512: remove subdevice pointer math
      staging: comedi: gsc_hpdi: remove subdevice pointer math
      staging: comedi: icp_multi: remove subdevice pointer math
      staging: comedi: ii_pci20kc: remove subdevice pointer math
      staging: comedi: ke_counter: rename 'subdevice' variable to 's'
      staging: comedi: ke_counter: remove subdevice pointer math
      staging: comedi: me4000: remove subdevice pointer math
      staging: comedi: me_daq: rename 'subdevice' variable to 's'
      staging: comedi: me_daq: remove subdevice pointer math
      staging: comedi: mpc624: remove subdevice pointer math
      staging: comedi: mpc8260cpm: remove subdevice pointer math
      staging: comedi: multiq3: remove subdevice pointer math
      staging: comedi: ni_6527: remove subdevice pointer math
      staging: comedi: ni_65xx: remove subdevice pointer math
      staging: comedi: ni_660x: remove subdevice pointer math
      staging: comedi: ni_670x: remove subdevice pointer math
      staging: comedi: ni_at_a2150: remove subdevice pointer math
      staging: comedi: ni_at_ao: remove subdevice pointer math
      staging: comedi: ni_atmio16d: remove subdevice pointer math
      staging: comedi: ni_daq_700: remove subdevice pointer math
      staging: comedi: ni_daq_dio24: remove subdevice pointer math
      staging: comedi: ni_labpc: remove subdevice pointer math
      staging: comedi: ni_mio_common: remove subdevice pointer math
      staging: comedi: ni_pcidio: remove subdevice pointer math
      staging: comedi: pcl711: remove subdevice pointer math
      staging: comedi: pcl724: remove subdevice pointer math
      staging: comedi: pcl725: remove subdevice pointer math
      staging: comedi: pcl726: remove subdevice pointer math
      staging: comedi: pcl730: remove subdevice pointer math
      staging: comedi: pcl812: remove subdevice pointer math
      staging: comedi: pcl816: remove subdevice pointer math
      staging: comedi: pcl818: remove subdevice pointer math
      staging: comedi: pcm3724: remove subdevice pointer math
      staging: comedi: pcm3730: remove subdevice pointer math
      staging: comedi: pcmad: remove subdevice pointer math
      staging: comedi: pcmda12: remove subdevice pointer math
      staging: comedi: pcmmio: remove subdevice pointer math
      staging: comedi: pcmuio: remove subdevice pointer math
      staging: comedi: poc: remove subdevice pointer math
      staging: comedi: quatech_daqp_cs: remove subdevice pointer math
      staging: comedi: rtd520: remove subdevice pointer math
      staging: comedi: rti800: remove subdevice pointer math
      staging: comedi: rti802: remove subdevice pointer math
      staging: comedi: s526: remove subdevice pointer math
      staging: comedi: serial2002: remove subdevice pointer math
      staging: comedi: skel: remove subdevice pointer math
      staging: comedi: ssv_dnp: remove subdevice pointer math
      staging: comedi: usbdux: remove subdevice pointer math
      staging: comedi: usbduxfast: remove subdevice pointer math
      staging: comedi: usbduxsigma: remove subdevice pointer math
      staging: comedi: vmk80xx: remove subdevice pointer math
      staging: comedi: kcomedilib: remove subdevice pointer math
      staging: comedi: range: remove subdevice pointer math
      staging: comedi: me4000: remove ME4000_BOARD_VERSIONS
      staging: comedi: me4000: convert boardinfo initialization to C99 format
      staging: comedi: me4000: remove the '0' boardinfo data
      staging: comedi: me4000: remove struct me4000_cnt_info
      staging: comedi: me4000: remove struct me4000_dio_info
      staging: comedi: me4000: remove struct me4000_ai_info
      staging: comedi: me4000: remove struct me4000_ao_info
      staging: comedi: me4000: remove thisboard macro
      staging: comedi: me4000: move struct me4000_board definition
      staging: comedi: me4000: move pci vendor/device ids to source
      staging: comedi: me4000: remove struct me4000_cnt_context
      staging: comedi: me4000: don't save the pci resource sizes
      staging: comedi: me4000: remove the pci resource error messages
      staging: comedi: me4000: absorb get_registers() into its caller
      staging: comedi: me4000: remove the noise when probing the card
      staging: comedi: me4000: use dev->iobase for the card base address
      staging: comedi: me4000: remove dio context
      staging: comedi: me4000: remove ai context
      staging: comedi: me4000: remove serial_no from the private data
      staging: comedi: me4000: remove hw_revision from the private data
      staging: comedi: me4000: remove {vendor, device}_id from the private data
      staging: comedi: me4000: remove ao context
      staging: comedi: me4000: use dev->irq to save the irq number
      staging: comedi: me4000: absorb init_board_info() into its caller
      staging: comedi: me4000: remove info macro
      staging: comedi: me4000: remove me4000_ao_range
      staging: comedi: me4000: remove forward declarations
      staging: comedi: me4000: store the pci_dev in the comedi_device
      staging: comedi: me4000: cleanup me4000_probe()
      staging: comedi: me4000: use attach_pci callback
      staging: comedi: me4000: remove program_regbase from private data
      staging: comedi: me4000: combine the checks for valid io addresses
      staging: comedi: me4000: fix the interrupt request/free
      staging: comedi: me4000: add namespace to reset_board()
      staging: comedi: me4000: use the 8253 helper functions
      staging: comedi: me4000: cleanup me4000_cnt_insn_config()
      staging: comedi: me4000: remove ME4000_CNT_* defines
      staging: comedi: me4000: move struct me4000_info definition
      staging: comedi: me4000: remove me4000.h
      staging: comedi: me4000: convert printk's to dev_printk's
      staging: comedi: adl_pci9111: remove dev_private macro
      staging: comedi: adl_pci9111: remove pci9111_board_nbr macro
      staging: comedi: adl_pci9111: remove PCI9111_IO_BASE macro
      staging: comedi: adl_pci9111: remove pci9111_8254_* i/o macros
      staging: comedi: adl_pci9111: use 8253 helper functions
      staging: comedi: adl_pci9111: remove pci9111_d[io]_* i/o macros
      staging: comedi: adl_pci9111: cleanup pci9111_di_insn_bits()
      staging: comedi: adl_pci9111: cleanup pci9111_do_insn_bits()
      staging: comedi: adl_pci9111: remove pci9111_ao_set_data macro
      staging: comedi: adl_pci9111: cleanup pci9111_ao_insn_read()
      staging: comedi: adl_pci9111: cleanup ao resolution
      staging: comedi: adl_pci9111: cleanup pci9111_ao_insn_write()
      staging: comedi: adl_pci9111: remove AI_INSN_DEBUG code
      staging: comedi: adl_pci9111: cleanup pci9111_ai_munge()
      staging: comedi: adl_pci9111: remove pci9111_{hr_, )ai* macros
      staging: comedi: adl_pci9111: cleanup ai read in pci9111_ai_insn_read()
      staging: comedi: adl_pci9111: analog output subdevice is fixed
      staging: comedi: adl_pci9111: digital input/output subdevices are fixed
      staging: comedi: adl_pci9111: remove chanlist_len checks
      staging: comedi: adl_pci9111: remove 'single' channel list check
      staging: comedi: adl_pci9111: analog input subdevice is fixed
      staging: comedi: adl_pci9111: remove the board attach noise
      staging: comedi: adl_pci9111: remove the io_range values from the private data
      staging: comedi: adl_pci9111: use attach_pci callback
      staging: comedi: adl_pci9111: remove AI_DO_CMD_DEBUG code
      staging: comedi: adl_pci9111: remove INTERRUPT_DEBUG code
      staging: comedi: adl_pci9111: use local variables for the chan/range
      staging: comedi: adl_pci9111: remove pci9111_ai_range_[gs]et macros
      staging: comedi: adl_pci9111: remove pci9111_ai_channel_[gs]et macros
      staging: comedi: adl_pci9111: remove pci9111_is_fifo_* macros
      staging: comedi: adl_pci9111: remove pci9111_interrupt_clear macro
      staging: comedi: adl_pci9111: remove pci9111_interrupt_and_fifo_[sg]et macros
      staging: comedi: adl_pci9111: remove pci9111_trigger_and_autoscan_[sg]et macros
      staging: comedi: adl_pci9111: change pci9111_fifo_reset into a function
      staging: comedi: adl_pci9111: cleanup the io register map
      staging: comedi: adl_pci9111: cleanup pci9111_hr_ai_range
      staging: comedi: adl_pci9111: cleanup timer_divisor_[12]
      staging: comedi: adl_pci9111: remove unnecessary 'is_valid'
      staging: comedi: comedi_fc: introduce cfc_check_trigger_src
      staging: comedi: adl_pci9111: use cfc_check_trigger_src
      staging: comedi: adl_pci9111: single source triggers are unique
      staging: comedi: comedi_fc: introduce cfc_check_trigger_is_unique
      staging: comedi: adl_pci9111: use cfc_check_trigger_is_unique
      staging: comedi: adl_pci9111: remove extra i8253_cascade_ns_to_timer_2div()
      staging: comedi: adl_pci9111: remove unnecessary comments
      staging: comedi: icp_multi: convert to a pci_driver
      staging: comedi: icp_multi: remove ICP_MULTI_EXTDEBUG
      staging: comedi: icp_multi: remove n_ctrs from boardinfo
      staging: comedi: icp_multi: remove n_dochan from boardinfo
      staging: comedi: icp_multi: remove n_dichan from boardinfo
      staging: comedi: icp_multi: remove n_aochan from boardinfo
      staging: comedi: icp_multi: remove n_aichan from boardinfo
      staging: comedi: icp_multi: remove n_aichand from boardinfo
      staging: comedi: icp_multi: remove ao_maxdata from boardinfo
      staging: comedi: icp_multi: remove ai_maxdata from boardinfo
      staging: comedi: icp_multi: remove ranglist_ao from boardinfo
      staging: comedi: icp_multi: remove rangelist_ai from boardinfo
      staging: comedi: icp_multi: remove rangecode from boardinfo
      staging: comedi: icp_multi: remove cardtype from boardinfo
      staging: comedi: icp_multi: remove iorange from boardinfo
      staging: comedi: icp_multi: remove have_irq from boardinfo
      staging: comedi: icp_multi: the number of subdevices is fixed
      staging: comedi: icp_multi: remove board attach noise
      staging: comedi: icp_multi: use attach_pci callback
      staging: comedi: icp_multi: remove devpriv macro
      staging: comedi: icp_multi: remove the function description comments
      staging: comedi: adl_pci9111: remove pci_dev_put()
      staging: comedi: adv_pci1710: remove board attach noise
      staging: comedi: adv_pci1710: use attach_pci callback
      staging: comedi: adv_pci1710: remove unnecessary 'valid'
      staging: comedi: adv_pci1710: remove "dummy" boardinfo entry
      staging: comedi: adv_pci1710: use cfc_check_trigger_src
      staging: comedi: adv_pci1710: single source triggers are unique
      staging: comedi: adv_pci1710: use cfc_check_trigger_is_unique
      staging: comedi: adl_pci9118: remove devpriv and this_board macros
      staging: comedi: adl_pci9118: remove PCI9118_EXTDEBUG and DPRINTK
      staging: comedi: adl_pci9118: remove the function separation comments
      staging: comedi: adl_pci9118: remove commented out printk debug
      staging: comedi: adl_pci9118: remove forward declarations
      staging: comedi: adl_pci9118: use cfc_check_trigger_src
      staging: comedi: adq12b: remove devpriv macro
      staging: comedi: rename adl_pci7296 driver
      staging: comedi: 8255_pci: fix namespace due to rename of driver
      staging: comedi: remove cb_pcidio driver
      staging: comedi: 8255_pci: add support for the PCI-DIO96H board
      staging: comedi: 8255_pci: add vendor id to boardinfo
      staging: comedi: 8255_pci: support memory mapped i/o boards
      staging: comedi: 8255_pci: move ni_pcidio 8255 board support
      staging: comedi: comedi_fops: make internal function static
      staging: comedi: ni_mio_common: make internal functions static
      staging: comedi: jr3_pci.h: remove vect_bits_t and warning_bits_t
      staging: comedi: jr3_pci: local functions should not be exported
      staging: comedi: ni_660x: local functions should not be exported
      staging: comedi: ni_pcidio: local functions should not be exported
      staging: comedi: ni_daq_dio24: local symbols should not be exported
      staging: comedi: ni_labpc_cs: local symbols should not be exported
      staging: comedi: ni_mio_cs: local symbols should not be exported
      staging: comedi: mite: local symbols should not be exported
      staging: comedi: pcmmio: remove kernel messages about IRQ
      staging: comedi: pcmuio: pointers should be cleared with NULL
      staging: comedi: jr3_pci: quiet "Using plain interger as NULL pointer" noise
      staging: comedi: comedi.h: remove the extra indents
      staging: comedi: comedi.h: remove __user tag from chanlist
      staging: comedi: comedi_fops: rename the __user *cmd param in do_cmd_ioctl
      staging: comedi: comedi_fops: rename user_cmd in do_cmd_ioctl
      staging: comedi: comedi_fops: rename user_cmd in do_cmdtest_ioctl
      staging: comedi: comedi_fops: cast the cmd->chanlist to the correct address space
      staging: comedi: daqboard2000: remove struct daqboard2000_hw
      staging: comedi: daqboard2000: remove this_board and devpriv macros
      staging: comedi: daqboard2000: use request_firmware()
      staging: comedi: daqboard2000: use attach_pci callback
      staging: comedi: daqboard2000: remove range_daqboard2000_ao
      staging: comedi: daqboard2000: cleanup range_daqboard2000_ai
      staging: comedi: daqboard2000: remove the commented out debug messages
      staging: comedi: daqboard2000: remove DEBUG_EEPROM messages
      staging: comedi: daqboard2000: remove the dev_printk function trace
      staging: comedi: daqboard2000: remove the "test command" comment
      staging: comedi: daqboard2000: use the driver name for the resource name
      staging: comedi: daqboard2000: add a dev_info message after attach
      staging: comedi: daqboard2000: use the pci_resource_len()
      staging: comedi: daqboard2000: remove local variable in daqboard2000_attach_pci()
      staging: comedi: s526: don't dereference insn->data pointer
      staging: comedi: s526: remove devpriv macro
      staging: comedi: s526: remove ADDR_REG macro
      staging: comedi: s526: remove ADDR_CHAN_REG macro
      staging: comedi: s526: remove commented out debug messages
      staging: comedi: s526: remove unneeded check in s526_gpct_rinsn()
      staging: comedi: s526: remove unreachable code in s526_attach()
      staging: comedi: s526: remove printk noise
      staging: comedi: s526: remove unused s526_ports array
      staging: comedi: s526: remove cut-and-paste comments from skel driver
      staging: comedi: s526: remove boardinfo
      staging: comedi: s526: rename local var used for CR_CHAN() value
      staging: comedi: s526: cleanup s526_gpct_rinsn()
      staging: comedi: s526: cleanup s526_gpct_insn_config()
      staging: comedi: s526: cleanup s526_gpct_winsn()
      staging: comedi: s526: remove struct s526GPCTConfig
      staging: comedi: s526: rename s526_ai_config
      staging: comedi: usbduxsigma: remove usbduxsigma_attach
      staging: comedi: usbduxfast: remove usbduxfast_attach
      staging: comedi: usbdux: remove usbdux_attach
      staging: comedi: me_daq: use request_firmware()
      staging: comedi: me_daq: use attach_pci callback
      staging: comedi: kcomedilib: fix a __user space access issue
      staging: comedi: 8253: mmio address is a void __iomem *
      staging: comedi: s626: remove boardinfo
      staging: comedi: s626: use attach_pci callback
      staging: comedi: s626: store the pci_dev in the comedi_device
      staging: comedi: s626: use dev->board_name for resource name
      staging: comedi: s626: remove unneeded local variable in attach_pci()
      staging: comedi: s626: remove 'got_regions' from private data
      staging: comedi: s626: cleanup ioremap()
      staging: comedi: s626: remove unnecessary checks of 'devpriv->base_addr'
      staging: comedi: s626: factor out the dma buffer allocation
      staging: comedi: s626: cleanup request_irq in s626_attach_pci()
      staging: comedi: s626: factor out the board init code
      staging: comedi: s626: remove unneeded clear of private data
      staging: comedi: s626: add final attach message
      staging: comedi: s626: remove 'allocatedBuf' from private data
      staging: comedi: s626: #if 0 out the "SAA7146 BUG WORKAROUND"
      staging: comedi: s626: remove 'IsBoardRevA' comment
      staging: comedi: s626: remove 'ChargeEnabled' from private data
      staging: comedi: s626: remove 'WDInterval' from private data
      staging: comedi: s626: remove clear of kzalloc'ed data
      staging: comedi: s626: cleanup comments in s626_initialize()
      staging: comedi: s526: fix if() check in s526_gpct_winsn()
      staging: comedi: drivers: use comedi_fc.h cmdtest helpers

H Hartley Sweeten dev (1):
      staging: comedi: adl_pci9111: remove pci9111_software_trigger macro

Harsh Kumar (8):
      staging: winbond: Coding Style correction and removal of unused macro
      Staging: winbond: Changed c99 comments to c89 comments
      Staging: winbond: Removed undesired spaces, lines and tabs
      Staging: winbond: Changed c99 comments to c89 comments
      Staging: winbond: Typo corrections in comments
      Staging: winbond: Removed undesired spaces, lines and tabs
      Staging: winbond: checkpatch cleanup
      Staging: winbond: usb_free_urb(NULL) is safe

Ian Abbott (88):
      staging: comedi: amplc_dio200: abbreviate IS_ENABLED()
      staging: comedi: amplc_dio200: check bus type in detach routine
      staging: comedi: amplc_dio200: add helper macros to check bus type
      staging: comedi: make attach handler optional
      staging: comedi: amplc_dio200: replace macros with inline functions
      staging: comedi: amplc_pc263: add helper functions to check bus type
      staging: comedi: amplc_pc263: check bus type in detach routine
      staging: comedi: amplc_pc263: abbreviate IS_ENABLED()
      staging: comedi: amplc_pc236: add helper functions to check bus type
      staging: comedi: amplc_pc236: check bus type in detach routine
      staging: comedi: amplc_pc236: check bus type before accessing LCR
      staging: comedi: amplc_pc236: abbreviate IS_ENABLED()
      staging: comedi: replace printk calls in comedi core
      staging: comedi: serial2002: Set range for digital inputs and outputs
      staging: comedi: das08: Remove pc104 bustype value
      staging: comedi: das08: Add number of DI channels in board structure
      staging: comedi: das08: Mark 'JR' boards in board data
      staging: comedi: das08: Remove function pointers from board structure
      staging: comedi: das08: Avoid zero initializers in board structure
      staging: comedi: das08,das08_cs: Move das08_cs_boards[]
      staging: comedi: das08: Remove dead code
      staging: comedi: das08: Remove pci_iobase from private data
      staging: comedi: das08: Remove i8254_iobase from private data
      staging: comedi: das08: No need to check insn->n for counter config
      staging: comedi: das08: Unmark some __maybe_unused functions
      staging: comedi: das08: Rearrange AO write functions
      staging: comedi: das08: Initialize AO channels
      staging: comedi: das08: Support read-back of AO subdevice
      staging: comedi: das08: Remove manual configuration of PCI boards
      staging: comedi: das08: absorb das08_pci_attach_common()
      staging: comedi: das08: Don't report iobase for PCI device
      staging: comedi: das08: Add helper functions to check bus type
      staging: comedi: das08: abbreviate IS_ENABLED()
      staging: comedi: das08: No need to manipulate PCI ref count
      staging: comedi: das08: Use struct comedi_device hw_dev for PCI
      staging: comedi: ni_6527: convert printk() to dev_...()
      staging: comedi: ni_6527: change driver name string
      staging: comedi: ni_6527: use module_comedi_pci_driver()
      staging: comedi: ni_6527: move ni6527_driver
      staging: comedi: ni_6527: use comedi attach_pci callback
      staging: comedi: ni_65xx: convert printk() to dev_...()
      staging: comedi: ni_65xx: use module_comedi_pci_driver()
      staging: comedi: ni_65xx: move ni_65xx_driver
      staging: comedi: ni_65xx: use comedi attach_pci callback
      staging: comedi: ni_660x: convert printk() to dev_...()
      staging: comedi: ni_660x: use module_comedi_pci_driver()
      staging: comedi: ni_660x: use comedi attach_pci callback
      staging: comedi: ni_670x: use comedi attach_pci callback
      staging: comedi: ni_labpc: convert printk() to dev_...()
      staging: comedi: ni_labpc: use module_comedi_pci_driver()
      staging: comedi: ni_labpc: move labpc_driver and labpc_pci_table
      staging: comedi: ni_labpc: use comedi attach_pci callback
      staging: comedi: ni_pcidio: convert printk() calls
      staging: comedi: ni_pcidio: use request_firmware()
      staging: comedi: ni_pcidio: use comedi attach_pci callback
      staging: comedi: ni_mio_common: don't pass config options to ni_E_init()
      staging: comedi: ni_pcimio: Add semicolon to module_comedi_pci_driver()
      staging: comedi: ni_pcimio: Use comedi attach_pci callback
      staging: comedi: mite: make internal functions static
      staging: comedi: mite: export mite_alloc_ring() and mite_free_ring()
      staging: comedi: mite: use ilog2()
      staging: comedi: mite: replace printk() calls
      staging: comedi: mite: add mite_alloc() and mite_free()
      staging: comedi: ni_6527: use mite_alloc()
      staging: comedi: ni_65xx: use mite_alloc()
      staging: comedi: ni_660x: use mite_alloc()
      staging: comedi: ni_670x: use mite_alloc()
      staging: comedi: ni_670x: remove spurious free_irq() call
      staging: comedi: ni_labpc: use mite_alloc()
      staging: comedi: ni_pcidio: use mite_alloc()
      staging: comedi: ni_pcimio: use mite_alloc()
      staging: comedi: mite: remove list of devices
      staging: comedi: mite: use module_init()/module_exit()
      staging: comedi: fix sparse warning in do_devconfig_ioctl()
      staging: comedi: sparse warning in insn_rw_emulate_bits()
      staging: comedi: don't dereference user memory for INSN_INTTRIG
      staging: comedi: ni_labpc: pass ai scan mode through various functions
      staging: comedi: fix memory leak for saved channel list
      staging: comedi: das16: pass struct comedi_cmd by reference
      staging: comedi: das1800: don't pass struct comedi_cmd by value
      staging: comedi: ni_labpc: don't pass struct comedi_cmd by value
      staging: comedi: ni_daq_700: use prefix daq700
      staging: comedi: ni_daq_700: rename functions for DIO subdevice
      staging: comedi: ni_daq_700: add AI subdevice
      staging: comedi: s626: don't dereference insn->data
      staging: comedi: s626: add FIXME comment
      staging: comedi: ni_mio_common: always lock in ni_ai_poll()
      staging: comedi: jr3_pci: fix iomem dereference

J Keerthy (1):
      staging: omap-thermal: Correct checkpatch.pl warnings

Javier M. Mellid (7):
      staging: sm7xxfb: clean fb_fix_screeninfo and fb_var_screeninfo initialization
      staging: sm7xxfb: clean smtcfb_fix's id initialization
      staging: sm7xxfb: cleanup on smtc_alloc_fb_info
      staging: sm7xxfb: annotate iomem pointers
      staging: sm7xxfb: rename some smtcfb_info fields
      staging: sm7xxfb: rename pFramebufferPhysical to mmio_base
      staging: sm7xxfb: remove smtc_VRAMBaseAddress

Jean-Francois Dagenais (2):
      iio:ad5446: Add support for I2C based DACs
      iio:ad5446: get rid of private header file

Jens Taprogge (52):
      Staging: ipack/bridges/tpci200: Reorganize tpci200_probe in preparation for functional changes.
      Staging: ipack/bridges/tpci200: Use the TPCI200 in big endian mode.
      Staging: ipack/devices/ipoctal: Convert ipoctal to directly use ioread/write functions.
      Staging: ipack/bridges/tpci200: Remove the read/write functions from ipack_bus_ops.
      Staging: ipack/devices/ipoctal: ipoctal cleanups.
      Staging: ipack/devices/ipoctal: Tidy up ipoctal some more.
      Staging: ipack: implement ipack device table.
      Staging: ipack: Read the ID space during device registration.
      Staging: ipack: Parse vendor and device id.
      Staging: ipack: Move device ids from ipoctal.c to ipack_ids.h.
      Staging: ipack: Make ipack_driver_ops const.
      Staging: ipack/devices/ipoctal: Expose DEVICE_TABLE for ipoctal.
      Staging: ipack: Implement device matching on the bus level.
      Staging: ipack: Expose modalias through sysfs.
      Staging: ipack: Provide ID Prom through sysfs.
      staging: ipack: only build on platforms that provide ioread/iowrite.
      staging/ipack: Fix bug introduced by IPack device matching
      Staging: ipack/bridges/tpci200: Put the TPCI200 control registers into a struct.
      Staging: ipack: Provide several carrier callbacks.
      Staging: ipack/bridges/tpci200: provide new callbacks to tpci200
      Staging: ipack: Obtain supported speeds from ID ROM.
      Staging: ipack: Choose the optimum bus speed by default.
      Staging: ipack: remove field driver from struct ipack_device.
      Staging: ipack: Switch to 8MHz operation before reading ID.
      Staging: ipack: reset previous timeouts during device registration.
      Staging: ipack: check the device ID space CRC.
      Staging: ipack/bridges/tpci200: Store the irq holder in slot_irq.
      Staging: ipack/bridges/tpci200: add helpers for writing control regs.
      Staging: ipack/bridges/tpci200: Remove side effects of tpci200_{request,free}_irq.
      Staging: ipack/bridges/tpci200: Clean up interrupt handler.
      Staging: ipack/devices/ipoctal: split ipoctal_channel from ipoctal.
      Staging: ipack/devices/ipoctal: Directly use ioread/iowrite function.
      Staging: ipack/devices/ipoctal: put ipoctal_channel into tty->driver_data.
      Staging: ipack/devices/ipoctal: Store isr masks in ipoctal_channel
      Staging: ipack/devices/ipoctal: Split interrupt service routine.
      Staging: ipack/devices/ipoctal: remove superfluous function.
      Staging: ipack/bridges/tpci200: RCU protect slot_irq pointers.
      Staging: ipack/bridges/tpci200: Protect device registers with spinlock.
      Staging: ipack/bridges/tpci200: Clean up interrupt handling.
      Staging: ipack/bridges/tpci200: Cleanup in tpci200_slot_irq() and tpci200_interrupt()
      Staging: ipack/bridges/tpci200: More cleanups.
      Staging: ipack/bridges/tpci200: move tpci200_free_irq() and tpci200_request_irq()
      Staging: ipack: Let interrupts return irqreturn_t.
      Staging: ipack/devices/ipoctal: Clean up device removal.
      Staging: ipack/devices/ipoctal: Check tty_register_device return value.
      Staging: ipack/devices/ipoctal: Use KBUILD_MODNAME instead of hardcoded string.
      Staging: ipack/devices/ipoctal: Get rid of ipoctal_list.
      Staging: ipack/devices/ipoctal: Unmap memory on device removal.
      staging: ipack/bridges/tpci200: Use endianess-aware types where applicable.
      Staging: ipack: Add IPACK_INT_SPACE memory space.
      Staging: ipack: move the responsibility to clear interrupts to the IPack devices.
      staging: ipack: remove irq field in struct ipack_device.

Jesper Juhl (3):
      staging: csr: Fix up version.h includes
      staging: vt6656: don't leak 'param' in vt6656_hostap_ioctl() when returning -EOPNOTSUPP
      staging: speakup: i18n.c: Fix leak in msg_set()

Johannes Thumshirn (2):
      staging: line6: pcm.c: Changed simple_strtoul to kstrtoint
      staging: line6: variax.c: Eliminated remaining strict_stroul()s

Jonathan Brett (3):
      staging: asus_oled: Change printk calls to dev_xxx
      staging: asus_oled add MODULE_VERSION
      Staging: asus_oled: Add suspend/resume callbacks

Jonathan Cameron (6):
      iio:kfifo_buf Take advantage of the fixed record size used in IIO
      iio:kfifo_buf improve error handling in read_first_n.
      iio: kfifo - add poll support.
      IIO: Update email address for Jonathan Cameron.
      staging:iio: Update email address for Jonathan Cameron.
      staging:iio: hid-sensors Use iio_push_to_buffer

Julia Lawall (4):
      drivers/iio/adc/at91_adc.c: use devm_ functions
      drivers/staging/iio/adc/spear_adc.c: use clk_prepare_enable and clk_disable_unprepare
      drivers/iio/adc/at91_adc.c: use clk_prepare_enable and clk_disable_unprepare
      drivers/staging/crystalhd/crystalhd_lnx.c: adjust inconsistent IS_ERR and PTR_ERR

Justin P. Mattock (13):
      staging: tidspbridge: Fix typos.
      staging "usbip" Fix typos.
      staging "vme" Fix typos.
      staging: "vt6655" Fix typos in comments.
      staging: "vt6655" Typo change *Embeded to *Embedded.
      staging: "vt6655" Typo change *Caculate to *Calculate.
      staging "vt6656" Fix typos in comments, and in a printk message.
      staging "vt6656" Typo rename Caculate to Calculate.
      staging "vt6656" Typo rename Embeded to Embedded.
      staging: "winbond" Fix typos.
      staging: "wlags49_h2" Fix typos.
      staging: "wlags49_h25" Fix typos.
      staging "wlan-ng" Fix typos.

Kevin McKinney (20):
      Staging: bcm: Fix white space issues in InterfaceInit.h
      Staging: bcm: Convert INT to int in InterfaceInit.h
      Staging: bcm: Create and initialize new device id in InterfaceInit
      Staging: bcm: Fix all white space issues in Transmit.c
      Staging: bcm: Properly format braces in Transmit.c
      Staging: bcm: Remove initialization from if statement in Transmit.c
      Staging: bcm: Properly format comments in Transmit.c
      Staging: bcm: Convert INT to int in Transmit.c
      Staging: bcm: Fix all white space issues in cntrl_SignalingInterface.h
      Staging: bcm: Properly format comments in cntrl_SignalingInterface.h
      Staging: bcm: Properly format braces in cntrl_SignalingInterface.h
      Staging: bcm: Remove typedef for _stIM_sfHostNotify and call directly.
      Staging: bcm: Remove typedef for stLocalSFDeleteIndication and call directly.
      Staging: bcm: Remove typedef for _stLocalSFDeleteRequest and call directly.
      Staging: bcm: Remove typedef for _stLocalSFAddIndication and call directly.
      Staging: bcm: Remove typedef for _stLocalSFAddRequest and call directly.
      Staging: bcm: Remove typedef for _stServiceFlowParamSI and call directly.
      Staging: bcm: Remove typedef for _stConvergenceSLTypes and call directly.
      Staging: bcm: Remove typedef for _stPhsRuleSI and call directly.
      Staging: bcm: Remove typedef for _stCPacketClassificationRuleSI and call directly.

Kim, Milo (6):
      iio: use IIO_CHAN_INFO_RAW rather than 0
      iio: inkern: allocate zeroed memory
      iio: inkern: add error case in iio_channel_get()
      iio: inkern: put the IIO device when it fails to allocate memory
      iio: inkern: clean up error return code
      iio: adc: add new lp8788 adc driver

Larry Finger (4):
      staging: r8712u: Reduce maximum receive buffer size to a more sensible value
      staging: r8712u: Fix allocations not checked for failure
      staging: r8712u: Remove defines that are not used
      staging: r8712u: Do not queue cloned skb

Lars-Peter Clausen (51):
      staging:iio:adis16220: Use kobj_to_dev instead of open-coding it
      staging:iio: Constify static iio_chan_spec arrays
      staging:iio:ad7793: Remove unused platform_data from device state struct
      staging:iio:ad7192: Remove unused platform_data from device state struct
      iio: Introduce iio_device_{set,get}_drvdata()
      iio:adc: Add common code for ADI Sigma Delta devices
      staging:iio:ad7780: Use common Sigma Delta library
      staging:iio:ad7793: Use common Sigma Delta library
      staging:iio:ad7192: Use common Sigma Delta library
      staging:iio:ad7793: Add support for ad7794/ad7795
      staging:iio:ad7793: Add ad7785 support
      iio:consumer.h: Fix include guard
      iio: Add missing include guards to headers
      iio:trigger_consumer.h: Add missing includes and forward declarations
      staging:iio: Add missing __devinit and __devexit annotations
      staging:iio:sysfs-trigger: Use irq_work to properly active trigger
      staging:iio: Use iio_push_to_buffer
      iio: Drop timestamp parameter from buffer store_to callback
      iio:ad5446: Add support for the ad5300/ad5310/ad5320
      iio:ad5446: Add device ids for ad5301/ad5311/ad5321
      staging:iio:adc: Add AD7791 driver
      staging:iio:ad7476: Fix off by one error for channel shift
      staging:iio:ad7476: Remove duplicated chip info entries
      staging:iio:ad7476: Avoid alloc/free for each sample in buffered mode
      staging:iio:ad7476: Rework reference voltage handling
      staging:iio:ad7476: Squash driver into a single file.
      staging:iio:ad7476: Use be16_to_cpup instead of open-coding it
      iio: Move ad7476 driver out of staging
      iio:ad7476: Add ad7910/ad7920 device table entries
      iio:ad7476: Add ad7940 support
      iio:ad7476: Add support for ad7273/ad7274/ad7276/ad7277/ad7278
      iio: Introduce a new fractional value type
      iio:dac: Add ad5755 driver
      iio: consumer.h: Fix kernel doc incosistency
      iio:inkern: Add function to read the processed value
      staging:iio:hwmon bridge: Use iio_read_channel_processed
      staging:iio:trigger:bfintmr: Avoid divide by zero
      staging:iio:trigger:bfintmr: Only enable timer when necessary
      staging:iio:trigger:bfintmr Add output support
      iio: ad7476: Add support for the ad7091r
      staging:iio:adis16200: Do not return a error in remove function
      staging:iio:adis16400: Do not return a error in remove function
      staging:iio:ade7753: Do not return a error in remove function
      staging:iio:ade7754: Do not return a error in remove function
      staging:iio:ade7758: Do not return a error in remove function
      staging:iio:ade7759: Do not return a error in remove function
      staging:iio:lis3l02dq: Do not return a error in remove function
      staging:iio:sca3000: Do not return a error in remove function
      staging:iio:ad7780: Make powerdown GPIO optional
      staging:iio:ad7780: Add support for the ad7170/ad7171
      staging:iio:dummy: Fix potential NULL pointer dereference

Lauri Hintsala (1):
      staging: csr: wait for the exec in usermodehelper

Macpaul Lin (5):
      staging/gdm72xx: remove camel-case vars in gdm_qos
      staging/gdm72xx: gdm_usb coding style clean up
      staging/gdm72xx: usb_boot: coding style cleanup
      staging/gdm72xx: usb_boot: replace firmware upgrade API
      staging/gdm72xx: usb_boot: replace firmware upgrade API in em_download

Marc Dietrich (4):
      Staging: nvec: fix coding style issues
      staging: nvec: fix clock setup
      staging: nvec: release sync write lock in error case
      staging: nvec: do not depend on MACH_PAZ00

Marcus Karlsson (1):
      staging: zcache: fix spelling of comment

Marek Belisko (3):
      staging:ccg: Fix missing brackets for sizeof (found by sparse).
      staging: ft1000: Fix ft1000_control function timeout argument usage.
      staging: ft1000: Replace timeout values with USB_CTRL_G(S)ET_TIMEOUT.

Marek Vasut (2):
      IIO: Add 4-byte unsigned reads into generic-buffer example
      IIO: Add basic MXS LRADC driver

Masanari Iida (7):
      staging: vt6656: Fix typo in vt6656
      staging: rtl8192e: Fix typo in staging/rtl8192e
      staging: rtl8187se: Fix typo in staging/rtl8187se
      staging: rtl8192u: Fix typo in staging/rtl8192u
      staging: bcm: Fix typo in drivers/bcm
      staging: ozwpan: Fix typo in staging/ozwpan
      staging: wlags49_h2: Fix typo in staging/wlags49_h2 driver

Omar Ramirez Luna (1):
      staging: tidspbridge: fix uuid strings

Peter Meerwald (5):
      staging iio: lis3l02dq cleanup
      iio: document missing elements
      iio: fix typos
      iio: whitespace cleanup and removal of semicolon after functions
      iio: fix spelling of subsystem

Peter Senna Tschudin (2):
      drivers/staging/rtl8192u/r8192U_core.c: Remove useless kfree
      drivers/staging/gdm72xx/gdm_sdio.c: Remove useless kfree

Philipp Zabel (1):
      staging: drm/imx: Add devicetree binding documentation

Priit Laes (14):
      staging: csr: netdev.c: Clean up KERNEL_VERSION checks: <=2.6.25
      staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.27
      staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.28
      staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.29
      staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.32
      staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.34
      staging: csr: netdev.c: Clean up KERNEL_VERSION checks: 2.6.37
      staging: csr: remove unused define ALLOW_Q_PAUSE
      staging: csr: Drop unused UNIFI_NET_NAME configuration option
      staging: csr: drv.c: Remove KERNEL_VERSION checks and associated defines
      staging: csr: unifi_wext.h: Remove KERNEL_VERSION checks
      staging: csr: unifi_priv.h: Remove KERNEL_VERSION checks
      staging: csr: Remove unneeded UF_NETIF_TX_* macros
      staging: csr: Remove all leftover kernel version checks \o/

Radhesh Fadnis (1):
      staging: omap-thermal: bandgap: fix setting of alert thresholds

Randy Dunlap (3):
      staging: fix ccg build when NET is not enabled
      staging: fix csr printk format warning
      staging: fix silicom dependencies and build errors

Rob Clark (3):
      staging: drm/omap: add rotation properties
      staging: drm/omap: invert dimensions on crtc when rotated
      staging: drm/omap: hold a ref to the bo while waiting for flip

Robert P. J. Day (1):
      Staging: sep: Correct misspelled "remap_page_range" -> "remap_pfn_range"

Rupesh Gujare (5):
      staging: ozwpan: buffer frame if urb not available.
      staging: ozwpan: Insulate driver from HZ value
      staging: ozwpan: Return correct actual_length to userland
      staging: ozwpan: isoc latency for audio burst
      staging: ozwpan: Bump version number

Sachin Kamat (2):
      Staging: android: binder: Make task_get_unused_fd_flags function static
      Staging: android: binder: Remove an inconsequential conditional macro

Samuel Iglesias Gonsalvez (4):
      Staging: ipack/devices/ipoctal: read more than one character from RX FIFO.
      Staging: ipack: update TODO file
      Staging: ipack/devices/ipoctal: acknowledge BREAK condition.
      Staging: ipack/devices/ipoctal: simplify ipoctal_write_tty()

Samuel Iglesias Gonsálvez (15):
      Staging: ipack/bridges/tpci200: avoid kernel bug when uninstalling a device
      Staging: ipack/bridges/tpci200: remove linked list of registered devices
      Staging: ipack/bridges/tpci200: use ioremap_nocache instead of ioremap
      Staging: ipack: remove read/write operations from ipack_bus_ops
      Staging: ipack: fix build failure in powerpc allyesconfig
      Staging: ipack/bridges/tpci200: remove struct list_head
      Staging: ipack/bridges/tpci200: reorder the iounmap and pci_release_region
      Staging: ipack/bridges/tpci200: increment the reference counter of the pci_dev
      Staging: ipack/bridges/tpci200: fix the uninstall the ipack device
      Staging: ipack/devices/ipoctal: change exiting procedure
      Staging: ipack/devices/ipoctal: free the IRQ.
      Staging: ipack: unregister devices when uninstall the carrier device.
      Staging: ipack/bridges/tpci200: delete ipack_device_unregister calls when exiting
      Staging: ipack/bridges/tpci200: remove tpci200_slot_unregister
      Staging: ipack: delete .remove_device() callback

Samuel Thibault (1):
      speakup: lower default software speech rate

Sascha Hauer (5):
      staging: drm/imx: Add i.MX drm core support
      staging: drm/imx: Add parallel display support
      staging: drm/imx: add i.MX IPUv3 base driver
      staging: drm/imx: Add i.MX IPUv3 crtc support
      staging: drm/imx: Add TODO

Seth Jennings (4):
      staging: zsmalloc: s/firstpage/page in new copy map funcs
      staging: zsmalloc: prevent mappping in interrupt context
      staging: zsmalloc: add page table mapping method
      zsmalloc: collapse internal .h into .c

Srinivas Pandruvada (1):
      iio: hid-sensors: Prevent crash during hot-unplug

Stephen Hemminger (2):
      staging: tpci200: fix section mismatch warning
      staging: ipack: make function tables const.

Stephen Rothwell (1):
      HID: sensors: fix up for mfd_add_devices() API change

Tejun Heo (2):
      staging: omapdrm: use alloc_ordered_workqueue() instead of UNBOUND w/ max_active = 1
      staging: nvec: use system_nrt_wq instead of custom one

Tim Gardner (1):
      staging rtl8192e: Declare MODULE_FIRMWARE usage

Tony Lindgren (1):
      staging: tidspbridge: Prepare for irqs.h removal

Toshiaki Yamane (67):
      staging: panel: fix checkpatch warnings
      staging/olpc_dcon: fix checkpatch warnings
      staging/rts_pstor: remove braces {} in rtsx_card.c
      staging/rts_pstor: remove braces {} in rtsx_transport.c
      staging/rts_pstor: remove braces {} in rtsx_chip.c
      Staging: vme: Fix a white space issue
      staging/vme: Use pr_ printks in vme_pio2_core.c
      staging/rts_pstor: remove braces {} in sd.c (sd_send_cmd_get_rsp)
      staging/rts_pstor: remove braces {} in sd.c (sd_read_data)
      staging/rts_pstor: remove braces {} in sd.c (sd_write_data)
      staging/rts_pstor: remove braces {} in sd.c (sd_check_csd)
      staging/rts_pstor: remove braces {} in sd.c (sd_set_sample_push_timing)
      staging/rts_pstor: remove braces {} in sd.c (sd_choose_proper_clock)
      staging/rts_pstor: remove braces {} in sd.c (sd_set_clock_divider)
      staging/rts_pstor: remove braces {} in sd.c (sd_set_init_para)
      staging/rts_pstor: remove braces {} in sd.c (sd_select_card)
      staging/rts_pstor: remove braces {} in sd.c (sd_update_lock_status)
      staging/rts_pstor: remove braces {} in sd.c (sd_wait_state_data_ready)
      staging/rts_pstor: remove braces {} in sd.c (sd_change_bank_voltage)
      staging/rts_pstor: remove braces {} in sd.c (sd_voltage_switch)
      staging/rts_pstor: remove braces {} in sd.c (sd_change_phase)
      staging/rts_pstor: remove braces {} in sd.c (sd_check_spec)
      staging/rts_pstor: remove braces {} in sd.c (sd_check_switch_mode)
      staging/rts_pstor: remove braces {} in sd.c (downgrade_switch_mode)
      staging/rts_pstor: remove braces {} in sd.c (sd_check_switch)
      staging/rts_pstor: remove braces {} in sd.c (sd_switch_function)
      staging/rts_pstor: remove braces {} in sd.c (sd_sdr_tuning_rx_cmd)
      staging/rts_pstor: remove braces {} in sd.c (sd_ddr_tuning_rx_cmd)
      staging/rts_pstor: remove braces {} in sd.c (mmc_ddr_tunning_rx_cmd)
      staging/rts_pstor: remove braces {} in sd.c (sd_sdr_tuning_tx_cmd)
      staging/rts_pstor: remove braces {} in sd.c (sd_ddr_tuning_tx_cmd)
      staging/rts_pstor: remove braces {} in sd.c (sd_search_final_phase)
      staging/rts_pstor: remove braces {} in sd.c (sd_tuning_rx)
      staging/rts_pstor: remove braces {} in sd.c (sd_ddr_pre_tuning_tx)
      staging/rts_pstor: remove braces {} in sd.c (sd_tuning_tx)
      staging/rts_pstor: remove braces {} in sd.c (sd_sdr_tuning)
      staging/rts_pstor: remove braces {} in sd.c (sd_ddr_tuning)
      staging/rts_pstor: remove braces {} in sd.c (mmc_ddr_tuning)
      staging/rts_pstor: remove braces {} in sd.c (sd_switch_clock)
      staging/rts_pstor: remove braces {} in sd.c (sd_prepare_reset)
      staging/rts_pstor: remove braces {} in sd.c (sd_pull_ctl_enable)
      staging/rts_pstor: remove braces {} in sd.c (sd_init_power)
      staging/rts_pstor: remove braces {} in sd.c (sd_read_lba0)
      staging/rts_pstor: remove braces {} in sd.c (sd_check_wp_state)
      staging/rts_pstor: remove braces {} in sd.c (reset_sd)
      staging/rts_pstor: remove braces {} in sd.c (mmc_test_switch_bus)
      staging/rts_pstor: remove braces {} in sd.c (mmc_switch_timing_bus)
      staging/rts_pstor: remove braces {} in sd.c (reset_mmc)
      staging/rts_pstor: remove braces {} in sd.c (reset_sd_card)
      staging/rts_pstor: remove braces {} in sd.c (reset_mmc_only)
      staging/rts_pstor: remove braces {} in sd.c (wait_data_buf_ready)
      staging/rts_pstor: remove braces {} in sd.c (sd_stop_seq_mode)
      staging/rts_pstor: remove braces {} in sd.c (sd_auto_tune_clock)
      staging/rts_pstor: remove braces {} in sd.c (sd_rw)
      staging/rts_pstor: remove braces {} in sd.c (ext_sd_send_cmd_get_rsp)
      staging/rts_pstor: remove braces {} in sd.c (ext_sd_get_rsp)
      staging/rts_pstor: remove braces {} in sd.c (sd_pass_thru_mode)
      staging/rts_pstor: remove braces {} in sd.c (get_rsp_type)
      staging/rts_pstor: remove braces {} in sd.c (sd_execute_no_data)
      staging/rts_pstor: remove braces {} in sd.c (sd_execute_read_data)
      staging/rts_pstor: remove braces {} in sd.c (sd_execute_write_data)
      staging/rts_pstor: remove braces {} in sd.c (sd_hw_rst)
      staging/rts_pstor: remove braces {} in sd.c (sd_power_off_card3v3)
      staging/rts_pstor: remove braces {} in sd.c (release_sd_card)
      staging/rts_pstor: remove braces {} in rtsx_scsi.c
      staging/rts_pstor: remove braces {} in ms.c
      staging/rts_pstor: Use pr_ or dev_ printks in rtsx.c

Tushar Behera (1):
      Staging: bcm: Fix udelay related compilation error

W. Trevor King (3):
      staging: usbip: export usbip_debug_flag as a usbip-core module parameter.
      staging: usbip: userspace: allow `configure --with-tcp-wrappers`
      staging: usbip: userspace: update man pages for v1.0.0

Wei Yongjun (27):
      staging: ozwpan: remove pointless conditional before kfree_skb()
      staging: wlags49_h2: use is_broadcast_ether_addr() instead of memcmp()
      Staging: vt6656: using is_broadcast_ether_addr() to simplify the code
      Staging: vt6655: using is_broadcast_ether_addr() to simplify the code
      staging: rtl8192e: use is_broadcast_ether_addr() instead of memcmp()
      Staging: rtl8192u: use is_broadcast_ether_addr() instead of memcmp()
      staging: rtl8187se: use is_broadcast_ether_addr() instead of memcmp()
      staging: r8712u: use is_broadcast_ether_addr() to simplify the code
      Staging: rtl8187se: use is_zero_ether_addr() instead of memcmp()
      Staging: rtl8192u: use is_zero_ether_addr() instead of memcmp()
      staging: rtl8192e: use is_zero_ether_addr() instead of memcmp()
      staging: r8712u: rtl871x_mlme.c: use is_zero_ether_addr() instead of memcmp()
      staging: rtl8192e: remove pointless conditional before kfree_skb()
      staging: rtl8187se: using random_ether_addr() to generate random MAC
      staging: rtl8192e: using random_ether_addr() to generate random MAC
      Staging: rtl8192u: using random_ether_addr() to generate random MAC
      staging: csr: fix possible memory leak in do_patch_convert_download()
      staging: csr: use is_zero_ether_addr() instead of memcmp()
      staging: r8712u: use is_zero_ether_addr() instead of memcmp()
      staging: et131x: using is_zero_ether_addr() to simplify the code
      staging: bcm: fix possible memory leak in bcm_char_ioctl()
      staging: ozwpan: use list_move_tail instead of list_del/list_add_tail
      staging: gdm72xx: use list_move_tail instead of list_del/list_add_tail
      staging: wlags49_h2: use list_move instead of list_del/list_add
      staging: gdm72xx: use list_move instead of list_del/list_add
      staging: tidspbridge: move the dereference below the NULL test
      staging: tidspbridge: fix return value check in dsp_wdt_init()

YAMANE Toshiaki (1):
      staging/rts_pstor: Delete some lines (dev_info() and dev_err()) in rtsx.c

anish kumar (2):
      iio: Documentation change for inkern interface.
      power: battery: Generic battery driver using IIO

navin (2):
      staging: usbip: stub_dev: Fixed oops during removal of usbip_host
      staging: usbip: vhci_hcd: Fixed oops during removal of vhci_hcd

navin patidar (1):
      staging: usbip: vhci_hcd: fixed suspend-resume loop

srinivas pandruvada (9):
      iio: core: Add hysteresis in channel spec
      HID: sensors: add documentation
      HID: sensors: add to special driver list
      HID: sensors: introduce sensor framework
      iio: hid-sensors: Common attribute and trigger
      iio: hid-sensors: Added accelerometer 3D
      iio: hid-sensors: Added Gyroscope 3D
      iio: hid-sensors: Added Compass/Magnetometer 3D
      iio: hid-sensors: Added ALS

 Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt    |   15 +
 Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt  |   41 +
 Documentation/hid/hid-sensor.txt                                   |  140 +
 drivers/hid/Kconfig                                                |   14 +
 drivers/hid/Makefile                                               |    1 +
 drivers/hid/hid-core.c                                             |    5 +
 drivers/hid/hid-ids.h                                              |    6 +
 drivers/hid/hid-sensor-hub.c                                       |  680 ++++
 drivers/iio/Kconfig                                                |    7 +-
 drivers/iio/Makefile                                               |    5 +
 drivers/iio/accel/Kconfig                                          |   16 +
 drivers/iio/accel/Makefile                                         |    5 +
 drivers/iio/accel/hid-sensor-accel-3d.c                            |  418 ++
 drivers/iio/adc/Kconfig                                            |   38 +
 drivers/iio/adc/Makefile                                           |    4 +
 drivers/iio/adc/ad7266.c                                           |    2 +-
 drivers/{staging/iio/adc/ad7476_core.c => iio/adc/ad7476.c}        |  210 +-
 drivers/iio/adc/ad7791.c                                           |  460 +++
 drivers/iio/adc/ad_sigma_delta.c                                   |  558 +++
 drivers/iio/adc/at91_adc.c                                         |   77 +-
 drivers/iio/adc/lp8788_adc.c                                       |  264 ++
 drivers/iio/common/Kconfig                                         |    5 +
 drivers/iio/common/Makefile                                        |    9 +
 drivers/iio/common/hid-sensors/Kconfig                             |   26 +
 drivers/iio/common/hid-sensors/Makefile                            |    6 +
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c             |  250 ++
 drivers/iio/common/hid-sensors/hid-sensor-attributes.h             |   57 +
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c                |  103 +
 drivers/iio/common/hid-sensors/hid-sensor-trigger.h                |   26 +
 drivers/iio/dac/Kconfig                                            |   20 +-
 drivers/iio/dac/Makefile                                           |    1 +
 drivers/iio/dac/ad5446.c                                           |  450 ++-
 drivers/iio/dac/ad5446.h                                           |   91 -
 drivers/iio/dac/ad5755.c                                           |  650 ++++
 drivers/iio/gyro/Kconfig                                           |   16 +
 drivers/iio/gyro/Makefile                                          |    5 +
 drivers/iio/gyro/hid-sensor-gyro-3d.c                              |  418 ++
 drivers/iio/industrialio-buffer.c                                  |   15 +-
 drivers/iio/industrialio-core.c                                    |   13 +-
 drivers/iio/inkern.c                                               |  139 +-
 drivers/iio/kfifo_buf.c                                            |   31 +-
 drivers/iio/light/Kconfig                                          |   10 +
 drivers/iio/light/Makefile                                         |    1 +
 drivers/iio/light/adjd_s311.c                                      |    2 +-
 drivers/iio/light/hid-sensor-als.c                                 |  385 ++
 drivers/iio/magnetometer/Kconfig                                   |   16 +
 drivers/iio/magnetometer/Makefile                                  |    5 +
 drivers/iio/magnetometer/hid-sensor-magn-3d.c                      |  419 ++
 drivers/power/Kconfig                                              |    7 +
 drivers/power/Makefile                                             |    1 +
 drivers/power/generic-adc-battery.c                                |  422 ++
 drivers/staging/Kconfig                                            |   10 +-
 drivers/staging/Makefile                                           |    5 +-
 drivers/staging/android/alarm-dev.c                                |   17 +-
 drivers/staging/android/ashmem.c                                   |   32 +-
 drivers/staging/android/binder.c                                   |    6 +-
 drivers/staging/android/logger.c                                   |   40 +-
 drivers/staging/android/logger.h                                   |   24 +-
 drivers/staging/android/timed_gpio.c                               |   13 +-
 drivers/staging/asus_oled/asus_oled.c                              |   56 +-
 drivers/staging/bcm/Bcmchar.c                                      |    2 +
 drivers/staging/bcm/CmHost.c                                       |  150 +-
 drivers/staging/bcm/CmHost.h                                       |   54 +-
 drivers/staging/bcm/InterfaceInit.c                                |   17 +-
 drivers/staging/bcm/InterfaceInit.h                                |   33 +-
 drivers/staging/bcm/Kconfig                                        |    2 +-
 drivers/staging/bcm/Misc.c                                         |    5 +-
 drivers/staging/bcm/PHSModule.c                                    |    4 +-
 drivers/staging/bcm/Prototypes.h                                   |    2 +-
 drivers/staging/bcm/Transmit.c                                     |  234 +-
 drivers/staging/bcm/cntrl_SignalingInterface.h                     |  704 ++--
 drivers/staging/bcm/hostmibs.c                                     |    2 +-
 drivers/staging/bcm/nvm.c                                          |    4 +-
 drivers/staging/bcm/target_params.h                                |    2 +-
 drivers/staging/ccg/Kconfig                                        |    2 +-
 drivers/staging/ccg/ccg.c                                          |   14 +-
 drivers/staging/ced1401/Kconfig                                    |    6 +
 drivers/staging/ced1401/Makefile                                   |    3 +
 drivers/staging/ced1401/TODO                                       |   10 +
 drivers/staging/ced1401/ced_ioc.c                                  | 1515 ++++++++
 drivers/staging/ced1401/ced_ioctl.h                                |  345 ++
 drivers/staging/ced1401/machine.h                                  |  127 +
 drivers/staging/ced1401/usb1401.c                                  | 1637 ++++++++
 drivers/staging/ced1401/usb1401.h                                  |  249 ++
 drivers/staging/ced1401/use1401.h                                  |  287 ++
 drivers/staging/ced1401/use14_ioc.h                                |  301 ++
 drivers/staging/ced1401/userspace/use1401.c                        | 3035 +++++++++++++++
 drivers/staging/comedi/Kconfig                                     |   66 +-
 drivers/staging/comedi/comedi.h                                    | 1109 +++---
 drivers/staging/comedi/comedi_fops.c                               |  152 +-
 drivers/staging/comedi/comedidev.h                                 |    2 +-
 drivers/staging/comedi/drivers.c                                   |   82 +-
 drivers/staging/comedi/drivers/8253.h                              |   15 +-
 drivers/staging/comedi/drivers/8255.c                              |   41 +-
 drivers/staging/comedi/drivers/8255_pci.c                          |  353 ++
 drivers/staging/comedi/drivers/Makefile                            |    6 +-
 drivers/staging/comedi/drivers/acl7225b.c                          |    6 +-
 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c         |  195 -
 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h         |   27 -
 drivers/staging/comedi/drivers/addi-data/addi_common.c             |   14 +-
 drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h           |  453 ---
 drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c          |   18 +-
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c          |   61 +-
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c          |   81 +-
 drivers/staging/comedi/drivers/addi_apci_all.c                     |   18 -
 drivers/staging/comedi/drivers/adl_pci6208.c                       |  183 +-
 drivers/staging/comedi/drivers/adl_pci7230.c                       |  190 -
 drivers/staging/comedi/drivers/adl_pci7296.c                       |  183 -
 drivers/staging/comedi/drivers/adl_pci7432.c                       |  200 -
 drivers/staging/comedi/drivers/adl_pci7x3x.c                       |  332 ++
 drivers/staging/comedi/drivers/adl_pci8164.c                       |   73 +-
 drivers/staging/comedi/drivers/adl_pci9111.c                       |  973 ++---
 drivers/staging/comedi/drivers/adl_pci9118.c                       | 1059 ++---
 drivers/staging/comedi/drivers/adq12b.c                            |   29 +-
 drivers/staging/comedi/drivers/adv_pci1710.c                       |  766 ++--
 drivers/staging/comedi/drivers/adv_pci1723.c                       |  222 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c                       |  473 ++-
 drivers/staging/comedi/drivers/aio_aio12_8.c                       |  218 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c                       |    4 +-
 drivers/staging/comedi/drivers/amplc_dio200.c                      |  114 +-
 drivers/staging/comedi/drivers/amplc_pc236.c                       |  108 +-
 drivers/staging/comedi/drivers/amplc_pc263.c                       |   54 +-
 drivers/staging/comedi/drivers/amplc_pci224.c                      |   64 +-
 drivers/staging/comedi/drivers/amplc_pci230.c                      |  154 +-
 drivers/staging/comedi/drivers/c6xdigio.c                          |    6 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c                       |   56 +-
 drivers/staging/comedi/drivers/cb_pcidas.c                         |  202 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c                       |  128 +-
 drivers/staging/comedi/drivers/cb_pcidda.c                         |  441 +--
 drivers/staging/comedi/drivers/cb_pcidio.c                         |  211 -
 drivers/staging/comedi/drivers/cb_pcimdas.c                        |  279 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c                        |  393 +-
 drivers/staging/comedi/drivers/comedi_bond.c                       |  110 +-
 drivers/staging/comedi/drivers/comedi_fc.h                         |   32 +
 drivers/staging/comedi/drivers/comedi_parport.c                    |   86 +-
 drivers/staging/comedi/drivers/comedi_test.c                       |  108 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c                    |  146 +-
 drivers/staging/comedi/drivers/daqboard2000.c                      |  466 +--
 drivers/staging/comedi/drivers/das08.c                             |  482 +--
 drivers/staging/comedi/drivers/das08.h                             |   15 +-
 drivers/staging/comedi/drivers/das08_cs.c                          |   26 +
 drivers/staging/comedi/drivers/das16.c                             |   82 +-
 drivers/staging/comedi/drivers/das16m1.c                           |   54 +-
 drivers/staging/comedi/drivers/das1800.c                           |  145 +-
 drivers/staging/comedi/drivers/das6402.c                           |    4 +-
 drivers/staging/comedi/drivers/das800.c                            |   52 +-
 drivers/staging/comedi/drivers/dmm32at.c                           |   57 +-
 drivers/staging/comedi/drivers/dt2801.c                            |   12 +-
 drivers/staging/comedi/drivers/dt2811.c                            |    8 +-
 drivers/staging/comedi/drivers/dt2814.c                            |   46 +-
 drivers/staging/comedi/drivers/dt2815.c                            |    2 +-
 drivers/staging/comedi/drivers/dt2817.c                            |    2 +-
 drivers/staging/comedi/drivers/dt282x.c                            |  103 +-
 drivers/staging/comedi/drivers/dt3000.c                            |   48 +-
 drivers/staging/comedi/drivers/dt9812.c                            |    8 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c                      |  161 +-
 drivers/staging/comedi/drivers/fl512.c                             |    4 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c                          |   43 +-
 drivers/staging/comedi/drivers/icp_multi.c                         |  692 +---
 drivers/staging/comedi/drivers/icp_multi.h                         |  297 --
 drivers/staging/comedi/drivers/ii_pci20kc.c                        |    4 +-
 drivers/staging/comedi/drivers/jr3_pci.c                           |    9 +-
 drivers/staging/comedi/drivers/jr3_pci.h                           |    4 +-
 drivers/staging/comedi/drivers/ke_counter.c                        |  103 +-
 drivers/staging/comedi/drivers/me4000.c                            | 1636 +++-----
 drivers/staging/comedi/drivers/me4000.h                            |  409 --
 drivers/staging/comedi/drivers/me_daq.c                            |  221 +-
 drivers/staging/comedi/drivers/mite.c                              |  285 +-
 drivers/staging/comedi/drivers/mite.h                              |   66 +-
 drivers/staging/comedi/drivers/mpc624.c                            |    2 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c                        |    2 +-
 drivers/staging/comedi/drivers/multiq3.c                           |   14 +-
 drivers/staging/comedi/drivers/ni_6527.c                           |  171 +-
 drivers/staging/comedi/drivers/ni_65xx.c                           |  181 +-
 drivers/staging/comedi/drivers/ni_660x.c                           |  133 +-
 drivers/staging/comedi/drivers/ni_670x.c                           |   62 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c                       |   46 +-
 drivers/staging/comedi/drivers/ni_at_ao.c                          |    8 +-
 drivers/staging/comedi/drivers/ni_atmio.c                          |    2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c                       |   67 +-
 drivers/staging/comedi/drivers/ni_daq_700.c                        |  212 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c                      |   12 +-
 drivers/staging/comedi/drivers/ni_labpc.c                          |  467 +--
 drivers/staging/comedi/drivers/ni_labpc_cs.c                       |    6 +-
 drivers/staging/comedi/drivers/ni_mio_common.c                     |  240 +-
 drivers/staging/comedi/drivers/ni_mio_cs.c                         |    4 +-
 drivers/staging/comedi/drivers/ni_pcidio.c                         |  472 +--
 drivers/staging/comedi/drivers/ni_pcimio.c                         |   70 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c                         |   61 +-
 drivers/staging/comedi/drivers/pcl711.c                            |   53 +-
 drivers/staging/comedi/drivers/pcl724.c                            |   15 +-
 drivers/staging/comedi/drivers/pcl725.c                            |    4 +-
 drivers/staging/comedi/drivers/pcl726.c                            |    6 +-
 drivers/staging/comedi/drivers/pcl730.c                            |    8 +-
 drivers/staging/comedi/drivers/pcl812.c                            |   57 +-
 drivers/staging/comedi/drivers/pcl816.c                            |   52 +-
 drivers/staging/comedi/drivers/pcl818.c                            |   59 +-
 drivers/staging/comedi/drivers/pcm3724.c                           |   26 +-
 drivers/staging/comedi/drivers/pcm3730.c                           |   12 +-
 drivers/staging/comedi/drivers/pcm_common.c                        |   56 +-
 drivers/staging/comedi/drivers/pcmad.c                             |    2 +-
 drivers/staging/comedi/drivers/pcmda12.c                           |    2 +-
 drivers/staging/comedi/drivers/pcmmio.c                            |   32 +-
 drivers/staging/comedi/drivers/pcmuio.c                            |   14 +-
 drivers/staging/comedi/drivers/poc.c                               |    2 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c                   |   63 +-
 drivers/staging/comedi/drivers/rtd520.c                            |   67 +-
 drivers/staging/comedi/drivers/rti800.c                            |   10 +-
 drivers/staging/comedi/drivers/rti802.c                            |    2 +-
 drivers/staging/comedi/drivers/s526.c                              |  602 +--
 drivers/staging/comedi/drivers/s626.c                              |  755 ++--
 drivers/staging/comedi/drivers/s626.h                              |    1 -
 drivers/staging/comedi/drivers/serial2002.c                        |   14 +-
 drivers/staging/comedi/drivers/skel.c                              |   74 +-
 drivers/staging/comedi/drivers/ssv_dnp.c                           |    7 +-
 drivers/staging/comedi/drivers/usbdux.c                            |  201 +-
 drivers/staging/comedi/drivers/usbduxfast.c                        |  120 +-
 drivers/staging/comedi/drivers/usbduxsigma.c                       |  192 +-
 drivers/staging/comedi/drivers/vmk80xx.c                           |   14 +-
 drivers/staging/comedi/kcomedilib/kcomedilib_main.c                |   23 +-
 drivers/staging/comedi/range.c                                     |   18 +-
 drivers/staging/cptm1217/clearpad_tm1217.c                         |   13 +-
 drivers/staging/crystalhd/crystalhd_lnx.c                          |    6 +-
 drivers/staging/csr/Makefile                                       |    1 -
 drivers/staging/csr/bh.c                                           |  173 +-
 drivers/staging/csr/csr_formatted_io.c                             |   27 -
 drivers/staging/csr/csr_formatted_io.h                             |   25 -
 drivers/staging/csr/csr_framework_ext.c                            |   13 +-
 drivers/staging/csr/csr_panic.c                                    |    1 -
 drivers/staging/csr/csr_time.c                                     |   27 +-
 drivers/staging/csr/csr_wifi_hip_card_sdio.c                       |    8 +-
 drivers/staging/csr/csr_wifi_hip_download.c                        |    2 +
 drivers/staging/csr/csr_wifi_hip_send.c                            |    9 +-
 drivers/staging/csr/csr_wifi_hip_udi.c                             |   94 +-
 drivers/staging/csr/csr_wifi_hip_unifi.h                           |    1 -
 drivers/staging/csr/drv.c                                          |   46 +-
 drivers/staging/csr/firmware.c                                     |    6 +-
 drivers/staging/csr/io.c                                           |   53 +-
 drivers/staging/csr/monitor.c                                      |    7 +-
 drivers/staging/csr/netdev.c                                       |  630 +--
 drivers/staging/csr/sdio_events.c                                  |    4 +-
 drivers/staging/csr/sdio_mmc.c                                     |   65 +-
 drivers/staging/csr/sme_blocking.c                                 |    4 +-
 drivers/staging/csr/sme_native.c                                   |    6 +-
 drivers/staging/csr/sme_sys.c                                      |   22 +-
 drivers/staging/csr/sme_wext.c                                     |    8 +-
 drivers/staging/csr/ul_int.c                                       |    5 +-
 drivers/staging/csr/unifi_pdu_processing.c                         |    5 +-
 drivers/staging/csr/unifi_priv.h                                   |   40 -
 drivers/staging/csr/unifi_wext.h                                   |   27 +-
 drivers/staging/csr/wext_events.c                                  |    8 +-
 drivers/staging/cxt1e1/linux.c                                     |   12 +-
 drivers/staging/cxt1e1/musycc.c                                    |   10 +-
 drivers/staging/et131x/et131x.c                                    |    7 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c                 |   34 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c                      |   14 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h                     |    2 -
 drivers/staging/gdm72xx/gdm_qos.c                                  |  118 +-
 drivers/staging/gdm72xx/gdm_qos.h                                  |   58 +-
 drivers/staging/gdm72xx/gdm_sdio.c                                 |   37 +-
 drivers/staging/gdm72xx/gdm_usb.c                                  |   62 +-
 drivers/staging/gdm72xx/gdm_usb.h                                  |   16 +-
 drivers/staging/gdm72xx/gdm_wimax.c                                |   16 +-
 drivers/staging/gdm72xx/usb_boot.c                                 |  220 +-
 drivers/staging/iio/Documentation/generic_buffer.c                 |   10 +
 drivers/staging/iio/Documentation/inkernel.txt                     |    6 +-
 drivers/staging/iio/Kconfig                                        |    2 +-
 drivers/staging/iio/TODO                                           |    2 +-
 drivers/staging/iio/accel/adis16201_core.c                         |    4 +-
 drivers/staging/iio/accel/adis16201_ring.c                         |    3 +-
 drivers/staging/iio/accel/adis16203_core.c                         |    4 +-
 drivers/staging/iio/accel/adis16203_ring.c                         |    5 +-
 drivers/staging/iio/accel/adis16204_core.c                         |    4 +-
 drivers/staging/iio/accel/adis16204_ring.c                         |    3 +-
 drivers/staging/iio/accel/adis16209_core.c                         |    4 +-
 drivers/staging/iio/accel/adis16209_ring.c                         |    3 +-
 drivers/staging/iio/accel/adis16220_core.c                         |   11 +-
 drivers/staging/iio/accel/adis16240_core.c                         |    4 +-
 drivers/staging/iio/accel/adis16240_ring.c                         |    3 +-
 drivers/staging/iio/accel/kxsd9.c                                  |    6 +-
 drivers/staging/iio/accel/lis3l02dq.h                              |   14 +-
 drivers/staging/iio/accel/lis3l02dq_core.c                         |   26 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c                         |   31 +-
 drivers/staging/iio/accel/sca3000.h                                |    2 +-
 drivers/staging/iio/accel/sca3000_core.c                           |   14 +-
 drivers/staging/iio/accel/sca3000_ring.c                           |    2 +-
 drivers/staging/iio/adc/Kconfig                                    |   43 +-
 drivers/staging/iio/adc/Makefile                                   |    5 +-
 drivers/staging/iio/adc/ad7192.c                                   |  523 +--
 drivers/staging/iio/adc/ad7298_core.c                              |    2 +-
 drivers/staging/iio/adc/ad7298_ring.c                              |    3 +-
 drivers/staging/iio/adc/ad7476.h                                   |   66 -
 drivers/staging/iio/adc/ad7476_ring.c                              |   64 -
 drivers/staging/iio/adc/ad7606.h                                   |    2 +-
 drivers/staging/iio/adc/ad7606_core.c                              |    6 +-
 drivers/staging/iio/adc/ad7606_ring.c                              |    3 +-
 drivers/staging/iio/adc/ad7780.c                                   |  237 +-
 drivers/staging/iio/adc/ad7793.c                                   |  688 +---
 drivers/staging/iio/adc/ad7793.h                                   |   10 +-
 drivers/staging/iio/adc/ad7887_core.c                              |    2 +-
 drivers/staging/iio/adc/ad7887_ring.c                              |    2 +-
 drivers/staging/iio/adc/ad799x_ring.c                              |    3 +-
 drivers/staging/iio/adc/lpc32xx_adc.c                              |    2 +-
 drivers/staging/iio/adc/max1363.h                                  |    2 +-
 drivers/staging/iio/adc/max1363_core.c                             |   32 +-
 drivers/staging/iio/adc/max1363_ring.c                             |    2 +-
 drivers/staging/iio/adc/mxs-lradc.c                                |  590 +++
 drivers/staging/iio/adc/spear_adc.c                                |   27 +-
 drivers/staging/iio/gyro/adis16060_core.c                          |    4 +-
 drivers/staging/iio/gyro/adis16080_core.c                          |    2 +-
 drivers/staging/iio/gyro/adis16130_core.c                          |    2 +-
 drivers/staging/iio/gyro/adis16260_core.c                          |   12 +-
 drivers/staging/iio/gyro/adis16260_ring.c                          |    3 +-
 drivers/staging/iio/gyro/adxrs450_core.c                           |    2 +-
 drivers/staging/iio/iio_dummy_evgen.c                              |    2 +-
 drivers/staging/iio/iio_hwmon.c                                    |   47 +-
 drivers/staging/iio/iio_simple_dummy.c                             |   24 +-
 drivers/staging/iio/iio_simple_dummy.h                             |    6 +-
 drivers/staging/iio/iio_simple_dummy_buffer.c                      |   13 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c                    |    4 +-
 drivers/staging/iio/imu/adis16400.h                                |    2 +-
 drivers/staging/iio/imu/adis16400_core.c                           |   18 +-
 drivers/staging/iio/imu/adis16400_ring.c                           |    2 +-
 drivers/staging/iio/light/isl29018.c                               |   17 +-
 drivers/staging/iio/light/tsl2563.c                                |    2 +-
 drivers/staging/iio/magnetometer/hmc5843.c                         |    2 +-
 drivers/staging/iio/meter/ade7753.c                                |   13 +-
 drivers/staging/iio/meter/ade7754.c                                |   12 +-
 drivers/staging/iio/meter/ade7758.h                                |    2 +-
 drivers/staging/iio/meter/ade7758_core.c                           |   13 +-
 drivers/staging/iio/meter/ade7758_ring.c                           |    3 +-
 drivers/staging/iio/meter/ade7759.c                                |   11 +-
 drivers/staging/iio/meter/ade7854-spi.c                            |    2 +-
 drivers/staging/iio/resolver/ad2s1210.c                            |    2 +-
 drivers/staging/iio/ring_hw.h                                      |    2 +-
 drivers/staging/iio/ring_sw.c                                      |    7 +-
 drivers/staging/iio/trigger/Kconfig                                |    2 +
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c                  |  109 +-
 drivers/staging/iio/trigger/iio-trig-bfin-timer.h                  |   24 +
 drivers/staging/iio/trigger/iio-trig-gpio.c                        |    8 +-
 drivers/staging/iio/trigger/iio-trig-periodic-rtc.c                |    8 +-
 drivers/staging/iio/trigger/iio-trig-sysfs.c                       |   17 +-
 drivers/staging/imx-drm/Kconfig                                    |   35 +
 drivers/staging/imx-drm/Makefile                                   |    9 +
 drivers/staging/imx-drm/TODO                                       |   22 +
 drivers/staging/imx-drm/imx-drm-core.c                             |  884 +++++
 drivers/staging/imx-drm/imx-drm.h                                  |   58 +
 drivers/staging/imx-drm/imx-fb.c                                   |   47 +
 drivers/staging/imx-drm/imx-fbdev.c                                |   74 +
 drivers/staging/imx-drm/ipu-v3/Makefile                            |    3 +
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h                        |  318 ++
 drivers/staging/imx-drm/ipu-v3/ipu-common.c                        | 1143 ++++++
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c                            |  372 ++
 drivers/staging/imx-drm/ipu-v3/ipu-di.c                            |  700 ++++
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c                          |  408 ++
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c                            |  336 ++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h                           |  206 +
 drivers/staging/imx-drm/ipuv3-crtc.c                               |  579 +++
 drivers/staging/imx-drm/parallel-display.c                         |  261 ++
 drivers/staging/ipack/Kconfig                                      |    1 +
 drivers/staging/ipack/TODO                                         |   25 +-
 drivers/staging/ipack/bridges/tpci200.c                            |  735 ++--
 drivers/staging/ipack/bridges/tpci200.h                            |   39 +-
 drivers/staging/ipack/devices/ipoctal.c                            |  738 ++--
 drivers/staging/ipack/devices/scc2698.h                            |  117 +-
 drivers/staging/ipack/ipack.c                                      |  372 +-
 drivers/staging/ipack/ipack.h                                      |   88 +-
 drivers/staging/ipack/ipack_ids.h                                  |   32 +
 drivers/staging/keucr/smcommon.h                                   |    2 -
 drivers/staging/line6/pcm.c                                        |    8 +-
 drivers/staging/line6/variax.c                                     |    8 +-
 drivers/staging/nvec/Kconfig                                       |    2 +-
 drivers/staging/nvec/nvec.c                                        |   25 +-
 drivers/staging/olpc_dcon/olpc_dcon.c                              |   53 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c                         |   15 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c                       |    6 +-
 drivers/staging/omap-thermal/omap-bandgap.c                        |   23 +-
 drivers/staging/omap-thermal/omap-thermal-common.c                 |   42 +-
 drivers/staging/omap-thermal/omap4-thermal.c                       |   54 +-
 drivers/staging/omap-thermal/omap5-thermal.c                       |   38 +-
 drivers/staging/omapdrm/omap_crtc.c                                |   33 +-
 drivers/staging/omapdrm/omap_dmm_tiler.c                           |   51 +-
 drivers/staging/omapdrm/omap_dmm_tiler.h                           |   17 +-
 drivers/staging/omapdrm/omap_drv.c                                 |   21 +-
 drivers/staging/omapdrm/omap_drv.h                                 |   33 +-
 drivers/staging/omapdrm/omap_fb.c                                  |   99 +-
 drivers/staging/omapdrm/omap_gem.c                                 |   60 +-
 drivers/staging/omapdrm/omap_plane.c                               |  111 +-
 drivers/staging/ozwpan/ozcdev.c                                    |   14 +-
 drivers/staging/ozwpan/ozevent.c                                   |    6 +-
 drivers/staging/ozwpan/ozhcd.c                                     |  104 +-
 drivers/staging/ozwpan/ozmain.c                                    |    2 +-
 drivers/staging/ozwpan/ozpd.c                                      |   11 +-
 drivers/staging/ozwpan/ozpd.h                                      |    1 +
 drivers/staging/ozwpan/ozproto.c                                   |   13 +
 drivers/staging/ozwpan/ozproto.h                                   |    8 +-
 drivers/staging/ozwpan/ozprotocol.h                                |    6 +-
 drivers/staging/panel/panel.c                                      |   52 +-
 drivers/staging/ramster/Kconfig                                    |   25 +-
 drivers/staging/ramster/Makefile                                   |    7 +-
 drivers/staging/ramster/TODO                                       |   13 -
 drivers/staging/ramster/cluster/Makefile                           |    3 -
 drivers/staging/ramster/ramster.h                                  |  113 +-
 drivers/staging/ramster/{cluster => ramster}/heartbeat.c           |    6 +-
 drivers/staging/ramster/{cluster => ramster}/heartbeat.h           |    0
 drivers/staging/ramster/{cluster => ramster}/masklog.c             |    0
 drivers/staging/ramster/{cluster => ramster}/masklog.h             |    0
 drivers/staging/ramster/{cluster => ramster}/nodemanager.c         |   15 +-
 drivers/staging/ramster/{cluster => ramster}/nodemanager.h         |    0
 drivers/staging/ramster/{ => }/ramster/r2net.c                     |   79 +-
 drivers/staging/ramster/ramster/ramster.c                          |  985 +++++
 drivers/staging/ramster/ramster/ramster.h                          |  161 +
 drivers/staging/ramster/{cluster => ramster}/ramster_nodemanager.h |    0
 drivers/staging/ramster/{cluster => ramster}/tcp.c                 |   53 +-
 drivers/staging/ramster/{cluster => ramster}/tcp.h                 |    0
 drivers/staging/ramster/{cluster => ramster}/tcp_internal.h        |    0
 drivers/staging/ramster/tmem.c                                     |  313 +-
 drivers/staging/ramster/tmem.h                                     |  109 +-
 drivers/staging/ramster/xvmalloc.c                                 |  509 ---
 drivers/staging/ramster/xvmalloc.h                                 |   30 -
 drivers/staging/ramster/xvmalloc_int.h                             |   95 -
 drivers/staging/ramster/zbud.c                                     | 1060 +++++
 drivers/staging/ramster/zbud.h                                     |   33 +
 drivers/staging/ramster/zcache-main.c                              | 3566 +++++------------
 drivers/staging/ramster/zcache.h                                   |   55 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h                    |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c            |   13 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c         |    5 +-
 drivers/staging/rtl8187se/r8180_core.c                             |    4 +-
 drivers/staging/rtl8187se/r8180_hw.h                               |    9 +-
 drivers/staging/rtl8187se/r8185b_init.c                            |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c                |    9 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.h                |    4 +
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                       |    6 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c                         |    2 +-
 drivers/staging/rtl8192e/rtllib.h                                  |    8 +-
 drivers/staging/rtl8192e/rtllib_softmac.c                          |   24 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c                       |    7 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h                     |    4 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c             |   20 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c          |    5 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c                |    2 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h                    |    4 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c                |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c                             |   27 +-
 drivers/staging/rtl8192u/r819xU_HTType.h                           |    2 +-
 drivers/staging/rtl8192u/r819xU_phyreg.h                           |    2 +-
 drivers/staging/rtl8712/drv_types.h                                |    9 -
 drivers/staging/rtl8712/ethernet.h                                 |    8 -
 drivers/staging/rtl8712/os_intfs.c                                 |    2 +-
 drivers/staging/rtl8712/rtl8712_recv.c                             |    9 +-
 drivers/staging/rtl8712/rtl8712_recv.h                             |    2 +-
 drivers/staging/rtl8712/rtl8712_xmit.c                             |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                      |    4 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c                        |    5 +-
 drivers/staging/rtl8712/rtl871x_mlme.c                             |    5 +-
 drivers/staging/rtl8712/rtl871x_pwrctrl.h                          |   20 -
 drivers/staging/rtl8712/rtl871x_recv.c                             |    9 +-
 drivers/staging/rtl8712/rtl871x_security.c                         |    8 +-
 drivers/staging/rtl8712/usb_intf.c                                 |    1 -
 drivers/staging/rtl8712/usb_osintf.h                               |    3 -
 drivers/staging/rtl8712/usb_vendor_req.h                           |   58 -
 drivers/staging/rts5139/rts51x_fop.c                               |    2 +-
 drivers/staging/rts5139/trace.h                                    |   32 +-
 drivers/staging/rts_pstor/ms.c                                     |  872 ++---
 drivers/staging/rts_pstor/rtsx.c                                   |  112 +-
 drivers/staging/rts_pstor/rtsx_card.c                              |  186 +-
 drivers/staging/rts_pstor/rtsx_chip.c                              |  563 ++-
 drivers/staging/rts_pstor/rtsx_scsi.c                              |  405 +-
 drivers/staging/rts_pstor/rtsx_transport.c                         |  100 +-
 drivers/staging/rts_pstor/sd.c                                     | 1055 ++---
 drivers/staging/rts_pstor/trace.h                                  |   30 +-
 drivers/staging/sbe-2t3e3/2t3e3.h                                  |    1 -
 drivers/staging/sbe-2t3e3/dc.c                                     |   10 +-
 drivers/staging/sbe-2t3e3/module.c                                 |   15 +-
 drivers/staging/sbe-2t3e3/netdev.c                                 |    8 +-
 drivers/staging/sep/sep_main.c                                     |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c                            |   11 +-
 drivers/staging/silicom/Kconfig                                    |   46 +
 drivers/staging/silicom/Makefile                                   |    9 +
 drivers/staging/silicom/README                                     |   14 +
 drivers/staging/silicom/TODO                                       |    8 +
 drivers/staging/silicom/bits.h                                     |   56 +
 drivers/staging/silicom/bp_ioctl.h                                 |  140 +
 drivers/staging/silicom/bp_mod.c                                   | 8931 +++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/silicom/bp_mod.h                                   |  704 ++++
 drivers/staging/silicom/bp_proc.c                                  | 1350 +++++++
 drivers/staging/silicom/bypass.h                                   |  202 +
 drivers/staging/silicom/bypasslib/Makefile                         |    6 +
 drivers/staging/silicom/bypasslib/bp_ioctl.h                       |  198 +
 drivers/staging/silicom/bypasslib/bplibk.h                         |   47 +
 drivers/staging/silicom/bypasslib/bypass.c                         |  529 +++
 drivers/staging/silicom/bypasslib/libbp_sd.h                       |  509 +++
 drivers/staging/silicom/libbp_sd.h                                 |  550 +++
 drivers/staging/slicoss/slicoss.c                                  |   40 +-
 drivers/staging/sm7xxfb/sm7xx.h                                    |    2 +-
 drivers/staging/sm7xxfb/sm7xxfb.c                                  |  119 +-
 drivers/staging/speakup/i18n.c                                     |    1 +
 drivers/staging/speakup/speakup_soft.c                             |   15 +-
 drivers/staging/telephony/ixj.c                                    |    4 +-
 drivers/staging/tidspbridge/Documentation/error-codes              |    2 +-
 drivers/staging/tidspbridge/core/_tiomap.h                         |    2 +-
 drivers/staging/tidspbridge/core/chnl_sm.c                         |    9 +-
 drivers/staging/tidspbridge/core/dsp-clock.c                       |    2 +
 drivers/staging/tidspbridge/core/io_sm.c                           |   10 +-
 drivers/staging/tidspbridge/core/sync.c                            |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430.c                      |    8 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c                  |    2 +-
 drivers/staging/tidspbridge/core/wdt.c                             |    7 +-
 drivers/staging/tidspbridge/dynload/tramp.c                        |    8 +-
 drivers/staging/tidspbridge/gen/uuidutil.c                         |   21 -
 drivers/staging/tidspbridge/hw/hw_mmu.c                            |    6 +-
 drivers/staging/tidspbridge/include/dspbridge/dspioctl.h           |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h             |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/node.h               |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/ntfy.h               |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/proc.h               |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/strm.h               |    2 +-
 drivers/staging/tidspbridge/include/dspbridge/sync.h               |    4 +-
 drivers/staging/tidspbridge/include/dspbridge/uuidutil.h           |   20 -
 drivers/staging/tidspbridge/rmgr/dbdcd.c                           |   29 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c                   |   14 +-
 drivers/staging/tidspbridge/rmgr/dspdrv.c                          |    4 +-
 drivers/staging/tidspbridge/rmgr/mgr.c                             |    4 +-
 drivers/staging/tidspbridge/rmgr/nldr.c                            |    2 +-
 drivers/staging/tidspbridge/rmgr/node.c                            |    5 +-
 drivers/staging/tidspbridge/rmgr/proc.c                            |    2 +-
 drivers/staging/usbip/Kconfig                                      |    4 +-
 drivers/staging/usbip/stub_dev.c                                   |    8 +-
 drivers/staging/usbip/stub_rx.c                                    |    2 +-
 drivers/staging/usbip/usbip_common.c                               |    4 +
 drivers/staging/usbip/userspace/configure.ac                       |   12 +-
 drivers/staging/usbip/userspace/doc/usbip.8                        |   66 +-
 drivers/staging/usbip/userspace/doc/usbip_bind_driver.8            |   42 -
 drivers/staging/usbip/userspace/doc/usbipd.8                       |   16 +-
 drivers/staging/usbip/vhci_hcd.c                                   |   31 +-
 drivers/staging/vme/devices/vme_pio2_core.c                        |   10 +-
 drivers/staging/vme/devices/vme_user.c                             |   10 +-
 drivers/staging/vt6655/80211mgr.h                                  |    2 +-
 drivers/staging/vt6655/baseband.c                                  |  172 +-
 drivers/staging/vt6655/baseband.h                                  |   10 +-
 drivers/staging/vt6655/bssdb.c                                     |    4 +-
 drivers/staging/vt6655/card.c                                      |  101 +-
 drivers/staging/vt6655/datarate.c                                  |    2 +-
 drivers/staging/vt6655/device.h                                    |    4 +-
 drivers/staging/vt6655/device_main.c                               |  104 +-
 drivers/staging/vt6655/dpc.c                                       |    2 +-
 drivers/staging/vt6655/hostap.c                                    |    8 +-
 drivers/staging/vt6655/ioctl.c                                     |    9 +-
 drivers/staging/vt6655/iwctl.c                                     |    6 +-
 drivers/staging/vt6655/key.c                                       |    2 +-
 drivers/staging/vt6655/mac.c                                       |   12 +-
 drivers/staging/vt6655/mac.h                                       |    2 +-
 drivers/staging/vt6655/mib.c                                       |    2 +-
 drivers/staging/vt6655/power.c                                     |    2 +-
 drivers/staging/vt6655/rf.c                                        |   82 +-
 drivers/staging/vt6655/rf.h                                        |    2 +-
 drivers/staging/vt6655/rxtx.c                                      |   42 +-
 drivers/staging/vt6655/tcrc.c                                      |    2 +-
 drivers/staging/vt6655/tcrc.h                                      |    2 +-
 drivers/staging/vt6655/tether.c                                    |    4 +-
 drivers/staging/vt6655/tkip.c                                      |    2 +-
 drivers/staging/vt6655/vntwifi.c                                   |    2 +-
 drivers/staging/vt6655/wcmd.c                                      |    6 +-
 drivers/staging/vt6655/wmgr.c                                      |   56 +-
 drivers/staging/vt6655/wmgr.h                                      |    4 +-
 drivers/staging/vt6655/wpa.c                                       |    2 +-
 drivers/staging/vt6655/wpa2.c                                      |    8 +-
 drivers/staging/vt6655/wpactl.c                                    |    6 +-
 drivers/staging/vt6655/wroute.c                                    |    2 +-
 drivers/staging/vt6656/80211mgr.h                                  |    4 +-
 drivers/staging/vt6656/baseband.c                                  |    6 +-
 drivers/staging/vt6656/baseband.h                                  |    2 +-
 drivers/staging/vt6656/bssdb.c                                     |   18 +-
 drivers/staging/vt6656/card.c                                      |   38 +-
 drivers/staging/vt6656/device.h                                    |    2 +-
 drivers/staging/vt6656/dpc.c                                       |    2 +-
 drivers/staging/vt6656/hostap.c                                    |   30 +-
 drivers/staging/vt6656/int.c                                       |    2 +-
 drivers/staging/vt6656/ioctl.c                                     |   11 +-
 drivers/staging/vt6656/iwctl.c                                     |    2 +-
 drivers/staging/vt6656/key.c                                       |    4 +-
 drivers/staging/vt6656/main_usb.c                                  |   20 +-
 drivers/staging/vt6656/power.c                                     |    2 +-
 drivers/staging/vt6656/rf.c                                        |   58 +-
 drivers/staging/vt6656/rf.h                                        |    2 +-
 drivers/staging/vt6656/rxtx.c                                      |   52 +-
 drivers/staging/vt6656/tcrc.c                                      |    2 +-
 drivers/staging/vt6656/tcrc.h                                      |    2 +-
 drivers/staging/vt6656/tether.c                                    |    4 +-
 drivers/staging/vt6656/tkip.c                                      |    2 +-
 drivers/staging/vt6656/wcmd.c                                      |    8 +-
 drivers/staging/vt6656/wctl.c                                      |    2 +-
 drivers/staging/vt6656/wmgr.c                                      |   26 +-
 drivers/staging/vt6656/wpa.c                                       |    2 +-
 drivers/staging/vt6656/wpa2.c                                      |    6 +-
 drivers/staging/vt6656/wpactl.c                                    |    6 +-
 drivers/staging/winbond/Kconfig                                    |    2 +-
 drivers/staging/winbond/localpara.h                                |    4 +-
 drivers/staging/winbond/mds.c                                      |    2 +-
 drivers/staging/winbond/mto.c                                      |    2 +-
 drivers/staging/winbond/phy_calibration.c                          |   14 +-
 drivers/staging/winbond/reg.c                                      |    2 +-
 drivers/staging/winbond/sme_api.h                                  |   11 +-
 drivers/staging/winbond/wb35reg.c                                  |    4 +-
 drivers/staging/winbond/wb35tx.c                                   |  154 +-
 drivers/staging/winbond/wb35tx_s.h                                 |   46 +-
 drivers/staging/wlags49_h2/README.ubuntu                           |   12 +-
 drivers/staging/wlags49_h2/TODO                                    |   10 +-
 drivers/staging/wlags49_h2/hcf.c                                   |   20 +-
 drivers/staging/wlags49_h2/hcfcfg.h                                |    2 +-
 drivers/staging/wlags49_h2/hcfdef.h                                |    6 +-
 drivers/staging/wlags49_h2/mdd.h                                   |    8 +-
 drivers/staging/wlags49_h2/sta_h2.c                                |    2 +-
 drivers/staging/wlags49_h2/sta_h25.c                               |    2 +-
 drivers/staging/wlags49_h2/wl_enc.h                                |    2 +-
 drivers/staging/wlags49_h2/wl_if.h                                 |    2 +-
 drivers/staging/wlags49_h2/wl_internal.h                           |    4 +-
 drivers/staging/wlags49_h2/wl_main.c                               |   18 +-
 drivers/staging/wlags49_h2/wl_netdev.c                             |   59 +-
 drivers/staging/wlags49_h2/wl_pci.c                                |    8 +-
 drivers/staging/wlags49_h2/wl_priv.c                               |    2 +-
 drivers/staging/wlags49_h2/wl_profile.c                            |    2 +-
 drivers/staging/wlags49_h2/wl_version.h                            |    2 +-
 drivers/staging/wlags49_h2/wl_wext.c                               |   27 +-
 drivers/staging/wlags49_h25/Kconfig                                |    2 +-
 drivers/staging/wlags49_h25/TODO                                   |    8 +-
 drivers/staging/wlan-ng/cfg80211.c                                 |   11 +-
 drivers/staging/wlan-ng/hfa384x_usb.c                              |   37 +-
 drivers/staging/wlan-ng/p80211conv.c                               |    9 +-
 drivers/staging/wlan-ng/p80211netdev.c                             |   21 +-
 drivers/staging/wlan-ng/p80211netdev.h                             |    2 +-
 drivers/staging/wlan-ng/p80211req.c                                |  152 +-
 drivers/staging/wlan-ng/p80211types.h                              |    2 +-
 drivers/staging/wlan-ng/p80211wep.c                                |   18 +-
 drivers/staging/wlan-ng/prism2fw.c                                 |   56 +-
 drivers/staging/wlan-ng/prism2sta.c                                |   53 +-
 drivers/staging/xgifb/XGI_main_26.c                                |   45 +-
 drivers/staging/xgifb/vb_def.h                                     |   21 -
 drivers/staging/xgifb/vb_init.c                                    |    5 +-
 drivers/staging/xgifb/vb_setmode.c                                 |  601 +--
 drivers/staging/xgifb/vb_struct.h                                  |   49 +-
 drivers/staging/xgifb/vb_table.h                                   |  194 +-
 drivers/staging/zcache/tmem.c                                      |    2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c                           |  322 +-
 drivers/staging/zsmalloc/zsmalloc_int.h                            |  155 -
 include/linux/hid-sensor-hub.h                                     |  160 +
 include/linux/hid-sensor-ids.h                                     |  112 +
 include/linux/iio/adc/ad_sigma_delta.h                             |  173 +
 include/linux/iio/buffer.h                                         |    6 +-
 include/linux/iio/consumer.h                                       |   44 +-
 include/linux/iio/iio.h                                            |   65 +-
 include/linux/iio/kfifo_buf.h                                      |    3 +
 include/linux/iio/machine.h                                        |    5 +
 include/linux/iio/trigger.h                                        |   13 +-
 include/linux/iio/trigger_consumer.h                               |   11 +
 include/linux/iio/types.h                                          |    1 +
 include/linux/mod_devicetable.h                                    |    8 +
 include/linux/platform_data/ad5755.h                               |  103 +
 include/linux/platform_data/ad7791.h                               |   17 +
 include/linux/power/generic-adc-battery.h                          |   29 +
 scripts/mod/file2alias.c                                           |   15 +
 662 files changed, 51649 insertions(+), 26582 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
 create mode 100644 Documentation/devicetree/bindings/staging/imx-drm/fsl-imx-drm.txt
 create mode 100755 Documentation/hid/hid-sensor.txt
 create mode 100644 drivers/hid/hid-sensor-hub.c
 create mode 100644 drivers/iio/accel/Kconfig
 create mode 100644 drivers/iio/accel/Makefile
 create mode 100644 drivers/iio/accel/hid-sensor-accel-3d.c
 rename drivers/{staging/iio/adc/ad7476_core.c => iio/adc/ad7476.c} (52%)
 create mode 100644 drivers/iio/adc/ad7791.c
 create mode 100644 drivers/iio/adc/ad_sigma_delta.c
 create mode 100644 drivers/iio/adc/lp8788_adc.c
 create mode 100644 drivers/iio/common/Kconfig
 create mode 100644 drivers/iio/common/Makefile
 create mode 100644 drivers/iio/common/hid-sensors/Kconfig
 create mode 100644 drivers/iio/common/hid-sensors/Makefile
 create mode 100644 drivers/iio/common/hid-sensors/hid-sensor-attributes.c
 create mode 100644 drivers/iio/common/hid-sensors/hid-sensor-attributes.h
 create mode 100644 drivers/iio/common/hid-sensors/hid-sensor-trigger.c
 create mode 100644 drivers/iio/common/hid-sensors/hid-sensor-trigger.h
 delete mode 100644 drivers/iio/dac/ad5446.h
 create mode 100644 drivers/iio/dac/ad5755.c
 create mode 100644 drivers/iio/gyro/Kconfig
 create mode 100644 drivers/iio/gyro/Makefile
 create mode 100644 drivers/iio/gyro/hid-sensor-gyro-3d.c
 create mode 100644 drivers/iio/light/hid-sensor-als.c
 create mode 100644 drivers/iio/magnetometer/Kconfig
 create mode 100644 drivers/iio/magnetometer/Makefile
 create mode 100644 drivers/iio/magnetometer/hid-sensor-magn-3d.c
 create mode 100644 drivers/power/generic-adc-battery.c
 create mode 100644 drivers/staging/ced1401/Kconfig
 create mode 100644 drivers/staging/ced1401/Makefile
 create mode 100644 drivers/staging/ced1401/TODO
 create mode 100644 drivers/staging/ced1401/ced_ioc.c
 create mode 100644 drivers/staging/ced1401/ced_ioctl.h
 create mode 100644 drivers/staging/ced1401/machine.h
 create mode 100644 drivers/staging/ced1401/usb1401.c
 create mode 100644 drivers/staging/ced1401/usb1401.h
 create mode 100644 drivers/staging/ced1401/use1401.h
 create mode 100644 drivers/staging/ced1401/use14_ioc.h
 create mode 100644 drivers/staging/ced1401/userspace/use1401.c
 create mode 100644 drivers/staging/comedi/drivers/8255_pci.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_all.c
 delete mode 100644 drivers/staging/comedi/drivers/adl_pci7230.c
 delete mode 100644 drivers/staging/comedi/drivers/adl_pci7296.c
 delete mode 100644 drivers/staging/comedi/drivers/adl_pci7432.c
 create mode 100644 drivers/staging/comedi/drivers/adl_pci7x3x.c
 delete mode 100644 drivers/staging/comedi/drivers/cb_pcidio.c
 delete mode 100644 drivers/staging/comedi/drivers/icp_multi.h
 delete mode 100644 drivers/staging/comedi/drivers/me4000.h
 delete mode 100644 drivers/staging/csr/csr_formatted_io.c
 delete mode 100644 drivers/staging/csr/csr_formatted_io.h
 delete mode 100644 drivers/staging/iio/adc/ad7476.h
 delete mode 100644 drivers/staging/iio/adc/ad7476_ring.c
 create mode 100644 drivers/staging/iio/adc/mxs-lradc.c
 create mode 100644 drivers/staging/iio/trigger/iio-trig-bfin-timer.h
 create mode 100644 drivers/staging/imx-drm/Kconfig
 create mode 100644 drivers/staging/imx-drm/Makefile
 create mode 100644 drivers/staging/imx-drm/TODO
 create mode 100644 drivers/staging/imx-drm/imx-drm-core.c
 create mode 100644 drivers/staging/imx-drm/imx-drm.h
 create mode 100644 drivers/staging/imx-drm/imx-fb.c
 create mode 100644 drivers/staging/imx-drm/imx-fbdev.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/Makefile
 create mode 100644 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-common.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-dc.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-di.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-dp.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-prv.h
 create mode 100644 drivers/staging/imx-drm/ipuv3-crtc.c
 create mode 100644 drivers/staging/imx-drm/parallel-display.c
 create mode 100644 drivers/staging/ipack/ipack_ids.h
 delete mode 100644 drivers/staging/ramster/TODO
 delete mode 100644 drivers/staging/ramster/cluster/Makefile
 rename drivers/staging/ramster/{cluster => ramster}/heartbeat.c (98%)
 rename drivers/staging/ramster/{cluster => ramster}/heartbeat.h (100%)
 rename drivers/staging/ramster/{cluster => ramster}/masklog.c (100%)
 rename drivers/staging/ramster/{cluster => ramster}/masklog.h (100%)
 rename drivers/staging/ramster/{cluster => ramster}/nodemanager.c (98%)
 rename drivers/staging/ramster/{cluster => ramster}/nodemanager.h (100%)
 rename drivers/staging/ramster/{ => }/ramster/r2net.c (86%)
 create mode 100644 drivers/staging/ramster/ramster/ramster.c
 create mode 100644 drivers/staging/ramster/ramster/ramster.h
 rename drivers/staging/ramster/{cluster => ramster}/ramster_nodemanager.h (100%)
 rename drivers/staging/ramster/{cluster => ramster}/tcp.c (97%)
 rename drivers/staging/ramster/{cluster => ramster}/tcp.h (100%)
 rename drivers/staging/ramster/{cluster => ramster}/tcp_internal.h (100%)
 delete mode 100644 drivers/staging/ramster/xvmalloc.c
 delete mode 100644 drivers/staging/ramster/xvmalloc.h
 delete mode 100644 drivers/staging/ramster/xvmalloc_int.h
 create mode 100644 drivers/staging/ramster/zbud.c
 create mode 100644 drivers/staging/ramster/zbud.h
 delete mode 100644 drivers/staging/rtl8712/usb_vendor_req.h
 create mode 100644 drivers/staging/silicom/Kconfig
 create mode 100644 drivers/staging/silicom/Makefile
 create mode 100644 drivers/staging/silicom/README
 create mode 100644 drivers/staging/silicom/TODO
 create mode 100644 drivers/staging/silicom/bits.h
 create mode 100644 drivers/staging/silicom/bp_ioctl.h
 create mode 100644 drivers/staging/silicom/bp_mod.c
 create mode 100644 drivers/staging/silicom/bp_mod.h
 create mode 100644 drivers/staging/silicom/bp_proc.c
 create mode 100644 drivers/staging/silicom/bypass.h
 create mode 100644 drivers/staging/silicom/bypasslib/Makefile
 create mode 100644 drivers/staging/silicom/bypasslib/bp_ioctl.h
 create mode 100644 drivers/staging/silicom/bypasslib/bplibk.h
 create mode 100644 drivers/staging/silicom/bypasslib/bypass.c
 create mode 100644 drivers/staging/silicom/bypasslib/libbp_sd.h
 create mode 100644 drivers/staging/silicom/libbp_sd.h
 delete mode 100644 drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
 delete mode 100644 drivers/staging/zsmalloc/zsmalloc_int.h
 create mode 100644 include/linux/hid-sensor-hub.h
 create mode 100644 include/linux/hid-sensor-ids.h
 create mode 100644 include/linux/iio/adc/ad_sigma_delta.h
 create mode 100644 include/linux/platform_data/ad5755.h
 create mode 100644 include/linux/platform_data/ad7791.h
 create mode 100644 include/linux/power/generic-adc-battery.h
