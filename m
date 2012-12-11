Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2LKULO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:11:14 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56651 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2LKULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:11:08 -0500
Date: Tue, 11 Dec 2012 12:11:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.8-rc1
Message-ID: <20121211201103.GA19525@kroah.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.8-rc1

for you to fetch changes up to 7bcb57cde66c19df378f3468ea342166a8a4504d:

  Merge tag 'iio-for-3.8f' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next (2012-11-30 10:39:49 -0800)

----------------------------------------------------------------

Staging driver tree merge for 3.8-rc1

Here's the big staging tree merge for 3.8-rc1

There's a lot of patches in here, the majority being the comedi rework/cleanup
that has been ongoing and is causing a huge reduction in overall code size,
which is amazing to watch.  We also removed some older drivers (telephony and
rts_pstor), and added a new one (fwserial which also came in through the tty
tree due to tty api changes, take that one if you get merge conflicts.)

The iio and ipack drivers are moving out of the staging area into their
own part of the kernel as they have been cleaned up sufficiently and are
working well.

Overall, again a reduction of code:
 768 files changed, 31887 insertions(+), 82166 deletions(-)

All of this has been in the linux-next tree for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (26):
      staging: xgifb: XGI_GetLcdPtr: add separate table for VB_SIS301LV/VB_SIS302LV
      staging: xgifb: XGI_GetLcdPtr: replace xgifb_epllcd_crt1
      staging: xgifb: XGI_GetLcdPtr: use real pointers for data tables
      staging: xgifb: XGI_GetLcdPtr: delete redundant code
      staging: xgifb: XGI_GetLcdPtr: pass the table pointer directly
      staging: xgifb: constify LCD data
      staging: xgifb: vb_init.h: delete redundant declaration
      staging: xgifb: refactor XGI_GetLVDSData()
      staging: xgifb: eliminate global TimingV/TimingH data
      staging: xgifb: eliminate pVBInfo->StandTable
      staging: xgifb: eliminate pVBInfo->EModeIDTable
      staging: xgifb: eliminate pVBInfo->RefIndex
      staging: xgifb: eliminate pVBInfo->XGINEWUB_CRT1Table
      staging: xgifb: eliminate pVBInfo->UpdateCRT1
      staging: xgifb: eliminate pVBInfo->CR6E/6F/89
      staging: xgifb: eliminate pVBInfo->ECLKData
      staging: xgifb: eliminate pVBInfo->VCLKData/VBVCLKData
      staging: xgifb: eliminate pVBInfo->ScreenOffset
      staging: xgifb: eliminate pVBInfo->ModeResInfo
      staging: xgifb: eliminate pVBInfo->StResInfo
      staging: xgifb: eliminate pVBInfo->SR21/22/25
      staging: xgifb: eliminate pVBInfo->CR6B
      staging: xgifb: eliminate pVBInfo->SR16
      staging: xgifb: eliminate pVBInfo->AGPReg
      staging: xgifb: constify Tap4 data
      staging: xgifb: make remaining data tables const

Adil Mujeeb (4):
      Staging: winbond: wbusb: Fixed coding style issue
      Staging: winbond: wb35rx_f: Fixed coding style issues
      Staging: winbond: mds: Fixed coding style issues
      Staging: winbond: wb35rx_s: Fixed coding style issue

Alan Cox (2):
      staging: dgrp: fix some warnings
      staging: silicom: pointless check removal

Alexandra Chin (1):
      staging: ste_rmi4: Convert to Type-B support

Andres Salomon (5):
      staging/olpc_dcon: drop useaa module arg
      staging/olpc_dcon: move wait queue into dcon_priv struct
      staging/olpc_dcon: drop fb_notifier code
      staging/olpc_dcon: drop pin frobbing code for xo1.5
      staging/olpc_dcon: use s/r hooks from device_driver->pm

Andy Gross (7):
      drm/omap: Remove shadow lut usage
      drm/omap: Use writecombine for descriptors
      drm/omap: Fix release of refill engine
      staging: drm/omap: Fix include error during make
      drm/omap: Remove cpu_is_omapXXXX usage in DMM
      staging: drm/omap: Fix usage of IS_ERR_OR_NULL and PTR_ERR
      staging: drm/omap: Fix usage of IS_ERR_OR_NULL and PTR_ERR

Anmol Sarma (1):
      Staging: android: binder: Fixed multi-line strings

Arnd Bergmann (1):
      staging/iio/lis3l02dq: fix building without irq_to_gpio

Arve Hjønnevåg (2):
      Staging: android: binder: Add some missing binder_stat_br calls
      Staging: android: binder: Add some tracepoints

Axel Lin (2):
      Revert "iio: at91_adc: Use devm_kcalloc to allocate arrays"
      iio: hid-sensor: Return proper error if kmemdup fails

Bart Westgeest (3):
      staging: usbip: replaced pointer arithmetic, and strongly type function return.
      staging: usbip: make rh_port_disconnect static
      staging: usbip: cleanup of comments

Ben Chan (2):
      staging: gdm72xx: protect access of rx / tx structs
      staging: gdm72xx: fix unused variable warning in gdm_usb_send

Bernard Blackham (2):
      staging: usbip: Don't leak struct file.
      staging: usbip: Avoid superfluous set HC_STATE_RUNNING in vhci_start

Bill Pemberton (82):
      staging: dgrp: remove TIOCGSOFTCAR and TIOCSSOFTCAR handling
      staging: wlags49_h2: remove use of __devexit_p
      staging: wlags49_h2: remove use of __devinit
      staging: wlags49_h2: remove use of __devinitdata
      staging: wlags49_h2: remove use of __devexit
      staging: et131x: remove use of __devexit
      staging: et131x: remove use of __devinit
      staging: et131x: remove use of __devexit_p
      staging: rtl8187se: remove use of __devexit_p
      staging: rtl8192e: remove use of __devexit_p
      staging: rtl8192u: remove use of __devinit
      staging: rtl8192e: remove use of __devinit
      staging: rtl8187se: remove use of __devinit
      staging: rtl8187se: remove use of __devinitdata
      staging: rtl8192e: remove use of __devinitdata
      staging: rtl8187se: remove use of __devexit
      staging: rtl8192e: remove use of __devexit
      staging: rtl8192u: remove use of __devexit
      staging: comedi: remove use of __devexit_p
      staging: comedi: remove use of __devinit
      staging: comedi: remove use of __devexit
      staging: nvec: remove use of __devexit_p
      staging: nvec: remove use of __devinit
      staging: nvec: remove use of __devinitconst
      staging: nvec: remove use of __devexit
      staging: iio: remove use of __devinit
      staging: iio: remove use of __devexit
      staging: iio: remove use of __devexit_p
      staging: csr: remove CONFIG_HOTPLUG ifdefs
      staging: crystalhd: remove use of __devexit_p
      staging: drm/imx: remove use of __devexit_p
      staging: pc300: remove use of __devexit_p
      staging: octeon_ethernet: remove use of __devexit_p
      staging: slicoss: remove use of __devexit_p
      staging: sm7xxfb: remove use of __devexit_p
      staging: tidspbridge: remove use of __devexit_p
      staging: usbip: remove use of __devexit_p
      staging: vme: remove use of __devexit_p
      staging: xgifb: remove use of __devexit_p
      staging: olpc_dcon: remove use of __devexit_p
      staging: ste_rmi4: remove use of __devexit_p
      staging: xgifb: remove use of __devinit
      staging: vt6655: remove use of __devinit
      staging: vt6656: remove use of __devinit
      staging: vme: remove use of __devinit
      staging: tidspbridge: remove use of __devinit
      staging: ste_rmi4: remove use of __devinit
      staging: sm7xxfb: remove use of __devinit
      staging: slicoss: remove use of __devinit
      staging: sep: remove use of __devinit
      staging: octeon: remove use of __devinit
      staging: net: remove use of __devinit
      staging: crystalhd: remove use of __devinit
      staging: imx-drm: remove use of __devinit
      staging: omap-thermal: remove use of __devinit
      staging: sbe-2t3e3: remove use of __devinit
      staging: sbe-2t3e3: remove use of __devinitdata
      staging: imx-drm: remove use of __devexit
      staging: net: remove use of __devexit
      staging: octeon: remove use of __devexit
      staging: omap-thermal: remove use of __devexit
      staging: sbe-2t3e3: remove use of __devexit
      staging: slicoss: remove use of __devexit
      staging: sm7xxfb: remove use of __devexit
      staging: ste_rmi4: remove use of __devexit
      staging: tidspbridge: remove use of __devexit
      staging: vme: remove use of __devexit
      staging: vt6655: remove use of __devexit
      staging: xgifb: remove use of __devexit
      staging: crystalhd: remove use of __devexit
      staging: vt6656: remove use of __devexit
      ipack: remove use of __devexit_p
      ipack: remove use of __devinitconst
      ipack: remove use of __devexit
      staging: dt3155v4l: remove use of __devexit_p
      staging: lirc: remove use of __devexit_p
      staging: lirc: remove use of __devinit
      staging: solo6x10: remove use of __devinit
      staging: dt3155v4l: remove use of __devinit
      staging: lirc: remove use of __devexit
      staging: dt3155v4l: remove use of __devexit
      staging: solo6x10: remove use of __devexit

Bryan Freed (1):
      iio: isl29018: Support suspend and resume.

Ceri James (2):
      Staging: bcm: LeakyBucket.c: Checkpatch fixes
      Staging: bcm: InterfaceIdleMode.h: Checkpatch fixes

Chad Williamson (6):
      staging: silicom: fix whitespace in bp_proc.c
      staging: silicom: fix C99 comments in bp_proc.c
      staging: silicom: remove parentheses from return statements in bg_proc.c
      staging: silicom: remove unnecessary braces in bp_proc.c
      staging: silicom: fix explicit intialization of procfs_dir in bp_proc.c
      Staging: silicom: remove code requiring an old LINUX_VERSION_CODE

Chihau Chau (1):
      Staging: csr: bh.c: fixing spaces coding style issues

Constantine Shulyupin (1):
      staging: ccg: rename ccg init and exit functions to conventional names

Dan Carpenter (9):
      staging: rtl8192u: fix a macro expansion bug
      Staging: vt6655-6: shift wrap buf in s_vFillTxKey()
      Staging: vt6655-6: shift wrap in hostap_set_encryption()
      staging: r8712u: cleanup pointer type in r8712_setassocsta_cmd()
      iio:dac:ad5449: unlock on error path
      staging: panel: pass correct lengths to keypad_send_key()
      staging: gdm72xx: unlock on error in init_usb()
      iio:gyro: adis16136: divide by zero in write_frequency()
      iio:imu: adis16480: show_firmware() buffer too small

Derek Basehore (1):
      tsl2563: fixed bug with disabling interrupts

Devendra Naga (43):
      staging: ced1401: remove an obvious commit about the minor number
      staging: ced1401: fix some style warnings
      staging: ced1401: remove kernel version ifdef 's
      staging: crystalhd: fix a style warning
      staging: slicoss: fail out if we dont have a valid firmware file
      staging: slicoss: remove ASSERT macro altogether
      staging: slicoss: return -ENOMEM if kzalloc fail
      staging: slicoss: remove default case in irqhandler
      staging: slicoss: get rid of slic_cmdqmem_init function
      staging: ced1401: fix a frame size warning
      staging: csr: remove the CsrTime typedef altogether
      staging: csr: remove unused function prototypes
      staging: csr: remove panic at locking the mutex
      staging: csr: remove CsrMutexLock function
      staging: csr: remove CsrMutexUnlock function
      staging: csr: remove CsrMutexDestroy function
      staging: csr: remove CsrMutexCreate function
      staging: csr: remove all prototypes of not defined functions
      staging: csr: remove csrPanic and CSR_LOG_ASSERT and CSR_LOG_ASSERT_ENABLE
      staging: slicoss: fix a leak when kzalloc fail
      staging: csr: remove unused macros/ prototypes in csr_sched.h
      staging: csr: remove unused macros and prototypes
      staging: csr: remove func_enter macro
      staging: csr: remove func_exit macro
      staging: csr: remove func_exit_r macro
      staging: sep: return -EFAULT on copy_from_user failure
      staging: csr: io.c: replace spaces with tabs
      staging: csr: drv.c: replace spaces with tabs
      staging: csr: drv.c: replace spaces with tabs in uf_destroy_device_nodes
      staging: csr: os.c: remove col variable
      staging: csr: os.c: remove braces around single statement blocks
      staging: csr: remove csr_lib.h
      staging: csr: csr_log_configure.h: remove a bunch of function protos
      staging: csr: inet.c: single statement if blocks doesn't need braces
      staging: csr: inet.c: replaces spaces with tabs
      staging: csr: sme_blocking.c: replace spaces with tabs
      staging: csr: sme_blocking.c: replace spaces with the tabs in sme_mgt_tspec
      staging: csr: sme_blocking.c: remove braces around single statement blocks
      staging: csr: sme_blocking.c: add missing check for return of sme_wait_for_reply
      staging: csr: csr_wifi_nme_lib.h: remove function prototypes
      staging: csr: csr_wifi_nme_ap_lib.h: remove the function prototypes
      staging: csr: csr_wifi_nme_task.h: remove function prototypes
      staging: ft1000: remove assigments of ret and initialise it in beginning

Edgar Neukirchner (1):
      Staging: rtl8192e: rtllib_tx.c: fixed an asterisk coding style issue

Eduardo Valentin (4):
      staging: omap-thermal: fix compilation
      staging: omap-thermal: remove platform data nomenclature
      staging: omap-thermal: remove freq_clip table
      staging: omap-thermal: add IRQ debugging messaging

Fabio Estevam (2):
      staging: ipu-v3: ipu-common: Make it less verbose
      staging: ipu-v3: ipu-common: Indicate succesful probe

Fengguang Wu (1):
      staging: ced1401: remove useless value cast on kmalloc()

Greg Kroah-Hartman (23):
      Staging: csr: data_tx: clean up tab mess
      Staging: csr: data_tx: fix up brace placement
      Staging: csr: data_tx: remove extra space in printk
      Merge tag 'iio-for-3.8a' of git://git.kernel.org/.../jic23/iio into staging-next
      Staging: silicom: fix up compiler warnings in bp_proc.c
      Staging: remove rts_pstor driver
      Staging: remove telephony drivers
      Staging: csr: remove __cplusplus nonsense from the .h files
      Staging: csr: csr_macro.h: remove unused macros
      Staging: telephony: remove unneeded Documentation
      Staging: csr: remove CSRMIN() macro
      Merge 3.7-rc3 into staging-next
      Merge tag 'iio-for-3.8b' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge 3.7-rc5 into staging-next
      Merge tag 'iio-for-3.8c' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge tag 'iio-for-3.8d' of git://git.kernel.org/.../jic23/iio into staging-next
      IIO: fix build error in lp8788-charger.c
      Staging: ipack: CONFIG_HOTPLUG is always enabled
      Staging: ipack: remove last TODO items
      Staging: ipack: move out of staging
      Merge 3.7-rc6 into staging-next
      Merge tag 'iio-for-3.8e' of git://git.kernel.org/.../jic23/iio into staging-next
      Merge tag 'iio-for-3.8f' of git://git.kernel.org/.../jic23/iio into staging-next

H Hartley Sweeten (426):
      staging: comedi: mpc8260cpm: remove driver
      staging: comedi: ssv_dnp: remove boardinfo
      staging: comedi: serial2002: remove boardinfo
      staging: comedi: pcmmio: remove boardinfo
      staging: comedi: pcmda12: remove boardinfo
      staging: comedi: pcm3724: remove boardinfo
      staging: comedi: ke_counter: remove boardinfo
      staging: comedi: dmm32at: remove boardinfo
      staging: comedi: das16m1: remove boardinfo
      staging: comedi: cb_pcimdas: remove boardinfo
      staging: comedi: aio_iiro_16: remove boardinfo
      staging: comedi: adq12b: remove boardinfo
      staging: comedi: cb_pcidas64: remove inline priv() function
      staging: comedi: gsc_hpdi: remove inline priv() function
      staging: comedi: ni_65xx: remove inline private() function
      staging: comedi: ni_660x: remove inline private() function
      staging: comedi: poc: introduce struct poc_private
      staging: comedi: addi-data: remove devpriv macro
      staging: comedi: ni_mio_common: remove devpriv macro
      staging: comedi: drivers: remove remaining devpriv macros
      staging: comedi: s626: remove devpriv macro
      staging: comedi: remove inline alloc_private()
      staging: comedi: auto-config drivers do not need to set hw_dev
      staging: comedi: ni_660x: move module init code to EOF
      staging: comedi: ni_660x: remove inline function board()
      staging: comedi: ni_660x: remove BUG_ON(chan >= NUM_PFI_CHANNELS)
      staging: comedi: ni_660x: remove ni_660x_get_pfi_routing()
      staging: comedi: ni_660x: remove ni660x_config_filter()
      staging: comedi: ni_660x: cleanup ni_660x_dio_insn_config()
      staging: comedi: cb_pcidda: fix error test in cb_pcidda_attach_pci()
      staging: comedi: cb_pcidda: remove code in #if 0/#endif blocks
      staging: comedi: cb_pcidda: add defines for the PCI device ids
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_CB
      staging: comedi: cb_pcidda: remove private data variable 'dac'
      staging: comedi: cb_pcidda: cleanup the private data
      staging: comedi: cb_pcidda: remove private data variable 'digitalio'
      staging: comedi: cb_pcidda: remove the debug output of the eeprom data
      staging: comedi: cb_pcidda: rename local variable 'index'
      staging: comedi: cb_pcidda: check for subdev_8255_init() failure
      staging: comedi: cb_pcidda: cleanup the analog output range
      staging: comedi: cb_pcidda: cleanup the copyright and comedi comments
      staging: comedi: cb_pcidda: remove the private data 'status'
      staging: comedi: cb_pcidda: cleanup the boardinfo
      staging: comedi: cb_pcidda: cleanup the dio register defines
      staging: comedi: cb_pcidda: cleanup DACCONTROL defines
      staging: comedi: cb_pcidda: cleanup DADATA define
      staging: comedi: cb_pcidda: cleanup cb_pcidda_ao_winsn()
      staging: comedi: cb_pcidda: cleanup cb_pcidda_calibrate()
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_ADVANTECH
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_MEILHAUS
      staging: comedi: hwdrv_APCI1710: remove APCI1710_BOARD_VENDOR_ID
      staging: comedi: addi_common: use PCI_VENDOR_ID_ADDIDATA
      staging: comedi: addi_common: use PCI_VENDOR_ID_ADDIDATA_OLD
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_DT
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_KOLTER
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_IOTECH
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_RTD
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_AMCC
      staging: comedi: dyna_pci10xx: remove PCI_VENDOR_ID_DYNALOG
      staging: comedi: comedidev.h: add PCI_VENDOR_ID_AMPLICON
      staging: comedi: dt3000: remove this_board macro
      staging: comedi: dt3000: convert driver to attach_pci
      staging: comedi: dt3000: cleanup the range tables
      staging: comedi: dt3000: add defines for the PCI device ids
      staging: comedi: dt3000: remove forward declarations
      staging: comedi: dt3000: remove '0' entries in boardinfo
      staging: comedi: dt3000: cleanup the boardinfo
      staging: comedi: dt3000: add a simple dev_info() when attached
      staging: comedi: dt3000: add some whitespace to the subdevice init
      staging: comedi: dt3000: remove dev_dbg() noise
      staging: comedi: dt3000: remove empty 'else' code
      staging: comedi: dt3000: change return type of dt3k_send_cmd to void
      staging: comedi: me_daq: fix pointer dereference in me_detach()
      staging: comedi: me_daq: cleanup ioremap of PCI bar 2
      staging: comedi: me_daq: replace 'result' and 'error' with 'ret'
      staging: comedi: me_daq: pass on the error from comedi_pci_enable()
      staging: comedi: me_daq: factor out the PLX bug workaround
      staging: comedi: me_daq: analog output subdevice could be unused
      staging: comedi: me_daq: remove '0' and 'NULL' entries in boardinfo
      staging: comedi: me_daq: remove {ao,ai}_resoultion_mask
      staging: comedi: me_daq: remove dio_channel_nbr from boardinfo
      staging: comedi: me_daq: cleanup the boardinfo
      staging: comedi: me_daq: cleanup the range tables
      staging: comedi: me_daq: add some whitespace to the subdevice init
      staging: comedi: me_daq: remove pci_dev_put() in detach
      staging: comedi: me_daq: fix me_ao_insn_read()
      staging: comedi: me_daq: fix me_ao_insn_write()
      staging: comedi: me_daq: remove incomplete analog input command support
      staging: comedi: me_daq: cleanup the copyright and comedi comments
      staging: comedi: me_daq: all boards have the same analog input specs
      staging: comedi: me_daq: simplify analog output boardinfo
      staging: comedi: me_daq: fix me_dio_insn_config()
      staging: comedi: me_daq: cleanup me_dio_insn_bits()
      staging: comedi: me_daq: cleanup me_ai_insn_read()
      staging: comedi: me_daq: remove some obvious comments
      staging: comedi: rtd520: cleanup pci bar ioremap
      staging: comedi: rtd520: factor out the pci latency quirk
      staging: comedi: rtd520: factor out the board init
      staging: comedi: rtd520: factor out the board reset
      staging: comedi: rtd520: remove broken USE_DMA code
      staging: comedi: rtd520: remove the board attach noise
      staging: comedi: rtd520: convert driver to attach_pci
      staging: comedi: rtd520: remove code in #if 0/#endif blocks
      staging: comedi: rtd520: remove DPRINTK messages
      staging: comedi: rtd520: remove 'intCount' from the private data
      staging: comedi: rtd520: fix > 80 char line checkpatch.pl issues
      staging: comedi: rtd520: allow attaching without interrupt support
      staging: comedi: rtd520: remove 'aiChans' and 'aiBits' from boardinfo
      staging: comedi: rtd520: remove 'aiMaxGain' from boardinfo
      staging: comedi: rtd520: add whitespace to the subdevice init
      staging: comedi: rtd520: move #include's to top of file
      staging: comedi: rtd520: remove unused LAS0_SPARE_* defines
      staging: comedi: rtd520: cleanup the LAS0_* defines
      staging: comedi: rtd520: cleanup the LAS1_* defines
      staging: comedi: rtd520: cleanup the LCFG_* defines
      staging: comedi: rtd520: cleanup FS_* defines
      staging: comedi: rtd520: cleanup TS_* defines
      staging: comedi: addi_common: move module init code to EOF
      staging: comedi: addi-data: move the main #include's to the drivers
      staging: comedi: addi-data: remove this_board macro
      staging: comedi: addi-data: remove the addi-data #include ifdef'ery
      staging: comedi: addi-data: remove the MODULE_DEVICE_TABLE #ifdef'ery
      staging: comedi: addi-data: remove the boardinfo #ifdef'ery
      staging: comedi: addi_common: remove the extra cruft
      staging: comedi: addi_common: remove forward declarations
      staging: comedi: hwdrv_apci035: remove forward declarations
      staging: comedi: hwdrv_apci1032: remove forward declarations
      staging: comedi: hwdrv_apci1500: remove forward declarations
      staging: comedi: hwdrv_apci1516: remove forward declarations
      staging: comedi: hwdrv_apci1564: remove forward declarations
      staging: comedi: hwdrv_apci16xx: remove forward declarations
      staging: comedi: hwdrv_apci2016: remove forward declarations
      staging: comedi: hwdrv_apci2032: remove forward declarations
      staging: comedi: hwdrv_apci2200: remove forward declarations
      staging: comedi: hwdrv_apci3501: remove forward declarations
      staging: comedi: hwdrv_APCI1710: remove forward declarations
      staging: comedi: APCI1710_Dig_io: remove forward declarations
      staging: comedi: APCI1710_Inp_cpt: remove forward declarations
      staging: comedi: APCI1710_Ssi: remove forward declarations
      staging: comedi: APCI1710_Tor: remove forward declarations
      staging: comedi: APCI1710_Ttl: remove forward declarations
      staging: comedi: addi_eeprom: remove extra whitespace and comment cruft
      staging: comedi: addi_eeprom: make v_EepromWaitBusy() static
      staging: comedi: addi_eeprom: make the 93c76 eeprom functions static
      staging: comedi: addi_eeprom: make the eeprom helper functions static
      staging: comedi: addi_eeprom: remove the last forward declarations
      staging: comedi: addi_eeprom: rename 'dw_Address'/'w_PCIBoardEepromAddress'
      staging: comedi: addi_eeprom: rename 'pc_PCIChipInformation'
      staging: comedi: addi_eeprom: add defines for the 93c76 eeprom bits
      staging: comedi: addi_eeprom: cleanup v_EepromClock76()
      staging: comedi: addi_eeprom: cleanup v_EepromSendCommand76()
      staging: comedi: addi_eeprom: cleanup v_EepromCs76Read()
      staging: comedi: addi_eeprom: cleanup v_EepromWaitBusy()
      staging: comedi: addi_eeprom: factor out the nvram read code
      staging: comedi: addi_eeprom: use AMCC_OP_REG_* defines
      staging: comedi: addi_eeprom: cleanup v_EepromReadWord()
      staging: comedi: addi_eeprom: move the eeprom offset to addi_eeprom_readw()
      staging: comedi: addi_eeprom: cleanup i_EepromReadMainHeader()
      staging: comedi: addi_eeprom: cleanup i_EepromReadDigitalInputHeader()
      staging: comedi: addi_eeprom: cleanup i_EepromReadDigitalOutputHeader()
      staging: comedi: addi_eeprom: cleanup i_EepromReadAnlogOutputHeader()
      staging: comedi: addi_eeprom: cleanup i_EepromReadAnlogInputHeader()
      staging: comedi: addi_eeprom: cleanup i_EepromReadTimerHeader()
      staging: comedi: addi_eeprom: cleanup i_EepromReadMainHeader()
      staging: comedi: addi_eeprom: reformat driver comment
      staging: comedi: addi_eeprom: cleanup the defines
      staging: comedi: addi_eeprom: fix remaining checkpatch.pl issues
      staging: comedi: addi_eeprom: don't pass the eeprom 'type'
      staging: comedi: hwrdv_apci035: absorb private header
      staging: comedi: hwrdv_apci1032: absorb private header
      staging: comedi: hwrdv_apci1500: absorb private header
      staging: comedi: hwrdv_apci1516: absorb private header
      staging: comedi: hwrdv_apci1564: absorb private header
      staging: comedi: hwrdv_apci16xx: absorb private header
      staging: comedi: hwrdv_apci2016: absorb private header
      staging: comedi: hwrdv_apci2032: absorb private header
      staging: comedi: hwrdv_apci2200: absorb private header
      staging: comedi: hwrdv_apci3501: absorb private header
      staging: comedi: hwrdv_apci3xxx: absorb private header
      staging: comedi: hwdrv_apci3120: remove forward declarations
      staging: comedi: hwrdv_apci3120: absorb private header
      staging: comedi: APCI1710_Ttl: absorb private header
      staging: comedi: APCI1710_Tor: absorb private header
      staging: comedi: APCI1710_Ssi: absorb private header
      staging: comedi: APCI1710_Inp_cpt: absorb private header
      staging: comedi: APCI1710_Dig_io: absorb private header
      staging: comedi: APCI1710_82x54: remove forward declarations
      staging: comedi: APCI1710_82x54: absorb private header
      staging: comedi: APCI1710_Chrono: remove forward declarations
      staging: comedi: APCI1710_Chrono: absorb private header
      staging: comedi: APCI1710_INCCPT: remove forward declarations
      staging: comedi: APCI1710_INCCPT: absorb private header
      staging: comedi: APCI1710_Pwm: remove forward declarations
      staging: comedi: APCI1710_Pwm: absorb private header
      staging: comedi: hwdrv_apci3200: remove forward declarations
      staging: comedi: hwdrv_apci3200: absorb private header
      staging: comedi: hwdrv_APCI1710: absorb private header
      staging: comedi: addi_apci_*: remove unneeded CONFIG_APCI_* defines
      staging: comedi: addi_apci_*: add module_comedi_pci_driver()
      staging: comedi: addi-data: remove v_pci_card_list_display()
      staging: comedi: addi-data: remove the board attach noise
      staging: comedi: addi-data: remove unused parameters from i_pci_card_data()
      staging: comedi: addi-data: remove irq parameter from i_pci_card_data()
      staging: comedi: addi-data: remove io_addr array from card data
      staging: comedi: addi-data: absorb pci_card_alloc() into i_ADDI_Attach()
      staging: comedi: addi-data: add a 'pcidev' local var to i_ADDI_Attach()
      staging: comedi: addi-data: remove 'irq' from the card data
      staging: comedi: addi-data: remove attach option to disable dma
      staging: comedi: addi-data: remove i_pci_card_free()
      staging: comedi: addi-data: use attach_pci callback
      staging: comedi: addi-data: cleanup reading of the PCI bars
      staging: comedi: addi-data: remove 'allocated' from the private data
      staging: comedi: addi-data: remove 'b_ValidDriver' from the private data
      staging: comedi: addi-data: remove addi_amcc_s5933.h
      staging: comedi: addi-data: remove duplicate #include's
      staging: comedi: addi-data: remove duplicate ADDIDATA_{ENABLE,DISABLE} defines
      staging: comedi: addi-data: remove ERROR and SUCCESS defines
      staging: comedi: addi_apci_1710: separate from addi_common.c
      staging: comedi: addi-data: remove special handling for apci1710
      staging: comedi: addi_apci_1710: cleanup addi_find_boardinfo()
      staging: comedi: addi_apci_1710: remove i_ADDI_Reset
      staging: comedi: addi_apci_1710: remove eeprom handling code
      staging: comedi: addi_apci_1710: remove dma setup/free code
      staging: comedi: addi_apci_1710: remove the eeprom parameters
      staging: comedi: addi_apci_1710: remove the 'i_IorangeBase*'
      staging: comedi: addi_apci_1710: remove COMEDI_SUBD_TTLIO define
      staging: comedi: addi_apci_1710: add the missing MODULE_* information
      staging: comedi: addi_apci_3120: merge in addi_apci_3001 driver
      staging: comedi: addi_apci_3120: remove CONFIG_APCI_3120 define
      staging: comedi: addi_apci_3120: separate from addi_common.c
      staging: comedi: addi_common: remove dma setup/free code
      staging: comedi: addi_apci_3120: remove eeprom handling code
      staging: comedi: addi_apci_3120: board does not have ttl i/o
      staging: comedi: addi_apci_3120: remove need for s_EeParameters
      staging: comedi: addi_apci_3120: remove test for dma support
      staging: comedi: addi_apci_3120: remove test for timer support
      staging: comedi: addi_apci_3120: remove test for DO subdevice
      staging: comedi: addi_apci_3120: remove test for DI subdevice
      staging: comedi: addi_apci_3120: remove test for AI subdevice
      staging: comedi: addi_apci_3120: clarify timer subdevice init
      staging: comedi: addi_apci_3120: clarify DO subdevice init
      The two boards supported by this driver use the same functions for     the comedi operations. Remove this data from the boardinfo to clarify     the subdevice init.
      staging: comedi: addi_apci_3120: clarify AI subdevice init
      staging: comedi: addi_apci_3120: remove i_ADDI_Reset()
      staging: comedi: addi_apci_3120: fix the number of subdevices
      staging: comedi: addi_apci_3120: remove the 'i_IorangeBase*'
      staging: comedi: addi_apci_3120: remove 'pr_AiRangelist'
      staging: comedi: addi_apci_3120: remove 'ui_MinAcquisitiontimeNs'
      staging: comedi: addi_apci_3120: remove 'ui_MinDelaytimeNs'
      staging: comedi: addi_apci_3120: remove 'b_AvailableConvertUnit'
      staging: comedi: addi_apci_3120: clarify AO subdevice init
      staging: comedi: addi_apci_3120: cleanup apci3120_detach()
      staging: comedi: addi_apci_3120: remove COMEDI_SUBD_TTLIO define
      staging: comedi: addi_apci_3120: cleanup addi_find_boardinfo()
      staging: comedi: addi_apci_1032: separate from addi_common.c
      staging: comedi: addi_apci_1032: remove i_ADDI_Reset()
      staging: comedi: addi_apci_1032: board does not have ttl i/o
      staging: comedi: addi_apci_1032: board does not have a timer
      staging: comedi: addi_apci_1032: board does not have digital outputs
      staging: comedi: addi_apci_1032: board does not have analog inputs
      staging: comedi: addi_apci_1032: board does not have analog outputs
      staging: comedi: addi_apci_1032: board has 32 digital inputs
      staging: comedi: addi_apci_1032: simplify the PCI bar reading
      staging: comedi: addi_apci_1032: remove dw_AiBase
      staging: comedi: addi_apci_1032: remove i_IorangeBase[01]
      staging: comedi: addi_apci_1032: remove use of devpriv->iobase
      staging: comedi: addi_apci_1032: remove i_IobaseReserved
      staging: comedi: addi_apci_1032: remove unnecessary eeprom code
      staging: comedi: addi_apci_1032: call v_APCI1032_Interrupt() directly
      staging: comedi: addi_apci_1032: remove the boardinfo
      staging: comedi: addi_apci_1032: cleanup the register map defines
      staging: comedi: addi_apci_1032: cleanup i_APCI1032_Reset()
      staging: comedi: addi_apci_1032: fix i_APCI1032_ReadMoreDigitalInput()
      staging: comedi: addi_apci_1032: remove i_APCI1032_Read1DigitalInput()
      staging: comedi: addi_apci_1032: cleanup i_APCI1032_ReadMoreDigitalInput()
      staging: comedi: addi_apci_1032: only allocate one subdevice
      staging: comedi: addi_apci_1032: cleanup v_ADDI_Interrupt()
      staging: comedi: addi_apci_1032: merge in hwdrv_apci1032.c
      staging: comedi: addi_apci_1032: add a subdevice for the interrupt support
      staging: comedi: addi_apci_1032: remove send_sig() use
      staging: comedi: addi_apci_1032: hook-up the interrupt subdevice
      staging: comedi: addi_apci_1032: remove len_chanlist on di subdevice
      staging: comedi: addi_apci_1032: remove unnecessary include
      staging: comedi: addi_apci_3501: remove i_APCI3501_ConfigDigitalOutput()
      staging: comedi: addi_apci_3501: fix digital input 'insn_bits' function
      staging: comedi: addi_apci_3501: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_3xxx: fix digital input 'insn_bits' function
      staging: comedi: addi_apci_3xxx: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_3200: merge addi_apci_3300 support
      staging: comedi: addi_apci_3200: fix digital input 'insn_bits' function
      staging: comedi: addi_apci_3200: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_3200: remove i_APCI3200_ConfigDigitalOutput()
      staging: comedi: addi_apci_3120: fix digital input 'insn_bits' function
      staging: comedi: addi_apci_3120: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_3120: remove i_APCI3120_InsnConfigDigitalOutput()
      staging: comedi: addi_apci_2200: fix digital input 'insn_bits' function
      staging: comedi: addi_apci_2200: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_2200: remove i_APCI2200_ConfigDigitalOutput()
      staging: comedi: addi_apci_2032: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_2016: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_2016: remove i_APCI2016_ConfigDigitalOutput()
      staging: comedi: addi_apci_1564: fix digital input 'insn_bits' function
      staging: comedi: addi_apci_1564: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_1516: fix digital input 'insn_bits' function
      staging: comedi: addi_apci_1516: fix digital output 'insn_bits' function
      staging: comedi: addi_apci_1516: remove i_APCI1516_ConfigDigitalOutput()
      staging: comedi: addi_apci_1500: fix digital input 'insn_bits' function
      staging: comedi: addi-data: use auto_attach instead of attach_pci
      staging: comedi: addi_apci_*: use auto_attach instead of attach_pci
      staging: comedi: addi_common.c: fix the test for the PCI bars
      staging: comedi: addi_apci_1516: merge in addi_apci_2016 driver
      staging: comedi: addi_apci_1516: add support for apci1016 board
      staging: comedi: addi_apci_1516: cleanup the register map defines
      staging: comedi: addi_apci_1516: define the watchdog control register
      staging: comedi: addi_apci_1516: separate from addi_common.c
      staging: comedi: addi_apci_1516: board does not have ttl i/o
      staging: comedi: addi_apci_1516: board does not have analog inputs
      staging: comedi: addi_apci_1516: board does not have analog outputs
      staging: comedi: addi_apci_1516: remove eeprom support code
      staging: comedi: addi_apci_1516: remove unused define
      staging: comedi: addi_apci_1516: remove unnecessary include
      staging: comedi: addi_apci_1516: absorb i_APCI1516_Reset()
      staging: comedi: addi_apci_1516: don't reset the apci1016 board
      staging: comedi: addi_apci_1516: boards do not have interrupts
      staging: comedi: addi_apci_1516: cleanup subdevice ops pointers
      staging: comedi: addi_apci_1516: simplify the PCI bar reading
      staging: comedi: addi_apci_1516: remove unnecessary info from boardinfo
      staging: comedi: addi_apci_1516: remove devpriv->iobase usage
      staging: comedi: addi_apci_1516: remove devpriv->dw_AiBase
      staging: comedi: addi_apci_1516: don't read the unused PCI bars
      staging: comedi: addi_apci_1516: remove use of devpriv->s_EeParameters
      staging: comedi: addi_apci_1516: only allocate needed subdevices
      staging: comedi: addi_apci_1516: remove use of struct addi_private
      staging: comedi: addi_apci_1516: remove use of struct addi_board
      staging: comedi: addi_apci_1516: remove unnecessary include
      staging: comedi: addi_apci_1516: cleanup addi_find_boardinfo()
      staging: comedi: addi_apci_1516: merge in hwdrv_apci1516.c
      staging: comedi: addi_apci_1516: remove setting of s->len_chanlist
      staging: comedi: addi_apci_1516: remove setting of s->io_bits
      staging: comedi: addi_apci_1516: cleanup the s->subdev_flags
      staging: comedi: addi_apci_1516: add defines for the PCI device ids
      staging: comedi: addi_apci_1516: cleanup apci1516_detach()
      staging: comedi: addi_apci_1516: cleanup the subdevice init
      staging: comedi: addi_apci_1516: fix i_APCI1516_ReadWatchdog()
      staging: comedi: addi_apci_1516: fix i_APCI1516_ConfigWatchdog()
      staging: comedi: addi_apci_1516: fix i_APCI1516_StartStopWriteWatchdog()
      staging: comedi: addi_apci_1516: final cleanup of the register map defines
      staging: comedi: addi_apci_1516: rename has_timer
      staging: comedi: addi_apci_1516: reword the initialization comments
      staging: comedi: addi_apci_1516: update the Kconfig
      staging: comedi: addi_apci_1516: update the MODULE_DESCRIPTION
      staging: comedi: Kconfig: remove VIRT_TO_BUS depends on
      staging: comedi: comedi_fc.h: introduce new helpers for do_cmdtest step 3
      staging: comedi: 8255: use cfc_check_trigger_arg_*() helpers
      staging: comedi: comedi_parport: use cfc_check_trigger_arg_*() helpers
      staging: comedi: addi_apci_1032: use cfc_check_trigger_arg_*() helpers
      staging: comedi: amplc_dio200: use cfc_check_trigger_arg_*() helpers
      staging: comedi: amplc_pc236: use cfc_check_trigger_arg_*() helpers
      staging: comedi: ni_6527: use cfc_check_trigger_arg_*() helpers
      staging: comedi: ni_65xx: use cfc_check_trigger_arg_*() helpers
      staging: comedi: pcm_common: use cfc_check_trigger_arg_*() helpers
      staging: comedi: das800: use cfc_check_trigger_arg_*() helpers
      staging: comedi: comedi_test: use cfc_check_trigger_arg_*() helpers
      staging: comedi: hwdrv_apci3120: use cfc_check_trigger_arg_*() helpers
      staging: comedi: adl_pci9111: use cfc_check_trigger_arg_*() helpers
      staging: comedi: adl_pci9118: use cfc_check_trigger_arg_*() helpers
      staging: comedi: adv_pci1710: use cfc_check_trigger_arg_*() helpers
      staging: comedi: amplc_pci224: use cfc_check_trigger_arg_*() helpers
      staging: comedi: amplc_pci230: use cfc_check_trigger_arg_*() helpers
      staging: comedi: cb_das16_cs: use cfc_check_trigger_arg_*() helpers
      staging: comedi: cb_pcidas: use cfc_check_trigger_arg_*() helpers
      staging: comedi: das16: use cfc_check_trigger_arg_*() helpers
      staging: comedi: das16m1: use cfc_check_trigger_arg_*() helpers
      staging: comedi: das1800: use cfc_check_trigger_arg_*() helpers
      staging: comedi: dmm32at: use cfc_check_trigger_arg_*() helpers
      staging: comedi: dt2814: use cfc_check_trigger_arg_*() helpers
      staging: comedi: dt282x: use cfc_check_trigger_arg_*() helpers
      staging: comedi: dt3000: use cfc_check_trigger_arg_*() helpers
      staging: comedi: gsc_hpdi: use cfc_check_trigger_arg_*() helpers
      staging: comedi: gsc_hpdi: cleanup step 3 of me4000_ai_do_cmd_test()
      staging: comedi: ni_at_a2150: use cfc_check_trigger_arg_*() helpers
      staging: comedi: ni_atmio16d: use cfc_check_trigger_arg_*() helpers
      staging: comedi: ni_labpc: use cfc_check_trigger_arg_*() helpers
      staging: comedi: ni_pcidio: use cfc_check_trigger_arg_*() helpers
      staging: comedi: ni_tiocmd: use cfc_check_trigger_arg_*() helpers
      staging: comedi: pcl711: use cfc_check_trigger_arg_*() helpers
      staging: comedi: pcl812: use cfc_check_trigger_arg_*() helpers
      staging: comedi: pcl816: use cfc_check_trigger_arg_*() helpers
      staging: comedi: pcl818: use cfc_check_trigger_arg_*() helpers
      staging: comedi: quatech_daqp_cs: use cfc_check_trigger_arg_*() helpers
      staging: comedi: rtd520: use cfc_check_trigger_arg_*() helpers
      staging: comedi: s626: use cfc_check_trigger_arg_*() helpers
      staging: comedi: skel: use cfc_check_trigger_arg_*() helpers
      staging: comedi: usbdux: use cfc_check_trigger_arg_*() helpers
      staging: comedi: usbduxfast: use cfc_check_trigger_arg_*() helpers
      staging: comedi: usbduxsigma: use cfc_check_trigger_arg_*() helpers
      staging: comedi: ni_mio_common: use cfc_check_trigger_arg_*() helpers
      staging: comedi: cb_pcidas64: use cfc_check_trigger_arg_*() helpers
      staging: comedi: remove unnecessary '#define _GNU_SOURCE'
      staging: comedi: remove unnecessary '#define __NO_VERSION__'
      staging: comedi: addi_apci_2032: separate from addi_common.c
      staging: comedi: addi_apci_2032: board does not have ttl i/o
      staging: comedi: addi_apci_2032: board does not have digital inputs
      staging: comedi: addi_apci_2032: board does not have analog outputs
      staging: comedi: addi_apci_2032: board does not have analog inputs
      staging: comedi: addi_apci_2032: remove eeprom support code
      staging: comedi: addi_apci_2032: remove unnecessary include
      staging: comedi: addi_apci_2032: absorb i_APCI2032_Reset()
      staging: comedi: addi_apci_2032: simplify the PCI bar reading
      staging: comedi: addi_apci_2032: remove unnecessary info from boardinfo
      staging: comedi: addi_apci_2032: remove devpriv->iobase usage
      staging: comedi: addi_apci_2032: don't read the unused PCI bars
      staging: comedi: addi_apci_2032: remove use of devpriv->s_EeParameters
      staging: comedi: addi_apci_2032: only allocate needed subdevices
      staging: comedi: addi_apci_2032: remove boardinfo
      staging: comedi: addi_apci_2032: cleanup the s->subdev_flags
      staging: comedi: addi_apci_2032: merge in hwdrv_apci2032.c
      staging: comedi: addi_apci_2032: cleanup register map defines
      staging: comedi: addi_apci_2032: fix i_APCI2032_ReadWatchdog()
      staging: comedi: addi_apci_2032: remove use of struct addi_private
      staging: comedi: addi_apci_2032: remove need for addi-data/addi_common.h
      staging: comedi: addi_apci_2032: fix the watchdog timer subdevice
      staging: comedi: addi_apci_2032: cleanup the subdevice init
      staging: comedi: addi_apci_2032: remove the timer s->range_table
      staging: comedi: addi_apci_2032: move i_APCI2032_ConfigDigitalOutput()
      staging: comedi: addi_apci_2032: fix interrupt support

Harvey Yang (2):
      staging: usbip: put usb_device and kill event handler thread in error cleanups.
      usb: usbip: userspace: remove the port state file when detaching port.

Hojung Youn (4):
      staging: csr: csr_wifi_hip_unifi_signal_names: fix indent
      staging: csr: csr_wifi_hip_unifi_signal_names: fix brackets
      staging: csr: csr_wifi_hip_unifi_signal_names: fix whitespaced paddings
      staging: csr: csr_wifi_hip_unifi_signal_names: Fix pointer position

Homin Lee (1):
      Staging: csr: csr_log_configure.h: clean up tab mess

Ian Abbott (93):
      staging: comedi: jr3_pci: add __iomem tags
      staging: comedi: gsc_hpdi: make internal functions static
      staging: comedi: avoid a put_device(), get_device() sequence
      staging: comedi: always set hw_dev during auto-config
      staging: comedi: amplc_dio200: reformat driver comment
      staging: comedi: amplc_dio200: remove manual configuration of PCI boards
      staging: comedi: amplc_dio200: no need to manipulate PCI ref count
      staging: comedi: amplc_dio200: no need to set hw_dev
      staging: comedi: amplc_dio200: absorb dio200_pci_common_attach()
      staging: comedi: amplc_dio200: pass device to clock/gate config
      staging: comedi: amplc_dio200: rename enum dio200_layout
      staging: comedi: amplc_dio200: rename struct dio200_layout_struct
      staging: comedi: amplc_dio200: add helpers to get board layout
      staging: comedi: amplc_dio200: remove 'has_clk_gat_sce' from subdevice
      staging: comedi: amplc_dio200: use register offsets in subdevices
      staging: comedi: amplc_dio200: add functions to access 8254 counters
      staging: comedi: amplc_dio200: internalize 8255 DIO implementation
      staging: comedi: amplc_dio200: don't select COMEDI_8255
      staging: comedi: amplc_dio200: use custom register access functions
      staging: comedi: amplc_dio200: set dev->iobase before common attach
      staging: comedi: amplc_dio200: support memory-mapped I/O
      staging: comedi: amplc_dio200: add PCI BAR information to board
      staging: comedi: amplc_dio200: add min register region size in board
      staging: comedi: amplc_dio200: add register shift to board info
      staging: comedi: amplc_dio200: support PCIe215, PCIe236 and PCIe296
      staging: comedi: amplc_dio200: allow generation of PCIe interrupts
      staging: comedi: amplc_dio200: enable enhanced features of PCIe boards
      staging: comedi: amplc_dio200: allow extra clock and gate sources
      staging: comedi: comedi.h: extra clock and gate sources for amplc_dio200
      staging: comedi: amplc_dio200: add 32-bit register access functions
      staging: comedi: amplc_dio200: implement timer subdevice
      staging: comedi: comedi.h: add clock sources for amplc_dio200 timer
      staging: comedi: amplc_dio200: support multiple read/write of counter
      staging: comedi: Kconfig: update COMEDI_AMPLC_DIO200_PCI option
      staging: comedi: change type of auto-config context
      staging: comedi: rename old auto-config functions
      staging: comedi: add generic auto-config functions
      staging: comedi: support auto_attach() for PCI and USB
      staging: comedi: add comedi to usb interface helper
      staging: comedi: vmk80xx: use auto_attach() hook
      staging: comedi: amplc_pci230: use auto_attach() hook
      staging: comedi/drivers: use auto_attach instead of attach_usb
      staging: comedi/drivers: use auto_attach instead of attach_pci
      staging: comedi: rtd520: use auto_attach instead of attach_pci
      staging: comedi: skel: remove thisboard macro
      staging: comedi: skel: replace pr_...() with dev_...()
      staging: comedi: skel: remove driver_ prefix
      staging: comedi: skel: use module_comedi_pci_driver()
      staging: comedi: skel: remove most forward declarations
      staging: comedi: skel: remove remaining forward declaration
      staging: comedi: skel: move skel_pci_table
      staging: comedi: skel: do auto-attachment of PCI devices
      staging: comedi: gsc_hpdi: use auto_attach method
      staging: comedi: gsc_hpdi: remove devpriv->hw_dev
      staging: comedi: gsc_hpdi: don't store physical base addresses
      staging: comedi: gsc_hpdi: remove board(dev) function
      staging: comedi: gsc_hpdi: make board name pointer const
      staging: comedi: gsc_hpdi: use board name to request resources
      staging: comedi: gsc_hpdi: change DEBUG_PRINT()
      staging: comedi: gsc_hpdi: update driver description comment
      staging: comedi: jr3_pci: use auto_attach method
      staging: comedi: jr3_pci: rename card variable
      staging: comedi: jr3_pci: remove devpriv->pci_dev
      staging: comedi: jr3_pci: remove devpriv->pci_enabled
      staging: comedi: jr3_pci: remove noisy printk
      staging: comedi: jr3_pci: update driver description comment
      staging: comedi: jr3_pci: CodingStyle fixes
      staging: comedi: adl_pci9118: replace printks
      staging: comedi: adl_pci9118: split pci9118_attach()
      staging: comedi: adl_pci9118: cards have same vendor ID
      staging: comedi: adl_pci9118: support auto-attachment
      staging: comedi: cb_pcidas64: use auto_attach method
      staging: comedi: cb_pcidas64: fix printks
      staging: comedi: cb_pcidas64: whitespace/brace changes
      staging: comedi: comedidev.h: make comedi_board() parameter const
      staging: comedi: cb_pcidas64: remove board(dev) inline
      staging: comedi: cb_pcidas64: fix forward declarations 1
      staging: comedi: cb_pcidas64: fix forward declarations 2
      staging: comedi: cb_pcidas64: fix forward declarations 3
      staging: comedi: cb_pcidas64: fix forward declararions 4
      staging: comedi: cb_pcidas64: update driver comment
      staging: comedi: addi_apci_1032: check shared interrupt
      staging: comedi: addi_apci_1032: conform to new INSN_CONFIG_DIGITAL_TRIG
      staging: comedi: check data length for INSN_CONFIG_DIGITAL_TRIG
      staging: comedi: define operations for INSN_CONFIG_DIGITAL_TRIG
      staging: comedi: remove old auto-config
      staging: comedi: don't call attach_pci handler
      staging: comedi: don't call attach_usb handler
      staging: comedi: don't check driver->auto_attach
      staging: comedi: simplify comedi_auto_attach()
      staging: comedi: remove attach_pci and attach_usb handlers
      staging: comedi: use inlines for PCI/USB auto config
      staging: comedi: me_daq: remove broken workaround for PLX bug

Jens Taprogge (15):
      Staging: ipack: get rid of ipack_device->bus_nr.
      Staging: ipack: Make ipack_device_register() analogous to device_register().
      Staging: ipack/bridges/tpci200: Don't map memory spaces that are not used later on.
      Staging: ipack/bridges/tpci200: change tpci200_slot->*_phys type.
      Staging: ipack/bridges/tpci200: Store beginning of module memory regions in struct tpci200.
      Staging: ipack/bridges/tpci200: Cleanups.
      Staging: ipack: Provide physical memory regions to IPack devices.
      staging: ipack/devices/ipoctal: fix ipoctal_inst_slot error path.
      staging: ipack/devices/ipoctal: obtain model from dev->id_device.
      staging: ipack: swich to regular ioremap and friends.
      Staging: ipack: remove memory mapping callbacks.
      staging: ipack: Rename IPACK_MEM_SPACE to IPACK_MEM8_SPACE.
      staging: ipack: Add support for IPACK_MEM16_SPACE.
      staging: ipack: Rename bridges to carriers.
      staging: ipack: Documentation cleanups.

Jesper Juhl (2):
      staging: remove version.h include from dgrp/dgrp_sysfs.c
      Staging: silicom: Fix up version.h includes

Johan Meiring (18):
      Staging: ipack: ipack: fix coding style issues
      staging: ipack: tpci200: fixes 80 character line length issue
      staging: wlags49_h2: wl_if.h: fixes macro styling issues
      staging: wlags49_h2: wl_if.h: fixes tab indentation
      staging: wlags49_h2: wl_if.h: fixes spaces-before-tabs issue
      staging: wlags49_h2: wl_if.h: fixes 80 char line length issues
      staging: wlags49_h2: wl_if.h: fixes brace placement
      staging: wlags49_h2: wl_if.h: gets rid of C99 // comments
      staging: wlags49_h2: ap_h2.c: fixes spaces-before-tabs problems
      staging: cxt1e1: musycc.h: fixes indentation issues
      staging: cxt1e1: musycc.h: fixes coding style issues
      staging: cxt1e1: musycc.h: fixes brace placement
      staging: cxt1e1: musycc.c: uses tabs for indentation
      staging: cxt1e1: musycc.c: fixes brace placement
      staging: cxt1e1: musycc.c: fixes placement of parentheses
      staging: cxt1e1: sbecrc.c: fixes indentation issues
      staging: cxt1e1: sbecrc.c: fixes brace placement
      staging: cxt1e1: sbecrc.c: fixes coding style issue

Jonathan Cameron (11):
      staging:iio: Add support for multiple buffers
      staging:iio:in kernel users: Add a data field for channel specific info.
      staging:iio: add a callback buffer for in kernel push interface
      staging:iio:adc:max1363 ring_sw->kfifo conversion
      staging:iio:adc:max1363 consolidate files.
      staging:iio:adc:max1363 drop references to 'ring' given now using a fifo
      staging:iio:adc:max1363 make docs match the contents of max1363_chip_info
      staging:iio:adc:max1363 white space cleanup
      staging:iio:adc:max1363 cleanup regulator handling.
      iio:adc:max1363 move from staging.
      iio:adc:ad7298 make the tx and rx buffers __be16

Jugwan Eom (3):
      Staging: csr: csr_wifi_router_ctrl_sef.c: fix up brace placement
      Staging: csr: csr_wifi_router_ctrl_sef.c: fix tab mess
      Staging: csr: csr_wifi_router_ctrl_sef.c: fix line over 80 characters

Julia Lawall (1):
      drivers/iio/industrialio-event.c: eliminate possible double free

Justin P. Mattock (2):
      staging "xgifb" Fix typos.
      staging: "winbond" Fix typos.

Kees Cook (2):
      drivers/staging/wlags49_h2/man: remove CONFIG_EXPERIMENTAL
      drivers/iio/dac: remove CONFIG_EXPERIMENTAL

Kevin McKinney (103):
      Staging: bcm: Rename all local variables in function GetNextTargetBufferLocation.
      Staging: bcm: Rename INT to int in InterfaceMisc.c
      Staging: bcm: Rename UINT to unsigned int in InterfaceMisc.c
      Staging: bcm: Rename USHORT to unsigned short in InterfaceMisc.c
      Staging: bcm: Rename PVOID to void * in InterfaceMisc.c
      Staging: bcm: Change the style of comparing structures to null in InterfaceMisc.c.
      Staging: bcm: Rename VOID to void in InterfaceMisc.c
      Staging: bcm: Remove unneeded do while loop in InterfaceRDM.
      Staging: bcm: Remove unneeded do while loop in InterfaceWRM.
      Staging: bcm: Remove null dereference from InterfaceRDM.
      Staging: bcm: Remove null dereference from InterfaceWRM.
      Staging: bcm: Rename PVOID to "void *" in Misc.c
      Staging: bcm: Rename VOID to void in Misc.c
      Staging: bcm: Rename PUINT to "unsigned int *" in Misc.c
      Staging: bcm: Rename B_UINT8 to "unsigned char" in Misc.c
      Staging: bcm: Rename B_UINT32 to "unsigned int" in Misc.c
      Staging: bcm: Rename UINT to "unsigned int" in Misc.c
      Staging: bcm: Rename INT to "int" in Misc.c
      Staging: bcm: Clean up function CopyBufferToControlPacket in Misc.c
      Staging: bcm: Reverse condition in if statement in Misc.c
      Staging: bcm: Change B_UINT32 to u32 cntrl_SignalingInterface.h
      Staging: bcm: Change B_UINT16 to u16 in cntrl_SignalingInterface.h
      Staging: bcm: Change B_UINT8 to u8 in cntrl_SignalingInterface.h
      Staging: bcm: Correctly format comments in CmHost.h
      Staging: bcm: Fix all white space issues in CmHost.h
      Staging: bcm: Change B_UINT16 to u16 in CmHost.h
      Staging: bcm: Change B_UINT8 to u8 in CmHost.h
      Staging: bcm: Change INT to int in CmHost.h
      Staging: bcm: Change ULONG to unsigned long in CmHost.h
      Staging: bcm: Change UINT to unsigned int in CmHost.h
      Staging: bcm: Change PVOID to void * in CmHost.h
      Staging: bcm: Remove typedef for stLocalSFChangeIndicationAlt and call directly.
      Staging: bcm: Remove typedef stLocalSFChangeConfirmationAlt.
      Staging: bcm: Remove typedef stLocalSFChangeRequestAlt.
      Staging: bcm: Remove typedef stLocalSFAddConfirmationAlt.
      Staging: bcm: Remove typedef for stLocalSFAddIndicationAlt and call directly.
      Staging: bcm: Remove typedef stLocalSFAddRequestAlt.
      Staging: bcm: Fix all white space issues in InterfaceAdapter.h
      Staging: bcm: Correctly format comments in InterfaceAdapter.h
      Staging: bcm: Correctly format braces in InterfaceAdapter.h
      Staging: bcm: Change PCHAR to char * in InterfaceAdapter.h
      Staging: bcm: Change UCHAR to unsigned char in InterfaceAdapter.h
      Staging: bcm: Change UINT to unsigned int in InterfaceAdapter.h
      Staging: bcm: Change PVOID to void * in InterfaceAdapter.h
      Staging: bcm: Change BOOLEAN to bool in InterfaceAdapter.h
      Staging: bcm: Remove typedef for _S_INTERFACE_ADAPTER and call directly.
      Staging: bcm: Remove typedef for _USB_RCB and call directly.
      Staging: bcm: Remove typedef for _USB_TCB and call directly.
      Staging: bcm: Remove typedef for _INTR_ENDP_OUT and call directly.
      Staging: bcm: Remove typedef for _INTR_ENDP_IN and call directly.
      Staging: bcm: Remove typedef for _BULK_ENDP_OUT and call directly.
      Staging: bcm: Remove typedef for _BULK_ENDP_IN and call directly.
      Staging: bcm: Change ULONG to unsigned long in InterfaceAdapter.h
      Staging: bcm: Add two products and remove an existing product.
      Staging: bcm: Fix all white space issues in Ioctl.h
      Staging: bcm: Properly format and remove comments as needed in Ioctl.h
      Staging: bcm: Properly format braces in Ioctl.h
      Staging: bcm: Replace __attribute__((packed)) with __packed in Ioctl.h
      Staging: bcm: Replace UCHAR with unsigned char in Ioctl.h
      Staging: bcm: Replace ULONG64 with unsigned long long in Ioctl.h
      Staging: bcm: Replace ULONG with unsigned long in Ioctl.h
      Staging: bcm: Replace B_UINT32 with u32 in Ioctl.h
      Staging: bcm: Replace UINT32 with u32 in Ioctl.h
      Staging: bcm: Replace UINT with unsigned int in Ioctl.h
      Staging: bcm: Remove typedef for stGPIOMultiMode and call directly.
      Staging: bcm: Remove typedef for stGPIOMultiInfo and call directly.
      Staging: bcm: Remove typedef for _ST_TIME_ELAPSED_ and call directly.
      Staging: bcm: Remove typedef for _FLASH2X_BITMAP and call directly.
      Staging: bcm: Remove typedef for _SECTION_TYPE.
      Staging: bcm: Remove typedef for _FLASH2X_COPY_SECTION and call directly.
      Staging: bcm: Remove typedef for bulkwrmbuffer and call directly.
      Staging: bcm: Remove typedef for _NVM_READWRITE and call directly.
      Staging: bcm: Remove typedef for _FLASH2X_READWRITE and call directly.
      Staging: bcm: Remove typedef for _DEVICE_DRIVER_INFO and call directly.
      Staging: bcm: Remove typedef for _BCM_INTERFACE_TYPE and reference directly.
      Staging: bcm: Remove typedef for _FLASH2X_SECTION_VAL and reference directly.
      Staging: bcm: Remove typedef for stUserThreadReq and call directly.
      Staging: bcm: Remove typedef for ioctlbuffer and call directly.
      Staging: bcm: Remove typedef for stGPIOInfo and call directly.
      Staging: bcm: Remove typedef for wrmbuffer and call directly.
      Staging: bcm: Remove typedef for rdmbuffer and call directly.
      Staging: bcm: Fix all white space issues in HostMIBSInterface.h
      Staging: bcm: Properly format and remove comments as needed in HostMIBSInterface.h
      Staging: bcm: Properly format braces in HostMIBSInterface.h
      Staging: bcm: Replace UCHAR with unsigned char in HostMIBSInterface.h
      Staging: bcm: Replace ULONG64 with u64 in HostMIBSInterface.h
      Staging: bcm: Replace ULONG with unsigned long in HostMIBSInterface.h
      Staging: bcm: Replace LONG with long in HostMIBSInterface.h
      Staging: bcm: Replace UINT32 with u32 in HostMIBSInterface.h
      Staging: bcm: Replace B_UINT16 with u16 in HostMIBSInterface.h
      Staging: bcm: Replace B_UINT8 with u8 in HostMIBSInterface.h
      Staging: bcm: Replace UINT with unsigned int in HostMIBSInterface.h
      Staging: bcm: Replace USHORT with unsigned short in HostMIBSInterface.h
      Staging: bcm: Replace BOOLEAN with bool in HostMIBSInterface.h
      Staging: bcm: Replace LARGE_INTEGER with u64 in HostMIBSInterface.h
      Staging: bcm: Remove typedef for _S_MIBS_HOST_STATS_MIBS and call directly.
      Staging: bcm: Remove typedef for _S_MIBS_DROPPED_APP_CNTRL_MESSAGES and call directly.
      Staging: bcm: Remove typedef for _S_MIBS_SERVICEFLOW_TABLE and call directly.
      Staging: bcm: Remove typedef for _S_MIBS_EXTSERVICEFLOW_PARAMETERS and call directly.
      Staging: bcm: Remove typedef for _S_MIBS_PHS_RULE and call directly.
      Staging: bcm: Remove typedef for _S_MIBS_CLASSIFIER_RULE and call directly.
      Staging: bcm: Remove typedef for _S_MIBS_HOST_INFO and call directly.
      Staging: bcm: Remove typedef for _U_MIBS_IP_ADDRESS and call directly.

Kirill A. Shutemov (1):
      iio: hid-sensors: convert HID_SENSOR_ENUM_BASE_QUIRKS to bool

Kumar Amit Mehta (7):
      staging: iio: adc: ad7280a.c: fixed macro coding style
      staging: wlan-ng: hfa384x_usb.c: fixed a coding style issue
      staging: comedi: drivers: jr3_pci.c: fix for coding style issue
      staging: tidspbridge: dynload: dload_internal.h: fix for coding style issue
      staging: tidspbridge: dynload: reloc.c: checkpatch.pl cleanup
      staging: rtl8187se: r8180_core.c: Inspect the return value of register_netdev()
      staging: rtl8192e: rtl8192e: rtl_core.c: Audit the return value of register_netdev()

Larry Finger (1):
      staging: r8712u: Fix possible buffer overrun

Lars-Peter Clausen (59):
      staging:iio: Remove unused DRIVER_NAME defines
      staging:iio: Don't compare boolean values with true/false
      staging:iio:lpc32xx_adc: Use resource_size instead of opencoding it
      iio: Don't compare boolean values to true/false
      iio: at91_adc: Use devm_kcalloc to allocate arrays
      iio: Use strict_strtouint instead of kstrtoul
      iio: Add a logarithmic fractional value type
      iio:dac: Add support for the ad5449
      staging:iio: Consolidate adt7310 and adt7410 driver
      iio: Do not accept multiple '.' in fixed point numbers
      iio: Reject trailing garbage when parsing fixed point numbers
      iio: Accept a leading '+' sign when parsing fixed point numbers
      staging:iio:adis16400: Fix adis16334 sampling frequency control
      staging:iio:adis16400: Fix product id check
      staging:iio:adis16400: Remove now duplicated chip_table entry
      staging:iio:adis16400: Set the PROD_ID flag for the adis16334
      staging:iio:ad7887: Preallocate sample buffer
      staging:iio:ad7887: Rework regulator handling
      staging:iio:ad7887: Squash everything into one file
      staging:iio:ad7887: Use proper kernel doc
      staging:iio:ad7887: Allow to use internal ref in two channel mode
      staging:iio:ad7887: Use passed in chan spec in ad7887_read_raw
      staging:iio: Move the ad7887 driver out of staging
      staging:iio:adt7410: Fix adt7410_set_mode return value
      iio: Fix iio_buffer_register stub signature
      staging:iio: Add common ADIS library
      staging:iio:adis16201: Use adis library
      staging:iio:adis16203: Use adis library
      staging:iio:adis16204: Use adis library
      staging:iio:adis16209: Use adis library
      staging:iio:adis16220: Use adis library
      staging:iio:adis16240: Use adis library
      staging:iio:adis16260: Use adis library
      staging:iio:adis_lib: Use triggered buffer setup helper function
      staging:iio:adis: Preallocate transfer message
      staging:iio: Move adis library out of staging
      staging:iio:ad7298: Do not perform endianness conversion in buffered mode
      staging:iio:ad7298: Rework regulator handling
      staging:iio:ad7298: Fix temperature scale and offset
      staging:iio:ad7298: Squash everything into one file
      staging:iio: Move the ad7298 driver out of staging
      iio:imu:adis: Add debugfs register access support
      iio:imu:adis: Add support for 32bit registers
      iio:gyro: Add support for the ADIS16136 gyroscope
      iio:imu:adis: Add paging support
      iio: Add pressure channel type
      iio: Factor out fixed point number parsing into its own function
      iio:imu: Add support for the ADIS16480 and similar IMUs
      staging:iio:ad7793: Fix VDD monitor scale
      staging:iio:ad7793: Fix temperature scale
      staging:iio:ad7793: Use usleep_range instead of msleep
      staging:iio:ad7793: Use kstrtol instead of strict_strtol
      staging:iio:ad7793: Rework platform data
      staging:iio:ad7793: Rework regulator handling
      staging:iio:ad7793: Move register definitions from header to source
      staging:iio:ad7793: Implement stricter id checking
      staging:iio: Move ad7793 driver out of staging
      iio:ad7793: Add support for the ad7798 and ad7799
      iio:ad7793: Add support for the ad7796 and ad7797

Luca Clementi (1):
      Staging: Android: logger: module_exit implementation

MAACHE Mehdi (1):
      Staging: rtl8187se: remove check for IW_ENCODE_DISABLED

Macpaul Lin (2):
      staging/gdm72xx: gdm_wimax: fix compile error when enable debug
      staging/gdm72xx: sdio_boot: replace firmware upgrade API

Malcolm Priestley (36):
      staging: vt6656: [BUG] out of bound array reference in RFbSetPower.
      staging: vt6656: Keep firmware loading local and release firware.
      staging: vt6656: [BUG] PIPEnsSendBulkOut free bBoolInUse
      staging: vt6656: no need to bIndicateReceive when no bytes to read.
      staging: vt6656: free skbuff and relocate on bReAllocSkb == FALSE.
      staging: vt6656: dead code remove upc.h
      staging: vt6656: dead code byCntMeasure/TKIPCounterMeasuresInvoked
      staging: vt6656: nsDMA_tx_packet: free tx context bBoolInUse
      staging: vt6656: fix viawget_wpa_param size
      staging: vt6656: 64 bit- Correctly address void structure.
      staging: vt6656: 64bit fixes: dpc.c incorrect addressing of void structure.
      staging: vt6656: 64bit fixes: desh.h fix size. replace DWORD with u32.
      staging: vt6656: 64 bit fixes: RXbBulkInProcessData Framesize
      staging: vt6656: 64 bit fixes: use u32 for QWORD definition.
      staging: vt6656: 64 bit fixes: rxtx.h Replace DWORD with u32.
      staging: vt6656: 64 bit fixes: int.h replaced DWORD with u32
      staging: vt6656: 64 bit fixes : correct all type sizes
      staging: vt6656: 64 bit fixes: fix long warning messages.
      staging: vt6656: 64bit fixes: key.c/h change unsigned long to u32
      staging: vt6656: 64 bit fixes pdwIV is now u32
      staging: vt6656: 64 bit fixes TKIPvMixKey remove unsigned long
      staging: vt6656: 64 bit fixes correct sizes of NDIS_802_11_ASSOCIATION_INFORMATION
      staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.
      staging: vt6656: Remove WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT macro
      staging: vt6656: iwctl_giwaplist/device_ioctl : use off stack buffers.
      staging: vt6656: iwctl_giwaplist() re warn: possible memory leak of 'qual'
      staging: vt6656: fix headers and add cfg80211.
      staging: vt6656: move move all commands to iw_handler.
      staging: vt6656: remove wpahdr from driver.
      staging: vt6656: dead code removal : wpactl.c/h
      staging: vt6656: dead code remove ioctl.c/h
      staging: vt6656: cleanup of device_ioctl/net_device_stats
      staging: vt6656: remove redundant IWEVCUSTOM events.
      staging: vt6656: extend wireless definitions to v22
      staging: vt6656: send SIOCGIWSCAN at end of all scanning events.
      staging: vt6656: wpa_set_keys remove fcpfkernel

Marc Dietrich (1):
      staging: nvec: let nvec select MFD_CORE

Mark Einon (22):
      staging: et131x: Use skb_headlen() where appropriate
      staging: et131x: Fix 64bit tx dma address handling
      staging: et131x: Remove fbr_lookup.real_physaddr
      staging: et131x: Use upper_32_bits() instead of '>> 32'
      staging: et131x: Remove USE_FBR0 define and #ifdefs
      staging: et131x: Fix i386 build warnings from use of dma_addr_t
      staging: et131x: Remove duplicate code for fbr[0, 1]
      staging: et131x: Refactor nic_rx_pkts() to remove indenting
      staging: et131x: Update TODO list in README
      staging: et131x: Remove unnecessary NULL pointer assignments
      staging: et131x: Remove unnecessary PHY register write
      staging: et131x: Add ethtool printout to match MII regs
      staging: et131x: Remove unused buffer[1,2] variables.
      staging: et131x: Align ring_index and fbr[] indicies
      staging: et131x: Avoid unnecessary calculations in for loop
      staging: et131x: Remove unnecessary DMA address alignment code
      staging: et131x: Refactor et131x_isr() to remove indenting
      staging: et131x: Remove alignment offset padding on DMA buffer allocation/free
      staging: et131x: Reduce indenting in et131x_rx_dma_memory_free()
      staging: et131x: Remove incorrect comments regarding alignment
      staging: et131x: Replace kmem_cache use with plain kmalloc/kfree
      staging: et131x: Removing final checkpatch errors, all line >80 chars

Masanari Iida (2):
      staging : csr: Fix typo in csr/netdev.c
      staging: ced1401: Fix typo in staging/ced1401

Matt Phillips (1):
      staging: comedi: ni_tio.h fixed coding style issue with pointer variables

Maxim Mikityanskiy (17):
      staging: rtl8187se: Removed dead functions
      staging: rtl8187se: Removed legacy rtl8225_rf_set_chan()
      staging: rtl8187se: Removed empty functions and one-iteration loop
      staging: rtl8187se: Fixed bugs in interrupt handler
      staging: rtl8187se: Simplified function GetSupportedWirelessMode8185()
      staging: rtl8187se: Fixed oops when rmmoding
      staging: rtl8187se: Removed unused module parameters and fixed module description
      staging: rtl8187se: Removed dead code
      staging: rtl8187se: Removed unused parameters of HwHSSIThreeWire()
      staging: rtl8187se: Fixed typo in TransmitConfig
      staging: rtl8187se: Removed non-existent function headers from r8180.h
      staging: rtl8187se: Removed unused arrays in r8180_rtl8225z2.c
      staging: rtl8187se: Use ARRAY_SIZE instead of in-code constants
      staging: rtl8187se: Removed unneeded reads from EEPROM
      staging: rtl8187se: Removed unused fields in r8180_priv
      staging: rtl8187se: Removed empty stub read_acadapter_file()
      staging: rtl8187se: Fixed size of BEACON_INTERVAL register

Michael Olbrich (1):
      staging: drm/imx: Fix YUYV support in i.MX IPUv3 base driver

Minchan Kim (1):
      staging: zram: correct obsolete comment on max_zpage_size

Peter Huewe (2):
      staging/rtl8192e: Fix compile warning 'is static but declared in .. which is not static'
      staging/rtl8187se: Fix compile warning 'is static but declared in .. which is not static'

Peter Hurley (2):
      staging: fwserial: Add TTY-over-Firewire serial driver
      staging/fwserial: Fix build breakage when !CONFIG_BUG

Peter Meerwald (5):
      iio: remove useless irq_enabled variable in at91
      iio: use iio_push_to_buffer() in at91 driver
      iio: fix spelling of Accelerometer in Kconfig
      staging iio: use iio_trigger_generic_data_rdy_poll() in accel/adis16209,adis16240 driver
      staging iio: consistent commas in adis16400 channel spec

Peter Senna Tschudin (1):
      drivers/staging/iio: Remove unnecessary semicolon

Philipp Zabel (4):
      staging: drm/imx: Add YVU420 support to i.MX IPUv3 base driver
      staging: drm/imx: silence ipu_crtc_dpms debug message
      staging: drm/imx: Add ipu_cpmem_set_yuv_interleaved()
      staging: drm/imx: Remove 300ms delay after memory reset

Pranav Ravichandran (1):
      Staging: sbe-2t3e3: fix coding style issues in netdev.c

Radhesh Fadnis (1):
      staging: omap-thermal: fix context restore function

Rob Clark (5):
      drm/omap: fix issue w/ fb attached to multiple CRTCs
      staging: drm/omap: only advertise rotation prop if supported
      staging: drm/omap: remove global drm_device ptr
      staging: drm/omap: add support for ARCH_MULTIPLATFORM
      staging: drm/imx: add support for ARCH_MULTIPLATFORM

Roger Tseng (1):
      staging: rts5139: fixed issues when config to built-in object

Sachin Kamat (5):
      staging: ozwpan: Include oz_events_clear() conditionally
      staging: ozwpan: Remove redundant null check before kfree in ozpd.c
      staging: ozwpan: Remove redundant null check before kfree in ozproto.c
      staging: ozwpan: Remove redundant null check before kfree in ozhcd.c
      staging: drm/imx: Remove duplicate inclusion of linux/videodev2.h

Samuel Iglesias Gonsalvez (7):
      Staging: ipack: remove blank line at EOF warning in Kconfig files
      Staging: ipack: fix wrong return value.
      Staging: ipack/carriers: fix missing include linux/slab.h
      Staging: ipack: adapt copyright to CERN guidelines
      MAINTAINERS: Add maintainers for Industry Pack subsystem
      ipack: move header files to include/linux
      ipack: remove ipack_ids.h file

Sangho Yi (10):
      Staging: CSR: csr_time.h: fixed indentation warnings based on coding style
      Staging: CSR: csr_time.h: Removed unnecessary typedef struct
      Drivers: Staging: CSR: fixed coding style errors in csr_wifi_router_free_upstream_contents.c
      staging: csr: csr_wifi_sme_task.h: fixed indentation coding style
      staging: csr: csr_wifi_sme_serialize.h: Fixed from foo* bar to foo *bar
      staging: csr: csr_wifi_sme_serialize.h: fixed over 80 char lines
      staging: csr: csr_wifi_sme_sef.h: Fixed from foo* bar to foo *bar
      staging: csr: csr_wifi_sme_sef.h: Fixed lines over 80 chars per line
      staging: csr: csr_wifi_sme_serialize.h: fixed indentation warnings
      staging: csr: csr_wifi_sme_sef.h: fixed indentation warnings

Sascha Hauer (1):
      staging: drm/imx: Add pinctrl support to parallel display driver

SeongJae Park (5):
      staging: csr: csr_framework_ext_types.h: fix coding style
      staging: csr: Remove struct CsrThread
      staging: csr: Remove CsrThreadHandle
      staging: csr: csr_log.h: Fix coding style
      staging: csr: Remove struct CsrEvent

Sergey Senozhatsky (2):
      staging: zram: factor-out zram_decompress_page() function
      staging: zram: handle mem suffixes in disk size zram_sysfs parameter

Shan Wei (1):
      staging: gdm72xx: use %pI4 format to print IPv4 address and remove last usage of NIP6

Stefan Hajnoczi (65):
      staging: line6: drop unused line6_devices[] array
      staging: line6: drop unused line6_index and line6_id arrays
      staging: line6: wrap >80 char lines in capture.c
      staging: line6: fix quoted string across lines in midibuf.c
      staging: line6: shorten comment below 80 chars in pcm.c
      staging: line6: drop trailing whitespace in pcm.h
      staging: line6: wrap lines to 80 chars in playback.c
      staging: line6: replace deprecated strict_strtol() in toneport.c
      staging: line6: wrap lines to 80 chars in usbdefs.h
      staging: line6: wrap comment to 80 chars in variax.c
      staging: line6: replace DEBUG_MESSAGES() with dev_dbg()
      staging: line6: drop unused DEBUG_MESSAGES() macro
      staging: line6: drop unused CONFIG_LINE6_USB_DEBUG
      staging: line6: drop control URB dumping code
      staging: line6: drop CONTROL from CONFIG_LINE6_USB_DUMP_ANY
      staging: line6: drop unused CONFIG_LINE6_USB_DUMP_CTRL
      staging: line6: drop MIDI dumping code
      staging: line6: drop MIDI from CONFIG_LINE6_USB_DUMP_ANY
      staging: line6: drop unused CONFIG_LINE6_USB_DUMP_MIDI
      staging: line6: drop channel sysfs attr
      staging: line6: drop clip sysfs attr
      staging: line6: drop unused param_dirty bitmap
      staging: line6: drop dirty sysfs attr
      staging: line6: drop dump sysfs attr
      staging: line6: drop dump_buf sysfs attr
      staging: line6: drop monitor_level sysfs attr
      staging: line6: change monitor_level type ValueWait -> int
      staging: line6: drop name sysfs attr
      staging: line6: drop name_buf sysfs attr
      staging: line6: drop retrieve_amp_setup sysfs attr
      staging: line6: drop retrieve_channel sysfs attr
      staging: line6: drop retrieve_effects_setup sysfs attr
      staging: line6: drop store_amp_setup sysfs attr
      staging: line6: drop store_channel sysfs attr
      staging: line6: drop store_effects_setup sysfs attr
      staging: line6: drop routing sysfs attr
      staging: line6: drop tuner_freq sysfs attr
      staging: line6: drop tuner_note sysfs attr
      staging: line6: drop tuner_mute sysfs attr
      staging: line6: drop tuner_pitch sysfs attr
      staging: line6: drop finish sysfs attr
      staging: line6: drop midi_postprocess sysfs attr
      staging: line6: drop midi_mask_receive
      staging: line6: drop midi_mask_transmit
      staging: line6: drop midi_postprocess flag
      staging: line6: drop pod.c raw sysfs attr
      staging: line6: drop tuner param filtering
      staging: line6: drop variax model sysfs attr
      staging: line6: drop variax volume sysfs attr
      staging: line6: drop variax tone sysfs attr
      staging: line6: drop variax name sysfs attr
      staging: line6: drop variax bank sysfs attr
      staging: line6: drop variax dump sysfs attr
      staging: line6: drop variax active sysfs attr
      staging: line6: drop variax guitar sysfs attr
      staging: line6: drop variax raw sysfs attrs
      staging: line6: drop CONFIG_LINE6_USB_RAW
      staging: line6: drop amp/effects dump request triggers
      staging: line6: drop MIDI parameter sysfs attrs
      staging: line6: drop pod prog_data buffers
      staging: line6: drop unused pod atomic_flags field
      staging: line6: drop variax model_data field
      staging: line6: drop dump requests from variax startup
      staging: line6: drop dump requests from pod startup
      staging: line6: drop unused dumprequest code

Sunhee Hwang (2):
      Staging: csr: fix pointer(asterisk) position coding style issue in sme_userspace.h
      Staging: csr: fix code indent coding style issues in csr_wifi_hip_signals.h

Thierry Reding (1):
      iio: adc: Add Texas Instruments ADC081C021/027 support

Wei Yongjun (18):
      Staging: ipack/bridges/tpci200: use module_pci_driver to simplify the code
      Staging: vt6655: fix missing unlock on error in vCommandTimer()
      Staging: ced1401: fix missing unlock on error in FreeCircBlock()
      staging: r8712u: fix potential NULL pointer dereference in r871x_wps_start()
      staging: ste_rmi4: use module_i2c_driver to simplify the code
      staging: csr: remove unused including <linux/version.h>
      vme: vme_vmivme7805.c: use module_pci_driver to simplify the code
      vme: vme_ca91cx42.c: use module_pci_driver to simplify the code
      vme: vme_tsi148.c: use module_pci_driver to simplify the code
      staging: ced1401: usb1401: remove unused including <linux/version.h>
      staging: comedi: use module_comedi_driver to simplify the code
      staging: comedi: skel: use module_comedi_driver to simplify the code
      Staging: silicom: remove unused including <linux/version.h>
      Staging: silicom: bypasslib: remove unused including <linux/version.h>
      staging: comedi: usbduxfast: remove unused variable in usbduxfastsub_ai_Irq()
      iio: isl29018: fix to return error or 0 in isl29018_write_raw()
      iio: gyro: adis16136: remove duplicated include from adis16136.c
      iio: imu: adis16480: remove duplicated include from adis16480.c

Xiaotian Feng (1):
      staging: ozwpan: use tasklet_kill in device remove/release process

YAMANE Toshiaki (94):
      staging/sbe-2t3e3: Use netdev_ printks in cpld.c
      staging/comedi: Use dev_ printks in kcomedilib/kcomedilib_main.c
      staging/comedi: Use dev_ printks in drivers/me_daq.c
      staging/comedi: Use dev_ printks in drivers/adl_pci8164.c
      staging/comedi: Use dev_ printks in drivers/quatech_daqp_cs.c
      staging/comedi: Use dev_ printks in rtd520.c
      staging/comedi: Use dev_ printks in drivers/usbdux.c
      staging/comedi: Use dev_ printks in drivers/ni_daq_dio24.c
      staging/comedi: Use dev_ printks in drivers/ni_pcimio.c
      staging/comedi: Use dev_ printks in drivers/ii_pci20kc.c
      staging/comedi: Use pr_ or dev_ printks in drivers/dt9812.c
      staging/sbe-2t3e3: Use netdev_ printks in main.c
      staging/sbe-2t3e3: Use netdev_ or dev_ or pr_ printks in module.c
      staging/comedi: Use dev_ printks in drivers/vmk80xx.c
      staging/comedi: Use pr_ or dev_ printks in drivers/usbduxfast.c
      staging/comedi: Use pr_ or dev_ printks in drivers/unioxx5.c
      staging/comedi: Use pr_ or dev_ printks in drivers/serial2002.c
      staging/comedi: Use pr_ or dev_ printks in drivers/gsc_hpdi.c
      staging:comedi: Use pr_ or dev_ printks in drivers/usbduxfaxt.c
      staging/comedi: Fix trailing statements should be on next line in drivers/quatech_daqp_cs.c
      staging/comedi: Use dev_ printks in drivers/quatech_daqp_cs.c
      staging/gdm72xx: Use netdev_ or pr_ printks in gdm_wimax.c
      staging/gdm72xx: Use netdev_ or pr_ printks in gdm_qos.c
      staging/gdm72xx: Use netdev_ or pr_ printks in netlink_k.c
      staging/gdm72xx: Use dev_ printks in gdm_sdio.c
      staging/gdm72xx: Use dev_ printks in sdio_boot.c
      staging/gdm72xx: Use dev_ printks in gdm_usb.c
      staging/gdm72xx: Use dev_ printks in usb_boot.c
      staging/comedi: fix the spaces issue at the start of line in drivers/ni_mio_cs.c
      staging/comedi: fix the initialize statics issue in drivers/ni_mio_cs.c
      staging/comedi: Use dev_ printks in drivers/ni_mio_cs.c
      staging/comedi: Use dev_ printks in ni_tiocmd.c
      staging/comedi: fix the spaces issue around that '=' in drivers/ni_670x.c
      staging/comedi: Use dev_ printks in drivers/comedi_fc.c
      staging/vme: Use dev_ or pr_ printks in devices/vme_user.c
      staging/serqt_usb2: fixed line over issue in serqt_usb2.c
      staging/serqt_usb2: refactor qt_read_bulk_callback() in serqt_usb2.c
      staging/serqt_usb2: refactor qt_open() in serqt_usb2.c
      staging/serqt_usb2: refactor qt_unthrottle() in serqt_usb2.c
      staging/omapdrm: Fix spacing coding style in omap_connector.c
      staging/omapdrm: remove the unnecessary initialization of a local variable in omap_crtc.c
      staging/omapdrm: Fix spacing coding style in omap_crtc.c
      staging/omapdrm: Fix spacing coding style in omap_drv.c
      staging/omapdrm: Fix spacing coding style in omap_drv.h
      staging/omapdrm: Fix spacing coding style in omap_drv.h
      staging/omapdrm: Fix spacing coding style in omap_encoder.c
      staging/omapdrm: Fix spacing coding style in omap_fb.c
      staging/omapdrm: Fix spacing coding style in omap_gem.c
      staging/omapdrm: Fix spacing coding style in omap_gem.c
      staging/omapdrm: Fix spacing coding style in omap_gem.c
      staging/omapdrm: Fix spacing coding style in omap_gem_dmabuf.c
      staging/omapdrm: Fix spacing coding style in omap_gem_helper.c
      staging/omapdrm: Fix spacing coding style in omap_gem_helper.c
      staging/omapdrm: Fix spacing coding style in omap_plane.c
      staging/omapdrm: Fix spacing coding style in omap_plane.c
      staging/serqt_usb2: Refactor qt_status_change_check() in serqt_usb2.c
      staging/rtl8187se: Fix spacing coding style in r8180_dm.h
      staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_crypt.c
      staging/rtl8187se: Use pr_ printks in ieee80211/ieee80211_crypt.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt.h
      staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_module.c
      staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_module.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_module.c
      staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_crypt_ccmp.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_ccmp.c
      staging/rtl8187se: Use pr_ printks in ieee80211/ieee80211_crypt_ccmp.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_ccmp.c
      staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_crypt_wep.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_wep.c
      staging/rtl8187se: Use pr_ printks in ieee80211/ieee80211_crypt_wep.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_crypt_wep.c
      staging/rtl8187se: Use netdev_ printks in r8185b_init.c
      staging/rtl8187se: Fix spacing coding style in r8185b_init.c
      staging/rtl8187se: Remove the unnecessary initialization of a local variable in r8180_core.c
      staging/rtl8187se: Remove an unnecessary line continuation in r8180_core.c
      staging/rtl8187se: Fix spacing coding style in r8180_core.c
      staging/rtl8187se: Use dev_ or pr_ printks in r8180_core.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_softmac_wx.c
      staging/rtl8187se: Fix include file issue in ieee80211/ieee80211_rx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
      staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_rx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c
      staging/rtl8187se: Fix spacing coding style in ieee80211/ieee80211_rx.c

Yuanhan Liu (2):
      staging: dgrp: fix potential NULL defereference issue
      staging: comedi: jr3_pci: return 'result' from comedi_pci_enable instead of -EIO

 Documentation/ABI/testing/sysfs-bus-iio                       |    24 +
 Documentation/telephony/00-INDEX                              |     4 -
 Documentation/telephony/ixj.txt                               |   394 ---
 MAINTAINERS                                                   |     9 +
 arch/arm/mach-omap2/board-overo.c                             |     1 -
 arch/arm/mach-omap2/drm.c                                     |     7 +
 drivers/Kconfig                                               |     2 +
 drivers/Makefile                                              |     1 +
 drivers/iio/Kconfig                                           |    13 +-
 drivers/iio/Makefile                                          |     8 +-
 drivers/iio/accel/Kconfig                                     |     2 +-
 drivers/iio/accel/hid-sensor-accel-3d.c                       |    21 +-
 drivers/iio/adc/Kconfig                                       |    65 +
 drivers/iio/adc/Makefile                                      |     6 +
 drivers/iio/adc/ad7266.c                                      |     3 +-
 drivers/{staging/iio/adc/ad7298_core.c => iio/adc/ad7298.c}   |   201 +-
 drivers/iio/adc/ad7476.c                                      |     2 +-
 drivers/{staging => }/iio/adc/ad7793.c                        |   390 ++-
 drivers/{staging/iio/adc/ad7887_core.c => iio/adc/ad7887.c}   |   217 +-
 drivers/iio/adc/ad_sigma_delta.c                              |     2 +-
 drivers/iio/adc/at91_adc.c                                    |     6 +-
 drivers/{staging/iio/adc/max1363_core.c => iio/adc/max1363.c} |   330 ++-
 drivers/iio/adc/ti-adc081c.c                                  |   161 ++
 drivers/iio/buffer_cb.c                                       |   113 +
 drivers/iio/common/hid-sensors/Kconfig                        |     2 +-
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c           |     6 +-
 drivers/iio/dac/Kconfig                                       |    12 +-
 drivers/iio/dac/Makefile                                      |     1 +
 drivers/iio/dac/ad5449.c                                      |   376 +++
 drivers/iio/dac/ad5686.c                                      |     2 +-
 drivers/iio/gyro/Kconfig                                      |     9 +
 drivers/iio/gyro/Makefile                                     |     1 +
 drivers/iio/gyro/adis16136.c                                  |   580 +++++
 drivers/iio/gyro/hid-sensor-gyro-3d.c                         |    21 +-
 drivers/iio/imu/Kconfig                                       |    27 +
 drivers/iio/imu/Makefile                                      |    10 +
 drivers/iio/imu/adis.c                                        |   440 ++++
 drivers/iio/imu/adis16480.c                                   |   924 +++++++
 drivers/iio/imu/adis_buffer.c                                 |   176 ++
 drivers/iio/imu/adis_trigger.c                                |    89 +
 drivers/iio/industrialio-buffer.c                             |   386 ++-
 drivers/iio/industrialio-core.c                               |   105 +-
 drivers/iio/industrialio-event.c                              |    11 +-
 drivers/iio/inkern.c                                          |     6 +-
 drivers/iio/light/adjd_s311.c                                 |     3 +-
 drivers/iio/light/hid-sensor-als.c                            |    20 +-
 drivers/iio/magnetometer/hid-sensor-magn-3d.c                 |    21 +-
 drivers/ipack/Kconfig                                         |    24 +
 drivers/{staging => }/ipack/Makefile                          |     2 +-
 drivers/ipack/carriers/Kconfig                                |     7 +
 drivers/{staging/ipack/bridges => ipack/carriers}/Makefile    |     0
 drivers/{staging/ipack/bridges => ipack/carriers}/tpci200.c   |   321 +--
 drivers/{staging/ipack/bridges => ipack/carriers}/tpci200.h   |    33 +-
 drivers/{staging => }/ipack/devices/Kconfig                   |     1 -
 drivers/{staging => }/ipack/devices/Makefile                  |     0
 drivers/{staging => }/ipack/devices/ipoctal.c                 |   127 +-
 drivers/{staging => }/ipack/devices/ipoctal.h                 |     7 +-
 drivers/{staging => }/ipack/devices/scc2698.h                 |     7 +-
 drivers/{staging => }/ipack/ipack.c                           |    64 +-
 drivers/staging/Kconfig                                       |     8 +-
 drivers/staging/Makefile                                      |     4 +-
 drivers/staging/android/Makefile                              |     2 +
 drivers/staging/android/binder.c                              |   471 ++--
 drivers/staging/android/binder_trace.h                        |   327 +++
 drivers/staging/android/logger.c                              |    21 +
 drivers/staging/bcm/Adapter.h                                 |     8 +-
 drivers/staging/bcm/Bcmchar.c                                 |   149 +-
 drivers/staging/bcm/Bcmnet.c                                  |     6 +-
 drivers/staging/bcm/CmHost.c                                  |    90 +-
 drivers/staging/bcm/CmHost.h                                  |   189 +-
 drivers/staging/bcm/HandleControlPacket.c                     |     2 +-
 drivers/staging/bcm/HostMIBSInterface.h                       |   384 ++-
 drivers/staging/bcm/InterfaceAdapter.h                        |   142 +-
 drivers/staging/bcm/InterfaceDld.c                            |     4 +-
 drivers/staging/bcm/InterfaceIdleMode.c                       |     2 +-
 drivers/staging/bcm/InterfaceIdleMode.h                       |     5 +-
 drivers/staging/bcm/InterfaceInit.c                           |    25 +-
 drivers/staging/bcm/InterfaceInit.h                           |     4 +-
 drivers/staging/bcm/InterfaceIsr.c                            |     6 +-
 drivers/staging/bcm/InterfaceIsr.h                            |     4 +-
 drivers/staging/bcm/InterfaceMisc.c                           |   124 +-
 drivers/staging/bcm/InterfaceMisc.h                           |     6 +-
 drivers/staging/bcm/InterfaceRx.c                             |    16 +-
 drivers/staging/bcm/InterfaceRx.h                             |     2 +-
 drivers/staging/bcm/InterfaceTx.c                             |    14 +-
 drivers/staging/bcm/Ioctl.h                                   |   482 ++--
 drivers/staging/bcm/LeakyBucket.c                             |     6 +-
 drivers/staging/bcm/Misc.c                                    |   236 +-
 drivers/staging/bcm/Prototypes.h                              |    36 +-
 drivers/staging/bcm/Transmit.c                                |     2 +-
 drivers/staging/bcm/cntrl_SignalingInterface.h                |   256 +-
 drivers/staging/bcm/hostmibs.c                                |    12 +-
 drivers/staging/bcm/nvm.c                                     |    94 +-
 drivers/staging/bcm/vendorspecificextn.c                      |     6 +-
 drivers/staging/bcm/vendorspecificextn.h                      |     6 +-
 drivers/staging/ccg/ccg.c                                     |     8 +-
 drivers/staging/ced1401/ced_ioc.c                             |    37 +-
 drivers/staging/ced1401/usb1401.c                             |    36 +-
 drivers/staging/ced1401/usb1401.h                             |     2 +-
 drivers/staging/ced1401/userspace/use1401.c                   |     8 +-
 drivers/staging/comedi/Kconfig                                |    45 +-
 drivers/staging/comedi/comedi.h                               |    65 +-
 drivers/staging/comedi/comedi_compat32.c                      |     1 -
 drivers/staging/comedi/comedi_fops.c                          |     5 +-
 drivers/staging/comedi/comedidev.h                            |    70 +-
 drivers/staging/comedi/drivers.c                              |   144 +-
 drivers/staging/comedi/drivers/8255.c                         |    27 +-
 drivers/staging/comedi/drivers/8255_pci.c                     |    26 +-
 drivers/staging/comedi/drivers/Makefile                       |     2 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c     |   205 +-
 drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h     |    73 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c    |   245 +-
 drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.h    |    74 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c    |    44 +-
 drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h    |    46 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c    |   886 ++++---
 drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h    |   271 --
 drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c   |    39 +-
 drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h   |    47 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c       |   278 ++-
 drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h       |    76 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c       |    41 +-
 drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h       |    43 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c       |    50 +-
 drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h       |    57 -
 drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c       |    38 +-
 drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h       |    44 -
 drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h    |   469 ----
 drivers/staging/comedi/drivers/addi-data/addi_common.c        |  2036 ++-------------
 drivers/staging/comedi/drivers/addi-data/addi_common.h        |    32 -
 drivers/staging/comedi/drivers/addi-data/addi_eeprom.c        |  1367 +++-------
 drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c     |    69 +-
 drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h     |    71 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c      |   116 +-
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h      |   109 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c     |   287 ---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h     |    64 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c     |   197 +-
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h     |   165 --
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c     |   542 ----
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h     |    65 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c     |   469 +---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h     |   121 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c     |    57 +-
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.h     |    79 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c     |   460 ----
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h     |    72 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c     |   579 -----
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h     |    83 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c     |   392 +--
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h     |    61 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c     |  1768 ++++++-------
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h     |   249 --
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c     |  3417 +++++++++++--------------
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h     |   191 --
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c     |   320 +--
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h     |    98 -
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c     |   414 +---
 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h     |    48 -
 drivers/staging/comedi/drivers/addi_apci_035.c                |    72 +-
 drivers/staging/comedi/drivers/addi_apci_1032.c               |   396 ++-
 drivers/staging/comedi/drivers/addi_apci_1500.c               |    72 +-
 drivers/staging/comedi/drivers/addi_apci_1516.c               |   348 ++-
 drivers/staging/comedi/drivers/addi_apci_1564.c               |    69 +-
 drivers/staging/comedi/drivers/addi_apci_16xx.c               |    72 +-
 drivers/staging/comedi/drivers/addi_apci_1710.c               |   153 +-
 drivers/staging/comedi/drivers/addi_apci_2016.c               |     9 -
 drivers/staging/comedi/drivers/addi_apci_2032.c               |   381 ++-
 drivers/staging/comedi/drivers/addi_apci_2200.c               |    64 +-
 drivers/staging/comedi/drivers/addi_apci_3001.c               |     9 -
 drivers/staging/comedi/drivers/addi_apci_3120.c               |   273 +-
 drivers/staging/comedi/drivers/addi_apci_3200.c               |   119 +-
 drivers/staging/comedi/drivers/addi_apci_3300.c               |     5 -
 drivers/staging/comedi/drivers/addi_apci_3501.c               |    70 +-
 drivers/staging/comedi/drivers/addi_apci_3xxx.c               |   794 +++++-
 drivers/staging/comedi/drivers/adl_pci6208.c                  |    23 +-
 drivers/staging/comedi/drivers/adl_pci7x3x.c                  |    15 +-
 drivers/staging/comedi/drivers/adl_pci8164.c                  |    27 +-
 drivers/staging/comedi/drivers/adl_pci9111.c                  |    81 +-
 drivers/staging/comedi/drivers/adl_pci9118.c                  |   494 ++--
 drivers/staging/comedi/drivers/adq12b.c                       |    46 +-
 drivers/staging/comedi/drivers/adv_pci1710.c                  |    73 +-
 drivers/staging/comedi/drivers/adv_pci1723.c                  |    24 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c                  |    25 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c                  |     8 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c                  |    19 +-
 drivers/staging/comedi/drivers/amplc_dio200.c                 |  1468 +++++++----
 drivers/staging/comedi/drivers/amplc_pc236.c                  |    72 +-
 drivers/staging/comedi/drivers/amplc_pc263.c                  |    23 +-
 drivers/staging/comedi/drivers/amplc_pci224.c                 |    93 +-
 drivers/staging/comedi/drivers/amplc_pci230.c                 |   157 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c                  |    69 +-
 drivers/staging/comedi/drivers/cb_pcidas.c                    |   106 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c                  |  3041 ++++++++++++-----------
 drivers/staging/comedi/drivers/cb_pcidda.c                    |   681 ++---
 drivers/staging/comedi/drivers/cb_pcimdas.c                   |   121 +-
 drivers/staging/comedi/drivers/cb_pcimdda.c                   |    25 +-
 drivers/staging/comedi/drivers/comedi_bond.c                  |     8 +-
 drivers/staging/comedi/drivers/comedi_fc.c                    |     2 +-
 drivers/staging/comedi/drivers/comedi_fc.h                    |    44 +
 drivers/staging/comedi/drivers/comedi_parport.c               |    35 +-
 drivers/staging/comedi/drivers/comedi_test.c                  |    71 +-
 drivers/staging/comedi/drivers/contec_pci_dio.c               |    15 +-
 drivers/staging/comedi/drivers/daqboard2000.c                 |    23 +-
 drivers/staging/comedi/drivers/das08.c                        |    39 +-
 drivers/staging/comedi/drivers/das08_cs.c                     |     9 +-
 drivers/staging/comedi/drivers/das16.c                        |    78 +-
 drivers/staging/comedi/drivers/das16m1.c                      |    80 +-
 drivers/staging/comedi/drivers/das1800.c                      |    66 +-
 drivers/staging/comedi/drivers/das6402.c                      |    16 +-
 drivers/staging/comedi/drivers/das800.c                       |    79 +-
 drivers/staging/comedi/drivers/dmm32at.c                      |    80 +-
 drivers/staging/comedi/drivers/dt2801.c                       |    14 +-
 drivers/staging/comedi/drivers/dt2811.c                       |    13 +-
 drivers/staging/comedi/drivers/dt2814.c                       |    54 +-
 drivers/staging/comedi/drivers/dt2815.c                       |     9 +-
 drivers/staging/comedi/drivers/dt282x.c                       |   115 +-
 drivers/staging/comedi/drivers/dt3000.c                       |   620 +++--
 drivers/staging/comedi/drivers/dt9812.c                       |    27 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c                 |    27 +-
 drivers/staging/comedi/drivers/fl512.c                        |    10 +-
 drivers/staging/comedi/drivers/gsc_hpdi.c                     |   515 ++--
 drivers/staging/comedi/drivers/icp_multi.c                    |    22 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c                   |    51 +-
 drivers/staging/comedi/drivers/jr3_pci.c                      |   658 ++---
 drivers/staging/comedi/drivers/jr3_pci.h                      |    12 +-
 drivers/staging/comedi/drivers/ke_counter.c                   |    60 +-
 drivers/staging/comedi/drivers/me4000.c                       |    42 +-
 drivers/staging/comedi/drivers/me_daq.c                       |   595 ++---
 drivers/staging/comedi/drivers/mpc624.c                       |    10 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c                   |   164 --
 drivers/staging/comedi/drivers/multiq3.c                      |    11 +-
 drivers/staging/comedi/drivers/ni_6527.c                      |    64 +-
 drivers/staging/comedi/drivers/ni_65xx.c                      |   164 +-
 drivers/staging/comedi/drivers/ni_660x.c                      |   586 +++--
 drivers/staging/comedi/drivers/ni_670x.c                      |    24 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c                  |    64 +-
 drivers/staging/comedi/drivers/ni_at_ao.c                     |    13 +-
 drivers/staging/comedi/drivers/ni_atmio.c                     |    11 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c                  |    58 +-
 drivers/staging/comedi/drivers/ni_daq_dio24.c                 |    14 +-
 drivers/staging/comedi/drivers/ni_labpc.c                     |   114 +-
 drivers/staging/comedi/drivers/ni_labpc_cs.c                  |     6 +-
 drivers/staging/comedi/drivers/ni_mio_common.c                |   336 +--
 drivers/staging/comedi/drivers/ni_mio_cs.c                    |    29 +-
 drivers/staging/comedi/drivers/ni_pcidio.c                    |    85 +-
 drivers/staging/comedi/drivers/ni_pcimio.c                    |    62 +-
 drivers/staging/comedi/drivers/ni_tio.h                       |     4 +-
 drivers/staging/comedi/drivers/ni_tiocmd.c                    |    60 +-
 drivers/staging/comedi/drivers/pcl711.c                       |    51 +-
 drivers/staging/comedi/drivers/pcl726.c                       |    10 +-
 drivers/staging/comedi/drivers/pcl812.c                       |    85 +-
 drivers/staging/comedi/drivers/pcl816.c                       |    71 +-
 drivers/staging/comedi/drivers/pcl818.c                       |    80 +-
 drivers/staging/comedi/drivers/pcm3724.c                      |    44 +-
 drivers/staging/comedi/drivers/pcm_common.c                   |    34 +-
 drivers/staging/comedi/drivers/pcmad.c                        |    10 +-
 drivers/staging/comedi/drivers/pcmda12.c                      |    34 +-
 drivers/staging/comedi/drivers/pcmmio.c                       |   124 +-
 drivers/staging/comedi/drivers/pcmuio.c                       |    25 +-
 drivers/staging/comedi/drivers/poc.c                          |    15 +-
 drivers/staging/comedi/drivers/quatech_daqp_cs.c              |    95 +-
 drivers/staging/comedi/drivers/rtd520.c                       |   950 ++-----
 drivers/staging/comedi/drivers/rtd520.h                       |   267 +-
 drivers/staging/comedi/drivers/rti800.c                       |    13 +-
 drivers/staging/comedi/drivers/rti802.c                       |     9 +-
 drivers/staging/comedi/drivers/s526.c                         |     8 +-
 drivers/staging/comedi/drivers/s626.c                         |   129 +-
 drivers/staging/comedi/drivers/serial2002.c                   |    44 +-
 drivers/staging/comedi/drivers/skel.c                         |   610 +++--
 drivers/staging/comedi/drivers/ssv_dnp.c                      |    26 +-
 drivers/staging/comedi/drivers/unioxx5.c                      |    44 +-
 drivers/staging/comedi/drivers/usbdux.c                       |   125 +-
 drivers/staging/comedi/drivers/usbduxfast.c                   |   211 +-
 drivers/staging/comedi/drivers/usbduxsigma.c                  |   116 +-
 drivers/staging/comedi/drivers/vmk80xx.c                      |    20 +-
 drivers/staging/comedi/kcomedilib/kcomedilib_main.c           |     6 +-
 drivers/staging/comedi/proc.c                                 |     1 -
 drivers/staging/crystalhd/crystalhd_cmds.c                    |     8 +-
 drivers/staging/crystalhd/crystalhd_lnx.c                     |    14 +-
 drivers/staging/crystalhd/crystalhd_misc.c                    |     2 +-
 drivers/staging/csr/Makefile                                  |     3 +-
 drivers/staging/csr/bh.c                                      |    19 +-
 drivers/staging/csr/csr_framework_ext.c                       |    97 -
 drivers/staging/csr/csr_framework_ext.h                       |   213 --
 drivers/staging/csr/csr_framework_ext_types.h                 |    41 +-
 drivers/staging/csr/csr_lib.h                                 |   188 --
 drivers/staging/csr/csr_log.h                                 |   172 +-
 drivers/staging/csr/csr_log_configure.h                       |   105 +-
 drivers/staging/csr/csr_log_text.h                            |     8 -
 drivers/staging/csr/csr_macro.h                               |    75 -
 drivers/staging/csr/csr_msg_transport.h                       |     8 -
 drivers/staging/csr/csr_msgconv.c                             |     1 -
 drivers/staging/csr/csr_msgconv.h                             |     9 -
 drivers/staging/csr/csr_panic.c                               |    20 -
 drivers/staging/csr/csr_panic.h                               |    53 -
 drivers/staging/csr/csr_prim_defs.h                           |     7 -
 drivers/staging/csr/csr_result.h                              |     8 -
 drivers/staging/csr/csr_sched.h                               |   215 +-
 drivers/staging/csr/csr_sdio.h                                |     8 -
 drivers/staging/csr/csr_serialize_primitive_types.c           |     1 -
 drivers/staging/csr/csr_time.c                                |     9 +-
 drivers/staging/csr/csr_time.h                                |    82 +-
 drivers/staging/csr/csr_wifi_common.h                         |     8 -
 drivers/staging/csr/csr_wifi_fsm.h                            |     8 -
 drivers/staging/csr/csr_wifi_fsm_event.h                      |     8 -
 drivers/staging/csr/csr_wifi_fsm_types.h                      |    10 -
 drivers/staging/csr/csr_wifi_hip_card.h                       |     9 -
 drivers/staging/csr/csr_wifi_hip_card_sdio.c                  |   162 --
 drivers/staging/csr/csr_wifi_hip_card_sdio.h                  |     8 -
 drivers/staging/csr/csr_wifi_hip_chiphelper.h                 |    64 -
 drivers/staging/csr/csr_wifi_hip_chiphelper_private.h         |     8 -
 drivers/staging/csr/csr_wifi_hip_conversions.h                |     8 -
 drivers/staging/csr/csr_wifi_hip_download.c                   |    18 -
 drivers/staging/csr/csr_wifi_hip_dump.c                       |    32 +-
 drivers/staging/csr/csr_wifi_hip_send.c                       |     2 -
 drivers/staging/csr/csr_wifi_hip_signals.h                    |    17 +-
 drivers/staging/csr/csr_wifi_hip_sigs.h                       |     8 -
 drivers/staging/csr/csr_wifi_hip_ta_sampling.h                |     9 -
 drivers/staging/csr/csr_wifi_hip_unifi.h                      |    10 +-
 drivers/staging/csr/csr_wifi_hip_unifi_signal_names.c         |    45 +-
 drivers/staging/csr/csr_wifi_hip_unifi_udi.h                  |     9 -
 drivers/staging/csr/csr_wifi_hip_unifihw.h                    |     8 -
 drivers/staging/csr/csr_wifi_hip_unifiversion.h               |     8 -
 drivers/staging/csr/csr_wifi_hip_xbv.c                        |     2 +-
 drivers/staging/csr/csr_wifi_hip_xbv.h                        |     8 -
 drivers/staging/csr/csr_wifi_hostio_prim.h                    |     9 -
 drivers/staging/csr/csr_wifi_lib.h                            |     9 -
 drivers/staging/csr/csr_wifi_msgconv.h                        |     9 -
 drivers/staging/csr/csr_wifi_nme_ap_converter_init.h          |     8 -
 drivers/staging/csr/csr_wifi_nme_ap_lib.h                     |    28 -
 drivers/staging/csr/csr_wifi_nme_ap_prim.h                    |     9 -
 drivers/staging/csr/csr_wifi_nme_ap_sef.h                     |    10 -
 drivers/staging/csr/csr_wifi_nme_ap_serialize.h               |     9 -
 drivers/staging/csr/csr_wifi_nme_converter_init.h             |     8 -
 drivers/staging/csr/csr_wifi_nme_lib.h                        |    63 -
 drivers/staging/csr/csr_wifi_nme_prim.h                       |     9 -
 drivers/staging/csr/csr_wifi_nme_serialize.h                  |     8 -
 drivers/staging/csr/csr_wifi_nme_task.h                       |    11 -
 drivers/staging/csr/csr_wifi_private_common.h                 |     8 -
 drivers/staging/csr/csr_wifi_result.h                         |     8 -
 drivers/staging/csr/csr_wifi_router_converter_init.h          |     8 -
 drivers/staging/csr/csr_wifi_router_ctrl_converter_init.h     |     8 -
 drivers/staging/csr/csr_wifi_router_ctrl_lib.h                |    10 -
 drivers/staging/csr/csr_wifi_router_ctrl_prim.h               |     9 -
 drivers/staging/csr/csr_wifi_router_ctrl_sef.c                |    67 +-
 drivers/staging/csr/csr_wifi_router_ctrl_sef.h                |     7 -
 drivers/staging/csr/csr_wifi_router_ctrl_serialize.h          |     8 -
 drivers/staging/csr/csr_wifi_router_free_upstream_contents.c  |    46 +-
 drivers/staging/csr/csr_wifi_router_lib.h                     |    10 -
 drivers/staging/csr/csr_wifi_router_prim.h                    |     9 -
 drivers/staging/csr/csr_wifi_router_sef.h                     |     8 -
 drivers/staging/csr/csr_wifi_router_serialize.h               |     8 -
 drivers/staging/csr/csr_wifi_router_task.h                    |     8 -
 drivers/staging/csr/csr_wifi_sme_ap_lib.h                     |     9 -
 drivers/staging/csr/csr_wifi_sme_ap_prim.h                    |     8 -
 drivers/staging/csr/csr_wifi_sme_converter_init.h             |     8 -
 drivers/staging/csr/csr_wifi_sme_lib.h                        |    10 -
 drivers/staging/csr/csr_wifi_sme_prim.h                       |     9 -
 drivers/staging/csr/csr_wifi_sme_sef.h                        |   213 +-
 drivers/staging/csr/csr_wifi_sme_serialize.h                  |   336 ++-
 drivers/staging/csr/csr_wifi_sme_task.h                       |    16 +-
 drivers/staging/csr/csr_wifi_vif_utils.h                      |    81 -
 drivers/staging/csr/data_tx.c                                 |    45 +-
 drivers/staging/csr/drv.c                                     |   101 +-
 drivers/staging/csr/firmware.c                                |    15 -
 drivers/staging/csr/inet.c                                    |    10 +-
 drivers/staging/csr/io.c                                      |   102 +-
 drivers/staging/csr/mlme.c                                    |     3 -
 drivers/staging/csr/monitor.c                                 |    10 -
 drivers/staging/csr/netdev.c                                  |    90 +-
 drivers/staging/csr/os.c                                      |    18 +-
 drivers/staging/csr/sdio_mmc.c                                |    28 -
 drivers/staging/csr/sme_blocking.c                            |   307 +--
 drivers/staging/csr/sme_native.c                              |    21 -
 drivers/staging/csr/sme_sys.c                                 |    17 +-
 drivers/staging/csr/sme_userspace.h                           |     2 +-
 drivers/staging/csr/sme_wext.c                                |    49 -
 drivers/staging/csr/ul_int.c                                  |     1 -
 drivers/staging/csr/unifi_event.c                             |     8 -
 drivers/staging/csr/unifi_os.h                                |    23 -
 drivers/staging/csr/unifi_pdu_processing.c                    |    39 +-
 drivers/staging/csr/unifi_priv.h                              |     7 +-
 drivers/staging/csr/unifi_sme.c                               |    15 -
 drivers/staging/csr/unifi_wext.h                              |     1 -
 drivers/staging/cxt1e1/musycc.c                               |  2162 ++++++++--------
 drivers/staging/cxt1e1/musycc.h                               |   236 +-
 drivers/staging/cxt1e1/sbecrc.c                               |   105 +-
 drivers/staging/dgrp/dgrp_dpa_ops.c                           |     2 +-
 drivers/staging/dgrp/dgrp_net_ops.c                           |     5 +-
 drivers/staging/dgrp/dgrp_sysfs.c                             |     3 +-
 drivers/staging/dgrp/dgrp_tty.c                               |    15 -
 drivers/staging/et131x/README                                 |     2 +-
 drivers/staging/et131x/et131x.c                               |  1323 ++++------
 drivers/staging/et131x/et131x.h                               |     4 -
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c               |     4 +-
 drivers/staging/fwserial/Kconfig                              |     9 +
 drivers/staging/fwserial/Makefile                             |     2 +
 drivers/staging/fwserial/TODO                                 |    37 +
 drivers/staging/fwserial/dma_fifo.c                           |   307 +++
 drivers/staging/fwserial/dma_fifo.h                           |   130 +
 drivers/staging/fwserial/fwserial.c                           |  2946 ++++++++++++++++++++++
 drivers/staging/fwserial/fwserial.h                           |   387 +++
 drivers/staging/gdm72xx/gdm_qos.c                             |    33 +-
 drivers/staging/gdm72xx/gdm_sdio.c                            |    29 +-
 drivers/staging/gdm72xx/gdm_usb.c                             |    64 +-
 drivers/staging/gdm72xx/gdm_wimax.c                           |    70 +-
 drivers/staging/gdm72xx/netlink_k.c                           |    23 +-
 drivers/staging/gdm72xx/sdio_boot.c                           |   100 +-
 drivers/staging/gdm72xx/usb_boot.c                            |    49 +-
 drivers/staging/iio/accel/Kconfig                             |    21 +-
 drivers/staging/iio/accel/Makefile                            |     5 -
 drivers/staging/iio/accel/adis16201.h                         |    89 +-
 drivers/staging/iio/accel/adis16201_core.c                    |   476 +---
 drivers/staging/iio/accel/adis16201_ring.c                    |   136 -
 drivers/staging/iio/accel/adis16201_trigger.c                 |    71 -
 drivers/staging/iio/accel/adis16203.h                         |    80 +-
 drivers/staging/iio/accel/adis16203_core.c                    |   432 +---
 drivers/staging/iio/accel/adis16203_ring.c                    |   136 -
 drivers/staging/iio/accel/adis16203_trigger.c                 |    73 -
 drivers/staging/iio/accel/adis16204.h                         |    79 +-
 drivers/staging/iio/accel/adis16204_core.c                    |   462 +---
 drivers/staging/iio/accel/adis16204_ring.c                    |   134 -
 drivers/staging/iio/accel/adis16204_trigger.c                 |    73 -
 drivers/staging/iio/accel/adis16209.h                         |    77 +-
 drivers/staging/iio/accel/adis16209_core.c                    |   496 +---
 drivers/staging/iio/accel/adis16209_ring.c                    |   134 -
 drivers/staging/iio/accel/adis16209_trigger.c                 |    81 -
 drivers/staging/iio/accel/adis16220.h                         |    20 +-
 drivers/staging/iio/accel/adis16220_core.c                    |   288 +--
 drivers/staging/iio/accel/adis16240.h                         |    85 +-
 drivers/staging/iio/accel/adis16240_core.c                    |   481 +---
 drivers/staging/iio/accel/adis16240_ring.c                    |   132 -
 drivers/staging/iio/accel/adis16240_trigger.c                 |    82 -
 drivers/staging/iio/accel/kxsd9.c                             |    10 +-
 drivers/staging/iio/accel/lis3l02dq.h                         |     1 +
 drivers/staging/iio/accel/lis3l02dq_core.c                    |    16 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c                    |     6 +-
 drivers/staging/iio/accel/sca3000_core.c                      |     6 +-
 drivers/staging/iio/adc/Kconfig                               |    73 +-
 drivers/staging/iio/adc/Makefile                              |    15 -
 drivers/staging/iio/adc/ad7192.c                              |     6 +-
 drivers/staging/iio/adc/ad7280a.c                             |     8 +-
 drivers/staging/iio/adc/ad7291.c                              |     6 +-
 drivers/staging/iio/adc/ad7298.h                              |    75 -
 drivers/staging/iio/adc/ad7298_ring.c                         |   113 -
 drivers/staging/iio/adc/ad7606_par.c                          |     6 +-
 drivers/staging/iio/adc/ad7606_ring.c                         |     2 +-
 drivers/staging/iio/adc/ad7606_spi.c                          |     6 +-
 drivers/staging/iio/adc/ad7780.c                              |     6 +-
 drivers/staging/iio/adc/ad7793.h                              |   115 -
 drivers/staging/iio/adc/ad7816.c                              |     6 +-
 drivers/staging/iio/adc/ad7887.h                              |    99 -
 drivers/staging/iio/adc/ad7887_ring.c                         |   122 -
 drivers/staging/iio/adc/ad799x_core.c                         |     6 +-
 drivers/staging/iio/adc/ad799x_ring.c                         |     2 +-
 drivers/staging/iio/adc/adt7310.c                             |   881 -------
 drivers/staging/iio/adc/adt7410.c                             |   460 +++-
 drivers/staging/iio/adc/lpc32xx_adc.c                         |     8 +-
 drivers/staging/iio/adc/max1363.h                             |   177 --
 drivers/staging/iio/adc/max1363_ring.c                        |   139 --
 drivers/staging/iio/adc/mxs-lradc.c                           |    11 +-
 drivers/staging/iio/adc/spear_adc.c                           |     6 +-
 drivers/staging/iio/addac/adt7316-i2c.c                       |     6 +-
 drivers/staging/iio/addac/adt7316-spi.c                       |     6 +-
 drivers/staging/iio/addac/adt7316.c                           |     4 +-
 drivers/staging/iio/cdc/ad7150.c                              |    18 +-
 drivers/staging/iio/cdc/ad7152.c                              |     8 +-
 drivers/staging/iio/cdc/ad7746.c                              |     8 +-
 drivers/staging/iio/frequency/ad5930.c                        |     6 +-
 drivers/staging/iio/frequency/ad9832.c                        |     6 +-
 drivers/staging/iio/frequency/ad9834.c                        |     6 +-
 drivers/staging/iio/frequency/ad9850.c                        |     6 +-
 drivers/staging/iio/frequency/ad9852.c                        |     6 +-
 drivers/staging/iio/frequency/ad9910.c                        |     6 +-
 drivers/staging/iio/frequency/ad9951.c                        |     6 +-
 drivers/staging/iio/gyro/Makefile                             |     1 -
 drivers/staging/iio/gyro/adis16060_core.c                     |    12 +-
 drivers/staging/iio/gyro/adis16080_core.c                     |     6 +-
 drivers/staging/iio/gyro/adis16130_core.c                     |     6 +-
 drivers/staging/iio/gyro/adis16260.h                          |    84 +-
 drivers/staging/iio/gyro/adis16260_core.c                     |   496 +---
 drivers/staging/iio/gyro/adis16260_ring.c                     |   136 -
 drivers/staging/iio/gyro/adis16260_trigger.c                  |    75 -
 drivers/staging/iio/gyro/adxrs450_core.c                      |     6 +-
 drivers/staging/iio/iio_dummy_evgen.c                         |     2 +-
 drivers/staging/iio/iio_hwmon.c                               |     6 +-
 drivers/staging/iio/iio_simple_dummy.c                        |     2 +-
 drivers/staging/iio/iio_simple_dummy_buffer.c                 |     5 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c               |    10 +-
 drivers/staging/iio/imu/adis16400.h                           |    12 +-
 drivers/staging/iio/imu/adis16400_core.c                      |   161 +-
 drivers/staging/iio/imu/adis16400_ring.c                      |     5 +-
 drivers/staging/iio/light/isl29018.c                          |    53 +-
 drivers/staging/iio/light/isl29028.c                          |     6 +-
 drivers/staging/iio/light/tsl2563.c                           |    10 +-
 drivers/staging/iio/light/tsl2583.c                           |     6 +-
 drivers/staging/iio/light/tsl2x7x_core.c                      |     6 +-
 drivers/staging/iio/magnetometer/ak8975.c                     |     6 +-
 drivers/staging/iio/magnetometer/hmc5843.c                    |     8 +-
 drivers/staging/iio/meter/ade7753.c                           |     6 +-
 drivers/staging/iio/meter/ade7753.h                           |     2 -
 drivers/staging/iio/meter/ade7754.c                           |     6 +-
 drivers/staging/iio/meter/ade7754.h                           |     2 -
 drivers/staging/iio/meter/ade7758.h                           |     3 -
 drivers/staging/iio/meter/ade7758_core.c                      |     6 +-
 drivers/staging/iio/meter/ade7758_ring.c                      |     2 +-
 drivers/staging/iio/meter/ade7759.c                           |     6 +-
 drivers/staging/iio/meter/ade7759.h                           |     2 -
 drivers/staging/iio/meter/ade7854-i2c.c                       |     6 +-
 drivers/staging/iio/meter/ade7854-spi.c                       |     6 +-
 drivers/staging/iio/meter/ade7854.h                           |     2 -
 drivers/staging/iio/resolver/ad2s1200.c                       |     6 +-
 drivers/staging/iio/resolver/ad2s1210.c                       |     8 +-
 drivers/staging/iio/resolver/ad2s90.c                         |     6 +-
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c             |     6 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c                   |     6 +-
 drivers/staging/iio/trigger/iio-trig-periodic-rtc.c           |     6 +-
 drivers/staging/imx-drm/Kconfig                               |     2 +-
 drivers/staging/imx-drm/imx-drm-core.c                        |     2 +-
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h                   |     2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-common.c                   |    67 +-
 drivers/staging/imx-drm/ipuv3-crtc.c                          |     8 +-
 drivers/staging/imx-drm/parallel-display.c                    |    16 +-
 drivers/staging/ipack/Kconfig                                 |    21 -
 drivers/staging/ipack/TODO                                    |    22 -
 drivers/staging/ipack/bridges/Kconfig                         |     8 -
 drivers/staging/ipack/ipack_ids.h                             |    32 -
 drivers/staging/line6/Kconfig                                 |    37 -
 drivers/staging/line6/Makefile                                |     2 -
 drivers/staging/line6/audio.c                                 |     8 +-
 drivers/staging/line6/capture.c                               |    13 +-
 drivers/staging/line6/control.c                               |   995 --------
 drivers/staging/line6/control.h                               |   195 --
 drivers/staging/line6/driver.c                                |    85 +-
 drivers/staging/line6/driver.h                                |    10 +-
 drivers/staging/line6/dumprequest.c                           |   135 -
 drivers/staging/line6/dumprequest.h                           |    76 -
 drivers/staging/line6/midi.c                                  |   126 -
 drivers/staging/line6/midi.h                                  |    10 -
 drivers/staging/line6/midibuf.c                               |     6 +-
 drivers/staging/line6/pcm.c                                   |     4 +-
 drivers/staging/line6/pcm.h                                   |     2 +-
 drivers/staging/line6/playback.c                              |    17 +-
 drivers/staging/line6/pod.c                                   |   879 +------
 drivers/staging/line6/pod.h                                   |   105 +-
 drivers/staging/line6/toneport.c                              |     8 +-
 drivers/staging/line6/usbdefs.h                               |    10 +-
 drivers/staging/line6/variax.c                                |   484 +---
 drivers/staging/line6/variax.h                                |    60 -
 drivers/staging/media/dt3155v4l/dt3155v4l.c                   |    12 +-
 drivers/staging/media/lirc/lirc_parallel.c                    |     6 +-
 drivers/staging/media/lirc/lirc_serial.c                      |     6 +-
 drivers/staging/media/lirc/lirc_sir.c                         |     6 +-
 drivers/staging/media/solo6x10/core.c                         |     4 +-
 drivers/staging/net/pc300_drv.c                               |     6 +-
 drivers/staging/nvec/Kconfig                                  |     1 +
 drivers/staging/nvec/nvec.c                                   |     8 +-
 drivers/staging/nvec/nvec_kbd.c                               |     6 +-
 drivers/staging/nvec/nvec_paz00.c                             |     6 +-
 drivers/staging/nvec/nvec_power.c                             |     6 +-
 drivers/staging/nvec/nvec_ps2.c                               |     6 +-
 drivers/staging/octeon/ethernet.c                             |    12 +-
 drivers/staging/olpc_dcon/olpc_dcon.c                         |    85 +-
 drivers/staging/olpc_dcon/olpc_dcon.h                         |     2 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c                  |    30 -
 drivers/staging/omap-thermal/omap-bandgap.c                   |    67 +-
 drivers/staging/omap-thermal/omap-bandgap.h                   |     9 -
 drivers/staging/omap-thermal/omap-thermal-common.c            |    69 +-
 drivers/staging/omapdrm/Kconfig                               |     2 +-
 drivers/staging/omapdrm/omap_connector.c                      |     8 +-
 drivers/staging/omapdrm/omap_crtc.c                           |     8 +-
 drivers/staging/omapdrm/omap_dmm_priv.h                       |     9 +-
 drivers/staging/omapdrm/omap_dmm_tiler.c                      |   108 +-
 drivers/staging/omapdrm/omap_dmm_tiler.h                      |     8 +-
 drivers/staging/omapdrm/omap_drv.c                            |    73 +-
 drivers/staging/omapdrm/omap_drv.h                            |    14 +-
 drivers/staging/omapdrm/omap_encoder.c                        |     7 +-
 drivers/staging/omapdrm/omap_fb.c                             |    25 +-
 drivers/staging/omapdrm/omap_gem.c                            |    46 +-
 drivers/staging/omapdrm/omap_gem_dmabuf.c                     |     4 +-
 drivers/staging/omapdrm/omap_gem_helpers.c                    |     6 +-
 drivers/staging/omapdrm/omap_plane.c                          |    42 +-
 drivers/staging/ozwpan/ozevent.c                              |     2 +-
 drivers/staging/ozwpan/ozhcd.c                                |     7 +-
 drivers/staging/ozwpan/ozpd.c                                 |     6 +-
 drivers/staging/ozwpan/ozproto.c                              |     3 +-
 drivers/staging/panel/panel.c                                 |     8 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h               |     6 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c         |    24 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.h         |     2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c    |    38 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c     |    18 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_module.c        |    23 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c            |   321 +--
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c    |   121 +-
 drivers/staging/rtl8187se/r8180.h                             |    28 -
 drivers/staging/rtl8187se/r8180_core.c                        |   496 +---
 drivers/staging/rtl8187se/r8180_dm.h                          |     4 +-
 drivers/staging/rtl8187se/r8180_rtl8225.h                     |     4 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c                   |   229 +-
 drivers/staging/rtl8187se/r8180_wx.c                          |     2 -
 drivers/staging/rtl8187se/r8185b_init.c                       |   239 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                  |    15 +-
 drivers/staging/rtl8192e/rtllib.h                             |     6 +-
 drivers/staging/rtl8192e/rtllib_tx.c                          |     2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h                |     5 +-
 drivers/staging/rtl8192u/r8192U_core.c                        |     8 +-
 drivers/staging/rtl8712/mlme_linux.c                          |     2 +-
 drivers/staging/rtl8712/rtl871x_cmd.c                         |     4 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                 |     4 +-
 drivers/staging/rts5139/Makefile                              |    22 +-
 drivers/staging/rts5139/ms.c                                  |    96 +-
 drivers/staging/rts5139/ms.h                                  |    18 +-
 drivers/staging/rts5139/ms_mg.c                               |   104 +-
 drivers/staging/rts5139/ms_mg.h                               |    14 +-
 drivers/staging/rts5139/rts51x.c                              |    10 +-
 drivers/staging/rts5139/rts51x_card.c                         |    80 +-
 drivers/staging/rts5139/rts51x_card.h                         |    30 +-
 drivers/staging/rts5139/rts51x_chip.c                         |    24 +-
 drivers/staging/rts5139/rts51x_chip.h                         |    16 +-
 drivers/staging/rts5139/rts51x_fop.c                          |     6 +-
 drivers/staging/rts5139/rts51x_scsi.c                         |   238 +-
 drivers/staging/rts5139/rts51x_scsi.h                         |     6 +-
 drivers/staging/rts5139/sd.c                                  |    36 +-
 drivers/staging/rts5139/sd.h                                  |    12 +-
 drivers/staging/rts5139/sd_cprm.c                             |   124 +-
 drivers/staging/rts5139/sd_cprm.h                             |    18 +-
 drivers/staging/rts5139/xd.c                                  |    58 +-
 drivers/staging/rts5139/xd.h                                  |    10 +-
 drivers/staging/rts_pstor/Kconfig                             |    16 -
 drivers/staging/rts_pstor/Makefile                            |    16 -
 drivers/staging/rts_pstor/TODO                                |     9 -
 drivers/staging/rts_pstor/debug.h                             |    43 -
 drivers/staging/rts_pstor/general.c                           |    35 -
 drivers/staging/rts_pstor/general.h                           |    31 -
 drivers/staging/rts_pstor/ms.c                                |  4051 ------------------------------
 drivers/staging/rts_pstor/ms.h                                |   225 --
 drivers/staging/rts_pstor/rtsx.c                              |  1105 ---------
 drivers/staging/rts_pstor/rtsx.h                              |   186 --
 drivers/staging/rts_pstor/rtsx_card.c                         |  1233 ---------
 drivers/staging/rts_pstor/rtsx_card.h                         |  1093 --------
 drivers/staging/rts_pstor/rtsx_chip.c                         |  2264 -----------------
 drivers/staging/rts_pstor/rtsx_chip.h                         |   989 --------
 drivers/staging/rts_pstor/rtsx_scsi.c                         |  3137 -----------------------
 drivers/staging/rts_pstor/rtsx_scsi.h                         |   142 --
 drivers/staging/rts_pstor/rtsx_sys.h                          |    50 -
 drivers/staging/rts_pstor/rtsx_transport.c                    |   769 ------
 drivers/staging/rts_pstor/rtsx_transport.h                    |    66 -
 drivers/staging/rts_pstor/sd.c                                |  4570 ----------------------------------
 drivers/staging/rts_pstor/sd.h                                |   300 ---
 drivers/staging/rts_pstor/spi.c                               |   812 ------
 drivers/staging/rts_pstor/spi.h                               |    65 -
 drivers/staging/rts_pstor/trace.h                             |    93 -
 drivers/staging/rts_pstor/xd.c                                |  2052 ---------------
 drivers/staging/rts_pstor/xd.h                                |   188 --
 drivers/staging/sbe-2t3e3/cpld.c                              |     2 +-
 drivers/staging/sbe-2t3e3/main.c                              |     7 +-
 drivers/staging/sbe-2t3e3/module.c                            |    19 +-
 drivers/staging/sbe-2t3e3/netdev.c                            |     5 +-
 drivers/staging/sep/sep_main.c                                |     6 +-
 drivers/staging/serqt_usb2/serqt_usb2.c                       |   287 ++-
 drivers/staging/silicom/bp_mod.c                              |   219 +-
 drivers/staging/silicom/bp_proc.c                             |    85 +-
 drivers/staging/silicom/bypasslib/bplibk.h                    |     9 -
 drivers/staging/silicom/bypasslib/bypass.c                    |     1 -
 drivers/staging/slicoss/slicoss.c                             |   166 +-
 drivers/staging/sm7xxfb/sm7xxfb.c                             |     6 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c                 |   106 +-
 drivers/staging/telephony/Kconfig                             |    47 -
 drivers/staging/telephony/Makefile                            |     7 -
 drivers/staging/telephony/TODO                                |    10 -
 drivers/staging/telephony/ixj-ver.h                           |     4 -
 drivers/staging/telephony/ixj.c                               | 10571 ------------------------------------------------------------------------------
 drivers/staging/telephony/ixj.h                               |  1322 ----------
 drivers/staging/telephony/ixj_pcmcia.c                        |   187 --
 drivers/staging/telephony/phonedev.c                          |   166 --
 drivers/staging/tidspbridge/dynload/dload_internal.h          |     8 +-
 drivers/staging/tidspbridge/dynload/reloc.c                   |     6 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c              |     6 +-
 drivers/staging/usbip/stub_dev.c                              |    15 +-
 drivers/staging/usbip/stub_rx.c                               |     5 +-
 drivers/staging/usbip/stub_tx.c                               |     3 +-
 drivers/staging/usbip/usbip_common.c                          |    40 +-
 drivers/staging/usbip/usbip_common.h                          |     4 +-
 drivers/staging/usbip/userspace/src/usbip_detach.c            |     9 +
 drivers/staging/usbip/vhci.h                                  |     1 -
 drivers/staging/usbip/vhci_hcd.c                              |    51 +-
 drivers/staging/usbip/vhci_rx.c                               |     2 +-
 drivers/staging/usbip/vhci_sysfs.c                            |     6 +-
 drivers/staging/usbip/vhci_tx.c                               |     2 +-
 drivers/staging/vme/devices/vme_pio2.h                        |     2 +-
 drivers/staging/vme/devices/vme_pio2_core.c                   |    10 +-
 drivers/staging/vme/devices/vme_pio2_gpio.c                   |     2 +-
 drivers/staging/vme/devices/vme_user.c                        |    83 +-
 drivers/staging/vt6655/device_main.c                          |     6 +-
 drivers/staging/vt6655/hostap.c                               |     6 +-
 drivers/staging/vt6655/rxtx.c                                 |     2 +-
 drivers/staging/vt6655/wcmd.c                                 |     1 +
 drivers/staging/vt6656/80211mgr.c                             |     2 +-
 drivers/staging/vt6656/Makefile                               |     1 -
 drivers/staging/vt6656/bssdb.c                                |    43 -
 drivers/staging/vt6656/desc.h                                 |    28 +-
 drivers/staging/vt6656/device.h                               |    48 +-
 drivers/staging/vt6656/dpc.c                                  |    64 +-
 drivers/staging/vt6656/firmware.c                             |    22 +-
 drivers/staging/vt6656/hostap.c                               |     6 +-
 drivers/staging/vt6656/int.h                                  |     4 +-
 drivers/staging/vt6656/ioctl.c                                |   648 -----
 drivers/staging/vt6656/ioctl.h                                |    54 -
 drivers/staging/vt6656/iwctl.c                                |   510 ++--
 drivers/staging/vt6656/iwctl.h                                |    79 +-
 drivers/staging/vt6656/key.c                                  |    55 +-
 drivers/staging/vt6656/key.h                                  |     8 +-
 drivers/staging/vt6656/mac.c                                  |     6 +-
 drivers/staging/vt6656/main_usb.c                             |   552 +----
 drivers/staging/vt6656/mib.c                                  |     1 -
 drivers/staging/vt6656/mib.h                                  |     1 -
 drivers/staging/vt6656/rf.c                                   |     3 +
 drivers/staging/vt6656/rxtx.c                                 |    36 +-
 drivers/staging/vt6656/rxtx.h                                 |     8 +-
 drivers/staging/vt6656/tkip.c                                 |    40 +-
 drivers/staging/vt6656/ttype.h                                |    16 +-
 drivers/staging/vt6656/upc.h                                  |   162 --
 drivers/staging/vt6656/usbpipe.c                              |     4 +-
 drivers/staging/vt6656/wcmd.c                                 |    44 +-
 drivers/staging/vt6656/wmgr.c                                 |    66 -
 drivers/staging/vt6656/wmgr.h                                 |    42 +-
 drivers/staging/vt6656/wpa2.c                                 |     2 +-
 drivers/staging/vt6656/wpa2.h                                 |     4 +-
 drivers/staging/vt6656/wpactl.c                               |   664 +----
 drivers/staging/vt6656/wpactl.h                               |    12 +-
 drivers/staging/winbond/mds.c                                 |     7 +-
 drivers/staging/winbond/wb35rx_f.h                            |    12 +-
 drivers/staging/winbond/wb35rx_s.h                            |    62 +-
 drivers/staging/winbond/wbhal.h                               |     4 +-
 drivers/staging/winbond/wbusb.c                               |    14 -
 drivers/staging/wlags49_h2/ap_h2.c                            |    16 +-
 drivers/staging/wlags49_h2/man/wlags49.4                      |     2 +-
 drivers/staging/wlags49_h2/wl_if.h                            |   133 +-
 drivers/staging/wlags49_h2/wl_pci.c                           |    25 +-
 drivers/staging/wlan-ng/hfa384x_usb.c                         |     6 +-
 drivers/staging/xgifb/TODO                                    |     2 +-
 drivers/staging/xgifb/XGI_main_26.c                           |    60 +-
 drivers/staging/xgifb/vb_def.h                                |     9 +-
 drivers/staging/xgifb/vb_init.c                               |    47 +-
 drivers/staging/xgifb/vb_init.h                               |     1 -
 drivers/staging/xgifb/vb_setmode.c                            |   898 ++-----
 drivers/staging/xgifb/vb_struct.h                             |    36 +-
 drivers/staging/xgifb/vb_table.h                              |   504 ++--
 drivers/staging/zram/zram_drv.c                               |   113 +-
 drivers/staging/zram/zram_drv.h                               |     4 +-
 drivers/staging/zram/zram_sysfs.c                             |     8 +-
 drivers/vme/boards/vme_vmivme7805.c                           |    15 +-
 drivers/vme/bridges/vme_ca91cx42.c                            |    15 +-
 drivers/vme/bridges/vme_tsi148.c                              |    15 +-
 include/linux/iio/buffer.h                                    |    26 +-
 include/linux/iio/consumer.h                                  |    50 +
 include/linux/iio/iio.h                                       |     5 +
 include/linux/iio/imu/adis.h                                  |   280 +++
 include/linux/iio/machine.h                                   |     2 +
 include/linux/iio/types.h                                     |     2 +
 {drivers/staging/ipack => include/linux}/ipack.h              |   100 +-
 include/linux/platform_data/ad5449.h                          |    40 +
 include/linux/platform_data/ad7298.h                          |    20 +
 include/linux/platform_data/ad7793.h                          |   112 +
 include/linux/platform_data/ad7887.h                          |    26 +
 include/linux/platform_data/omap_drm.h                        |     1 +
 768 files changed, 31887 insertions(+), 82166 deletions(-)
 delete mode 100644 Documentation/telephony/00-INDEX
 delete mode 100644 Documentation/telephony/ixj.txt
 rename drivers/{staging/iio/adc/ad7298_core.c => iio/adc/ad7298.c} (55%)
 rename drivers/{staging => }/iio/adc/ad7793.c (50%)
 rename drivers/{staging/iio/adc/ad7887_core.c => iio/adc/ad7887.c} (50%)
 rename drivers/{staging/iio/adc/max1363_core.c => iio/adc/max1363.c} (81%)
 create mode 100644 drivers/iio/adc/ti-adc081c.c
 create mode 100644 drivers/iio/buffer_cb.c
 create mode 100644 drivers/iio/dac/ad5449.c
 create mode 100644 drivers/iio/gyro/adis16136.c
 create mode 100644 drivers/iio/imu/Kconfig
 create mode 100644 drivers/iio/imu/Makefile
 create mode 100644 drivers/iio/imu/adis.c
 create mode 100644 drivers/iio/imu/adis16480.c
 create mode 100644 drivers/iio/imu/adis_buffer.c
 create mode 100644 drivers/iio/imu/adis_trigger.c
 create mode 100644 drivers/ipack/Kconfig
 rename drivers/{staging => }/ipack/Makefile (83%)
 create mode 100644 drivers/ipack/carriers/Kconfig
 rename drivers/{staging/ipack/bridges => ipack/carriers}/Makefile (100%)
 rename drivers/{staging/ipack/bridges => ipack/carriers}/tpci200.c (66%)
 rename drivers/{staging/ipack/bridges => ipack/carriers}/tpci200.h (85%)
 rename drivers/{staging => }/ipack/devices/Kconfig (99%)
 rename drivers/{staging => }/ipack/devices/Makefile (100%)
 rename drivers/{staging => }/ipack/devices/ipoctal.c (86%)
 rename drivers/{staging => }/ipack/devices/ipoctal.h (82%)
 rename drivers/{staging => }/ipack/devices/scc2698.h (97%)
 rename drivers/{staging => }/ipack/ipack.c (90%)
 create mode 100644 drivers/staging/android/binder_trace.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
 delete mode 100644 drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_2016.c
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_3001.c
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_3300.c
 delete mode 100644 drivers/staging/comedi/drivers/mpc8260cpm.c
 delete mode 100644 drivers/staging/csr/csr_lib.h
 delete mode 100644 drivers/staging/csr/csr_panic.c
 delete mode 100644 drivers/staging/csr/csr_panic.h
 create mode 100644 drivers/staging/fwserial/Kconfig
 create mode 100644 drivers/staging/fwserial/Makefile
 create mode 100644 drivers/staging/fwserial/TODO
 create mode 100644 drivers/staging/fwserial/dma_fifo.c
 create mode 100644 drivers/staging/fwserial/dma_fifo.h
 create mode 100644 drivers/staging/fwserial/fwserial.c
 create mode 100644 drivers/staging/fwserial/fwserial.h
 delete mode 100644 drivers/staging/iio/accel/adis16201_ring.c
 delete mode 100644 drivers/staging/iio/accel/adis16201_trigger.c
 delete mode 100644 drivers/staging/iio/accel/adis16203_ring.c
 delete mode 100644 drivers/staging/iio/accel/adis16203_trigger.c
 delete mode 100644 drivers/staging/iio/accel/adis16204_ring.c
 delete mode 100644 drivers/staging/iio/accel/adis16204_trigger.c
 delete mode 100644 drivers/staging/iio/accel/adis16209_ring.c
 delete mode 100644 drivers/staging/iio/accel/adis16209_trigger.c
 delete mode 100644 drivers/staging/iio/accel/adis16240_ring.c
 delete mode 100644 drivers/staging/iio/accel/adis16240_trigger.c
 delete mode 100644 drivers/staging/iio/adc/ad7298.h
 delete mode 100644 drivers/staging/iio/adc/ad7298_ring.c
 delete mode 100644 drivers/staging/iio/adc/ad7793.h
 delete mode 100644 drivers/staging/iio/adc/ad7887.h
 delete mode 100644 drivers/staging/iio/adc/ad7887_ring.c
 delete mode 100644 drivers/staging/iio/adc/adt7310.c
 delete mode 100644 drivers/staging/iio/adc/max1363.h
 delete mode 100644 drivers/staging/iio/adc/max1363_ring.c
 delete mode 100644 drivers/staging/iio/gyro/adis16260_ring.c
 delete mode 100644 drivers/staging/iio/gyro/adis16260_trigger.c
 delete mode 100644 drivers/staging/ipack/Kconfig
 delete mode 100644 drivers/staging/ipack/TODO
 delete mode 100644 drivers/staging/ipack/bridges/Kconfig
 delete mode 100644 drivers/staging/ipack/ipack_ids.h
 delete mode 100644 drivers/staging/line6/control.c
 delete mode 100644 drivers/staging/line6/control.h
 delete mode 100644 drivers/staging/line6/dumprequest.c
 delete mode 100644 drivers/staging/line6/dumprequest.h
 delete mode 100644 drivers/staging/rts_pstor/Kconfig
 delete mode 100644 drivers/staging/rts_pstor/Makefile
 delete mode 100644 drivers/staging/rts_pstor/TODO
 delete mode 100644 drivers/staging/rts_pstor/debug.h
 delete mode 100644 drivers/staging/rts_pstor/general.c
 delete mode 100644 drivers/staging/rts_pstor/general.h
 delete mode 100644 drivers/staging/rts_pstor/ms.c
 delete mode 100644 drivers/staging/rts_pstor/ms.h
 delete mode 100644 drivers/staging/rts_pstor/rtsx.c
 delete mode 100644 drivers/staging/rts_pstor/rtsx.h
 delete mode 100644 drivers/staging/rts_pstor/rtsx_card.c
 delete mode 100644 drivers/staging/rts_pstor/rtsx_card.h
 delete mode 100644 drivers/staging/rts_pstor/rtsx_chip.c
 delete mode 100644 drivers/staging/rts_pstor/rtsx_chip.h
 delete mode 100644 drivers/staging/rts_pstor/rtsx_scsi.c
 delete mode 100644 drivers/staging/rts_pstor/rtsx_scsi.h
 delete mode 100644 drivers/staging/rts_pstor/rtsx_sys.h
 delete mode 100644 drivers/staging/rts_pstor/rtsx_transport.c
 delete mode 100644 drivers/staging/rts_pstor/rtsx_transport.h
 delete mode 100644 drivers/staging/rts_pstor/sd.c
 delete mode 100644 drivers/staging/rts_pstor/sd.h
 delete mode 100644 drivers/staging/rts_pstor/spi.c
 delete mode 100644 drivers/staging/rts_pstor/spi.h
 delete mode 100644 drivers/staging/rts_pstor/trace.h
 delete mode 100644 drivers/staging/rts_pstor/xd.c
 delete mode 100644 drivers/staging/rts_pstor/xd.h
 delete mode 100644 drivers/staging/telephony/Kconfig
 delete mode 100644 drivers/staging/telephony/Makefile
 delete mode 100644 drivers/staging/telephony/TODO
 delete mode 100644 drivers/staging/telephony/ixj-ver.h
 delete mode 100644 drivers/staging/telephony/ixj.c
 delete mode 100644 drivers/staging/telephony/ixj.h
 delete mode 100644 drivers/staging/telephony/ixj_pcmcia.c
 delete mode 100644 drivers/staging/telephony/phonedev.c
 delete mode 100644 drivers/staging/vt6656/ioctl.c
 delete mode 100644 drivers/staging/vt6656/ioctl.h
 delete mode 100644 drivers/staging/vt6656/upc.h
 create mode 100644 include/linux/iio/imu/adis.h
 rename {drivers/staging/ipack => include/linux}/ipack.h (66%)
 create mode 100644 include/linux/platform_data/ad5449.h
 create mode 100644 include/linux/platform_data/ad7298.h
 create mode 100644 include/linux/platform_data/ad7793.h
 create mode 100644 include/linux/platform_data/ad7887.h
