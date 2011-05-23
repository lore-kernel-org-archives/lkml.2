Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab1EWTh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:37:56 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54927 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932209Ab1EWThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:37:51 -0400
X-Sasl-enc: 3FFSz6jXmL+2Oy9XCjk2a2wG9M0lWFmZctbeTu9c18XY 1306179469
Date: Mon, 23 May 2011 12:38:55 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING pull for .40
Message-ID: <20110523193855.GA20384@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big pull request for the staging tree for your .40 tree (or
2.8.0, whatever you are wanting to rename it to.)

All patches are self-contained to the drivers/staging/ tree, with the
exception of a module.c fix that was necessary to allow staging drivers
to have access to EXPORT_SYMBOL_GPL() symbols, which they should as they
are licensed under the GPL.  That change was acked by Rusty.

The big thing here is the overall size after pulling:
 822 files changed, 68690 insertions(+), 172256 deletions(-)

Yes, that's over 100000 lines removed!

Almost makes up for some of my previous pull requests :)

Anyway, lots of changes here, the majority being in the Microsoft
HyperV drivers, where the developers there woke up and got interested in
making the needed changes to merge their code out of the staging tree.
Some wireless drivers were removed, and lots of cleanups on other
drivers.  Some new drivers also added, and a huge IIO rework based on
review comments that happened on lkml.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/ staging-next

Note, you will get 4 trivial merge issues when pulling this into your
tree right now.  Two are just files that should be removed.  The other
two are trivial issues that you should be able to easily fix up.  If you
want me to do the merge myself here, I will be glad to do so.

All of these patches have been in the mm and -next trees for a while.

There's over 900 patches here, so I'll spare the linuxdriverproject.org
mailing list with them, and I think they will be happy.  All of them
have previously been posted there so there's no surprises here.

thanks,

greg k-h

--------------


 drivers/staging/Kconfig                            |    8 +-
 drivers/staging/Makefile                           |    9 +-
 drivers/staging/ath6kl/Kconfig                     |    6 -
 drivers/staging/ath6kl/Makefile                    |   39 +-
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |    3 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |    8 +-
 .../hif/sdio/linux_sdio/include/hif_internal.h     |    1 -
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |  382 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   10 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |    5 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    3 -
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |    3 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |    1 -
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    3 +-
 drivers/staging/ath6kl/htc2/htc.c                  |   10 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |    9 -
 drivers/staging/ath6kl/htc2/htc_recv.c             |    6 -
 drivers/staging/ath6kl/htc2/htc_send.c             |    5 -
 drivers/staging/ath6kl/include/a_config.h          |   22 -
 drivers/staging/ath6kl/include/a_debug.h           |   29 -
 drivers/staging/ath6kl/include/a_drv.h             |   22 -
 drivers/staging/ath6kl/include/a_drv_api.h         |   28 -
 drivers/staging/ath6kl/include/a_osapi.h           |   29 -
 drivers/staging/ath6kl/include/a_types.h           |   58 -
 drivers/staging/ath6kl/include/ar6000_api.h        |   22 -
 drivers/staging/ath6kl/include/athendpack.h        |   52 -
 drivers/staging/ath6kl/include/athstartpack.h      |   55 -
 drivers/staging/ath6kl/include/bmi.h               |    1 -
 .../ath6kl/include/common/AR6002/AR6002_regdump.h  |   60 -
 .../common/AR6002/hw2.0/hw/analog_intf_reg.h       |   64 -
 .../include/common/AR6002/hw2.0/hw/analog_reg.h    | 1932 ---
 .../include/common/AR6002/hw2.0/hw/apb_map.h       |   13 -
 .../include/common/AR6002/hw2.0/hw/gpio_reg.h      |  977 --
 .../include/common/AR6002/hw2.0/hw/mbox_host_reg.h |  386 -
 .../include/common/AR6002/hw2.0/hw/mbox_reg.h      |  481 -
 .../include/common/AR6002/hw2.0/hw/rtc_reg.h       | 1163 --
 .../ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h |  186 -
 .../include/common/AR6002/hw2.0/hw/uart_reg.h      |  327 -
 .../include/common/AR6002/hw2.0/hw/vmc_reg.h       |   76 -
 .../common/AR6002/hw4.0/hw/analog_intf_ares_reg.h  | 3291 -----
 .../AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h    | 3674 ------
 .../common/AR6002/hw4.0/hw/analog_intf_reg.h       |   37 -
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |    8 -
 .../include/common/AR6002/hw4.0/hw/bb_lc_reg.h     | 7076 -----------
 .../include/common/AR6002/hw4.0/hw/efuse_reg.h     |  108 -
 .../common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h    | 1253 --
 .../include/common/AR6002/hw4.0/hw/gpio_reg.h      | 1094 --
 .../include/common/AR6002/hw4.0/hw/mac_dma_reg.h   |  605 -
 .../include/common/AR6002/hw4.0/hw/mac_pcu_reg.h   | 3065 -----
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   13 -
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |    8 -
 .../common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h    |   51 -
 .../include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h |   49 -
 .../include/common/AR6002/hw4.0/hw/rdma_reg.h      |  564 -
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |  788 --
 .../include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h  | 1903 ---
 .../ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h |  209 -
 .../include/common/AR6002/hw4.0/hw/uart_reg.h      |  220 -
 .../include/common/AR6002/hw4.0/hw/umbox_reg.h     |   37 -
 .../common/AR6002/hw4.0/hw/umbox_wlan_reg.h        |  322 -
 .../include/common/AR6002/hw4.0/hw/vmc_reg.h       |  167 -
 .../include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h  |  195 -
 drivers/staging/ath6kl/include/common/a_hci.h      |  682 -
 drivers/staging/ath6kl/include/common/bmi_msg.h    |    8 -
 drivers/staging/ath6kl/include/common/btcoexGpio.h |   86 -
 drivers/staging/ath6kl/include/common/dbglog.h     |    8 -
 .../staging/ath6kl/include/common/dset_internal.h  |   63 -
 drivers/staging/ath6kl/include/common/dsetid.h     |  134 -
 .../staging/ath6kl/include/common/epping_test.h    |    9 -
 drivers/staging/ath6kl/include/common/gmboxif.h    |    8 -
 drivers/staging/ath6kl/include/common/gpio.h       |   45 -
 drivers/staging/ath6kl/include/common/gpio_reg.h   |    9 +
 drivers/staging/ath6kl/include/common/htc.h        |    9 -
 drivers/staging/ath6kl/include/common/ini_dset.h   |   82 -
 drivers/staging/ath6kl/include/common/regDb.h      |   29 -
 drivers/staging/ath6kl/include/common/regdump.h    |   59 -
 .../include/common/regulatory/reg_dbschema.h       |  237 -
 .../include/common/regulatory/reg_dbvalues.h       |  504 -
 drivers/staging/ath6kl/include/common/targaddrs.h  |  234 +-
 drivers/staging/ath6kl/include/common/wlan_dset.h  |   33 -
 drivers/staging/ath6kl/include/common/wmi.h        |  135 +-
 drivers/staging/ath6kl/include/common/wmi_thin.h   |  347 -
 drivers/staging/ath6kl/include/common/wmix.h       |    8 -
 drivers/staging/ath6kl/include/common_drv.h        |    4 -
 drivers/staging/ath6kl/include/gpio_api.h          |   59 -
 drivers/staging/ath6kl/include/hif.h               |    3 +-
 drivers/staging/ath6kl/include/target_reg_table.h  |  244 -
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   23 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |   22 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   28 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |    6 -
 drivers/staging/ath6kl/miscdrv/common_drv.c        |  126 +-
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |    1 -
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |  388 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  793 +-
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   77 -
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |  479 -
 drivers/staging/ath6kl/os/linux/cfg80211.c         |  340 +-
 drivers/staging/ath6kl/os/linux/eeprom.c           |  574 -
 .../staging/ath6kl/os/linux/export_hci_transport.c |    1 -
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |    5 +-
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  152 +-
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |    8 -
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |    4 +-
 .../ath6kl/os/linux/include/athtypes_linux.h       |   51 -
 .../staging/ath6kl/os/linux/include/config_linux.h |    7 -
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |   49 +-
 .../staging/ath6kl/os/linux/include/wlan_config.h  |   10 -
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |    2 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            | 4767 -------
 drivers/staging/ath6kl/os/linux/netbuf.c           |    1 -
 drivers/staging/ath6kl/os/linux/wireless_ext.c     | 2723 ----
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |   15 +-
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |    4 -
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |   11 +-
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |    1 -
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |    1 -
 drivers/staging/ath6kl/wmi/wmi.c                   |  248 +-
 drivers/staging/brcm80211/Kconfig                  |   21 +-
 drivers/staging/brcm80211/Makefile                 |    1 +
 drivers/staging/brcm80211/README                   |  102 +-
 drivers/staging/brcm80211/TODO                     |   56 +-
 drivers/staging/brcm80211/brcmfmac/Makefile        |   13 +-
 drivers/staging/brcm80211/brcmfmac/README          |   35 -
 .../{util/siutils_priv.h => brcmfmac/bcmchip.h}    |   33 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   38 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |   10 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   55 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    7 +-
 drivers/staging/brcm80211/brcmfmac/bcmutils.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/bcmwifi.c       |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   32 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   16 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   50 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  121 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      | 1132 ++-
 drivers/staging/brcm80211/brcmfmac/hndpmu.c        |    1 -
 drivers/staging/brcm80211/brcmfmac/sbutils.c       |    1 -
 drivers/staging/brcm80211/brcmfmac/siutils.c       |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   | 1624 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |   75 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |  161 +-
 drivers/staging/brcm80211/brcmsmac/Makefile        |   22 +-
 .../{util/siutils.c => brcmsmac/aiutils.c}         | 1646 ++--
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |  546 +
 .../staging/brcm80211/{util => brcmsmac}/bcmotp.c  |  127 +-
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |  714 ++
 .../brcm80211/{util => brcmsmac}/bcmsrom_tbl.h     |   70 -
 drivers/staging/brcm80211/brcmsmac/d11.h           |    2 +
 .../staging/brcm80211/{util => brcmsmac}/hnddma.c  |  110 +-
 .../staging/brcm80211/{util => brcmsmac}/nicpci.c  |   77 +-
 .../{util/nvram/nvram_ro.c => brcmsmac/nvram.c}    |   94 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |  182 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    5 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    4 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |   51 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |  173 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c |  296 +
 .../qmath.h => brcmsmac/phy/wlc_phy_qmath.h}       |   38 -
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h        |   24 +-
 drivers/staging/brcm80211/brcmsmac/wl_export.h     |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |  469 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |    5 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |   74 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.h     |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |  362 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.h     |    3 -
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |   15 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |  692 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h      |    6 -
 drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h    |    3 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |   73 +-
 drivers/staging/brcm80211/brcmsmac/wlc_key.h       |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      | 1869 +---
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |   41 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    9 +-
 .../{util/hndpmu.c => brcmsmac/wlc_pmu.c}          | 3192 ++---
 .../{include/hndpmu.h => brcmsmac/wlc_pmu.h}       |   54 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |   52 +-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |   20 +-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.h      |   15 +-
 drivers/staging/brcm80211/brcmsmac/wlc_scb.h       |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |   62 +-
 drivers/staging/brcm80211/include/aidmp.h          |    6 +-
 drivers/staging/brcm80211/include/bcmdefs.h        |   12 -
 drivers/staging/brcm80211/include/bcmdevs.h        |   72 +-
 drivers/staging/brcm80211/include/bcmnvram.h       |   29 +-
 drivers/staging/brcm80211/include/bcmsdpcm.h       |    3 +-
 drivers/staging/brcm80211/include/bcmsrom_fmt.h    |    2 +-
 drivers/staging/brcm80211/include/bcmutils.h       |  189 +-
 drivers/staging/brcm80211/include/bcmwifi.h        |    6 +-
 drivers/staging/brcm80211/include/hnddma.h         |   19 +
 .../staging/brcm80211/{util => include}/pci_core.h |    0
 drivers/staging/brcm80211/include/pcicfg.h         |  510 +-
 drivers/staging/brcm80211/include/sbchipc.h        |    6 +-
 drivers/staging/brcm80211/include/siutils.h        |  361 -
 drivers/staging/brcm80211/include/wlioctl.h        |  349 +-
 drivers/staging/brcm80211/util/Makefile            |   29 +
 drivers/staging/brcm80211/util/aiutils.c           |  705 --
 drivers/staging/brcm80211/util/bcmsrom.c           | 2088 ----
 drivers/staging/brcm80211/util/bcmutils.c          |  484 +-
 drivers/staging/brcm80211/util/bcmwifi.c           |   13 +-
 drivers/staging/brcm80211/util/qmath.c             |  681 -
 drivers/staging/brcm80211/util/sbpcmcia.h          |  217 -
 drivers/staging/brcm80211/util/sbsocram.h          |  175 -
 drivers/staging/brcm80211/util/sbutils.c           |  476 -
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |   16 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |   61 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |   17 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |   36 +-
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |   10 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |   27 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |   24 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |    4 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |    3 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |    2 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    2 +-
 drivers/staging/comedi/drivers/jr3_pci.c           |   27 +-
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c     |    6 +-
 drivers/staging/comedi/drivers/ni_tio.c            |    6 +-
 drivers/staging/comedi/drivers/pcl724.c            |    2 +-
 drivers/staging/comedi/drivers/pcl818.c            |    2 +-
 drivers/staging/comedi/drivers/pcm3724.c           |    2 +-
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |  343 +-
 drivers/staging/cptm1217/clearpad_tm1217.c         |    5 +-
 drivers/staging/crystalhd/bc_dts_types.h           |    1 -
 drivers/staging/crystalhd/crystalhd_misc.c         |    4 +-
 drivers/staging/cx25821/cx25821-video.c            |    3 +-
 drivers/staging/easycap/easycap_main.c             |  479 +-
 drivers/staging/echo/echo.c                        |   26 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |  158 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   19 -
 drivers/staging/gma500/Makefile                    |   15 +-
 drivers/staging/gma500/mrst.h                      |  217 +
 drivers/staging/gma500/mrst_crtc.c                 |  619 +
 drivers/staging/gma500/mrst_lvds.c                 |  371 +
 drivers/staging/gma500/psb_2d.c                    |    9 +-
 drivers/staging/gma500/psb_bl.c                    |  118 +-
 drivers/staging/gma500/psb_buffer.c                |  450 -
 drivers/staging/gma500/psb_drm.h                   |  122 -
 drivers/staging/gma500/psb_drv.c                   |  765 +-
 drivers/staging/gma500/psb_drv.h                   |  462 +-
 drivers/staging/gma500/psb_fb.c                    |  365 +-
 drivers/staging/gma500/psb_fb.h                    |   16 +-
 drivers/staging/gma500/psb_fence.c                 |  122 -
 drivers/staging/gma500/psb_gem.c                   |  320 +
 drivers/staging/gma500/psb_gtt.c                   | 1263 +--
 drivers/staging/gma500/psb_gtt.h                   |   84 +-
 drivers/staging/gma500/psb_intel_display.c         |  147 +-
 drivers/staging/gma500/psb_intel_drv.h             |   13 +-
 drivers/staging/gma500/psb_intel_lvds.c            |   50 +-
 drivers/staging/gma500/psb_intel_sdvo.c            |    4 +-
 drivers/staging/gma500/psb_irq.c                   |  178 +-
 drivers/staging/gma500/{psb_reset.c => psb_lid.c}  |    0
 drivers/staging/gma500/psb_mmu.c                   |   61 -
 drivers/staging/gma500/psb_powermgmt.c             |  755 +-
 drivers/staging/gma500/psb_powermgmt.h             |   55 +-
 drivers/staging/gma500/psb_pvr_glue.c              |   73 -
 drivers/staging/gma500/psb_pvr_glue.h              |   25 -
 drivers/staging/gma500/psb_sgx.c                   |  238 -
 drivers/staging/gma500/psb_sgx.h                   |   32 -
 drivers/staging/gma500/psb_ttm_fence.c             |  605 -
 drivers/staging/gma500/psb_ttm_fence_api.h         |  272 -
 drivers/staging/gma500/psb_ttm_fence_driver.h      |  302 -
 drivers/staging/gma500/psb_ttm_fence_user.c        |  237 -
 drivers/staging/gma500/psb_ttm_fence_user.h        |  140 -
 drivers/staging/gma500/psb_ttm_glue.c              |  349 -
 drivers/staging/gma500/psb_ttm_placement_user.c    |  628 -
 drivers/staging/gma500/psb_ttm_placement_user.h    |  252 -
 drivers/staging/gma500/psb_ttm_userobj_api.h       |   85 -
 drivers/staging/hv/Kconfig                         |    4 +-
 drivers/staging/hv/Makefile                        |    2 +-
 drivers/staging/hv/blkvsc.c                        |  102 -
 drivers/staging/hv/blkvsc_drv.c                    | 1477 +--
 drivers/staging/hv/channel.c                       |  230 +-
 drivers/staging/hv/channel.h                       |  112 -
 drivers/staging/hv/channel_mgmt.c                  |  201 +-
 drivers/staging/hv/channel_mgmt.h                  |  320 -
 drivers/staging/hv/connection.c                    |  108 +-
 drivers/staging/hv/hv.c                            |  111 +-
 drivers/staging/hv/hv.h                            |  140 -
 drivers/staging/hv/hv_api.h                        |  910 --
 drivers/staging/hv/hv_kvp.c                        |   20 +-
 drivers/staging/hv/hv_mouse.c                      |  502 +-
 drivers/staging/hv/hv_timesource.c                 |    3 +-
 drivers/staging/hv/hv_util.c                       |   81 +-
 drivers/staging/hv/hyperv.h                        |  944 ++
 drivers/staging/hv/{rndis.h => hyperv_net.h}       |  422 +-
 .../staging/hv/{vstorage.h => hyperv_storage.h}    |  144 +-
 drivers/staging/hv/hyperv_vmbus.h                  |  631 +
 drivers/staging/hv/logging.h                       |   98 -
 drivers/staging/hv/netvsc.c                        |  987 +-
 drivers/staging/hv/netvsc.h                        |  332 -
 drivers/staging/hv/netvsc_api.h                    |  116 -
 drivers/staging/hv/netvsc_drv.c                    |  190 +-
 drivers/staging/hv/ring_buffer.c                   |  526 +-
 drivers/staging/hv/ring_buffer.h                   |  102 -
 drivers/staging/hv/rndis_filter.c                  |  187 +-
 drivers/staging/hv/rndis_filter.h                  |   55 -
 drivers/staging/hv/storvsc.c                       |  547 +-
 drivers/staging/hv/storvsc_api.h                   |  110 -
 drivers/staging/hv/storvsc_drv.c                   | 1015 +-
 drivers/staging/hv/utils.h                         |  120 -
 drivers/staging/hv/version_info.h                  |   48 -
 drivers/staging/hv/vmbus.h                         |   51 -
 drivers/staging/hv/vmbus_api.h                     |  139 -
 drivers/staging/hv/vmbus_channel_interface.h       |   89 -
 drivers/staging/hv/vmbus_drv.c                     | 1098 +-
 drivers/staging/hv/vmbus_packet_format.h           |  161 -
 drivers/staging/hv/vmbus_private.h                 |  134 -
 drivers/staging/iio/Documentation/device.txt       |   78 +-
 drivers/staging/iio/Documentation/generic_buffer.c |   95 +-
 drivers/staging/iio/Documentation/iio_utils.h      |   20 +-
 drivers/staging/iio/Documentation/overview.txt     |   19 +-
 drivers/staging/iio/Documentation/ring.txt         |   44 +-
 drivers/staging/iio/Documentation/sysfs-bus-iio    |   13 +
 .../staging/iio/Documentation/sysfs-bus-iio-light  |   13 +
 .../iio/Documentation/sysfs-bus-iio-light-tsl2583  |   20 +
 drivers/staging/iio/Documentation/trigger.txt      |   16 +-
 drivers/staging/iio/Documentation/userspace.txt    |   12 -
 drivers/staging/iio/Kconfig                        |   15 +-
 drivers/staging/iio/accel/adis16201.h              |    9 +-
 drivers/staging/iio/accel/adis16201_core.c         |  489 +-
 drivers/staging/iio/accel/adis16201_ring.c         |  146 +-
 drivers/staging/iio/accel/adis16201_trigger.c      |   82 +-
 drivers/staging/iio/accel/adis16203.h              |   18 +-
 drivers/staging/iio/accel/adis16203_core.c         |  411 +-
 drivers/staging/iio/accel/adis16203_ring.c         |  123 +-
 drivers/staging/iio/accel/adis16203_trigger.c      |   83 +-
 drivers/staging/iio/accel/adis16204.h              |   18 +-
 drivers/staging/iio/accel/adis16204_core.c         |  434 +-
 drivers/staging/iio/accel/adis16204_ring.c         |  126 +-
 drivers/staging/iio/accel/adis16204_trigger.c      |   83 +-
 drivers/staging/iio/accel/adis16209.h              |    6 +-
 drivers/staging/iio/accel/adis16209_core.c         |  468 +-
 drivers/staging/iio/accel/adis16209_ring.c         |  143 +-
 drivers/staging/iio/accel/adis16209_trigger.c      |   77 +-
 drivers/staging/iio/accel/adis16220_core.c         |   13 +-
 drivers/staging/iio/accel/adis16240.h              |    7 +-
 drivers/staging/iio/accel/adis16240_core.c         |  390 +-
 drivers/staging/iio/accel/adis16240_ring.c         |  131 +-
 drivers/staging/iio/accel/adis16240_trigger.c      |   78 +-
 drivers/staging/iio/accel/kxsd9.c                  |   14 +-
 drivers/staging/iio/accel/lis3l02dq.h              |   46 +-
 drivers/staging/iio/accel/lis3l02dq_core.c         |  844 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |  504 +-
 drivers/staging/iio/accel/sca3000.h                |   76 +-
 drivers/staging/iio/accel/sca3000_core.c           |  955 +-
 drivers/staging/iio/accel/sca3000_ring.c           |  269 +-
 drivers/staging/iio/adc/Kconfig                    |   60 +-
 drivers/staging/iio/adc/Makefile                   |    1 +
 drivers/staging/iio/adc/ad7150.c                   |  178 +-
 drivers/staging/iio/adc/ad7152.c                   |   33 +-
 drivers/staging/iio/adc/ad7291.c                   |  502 +-
 drivers/staging/iio/adc/ad7298.h                   |   12 +-
 drivers/staging/iio/adc/ad7298_core.c              |  242 +-
 drivers/staging/iio/adc/ad7298_ring.c              |  134 +-
 drivers/staging/iio/adc/ad7314.c                   |   35 +-
 drivers/staging/iio/adc/ad7476.h                   |    7 +-
 drivers/staging/iio/adc/ad7476_core.c              |  173 +-
 drivers/staging/iio/adc/ad7476_ring.c              |  127 +-
 drivers/staging/iio/adc/ad7606.h                   |   20 +-
 drivers/staging/iio/adc/ad7606_core.c              |  300 +-
 drivers/staging/iio/adc/ad7606_par.c               |   30 +-
 drivers/staging/iio/adc/ad7606_ring.c              |  152 +-
 drivers/staging/iio/adc/ad7606_spi.c               |   24 +-
 drivers/staging/iio/adc/ad7745.c                   |  121 +-
 drivers/staging/iio/adc/ad7780.c                   |  301 +
 drivers/staging/iio/adc/ad7780.h                   |   30 +
 drivers/staging/iio/adc/ad7816.c                   |  111 +-
 drivers/staging/iio/adc/ad7887.h                   |   17 +-
 drivers/staging/iio/adc/ad7887_core.c              |  200 +-
 drivers/staging/iio/adc/ad7887_ring.c              |  156 +-
 drivers/staging/iio/adc/ad799x.h                   |   33 +-
 drivers/staging/iio/adc/ad799x_core.c              |  859 +-
 drivers/staging/iio/adc/ad799x_ring.c              |   93 +-
 drivers/staging/iio/adc/adt7310.c                  |  206 +-
 drivers/staging/iio/adc/adt7410.c                  |  201 +-
 drivers/staging/iio/adc/adt75.c                    |  180 +-
 drivers/staging/iio/adc/max1363.h                  |   93 +-
 drivers/staging/iio/adc/max1363_core.c             | 1945 ++--
 drivers/staging/iio/adc/max1363_ring.c             |  109 +-
 drivers/staging/iio/addac/adt7316.c                |  502 +-
 drivers/staging/iio/chrdev.h                       |   44 +-
 drivers/staging/iio/dac/Kconfig                    |   21 +
 drivers/staging/iio/dac/Makefile                   |    2 +
 drivers/staging/iio/dac/ad5446.c                   |   30 +-
 drivers/staging/iio/dac/ad5446.h                   |    1 +
 drivers/staging/iio/dac/ad5504.c                   |  404 +
 drivers/staging/iio/dac/ad5504.h                   |   70 +
 drivers/staging/iio/dac/ad5624r_spi.c              |   23 +-
 drivers/staging/iio/dac/ad5791.c                   |  444 +
 drivers/staging/iio/dac/ad5791.h                   |  116 +
 drivers/staging/iio/dac/max517.c                   |   17 +-
 drivers/staging/iio/dds/Kconfig                    |    4 +-
 drivers/staging/iio/dds/ad5930.c                   |   14 +-
 drivers/staging/iio/dds/ad9832.c                   |   23 +-
 drivers/staging/iio/dds/ad9834.c                   |   54 +-
 drivers/staging/iio/dds/ad9834.h                   |    8 +-
 drivers/staging/iio/dds/ad9850.c                   |   12 +-
 drivers/staging/iio/dds/ad9852.c                   |   12 +-
 drivers/staging/iio/dds/ad9910.c                   |   12 +-
 drivers/staging/iio/dds/ad9951.c                   |   12 +-
 drivers/staging/iio/gyro/Kconfig                   |   10 +
 drivers/staging/iio/gyro/Makefile                  |    3 +
 drivers/staging/iio/gyro/adis16060_core.c          |   10 +-
 drivers/staging/iio/gyro/adis16080_core.c          |   13 +-
 drivers/staging/iio/gyro/adis16130_core.c          |   14 +-
 drivers/staging/iio/gyro/adis16260.h               |    7 +-
 drivers/staging/iio/gyro/adis16260_core.c          |  477 +-
 drivers/staging/iio/gyro/adis16260_ring.c          |  124 +-
 drivers/staging/iio/gyro/adis16260_trigger.c       |   85 +-
 drivers/staging/iio/gyro/adxrs450.h                |   58 +
 drivers/staging/iio/gyro/adxrs450_core.c           |  455 +
 drivers/staging/iio/gyro/gyro.h                    |    3 +
 drivers/staging/iio/iio.h                          |  356 +-
 drivers/staging/iio/imu/Kconfig                    |   26 +-
 drivers/staging/iio/imu/Makefile                   |    8 -
 drivers/staging/iio/imu/adis16300.h                |  184 -
 drivers/staging/iio/imu/adis16300_core.c           |  756 --
 drivers/staging/iio/imu/adis16300_ring.c           |  238 -
 drivers/staging/iio/imu/adis16300_trigger.c        |  125 -
 drivers/staging/iio/imu/adis16350.h                |  177 -
 drivers/staging/iio/imu/adis16350_core.c           |  757 --
 drivers/staging/iio/imu/adis16350_ring.c           |  236 -
 drivers/staging/iio/imu/adis16350_trigger.c        |  125 -
 drivers/staging/iio/imu/adis16400.h                |   38 +-
 drivers/staging/iio/imu/adis16400_core.c           |  731 +-
 drivers/staging/iio/imu/adis16400_ring.c           |  235 +-
 drivers/staging/iio/imu/adis16400_trigger.c        |  100 +-
 drivers/staging/iio/industrialio-core.c            |  943 +-
 drivers/staging/iio/industrialio-ring.c            |  587 +-
 drivers/staging/iio/industrialio-trigger.c         |  299 +-
 drivers/staging/iio/kfifo_buf.c                    |   63 +-
 drivers/staging/iio/kfifo_buf.h                    |   40 +-
 drivers/staging/iio/light/Kconfig                  |   28 +-
 drivers/staging/iio/light/Makefile                 |    1 +
 drivers/staging/iio/light/isl29018.c               |   23 +-
 drivers/staging/iio/light/tsl2563.c                |  427 +-
 drivers/staging/iio/light/tsl2583.c                |  964 ++
 drivers/staging/iio/magnetometer/ak8975.c          |  130 +-
 drivers/staging/iio/magnetometer/hmc5843.c         |   10 +-
 drivers/staging/iio/meter/ade7753.c                |   14 +-
 drivers/staging/iio/meter/ade7754.c                |   14 +-
 drivers/staging/iio/meter/ade7758.h                |   71 +-
 drivers/staging/iio/meter/ade7758_core.c           |  366 +-
 drivers/staging/iio/meter/ade7758_ring.c           |  281 +-
 drivers/staging/iio/meter/ade7758_trigger.c        |   95 +-
 drivers/staging/iio/meter/ade7759.c                |   15 +-
 drivers/staging/iio/meter/ade7854.c                |   10 +-
 drivers/staging/iio/resolver/ad2s120x.c            |   13 +-
 drivers/staging/iio/resolver/ad2s1210.c            |   12 +-
 drivers/staging/iio/resolver/ad2s90.c              |   12 +-
 drivers/staging/iio/ring_generic.h                 |  293 +-
 drivers/staging/iio/ring_sw.c                      |  205 +-
 drivers/staging/iio/ring_sw.h                      |  196 +-
 drivers/staging/iio/sysfs.h                        |  184 +-
 drivers/staging/iio/trigger.h                      |  116 +-
 drivers/staging/iio/trigger/Kconfig                |    1 +
 drivers/staging/iio/trigger/iio-trig-bfin-timer.c  |   22 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c        |   25 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   24 +-
 drivers/staging/iio/trigger/iio-trig-sysfs.c       |  169 +-
 drivers/staging/intel_sst/intel_sst.c              |  129 +-
 drivers/staging/intel_sst/intel_sst.h              |   33 +-
 .../staging/intel_sst/intel_sst_app_interface.c    |   45 +-
 drivers/staging/intel_sst/intel_sst_common.h       |    9 +-
 .../staging/intel_sst/intel_sst_drv_interface.c    |   24 +-
 drivers/staging/intel_sst/intel_sst_dsp.c          |   14 +-
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |    7 +
 drivers/staging/intel_sst/intel_sst_ioctl.h        |    8 +
 drivers/staging/intel_sst/intel_sst_ipc.c          |   74 +-
 drivers/staging/intel_sst/intel_sst_pvt.c          |    2 +-
 drivers/staging/intel_sst/intel_sst_stream.c       |   15 +-
 .../staging/intel_sst/intel_sst_stream_encoded.c   |    8 +-
 drivers/staging/intel_sst/intelmid.c               |  473 +-
 drivers/staging/intel_sst/intelmid.h               |   38 +-
 drivers/staging/intel_sst/intelmid_adc_control.h   |  193 +
 drivers/staging/intel_sst/intelmid_ctrl.c          |  304 +-
 drivers/staging/intel_sst/intelmid_msic_control.c  |  833 ++-
 drivers/staging/intel_sst/intelmid_pvt.c           |    1 -
 drivers/staging/intel_sst/intelmid_snd_control.h   |    9 +
 drivers/staging/intel_sst/intelmid_v0_control.c    |  109 +-
 drivers/staging/intel_sst/intelmid_v1_control.c    |  141 +-
 drivers/staging/intel_sst/intelmid_v2_control.c    |  219 +-
 drivers/staging/intel_sst/jack.h                   |   10 -
 drivers/staging/keucr/common.h                     |    2 +
 drivers/staging/keucr/init.c                       |    3 -
 drivers/staging/keucr/init.h                       |   10 +-
 drivers/staging/keucr/ms.c                         |  698 +-
 drivers/staging/keucr/ms.h                         |  338 +-
 drivers/staging/keucr/msscsi.c                     |  250 +-
 drivers/staging/keucr/scsiglue.c                   |  192 +-
 drivers/staging/keucr/smcommon.h                   |    2 +-
 drivers/staging/keucr/smil.h                       |  309 +-
 drivers/staging/keucr/smilecc.c                    |  314 +-
 drivers/staging/keucr/smilmain.c                   |  144 +-
 drivers/staging/keucr/smilsub.c                    |   66 +-
 drivers/staging/keucr/smscsi.c                     |    2 -
 drivers/staging/keucr/transport.c                  |  531 +-
 drivers/staging/keucr/transport.h                  |   84 +-
 drivers/staging/keucr/usb.c                        |   95 +-
 drivers/staging/line6/driver.c                     |    2 -
 drivers/staging/lirc/lirc_parallel.c               |   27 +-
 drivers/staging/lirc/lirc_serial.c                 |    2 +-
 drivers/staging/lirc/lirc_sir.c                    |   30 +-
 drivers/staging/mei/Kconfig                        |   28 +
 drivers/staging/mei/Makefile                       |   11 +
 drivers/staging/mei/TODO                           |   17 +
 drivers/staging/mei/hw.h                           |  333 +
 drivers/staging/mei/init.c                         |  770 ++
 drivers/staging/mei/interface.c                    |  447 +
 drivers/staging/mei/interface.h                    |   62 +
 drivers/staging/mei/interrupt.c                    | 1624 +++
 drivers/staging/mei/iorw.c                         |  604 +
 drivers/staging/mei/main.c                         | 1349 ++
 drivers/staging/mei/mei.h                          |  105 +
 drivers/staging/mei/mei.txt                        |  189 +
 drivers/staging/mei/mei_dev.h                      |  422 +
 drivers/staging/mei/mei_version.h                  |   31 +
 drivers/staging/mei/wd.c                           |  183 +
 drivers/staging/nvec/Kconfig                       |   27 +
 drivers/staging/nvec/Makefile                      |    4 +
 drivers/staging/nvec/README                        |   14 +
 drivers/staging/nvec/TODO                          |    8 +
 drivers/staging/nvec/nvec-keytable.h               |  266 +
 drivers/staging/nvec/nvec.c                        |  468 +
 drivers/staging/nvec/nvec.h                        |  110 +
 drivers/staging/nvec/nvec_kbd.c                    |  122 +
 drivers/staging/nvec/nvec_power.c                  |  418 +
 drivers/staging/nvec/nvec_ps2.c                    |  103 +
 drivers/staging/octeon/ethernet-mdio.c             |    2 -
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c         |    2 +-
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c       |   22 +-
 drivers/staging/rt2860/Kconfig                     |   10 -
 drivers/staging/rt2860/Makefile                    |   52 -
 drivers/staging/rt2860/TODO                        |   16 -
 drivers/staging/rt2860/ap.h                        |   68 -
 drivers/staging/rt2860/chip/mac_pci.h              |  355 -
 drivers/staging/rt2860/chip/mac_usb.h              |  345 -
 drivers/staging/rt2860/chip/rt2860.h               |   54 -
 drivers/staging/rt2860/chip/rt2870.h               |   46 -
 drivers/staging/rt2860/chip/rt3070.h               |   67 -
 drivers/staging/rt2860/chip/rt3090.h               |   72 -
 drivers/staging/rt2860/chip/rt30xx.h               |   47 -
 drivers/staging/rt2860/chip/rtmp_mac.h             | 1308 --
 drivers/staging/rt2860/chip/rtmp_phy.h             |  516 -
 drivers/staging/rt2860/chips/rt3070.c              |  169 -
 drivers/staging/rt2860/chips/rt3090.c              |  121 -
 drivers/staging/rt2860/chips/rt30xx.c              |  516 -
 drivers/staging/rt2860/chlist.h                    |  113 -
 drivers/staging/rt2860/common/action.c             |  606 -
 drivers/staging/rt2860/common/action.h             |   56 -
 drivers/staging/rt2860/common/ba_action.c          | 1650 ---
 drivers/staging/rt2860/common/cmm_aes.c            | 1311 --
 drivers/staging/rt2860/common/cmm_asic.c           | 2565 ----
 drivers/staging/rt2860/common/cmm_cfg.c            |  258 -
 drivers/staging/rt2860/common/cmm_data.c           | 2361 ----
 drivers/staging/rt2860/common/cmm_data_pci.c       | 1096 --
 drivers/staging/rt2860/common/cmm_data_usb.c       |  951 --
 drivers/staging/rt2860/common/cmm_info.c           |  955 --
 drivers/staging/rt2860/common/cmm_mac_pci.c        | 1661 ---
 drivers/staging/rt2860/common/cmm_mac_usb.c        | 1162 --
 drivers/staging/rt2860/common/cmm_sanity.c         | 1205 --
 drivers/staging/rt2860/common/cmm_sync.c           |  718 --
 drivers/staging/rt2860/common/cmm_tkip.c           |  833 --
 drivers/staging/rt2860/common/cmm_wep.c            |  473 -
 drivers/staging/rt2860/common/cmm_wpa.c            | 3010 -----
 drivers/staging/rt2860/common/crypt_hmac.c         |  187 -
 drivers/staging/rt2860/common/crypt_md5.c          |  339 -
 drivers/staging/rt2860/common/crypt_sha2.c         |  269 -
 drivers/staging/rt2860/common/dfs.c                |   68 -
 drivers/staging/rt2860/common/ee_efuse.c           |  351 -
 drivers/staging/rt2860/common/ee_prom.c            |  197 -
 drivers/staging/rt2860/common/eeprom.c             |   91 -
 drivers/staging/rt2860/common/mlme.c               | 6068 ---------
 drivers/staging/rt2860/common/rt_channel.c         | 1705 ---
 drivers/staging/rt2860/common/rt_rf.c              |  187 -
 drivers/staging/rt2860/common/rtmp_init.c          | 3536 ------
 drivers/staging/rt2860/common/rtmp_mcu.c           |  336 -
 drivers/staging/rt2860/common/rtmp_timer.c         |  302 -
 drivers/staging/rt2860/common/spectrum.c           | 2205 ----
 drivers/staging/rt2860/crypt_hmac.h                |   65 -
 drivers/staging/rt2860/crypt_md5.h                 |   73 -
 drivers/staging/rt2860/crypt_sha2.h                |   73 -
 drivers/staging/rt2860/dfs.h                       |   39 -
 drivers/staging/rt2860/eeprom.h                    |   67 -
 drivers/staging/rt2860/iface/rtmp_pci.h            |   80 -
 drivers/staging/rt2860/iface/rtmp_usb.h            |  196 -
 drivers/staging/rt2860/mlme.h                      | 1050 --
 drivers/staging/rt2860/oid.h                       |  779 --
 drivers/staging/rt2860/pci_main_dev.c              | 1192 --
 drivers/staging/rt2860/rt_config.h                 |   71 -
 drivers/staging/rt2860/rt_linux.c                  | 1367 --
 drivers/staging/rt2860/rt_linux.h                  |  835 --
 drivers/staging/rt2860/rt_main_dev.c               |  736 --
 drivers/staging/rt2860/rt_pci_rbus.c               |  837 --
 drivers/staging/rt2860/rt_usb.c                    |  794 --
 drivers/staging/rt2860/rtmp.h                      | 4332 -------
 drivers/staging/rt2860/rtmp_chip.h                 |  258 -
 drivers/staging/rt2860/rtmp_ckipmic.h              |   63 -
 drivers/staging/rt2860/rtmp_def.h                  | 1427 ---
 drivers/staging/rt2860/rtmp_dot11.h                |  100 -
 drivers/staging/rt2860/rtmp_iface.h                |   75 -
 drivers/staging/rt2860/rtmp_mcu.h                  |   49 -
 drivers/staging/rt2860/rtmp_os.h                   |   90 -
 drivers/staging/rt2860/rtmp_timer.h                |  148 -
 drivers/staging/rt2860/rtmp_type.h                 |   89 -
 drivers/staging/rt2860/rtusb_io.h                  |  185 -
 drivers/staging/rt2860/spectrum.h                  |  189 -
 drivers/staging/rt2860/spectrum_def.h              |  202 -
 drivers/staging/rt2860/sta/assoc.c                 | 1602 ---
 drivers/staging/rt2860/sta/auth.c                  |  517 -
 drivers/staging/rt2860/sta/auth_rsp.c              |  142 -
 drivers/staging/rt2860/sta/connect.c               | 2613 ----
 drivers/staging/rt2860/sta/rtmp_data.c             | 2552 ----
 drivers/staging/rt2860/sta/sanity.c                |  362 -
 drivers/staging/rt2860/sta/sync.c                  | 1968 ---
 drivers/staging/rt2860/sta/wpa.c                   |  374 -
 drivers/staging/rt2860/sta_ioctl.c                 | 2912 -----
 drivers/staging/rt2860/usb_main_dev.c              |  927 --
 drivers/staging/rt2860/wpa.h                       |  390 -
 drivers/staging/rt2870/Kconfig                     |    9 -
 drivers/staging/rt2870/Makefile                    |   55 -
 drivers/staging/rt2870/TODO                        |   17 -
 drivers/staging/rt2870/aironet.h                   |    1 -
 drivers/staging/rt2870/ap.h                        |    1 -
 drivers/staging/rt2870/chips/rt3070.c              |    1 -
 drivers/staging/rt2870/chips/rt30xx.c              |    1 -
 drivers/staging/rt2870/chlist.h                    |    1 -
 drivers/staging/rt2870/common/acction.c            |    1 -
 drivers/staging/rt2870/common/action.c             |    1 -
 drivers/staging/rt2870/common/action.h             |    1 -
 drivers/staging/rt2870/common/ba_action.c          |    1 -
 drivers/staging/rt2870/common/cmm_aes.c            |    1 -
 drivers/staging/rt2870/common/cmm_asic.c           |    1 -
 drivers/staging/rt2870/common/cmm_cfg.c            |    1 -
 drivers/staging/rt2870/common/cmm_data.c           |    1 -
 drivers/staging/rt2870/common/cmm_data_usb.c       |    1 -
 drivers/staging/rt2870/common/cmm_info.c           |    1 -
 drivers/staging/rt2870/common/cmm_mac_usb.c        |    1 -
 drivers/staging/rt2870/common/cmm_profile.c        |    1 -
 drivers/staging/rt2870/common/cmm_sanity.c         |    1 -
 drivers/staging/rt2870/common/cmm_sync.c           |    1 -
 drivers/staging/rt2870/common/cmm_tkip.c           |    1 -
 drivers/staging/rt2870/common/cmm_wep.c            |    1 -
 drivers/staging/rt2870/common/cmm_wpa.c            |    1 -
 drivers/staging/rt2870/common/crypt_hmac.c         |    1 -
 drivers/staging/rt2870/common/crypt_md5.c          |    1 -
 drivers/staging/rt2870/common/crypt_sha2.c         |    1 -
 drivers/staging/rt2870/common/dfs.c                |    1 -
 drivers/staging/rt2870/common/ee_efuse.c           |    1 -
 drivers/staging/rt2870/common/eeprom.c             |    1 -
 drivers/staging/rt2870/common/md5.c                |    1 -
 drivers/staging/rt2870/common/mlme.c               |    1 -
 drivers/staging/rt2870/common/rt_channel.c         |    1 -
 drivers/staging/rt2870/common/rt_rf.c              |    1 -
 drivers/staging/rt2870/common/rtmp_init.c          |    1 -
 drivers/staging/rt2870/common/rtmp_mcu.c           |    1 -
 drivers/staging/rt2870/common/rtmp_timer.c         |    1 -
 drivers/staging/rt2870/common/rtmp_tkip.c          |    1 -
 drivers/staging/rt2870/common/rtmp_wep.c           |    1 -
 drivers/staging/rt2870/common/rtusb_bulk.c         | 1232 --
 drivers/staging/rt2870/common/rtusb_data.c         |  262 -
 drivers/staging/rt2870/common/rtusb_io.c           | 2104 ----
 drivers/staging/rt2870/common/spectrum.c           |    1 -
 drivers/staging/rt2870/dfs.h                       |    1 -
 drivers/staging/rt2870/md5.h                       |    1 -
 drivers/staging/rt2870/mlme.h                      |    1 -
 drivers/staging/rt2870/oid.h                       |    1 -
 drivers/staging/rt2870/rt28xx.h                    |    1 -
 drivers/staging/rt2870/rt_config.h                 |    1 -
 drivers/staging/rt2870/rt_linux.c                  |    1 -
 drivers/staging/rt2870/rt_linux.h                  |    1 -
 drivers/staging/rt2870/rt_main_dev.c               |    1 -
 drivers/staging/rt2870/rt_profile.c                |    1 -
 drivers/staging/rt2870/rt_usb.c                    |    1 -
 drivers/staging/rt2870/rtmp.h                      |    1 -
 drivers/staging/rt2870/rtmp_ckipmic.h              |    1 -
 drivers/staging/rt2870/rtmp_def.h                  |    1 -
 drivers/staging/rt2870/rtmp_type.h                 |    1 -
 drivers/staging/rt2870/spectrum.h                  |    1 -
 drivers/staging/rt2870/spectrum_def.h              |    1 -
 drivers/staging/rt2870/sta/aironet.c               |    1 -
 drivers/staging/rt2870/sta/assoc.c                 |    1 -
 drivers/staging/rt2870/sta/auth.c                  |    1 -
 drivers/staging/rt2870/sta/auth_rsp.c              |    1 -
 drivers/staging/rt2870/sta/connect.c               |    1 -
 drivers/staging/rt2870/sta/rtmp_data.c             |    1 -
 drivers/staging/rt2870/sta/sanity.c                |    1 -
 drivers/staging/rt2870/sta/sync.c                  |    1 -
 drivers/staging/rt2870/sta/wpa.c                   |    1 -
 drivers/staging/rt2870/sta_ioctl.c                 |    1 -
 drivers/staging/rt2870/usb_main_dev.c              |    1 -
 drivers/staging/rt2870/wpa.h                       |    1 -
 drivers/staging/rtl8712/ieee80211.h                |   26 +-
 drivers/staging/rtl8712/if_ether.h                 |    4 +-
 drivers/staging/rtl8712/ip.h                       |   34 +-
 drivers/staging/rtl8712/mlme_osdep.h               |    4 +-
 drivers/staging/rtl8712/osdep_service.h            |    3 +-
 drivers/staging/rtl8712/recv_osdep.h               |    4 +-
 drivers/staging/rtl8712/rtl8712_event.h            |   25 +-
 drivers/staging/rtl8712/rtl8712_hal.h              |  100 +-
 drivers/staging/rtl8712/rtl8712_led.c              |    2 +-
 drivers/staging/rtl8712/rtl8712_recv.c             |    2 +-
 drivers/staging/rtl8712/rtl8712_recv.h             |    2 +-
 drivers/staging/rtl8712/rtl8712_xmit.h             |   11 +-
 drivers/staging/rtl8712/rtl871x_cmd.c              |    7 +-
 drivers/staging/rtl8712/rtl871x_cmd.h              |   26 +-
 drivers/staging/rtl8712/rtl871x_event.h            |   12 +-
 drivers/staging/rtl8712/rtl871x_io.c               |    6 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      |    9 +-
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c        |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c        |    5 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.h        |   16 +-
 drivers/staging/rtl8712/rtl871x_mp.c               |    8 +-
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h         |   10 +-
 drivers/staging/rtl8712/rtl871x_recv.c             |   16 +-
 drivers/staging/rtl8712/rtl871x_recv.h             |    4 +-
 drivers/staging/rtl8712/rtl871x_rf.h               |    2 +-
 drivers/staging/rtl8712/rtl871x_security.h         |   51 +-
 drivers/staging/rtl8712/rtl871x_xmit.c             |    3 +-
 drivers/staging/rtl8712/rtl871x_xmit.h             |    3 +-
 drivers/staging/rtl8712/wifi.h                     |   63 +-
 drivers/staging/rtl8712/wlan_bssdef.h              |  212 +-
 drivers/staging/rts_pstor/ms.c                     |   52 +-
 drivers/staging/rts_pstor/rtsx.c                   |    4 +-
 drivers/staging/rts_pstor/rtsx.h                   |    3 -
 drivers/staging/rts_pstor/sd.c                     |    1 +
 drivers/staging/rts_pstor/spi.c                    |   34 +-
 drivers/staging/rts_pstor/xd.c                     |    4 +-
 drivers/staging/sbe-2t3e3/dc.c                     |   33 +-
 drivers/staging/sep/sep_driver.c                   |    9 +-
 drivers/staging/sm7xx/TODO                         |    2 -
 drivers/staging/sm7xx/smtcfb.c                     |  215 +-
 drivers/staging/sm7xx/smtcfb.h                     |    7 +-
 drivers/staging/tty/istallion.c                    |    2 +-
 drivers/staging/usbip/Kconfig                      |   52 +-
 drivers/staging/usbip/Makefile                     |   15 +-
 drivers/staging/usbip/stub.h                       |   33 +-
 drivers/staging/usbip/stub_dev.c                   |   97 +-
 drivers/staging/usbip/stub_main.c                  |   51 +-
 drivers/staging/usbip/stub_rx.c                    |   68 +-
 drivers/staging/usbip/stub_tx.c                    |   81 +-
 drivers/staging/usbip/usbip_common.c               |  333 +-
 drivers/staging/usbip/usbip_common.h               |  139 +-
 drivers/staging/usbip/usbip_event.c                |   20 +-
 drivers/staging/usbip/userspace/AUTHORS            |    2 +
 drivers/staging/usbip/userspace/COPYING            |  340 +
 drivers/staging/usbip/userspace/INSTALL            |  237 +
 drivers/staging/usbip/userspace/Makefile.am        |   11 +
 drivers/staging/usbip/userspace/README             |  215 +
 drivers/staging/usbip/userspace/autogen.sh         |    9 +
 drivers/staging/usbip/userspace/cleanup.sh         |   10 +
 drivers/staging/usbip/userspace/configure.ac       |  114 +
 drivers/staging/usbip/userspace/doc/usbip.8        |   71 +
 .../usbip/userspace/doc/usbip_bind_driver.8        |   42 +
 drivers/staging/usbip/userspace/doc/usbipd.8       |   62 +
 drivers/staging/usbip/userspace/libsrc/Makefile.am |    7 +
 drivers/staging/usbip/userspace/libsrc/names.c     |  793 ++
 drivers/staging/usbip/userspace/libsrc/names.h     |   57 +
 .../staging/usbip/userspace/libsrc/stub_driver.c   |  391 +
 .../staging/usbip/userspace/libsrc/stub_driver.h   |   36 +
 drivers/staging/usbip/userspace/libsrc/usbip.h     |   19 +
 .../staging/usbip/userspace/libsrc/usbip_common.c  |  282 +
 .../staging/usbip/userspace/libsrc/usbip_common.h  |  149 +
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |  506 +
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   61 +
 drivers/staging/usbip/userspace/src/Makefile.am    |   10 +
 drivers/staging/usbip/userspace/src/bind-driver.c  |  643 +
 drivers/staging/usbip/userspace/src/usbip.c        |  723 ++
 .../staging/usbip/userspace/src/usbip_network.c    |  251 +
 .../staging/usbip/userspace/src/usbip_network.h    |  198 +
 drivers/staging/usbip/userspace/src/usbipd.c       |  570 +
 drivers/staging/usbip/userspace/src/utils.c        |  255 +
 drivers/staging/usbip/userspace/src/utils.h        |   38 +
 drivers/staging/usbip/userspace/usb.ids            |13209 ++++++++++++++++++++
 drivers/staging/usbip/vhci.h                       |   38 +-
 drivers/staging/usbip/vhci_hcd.c                   |  284 +-
 drivers/staging/usbip/vhci_rx.c                    |   74 +-
 drivers/staging/usbip/vhci_sysfs.c                 |   30 +-
 drivers/staging/usbip/vhci_tx.c                    |   44 +-
 drivers/staging/vt6655/bssdb.c                     |    8 +-
 drivers/staging/vt6655/device.h                    |    2 +-
 drivers/staging/vt6655/device_main.c               |   14 +-
 drivers/staging/vt6655/dpc.c                       |   10 +-
 drivers/staging/vt6655/ioctl.c                     |   44 +-
 drivers/staging/vt6655/power.c                     |    2 +-
 drivers/staging/vt6655/rxtx.c                      |    4 +-
 drivers/staging/vt6655/wcmd.c                      |   14 +-
 drivers/staging/vt6655/wmgr.c                      |   46 +-
 drivers/staging/vt6655/wpactl.c                    |   10 +-
 drivers/staging/vt6656/bssdb.c                     |    8 +-
 drivers/staging/vt6656/dpc.c                       |   10 +-
 drivers/staging/vt6656/ioctl.c                     |   44 +-
 drivers/staging/vt6656/main_usb.c                  |    7 +-
 drivers/staging/vt6656/rxtx.c                      |    4 +-
 drivers/staging/vt6656/wcmd.c                      |    8 +-
 drivers/staging/vt6656/wmgr.c                      |   48 +-
 drivers/staging/vt6656/wpactl.c                    |   10 +-
 .../arch/arm/mach-omap2/cyashalomap_kernel.c       |    2 +-
 .../westbridge/astoria/block/cyasblkdev_block.c    |    2 +-
 drivers/staging/winbond/mto.c                      |   10 -
 drivers/staging/winbond/phy_calibration.c          |    8 +-
 drivers/staging/winbond/wb35tx.c                   |    3 +-
 drivers/staging/xgifb/XGI_main.h                   |  792 +-
 drivers/staging/xgifb/XGI_main_26.c                | 1259 +-
 drivers/staging/xgifb/XGIfb.h                      |  142 +-
 drivers/staging/xgifb/vb_def.h                     | 1269 +-
 drivers/staging/xgifb/vb_ext.c                     |  138 +-
 drivers/staging/xgifb/vb_ext.h                     |   25 +-
 drivers/staging/xgifb/vb_init.c                    |  527 +-
 drivers/staging/xgifb/vb_init.h                    |    7 +-
 drivers/staging/xgifb/vb_setmode.c                 | 1885 ++--
 drivers/staging/xgifb/vb_setmode.h                 |   97 +-
 drivers/staging/xgifb/vb_struct.h                  |  823 +-
 drivers/staging/xgifb/vb_table.h                   | 8147 ++++++------
 drivers/staging/xgifb/vb_util.c                    |    2 +-
 drivers/staging/xgifb/vgatypes.h                   |  113 +-
 kernel/module.c                                    |    4 +-
 822 files changed, 68690 insertions(+), 172256 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/include/a_types.h
 delete mode 100644 drivers/staging/ath6kl/include/athendpack.h
 delete mode 100644 drivers/staging/ath6kl/include/athstartpack.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6002_regdump.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_ares_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/bb_lc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/efuse_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_dma_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_pcu_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rdma_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/a_hci.h
 delete mode 100644 drivers/staging/ath6kl/include/common/btcoexGpio.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dset_internal.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dsetid.h
 delete mode 100644 drivers/staging/ath6kl/include/common/gpio.h
 create mode 100644 drivers/staging/ath6kl/include/common/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/ini_dset.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regDb.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regdump.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h
 delete mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbvalues.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wlan_dset.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmi_thin.h
 delete mode 100644 drivers/staging/ath6kl/include/gpio_api.h
 delete mode 100644 drivers/staging/ath6kl/include/target_reg_table.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_android.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6k_pal.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/eeprom.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/athtypes_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/ioctl.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/wireless_ext.c
 rename drivers/staging/brcm80211/{util/siutils_priv.h => brcmfmac/bcmchip.h} (52%)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmutils.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/bcmwifi.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/hndpmu.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/sbutils.c
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/siutils.c
 rename drivers/staging/brcm80211/{util/siutils.c => brcmsmac/aiutils.c} (55%)
 create mode 100644 drivers/staging/brcm80211/brcmsmac/aiutils.h
 rename drivers/staging/brcm80211/{util => brcmsmac}/bcmotp.c (90%)
 create mode 100644 drivers/staging/brcm80211/brcmsmac/bcmsrom.c
 rename drivers/staging/brcm80211/{util => brcmsmac}/bcmsrom_tbl.h (89%)
 rename drivers/staging/brcm80211/{util => brcmsmac}/hnddma.c (94%)
 rename drivers/staging/brcm80211/{util => brcmsmac}/nicpci.c (92%)
 rename drivers/staging/brcm80211/{util/nvram/nvram_ro.c => brcmsmac/nvram.c} (76%)
 create mode 100644 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_qmath.c
 rename drivers/staging/brcm80211/{include/qmath.h => brcmsmac/phy/wlc_phy_qmath.h} (63%)
 rename drivers/staging/brcm80211/{util/hndpmu.c => brcmsmac/wlc_pmu.c} (67%)
 rename drivers/staging/brcm80211/{include/hndpmu.h => brcmsmac/wlc_pmu.h} (77%)
 rename drivers/staging/brcm80211/{util => include}/pci_core.h (100%)
 delete mode 100644 drivers/staging/brcm80211/include/siutils.h
 create mode 100644 drivers/staging/brcm80211/util/Makefile
 delete mode 100644 drivers/staging/brcm80211/util/aiutils.c
 delete mode 100644 drivers/staging/brcm80211/util/bcmsrom.c
 delete mode 100644 drivers/staging/brcm80211/util/qmath.c
 delete mode 100644 drivers/staging/brcm80211/util/sbpcmcia.h
 delete mode 100644 drivers/staging/brcm80211/util/sbsocram.h
 delete mode 100644 drivers/staging/brcm80211/util/sbutils.c
 create mode 100644 drivers/staging/gma500/mrst.h
 create mode 100644 drivers/staging/gma500/mrst_crtc.c
 create mode 100644 drivers/staging/gma500/mrst_lvds.c
 delete mode 100644 drivers/staging/gma500/psb_buffer.c
 delete mode 100644 drivers/staging/gma500/psb_fence.c
 create mode 100644 drivers/staging/gma500/psb_gem.c
 rename drivers/staging/gma500/{psb_reset.c => psb_lid.c} (100%)
 delete mode 100644 drivers/staging/gma500/psb_pvr_glue.c
 delete mode 100644 drivers/staging/gma500/psb_pvr_glue.h
 delete mode 100644 drivers/staging/gma500/psb_sgx.c
 delete mode 100644 drivers/staging/gma500/psb_sgx.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_api.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_driver.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_user.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_fence_user.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_glue.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_placement_user.c
 delete mode 100644 drivers/staging/gma500/psb_ttm_placement_user.h
 delete mode 100644 drivers/staging/gma500/psb_ttm_userobj_api.h
 delete mode 100644 drivers/staging/hv/blkvsc.c
 delete mode 100644 drivers/staging/hv/channel.h
 delete mode 100644 drivers/staging/hv/channel_mgmt.h
 delete mode 100644 drivers/staging/hv/hv.h
 delete mode 100644 drivers/staging/hv/hv_api.h
 create mode 100644 drivers/staging/hv/hyperv.h
 rename drivers/staging/hv/{rndis.h => hyperv_net.h} (65%)
 rename drivers/staging/hv/{vstorage.h => hyperv_storage.h} (63%)
 create mode 100644 drivers/staging/hv/hyperv_vmbus.h
 delete mode 100644 drivers/staging/hv/logging.h
 delete mode 100644 drivers/staging/hv/netvsc.h
 delete mode 100644 drivers/staging/hv/netvsc_api.h
 delete mode 100644 drivers/staging/hv/ring_buffer.h
 delete mode 100644 drivers/staging/hv/rndis_filter.h
 delete mode 100644 drivers/staging/hv/storvsc_api.h
 delete mode 100644 drivers/staging/hv/utils.h
 delete mode 100644 drivers/staging/hv/version_info.h
 delete mode 100644 drivers/staging/hv/vmbus.h
 delete mode 100644 drivers/staging/hv/vmbus_api.h
 delete mode 100644 drivers/staging/hv/vmbus_channel_interface.h
 delete mode 100644 drivers/staging/hv/vmbus_packet_format.h
 delete mode 100644 drivers/staging/hv/vmbus_private.h
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-light-tsl2583
 delete mode 100644 drivers/staging/iio/Documentation/userspace.txt
 create mode 100644 drivers/staging/iio/adc/ad7780.c
 create mode 100644 drivers/staging/iio/adc/ad7780.h
 create mode 100644 drivers/staging/iio/dac/ad5504.c
 create mode 100644 drivers/staging/iio/dac/ad5504.h
 create mode 100644 drivers/staging/iio/dac/ad5791.c
 create mode 100644 drivers/staging/iio/dac/ad5791.h
 create mode 100644 drivers/staging/iio/gyro/adxrs450.h
 create mode 100644 drivers/staging/iio/gyro/adxrs450_core.c
 delete mode 100644 drivers/staging/iio/imu/adis16300.h
 delete mode 100644 drivers/staging/iio/imu/adis16300_core.c
 delete mode 100644 drivers/staging/iio/imu/adis16300_ring.c
 delete mode 100644 drivers/staging/iio/imu/adis16300_trigger.c
 delete mode 100644 drivers/staging/iio/imu/adis16350.h
 delete mode 100644 drivers/staging/iio/imu/adis16350_core.c
 delete mode 100644 drivers/staging/iio/imu/adis16350_ring.c
 delete mode 100644 drivers/staging/iio/imu/adis16350_trigger.c
 create mode 100644 drivers/staging/iio/light/tsl2583.c
 create mode 100644 drivers/staging/intel_sst/intelmid_adc_control.h
 delete mode 100644 drivers/staging/intel_sst/jack.h
 create mode 100644 drivers/staging/mei/Kconfig
 create mode 100644 drivers/staging/mei/Makefile
 create mode 100644 drivers/staging/mei/TODO
 create mode 100644 drivers/staging/mei/hw.h
 create mode 100644 drivers/staging/mei/init.c
 create mode 100644 drivers/staging/mei/interface.c
 create mode 100644 drivers/staging/mei/interface.h
 create mode 100644 drivers/staging/mei/interrupt.c
 create mode 100644 drivers/staging/mei/iorw.c
 create mode 100644 drivers/staging/mei/main.c
 create mode 100644 drivers/staging/mei/mei.h
 create mode 100644 drivers/staging/mei/mei.txt
 create mode 100644 drivers/staging/mei/mei_dev.h
 create mode 100644 drivers/staging/mei/mei_version.h
 create mode 100644 drivers/staging/mei/wd.c
 create mode 100644 drivers/staging/nvec/Kconfig
 create mode 100644 drivers/staging/nvec/Makefile
 create mode 100644 drivers/staging/nvec/README
 create mode 100644 drivers/staging/nvec/TODO
 create mode 100644 drivers/staging/nvec/nvec-keytable.h
 create mode 100644 drivers/staging/nvec/nvec.c
 create mode 100644 drivers/staging/nvec/nvec.h
 create mode 100644 drivers/staging/nvec/nvec_kbd.c
 create mode 100644 drivers/staging/nvec/nvec_power.c
 create mode 100644 drivers/staging/nvec/nvec_ps2.c
 delete mode 100644 drivers/staging/rt2860/Kconfig
 delete mode 100644 drivers/staging/rt2860/Makefile
 delete mode 100644 drivers/staging/rt2860/TODO
 delete mode 100644 drivers/staging/rt2860/ap.h
 delete mode 100644 drivers/staging/rt2860/chip/mac_pci.h
 delete mode 100644 drivers/staging/rt2860/chip/mac_usb.h
 delete mode 100644 drivers/staging/rt2860/chip/rt2860.h
 delete mode 100644 drivers/staging/rt2860/chip/rt2870.h
 delete mode 100644 drivers/staging/rt2860/chip/rt3070.h
 delete mode 100644 drivers/staging/rt2860/chip/rt3090.h
 delete mode 100644 drivers/staging/rt2860/chip/rt30xx.h
 delete mode 100644 drivers/staging/rt2860/chip/rtmp_mac.h
 delete mode 100644 drivers/staging/rt2860/chip/rtmp_phy.h
 delete mode 100644 drivers/staging/rt2860/chips/rt3070.c
 delete mode 100644 drivers/staging/rt2860/chips/rt3090.c
 delete mode 100644 drivers/staging/rt2860/chips/rt30xx.c
 delete mode 100644 drivers/staging/rt2860/chlist.h
 delete mode 100644 drivers/staging/rt2860/common/action.c
 delete mode 100644 drivers/staging/rt2860/common/action.h
 delete mode 100644 drivers/staging/rt2860/common/ba_action.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_aes.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_asic.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_cfg.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_data.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_data_pci.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_data_usb.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_info.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_mac_pci.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_mac_usb.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_sanity.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_sync.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_tkip.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_wep.c
 delete mode 100644 drivers/staging/rt2860/common/cmm_wpa.c
 delete mode 100644 drivers/staging/rt2860/common/crypt_hmac.c
 delete mode 100644 drivers/staging/rt2860/common/crypt_md5.c
 delete mode 100644 drivers/staging/rt2860/common/crypt_sha2.c
 delete mode 100644 drivers/staging/rt2860/common/dfs.c
 delete mode 100644 drivers/staging/rt2860/common/ee_efuse.c
 delete mode 100644 drivers/staging/rt2860/common/ee_prom.c
 delete mode 100644 drivers/staging/rt2860/common/eeprom.c
 delete mode 100644 drivers/staging/rt2860/common/mlme.c
 delete mode 100644 drivers/staging/rt2860/common/rt_channel.c
 delete mode 100644 drivers/staging/rt2860/common/rt_rf.c
 delete mode 100644 drivers/staging/rt2860/common/rtmp_init.c
 delete mode 100644 drivers/staging/rt2860/common/rtmp_mcu.c
 delete mode 100644 drivers/staging/rt2860/common/rtmp_timer.c
 delete mode 100644 drivers/staging/rt2860/common/spectrum.c
 delete mode 100644 drivers/staging/rt2860/crypt_hmac.h
 delete mode 100644 drivers/staging/rt2860/crypt_md5.h
 delete mode 100644 drivers/staging/rt2860/crypt_sha2.h
 delete mode 100644 drivers/staging/rt2860/dfs.h
 delete mode 100644 drivers/staging/rt2860/eeprom.h
 delete mode 100644 drivers/staging/rt2860/iface/rtmp_pci.h
 delete mode 100644 drivers/staging/rt2860/iface/rtmp_usb.h
 delete mode 100644 drivers/staging/rt2860/mlme.h
 delete mode 100644 drivers/staging/rt2860/oid.h
 delete mode 100644 drivers/staging/rt2860/pci_main_dev.c
 delete mode 100644 drivers/staging/rt2860/rt_config.h
 delete mode 100644 drivers/staging/rt2860/rt_linux.c
 delete mode 100644 drivers/staging/rt2860/rt_linux.h
 delete mode 100644 drivers/staging/rt2860/rt_main_dev.c
 delete mode 100644 drivers/staging/rt2860/rt_pci_rbus.c
 delete mode 100644 drivers/staging/rt2860/rt_usb.c
 delete mode 100644 drivers/staging/rt2860/rtmp.h
 delete mode 100644 drivers/staging/rt2860/rtmp_chip.h
 delete mode 100644 drivers/staging/rt2860/rtmp_ckipmic.h
 delete mode 100644 drivers/staging/rt2860/rtmp_def.h
 delete mode 100644 drivers/staging/rt2860/rtmp_dot11.h
 delete mode 100644 drivers/staging/rt2860/rtmp_iface.h
 delete mode 100644 drivers/staging/rt2860/rtmp_mcu.h
 delete mode 100644 drivers/staging/rt2860/rtmp_os.h
 delete mode 100644 drivers/staging/rt2860/rtmp_timer.h
 delete mode 100644 drivers/staging/rt2860/rtmp_type.h
 delete mode 100644 drivers/staging/rt2860/rtusb_io.h
 delete mode 100644 drivers/staging/rt2860/spectrum.h
 delete mode 100644 drivers/staging/rt2860/spectrum_def.h
 delete mode 100644 drivers/staging/rt2860/sta/assoc.c
 delete mode 100644 drivers/staging/rt2860/sta/auth.c
 delete mode 100644 drivers/staging/rt2860/sta/auth_rsp.c
 delete mode 100644 drivers/staging/rt2860/sta/connect.c
 delete mode 100644 drivers/staging/rt2860/sta/rtmp_data.c
 delete mode 100644 drivers/staging/rt2860/sta/sanity.c
 delete mode 100644 drivers/staging/rt2860/sta/sync.c
 delete mode 100644 drivers/staging/rt2860/sta/wpa.c
 delete mode 100644 drivers/staging/rt2860/sta_ioctl.c
 delete mode 100644 drivers/staging/rt2860/usb_main_dev.c
 delete mode 100644 drivers/staging/rt2860/wpa.h
 delete mode 100644 drivers/staging/rt2870/Kconfig
 delete mode 100644 drivers/staging/rt2870/Makefile
 delete mode 100644 drivers/staging/rt2870/TODO
 delete mode 100644 drivers/staging/rt2870/aironet.h
 delete mode 100644 drivers/staging/rt2870/ap.h
 delete mode 100644 drivers/staging/rt2870/chips/rt3070.c
 delete mode 100644 drivers/staging/rt2870/chips/rt30xx.c
 delete mode 100644 drivers/staging/rt2870/chlist.h
 delete mode 100644 drivers/staging/rt2870/common/acction.c
 delete mode 100644 drivers/staging/rt2870/common/action.c
 delete mode 100644 drivers/staging/rt2870/common/action.h
 delete mode 100644 drivers/staging/rt2870/common/ba_action.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_aes.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_asic.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_cfg.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_data.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_data_usb.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_info.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_mac_usb.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_profile.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_sanity.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_sync.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_tkip.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_wep.c
 delete mode 100644 drivers/staging/rt2870/common/cmm_wpa.c
 delete mode 100644 drivers/staging/rt2870/common/crypt_hmac.c
 delete mode 100644 drivers/staging/rt2870/common/crypt_md5.c
 delete mode 100644 drivers/staging/rt2870/common/crypt_sha2.c
 delete mode 100644 drivers/staging/rt2870/common/dfs.c
 delete mode 100644 drivers/staging/rt2870/common/ee_efuse.c
 delete mode 100644 drivers/staging/rt2870/common/eeprom.c
 delete mode 100644 drivers/staging/rt2870/common/md5.c
 delete mode 100644 drivers/staging/rt2870/common/mlme.c
 delete mode 100644 drivers/staging/rt2870/common/rt_channel.c
 delete mode 100644 drivers/staging/rt2870/common/rt_rf.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_init.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_mcu.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_timer.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_tkip.c
 delete mode 100644 drivers/staging/rt2870/common/rtmp_wep.c
 delete mode 100644 drivers/staging/rt2870/common/rtusb_bulk.c
 delete mode 100644 drivers/staging/rt2870/common/rtusb_data.c
 delete mode 100644 drivers/staging/rt2870/common/rtusb_io.c
 delete mode 100644 drivers/staging/rt2870/common/spectrum.c
 delete mode 100644 drivers/staging/rt2870/dfs.h
 delete mode 100644 drivers/staging/rt2870/md5.h
 delete mode 100644 drivers/staging/rt2870/mlme.h
 delete mode 100644 drivers/staging/rt2870/oid.h
 delete mode 100644 drivers/staging/rt2870/rt28xx.h
 delete mode 100644 drivers/staging/rt2870/rt_config.h
 delete mode 100644 drivers/staging/rt2870/rt_linux.c
 delete mode 100644 drivers/staging/rt2870/rt_linux.h
 delete mode 100644 drivers/staging/rt2870/rt_main_dev.c
 delete mode 100644 drivers/staging/rt2870/rt_profile.c
 delete mode 100644 drivers/staging/rt2870/rt_usb.c
 delete mode 100644 drivers/staging/rt2870/rtmp.h
 delete mode 100644 drivers/staging/rt2870/rtmp_ckipmic.h
 delete mode 100644 drivers/staging/rt2870/rtmp_def.h
 delete mode 100644 drivers/staging/rt2870/rtmp_type.h
 delete mode 100644 drivers/staging/rt2870/spectrum.h
 delete mode 100644 drivers/staging/rt2870/spectrum_def.h
 delete mode 100644 drivers/staging/rt2870/sta/aironet.c
 delete mode 100644 drivers/staging/rt2870/sta/assoc.c
 delete mode 100644 drivers/staging/rt2870/sta/auth.c
 delete mode 100644 drivers/staging/rt2870/sta/auth_rsp.c
 delete mode 100644 drivers/staging/rt2870/sta/connect.c
 delete mode 100644 drivers/staging/rt2870/sta/rtmp_data.c
 delete mode 100644 drivers/staging/rt2870/sta/sanity.c
 delete mode 100644 drivers/staging/rt2870/sta/sync.c
 delete mode 100644 drivers/staging/rt2870/sta/wpa.c
 delete mode 100644 drivers/staging/rt2870/sta_ioctl.c
 delete mode 100644 drivers/staging/rt2870/usb_main_dev.c
 delete mode 100644 drivers/staging/rt2870/wpa.h
 create mode 100644 drivers/staging/usbip/userspace/AUTHORS
 create mode 100644 drivers/staging/usbip/userspace/COPYING
 create mode 100644 drivers/staging/usbip/userspace/INSTALL
 create mode 100644 drivers/staging/usbip/userspace/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/README
 create mode 100755 drivers/staging/usbip/userspace/autogen.sh
 create mode 100755 drivers/staging/usbip/userspace/cleanup.sh
 create mode 100644 drivers/staging/usbip/userspace/configure.ac
 create mode 100644 drivers/staging/usbip/userspace/doc/usbip.8
 create mode 100644 drivers/staging/usbip/userspace/doc/usbip_bind_driver.8
 create mode 100644 drivers/staging/usbip/userspace/doc/usbipd.8
 create mode 100644 drivers/staging/usbip/userspace/libsrc/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/libsrc/names.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/names.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/stub_driver.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/usbip_common.h
 create mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.c
 create mode 100644 drivers/staging/usbip/userspace/libsrc/vhci_driver.h
 create mode 100644 drivers/staging/usbip/userspace/src/Makefile.am
 create mode 100644 drivers/staging/usbip/userspace/src/bind-driver.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_network.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_network.h
 create mode 100644 drivers/staging/usbip/userspace/src/usbipd.c
 create mode 100644 drivers/staging/usbip/userspace/src/utils.c
 create mode 100644 drivers/staging/usbip/userspace/src/utils.h
 create mode 100644 drivers/staging/usbip/userspace/usb.ids

---------------

Aaro Koskinen (12):
      staging: xgifb: replace outXGIREG() with outb()
      staging: xgifb: replace inXGIIDXREG() with xgifb_reg_get()
      staging: xgifb: replace outXGIIDXREG() with xgifb_reg_set()
      staging: xgifb: replace orXGIIDXREG() with xgifb_reg_or()
      staging: xgifb: replace andXGIIDXREG() with xgifb_reg_and()
      staging: xgifb: replace setXGIIDXREG() with xgifb_reg_and_or()
      staging: xgifb: delete unused register I/O macros
      staging: xgifb: delete unused register I/O functions
      staging: xgifb: main: move functions to avoid forward declarations
      staging: xgifb: main: delete redudant extern declarations
      staging: xgifb: main: delete unused functions
      staging: xgifb: main: make internal functions static

Alan Cox (49):
      staging: gma500: begin adding Moorestown support
      staging: gma500: Add moorestown lvds driver code
      staging: gma500: Make some of the lvds operations non-static
      staging: gma500: Add moorestown config structures
      staging: gma500: Add moorestown specific data to the device structure
      staging: gma500: Makefiles
      staging: gma500: Add Moorestown backlight support
      staging: gma500: add framebuffer setup
      staging: gma500: enable Moorestown CRTC handling
      staging: gma500: Moorestown does its setup differently
      staging: gma500: Add Moorestown identifiers
      staging: gma500: delete the RAR handling
      staging: gma500: We don't support the CI either
      staging: gma500: Clean up more unused structures and code
      staging: gma500: pull mrst firmware stuff into its own header
      staging: gma500: kill off TTM
      staging: gma500: turn on psb SDVO
      staging: gma500: Another file we don't need
      staging: gma500: kill some more #if 0 bits
      staging: gma500: Fix some set up bugs found by comparing driver versions
      staging: gma500: Add a test ioctl for issuing 2D accel ops via user space
      staging: gma500: prune more unused fields
      staging: gma500: begin tidying up the power management
      staging: gma500: cleanup the SDVO messages
      staging: gma500: Set the TWOD base
      staging: gma500: psb_reset actually holds lid functions
      staging: gma500: enable the 2D op stuff
      staging: gma500: Add oaktrail
      Staging: iio: oaktrail AK8975 support via IIO
      gma500: ioctl first pass
      gma500: prepare to do some actual memory management
      gma500: backlight warning
      gma500: Add a gtt allocator
      gma500: Tidy up the allocations
      gma500: add the ability to request backed space or not
      gma500: begin adding GEM
      gma500: Add support for inserting and removing pages from the GART
      gma500: Begin the GEMification of the cursor code
      gma500: GEMify the frame buffer base bits
      gma500: GEM - now we have the basics we shall stick pins in it
      gma500: prune some unused variables
      gma500: allow non stolen page backed framebuffer
      gma500: The MID devices have the register offset different
      gma500: sort out the file operations
      gma500: Fix dumb create crash
      sst: tweak the shared functions so we don't crash the ASoC driver
      gma500: enable GEM mmap
      gma500: Don't try and take a GEM handle of a non GEM fb
      gma500: finish off the fault handler

Alexander Beregalov (6):
      Staging: sbe-2t3e3: remove T3E3_USE_CONTIGMALLOC
      Staging: sbe-2t3e3: redundant null check before kfree()
      Staging: rts_pstor: s/rtsx_free_dma_buf/kfree/
      Staging: rts_pstor: s/rtsx_alloc_dma_buf/kmalloc/
      Staging: rts_pstor: redundant null check before kfree()
      Staging: rtl8712: redundant null check before kfree()

Andy CH Lin (1):
      intel_sst: intelmid_v2_control: correct jack event type

Arend van Spriel (57):
      staging: brcm80211: cleanup si_doattach function for fullmac
      staging: brcm80211: remove duplicate prototype for si_pmu_pllupd
      staging: brcm80211: replace si_* calls with ai_* calls in brcmsmac driver
      staging: brcm80211: remove defines from bcmsrom.c
      staging: brcm80211: remove unneccessary include from bcmsrom.c
      staging: brcm80211: remove conditional BCMSDIO code from bcmsrom.c
      staging: brcm80211: remove support functions for older chipsets from bcmsrom
      staging: brcm80211: separate hndpmu functionality for brcmsmac driver
      staging: brcm80211: remove unnecessary include from nvram_ro.c
      staging: brcm80211: remove unnecessary if statements from bss_info_changed
      staging: brcm80211: remove wl_ops_set_rts_threshold
      staging: brcm80211: rename rate related definitions
      staging: brcm80211: honour basic rate configuration from mac80211
      staging: brcm80211: implement flush driver callback for mac80211
      staging: brcm80211: rename active_queue identifier
      staging: brcm80211: remove queue info parameter from wlc_send_q
      staging: brcm80211: provide TSF value in receive status
      staging: brcm80211: remove tsf retrieval from wlc_bmac.c
      staging: brcm80211: remove retrieval function for tsf in wlc_main.c
      Revert "staging: brcm80211: separate hndpmu functionality for brcmsmac driver"
      staging: brcm80211: remove unused functions from hndpmu.c
      staging: brcm80211: remove use of si_* functions from wlc_phy_lcn.c
      staging: brcm80211: separate hndpmu functionality for brcmsmac driver
      staging: brcm80211: remove dependency between aiutils and siutils sources
      staging: brcm80211: fix checkpatch warnings in si_pmu_spuravoid_pllupdate
      staging: brcm80211: remove zero initialization of static in si_pmu_ilp_clock
      staging: brcm80211: fix checkpatch warning in si_pmu_res_init
      staging: brcm80211: fix checkpatch issues in si_pmu_measure_alpclk
      staging: brcm80211: fix checkpatch warning in si_pmu_otp_power
      staging: brcm80211: cleanup definitions in aiutils header file
      staging: brcm80211: cleanup code in source file aiutils.c
      staging: brcm80211: move aiutils source files to brcmsmac folder
      staging: brcm80211: remove check on interconnect type in ai_setcore
      staging: brcm80211: use local variable for socitype during ai_scan
      staging: brcm80211: remove socitype member for struct si_pub definition
      staging: brcm80211: replace hndcrc16 with crc-ccitt function
      staging: brcm80211: remove unused hndcrc32 function
      staging: brcm80211: remove CRC_INNER_LOOP macro
      staging: brcm80211: move qmath sources to phy directory
      staging: brcm80211: remove unused functions from wlc_phy_qmath.c
      staging: brcm80211: fix perimeter locking in wl_ops_bss_info_changed
      staging: brcm80211: local used function made static
      staging: brcm80211: wlc_aggregatable function prototype moved
      staging: brcm80211: remove unused function from wlc_phy_cmn.c
      staging: brcm80211: use int_sqrt kernel function iso driver implementation
      staging: brcm80211: make use of fls bit operation in wlc_phy_compute_dB
      staging: brcm80211: fix checkpatch issue introduced in wlc_alloc.c
      staging: brcm80211: cleanup unnecessary functions from wlc_ampdu.c
      staging: brcm80211: remove definition of BCMFASTPATH macro
      staging: brcm80211: use print_hex_dump_bytes kernel function
      staging: brcm80211: fix checkpatch issue introduced in dhd_sdio.c
      staging: brcm80211: remove unnecessary functions from wlc_main.c
      staging: brcm80211: remove unused functions and prototypes
      staging: brcm80211: make function definitions and prototype consistent
      staging: brcm80211: cleanup functions in nvram.c
      staging: brcm80211: fix makefiles for building drivers in kernel
      staging: brcm80211: fix checkpatch issue in wlc_channel.c

Chandramouli Narayanan (1):
      intel_sst: fix runtime pm issue

Chihau Chau (1):
      staging: winbond: fixing some code styles issues

Cho, Yu-Chen (12):
      staging/keucr: msscsi use pr_<level> for messages
      staging/keucr: scsiglue use pr_<level> for messages
      staging/keucr: smilmain use pr_<level> for messages
      staging/keucr: transport usb use pr_<level>
      staging/rts_pstor: fix Polling thread wakeups CPU
      staging/keucr: fix keucr ms coding style
      staging/keucr: fix keucr msscsi coding style
      staging/keucr: fix keucr scsiglue coding style
      staging/keucr: fix keucr smilecc.c coding style
      staging/keucr: fix keucr smil.h coding style
      staging/keucr: fix keucr transport coding style
      staging/keucr: fix transport other code style

Clemens Noss (2):
      staging: brcm80211: fix cast to pointer from integer
      staging: brcm80211: use correct pointer types in bcm_pktq_flush

David Chang (1):
      staging: usbip: fix wrong endian conversion

Dharageswari R (1):
      intel_sst: Line out support

Feng Tang (1):
      intel_sst: make sure the sst_drop_stream() get called when needed

Franky Lin (7):
      staging: brcm80211: Add bcmchip.h
      staging: brcm80211: Add dhdsdio_chip_attach in dhd_sdio.c
      staging: brcm80211: Remove siutils dependency of dhdsdio_download_state
      staging: brcm80211: Move sdiod strength init to dhd_sdio.c
      staging: brcm80211: Add dhdsdio_chip_detach in dhd_sdio.c
      staging: brcm80211: Remove siutils dependence from dhd_sdio.c
      staging: brcm80211: Remove si sb utils from brcmfmac

Grant Grundler (2):
      STAGING: brcm80211 v2 keep power on in suspend state
      staging: brcm80211: SDIO/MMC cleanups

Greg Dietsche (1):
      staging: lirc: fixed coding style

Guilherme Salazar (1):
      Staging: brcm80211: fix brace coding style issue in dhd_cdc.c

Haiyang Zhang (8):
      staging: hv: move netvsc_initialize() to clean up forward declaration
      staging: hv: move netvsc_receive_completion() to clean up forward declaration
      staging: hv: move netvsc_send_recv_completion() to clean up forward declaration
      staging: hv: move netvsc_destroy_recv_buf() to clean up forward declaration
      staging: hv: move netvsc_destroy_send_buf() to clean up forward declaration
      staging: hv: move netvsc_device_add() to clean up forward declaration
      staging: hv: clean up unused forward declarations
      staging: hv: convert function name NetVscDisconnectFromVsp to lower case

Hank Janssen (12):
      staging: hv: Remove all unneeded DPRINT from hv_vmbus
      staging: hv: Remove all unneeded DPRINT from hv_netvsc
      staging: hv: Remove all unneeded DPRINT from hv_utils
      staging: hv: Replace DPRINT with natives in hv_vmbus
      staging: hv: replace DPRINT with native primitives in hv_netvsc
      staging: hv: Replaced DPRINT and printk with native functions in hv_utils
      staging: hv: Replaced printk with pr_info in hv_timesource
      staging: hv: change camel case funct names to lower case funct in hv_mouse
      staging: hv: Convert camel case func params to lower case in hv_mouse
      staging: hv: Convert camel case member of struct mousevsc_drv_obj to lower case
      staging: hv: Convert camel case members of struct mousevsc_dev to lower case
      staging: hv: Convert camel case in in all functions to lower case in hv_mouse

Henry Ptasinski (12):
      staging: brcm80211: use common pktq_flush functions
      staging: brcm80211: remove unused cis_hnbuvars
      staging: brcm80211: delete unused sbpcmcia.h file
      staging: brcm80211: move header file
      staging: brcm80211: move files only used by brcmsmac into appropriate dir
      staging: brcm80211: delete unneeded files
      staging: brcm80211: remove unnecessary header file
      staging: brcm80211: remove unneeded include path
      staging: brcm80211: remove unused function
      staging: brcm80211: move another file only used by brcmsmac into appropriate dir
      staging: brcm80211: move functions only used by brcmsmac out of utils
      staging: brcm80211: move utility functions into new module

Ian Abbott (3):
      staging: comedi: adv_pci_dio: Add a counter subdevice to PCI-1751
      staging: comedi: addi-data: Don't overwrite read-only data
      staging: comedi: addi-data: Get rid of redundant ps_BoardInfo

J. Ali Harlow (7):
      comedi vmk80xx: Style improvements
      comedi vmk80xx: make rudimentary_check a static function
      comedi vmk80xx: Digitial I/O should have a maxdata of 1
      comedi vmk80xx: simplify rinsn output calculation
      comedi vmk80xx: extend rudimentary_check to check both directions
      comedi vmk80xx: support bits instruction
      comedi vmk80xx: support comedi auto-configuration

Javier M. Mellid (5):
      staging: rtl8712: fixed coding style issues
      staging: rtl8712: fixed coding style issues
      staging: sm7xx: smtcfb.c: Use the new PCI PM
      staging: sm7xx: minor cleanup
      staging: sm7xx: Use kernel framebuffer mode setting

Jeff Chua (1):
      staging: r8712u: Fix driver to support ad-hoc mode

Joe Perches (5):
      staging: Remove unnecessary semicolons when if (foo) {...};
      staging: Remove unnecessary semicolons when while (foo) {...};
      staging: Remove unnecessary semicolons when for (foo) {...};
      staging: Remove unnecessary semicolons when switch (foo) {...};
      staging: brcm80211: brcmfmac: Fix memset using sizeof(ptr) not sizeof(*ptr)

Jon Brenner (1):
      staging: iio: TAOS tsl258x: Device driver

Jonathan Cameron (112):
      staging:iio:trigger remove export of iio_trigger_find_by_name, use sysfs_streq for matching
      staging:iio: iio_trigger_unregister - remove rather strange search for what we already have.
      staging:iio: replace rip_lots naming with read_first_n
      staging:iio: Add ability to allocate private data space to iio_allocate_device
      staging:iio:adc:max1363 fix timestamp handling.
      staging:iio:adc: max1363 dev_info -> indio_dev in naming for consistency
      staging:iio:max1363 take advantage of new iio_device_allocate private data.
      staging:iio:documentation make read_size signed to allow for errors.
      staging:iio:tsl2563 take advantage of new iio_device_allocate private data.
      staging:iio:light:tsl2563 constify gain level table.
      staging:iio:adis16300 replace unnecessary event line registration.
      staging:iio:adis16350 replace unnecessary event line registration.
      staging:iio:adis16400 replace unnecessary event line registration.
      staging:iio:adis16260 replace unnecessary event line registration.
      staging:iio:adis16203 replace unnecessary event line registration.
      staging:iio:adis16204 replace unnecessary event line registration.
      staging:iio:adis16201 replace unnecessary event line registration.
      staging:iio:adis16240 replace unnecessary event line registration.
      staging:iio:adis16209 replace unnecessary event line registration.
      staging:iio:ade7758 replace unnecessary event line registration.
      staging:iio: allow channels to be set up using a table of iio_channel_spec structures.
      staging:iio:lis3l02dq - move to new channel_spec approach.
      staging:iio:max1363 - move to channel_spec registration.
      staging:iio: remove ability to escalate events.
      staging:iio: Add polling of events on the ring access chrdev.
      staging:iio: remove legacy event chrdev for the buffers
      staging:iio: Buffer device flattening.
      staging:iio:lis3l02dq: General cleanup
      staging:iio: Push interrupt setup down into the drivers for event lines.
      staging:iio: lis3l02dq - separate entirely interrupt handling for thesholds from that for the datardy signal.
      staging:iio:sca3000 extract old event handling and move to poll for events from buffer
      staging:iio:buffering remove unused parameter dead_offset from read_last_n in all buffer implementations.
      staging:iio:light:tsl2563 remove old style event registration.
      staging:iio:dac:ad5504 move from old to new event handling.
      staging:iio:adt7316 get rid of legacy event handling code.
      staging:iio:adc:ad7745 move from old to current event handling.
      staging:iio:adc:ad7816 move from old to current event handling.
      staging:iio:adc:ad7150 move from deprecated event handling plus remove irq as gpio requirement.
      staging:iio:adc:ad7152 remove unregister of interrupt line.
      staging:iio:adc:adt75 old to new event handling conversion
      staging:iio:ad7291 move from old event system to current.
      staging:iio:adc:adt7410 move to current event handling
      staging:iio:adt7310 move to current event handling
      staging:iio:adc:ad7314 remove unmatched unregister of event line.
      staging:iio:adc:ad799x move to new event handling
      staging:iio: Remove legacy event handling.
      staging:iio:accel:lis3l02dq make threshold interrupt threaded.
      staging:iio: Add infrastructure for irq_chip based triggers
      staging:iio:Documentation generic_buffer.c update to new abi for buffers + misc fixes
      staging:iio:ring_sw add function needed for threaded irq.
      staging:iio: add generic data ready poll function.
      staging:iio:accel:lis3l02dq move to threaded trigger handling.
      staging:iio:adc:max1363 move to irqchip based threaded irq triggering
      staging:iio:adc:ad7476 use channel_spec
      staging:iio:adc:ad7476 move to irqchip based triggering
      staging:iio:meter:ade7758 move to irqchip based trigger handling.
      staging:iio:imu:adis16400 move to irq based triggers and channel spec channel registration.
      staging:iio:imu:adis16350 etc support into adis16400 driver.
      staging:iio:imu remove old adis16350. Support now in adis16400 driver.
      staging:iio:imu:adis16400 add support for adis16300
      staging:iio:imu remove adis16300 driver.
      staging:iio:accel:adis16201 move to irqchip based trigger handling.
      staging:iio:accel:adis16203 move to irqchip based trigger handling.
      staging:iio:accel:adis16204 move to irqchip based trigger handling.
      staging:iio:accel:adis16209 move to irqchip based trigger handling.
      staging:iio:accel:adis16240 move to irqchip based trigger handling.
      staging:iio:adc:ad7298 move to irqchip based trigger handling.
      staging:iio:adc:ad7606 conversion to irq_chip based polling.
      staging:iio:adc:ad7887 move to irqchip based trigger handling.
      staging:iio:adc:ad799x move to irqchip based trigger handling.
      staging:iio:gyro:adis16260 move to irqchip based trigger handling.
      staging:iio:trigger remove legacy pollfunc elements.
      staging:iio: Add core attribute handling for name of device.
      staging:iio: use the new central name attribute creation code
      staging:iio:light:tsl2563: chan_spec based channel setup.
      staging:iio:accel:adis16201 move to chan_spec based setup.
      staging:iio:accel:adis16203 move to chan_spec based setup.
      staging:iio:accel:adis16204 move to chan_spec based setup.
      staging:iio:accel:adis16209 move to chan_spec based setup.
      staging:iio:adc:ad799x removed unused headers.
      staging:iio:accel: lis3l02dq add writing for calibscale and calibbias.
      staging:iio: Add chan info support for 'peak_raw' attributes.
      staging:iio:accel:adis16240 move to chan_spec based setup.
      staging:iio:gyro:adis16260 move to chan_spec based setup.
      staging:iio: rip out scan_el attributes. Now handled as iio_dev_attrs like everything else.
      staging:iio:max1363 trivial removal of unused trig pointer.
      staging:iio:max1363 add new 2 channels parts form maxim, 11644-7
      staging:iio:trigger sysfs userspace trigger rework.
      staging:iio:core clean out unused elements.
      staging:iio:adc:ad7150 fix event codes.
      staging:iio:adc:ad7816 and adt75 change to meaningful event code.
      staging:iio:adc:ad7291 remove abuse of buffer events and replace with something almost sane
      staging:iio:adc:adt7310 replace abuse of buffer events.
      staging:iio:adc:adt7410 replace abuse of buffer events.
      staging:iio:addac:adt7316 replace abuse of buffer events.
      staging:iio:buffer - remove unused event code for buffer events.
      staging:iio:lis3l02dq remerge the two interrupt handlers.
      staging:iio: iio_event_interfaces - clean out unused elements
      staging:iio:trigger handle name attr in core, remove old alloc and register any control_attrs via struct device
      staging:iio:imu:adis16400 avoid allocating rx, tx, and state separately from iio_dev.
      staging:iio: rationalization of different buffer implementation hooks.
      staging:iio: Rip out helper for software rings.
      staging:iio:ad7780 trivial unused header cleanup.
      staging:iio: poll func allocation clean up.
      staging:iio:core cleanup: squash tiny wrappers and use dev_set_name to handle creation of event interface name.
      staging:iio: ring core cleanups + check if read_last available in lis3l02dq
      staging:iio:accel:lis3l02dq make write_reg_8 take value not a pointer to value.
      staging:iio: implement an iio_info structure to take some of the constant elements out of iio_dev.
      staging:iio:max1363 misc cleanups and use of for_each_bit_set to simplify event code spitting out.
      staging:iio: use pollfunc allocation helpers in remaining drivers.
      staging:iio:documenation partial update.
      staging:iio: Trivial kconfig reorganization and uniformity improvements.

Jonathan Neuschäfer (1):
      staging: winbond/mto.c: remove unused variables

Julia Lawall (7):
      drivers/staging/brcm80211/brcmfmac/wl_iw.c: introduce missing kfree
      drivers/staging/intel_sst/intel_sst_app_interface.c: introduce missing kfree
      drivers/staging/cx25821/cx25821-video.c: introduce missing kfree
      drivers/staging/vt6656/main_usb.c: Delete unnecessary call to usb_kill_urb
      drivers/staging/ath6kl/os/linux/cfg80211.c: Add missing call to cfg80211_put_bss
      drivers/staging/line6/driver.c: Drop unneeded put functions.
      drivers/staging/cptm1217/clearpad_tm1217.c: Correct call to input_free_device

Justin P. Mattock (1):
      staging: gma500: Remove extra semi-colon.

K. Y. Srinivasan (339):
      Staging: hv: Make vmbus driver a pci driver
      Staging: hv: Cleanup root device handling
      Staging: hv: Cleanup irq management
      Staging: hv: Rename vmbus_driver_context structure
      Staging: hv: Get rid of the forward declaration for vmbus_uevent
      Staging: hv: Get rid of the forward declaration for vmbus_match
      Staging: hv: Get rid of the forward declaration for vmbus_probe
      Staging: hv: Get rid of the forward declaration for vmbus_remove
      Staging: hv: Get rid of the forward declaration for vmbus_shutdown
      Staging: hv: Get rid of the forward declaration for vmbus_device_release
      Staging: hv: Get rid of the forward declaration for vmbus_isr
      Staging: hv: Get rid of the forward declaration for vmbus_show_device_attr
      Staging: hv: Add the inclusion guard for vstorage.h
      Staging: hv: Move the definition of struct storvsc_request_extension
      Staging: hv: Move the definition of struct storvsc_device
      Staging: hv: Cleanup struct storvsc_device
      Staging: hv: Get rid of the include of storvsc.c from blkvsc.c
      Staging: hv: Get rid of dead code in storvsc.c
      Staging: hv: Move the definition of stor_vsc_initialize()
      Staging: hv: Make the function stor_vsc_initialize() static
      Staging: hv: Cleanup the initialization of storvsc driver
      Staging: hv: Move the contents of blkvsc.c to blkvsc_drv.c
      Staging: hv: Get rid of the file blkvsc.c
      Staging: hv: Cleanup initialization of blkvsc driver
      Staging: hv: Move the definition of the function get_stor_device()
      Staging: hv: Move the definition of the function put_stor_device()
      Staging: hv: Move the definition of the function stor_vsc_on_host_reset()
      Staging: hv: Make the function stor_vsc_on_host_reset() static
      Staging: hv: Move the definition of struct storvsc_request_extension
      Staging: hv: Embed struct storvsc_request_extension into hv_storvsc_request
      Staging: hv: Get rid of request_ext_size from struct storvsc_driver_object
      Staging: hv: Add a function to map a hv_driver pointer to storvsc driver
      Staging: hv: Use struct completion in struct storvsc_request_extension
      Staging: hv: Get rid of the type field from struct hv_storvsc_request
      Staging: hv: Get rid of the host field from struct hv_storvsc_request
      Staging: hv: Get rid of the bus field from struct hv_storvsc_request
      Staging: hv: Get rid of the target_id from struct hv_storvsc_request
      Staging: hv: Get rid of lun_id from struct hv_storvsc_request
      Staging: hv: Get rid of the cdb_len from struct hv_storvsc_request
      Staging: hv: Get rid of cdb from struct hv_storvsc_request
      Staging: hv: Get rid of sense_buffer_size from struct hv_storvsc_request
      Staging: hv: Move sense_buffer field
      Staging: hv: Move the context field from struct hv_storvsc_request
      Staging: hv: Move on_io_completion() from struct hv_storvsc_request
      Staging: hv: Get rid of the status field from struct hv_storvsc_request
      Staging: hv: Move the data_buffer field from struct hv_storvsc_request
      Staging: hv: Rename struct storvsc_request_extension
      Staging: hv: Get rid of synch primitive in struct blkvsc_request
      Staging: hv: Properly capture the error state
      Staging: hv: Zero out the request structure on allocation
      Staging: hv: Get rid of the forward declaration of blkvsc_submit_request()
      Staging: hv: Get rid of the forward declaration of blkvsc_check_events()
      Staging: hv: Get rid of the forward declaration of blkvsc_open()
      Staging: hv: Get rid of the forward declaration of blkvsc_getgeo()
      Staging: hv: Get rid of blkvsc_check_events()
      Staging: hv: Get rid of the forward declaration of blkvsc_init_rw()
      Staging: hv: Get rid of the forward declaration of blkvsc_ioctl()
      Staging: hv: Get rid of the forward declaration of blkvsc_cmd_completion()
      Staging: hv: Get rid of the forward declaration of blkvsc_do_flush()
      Staging: hv: Get rid of the forward declaration of blkvsc_cancel_pending_reqs()
      Staging: hv: Get rid of the forward declaration of blkvsc_remove()
      Staging: hv: Get rid of the forward declaration of blkvsc_shutdown()
      Staging: hv: Get rid of the forward declaration for blkvsc_release()
      Staging: hv: Get rid of the forward declaration for blkvsc_do_read_capacity()
      Staging: hv: Get rid of the forward declaration of blkvsc_do_read_capacity16()
      Staging: hv: Get rid of the forward declaration of blkvsc_revalidate_disk()
      Staging: hv: Get rid of the forward declaration for blkvsc_do_inquiry()
      Staging: hv: Get rid of the forward declaration for blkvsc_do_request()
      Staging: hv: Get rid of the forward declaration for blkvsc_do_pending_reqs()
      Staging: hv: Get rid of the forward declaration for blkvsc_request()
      Staging: hv: Move some definitions/declarations to be earlier in the file
      Staging: hv: Move module parameter to earlier in the file
      Staging: hv: Get rid of some dead code in blkvsc_drv.c
      Staging: hv: Enable blkvsc_ioctl()
      Staging: hv: Simplify the code for blkvsc_getgeo()
      Staging: hv: Introduce a common function for issuing commands to the device
      Staging: hv: Get rid of blkvsc_do_read_capacity()
      Staging: hv: Get rid of blkvsc_do_read_capacity16()
      Staging: hv: Get rid of the function blkvsc_do_flush()
      Staging: hv: Get rid of the state media_not_present
      Staging: hv: Get rid of the function blkvsc_revalidate_disk()
      Staging: hv: Simplify blkvsc_init_rw()
      Staging: hv: Get rid of some DPRINT_INFO() statements
      Staging: hv: Get rid of some DPRINT_DBG() calls
      Staging: hv: Cleanup blkvsc_remove()
      Staging: hv: Cleanup storvsc_remove()
      Staging: hv: Get rid of the code to manage removable media
      Staging: hv: Get rid of some DPRINT_ERR() calls
      Staging: hv: Get rid of an unnecessary check in blkvsc_probe()
      Staging: hv: Cleanup blkvsc_open()
      Staging: hv: Fix a jump label (Cleanup) in blkvsc_drv
      Staging: hv: Fix a jump label (Remove) in blkvsc_drv.c
      Staging: hv: Introduce a function to map channel properties onto block device info
      Staging: hv: Get rid of IDE details from blkvsc_drv.c
      Staging: hv: Introduce a function to map a generic driver pointer to a pointer to storvsc_driver_object
      Staging: hv: Get rid of the references to the priv element of struct hv_driver in block driver
      Staging: hv: Get rid of the references to the priv element of struct hv_driver in hv_mouse.c
      Staging: hv: Introduce a function to map a generic driver pointer to a pointer to struct netvsc_driver
      Staging: hv: Get rid of the references to the priv element of struct hv_driver in net driver
      Staging: hv: Get rid of the references to the priv element of struct hv_driver in storvsc_drv.c
      Staging: hv: Cleanup vmbus_match()
      Staging: hv: Get rid of the priv pointer in struct hv_driver
      Staging: hv: vmbus_driver cannot be unloaded; cleanup accordingly
      Staging: hv: Get rid of vmbus_release_unattached_channels() as it is not used
      Staging: hv: Get rid of the drv field in struct hv_device
      Staging: hv: Cleanup error handling in vmbus_child_device_register()
      Staging: hv: Cleanup vmbus_probe() function
      Staging: hv: Properly handle errors in hv_pci_probe()
      Staging: hv: Make hv_pci_dev a static variable
      Staging: hv: Make msg_dpc a stand alone variable
      Staging: hv: Make event_dpc a stand alone variable
      Staging: hv: Get rid of struct hv_bus
      Staging: hv: Add probe function to struct hv_driver
      Staging: hv: Use the probe function in struct hv_driver
      Staging: hv: Add remove() function to struct hv_driver
      Staging: hv: Use the remove() function in struct hv_driver
      Staging: hv: Add shutdown() function to struct hv_driver
      Staging: hv: Use the shutdown() function in struct hv_driver
      Staging: hv: VMBUS is a acpi enumerated device; get irq value from bios
      Staging: hv: Get rid of an unused variable from struct hv_driver
      Staging: hv: Add the necessary dependencies to hyperv Kconfig
      Staging: hv: Get rid of blkvsc_mutex
      Staging: hv: blkvsc_drv: Cleanup spin lock usage
      Staging: hv: blkvsc_drv: Fix some locking issues
      Staging: hv: blkvsc_drv: Rename driver name variable
      Staging: hv: blkvsc_drv: Rename the device type variable
      Staging: hv: Change the name of struct storvsc_driver_object
      Staging: hv: Change the name of blkvsc driver variable
      Staging: hv: Rename variables of type struct storvsc_driver *
      Staging: hv: Rename the function blk_vsc_on_device_add
      Staging: hv: blkvsc_drv: Get rid of the indirection for invoking device_add
      Staging: hv: Rename the function stor_vsc_device_add
      Staging: hv: Rename the function stor_vsc_on_device_remove
      Staging: hv: blkvsc_drv: Get rid of the indirection for removing stor device
      Staging: hv: Rename the function stor_vsc_on_cleanup
      Staging: hv: blkvsc_drv: Get rid of the indirection for invoking cleanup function
      Staging: hv: Rename the function stor_vsc_on_io_request
      Staging: hv: blkvsc_drv: Get rid of the indirection for invoking io request
      Staging: hv: blkvsc_drv: Statically initialize pointers for probe etc
      Staging: hv: blkvsc_drv: Get rid of the calls to storvsc_cleanup
      Staging: hv: Rename the function stor_vsc_get_major_info()
      Staging: hv: Introduce a function to wait to drain outgoing I/O
      Staging: hv: Use the newly introduced I/O drain synch method
      Staging: hv: Cleanup blkvsc_remove()
      Staging: hv: Cleanup blkvsc_shutdown()
      Staging: hv: Rename stor_vsc_channel_init()
      Staging: hv: Rename stor_vsc_on_io_completion
      Staging: hv: Rename stor_vsc_on_receive
      Staging: hv: Rename stor_vsc_on_channel_callback
      Staging: hv: Rename stor_vsc_connect_to_vsp
      Staging: hv: storvsc: Get rid of/change some dated comments
      Staging: hv: storvsc: Get rid of some unnecessary DPRINTS
      Staging: hv: storvsc_drv: Rename g_driver_name
      Staging: hv: storvsc_drv: Rename struct host_device_context
      Staging: hv: storvsc_drv: Rename variables pointing to struct hv_host_device
      Staging: hv: storvsc_drv: Rename the struct hv_device * element of struct hv_host_device
      Staging: hv: storvsc_drv: Rename variables pointing to struct hv_device
      Staging: hv: storvsc_drv: Get rid of some dated comments
      Staging: hv: storvsc_drv: Get rid of some DPRINTS
      Staging: hv: Get rid of the forward declaration for storvsc_device_alloc()
      Staging: hv: Move the function storvsc_merge_bvec() to earlier in the file
      Staging: hv: Get rid of the forward declaration for storvsc_device_configure()
      Staging: hv: Get rid of the forwrd declaration of destroy_bounce_buffer
      Staging: hv: Get rid of the forward declaration for do_bounce_buffer()
      Staging: hv: Get rid of the forward declaration for create_bounce_buffer()
      Staging: hv: Get rid of the forward declaration of copy_from_bounce_buffer()
      Staging: hv: Get rid of the forward declaration for copy_to_bounce_buffer()
      Staging: hv: Get rid of the forward declaration of storvsc_remove()
      Staging: hv: Get rid of the forward declaration of storvsc_get_chs()
      Staging: hv: Rename the function stor_vsc_on_host_reset()
      Staging: hv: Rename stor_vsc_initialize()
      Staging: hv: Move the definition of storvsc_host_reset() to earlier in the file
      Staging: hv: Get rid of the forward declaration for storvsc_host_reset_handler()
      Staging: hv: Move the definition of storvsc_ringbuffer_size to earlier in the file
      Staging: hv: storvsc_drv: Move module parameters to earlier in the file
      Staging: hv: Move the function storvsc_commmand_completion() to earlier in the file
      Staging: hv: Get rid of the forward declaration of storvsc_queuecommand()
      Staging: hv: Get rid of the forward declaration of storvsc_probe()
      Staging: hv: storvsc_drv: Rename the driver variable
      Staging: hv: storvsc_drv: Move the declaration of the driver variable
      Staging: hv: storvsc_drv: Statically initialize probe/remove elements of the driver
      Staging: hv: storvsc_drv: Get rid of unnecessary comments/dead code
      Staging: hv: storvsc_drv: Get rid of the indirection in invoking storvsc_dev_remove()
      Staging: hv: storvsc_drv: Get rid of the indirection in invoking storvsc_dev_add()
      Staging: hv: storvsc_drv: Get rid of the indirection in invoking storvsc_do_io()
      Staging: hv: storvsc_drv: Get rid of the code initializing the dispatch table
      Staging: hv: storvsc_drv: Simplify the code for getting the drive parameters
      Staging: hv: Make the function netvsc_device_add() non static
      Staging: hv: Make netvsc_device_remove non static
      Staging: hv: Get rid of netvsc_cleanup()
      Staging: hv: Make rndis_filte_device_add() non static
      Staging: hv: Make rndis_filter_device_remove() non static
      Staging: hv: Get rid of rndis_filter_cleanup()
      Staging: hv: Get rid of the indirection to invoke rndis_filte_device_add()
      Staging: hv: Get rid of the indirection to invoke netvsc_device_add()
      Staging: hv: Get rid of the indirection in invoking rndis_filter_device_remove()
      Staging: hv: Get rid of the indirection in invoking netvsc_device_remove()
      Staging: hv: netvsc_drv: Get rid of call to cleanup()
      Staging: hv: Get rid of unnecessary code in netvsc.c
      Staging: hv: Get rid of some unnecessary code in rndis_filter.c
      Staging: hv: Get rid of the indirection to invoke mousevsc_on_device_add()
      Staging: hv: Get rid of the indirection to invoke mousevsc_on_device_remove
      Staging: hv: Get rid of the mouse cleanup() function
      Staging: hv: Cleanup mouse_vsc_initialize()
      Staging: hv: Get rid of dev_add from struct hv_driver
      Staging: hv: Get rid of dev_rm from struct hv_driver
      Staging: hv: Cleanup calls to cleanup in storvsc_drv.c
      Staging: hv: Cleanup calls to cleanup() in hv_mouse.c
      Staging: hv: Get rid of cleanup from struct hv_driver
      Staging: hv: netvsc_drv: Rename the variable g_netvsc_drv
      Staging: hv: Move the declaration of the variable netvsc_drv
      Staging: hv: netvsc_drv: Statically initialize probe/remove
      Staging: hv: mouse_vsc: Rename the variable g_mousevsc_drv
      Staging: hv: Move the declaration of the variable mousevsc_drv
      Staging: hv: mousevsc_drv: Statically initialize probe/remove
      Staging: hv: Rename the function ringbuffer_init
      Staging: hv: Rename ringbuffer_cleanup
      Staging: hv: Rename ringbuffer_write
      Staging: hv: Rename ringbuffer_peek
      Staging: hv: Rename ringbuffer_read
      Staging: hv: Rename get_ringbuffer_interrupt_mask
      Staging: hv: Rename dump_ring_info
      Staging: hv: Rename ringbuffer_get_debuginfo
      Staging: hv: Rename all static functions in ring_buffer.c
      Staging: hv: Cleanup comments in ring_buffer.c
      Staging: hv: Get rid of the forward declaration of hv_copyfrom_ringbuffer
      Staging: hv: Get rid of the forward declaration of hv_copyto_ringbuffer()
      Staging: hv: Get rid of the volatile qualifier for a variable in ring_buffer.c
      Staging: hv: Cleanup ring_buffer.h
      Staging: hv: vmbus_drv: Rename the variable gSupportedDeviceClasses
      Staging: hv: vmbus_drv: Rename the variable messageHandler
      Staging: hv: vmbus_drv: Rename the variable messageType
      Staging: hv: vmbus_drv: Rename the variable gChannelMessageTable
      Staging: hv: Use completion abstraction to synchronize in vmbus_channel_msginfo
      Staging: hv: Get rid of some unnecessary state from struct vmbus_msginfo
      Staging: hv: Use completion abstraction in struct netvsc_device
      Staging: hv: Use the completion abstraction in struct rndis_request
      Staging: hv: Get rid of some dead code in channel.c
      Staging: hv: Change Cleanup to cleanup in connection.c
      Staging: hv: Get rid of some dead code in connection.c
      Staging: hv: Get rid of some dead code from hv.c
      Staging: hv: Change Cleanup to cleanup in hv.c
      Staging: hv: Get rid of unnecessary state from struct storvsc_driver
      Staging: hv: blkvsc_drv: Get rid unnecessary DPRINT
      Staging: hv: blkvsc_drv: Get rid of unnecessary code/comments
      Staging: hv: blkvsc_drv: Assign the name directly
      Staging: hv: blkvsc_drv: Move the assignment of driver name
      Staging: hv: blkvsc_drv: Inline the copying of dev_type guid
      Staging: hv: blkvsc_drv: Get rid of the empty function
      Staging: hv: Move the sector size check into blkvsc_drv_init
      Staging: hv: Make blkvsc_drv_init the module init function
      Staging: hv: storvsc_drv: Get rid of some unnecessary DPRINTs
      Staging: hv: storvsc_drv: Compute max_outstanding_req_per_channel where it is needed
      Staging: hv: storvsc_drv: Get rid of max_outstanding_req_per_channel from struct storvsc_driver
      Staging: hv: Add ring_buffer_size to struct storvsc_device_info
      Staging: hv: Use the rinbuffer size info in struct storvsc_device_info
      Staging: hv: storvsc_drv: Get rid of the unnecessary assignment of ring size
      Staging: hv: Get rid of the ring size state from struct storvsc_driver
      Staging: hv: storvsc_drv: Directly assign the driver name
      Staging: hv: storvsc_drv: Move the assignment of name to the hv_driver
      Staging: hv: storvsc_drv: Inline the copying of the dev_type information
      Staging: hv: Now get rid of an empty function storvsc_initialize()
      Staging: hv: Get rid of some unused functions from storvsc_api.h
      Staging: hv: Make storvsc_drv an instance of hv_driver
      Staging: hv: Make blkvsc_drv an instance of struct hv_driver
      Staging: hv: Get rid of struct storvsc_driver
      Staging: hv: mouse_drv: Directly assign the driver name
      Staging: hv: mouse_drv: Move the assignment of name variable
      Staging: hv: mouse_drv: Move the code to copy dev_type information
      Staging: hv: Get rid of an empty function mouse_vsc_initialize()
      Staging: hv: Make mousevsc_drv an instance of struct hv_driver
      Staging: hv: mouse_drv: Get rid of some unused code
      Staging: hv: Create a common header for all hyperv drivers to include
      Staging: hv: Include the newly created header file in all of the relevant hyperv files
      Staging: hv: Add a subset of definitions from vmbus_api.h to hyperv.h
      Staging: hv: Move a subset of definitions from ring_buffer.h to hyperv.h
      Staging: hv: Move the contents of the file version_info.h to hyperv.h
      Staging: hv: Move the contents of vmbus_channel_interface.h to hyperv.h
      Staging: hv: Move the contents of vmbus_packet_format.h to hyperv.h
      Staging: hv: Move the contents of channel_mgmt.h to hyperv.h
      Staging: hv: Move the contents of channel.h to hyperv.h
      Staging: hv: Move the contents of logging.h to hyperv.h
      Staging: hv: Move the contents of vmbus_api.h to hyperv.h
      Staging: hv: Move the contents of vmbus.h to hyperv.h
      Staging: hv: Move the contents of utils.h to hyperv.h
      Staging: hv: Include asm/hyperv.h in hyperv.h
      Staging: hv: vmbus_drv: Create a common header file to build the vmbus driver
      Staging: hv: vmbus_drv: Include the contents of hv_api.h in hyperv_vmbus.h
      Staging: hv: vmbus_drv: Move the content of hv.h to hyperv_vmbus.h
      Staging: hv: vmbus_drv: Move the contents of ring_buffer.h to hyperv_vmbus.h
      Staging: hv: vmbus_drv: Move the contents of vmbus_private.h to vmbus_hyperv.h
      Staging: hv: vmbus_drv: Cleanup hyperv_vmbus.h
      Staging: hv: stor: Create a common header file for storage drivers
      Staging: hv: stor: Move the contents of vstorage.h to hyperv_storage.h
      Staging: hv: Move the contents of storvsc_api.h to hyperv_storage.h
      Staging: hv: netvsc: Create a common header file for network driver
      Staging: hv: netvsc: Include the contents of netvsc_api.h into hyperv_net.h
      Staging: hv: netvsc: Move the contents of netvsc.h to hyperv_net.h
      Staging: hv: netvsc: Move the contents of rndis.h to hyperv_net.h
      Staging: hv: netvsc: Move the contents of rndis_filter.h to hyperv_net.h
      Staging: hv: netvsc: Cleanup hyperv_net.h
      Staging: hv: mouse_drv: Fix a sparse warning
      Staging: hv: blkvsc_drv: Cleanup the blkvsc_drv_exit() function
      Staging: hv: storvsc_drv: Cleanup storvsc_drv_exit() function
      Staging: hv: mousevsc_drv: Cleanup mousevsc_drv_exit() function
      Staging: hv: netvsc_drv: Clean up the netvsc_drv_exit() function
      Staging: hv: netvsc_drv: Get rid of unused state in struct netvsc_driver
      Staging: hv: netvsc_drv: Make the function netvsc_send non-static
      Staging: hv: netvsc_drv: Make the function netvsc_linkstatus_callback() non-static
      Staging: hv: netvsc_drv: Make the function netvsc_recv_callback() non-static
      Staging: hv: netvsc_drv: Make the function rndis_filter_receive() non-static
      Staging: hv: netvsc_drv: Make the function rndis_filter_send() non-static
      Staging: hv: netvsc_drv: Invoke rndis_filter_send() directly
      Staging: hv: netvsc_drv: Invoke netvsc_send() directly
      Staging: hv: netvsc_drv: Invoke netvsc_linkstatus_callback directly
      Staging: hv: netvsc_drv: Directly invoke the function netvsc_recv_callback()
      Staging: hv: netvsc_drv: Directly invoke the function rndis_filter_receive()
      Staging: hv: netvsc_drv: Get rid of unnecessary state in struct netvsc_driver
      Staging: hv: netvsc_drv: Move the definition of struct rndis_filter_packet to hyperv_net.h
      Staging: hv: netvsc_drv: Directly get the size of rndis_filter_packet
      Staging: hv: netvsc_drv: Get rid of an unnecessary assignment in rndis_filter.c
      Staging: hv: netvsc_drv: Get rid of unused state in struct netvsc_driver
      Staging: hv: netvsc_drv: Add ring_size element to struct netvsc_device_info
      Staging: hv: netvsc_drv: Get the ring size information from struct netvsc_device_info
      Staging: hv: netvsc_drv: Get rid of the unnecessary assignment of ring_buf_size
      Staging: hv: netvsc_drv: Get rid of the unnecessary state from struct netvsc_driver
      Staging: hv: netvsc_drv: Make netvsc_drv an instance of struct hv_driver
      Staging: hv: netvsc_drv: Get rid of some unnecessary/dead code from rndis_filter.c
      Staging: hv: netvsc_drv: Get rid of the empty function rndis_filter_init()
      Staging: hv: netvsc_drv: Get rid of the unused function drv_to_netvscdrv()
      Staging: hv: netvsc_drv: Get rid of the used type struct netvsc_driver
      Staging: hv: netvsc_drv: Move the dmi table declaration to earlier in the file
      Staging: hv: netvsc_drv: Change the signature of netvsc_drv_init()
      Staging: hv: netvsc_drv: Move the dmi_check code to netvsc_drv_init()
      Staging: hv: netvsc_drv: Make netvsc_drv_init the module init function
      Staging: hv: netvsc_drv: Make netvsc_drv_exit() the module exit function
      Staging: hv: vmbus_drv: Introduce state in struct vmbus_channel to track util services
      Staging: hv: Re-implement the synchronization for util channels
      Staging: hv: vmbus_drv: Get rid of util synchronixation based on channel counting

Kalle Valo (1):
      staging: ath6kl: provide hardware version to userspace

Karthigan Srinivasan (1):
      Staging: winbond: wb35tx.c: Fixed coding style

Kenji Toyama (12):
      Staging: xgifb: Fixed coding style issues in vb_def.h
      Staging: xgifb: Fixed coding style issues.
      Staging: xgifb: Fixed lots of coding style issues.
      Staging: xgifb: Fixed coding style issues in vb_setmode.h
      Staging: xgifb: Fixed lots of coding style issues.
      Staging: xgifb: Fixed almost all style warnings.
      Staging: xgifb: Removed thousands of warnings.
      Staging: xgifb: Fixed header file.
      Staging: xgifb: Fixed style issues.
      Staging: xgifb: Fixed styles issues.
      Staging: xgifb: Fixed style issues.
      Staging: xgifb: Fixed style issues.

Larry Finger (3):
      staging: rt2860sta and rt2870sta: Remove drivers replaced in net/wireless
      staging: brcm80211: Remove symbol CONFIG_BRCM80211
      staging: vt6655: Fix warnings if CONFIG_PM is not defined

Lu Guanqun (11):
      sst: make register_sst_card more self-contained
      sst: fix compile error
      intel_sst: Set de-bounce time
      intel_sst: Enable recording via HS_MIC
      intel_sst: Enable recording via DMIC
      intel_sst: move jack detection related configs to init time
      intel_sst: return correct output/input device id
      intel_sst: set default output and input device
      intel_sst: add Master Volume
      intel_sst: internal speaker needs setting a GPIO line
      intel_sst: fix output noises when it's not in playback

Luis R. Rodriguez (33):
      ath6kl: s|A_FREE|kfree|g
      ath6kl: remove BMIENABLE_SET define
      ath6kl: propagate error values on ar6000_avail_ev()
      ath6kl: replace do while loop with function helpers on ar6000_avail_ev()
      ath6kl: remove SET_MODULE_OWNER usage
      ath6kl: move setting netdev for non-cf80211 case
      ath6kl: remove Bluetooth PAL code and WMI ACL TX/RX data support
      ath6kl: kill Android specific code
      ath6kl: remove all the wext and super extended private ioctl crap
      ath6kl: remove define ATH_AR6K_11N_SUPPORT
      ath6kl: remove dependency on LINUX and KERNEL_2_6 macros
      ath6kl: remove SEND_EVENT_TO_APP define
      ath6kl: remove USER_KEYS define
      ath6kl: remove unused define NO_SYNC_FLUSH
      ath6kl: remove define HTC_EP_STAT_PROFILING
      ath6kl: remove unused define WLAN_HEADERS
      ath6kl: remove INIT_MODE_DRV_ENABLED define
      ath6kl: use CONFIG_AR600x_SD31_XXX
      ath6kl: use CONFIG_AR600x_WB31_XXX
      ath6kl: use CONFIG_AR600x_SD32_XXX
      ath6kl: remove AR600x_CUSTOM_XXX define
      ath6kl: use CONFIG_ATH6KL_ENABLE_COEXISTENCE
      ath6kl: simplify btcoex parameter programming
      ath6kl: propagate errors on module setup
      ath6kl: remove useless plat_setup_power() calls
      ath6kl: propagate errors on hifEnableFunc() failures
      ath6kl: cleanup allocation and getting of the hif dev
      ath6kl: style cleanup on struct sdio_driver components
      ath6kl: remove completely pointles platform driver
      ath6kl: cleanup and move the ath6kl pm ops to be assigned statically
      ath6kl: rename the pm ops to something more sensible
      ath6kl: remove chatty debug messages on ath6kl driver ops
      ath6kl: remove ar6000_prepare_target() crap

Marc Dietrich (1):
      Staging: initial version of the nvec driver

Marek Belisko (7):
      staging:ft1000: Remove dead code in ft1000_hw.c
      staging: ft1000: Remove unused declaration in ft1000_usb.h.
      staging: ft1000: Remove unused variables in ft1000_info.
      staging: ft1000: Remove unused variable ASICResetNum.
      staging: ft1000: Remove unused variable DSPResetNum.
      staging: ft1000: Remove unused variable CurrentInterruptEnableMask.
      staging: ft1000: Removed unused variable InterruptsEnabled.

Mark Allyn (1):
      staging: sep: resolve issue with false zero length of page

Michael Hennerich (36):
      staging: IIO: ADC: New driver for the AD7780 / AD7781 24-bit Sigma-Delta ADC
      staging: IIO: DAC: New driver for the AD5504 and AD55041 High Voltage DACs
      IIO: GYRO: Add MACRO for gyro quadrature correction
      IIO: Documentation: Add ABI documentatio for gyro quadrature correction
      IIO: GYRO: IIO driver for Analog Devices Digital Output Gyroscope ADXRS450
      staging: IIO: DAC: New driver for AD5791/AD5781 High Resolution Voltage Output DACs
      staging: IIO: DAC: AD5446 add support for AD5541A devices
      IIO: DAC: AD5791: Add support for the AD5760/AD5780 High Resolution DACs
      IIO: DDS: AD9834: Add support for AD9837 and AD9838 DDS devices
      IIO: GYRO: ADXRS450: Don't issue two messages, use two transfers
      IIO: GYRO: ADXRS450: Cleanup result extraction and update license notice
      IIO: GYRO: ADXRS450: Add missing parity bit generation
      IIO: GYRO: ADXRS450: enforce sequential transfer delay of at least 0.1ms
      IIO: GYRO: ADXRS450: Fix sign issues, properly shift results and limit values
      IIO: GYRO: ADXRS450: Don't exit probe, in case the power on default is not met.
      iio: trigger: iio-trig-bfin-timer: select missing dependency
      iio: adc: ad7780: Add missing GPIOLIB dependency
      staging:iio:adc:ad7887: Convert to new channel registration method.
      staging:iio:adc:ad7887: Use private data space from iio_allocate_device
      staging:iio:adc:ad799x: Convert to new channel registration method.
      staging:iio:adc:ad799x: Use private data space from iio_allocate_device
      staging:iio:adc:ad7298: Convert to new channel registration method
      staging:iio:adc:ad7606 Convert to new channel registration method Update Add missing call to iio_trigger_notify_done() Set pollfunc top and bottom half handler
      staging:iio:adc:ad7606: Use private data space from iio_allocate_device
      staging:iio: Add channel types IIO_CURRENT and IIO_POWER.
      staging:iio:meter:ade7758: Update trigger to the new API
      staging:iio:meter:ade7758: Fix timing on SPI read accessor functions.
      staging:iio:meter:ade7758: Fix return value of ade7758_write_reset
      staging:iio:meter:ade7758: Fix list and set of available sample frequencies.
      staging:iio:meter:ade7758: Use iio channel spec and miscellaneous other changes.
      staging:iio:adc:AD7298: Use private data space from iio_allocate_device
      staging:iio:adc: AD7606: Consitently use indio_dev
      staging:iio:adc: AD7606: Drop dev_data in favour of iio_priv()
      staging:iio:adc:AD7780: Convert to new channel registration method
      staging:iio:adc: AD7780: Use private data space from iio_allocate_device + trivial fixes
      staging:iio:meter:ade7758: Use private data space from iio_allocate_device

Michał Mirosław (2):
      Staging: convert hv network driver to hw_features
      staging: octeon-ethernet: remove .get_sg, etc. ethtool_ops

Naveen Singh (9):
      staging:ath6kl:Correcting the typo
      ath6kl: add support for AR6003 v2.1.1
      ath6kl: Extend WMI API used by AR6003 v2.1.1
      ath6kl: add the device ID on the data command packet
      ath6kl: fix scan operation while disconnect
      ath6kl: fix operations for power management
      staging: ath6kl: cfg80211_roam issue; driver wedge
      staging: ath6kl: open/shared auth implementation
      ath6kl: iw dev wlan0 link implementation

Nicolas Kaiser (1):
      staging: crystalhd: remove unused typedef bc_bool_t

Olaf Hering (4):
      hv: Reduce indention in vmbus_on_event
      hv: pass u32 to process_chn_event()
      hv: pass integer to tasklet_init()
      hv: make vmbus_loglevel writeable

Oren Weil (10):
      staging/mei: MEI Driver documentations
      staging/mei: MEI Driver TODO list
      staging/mei: PCI device and char driver support.
      staging/mei: Interrupt handling.
      staging/mei: MEI link layer
      staging/mei: MEI driver init flow.
      staging/mei: Hardware and MEI driver internal struct definition
      staging/mei: mei.h defining user space interface
      staging/mei: AMT Watchdog
      staging/mei: add mei to staging Kbuild

Peter Huewe (1):
      staging/brcm80211: Fix common spelling mistakes

Rahul Tank (1):
      staging: echo: Trivial indentation changes

Ramesh Babu K V (1):
      intel_sst: rework jack implementation

Randy Dunlap (4):
      staging/keucr: fix sparse statics and non-ANSI function warnings
      staging/keucr: eliminate sparse warnings in ms.c
      staging/keucr: don't use SUCCESS as macro name
      staging: fix mei build when PM is not enabled

Roland Vossen (57):
      staging: brcm80211: code cleanup
      staging: brcm80211: deleted inactive BCMDBG_FORCEHT code
      staging: brcm80211: changed comment on rx buffer len in wlc_ampdu.c
      staging: brcm80211: Removed invalid comment in receive processing.
      staging: brcm80211: deleted unused code in hndpmu.c
      staging: brcm80211: unified README files
      staging: brcm80211: moved several README items to website
      staging: brcm80211: revised README
      staging: brcm80211: cleaned up TODO file
      staging: brcm80211: cleanup of WMM related functions
      staging: brcm80211: made overlapping WMM functions more similar
      staging: brcm80211: removed duplicate WMM code
      staging: brcm80211: removed ASSERTs in LCN phy code
      staging: brcm80211: ASSERT cleanup in phy
      staging: brcm80211: removed static ASSERTs
      staging: brcm80211: removed unused error codes
      staging: brcm80211: replaced BCME_OK by 0
      staging: brcm80211: bugfix for div by zero in minstrel_ht_tx_status
      modules: Enabled dynamic debugging for staging modules
      staging: brcm80211: fixed error in non-DHD_DEBUG fullmac build
      staging: brcm80211: made error codes in bcmutils.h positive
      staging: brcm80211: bugfix for fullmac return codes
      staging: brcm80211: removed WL_NONE
      staging: brcm80211: making wiphy object accessible from wlc and phy
      staging: brcm80211: replaced WL_ERROR in two files.
      staging: brcm80211: replaced WL_ERROR in wlc_ampdu.c
      staging: brcm80211: replaced WL_ERROR in wlc_bmac.c
      staging: brcm80211: replaced WL_ERROR in wlc_main.c
      staging: brcm80211: replaced WL_ERROR in rest of softmac.
      staging: brcm80211: removed ASSERTs from wlc_main.c
      staging: brcm80211: removed ASSERTs from wlc_ampdu.c
      staging: brcm80211: removed ASSERTs from wlc_bmac.c
      staging: brcm80211: removed error string function
      staging: brcm80211: replace error codes part 1
      staging: brcm80211: replace error codes part 2
      staging: brcm80211: made fullmac error codes more consistent
      staging: brcm80211: removed ASSERTs from util dir, part 1
      staging: brcm80211: removed ASSERTs from util dir, part 2
      staging: brcm80211: delete ASSERTs in 4 files in brcmsmac dir
      staging: brcm80211: removed all ASSERTs from wl_mac80211.c
      staging: brcm80211: removed all ASSERTs from wlc_ampdu.c
      staging: brcm80211: removed remaining ASSERTs from phy
      staging: brcm80211: removed ASSERTs from aiutils.c
      staging: brcm80211: removed ASSERTs from wlc_pmu.c
      staging: brcm80211: moved ASSERT logic to fullmac driver
      staging: brcm80211: replaced WL_TRACE by BCMMSG
      staging: brcm80211: replaced WL_AMPDU_* with BCMMSG
      staging: brcm80211: got rid of WL_FFPLD message log macro
      staging: brcm80211: removed function wlc_calloc()
      staging: brcm80211: replaced IL_BIGENDIAN by __BIG_ENDIAN
      staging: brcm80211: got rid of #ifdef __mips__ by new dma_spin_for_len()
      staging: brcm80211: removed unused struct net_device_stats related code
      staging: brcm80211: removed counter related macros that expanded to NOP
      staging: brcm80211: removed stats WEXT support from fullmac
      staging: brcm80211: removed support for proprietary ioctl WLC_GET_PKTCNTS
      staging: brcm80211: removed counter related struct wl_cnt
      staging: brcm80211: removed more unused counter related structures

Sitanshu Nanavati (1):
      intel_sst: DMIC routing

Stanislav Fomichev (8):
      brcm80211: replace VENDOR_BROADCOM with PCI_VENDOR_ID_BROADCOM
      brcm80211: remove unused defines in bcmdevs.h
      brcm80211: remove unused defines in pcicfg.h
      brcm80211: use native PCI register offsets
      brcm80211: use native PCI capability defines
      brcm80211: use native PCI header defines
      brcm80211: remove unused struct ppb_config_regs
      brcm80211: update PCI config space define

Stefan Brähler (1):
      staging: olpc_dcon: fix space and coding issues

Stephane Pajot (1):
      Staging: comedi: fix brace coding style issue in jr3_pci.c

Sukesh Srikakula (14):
      staging: brcm80211: Fix for WPA GTK install issue in brcmfmac driver
      staging: brcm80211: Fix for suspend issue in brcmfmac driver
      staging: brcm80211: brcmfmac driver's interface name changed to "wlan"
      staging: brcm80211: Fixed wl_assoc_params structure miss match in brcmfmac driver
      staging: brcm80211: Optimized wl_inform_single_bss function in brcmfmac driver
      staging: brcm80211: Fixed bss (re)connect/disconnect issues in brcmfmac driver
      staging: brcm80211: Fixed ibss join/leave functionality in brcmfmac driver
      staging: brcm80211: Added support to change roaming parameters from brcmfmac driver
      staging: brcm80211: Added support to change scan times from brcmfmac driver
      staging: brcm80211: Fixed scan notification functionality in brcmfmac driver
      staging: brcm80211: Removed unused variable from brcmfmac driver
      staging: brcm80211: cfg80211 up/down routines in brcmfmac driver are fixed
      staging: brcm80211: Better debug support added to brcmfmac driver
      staging: brcm80211: Corrected sdpcm_shared_t structure definition

Takahiro Hirofuchi (1):
      staging: usbip: add userspace code

Tomas Winkler (7):
      staging/easycap: revamp reset function
      staging/easycap: easycap_probe : rename usb variables to common names
      staging/easycap: easycap_probe: take out duplicated code from ifdef - else
      staging/easycap: easycap_probe: drop unuzed variables
      staging/easycap: easycap_probe: drop verbose printouts
      staging/easycap: probe: simplify the endpoints tests
      staging/easycap: easycap_probe: drop more unused variables

Uwe Kleine-König (1):
      staging/comedi: remove German in-file changelog

Vasanthakumar Thiagarajan (19):
      ath6kl: Remove unused analog_register header files
      ath6kl: Remove duplicate abp_map.h
      ath6kl: Remove duplicate mbox_host_reg.h
      ath6kl: Remove duplicate mbox_wlan_reg.h
      ath6kl: Remove duplicate rtc_reg.h
      ath6kl: Remove duplicate si_reg.h
      ath6kl: Remove unused hw2.0/hw/uart_reg.h
      ath6kl: Remove unused bb_lc_reg.h
      ath6kl: Remove unused hw4.0/hw/vmc_reg.h
      ath6kl: Remove somemore unused header files from hw4.0/hw/
      ath6kl: Remove unused regdump.h
      ath6kl: Remove unused macros from gpio_reg.h
      ath6kl: Replace data type macros with kernel defined ones
      ath6kl: Remove few more unused header files
      ath6kl: Remove somemore unused header files
      ath6kl: Remove dead code with CONFIG_AR6002_REV1_FORCE_HOST
      ath6kl: Remove unused eeprom.c
      ath6kl: Remove gpio.h and gpio_api.h
      ath6kl: Remove ununsed macros from gpio_reg.h

Vasiliy Kulikov (1):
      staging: istallion: fix arbitrary kernel memory reads/writes

Vinod Koul (5):
      intel_sst: Save audio state across D3 on Medfield
      intel_sst: MSIC codec power optimisation
      intel_sst: fix unload bugs
      intel_sst: ignore IRQ when suspended
      intel_sst: parameter tuning ioctl

Weiping Pan(潘卫平) (1):
      staging: comedi: fix a typo

Wu Fengguang (2):
      intel_sst: MRST can only do mono recording
      intel_sst: MRST can only do 16bit recording

anish kumar (3):
      Staging: sm7xx: removing extra white spaces,redundant code and using macros
      Staging: sm7xx: preferred form for passing a size to memory allocation routines
      Staging: sm7xx: printk loglevels modified to match the scenario

matt mooney (37):
      staging: usbip: stub_dev.c: coding style cleanup
      staging: usbip: stub_main.c: coding style cleanup
      staging: usbip: stub_rx.c: coding style cleanup
      staging: usbip: stub_tx.c: coding style cleanup
      staging: usbip: usbip_common.h: coding style cleanup
      staging: usbip: usbip_common.c: coding style cleanup
      staging: usbip: usbip_event.c: coding style cleanup
      staging: usbip: stub.h: coding style cleanup
      staging: usbip: vhci.h: coding style cleanup
      staging: usbip: vhci_hcd.c: coding style cleanup
      staging: usbip: vhci_rx.c: coding style cleanup
      staging: usbip: vhci_sysfs.c: coding style cleanup
      staging: usbip: vhci_tx.c: coding style cleanup
      staging: usbip: add break to default case in switch statements
      staging: usbip: remove section dividers
      staging: usbip: fixup MODULE_ macros
      staging: usbip: change debug configuration option
      staging: usbip: use single version for all modules
      staging: usbip: stub.h: reorganize
      staging: usbip: vhci.h: reorganize
      staging: usbip: fix header includes
      staging: usbip: edit Kconfig and rename CONFIG options
      staging: usbip: userspace: move manpages to separate directory
      staging: usbip: userspace: rename source directories
      staging: usbip: userspace: remove unused files
      staging: usbip: userspace: whitespace cleanup
      staging: usbip: userspace: update module name references
      staging: usbip: userspace: configure.ac: major overhaul
      staging: usbip: userspace: cleanup makefiles
      staging: usbip: userspace: set libusbip version in configure.ac
      staging: usbip: userspace: remove revision $Id$
      staging: usbip: userspace: remove gcc warnings
      staging: usbip: userspace: move common cflags to configure.ac
      staging: usbip: userspace: modify project gcc flags
      staging: usbip: userspace: stub_driver.c: update kernel module name
      staging: usbip: userspace: bind-driver.c: mark remote_host as unused
      staging: usbip: replace usbip_u{dbg,err,info} and printk with dev_ and pr_

pefoley2@verizon.net (1):
      staging: hv: make HYPERV_UTILS depend on NLS to prevent a build error

wwang (1):
      staging: rts_pstor: clear error when read sd lba0 fail

xingchao (1):
      intel_sst: Headphone Automute support

