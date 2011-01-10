Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab1AJUgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:36:47 -0500
Received: from kroah.org ([198.145.64.141]:41685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab1AJUgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:36:43 -0500
Date: Mon, 10 Jan 2011 12:36:38 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING patches for .38
Message-ID: <20110110203638.GA22263@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the big staging tree merge for .38.

Note, when you pull, there will be a trivial merge conflict in the udlfp
driver, which I'm sure you can handle on your own.  If not, I'll be glad
to do the merge myself.

While we do delete the batman-adv driver (as it is now in the main
portion of the kernel), the overall diffstat is still increasing:
 566 files changed, 51147 insertions(+), 32282 deletions(-)

This is mostly due to the new iio drivers that have been added, as well
as a few other minor ones.

The majority of the patches in here are cleanups for the different
drivers, which have all gotten smaller due to them (broadcom, hyperv,
etc.)  Nothing major here at all.

There are 3 files outside of drivers/staging/ that are touched in this
series:
  MAINTAINERS
	- entry was changed for one of the drivers
  drivers/usb/serial/option.c
	- device id fixed up where it was duplicated with a staging
	  driver
  include/linux/rar_register.h
	- changes needed for the sep driver

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-next

All of these patches have been in the -next trees for a while.
These patches will be sent to the linux driver project list for all to
see.

thanks,

greg k-h

--------------


 MAINTAINERS                                        |    4 +-
 drivers/staging/Kconfig                            |   10 +-
 drivers/staging/Makefile                           |    5 +-
 drivers/staging/adis16255/Kconfig                  |   11 -
 drivers/staging/adis16255/Makefile                 |    1 -
 drivers/staging/adis16255/adis16255.c              |  468 ---
 drivers/staging/adis16255/adis16255.h              |   12 -
 drivers/staging/asus_oled/asus_oled.c              |    2 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    4 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    2 +-
 drivers/staging/autofs/dirhash.c                   |   87 +-
 drivers/staging/batman-adv/Kconfig                 |   26 -
 drivers/staging/batman-adv/Makefile                |   22 -
 drivers/staging/batman-adv/README                  |  240 --
 drivers/staging/batman-adv/TODO                    |   14 -
 drivers/staging/batman-adv/aggregation.c           |  275 --
 drivers/staging/batman-adv/aggregation.h           |   43 -
 drivers/staging/batman-adv/bat_debugfs.c           |  343 --
 drivers/staging/batman-adv/bat_debugfs.h           |   33 -
 drivers/staging/batman-adv/bat_sysfs.c             |  558 ---
 drivers/staging/batman-adv/bat_sysfs.h             |   42 -
 drivers/staging/batman-adv/bitarray.c              |  201 --
 drivers/staging/batman-adv/bitarray.h              |   47 -
 drivers/staging/batman-adv/hard-interface.c        |  647 ----
 drivers/staging/batman-adv/hard-interface.h        |   58 -
 drivers/staging/batman-adv/hash.c                  |  306 --
 drivers/staging/batman-adv/hash.h                  |  100 -
 drivers/staging/batman-adv/icmp_socket.c           |  359 --
 drivers/staging/batman-adv/icmp_socket.h           |   34 -
 drivers/staging/batman-adv/main.c                  |  217 --
 drivers/staging/batman-adv/main.h                  |  183 -
 drivers/staging/batman-adv/originator.c            |  533 ---
 drivers/staging/batman-adv/originator.h            |   36 -
 drivers/staging/batman-adv/packet.h                |  134 -
 drivers/staging/batman-adv/ring_buffer.c           |   52 -
 drivers/staging/batman-adv/ring_buffer.h           |   28 -
 drivers/staging/batman-adv/routing.c               | 1389 --------
 drivers/staging/batman-adv/routing.h               |   46 -
 drivers/staging/batman-adv/send.c                  |  580 ----
 drivers/staging/batman-adv/send.h                  |   41 -
 drivers/staging/batman-adv/soft-interface.c        |  398 ---
 drivers/staging/batman-adv/soft-interface.h        |   32 -
 .../staging/batman-adv/sysfs-class-net-batman-adv  |   14 -
 drivers/staging/batman-adv/sysfs-class-net-mesh    |   41 -
 drivers/staging/batman-adv/translation-table.c     |  518 ---
 drivers/staging/batman-adv/translation-table.h     |   45 -
 drivers/staging/batman-adv/types.h                 |  241 --
 drivers/staging/batman-adv/unicast.c               |  269 --
 drivers/staging/batman-adv/unicast.h               |   39 -
 drivers/staging/batman-adv/vis.c                   |  895 -----
 drivers/staging/batman-adv/vis.h                   |   37 -
 drivers/staging/bcm/Adapter.h                      |  134 +-
 drivers/staging/bcm/Arp.c                          |   94 -
 drivers/staging/bcm/Bcmchar.c                      |  967 ++----
 drivers/staging/bcm/Bcmnet.c                       |  404 +--
 drivers/staging/bcm/CmHost.c                       |  139 +-
 drivers/staging/bcm/CmHost.h                       |    3 -
 drivers/staging/bcm/DDRInit.c                      |   17 +-
 drivers/staging/bcm/Debug.c                        |   41 -
 drivers/staging/bcm/Debug.h                        |   88 +-
 drivers/staging/bcm/HandleControlPacket.c          |   39 +-
 drivers/staging/bcm/HostMibs.h                     |    7 -
 drivers/staging/bcm/IPv6Protocol.c                 |   10 +-
 drivers/staging/bcm/IPv6ProtocolHdr.h              |    3 -
 drivers/staging/bcm/InterfaceDld.c                 |  136 +-
 drivers/staging/bcm/InterfaceIdleMode.c            |   20 +-
 drivers/staging/bcm/InterfaceIdleMode.h            |    2 -
 drivers/staging/bcm/InterfaceInit.c                |  854 ++---
 drivers/staging/bcm/InterfaceInit.h                |   28 +-
 drivers/staging/bcm/InterfaceIsr.c                 |   44 +-
 drivers/staging/bcm/InterfaceMisc.c                |   29 +-
 drivers/staging/bcm/InterfaceMisc.h                |    3 -
 drivers/staging/bcm/InterfaceRx.c                  |   40 +-
 drivers/staging/bcm/InterfaceTx.c                  |   74 +-
 drivers/staging/bcm/InterfaceTx.h                  |    6 -
 drivers/staging/bcm/Interfacemain.h                |   10 -
 drivers/staging/bcm/LeakyBucket.c                  |   72 +-
 drivers/staging/bcm/Macros.h                       |   40 +-
 drivers/staging/bcm/Makefile                       |    4 +-
 drivers/staging/bcm/Misc.c                         |  536 +---
 drivers/staging/bcm/Osal_Misc.c                    |   27 -
 drivers/staging/bcm/PHSModule.c                    |  234 +-
 drivers/staging/bcm/PHSModule.h                    |   45 -
 drivers/staging/bcm/Protocol.h                     |    6 +-
 drivers/staging/bcm/Prototypes.h                   |  122 +-
 drivers/staging/bcm/Qos.c                          |  106 +-
 drivers/staging/bcm/TODO                           |   25 +-
 drivers/staging/bcm/Transmit.c                     |  393 +--
 drivers/staging/bcm/cntrl_SignalingInterface.h     |  254 --
 drivers/staging/bcm/headers.h                      |   40 +-
 drivers/staging/bcm/hostmibs.c                     |   35 +-
 drivers/staging/bcm/led_control.c                  |  135 +-
 drivers/staging/bcm/nvm.c                          |  642 +---
 drivers/staging/bcm/nvm.h                          |   80 -
 drivers/staging/bcm/osal_misc.h                    |   49 -
 drivers/staging/brcm80211/README                   |   10 +-
 drivers/staging/brcm80211/brcmfmac/README          |    5 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   12 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |  270 +--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   59 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   19 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   40 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   18 +-
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |   36 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  148 +-
 .../staging/brcm80211/brcmfmac/dhd_linux_sched.c   |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |    7 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  348 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |  586 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |   48 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |  578 ++--
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    2 +-
 drivers/staging/brcm80211/include/bcm_rpc.h        |   79 -
 drivers/staging/brcm80211/include/bcm_rpc_tp.h     |  137 -
 drivers/staging/brcm80211/include/bcm_xdr.h        |   60 -
 drivers/staging/brcm80211/include/bcmdefs.h        |   63 +-
 drivers/staging/brcm80211/include/bcmsdbus.h       |    6 +-
 drivers/staging/brcm80211/include/bcmsdh.h         |   12 +-
 drivers/staging/brcm80211/include/bcmsdh_sdmmc.h   |    6 +-
 drivers/staging/brcm80211/include/bcmsrom.h        |    8 +-
 drivers/staging/brcm80211/include/bcmutils.h       |   60 +-
 drivers/staging/brcm80211/include/d11.h            |    7 -
 drivers/staging/brcm80211/include/dbus.h           |  353 --
 drivers/staging/brcm80211/include/epivers.h        |   44 -
 drivers/staging/brcm80211/include/hnddma.h         |   91 +-
 drivers/staging/brcm80211/include/hndpmu.h         |   44 +-
 drivers/staging/brcm80211/include/linux_osl.h      |  407 ---
 drivers/staging/brcm80211/include/linuxver.h       |   38 -
 drivers/staging/brcm80211/include/nicpci.h         |   12 +-
 drivers/staging/brcm80211/include/osl.h            |  209 +-
 drivers/staging/brcm80211/include/proto/ethernet.h |   54 +-
 drivers/staging/brcm80211/include/proto/wpa.h      |   94 -
 drivers/staging/brcm80211/include/rpc_osl.h        |    2 +-
 drivers/staging/brcm80211/include/siutils.h        |   28 +-
 drivers/staging/brcm80211/include/wlioctl.h        |  342 +--
 drivers/staging/brcm80211/phy/wlc_phy_cmn.c        |   63 +-
 drivers/staging/brcm80211/phy/wlc_phy_hal.h        |    6 -
 drivers/staging/brcm80211/phy/wlc_phy_int.h        |    4 +-
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c        |   13 +-
 drivers/staging/brcm80211/phy/wlc_phy_n.c          |   59 +-
 drivers/staging/brcm80211/phy/wlc_phytbl_lcn.c     |    3 +
 drivers/staging/brcm80211/phy/wlc_phytbl_n.c       |    3 +
 drivers/staging/brcm80211/sys/wl_dbg.h             |   72 +-
 drivers/staging/brcm80211/sys/wl_export.h          |    8 +-
 drivers/staging/brcm80211/sys/wl_mac80211.c        | 1026 ++-----
 drivers/staging/brcm80211/sys/wl_mac80211.h        |   50 +-
 drivers/staging/brcm80211/sys/wl_ucode.h           |   12 +
 drivers/staging/brcm80211/sys/wl_ucode_loader.c    |   13 +-
 drivers/staging/brcm80211/sys/wlc_alloc.c          |   70 +-
 drivers/staging/brcm80211/sys/wlc_alloc.h          |   12 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |  316 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.h          |   30 +-
 drivers/staging/brcm80211/sys/wlc_antsel.c         |   49 +-
 drivers/staging/brcm80211/sys/wlc_antsel.h         |   16 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |  806 +++---
 drivers/staging/brcm80211/sys/wlc_bmac.h           |  182 +-
 drivers/staging/brcm80211/sys/wlc_bsscfg.h         |    3 +-
 drivers/staging/brcm80211/sys/wlc_cfg.h            |   24 -
 drivers/staging/brcm80211/sys/wlc_channel.c        |  102 +-
 drivers/staging/brcm80211/sys/wlc_event.c          |   16 +-
 drivers/staging/brcm80211/sys/wlc_event.h          |    5 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       | 1297 +++-----
 drivers/staging/brcm80211/sys/wlc_mac80211.h       |  312 +-
 drivers/staging/brcm80211/sys/wlc_phy_shim.c       |   14 +-
 drivers/staging/brcm80211/sys/wlc_pub.h            |   48 +-
 drivers/staging/brcm80211/sys/wlc_rate.c           |    6 +-
 drivers/staging/brcm80211/sys/wlc_rpc.h            |  527 ---
 drivers/staging/brcm80211/sys/wlc_rpctx.h          |   71 -
 drivers/staging/brcm80211/sys/wlc_scb.h            |    2 +-
 drivers/staging/brcm80211/sys/wlc_stf.c            |   72 +-
 drivers/staging/brcm80211/sys/wlc_stf.h            |   31 +-
 drivers/staging/brcm80211/sys/wlc_types.h          |   31 +-
 drivers/staging/brcm80211/util/aiutils.c           |   25 +-
 drivers/staging/brcm80211/util/bcmotp.c            |   22 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   95 +-
 drivers/staging/brcm80211/util/bcmutils.c          |  112 +-
 drivers/staging/brcm80211/util/bcmwifi.c           |    4 +
 drivers/staging/brcm80211/util/hnddma.c            |  136 +-
 drivers/staging/brcm80211/util/hndpmu.c            |  174 +-
 drivers/staging/brcm80211/util/linux_osl.c         |  247 +--
 drivers/staging/brcm80211/util/nicpci.c            |  125 +-
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    4 +-
 drivers/staging/brcm80211/util/sbutils.c           |   13 +-
 drivers/staging/brcm80211/util/siutils.c           |  206 +-
 drivers/staging/comedi/drivers.c                   |   30 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |    4 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c       |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/comedi/drivers/ii_pci20kc.c        |   66 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |    7 +
 drivers/staging/comedi/drivers/ni_tiocmd.c         |   71 +-
 drivers/staging/comedi/drivers/rtd520.c            |    2 +-
 drivers/staging/comedi/drivers/s526.c              |  139 +-
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/cptm1217/Kconfig                   |   12 +
 drivers/staging/cptm1217/Makefile                  |    2 +
 drivers/staging/cptm1217/TODO                      |    5 +
 drivers/staging/cptm1217/clearpad_tm1217.c         |  675 ++++
 drivers/staging/cptm1217/cp_tm1217.h               |    9 +
 drivers/staging/crystalhd/crystalhd_hw.c           |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |    6 +-
 drivers/staging/cx25821/cx25821-alsa.c             |    2 +-
 drivers/staging/cxt1e1/comet.c                     |    8 +-
 drivers/staging/cxt1e1/functions.c                 |    8 +-
 drivers/staging/cxt1e1/hwprobe.c                   |    4 +-
 drivers/staging/cxt1e1/linux.c                     |   18 +-
 drivers/staging/cxt1e1/musycc.c                    |   58 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |   38 +-
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |    4 +-
 drivers/staging/easycap/Kconfig                    |    1 -
 drivers/staging/easycap/Makefile                   |    1 +
 drivers/staging/easycap/README                     |   93 +-
 drivers/staging/easycap/easycap.h                  |  186 +-
 drivers/staging/easycap/easycap_debug.h            |    2 +
 drivers/staging/easycap/easycap_ioctl.c            | 2286 +++++++------
 drivers/staging/easycap/easycap_low.c              |  895 +++--
 drivers/staging/easycap/easycap_main.c             | 2782 ++++++++++------
 drivers/staging/easycap/easycap_settings.c         |  272 ++-
 drivers/staging/easycap/easycap_sound.c            |  603 +++--
 drivers/staging/easycap/easycap_testcard.c         |  372 ++-
 drivers/staging/et131x/et131x_initpci.c            |    2 +-
 drivers/staging/frontier/alphatrack.c              |    4 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   54 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    8 +-
 drivers/staging/ft1000/ft1000-usb/Makefile         |    2 +-
 .../ft1000-usb/{ft1000_chdev.c => ft1000_debug.c}  |  435 +--
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  386 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |  433 +--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.h      |    4 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |  373 ++-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   34 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   62 +-
 drivers/staging/go7007/go7007-driver.c             |    2 +-
 drivers/staging/hv/Makefile                        |    2 +-
 drivers/staging/hv/blkvsc.c                        |   52 +-
 drivers/staging/hv/blkvsc_drv.c                    |  117 +-
 drivers/staging/hv/channel.c                       |  338 +-
 drivers/staging/hv/channel_mgmt.c                  |  244 +-
 drivers/staging/hv/channel_mgmt.h                  |  245 +-
 drivers/staging/hv/connection.c                    |   56 +-
 drivers/staging/hv/hv.c                            |  346 +-
 drivers/staging/hv/hv.h                            |   36 +-
 drivers/staging/hv/hv_api.h                        |  278 +-
 drivers/staging/hv/hv_utils.c                      |   99 +-
 drivers/staging/hv/netvsc.c                        |  937 +++---
 drivers/staging/hv/netvsc.h                        |  164 +-
 drivers/staging/hv/netvsc_api.h                    |   64 +-
 drivers/staging/hv/netvsc_drv.c                    |   83 +-
 drivers/staging/hv/osd.c                           |  108 +-
 drivers/staging/hv/osd.h                           |   22 +-
 drivers/staging/hv/ring_buffer.c                   |  404 ++--
 drivers/staging/hv/ring_buffer.h                   |   56 +-
 drivers/staging/hv/rndis.h                         |  353 +-
 drivers/staging/hv/rndis_filter.c                  |  640 ++--
 drivers/staging/hv/rndis_filter.h                  |    2 +-
 drivers/staging/hv/storvsc.c                       |  584 ++--
 drivers/staging/hv/storvsc_api.h                   |   54 +-
 drivers/staging/hv/storvsc_drv.c                   |   95 +-
 drivers/staging/hv/vmbus.c                         |  274 --
 drivers/staging/hv/vmbus_api.h                     |   24 -
 drivers/staging/hv/vmbus_drv.c                     |  351 ++-
 drivers/staging/hv/vmbus_private.h                 |    7 +-
 drivers/staging/hv/vstorage.h                      |  106 +-
 drivers/staging/iio/Documentation/sysfs-bus-iio    |  627 +++--
 .../staging/iio/Documentation/sysfs-bus-iio-dds    |   93 +
 drivers/staging/iio/Kconfig                        |    6 +-
 drivers/staging/iio/Makefile                       |    7 +-
 drivers/staging/iio/TODO                           |    4 +
 drivers/staging/iio/accel/Kconfig                  |   27 +
 drivers/staging/iio/accel/Makefile                 |   12 +
 drivers/staging/iio/accel/accel.h                  |   20 +
 drivers/staging/iio/accel/adis16201.h              |  150 +
 drivers/staging/iio/accel/adis16201_core.c         |  659 ++++
 drivers/staging/iio/accel/adis16201_ring.c         |  218 ++
 drivers/staging/iio/accel/adis16201_trigger.c      |  122 +
 drivers/staging/iio/accel/adis16203.h              |  143 +
 drivers/staging/iio/accel/adis16203_core.c         |  568 ++++
 drivers/staging/iio/accel/adis16203_ring.c         |  211 ++
 drivers/staging/iio/accel/adis16203_trigger.c      |  122 +
 drivers/staging/iio/accel/adis16204.h              |  151 +
 drivers/staging/iio/accel/adis16204_core.c         |  613 ++++
 drivers/staging/iio/accel/adis16204_ring.c         |  206 ++
 drivers/staging/iio/accel/adis16204_trigger.c      |  122 +
 drivers/staging/iio/accel/adis16209_ring.c         |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 drivers/staging/iio/adc/Kconfig                    |   91 +-
 drivers/staging/iio/adc/Makefile                   |   15 +
 drivers/staging/iio/adc/ad7150.c                   |  877 +++++
 drivers/staging/iio/adc/ad7152.c                   |  610 ++++
 drivers/staging/iio/adc/ad7291.c                   | 1039 ++++++
 drivers/staging/iio/adc/ad7298.c                   |  501 +++
 drivers/staging/iio/adc/ad7314.c                   |  308 ++
 drivers/staging/iio/adc/ad7745.c                   |  734 ++++
 drivers/staging/iio/adc/ad7816.c                   |  535 +++
 drivers/staging/iio/adc/ad7887.h                   |  105 +
 drivers/staging/iio/adc/ad7887_core.c              |  305 ++
 drivers/staging/iio/adc/ad7887_ring.c              |  266 ++
 drivers/staging/iio/adc/adt7310.c                  |  952 ++++++
 drivers/staging/iio/adc/adt7410.c                  |  915 +++++
 drivers/staging/iio/adc/adt75.c                    |  732 ++++
 drivers/staging/iio/addac/Kconfig                  |   25 +
 drivers/staging/iio/addac/Makefile                 |    7 +
 drivers/staging/iio/addac/adt7316-i2c.c            |  170 +
 drivers/staging/iio/addac/adt7316-spi.c            |  180 +
 drivers/staging/iio/addac/adt7316.c                | 2402 +++++++++++++
 drivers/staging/iio/addac/adt7316.h                |   33 +
 drivers/staging/iio/dac/Kconfig                    |   21 +
 drivers/staging/iio/dac/Makefile                   |    6 +
 drivers/staging/iio/dac/ad5446.c                   |  323 ++
 drivers/staging/iio/dac/ad5446.h                   |   96 +
 drivers/staging/iio/dac/ad5624r.h                  |   21 +
 drivers/staging/iio/dac/ad5624r_spi.c              |  300 ++
 drivers/staging/iio/dac/dac.h                      |    6 +
 drivers/staging/iio/dds/Kconfig                    |   56 +
 drivers/staging/iio/dds/Makefile                   |   11 +
 drivers/staging/iio/dds/ad5930.c                   |  170 +
 drivers/staging/iio/dds/ad9832.c                   |  264 ++
 drivers/staging/iio/dds/ad9834.c                   |  477 +++
 drivers/staging/iio/dds/ad9834.h                   |  112 +
 drivers/staging/iio/dds/ad9850.c                   |  156 +
 drivers/staging/iio/dds/ad9852.c                   |  305 ++
 drivers/staging/iio/dds/ad9910.c                   |  440 +++
 drivers/staging/iio/dds/ad9951.c                   |  249 ++
 drivers/staging/iio/dds/dds.h                      |  110 +
 drivers/staging/iio/gyro/Kconfig                   |   38 +-
 drivers/staging/iio/gyro/Makefile                  |   12 +
 drivers/staging/iio/gyro/adis16060.h               |  101 +
 drivers/staging/iio/gyro/adis16060_core.c          |  319 ++
 drivers/staging/iio/gyro/adis16080.h               |  102 +
 drivers/staging/iio/gyro/adis16080_core.c          |  271 ++
 drivers/staging/iio/gyro/adis16130.h               |  108 +
 drivers/staging/iio/gyro/adis16130_core.c          |  313 ++
 drivers/staging/iio/gyro/adis16251.h               |  185 +
 drivers/staging/iio/gyro/adis16251_core.c          |  777 +++++
 drivers/staging/iio/gyro/adis16260.h               |    3 +
 drivers/staging/iio/gyro/adis16260_core.c          |  142 +-
 drivers/staging/iio/gyro/adis16260_platform_data.h |   19 +
 drivers/staging/iio/gyro/gyro.h                    |    9 +
 drivers/staging/iio/imu/adis16350_core.c           |    1 +
 drivers/staging/iio/meter/Kconfig                  |   61 +
 drivers/staging/iio/meter/Makefile                 |   15 +
 drivers/staging/iio/meter/ade7753.c                |  730 ++++
 drivers/staging/iio/meter/ade7753.h                |  140 +
 drivers/staging/iio/meter/ade7754.c                |  756 +++++
 drivers/staging/iio/meter/ade7754.h                |  161 +
 drivers/staging/iio/meter/ade7758.h                |  171 +
 drivers/staging/iio/meter/ade7758_core.c           |  866 +++++
 drivers/staging/iio/meter/ade7758_ring.c           |  212 ++
 drivers/staging/iio/meter/ade7758_trigger.c        |  125 +
 drivers/staging/iio/meter/ade7759.c                |  670 ++++
 drivers/staging/iio/meter/ade7759.h                |  122 +
 drivers/staging/iio/meter/ade7854-i2c.c            |  272 ++
 drivers/staging/iio/meter/ade7854-spi.c            |  360 ++
 drivers/staging/iio/meter/ade7854.c                |  680 ++++
 drivers/staging/iio/meter/ade7854.h                |  245 ++
 drivers/staging/iio/meter/meter.h                  |  396 +++
 drivers/staging/iio/resolver/Kconfig               |   54 +
 drivers/staging/iio/resolver/Makefile              |    7 +
 drivers/staging/iio/resolver/ad2s120x.c            |  310 ++
 drivers/staging/iio/resolver/ad2s1210.c            |  872 +++++
 drivers/staging/iio/resolver/ad2s90.c              |  159 +
 drivers/staging/iio/sysfs.h                        |    6 +
 drivers/staging/intel_sst/Kconfig                  |    1 +
 drivers/staging/intel_sst/intel_sst.c              |  116 +-
 drivers/staging/intel_sst/intel_sst.h              |    8 +-
 .../staging/intel_sst/intel_sst_app_interface.c    |  314 ++-
 drivers/staging/intel_sst/intel_sst_common.h       |   10 +-
 .../staging/intel_sst/intel_sst_drv_interface.c    |  209 +-
 drivers/staging/intel_sst/intel_sst_dsp.c          |   70 +-
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |  113 +-
 drivers/staging/intel_sst/intel_sst_ioctl.h        |   15 +-
 drivers/staging/intel_sst/intel_sst_ipc.c          |  194 +-
 drivers/staging/intel_sst/intel_sst_pvt.c          |   36 +-
 drivers/staging/intel_sst/intel_sst_stream.c       |   20 +-
 .../staging/intel_sst/intel_sst_stream_encoded.c   |  214 +-
 drivers/staging/intel_sst/intelmid.c               |  192 +-
 drivers/staging/intel_sst/intelmid.h               |    5 -
 drivers/staging/intel_sst/intelmid_ctrl.c          |   28 +-
 drivers/staging/intel_sst/intelmid_msic_control.c  |   24 +-
 drivers/staging/intel_sst/intelmid_pvt.c           |   54 +-
 drivers/staging/intel_sst/intelmid_v0_control.c    |   32 +-
 drivers/staging/intel_sst/intelmid_v1_control.c    |   70 +-
 drivers/staging/intel_sst/intelmid_v2_control.c    |   96 +-
 drivers/staging/keucr/init.c                       |  420 ++--
 drivers/staging/keucr/init.h                       |    3 +
 drivers/staging/keucr/ms.c                         |   10 +-
 drivers/staging/keucr/smilmain.c                   |    4 +-
 drivers/staging/keucr/smilsub.c                    |    4 +-
 drivers/staging/line6/capture.c                    |    2 +-
 drivers/staging/line6/midi.c                       |    4 +-
 drivers/staging/line6/playback.c                   |    2 +-
 drivers/staging/memrar/memrar.h                    |   19 +
 drivers/staging/msm/Makefile                       |    4 +-
 drivers/staging/msm/lcdc_toshiba_wvga_pt.c         |    2 +-
 drivers/staging/msm/tvenc.c                        |    5 +-
 drivers/staging/phison/phison.c                    |    2 +-
 drivers/staging/pohmelfs/crypto.c                  |    6 +-
 drivers/staging/rt2860/chip/mac_pci.h              |    7 +-
 drivers/staging/rt2860/chip/mac_usb.h              |    5 +-
 drivers/staging/rt2860/chip/rtmp_mac.h             |   19 +-
 drivers/staging/rt2860/chip/rtmp_phy.h             |   14 +-
 drivers/staging/rt2860/chips/rt3090.c              |    8 +-
 drivers/staging/rt2860/chips/rt30xx.c              |   13 +-
 drivers/staging/rt2860/common/ba_action.c          |   18 +-
 drivers/staging/rt2860/common/cmm_data.c           |    2 +-
 drivers/staging/rt2860/common/cmm_data_pci.c       |    4 +-
 drivers/staging/rt2860/common/cmm_mac_pci.c        |   10 +-
 drivers/staging/rt2860/common/cmm_mac_usb.c        |    2 +-
 drivers/staging/rt2860/common/cmm_wpa.c            |   22 +-
 drivers/staging/rt2860/common/ee_efuse.c           |   15 +-
 drivers/staging/rt2860/common/mlme.c               |   13 +-
 drivers/staging/rt2860/common/rt_rf.c              |    3 +-
 drivers/staging/rt2860/common/rtmp_init.c          |   24 +-
 drivers/staging/rt2860/common/rtmp_mcu.c           |    4 +-
 drivers/staging/rt2860/common/spectrum.c           |    2 +-
 drivers/staging/rt2860/mlme.h                      |   41 +-
 drivers/staging/rt2860/oid.h                       |   15 +-
 drivers/staging/rt2860/pci_main_dev.c              |   22 +-
 drivers/staging/rt2860/rt_linux.c                  |   35 +-
 drivers/staging/rt2860/rt_linux.h                  |   11 +-
 drivers/staging/rt2860/rt_main_dev.c               |   18 +-
 drivers/staging/rt2860/rt_pci_rbus.c               |    7 +-
 drivers/staging/rt2860/rt_usb.c                    |   45 +-
 drivers/staging/rt2860/rtmp.h                      |   71 +-
 drivers/staging/rt2860/rtmp_def.h                  |   37 +-
 drivers/staging/rt2860/rtmp_timer.h                |   13 +-
 drivers/staging/rt2860/spectrum.h                  |   12 +-
 drivers/staging/rt2860/sta/assoc.c                 |   15 +-
 drivers/staging/rt2860/sta/auth.c                  |   10 +-
 drivers/staging/rt2860/sta/connect.c               |   38 +-
 drivers/staging/rt2860/sta/rtmp_data.c             |   35 +-
 drivers/staging/rt2860/sta/sanity.c                |    5 +-
 drivers/staging/rt2860/sta/sync.c                  |   25 +-
 drivers/staging/rt2860/sta/wpa.c                   |    5 +-
 drivers/staging/rt2860/sta_ioctl.c                 |   25 +-
 drivers/staging/rt2860/usb_main_dev.c              |   20 +-
 drivers/staging/rt2860/wpa.h                       |    5 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192e/r8192E_core.c             |    6 +-
 drivers/staging/rtl8192e/r819xE_phy.c              |    2 +-
 drivers/staging/rtl8192u/Makefile                  |    1 -
 drivers/staging/rtl8192u/dot11d.h                  |    2 -
 drivers/staging/rtl8192u/ieee80211/Makefile        |    2 -
 drivers/staging/rtl8192u/ieee80211/dot11d.c        |    2 -
 drivers/staging/rtl8192u/ieee80211/dot11d.h        |    3 -
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    8 -
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   12 -
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   47 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |    4 -
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   27 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |    6 -
 drivers/staging/rtl8192u/r819xU_phy.c              |    6 +-
 drivers/staging/rtl8712/TODO                       |    1 -
 drivers/staging/rtl8712/osdep_service.h            |   25 +-
 drivers/staging/rtl8712/rtl8712_efuse.c            |    2 +-
 drivers/staging/rtl8712/rtl8712_xmit.c             |    2 +-
 drivers/staging/rtl8712/rtl871x_xmit.c             |    2 +-
 drivers/staging/rtl8712/usb_intf.c                 |    2 +-
 drivers/staging/sep/Kconfig                        |   10 +
 drivers/staging/sep/Makefile                       |    2 +
 drivers/staging/sep/TODO                           |    5 +
 drivers/staging/sep/sep_dev.h                      |  156 +
 drivers/staging/sep/sep_driver.c                   | 3577 ++++++++++++++++++++
 drivers/staging/sep/sep_driver_api.h               |  297 ++
 drivers/staging/sep/sep_driver_config.h            |  239 ++
 drivers/staging/sep/sep_driver_hw_defs.h           |  233 ++
 drivers/staging/sm7xx/smtcfb.c                     |    2 +-
 drivers/staging/solo6x10/Kconfig                   |    4 +-
 drivers/staging/solo6x10/TODO                      |    4 -
 drivers/staging/solo6x10/solo6010-core.c           |   42 +-
 drivers/staging/solo6x10/solo6010-disp.c           |    6 +-
 drivers/staging/solo6x10/solo6010-enc.c            |    6 +-
 drivers/staging/solo6x10/solo6010-g723.c           |   22 +-
 drivers/staging/solo6x10/solo6010-gpio.c           |    4 +-
 drivers/staging/solo6x10/solo6010-i2c.c            |   13 +-
 drivers/staging/solo6x10/solo6010-osd-font.h       |   60 +-
 drivers/staging/solo6x10/solo6010-p2m.c            |  156 +-
 drivers/staging/solo6x10/solo6010-tw28.c           |  118 +-
 drivers/staging/solo6x10/solo6010-v4l2-enc.c       |  370 ++-
 drivers/staging/solo6x10/solo6010-v4l2.c           |  197 +-
 drivers/staging/solo6x10/solo6010.h                |   39 +-
 drivers/staging/speakup/kobjects.c                 |    9 +-
 drivers/staging/speakup/main.c                     |   33 +-
 drivers/staging/speakup/spk_types.h                |    2 +-
 drivers/staging/spectra/ffsport.c                  |   61 +-
 drivers/staging/spectra/ffsport.h                  |    1 +
 drivers/staging/spectra/flash.c                    |    4 +-
 drivers/staging/spectra/lld_emu.c                  |    6 +-
 drivers/staging/spectra/lld_nand.c                 |  177 +-
 drivers/staging/ste_rmi4/Kconfig                   |    9 +
 drivers/staging/ste_rmi4/Makefile                  |    4 +
 drivers/staging/ste_rmi4/TODO                      |    7 +
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c      | 1179 +++++++
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h      |   50 +
 drivers/staging/tidspbridge/core/tiomap3430.c      |    4 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |    2 +-
 drivers/staging/udlfb/udlfb.c                      |    5 +-
 drivers/staging/usbip/vhci_hcd.c                   |   14 -
 drivers/staging/vme/bridges/vme_ca91cx42.c         |  235 +-
 drivers/staging/vme/bridges/vme_ca91cx42.h         |    2 +-
 drivers/staging/vme/bridges/vme_tsi148.c           |  264 +-
 drivers/staging/vme/bridges/vme_tsi148.h           |    2 +-
 drivers/staging/vme/devices/vme_user.c             |   79 +-
 drivers/staging/vme/vme.c                          |  116 +-
 drivers/staging/vme/vme_bridge.h                   |    2 +-
 drivers/staging/vt6655/card.c                      |    2 +-
 drivers/staging/vt6655/iwctl.c                     |    2 +-
 drivers/staging/vt6655/wpa2.c                      |    4 +-
 drivers/staging/vt6656/baseband.c                  |    2 +-
 drivers/staging/vt6656/card.c                      |    2 +-
 drivers/staging/vt6656/dpc.c                       |    4 +-
 drivers/staging/vt6656/iwctl.c                     |    2 +-
 drivers/staging/vt6656/power.c                     |    2 +-
 drivers/staging/vt6656/rxtx.c                      |    3 +-
 drivers/staging/vt6656/tkip.c                      |   37 +-
 drivers/staging/vt6656/wpa2.c                      |    4 +-
 .../arch/arm/mach-omap2/cyashalomap_kernel.c       |   10 +-
 drivers/staging/winbond/Makefile                   |    1 -
 drivers/staging/winbond/core.h                     |    2 +-
 drivers/staging/winbond/mac_structures.h           |  545 ---
 drivers/staging/winbond/mds.c                      |   70 +-
 drivers/staging/winbond/mds_f.h                    |    3 +-
 drivers/staging/winbond/mds_s.h                    |    4 -
 drivers/staging/winbond/mlmetxrx.c                 |   62 -
 drivers/staging/winbond/mlmetxrx_f.h               |   23 -
 drivers/staging/winbond/mto.c                      |    5 +-
 drivers/staging/winbond/phy_calibration.c          |    5 +-
 drivers/staging/winbond/phy_calibration.h          |    2 +-
 drivers/staging/winbond/reg.c                      |   36 +-
 drivers/staging/winbond/sysdef.h                   |   31 -
 drivers/staging/winbond/wb35reg.c                  |   33 +-
 drivers/staging/winbond/wb35reg_f.h                |    2 +-
 drivers/staging/winbond/wb35reg_s.h                |   77 +-
 drivers/staging/winbond/wb35rx.c                   |   30 +-
 drivers/staging/winbond/wb35rx_f.h                 |    2 +-
 drivers/staging/winbond/wb35tx.c                   |   31 +-
 drivers/staging/winbond/wb35tx_f.h                 |    1 -
 drivers/staging/winbond/{wbhal_s.h => wbhal.h}     |   14 +-
 drivers/staging/winbond/wbhal_f.h                  |   81 -
 drivers/staging/winbond/wblinux_f.h                |   17 -
 drivers/staging/winbond/wbusb.c                    |   50 +-
 drivers/staging/winbond/wbusb_s.h                  |   18 -
 drivers/staging/wlags49_h2/wl_pci.c                |    2 +-
 drivers/staging/wlags49_h2/wl_profile.c            |    2 +-
 drivers/staging/wlags49_h2/wl_sysfs.c              |    4 +-
 drivers/staging/wlan-ng/p80211conv.c               |   45 +-
 drivers/staging/wlan-ng/p80211conv.h               |    6 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    6 +-
 drivers/staging/wlan-ng/p80211netdev.h             |   10 +-
 drivers/staging/wlan-ng/p80211types.h              |    4 +-
 drivers/staging/wlan-ng/prism2mgmt.c               |   26 +-
 drivers/staging/xgifb/XGI_main_26.c                |    9 +-
 drivers/staging/zram/xvmalloc.c                    |    6 +-
 drivers/staging/zram/zram_drv.c                    |    3 +-
 drivers/usb/serial/option.c                        |    1 -
 include/linux/rar_register.h                       |   16 +
 566 files changed, 51147 insertions(+), 32282 deletions(-)
 delete mode 100644 drivers/staging/adis16255/Kconfig
 delete mode 100644 drivers/staging/adis16255/Makefile
 delete mode 100644 drivers/staging/adis16255/adis16255.c
 delete mode 100644 drivers/staging/adis16255/adis16255.h
 delete mode 100644 drivers/staging/batman-adv/Kconfig
 delete mode 100644 drivers/staging/batman-adv/Makefile
 delete mode 100644 drivers/staging/batman-adv/README
 delete mode 100644 drivers/staging/batman-adv/TODO
 delete mode 100644 drivers/staging/batman-adv/aggregation.c
 delete mode 100644 drivers/staging/batman-adv/aggregation.h
 delete mode 100644 drivers/staging/batman-adv/bat_debugfs.c
 delete mode 100644 drivers/staging/batman-adv/bat_debugfs.h
 delete mode 100644 drivers/staging/batman-adv/bat_sysfs.c
 delete mode 100644 drivers/staging/batman-adv/bat_sysfs.h
 delete mode 100644 drivers/staging/batman-adv/bitarray.c
 delete mode 100644 drivers/staging/batman-adv/bitarray.h
 delete mode 100644 drivers/staging/batman-adv/hard-interface.c
 delete mode 100644 drivers/staging/batman-adv/hard-interface.h
 delete mode 100644 drivers/staging/batman-adv/hash.c
 delete mode 100644 drivers/staging/batman-adv/hash.h
 delete mode 100644 drivers/staging/batman-adv/icmp_socket.c
 delete mode 100644 drivers/staging/batman-adv/icmp_socket.h
 delete mode 100644 drivers/staging/batman-adv/main.c
 delete mode 100644 drivers/staging/batman-adv/main.h
 delete mode 100644 drivers/staging/batman-adv/originator.c
 delete mode 100644 drivers/staging/batman-adv/originator.h
 delete mode 100644 drivers/staging/batman-adv/packet.h
 delete mode 100644 drivers/staging/batman-adv/ring_buffer.c
 delete mode 100644 drivers/staging/batman-adv/ring_buffer.h
 delete mode 100644 drivers/staging/batman-adv/routing.c
 delete mode 100644 drivers/staging/batman-adv/routing.h
 delete mode 100644 drivers/staging/batman-adv/send.c
 delete mode 100644 drivers/staging/batman-adv/send.h
 delete mode 100644 drivers/staging/batman-adv/soft-interface.c
 delete mode 100644 drivers/staging/batman-adv/soft-interface.h
 delete mode 100644 drivers/staging/batman-adv/sysfs-class-net-batman-adv
 delete mode 100644 drivers/staging/batman-adv/sysfs-class-net-mesh
 delete mode 100644 drivers/staging/batman-adv/translation-table.c
 delete mode 100644 drivers/staging/batman-adv/translation-table.h
 delete mode 100644 drivers/staging/batman-adv/types.h
 delete mode 100644 drivers/staging/batman-adv/unicast.c
 delete mode 100644 drivers/staging/batman-adv/unicast.h
 delete mode 100644 drivers/staging/batman-adv/vis.c
 delete mode 100644 drivers/staging/batman-adv/vis.h
 delete mode 100644 drivers/staging/bcm/Arp.c
 delete mode 100644 drivers/staging/bcm/Debug.c
 delete mode 100644 drivers/staging/bcm/HostMibs.h
 delete mode 100644 drivers/staging/bcm/Interfacemain.h
 delete mode 100644 drivers/staging/bcm/Osal_Misc.c
 delete mode 100644 drivers/staging/bcm/osal_misc.h
 delete mode 100644 drivers/staging/brcm80211/include/bcm_rpc.h
 delete mode 100644 drivers/staging/brcm80211/include/bcm_rpc_tp.h
 delete mode 100644 drivers/staging/brcm80211/include/bcm_xdr.h
 delete mode 100644 drivers/staging/brcm80211/include/dbus.h
 delete mode 100644 drivers/staging/brcm80211/include/epivers.h
 delete mode 100644 drivers/staging/brcm80211/include/linux_osl.h
 delete mode 100644 drivers/staging/brcm80211/include/linuxver.h
 delete mode 100644 drivers/staging/brcm80211/sys/wlc_rpc.h
 delete mode 100644 drivers/staging/brcm80211/sys/wlc_rpctx.h
 create mode 100644 drivers/staging/cptm1217/Kconfig
 create mode 100644 drivers/staging/cptm1217/Makefile
 create mode 100644 drivers/staging/cptm1217/TODO
 create mode 100644 drivers/staging/cptm1217/clearpad_tm1217.c
 create mode 100644 drivers/staging/cptm1217/cp_tm1217.h
 rename drivers/staging/ft1000/ft1000-usb/{ft1000_chdev.c => ft1000_debug.c} (61%)
 delete mode 100644 drivers/staging/hv/vmbus.c
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-dds
 create mode 100644 drivers/staging/iio/accel/adis16201.h
 create mode 100644 drivers/staging/iio/accel/adis16201_core.c
 create mode 100644 drivers/staging/iio/accel/adis16201_ring.c
 create mode 100644 drivers/staging/iio/accel/adis16201_trigger.c
 create mode 100644 drivers/staging/iio/accel/adis16203.h
 create mode 100644 drivers/staging/iio/accel/adis16203_core.c
 create mode 100644 drivers/staging/iio/accel/adis16203_ring.c
 create mode 100644 drivers/staging/iio/accel/adis16203_trigger.c
 create mode 100644 drivers/staging/iio/accel/adis16204.h
 create mode 100644 drivers/staging/iio/accel/adis16204_core.c
 create mode 100644 drivers/staging/iio/accel/adis16204_ring.c
 create mode 100644 drivers/staging/iio/accel/adis16204_trigger.c
 create mode 100644 drivers/staging/iio/adc/ad7150.c
 create mode 100644 drivers/staging/iio/adc/ad7152.c
 create mode 100644 drivers/staging/iio/adc/ad7291.c
 create mode 100644 drivers/staging/iio/adc/ad7298.c
 create mode 100644 drivers/staging/iio/adc/ad7314.c
 create mode 100644 drivers/staging/iio/adc/ad7745.c
 create mode 100644 drivers/staging/iio/adc/ad7816.c
 create mode 100644 drivers/staging/iio/adc/ad7887.h
 create mode 100644 drivers/staging/iio/adc/ad7887_core.c
 create mode 100644 drivers/staging/iio/adc/ad7887_ring.c
 create mode 100644 drivers/staging/iio/adc/adt7310.c
 create mode 100644 drivers/staging/iio/adc/adt7410.c
 create mode 100644 drivers/staging/iio/adc/adt75.c
 create mode 100644 drivers/staging/iio/addac/Kconfig
 create mode 100644 drivers/staging/iio/addac/Makefile
 create mode 100644 drivers/staging/iio/addac/adt7316-i2c.c
 create mode 100644 drivers/staging/iio/addac/adt7316-spi.c
 create mode 100644 drivers/staging/iio/addac/adt7316.c
 create mode 100644 drivers/staging/iio/addac/adt7316.h
 create mode 100644 drivers/staging/iio/dac/Kconfig
 create mode 100644 drivers/staging/iio/dac/Makefile
 create mode 100644 drivers/staging/iio/dac/ad5446.c
 create mode 100644 drivers/staging/iio/dac/ad5446.h
 create mode 100644 drivers/staging/iio/dac/ad5624r.h
 create mode 100644 drivers/staging/iio/dac/ad5624r_spi.c
 create mode 100644 drivers/staging/iio/dac/dac.h
 create mode 100644 drivers/staging/iio/dds/Kconfig
 create mode 100644 drivers/staging/iio/dds/Makefile
 create mode 100644 drivers/staging/iio/dds/ad5930.c
 create mode 100644 drivers/staging/iio/dds/ad9832.c
 create mode 100644 drivers/staging/iio/dds/ad9834.c
 create mode 100644 drivers/staging/iio/dds/ad9834.h
 create mode 100644 drivers/staging/iio/dds/ad9850.c
 create mode 100644 drivers/staging/iio/dds/ad9852.c
 create mode 100644 drivers/staging/iio/dds/ad9910.c
 create mode 100644 drivers/staging/iio/dds/ad9951.c
 create mode 100644 drivers/staging/iio/dds/dds.h
 create mode 100644 drivers/staging/iio/gyro/adis16060.h
 create mode 100644 drivers/staging/iio/gyro/adis16060_core.c
 create mode 100644 drivers/staging/iio/gyro/adis16080.h
 create mode 100644 drivers/staging/iio/gyro/adis16080_core.c
 create mode 100644 drivers/staging/iio/gyro/adis16130.h
 create mode 100644 drivers/staging/iio/gyro/adis16130_core.c
 create mode 100644 drivers/staging/iio/gyro/adis16251.h
 create mode 100644 drivers/staging/iio/gyro/adis16251_core.c
 create mode 100644 drivers/staging/iio/gyro/adis16260_platform_data.h
 create mode 100644 drivers/staging/iio/meter/Kconfig
 create mode 100644 drivers/staging/iio/meter/Makefile
 create mode 100644 drivers/staging/iio/meter/ade7753.c
 create mode 100644 drivers/staging/iio/meter/ade7753.h
 create mode 100644 drivers/staging/iio/meter/ade7754.c
 create mode 100644 drivers/staging/iio/meter/ade7754.h
 create mode 100644 drivers/staging/iio/meter/ade7758.h
 create mode 100644 drivers/staging/iio/meter/ade7758_core.c
 create mode 100644 drivers/staging/iio/meter/ade7758_ring.c
 create mode 100644 drivers/staging/iio/meter/ade7758_trigger.c
 create mode 100644 drivers/staging/iio/meter/ade7759.c
 create mode 100644 drivers/staging/iio/meter/ade7759.h
 create mode 100644 drivers/staging/iio/meter/ade7854-i2c.c
 create mode 100644 drivers/staging/iio/meter/ade7854-spi.c
 create mode 100644 drivers/staging/iio/meter/ade7854.c
 create mode 100644 drivers/staging/iio/meter/ade7854.h
 create mode 100644 drivers/staging/iio/meter/meter.h
 create mode 100644 drivers/staging/iio/resolver/Kconfig
 create mode 100644 drivers/staging/iio/resolver/Makefile
 create mode 100644 drivers/staging/iio/resolver/ad2s120x.c
 create mode 100644 drivers/staging/iio/resolver/ad2s1210.c
 create mode 100644 drivers/staging/iio/resolver/ad2s90.c
 create mode 100644 drivers/staging/sep/Kconfig
 create mode 100644 drivers/staging/sep/Makefile
 create mode 100644 drivers/staging/sep/TODO
 create mode 100644 drivers/staging/sep/sep_dev.h
 create mode 100644 drivers/staging/sep/sep_driver.c
 create mode 100644 drivers/staging/sep/sep_driver_api.h
 create mode 100644 drivers/staging/sep/sep_driver_config.h
 create mode 100644 drivers/staging/sep/sep_driver_hw_defs.h
 create mode 100644 drivers/staging/ste_rmi4/Kconfig
 create mode 100644 drivers/staging/ste_rmi4/Makefile
 create mode 100644 drivers/staging/ste_rmi4/TODO
 create mode 100644 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
 create mode 100644 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.h
 create mode 100644 drivers/staging/vme/bridges/Module.symvers
 delete mode 100644 drivers/staging/winbond/mlmetxrx.c
 delete mode 100644 drivers/staging/winbond/mlmetxrx_f.h
 delete mode 100644 drivers/staging/winbond/sysdef.h
 rename drivers/staging/winbond/{wbhal_s.h => wbhal.h} (98%)
 delete mode 100644 drivers/staging/winbond/wbhal_f.h
 delete mode 100644 drivers/staging/winbond/wblinux_f.h
 delete mode 100644 drivers/staging/winbond/wbusb_s.h

---------------

Al Cho (2):
      staging: keucr: fix keucr init coding style
      staging: keucr: fix keucr init other coding style

Alan Cox (12):
      Staging: sep: minimal fix for wrong include
      Staging: sep: handle the rar definition stuff in the header
      Staging: sep: handle the memrar stuff in the headers
      Staging: sep: netlink - what netlink
      Staging: sep: clean up caller_id function
      Staging: sep: Fix the kernel-doc in SEP
      Staging: sep: clean up some of the obvious sillies
      Staging: sep: Use kzalloc when needed
      Staging: sep: Make SEP consistent
      Staging: sep: cant is an angular inclination
      Staging: sep: clean up a couple of spots missed in pass one
      Staging: sep: Fix crash if a device is not found

Alejandro R. Sedeño (2):
      Staging: beceem: Use 32-bit integers for hardware register values
      Staging: beceem: Move ZTE TU25's USB id to the beceem module

Andreas Langer (6):
      Staging: batman-adv: restructure fragmentation to handle batman unicast packets
      Staging: batman-adv: add frag_ prefix to all fragmentation related functions
      Staging: batman-adv: move skb reassembly of fragmented packets into dedicated function
      Staging: batman-adv: remove redundant is_my_mac() check in route_unicast_packet
      Staging: batman-adv: fragment forwarded packets
      Staging: batman-adv: reassemble fragmented skb if mtu allows it

Arend van Spriel (13):
      staging: brcm80211: replace PKTPUSH and PKTPULL macros with native skbuff calls
      staging: brcm80211: replaced PKTSETLEN macro by native __skb_trim call
      staging: brcm80211: add include file for using semaphore related definitions
      staging: brcm80211: remove unneccessary packets funtion prototype
      staging: brcm80211: change packet buffer type to native struct sk_buff
      staging: brcm80211: removed packet macros for accessing sk_buff fields
      staging: brcm80211: remove some more packet related macros
      staging: brcm80211: remove unused dhd_ops_virt variable definition
      staging: brcm80211: remove redundant CHIPTYPE macro
      staging: brcm80211: remove redundant CHIPID macro
      staging: brcm80211: remove redundant CHIPREV macro
      staging: brcm80211: remove macro usage for sk_buff allocation
      staging: brcm80211: remove macro usage for sk_buff release

Ariel Savini (1):
      staging: vt6656 resolved parenthesis not spaces

Atul Sowani (1):
      Staging: xgifb: change obsolete pci_find_device() with pci_get_device()

Barry Song (17):
      staging: iio: new adis16201 driver
      staging: iio: new adis16203 driver
      staging: iio: new adis16204 driver
      staging: iio: adc: new driver for AD7150/1/6 devices
      staging: iio: adc: new driver for AD7152/3 devices
      staging: iio: adc: new driver for AD7745/6/7 devices
      staging: iio: gyro: new driver for ADIS16251 devices
      staging: iio: gyro: new driver for ADIS16060 digital output gyros
      staging: iio: gyro: new driver for ADIS16080 digital output gyros
      staging: iio: gyro: new driver for ADIS16130 digital output gyros
      staging: iio: dac: new driver for AD5624R devices
      staging: iio: meter: new driver for ADE7753/6 devices
      staging: iio: meter: new driver for ADE7754 devices
      staging: iio: meter: new driver for ADE7758 devices
      staging: iio: meter: new driver for ADE7759 devices
      staging: iio: meter: new driver for ADE7854/58/68/78 devices
      staging: iio: adis16209: tuning spi delay to make hardware more stable

Ben Collins (6):
      solo6x10: Spaces to tabs
      solo6x10: Update TODO
      solo6x10: Conversion to videobuf-dma-sg (from dma-cont)
      solo6x10: Updates to videobuf-dma-sg functions for latest kernel
      solo6x10: Implement working P2M descriptor more DMA
      solo6x10: [P2M] Fix memory leak

Ben Hutchings (1):
      Staging: brcmfmac: Fix MAC header lookup on 64-bit architectures

Brandon Philips (1):
      staging: hv: add explanation of no-op set_multicast_list

Brett Rudley (45):
      staging: brcm80211: Purge unused lines from bcmdefs.h/wlc_pub.h
      staging: brcm80211: Purge unused includes from d11.h
      staging: brcm80211: Move #includes out of d11.h
      staging: brcm80211: Purge linuxver.h and redistribute #includes as required
      staging: brcm80211: Move #include from bcmutils.h out to .c files
      staging: brcm80211: Separate fullmac vs softmac defs in shared file
      staging: brcm80211: purge epivers.h
      staging: brcm80211: Remove abstraction layer for dma alignment
      staging: brcm80211: Remove dead code from osl.h
      staging: brcm80211: Remove OSL_ERROR entry point
      staging: brcm80211: Remove cruft from wlioctl.h
      staging: brcm80211: Remove 'failed' field from osh
      staging: brcm80211: Remove pkttag from osl
      staging: brcm80211: migrate #includes from headers into .c files.
      staging: brcm80211: Remove unused module parameters.
      staging: brcm80211: simplify pci_config_read/write osl routines.
      staging: brcm80211: get rid of last bit of pci configspace workaround.
      staging: brcm80211: expose osl contents and start combining osl and pub_osl.
      staging: brcm80211: completely remove osl_pubinfo_t typedef
      staging: brcm80211: s/osl_t/struct osl_info/g
      staging: brcm80211: nicpci.c: replace osl based PCI calls with native linux pci calls
      staging: brcm80211: unifdef -UWLC_HIGH_ONLY
      staging: brcm80211: unifdef -UWLC_LOW_ONLY
      staging: brcm80211: unifdef -DWLC_LOW
      staging: brcm80211: unifdef -UWLC_SPLIT
      staging: brcm80211: remove bmac-only header files
      staging: brcm80211: unifdef -UBCMSDIO
      staging: brcm80211: stragglers not handled by unifdef
      staging: brcm80211: OSL shrink: Remove OSL_PCI_READ/WRITE_CONFIG
      staging: brcm80211: Remove BUSTYPE macro
      staging: brcm80211: Remove OSL_DMADDRWIDTH
      staging: brcm80211: Remove unused PKTFREESETCB
      staging: brcm80211: Remove bogus gcc version checking
      staging: brcm80211: remove OSL_SYSUPTIME_SUPPORT
      staging: brcm80211: bzero => memset
      staging: brcm80211: bcmp => memcmp
      staging: brcm80211: Remove unused code from osl.h
      staging: brcm80211: absorb linux_osl.h into osl.h
      staging: brcm80211: OSLREGOPS is unused, remove checks for it.
      staging: brcm80211: Move osl_pub into osl
      staging: brcm80211: Remove unused softmac macros
      staging: brcm80211: move fullmac-only code from osl to fullmac files
      staging: brcm80211: move dma specific macros from osl to dma code
      staging: brcm80211: migrate register ops macros to bcmutils.h
      staging: brcm80211: Removing cruft from osl.h

Chen, Chien-Chia (2):
      Staging: rt3090: Fix RT3090 scan AP function
      Staging: rt2860: fix previous patch error

Cliff Cai (6):
      staging: iio: dds: new driver for AD5930/2 devices
      staging: iio: dds: new driver for AD9832/3/4/5 devices
      staging: iio: dds: new driver for AD9850/1 devices
      staging: iio: dds: new driver for AD9852/4 devices
      staging: iio: dds: new driver for AD9910 devices
      staging: iio: dds: new driver for AD9951 devices

Dan Carpenter (13):
      Staging: cptm1217: move free under dereference
      Staging: iio/dds: double locking bugs
      Staging: bcm: signedness bug in StoreSFParam()
      Staging: bcm: signedness bug in InitCardAndDownloadFirmware()
      Staging: ft1000-usb: freeing uninitialized pointer
      Staging: Beceem: add USB id for BCSM250 Mobile WiMAX
      Staging: Beceem: use lower case "int" instead of "INT"
      Staging: Beceem: white space changes to InterfaceInit.c
      Staging: Beceem: remove old kernel compatibility code
      Staging: Beceem: use after free in bcm_exit()
      Staging: Beceem: improve debug printk statements
      Staging: Beceem: more checkpatch.pl changes to InterfaceInit.c
      Staging: rtl8192u: add missing curly braces

David Chosrova (2):
      Staging: rtl8192u: remove dead code to disable dot11d
      Staging: rtl8192u: check return code kmalloc.

Emilio G. Cota (20):
      staging: vme: style: convert '&(foo)' to '&foo'
      staging: vme_user: return the appropriate error code when module_init fails
      staging: vme_user: remove unreachable line
      staging: vme: fix bogus clearing of the bus number in vme_free_bus_num
      staging: vme: tsi148: use list_for_each_safe when deleting resources in .remove
      staging: vme: tsi148: remove double freeing of the IRQ in .remove
      staging: vme: tsi148: fix warning in free_irq
      staging: vme: tsi148: remove unreachable line
      staging: vme: tsi148: declare static functions as such
      staging: vme: ca91cx42: declare static functions as such
      staging: vme_user: declare private variables as static
      staging: vme_user: use an unsigned int for counting the number of kparams
      staging: vme_user: remove __iomem marking from kern_buf and derivates
      staging: vme_user: mark user-space buffers with __user
      staging: vme: mark struct vme_master_resource's base address pointer as __iomem
      staging: vme: tsi148: mark the registers' base address pointer as __iomem
      staging: vme: ca91cx42: mark the registers' base address pointer as __iomem
      staging/vme_user: fix usage of the slave resources after they've been freed
      staging/vme/vme_user: use __dev{init, exit} for .probe and .remove
      staging/vme_user: add missing calls to vme_master_free calls in .remove

Eric Dumazet (1):
      staging: get rid of dev_base_lock

Felipe Andres Besoain Pino (1):
      staging: vt6656: resolved checkpatch finding

Graf Yang (3):
      staging: iio: resolver: new driver for AD2S90 devices
      staging: iio: resolver: new driver for AD2S1200/1205 devices
      staging: iio: resolver: new driver for AD2S1210 devices

Greg Kroah-Hartman (22):
      Revert "staging: batman-adv: Use linux/etherdevice.h address helper functions"
      Staging: sep: do not select the driver by default
      Staging: sep: do not select the driver by default
      Staging: hv: remove OnChildDeviceCreate vmbus_driver callback
      Staging: hv: remove OnChildDeviceDestroy vmbus_driver callback
      Staging: hv: remove OnChildDeviceRemove vmbus_driver callback
      Staging: hv: remove OnIsr vmbus_driver callback
      Staging: hv: remove OnMsgDpc vmbus_driver callback
      Staging: hv: remove OnEventDpc vmbus_driver callback
      Staging: hv: remove GetChannelOffers vmbus_driver callback
      Staging: hv: remove OnChildDeviceAdd vmbus_driver callback
      Staging: hv: remove struct vmbus_driver
      Staging: hv: rename the vmbus to "hyperv"
      Staging: hv: remove vmbus.c
      Staging: hv: call VmbusInitialize directly from vmbus_bus_init()
      Staging: hv: remove gDriver variable
      Staging: hv: merge VmbusInitialize into vmbus_bus_init
      Staging: hv: make some vmbus_drv functions static
      Staging: hv: remove vmbus_on_event_dpc()
      Staging: cxt1e1: rename global log_level variable
      Staging: ft1000: fix world writable debugfs file
      Staging: iio: fix up world writable sysfs files.

Haiyang Zhang (17):
      staging: hv: Convert camel cased struct fields in channel_mgmt.h to lower cases
      staging: hv: Convert camel cased struct fields in hv_api.h to lower cases
      staging: hv: Convert camel cased struct fields in hv.h to lower cases
      staging: hv: Convert camel cased local variables in hv.c to lower cases
      staging: hv: Convert camel cased functions in hv.c to lower cases
      staging: hv: Convert camel cased local variables in osd.c to lower cases
      staging: hv: Convert camel cased functions in osd.c to lower cases
      staging: hv: Convert camel cased struct fields in ring_buffer.h to lower cases
      staging: hv: Convert camel cased local variables in ring_buffer.c to lower cases
      staging: hv: Convert camel cased functions in ring_buffer.c to lower cases
      staging: hv: Convert camel cased variables in netvsc.c to lower cases
      staging: hv: Convert camel cased functions in netvsc.c to lower cases
      staging: hv: Convert camel cased variables in rndis_filter.c to lower cases
      staging: hv: Convert camel cased functions in rndis_filter.c to lower cases
      staging: hv: Convert camel cased struct fields in netvsc_api.h to lower cases
      staging: hv: Convert camel cased struct fields in netvsc.h to lower cases
      staging: hv: Convert camel cased struct fields in rndis.h to lower cases

Hank Janssen (9):
      staging: hv: Convert camel case struct fields in vstorage.h to lowercase
      staging: hv: Convert camel case struct fields in storvsc_api.h to lowercase
      staging: hv: Convert camel case functions in storvsc_api.h to lowercase
      staging: hv: Convert camel case struct fields in storvsc.c to lowercase
      staging: hv: Convert camel case function names in storvsc.c to lowercase
      staging: hv: Convert camel case local variables in storvsc.c to lowercase
      staging: hv: Convert camel case function names in blkvsc.c to lowercase
      staging: hv: Convert camel case local variables in blkvsc.c to lowercase
      Staging: hv: Use only one txf buffer per channel and kmalloc/GFP_KERNEL on initialize

Henry Ptasinski (2):
      MAINTAINERS: update the entry for the BRCM80211 driver
      staging: brcm80211: fix documentation on installing firmware

Huang Weiyi (1):
      staging: brcm80211: remove duplicated #include

Jesper Juhl (10):
      Staging: brcm80211: Remove unnecessary casts of void ptr returning alloc function return values
      pohmelfs: remove unneeded conditionals before calls to crypto_destroy_tfm wrappers.
      staging: r8712u: Remove unneeded local variable in _malloc in osdep_service.h header
      Staging: Cypress WestBridge OMAP3430 Kernel Hal: Remove unneeded local variables from alloc functions
      staging, keucr: Remove unnecessary casts of void ptr returning alloc function return values
      staging, rt2860: Remove unnecessary casts of void ptr returning alloc function return values
      staging, ath6kl: Remove unnecessary casts of void ptr returning alloc function return values
      staging, wlags49_h2: Remove unnecessary casts of void ptr returning alloc function return values
      staging, spectra: Remove unnecessary casts of void ptr returning alloc function return values
      Staging, bcm: Remove unnecessary casts of void ptr returning alloc function return values

Joe Perches (15):
      Staging: intel_sst: Use pr_fmt, fix misspellings
      Staging: solo6x10: Update WARN uses
      staging: Use vzalloc
      drivers/staging: Remove unnecessary semicolons
      drivers/staging: Remove unnecessary casts of pci_get_drvdata
      drivers/staging: Remove unnecessary casts of netdev_priv
      staging: brcm80211: Remove unused #defines ETHER_<foo>_LOCALADDR
      staging: brcm80211: Convert ETHER_IS_MULTI to is_multicast_ether_addr
      staging: brcm80211: Remove unused ether_<foo> #defines and struct
      staging: brcm80211: Convert ETHER_IS<FOO> to is_<foo>_ether_addr
      staging: brcm80211: Convert ETHER_ADDR_LEN to ETH_ALEN
      staging: brcm80211: Remove ETHER_HDR_LEN, use ETH_HLEN
      staging: brcm80211: Remove unused ETHER_TYPE_<foo> #defines
      staging: brcm80211: Convert ETHER_TYPE_802_1X to ETH_P_PAE
      staging: brcm80211: Fix WL_<type> logging macros

Johan Meiring (7):
      Staging: wlan-ng: fixed coding style issues in p80211conv.c
      Staging: wlan-ng: fixed coding style issues in p80211netdev.h
      Staging: wlan-ng: fix coding style issues in p80211types.h
      Staging: wlan-ng: fix coding style issues in prism2mgmt.c
      Staging: asus_oled: fix coding style issue in asus_oled.c
      Staging: wlan-ng: fixed coding style issues in p80211conv.h
      Staging: wlan-ng: fixed coding style issues in p80211netdev.c

Jonathan Cameron (3):
      staging: iio: adis16260 add id table support
      staging: iio: adis16260 add suppport for adis16255 and adis16250.
      staging: iio: documentation rewrite and cleanup of sysfs documetation

Justin P. Mattock (1):
      staging: Fix typos in rt2860

L. Alberto Giménez (4):
      Staging: rt2860: Clean spaces before tabs
      Staging: rt2860: Avoid extern in .c file
      Staging: rt2860: include KERN_* in printk
      Staging: rt2860: Sanitize DBGPRINT_ERR macro

Larry Finger (2):
      staging: r8712u: Remove extraneous variables from osdep_service.h
      staging: r8712u: Update TODO for sparse fixes

Linus Lüssing (4):
      Staging: batman-adv: Unify sysfs file names with their bat_priv atomics
      Staging: batman-adv: Wrapper functions for sysfs storing
      Staging: batman-adv: Ommit storing struct device in sysfs functions
      Staging: batman-adv: Make hop_penalty configurable via sysfs

Marek Belisko (43):
      staging: ft1000: Use memset instead looping with for.
      staging: ft1000: Remove dead code.
      staging: ft1000: Pseudo header handlig improved.
      staging: ft1000: Use specific error codes instead self defined.
      staging: ft1000: Use common return point.
      staging: ft1000: Correct return error values.
      staging: ft1000: Check return value.
      staging: ft1000: Get rid of PUCHAR typedef.
      staging: ft1000: Get rid of UCHAR typedef.
      staging: ft1000: GEt rid of PUSHORT typedef usage.
      staging: ft1000: Get rid of USHORT typedef usage.
      staging: ft1000: Get rid of PULONG typedef usage.
      staging: ft1000: Get rid of ULONG typedef usage.
      staging: ft1000: Get rid of BOOLEAN typedef usage.
      staging: ft1000: Get rid of PCHAR typedef usage.
      staging: ft1000: Get rid of UINT typedef usage.
      staging: ft1000: Check return value of kthread_run.
      staging: ft1000: Create common return point.
      staging: ft1000: Fix error goto statements.
      staging: ft1000: Fix compilation warning.
      staging: ft1000: Remove functions which create devices in kernel space.
      staging: ft1000: Fix goto error logic.
      staging: ft1000: Convert char device to debugfs.
      staging: ft1000: Fix private data pointer usage.
      staging: ft1000: Remove unused pdevobj array.
      staging: ft1000: Remove unused variable.
      staging: ft1000: Fix camelcase functions and variables.
      staging: ft1000: Remove dead code.
      staging: ft1000: Remove unused headers.
      staging: ft1000: Fix debug messages.
      staging: ft1000: Fix proc initialization handling.
      staging: ft1000: Fix coding style.
      staging: ft1000: Use return value for ft1000InitProc.
      staging: ft1000: Fix coding style in ft1000NotifyProc.
      staging: ft1000: Coding style fix in ft1000ReadProc.
      staging: ft1000: Fix coding style.
      staging: ft1000: Remove dead code.
      staging: ft1000: Add file header to ft1000_proc.c
      staging: ft1000: Always extract device number from netdev name.
      staging: ft1000: Fix camelcase function names.
      staging: ft1000: Rename ft1000_chdev.c to ft1000_debug.c.
      staging: ft1000: Fix camelcase variable names.
      staging: ft1000: Fix kernel panic when use ioctl.

Marek Lindner (8):
      Staging: batman-adv: ensure that eth_type_trans gets linear memory
      Staging: batman-adv: convert batman_if custom refcounting to kref functions
      Staging: batman-adv: use rcu callbacks when freeing batman_if
      Staging: batman-adv: softif bridge loop avoidance
      Staging: batman-adv: adding gateway functionality
      Staging: batman-adv: send DHCP requests directly to the chosen gw
      Staging: batman-adv: best gw DHCP filter 802.1Q support
      Staging: batman-adv: add gateway IPv6 support by filtering DHCPv6 messages

Mariano Reingart (1):
      staging: vt6656: resolved checkpatch finding

Mark Allyn (13):
      Staging: sep: Introduce sep driver
      Staging: sep: remove virtual address being passed to user space application
      Staging: sep: remove spaces at end of lines
      Staging: sep: sram_addr is 32 bit; this is not a kernel address, but device internal value
      Staging: sep: clean up error checking in probe function
      Staging: sep: initialize driver copy of send and receive count with device
      Staging: sep: remove code for Moorestown device
      Staging: sep: remove completed items in TODO
      Staging: sep: limit time to wait for reconfig shared area complete
      Staging: sep: reduce 64 and 32 bit compile warnings
      Staging: sep: ensure that caller id buffer is little endian
      Staging: sep: eliminate kernel crash due to null parameter in dma_alloc_coherent
      staging: sep: fix comments in sep_get_static_pool_addr_handler

Matias De la Puente (1):
      staging: vt6656: resolved checkpatch finding

Matthias Brugger (1):
      staging: adis16255 delete driver

Mauro Schilman (1):
      Staging: frontier: fix space and * coding style issues in alphatrack.c

Michael Hennerich (14):
      staging: iio: gyro: make sure grep can find the ADIS16265 support
      staging: iio: dac: more consistent DAC sysfs attributes naming
      staging: iio: dac: Update drivers to use new attribute naming
      staging: iio: dac: Use spi_write() and handle return value
      staging: iio: dac: Use spi_device_id
      staging: iio: dac: Cleanup style - no functional changes
      staging: iio: dac: Enable driver support for AD5444 and AD5446 DA converters
      staging: iio: adc: Enable driver support for ad7887 AD converter
      staging: iio: dac: ad5446: Enable driver support for AD5620/AD5640/AD5660 DA converters
      staging: iio: dac: ad5446: Remove unused sign member from chip specific information structure
      staging: iio: dds: ad9832: Fix kconfig description
      Staging: IIO: Direct digital synthesis abi documentation
      Staging: IIO: dds.h convenience macros
      Staging: IIO: DDS: AD9833 / AD9834 driver

Mike Frysinger (2):
      staging: iio: adis16350: add missing reference to temp offset
      staging: iio: add ADI info to TODO

Mike Rapoport (4):
      staging: brcm80211: remove unused osl_pkt{get,free}_static
      staging: brcm80211: brcmfmac: remove PXA SDIO controller binding
      staging: brcm80211: brcmfmac: remove PCI SDIO controller binding
      staging: brcm80211: brcmfmac: cleanup bcmsdh_(un)register

Mike Thomas (9):
      staging/easycap: Remove obsolete routines
      staging/easycap: Make code re-entrant
      staging/easycap: Improve hardware initialization
      staging/easycap: Implement interlaced modes and reduced framerates
      staging/easycap: Add option to show conspicuous indication of signal loss
      staging/easycap: Add option to set the hardware audio gain
      staging/easycap: Avoid compiler warning about frame size ... larger than ...
      staging/easycap: Eliminate BKL
      staging/easycap: Improve interface to the videodev module

Márton Németh (1):
      staging: usbip: remove double giveback of URB

Namhyung Kim (6):
      Staging: vme_ca91cx42: use DEFINE_PCI_DEVICE_TABLE
      Staging: vme_tsi148: use DEFINE_PCI_DEVICE_TABLE
      Staging: phison: use DEFINE_PCI_DEVICE_TABLE
      Staging: cx25821: use DEFINE_PCI_DEVICE_TABLE
      Staging: rtl8192e: use DEFINE_PCI_DEVICE_TABLE
      Staging: sm7xx: use DEFINE_PCI_DEVICE_TABLE

Naveen Kumar Gaddipati (1):
      Staging: add Synaptics RMI4 touchpad driver support

Nicolas Kaiser (2):
      Staging: brcm80211: simplify expression
      staging: comedi: fix typo in error message

Pekka Enberg (19):
      Staging: w35und: Merge wbhal_f.h to wbhal_s.h
      Staging: w35und: Rename wbhal_s.h to wbhal.h
      Staging: w35und: Kill empty Mds_Destroy function
      Staging: w35und: Kill struct hwdata ->NullPacketCount
      Staging: w35und: Kill struct hwdata ->HwStop
      Staging: w35und: Kill struct hwdata ->SurpriseRemoveCount
      Staging: w35und: Remove unused defines from sysdef.h
      Staging: w35und: Kill _USE_FALLBACK_RATE_ macro
      Staging: w35und: Kill WPA2 definitions
      Staging: w35und: Kill unused code in mac_structures.h
      Staging: w35und: Use pr_debug() for debugging
      Staging: w35und: Remove empty sysdef.h header
      Staging: w35und: Kill Vendor2 ifdef from hal_init_hardware
      Staging: w35und: Kill write-only ->TxToggle
      Staging: w35und: Kill _IBSS_BEACON_SEQ_STICK_
      Staging: w35und: Merge mlmetxrx.c to mds.c
      Staging: w35und: Kill wblinux_f.h header
      Staging: w35und: Remove unused fields from struct wb_usb
      Staging: w35und: Kill struct wb_usb

Peter Huewe (5):
      staging/sep: Fix sparse warning 'do-while statement is not a compound statement'
      staging/sep: Fix sparse warning 'Using plain integer as NULL pointer'
      staging/sep: Fix printk format warning
      staging/line6: Fix sparse warning 'Using plain integer as NULL pointer'
      staging/zram: Fix sparse warning 'Using plain integer as NULL pointer'

Ramesh Agarwal (1):
      Staging: add Synaptics TM1217 Touchscreen Controller driver

Randy Dunlap (7):
      staging: fix ste_rmi4 build, depends on INPUT
      staging/easycap: make module params private/static, fix build
      staging: fix iio/gyro typos, build errors
      staging: clearpad_tm1217 depends on INPUT
      staging: fix intel_sst/intelmid sound build
      staging: brcm80211 needs lots of delay.h
      staging: solo6010 depends on I2C

Roland Vossen (18):
      staging: brcm80211: replaced typedef struct wl_info_t by struct wl_info.
      staging: brcm80211: added firmware validation
      staging: brcm80211: replaced wlc_info_t by struct wlc_info.
      staging: brcm80211: replaced wlc_hw_info_t by struct wlc_hw_info
      staging: brcm80211: removed unused typedefs
      staging: brcm80211: removed unused macro's and typedefs from wpa.h
      staging: brcm80211: replaced typedef wlc_if_t by struct wlc_if
      staging: brcm80211: replaced typedef ampdu_info_t by struct ampdu_info
      staging: brcm80211: replaced typedef wlc_ap_info_t by struct wlc_ap_info
      staging: brcm80211: replaced typedef antsel_info_t by struct antsel_info
      staging: brcm80211: replaced typedef bmac_pmq_t by struct bmac_pmq
      staging: brcm80211: replaced typedef wl_if_t by struct wl_if
      staging: brcm80211: replaced typedef hnddma_t by struct hnddma_pub
      staging: brcm80211: replaced typedef wlcband_t by struct wlcband
      staging: brcm80211: replaced typedef wlccore_t by struct wlccore
      staging: brcm80211: replaced typedef wlc_pub_t by struct wlc_pub
      staging: brcm80211: removed unused struct wlc_ap_info
      staging: brcm80211: removed ap related comments

Ruben Smits (1):
      staging: comedi: add support for newer jr3 1-channel pci board

Sonic Zhang (8):
      staging: iio: new ADT7316/7/8 and ADT7516/7/9 driver
      staging: iio: adc: new driver for AD7291 devices
      staging: iio: adc: new driver for AD7298 devices
      staging: iio: adc: new driver for AD7314 devices
      staging: iio: adc: new driver for AD7816 devices
      staging: iio: adc: new driver for ADT75 temperature sensors
      staging: iio: adc: new driver for ADT7310 temperature sensors
      staging: iio: adc: new driver for ADT7410 temperature sensors

Stephen Hemminger (52):
      beceem: add module information
      beceem: remove ifdef's
      beceem: remove version ifdef's
      beceem: eliminate unused USB stubs
      beceem: cleanup debug level infrastructure
      beceem: remove bogus network device notifier
      beceem: eliminate network registered state variable
      beceem: eliminate dead code
      beceem: get rid of OS dependent data structure
      beceem: cleanup network device setup
      beceem: use kernel print_hex_dump function
      beceem: remove OS wrapper library
      beceem: name threads with device name
      beceem: make transmit thread interruptible
      beceem: add ethtool support
      beceem: remove dead code
      beceem: reduce transmit queue len
      beceem: Add proper carrier and link management
      beceem: remove indirection to Adapter structure
      beceem: print better message on bad ioctl
      beceem: remove ARP spoofing
      beceem: fold unregister_netdevice into AdapterFree
      beceem: get rid of unnecessary inline usage
      beceem: support multiple queues
      beceem: remove dead code
      beceem: reserve one queue for bit-bucket
      beceem: fix printf format strings
      beceem: fix character device ioctl
      beceem: remove unnecessary usb class
      beceem: remove problematic debug print messages
      beceem: remove useless debug function entry messages
      beceem: convert to kernel coding style
      beceem: create class on module installation
      beceem: clean up adapter structure
      beceem: change format of debug message
      beceem: add network device message level control
      beceem: module initialization
      beceem: use get_seconds for elapsed time
      beceem: debug message format changes
      beceem: allow multicast/broadcast
      beceem: transmit code cleanup
      beceem: remove unused code to dump header
      beceem: make local functions static
      beceem: off by one on queue index
      beceem: do classification even if device is offline
      beceem: statistics and transmit queue changes
      beceem: fix definition of VLAN header type
      beceem: eliminate unused bcm_jiffies
      beceem: don't overrun user buffer on read
      beceem: change startup messages
      beceem: dump control packet information
      beceem: update TODO list

Steven Rostedt (1):
      staging: ft1000: Copy from user into correct data

Sven Eckelmann (13):
      Staging: batman-adv: Remove useless braces
      Staging: batman-adv: Replace Andrew Lunn as Staging maintainer
      Staging: batman-adv: Add new sysfs files to README
      Staging: batman-adv: Don't remove interface with spinlock held
      Staging: batman-adv: Remove hashdata_compare_cb from hash
      Staging: batman-adv: Remove hashdata_choose_cb from hash
      Staging: batman-adv: Move hash callback related function to header
      Staging: batman-adv: Make hash_iterate inlineable
      Staging: batman-adv: Rewrite hash using hlist_*
      Staging: batman-adv: Limit spin_locks to spin_lock_bh
      Staging: batman-adv: Use kernel version min macro
      Staging: batman-adv: Use kernel functions to identify broadcasts
      Staging: batman-adv: Remove batman-adv from staging

Timo Teräs (3):
      staging: hv: convert vmbus_on_msg_dpc to not call osd_schedule_callback
      staging: hv: convert channel_mgmt.c to not call osd_schedule_callback
      staging: hv: remove unneeded osd_schedule_callback

Tobias Klauser (2):
      staging: batman-adv: Use linux/etherdevice.h address helper functions
      staging: brcm80211: Remove redundant unlikely()

Tracey Dent (2):
      Staging: msm: Makefile: replace the use of <module>-objs with <module>-y
      Staging: speakup: spk_types: trival coding style issue

Tushar Mehta (1):
      Staging: autofs: fix coding style issue in dirhash.c

Uwe Kleine-König (2):
      Staging: trivial: fix typos concerning "configure"
      Staging: trivial: fix typos concerning "controller"

Vasiliy Kulikov (1):
      staging: msm: tvenc: fix error handling

Vinod Koul (7):
      sst: remove rest of aava bits and aava related code
      sst: Change the SST driver PCM interface
      sst: Firmware error codes force number values
      sst: log error returned by scu ipc read/write
      Staging: sst: Add runtime PM support
      Staging: sst: Construct fw string name runtime
      Staging: sst: add ioctls for post processing algorithm interface

William Hubbs (1):
      staging: speakup: fix failure handling

Xenofon Foukas (4):
      Staging: comedi: Fix coding style issues in drivers.c
      Staging: comedi: Fix coding style issues in ni_tiocmd.c
      Staging: comedi: Fix coding style issues in ii_pci20kc.c
      Staging: comedi: Fix checkpatch.pl issues in file s526.c

Yong Wang (2):
      staging: spectra: move all init logic into nand_pci_probe
      staging: spectra: asynchronous init

facugaich (1):
      Staging: solo6x10: Fix checkpatch errors and most warnings

