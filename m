Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0IISWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:22:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1564 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0IISWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:22:18 -0400
Subject: [rfc patch] treewide: Convert "static const char <*> foo[] =" to
 "static const char <*> const foo[] ="
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 11:22:16 -0700
Message-ID: <1284056536.24986.182.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To move data to const sections, specify
that the pointed to strings are also const.

For instance:

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2cc4cfc..88a91d4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -243,7 +243,7 @@ static void bond_uninit(struct net_device *bond_dev);
 
 static const char *bond_mode_name(int mode)
 {
-	static const char *names[] = {
+	static const char * const names[] = {
 		[BOND_MODE_ROUNDROBIN] = "load balancing (round-robin)",
 		[BOND_MODE_ACTIVEBACKUP] = "fault-tolerance (active-backup)",
 		[BOND_MODE_XOR] = "load balancing (xor)",

It's a pretty big patch: > ~300KB

There are some additional changes needed to avoid
compilation warnings like:

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 5ea2128..532a1b2 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -793,7 +793,8 @@ static int check_existing_control(struct hda_codec *codec, const char *type, c
 /*
  * build output mixer controls
  */
-static int create_output_mixers(struct hda_codec *codec, const char **names)
+static int create_output_mixers(struct hda_codec *codec,
+                               const char * const *names)

Any ideas on how best to get this verified and included?

Compiled x86 defconfig only

 Documentation/vm/page-types.c                      |    2 +-
 arch/arm/kernel/perf_event.c                       |    2 +-
 arch/arm/kernel/process.c                          |    4 +-
 arch/arm/kernel/setup.c                            |    4 +-
 arch/arm/kernel/traps.c                            |    2 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c      |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |    2 +-
 arch/arm/mach-ep93xx/snappercl15.c                 |    2 +-
 arch/arm/mach-ep93xx/ts72xx.c                      |    2 +-
 arch/arm/mach-omap1/board-fsample.c                |    2 +-
 arch/arm/mach-omap1/board-h2.c                     |    2 +-
 arch/arm/mach-omap1/board-h3.c                     |    2 +-
 arch/arm/mach-omap1/board-perseus2.c               |    2 +-
 arch/arm/mach-pxa/balloon3.c                       |    2 +-
 arch/arm/mach-pxa/em-x270.c                        |    2 +-
 arch/arm/mach-pxa/palmtx.c                         |    2 +-
 arch/arm/mm/alignment.c                            |    2 +-
 arch/arm/plat-mxc/time.c                           |    2 +-
 arch/arm/plat-nomadik/gpio.c                       |    6 +-
 arch/arm/plat-omap/mcbsp.c                         |    2 +-
 arch/avr32/kernel/cpu.c                            |    8 +-
 arch/avr32/kernel/process.c                        |    2 +-
 arch/frv/kernel/gdb-stub.c                         |    2 +-
 arch/frv/kernel/traps.c                            |    2 +-
 arch/ia64/kernel/palinfo.c                         |   12 ++--
 arch/ia64/kernel/topology.c                        |    4 +-
 arch/ia64/kernel/traps.c                           |    2 +-
 arch/m68k/apollo/config.c                          |    2 +-
 arch/m68k/kernel/traps.c                           |    4 +-
 arch/mips/alchemy/devboards/db1200/platform.c      |    2 +-
 arch/mips/cavium-octeon/flash_setup.c              |    2 +-
 arch/mips/dec/prom/identify.c                      |    2 +-
 arch/mips/loongson/common/machtype.c               |    2 +-
 arch/mips/pnx833x/common/platform.c                |    2 +-
 arch/powerpc/platforms/cell/spu_base.c             |    2 +-
 arch/powerpc/platforms/cell/spufs/file.c           |    2 +-
 arch/powerpc/platforms/chrp/setup.c                |    2 +-
 arch/powerpc/platforms/powermac/feature.c          |    3 +-
 arch/powerpc/platforms/powermac/low_i2c.c          |    2 +-
 arch/powerpc/xmon/xmon.c                           |    2 +-
 arch/s390/kernel/irq.c                             |    2 +-
 arch/sh/boards/board-magicpanelr2.c                |    2 +-
 arch/sh/boards/mach-rsk/setup.c                    |    2 +-
 arch/sh/drivers/dma/dma-sh.c                       |    2 +-
 arch/sh/kernel/setup.c                             |    4 +-
 arch/sh/mm/alignment.c                             |    2 +-
 arch/x86/boot/compressed/relocs.c                  |    8 +-
 arch/x86/boot/video-vga.c                          |    2 +-
 arch/x86/kvm/mmutrace.h                            |    2 +-
 arch/x86/math-emu/errors.c                         |    2 +-
 arch/x86/mm/kmemcheck/error.c                      |    2 +-
 drivers/acpi/acpica/nspredef.c                     |    2 +-
 drivers/acpi/acpica/utglobal.c                     |    8 +-
 drivers/ata/ata_piix.c                             |    2 +-
 drivers/ata/libata-eh.c                            |    4 +-
 drivers/ata/pata_hpt366.c                          |    6 +-
 drivers/ata/pata_hpt37x.c                          |    4 +-
 drivers/ata/pata_macio.c                           |    2 +-
 drivers/ata/pata_serverworks.c                     |    2 +-
 drivers/atm/eni.c                                  |    2 +-
 drivers/atm/fore200e.c                             |    6 +-
 drivers/atm/zatm.c                                 |    2 +-
 drivers/block/cciss.c                              |    2 +-
 drivers/block/drbd/drbd_int.h                      |    2 +-
 drivers/block/drbd/drbd_strings.c                  |    8 +-
 drivers/block/pktcdvd.c                            |    2 +-
 drivers/block/sx8.c                                |    2 +-
 drivers/cdrom/cdrom.c                              |    4 +-
 drivers/char/ds1620.c                              |    2 +-
 drivers/char/hvsi.c                                |    2 +-
 drivers/char/tpm/tpm_bios.c                        |    4 +-
 drivers/edac/edac_mc_sysfs.c                       |    6 +-
 drivers/edac/i5100_edac.c                          |    2 +-
 drivers/edac/i5400_edac.c                          |    6 +-
 drivers/firewire/ohci.c                            |   10 ++--
 drivers/gpu/drm/i915/intel_sdvo.c                  |    4 +-
 drivers/gpu/drm/radeon/radeon_atombios.c           |    4 +-
 drivers/hid/hid-core.c                             |    2 +-
 drivers/hid/hid-debug.c                            |    2 +-
 drivers/hid/hid-picolcd.c                          |    2 +-
 drivers/hwmon/adt7475.c                            |    2 +-
 drivers/hwmon/applesmc.c                           |    2 +-
 drivers/hwmon/f71805f.c                            |    4 +-
 drivers/hwmon/f71882fg.c                           |    2 +-
 drivers/hwmon/it87.c                               |    4 +-
 drivers/hwmon/smsc47m1.c                           |    2 +-
 drivers/hwmon/w83627ehf.c                          |    2 +-
 drivers/hwmon/w83627hf.c                           |    2 +-
 drivers/hwmon/wm831x-hwmon.c                       |    2 +-
 drivers/hwmon/wm8350-hwmon.c                       |    2 +-
 drivers/i2c/busses/i2c-amd756.c                    |    2 +-
 drivers/i2c/busses/i2c-i801.c                      |    2 +-
 drivers/i2c/busses/i2c-nomadik.c                   |    2 +-
 drivers/i2c/busses/scx200_acb.c                    |    2 +-
 drivers/ide/buddha.c                               |    2 +-
 drivers/ide/hpt366.c                               |    8 +-
 drivers/ide/ide-eh.c                               |    3 +-
 drivers/ide/ide-iops.c                             |    2 +-
 drivers/ide/ide-xfer-mode.c                        |   12 +---
 drivers/ide/macide.c                               |    3 +-
 drivers/ide/pmac.c                                 |    2 +-
 drivers/ide/serverworks.c                          |    2 +-
 drivers/ide/siimage.c                              |    3 +-
 drivers/infiniband/core/sysfs.c                    |    2 +-
 drivers/infiniband/hw/amso1100/c2_ae.c             |    2 +-
 drivers/infiniband/hw/amso1100/c2_qp.c             |    2 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c          |    2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c             |    2 +-
 drivers/infiniband/hw/qib/qib_sysfs.c              |    2 +-
 drivers/input/joystick/gamecon.c                   |    2 +-
 drivers/input/joystick/grip_mp.c                   |    2 +-
 drivers/input/mouse/sermouse.c                     |    2 +-
 drivers/input/touchscreen/elo.c                    |    2 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c            |    6 +-
 drivers/isdn/hardware/mISDN/w6692.c                |    2 +-
 drivers/isdn/hisax/bkm_a8.c                        |    3 +-
 drivers/isdn/hisax/elsa.c                          |    6 +-
 drivers/isdn/hisax/isar.c                          |    4 +-
 drivers/isdn/hisax/sedlbauer.c                     |    3 +-
 drivers/isdn/sc/init.c                             |    2 +-
 drivers/leds/leds-wm831x-status.c                  |    2 +-
 drivers/macintosh/via-pmu.c                        |    2 +-
 drivers/media/dvb/b2c2/flexcop-misc.c              |    6 +-
 drivers/media/dvb/firewire/firedtv-avc.c           |    2 +-
 drivers/media/dvb/frontends/drx397xD.c             |    2 +-
 drivers/media/dvb/frontends/stb6100.c              |    2 +-
 drivers/media/video/au0828/au0828-video.c          |    2 +-
 drivers/media/video/cpia2/cpia2_core.c             |    2 +-
 drivers/media/video/cx18/cx18-mailbox.c            |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c        |    2 +-
 drivers/media/video/cx2341x.c                      |   16 +++---
 drivers/media/video/cx23885/cx23885-video.c        |    2 +-
 drivers/media/video/cx88/cx88-video.c              |    2 +-
 drivers/media/video/em28xx/em28xx-video.c          |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    4 +-
 drivers/media/video/ivtv/ivtv-i2c.c                |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-ctrl.c         |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-devattr.c      |    8 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c          |   16 +++---
 drivers/media/video/s2255drv.c                     |    2 +-
 drivers/media/video/saa7134/saa7134-video.c        |    2 +-
 drivers/media/video/tveeprom.c                     |    2 +-
 drivers/media/video/v4l2-ctrls.c                   |   38 ++++++------
 drivers/media/video/v4l2-ioctl.c                   |    6 +-
 drivers/media/video/w9966.c                        |    4 +-
 drivers/mfd/wm8994-core.c                          |    2 +-
 drivers/mmc/core/debugfs.c                         |    2 +-
 drivers/mmc/host/atmel-mci.c                       |    2 +-
 drivers/mmc/host/omap.c                            |    2 +-
 drivers/mmc/host/omap_hsmmc.c                      |    2 +-
 drivers/mtd/devices/sst25l.c                       |    3 +-
 drivers/mtd/maps/bfin-async-flash.c                |    2 +-
 drivers/mtd/maps/ceiva.c                           |    2 +-
 drivers/mtd/maps/dc21285.c                         |    2 +-
 drivers/mtd/maps/edb7312.c                         |    4 +-
 drivers/mtd/maps/gpio-addr-flash.c                 |    2 +-
 drivers/mtd/maps/h720x-flash.c                     |    2 +-
 drivers/mtd/maps/impa7.c                           |    4 +-
 drivers/mtd/maps/integrator-flash.c                |    2 +-
 drivers/mtd/maps/intel_vr_nor.c                    |    5 +-
 drivers/mtd/maps/ixp2000.c                         |    2 +-
 drivers/mtd/maps/ixp4xx.c                          |    2 +-
 drivers/mtd/maps/physmap.c                         |    4 +-
 drivers/mtd/maps/physmap_of.c                      |    2 +-
 drivers/mtd/maps/pxa2xx-flash.c                    |    2 +-
 drivers/mtd/maps/rbtx4939-flash.c                  |    4 +-
 drivers/mtd/maps/sa1100-flash.c                    |    2 +-
 drivers/mtd/maps/solutionengine.c                  |    2 +-
 drivers/mtd/maps/tsunami_flash.c                   |    2 +-
 drivers/mtd/nand/atmel_nand.c                      |    2 +-
 drivers/mtd/nand/cafe_nand.c                       |    2 +-
 drivers/mtd/nand/cs553x_nand.c                     |    2 +-
 drivers/mtd/nand/fsl_upm.c                         |    2 +-
 drivers/mtd/nand/jz4740_nand.c                     |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |    2 +-
 drivers/mtd/nand/mxc_nand.c                        |    2 +-
 drivers/mtd/nand/ndfc.c                            |    4 +-
 drivers/mtd/nand/omap2.c                           |    2 +-
 drivers/mtd/nand/orion_nand.c                      |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |    2 +-
 drivers/mtd/nand/sharpsl.c                         |    2 +-
 drivers/mtd/nand/socrates_nand.c                   |    2 +-
 drivers/mtd/nand/tmio_nand.c                       |    2 +-
 drivers/mtd/nand/txx9ndfmc.c                       |    2 +-
 drivers/mtd/onenand/generic.c                      |    2 +-
 drivers/mtd/onenand/samsung.c                      |    2 +-
 drivers/net/bonding/bond_main.c                    |    2 +-
 drivers/net/cxgb3/cxgb3_main.c                     |    4 +-
 drivers/net/cxgb4/cxgb4_main.c                     |    8 +-
 drivers/net/hamradio/baycom_ser_fdx.c              |    2 +-
 drivers/net/hamradio/baycom_ser_hdx.c              |    2 +-
 drivers/net/hamradio/yam.c                         |    3 +-
 drivers/net/hp100.c                                |    2 +-
 drivers/net/ipg.c                                  |    2 +-
 drivers/net/mac8390.c                              |    2 +-
 drivers/net/mlx4/fw.c                              |    2 +-
 drivers/net/mlx4/profile.c                         |    2 +-
 drivers/net/ns83820.c                              |    2 +-
 drivers/net/pcmcia/3c574_cs.c                      |    2 +-
 drivers/net/pcmcia/3c589_cs.c                      |    2 +-
 drivers/net/pcmcia/nmclan_cs.c                     |    2 +-
 drivers/net/pcmcia/pcnet_cs.c                      |    2 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |    2 +-
 drivers/net/pcmcia/xirc2ps_cs.c                    |    2 +-
 drivers/net/qlcnic/qlcnic_init.c                   |    2 +-
 drivers/net/sfc/mcdi.c                             |    4 +-
 drivers/net/sis900.c                               |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/tlan.c                                 |    2 +-
 drivers/net/wan/z85230.c                           |    2 +-
 drivers/net/wimax/i2400m/sdio.c                    |    2 +-
 drivers/net/wimax/i2400m/usb.c                     |    4 +-
 drivers/net/wireless/airo.c                        |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    4 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |    2 +-
 drivers/net/wireless/libertas/mesh.c               |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |    4 +-
 drivers/net/wireless/p54/eeprom.c                  |    2 +-
 drivers/net/wireless/ray_cs.c                      |    6 +-
 drivers/parisc/dino.c                              |    4 +-
 drivers/parport/daisy.c                            |    2 +-
 drivers/pci/dmar.c                                 |    6 +-
 drivers/pci/pcie/aer/ecrc.c                        |    2 +-
 drivers/pci/pcie/aspm.c                            |    2 +-
 drivers/pci/slot.c                                 |    2 +-
 drivers/pcmcia/au1000_generic.c                    |    2 +-
 drivers/pcmcia/pxa2xx_base.c                       |    2 +-
 drivers/pcmcia/sa11xx_base.c                       |    2 +-
 drivers/platform/x86/eeepc-laptop.c                |    4 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/power/wm831x_power.c                       |    2 +-
 drivers/ps3/ps3-vuart.c                            |    2 +-
 drivers/s390/net/ctcm_mpc.c                        |    4 +-
 drivers/s390/net/netiucv.c                         |    8 +-
 drivers/s390/scsi/zfcp_dbf.c                       |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    4 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c                 |   15 ++---
 drivers/scsi/aic7xxx_old.c                         |    2 +-
 drivers/scsi/aic94xx/aic94xx_sds.c                 |    8 +-
 drivers/scsi/arm/fas216.c                          |    4 +-
 drivers/scsi/constants.c                           |    2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c          |    3 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |    3 +-
 drivers/scsi/esp_scsi.c                            |    2 +-
 drivers/scsi/fcoe/libfcoe.c                        |    2 +-
 drivers/scsi/fnic/fnic_scsi.c                      |    4 +-
 drivers/scsi/hpsa.c                                |    2 +-
 drivers/scsi/ibmmca.c                              |    2 +-
 drivers/scsi/ipr.c                                 |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |    2 +-
 drivers/scsi/libfc/fc_rport.c                      |    2 +-
 drivers/scsi/libsas/sas_dump.c                     |    6 +-
 drivers/scsi/libsas/sas_expander.c                 |    2 +-
 drivers/scsi/nsp32_debug.c                         |    6 +-
 drivers/scsi/pcmcia/nsp_debug.c                    |    6 +-
 drivers/scsi/sd.c                                  |    2 +-
 drivers/scsi/sr.c                                  |    3 +-
 drivers/scsi/st.c                                  |    2 +-
 drivers/ssb/driver_mipscore.c                      |    2 +-
 drivers/staging/cx25821/cx25821-video.c            |    2 +-
 drivers/staging/dream/qdsp5/audio_out.c            |    2 +-
 drivers/staging/dream/qdsp5/audpp.c                |    2 +-
 drivers/staging/iio/magnetometer/hmc5843.c         |    4 +-
 drivers/staging/octeon/cvmx-spi.c                  |    3 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    2 +-
 drivers/staging/rtl8192e/ieee80211.h               |    2 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |    2 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    2 +-
 drivers/staging/solo6x10/solo6010-v4l2.c           |    6 +-
 drivers/staging/usbip/vhci_hcd.c                   |    2 +-
 .../staging/westbridge/astoria/gadget/cyasgadget.c |    2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/class/usblp.c                          |    2 +-
 drivers/usb/core/devio.c                           |    4 +-
 drivers/usb/gadget/amd5536udc.c                    |    2 +-
 drivers/usb/gadget/imx_udc.h                       |    2 +-
 drivers/usb/gadget/m66592-udc.c                    |    2 +-
 drivers/usb/gadget/pxa25x_udc.h                    |    2 +-
 drivers/usb/gadget/r8a66597-udc.c                  |    2 +-
 drivers/usb/gadget/s3c2410_udc.h                   |    2 +-
 drivers/usb/host/imx21-dbg.c                       |    6 +-
 drivers/usb/host/whci/debug.c                      |    2 +-
 drivers/usb/serial/ftdi_sio.c                      |    2 +-
 drivers/usb/wusbcore/devconnect.c                  |    2 +-
 drivers/uwb/rsv.c                                  |    4 +-
 drivers/uwb/wlp/eda.c                              |    2 +-
 drivers/uwb/wlp/messages.c                         |    2 +-
 drivers/video/omap2/displays/panel-acx565akm.c     |    2 +-
 drivers/video/omap2/displays/panel-taal.c          |    2 +-
 drivers/video/omap2/dss/manager.c                  |    2 +-
 drivers/video/s1d13xxxfb.c                         |    2 +-
 drivers/watchdog/cpwd.c                            |    2 +-
 drivers/watchdog/f71808e_wdt.c                     |    2 +-
 fs/afs/volume.c                                    |    2 +-
 fs/hpfs/name.c                                     |    4 +-
 fs/ocfs2/dlm/dlmdebug.c                            |    4 +-
 fs/proc/array.c                                    |    2 +-
 include/net/tcp.h                                  |    2 +-
 init/do_mounts_initrd.c                            |    2 +-
 kernel/cgroup_freezer.c                            |    2 +-
 kernel/lockdep.c                                   |    7 +-
 kernel/sched.c                                     |    2 +-
 kernel/sched_debug.c                               |    2 +-
 kernel/trace/trace.c                               |    2 +-
 lib/kobject_uevent.c                               |    2 +-
 mm/memory-failure.c                                |    2 +-
 net/mac80211/mesh_plink.c                          |    2 +-
 samples/kfifo/record-example.c                     |    2 +-
 sound/aoa/soundbus/i2sbus/core.c                   |    2 +-
 sound/pci/ac97/ac97_codec.c                        |    8 +-
 sound/pci/ac97/ac97_patch.c                        |   66 +++++++++----------
 sound/pci/ac97/ac97_proc.c                         |    3 +-
 sound/pci/hda/hda_generic.c                        |    4 +-
 sound/pci/hda/patch_analog.c                       |    6 +-
 sound/pci/hda/patch_conexant.c                     |    4 +-
 sound/pci/hda/patch_realtek.c                      |    4 +-
 sound/pci/hda/patch_sigmatel.c                     |    4 +-
 sound/pci/hda/patch_via.c                          |    4 +-
 sound/pci/ice1712/revo.c                           |    2 +-
 sound/pci/ice1712/se.c                             |    4 +-
 sound/soc/codecs/88pm860x-codec.c                  |   26 ++++----
 sound/soc/codecs/ad1836.c                          |    2 +-
 sound/soc/codecs/ad193x.c                          |    2 +-
 sound/soc/codecs/ad1980.c                          |    2 +-
 sound/soc/codecs/ak4535.c                          |   10 ++--
 sound/soc/codecs/ak4671.c                          |    6 +-
 sound/soc/codecs/cs4270.c                          |    2 +-
 sound/soc/codecs/cs42l51.c                         |    8 +-
 sound/soc/codecs/max9877.c                         |    4 +-
 sound/soc/codecs/ssm2602.c                         |    4 +-
 sound/soc/codecs/stac9766.c                        |   18 +++---
 sound/soc/codecs/tlv320aic23.c                     |    4 +-
 sound/soc/codecs/tlv320aic26.c                     |    2 +-
 sound/soc/codecs/tlv320aic3x.c                     |   15 ++---
 sound/soc/codecs/tlv320dac33.c                     |    2 +-
 sound/soc/codecs/twl4030.c                         |   30 ++++-----
 sound/soc/codecs/twl6040.c                         |    6 +-
 sound/soc/codecs/uda134x.c                         |    6 +-
 sound/soc/codecs/uda1380.c                         |   18 +++---
 sound/soc/codecs/wl1273.c                          |    4 +-
 sound/soc/codecs/wm8350.c                          |   16 +++---
 sound/soc/codecs/wm8400.c                          |   12 +---
 sound/soc/codecs/wm8510.c                          |    6 +-
 sound/soc/codecs/wm8523.c                          |    2 +-
 sound/soc/codecs/wm8731.c                          |    4 +-
 sound/soc/codecs/wm8750.c                          |   30 +++++-----
 sound/soc/codecs/wm8753.c                          |   59 +++++++++---------
 sound/soc/codecs/wm8900.c                          |   14 ++--
 sound/soc/codecs/wm8903.c                          |   28 ++++----
 sound/soc/codecs/wm8904.c                          |   16 +++---
 sound/soc/codecs/wm8940.c                          |    8 +-
 sound/soc/codecs/wm8955.c                          |    6 +-
 sound/soc/codecs/wm8960.c                          |   10 ++--
 sound/soc/codecs/wm8961.c                          |    6 +-
 sound/soc/codecs/wm8962.c                          |    4 +-
 sound/soc/codecs/wm8971.c                          |   26 ++++----
 sound/soc/codecs/wm8974.c                          |   22 +++---
 sound/soc/codecs/wm8978.c                          |   20 +++---
 sound/soc/codecs/wm8988.c                          |   28 ++++----
 sound/soc/codecs/wm8990.c                          |   12 +---
 sound/soc/codecs/wm8993.c                          |   26 ++++----
 sound/soc/codecs/wm8994.c                          |   18 +++---
 sound/soc/codecs/wm9081.c                          |   14 ++--
 sound/soc/codecs/wm9705.c                          |    4 +-
 sound/soc/codecs/wm9712.c                          |   22 +++---
 sound/soc/codecs/wm9713.c                          |   33 +++++-----
 sound/soc/codecs/wm_hubs.c                         |    4 +-
 sound/soc/omap/ams-delta.c                         |    3 +-
 sound/soc/omap/n810.c                              |    6 +-
 sound/soc/omap/rx51.c                              |    6 +-
 sound/soc/omap/sdp4430.c                           |    2 +-
 sound/soc/pxa/corgi.c                              |    4 +-
 sound/soc/pxa/magician.c                           |    2 +-
 sound/soc/pxa/poodle.c                             |    4 +-
 sound/soc/pxa/spitz.c                              |    4 +-
 sound/soc/pxa/tosa.c                               |    4 +-
 sound/soc/s3c24xx/neo1973_wm8753.c                 |    4 +-
 tools/perf/builtin-kmem.c                          |    2 +-
 tools/perf/builtin-lock.c                          |    2 +-
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/builtin-timechart.c                     |    2 +-
 tools/perf/builtin-top.c                           |    2 +-
 tools/perf/util/debugfs.c                          |    2 +-
 tools/perf/util/pager.c                            |    2 +-
 tools/perf/util/parse-events.c                     |    4 +-
 390 files changed, 836 insertions(+), 896 deletions(-)


