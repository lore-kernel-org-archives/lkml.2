Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab1HKFzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 01:55:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53076 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1HKFzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 01:55:39 -0400
Date: Thu, 11 Aug 2011 15:55:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Raja Mani <rmani@qca.qualcomm.com>
Subject: linux-next: build failure after merge of the final tree (wireless &
 staging trees related)
Message-Id: <20110811155529.e5f47afa0504c4ddef58ab37@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Aug_2011_15_55_29_+1000_SSJ48rtBGGjVaYX1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Aug_2011_15_55_29_+1000_SSJ48rtBGGjVaYX1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/built-in.o: In function `aggr_recv_delba_req_evt':
(.opd+0x23a60): multiple definition of `aggr_recv_delba_req_evt'
drivers/net/built-in.o:(.opd+0x79980): first defined here
drivers/staging/built-in.o: In function `.wlan_node_reclaim':
(.text+0x303360): multiple definition of `.wlan_node_reclaim'
drivers/net/built-in.o:(.text+0xdd0618): first defined here
drivers/staging/built-in.o: In function `aggr_init':
(.opd+0x23a00): multiple definition of `aggr_init'
drivers/net/built-in.o:(.opd+0x79968): first defined here
drivers/staging/built-in.o: In function `.aggr_recv_delba_req_evt':
(.text+0x302614): multiple definition of `.aggr_recv_delba_req_evt'
drivers/net/built-in.o:(.text+0xdc8b60): first defined here
drivers/staging/built-in.o: In function `.wlan_node_table_cleanup':
(.text+0x303888): multiple definition of `.wlan_node_table_cleanup'
drivers/net/built-in.o:(.text+0xdd0a6c): first defined here

You get the idea. :-(  So, the ath6kl driver now exists in the wireless
tree and the staging tree.

I applied this patch for today (I have elided the part from "rm -rf
drivers/staging/ath6kl"):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 11 Aug 2011 15:49:40 +1000
Subject: [PATCH] staging: remove the ath6kl driver

since it is now in the main tree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/ath6kl/Kconfig                     |  158 -
 drivers/staging/ath6kl/Makefile                    |  122 -
 drivers/staging/ath6kl/TODO                        |   25 -
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |   54 -
 drivers/staging/ath6kl/bmi/src/bmi.c               | 1010 ---
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |   87 -
 .../hif/sdio/linux_sdio/include/hif_internal.h     |  131 -
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   | 1273 ----
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |  393 --
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          | 1479 -----
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  401 --
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |  783 ---
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |  755 ---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        | 1284 ----
 drivers/staging/ath6kl/htc2/htc.c                  |  575 --
 drivers/staging/ath6kl/htc2/htc_debug.h            |   38 -
 drivers/staging/ath6kl/htc2/htc_internal.h         |  211 -
 drivers/staging/ath6kl/htc2/htc_recv.c             | 1572 -----
 drivers/staging/ath6kl/htc2/htc_send.c             | 1018 ---
 drivers/staging/ath6kl/htc2/htc_services.c         |  450 --
 drivers/staging/ath6kl/include/a_config.h          |   31 -
 drivers/staging/ath6kl/include/a_debug.h           |  195 -
 drivers/staging/ath6kl/include/a_drv.h             |   32 -
 drivers/staging/ath6kl/include/a_drv_api.h         |  204 -
 drivers/staging/ath6kl/include/a_osapi.h           |   32 -
 drivers/staging/ath6kl/include/aggr_recv_api.h     |  140 -
 drivers/staging/ath6kl/include/ar3kconfig.h        |   65 -
 drivers/staging/ath6kl/include/ar6000_api.h        |   32 -
 drivers/staging/ath6kl/include/ar6000_diag.h       |   48 -
 drivers/staging/ath6kl/include/ar6kap_common.h     |   44 -
 drivers/staging/ath6kl/include/athbtfilter.h       |  135 -
 drivers/staging/ath6kl/include/bmi.h               |  134 -
 .../ath6kl/include/common/AR6002/AR6K_version.h    |   52 -
 .../staging/ath6kl/include/common/AR6002/addrs.h   |   90 -
 .../common/AR6002/hw4.0/hw/apb_athr_wlan_map.h     |   40 -
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |   40 -
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   24 -
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |  552 --
 .../common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h    |  471 --
 .../include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h |  589 --
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |  187 -
 .../include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h  |  162 -
 .../include/common/AR6002/hw4.0/hw/uart_reg.h      |   40 -
 drivers/staging/ath6kl/include/common/athdefs.h    |   75 -
 drivers/staging/ath6kl/include/common/bmi_msg.h    |  233 -
 drivers/staging/ath6kl/include/common/cnxmgmt.h    |   36 -
 drivers/staging/ath6kl/include/common/dbglog.h     |  126 -
 drivers/staging/ath6kl/include/common/dbglog_id.h  |  558 --
 drivers/staging/ath6kl/include/common/discovery.h  |   75 -
 .../staging/ath6kl/include/common/epping_test.h    |  111 -
 drivers/staging/ath6kl/include/common/gmboxif.h    |   70 -
 drivers/staging/ath6kl/include/common/gpio_reg.h   |    9 -
 drivers/staging/ath6kl/include/common/htc.h        |  227 -
 .../staging/ath6kl/include/common/htc_services.h   |   52 -
 drivers/staging/ath6kl/include/common/pkt_log.h    |   45 -
 drivers/staging/ath6kl/include/common/roaming.h    |   41 -
 drivers/staging/ath6kl/include/common/targaddrs.h  |  395 --
 drivers/staging/ath6kl/include/common/testcmd.h    |  185 -
 drivers/staging/ath6kl/include/common/tlpm.h       |   38 -
 drivers/staging/ath6kl/include/common/wlan_defs.h  |   79 -
 drivers/staging/ath6kl/include/common/wmi.h        | 3220 ----------
 drivers/staging/ath6kl/include/common/wmix.h       |  271 -
 drivers/staging/ath6kl/include/common_drv.h        |  104 -
 drivers/staging/ath6kl/include/dbglog_api.h        |   52 -
 drivers/staging/ath6kl/include/dl_list.h           |  153 -
 drivers/staging/ath6kl/include/dset_api.h          |   65 -
 drivers/staging/ath6kl/include/hci_transport_api.h |  259 -
 drivers/staging/ath6kl/include/hif.h               |  456 --
 drivers/staging/ath6kl/include/host_version.h      |   52 -
 drivers/staging/ath6kl/include/htc_api.h           |  575 --
 drivers/staging/ath6kl/include/htc_packet.h        |  227 -
 drivers/staging/ath6kl/include/wlan_api.h          |  128 -
 drivers/staging/ath6kl/include/wmi_api.h           |  441 --
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |  565 --
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |  572 --
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |   75 -
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |  969 ---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |  113 -
 drivers/staging/ath6kl/miscdrv/common_drv.c        |  910 ---
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |  417 --
 drivers/staging/ath6kl/miscdrv/miscdrv.h           |   42 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       | 6267 ----------------=
---
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |  626 --
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  455 --
 drivers/staging/ath6kl/os/linux/cfg80211.c         | 1892 ------
 .../staging/ath6kl/os/linux/export_hci_transport.c |  124 -
 drivers/staging/ath6kl/os/linux/hci_bridge.c       | 1141 ----
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  776 ---
 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h |   36 -
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |  190 -
 .../staging/ath6kl/os/linux/include/athdrv_linux.h | 1217 ----
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   61 -
 .../staging/ath6kl/os/linux/include/config_linux.h |   51 -
 .../staging/ath6kl/os/linux/include/debug_linux.h  |   50 -
 .../ath6kl/os/linux/include/export_hci_transport.h |   76 -
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |  177 -
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |  339 -
 .../staging/ath6kl/os/linux/include/wlan_config.h  |  108 -
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |  300 -
 drivers/staging/ath6kl/os/linux/netbuf.c           |  231 -
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |  117 -
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |  661 --
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |  397 --
 .../staging/ath6kl/wlan/include/ieee80211_node.h   |   93 -
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |  636 --
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |  199 -
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |   58 -
 drivers/staging/ath6kl/wmi/wmi.c                   | 6444 ----------------=
----
 drivers/staging/ath6kl/wmi/wmi_host.h              |  102 -
 111 files changed, 0 insertions(+), 50006 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/Kconfig
 delete mode 100644 drivers/staging/ath6kl/Makefile
 delete mode 100644 drivers/staging/ath6kl/TODO
 delete mode 100644 drivers/staging/ath6kl/bmi/include/bmi_internal.h
 delete mode 100644 drivers/staging/ath6kl/bmi/src/bmi.c
 delete mode 100644 drivers/staging/ath6kl/hif/common/hif_sdio_common.h
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_=
internal.h
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
 delete mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scat=
ter.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.h
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
 delete mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_debug.h
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_internal.h
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_recv.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_send.c
 delete mode 100644 drivers/staging/ath6kl/htc2/htc_services.c
 delete mode 100644 drivers/staging/ath6kl/include/a_config.h
 delete mode 100644 drivers/staging/ath6kl/include/a_debug.h
 delete mode 100644 drivers/staging/ath6kl/include/a_drv.h
 delete mode 100644 drivers/staging/ath6kl/include/a_drv_api.h
 delete mode 100644 drivers/staging/ath6kl/include/a_osapi.h
 delete mode 100644 drivers/staging/ath6kl/include/aggr_recv_api.h
 delete mode 100644 drivers/staging/ath6kl/include/ar3kconfig.h
 delete mode 100644 drivers/staging/ath6kl/include/ar6000_api.h
 delete mode 100644 drivers/staging/ath6kl/include/ar6000_diag.h
 delete mode 100644 drivers/staging/ath6kl/include/ar6kap_common.h
 delete mode 100644 drivers/staging/ath6kl/include/athbtfilter.h
 delete mode 100644 drivers/staging/ath6kl/include/bmi.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6K_versi=
on.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/addrs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/a=
pb_athr_wlan_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/a=
pb_map.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/m=
box_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/m=
box_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/m=
box_wlan_host_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/m=
box_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/r=
tc_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/r=
tc_wlan_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/u=
art_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/athdefs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/bmi_msg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/cnxmgmt.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dbglog.h
 delete mode 100644 drivers/staging/ath6kl/include/common/dbglog_id.h
 delete mode 100644 drivers/staging/ath6kl/include/common/discovery.h
 delete mode 100644 drivers/staging/ath6kl/include/common/epping_test.h
 delete mode 100644 drivers/staging/ath6kl/include/common/gmboxif.h
 delete mode 100644 drivers/staging/ath6kl/include/common/gpio_reg.h
 delete mode 100644 drivers/staging/ath6kl/include/common/htc.h
 delete mode 100644 drivers/staging/ath6kl/include/common/htc_services.h
 delete mode 100644 drivers/staging/ath6kl/include/common/pkt_log.h
 delete mode 100644 drivers/staging/ath6kl/include/common/roaming.h
 delete mode 100644 drivers/staging/ath6kl/include/common/targaddrs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/testcmd.h
 delete mode 100644 drivers/staging/ath6kl/include/common/tlpm.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wlan_defs.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmi.h
 delete mode 100644 drivers/staging/ath6kl/include/common/wmix.h
 delete mode 100644 drivers/staging/ath6kl/include/common_drv.h
 delete mode 100644 drivers/staging/ath6kl/include/dbglog_api.h
 delete mode 100644 drivers/staging/ath6kl/include/dl_list.h
 delete mode 100644 drivers/staging/ath6kl/include/dset_api.h
 delete mode 100644 drivers/staging/ath6kl/include/hci_transport_api.h
 delete mode 100644 drivers/staging/ath6kl/include/hif.h
 delete mode 100644 drivers/staging/ath6kl/include/host_version.h
 delete mode 100644 drivers/staging/ath6kl/include/htc_api.h
 delete mode 100644 drivers/staging/ath6kl/include/htc_packet.h
 delete mode 100644 drivers/staging/ath6kl/include/wlan_api.h
 delete mode 100644 drivers/staging/ath6kl/include/wmi_api.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kconfig.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
 delete mode 100644 drivers/staging/ath6kl/miscdrv/common_drv.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/credit_dist.c
 delete mode 100644 drivers/staging/ath6kl/miscdrv/miscdrv.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_drv.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_pm.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/cfg80211.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/export_hci_transport.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/hci_bridge.c
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/cfg80211.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/config_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/debug_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/export_hci_tran=
sport.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl=
.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/osapi_linux.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/wlan_config.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/include/wmi_filter_linu=
x.h
 delete mode 100644 drivers/staging/ath6kl/os/linux/netbuf.c
 delete mode 100644 drivers/staging/ath6kl/reorder/aggr_rx_internal.h
 delete mode 100644 drivers/staging/ath6kl/reorder/rcv_aggr.c
 delete mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211.h
 delete mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211_node.h
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_node.c
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
 delete mode 100644 drivers/staging/ath6kl/wlan/src/wlan_utils.c
 delete mode 100644 drivers/staging/ath6kl/wmi/wmi.c
 delete mode 100644 drivers/staging/ath6kl/wmi/wmi_host.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 06c9081..d497a93 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -126,8 +126,6 @@ source "drivers/staging/quickstart/Kconfig"
=20
 source "drivers/staging/sbe-2t3e3/Kconfig"
=20
-source "drivers/staging/ath6kl/Kconfig"
-
 source "drivers/staging/keucr/Kconfig"
=20
 source "drivers/staging/bcm/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index f3c5e33..fe6c611 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -54,7 +54,6 @@ obj-$(CONFIG_SOLO6X10)		+=3D solo6x10/
 obj-$(CONFIG_TIDSPBRIDGE)	+=3D tidspbridge/
 obj-$(CONFIG_ACPI_QUICKSTART)	+=3D quickstart/
 obj-$(CONFIG_SBE_2T3E3)		+=3D sbe-2t3e3/
-obj-$(CONFIG_ATH6K_LEGACY)	+=3D ath6kl/
 obj-$(CONFIG_USB_ENESTORAGE)	+=3D keucr/
 obj-$(CONFIG_BCM_WIMAX)		+=3D bcm/
 obj-$(CONFIG_FT1000)		+=3D ft1000/
--=20
1.7.5.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Aug_2011_15_55_29_+1000_SSJ48rtBGGjVaYX1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOQ27RAAoJEDMEi1NhKgbsW+EH/1RVgUU02RbNw/tJaSL2CRUj
BMj3ciMhBZOd0MPGYauPYtqDu2hx6wt1qVSCZAH2fv1gkRjrqkKsQrGz9+lU7v7H
JecHp+xI4dPIeKiqKRfYnMW5tUpS3MbTQkFKYaxEhCM0YC6wDnegL2PE4/+lUXB3
KzwWmyKClvRuuNlCtYW+BtkRa3HRX5iZb6gxuhoRSN9URaUzR2Q6zSHUjakaHu8M
EnDfjNwelrlTSth9WNIYfdS1E6KecpIYuupEjYy1XqPiZOLcBfBgFDugp3BF5gZm
+DT9QvUUYLl37gDm1Mn7L6rUt8J9NWbvsIqBhRyFyHPIEYwlLFuomFCv69qhoRQ=
=hWpx
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Aug_2011_15_55_29_+1000_SSJ48rtBGGjVaYX1--
