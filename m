Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2ALXON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:14:13 -0500
Received: from ozlabs.org ([203.10.76.45]:33949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab2ALXN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:13:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: torvalds@linux-foundation.org
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Kevin Cernekee <cernekee@gmail.com>
Subject: [PULL] module and param
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 13 Jan 2012 09:43:11 +1030
Message-ID: <87pqeo346w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sweeps remaining 'bool' module params which were actually ints.
 "int x; module_param(bool, x, 0);" still works for now, but gcc warns.)

 * [new tag]         for-linus -> for-linus
The following changes since commit 2485a4b610171f4e1c4ab0d053569747795c1bbe:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2012-01-12 12:40:41 -0800)

are available in the git repository at:

  git://github.com/rustyrussell/linux.git master

Eric Dumazet (1):
      module: struct module_ref should contains long fields

Jim Cromie (2):
      module: replace DEBUGP with pr_debug
      kernel/params: replace DEBUGP with pr_debug

Kay Sievers (1):
      modules: sysfs - export: taint, coresize, initsize

Kevin Cernekee (2):
      module: Add comments describing how the "strmap" logic works
      module: Fix performance regression on modules with large symbol tables

Rusty Russell (13):
      modpost: use a table rather than a giant if/else statement.
      modpost: use linker section to generate table.
      module_param: check type correctness for module_param_array
      module_param: avoid bool abuse, add bint for special cases.
      lirc_parallel: fix module parameter description.
      printk: fix unnecessary module_param_name.
      kernel/async: remove redundant declaration.
      module_param: make bool parameters really bool (core code)
      module_param: make bool parameters really bool (arch)
      module_param: make bool parameters really bool (drivers & misc)
      paride/pcd: fix bool verbose module parameter.
      intelfbdrv.c: bailearly is an int module_param
      module_param: check that bool parameters really are bool.

 Documentation/ABI/testing/sysfs-module          |   16 ++
 arch/ia64/hp/common/aml_nfw.c                   |    2 +-
 arch/x86/kernel/apm_32.c                        |   16 +-
 arch/x86/kvm/mmu.c                              |    2 +-
 arch/x86/kvm/vmx.c                              |   18 +-
 arch/x86/kvm/x86.c                              |    4 +-
 arch/x86/mm/mmio-mod.c                          |    4 +-
 arch/x86/platform/geode/alix.c                  |    2 +-
 arch/x86/platform/iris/iris.c                   |    2 +-
 drivers/accessibility/braille/braille_console.c |    2 +-
 drivers/acpi/acpica/acglobal.h                  |    2 +-
 drivers/acpi/apei/ghes.c                        |    2 +-
 drivers/acpi/apei/hest.c                        |    2 +-
 drivers/acpi/dock.c                             |    2 +-
 drivers/acpi/pci_slot.c                         |    2 +-
 drivers/acpi/video.c                            |    6 +-
 drivers/ata/sata_nv.c                           |    6 +-
 drivers/ata/sata_sil24.c                        |    2 +-
 drivers/atm/he.c                                |    6 +-
 drivers/block/drbd/drbd_int.h                   |    4 +-
 drivers/block/drbd/drbd_main.c                  |    4 +-
 drivers/block/paride/bpck6.c                    |    5 +-
 drivers/block/paride/pcd.c                      |    2 +-
 drivers/block/paride/pd.c                       |    3 +-
 drivers/block/paride/pf.c                       |    4 +-
 drivers/block/paride/pg.c                       |    3 +-
 drivers/block/paride/pt.c                       |    4 +-
 drivers/block/xd.c                              |    2 +-
 drivers/bluetooth/btusb.c                       |   12 +-
 drivers/bluetooth/hci_bcsp.c                    |    4 +-
 drivers/bluetooth/hci_ldisc.c                   |    2 +-
 drivers/cdrom/cdrom.c                           |   12 +-
 drivers/char/agp/amd64-agp.c                    |    2 +-
 drivers/char/agp/sis-agp.c                      |    2 +-
 drivers/char/i8k.c                              |    8 +-
 drivers/char/ipmi/ipmi_si_intf.c                |    2 +-
 drivers/char/lp.c                               |    2 +-
 drivers/char/nwflash.c                          |    2 +-
 drivers/char/pcmcia/synclink_cs.c               |    2 +-
 drivers/char/random.c                           |    2 +-
 drivers/char/tpm/tpm_tis.c                      |    6 +-
 drivers/edac/r82600_edac.c                      |    2 +-
 drivers/firewire/sbp2.c                         |    2 +-
 drivers/hid/hid-prodikeys.c                     |    2 +-
 drivers/hwmon/abituguru.c                       |    2 +-
 drivers/hwmon/abituguru3.c                      |    4 +-
 drivers/hwmon/acpi_power_meter.c                |    2 +-
 drivers/hwmon/adm1021.c                         |    2 +-
 drivers/hwmon/ads7828.c                         |    4 +-
 drivers/hwmon/dme1737.c                         |    4 +-
 drivers/hwmon/emc2103.c                         |    2 +-
 drivers/hwmon/it87.c                            |    4 +-
 drivers/hwmon/lm93.c                            |    4 +-
 drivers/hwmon/max1668.c                         |    2 +-
 drivers/hwmon/w83627hf.c                        |    2 +-
 drivers/hwmon/w83781d.c                         |    4 +-
 drivers/hwmon/w83791d.c                         |    4 +-
 drivers/hwmon/w83792d.c                         |    2 +-
 drivers/hwmon/w83793.c                          |    2 +-
 drivers/hwmon/w83795.c                          |    2 +-
 drivers/hwmon/w83l786ng.c                       |    2 +-
 drivers/i2c/busses/i2c-highlander.c             |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c                |    4 +-
 drivers/i2c/busses/i2c-sis630.c                 |    4 +-
 drivers/i2c/busses/i2c-viapro.c                 |    2 +-
 drivers/ide/ali14xx.c                           |    2 +-
 drivers/ide/cmd640.c                            |    2 +-
 drivers/ide/dtc2278.c                           |    2 +-
 drivers/ide/gayle.c                             |    2 +-
 drivers/ide/ht6560b.c                           |    2 +-
 drivers/ide/ide-4drives.c                       |    2 +-
 drivers/ide/ide-acpi.c                          |    6 +-
 drivers/ide/ide-pci-generic.c                   |    2 +-
 drivers/ide/qd65xx.c                            |    2 +-
 drivers/ide/umc8672.c                           |    2 +-
 drivers/infiniband/hw/ehca/ehca_classes.h       |    4 +-
 drivers/infiniband/hw/ehca/ehca_main.c          |   10 +-
 drivers/infiniband/hw/nes/nes.c                 |    2 +-
 drivers/input/joystick/xpad.c                   |    6 +-
 drivers/input/misc/wistron_btns.c               |    2 +-
 drivers/input/mouse/psmouse-base.c              |    2 +-
 drivers/input/mouse/synaptics_i2c.c             |    6 +-
 drivers/input/serio/hp_sdc.c                    |    2 +-
 drivers/input/touchscreen/eeti_ts.c             |    4 +-
 drivers/input/touchscreen/htcpen.c              |    4 +-
 drivers/input/touchscreen/ucb1400_ts.c          |    2 +-
 drivers/input/touchscreen/usbtouchscreen.c      |    4 +-
 drivers/isdn/hardware/avm/b1dma.c               |    2 +-
 drivers/isdn/hardware/avm/c4.c                  |    2 +-
 drivers/isdn/sc/init.c                          |    2 +-
 drivers/leds/leds-clevo-mail.c                  |    2 +-
 drivers/leds/leds-ss4200.c                      |    2 +-
 drivers/macintosh/ams/ams-core.c                |    2 +-
 drivers/macintosh/ams/ams-input.c               |    4 +-
 drivers/macintosh/therm_adt746x.c               |    2 +-
 drivers/media/dvb/dvb-usb/af9005.c              |    2 +-
 drivers/media/dvb/dvb-usb/af9005.h              |    2 +-
 drivers/media/radio/radio-gemtek.c              |   10 +-
 drivers/media/radio/radio-miropcm20.c           |    2 +-
 drivers/media/rc/lirc_dev.c                     |    2 +-
 drivers/media/rc/mceusb.c                       |    4 +-
 drivers/media/rc/streamzap.c                    |    4 +-
 drivers/media/rc/winbond-cir.c                  |    4 +-
 drivers/media/video/c-qcam.c                    |    2 +-
 drivers/media/video/cs5345.c                    |    2 +-
 drivers/media/video/cs53l32a.c                  |    2 +-
 drivers/media/video/cx18/cx18-driver.c          |    2 +-
 drivers/media/video/cx25821/cx25821-alsa.c      |    2 +-
 drivers/media/video/cx88/cx88-alsa.c            |    2 +-
 drivers/media/video/et61x251/et61x251_core.c    |    4 +-
 drivers/media/video/gspca/m5602/m5602_core.c    |    4 +-
 drivers/media/video/gspca/m5602/m5602_mt9m111.h |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_po1030.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.h  |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c     |    4 +-
 drivers/media/video/hdpvr/hdpvr-core.c          |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c          |    2 +-
 drivers/media/video/ivtv/ivtvfb.c               |    2 +-
 drivers/media/video/marvell-ccic/mcam-core.c    |    6 +-
 drivers/media/video/msp3400-driver.c            |    6 +-
 drivers/media/video/msp3400-driver.h            |    6 +-
 drivers/media/video/omap/omap_vout.c            |    6 +-
 drivers/media/video/omap/omap_vout_vrfb.c       |    2 +-
 drivers/media/video/ov7670.c                    |    2 +-
 drivers/media/video/saa7115.c                   |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c      |    4 +-
 drivers/media/video/stk-webcam.c                |    4 +-
 drivers/media/video/tm6000/tm6000-alsa.c        |    2 +-
 drivers/media/video/tvp514x.c                   |    2 +-
 drivers/media/video/tvp7002.c                   |    2 +-
 drivers/media/video/upd64083.c                  |    2 +-
 drivers/media/video/via-camera.c                |    4 +-
 drivers/media/video/zoran/zoran_device.c        |    2 +-
 drivers/media/video/zoran/zr36060.c             |    2 +-
 drivers/memstick/host/jmb38x_ms.c               |    2 +-
 drivers/memstick/host/r592.c                    |    2 +-
 drivers/memstick/host/tifm_ms.c                 |    2 +-
 drivers/mfd/janz-cmodio.c                       |    2 +-
 drivers/misc/iwmc3200top/main.c                 |   12 +-
 drivers/misc/lis3lv02d/lis3lv02d.c              |    2 +
 drivers/mmc/core/core.c                         |    6 +-
 drivers/mmc/core/core.h                         |    2 +-
 drivers/mmc/host/tifm_sd.c                      |    4 +-
 drivers/mmc/host/vub300.c                       |   10 +-
 drivers/mtd/nand/pxa3xx_nand.c                  |    2 +-
 drivers/mtd/nand/r852.c                         |    2 +-
 drivers/parport/parport_ip32.c                  |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c                |    2 +-
 drivers/pci/hotplug/acpiphp_core.c              |    2 +-
 drivers/pci/hotplug/acpiphp_ibm.c               |    2 +-
 drivers/pci/hotplug/cpcihp_zt5550.c             |    4 +-
 drivers/pci/hotplug/cpqphp_core.c               |    4 +-
 drivers/pci/hotplug/ibmphp_core.c               |    2 +-
 drivers/pci/hotplug/pci_hotplug_core.c          |    2 +-
 drivers/pci/hotplug/pciehp.h                    |    6 +-
 drivers/pci/hotplug/pciehp_core.c               |    6 +-
 drivers/pci/hotplug/pcihp_skeleton.c            |    2 +-
 drivers/pci/hotplug/rpaphp.h                    |    2 +-
 drivers/pci/hotplug/rpaphp_core.c               |    2 +-
 drivers/pci/hotplug/shpchp.h                    |    4 +-
 drivers/pci/hotplug/shpchp_core.c               |    4 +-
 drivers/pci/pcie/aer/aer_inject.c               |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c              |    4 +-
 drivers/pcmcia/yenta_socket.c                   |    6 +-
 drivers/platform/x86/compal-laptop.c            |    2 +-
 drivers/platform/x86/intel_oaktrail.c           |    2 +-
 drivers/platform/x86/msi-laptop.c               |    2 +-
 drivers/platform/x86/samsung-laptop.c           |    4 +-
 drivers/platform/x86/thinkpad_acpi.c            |   16 +-
 drivers/platform/x86/wmi.c                      |    4 +-
 drivers/power/ds2760_battery.c                  |    2 +-
 drivers/s390/char/raw3270.c                     |    2 +-
 drivers/s390/char/vmwatchdog.c                  |    4 +-
 drivers/s390/cio/cmf.c                          |    2 +-
 drivers/scsi/aha1542.c                          |    2 +-
 drivers/scsi/dc395x.c                           |    2 +-
 drivers/scsi/nsp32.c                            |    4 +-
 drivers/scsi/pcmcia/nsp_cs.c                    |    2 +-
 drivers/staging/comedi/comedi_fops.c            |    2 +-
 drivers/staging/comedi/comedi_fops.h            |    3 +-
 drivers/staging/media/go7007/snd-go7007.c       |    2 +-
 drivers/staging/media/lirc/lirc_bt829.c         |    2 +-
 drivers/staging/media/lirc/lirc_igorplugusb.c   |    4 +-
 drivers/staging/media/lirc/lirc_parallel.c      |    6 +-
 drivers/staging/media/lirc/lirc_serial.c        |   10 +-
 drivers/staging/media/lirc/lirc_sir.c           |    2 +-
 drivers/staging/media/lirc/lirc_zilog.c         |    4 +-
 drivers/staging/quatech_usb2/quatech_usb2.c     |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c         |    2 +-
 drivers/staging/speakup/speakup.h               |    2 +-
 drivers/staging/speakup/synth.c                 |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c        |    2 +-
 drivers/tty/rocket.c                            |    2 +-
 drivers/tty/synclink.c                          |    2 +-
 drivers/tty/synclinkmp.c                        |    2 +-
 drivers/usb/atm/speedtch.c                      |    6 +-
 drivers/usb/atm/ueagle-atm.c                    |    2 +-
 drivers/usb/core/devio.c                        |    2 +-
 drivers/usb/core/hub.c                          |    8 +-
 drivers/usb/core/usb.c                          |    2 +-
 drivers/usb/gadget/amd5536udc.c                 |    8 +-
 drivers/usb/gadget/ether.c                      |    4 +-
 drivers/usb/gadget/file_storage.c               |   10 +-
 drivers/usb/gadget/net2272.c                    |    2 +-
 drivers/usb/gadget/net2280.c                    |    6 +-
 drivers/usb/gadget/omap_udc.c                   |    2 +-
 drivers/usb/gadget/pch_udc.c                    |    2 +-
 drivers/usb/gadget/serial.c                     |    4 +-
 drivers/usb/gadget/zero.c                       |    2 +-
 drivers/usb/host/ehci-hcd.c                     |    2 +-
 drivers/usb/host/ohci-hcd.c                     |    4 +-
 drivers/usb/host/oxu210hp-hcd.c                 |    2 +-
 drivers/usb/host/u132-hcd.c                     |    2 +-
 drivers/usb/host/uhci-hcd.c                     |    2 +-
 drivers/usb/misc/ftdi-elan.c                    |    2 +-
 drivers/usb/misc/iowarrior.c                    |    2 +-
 drivers/usb/musb/cppi_dma.c                     |    2 +-
 drivers/usb/musb/musb_core.c                    |    2 +-
 drivers/usb/serial/aircable.c                   |    2 +-
 drivers/usb/serial/ark3116.c                    |    2 +-
 drivers/usb/serial/belkin_sa.c                  |    2 +-
 drivers/usb/serial/ch341.c                      |    2 +-
 drivers/usb/serial/cp210x.c                     |    2 +-
 drivers/usb/serial/cyberjack.c                  |    2 +-
 drivers/usb/serial/cypress_m8.c                 |    6 +-
 drivers/usb/serial/digi_acceleport.c            |    2 +-
 drivers/usb/serial/empeg.c                      |    2 +-
 drivers/usb/serial/ftdi_sio.c                   |    2 +-
 drivers/usb/serial/funsoft.c                    |    2 +-
 drivers/usb/serial/garmin_gps.c                 |    2 +-
 drivers/usb/serial/io_edgeport.c                |    2 +-
 drivers/usb/serial/io_ti.c                      |    4 +-
 drivers/usb/serial/ipaq.c                       |    2 +-
 drivers/usb/serial/ipw.c                        |    2 +-
 drivers/usb/serial/ir-usb.c                     |    2 +-
 drivers/usb/serial/iuu_phoenix.c                |    6 +-
 drivers/usb/serial/keyspan.c                    |    2 +-
 drivers/usb/serial/keyspan_pda.c                |    2 +-
 drivers/usb/serial/kl5kusb105.c                 |    2 +-
 drivers/usb/serial/mct_u232.c                   |    2 +-
 drivers/usb/serial/mos7720.c                    |    2 +-
 drivers/usb/serial/mos7840.c                    |    2 +-
 drivers/usb/serial/navman.c                     |    2 +-
 drivers/usb/serial/omninet.c                    |    2 +-
 drivers/usb/serial/opticon.c                    |    2 +-
 drivers/usb/serial/option.c                     |    2 +-
 drivers/usb/serial/oti6858.c                    |    2 +-
 drivers/usb/serial/pl2303.c                     |    2 +-
 drivers/usb/serial/qcserial.c                   |    2 +-
 drivers/usb/serial/safe_serial.c                |    6 +-
 drivers/usb/serial/sierra.c                     |    4 +-
 drivers/usb/serial/spcp8x5.c                    |    2 +-
 drivers/usb/serial/ssu100.c                     |    2 +-
 drivers/usb/serial/symbolserial.c               |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 +-
 drivers/usb/serial/usb-serial.c                 |    2 +-
 drivers/usb/serial/usb_wwan.c                   |    2 +-
 drivers/usb/serial/visor.c                      |    2 +-
 drivers/usb/serial/whiteheat.c                  |    2 +-
 drivers/video/aty/atyfb_base.c                  |    4 +-
 drivers/video/aty/radeon_base.c                 |   18 +-
 drivers/video/cirrusfb.c                        |    2 +-
 drivers/video/hgafb.c                           |    2 +-
 drivers/video/intelfb/intelfbdrv.c              |   18 +-
 drivers/video/logo/logo.c                       |    2 +-
 drivers/video/neofb.c                           |   10 +-
 drivers/video/omap/omapfb_main.c                |    4 +-
 drivers/video/omap2/dss/core.c                  |    2 +-
 drivers/video/omap2/dss/dsi.c                   |    4 +-
 drivers/video/omap2/dss/dss.h                   |    2 +-
 drivers/video/omap2/omapfb/omapfb-main.c        |    8 +-
 drivers/video/omap2/omapfb/omapfb.h             |    2 +-
 drivers/video/pm2fb.c                           |    8 +-
 drivers/video/pm3fb.c                           |    4 +-
 drivers/video/riva/fbdev.c                      |    6 +-
 drivers/video/smscufx.c                         |    4 +-
 drivers/video/sstfb.c                           |    6 +-
 drivers/video/tdfxfb.c                          |    2 +-
 drivers/video/udlfb.c                           |    6 +-
 drivers/video/uvesafb.c                         |    6 +-
 drivers/video/vfb.c                             |    2 +-
 drivers/watchdog/f71808e_wdt.c                  |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c                  |    2 +-
 drivers/xen/xen-pciback/conf_space.c            |    2 +-
 drivers/xen/xen-pciback/xenbus.c                |    2 +-
 fs/lockd/mon.c                                  |    2 +-
 fs/nfs/client.c                                 |    2 +-
 fs/nfs/inode.c                                  |    2 +-
 fs/ntfs/super.c                                 |    2 +-
 include/acpi/acpixf.h                           |    2 +-
 include/acpi/apei.h                             |    4 +-
 include/linux/console.h                         |    2 +-
 include/linux/init.h                            |    3 +-
 include/linux/lockd/lockd.h                     |    2 +-
 include/linux/mmc/host.h                        |    2 +-
 include/linux/module.h                          |   21 ++-
 include/linux/moduleparam.h                     |   17 +-
 init/main.c                                     |    2 +-
 kernel/async.c                                  |    2 -
 kernel/debug/kdb/kdb_main.c                     |    2 +-
 kernel/irq/internals.h                          |    2 +-
 kernel/irq/spurious.c                           |    2 +-
 kernel/module.c                                 |  205 ++++++++++++----------
 kernel/params.c                                 |   38 +++-
 kernel/printk.c                                 |   10 +-
 scripts/mod/file2alias.c                        |  212 ++++++++++-------------
 security/apparmor/include/apparmor.h            |   10 +-
 security/apparmor/lsm.c                         |   12 +-
 sound/pci/intel8x0.c                            |    4 +-
 virt/kvm/iommu.c                                |    2 +-
 313 files changed, 793 insertions(+), 755 deletions(-)
