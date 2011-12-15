Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab1LODZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 22:25:31 -0500
Received: from ozlabs.org ([203.10.76.45]:53550 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab1LODXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 22:23:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 12/15] module_param: make bool parameters really bool (drivers & misc)
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 15 Dec 2011 13:48:51 +1030
Message-ID: <87ehw6sesk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

module_param(bool) used to counter-intuitively take an int.  In
fddd5201 (mid-2009) we allowed bool or int/unsigned int using a messy
trick.

It's time to remove the int/unsigned int option.  For this version
it'll simply give a warning, but it'll break next kernel version.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/accessibility/braille/braille_console.c |    2 +-
 drivers/acpi/acpica/acglobal.h                  |    2 +-
 drivers/acpi/apei/ghes.c                        |    2 +-
 drivers/acpi/apei/hest.c                        |    2 +-
 drivers/acpi/dock.c                             |    2 +-
 drivers/acpi/pci_slot.c                         |    2 +-
 drivers/acpi/video.c                            |    6 +++---
 drivers/ata/sata_nv.c                           |    6 +++---
 drivers/ata/sata_sil24.c                        |    2 +-
 drivers/atm/he.c                                |    6 +++---
 drivers/block/drbd/drbd_int.h                   |    4 ++--
 drivers/block/drbd/drbd_main.c                  |    4 ++--
 drivers/block/paride/bpck6.c                    |    2 +-
 drivers/block/paride/pcd.c                      |    4 +++-
 drivers/block/paride/pd.c                       |    3 ++-
 drivers/block/paride/pf.c                       |    4 +++-
 drivers/block/paride/pg.c                       |    3 ++-
 drivers/block/paride/pt.c                       |    4 +++-
 drivers/block/xd.c                              |    2 +-
 drivers/bluetooth/btusb.c                       |   12 ++++++------
 drivers/bluetooth/hci_bcsp.c                    |    4 ++--
 drivers/bluetooth/hci_ldisc.c                   |    2 +-
 drivers/cdrom/cdrom.c                           |   12 ++++++------
 drivers/char/agp/amd64-agp.c                    |    2 +-
 drivers/char/agp/sis-agp.c                      |    2 +-
 drivers/char/i8k.c                              |    8 ++++----
 drivers/char/ipmi/ipmi_si_intf.c                |    2 +-
 drivers/char/lp.c                               |    2 +-
 drivers/char/nwflash.c                          |    2 +-
 drivers/char/pcmcia/synclink_cs.c               |    2 +-
 drivers/char/random.c                           |    2 +-
 drivers/char/tpm/tpm_tis.c                      |    6 +++---
 drivers/edac/r82600_edac.c                      |    2 +-
 drivers/firewire/sbp2.c                         |    2 +-
 drivers/hid/hid-prodikeys.c                     |    2 +-
 drivers/hwmon/abituguru.c                       |    2 +-
 drivers/hwmon/abituguru3.c                      |    4 ++--
 drivers/hwmon/acpi_power_meter.c                |    2 +-
 drivers/hwmon/adm1021.c                         |    2 +-
 drivers/hwmon/ads7828.c                         |    4 ++--
 drivers/hwmon/dme1737.c                         |    4 ++--
 drivers/hwmon/it87.c                            |    4 ++--
 drivers/hwmon/lm93.c                            |    4 ++--
 drivers/hwmon/max1668.c                         |    2 +-
 drivers/hwmon/w83627hf.c                        |    2 +-
 drivers/hwmon/w83781d.c                         |    4 ++--
 drivers/hwmon/w83791d.c                         |    4 ++--
 drivers/hwmon/w83792d.c                         |    2 +-
 drivers/hwmon/w83793.c                          |    2 +-
 drivers/hwmon/w83795.c                          |    2 +-
 drivers/hwmon/w83l786ng.c                       |    2 +-
 drivers/i2c/busses/i2c-highlander.c             |    2 +-
 drivers/i2c/busses/i2c-ibm_iic.c                |    4 ++--
 drivers/i2c/busses/i2c-sis630.c                 |    4 ++--
 drivers/i2c/busses/i2c-viapro.c                 |    2 +-
 drivers/ide/ali14xx.c                           |    2 +-
 drivers/ide/cmd640.c                            |    2 +-
 drivers/ide/dtc2278.c                           |    2 +-
 drivers/ide/gayle.c                             |    2 +-
 drivers/ide/ht6560b.c                           |    2 +-
 drivers/ide/ide-4drives.c                       |    2 +-
 drivers/ide/ide-acpi.c                          |    6 +++---
 drivers/ide/ide-pci-generic.c                   |    2 +-
 drivers/ide/qd65xx.c                            |    2 +-
 drivers/ide/umc8672.c                           |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c          |    8 ++++----
 drivers/infiniband/hw/nes/nes.c                 |    2 +-
 drivers/input/joystick/xpad.c                   |    6 +++---
 drivers/input/misc/wistron_btns.c               |    2 +-
 drivers/input/mouse/psmouse-base.c              |    2 +-
 drivers/input/mouse/synaptics_i2c.c             |    6 +++---
 drivers/input/serio/hp_sdc.c                    |    2 +-
 drivers/input/touchscreen/eeti_ts.c             |    4 ++--
 drivers/input/touchscreen/htcpen.c              |    4 ++--
 drivers/input/touchscreen/ucb1400_ts.c          |    2 +-
 drivers/input/touchscreen/usbtouchscreen.c      |    4 ++--
 drivers/isdn/hardware/avm/b1dma.c               |    2 +-
 drivers/isdn/hardware/avm/c4.c                  |    2 +-
 drivers/isdn/sc/init.c                          |    2 +-
 drivers/leds/leds-clevo-mail.c                  |    2 +-
 drivers/leds/leds-ss4200.c                      |    2 +-
 drivers/macintosh/ams/ams-core.c                |    2 +-
 drivers/macintosh/ams/ams-input.c               |    4 ++--
 drivers/macintosh/therm_adt746x.c               |    2 +-
 drivers/media/dvb/dvb-usb/af9005.c              |    2 +-
 drivers/media/dvb/dvb-usb/af9005.h              |    2 +-
 drivers/media/radio/radio-gemtek.c              |   10 +++++-----
 drivers/media/radio/radio-miropcm20.c           |    2 +-
 drivers/media/rc/lirc_dev.c                     |    2 +-
 drivers/media/rc/mceusb.c                       |    4 ++--
 drivers/media/rc/streamzap.c                    |    4 ++--
 drivers/media/rc/winbond-cir.c                  |    4 ++--
 drivers/media/video/c-qcam.c                    |    2 +-
 drivers/media/video/cs5345.c                    |    2 +-
 drivers/media/video/cs53l32a.c                  |    2 +-
 drivers/media/video/cx18/cx18-driver.c          |    2 +-
 drivers/media/video/cx25821/cx25821-alsa.c      |    2 +-
 drivers/media/video/cx88/cx88-alsa.c            |    2 +-
 drivers/media/video/gspca/m5602/m5602_core.c    |    4 ++--
 drivers/media/video/gspca/m5602/m5602_mt9m111.h |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov7660.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_ov9650.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_po1030.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k4aa.h  |    2 +-
 drivers/media/video/gspca/m5602/m5602_s5k83a.h  |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c     |    4 ++--
 drivers/media/video/hdpvr/hdpvr-core.c          |    2 +-
 drivers/media/video/ivtv/ivtv-driver.c          |    2 +-
 drivers/media/video/ivtv/ivtvfb.c               |    2 +-
 drivers/media/video/marvell-ccic/mcam-core.c    |    6 +++---
 drivers/media/video/msp3400-driver.c            |    6 +++---
 drivers/media/video/msp3400-driver.h            |    6 +++---
 drivers/media/video/omap/omap_vout.c            |    6 +++---
 drivers/media/video/omap/omap_vout_vrfb.c       |    2 +-
 drivers/media/video/ov7670.c                    |    2 +-
 drivers/media/video/saa7115.c                   |    2 +-
 drivers/media/video/stk-webcam.c                |    4 ++--
 drivers/media/video/tm6000/tm6000-alsa.c        |    2 +-
 drivers/media/video/tvp514x.c                   |    2 +-
 drivers/media/video/tvp7002.c                   |    2 +-
 drivers/media/video/upd64083.c                  |    2 +-
 drivers/media/video/via-camera.c                |    4 ++--
 drivers/media/video/zoran/zoran_device.c        |    2 +-
 drivers/media/video/zoran/zr36060.c             |    2 +-
 drivers/memstick/host/jmb38x_ms.c               |    2 +-
 drivers/memstick/host/r592.c                    |    2 +-
 drivers/memstick/host/tifm_ms.c                 |    2 +-
 drivers/misc/iwmc3200top/main.c                 |   12 ++++++------
 drivers/mmc/core/core.c                         |    6 +++---
 drivers/mmc/core/core.h                         |    2 +-
 drivers/mmc/host/tifm_sd.c                      |    4 ++--
 drivers/mmc/host/vub300.c                       |   10 +++++-----
 drivers/mtd/nand/pxa3xx_nand.c                  |    2 +-
 drivers/mtd/nand/r852.c                         |    2 +-
 drivers/parport/parport_ip32.c                  |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c                |    2 +-
 drivers/pci/hotplug/acpiphp_core.c              |    2 +-
 drivers/pci/hotplug/acpiphp_ibm.c               |    2 +-
 drivers/pci/hotplug/cpcihp_zt5550.c             |    4 ++--
 drivers/pci/hotplug/cpqphp_core.c               |    4 ++--
 drivers/pci/hotplug/ibmphp_core.c               |    2 +-
 drivers/pci/hotplug/pci_hotplug_core.c          |    2 +-
 drivers/pci/hotplug/pciehp.h                    |    6 +++---
 drivers/pci/hotplug/pciehp_core.c               |    6 +++---
 drivers/pci/hotplug/pcihp_skeleton.c            |    2 +-
 drivers/pci/hotplug/rpaphp_core.c               |    2 +-
 drivers/pci/hotplug/shpchp.h                    |    4 ++--
 drivers/pci/hotplug/shpchp_core.c               |    4 ++--
 drivers/pci/pcie/aer/aer_inject.c               |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c              |    4 ++--
 drivers/pcmcia/yenta_socket.c                   |    6 +++---
 drivers/platform/x86/compal-laptop.c            |    2 +-
 drivers/platform/x86/intel_oaktrail.c           |    2 +-
 drivers/platform/x86/msi-laptop.c               |    2 +-
 drivers/platform/x86/samsung-laptop.c           |    4 ++--
 drivers/platform/x86/thinkpad_acpi.c            |   16 ++++++++--------
 drivers/platform/x86/wmi.c                      |    4 ++--
 drivers/power/ds2760_battery.c                  |    2 +-
 drivers/s390/char/raw3270.c                     |    2 +-
 drivers/s390/char/vmwatchdog.c                  |    4 ++--
 drivers/scsi/aha1542.c                          |    2 +-
 drivers/scsi/dc395x.c                           |    2 +-
 drivers/scsi/nsp32.c                            |    4 ++--
 drivers/scsi/pcmcia/nsp_cs.c                    |    2 +-
 drivers/staging/comedi/comedi_fops.c            |    2 +-
 drivers/staging/comedi/comedi_fops.h            |    3 ++-
 drivers/staging/media/go7007/snd-go7007.c       |    2 +-
 drivers/staging/media/lirc/lirc_bt829.c         |    2 +-
 drivers/staging/media/lirc/lirc_igorplugusb.c   |    4 ++--
 drivers/staging/media/lirc/lirc_parallel.c      |    4 ++--
 drivers/staging/media/lirc/lirc_serial.c        |   10 +++++-----
 drivers/staging/media/lirc/lirc_sir.c           |    2 +-
 drivers/staging/media/lirc/lirc_zilog.c         |    4 ++--
 drivers/staging/quatech_usb2/quatech_usb2.c     |    2 +-
 drivers/staging/serqt_usb2/serqt_usb2.c         |    2 +-
 drivers/staging/speakup/speakup.h               |    2 +-
 drivers/staging/speakup/synth.c                 |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c        |    2 +-
 drivers/tty/rocket.c                            |    2 +-
 drivers/tty/synclink.c                          |    2 +-
 drivers/tty/synclinkmp.c                        |    2 +-
 drivers/usb/atm/speedtch.c                      |    6 +++---
 drivers/usb/atm/ueagle-atm.c                    |    2 +-
 drivers/usb/core/devio.c                        |    2 +-
 drivers/usb/core/hub.c                          |    8 ++++----
 drivers/usb/core/usb.c                          |    2 +-
 drivers/usb/gadget/amd5536udc.c                 |    8 ++++----
 drivers/usb/gadget/ether.c                      |    4 ++--
 drivers/usb/gadget/file_storage.c               |   10 +++++-----
 drivers/usb/gadget/net2272.c                    |    2 +-
 drivers/usb/gadget/net2280.c                    |    6 +++---
 drivers/usb/gadget/omap_udc.c                   |    2 +-
 drivers/usb/gadget/pch_udc.c                    |    2 +-
 drivers/usb/gadget/serial.c                     |    4 ++--
 drivers/usb/gadget/zero.c                       |    2 +-
 drivers/usb/host/ehci-hcd.c                     |    2 +-
 drivers/usb/host/ohci-hcd.c                     |    4 ++--
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
 drivers/usb/serial/cypress_m8.c                 |    6 +++---
 drivers/usb/serial/digi_acceleport.c            |    2 +-
 drivers/usb/serial/empeg.c                      |    2 +-
 drivers/usb/serial/ftdi_sio.c                   |    2 +-
 drivers/usb/serial/funsoft.c                    |    2 +-
 drivers/usb/serial/garmin_gps.c                 |    2 +-
 drivers/usb/serial/io_edgeport.c                |    2 +-
 drivers/usb/serial/io_ti.c                      |    4 ++--
 drivers/usb/serial/ipaq.c                       |    2 +-
 drivers/usb/serial/ipw.c                        |    2 +-
 drivers/usb/serial/ir-usb.c                     |    2 +-
 drivers/usb/serial/iuu_phoenix.c                |    6 +++---
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
 drivers/usb/serial/safe_serial.c                |    6 +++---
 drivers/usb/serial/sierra.c                     |    4 ++--
 drivers/usb/serial/spcp8x5.c                    |    2 +-
 drivers/usb/serial/ssu100.c                     |    2 +-
 drivers/usb/serial/symbolserial.c               |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c           |    2 +-
 drivers/usb/serial/usb-serial.c                 |    2 +-
 drivers/usb/serial/usb_wwan.c                   |    2 +-
 drivers/usb/serial/visor.c                      |    2 +-
 drivers/usb/serial/whiteheat.c                  |    2 +-
 drivers/video/aty/atyfb_base.c                  |    4 ++--
 drivers/video/aty/radeon_base.c                 |   18 +++++++++---------
 drivers/video/cirrusfb.c                        |    2 +-
 drivers/video/hgafb.c                           |    2 +-
 drivers/video/i810/i810_main.c                  |   10 +++++-----
 drivers/video/intelfb/intelfbdrv.c              |   18 +++++++++---------
 drivers/video/logo/logo.c                       |    2 +-
 drivers/video/neofb.c                           |   10 +++++-----
 drivers/video/omap/omapfb_main.c                |    4 ++--
 drivers/video/omap2/dss/core.c                  |    2 +-
 drivers/video/omap2/dss/dsi.c                   |    4 ++--
 drivers/video/omap2/omapfb/omapfb-main.c        |    8 ++++----
 drivers/video/pm2fb.c                           |    8 ++++----
 drivers/video/pm3fb.c                           |    4 ++--
 drivers/video/riva/fbdev.c                      |    6 +++---
 drivers/video/smscufx.c                         |    4 ++--
 drivers/video/sstfb.c                           |    6 +++---
 drivers/video/tdfxfb.c                          |    2 +-
 drivers/video/udlfb.c                           |    6 +++---
 drivers/video/uvesafb.c                         |    6 +++---
 drivers/video/vfb.c                             |    2 +-
 drivers/watchdog/f71808e_wdt.c                  |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c                  |    2 +-
 drivers/xen/xen-pciback/conf_space.c            |    2 +-
 drivers/xen/xen-pciback/xenbus.c                |    2 +-
 fs/lockd/mon.c                                  |    2 +-
 fs/nfs/client.c                                 |    2 +-
 fs/nfs/inode.c                                  |    2 +-
 include/acpi/acpixf.h                           |    2 +-
 include/acpi/apei.h                             |    4 ++--
 include/linux/console.h                         |    2 +-
 include/linux/lockd/lockd.h                     |    2 +-
 include/linux/mmc/host.h                        |    2 +-
 security/apparmor/include/apparmor.h            |   10 +++++-----
 security/apparmor/lsm.c                         |   12 ++++++------
 virt/kvm/iommu.c                                |    2 +-
 281 files changed, 474 insertions(+), 465 deletions(-)

diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -44,7 +44,7 @@ MODULE_LICENSE("GPL");
  */
 
 /* Emit various sounds */
-static int sound;
+static bool sound;
 module_param(sound, bool, 0);
 MODULE_PARM_DESC(sound, "emit sounds");
 
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -108,7 +108,7 @@ u8 ACPI_INIT_GLOBAL(acpi_gbl_use_default
 /*
  * Optionally enable output from the AML Debug Object.
  */
-u32 ACPI_INIT_GLOBAL(acpi_gbl_enable_aml_debug_object, FALSE);
+bool ACPI_INIT_GLOBAL(acpi_gbl_enable_aml_debug_object, FALSE);
 
 /*
  * Optionally copy the entire DSDT to local memory (instead of simply
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -118,7 +118,7 @@ struct ghes_estatus_cache {
 	struct rcu_head rcu;
 };
 
-int ghes_disable;
+bool ghes_disable;
 module_param_named(disable, ghes_disable, bool, 0);
 
 static int ghes_panic_timeout	__read_mostly = 30;
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -41,7 +41,7 @@
 
 #define HEST_PFX "HEST: "
 
-int hest_disable;
+bool hest_disable;
 EXPORT_SYMBOL_GPL(hest_disable);
 
 /* HEST table parsing */
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -43,7 +43,7 @@ MODULE_AUTHOR("Kristen Carlson Accardi")
 MODULE_DESCRIPTION(ACPI_DOCK_DRIVER_DESCRIPTION);
 MODULE_LICENSE("GPL");
 
-static int immediate_undock = 1;
+static bool immediate_undock = 1;
 module_param(immediate_undock, bool, 0644);
 MODULE_PARM_DESC(immediate_undock, "1 (default) will cause the driver to "
 	"undock immediately when the undock button is pressed, 0 will cause"
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -34,7 +34,7 @@
 #include <acpi/acpi_drivers.h>
 #include <linux/dmi.h>
 
-static int debug;
+static bool debug;
 static int check_sta_before_sun;
 
 #define DRIVER_VERSION 	"0.1"
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -69,21 +69,21 @@ MODULE_AUTHOR("Bruno Ducrot");
 MODULE_DESCRIPTION("ACPI Video Driver");
 MODULE_LICENSE("GPL");
 
-static int brightness_switch_enabled = 1;
+static bool brightness_switch_enabled = 1;
 module_param(brightness_switch_enabled, bool, 0644);
 
 /*
  * By default, we don't allow duplicate ACPI video bus devices
  * under the same VGA controller
  */
-static int allow_duplicates;
+static bool allow_duplicates;
 module_param(allow_duplicates, bool, 0644);
 
 /*
  * Some BIOSes claim they use minimum backlight at boot,
  * and this may bring dimming screen after boot
  */
-static int use_bios_initial_backlight = 1;
+static bool use_bios_initial_backlight = 1;
 module_param(use_bios_initial_backlight, bool, 0644);
 
 static int register_count = 0;
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -599,9 +599,9 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, nv_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-static int adma_enabled;
-static int swncq_enabled = 1;
-static int msi_enabled;
+static bool adma_enabled;
+static bool swncq_enabled = 1;
+static bool msi_enabled;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -417,7 +417,7 @@ static struct ata_port_operations sil24_
 #endif
 };
 
-static int sata_sil24_msi;    /* Disable MSI */
+static bool sata_sil24_msi;    /* Disable MSI */
 module_param_named(msi, sata_sil24_msi, bool, S_IRUGO);
 MODULE_PARM_DESC(msi, "Enable MSI (Default: false)");
 
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -112,12 +112,12 @@ static u8 read_prom_byte(struct he_dev *
 /* globals */
 
 static struct he_dev *he_devs;
-static int disable64;
+static bool disable64;
 static short nvpibits = -1;
 static short nvcibits = -1;
 static short rx_skb_reserve = 16;
-static int irq_coalesce = 1;
-static int sdh = 0;
+static bool irq_coalesce = 1;
+static bool sdh = 0;
 
 /* Read from EEPROM = 0000 0011b */
 static unsigned int readtab[] = {
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -59,8 +59,8 @@
 
 /* module parameter, defined in drbd_main.c */
 extern unsigned int minor_count;
-extern int disable_sendpage;
-extern int allow_oos;
+extern bool disable_sendpage;
+extern bool allow_oos;
 extern unsigned int cn_idx;
 
 #ifdef CONFIG_DRBD_FAULT_INJECTION
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -117,8 +117,8 @@ module_param(fault_devs, int, 0644);
 
 /* module parameter, defined */
 unsigned int minor_count = DRBD_MINOR_COUNT_DEF;
-int disable_sendpage;
-int allow_oos;
+bool disable_sendpage;
+bool allow_oos;
 unsigned int cn_idx = CN_IDX_DRBD;
 int proc_details;       /* Detail level in proc drbd*/
 
diff --git a/drivers/block/paride/bpck6.c b/drivers/block/paride/bpck6.c
--- a/drivers/block/paride/bpck6.c
+++ b/drivers/block/paride/bpck6.c
@@ -21,7 +21,7 @@
 
 
 /* PARAMETERS */
-static int verbose; /* set this to 1 to see debugging messages and whatnot */
+static bool verbose; /* set this to 1 to see debugging messages and whatnot */
 
 #define BACKPACK_VERSION "2.0.2"
 
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -105,13 +105,14 @@
 #define PCD_NAME	"pcd"
 #define PCD_UNITS	4
 
+#include <linux/types.h>
 /* Here are things one can override from the insmod command.
    Most are autoprobed by paride unless set here.  Verbose is off
    by default.
 
 */
 
-static int verbose = 0;
+static bool verbose = 0;
 static int major = PCD_MAJOR;
 static char *name = PCD_NAME;
 static int nice = 0;
@@ -139,6 +140,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV,
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/types.h>
 #include <asm/uaccess.h>
 
 static DEFINE_MUTEX(pcd_mutex);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -124,8 +124,9 @@
    by default.
 
 */
+#include <linux/types.h>
 
-static int verbose = 0;
+static bool verbose = 0;
 static int major = PD_MAJOR;
 static char *name = PD_NAME;
 static int cluster = 64;
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -118,13 +118,15 @@
 #define PF_NAME		"pf"
 #define PF_UNITS	4
 
+#include <linux/types.h>
+
 /* Here are things one can override from the insmod command.
    Most are autoprobed by paride unless set here.  Verbose is off
    by default.
 
 */
 
-static int verbose = 0;
+static bool verbose = 0;
 static int major = PF_MAJOR;
 static char *name = PF_NAME;
 static int cluster = 64;
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -130,13 +130,14 @@
 #define PI_PG	4
 #endif
 
+#include <linux/types.h>
 /* Here are things one can override from the insmod command.
    Most are autoprobed by paride unless set here.  Verbose is 0
    by default.
 
 */
 
-static int verbose = 0;
+static bool verbose = 0;
 static int major = PG_MAJOR;
 static char *name = PG_NAME;
 static int disable = 0;
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -109,13 +109,15 @@
 #define PT_NAME		"pt"
 #define PT_UNITS	4
 
+#include <linux/types.h>
+
 /* Here are things one can override from the insmod command.
    Most are autoprobed by paride unless set here.  Verbose is on
    by default.
 
 */
 
-static int verbose = 0;
+static bool verbose = 0;
 static int major = PT_MAJOR;
 static char *name = PT_NAME;
 static int disable = 0;
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -148,7 +148,7 @@ static volatile int xdc_busy;
 static struct timer_list xd_watchdog_int;
 
 static volatile u_char xd_error;
-static int nodma = XD_DONT_USE_DMA;
+static bool nodma = XD_DONT_USE_DMA;
 
 static struct request_queue *xd_queue;
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -37,13 +37,13 @@
 
 #define VERSION "0.6"
 
-static int ignore_dga;
-static int ignore_csr;
-static int ignore_sniffer;
-static int disable_scofix;
-static int force_scofix;
+static bool ignore_dga;
+static bool ignore_csr;
+static bool ignore_sniffer;
+static bool disable_scofix;
+static bool force_scofix;
 
-static int reset = 1;
+static bool reset = 1;
 
 static struct usb_driver btusb_driver;
 
diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -49,8 +49,8 @@
 
 #define VERSION "0.3"
 
-static int txcrc = 1;
-static int hciextn = 1;
+static bool txcrc = 1;
+static bool hciextn = 1;
 
 #define BCSP_TXWINSIZE	4
 
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -48,7 +48,7 @@
 
 #define VERSION "2.2"
 
-static int reset = 0;
+static bool reset = 0;
 
 static struct hci_uart_proto *hup[HCI_UART_MAX_PROTO];
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -286,17 +286,17 @@ 2.50 Oct 19, 1998 - Jens Axboe <axboe@im
 #include <asm/uaccess.h>
 
 /* used to tell the module to turn on full debugging messages */
-static int debug;
+static bool debug;
 /* used to keep tray locked at all times */
 static int keeplocked;
 /* default compatibility mode */
-static int autoclose=1;
-static int autoeject;
-static int lockdoor = 1;
+static bool autoclose=1;
+static bool autoeject;
+static bool lockdoor = 1;
 /* will we ever get to use this... sigh. */
-static int check_media_type;
+static bool check_media_type;
 /* automatically restart mrw format */
-static int mrw_format_restart = 1;
+static bool mrw_format_restart = 1;
 module_param(debug, bool, 0);
 module_param(autoclose, bool, 0);
 module_param(autoeject, bool, 0);
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -33,7 +33,7 @@
 #define ULI_X86_64_ENU_SCR_REG		0x54
 
 static struct resource *aperture_resource;
-static int __initdata agp_try_unsupported = 1;
+static bool __initdata agp_try_unsupported = 1;
 static int agp_bridges_found;
 
 static void amd64_tlbflush(struct agp_memory *temp)
diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -17,7 +17,7 @@
 #define PCI_DEVICE_ID_SI_662	0x0662
 #define PCI_DEVICE_ID_SI_671	0x0671
 
-static int __devinitdata agp_sis_force_delay = 0;
+static bool __devinitdata agp_sis_force_delay = 0;
 static int __devinitdata agp_sis_agp_spec = -1;
 
 static int sis_fetch_size(void)
diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -69,19 +69,19 @@ MODULE_AUTHOR("Massimo Dal Zotto (dz@deb
 MODULE_DESCRIPTION("Driver for accessing SMM BIOS on Dell laptops");
 MODULE_LICENSE("GPL");
 
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force loading without checking for supported models");
 
-static int ignore_dmi;
+static bool ignore_dmi;
 module_param(ignore_dmi, bool, 0);
 MODULE_PARM_DESC(ignore_dmi, "Continue probing hardware even if DMI data does not match");
 
-static int restricted;
+static bool restricted;
 module_param(restricted, bool, 0);
 MODULE_PARM_DESC(restricted, "Allow fan control if SYS_ADMIN capability set");
 
-static int power_status;
+static bool power_status;
 module_param(power_status, bool, 0600);
 MODULE_PARM_DESC(power_status, "Report power status in /proc/i8k");
 
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1227,7 +1227,7 @@ static int smi_num; /* Used to sequence 
 #define DEFAULT_REGSPACING	1
 #define DEFAULT_REGSIZE		1
 
-static int           si_trydefaults = 1;
+static bool          si_trydefaults = 1;
 static char          *si_type[SI_MAX_PARMS];
 #define MAX_SI_TYPE_STR 30
 static char          si_type_str[MAX_SI_TYPE_STR];
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -829,7 +829,7 @@ static struct console lpcons = {
 
 static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
 static char *parport[LP_NO];
-static int reset;
+static bool reset;
 
 module_param_array(parport, charp, NULL, 0);
 module_param(reset, bool, 0);
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -51,7 +51,7 @@ static int write_block(unsigned long p, 
 #define KFLASH_ID	0x89A6		//Intel flash
 #define KFLASH_ID4	0xB0D4		//Intel flash 4Meg
 
-static int flashdebug;		//if set - we will display progress msgs
+static bool flashdebug;		//if set - we will display progress msgs
 
 static int gbWriteEnable;
 static int gbWriteBase64Enable;
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -439,7 +439,7 @@ static int mgslpc_device_count = 0;
  * .text section address and breakpoint on module load.
  * This is useful for use with gdb and add-symbol-file command.
  */
-static int break_on_load=0;
+static bool break_on_load=0;
 
 /*
  * Driver major number, defaults to zero to get auto
diff --git a/drivers/char/random.c b/drivers/char/random.c
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -387,7 +387,7 @@ static DECLARE_WAIT_QUEUE_HEAD(random_wr
 static struct fasync_struct *fasync;
 
 #if 0
-static int debug;
+static bool debug;
 module_param(debug, bool, 0644);
 #define DEBUG_ENT(fmt, arg...) do { \
 	if (debug) \
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -297,7 +297,7 @@ out:
 	return size;
 }
 
-static int itpm;
+static bool itpm;
 module_param(itpm, bool, 0444);
 MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
 
@@ -539,7 +539,7 @@ static irqreturn_t tis_int_handler(int d
 	return IRQ_HANDLED;
 }
 
-static int interrupts = 1;
+static bool interrupts = 1;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
@@ -858,7 +858,7 @@ static struct platform_driver tis_drv = 
 
 static struct platform_device *pdev;
 
-static int force;
+static bool force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
 static int __init init_tis(void)
diff --git a/drivers/edac/r82600_edac.c b/drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c
+++ b/drivers/edac/r82600_edac.c
@@ -131,7 +131,7 @@ struct r82600_error_info {
 	u32 eapr;
 };
 
-static unsigned int disable_hardware_scrub;
+static bool disable_hardware_scrub;
 
 static struct edac_pci_ctl_info *r82600_pci;
 
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -66,7 +66,7 @@
  *
  * Concurrent logins are useful together with cluster filesystems.
  */
-static int sbp2_param_exclusive_login = 1;
+static bool sbp2_param_exclusive_login = 1;
 module_param_named(exclusive_login, sbp2_param_exclusive_login, bool, 0644);
 MODULE_PARM_DESC(exclusive_login, "Exclusive login to sbp2 device "
 		 "(default = Y, use N for concurrent initiators)");
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -90,7 +90,7 @@ static const char longname[] = "Prodikey
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 module_param_array(id, charp, NULL, 0444);
diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -145,7 +145,7 @@ static const u8 abituguru_pwm_max[5] = {
 
 
 /* Insmod parameters */
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Set to one to force detection.");
 static int bank1_types[ABIT_UGURU_MAX_BANK1_SENSORS] = { -1, -1, -1, -1, -1,
diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -603,11 +603,11 @@ static const struct abituguru3_motherboa
 
 
 /* Insmod parameters */
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Set to one to force detection.");
 /* Default verbose is 1, since this driver is still in the testing phase */
-static int verbose = 1;
+static bool verbose = 1;
 module_param(verbose, bool, 0644);
 MODULE_PARM_DESC(verbose, "Enable/disable verbose error reporting");
 
diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
--- a/drivers/hwmon/acpi_power_meter.c
+++ b/drivers/hwmon/acpi_power_meter.c
@@ -58,7 +58,7 @@ ACPI_MODULE_NAME(ACPI_POWER_METER_NAME);
 #define POWER_ALARM_NAME	"power1_alarm"
 
 static int cap_in_hardware;
-static int force_cap_on;
+static bool force_cap_on;
 
 static int can_cap_in_hardware(void)
 {
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -103,7 +103,7 @@ static int adm1021_remove(struct i2c_cli
 static struct adm1021_data *adm1021_update_device(struct device *dev);
 
 /* (amalysh) read only mode, otherwise any limit's writing confuse BIOS */
-static int read_only;
+static bool read_only;
 
 
 static const struct i2c_device_id adm1021_id[] = {
diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -48,8 +48,8 @@ static const unsigned short normal_i2c[]
 	I2C_CLIENT_END };
 
 /* Module parameters */
-static int se_input = 1; /* Default is SE, 0 == diff */
-static int int_vref = 1; /* Default is internal ref ON */
+static bool se_input = 1; /* Default is SE, 0 == diff */
+static bool int_vref = 1; /* Default is internal ref ON */
 static int vref_mv = ADS7828_INT_VREF_MV; /* set if vref != 2.5V */
 module_param(se_input, bool, S_IRUGO);
 module_param(int_vref, bool, S_IRUGO);
diff --git a/drivers/hwmon/dme1737.c b/drivers/hwmon/dme1737.c
--- a/drivers/hwmon/dme1737.c
+++ b/drivers/hwmon/dme1737.c
@@ -45,7 +45,7 @@
 static struct platform_device *pdev;
 
 /* Module load parameters */
-static int force_start;
+static bool force_start;
 module_param(force_start, bool, 0);
 MODULE_PARM_DESC(force_start, "Force the chip to start monitoring inputs");
 
@@ -53,7 +53,7 @@ static unsigned short force_id;
 module_param(force_id, ushort, 0);
 MODULE_PARM_DESC(force_id, "Override the detected device ID");
 
-static int probe_all_addr;
+static bool probe_all_addr;
 module_param(probe_all_addr, bool, 0);
 MODULE_PARM_DESC(probe_all_addr, "Include probing of non-standard LPC "
 		 "addresses");
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -146,10 +146,10 @@ static inline void superio_exit(void)
 #define IT87_SIO_BEEP_PIN_REG	0xf6	/* Beep pin mapping */
 
 /* Update battery voltage after every reading if true */
-static int update_vbat;
+static bool update_vbat;
 
 /* Not all BIOSes properly configure the PWM registers */
-static int fix_pwm_polarity;
+static bool fix_pwm_polarity;
 
 /* Many IT87 constants specified below */
 
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -151,12 +151,12 @@ static const unsigned short normal_i2c[]
 
 /* Insmod parameters */
 
-static int disable_block;
+static bool disable_block;
 module_param(disable_block, bool, 0);
 MODULE_PARM_DESC(disable_block,
 	"Set to non-zero to disable SMBus block data transactions.");
 
-static int init;
+static bool init;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to non-zero to force chip initialization.");
 
diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -59,7 +59,7 @@ static unsigned short max1668_addr_list[
 #define DEV_ID_MAX1989		0xb
 
 /* read only mode module parameter */
-static int read_only;
+static bool read_only;
 module_param(read_only, bool, 0);
 MODULE_PARM_DESC(read_only, "Don't set any values, read only mode");
 
diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -71,7 +71,7 @@ module_param(force_i2c, byte, 0);
 MODULE_PARM_DESC(force_i2c,
 		 "Initialize the i2c address of the sensors");
 
-static int init = 1;
+static bool init = 1;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to zero to bypass chip initialization");
 
diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -67,11 +67,11 @@ module_param_array(force_subclients, sho
 MODULE_PARM_DESC(force_subclients, "List of subclient addresses: "
 		    "{bus, clientaddr, subclientaddr1, subclientaddr2}");
 
-static int reset;
+static bool reset;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset, "Set to one to reset chip on load");
 
-static int init = 1;
+static bool init = 1;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to zero to bypass chip initialization");
 
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -58,11 +58,11 @@ module_param_array(force_subclients, sho
 MODULE_PARM_DESC(force_subclients, "List of subclient addresses: "
 			"{bus, clientaddr, subclientaddr1, subclientaddr2}");
 
-static int reset;
+static bool reset;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset, "Set to one to force a hardware chip reset");
 
-static int init;
+static bool init;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to one to force extra software initialization");
 
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -56,7 +56,7 @@ module_param_array(force_subclients, sho
 MODULE_PARM_DESC(force_subclients, "List of subclient addresses: "
 			"{bus, clientaddr, subclientaddr1, subclientaddr2}");
 
-static int init;
+static bool init;
 module_param(init, bool, 0);
 MODULE_PARM_DESC(init, "Set to one to force chip initialization");
 
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -61,7 +61,7 @@ module_param_array(force_subclients, sho
 MODULE_PARM_DESC(force_subclients, "List of subclient addresses: "
 		       "{bus, clientaddr, subclientaddr1, subclientaddr2}");
 
-static int reset;
+static bool reset;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset, "Set to 1 to reset chip, not recommended");
 
diff --git a/drivers/hwmon/w83795.c b/drivers/hwmon/w83795.c
--- a/drivers/hwmon/w83795.c
+++ b/drivers/hwmon/w83795.c
@@ -42,7 +42,7 @@ static const unsigned short normal_i2c[]
 };
 
 
-static int reset;
+static bool reset;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset, "Set to 1 to reset chip, not recommended");
 
diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -39,7 +39,7 @@ static const unsigned short normal_i2c[]
 
 /* Insmod parameters */
 
-static int reset;
+static bool reset;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset, "Set to 1 to reset chip, not recommended");
 
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -52,7 +52,7 @@ struct highlander_i2c_dev {
 	size_t			buf_len;
 };
 
-static int iic_force_poll, iic_force_normal;
+static bool iic_force_poll, iic_force_normal;
 static int iic_timeout = 1000, iic_read_delay;
 
 static inline void highlander_i2c_irq_enable(struct highlander_i2c_dev *dev)
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -51,11 +51,11 @@
 MODULE_DESCRIPTION("IBM IIC driver v" DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-static int iic_force_poll;
+static bool iic_force_poll;
 module_param(iic_force_poll, bool, 0);
 MODULE_PARM_DESC(iic_force_poll, "Force polling mode");
 
-static int iic_force_fast;
+static bool iic_force_fast;
 module_param(iic_force_fast, bool, 0);
 MODULE_PARM_DESC(iic_force_fast, "Force fast mode (400 kHz)");
 
diff --git a/drivers/i2c/busses/i2c-sis630.c b/drivers/i2c/busses/i2c-sis630.c
--- a/drivers/i2c/busses/i2c-sis630.c
+++ b/drivers/i2c/busses/i2c-sis630.c
@@ -93,8 +93,8 @@
 static struct pci_driver sis630_driver;
 
 /* insmod parameters */
-static int high_clock;
-static int force;
+static bool high_clock;
+static bool force;
 module_param(high_clock, bool, 0);
 MODULE_PARM_DESC(high_clock, "Set Host Master Clock to 56KHz (default 14KHz).");
 module_param(force, bool, 0);
diff --git a/drivers/i2c/busses/i2c-viapro.c b/drivers/i2c/busses/i2c-viapro.c
--- a/drivers/i2c/busses/i2c-viapro.c
+++ b/drivers/i2c/busses/i2c-viapro.c
@@ -91,7 +91,7 @@ static unsigned short SMBHSTCFG = 0xD2;
 
 /* If force is set to anything different from 0, we forcibly enable the
    VT596. DANGEROUS! */
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Forcibly enable the SMBus. DANGEROUS!");
 
diff --git a/drivers/ide/ali14xx.c b/drivers/ide/ali14xx.c
--- a/drivers/ide/ali14xx.c
+++ b/drivers/ide/ali14xx.c
@@ -221,7 +221,7 @@ static int __init ali14xx_probe(void)
 	return ide_legacy_device_add(&ali14xx_port_info, 0);
 }
 
-static int probe_ali14xx;
+static bool probe_ali14xx;
 
 module_param_named(probe, probe_ali14xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for ALI M14xx chipsets");
diff --git a/drivers/ide/cmd640.c b/drivers/ide/cmd640.c
--- a/drivers/ide/cmd640.c
+++ b/drivers/ide/cmd640.c
@@ -111,7 +111,7 @@
 
 #define DRV_NAME "cmd640"
 
-static int cmd640_vlb;
+static bool cmd640_vlb;
 
 /*
  * CMD640 specific registers definition.
diff --git a/drivers/ide/dtc2278.c b/drivers/ide/dtc2278.c
--- a/drivers/ide/dtc2278.c
+++ b/drivers/ide/dtc2278.c
@@ -130,7 +130,7 @@ static int __init dtc2278_probe(void)
 	return ide_legacy_device_add(&dtc2278_port_info, 0);
 }
 
-static int probe_dtc2278;
+static bool probe_dtc2278;
 
 module_param_named(probe, probe_dtc2278, bool, 0);
 MODULE_PARM_DESC(probe, "probe for DTC2278xx chipsets");
diff --git a/drivers/ide/gayle.c b/drivers/ide/gayle.c
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -50,7 +50,7 @@
 					       GAYLE_NUM_HWIFS-1)
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
 
-static int ide_doubler;
+static bool ide_doubler;
 module_param_named(doubler, ide_doubler, bool, 0);
 MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
 
diff --git a/drivers/ide/ht6560b.c b/drivers/ide/ht6560b.c
--- a/drivers/ide/ht6560b.c
+++ b/drivers/ide/ht6560b.c
@@ -317,7 +317,7 @@ static void __init ht6560b_init_dev(ide_
 	ide_set_drivedata(drive, (void *)t);
 }
 
-static int probe_ht6560b;
+static bool probe_ht6560b;
 
 module_param_named(probe, probe_ht6560b, bool, 0);
 MODULE_PARM_DESC(probe, "probe for HT6560B chipset");
diff --git a/drivers/ide/ide-4drives.c b/drivers/ide/ide-4drives.c
--- a/drivers/ide/ide-4drives.c
+++ b/drivers/ide/ide-4drives.c
@@ -6,7 +6,7 @@
 
 #define DRV_NAME "ide-4drives"
 
-static int probe_4drives;
+static bool probe_4drives;
 
 module_param_named(probe, probe_4drives, bool, 0);
 MODULE_PARM_DESC(probe, "probe for generic IDE chipset with 4 drives/port");
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -53,15 +53,15 @@ struct ide_acpi_hwif_link {
 #define DEBPRINT(fmt, args...)	do {} while (0)
 #endif	/* DEBUGGING */
 
-static int ide_noacpi;
+static bool ide_noacpi;
 module_param_named(noacpi, ide_noacpi, bool, 0);
 MODULE_PARM_DESC(noacpi, "disable IDE ACPI support");
 
-static int ide_acpigtf;
+static bool ide_acpigtf;
 module_param_named(acpigtf, ide_acpigtf, bool, 0);
 MODULE_PARM_DESC(acpigtf, "enable IDE ACPI _GTF support");
 
-static int ide_acpionboot;
+static bool ide_acpionboot;
 module_param_named(acpionboot, ide_acpionboot, bool, 0);
 MODULE_PARM_DESC(acpionboot, "call IDE ACPI methods on boot");
 
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -28,7 +28,7 @@
 
 #define DRV_NAME "ide_pci_generic"
 
-static int ide_generic_all;		/* Set to claim all devices */
+static bool ide_generic_all;		/* Set to claim all devices */
 
 module_param_named(all_generic_ide, ide_generic_all, bool, 0444);
 MODULE_PARM_DESC(all_generic_ide, "IDE generic will claim all unknown PCI IDE storage controllers.");
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -417,7 +417,7 @@ static int __init qd_probe(int base)
 	return rc;
 }
 
-static int probe_qd65xx;
+static bool probe_qd65xx;
 
 module_param_named(probe, probe_qd65xx, bool, 0);
 MODULE_PARM_DESC(probe, "probe for QD65xx chipsets");
diff --git a/drivers/ide/umc8672.c b/drivers/ide/umc8672.c
--- a/drivers/ide/umc8672.c
+++ b/drivers/ide/umc8672.c
@@ -160,7 +160,7 @@ static int __init umc8672_probe(void)
 	return ide_legacy_device_add(&umc8672_port_info, 0);
 }
 
-static int probe_umc8672;
+static bool probe_umc8672;
 
 module_param_named(probe, probe_umc8672, bool, 0);
 MODULE_PARM_DESC(probe, "probe for UMC8672 chipset");
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -59,16 +59,16 @@ MODULE_AUTHOR("Christoph Raisch <raisch@
 MODULE_DESCRIPTION("IBM eServer HCA InfiniBand Device Driver");
 MODULE_VERSION(HCAD_VERSION);
 
-static int ehca_open_aqp1     = 0;
+static bool ehca_open_aqp1    = 0;
 static int ehca_hw_level      = 0;
-static int ehca_poll_all_eqs  = 1;
+static bool ehca_poll_all_eqs = 1;
 
 int ehca_debug_level   = 0;
 int ehca_nr_ports      = -1;
-int ehca_use_hp_mr     = 0;
+bool ehca_use_hp_mr    = 0;
 int ehca_port_act_time = 30;
 int ehca_static_rate   = -1;
-int ehca_scaling_code  = 0;
+bool ehca_scaling_code = 0;
 int ehca_lock_hcalls   = -1;
 int ehca_max_cq        = -1;
 int ehca_max_qp        = -1;
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -96,7 +96,7 @@ unsigned int wqm_quanta = 0x10000;
 module_param(wqm_quanta, int, 0644);
 MODULE_PARM_DESC(wqm_quanta, "WQM quanta");
 
-static unsigned int limit_maxrdreqsz;
+static bool limit_maxrdreqsz;
 module_param(limit_maxrdreqsz, bool, 0644);
 MODULE_PARM_DESC(limit_maxrdreqsz, "Limit max read request size to 256 Bytes");
 
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -98,15 +98,15 @@
 #define XTYPE_XBOX360W    2
 #define XTYPE_UNKNOWN     3
 
-static int dpad_to_buttons;
+static bool dpad_to_buttons;
 module_param(dpad_to_buttons, bool, S_IRUGO);
 MODULE_PARM_DESC(dpad_to_buttons, "Map D-PAD to buttons rather than axes for unknown pads");
 
-static int triggers_to_buttons;
+static bool triggers_to_buttons;
 module_param(triggers_to_buttons, bool, S_IRUGO);
 MODULE_PARM_DESC(triggers_to_buttons, "Map triggers to buttons rather than axes for unknown pads");
 
-static int sticks_to_null;
+static bool sticks_to_null;
 module_param(sticks_to_null, bool, S_IRUGO);
 MODULE_PARM_DESC(sticks_to_null, "Do not map sticks at all for unknown pads");
 
diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -48,7 +48,7 @@ MODULE_DESCRIPTION("Wistron laptop butto
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION("0.3");
 
-static int force; /* = 0; */
+static bool force; /* = 0; */
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Load even if computer is not in database");
 
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -60,7 +60,7 @@ static unsigned int psmouse_rate = 100;
 module_param_named(rate, psmouse_rate, uint, 0644);
 MODULE_PARM_DESC(rate, "Report rate, in reports per second.");
 
-static unsigned int psmouse_smartscroll = 1;
+static bool psmouse_smartscroll = 1;
 module_param_named(smartscroll, psmouse_smartscroll, bool, 0644);
 MODULE_PARM_DESC(smartscroll, "Logitech Smartscroll autorepeat, 1 = enabled (default), 0 = disabled.");
 
diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -185,17 +185,17 @@
 #define NO_DATA_SLEEP_MSECS	(MSEC_PER_SEC / 4)
 
 /* Control touchpad's No Deceleration option */
-static int no_decel = 1;
+static bool no_decel = 1;
 module_param(no_decel, bool, 0644);
 MODULE_PARM_DESC(no_decel, "No Deceleration. Default = 1 (on)");
 
 /* Control touchpad's Reduced Reporting option */
-static int reduce_report;
+static bool reduce_report;
 module_param(reduce_report, bool, 0644);
 MODULE_PARM_DESC(reduce_report, "Reduced Reporting. Default = 0 (off)");
 
 /* Control touchpad's No Filter option */
-static int no_filter;
+static bool no_filter;
 module_param(no_filter, bool, 0644);
 MODULE_PARM_DESC(no_filter, "No Filter. Default = 0 (off)");
 
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -105,7 +105,7 @@ EXPORT_SYMBOL(__hp_sdc_enqueue_transacti
 EXPORT_SYMBOL(hp_sdc_enqueue_transaction);
 EXPORT_SYMBOL(hp_sdc_dequeue_transaction);
 
-static unsigned int hp_sdc_disabled;
+static bool hp_sdc_disabled;
 module_param_named(no_hpsdc, hp_sdc_disabled, bool, 0);
 MODULE_PARM_DESC(no_hpsdc, "Do not enable HP SDC driver.");
 
diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -35,11 +35,11 @@
 #include <linux/input/eeti_ts.h>
 #include <linux/slab.h>
 
-static int flip_x;
+static bool flip_x;
 module_param(flip_x, bool, 0644);
 MODULE_PARM_DESC(flip_x, "flip x coordinate");
 
-static int flip_y;
+static bool flip_y;
 module_param(flip_y, bool, 0644);
 MODULE_PARM_DESC(flip_y, "flip y coordinate");
 
diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -40,10 +40,10 @@ MODULE_LICENSE("GPL");
 #define X_AXIS_MAX		2040
 #define Y_AXIS_MAX		2040
 
-static int invert_x;
+static bool invert_x;
 module_param(invert_x, bool, 0644);
 MODULE_PARM_DESC(invert_x, "If set, X axis is inverted");
-static int invert_y;
+static bool invert_y;
 module_param(invert_y, bool, 0644);
 MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
 
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -30,7 +30,7 @@
 #include <linux/freezer.h>
 #include <linux/ucb1400.h>
 
-static int adcsync;
+static bool adcsync;
 static int ts_delay = 55; /* us */
 static int ts_delay_pressure;	/* us */
 
diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -59,11 +59,11 @@
 #define DRIVER_AUTHOR		"Daniel Ritz <daniel.ritz@gmx.ch>"
 #define DRIVER_DESC		"USB Touchscreen Driver"
 
-static int swap_xy;
+static bool swap_xy;
 module_param(swap_xy, bool, 0644);
 MODULE_PARM_DESC(swap_xy, "If set X and Y axes are swapped.");
 
-static int hwcalib_xy;
+static bool hwcalib_xy;
 module_param(hwcalib_xy, bool, 0644);
 MODULE_PARM_DESC(hwcalib_xy, "If set hw-calibrated X/Y are used if available");
 
diff --git a/drivers/isdn/hardware/avm/b1dma.c b/drivers/isdn/hardware/avm/b1dma.c
--- a/drivers/isdn/hardware/avm/b1dma.c
+++ b/drivers/isdn/hardware/avm/b1dma.c
@@ -40,7 +40,7 @@ MODULE_DESCRIPTION("CAPI4Linux: DMA supp
 MODULE_AUTHOR("Carsten Paeth");
 MODULE_LICENSE("GPL");
 
-static int suppress_pollack = 0;
+static bool suppress_pollack = 0;
 module_param(suppress_pollack, bool, 0);
 
 /* ------------------------------------------------------------- */
diff --git a/drivers/isdn/hardware/avm/c4.c b/drivers/isdn/hardware/avm/c4.c
--- a/drivers/isdn/hardware/avm/c4.c
+++ b/drivers/isdn/hardware/avm/c4.c
@@ -40,7 +40,7 @@ static char *revision = "$Revision: 1.1.
 
 /* ------------------------------------------------------------- */
 
-static int suppress_pollack;
+static bool suppress_pollack;
 
 static struct pci_device_id c4_pci_tbl[] = {
 	{ PCI_VENDOR_ID_DEC, PCI_DEVICE_ID_DEC_21285, PCI_VENDOR_ID_AVM, PCI_DEVICE_ID_AVM_C4, 0, 0, (unsigned long)4 },
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -30,7 +30,7 @@ static const char *boardname[] = { "Data
 static unsigned int io[] = {0,0,0,0};
 static unsigned char irq[] = {0,0,0,0};
 static unsigned long ram[] = {0,0,0,0};
-static int do_reset = 0;
+static bool do_reset = 0;
 
 module_param_array(io, int, NULL, 0);
 module_param_array(irq, int, NULL, 0);
diff --git a/drivers/leds/leds-clevo-mail.c b/drivers/leds/leds-clevo-mail.c
--- a/drivers/leds/leds-clevo-mail.c
+++ b/drivers/leds/leds-clevo-mail.c
@@ -18,7 +18,7 @@ MODULE_AUTHOR("Márton Németh <nm127@fr
 MODULE_DESCRIPTION("Clevo mail LED driver");
 MODULE_LICENSE("GPL");
 
-static unsigned int __initdata nodetect;
+static bool __initdata nodetect;
 module_param_named(nodetect, nodetect, bool, 0);
 MODULE_PARM_DESC(nodetect, "Skip DMI hardware detection");
 
diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -79,7 +79,7 @@ static int __init ss4200_led_dmi_callbac
 	return 1;
 }
 
-static unsigned int __initdata nodetect;
+static bool __initdata nodetect;
 module_param_named(nodetect, nodetect, bool, 0);
 MODULE_PARM_DESC(nodetect, "Skip DMI-based hardware detection");
 
diff --git a/drivers/macintosh/ams/ams-core.c b/drivers/macintosh/ams/ams-core.c
--- a/drivers/macintosh/ams/ams-core.c
+++ b/drivers/macintosh/ams/ams-core.c
@@ -31,7 +31,7 @@
 /* There is only one motion sensor per machine */
 struct ams ams_info;
 
-static unsigned int verbose;
+static bool verbose;
 module_param(verbose, bool, 0644);
 MODULE_PARM_DESC(verbose, "Show free falls and shocks in kernel output");
 
diff --git a/drivers/macintosh/ams/ams-input.c b/drivers/macintosh/ams/ams-input.c
--- a/drivers/macintosh/ams/ams-input.c
+++ b/drivers/macintosh/ams/ams-input.c
@@ -19,11 +19,11 @@
 
 #include "ams.h"
 
-static unsigned int joystick;
+static bool joystick;
 module_param(joystick, bool, S_IRUGO);
 MODULE_PARM_DESC(joystick, "Enable the input class device on module load");
 
-static unsigned int invert;
+static bool invert;
 module_param(invert, bool, S_IWUSR | S_IRUGO);
 MODULE_PARM_DESC(invert, "Invert input data on X and Y axis");
 
diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -52,7 +52,7 @@ static const char *sensor_location[3];
 
 static int limit_adjust;
 static int fan_speed = -1;
-static int verbose;
+static bool verbose;
 
 MODULE_AUTHOR("Colin Leroy <colin@colino.net>");
 MODULE_DESCRIPTION("Driver for ADT746x thermostat in iBook G4 and "
diff --git a/drivers/media/dvb/dvb-usb/af9005.c b/drivers/media/dvb/dvb-usb/af9005.c
--- a/drivers/media/dvb/dvb-usb/af9005.c
+++ b/drivers/media/dvb/dvb-usb/af9005.c
@@ -30,7 +30,7 @@ MODULE_PARM_DESC(debug,
 		 "set debugging level (1=info,xfer=2,rc=4,reg=8,i2c=16,fw=32 (or-able))."
 		 DVB_USB_DEBUG_STATUS);
 /* enable obnoxious led */
-int dvb_usb_af9005_led = 1;
+bool dvb_usb_af9005_led = 1;
 module_param_named(led, dvb_usb_af9005_led, bool, 0644);
 MODULE_PARM_DESC(led, "enable led (default: 1).");
 
diff --git a/drivers/media/dvb/dvb-usb/af9005.h b/drivers/media/dvb/dvb-usb/af9005.h
--- a/drivers/media/dvb/dvb-usb/af9005.h
+++ b/drivers/media/dvb/dvb-usb/af9005.h
@@ -35,7 +35,7 @@ extern int dvb_usb_af9005_debug;
 #define deb_i2c(args...)  dprintk(dvb_usb_af9005_debug,0x10,args)
 #define deb_fw(args...)   dprintk(dvb_usb_af9005_debug,0x20,args)
 
-extern int dvb_usb_af9005_led;
+extern bool dvb_usb_af9005_led;
 
 /* firmware */
 #define FW_BULKOUT_SIZE 250
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -47,11 +47,11 @@ MODULE_VERSION("0.0.4");
 #endif
 
 static int io		= CONFIG_RADIO_GEMTEK_PORT;
-static int probe	= CONFIG_RADIO_GEMTEK_PROBE;
-static int hardmute;
-static int shutdown	= 1;
-static int keepmuted	= 1;
-static int initmute	= 1;
+static bool probe	= CONFIG_RADIO_GEMTEK_PROBE;
+static bool hardmute;
+static bool shutdown	= 1;
+static bool keepmuted	= 1;
+static bool initmute	= 1;
 static int radio_nr	= -1;
 
 module_param(io, int, 0444);
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -23,7 +23,7 @@ static int radio_nr = -1;
 module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Default: -1 (autodetect)");
 
-static int mono;
+static bool mono;
 module_param(mono, bool, 0);
 MODULE_PARM_DESC(mono, "Force tuner into mono mode.");
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -38,7 +38,7 @@
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
 
-static int debug;
+static bool debug;
 
 #define IRCTL_DEV_NAME	"BaseRemoteCtl"
 #define NOPLUG		-1
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -156,9 +156,9 @@
 
 /* module parameters */
 #ifdef CONFIG_USB_DEBUG
-static int debug = 1;
+static bool debug = 1;
 #else
-static int debug;
+static bool debug;
 #endif
 
 #define mce_dbg(dev, fmt, ...)					\
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -43,9 +43,9 @@
 #define DRIVER_DESC	"Streamzap Remote Control driver"
 
 #ifdef CONFIG_USB_DEBUG
-static int debug = 1;
+static bool debug = 1;
 #else
-static int debug;
+static bool debug;
 #endif
 
 #define USB_STREAMZAP_VENDOR_ID		0x0e9c
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -226,11 +226,11 @@ module_param(protocol, uint, 0444);
 MODULE_PARM_DESC(protocol, "IR protocol to use for the power-on command "
 		 "(0 = RC5, 1 = NEC, 2 = RC6A, default)");
 
-static int invert; /* default = 0 */
+static bool invert; /* default = 0 */
 module_param(invert, bool, 0444);
 MODULE_PARM_DESC(invert, "Invert the signal from the IR receiver");
 
-static int txandrx; /* default = 0 */
+static bool txandrx; /* default = 0 */
 module_param(txandrx, bool, 0444);
 MODULE_PARM_DESC(invert, "Allow simultaneous TX and RX");
 
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
--- a/drivers/media/video/c-qcam.c
+++ b/drivers/media/video/c-qcam.c
@@ -72,7 +72,7 @@ struct qcam {
 
 static int parport[MAX_CAMS] = { [1 ... MAX_CAMS-1] = -1 };
 static int probe = 2;
-static int force_rgb;
+static bool force_rgb;
 static int video_nr = -1;
 
 /* FIXME: parport=auto would never have worked, surely? --RR */
diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -31,7 +31,7 @@ MODULE_DESCRIPTION("i2c device driver fo
 MODULE_AUTHOR("Hans Verkuil");
 MODULE_LICENSE("GPL");
 
-static int debug;
+static bool debug;
 
 module_param(debug, bool, 0644);
 
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -35,7 +35,7 @@ MODULE_DESCRIPTION("i2c device driver fo
 MODULE_AUTHOR("Martin Vaughan");
 MODULE_LICENSE("GPL");
 
-static int debug;
+static bool debug;
 
 module_param(debug, bool, 0644);
 
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -75,7 +75,7 @@ static int radio[CX18_MAX_CARDS] = { -1,
 				     -1, -1, -1, -1, -1, -1, -1, -1 };
 static unsigned cardtype_c = 1;
 static unsigned tuner_c = 1;
-static unsigned radio_c = 1;
+static bool radio_c = 1;
 static char pal[] = "--";
 static char secam[] = "--";
 static char ntsc[] = "-";
diff --git a/drivers/media/video/cx25821/cx25821-alsa.c b/drivers/media/video/cx25821/cx25821-alsa.c
--- a/drivers/media/video/cx25821/cx25821-alsa.c
+++ b/drivers/media/video/cx25821/cx25821-alsa.c
@@ -102,7 +102,7 @@ struct cx25821_audio_dev {
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = { 1, [1 ... (SNDRV_CARDS - 1)] = 1 };
+static bool enable[SNDRV_CARDS] = { 1, [1 ... (SNDRV_CARDS - 1)] = 1 };
 
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable cx25821 soundcard. default enabled.");
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -96,7 +96,7 @@ typedef struct cx88_audio_dev snd_cx88_c
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static const char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
-static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
+static bool enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable cx88x soundcard. default enabled.");
diff --git a/drivers/media/video/gspca/m5602/m5602_core.c b/drivers/media/video/gspca/m5602/m5602_core.c
--- a/drivers/media/video/gspca/m5602/m5602_core.c
+++ b/drivers/media/video/gspca/m5602/m5602_core.c
@@ -27,8 +27,8 @@
 
 /* Kernel module parameters */
 int force_sensor;
-static int dump_bridge;
-int dump_sensor;
+static bool dump_bridge;
+bool dump_sensor;
 
 static const struct usb_device_id m5602_table[] = {
 	{USB_DEVICE(0x0402, 0x5602)},
diff --git a/drivers/media/video/gspca/m5602/m5602_mt9m111.h b/drivers/media/video/gspca/m5602/m5602_mt9m111.h
--- a/drivers/media/video/gspca/m5602/m5602_mt9m111.h
+++ b/drivers/media/video/gspca/m5602/m5602_mt9m111.h
@@ -106,7 +106,7 @@
 
 /* Kernel module parameters */
 extern int force_sensor;
-extern int dump_sensor;
+extern bool dump_sensor;
 
 int mt9m111_probe(struct sd *sd);
 int mt9m111_init(struct sd *sd);
diff --git a/drivers/media/video/gspca/m5602/m5602_ov7660.h b/drivers/media/video/gspca/m5602/m5602_ov7660.h
--- a/drivers/media/video/gspca/m5602/m5602_ov7660.h
+++ b/drivers/media/video/gspca/m5602/m5602_ov7660.h
@@ -86,7 +86,7 @@
 
 /* Kernel module parameters */
 extern int force_sensor;
-extern int dump_sensor;
+extern bool dump_sensor;
 
 int ov7660_probe(struct sd *sd);
 int ov7660_init(struct sd *sd);
diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.h b/drivers/media/video/gspca/m5602/m5602_ov9650.h
--- a/drivers/media/video/gspca/m5602/m5602_ov9650.h
+++ b/drivers/media/video/gspca/m5602/m5602_ov9650.h
@@ -135,7 +135,7 @@
 
 /* Kernel module parameters */
 extern int force_sensor;
-extern int dump_sensor;
+extern bool dump_sensor;
 
 int ov9650_probe(struct sd *sd);
 int ov9650_init(struct sd *sd);
diff --git a/drivers/media/video/gspca/m5602/m5602_po1030.h b/drivers/media/video/gspca/m5602/m5602_po1030.h
--- a/drivers/media/video/gspca/m5602/m5602_po1030.h
+++ b/drivers/media/video/gspca/m5602/m5602_po1030.h
@@ -147,7 +147,7 @@
 
 /* Kernel module parameters */
 extern int force_sensor;
-extern int dump_sensor;
+extern bool dump_sensor;
 
 int po1030_probe(struct sd *sd);
 int po1030_init(struct sd *sd);
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.h b/drivers/media/video/gspca/m5602/m5602_s5k4aa.h
--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.h
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.h
@@ -65,7 +65,7 @@
 
 /* Kernel module parameters */
 extern int force_sensor;
-extern int dump_sensor;
+extern bool dump_sensor;
 
 int s5k4aa_probe(struct sd *sd);
 int s5k4aa_init(struct sd *sd);
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k83a.h b/drivers/media/video/gspca/m5602/m5602_s5k83a.h
--- a/drivers/media/video/gspca/m5602/m5602_s5k83a.h
+++ b/drivers/media/video/gspca/m5602/m5602_s5k83a.h
@@ -41,7 +41,7 @@
 
 /* Kernel module parameters */
 extern int force_sensor;
-extern int dump_sensor;
+extern bool dump_sensor;
 
 int s5k83a_probe(struct sd *sd);
 int s5k83a_init(struct sd *sd);
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c b/drivers/media/video/gspca/stv06xx/stv06xx.c
--- a/drivers/media/video/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/video/gspca/stv06xx/stv06xx.c
@@ -36,8 +36,8 @@ MODULE_AUTHOR("Erik Andrén");
 MODULE_DESCRIPTION("STV06XX USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-static int dump_bridge;
-static int dump_sensor;
+static bool dump_bridge;
+static bool dump_sensor;
 
 int stv06xx_write_bridge(struct sd *sd, u16 address, u16 i2c_data)
 {
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -49,7 +49,7 @@ module_param(default_audio_input, uint, 
 MODULE_PARM_DESC(default_audio_input, "default audio input: 0=RCA back / "
 		 "1=RCA front / 2=S/PDIF");
 
-static int boost_audio;
+static bool boost_audio;
 module_param(boost_audio, bool, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(boost_audio, "boost the audio signal");
 
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -99,7 +99,7 @@ static int i2c_clock_period[IVTV_MAX_CAR
 
 static unsigned int cardtype_c = 1;
 static unsigned int tuner_c = 1;
-static unsigned int radio_c = 1;
+static bool radio_c = 1;
 static unsigned int i2c_clock_period_c = 1;
 static char pal[] = "---";
 static char secam[] = "--";
diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -58,7 +58,7 @@
 /* card parameters */
 static int ivtvfb_card_id = -1;
 static int ivtvfb_debug = 0;
-static int osd_laced;
+static bool osd_laced;
 static int osd_depth;
 static int osd_upper;
 static int osd_left;
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -51,7 +51,7 @@ static int delivered;
  * sense.
  */
 
-static int alloc_bufs_at_read;
+static bool alloc_bufs_at_read;
 module_param(alloc_bufs_at_read, bool, 0444);
 MODULE_PARM_DESC(alloc_bufs_at_read,
 		"Non-zero value causes DMA buffers to be allocated when the "
@@ -73,11 +73,11 @@ MODULE_PARM_DESC(dma_buf_size,
 		"parameters require larger buffers, an attempt to reallocate "
 		"will be made.");
 #else /* MCAM_MODE_VMALLOC */
-static const int alloc_bufs_at_read = 0;
+static const bool alloc_bufs_at_read = 0;
 static const int n_dma_bufs = 3;  /* Used by S/G_PARM */
 #endif /* MCAM_MODE_VMALLOC */
 
-static int flip;
+static bool flip;
 module_param(flip, bool, 0444);
 MODULE_PARM_DESC(flip,
 		"If set, the sensor will be instructed to flip the image "
diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -69,12 +69,12 @@ MODULE_LICENSE("GPL");
 /* module parameters */
 static int opmode   = OPMODE_AUTO;
 int msp_debug;		 /* msp_debug output */
-int msp_once;		 /* no continuous stereo monitoring */
-int msp_amsound;	 /* hard-wire AM sound at 6.5 Hz (france),
+bool msp_once;		 /* no continuous stereo monitoring */
+bool msp_amsound;	 /* hard-wire AM sound at 6.5 Hz (france),
 			    the autoscan seems work well only with FM... */
 int msp_standard = 1;    /* Override auto detect of audio msp_standard,
 			    if needed. */
-int msp_dolby;
+bool msp_dolby;
 
 int msp_stereo_thresh = 0x190; /* a2 threshold for stereo/bilingual
 					(msp34xxg only) 0x00a0-0x03c0 */
diff --git a/drivers/media/video/msp3400-driver.h b/drivers/media/video/msp3400-driver.h
--- a/drivers/media/video/msp3400-driver.h
+++ b/drivers/media/video/msp3400-driver.h
@@ -44,10 +44,10 @@
 
 /* module parameters */
 extern int msp_debug;
-extern int msp_once;
-extern int msp_amsound;
+extern bool msp_once;
+extern bool msp_amsound;
 extern int msp_standard;
-extern int msp_dolby;
+extern bool msp_dolby;
 extern int msp_stereo_thresh;
 
 struct msp_state {
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -69,9 +69,9 @@ static u32 video1_numbuffers = 3;
 static u32 video2_numbuffers = 3;
 static u32 video1_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
 static u32 video2_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
-static u32 vid1_static_vrfb_alloc;
-static u32 vid2_static_vrfb_alloc;
-static int debug;
+static bool vid1_static_vrfb_alloc;
+static bool vid2_static_vrfb_alloc;
+static bool debug;
 
 /* Module parameters */
 module_param(video1_numbuffers, uint, S_IRUGO);
diff --git a/drivers/media/video/omap/omap_vout_vrfb.c b/drivers/media/video/omap/omap_vout_vrfb.c
--- a/drivers/media/video/omap/omap_vout_vrfb.c
+++ b/drivers/media/video/omap/omap_vout_vrfb.c
@@ -84,7 +84,7 @@ void omap_vout_free_vrfb_buffers(struct 
 }
 
 int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
-			u32 static_vrfb_allocation)
+			      bool static_vrfb_allocation)
 {
 	int ret = 0, i, j;
 	struct omap_vout_device *vout;
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -25,7 +25,7 @@ MODULE_AUTHOR("Jonathan Corbet <corbet@l
 MODULE_DESCRIPTION("A low-level driver for OmniVision ov7670 sensors");
 MODULE_LICENSE("GPL");
 
-static int debug;
+static bool debug;
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -57,7 +57,7 @@ MODULE_AUTHOR(  "Maxim Yevtyushkin, Kevi
 		"Hans Verkuil, Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
 
-static int debug;
+static bool debug;
 module_param(debug, bool, 0644);
 
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -38,11 +38,11 @@
 #include "stk-webcam.h"
 
 
-static int hflip = 1;
+static bool hflip = 1;
 module_param(hflip, bool, 0444);
 MODULE_PARM_DESC(hflip, "Horizontal image flip (mirror). Defaults to 1");
 
-static int vflip = 1;
+static bool vflip = 1;
 module_param(vflip, bool, 0444);
 MODULE_PARM_DESC(vflip, "Vertical image flip. Defaults to 1");
 
diff --git a/drivers/media/video/tm6000/tm6000-alsa.c b/drivers/media/video/tm6000/tm6000-alsa.c
--- a/drivers/media/video/tm6000/tm6000-alsa.c
+++ b/drivers/media/video/tm6000/tm6000-alsa.c
@@ -42,7 +42,7 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 
-static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
+static bool enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable tm6000x soundcard. default enabled.");
diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -52,7 +52,7 @@
 #define LOCK_RETRY_DELAY                (200)
 
 /* Debug functions */
-static int debug;
+static bool debug;
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -63,7 +63,7 @@ MODULE_LICENSE("GPL");
 #define TVP7002_CL_MASK		0x0f
 
 /* Debug functions */
-static int debug;
+static bool debug;
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
diff --git a/drivers/media/video/upd64083.c b/drivers/media/video/upd64083.c
--- a/drivers/media/video/upd64083.c
+++ b/drivers/media/video/upd64083.c
@@ -34,7 +34,7 @@ MODULE_DESCRIPTION("uPD64083 driver");
 MODULE_AUTHOR("T. Adachi, Takeru KOMORIYA, Hans Verkuil");
 MODULE_LICENSE("GPL");
 
-static int debug;
+static bool debug;
 module_param(debug, bool, 0644);
 
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -34,13 +34,13 @@ MODULE_AUTHOR("Jonathan Corbet <corbet@l
 MODULE_DESCRIPTION("VIA framebuffer-based camera controller driver");
 MODULE_LICENSE("GPL");
 
-static int flip_image;
+static bool flip_image;
 module_param(flip_image, bool, 0444);
 MODULE_PARM_DESC(flip_image,
 		"If set, the sensor will be instructed to flip the image "
 		"vertically.");
 
-static int override_serial;
+static bool override_serial;
 module_param(override_serial, bool, 0444);
 MODULE_PARM_DESC(override_serial,
 		"The camera driver will normally refuse to load if "
diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/video/zoran/zoran_device.c
--- a/drivers/media/video/zoran/zoran_device.c
+++ b/drivers/media/video/zoran/zoran_device.c
@@ -57,7 +57,7 @@
 		   ZR36057_ISR_GIRQ1 | \
 		   ZR36057_ISR_JPEGRepIRQ )
 
-static int lml33dpath;		/* default = 0
+static bool lml33dpath;		/* default = 0
 				 * 1 will use digital path in capture
 				 * mode instead of analog. It can be
 				 * used for picture adjustments using
diff --git a/drivers/media/video/zoran/zr36060.c b/drivers/media/video/zoran/zr36060.c
--- a/drivers/media/video/zoran/zr36060.c
+++ b/drivers/media/video/zoran/zr36060.c
@@ -50,7 +50,7 @@
 /* amount of chips attached via this driver */
 static int zr36060_codecs;
 
-static int low_bitrate;
+static bool low_bitrate;
 module_param(low_bitrate, bool, 0);
 MODULE_PARM_DESC(low_bitrate, "Buz compatibility option, halves bitrate");
 
diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -21,7 +21,7 @@
 
 #define DRIVER_NAME "jmb38x_ms"
 
-static int no_dma;
+static bool no_dma;
 module_param(no_dma, bool, 0644);
 
 enum {
diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -23,7 +23,7 @@
 #include <linux/swab.h>
 #include "r592.h"
 
-static int r592_enable_dma = 1;
+static bool r592_enable_dma = 1;
 static int debug;
 
 static const char *tpc_names[] = {
diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -22,7 +22,7 @@
 
 #define DRIVER_NAME "tifm_ms"
 
-static int no_dma;
+static bool no_dma;
 module_param(no_dma, bool, 0644);
 
 /*
diff --git a/drivers/misc/iwmc3200top/main.c b/drivers/misc/iwmc3200top/main.c
--- a/drivers/misc/iwmc3200top/main.c
+++ b/drivers/misc/iwmc3200top/main.c
@@ -376,20 +376,20 @@ static int blocks;
 module_param(blocks, int, 0604);
 MODULE_PARM_DESC(blocks, "max_blocks_to_send");
 
-static int dump;
+static bool dump;
 module_param(dump, bool, 0604);
 MODULE_PARM_DESC(dump, "dump_hex_content");
 
-static int jump = 1;
+static bool jump = 1;
 module_param(jump, bool, 0604);
 
-static int direct = 1;
+static bool direct = 1;
 module_param(direct, bool, 0604);
 
-static int checksum = 1;
+static bool checksum = 1;
 module_param(checksum, bool, 0604);
 
-static int fw_download = 1;
+static bool fw_download = 1;
 module_param(fw_download, bool, 0604);
 
 static int block_size = IWMC_SDIO_BLK_SIZE;
@@ -398,7 +398,7 @@ module_param(block_size, int, 0404);
 static int download_trans_blks = IWMC_DEFAULT_TR_BLK;
 module_param(download_trans_blks, int, 0604);
 
-static int rubbish_barker;
+static bool rubbish_barker;
 module_param(rubbish_barker, bool, 0604);
 
 #ifdef CONFIG_IWMC3200TOP_DEBUG
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -48,7 +48,7 @@ static struct workqueue_struct *workqueu
  * performance cost, and for other reasons may not always be desired.
  * So we allow it it to be disabled.
  */
-int use_spi_crc = 1;
+bool use_spi_crc = 1;
 module_param(use_spi_crc, bool, 0);
 
 /*
@@ -58,9 +58,9 @@ module_param(use_spi_crc, bool, 0);
  * overridden if necessary.
  */
 #ifdef CONFIG_MMC_UNSAFE_RESUME
-int mmc_assume_removable;
+bool mmc_assume_removable;
 #else
-int mmc_assume_removable = 1;
+bool mmc_assume_removable = 1;
 #endif
 EXPORT_SYMBOL(mmc_assume_removable);
 module_param_named(removable, mmc_assume_removable, bool, 0644);
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -64,7 +64,7 @@ int mmc_attach_sd(struct mmc_host *host)
 int mmc_attach_sdio(struct mmc_host *host);
 
 /* Module parameters */
-extern int use_spi_crc;
+extern bool use_spi_crc;
 
 /* Debugfs information for hosts and cards */
 void mmc_add_host_debugfs(struct mmc_host *host);
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -22,8 +22,8 @@
 #define DRIVER_NAME "tifm_sd"
 #define DRIVER_VERSION "0.8"
 
-static int no_dma = 0;
-static int fixed_timeout = 0;
+static bool no_dma = 0;
+static bool fixed_timeout = 0;
 module_param(no_dma, bool, 0644);
 module_param(fixed_timeout, bool, 0644);
 
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -223,25 +223,25 @@ enum SD_RESPONSE_TYPE {
 #define FUN(c) (0x000007 & (c->arg>>28))
 #define REG(c) (0x01FFFF & (c->arg>>9))
 
-static int limit_speed_to_24_MHz;
+static bool limit_speed_to_24_MHz;
 module_param(limit_speed_to_24_MHz, bool, 0644);
 MODULE_PARM_DESC(limit_speed_to_24_MHz, "Limit Max SDIO Clock Speed to 24 MHz");
 
-static int pad_input_to_usb_pkt;
+static bool pad_input_to_usb_pkt;
 module_param(pad_input_to_usb_pkt, bool, 0644);
 MODULE_PARM_DESC(pad_input_to_usb_pkt,
 		 "Pad USB data input transfers to whole USB Packet");
 
-static int disable_offload_processing;
+static bool disable_offload_processing;
 module_param(disable_offload_processing, bool, 0644);
 MODULE_PARM_DESC(disable_offload_processing, "Disable Offload Processing");
 
-static int force_1_bit_data_xfers;
+static bool force_1_bit_data_xfers;
 module_param(force_1_bit_data_xfers, bool, 0644);
 MODULE_PARM_DESC(force_1_bit_data_xfers,
 		 "Force SDIO Data Transfers to 1-bit Mode");
 
-static int force_polling_for_irqs;
+static bool force_polling_for_irqs;
 module_param(force_polling_for_irqs, bool, 0644);
 MODULE_PARM_DESC(force_polling_for_irqs, "Force Polling for SDIO interrupts");
 
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -185,7 +185,7 @@ struct pxa3xx_nand_info {
 	uint32_t		ndcb2;
 };
 
-static int use_dma = 1;
+static bool use_dma = 1;
 module_param(use_dma, bool, 0444);
 MODULE_PARM_DESC(use_dma, "enable DMA for data transferring to/from NAND HW");
 
diff --git a/drivers/mtd/nand/r852.c b/drivers/mtd/nand/r852.c
--- a/drivers/mtd/nand/r852.c
+++ b/drivers/mtd/nand/r852.c
@@ -22,7 +22,7 @@
 #include "r852.h"
 
 
-static int r852_enable_dma = 1;
+static bool r852_enable_dma = 1;
 module_param(r852_enable_dma, bool, S_IRUGO);
 MODULE_PARM_DESC(r852_enable_dma, "Enable usage of the DMA (default)");
 
diff --git a/drivers/parport/parport_ip32.c b/drivers/parport/parport_ip32.c
--- a/drivers/parport/parport_ip32.c
+++ b/drivers/parport/parport_ip32.c
@@ -135,7 +135,7 @@
 #define PARPORT_IP32_ENABLE_EPP	(1U << 3)
 #define PARPORT_IP32_ENABLE_ECP	(1U << 4)
 static unsigned int features =	~0U;
-static int verbose_probing =	DEFAULT_VERBOSE_PROBING;
+static bool verbose_probing =	DEFAULT_VERBOSE_PROBING;
 
 /* We do not support more than one port. */
 static struct parport *this_port = NULL;
diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -44,7 +44,7 @@
 #define	METHOD_NAME__SUN	"_SUN"
 #define	METHOD_NAME_OSHP	"OSHP"
 
-static int debug_acpi;
+static bool debug_acpi;
 
 static acpi_status
 decode_type0_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -47,7 +47,7 @@
 /* name size which is used for entries in pcihpfs */
 #define SLOT_NAME_SIZE  21              /* {_SUN} */
 
-static int debug;
+static bool debug;
 int acpiphp_debug;
 
 /* local variables */
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -43,7 +43,7 @@
 #define DRIVER_AUTHOR	"Irene Zubarev <zubarev@us.ibm.com>, Vernon Mauery <vernux@us.ibm.com>"
 #define DRIVER_DESC	"ACPI Hot Plug PCI Controller Driver IBM extension"
 
-static int debug;
+static bool debug;
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -57,8 +57,8 @@
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
 
 /* local variables */
-static int debug;
-static int poll;
+static bool debug;
+static bool poll;
 static struct cpci_hp_controller_ops zt5550_hpc_ops;
 static struct cpci_hp_controller zt5550_hpc;
 
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -57,8 +57,8 @@ struct irq_routing_table *cpqhp_routing_
 static void __iomem *smbios_table;
 static void __iomem *smbios_start;
 static void __iomem *cpqhp_rom_start;
-static int power_mode;
-static int debug;
+static bool power_mode;
+static bool debug;
 static int initialized;
 
 #define DRIVER_VERSION	"0.9.8"
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -49,7 +49,7 @@
 
 int ibmphp_debug;
 
-static int debug;
+static bool debug;
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC (debug, "Debugging mode enabled or not");
 MODULE_LICENSE ("GPL");
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -51,7 +51,7 @@
 
 
 /* local variables */
-static int debug;
+static bool debug;
 
 #define DRIVER_VERSION	"0.5"
 #define DRIVER_AUTHOR	"Greg Kroah-Hartman <greg@kroah.com>, Scott Murray <scottm@somanetworks.com>"
diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -40,10 +40,10 @@
 
 #define MY_NAME	"pciehp"
 
-extern int pciehp_poll_mode;
+extern bool pciehp_poll_mode;
 extern int pciehp_poll_time;
-extern int pciehp_debug;
-extern int pciehp_force;
+extern bool pciehp_debug;
+extern bool pciehp_force;
 extern struct workqueue_struct *pciehp_wq;
 extern struct workqueue_struct *pciehp_ordered_wq;
 
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -38,10 +38,10 @@
 #include <linux/time.h>
 
 /* Global variables */
-int pciehp_debug;
-int pciehp_poll_mode;
+bool pciehp_debug;
+bool pciehp_poll_mode;
 int pciehp_poll_time;
-int pciehp_force;
+bool pciehp_force;
 struct workqueue_struct *pciehp_wq;
 struct workqueue_struct *pciehp_ordered_wq;
 
diff --git a/drivers/pci/hotplug/pcihp_skeleton.c b/drivers/pci/hotplug/pcihp_skeleton.c
--- a/drivers/pci/hotplug/pcihp_skeleton.c
+++ b/drivers/pci/hotplug/pcihp_skeleton.c
@@ -59,7 +59,7 @@ static LIST_HEAD(slot_list);
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
 
 /* local variables */
-static int debug;
+static bool debug;
 static int num_slots;
 
 #define DRIVER_VERSION	"0.3"
diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -37,7 +37,7 @@
 				/* and pci_do_scan_bus */
 #include "rpaphp.h"
 
-int rpaphp_debug;
+bool rpaphp_debug;
 LIST_HEAD(rpaphp_slot_head);
 
 #define DRIVER_VERSION	"0.1"
diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -43,9 +43,9 @@
 	#define MY_NAME	THIS_MODULE->name
 #endif
 
-extern int shpchp_poll_mode;
+extern bool shpchp_poll_mode;
 extern int shpchp_poll_time;
-extern int shpchp_debug;
+extern bool shpchp_debug;
 extern struct workqueue_struct *shpchp_wq;
 extern struct workqueue_struct *shpchp_ordered_wq;
 
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -36,8 +36,8 @@
 #include "shpchp.h"
 
 /* Global variables */
-int shpchp_debug;
-int shpchp_poll_mode;
+bool shpchp_debug;
+bool shpchp_poll_mode;
 int shpchp_poll_time;
 struct workqueue_struct *shpchp_wq;
 struct workqueue_struct *shpchp_ordered_wq;
diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -28,7 +28,7 @@
 #include "aerdrv.h"
 
 /* Override the existing corrected and uncorrected error masks */
-static int aer_mask_override;
+static bool aer_mask_override;
 module_param(aer_mask_override, bool, 0);
 
 struct aer_error_inj {
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -27,8 +27,8 @@
 #include <linux/kfifo.h>
 #include "aerdrv.h"
 
-static int forceload;
-static int nosourceid;
+static bool forceload;
+static bool nosourceid;
 module_param(forceload, bool, 0);
 module_param(nosourceid, bool, 0);
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -24,15 +24,15 @@
 #include "yenta_socket.h"
 #include "i82365.h"
 
-static int disable_clkrun;
+static bool disable_clkrun;
 module_param(disable_clkrun, bool, 0444);
 MODULE_PARM_DESC(disable_clkrun, "If PC card doesn't function properly, please try this option");
 
-static int isa_probe = 1;
+static bool isa_probe = 1;
 module_param(isa_probe, bool, 0444);
 MODULE_PARM_DESC(isa_probe, "If set ISA interrupts are probed (default). Set to N to disable probing");
 
-static int pwr_irqs_off;
+static bool pwr_irqs_off;
 module_param(pwr_irqs_off, bool, 0644);
 MODULE_PARM_DESC(pwr_irqs_off, "Force IRQs off during power-on of slot. Use only when seeing IRQ storms!");
 
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -189,7 +189,7 @@ struct compal_data{
 /* =============== */
 /* General globals */
 /* =============== */
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
 
diff --git a/drivers/platform/x86/intel_oaktrail.c b/drivers/platform/x86/intel_oaktrail.c
--- a/drivers/platform/x86/intel_oaktrail.c
+++ b/drivers/platform/x86/intel_oaktrail.c
@@ -95,7 +95,7 @@
 #define OT_EC_BL_CONTROL_ON_DATA	0x1A
 
 
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
 
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -89,7 +89,7 @@ static int msi_laptop_resume(struct plat
 
 #define MSI_STANDARD_EC_DEVICES_EXISTS_ADDRESS	0x2f
 
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
 
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -228,12 +228,12 @@ static struct platform_device *sdev;
 static struct rfkill *rfk;
 static bool has_stepping_quirk;
 
-static int force;
+static bool force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force,
 		"Disable the DMI check and forces the driver to be loaded");
 
-static int debug;
+static bool debug;
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug enabled or not");
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -378,13 +378,13 @@ static unsigned int bright_maxlvl;	/* 0 
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUGFACILITIES
 static int dbg_wlswemul;
-static int tpacpi_wlsw_emulstate;
+static bool tpacpi_wlsw_emulstate;
 static int dbg_bluetoothemul;
-static int tpacpi_bluetooth_emulstate;
+static bool tpacpi_bluetooth_emulstate;
 static int dbg_wwanemul;
-static int tpacpi_wwan_emulstate;
+static bool tpacpi_wwan_emulstate;
 static int dbg_uwbemul;
-static int tpacpi_uwb_emulstate;
+static bool tpacpi_uwb_emulstate;
 #endif
 
 
@@ -6447,7 +6447,7 @@ static struct ibm_struct brightness_driv
 
 static int alsa_index = ~((1 << (SNDRV_CARDS - 3)) - 1); /* last three slots */
 static char *alsa_id = "ThinkPadEC";
-static int alsa_enable = SNDRV_DEFAULT_ENABLE1;
+static bool alsa_enable = SNDRV_DEFAULT_ENABLE1;
 
 struct tpacpi_alsa_data {
 	struct snd_card *card;
@@ -6490,7 +6490,7 @@ static enum tpacpi_volume_access_mode vo
 	TPACPI_VOL_MODE_MAX;
 
 static enum tpacpi_volume_capabilities volume_capabilities;
-static int volume_control_allowed;
+static bool volume_control_allowed;
 
 /*
  * Used to syncronize writers to TP_EC_AUDIO and
@@ -7268,7 +7268,7 @@ enum fan_control_commands {
 						 * and also watchdog cmd */
 };
 
-static int fan_control_allowed;
+static bool fan_control_allowed;
 
 static enum fan_status_access_mode fan_status_access_mode;
 static enum fan_control_access_mode fan_control_access_mode;
@@ -8440,7 +8440,7 @@ static struct proc_dir_entry *proc_dir;
  * Module and infrastructure proble, init and exit handling
  */
 
-static int force_load;
+static bool force_load;
 
 #ifdef CONFIG_THINKPAD_ACPI_DEBUG
 static const char * __init str_supported(int is_supported)
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -82,12 +82,12 @@ struct wmi_block {
 #define ACPI_WMI_STRING      0x4	/* GUID takes & returns a string */
 #define ACPI_WMI_EVENT       0x8	/* GUID is an event */
 
-static int debug_event;
+static bool debug_event;
 module_param(debug_event, bool, 0444);
 MODULE_PARM_DESC(debug_event,
 		 "Log WMI Events [0/1]");
 
-static int debug_dump_wdg;
+static bool debug_dump_wdg;
 module_param(debug_dump_wdg, bool, 0444);
 MODULE_PARM_DESC(debug_dump_wdg,
 		 "Dump available WMI interfaces [0/1]");
diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -64,7 +64,7 @@ static unsigned int cache_time = 1000;
 module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
-static unsigned int pmod_enabled;
+static bool pmod_enabled;
 module_param(pmod_enabled, bool, 0644);
 MODULE_PARM_DESC(pmod_enabled, "PMOD enable bit");
 
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -75,7 +75,7 @@ static LIST_HEAD(raw3270_devices);
 static int raw3270_registered;
 
 /* Module parameters */
-static int tubxcorrect = 0;
+static bool tubxcorrect = 0;
 module_param(tubxcorrect, bool, 0);
 
 /*
diff --git a/drivers/s390/char/vmwatchdog.c b/drivers/s390/char/vmwatchdog.c
--- a/drivers/s390/char/vmwatchdog.c
+++ b/drivers/s390/char/vmwatchdog.c
@@ -28,9 +28,9 @@
 #define MAX_CMDLEN 240
 #define MIN_INTERVAL 15
 static char vmwdt_cmd[MAX_CMDLEN] = "IPL";
-static int vmwdt_conceal;
+static bool vmwdt_conceal;
 
-static int vmwdt_nowayout = WATCHDOG_NOWAYOUT;
+static bool vmwdt_nowayout = WATCHDOG_NOWAYOUT;
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arnd Bergmann <arndb@de.ibm.com>");
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -102,7 +102,7 @@ static int setup_dmaspeed[MAXBOARDS] __i
  */
 
 #if defined(MODULE)
-static int isapnp = 0;
+static bool isapnp = 0;
 static int aha1542[] = {0x330, 11, 4, -1};
 module_param_array(aha1542, int, NULL, 0);
 module_param(isapnp, bool, 0);
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -546,7 +546,7 @@ static struct ParameterData __devinitdat
  * command line overrides will be used. If set to 1 then safe and
  * slow settings will be used.
  */
-static int use_safe_settings = 0;
+static bool use_safe_settings = 0;
 module_param_named(safe, use_safe_settings, bool, 0);
 MODULE_PARM_DESC(safe, "Use safe and slow settings only. Default: false");
 
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -59,11 +59,11 @@ MODULE_PARM_DESC(trans_mode, "transfer m
 #define ASYNC_MODE    1
 #define ULTRA20M_MODE 2
 
-static int       auto_param = 0;	/* default: ON */
+static bool      auto_param = 0;	/* default: ON */
 module_param     (auto_param, bool, 0);
 MODULE_PARM_DESC(auto_param, "AutoParameter mode (0: ON(default) 1: OFF)");
 
-static int       disc_priv  = 1;	/* default: OFF */
+static bool      disc_priv  = 1;	/* default: OFF */
 module_param     (disc_priv, bool, 0);
 MODULE_PARM_DESC(disc_priv,  "disconnection privilege mode (0: ON 1: OFF(default))");
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -70,7 +70,7 @@ module_param(nsp_burst_mode, int, 0);
 MODULE_PARM_DESC(nsp_burst_mode, "Burst transfer mode (0=io8, 1=io32, 2=mem32(default))");
 
 /* Release IO ports after configuration? */
-static int       free_ports = 0;
+static bool       free_ports = 0;
 module_param(free_ports, bool, 0);
 MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0 (=no))");
 
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL(comedi_debug);
 module_param(comedi_debug, int, 0644);
 #endif
 
-int comedi_autoconfig = 1;
+bool comedi_autoconfig = 1;
 module_param(comedi_autoconfig, bool, 0444);
 
 static int comedi_num_legacy_minors;
diff --git a/drivers/staging/comedi/comedi_fops.h b/drivers/staging/comedi/comedi_fops.h
--- a/drivers/staging/comedi/comedi_fops.h
+++ b/drivers/staging/comedi/comedi_fops.h
@@ -1,10 +1,11 @@
 
 #ifndef _COMEDI_FOPS_H
 #define _COMEDI_FOPS_H
+#include <linux/types.h>
 
 extern struct class *comedi_class;
 extern const struct file_operations comedi_fops;
-extern int comedi_autoconfig;
+extern bool comedi_autoconfig;
 extern struct comedi_driver *comedi_drivers;
 
 #endif /* _COMEDI_FOPS_H */
diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
--- a/drivers/staging/media/go7007/snd-go7007.c
+++ b/drivers/staging/media/go7007/snd-go7007.c
@@ -38,7 +38,7 @@
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;
-static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
+static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;
 
 module_param_array(index, int, NULL, 0444);
 module_param_array(id, charp, NULL, 0444);
diff --git a/drivers/staging/media/lirc/lirc_bt829.c b/drivers/staging/media/lirc/lirc_bt829.c
--- a/drivers/staging/media/lirc/lirc_bt829.c
+++ b/drivers/staging/media/lirc/lirc_bt829.c
@@ -53,7 +53,7 @@ static unsigned char do_get_bits(void);
 
 #define DRIVER_NAME "lirc_bt829"
 
-static int debug;
+static bool debug;
 #define dprintk(fmt, args...)						 \
 	do {								 \
 		if (debug)						 \
diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -62,9 +62,9 @@
 
 /* debugging support */
 #ifdef CONFIG_USB_DEBUG
-static int debug = 1;
+static bool debug = 1;
 #else
-static int debug;
+static bool debug;
 #endif
 
 #define dprintk(fmt, args...)					\
diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -63,8 +63,8 @@
 
 /*** Global Variables ***/
 
-static int debug;
-static int check_pselecd;
+static bool debug;
+static bool check_pselecd;
 
 unsigned int irq = LIRC_IRQ;
 unsigned int io = LIRC_PORT;
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -107,13 +107,13 @@ struct lirc_serial {
 static int type;
 static int io;
 static int irq;
-static int iommap;
+static bool iommap;
 static int ioshift;
-static int softcarrier = 1;
-static int share_irq;
-static int debug;
+static bool softcarrier = 1;
+static bool share_irq;
+static bool debug;
 static int sense = -1;	/* -1 = auto, 0 = active high, 1 = active low */
-static int txsense;	/* 0 = active high, 1 = active low */
+static bool txsense;	/* 0 = active high, 1 = active low */
 
 #define dprintk(fmt, args...)					\
 	do {							\
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -173,7 +173,7 @@ static DEFINE_SPINLOCK(hardware_lock);
 static int rx_buf[RBUF_LEN];
 static unsigned int rx_tail, rx_head;
 
-static int debug;
+static bool debug;
 #define dprintk(fmt, args...)						\
 	do {								\
 		if (debug)						\
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -155,8 +155,8 @@ static struct mutex tx_data_lock;
 #define zilog_info(s, args...) printk(KERN_INFO KBUILD_MODNAME ": " s, ## args)
 
 /* module parameters */
-static int debug;	/* debug output */
-static int tx_only;	/* only handle the IR Tx function */
+static bool debug;	/* debug output */
+static bool tx_only;	/* only handle the IR Tx function */
 static int minor = -1;	/* minor number */
 
 #define dprintk(fmt, args...)						\
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -16,7 +16,7 @@
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
 
-static int debug;
+static bool debug;
 
 /* Version Information */
 #define DRIVER_VERSION "v2.00"
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -16,7 +16,7 @@
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
 
-static int debug;
+static bool debug;
 
 /* Version Information */
 #define DRIVER_VERSION "v2.14"
diff --git a/drivers/staging/speakup/speakup.h b/drivers/staging/speakup/speakup.h
--- a/drivers/staging/speakup/speakup.h
+++ b/drivers/staging/speakup/speakup.h
@@ -116,7 +116,7 @@ extern int bleep_time, bell_pos;
 extern int spell_delay, key_echo;
 extern short punc_mask;
 extern short pitch_shift, synth_flags;
-extern int quiet_boot;
+extern bool quiet_boot;
 extern char *synth_name;
 extern struct bleep unprocessed_sound;
 
diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -22,7 +22,7 @@ static struct spk_synth *synths[MAXSYNTH
 struct spk_synth *synth;
 char pitch_buff[32] = "";
 static int module_status;
-int quiet_boot;
+bool quiet_boot;
 
 struct speakup_info_t speakup_info = {
 	.spinlock = __SPIN_LOCK_UNLOCKED(speakup_info.spinlock),
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -41,7 +41,7 @@ static void __exit tsi148_exit(void);
 
 
 /* Module parameter */
-static int err_chk;
+static bool err_chk;
 static int geoid;
 
 static const char driver_name[] = "vme_tsi148";
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -118,7 +118,7 @@ static unsigned long board2;
 static unsigned long board3;
 static unsigned long board4;
 static unsigned long controller;
-static int support_low_speed;
+static bool support_low_speed;
 static unsigned long modem1;
 static unsigned long modem2;
 static unsigned long modem3;
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -850,7 +850,7 @@ static int mgsl_device_count;
  * .text section address and breakpoint on module load.
  * This is useful for use with gdb and add-symbol-file command.
  */
-static int break_on_load;
+static bool break_on_load;
 
 /*
  * Driver major number, defaults to zero to get auto
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -456,7 +456,7 @@ static int synclinkmp_device_count = 0;
  * .text section address and breakpoint on module load.
  * This is useful for use with gdb and add-symbol-file command.
  */
-static int break_on_load = 0;
+static bool break_on_load = 0;
 
 /*
  * Driver major number, defaults to zero to get auto
diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -73,9 +73,9 @@ static const char speedtch_driver_name[]
 #define DEFAULT_SW_BUFFERING	0
 
 static unsigned int altsetting = 0; /* zero means: use the default */
-static int dl_512_first = DEFAULT_DL_512_FIRST;
-static int enable_isoc = DEFAULT_ENABLE_ISOC;
-static int sw_buffering = DEFAULT_SW_BUFFERING;
+static bool dl_512_first = DEFAULT_DL_512_FIRST;
+static bool enable_isoc = DEFAULT_ENABLE_ISOC;
+static bool sw_buffering = DEFAULT_SW_BUFFERING;
 
 #define DEFAULT_B_MAX_DSL	8128
 #define DEFAULT_MODEM_MODE	11
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -542,7 +542,7 @@ static int modem_index;
 static unsigned int debug;
 static unsigned int altsetting[NB_MODEM] = {
 				[0 ... (NB_MODEM - 1)] = FASTEST_ISO_INTF};
-static int sync_wait[NB_MODEM];
+static bool sync_wait[NB_MODEM];
 static char *cmv_file[NB_MODEM];
 static int annex[NB_MODEM];
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -92,7 +92,7 @@ struct async {
 	u8 bulk_status;
 };
 
-static int usbfs_snoop;
+static bool usbfs_snoop;
 module_param(usbfs_snoop, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(usbfs_snoop, "true to log all usbfs traffic");
 
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -102,7 +102,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khubd_wai
 static struct task_struct *khubd_task;
 
 /* cycle leds on hubs that aren't blinking for attention */
-static int blinkenlights = 0;
+static bool blinkenlights = 0;
 module_param (blinkenlights, bool, S_IRUGO);
 MODULE_PARM_DESC (blinkenlights, "true to cycle leds on hubs");
 
@@ -131,12 +131,12 @@ MODULE_PARM_DESC(initial_descriptor_time
  * otherwise the new scheme is used.  If that fails and "use_both_schemes"
  * is set, then the driver will make another attempt, using the other scheme.
  */
-static int old_scheme_first = 0;
+static bool old_scheme_first = 0;
 module_param(old_scheme_first, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(old_scheme_first,
 		 "start with the old device initialization scheme");
 
-static int use_both_schemes = 1;
+static bool use_both_schemes = 1;
 module_param(use_both_schemes, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(use_both_schemes,
 		"try the other device initialization scheme if the "
@@ -2027,7 +2027,7 @@ static unsigned hub_is_wusb(struct usb_h
 #define SET_ADDRESS_TRIES	2
 #define GET_DESCRIPTOR_TRIES	2
 #define SET_CONFIG_TRIES	(2 * (use_both_schemes + 1))
-#define USE_NEW_SCHEME(i)	((i) / 2 == old_scheme_first)
+#define USE_NEW_SCHEME(i)	((i) / 2 == (int)old_scheme_first)
 
 #define HUB_ROOT_RESET_TIME	50	/* times are in msec */
 #define HUB_SHORT_RESET_TIME	10
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -47,7 +47,7 @@
 
 const char *usbcore_name = "usbcore";
 
-static int nousb;	/* Disable USB when built into kernel image */
+static bool nousb;	/* Disable USB when built into kernel image */
 
 #ifdef	CONFIG_USB_SUSPEND
 static int usb_autosuspend_delay = 2;		/* Default delay value,
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -152,15 +152,15 @@ static const char *ep_string[] = {
 };
 
 /* DMA usage flag */
-static int use_dma = 1;
+static bool use_dma = 1;
 /* packet per buffer dma */
-static int use_dma_ppb = 1;
+static bool use_dma_ppb = 1;
 /* with per descr. update */
-static int use_dma_ppb_du;
+static bool use_dma_ppb_du;
 /* buffer fill mode */
 static int use_dma_bufferfill_mode;
 /* full speed only mode */
-static int use_fullspeed;
+static bool use_fullspeed;
 /* tx buffer size for high speed */
 static unsigned long hs_tx_buf = UDC_EPIN_BUFF_SIZE;
 
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -250,9 +250,9 @@ static struct usb_configuration rndis_co
 /*-------------------------------------------------------------------------*/
 
 #ifdef CONFIG_USB_ETH_EEM
-static int use_eem = 1;
+static bool use_eem = 1;
 #else
-static int use_eem;
+static bool use_eem;
 #endif
 module_param(use_eem, bool, 0);
 MODULE_PARM_DESC(use_eem, "use CDC EEM mode");
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -303,16 +303,16 @@ MODULE_LICENSE("Dual BSD/GPL");
 static struct {
 	char		*file[FSG_MAX_LUNS];
 	char		*serial;
-	int		ro[FSG_MAX_LUNS];
-	int		nofua[FSG_MAX_LUNS];
+	bool		ro[FSG_MAX_LUNS];
+	bool		nofua[FSG_MAX_LUNS];
 	unsigned int	num_filenames;
 	unsigned int	num_ros;
 	unsigned int	num_nofuas;
 	unsigned int	nluns;
 
-	int		removable;
-	int		can_stall;
-	int		cdrom;
+	bool		removable;
+	bool		can_stall;
+	bool		cdrom;
 
 	char		*transport_parm;
 	char		*protocol_parm;
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -69,7 +69,7 @@ static const char * const ep_name[] = {
  *
  * If use_dma is disabled, pio will be used instead.
  */
-static int use_dma = 0;
+static bool use_dma = 0;
 module_param(use_dma, bool, 0644);
 
 /*
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -90,8 +90,8 @@ static const char *const ep_name [] = {
  * Some gadget drivers work better with the dma support here than others.
  * These two parameters let you use PIO or more aggressive DMA.
  */
-static int use_dma = 1;
-static int use_dma_chaining = 0;
+static bool use_dma = 1;
+static bool use_dma_chaining = 0;
 
 /* "modprobe net2280 use_dma=n" etc */
 module_param (use_dma, bool, S_IRUGO);
@@ -112,7 +112,7 @@ module_param (fifo_mode, ushort, 0644);
  * USB suspend requests will be ignored.  This is acceptable for
  * self-powered devices
  */
-static int enable_suspend = 0;
+static bool enable_suspend = 0;
 
 /* "modprobe net2280 enable_suspend=1" etc */
 module_param (enable_suspend, bool, S_IRUGO);
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -98,7 +98,7 @@ module_param (fifo_mode, uint, 0);
 MODULE_PARM_DESC (fifo_mode, "endpoint configuration");
 
 #ifdef	USE_DMA
-static unsigned use_dma = 1;
+static bool use_dma = 1;
 
 /* "modprobe omap_udc use_dma=y", or else as a kernel
  * boot parameter "omap_udc:use_dma=y"
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -359,7 +359,7 @@ struct pch_udc_dev {
 static const char	ep0_string[] = "ep0in";
 static DEFINE_SPINLOCK(udc_stall_spinlock);	/* stall spin lock */
 struct pch_udc_dev *pch_udc;		/* pointer to device object */
-static int speed_fs;
+static bool speed_fs;
 module_param_named(speed_fs, speed_fs, bool, S_IRUGO);
 MODULE_PARM_DESC(speed_fs, "true for Full speed operation");
 
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -123,11 +123,11 @@ MODULE_AUTHOR("Al Borchers");
 MODULE_AUTHOR("David Brownell");
 MODULE_LICENSE("GPL");
 
-static int use_acm = true;
+static bool use_acm = true;
 module_param(use_acm, bool, 0);
 MODULE_PARM_DESC(use_acm, "Use CDC ACM, default=yes");
 
-static int use_obex = false;
+static bool use_obex = false;
 module_param(use_obex, bool, 0);
 MODULE_PARM_DESC(use_obex, "Use CDC OBEX, default=no");
 
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -81,7 +81,7 @@ module_param(buflen, uint, 0);
  * work better with hosts where config changes are problematic or
  * controllers (like original superh) that only support one config.
  */
-static int loopdefault = 0;
+static bool loopdefault = 0;
 module_param(loopdefault, bool, S_IRUGO|S_IWUSR);
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -108,7 +108,7 @@ module_param (park, uint, S_IRUGO);
 MODULE_PARM_DESC (park, "park setting; 1-3 back-to-back async packets");
 
 /* for flakey hardware, ignore overcurrent indicators */
-static int ignore_oc = 0;
+static bool ignore_oc = 0;
 module_param (ignore_oc, bool, S_IRUGO);
 MODULE_PARM_DESC (ignore_oc, "ignore bogus hardware overcurrent indications");
 
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -115,13 +115,13 @@ static inline void sb800_prefetch(struct
 
 
 /* Some boards misreport power switching/overcurrent */
-static int distrust_firmware = 1;
+static bool distrust_firmware = 1;
 module_param (distrust_firmware, bool, 0);
 MODULE_PARM_DESC (distrust_firmware,
 	"true to distrust firmware power/overcurrent setup");
 
 /* Some boards leave IR set wrongly, since they fail BIOS/SMM handshakes */
-static int no_handshake = 0;
+static bool no_handshake = 0;
 module_param (no_handshake, bool, 0);
 MODULE_PARM_DESC (no_handshake, "true (not default) disables BIOS handshake");
 
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -233,7 +233,7 @@ module_param(park, uint, S_IRUGO);
 MODULE_PARM_DESC(park, "park setting; 1-3 back-to-back async packets");
 
 /* For flakey hardware, ignore overcurrent indicators */
-static int ignore_oc;
+static bool ignore_oc;
 module_param(ignore_oc, bool, S_IRUGO);
 MODULE_PARM_DESC(ignore_oc, "ignore bogus hardware overcurrent indications");
 
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -74,7 +74,7 @@ MODULE_LICENSE("GPL");
 #define INT_MODULE_PARM(n, v) static int n = v;module_param(n, int, 0444)
 INT_MODULE_PARM(testing, 0);
 /* Some boards misreport power switching/overcurrent*/
-static int distrust_firmware = 1;
+static bool distrust_firmware = 1;
 module_param(distrust_firmware, bool, 0);
 MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overcurren"
 	"t setup");
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -59,7 +59,7 @@
 #define DRIVER_DESC "USB Universal Host Controller Interface driver"
 
 /* for flakey hardware, ignore overcurrent indicators */
-static int ignore_oc;
+static bool ignore_oc;
 module_param(ignore_oc, bool, S_IRUGO);
 MODULE_PARM_DESC(ignore_oc, "ignore hardware overcurrent indications");
 
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -53,7 +53,7 @@ MODULE_AUTHOR("Tony Olech");
 MODULE_DESCRIPTION("FTDI ELAN driver");
 MODULE_LICENSE("GPL");
 #define INT_MODULE_PARM(n, v) static int n = v;module_param(n, int, 0444)
-static int distrust_firmware = 1;
+static bool distrust_firmware = 1;
 module_param(distrust_firmware, bool, 0);
 MODULE_PARM_DESC(distrust_firmware, "true to distrust firmware power/overcurren"
         "t setup");
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -62,7 +62,7 @@ MODULE_LICENSE("GPL");
 
 /* Module parameters */
 static DEFINE_MUTEX(iowarrior_mutex);
-static int debug = 0;
+static bool debug = 0;
 module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "debug=1 enables debugging messages");
 
diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -750,7 +750,7 @@ cppi_next_tx_segment(struct musb *musb, 
  * So this module parameter lets the heuristic be disabled.  When using
  * gadgetfs, the heuristic will probably need to be disabled.
  */
-static int cppi_rx_rndis = 1;
+static bool cppi_rx_rndis = 1;
 
 module_param(cppi_rx_rndis, bool, 0);
 MODULE_PARM_DESC(cppi_rx_rndis, "enable/disable RX RNDIS heuristic");
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1587,7 +1587,7 @@ irqreturn_t musb_interrupt(struct musb *
 EXPORT_SYMBOL_GPL(musb_interrupt);
 
 #ifndef CONFIG_MUSB_PIO_ONLY
-static int __initdata use_dma = 1;
+static bool __initdata use_dma = 1;
 
 /* "modprobe ... use_dma=0" etc */
 module_param(use_dma, bool, 0);
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -52,7 +52,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-static int debug;
+static bool debug;
 
 /* Vendor and Product ID */
 #define AIRCABLE_VID		0x16CA
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -37,7 +37,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
-static int debug;
+static bool debug;
 /*
  * Version information
  */
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -80,7 +80,7 @@
 #include <linux/usb/serial.h>
 #include "belkin_sa.h"
 
-static int debug;
+static bool debug;
 
 /*
  * Version Information
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -70,7 +70,7 @@
 #define CH341_NBREAK_BITS_REG2 0x40
 
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -49,7 +49,7 @@ static void cp210x_break_ctl(struct tty_
 static int cp210x_startup(struct usb_serial *);
 static void cp210x_dtr_rts(struct usb_serial_port *p, int on);
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x045B, 0x0053) }, /* Renesas RX610 RX-Stick */
diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -43,7 +43,7 @@
 
 #define CYBERJACK_LOCAL_BUF_SIZE 32
 
-static int debug;
+static bool debug;
 
 /*
  * Version Information
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -72,10 +72,10 @@
 #include "cypress_m8.h"
 
 
-static int debug;
-static int stats;
+static bool debug;
+static bool stats;
 static int interval;
-static int unstable_bauds;
+static bool unstable_bauds;
 
 /*
  * Version Information
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -467,7 +467,7 @@ static int digi_read_oob_callback(struct
 
 /* Statics */
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table_combined[] = {
 	{ USB_DEVICE(DIGI_VENDOR_ID, DIGI_2_ID) },
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -28,7 +28,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-static int debug;
+static bool debug;
 
 /*
  * Version Information
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -55,7 +55,7 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <greg@kroah.com>, Bill Ryder <bryder@sgi.com>, Kuba Ober <kuba@mareimbrium.org>, Andreas Mohr, Johan Hovold <jhovold@gmail.com>"
 #define DRIVER_DESC "USB FTDI Serial Converters Driver"
 
-static int debug;
+static bool debug;
 static __u16 vendor = FTDI_VID;
 static __u16 product;
 
diff --git a/drivers/usb/serial/funsoft.c b/drivers/usb/serial/funsoft.c
--- a/drivers/usb/serial/funsoft.c
+++ b/drivers/usb/serial/funsoft.c
@@ -16,7 +16,7 @@
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1404, 0xcddc) },
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -42,7 +42,7 @@
 static int initial_mode = 1;
 
 /* debug flag */
-static int debug;
+static bool debug;
 
 #define GARMIN_VENDOR_ID             0x091E
 
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -191,7 +191,7 @@ static const struct divisor_table_entry 
 };
 
 /* local variables */
-static int debug;
+static bool debug;
 
 static atomic_t CmdUrbs;	/* Number of outstanding Command Write Urbs */
 
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -217,10 +217,10 @@ static unsigned char OperationalMajorVer
 static unsigned char OperationalMinorVersion;
 static unsigned short OperationalBuildNumber;
 
-static int debug;
+static bool debug;
 
 static int closing_wait = EDGE_CLOSING_WAIT;
-static int ignore_cpu_rev;
+static bool ignore_cpu_rev;
 static int default_uart_mode;		/* RS232 */
 
 static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
diff --git a/drivers/usb/serial/ipaq.c b/drivers/usb/serial/ipaq.c
--- a/drivers/usb/serial/ipaq.c
+++ b/drivers/usb/serial/ipaq.c
@@ -68,7 +68,7 @@
 #define DRIVER_DESC "USB PocketPC PDA driver"
 
 static __u16 product, vendor;
-static int debug;
+static bool debug;
 static int connect_retries = KP_RETRIES;
 static int initial_wait;
 
diff --git a/drivers/usb/serial/ipw.c b/drivers/usb/serial/ipw.c
--- a/drivers/usb/serial/ipw.c
+++ b/drivers/usb/serial/ipw.c
@@ -147,7 +147,7 @@ static struct usb_driver usb_ipw_driver 
 	.no_dynamic_id = 	1,
 };
 
-static int debug;
+static bool debug;
 
 static int ipw_open(struct tty_struct *tty, struct usb_serial_port *port)
 {
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -77,7 +77,7 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <greg@kroah.com>, Johan Hovold <jhovold@gmail.com>"
 #define DRIVER_DESC "USB IR Dongle driver"
 
-static int debug;
+static bool debug;
 
 /* if overridden by the user, then use their value for the size of the read and
  * write urbs */
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -34,9 +34,9 @@
 
 
 #ifdef CONFIG_USB_SERIAL_DEBUG
-static int debug = 1;
+static bool debug = 1;
 #else
-static int debug;
+static bool debug;
 #endif
 
 /*
@@ -65,7 +65,7 @@ static int clockmode = 1;
 static int cdmode = 1;
 static int iuu_cardin;
 static int iuu_cardout;
-static int xmas;
+static bool xmas;
 static int vcc_default = 5;
 
 static void read_rxcmd_callback(struct urb *urb);
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -112,7 +112,7 @@
 #include <linux/usb/serial.h>
 #include "keyspan.h"
 
-static int debug;
+static bool debug;
 
 /*
  * Version Information
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -84,7 +84,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-static int debug;
+static bool debug;
 
 /* make a simple define to handle if we are compiling keyspan_pda or xircom support */
 #if defined(CONFIG_USB_SERIAL_KEYSPAN_PDA) || defined(CONFIG_USB_SERIAL_KEYSPAN_PDA_MODULE)
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -49,7 +49,7 @@
 #include <linux/usb/serial.h>
 #include "kl5kusb105.h"
 
-static int debug;
+static bool debug;
 
 /*
  * Version Information
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -89,7 +89,7 @@
 #define DRIVER_AUTHOR "Wolfgang Grandegger <wolfgang@ces.ch>"
 #define DRIVER_DESC "Magic Control Technology USB-RS232 converter driver"
 
-static int debug;
+static bool debug;
 
 /*
  * Function prototypes
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -71,7 +71,7 @@ struct moschip_port {
 	struct urb		*write_urb_pool[NUM_URBS];
 };
 
-static int debug;
+static bool debug;
 
 static struct usb_serial_driver moschip7720_2port_driver;
 
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -263,7 +263,7 @@ struct moschip_port {
 };
 
 
-static int debug;
+static bool debug;
 
 /*
  * mos7840_set_reg_sync
diff --git a/drivers/usb/serial/navman.c b/drivers/usb/serial/navman.c
--- a/drivers/usb/serial/navman.c
+++ b/drivers/usb/serial/navman.c
@@ -21,7 +21,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0a99, 0x0001) },	/* Talon Technology device */
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -49,7 +49,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
-static int debug;
+static bool debug;
 
 /*
  * Version Information
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -32,7 +32,7 @@
  * an examples of 1D barcode types are EAN, UPC, Code39, IATA etc.. */
 #define DRIVER_DESC	"Opticon USB barcode to serial driver (1D)"
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x065a, 0x0009) },
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1220,7 +1220,7 @@ static struct usb_serial_driver option_1
 #endif
 };
 
-static int debug;
+static bool debug;
 
 /* per port private data */
 
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -74,7 +74,7 @@ static struct usb_driver oti6858_driver 
 	.no_dynamic_id = 	1,
 };
 
-static int debug;
+static bool debug;
 
 /* requests */
 #define	OTI6858_REQ_GET_STATUS		(USB_DIR_IN | USB_TYPE_VENDOR | 0x00)
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -36,7 +36,7 @@
  */
 #define DRIVER_DESC "Prolific PL2303 USB to serial adaptor driver"
 
-static int debug;
+static bool debug;
 
 #define PL2303_CLOSING_WAIT	(30*HZ)
 
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -22,7 +22,7 @@
 #define DRIVER_AUTHOR "Qualcomm Inc"
 #define DRIVER_DESC "Qualcomm USB Serial driver"
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x05c6, 0x9211)},	/* Acer Gobi QDL device */
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -81,9 +81,9 @@
 #define CONFIG_USB_SERIAL_SAFE_PADDED 0
 #endif
 
-static int debug;
-static int safe = 1;
-static int padded = CONFIG_USB_SERIAL_SAFE_PADDED;
+static bool debug;
+static bool safe = 1;
+static bool padded = CONFIG_USB_SERIAL_SAFE_PADDED;
 
 #define DRIVER_VERSION "v0.1"
 #define DRIVER_AUTHOR "sl@lineo.com, tbr@lineo.com, Johan Hovold <jhovold@gmail.com>"
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -46,8 +46,8 @@
    allocations > PAGE_SIZE and the number of packets in a page
    is an integer 512 is the largest possible packet on EHCI */
 
-static int debug;
-static int nmea;
+static bool debug;
+static bool nmea;
 
 /* Used in interface blacklisting */
 struct sierra_iface_info {
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -33,7 +33,7 @@
 #define DRIVER_VERSION	"v0.10"
 #define DRIVER_DESC 	"SPCP8x5 USB to serial adaptor driver"
 
-static int debug;
+static bool debug;
 
 #define SPCP8x5_007_VID		0x04FC
 #define SPCP8x5_007_PID		0x0201
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -46,7 +46,7 @@
 #define FULLPWRBIT          0x00000080
 #define NEXT_BOARD_POWER_BIT        0x00000004
 
-static int debug;
+static bool debug;
 
 /* Version Information */
 #define DRIVER_VERSION "v0.1"
diff --git a/drivers/usb/serial/symbolserial.c b/drivers/usb/serial/symbolserial.c
--- a/drivers/usb/serial/symbolserial.c
+++ b/drivers/usb/serial/symbolserial.c
@@ -20,7 +20,7 @@
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
 
-static int debug;
+static bool debug;
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x05e0, 0x0600) },
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -150,7 +150,7 @@ static int ti_download_firmware(struct t
 /* Data */
 
 /* module parameters */
-static int debug;
+static bool debug;
 static int closing_wait = TI_DEFAULT_CLOSING_WAIT;
 static ushort vendor_3410[TI_EXTRA_VID_PID_COUNT];
 static unsigned int vendor_3410_count;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -61,7 +61,7 @@ static struct usb_driver usb_serial_driv
    drivers depend on it.
 */
 
-static int debug;
+static bool debug;
 /* initially all NULL */
 static struct usb_serial *serial_table[SERIAL_TTY_MINORS];
 static DEFINE_MUTEX(table_lock);
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -37,7 +37,7 @@
 #include <linux/serial.h>
 #include "usb-wwan.h"
 
-static int debug;
+static bool debug;
 
 void usb_wwan_dtr_rts(struct usb_serial_port *port, int on)
 {
diff --git a/drivers/usb/serial/visor.c b/drivers/usb/serial/visor.c
--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -52,7 +52,7 @@ static int palm_os_4_probe(struct usb_se
 					const struct usb_device_id *id);
 
 /* Parameters that may be passed into the module. */
-static int debug;
+static bool debug;
 static __u16 vendor;
 static __u16 product;
 
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -87,7 +87,7 @@
 #include <linux/ihex.h>
 #include "whiteheat.h"			/* WhiteHEAT specific commands */
 
-static int debug;
+static bool debug;
 
 #ifndef CMSPAR
 #define CMSPAR 0
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -301,9 +301,9 @@ static struct fb_ops atyfb_ops = {
 	.fb_sync	= atyfb_sync,
 };
 
-static int noaccel;
+static bool noaccel;
 #ifdef CONFIG_MTRR
-static int nomtrr;
+static bool nomtrr;
 #endif
 static int vram;
 static int pll;
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -263,19 +263,19 @@ static reg_val common_regs[] = {
         
 static char *mode_option;
 static char *monitor_layout;
-static int noaccel = 0;
+static bool noaccel = 0;
 static int default_dynclk = -2;
-static int nomodeset = 0;
-static int ignore_edid = 0;
-static int mirror = 0;
+static bool nomodeset = 0;
+static bool ignore_edid = 0;
+static bool mirror = 0;
 static int panel_yres = 0;
-static int force_dfp = 0;
-static int force_measure_pll = 0;
+static bool force_dfp = 0;
+static bool force_measure_pll = 0;
 #ifdef CONFIG_MTRR
-static int nomtrr = 0;
+static bool nomtrr = 0;
 #endif
-static int force_sleep;
-static int ignore_devlist;
+static bool force_sleep;
+static bool ignore_devlist;
 #ifdef CONFIG_PMAC_BACKLIGHT
 static int backlight = 1;
 #else
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -350,7 +350,7 @@ struct cirrusfb_info {
 	void (*unmap)(struct fb_info *info);
 };
 
-static int noaccel __devinitdata;
+static bool noaccel __devinitdata;
 static char *mode_option __devinitdata = "640x480@60";
 
 /****************************************************************************/
diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -133,7 +133,7 @@ static struct fb_fix_screeninfo hga_fix 
 /* Don't assume that tty1 will be the initial current console. */
 static int release_io_port = 0;
 static int release_io_ports = 0;
-static int nologo = 0;
+static bool nologo = 0;
 
 /* -------------------------------------------------------------------------
  *
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -135,8 +135,8 @@ static struct pci_driver i810fb_driver =
 static char *mode_option __devinitdata = NULL;
 static int vram       __devinitdata = 4;
 static int bpp        __devinitdata = 8;
-static int mtrr       __devinitdata;
-static int accel      __devinitdata;
+static bool mtrr      __devinitdata;
+static bool accel     __devinitdata;
 static int hsync1     __devinitdata;
 static int hsync2     __devinitdata;
 static int vsync1     __devinitdata;
@@ -144,9 +144,9 @@ static int vsync2     __devinitdata;
 static int xres       __devinitdata;
 static int yres;
 static int vyres      __devinitdata;
-static int sync       __devinitdata;
-static int extvga     __devinitdata;
-static int dcolor     __devinitdata;
+static bool sync      __devinitdata;
+static bool extvga    __devinitdata;
+static bool dcolor    __devinitdata;
 static bool ddc3      __devinitdata;
 
 /*------------------------------------------------------------*/
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -230,16 +230,16 @@ MODULE_DESCRIPTION("Framebuffer driver f
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DEVICE_TABLE(pci, intelfb_pci_table);
 
-static int accel        = 1;
+static bool accel       = 1;
 static int vram         = 4;
-static int hwcursor     = 0;
-static int mtrr         = 1;
-static int fixed        = 0;
-static int noinit       = 0;
-static int noregister   = 0;
-static int probeonly    = 0;
-static int idonly       = 0;
-static int bailearly    = 0;
+static bool hwcursor    = 0;
+static bool mtrr        = 1;
+static bool fixed       = 0;
+static bool noinit      = 0;
+static bool noregister  = 0;
+static bool probeonly   = 0;
+static bool idonly      = 0;
+static bool bailearly   = 0;
 static int voffset	= 48;
 static char *mode       = NULL;
 
diff --git a/drivers/video/logo/logo.c b/drivers/video/logo/logo.c
--- a/drivers/video/logo/logo.c
+++ b/drivers/video/logo/logo.c
@@ -21,7 +21,7 @@
 #include <asm/bootinfo.h>
 #endif
 
-static int nologo;
+static bool nologo;
 module_param(nologo, bool, 0);
 MODULE_PARM_DESC(nologo, "Disables startup logo");
 
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -84,11 +84,11 @@
 
 /* --------------------------------------------------------------------- */
 
-static int internal;
-static int external;
-static int libretto;
-static int nostretch;
-static int nopciburst;
+static bool internal;
+static bool external;
+static bool libretto;
+static bool nostretch;
+static bool nopciburst;
 static char *mode_option __devinitdata = NULL;
 
 #ifdef MODULE
diff --git a/drivers/video/omap/omapfb_main.c b/drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c
+++ b/drivers/video/omap/omapfb_main.c
@@ -47,9 +47,9 @@ static unsigned int	def_rotate;
 static unsigned int	def_mirror;
 
 #ifdef CONFIG_FB_OMAP_MANUAL_UPDATE
-static int		manual_update = 1;
+static bool		manual_update = 1;
 #else
-static int		manual_update;
+static bool		manual_update;
 #endif
 
 static struct platform_device	*fbdev_pdev;
diff --git a/drivers/video/omap2/dss/core.c b/drivers/video/omap2/dss/core.c
--- a/drivers/video/omap2/dss/core.c
+++ b/drivers/video/omap2/dss/core.c
@@ -50,7 +50,7 @@ module_param_named(def_disp, def_disp_na
 MODULE_PARM_DESC(def_disp, "default display name");
 
 #ifdef DEBUG
-unsigned int dss_debug;
+bool dss_debug;
 module_param_named(debug, dss_debug, bool, 0644);
 #endif
 
diff --git a/drivers/video/omap2/dss/dsi.c b/drivers/video/omap2/dss/dsi.c
--- a/drivers/video/omap2/dss/dsi.c
+++ b/drivers/video/omap2/dss/dsi.c
@@ -340,8 +340,8 @@ struct dsi_packet_sent_handler_data {
 static struct platform_device *dsi_pdev_map[MAX_NUM_DSI];
 
 #ifdef DEBUG
-static unsigned int dsi_perf;
-module_param_named(dsi_perf, dsi_perf, bool, 0644);
+static bool dsi_perf;
+module_param(dsi_perf, bool, 0644);
 #endif
 
 static inline struct dsi_data *dsi_get_dsidrv_data(struct platform_device *dsidev)
diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2/omapfb/omapfb-main.c
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -43,18 +43,18 @@
 
 static char *def_mode;
 static char *def_vram;
-static int def_vrfb;
+static bool def_vrfb;
 static int def_rotate;
-static int def_mirror;
+static bool def_mirror;
 static bool auto_update;
 static unsigned int auto_update_freq;
 module_param(auto_update, bool, 0);
 module_param(auto_update_freq, uint, 0644);
 
 #ifdef DEBUG
-unsigned int omapfb_debug;
+bool omapfb_debug;
 module_param_named(debug, omapfb_debug, bool, 0644);
-static unsigned int omapfb_test_pattern;
+static bool omapfb_test_pattern;
 module_param_named(test, omapfb_test_pattern, bool, 0644);
 #endif
 
diff --git a/drivers/video/pm2fb.c b/drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c
+++ b/drivers/video/pm2fb.c
@@ -78,12 +78,12 @@ static char *mode_option __devinitdata;
  * these flags allow the user to specify that requests for +ve sync
  * should be silently turned in -ve sync.
  */
-static int lowhsync;
-static int lowvsync;
-static int noaccel __devinitdata;
+static bool lowhsync;
+static bool lowvsync;
+static bool noaccel __devinitdata;
 /* mtrr option */
 #ifdef CONFIG_MTRR
-static int nomtrr __devinitdata;
+static bool nomtrr __devinitdata;
 #endif
 
 /*
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -57,11 +57,11 @@
  */
 static int hwcursor = 1;
 static char *mode_option __devinitdata;
-static int noaccel __devinitdata;
+static bool noaccel __devinitdata;
 
 /* mtrr option */
 #ifdef CONFIG_MTRR
-static int nomtrr __devinitdata;
+static bool nomtrr __devinitdata;
 #endif
 
 /*
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -207,9 +207,9 @@ MODULE_DEVICE_TABLE(pci, rivafb_pci_tbl)
 /* command line data, set in rivafb_setup() */
 static int flatpanel __devinitdata = -1; /* Autodetect later */
 static int forceCRTC __devinitdata = -1;
-static int noaccel   __devinitdata = 0;
+static bool noaccel  __devinitdata = 0;
 #ifdef CONFIG_MTRR
-static int nomtrr __devinitdata = 0;
+static bool nomtrr __devinitdata = 0;
 #endif
 #ifdef CONFIG_PMAC_BACKLIGHT
 static int backlight __devinitdata = 1;
@@ -218,7 +218,7 @@ static int backlight __devinitdata = 0;
 #endif
 
 static char *mode_option __devinitdata = NULL;
-static int  strictmode       = 0;
+static bool strictmode       = 0;
 
 static struct fb_fix_screeninfo __devinitdata rivafb_fix = {
 	.type		= FB_TYPE_PACKED_PIXELS,
diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -130,8 +130,8 @@ static struct usb_device_id id_table[] =
 MODULE_DEVICE_TABLE(usb, id_table);
 
 /* module options */
-static int console;   /* Optionally allow fbcon to consume first framebuffer */
-static int fb_defio = true;  /* Optionally enable fb_defio mmap support */
+static bool console;   /* Optionally allow fbcon to consume first framebuffer */
+static bool fb_defio = true;  /* Optionally enable fb_defio mmap support */
 
 /* ufx keeps a list of urbs for efficient bulk transfers */
 static void ufx_urb_completion(struct urb *urb);
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -93,11 +93,11 @@
 
 /* initialized by setup */
 
-static int vgapass;		/* enable VGA passthrough cable */
+static bool vgapass;		/* enable VGA passthrough cable */
 static int mem;			/* mem size in MB, 0 = autodetect */
-static int clipping = 1;	/* use clipping (slower, safer) */
+static bool clipping = 1;	/* use clipping (slower, safer) */
 static int gfxclk;		/* force FBI freq in Mhz . Dangerous */
-static int slowpci;		/* slow PCI settings */
+static bool slowpci;		/* slow PCI settings */
 
 /*
   Possible default video modes: 800x600@60, 640x480@75, 1024x768@76, 640x480@60
diff --git a/drivers/video/tdfxfb.c b/drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c
+++ b/drivers/video/tdfxfb.c
@@ -169,7 +169,7 @@ static int nowrap = 1;      /* not imple
 static int hwcursor = 1;
 static char *mode_option __devinitdata;
 /* mtrr option */
-static int nomtrr __devinitdata;
+static bool nomtrr __devinitdata;
 
 /* -------------------------------------------------------------------------
  *			Hardware-specific funcions
diff --git a/drivers/video/udlfb.c b/drivers/video/udlfb.c
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@ -69,9 +69,9 @@ static struct usb_device_id id_table[] =
 MODULE_DEVICE_TABLE(usb, id_table);
 
 /* module options */
-static int console = 1; /* Allow fbcon to open framebuffer */
-static int fb_defio = 1;  /* Detect mmap writes using page faults */
-static int shadow = 1; /* Optionally disable shadow framebuffer */
+static bool console = 1; /* Allow fbcon to open framebuffer */
+static bool fb_defio = 1;  /* Detect mmap writes using page faults */
+static bool shadow = 1; /* Optionally disable shadow framebuffer */
 
 /* dlfb keeps a list of urbs for efficient bulk transfers */
 static void dlfb_urb_completion(struct urb *urb);
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -44,11 +44,11 @@ static struct fb_fix_screeninfo uvesafb_
 };
 
 static int mtrr		__devinitdata = 3; /* enable mtrr by default */
-static int blank	= 1;		   /* enable blanking by default */
+static bool blank	= 1;		   /* enable blanking by default */
 static int ypan		= 1; 		 /* 0: scroll, 1: ypan, 2: ywrap */
 static bool pmi_setpal	__devinitdata = true; /* use PMI for palette changes */
-static int nocrtc	__devinitdata; /* ignore CRTC settings */
-static int noedid	__devinitdata; /* don't try DDC transfers */
+static bool nocrtc	__devinitdata; /* ignore CRTC settings */
+static bool noedid	__devinitdata; /* don't try DDC transfers */
 static int vram_remap	__devinitdata; /* set amt. of memory to be used */
 static int vram_total	__devinitdata; /* set total amount of memory */
 static u16 maxclk	__devinitdata; /* maximum pixel clock */
diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -110,7 +110,7 @@ static struct fb_fix_screeninfo vfb_fix 
 	.accel =	FB_ACCEL_NONE,
 };
 
-static int vfb_enable __initdata = 0;	/* disabled by default */
+static bool vfb_enable __initdata = 0;	/* disabled by default */
 module_param(vfb_enable, bool, 0);
 
 static int vfb_check_var(struct fb_var_screeninfo *var,
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -100,7 +100,7 @@ MODULE_PARM_DESC(f71862fg_pin,
 	"Watchdog f71862fg reset output pin configuration. Choose pin 56 or 63"
 			" (default=" __MODULE_STRING(WATCHDOG_F71862FG_PIN)")");
 
-static int nowayout = WATCHDOG_NOWAYOUT;
+static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0444);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -55,7 +55,7 @@ module_param(timeout, ushort, 0);
 MODULE_PARM_DESC(timeout,
 	"Watchdog timeout in ticks. (0<timeout<65536, default=65535)");
 
-static int reset = 1;
+static bool reset = 1;
 module_param(reset, bool, 0);
 MODULE_PARM_DESC(reset,
 	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
diff --git a/drivers/xen/xen-pciback/conf_space.c b/drivers/xen/xen-pciback/conf_space.c
--- a/drivers/xen/xen-pciback/conf_space.c
+++ b/drivers/xen/xen-pciback/conf_space.c
@@ -16,7 +16,7 @@
 #include "conf_space.h"
 #include "conf_space_quirks.h"
 
-static int permissive;
+static bool permissive;
 module_param(permissive, bool, 0644);
 
 /* This is where xen_pcibk_read_config_byte, xen_pcibk_read_config_word,
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -16,7 +16,7 @@
 #define INVALID_EVTCHN_IRQ  (-1)
 struct workqueue_struct *xen_pcibk_wq;
 
-static int __read_mostly passthrough;
+static bool __read_mostly passthrough;
 module_param(passthrough, bool, S_IRUGO);
 MODULE_PARM_DESC(passthrough,
 	"Option to specify how to export PCI topology to guest:\n"\
diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -55,7 +55,7 @@ static				DEFINE_SPINLOCK(nsm_lock);
  * Local NSM state
  */
 u32	__read_mostly		nsm_local_state;
-int	__read_mostly		nsm_use_hostnames;
+bool	__read_mostly		nsm_use_hostnames;
 
 static inline struct sockaddr *nsm_addr(const struct nsm_handle *nsm)
 {
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -84,7 +84,7 @@ retry:
 /*
  * Turn off NFSv4 uid/gid mapping when using AUTH_SYS
  */
-static int nfs4_disable_idmapping = 0;
+static bool nfs4_disable_idmapping = 0;
 
 /*
  * RPC cruft for NFS
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -56,7 +56,7 @@
 #define NFS_64_BIT_INODE_NUMBERS_ENABLED	1
 
 /* Default is to see 64-bit inode numbers */
-static int enable_ino64 = NFS_64_BIT_INODE_NUMBERS_ENABLED;
+static bool enable_ino64 = NFS_64_BIT_INODE_NUMBERS_ENABLED;
 
 static void nfs_invalidate_inode(struct inode *);
 static int nfs_update_inode(struct inode *, struct nfs_fattr *);
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -66,7 +66,7 @@ extern u8 acpi_gbl_create_osi_method;
 extern u8 acpi_gbl_use_default_register_widths;
 extern acpi_name acpi_gbl_trace_method_name;
 extern u32 acpi_gbl_trace_flags;
-extern u32 acpi_gbl_enable_aml_debug_object;
+extern bool acpi_gbl_enable_aml_debug_object;
 extern u8 acpi_gbl_copy_dsdt_locally;
 extern u8 acpi_gbl_truncate_io_addresses;
 extern u8 acpi_gbl_disable_auto_repair;
diff --git a/include/acpi/apei.h b/include/acpi/apei.h
--- a/include/acpi/apei.h
+++ b/include/acpi/apei.h
@@ -16,10 +16,10 @@
 
 #ifdef __KERNEL__
 
-extern int hest_disable;
+extern bool hest_disable;
 extern int erst_disable;
 #ifdef CONFIG_ACPI_APEI_GHES
-extern int ghes_disable;
+extern bool ghes_disable;
 #else
 #define ghes_disable 1
 #endif
diff --git a/include/linux/console.h b/include/linux/console.h
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -152,7 +152,7 @@ extern int braille_register_console(stru
 		char *console_options, char *braille_options);
 extern int braille_unregister_console(struct console *);
 extern void console_sysfs_notify(void);
-extern int console_suspend_enabled;
+extern bool console_suspend_enabled;
 
 /* Suspend and resume console messages over PM events */
 extern void suspend_console(void);
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -195,7 +195,7 @@ extern struct svc_procedure	nlmsvc_proce
 #endif
 extern int			nlmsvc_grace_period;
 extern unsigned long		nlmsvc_timeout;
-extern int			nsm_use_hostnames;
+extern bool			nsm_use_hostnames;
 extern u32			nsm_local_state;
 
 /*
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -396,7 +396,7 @@ static inline void mmc_set_disable_delay
 }
 
 /* Module parameter */
-extern int mmc_assume_removable;
+extern bool mmc_assume_removable;
 
 static inline int mmc_card_is_removable(struct mmc_host *host)
 {
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -21,11 +21,11 @@
 
 /* Control parameters settable through module/boot flags */
 extern enum audit_mode aa_g_audit;
-extern int aa_g_audit_header;
-extern int aa_g_debug;
-extern int aa_g_lock_policy;
-extern int aa_g_logsyscall;
-extern int aa_g_paranoid_load;
+extern bool aa_g_audit_header;
+extern bool aa_g_debug;
+extern bool aa_g_lock_policy;
+extern bool aa_g_logsyscall;
+extern bool aa_g_paranoid_load;
 extern unsigned int aa_g_path_max;
 
 /*
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -709,7 +709,7 @@ module_param_call(mode, param_set_mode, 
 		  &aa_g_profile_mode, S_IRUSR | S_IWUSR);
 
 /* Debug mode */
-int aa_g_debug;
+bool aa_g_debug;
 module_param_named(debug, aa_g_debug, aabool, S_IRUSR | S_IWUSR);
 
 /* Audit mode */
@@ -720,7 +720,7 @@ module_param_call(audit, param_set_audit
 /* Determines if audit header is included in audited messages.  This
  * provides more context if the audit daemon is not running
  */
-int aa_g_audit_header = 1;
+bool aa_g_audit_header = 1;
 module_param_named(audit_header, aa_g_audit_header, aabool,
 		   S_IRUSR | S_IWUSR);
 
@@ -728,12 +728,12 @@ module_param_named(audit_header, aa_g_au
  * TODO: add in at boot loading of policy, which is the only way to
  *       load policy, if lock_policy is set
  */
-int aa_g_lock_policy;
+bool aa_g_lock_policy;
 module_param_named(lock_policy, aa_g_lock_policy, aalockpolicy,
 		   S_IRUSR | S_IWUSR);
 
 /* Syscall logging mode */
-int aa_g_logsyscall;
+bool aa_g_logsyscall;
 module_param_named(logsyscall, aa_g_logsyscall, aabool, S_IRUSR | S_IWUSR);
 
 /* Maximum pathname length before accesses will start getting rejected */
@@ -743,12 +743,12 @@ module_param_named(path_max, aa_g_path_m
 /* Determines how paranoid loading of policy is and how much verification
  * on the loaded policy is done.
  */
-int aa_g_paranoid_load = 1;
+bool aa_g_paranoid_load = 1;
 module_param_named(paranoid_load, aa_g_paranoid_load, aabool,
 		   S_IRUSR | S_IWUSR);
 
 /* Boot time disable flag */
-static unsigned int apparmor_enabled = CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE;
+static bool apparmor_enabled = CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE;
 module_param_named(enabled, apparmor_enabled, aabool, S_IRUSR);
 
 static int __init apparmor_enabled_setup(char *str)
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -32,7 +32,7 @@
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 
-static int allow_unsafe_assigned_interrupts;
+static bool allow_unsafe_assigned_interrupts;
 module_param_named(allow_unsafe_assigned_interrupts,
 		   allow_unsafe_assigned_interrupts, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(allow_unsafe_assigned_interrupts,
