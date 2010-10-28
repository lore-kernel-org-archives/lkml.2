Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab0J1RVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:21:07 -0400
Received: from kroah.org ([198.145.64.141]:40874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942Ab0J1RVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:21:03 -0400
Date: Thu, 28 Oct 2010 10:20:56 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] STAGING merge for .37-rc
Message-ID: <20101028172056.GA399@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the big staging tree merge for the .37 tree.  I waited till the
end of the window to handle merges from other trees happening so as to
get everything properly in sync here.

It's a big one this time around:
	1363 files changed, 421106 insertions(+), 148539 deletions(-)

With a number of new drivers being added:
	- ath6kl wireless driver
	- broadcom wireless driver
	- another wimax driver
	- rtl8712 wireless driver
	- a number of iio drivers
	- intel_sst
	- keucr usb-storage driver
	- olpc_dcon
	- sbe-2t3e3 HDLC network driver
	- speakup core and drivers
	- westbridge drivers (embedded usb controller)

Some drivers/filesystems moved to the staging tree to slowly be removed
from the tree for various reasons:
	- autofs
	- smbfs
And some drivers moving out of the staging tree as they are now "proper"
drivers:
	- ti-st

And some drivers removed as they are obsolete or abandonded:
	- otus wireless
	- rtl8192su wireless

And of course, there's lots of development with the rest of the drivers
in the staging tree.

There are a number of places where patches touch files outside of the
drivers/staging/ directory, but for every one of them, the proper
subsystem maintainer has given their ACK for them.

The full diffstat and changelog is below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees for a long
time.

Due to the large number of patches, and the size of some of them, I'm
not going to send them to the driver-devel list as I get complaints
every time I do that...

thanks,

greg k-h

--------------

 Documentation/ABI/testing/sysfs-block-zram         |   99 +
 Documentation/filesystems/00-INDEX                 |    2 -
 Documentation/ioctl/ioctl-number.txt               |    2 +-
 MAINTAINERS                                        |   14 +-
 arch/arm/mach-omap2/Makefile                       |    4 +
 arch/arm/mach-omap2/dsp.c                          |   85 +
 arch/arm/plat-omap/common.c                        |    2 +
 arch/arm/plat-omap/devices.c                       |   70 +
 arch/arm/plat-omap/include/plat/dsp.h              |   31 +
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/ti-st/Kconfig                         |   17 +
 drivers/misc/ti-st/Makefile                        |    6 +
 drivers/{staging => misc}/ti-st/st_core.c          |   91 +-
 drivers/{staging => misc}/ti-st/st_kim.c           |   32 +-
 drivers/{staging => misc}/ti-st/st_ll.c            |    7 +-
 drivers/staging/Kconfig                            |   28 +-
 drivers/staging/Makefile                           |   15 +-
 drivers/staging/adis16255/adis16255.c              |    4 +-
 drivers/staging/ath6kl/Kconfig                     |  163 +
 drivers/staging/ath6kl/Makefile                    |  159 +
 drivers/staging/ath6kl/TODO                        |    8 +
 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |   55 +
 drivers/staging/ath6kl/bmi/src/bmi.c               | 1010 +
 .../staging/ath6kl/hif/common/hif_sdio_common.h    |   87 +
 .../hif/sdio/linux_sdio/include/hif_internal.h     |  134 +
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   | 1298 +
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |  393 +
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          | 1471 +
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |  398 +
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |  784 +
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |  756 +
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        | 1280 +
 drivers/staging/ath6kl/htc2/htc.c                  |  579 +
 drivers/staging/ath6kl/htc2/htc_debug.h            |   38 +
 drivers/staging/ath6kl/htc2/htc_internal.h         |  220 +
 drivers/staging/ath6kl/htc2/htc_recv.c             | 1578 ++
 drivers/staging/ath6kl/htc2/htc_send.c             | 1023 +
 drivers/staging/ath6kl/htc2/htc_services.c         |  450 +
 drivers/staging/ath6kl/include/a_config.h          |   53 +
 drivers/staging/ath6kl/include/a_debug.h           |  224 +
 drivers/staging/ath6kl/include/a_drv.h             |   54 +
 drivers/staging/ath6kl/include/a_drv_api.h         |  232 +
 drivers/staging/ath6kl/include/a_osapi.h           |   61 +
 drivers/staging/ath6kl/include/a_types.h           |   58 +
 drivers/staging/ath6kl/include/aggr_recv_api.h     |  140 +
 drivers/staging/ath6kl/include/ar3kconfig.h        |   65 +
 drivers/staging/ath6kl/include/ar6000_api.h        |   54 +
 drivers/staging/ath6kl/include/ar6000_diag.h       |   48 +
 drivers/staging/ath6kl/include/ar6kap_common.h     |   44 +
 drivers/staging/ath6kl/include/athbtfilter.h       |  135 +
 drivers/staging/ath6kl/include/athendpack.h        |   52 +
 drivers/staging/ath6kl/include/athstartpack.h      |   55 +
 drivers/staging/ath6kl/include/bmi.h               |  135 +
 .../ath6kl/include/common/AR6002/AR6002_regdump.h  |   60 +
 .../ath6kl/include/common/AR6002/AR6K_version.h    |   52 +
 .../staging/ath6kl/include/common/AR6002/addrs.h   |   90 +
 .../common/AR6002/hw2.0/hw/analog_intf_reg.h       |   64 +
 .../include/common/AR6002/hw2.0/hw/analog_reg.h    | 1932 ++
 .../include/common/AR6002/hw2.0/hw/apb_map.h       |   13 +
 .../include/common/AR6002/hw2.0/hw/gpio_reg.h      |  977 +
 .../include/common/AR6002/hw2.0/hw/mbox_host_reg.h |  386 +
 .../include/common/AR6002/hw2.0/hw/mbox_reg.h      |  481 +
 .../include/common/AR6002/hw2.0/hw/rtc_reg.h       | 1163 +
 .../ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h |  186 +
 .../include/common/AR6002/hw2.0/hw/uart_reg.h      |  327 +
 .../include/common/AR6002/hw2.0/hw/vmc_reg.h       |   76 +
 .../common/AR6002/hw4.0/hw/analog_intf_ares_reg.h  | 3291 +++
 .../AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h    | 3674 +++
 .../common/AR6002/hw4.0/hw/analog_intf_reg.h       |   37 +
 .../common/AR6002/hw4.0/hw/apb_athr_wlan_map.h     |   40 +
 .../include/common/AR6002/hw4.0/hw/apb_map.h       |   48 +
 .../include/common/AR6002/hw4.0/hw/bb_lc_reg.h     | 7076 +++++
 .../include/common/AR6002/hw4.0/hw/efuse_reg.h     |  108 +
 .../common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h    | 1253 +
 .../include/common/AR6002/hw4.0/hw/gpio_reg.h      | 1094 +
 .../include/common/AR6002/hw4.0/hw/mac_dma_reg.h   |  605 +
 .../include/common/AR6002/hw4.0/hw/mac_pcu_reg.h   | 3065 ++
 .../include/common/AR6002/hw4.0/hw/mbox_host_reg.h |   37 +
 .../include/common/AR6002/hw4.0/hw/mbox_reg.h      |  560 +
 .../common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h    |  522 +
 .../include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h |  638 +
 .../include/common/AR6002/hw4.0/hw/rdma_reg.h      |  564 +
 .../include/common/AR6002/hw4.0/hw/rtc_reg.h       |  975 +
 .../include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h  | 2065 ++
 .../ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h |  209 +
 .../include/common/AR6002/hw4.0/hw/uart_reg.h      |  260 +
 .../include/common/AR6002/hw4.0/hw/umbox_reg.h     |   37 +
 .../common/AR6002/hw4.0/hw/umbox_wlan_reg.h        |  322 +
 .../include/common/AR6002/hw4.0/hw/vmc_reg.h       |  167 +
 .../include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h  |  195 +
 drivers/staging/ath6kl/include/common/a_hci.h      |  682 +
 drivers/staging/ath6kl/include/common/athdefs.h    |   84 +
 drivers/staging/ath6kl/include/common/bmi_msg.h    |  241 +
 drivers/staging/ath6kl/include/common/btcoexGpio.h |   86 +
 drivers/staging/ath6kl/include/common/cnxmgmt.h    |   36 +
 drivers/staging/ath6kl/include/common/dbglog.h     |  134 +
 drivers/staging/ath6kl/include/common/dbglog_id.h  |  558 +
 drivers/staging/ath6kl/include/common/discovery.h  |   75 +
 .../staging/ath6kl/include/common/dset_internal.h  |   63 +
 drivers/staging/ath6kl/include/common/dsetid.h     |  134 +
 .../staging/ath6kl/include/common/epping_test.h    |  120 +
 drivers/staging/ath6kl/include/common/gmboxif.h    |   78 +
 drivers/staging/ath6kl/include/common/gpio.h       |   45 +
 drivers/staging/ath6kl/include/common/htc.h        |  236 +
 .../staging/ath6kl/include/common/htc_services.h   |   52 +
 drivers/staging/ath6kl/include/common/ini_dset.h   |   82 +
 drivers/staging/ath6kl/include/common/pkt_log.h    |   45 +
 drivers/staging/ath6kl/include/common/regDb.h      |   29 +
 drivers/staging/ath6kl/include/common/regdump.h    |   59 +
 .../include/common/regulatory/reg_dbschema.h       |  237 +
 .../include/common/regulatory/reg_dbvalues.h       |  504 +
 drivers/staging/ath6kl/include/common/roaming.h    |   41 +
 drivers/staging/ath6kl/include/common/targaddrs.h  |  245 +
 drivers/staging/ath6kl/include/common/testcmd.h    |  185 +
 drivers/staging/ath6kl/include/common/tlpm.h       |   38 +
 drivers/staging/ath6kl/include/common/wlan_defs.h  |   79 +
 drivers/staging/ath6kl/include/common/wlan_dset.h  |   33 +
 drivers/staging/ath6kl/include/common/wmi.h        | 3119 +++
 drivers/staging/ath6kl/include/common/wmi_thin.h   |  347 +
 drivers/staging/ath6kl/include/common/wmix.h       |  279 +
 drivers/staging/ath6kl/include/common_drv.h        |  108 +
 drivers/staging/ath6kl/include/dbglog_api.h        |   52 +
 drivers/staging/ath6kl/include/dl_list.h           |  153 +
 drivers/staging/ath6kl/include/dset_api.h          |   65 +
 drivers/staging/ath6kl/include/gpio_api.h          |   59 +
 drivers/staging/ath6kl/include/hci_transport_api.h |  259 +
 drivers/staging/ath6kl/include/hif.h               |  458 +
 drivers/staging/ath6kl/include/host_version.h      |   52 +
 drivers/staging/ath6kl/include/htc_api.h           |  575 +
 drivers/staging/ath6kl/include/htc_packet.h        |  227 +
 drivers/staging/ath6kl/include/target_reg_table.h  |  244 +
 drivers/staging/ath6kl/include/wlan_api.h          |  128 +
 drivers/staging/ath6kl/include/wmi_api.h           |  441 +
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |  566 +
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |  572 +
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |   75 +
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |  969 +
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |  127 +
 drivers/staging/ath6kl/miscdrv/common_drv.c        | 1027 +
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |  418 +
 drivers/staging/ath6kl/miscdrv/miscdrv.h           |   42 +
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |  413 +
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       | 6443 +++++
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |  731 +
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |  455 +
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |  481 +
 drivers/staging/ath6kl/os/linux/cfg80211.c         | 1470 +
 drivers/staging/ath6kl/os/linux/eeprom.c           |  574 +
 .../staging/ath6kl/os/linux/export_hci_transport.c |  125 +
 drivers/staging/ath6kl/os/linux/hci_bridge.c       | 1144 +
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |  762 +
 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h |   36 +
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |  197 +
 .../staging/ath6kl/os/linux/include/athdrv_linux.h | 1219 +
 .../ath6kl/os/linux/include/athtypes_linux.h       |   53 +
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   50 +
 .../staging/ath6kl/os/linux/include/config_linux.h |   60 +
 .../staging/ath6kl/os/linux/include/debug_linux.h  |   50 +
 .../ath6kl/os/linux/include/export_hci_transport.h |   76 +
 .../ath6kl/os/linux/include/ieee80211_ioctl.h      |  179 +
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |  387 +
 .../staging/ath6kl/os/linux/include/wlan_config.h  |  111 +
 .../ath6kl/os/linux/include/wmi_filter_linux.h     |  293 +
 drivers/staging/ath6kl/os/linux/ioctl.c            | 4733 ++++
 drivers/staging/ath6kl/os/linux/netbuf.c           |  234 +
 drivers/staging/ath6kl/os/linux/wireless_ext.c     | 2725 ++
 drivers/staging/ath6kl/reorder/aggr_rx_internal.h  |  116 +
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |  666 +
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |  401 +
 .../staging/ath6kl/wlan/include/ieee80211_node.h   |   93 +
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |  636 +
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |  200 +
 drivers/staging/ath6kl/wlan/src/wlan_utils.c       |   61 +
 drivers/staging/ath6kl/wmi/wmi.c                   | 6670 +++++
 drivers/staging/ath6kl/wmi/wmi_host.h              |  102 +
 {fs => drivers/staging}/autofs/Kconfig             |    0
 {fs => drivers/staging}/autofs/Makefile            |    2 +-
 drivers/staging/autofs/TODO                        |    8 +
 {fs => drivers/staging}/autofs/autofs_i.h          |    2 +-
 {fs => drivers/staging}/autofs/dirhash.c           |    2 +-
 {fs => drivers/staging}/autofs/init.c              |    2 +-
 {fs => drivers/staging}/autofs/inode.c             |    2 +-
 {fs => drivers/staging}/autofs/root.c              |    2 +-
 {fs => drivers/staging}/autofs/symlink.c           |    2 +-
 {fs => drivers/staging}/autofs/waitq.c             |    2 +-
 drivers/staging/batman-adv/CHANGELOG               |   63 -
 drivers/staging/batman-adv/Makefile                |    2 +-
 drivers/staging/batman-adv/README                  |   50 +-
 drivers/staging/batman-adv/TODO                    |    9 +-
 drivers/staging/batman-adv/aggregation.c           |   70 +-
 drivers/staging/batman-adv/bat_debugfs.c           |    2 +
 drivers/staging/batman-adv/bat_sysfs.c             |  140 +-
 drivers/staging/batman-adv/bitarray.c              |   22 +-
 drivers/staging/batman-adv/bitarray.h              |    7 +-
 drivers/staging/batman-adv/hard-interface.c        |  291 +-
 drivers/staging/batman-adv/hard-interface.h        |   19 +-
 drivers/staging/batman-adv/hash.c                  |    6 +-
 drivers/staging/batman-adv/hash.h                  |    4 +-
 drivers/staging/batman-adv/icmp_socket.c           |   73 +-
 drivers/staging/batman-adv/main.c                  |  146 +-
 drivers/staging/batman-adv/main.h                  |   30 +-
 drivers/staging/batman-adv/originator.c            |  186 +-
 drivers/staging/batman-adv/originator.h            |    8 +-
 drivers/staging/batman-adv/packet.h                |   28 +-
 drivers/staging/batman-adv/routing.c               |  448 +-
 drivers/staging/batman-adv/routing.h               |   16 +-
 drivers/staging/batman-adv/send.c                  |  175 +-
 drivers/staging/batman-adv/send.h                  |    7 +-
 drivers/staging/batman-adv/soft-interface.c        |  241 +-
 drivers/staging/batman-adv/soft-interface.h        |   13 +-
 drivers/staging/batman-adv/sysfs-class-net-mesh    |    8 +
 drivers/staging/batman-adv/translation-table.c     |  271 +-
 drivers/staging/batman-adv/translation-table.h     |   30 +-
 drivers/staging/batman-adv/types.h                 |  103 +-
 drivers/staging/batman-adv/unicast.c               |  269 +
 drivers/staging/batman-adv/unicast.h               |   39 +
 drivers/staging/batman-adv/vis.c                   |  534 +-
 drivers/staging/batman-adv/vis.h                   |   27 +-
 drivers/staging/bcm/Adapter.h                      |  714 +
 drivers/staging/bcm/Arp.c                          |   94 +
 drivers/staging/bcm/Bcmchar.c                      | 2438 ++
 drivers/staging/bcm/Bcmnet.c                       |  264 +
 drivers/staging/bcm/CmHost.c                       | 2441 ++
 drivers/staging/bcm/CmHost.h                       |  166 +
 drivers/staging/bcm/DDRInit.c                      | 1302 +
 drivers/staging/bcm/DDRInit.h                      |    9 +
 drivers/staging/bcm/Debug.c                        |   41 +
 drivers/staging/bcm/Debug.h                        |  297 +
 drivers/staging/bcm/HandleControlPacket.c          |  247 +
 drivers/staging/bcm/HostMIBSInterface.h            |  230 +
 drivers/staging/bcm/HostMibs.h                     |    7 +
 drivers/staging/bcm/IPv6Protocol.c                 |  400 +
 drivers/staging/bcm/IPv6ProtocolHdr.h              |  119 +
 drivers/staging/bcm/InterfaceAdapter.h             |   97 +
 drivers/staging/bcm/InterfaceDld.c                 |  510 +
 drivers/staging/bcm/InterfaceIdleMode.c            |  318 +
 drivers/staging/bcm/InterfaceIdleMode.h            |   16 +
 drivers/staging/bcm/InterfaceInit.c                |  868 +
 drivers/staging/bcm/InterfaceInit.h                |   51 +
 drivers/staging/bcm/InterfaceIsr.c                 |  203 +
 drivers/staging/bcm/InterfaceIsr.h                 |   15 +
 drivers/staging/bcm/InterfaceMacros.h              |   18 +
 drivers/staging/bcm/InterfaceMisc.c                |  290 +
 drivers/staging/bcm/InterfaceMisc.h                |   45 +
 drivers/staging/bcm/InterfaceRx.c                  |  256 +
 drivers/staging/bcm/InterfaceRx.h                  |    7 +
 drivers/staging/bcm/InterfaceTx.c                  |  259 +
 drivers/staging/bcm/InterfaceTx.h                  |   13 +
 drivers/staging/bcm/Interfacemain.h                |   10 +
 drivers/staging/bcm/Ioctl.h                        |  360 +
 drivers/staging/bcm/Kconfig                        |    7 +
 drivers/staging/bcm/LeakyBucket.c                  |  399 +
 drivers/staging/bcm/Macros.h                       |  399 +
 drivers/staging/bcm/Makefile                       |   12 +
 drivers/staging/bcm/Misc.c                         | 2243 ++
 drivers/staging/bcm/Osal_Misc.c                    |   27 +
 drivers/staging/bcm/PHSDefines.h                   |  125 +
 drivers/staging/bcm/PHSModule.c                    | 1641 ++
 drivers/staging/bcm/PHSModule.h                    |   95 +
 drivers/staging/bcm/Protocol.h                     |  151 +
 drivers/staging/bcm/Prototypes.h                   |  322 +
 drivers/staging/bcm/Qos.c                          |  892 +
 drivers/staging/bcm/Queue.h                        |   31 +
 drivers/staging/bcm/TODO                           |   15 +
 drivers/staging/bcm/Transmit.c                     |  555 +
 drivers/staging/bcm/Typedefs.h                     |   47 +
 drivers/staging/bcm/Version.h                      |   35 +
 drivers/staging/bcm/cntrl_SignalingInterface.h     |  677 +
 drivers/staging/bcm/headers.h                      |  109 +
 drivers/staging/bcm/hostmibs.c                     |  164 +
 drivers/staging/bcm/led_control.c                  | 1006 +
 drivers/staging/bcm/led_control.h                  |  106 +
 drivers/staging/bcm/nvm.c                          | 5614 ++++
 drivers/staging/bcm/nvm.h                          |  489 +
 drivers/staging/bcm/osal_misc.h                    |   49 +
 drivers/staging/bcm/sort.c                         |   63 +
 drivers/staging/bcm/target_params.h                |   81 +
 drivers/staging/bcm/vendorspecificextn.c           |  146 +
 drivers/staging/bcm/vendorspecificextn.h           |   18 +
 drivers/staging/brcm80211/Kconfig                  |   33 +
 drivers/staging/brcm80211/Makefile                 |   76 +
 drivers/staging/brcm80211/README                   |   94 +
 drivers/staging/brcm80211/TODO                     |   49 +
 drivers/staging/brcm80211/brcmfmac/Kconfig         |   15 +
 drivers/staging/brcm80211/brcmfmac/Makefile        |   47 +
 drivers/staging/brcm80211/brcmfmac/README          |   36 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |  632 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |  658 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  | 1238 +
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |  231 +
 drivers/staging/brcm80211/brcmfmac/dhd.h           |  468 +
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h       |   82 +
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |  487 +
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    | 1910 ++
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |  160 +
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h       |  103 +
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     | 2929 ++
 .../staging/brcm80211/brcmfmac/dhd_linux_sched.c   |   26 +
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h     |   92 +
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      | 6103 ++++
 drivers/staging/brcm80211/brcmfmac/dngl_stats.h    |   32 +
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   | 4229 +++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |  394 +
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         | 3767 +++
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |  149 +
 drivers/staging/brcm80211/include/aidmp.h          |  374 +
 drivers/staging/brcm80211/include/bcm_rpc.h        |   79 +
 drivers/staging/brcm80211/include/bcm_rpc_tp.h     |  137 +
 drivers/staging/brcm80211/include/bcm_xdr.h        |   60 +
 drivers/staging/brcm80211/include/bcmcdc.h         |   98 +
 drivers/staging/brcm80211/include/bcmdefs.h        |  200 +
 drivers/staging/brcm80211/include/bcmdevs.h        |  192 +
 drivers/staging/brcm80211/include/bcmendian.h      |  303 +
 drivers/staging/brcm80211/include/bcmnvram.h       |  172 +
 drivers/staging/brcm80211/include/bcmotp.h         |   44 +
 drivers/staging/brcm80211/include/bcmsdbus.h       |  113 +
 drivers/staging/brcm80211/include/bcmsdh.h         |  198 +
 drivers/staging/brcm80211/include/bcmsdh_sdmmc.h   |  110 +
 drivers/staging/brcm80211/include/bcmsdpcm.h       |  207 +
 drivers/staging/brcm80211/include/bcmsrom.h        |   34 +
 drivers/staging/brcm80211/include/bcmsrom_fmt.h    |  367 +
 drivers/staging/brcm80211/include/bcmsrom_tbl.h    |  583 +
 drivers/staging/brcm80211/include/bcmutils.h       |  502 +
 drivers/staging/brcm80211/include/bcmwifi.h        |  192 +
 drivers/staging/brcm80211/include/d11.h            | 1778 ++
 drivers/staging/brcm80211/include/dbus.h           |  353 +
 drivers/staging/brcm80211/include/dhdioctl.h       |  107 +
 drivers/staging/brcm80211/include/epivers.h        |   44 +
 drivers/staging/brcm80211/include/hnddma.h         |  243 +
 drivers/staging/brcm80211/include/hndpmu.h         |   71 +
 drivers/staging/brcm80211/include/hndrte_armtrap.h |   75 +
 drivers/staging/brcm80211/include/hndrte_cons.h    |   57 +
 drivers/staging/brcm80211/include/hndsoc.h         |  199 +
 drivers/staging/brcm80211/include/linux_osl.h      |  407 +
 drivers/staging/brcm80211/include/linuxver.h       |   38 +
 drivers/staging/brcm80211/include/msgtrace.h       |   67 +
 drivers/staging/brcm80211/include/nicpci.h         |   79 +
 drivers/staging/brcm80211/include/osl.h            |   59 +
 .../staging/brcm80211/include/packed_section_end.h |   32 +
 .../brcm80211/include/packed_section_start.h       |   36 +
 drivers/staging/brcm80211/include/pci_core.h       |  122 +
 drivers/staging/brcm80211/include/pcicfg.h         |  524 +
 drivers/staging/brcm80211/include/pcie_core.h      |  299 +
 drivers/staging/brcm80211/include/proto/802.11.h   |  322 +
 drivers/staging/brcm80211/include/proto/802.1d.h   |   37 +
 drivers/staging/brcm80211/include/proto/bcmeth.h   |   48 +
 drivers/staging/brcm80211/include/proto/bcmevent.h |  217 +
 drivers/staging/brcm80211/include/proto/ethernet.h |  110 +
 drivers/staging/brcm80211/include/proto/wpa.h      |  127 +
 drivers/staging/brcm80211/include/qmath.h          |   78 +
 drivers/staging/brcm80211/include/rpc_osl.h        |   33 +
 drivers/staging/brcm80211/include/sbchipc.h        | 1588 ++
 drivers/staging/brcm80211/include/sbconfig.h       |  272 +
 drivers/staging/brcm80211/include/sbhnddma.h       |  315 +
 drivers/staging/brcm80211/include/sbhndpio.h       |   52 +
 drivers/staging/brcm80211/include/sbpcmcia.h       |  217 +
 drivers/staging/brcm80211/include/sbsdio.h         |  152 +
 drivers/staging/brcm80211/include/sbsdpcmdev.h     |  281 +
 drivers/staging/brcm80211/include/sbsocram.h       |  175 +
 drivers/staging/brcm80211/include/sdio.h           |  552 +
 drivers/staging/brcm80211/include/sdioh.h          |   63 +
 drivers/staging/brcm80211/include/sdiovar.h        |   44 +
 drivers/staging/brcm80211/include/siutils.h        |  377 +
 drivers/staging/brcm80211/include/spid.h           |  155 +
 drivers/staging/brcm80211/include/wlioctl.h        | 2025 ++
 drivers/staging/brcm80211/phy/phy_version.h        |   36 +
 drivers/staging/brcm80211/phy/wlc_phy_cmn.c        | 3456 +++
 drivers/staging/brcm80211/phy/wlc_phy_hal.h        |  262 +
 drivers/staging/brcm80211/phy/wlc_phy_int.h        | 1229 +
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c        | 5320 ++++
 drivers/staging/brcm80211/phy/wlc_phy_lcn.h        |  119 +
 drivers/staging/brcm80211/phy/wlc_phy_n.c          |29234 ++++++++++++++++++++
 drivers/staging/brcm80211/phy/wlc_phy_radio.h      | 1533 +
 drivers/staging/brcm80211/phy/wlc_phyreg_n.h       |  167 +
 drivers/staging/brcm80211/phy/wlc_phytbl_lcn.c     | 3638 +++
 drivers/staging/brcm80211/phy/wlc_phytbl_lcn.h     |   49 +
 drivers/staging/brcm80211/phy/wlc_phytbl_n.c       |10631 +++++++
 drivers/staging/brcm80211/phy/wlc_phytbl_n.h       |   39 +
 drivers/staging/brcm80211/sys/d11ucode_ext.h       |   35 +
 drivers/staging/brcm80211/sys/wl_dbg.h             |   82 +
 drivers/staging/brcm80211/sys/wl_export.h          |   63 +
 drivers/staging/brcm80211/sys/wl_mac80211.c        | 2382 ++
 drivers/staging/brcm80211/sys/wl_mac80211.h        |  161 +
 drivers/staging/brcm80211/sys/wl_ucode.h           |   37 +
 drivers/staging/brcm80211/sys/wl_ucode_loader.c    |   90 +
 drivers/staging/brcm80211/sys/wlc_alloc.c          |  373 +
 drivers/staging/brcm80211/sys/wlc_alloc.h          |   25 +
 drivers/staging/brcm80211/sys/wlc_ampdu.c          | 1411 +
 drivers/staging/brcm80211/sys/wlc_ampdu.h          |   40 +
 drivers/staging/brcm80211/sys/wlc_antsel.c         |  322 +
 drivers/staging/brcm80211/sys/wlc_antsel.h         |   28 +
 drivers/staging/brcm80211/sys/wlc_bmac.c           | 4206 +++
 drivers/staging/brcm80211/sys/wlc_bmac.h           |  277 +
 drivers/staging/brcm80211/sys/wlc_bsscfg.h         |  152 +
 drivers/staging/brcm80211/sys/wlc_cfg.h            |  310 +
 drivers/staging/brcm80211/sys/wlc_channel.c        | 1599 ++
 drivers/staging/brcm80211/sys/wlc_channel.h        |  159 +
 drivers/staging/brcm80211/sys/wlc_event.c          |  226 +
 drivers/staging/brcm80211/sys/wlc_event.h          |   51 +
 drivers/staging/brcm80211/sys/wlc_key.h            |  144 +
 drivers/staging/brcm80211/sys/wlc_mac80211.c       | 8675 ++++++
 drivers/staging/brcm80211/sys/wlc_mac80211.h       | 1040 +
 drivers/staging/brcm80211/sys/wlc_phy_shim.c       |  243 +
 drivers/staging/brcm80211/sys/wlc_phy_shim.h       |  112 +
 drivers/staging/brcm80211/sys/wlc_pub.h            |  627 +
 drivers/staging/brcm80211/sys/wlc_rate.c           |  499 +
 drivers/staging/brcm80211/sys/wlc_rate.h           |  170 +
 drivers/staging/brcm80211/sys/wlc_rpc.h            |  527 +
 drivers/staging/brcm80211/sys/wlc_rpctx.h          |   71 +
 drivers/staging/brcm80211/sys/wlc_scb.h            |   84 +
 drivers/staging/brcm80211/sys/wlc_stf.c            |  593 +
 drivers/staging/brcm80211/sys/wlc_stf.h            |   42 +
 drivers/staging/brcm80211/sys/wlc_types.h          |   52 +
 drivers/staging/brcm80211/util/aiutils.c           |  708 +
 drivers/staging/brcm80211/util/bcmotp.c            |  965 +
 drivers/staging/brcm80211/util/bcmsrom.c           | 2076 ++
 drivers/staging/brcm80211/util/bcmutils.c          | 1044 +
 drivers/staging/brcm80211/util/bcmwifi.c           |  189 +
 drivers/staging/brcm80211/util/hnddma.c            | 2690 ++
 drivers/staging/brcm80211/util/hndpmu.c            | 2693 ++
 drivers/staging/brcm80211/util/linux_osl.c         |  424 +
 drivers/staging/brcm80211/util/nicpci.c            |  881 +
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |  212 +
 drivers/staging/brcm80211/util/qmath.c             |  681 +
 drivers/staging/brcm80211/util/sbutils.c           |  585 +
 drivers/staging/brcm80211/util/siutils.c           | 2021 ++
 drivers/staging/brcm80211/util/siutils_priv.h      |   32 +
 drivers/staging/comedi/Makefile                    |    2 +-
 drivers/staging/comedi/comedi_fops.c               |    3 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.c      |    2 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.h      |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.h     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.h     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.c    |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.h    |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Pwm.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Pwm.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.h        |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.c     |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.h     |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |    2 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    6 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.h       |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    4 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.h      |    2 +-
 drivers/staging/comedi/drivers/adl_pci6208.c       |    5 +-
 drivers/staging/comedi/drivers/adl_pci9111.c       |  219 +-
 drivers/staging/comedi/drivers/adl_pci9118.c       |   42 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |   13 +-
 drivers/staging/comedi/drivers/adv_pci1723.c       |    5 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c       |   29 +-
 drivers/staging/comedi/drivers/aio_aio12_8.c       |    6 +-
 drivers/staging/comedi/drivers/aio_iiro_16.c       |    6 +-
 drivers/staging/comedi/drivers/cb_pcidas.c         |   19 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c       |   62 +-
 drivers/staging/comedi/drivers/cb_pcidda.c         |   15 +-
 drivers/staging/comedi/drivers/cb_pcidio.c         |    9 +-
 drivers/staging/comedi/drivers/cb_pcimdas.c        |    6 +-
 drivers/staging/comedi/drivers/dt2817.c            |   14 +-
 drivers/staging/comedi/drivers/dt3000.c            |   17 +-
 drivers/staging/comedi/drivers/dt9812.c            |    2 +-
 drivers/staging/comedi/drivers/me4000.c            |   29 +-
 drivers/staging/comedi/drivers/ni_labpc.c          |   16 +-
 drivers/staging/comedi/drivers/rtd520.c            |    7 +-
 drivers/staging/comedi/drivers/skel.c              |    7 +-
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/crystalhd/Makefile                 |    2 +-
 drivers/staging/crystalhd/crystalhd_lnx.c          |    1 +
 drivers/staging/crystalhd/crystalhd_lnx.h          |    2 +-
 drivers/staging/cx25821/Makefile                   |   10 +-
 drivers/staging/cx25821/cx25821-audio-upstream.c   |   15 +-
 drivers/staging/cx25821/cx25821-audio.h            |   16 +-
 drivers/staging/cx25821/cx25821-core.c             |   13 +-
 drivers/staging/cxt1e1/Kconfig                     |    2 +-
 drivers/staging/cxt1e1/Makefile                    |    8 +-
 drivers/staging/cxt1e1/functions.c                 |    4 +-
 drivers/staging/cxt1e1/linux.c                     |   20 +-
 drivers/staging/cxt1e1/musycc.c                    |   22 +-
 drivers/staging/cxt1e1/pmcc4_drv.c                 |   14 +-
 drivers/staging/cxt1e1/sbeproc.c                   |   13 +-
 drivers/staging/dream/Makefile                     |    2 +-
 drivers/staging/dream/camera/Makefile              |    2 +-
 drivers/staging/dream/pmem.c                       |    2 +-
 drivers/staging/dream/qdsp5/Makefile               |    2 +-
 drivers/staging/easycap/Makefile                   |   14 +-
 drivers/staging/et131x/Makefile                    |    2 +-
 drivers/staging/et131x/et131x_initpci.c            |    2 +-
 drivers/staging/frontier/alphatrack.c              |    2 +-
 drivers/staging/frontier/tranzport.c               |   56 +-
 drivers/staging/ft1000/Kconfig                     |   22 +
 drivers/staging/ft1000/Makefile                    |    3 +
 drivers/staging/ft1000/TODO                        |    9 +
 drivers/staging/ft1000/ft1000-pcmcia/Makefile      |    3 +
 drivers/staging/ft1000/ft1000-pcmcia/boot.h        |  158 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf   |   14 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |  409 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.img    |  Bin 0 -> 305770 bytes
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |  513 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h   |    1 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h  |   66 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |  940 +
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   | 2294 ++
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |  219 +
 drivers/staging/ft1000/ft1000-usb/Makefile         |    3 +
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |  936 +
 .../staging/ft1000/ft1000-usb/ft1000_download.c    | 1248 +
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      | 2326 ++
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.h      |   10 +
 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |  139 +
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |  232 +
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |  276 +
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |  608 +
 drivers/staging/ft1000/ft1000-usb/ft3000.img       |  Bin 0 -> 280414 bytes
 drivers/staging/go7007/Makefile                    |   10 +-
 drivers/staging/hv/Makefile                        |   10 +-
 drivers/staging/hv/TODO                            |    2 -
 drivers/staging/hv/blkvsc.c                        |    2 +-
 drivers/staging/hv/blkvsc_drv.c                    |    2 -
 drivers/staging/hv/channel.c                       |  841 +-
 drivers/staging/hv/channel.h                       |  122 +-
 drivers/staging/hv/channel_interface.c             |  152 -
 drivers/staging/hv/channel_interface.h             |   35 -
 drivers/staging/hv/channel_mgmt.c                  |  342 +-
 drivers/staging/hv/channel_mgmt.h                  |   10 +-
 drivers/staging/hv/connection.c                    |    4 +-
 drivers/staging/hv/hv_utils.c                      |   12 +-
 drivers/staging/hv/netvsc.c                        |  137 +-
 drivers/staging/hv/netvsc_drv.c                    |    4 +-
 drivers/staging/hv/storvsc.c                       |   93 +-
 drivers/staging/hv/storvsc_drv.c                   |    2 -
 drivers/staging/hv/vmbus.c                         |   35 +-
 drivers/staging/hv/vmbus.h                         |    2 -
 drivers/staging/hv/vmbus_api.h                     |   55 +-
 drivers/staging/hv/vmbus_drv.c                     |   84 +-
 drivers/staging/hv/vmbus_private.h                 |    3 +-
 drivers/staging/iio/Documentation/generic_buffer.c |  318 +
 drivers/staging/iio/Documentation/iio_utils.h      |  396 +-
 .../iio/Documentation/lis3l02dqbuffersimple.c      |  238 -
 drivers/staging/iio/Documentation/overview.txt     |   17 +-
 drivers/staging/iio/Documentation/ring.txt         |    6 +-
 drivers/staging/iio/Documentation/sysfs-bus-iio    |  390 +
 .../staging/iio/Documentation/sysfs-bus-iio-light  |   64 +
 drivers/staging/iio/Documentation/sysfs-class-iio  |  294 -
 drivers/staging/iio/Documentation/userspace.txt    |   56 +-
 drivers/staging/iio/accel/accel.h                  |  172 +-
 drivers/staging/iio/accel/adis16209_core.c         |   48 +-
 drivers/staging/iio/accel/adis16209_ring.c         |   90 +-
 drivers/staging/iio/accel/adis16209_trigger.c      |    2 +-
 drivers/staging/iio/accel/adis16220_core.c         |   26 +-
 drivers/staging/iio/accel/adis16240_core.c         |   37 +-
 drivers/staging/iio/accel/adis16240_ring.c         |   72 +-
 drivers/staging/iio/accel/adis16240_trigger.c      |    2 +-
 drivers/staging/iio/accel/inclinometer.h           |    2 +
 drivers/staging/iio/accel/lis3l02dq_core.c         |   66 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |   79 +-
 drivers/staging/iio/accel/sca3000.h                |    2 +-
 drivers/staging/iio/accel/sca3000_core.c           |   71 +-
 drivers/staging/iio/accel/sca3000_ring.c           |   91 +-
 drivers/staging/iio/adc/Kconfig                    |   35 +
 drivers/staging/iio/adc/Makefile                   |    8 +
 drivers/staging/iio/adc/ad7476.h                   |   77 +
 drivers/staging/iio/adc/ad7476_core.c              |  293 +
 drivers/staging/iio/adc/ad7476_ring.c              |  207 +
 drivers/staging/iio/adc/ad799x.h                   |  159 +
 drivers/staging/iio/adc/ad799x_core.c              |  923 +
 drivers/staging/iio/adc/ad799x_ring.c              |  240 +
 drivers/staging/iio/adc/adc.h                      |   19 +-
 drivers/staging/iio/adc/max1363_core.c             |  208 +-
 drivers/staging/iio/adc/max1363_ring.c             |   22 +-
 drivers/staging/iio/chrdev.h                       |    2 -
 drivers/staging/iio/gyro/adis16260_core.c          |   36 +-
 drivers/staging/iio/gyro/adis16260_ring.c          |   68 +-
 drivers/staging/iio/gyro/adis16260_trigger.c       |    2 +-
 drivers/staging/iio/gyro/gyro.h                    |   46 +-
 drivers/staging/iio/iio.h                          |  106 +-
 drivers/staging/iio/imu/adis16300_core.c           |   50 +-
 drivers/staging/iio/imu/adis16300_ring.c           |   95 +-
 drivers/staging/iio/imu/adis16300_trigger.c        |    2 +-
 drivers/staging/iio/imu/adis16350_core.c           |   59 +-
 drivers/staging/iio/imu/adis16350_ring.c           |  113 +-
 drivers/staging/iio/imu/adis16350_trigger.c        |    2 +-
 drivers/staging/iio/imu/adis16400_core.c           |   69 +-
 drivers/staging/iio/imu/adis16400_ring.c           |  122 +-
 drivers/staging/iio/imu/adis16400_trigger.c        |    2 +-
 drivers/staging/iio/industrialio-core.c            |   90 +-
 drivers/staging/iio/industrialio-ring.c            |   61 +-
 drivers/staging/iio/light/Kconfig                  |   12 +
 drivers/staging/iio/light/Makefile                 |    1 +
 drivers/staging/iio/light/isl29018.c               |  563 +
 drivers/staging/iio/light/light.h                  |    7 -
 drivers/staging/iio/light/tsl2563.c                |   35 +-
 drivers/staging/iio/magnetometer/Kconfig           |   10 +
 drivers/staging/iio/magnetometer/Makefile          |    1 +
 drivers/staging/iio/magnetometer/ak8975.c          |  558 +
 drivers/staging/iio/magnetometer/hmc5843.c         |   61 +-
 drivers/staging/iio/magnetometer/magnet.h          |   12 +-
 drivers/staging/iio/ring_generic.h                 |  241 +-
 drivers/staging/iio/ring_sw.c                      |   79 +-
 drivers/staging/iio/ring_sw.h                      |   12 +-
 drivers/staging/iio/sysfs.h                        |  162 +-
 drivers/staging/iio/trigger.h                      |    6 +-
 drivers/staging/iio/trigger/iio-trig-gpio.c        |    2 +-
 .../staging/iio/trigger/iio-trig-periodic-rtc.c    |   12 +-
 drivers/staging/intel_sst/Kconfig                  |   18 +
 drivers/staging/intel_sst/Makefile                 |    7 +
 drivers/staging/intel_sst/TODO                     |   13 +
 drivers/staging/intel_sst/intel_sst.c              |  512 +
 drivers/staging/intel_sst/intel_sst.h              |  131 +
 .../staging/intel_sst/intel_sst_app_interface.c    | 1216 +
 drivers/staging/intel_sst/intel_sst_common.h       |  618 +
 .../staging/intel_sst/intel_sst_drv_interface.c    |  493 +
 drivers/staging/intel_sst/intel_sst_dsp.c          |  486 +
 drivers/staging/intel_sst/intel_sst_fw_ipc.h       |  392 +
 drivers/staging/intel_sst/intel_sst_ioctl.h        |  435 +
 drivers/staging/intel_sst/intel_sst_ipc.c          |  656 +
 drivers/staging/intel_sst/intel_sst_pvt.c          |  311 +
 drivers/staging/intel_sst/intel_sst_stream.c       |  576 +
 .../staging/intel_sst/intel_sst_stream_encoded.c   | 1275 +
 drivers/staging/intel_sst/intelmid.c               | 1220 +
 drivers/staging/intel_sst/intelmid.h               |  186 +
 drivers/staging/intel_sst/intelmid_ctrl.c          |  629 +
 drivers/staging/intel_sst/intelmid_msic_control.c  |  410 +
 drivers/staging/intel_sst/intelmid_pvt.c           |  174 +
 drivers/staging/intel_sst/intelmid_snd_control.h   |  114 +
 drivers/staging/intel_sst/intelmid_v0_control.c    |  771 +
 drivers/staging/intel_sst/intelmid_v1_control.c    |  900 +
 drivers/staging/intel_sst/intelmid_v2_control.c    | 1001 +
 drivers/staging/intel_sst/jack.h                   |   10 +
 drivers/staging/keucr/Kconfig                      |   13 +
 drivers/staging/keucr/Makefile                     |   16 +
 drivers/staging/keucr/TODO                         |   14 +
 drivers/staging/keucr/common.h                     |   26 +
 drivers/staging/keucr/init.c                       |  543 +
 drivers/staging/keucr/init.h                       | 2066 ++
 drivers/staging/keucr/ms.c                         |  956 +
 drivers/staging/keucr/ms.h                         |  381 +
 drivers/staging/keucr/msscsi.c                     |  324 +
 drivers/staging/keucr/scsiglue.c                   |  448 +
 drivers/staging/keucr/scsiglue.h                   |   10 +
 drivers/staging/keucr/sdscsi.c                     |  210 +
 drivers/staging/keucr/smcommon.h                   |   33 +
 drivers/staging/keucr/smil.h                       |  290 +
 drivers/staging/keucr/smilecc.c                    |  201 +
 drivers/staging/keucr/smilmain.c                   | 1852 ++
 drivers/staging/keucr/smilsub.c                    | 1661 ++
 drivers/staging/keucr/smscsi.c                     |  193 +
 drivers/staging/keucr/transport.c                  |  783 +
 drivers/staging/keucr/transport.h                  |  144 +
 drivers/staging/keucr/usb.c                        |  709 +
 drivers/staging/keucr/usb.h                        |  238 +
 drivers/staging/line6/Kconfig                      |   67 +-
 drivers/staging/line6/Makefile                     |    2 +-
 drivers/staging/line6/audio.c                      |   16 +-
 drivers/staging/line6/audio.h                      |    7 +-
 drivers/staging/line6/capture.c                    |  239 +-
 drivers/staging/line6/capture.h                    |   25 +-
 drivers/staging/line6/config.h                     |    6 +-
 drivers/staging/line6/control.c                    |   38 +-
 drivers/staging/line6/control.h                    |  190 +-
 drivers/staging/line6/driver.c                     |  566 +-
 drivers/staging/line6/driver.h                     |   59 +-
 drivers/staging/line6/dumprequest.c                |   60 +-
 drivers/staging/line6/dumprequest.h                |   28 +-
 drivers/staging/line6/midi.c                       |  100 +-
 drivers/staging/line6/midi.h                       |    9 +-
 drivers/staging/line6/midibuf.c                    |   90 +-
 drivers/staging/line6/midibuf.h                    |   31 +-
 drivers/staging/line6/pcm.c                        |  319 +-
 drivers/staging/line6/pcm.h                        |  145 +-
 drivers/staging/line6/playback.c                   |  313 +-
 drivers/staging/line6/playback.h                   |   29 +-
 drivers/staging/line6/pod.c                        |  774 +-
 drivers/staging/line6/pod.h                        |  127 +-
 drivers/staging/line6/revision.h                   |    2 +-
 drivers/staging/line6/toneport.c                   |  279 +-
 drivers/staging/line6/toneport.h                   |   33 +-
 drivers/staging/line6/usbdefs.h                    |   44 +-
 drivers/staging/line6/variax.c                     |  365 +-
 drivers/staging/line6/variax.h                     |   84 +-
 drivers/staging/lirc/lirc_imon.c                   |   16 +-
 drivers/staging/lirc/lirc_parallel.c               |    1 -
 drivers/staging/lirc/lirc_sasem.c                  |   15 +-
 drivers/staging/lirc/lirc_zilog.c                  |   10 +-
 drivers/staging/msm/mddihost.c                     |    2 +-
 drivers/staging/msm/mdp.c                          |   10 +-
 drivers/staging/msm/msm_fb.c                       |    2 +-
 drivers/staging/msm/staging-devices.c              |    2 +-
 drivers/staging/octeon/Makefile                    |   20 +-
 drivers/staging/octeon/cvmx-fpa.c                  |    2 +-
 drivers/staging/octeon/cvmx-fpa.h                  |    2 +-
 drivers/staging/octeon/cvmx-helper-board.c         |   19 -
 drivers/staging/octeon/cvmx-helper-board.h         |   29 -
 drivers/staging/octeon/ethernet.c                  |   13 +-
 drivers/staging/olpc_dcon/Kconfig                  |    8 +
 drivers/staging/olpc_dcon/Makefile                 |    1 +
 drivers/staging/olpc_dcon/TODO                     |   17 +
 drivers/staging/olpc_dcon/olpc_dcon.c              |  870 +
 drivers/staging/olpc_dcon/olpc_dcon.h              |   75 +
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c         |  171 +
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c       |  219 +
 drivers/staging/otus/80211core/amsdu.c             |  129 -
 drivers/staging/otus/80211core/cagg.c              | 3621 ---
 drivers/staging/otus/80211core/cagg.h              |  435 -
 drivers/staging/otus/80211core/ccmd.c              | 1766 --
 drivers/staging/otus/80211core/cfunc.c             | 1226 -
 drivers/staging/otus/80211core/cfunc.h             |  449 -
 drivers/staging/otus/80211core/chb.c               |  200 -
 drivers/staging/otus/80211core/cic.c               |  499 -
 drivers/staging/otus/80211core/cinit.c             | 1912 --
 drivers/staging/otus/80211core/cmm.c               | 2183 --
 drivers/staging/otus/80211core/cmmap.c             | 2435 --
 drivers/staging/otus/80211core/cmmsta.c            | 5817 ----
 drivers/staging/otus/80211core/coid.c              | 2696 --
 drivers/staging/otus/80211core/cprecomp.h          |   32 -
 drivers/staging/otus/80211core/cpsmgr.c            |  730 -
 drivers/staging/otus/80211core/cscanmgr.c          |  533 -
 drivers/staging/otus/80211core/ctkip.c             |  599 -
 drivers/staging/otus/80211core/ctxrx.c             | 4115 ---
 drivers/staging/otus/80211core/cwep.c              |  299 -
 drivers/staging/otus/80211core/cwm.c               |  131 -
 drivers/staging/otus/80211core/cwm.h               |   45 -
 drivers/staging/otus/80211core/freqctrl.c          |  259 -
 drivers/staging/otus/80211core/ledmgr.c            |  556 -
 drivers/staging/otus/80211core/performance.c       |  431 -
 drivers/staging/otus/80211core/performance.h       |   97 -
 drivers/staging/otus/80211core/pub_usb.h           |  102 -
 drivers/staging/otus/80211core/pub_zfi.h           |  820 -
 drivers/staging/otus/80211core/pub_zfw.h           |   93 -
 drivers/staging/otus/80211core/queue.c             |  304 -
 drivers/staging/otus/80211core/queue.h             |   37 -
 drivers/staging/otus/80211core/ratectrl.c          |  875 -
 drivers/staging/otus/80211core/ratectrl.h          |   37 -
 drivers/staging/otus/80211core/struct.h            | 1315 -
 drivers/staging/otus/80211core/wlan.h              |  595 -
 drivers/staging/otus/Kconfig                       |   34 -
 drivers/staging/otus/Makefile                      |   67 -
 drivers/staging/otus/TODO                          |    8 -
 drivers/staging/otus/apdbg.c                       |  379 -
 drivers/staging/otus/athr_common.h                 |  141 -
 drivers/staging/otus/hal/hpDKfwu.c                 |  832 -
 drivers/staging/otus/hal/hpani.c                   |  721 -
 drivers/staging/otus/hal/hpani.h                   |  419 -
 drivers/staging/otus/hal/hpfw2.c                   | 1018 -
 drivers/staging/otus/hal/hpfwbu.c                  | 5269 ----
 drivers/staging/otus/hal/hpfwspiu.c                |  655 -
 drivers/staging/otus/hal/hpfwu.c                   | 1017 -
 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend     |  742 -
 drivers/staging/otus/hal/hpfwu_2k.c                | 1016 -
 drivers/staging/otus/hal/hpfwu_BA.c                |  874 -
 drivers/staging/otus/hal/hpfwu_FB50_mdk.c          |  721 -
 drivers/staging/otus/hal/hpfwu_OTUS_RC.c           |  715 -
 drivers/staging/otus/hal/hpfwu_txstream.c          | 1017 -
 drivers/staging/otus/hal/hpfwuinit.c               |  240 -
 drivers/staging/otus/hal/hpmain.c                  | 4672 ----
 drivers/staging/otus/hal/hpreg.c                   | 2270 --
 drivers/staging/otus/hal/hpreg.h                   |  524 -
 drivers/staging/otus/hal/hprw.c                    | 1568 --
 drivers/staging/otus/hal/hpusb.c                   | 1589 --
 drivers/staging/otus/hal/hpusb.h                   |  437 -
 drivers/staging/otus/hal/otus.ini                  |  414 -
 drivers/staging/otus/ioctl.c                       | 2756 --
 drivers/staging/otus/oal_dt.h                      |   60 -
 drivers/staging/otus/oal_marc.h                    |  143 -
 drivers/staging/otus/usbdrv.c                      | 1143 -
 drivers/staging/otus/usbdrv.h                      |  245 -
 drivers/staging/otus/wrap_buf.c                    |  111 -
 drivers/staging/otus/wrap_dbg.c                    |   95 -
 drivers/staging/otus/wrap_ev.c                     |  292 -
 drivers/staging/otus/wrap_mem.c                    |  105 -
 drivers/staging/otus/wrap_mis.c                    |  103 -
 drivers/staging/otus/wrap_pkt.c                    |  147 -
 drivers/staging/otus/wrap_sec.c                    |  125 -
 drivers/staging/otus/wrap_usb.c                    |  187 -
 drivers/staging/otus/wwrap.c                       | 1048 -
 drivers/staging/otus/zdcompat.h                    |   45 -
 drivers/staging/otus/zdusb.c                       |  226 -
 drivers/staging/otus/zdusb.h                       |   47 -
 drivers/staging/phison/phison.c                    |    2 +-
 drivers/staging/pohmelfs/config.c                  |   34 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    2 +-
 drivers/staging/quickstart/quickstart.c            |    7 +-
 drivers/staging/rt2860/Makefile                    |   10 +-
 drivers/staging/rt2860/ap.h                        |   20 +-
 drivers/staging/rt2860/common/ba_action.c          |    5 +-
 drivers/staging/rt2860/common/cmm_mac_usb.c        |    5 +-
 drivers/staging/rt2860/common/cmm_wpa.c            |    4 +-
 drivers/staging/rt2860/common/mlme.c               |    7 +-
 drivers/staging/rt2860/common/rtmp_init.c          |   20 +-
 drivers/staging/rt2860/eeprom.h                    |    4 +-
 drivers/staging/rt2860/iface/rtmp_pci.h            |   42 +-
 drivers/staging/rt2860/iface/rtmp_usb.h            |  110 +-
 drivers/staging/rt2860/oid.h                       |    2 +-
 drivers/staging/rt2860/rt_linux.c                  |    7 +-
 drivers/staging/rt2860/rt_linux.h                  |    3 -
 drivers/staging/rt2860/rtmp.h                      |   26 +-
 drivers/staging/rt2860/sta/assoc.c                 |    7 +-
 drivers/staging/rt2860/sta/connect.c               |   24 +-
 drivers/staging/rt2860/sta/rtmp_data.c             |    5 +-
 drivers/staging/rt2860/sta/sync.c                  |   12 +-
 drivers/staging/rt2860/sta_ioctl.c                 |   11 +-
 drivers/staging/rt2870/Makefile                    |   10 +-
 drivers/staging/rt2870/common/rtusb_io.c           |   11 +-
 drivers/staging/rtl8187se/Makefile                 |   16 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    1 -
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    4 +-
 drivers/staging/rtl8187se/r8180_core.c             |   10 +-
 drivers/staging/rtl8187se/r8180_dm.h               |   12 +-
 drivers/staging/rtl8187se/r8180_hw.h               |  432 +-
 drivers/staging/rtl8187se/r8180_rtl8225.h          |   20 +-
 drivers/staging/rtl8187se/r8180_wx.c               |  722 +-
 drivers/staging/rtl8187se/r8185b_init.c            | 1508 +-
 drivers/staging/rtl8192e/Makefile                  |   14 +-
 drivers/staging/rtl8192e/dot11d.h                  |    8 +-
 drivers/staging/rtl8192e/ieee80211.h               |  213 +-
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |   71 +-
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |    2 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |   18 +-
 drivers/staging/rtl8192e/r8180_93cx6.c             |   13 +-
 drivers/staging/rtl8192e/r8190_rtl8256.c           |    2 -
 drivers/staging/rtl8192e/r8190_rtl8256.h           |   12 +-
 drivers/staging/rtl8192e/r8192E.h                  |    8 +-
 drivers/staging/rtl8192e/r8192E_core.c             | 1423 +-
 drivers/staging/rtl8192e/r8192E_dm.c               |  480 +-
 drivers/staging/rtl8192e/r8192E_dm.h               |    2 -
 drivers/staging/rtl8192e/r8192E_wx.c               |   38 +-
 drivers/staging/rtl8192e/r8192E_wx.h               |    2 +-
 drivers/staging/rtl8192e/r8192_pm.c                |    6 +-
 drivers/staging/rtl8192e/r819xE_cmdpkt.c           |  310 +-
 drivers/staging/rtl8192e/r819xE_cmdpkt.h           |    2 +-
 drivers/staging/rtl8192e/r819xE_firmware.c         |   40 +-
 drivers/staging/rtl8192e/r819xE_phy.c              |   39 +-
 drivers/staging/rtl8192e/r819xE_phy.h              |   50 +-
 drivers/staging/rtl8192su/Kconfig                  |    9 -
 drivers/staging/rtl8192su/Makefile                 |   39 -
 drivers/staging/rtl8192su/TODO                     |   21 -
 drivers/staging/rtl8192su/authors                  |    1 -
 drivers/staging/rtl8192su/ieee80211/Makefile       |   30 -
 drivers/staging/rtl8192su/ieee80211/dot11d.c       |  224 -
 drivers/staging/rtl8192su/ieee80211/dot11d.h       |  111 -
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    | 1934 --
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.c  |  242 -
 .../staging/rtl8192su/ieee80211/ieee80211_crypt.h  |   86 -
 .../rtl8192su/ieee80211/ieee80211_crypt_ccmp.c     |  471 -
 .../rtl8192su/ieee80211/ieee80211_crypt_tkip.c     |  776 -
 .../rtl8192su/ieee80211/ieee80211_crypt_wep.c      |  294 -
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |  301 -
 .../staging/rtl8192su/ieee80211/ieee80211_r8192s.h |  449 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c | 2580 --
 .../rtl8192su/ieee80211/ieee80211_softmac.c        | 3291 ---
 .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |  625 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |  916 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c |  772 -
 drivers/staging/rtl8192su/ieee80211/readme         |  162 -
 drivers/staging/rtl8192su/ieee80211/rtl819x_BA.h   |   79 -
 .../staging/rtl8192su/ieee80211/rtl819x_BAProc.c   |  745 -
 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h   |  530 -
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   | 1725 --
 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h  |  540 -
 drivers/staging/rtl8192su/ieee80211/rtl819x_TS.h   |   71 -
 .../staging/rtl8192su/ieee80211/rtl819x_TSProc.c   |  631 -
 drivers/staging/rtl8192su/r8192SU_HWImg.c          |  647 -
 drivers/staging/rtl8192su/r8192SU_HWImg.h          |   60 -
 drivers/staging/rtl8192su/r8192SU_led.c            | 2338 --
 drivers/staging/rtl8192su/r8192SU_led.h            |   93 -
 drivers/staging/rtl8192su/r8192S_Efuse.c           | 2199 --
 drivers/staging/rtl8192su/r8192S_Efuse.h           |   79 -
 drivers/staging/rtl8192su/r8192S_firmware.c        |  481 -
 drivers/staging/rtl8192su/r8192S_firmware.h        |  210 -
 drivers/staging/rtl8192su/r8192S_hw.h              | 1445 -
 drivers/staging/rtl8192su/r8192S_phy.c             | 3634 ---
 drivers/staging/rtl8192su/r8192S_phy.h             |  135 -
 drivers/staging/rtl8192su/r8192S_phyreg.h          | 1033 -
 drivers/staging/rtl8192su/r8192S_rtl6052.c         |  842 -
 drivers/staging/rtl8192su/r8192S_rtl6052.h         |   87 -
 drivers/staging/rtl8192su/r8192S_rtl8225.c         |  292 -
 drivers/staging/rtl8192su/r8192S_rtl8225.h         |   30 -
 drivers/staging/rtl8192su/r8192U.h                 | 1519 -
 drivers/staging/rtl8192su/r8192U_core.c            | 7712 ------
 drivers/staging/rtl8192su/r8192U_dm.c              | 3982 ---
 drivers/staging/rtl8192su/r8192U_dm.h              |  254 -
 drivers/staging/rtl8192su/r8192U_pm.c              |   72 -
 drivers/staging/rtl8192su/r8192U_pm.h              |   25 -
 drivers/staging/rtl8192su/r8192U_wx.c              | 1296 -
 drivers/staging/rtl8192su/r8192U_wx.h              |   22 -
 drivers/staging/rtl8192su/r819xU_HTGen.h           |   22 -
 drivers/staging/rtl8192su/r819xU_HTType.h          |  383 -
 drivers/staging/rtl8192su/r819xU_cmdpkt.c          |  512 -
 drivers/staging/rtl8192su/r819xU_cmdpkt.h          |  192 -
 drivers/staging/rtl8192u/Makefile                  |   22 +-
 drivers/staging/rtl8192u/ieee80211/Makefile        |   16 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   25 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |    2 +-
 drivers/staging/rtl8712/Kconfig                    |   18 +
 drivers/staging/rtl8712/Makefile                   |   34 +
 drivers/staging/rtl8712/TODO                       |   16 +
 drivers/staging/rtl8712/basic_types.h              |   23 +
 drivers/staging/rtl8712/big_endian.h               |   69 +
 drivers/staging/rtl8712/drv_types.h                |  165 +
 drivers/staging/rtl8712/ethernet.h                 |   23 +
 drivers/staging/rtl8712/farray.h                   |10197 +++++++
 drivers/staging/rtl8712/generic.h                  |  153 +
 drivers/staging/rtl8712/hal_init.c                 |  358 +
 drivers/staging/rtl8712/ieee80211.c                |  454 +
 drivers/staging/rtl8712/ieee80211.h                |  770 +
 drivers/staging/rtl8712/if_ether.h                 |  116 +
 drivers/staging/rtl8712/ip.h                       |  137 +
 drivers/staging/rtl8712/little_endian.h            |   69 +
 drivers/staging/rtl8712/mlme_linux.c               |  170 +
 drivers/staging/rtl8712/mlme_osdep.h               |   18 +
 drivers/staging/rtl8712/mp_custom_oid.h            |  274 +
 drivers/staging/rtl8712/os_intfs.c                 |  464 +
 drivers/staging/rtl8712/osdep_intf.h               |   19 +
 drivers/staging/rtl8712/osdep_service.h            |  257 +
 drivers/staging/rtl8712/recv_linux.c               |  169 +
 drivers/staging/rtl8712/recv_osdep.h               |   27 +
 drivers/staging/rtl8712/rtl8712_bitdef.h           |   19 +
 drivers/staging/rtl8712/rtl8712_cmd.c              |  465 +
 drivers/staging/rtl8712/rtl8712_cmd.h              |  157 +
 drivers/staging/rtl8712/rtl8712_cmdctrl_bitdef.h   |   89 +
 drivers/staging/rtl8712/rtl8712_cmdctrl_regdef.h   |   15 +
 drivers/staging/rtl8712/rtl8712_debugctrl_bitdef.h |   36 +
 drivers/staging/rtl8712/rtl8712_debugctrl_regdef.h |   28 +
 .../staging/rtl8712/rtl8712_edcasetting_bitdef.h   |   52 +
 .../staging/rtl8712/rtl8712_edcasetting_regdef.h   |   18 +
 drivers/staging/rtl8712/rtl8712_efuse.c            |  568 +
 drivers/staging/rtl8712/rtl8712_efuse.h            |   43 +
 drivers/staging/rtl8712/rtl8712_event.h            |   73 +
 drivers/staging/rtl8712/rtl8712_fifoctrl_bitdef.h  |  126 +
 drivers/staging/rtl8712/rtl8712_fifoctrl_regdef.h  |   57 +
 drivers/staging/rtl8712/rtl8712_gp_bitdef.h        |   54 +
 drivers/staging/rtl8712/rtl8712_gp_regdef.h        |   17 +
 drivers/staging/rtl8712/rtl8712_hal.h              |  124 +
 drivers/staging/rtl8712/rtl8712_interrupt_bitdef.h |   39 +
 drivers/staging/rtl8712/rtl8712_io.c               |  151 +
 drivers/staging/rtl8712/rtl8712_led.c              | 1815 ++
 .../staging/rtl8712/rtl8712_macsetting_bitdef.h    |   28 +
 .../staging/rtl8712/rtl8712_macsetting_regdef.h    |   16 +
 drivers/staging/rtl8712/rtl8712_powersave_bitdef.h |   33 +
 drivers/staging/rtl8712/rtl8712_powersave_regdef.h |   20 +
 drivers/staging/rtl8712/rtl8712_ratectrl_bitdef.h  |   30 +
 drivers/staging/rtl8712/rtl8712_ratectrl_regdef.h  |   31 +
 drivers/staging/rtl8712/rtl8712_recv.c             | 1131 +
 drivers/staging/rtl8712/rtl8712_recv.h             |  128 +
 drivers/staging/rtl8712/rtl8712_regdef.h           |   19 +
 drivers/staging/rtl8712/rtl8712_security_bitdef.h  |   29 +
 drivers/staging/rtl8712/rtl8712_spec.h             |  110 +
 drivers/staging/rtl8712/rtl8712_syscfg_bitdef.h    |  145 +
 drivers/staging/rtl8712/rtl8712_syscfg_regdef.h    |   31 +
 drivers/staging/rtl8712/rtl8712_timectrl_bitdef.h  |   44 +
 drivers/staging/rtl8712/rtl8712_timectrl_regdef.h  |   20 +
 drivers/staging/rtl8712/rtl8712_wmac_bitdef.h      |   37 +
 drivers/staging/rtl8712/rtl8712_wmac_regdef.h      |   24 +
 drivers/staging/rtl8712/rtl8712_xmit.c             |  509 +
 drivers/staging/rtl8712/rtl8712_xmit.h             |   95 +
 drivers/staging/rtl8712/rtl871x_byteorder.h        |   13 +
 drivers/staging/rtl8712/rtl871x_cmd.c              |  926 +
 drivers/staging/rtl8712/rtl871x_cmd.h              |  719 +
 drivers/staging/rtl8712/rtl871x_debug.h            |  142 +
 drivers/staging/rtl8712/rtl871x_eeprom.c           |  233 +
 drivers/staging/rtl8712/rtl871x_eeprom.h           |   82 +
 drivers/staging/rtl8712/rtl871x_event.h            |   95 +
 drivers/staging/rtl8712/rtl871x_ht.h               |   19 +
 drivers/staging/rtl8712/rtl871x_io.c               |  163 +
 drivers/staging/rtl8712/rtl871x_io.h               |  233 +
 drivers/staging/rtl8712/rtl871x_ioctl.h            |   97 +
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c      | 2246 ++
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c        |  535 +
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.h        |   96 +
 drivers/staging/rtl8712/rtl871x_ioctl_set.c        |  379 +
 drivers/staging/rtl8712/rtl871x_ioctl_set.h        |   24 +
 drivers/staging/rtl8712/rtl871x_led.h              |   99 +
 drivers/staging/rtl8712/rtl871x_mlme.c             | 1840 ++
 drivers/staging/rtl8712/rtl871x_mlme.h             |  208 +
 drivers/staging/rtl8712/rtl871x_mp.c               |  736 +
 drivers/staging/rtl8712/rtl871x_mp.h               |  318 +
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c         | 1475 +
 drivers/staging/rtl8712/rtl871x_mp_ioctl.h         |  457 +
 drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h    | 1025 +
 drivers/staging/rtl8712/rtl871x_pwrctrl.c          |  250 +
 drivers/staging/rtl8712/rtl871x_pwrctrl.h          |  127 +
 drivers/staging/rtl8712/rtl871x_recv.c             |  693 +
 drivers/staging/rtl8712/rtl871x_recv.h             |  330 +
 drivers/staging/rtl8712/rtl871x_rf.h               |   43 +
 drivers/staging/rtl8712/rtl871x_security.c         | 1389 +
 drivers/staging/rtl8712/rtl871x_security.h         |  196 +
 drivers/staging/rtl8712/rtl871x_sta_mgt.c          |  299 +
 drivers/staging/rtl8712/rtl871x_wlan_sme.h         |   22 +
 drivers/staging/rtl8712/rtl871x_xmit.c             | 1052 +
 drivers/staging/rtl8712/rtl871x_xmit.h             |  260 +
 drivers/staging/rtl8712/sta_info.h                 |  125 +
 drivers/staging/rtl8712/swab.h                     |  106 +
 drivers/staging/rtl8712/usb_halinit.c              |  317 +
 drivers/staging/rtl8712/usb_intf.c                 |  571 +
 drivers/staging/rtl8712/usb_ops.c                  |  201 +
 drivers/staging/rtl8712/usb_ops.h                  |   25 +
 drivers/staging/rtl8712/usb_ops_linux.c            |  529 +
 drivers/staging/rtl8712/usb_osintf.h               |   24 +
 drivers/staging/rtl8712/usb_vendor_req.h           |   33 +
 drivers/staging/rtl8712/wifi.h                     |  622 +
 drivers/staging/rtl8712/wlan_bssdef.h              |  242 +
 drivers/staging/rtl8712/xmit_linux.c               |  182 +
 drivers/staging/rtl8712/xmit_osdep.h               |   38 +
 drivers/staging/sbe-2t3e3/2t3e3.h                  |  894 +
 drivers/staging/sbe-2t3e3/Kconfig                  |   13 +
 drivers/staging/sbe-2t3e3/Makefile                 |    4 +
 drivers/staging/sbe-2t3e3/TODO                     |    6 +
 drivers/staging/sbe-2t3e3/cpld.c                   |  366 +
 drivers/staging/sbe-2t3e3/ctrl.c                   |  362 +
 drivers/staging/sbe-2t3e3/ctrl.h                   |  131 +
 drivers/staging/sbe-2t3e3/dc.c                     |  502 +
 drivers/staging/sbe-2t3e3/exar7250.c               |  217 +
 drivers/staging/sbe-2t3e3/exar7300.c               |  182 +
 drivers/staging/sbe-2t3e3/intr.c                   |  635 +
 drivers/staging/sbe-2t3e3/io.c                     |  352 +
 drivers/staging/sbe-2t3e3/main.c                   |  171 +
 drivers/staging/sbe-2t3e3/maps.c                   |  104 +
 drivers/staging/sbe-2t3e3/module.c                 |  210 +
 drivers/staging/sbe-2t3e3/netdev.c                 |  142 +
 drivers/staging/slicoss/slic.h                     |    8 +-
 drivers/staging/slicoss/slicoss.c                  |   44 +-
 drivers/staging/sm7xx/smtcfb.c                     |   13 +-
 {fs => drivers/staging}/smbfs/Kconfig              |    0
 {fs => drivers/staging}/smbfs/Makefile             |   12 +-
 drivers/staging/smbfs/TODO                         |    8 +
 {fs => drivers/staging}/smbfs/cache.c              |    2 +-
 {fs => drivers/staging}/smbfs/dir.c                |    6 +-
 {fs => drivers/staging}/smbfs/file.c               |    5 +-
 {fs => drivers/staging}/smbfs/getopt.c             |    0
 {fs => drivers/staging}/smbfs/getopt.h             |    0
 {fs => drivers/staging}/smbfs/inode.c              |    8 +-
 {fs => drivers/staging}/smbfs/ioctl.c              |    5 +-
 {fs => drivers/staging}/smbfs/proc.c               |    7 +-
 {fs => drivers/staging}/smbfs/proto.h              |    0
 {fs => drivers/staging}/smbfs/request.c            |    7 +-
 {fs => drivers/staging}/smbfs/request.h            |    0
 {include/linux => drivers/staging/smbfs}/smb.h     |    0
 {fs => drivers/staging}/smbfs/smb_debug.h          |    0
 {include/linux => drivers/staging/smbfs}/smb_fs.h  |    8 +-
 .../linux => drivers/staging/smbfs}/smb_fs_i.h     |    0
 .../linux => drivers/staging/smbfs}/smb_fs_sb.h    |    2 +-
 .../linux => drivers/staging/smbfs}/smb_mount.h    |    0
 .../staging/smbfs}/smbfs.txt                       |    0
 {fs => drivers/staging}/smbfs/smbiod.c             |    7 +-
 {include/linux => drivers/staging/smbfs}/smbno.h   |    0
 {fs => drivers/staging}/smbfs/sock.c               |    7 +-
 {fs => drivers/staging}/smbfs/symlink.c            |    5 +-
 drivers/staging/solo6x10/Makefile                  |    2 +-
 drivers/staging/solo6x10/solo6010-core.c           |   40 +-
 drivers/staging/solo6x10/solo6010-g723.c           |    2 +-
 drivers/staging/solo6x10/solo6010-i2c.c            |    2 +-
 drivers/staging/solo6x10/solo6010-p2m.c            |    2 +-
 drivers/staging/solo6x10/solo6010-v4l2-enc.c       |    2 +-
 drivers/staging/solo6x10/solo6010-v4l2.c           |    2 +-
 drivers/staging/speakup/DefaultKeyAssignments      |   46 +
 drivers/staging/speakup/Kconfig                    |  195 +
 drivers/staging/speakup/Makefile                   |   30 +
 drivers/staging/speakup/TODO                       |   47 +
 drivers/staging/speakup/buffers.c                  |  107 +
 drivers/staging/speakup/devsynth.c                 |   94 +
 drivers/staging/speakup/fakekey.c                  |  105 +
 drivers/staging/speakup/i18n.c                     |  628 +
 drivers/staging/speakup/i18n.h                     |  228 +
 drivers/staging/speakup/keyhelp.c                  |  214 +
 drivers/staging/speakup/kobjects.c                 | 1022 +
 drivers/staging/speakup/main.c                     | 2310 ++
 drivers/staging/speakup/selection.c                |  151 +
 drivers/staging/speakup/serialio.c                 |  215 +
 drivers/staging/speakup/serialio.h                 |   55 +
 drivers/staging/speakup/speakup.h                  |  130 +
 drivers/staging/speakup/speakup_acnt.h             |   16 +
 drivers/staging/speakup/speakup_acntpc.c           |  335 +
 drivers/staging/speakup/speakup_acntsa.c           |  163 +
 drivers/staging/speakup/speakup_apollo.c           |  227 +
 drivers/staging/speakup/speakup_audptr.c           |  195 +
 drivers/staging/speakup/speakup_bns.c              |  147 +
 drivers/staging/speakup/speakup_decext.c           |  253 +
 drivers/staging/speakup/speakup_decpc.c            |  504 +
 drivers/staging/speakup/speakup_dectlk.c           |  322 +
 drivers/staging/speakup/speakup_dtlk.c             |  402 +
 drivers/staging/speakup/speakup_dtlk.h             |   54 +
 drivers/staging/speakup/speakup_dummy.c            |  148 +
 drivers/staging/speakup/speakup_keypc.c            |  335 +
 drivers/staging/speakup/speakup_ltlk.c             |  194 +
 drivers/staging/speakup/speakup_soft.c             |  379 +
 drivers/staging/speakup/speakup_spkout.c           |  165 +
 drivers/staging/speakup/speakup_txprt.c            |  147 +
 drivers/staging/speakup/speakupmap.h               |   65 +
 drivers/staging/speakup/speakupmap.map             |   93 +
 drivers/staging/speakup/spk_priv.h                 |   93 +
 drivers/staging/speakup/spk_priv_keyinfo.h         |  110 +
 drivers/staging/speakup/spk_types.h                |  193 +
 drivers/staging/speakup/spkguide.txt               | 1575 ++
 drivers/staging/speakup/synth.c                    |  463 +
 drivers/staging/speakup/thread.c                   |   58 +
 drivers/staging/speakup/varhandlers.c              |  404 +
 drivers/staging/spectra/Kconfig                    |    2 +-
 drivers/staging/spectra/flash.c                    |    2 +-
 drivers/staging/spectra/flash.h                    |    2 +-
 drivers/staging/spectra/lld_emu.c                  |   10 +-
 drivers/staging/spectra/lld_mtd.c                  |    8 +-
 drivers/staging/spectra/lld_nand.c                 |    7 +-
 drivers/staging/ti-st/Kconfig                      |   13 +-
 drivers/staging/ti-st/Makefile                     |    2 -
 drivers/staging/ti-st/bt_drv.c                     |    2 +-
 drivers/staging/ti-st/fm.h                         |   13 -
 drivers/staging/ti-st/st.h                         |   83 -
 drivers/staging/ti-st/st_core.h                    |  128 -
 drivers/staging/ti-st/st_kim.h                     |  180 -
 drivers/staging/ti-st/st_ll.h                      |   69 -
 drivers/staging/tidspbridge/Kconfig                |    1 +
 drivers/staging/tidspbridge/Makefile               |   13 +-
 drivers/staging/tidspbridge/TODO                   |    1 +
 drivers/staging/tidspbridge/core/_deh.h            |    5 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   19 +-
 drivers/staging/tidspbridge/core/chnl_sm.c         |    1 -
 drivers/staging/tidspbridge/core/dsp-clock.c       |    1 -
 drivers/staging/tidspbridge/core/dsp-mmu.c         |  317 +
 drivers/staging/tidspbridge/core/io_sm.c           |  181 +-
 .../staging/tidspbridge/{services => core}/sync.c  |   17 +
 drivers/staging/tidspbridge/core/tiomap3430.c      | 1088 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |   22 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |   22 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |  115 +-
 drivers/staging/tidspbridge/gen/gb.c               |    1 -
 drivers/staging/tidspbridge/gen/gs.c               |    1 -
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 -
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 -
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 -
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 -
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  562 -
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  163 -
 .../staging/tidspbridge/include/dspbridge/cfg.h    |  222 -
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 -
 .../staging/tidspbridge/include/dspbridge/cmm.h    |   19 -
 .../staging/tidspbridge/include/dspbridge/dev.h    |   24 -
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 -
 .../staging/tidspbridge/include/dspbridge/drv.h    |   12 +-
 .../tidspbridge/include/dspbridge/dsp-mmu.h        |   67 +
 .../tidspbridge/include/dspbridge/dspdefs.h        |   44 -
 .../tidspbridge/include/dspbridge/dspioctl.h       |    7 -
 .../tidspbridge/include/dspbridge/host_os.h        |   19 -
 .../staging/tidspbridge/include/dspbridge/mgr.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/proc.h   |   46 -
 .../tidspbridge/include/dspbridge/services.h       |   50 -
 .../staging/tidspbridge/include/dspbridge/wdt.h    |    2 +-
 drivers/staging/tidspbridge/pmgr/chnl.c            |    1 -
 drivers/staging/tidspbridge/pmgr/cmm.c             |   18 -
 drivers/staging/tidspbridge/pmgr/dbll.c            |    2 +-
 drivers/staging/tidspbridge/pmgr/dev.c             |  132 +-
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 -
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   62 +-
 drivers/staging/tidspbridge/pmgr/io.c              |    3 -
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    8 +
 drivers/staging/tidspbridge/rmgr/drv.c             |   74 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |   29 +-
 drivers/staging/tidspbridge/rmgr/dspdrv.c          |   12 +-
 drivers/staging/tidspbridge/rmgr/mgr.c             |   52 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |   17 +-
 drivers/staging/tidspbridge/rmgr/node.c            |   58 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |  245 +-
 drivers/staging/tidspbridge/rmgr/strm.c            |   12 +-
 drivers/staging/tidspbridge/services/cfg.c         |  253 -
 drivers/staging/tidspbridge/services/ntfy.c        |   31 -
 drivers/staging/tidspbridge/services/services.c    |   70 -
 drivers/staging/tm6000/Makefile                    |   10 +-
 drivers/staging/tm6000/tm6000-alsa.c               |    7 +-
 drivers/staging/tm6000/tm6000-core.c               |    6 +-
 drivers/staging/udlfb/udlfb.c                      |  987 +-
 drivers/staging/udlfb/udlfb.h                      |   39 +-
 drivers/staging/udlfb/udlfb.txt                    |  144 +
 drivers/staging/usbip/Makefile                     |   11 +-
 drivers/staging/usbip/stub_dev.c                   |    2 +-
 drivers/staging/usbip/usbip_common.c               |    2 +-
 drivers/staging/usbip/usbip_event.c                |   16 +-
 drivers/staging/usbip/vhci_hcd.c                   |    2 +
 drivers/staging/vme/bridges/vme_ca91cx42.c         |   94 +-
 drivers/staging/vme/devices/vme_user.c             |    2 +-
 drivers/staging/vt6655/Makefile                    |    4 +-
 drivers/staging/vt6655/device_main.c               |    3 +-
 drivers/staging/vt6655/iocmd.h                     |    4 -
 drivers/staging/vt6655/iwctl.c                     |    6 +-
 drivers/staging/vt6655/ttype.h                     |    7 -
 drivers/staging/vt6655/vntwifi.c                   |    6 +-
 drivers/staging/vt6656/80211mgr.h                  |   10 +-
 drivers/staging/vt6656/Makefile                    |    4 +-
 drivers/staging/vt6656/baseband.c                  |    2 -
 drivers/staging/vt6656/bssdb.c                     |   14 +-
 drivers/staging/vt6656/card.c                      |    2 +-
 drivers/staging/vt6656/channel.c                   |   12 +-
 drivers/staging/vt6656/device.h                    |   19 +-
 drivers/staging/vt6656/dpc.c                       |   17 +-
 drivers/staging/vt6656/firmware.c                  |    6 +-
 drivers/staging/vt6656/iocmd.h                     |    4 -
 drivers/staging/vt6656/ioctl.c                     |    2 +-
 drivers/staging/vt6656/iwctl.c                     |   20 +-
 drivers/staging/vt6656/iwctl.h                     |    3 -
 drivers/staging/vt6656/key.c                       |    2 +-
 drivers/staging/vt6656/mac.c                       |   12 +-
 drivers/staging/vt6656/main_usb.c                  |   29 +-
 drivers/staging/vt6656/power.c                     |    6 +-
 drivers/staging/vt6656/rxtx.c                      |   26 +-
 drivers/staging/vt6656/tether.h                    |   32 +-
 drivers/staging/vt6656/usbpipe.c                   |   52 +-
 drivers/staging/vt6656/wcmd.c                      |    4 +-
 drivers/staging/vt6656/wmgr.c                      |   19 +-
 drivers/staging/vt6656/wmgr.h                      |    2 +-
 drivers/staging/vt6656/wpa.c                       |    8 +-
 drivers/staging/vt6656/wpactl.c                    |    6 +-
 drivers/staging/westbridge/Kconfig                 |   53 +
 drivers/staging/westbridge/TODO                    |    7 +
 drivers/staging/westbridge/astoria/Kconfig         |    9 +
 drivers/staging/westbridge/astoria/Makefile        |   11 +
 drivers/staging/westbridge/astoria/api/Makefile    |   14 +
 .../staging/westbridge/astoria/api/src/cyasdma.c   | 1107 +
 .../staging/westbridge/astoria/api/src/cyasintr.c  |  143 +
 .../westbridge/astoria/api/src/cyaslep2pep.c       |  358 +
 .../westbridge/astoria/api/src/cyaslowlevel.c      | 1264 +
 .../staging/westbridge/astoria/api/src/cyasmisc.c  | 3474 +++
 .../staging/westbridge/astoria/api/src/cyasmtp.c   | 1128 +
 .../westbridge/astoria/api/src/cyasstorage.c       | 4104 +++
 .../staging/westbridge/astoria/api/src/cyasusb.c   | 3718 +++
 .../arch/arm/mach-omap2/cyashalomap_kernel.c       | 2450 ++
 .../plat-omap/include/mach/westbridge/cyashaldef.h |   55 +
 .../cyashalomap_kernel.h                           |  319 +
 .../westbridge-omap3-pnand-hal/cyasmemmap.h        |  558 +
 .../cyasomapdev_kernel.h                           |   72 +
 drivers/staging/westbridge/astoria/block/Kconfig   |    9 +
 drivers/staging/westbridge/astoria/block/Makefile  |   11 +
 .../westbridge/astoria/block/cyasblkdev_block.c    | 1628 ++
 .../westbridge/astoria/block/cyasblkdev_queue.c    |  417 +
 .../westbridge/astoria/block/cyasblkdev_queue.h    |   64 +
 drivers/staging/westbridge/astoria/device/Kconfig  |    9 +
 drivers/staging/westbridge/astoria/device/Makefile |   23 +
 .../westbridge/astoria/device/cyandevice_export.h  |  132 +
 .../staging/westbridge/astoria/device/cyasdevice.c |  412 +
 drivers/staging/westbridge/astoria/gadget/Kconfig  |    9 +
 drivers/staging/westbridge/astoria/gadget/Makefile |   11 +
 .../staging/westbridge/astoria/gadget/cyasgadget.c | 2176 ++
 .../staging/westbridge/astoria/gadget/cyasgadget.h |  193 +
 .../westbridge/astoria/gadget/cyasgadget_ioctl.h   |   99 +
 .../astoria/include/linux/westbridge/cyanerr.h     |  418 +
 .../astoria/include/linux/westbridge/cyanmedia.h   |   59 +
 .../astoria/include/linux/westbridge/cyanmisc.h    |  614 +
 .../astoria/include/linux/westbridge/cyanregs.h    |  180 +
 .../include/linux/westbridge/cyansdkversion.h      |   30 +
 .../astoria/include/linux/westbridge/cyanstorage.h |  419 +
 .../astoria/include/linux/westbridge/cyantioch.h   |   35 +
 .../astoria/include/linux/westbridge/cyantypes.h   |   31 +
 .../astoria/include/linux/westbridge/cyanusb.h     |  619 +
 .../include/linux/westbridge/cyas_cplus_end.h      |   11 +
 .../include/linux/westbridge/cyas_cplus_start.h    |   11 +
 .../astoria/include/linux/westbridge/cyascast.h    |   35 +
 .../astoria/include/linux/westbridge/cyasdevice.h  | 1057 +
 .../astoria/include/linux/westbridge/cyasdma.h     |  375 +
 .../astoria/include/linux/westbridge/cyaserr.h     | 1094 +
 .../astoria/include/linux/westbridge/cyashal.h     |  108 +
 .../astoria/include/linux/westbridge/cyashalcb.h   |   44 +
 .../astoria/include/linux/westbridge/cyashaldoc.h  |  800 +
 .../astoria/include/linux/westbridge/cyasintr.h    |  104 +
 .../astoria/include/linux/westbridge/cyaslep2pep.h |   36 +
 .../include/linux/westbridge/cyaslowlevel.h        |  366 +
 .../astoria/include/linux/westbridge/cyasmedia.h   |   54 +
 .../astoria/include/linux/westbridge/cyasmisc.h    | 1549 ++
 .../include/linux/westbridge/cyasmisc_dep.h        |   53 +
 .../astoria/include/linux/westbridge/cyasmtp.h     |  646 +
 .../include/linux/westbridge/cyasprotocol.h        | 3838 +++
 .../astoria/include/linux/westbridge/cyasregs.h    |  201 +
 .../astoria/include/linux/westbridge/cyasstorage.h | 2759 ++
 .../include/linux/westbridge/cyasstorage_dep.h     |  309 +
 .../astoria/include/linux/westbridge/cyastoria.h   |   36 +
 .../include/linux/westbridge/cyastsdkversion.h     |   30 +
 .../astoria/include/linux/westbridge/cyastypes.h   |   71 +
 .../astoria/include/linux/westbridge/cyasusb.h     | 1862 ++
 .../astoria/include/linux/westbridge/cyasusb_dep.h |  224 +
 drivers/staging/winbond/Makefile                   |    2 +-
 drivers/staging/winbond/TODO                       |    2 +-
 drivers/staging/winbond/core.h                     |   43 +-
 drivers/staging/winbond/mac_structures.h           |   17 -
 drivers/staging/winbond/mds.c                      |  207 +-
 drivers/staging/winbond/mds_f.h                    |    2 +-
 drivers/staging/winbond/mds_s.h                    |    1 -
 drivers/staging/winbond/mlme_s.h                   |  188 -
 drivers/staging/winbond/mlmetxrx.c                 |   31 -
 drivers/staging/winbond/mlmetxrx_f.h               |    2 -
 drivers/staging/winbond/phy_calibration.c          |   20 -
 drivers/staging/winbond/scan_s.h                   |  110 -
 drivers/staging/winbond/wb35rx.c                   |    2 +-
 drivers/staging/winbond/wb35tx.c                   |    2 +-
 drivers/staging/winbond/wbhal_f.h                  |   10 -
 drivers/staging/winbond/wbhal_s.h                  |   37 +-
 drivers/staging/winbond/wbusb.c                    |   21 +-
 drivers/staging/wlags49_h2/Makefile                |   10 +-
 drivers/staging/wlags49_h2/hcf.c                   |    1 +
 drivers/staging/wlags49_h2/hcfdef.h                |    8 -
 drivers/staging/wlags49_h2/mdd.h                   |    2 +-
 drivers/staging/wlags49_h2/wl_main.c               |   88 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |    5 +-
 drivers/staging/wlags49_h2/wl_util.c               |   72 +-
 drivers/staging/wlags49_h2/wl_util.h               |    5 -
 drivers/staging/wlags49_h2/wl_wext.c               |    9 +-
 drivers/staging/wlags49_h25/Makefile               |   10 +-
 drivers/staging/wlan-ng/Makefile                   |    2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |    2 +-
 drivers/staging/xgifb/Makefile                     |    2 +-
 drivers/staging/xgifb/XGI_accel.h                  |    3 +-
 drivers/staging/xgifb/XGI_main.h                   |   30 +-
 drivers/staging/xgifb/XGI_main_26.c                | 3876 ++--
 drivers/staging/xgifb/vb_ext.c                     | 1737 +-
 drivers/staging/xgifb/vb_init.c                    | 5022 ++--
 drivers/staging/xgifb/vb_setmode.c                 |17041 ++++++-------
 drivers/staging/xgifb/vb_table.h                   |  620 +-
 drivers/staging/xgifb/vb_util.c                    |  192 +-
 drivers/staging/zram/Kconfig                       |   12 -
 drivers/staging/zram/Makefile                      |    2 +-
 drivers/staging/zram/zram.txt                      |   58 +-
 drivers/staging/zram/zram_drv.c                    |  219 +-
 drivers/staging/zram/zram_drv.h                    |   57 +-
 drivers/staging/zram/zram_ioctl.h                  |   41 -
 drivers/staging/zram/zram_sysfs.c                  |  224 +
 fs/Kconfig                                         |    2 -
 fs/Makefile                                        |    2 -
 fs/compat.c                                        |   31 +-
 fs/compat_ioctl.c                                  |   29 +-
 include/linux/Kbuild                               |    4 -
 include/linux/ti_wilink_st.h                       |  400 +
 include/linux/tty.h                                |    1 +
 1363 files changed, 421106 insertions(+), 148539 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-zram
 create mode 100644 arch/arm/mach-omap2/dsp.c
 create mode 100644 arch/arm/plat-omap/include/plat/dsp.h
 create mode 100644 drivers/misc/ti-st/Kconfig
 create mode 100644 drivers/misc/ti-st/Makefile
 rename drivers/{staging => misc}/ti-st/st_core.c (93%)
 rename drivers/{staging => misc}/ti-st/st_kim.c (97%)
 rename drivers/{staging => misc}/ti-st/st_ll.c (95%)
 create mode 100644 drivers/staging/ath6kl/Kconfig
 create mode 100644 drivers/staging/ath6kl/Makefile
 create mode 100644 drivers/staging/ath6kl/TODO
 create mode 100644 drivers/staging/ath6kl/bmi/include/bmi_internal.h
 create mode 100644 drivers/staging/ath6kl/bmi/src/bmi.c
 create mode 100644 drivers/staging/ath6kl/hif/common/hif_sdio_common.h
 create mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/include/hif_internal.h
 create mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
 create mode 100644 drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k.h
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c
 create mode 100644 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc_debug.h
 create mode 100644 drivers/staging/ath6kl/htc2/htc_internal.h
 create mode 100644 drivers/staging/ath6kl/htc2/htc_recv.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc_send.c
 create mode 100644 drivers/staging/ath6kl/htc2/htc_services.c
 create mode 100644 drivers/staging/ath6kl/include/a_config.h
 create mode 100644 drivers/staging/ath6kl/include/a_debug.h
 create mode 100644 drivers/staging/ath6kl/include/a_drv.h
 create mode 100644 drivers/staging/ath6kl/include/a_drv_api.h
 create mode 100644 drivers/staging/ath6kl/include/a_osapi.h
 create mode 100644 drivers/staging/ath6kl/include/a_types.h
 create mode 100644 drivers/staging/ath6kl/include/aggr_recv_api.h
 create mode 100644 drivers/staging/ath6kl/include/ar3kconfig.h
 create mode 100644 drivers/staging/ath6kl/include/ar6000_api.h
 create mode 100644 drivers/staging/ath6kl/include/ar6000_diag.h
 create mode 100644 drivers/staging/ath6kl/include/ar6kap_common.h
 create mode 100644 drivers/staging/ath6kl/include/athbtfilter.h
 create mode 100644 drivers/staging/ath6kl/include/athendpack.h
 create mode 100644 drivers/staging/ath6kl/include/athstartpack.h
 create mode 100644 drivers/staging/ath6kl/include/bmi.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6002_regdump.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/AR6K_version.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/addrs.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_intf_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/analog_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/apb_map.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/gpio_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/mbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/rtc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/si_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/uart_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw2.0/hw/vmc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_ares_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_athr_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/analog_intf_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_athr_wlan_map.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/apb_map.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/bb_lc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/efuse_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_athr_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/gpio_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_dma_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mac_pcu_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_host_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/mbox_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rdma_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/rtc_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/si_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/uart_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/umbox_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/AR6002/hw4.0/hw/vmc_wlan_reg.h
 create mode 100644 drivers/staging/ath6kl/include/common/a_hci.h
 create mode 100644 drivers/staging/ath6kl/include/common/athdefs.h
 create mode 100644 drivers/staging/ath6kl/include/common/bmi_msg.h
 create mode 100644 drivers/staging/ath6kl/include/common/btcoexGpio.h
 create mode 100644 drivers/staging/ath6kl/include/common/cnxmgmt.h
 create mode 100644 drivers/staging/ath6kl/include/common/dbglog.h
 create mode 100644 drivers/staging/ath6kl/include/common/dbglog_id.h
 create mode 100644 drivers/staging/ath6kl/include/common/discovery.h
 create mode 100644 drivers/staging/ath6kl/include/common/dset_internal.h
 create mode 100644 drivers/staging/ath6kl/include/common/dsetid.h
 create mode 100644 drivers/staging/ath6kl/include/common/epping_test.h
 create mode 100644 drivers/staging/ath6kl/include/common/gmboxif.h
 create mode 100644 drivers/staging/ath6kl/include/common/gpio.h
 create mode 100644 drivers/staging/ath6kl/include/common/htc.h
 create mode 100644 drivers/staging/ath6kl/include/common/htc_services.h
 create mode 100644 drivers/staging/ath6kl/include/common/ini_dset.h
 create mode 100644 drivers/staging/ath6kl/include/common/pkt_log.h
 create mode 100644 drivers/staging/ath6kl/include/common/regDb.h
 create mode 100644 drivers/staging/ath6kl/include/common/regdump.h
 create mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbschema.h
 create mode 100644 drivers/staging/ath6kl/include/common/regulatory/reg_dbvalues.h
 create mode 100644 drivers/staging/ath6kl/include/common/roaming.h
 create mode 100644 drivers/staging/ath6kl/include/common/targaddrs.h
 create mode 100644 drivers/staging/ath6kl/include/common/testcmd.h
 create mode 100644 drivers/staging/ath6kl/include/common/tlpm.h
 create mode 100644 drivers/staging/ath6kl/include/common/wlan_defs.h
 create mode 100644 drivers/staging/ath6kl/include/common/wlan_dset.h
 create mode 100644 drivers/staging/ath6kl/include/common/wmi.h
 create mode 100644 drivers/staging/ath6kl/include/common/wmi_thin.h
 create mode 100644 drivers/staging/ath6kl/include/common/wmix.h
 create mode 100644 drivers/staging/ath6kl/include/common_drv.h
 create mode 100644 drivers/staging/ath6kl/include/dbglog_api.h
 create mode 100644 drivers/staging/ath6kl/include/dl_list.h
 create mode 100644 drivers/staging/ath6kl/include/dset_api.h
 create mode 100644 drivers/staging/ath6kl/include/gpio_api.h
 create mode 100644 drivers/staging/ath6kl/include/hci_transport_api.h
 create mode 100644 drivers/staging/ath6kl/include/hif.h
 create mode 100644 drivers/staging/ath6kl/include/host_version.h
 create mode 100644 drivers/staging/ath6kl/include/htc_api.h
 create mode 100644 drivers/staging/ath6kl/include/htc_packet.h
 create mode 100644 drivers/staging/ath6kl/include/target_reg_table.h
 create mode 100644 drivers/staging/ath6kl/include/wlan_api.h
 create mode 100644 drivers/staging/ath6kl/include/wmi_api.h
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kconfig.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h
 create mode 100644 drivers/staging/ath6kl/miscdrv/common_drv.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/credit_dist.c
 create mode 100644 drivers/staging/ath6kl/miscdrv/miscdrv.h
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_android.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_drv.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_pm.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c
 create mode 100644 drivers/staging/ath6kl/os/linux/ar6k_pal.c
 create mode 100644 drivers/staging/ath6kl/os/linux/cfg80211.c
 create mode 100644 drivers/staging/ath6kl/os/linux/eeprom.c
 create mode 100644 drivers/staging/ath6kl/os/linux/export_hci_transport.c
 create mode 100644 drivers/staging/ath6kl/os/linux/hci_bridge.c
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ar6k_pal.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athendpack_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athstartpack_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/athtypes_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/cfg80211.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/config_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/debug_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/export_hci_transport.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/ieee80211_ioctl.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/osapi_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/wlan_config.h
 create mode 100644 drivers/staging/ath6kl/os/linux/include/wmi_filter_linux.h
 create mode 100644 drivers/staging/ath6kl/os/linux/ioctl.c
 create mode 100644 drivers/staging/ath6kl/os/linux/netbuf.c
 create mode 100644 drivers/staging/ath6kl/os/linux/wireless_ext.c
 create mode 100644 drivers/staging/ath6kl/reorder/aggr_rx_internal.h
 create mode 100644 drivers/staging/ath6kl/reorder/rcv_aggr.c
 create mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211.h
 create mode 100644 drivers/staging/ath6kl/wlan/include/ieee80211_node.h
 create mode 100644 drivers/staging/ath6kl/wlan/src/wlan_node.c
 create mode 100644 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c
 create mode 100644 drivers/staging/ath6kl/wlan/src/wlan_utils.c
 create mode 100644 drivers/staging/ath6kl/wmi/wmi.c
 create mode 100644 drivers/staging/ath6kl/wmi/wmi_host.h
 rename {fs => drivers/staging}/autofs/Kconfig (100%)
 rename {fs => drivers/staging}/autofs/Makefile (59%)
 create mode 100644 drivers/staging/autofs/TODO
 rename {fs => drivers/staging}/autofs/autofs_i.h (99%)
 rename {fs => drivers/staging}/autofs/dirhash.c (99%)
 rename {fs => drivers/staging}/autofs/init.c (97%)
 rename {fs => drivers/staging}/autofs/inode.c (99%)
 rename {fs => drivers/staging}/autofs/root.c (99%)
 rename {fs => drivers/staging}/autofs/symlink.c (95%)
 rename {fs => drivers/staging}/autofs/waitq.c (99%)
 delete mode 100644 drivers/staging/batman-adv/CHANGELOG
 create mode 100644 drivers/staging/batman-adv/unicast.c
 create mode 100644 drivers/staging/batman-adv/unicast.h
 create mode 100644 drivers/staging/bcm/Adapter.h
 create mode 100644 drivers/staging/bcm/Arp.c
 create mode 100644 drivers/staging/bcm/Bcmchar.c
 create mode 100644 drivers/staging/bcm/Bcmnet.c
 create mode 100644 drivers/staging/bcm/CmHost.c
 create mode 100644 drivers/staging/bcm/CmHost.h
 create mode 100644 drivers/staging/bcm/DDRInit.c
 create mode 100644 drivers/staging/bcm/DDRInit.h
 create mode 100644 drivers/staging/bcm/Debug.c
 create mode 100644 drivers/staging/bcm/Debug.h
 create mode 100644 drivers/staging/bcm/HandleControlPacket.c
 create mode 100644 drivers/staging/bcm/HostMIBSInterface.h
 create mode 100644 drivers/staging/bcm/HostMibs.h
 create mode 100644 drivers/staging/bcm/IPv6Protocol.c
 create mode 100644 drivers/staging/bcm/IPv6ProtocolHdr.h
 create mode 100644 drivers/staging/bcm/InterfaceAdapter.h
 create mode 100644 drivers/staging/bcm/InterfaceDld.c
 create mode 100644 drivers/staging/bcm/InterfaceIdleMode.c
 create mode 100644 drivers/staging/bcm/InterfaceIdleMode.h
 create mode 100644 drivers/staging/bcm/InterfaceInit.c
 create mode 100644 drivers/staging/bcm/InterfaceInit.h
 create mode 100644 drivers/staging/bcm/InterfaceIsr.c
 create mode 100644 drivers/staging/bcm/InterfaceIsr.h
 create mode 100644 drivers/staging/bcm/InterfaceMacros.h
 create mode 100644 drivers/staging/bcm/InterfaceMisc.c
 create mode 100644 drivers/staging/bcm/InterfaceMisc.h
 create mode 100644 drivers/staging/bcm/InterfaceRx.c
 create mode 100644 drivers/staging/bcm/InterfaceRx.h
 create mode 100644 drivers/staging/bcm/InterfaceTx.c
 create mode 100644 drivers/staging/bcm/InterfaceTx.h
 create mode 100644 drivers/staging/bcm/Interfacemain.h
 create mode 100644 drivers/staging/bcm/Ioctl.h
 create mode 100644 drivers/staging/bcm/Kconfig
 create mode 100644 drivers/staging/bcm/LeakyBucket.c
 create mode 100644 drivers/staging/bcm/Macros.h
 create mode 100644 drivers/staging/bcm/Makefile
 create mode 100644 drivers/staging/bcm/Misc.c
 create mode 100644 drivers/staging/bcm/Osal_Misc.c
 create mode 100644 drivers/staging/bcm/PHSDefines.h
 create mode 100644 drivers/staging/bcm/PHSModule.c
 create mode 100644 drivers/staging/bcm/PHSModule.h
 create mode 100644 drivers/staging/bcm/Protocol.h
 create mode 100644 drivers/staging/bcm/Prototypes.h
 create mode 100644 drivers/staging/bcm/Qos.c
 create mode 100644 drivers/staging/bcm/Queue.h
 create mode 100644 drivers/staging/bcm/TODO
 create mode 100644 drivers/staging/bcm/Transmit.c
 create mode 100644 drivers/staging/bcm/Typedefs.h
 create mode 100644 drivers/staging/bcm/Version.h
 create mode 100644 drivers/staging/bcm/cntrl_SignalingInterface.h
 create mode 100644 drivers/staging/bcm/headers.h
 create mode 100644 drivers/staging/bcm/hostmibs.c
 create mode 100644 drivers/staging/bcm/led_control.c
 create mode 100644 drivers/staging/bcm/led_control.h
 create mode 100644 drivers/staging/bcm/nvm.c
 create mode 100644 drivers/staging/bcm/nvm.h
 create mode 100644 drivers/staging/bcm/osal_misc.h
 create mode 100644 drivers/staging/bcm/sort.c
 create mode 100644 drivers/staging/bcm/target_params.h
 create mode 100644 drivers/staging/bcm/vendorspecificextn.c
 create mode 100644 drivers/staging/bcm/vendorspecificextn.h
 create mode 100644 drivers/staging/brcm80211/Kconfig
 create mode 100644 drivers/staging/brcm80211/Makefile
 create mode 100644 drivers/staging/brcm80211/README
 create mode 100644 drivers/staging/brcm80211/TODO
 create mode 100644 drivers/staging/brcm80211/brcmfmac/Kconfig
 create mode 100644 drivers/staging/brcm80211/brcmfmac/Makefile
 create mode 100644 drivers/staging/brcm80211/brcmfmac/README
 create mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd.h
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_bus.h
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_common.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_linux.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_linux_sched.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_proto.h
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/dngl_stats.h
 create mode 100644 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
 create mode 100644 drivers/staging/brcm80211/brcmfmac/wl_iw.c
 create mode 100644 drivers/staging/brcm80211/brcmfmac/wl_iw.h
 create mode 100644 drivers/staging/brcm80211/include/aidmp.h
 create mode 100644 drivers/staging/brcm80211/include/bcm_rpc.h
 create mode 100644 drivers/staging/brcm80211/include/bcm_rpc_tp.h
 create mode 100644 drivers/staging/brcm80211/include/bcm_xdr.h
 create mode 100644 drivers/staging/brcm80211/include/bcmcdc.h
 create mode 100644 drivers/staging/brcm80211/include/bcmdefs.h
 create mode 100644 drivers/staging/brcm80211/include/bcmdevs.h
 create mode 100644 drivers/staging/brcm80211/include/bcmendian.h
 create mode 100644 drivers/staging/brcm80211/include/bcmnvram.h
 create mode 100644 drivers/staging/brcm80211/include/bcmotp.h
 create mode 100644 drivers/staging/brcm80211/include/bcmsdbus.h
 create mode 100644 drivers/staging/brcm80211/include/bcmsdh.h
 create mode 100644 drivers/staging/brcm80211/include/bcmsdh_sdmmc.h
 create mode 100644 drivers/staging/brcm80211/include/bcmsdpcm.h
 create mode 100644 drivers/staging/brcm80211/include/bcmsrom.h
 create mode 100644 drivers/staging/brcm80211/include/bcmsrom_fmt.h
 create mode 100644 drivers/staging/brcm80211/include/bcmsrom_tbl.h
 create mode 100644 drivers/staging/brcm80211/include/bcmutils.h
 create mode 100644 drivers/staging/brcm80211/include/bcmwifi.h
 create mode 100644 drivers/staging/brcm80211/include/d11.h
 create mode 100644 drivers/staging/brcm80211/include/dbus.h
 create mode 100644 drivers/staging/brcm80211/include/dhdioctl.h
 create mode 100644 drivers/staging/brcm80211/include/epivers.h
 create mode 100644 drivers/staging/brcm80211/include/hnddma.h
 create mode 100644 drivers/staging/brcm80211/include/hndpmu.h
 create mode 100644 drivers/staging/brcm80211/include/hndrte_armtrap.h
 create mode 100644 drivers/staging/brcm80211/include/hndrte_cons.h
 create mode 100644 drivers/staging/brcm80211/include/hndsoc.h
 create mode 100644 drivers/staging/brcm80211/include/linux_osl.h
 create mode 100644 drivers/staging/brcm80211/include/linuxver.h
 create mode 100644 drivers/staging/brcm80211/include/msgtrace.h
 create mode 100644 drivers/staging/brcm80211/include/nicpci.h
 create mode 100644 drivers/staging/brcm80211/include/osl.h
 create mode 100644 drivers/staging/brcm80211/include/packed_section_end.h
 create mode 100644 drivers/staging/brcm80211/include/packed_section_start.h
 create mode 100644 drivers/staging/brcm80211/include/pci_core.h
 create mode 100644 drivers/staging/brcm80211/include/pcicfg.h
 create mode 100644 drivers/staging/brcm80211/include/pcie_core.h
 create mode 100644 drivers/staging/brcm80211/include/proto/802.11.h
 create mode 100644 drivers/staging/brcm80211/include/proto/802.1d.h
 create mode 100644 drivers/staging/brcm80211/include/proto/bcmeth.h
 create mode 100644 drivers/staging/brcm80211/include/proto/bcmevent.h
 create mode 100644 drivers/staging/brcm80211/include/proto/ethernet.h
 create mode 100644 drivers/staging/brcm80211/include/proto/wpa.h
 create mode 100644 drivers/staging/brcm80211/include/qmath.h
 create mode 100644 drivers/staging/brcm80211/include/rpc_osl.h
 create mode 100644 drivers/staging/brcm80211/include/sbchipc.h
 create mode 100644 drivers/staging/brcm80211/include/sbconfig.h
 create mode 100644 drivers/staging/brcm80211/include/sbhnddma.h
 create mode 100644 drivers/staging/brcm80211/include/sbhndpio.h
 create mode 100644 drivers/staging/brcm80211/include/sbpcmcia.h
 create mode 100644 drivers/staging/brcm80211/include/sbsdio.h
 create mode 100644 drivers/staging/brcm80211/include/sbsdpcmdev.h
 create mode 100644 drivers/staging/brcm80211/include/sbsocram.h
 create mode 100644 drivers/staging/brcm80211/include/sdio.h
 create mode 100644 drivers/staging/brcm80211/include/sdioh.h
 create mode 100644 drivers/staging/brcm80211/include/sdiovar.h
 create mode 100644 drivers/staging/brcm80211/include/siutils.h
 create mode 100644 drivers/staging/brcm80211/include/spid.h
 create mode 100644 drivers/staging/brcm80211/include/wlioctl.h
 create mode 100644 drivers/staging/brcm80211/phy/phy_version.h
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phy_cmn.c
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phy_hal.h
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phy_int.h
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phy_lcn.c
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phy_lcn.h
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phy_n.c
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phy_radio.h
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phyreg_n.h
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phytbl_lcn.c
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phytbl_lcn.h
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phytbl_n.c
 create mode 100644 drivers/staging/brcm80211/phy/wlc_phytbl_n.h
 create mode 100644 drivers/staging/brcm80211/sys/d11ucode_ext.h
 create mode 100644 drivers/staging/brcm80211/sys/wl_dbg.h
 create mode 100644 drivers/staging/brcm80211/sys/wl_export.h
 create mode 100644 drivers/staging/brcm80211/sys/wl_mac80211.c
 create mode 100644 drivers/staging/brcm80211/sys/wl_mac80211.h
 create mode 100644 drivers/staging/brcm80211/sys/wl_ucode.h
 create mode 100644 drivers/staging/brcm80211/sys/wl_ucode_loader.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_alloc.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_alloc.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_ampdu.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_ampdu.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_antsel.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_antsel.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_bmac.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_bmac.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_bsscfg.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_cfg.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_channel.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_channel.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_event.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_event.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_key.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_mac80211.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_mac80211.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_phy_shim.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_phy_shim.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_pub.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_rate.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_rate.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_rpc.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_rpctx.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_scb.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_stf.c
 create mode 100644 drivers/staging/brcm80211/sys/wlc_stf.h
 create mode 100644 drivers/staging/brcm80211/sys/wlc_types.h
 create mode 100644 drivers/staging/brcm80211/util/aiutils.c
 create mode 100644 drivers/staging/brcm80211/util/bcmotp.c
 create mode 100644 drivers/staging/brcm80211/util/bcmsrom.c
 create mode 100644 drivers/staging/brcm80211/util/bcmutils.c
 create mode 100644 drivers/staging/brcm80211/util/bcmwifi.c
 create mode 100644 drivers/staging/brcm80211/util/hnddma.c
 create mode 100644 drivers/staging/brcm80211/util/hndpmu.c
 create mode 100644 drivers/staging/brcm80211/util/linux_osl.c
 create mode 100644 drivers/staging/brcm80211/util/nicpci.c
 create mode 100644 drivers/staging/brcm80211/util/nvram/nvram_ro.c
 create mode 100644 drivers/staging/brcm80211/util/qmath.c
 create mode 100644 drivers/staging/brcm80211/util/sbutils.c
 create mode 100644 drivers/staging/brcm80211/util/siutils.c
 create mode 100644 drivers/staging/brcm80211/util/siutils_priv.h
 create mode 100644 drivers/staging/ft1000/Kconfig
 create mode 100644 drivers/staging/ft1000/Makefile
 create mode 100644 drivers/staging/ft1000/TODO
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/Makefile
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/boot.h
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000.conf
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000.img
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.h
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dev.h
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
 create mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
 create mode 100644 drivers/staging/ft1000/ft1000-usb/Makefile
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_download.c
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
 create mode 100644 drivers/staging/ft1000/ft1000-usb/ft3000.img
 delete mode 100644 drivers/staging/hv/channel_interface.c
 delete mode 100644 drivers/staging/hv/channel_interface.h
 create mode 100644 drivers/staging/iio/Documentation/generic_buffer.c
 delete mode 100644 drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio
 create mode 100644 drivers/staging/iio/Documentation/sysfs-bus-iio-light
 delete mode 100644 drivers/staging/iio/Documentation/sysfs-class-iio
 create mode 100644 drivers/staging/iio/adc/ad7476.h
 create mode 100644 drivers/staging/iio/adc/ad7476_core.c
 create mode 100644 drivers/staging/iio/adc/ad7476_ring.c
 create mode 100644 drivers/staging/iio/adc/ad799x.h
 create mode 100644 drivers/staging/iio/adc/ad799x_core.c
 create mode 100644 drivers/staging/iio/adc/ad799x_ring.c
 create mode 100644 drivers/staging/iio/light/isl29018.c
 delete mode 100644 drivers/staging/iio/light/light.h
 create mode 100644 drivers/staging/iio/magnetometer/ak8975.c
 create mode 100644 drivers/staging/intel_sst/Kconfig
 create mode 100644 drivers/staging/intel_sst/Makefile
 create mode 100644 drivers/staging/intel_sst/TODO
 create mode 100644 drivers/staging/intel_sst/intel_sst.c
 create mode 100644 drivers/staging/intel_sst/intel_sst.h
 create mode 100644 drivers/staging/intel_sst/intel_sst_app_interface.c
 create mode 100644 drivers/staging/intel_sst/intel_sst_common.h
 create mode 100644 drivers/staging/intel_sst/intel_sst_drv_interface.c
 create mode 100644 drivers/staging/intel_sst/intel_sst_dsp.c
 create mode 100644 drivers/staging/intel_sst/intel_sst_fw_ipc.h
 create mode 100644 drivers/staging/intel_sst/intel_sst_ioctl.h
 create mode 100644 drivers/staging/intel_sst/intel_sst_ipc.c
 create mode 100644 drivers/staging/intel_sst/intel_sst_pvt.c
 create mode 100644 drivers/staging/intel_sst/intel_sst_stream.c
 create mode 100644 drivers/staging/intel_sst/intel_sst_stream_encoded.c
 create mode 100644 drivers/staging/intel_sst/intelmid.c
 create mode 100644 drivers/staging/intel_sst/intelmid.h
 create mode 100644 drivers/staging/intel_sst/intelmid_ctrl.c
 create mode 100644 drivers/staging/intel_sst/intelmid_msic_control.c
 create mode 100644 drivers/staging/intel_sst/intelmid_pvt.c
 create mode 100644 drivers/staging/intel_sst/intelmid_snd_control.h
 create mode 100644 drivers/staging/intel_sst/intelmid_v0_control.c
 create mode 100644 drivers/staging/intel_sst/intelmid_v1_control.c
 create mode 100644 drivers/staging/intel_sst/intelmid_v2_control.c
 create mode 100644 drivers/staging/intel_sst/jack.h
 create mode 100644 drivers/staging/keucr/Kconfig
 create mode 100644 drivers/staging/keucr/Makefile
 create mode 100644 drivers/staging/keucr/TODO
 create mode 100644 drivers/staging/keucr/common.h
 create mode 100644 drivers/staging/keucr/init.c
 create mode 100644 drivers/staging/keucr/init.h
 create mode 100644 drivers/staging/keucr/ms.c
 create mode 100644 drivers/staging/keucr/ms.h
 create mode 100644 drivers/staging/keucr/msscsi.c
 create mode 100644 drivers/staging/keucr/scsiglue.c
 create mode 100644 drivers/staging/keucr/scsiglue.h
 create mode 100644 drivers/staging/keucr/sdscsi.c
 create mode 100644 drivers/staging/keucr/smcommon.h
 create mode 100644 drivers/staging/keucr/smil.h
 create mode 100644 drivers/staging/keucr/smilecc.c
 create mode 100644 drivers/staging/keucr/smilmain.c
 create mode 100644 drivers/staging/keucr/smilsub.c
 create mode 100644 drivers/staging/keucr/smscsi.c
 create mode 100644 drivers/staging/keucr/transport.c
 create mode 100644 drivers/staging/keucr/transport.h
 create mode 100644 drivers/staging/keucr/usb.c
 create mode 100644 drivers/staging/keucr/usb.h
 create mode 100644 drivers/staging/olpc_dcon/Kconfig
 create mode 100644 drivers/staging/olpc_dcon/Makefile
 create mode 100644 drivers/staging/olpc_dcon/TODO
 create mode 100644 drivers/staging/olpc_dcon/olpc_dcon.c
 create mode 100644 drivers/staging/olpc_dcon/olpc_dcon.h
 create mode 100644 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
 create mode 100644 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
 delete mode 100644 drivers/staging/otus/80211core/amsdu.c
 delete mode 100644 drivers/staging/otus/80211core/cagg.c
 delete mode 100644 drivers/staging/otus/80211core/cagg.h
 delete mode 100644 drivers/staging/otus/80211core/ccmd.c
 delete mode 100644 drivers/staging/otus/80211core/cfunc.c
 delete mode 100644 drivers/staging/otus/80211core/cfunc.h
 delete mode 100644 drivers/staging/otus/80211core/chb.c
 delete mode 100644 drivers/staging/otus/80211core/cic.c
 delete mode 100644 drivers/staging/otus/80211core/cinit.c
 delete mode 100644 drivers/staging/otus/80211core/cmm.c
 delete mode 100644 drivers/staging/otus/80211core/cmmap.c
 delete mode 100644 drivers/staging/otus/80211core/cmmsta.c
 delete mode 100644 drivers/staging/otus/80211core/coid.c
 delete mode 100644 drivers/staging/otus/80211core/cprecomp.h
 delete mode 100644 drivers/staging/otus/80211core/cpsmgr.c
 delete mode 100644 drivers/staging/otus/80211core/cscanmgr.c
 delete mode 100644 drivers/staging/otus/80211core/ctkip.c
 delete mode 100644 drivers/staging/otus/80211core/ctxrx.c
 delete mode 100644 drivers/staging/otus/80211core/cwep.c
 delete mode 100644 drivers/staging/otus/80211core/cwm.c
 delete mode 100644 drivers/staging/otus/80211core/cwm.h
 delete mode 100644 drivers/staging/otus/80211core/freqctrl.c
 delete mode 100644 drivers/staging/otus/80211core/ledmgr.c
 delete mode 100644 drivers/staging/otus/80211core/performance.c
 delete mode 100644 drivers/staging/otus/80211core/performance.h
 delete mode 100644 drivers/staging/otus/80211core/pub_usb.h
 delete mode 100644 drivers/staging/otus/80211core/pub_zfi.h
 delete mode 100644 drivers/staging/otus/80211core/pub_zfw.h
 delete mode 100644 drivers/staging/otus/80211core/queue.c
 delete mode 100644 drivers/staging/otus/80211core/queue.h
 delete mode 100644 drivers/staging/otus/80211core/ratectrl.c
 delete mode 100644 drivers/staging/otus/80211core/ratectrl.h
 delete mode 100644 drivers/staging/otus/80211core/struct.h
 delete mode 100644 drivers/staging/otus/80211core/wlan.h
 delete mode 100644 drivers/staging/otus/Kconfig
 delete mode 100644 drivers/staging/otus/Makefile
 delete mode 100644 drivers/staging/otus/TODO
 delete mode 100644 drivers/staging/otus/apdbg.c
 delete mode 100644 drivers/staging/otus/athr_common.h
 delete mode 100644 drivers/staging/otus/hal/hpDKfwu.c
 delete mode 100644 drivers/staging/otus/hal/hpani.c
 delete mode 100644 drivers/staging/otus/hal/hpani.h
 delete mode 100644 drivers/staging/otus/hal/hpfw2.c
 delete mode 100644 drivers/staging/otus/hal/hpfwbu.c
 delete mode 100644 drivers/staging/otus/hal/hpfwspiu.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu.c.drv_ba_resend
 delete mode 100644 drivers/staging/otus/hal/hpfwu_2k.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_BA.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_FB50_mdk.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_OTUS_RC.c
 delete mode 100644 drivers/staging/otus/hal/hpfwu_txstream.c
 delete mode 100644 drivers/staging/otus/hal/hpfwuinit.c
 delete mode 100644 drivers/staging/otus/hal/hpmain.c
 delete mode 100644 drivers/staging/otus/hal/hpreg.c
 delete mode 100644 drivers/staging/otus/hal/hpreg.h
 delete mode 100644 drivers/staging/otus/hal/hprw.c
 delete mode 100644 drivers/staging/otus/hal/hpusb.c
 delete mode 100644 drivers/staging/otus/hal/hpusb.h
 delete mode 100644 drivers/staging/otus/hal/otus.ini
 delete mode 100644 drivers/staging/otus/ioctl.c
 delete mode 100644 drivers/staging/otus/oal_dt.h
 delete mode 100644 drivers/staging/otus/oal_marc.h
 delete mode 100644 drivers/staging/otus/usbdrv.c
 delete mode 100644 drivers/staging/otus/usbdrv.h
 delete mode 100644 drivers/staging/otus/wrap_buf.c
 delete mode 100644 drivers/staging/otus/wrap_dbg.c
 delete mode 100644 drivers/staging/otus/wrap_ev.c
 delete mode 100644 drivers/staging/otus/wrap_mem.c
 delete mode 100644 drivers/staging/otus/wrap_mis.c
 delete mode 100644 drivers/staging/otus/wrap_pkt.c
 delete mode 100644 drivers/staging/otus/wrap_sec.c
 delete mode 100644 drivers/staging/otus/wrap_usb.c
 delete mode 100644 drivers/staging/otus/wwrap.c
 delete mode 100644 drivers/staging/otus/zdcompat.h
 delete mode 100644 drivers/staging/otus/zdusb.c
 delete mode 100644 drivers/staging/otus/zdusb.h
 delete mode 100644 drivers/staging/rtl8192su/Kconfig
 delete mode 100644 drivers/staging/rtl8192su/Makefile
 delete mode 100644 drivers/staging/rtl8192su/TODO
 delete mode 100644 drivers/staging/rtl8192su/authors
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/Makefile
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/dot11d.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/dot11d.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_r8192s.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/readme
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_BA.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_BAProc.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_HT.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_Qos.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_TS.h
 delete mode 100644 drivers/staging/rtl8192su/ieee80211/rtl819x_TSProc.c
 delete mode 100644 drivers/staging/rtl8192su/r8192SU_HWImg.c
 delete mode 100644 drivers/staging/rtl8192su/r8192SU_HWImg.h
 delete mode 100644 drivers/staging/rtl8192su/r8192SU_led.c
 delete mode 100644 drivers/staging/rtl8192su/r8192SU_led.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_Efuse.c
 delete mode 100644 drivers/staging/rtl8192su/r8192S_Efuse.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_firmware.c
 delete mode 100644 drivers/staging/rtl8192su/r8192S_firmware.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_hw.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_phy.c
 delete mode 100644 drivers/staging/rtl8192su/r8192S_phy.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_phyreg.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_rtl6052.c
 delete mode 100644 drivers/staging/rtl8192su/r8192S_rtl6052.h
 delete mode 100644 drivers/staging/rtl8192su/r8192S_rtl8225.c
 delete mode 100644 drivers/staging/rtl8192su/r8192S_rtl8225.h
 delete mode 100644 drivers/staging/rtl8192su/r8192U.h
 delete mode 100644 drivers/staging/rtl8192su/r8192U_core.c
 delete mode 100644 drivers/staging/rtl8192su/r8192U_dm.c
 delete mode 100644 drivers/staging/rtl8192su/r8192U_dm.h
 delete mode 100644 drivers/staging/rtl8192su/r8192U_pm.c
 delete mode 100644 drivers/staging/rtl8192su/r8192U_pm.h
 delete mode 100644 drivers/staging/rtl8192su/r8192U_wx.c
 delete mode 100644 drivers/staging/rtl8192su/r8192U_wx.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_HTGen.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_HTType.h
 delete mode 100644 drivers/staging/rtl8192su/r819xU_cmdpkt.c
 delete mode 100644 drivers/staging/rtl8192su/r819xU_cmdpkt.h
 create mode 100644 drivers/staging/rtl8712/Kconfig
 create mode 100644 drivers/staging/rtl8712/Makefile
 create mode 100644 drivers/staging/rtl8712/TODO
 create mode 100644 drivers/staging/rtl8712/basic_types.h
 create mode 100644 drivers/staging/rtl8712/big_endian.h
 create mode 100644 drivers/staging/rtl8712/drv_types.h
 create mode 100644 drivers/staging/rtl8712/ethernet.h
 create mode 100644 drivers/staging/rtl8712/farray.h
 create mode 100644 drivers/staging/rtl8712/generic.h
 create mode 100644 drivers/staging/rtl8712/hal_init.c
 create mode 100644 drivers/staging/rtl8712/ieee80211.c
 create mode 100644 drivers/staging/rtl8712/ieee80211.h
 create mode 100644 drivers/staging/rtl8712/if_ether.h
 create mode 100644 drivers/staging/rtl8712/ip.h
 create mode 100644 drivers/staging/rtl8712/little_endian.h
 create mode 100644 drivers/staging/rtl8712/mlme_linux.c
 create mode 100644 drivers/staging/rtl8712/mlme_osdep.h
 create mode 100644 drivers/staging/rtl8712/mp_custom_oid.h
 create mode 100644 drivers/staging/rtl8712/os_intfs.c
 create mode 100644 drivers/staging/rtl8712/osdep_intf.h
 create mode 100644 drivers/staging/rtl8712/osdep_service.h
 create mode 100644 drivers/staging/rtl8712/recv_linux.c
 create mode 100644 drivers/staging/rtl8712/recv_osdep.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_cmd.c
 create mode 100644 drivers/staging/rtl8712/rtl8712_cmd.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_cmdctrl_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_cmdctrl_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_debugctrl_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_debugctrl_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_edcasetting_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_edcasetting_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_efuse.c
 create mode 100644 drivers/staging/rtl8712/rtl8712_efuse.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_event.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_fifoctrl_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_fifoctrl_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_gp_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_gp_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_hal.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_interrupt_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_io.c
 create mode 100644 drivers/staging/rtl8712/rtl8712_led.c
 create mode 100644 drivers/staging/rtl8712/rtl8712_macsetting_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_macsetting_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_powersave_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_powersave_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_ratectrl_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_ratectrl_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_recv.c
 create mode 100644 drivers/staging/rtl8712/rtl8712_recv.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_security_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_spec.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_syscfg_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_syscfg_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_timectrl_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_timectrl_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_wmac_bitdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_wmac_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl8712_xmit.c
 create mode 100644 drivers/staging/rtl8712/rtl8712_xmit.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_byteorder.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_cmd.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_cmd.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_debug.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_eeprom.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_eeprom.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_event.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_ht.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_io.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_io.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_ioctl.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_ioctl_linux.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_ioctl_rtl.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_ioctl_set.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_ioctl_set.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_led.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_mlme.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_mlme.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_mp.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_mp.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_mp_ioctl.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_mp_ioctl.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_mp_phy_regdef.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_pwrctrl.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_pwrctrl.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_recv.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_recv.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_rf.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_security.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_security.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_sta_mgt.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_wlan_sme.h
 create mode 100644 drivers/staging/rtl8712/rtl871x_xmit.c
 create mode 100644 drivers/staging/rtl8712/rtl871x_xmit.h
 create mode 100644 drivers/staging/rtl8712/sta_info.h
 create mode 100644 drivers/staging/rtl8712/swab.h
 create mode 100644 drivers/staging/rtl8712/usb_halinit.c
 create mode 100644 drivers/staging/rtl8712/usb_intf.c
 create mode 100644 drivers/staging/rtl8712/usb_ops.c
 create mode 100644 drivers/staging/rtl8712/usb_ops.h
 create mode 100644 drivers/staging/rtl8712/usb_ops_linux.c
 create mode 100644 drivers/staging/rtl8712/usb_osintf.h
 create mode 100644 drivers/staging/rtl8712/usb_vendor_req.h
 create mode 100644 drivers/staging/rtl8712/wifi.h
 create mode 100644 drivers/staging/rtl8712/wlan_bssdef.h
 create mode 100644 drivers/staging/rtl8712/xmit_linux.c
 create mode 100644 drivers/staging/rtl8712/xmit_osdep.h
 create mode 100644 drivers/staging/sbe-2t3e3/2t3e3.h
 create mode 100644 drivers/staging/sbe-2t3e3/Kconfig
 create mode 100644 drivers/staging/sbe-2t3e3/Makefile
 create mode 100644 drivers/staging/sbe-2t3e3/TODO
 create mode 100644 drivers/staging/sbe-2t3e3/cpld.c
 create mode 100644 drivers/staging/sbe-2t3e3/ctrl.c
 create mode 100644 drivers/staging/sbe-2t3e3/ctrl.h
 create mode 100644 drivers/staging/sbe-2t3e3/dc.c
 create mode 100644 drivers/staging/sbe-2t3e3/exar7250.c
 create mode 100644 drivers/staging/sbe-2t3e3/exar7300.c
 create mode 100644 drivers/staging/sbe-2t3e3/intr.c
 create mode 100644 drivers/staging/sbe-2t3e3/io.c
 create mode 100644 drivers/staging/sbe-2t3e3/main.c
 create mode 100644 drivers/staging/sbe-2t3e3/maps.c
 create mode 100644 drivers/staging/sbe-2t3e3/module.c
 create mode 100644 drivers/staging/sbe-2t3e3/netdev.c
 rename {fs => drivers/staging}/smbfs/Kconfig (100%)
 rename {fs => drivers/staging}/smbfs/Makefile (50%)
 create mode 100644 drivers/staging/smbfs/TODO
 rename {fs => drivers/staging}/smbfs/cache.c (99%)
 rename {fs => drivers/staging}/smbfs/dir.c (99%)
 rename {fs => drivers/staging}/smbfs/file.c (99%)
 rename {fs => drivers/staging}/smbfs/getopt.c (100%)
 rename {fs => drivers/staging}/smbfs/getopt.h (100%)
 rename {fs => drivers/staging}/smbfs/inode.c (99%)
 rename {fs => drivers/staging}/smbfs/ioctl.c (96%)
 rename {fs => drivers/staging}/smbfs/proc.c (99%)
 rename {fs => drivers/staging}/smbfs/proto.h (100%)
 rename {fs => drivers/staging}/smbfs/request.c (99%)
 rename {fs => drivers/staging}/smbfs/request.h (100%)
 rename {include/linux => drivers/staging/smbfs}/smb.h (100%)
 rename {fs => drivers/staging}/smbfs/smb_debug.h (100%)
 rename {include/linux => drivers/staging/smbfs}/smb_fs.h (97%)
 rename {include/linux => drivers/staging/smbfs}/smb_fs_i.h (100%)
 rename {include/linux => drivers/staging/smbfs}/smb_fs_sb.h (98%)
 rename {include/linux => drivers/staging/smbfs}/smb_mount.h (100%)
 rename {Documentation/filesystems => drivers/staging/smbfs}/smbfs.txt (100%)
 rename {fs => drivers/staging}/smbfs/smbiod.c (98%)
 rename {include/linux => drivers/staging/smbfs}/smbno.h (100%)
 rename {fs => drivers/staging}/smbfs/sock.c (99%)
 rename {fs => drivers/staging}/smbfs/symlink.c (96%)
 create mode 100644 drivers/staging/speakup/DefaultKeyAssignments
 create mode 100644 drivers/staging/speakup/Kconfig
 create mode 100644 drivers/staging/speakup/Makefile
 create mode 100644 drivers/staging/speakup/TODO
 create mode 100644 drivers/staging/speakup/buffers.c
 create mode 100644 drivers/staging/speakup/devsynth.c
 create mode 100644 drivers/staging/speakup/fakekey.c
 create mode 100644 drivers/staging/speakup/i18n.c
 create mode 100644 drivers/staging/speakup/i18n.h
 create mode 100644 drivers/staging/speakup/keyhelp.c
 create mode 100644 drivers/staging/speakup/kobjects.c
 create mode 100644 drivers/staging/speakup/main.c
 create mode 100644 drivers/staging/speakup/selection.c
 create mode 100644 drivers/staging/speakup/serialio.c
 create mode 100644 drivers/staging/speakup/serialio.h
 create mode 100644 drivers/staging/speakup/speakup.h
 create mode 100644 drivers/staging/speakup/speakup_acnt.h
 create mode 100644 drivers/staging/speakup/speakup_acntpc.c
 create mode 100644 drivers/staging/speakup/speakup_acntsa.c
 create mode 100644 drivers/staging/speakup/speakup_apollo.c
 create mode 100644 drivers/staging/speakup/speakup_audptr.c
 create mode 100644 drivers/staging/speakup/speakup_bns.c
 create mode 100644 drivers/staging/speakup/speakup_decext.c
 create mode 100644 drivers/staging/speakup/speakup_decpc.c
 create mode 100644 drivers/staging/speakup/speakup_dectlk.c
 create mode 100644 drivers/staging/speakup/speakup_dtlk.c
 create mode 100644 drivers/staging/speakup/speakup_dtlk.h
 create mode 100644 drivers/staging/speakup/speakup_dummy.c
 create mode 100644 drivers/staging/speakup/speakup_keypc.c
 create mode 100644 drivers/staging/speakup/speakup_ltlk.c
 create mode 100644 drivers/staging/speakup/speakup_soft.c
 create mode 100644 drivers/staging/speakup/speakup_spkout.c
 create mode 100644 drivers/staging/speakup/speakup_txprt.c
 create mode 100644 drivers/staging/speakup/speakupmap.h
 create mode 100644 drivers/staging/speakup/speakupmap.map
 create mode 100644 drivers/staging/speakup/spk_priv.h
 create mode 100644 drivers/staging/speakup/spk_priv_keyinfo.h
 create mode 100644 drivers/staging/speakup/spk_types.h
 create mode 100644 drivers/staging/speakup/spkguide.txt
 create mode 100644 drivers/staging/speakup/synth.c
 create mode 100644 drivers/staging/speakup/thread.c
 create mode 100644 drivers/staging/speakup/varhandlers.c
 delete mode 100644 drivers/staging/ti-st/fm.h
 delete mode 100644 drivers/staging/ti-st/st.h
 delete mode 100644 drivers/staging/ti-st/st_core.h
 delete mode 100644 drivers/staging/ti-st/st_kim.h
 delete mode 100644 drivers/staging/ti-st/st_ll.h
 create mode 100644 drivers/staging/tidspbridge/core/dsp-mmu.c
 rename drivers/staging/tidspbridge/{services => core}/sync.c (85%)
 delete mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/cfg.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/services.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c
 delete mode 100644 drivers/staging/tidspbridge/services/cfg.c
 delete mode 100644 drivers/staging/tidspbridge/services/ntfy.c
 delete mode 100644 drivers/staging/tidspbridge/services/services.c
 create mode 100644 drivers/staging/udlfb/udlfb.txt
 create mode 100644 drivers/staging/westbridge/Kconfig
 create mode 100644 drivers/staging/westbridge/TODO
 create mode 100644 drivers/staging/westbridge/astoria/Kconfig
 create mode 100644 drivers/staging/westbridge/astoria/Makefile
 create mode 100644 drivers/staging/westbridge/astoria/api/Makefile
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyasdma.c
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyasintr.c
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyaslep2pep.c
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyasmisc.c
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyasmtp.c
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyasstorage.c
 create mode 100644 drivers/staging/westbridge/astoria/api/src/cyasusb.c
 create mode 100644 drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
 create mode 100644 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/cyashaldef.h
 create mode 100644 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
 create mode 100644 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasmemmap.h
 create mode 100644 drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyasomapdev_kernel.h
 create mode 100644 drivers/staging/westbridge/astoria/block/Kconfig
 create mode 100644 drivers/staging/westbridge/astoria/block/Makefile
 create mode 100644 drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
 create mode 100644 drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
 create mode 100644 drivers/staging/westbridge/astoria/block/cyasblkdev_queue.h
 create mode 100644 drivers/staging/westbridge/astoria/device/Kconfig
 create mode 100644 drivers/staging/westbridge/astoria/device/Makefile
 create mode 100644 drivers/staging/westbridge/astoria/device/cyandevice_export.h
 create mode 100644 drivers/staging/westbridge/astoria/device/cyasdevice.c
 create mode 100644 drivers/staging/westbridge/astoria/gadget/Kconfig
 create mode 100644 drivers/staging/westbridge/astoria/gadget/Makefile
 create mode 100644 drivers/staging/westbridge/astoria/gadget/cyasgadget.c
 create mode 100644 drivers/staging/westbridge/astoria/gadget/cyasgadget.h
 create mode 100644 drivers/staging/westbridge/astoria/gadget/cyasgadget_ioctl.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanerr.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanmedia.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanmisc.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanregs.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyansdkversion.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanstorage.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyantioch.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyantypes.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyanusb.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyas_cplus_end.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyas_cplus_start.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyascast.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasdevice.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasdma.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyaserr.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyashal.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyashalcb.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyashaldoc.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasintr.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyaslep2pep.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyaslowlevel.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmedia.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmisc.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmisc_dep.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasmtp.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasprotocol.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasregs.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage_dep.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyastoria.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyastsdkversion.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyastypes.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb.h
 create mode 100644 drivers/staging/westbridge/astoria/include/linux/westbridge/cyasusb_dep.h
 delete mode 100644 drivers/staging/winbond/mlme_s.h
 delete mode 100644 drivers/staging/winbond/scan_s.h
 delete mode 100644 drivers/staging/zram/zram_ioctl.h
 create mode 100644 drivers/staging/zram/zram_sysfs.c
 create mode 100644 include/linux/ti_wilink_st.h

---------------

Agustin March (1):
      staging: usbip: resolved a space in a comment

Al Cho (3):
      Staging: add USB ENE card reader driver
      staging: keucr: fix keucr lost disconnect
      staging: keucr: fix keucr lost disconnect in transport

Alan Cox (1):
      staging: sst: Remove the aava bits

Alejandro Emanuel Paredes (1):
      staging: vt6656: changed comments convention and removed spaces before tab

Alek Du (1):
      Staging: mrst-touchscreen: Fix wrong Makefile config

Andre Nogueira (1):
      Staging: rtl8186se: Remove a duplicate include directive in ieee80211.h

Andrea Gelmini (2):
      drivers: staging: tidspbridge: gen: gb.c: Removed duplicated #include
      staging: spectra: Kconfig: add missing '.'

Andreas Langer (1):
      Staging: batman-adv: layer2 unicast packet fragmentation

Andres More (5):
      staging: vt6656: added spaces around '||'
      staging: vt6656: removed not useful comments
      staging: vt6656: removed custom definitions of Ethernet packet types
      staging: vt6656: removed NDIS_STATUS int redefinition
      staging: vt6656: removed macro to test bits

Andres Salomon (7):
      staging: olpc_dcon: add OLPC display controller (DCON) support
      staging: olpc_dcon: switch back to using olpc_board(0xXX)
      staging: olpc_dcon: drop XO-1.5 support for now
      staging: olpc_dcon: add TODO file
      staging: olpc_dcon: remove outdated backlight comment
      staging: olpc_dcon: add people to the Cc list
      staging: olpc_dcon: drop old VT switch code, watch for CONBLANK event

Andrew Chew (2):
      staging: iio: Change GAIN macros to SCALE.
      staging: iio: ak8975: Add ak8975 magnetometer sensor

Andy Shevchenko (31):
      staging: rtl8712: throw away custom hex_to_bin()
      staging: ath6kl: use native methods from kernel library
      staging: brcm80211: use '%pM' format to print MAC address
      staging: rt2860: change plain format of mac address to %pM in *printf()
      staging: wlags49_h2: use '%pM' format to print MAC address
      staging: vt6655: use '%pM' format to print MAC address
      staging: cxt1e1: use '%pMF' format to print MAC address
      staging: rtl8712: use '%pM' format to print MAC address
      staging: rt2870: use '%pM' format to print MAC address
      staging: otus: use '%pM' format to print MAC address
      staging: octeon: use '%pM' format to print MAC address
      staging: ath6kl: use '%pM' format to print MAC address
      staging: brcm80211: use native ctype library
      staging: brcm80211: use string native library
      staging: rt2860: '&pointer[0]' to 'pointer' fix
      staging: wlags49_h2: '&pointer[0]' to 'pointer' fix
      staging: rtl8712: '&pointer[0]' to 'pointer' fix
      staging: otus: '&pointer[0]' to 'pointer' fix
      staging: cxt1e1: '&pointer[0]' to 'pointer' fix
      staging: ath6kl: '&pointer[0]' to 'pointer' fix
      staging: vt6655: '&pointer[0]' to 'pointer' fix
      staging: rt2870: '&pointer[0]' to 'pointer' fix
      staging: octeon: '&pointer[0]' to 'pointer' fix
      staging: brcm80211: clean up custom ctype library again
      staging: brcm80211: remove custom string library again
      staging: brcm80211: remove useless bcm_ether_ntoa()
      staging: rt2860: remove custom min() and max()
      staging: wlags49_h2: remove custom macros min() and max()
      staging: wlags49_h2: fix format of timeStamp debug output
      staging: wlags49_h2: remove useless DbgHwAddr() method
      staging: batman-adv: remove useless addr_to_string()

Anton Blanchard (1):
      Staging: zram: work around oops due to startup ordering snafu

Arjan van de Ven (1):
      Staging: mrst-touchscreen: fix channel allocation in the touch screen driver

Arnd Bergmann (9):
      staging: make new character devices nonseekable
      staging/ft1000-usb: fix unlocked_ioctl prototype
      staging/ft1000-usb: fix build warnings
      staging/ft1000-usb: fix problems found by sparse
      staging/bcm: fix most build warnings
      staging/bcm: add sparse annotations
      autofs3: move to drivers/staging
      smbfs: move to drivers/staging
      staging: tidspbridge: add memory consistency to TODO list

Arthur Benilov (1):
      Staging: vme: Assure D16 cycle if required in master_read and master_write

Ben Hutchings (1):
      staging: brcm80211: Fix some initialisation failure paths

Bernhard Walle (1):
      staging: octeon: Remove USB code

Bernie Thompson (11):
      staging: udlfb: Add intro udlfb documentation
      staging: udlfb: fbdev character read and write support
      staging: udlfb: add DPMS support
      staging: udlfb: remove metrics_misc sysfs attribute
      staging: udlfb: revamp reference handling to insure successful shutdown
      staging: udlfb: enhance EDID and mode handling support
      staging: udlfb: fix big endian rendering error
      staging: udlfb: support for writing backup EDID to sysfs file
      staging: udlfb: add module options for console and fb_defio
      staging: udlfb: fix incorrect fb_defio implementation for multiple framebuffers
      staging: udlfb: fix checkpatch and style

Bob Beers (1):
      Staging: cxt1e1: multiple definition of max_mtu fix

Brett Rudley (17):
      staging: brcm80211: handle missing firmware better
      staging: brcm80211: delete unused/obsolete code
      staging: brcm80211: cleanup headers
      staging: brcm80211: cleanup headers
      staging: brcm80211: Fix debug section mismatch warning
      staging: brcm80211: Move #includes out of header
      staging: brcm80211: Purge unused #includes
      staging: brcm80211: Purge unused flags and macros from wlc_scb.h
      staging: brcm80211: Purge packets tags
      staging: brcm80211: Purge unused extern declarations
      staging: brcm80211: bcmutils.[ch]: purge unused funcs
      staging: brcm80211: Use proper BRCM_FULLMAC #ifdefs
      staging: brcm80211: Purge unused memlist debugging
      staging: brcm80211: Coalesce osl_dma_alloc_consistent between fullmac and softmac
      staging: brcm80211: Purge unused packet engine
      staging: brcm80211: Purge unused wlc_id_name
      staging: brcm80211: Purge unused bcmwpa.[ch]

Charles Clément (2):
      Staging: vt665x: remove unused DEF definition
      Staging: vt6655: remove unused update_BssList definition

Christopher Brannon (15):
      staging: speakup: speakup_acntpc.c: style fixes
      staging: speakup: speakup_acntsa.c: style fixes
      staging: speakup: speakup_apollo.c: style fixes
      staging: speakup: speakup_audptr.c: style fixes
      staging: speakup: speakup_bns.c: style fixes
      staging: speakup: speakup_decext.c: style fixes
      staging: speakup: speakup_decpc.c: style fixes
      staging: speakup: speakup_dtlk.c: style fixes
      staging: speakup: speakup_dummy.c: style fixes
      staging: speakup: speakup_keypc.c: style fixes
      staging: speakup: speakup_ltlk.c: style fixes
      staging: speakup: speakup_soft.c: style fixes
      staging: speakup: speakup_spkout.c: style fixes
      staging: speakup: speakup_txprt.c: style fixes
      staging: speakup: speakup_dectlk.c: style fixes

Clelia V. Korol (1):
      staging: vt6656: Fixed indentation with spaces

Dan Carpenter (22):
      Staging: vt6656: problems in error handling
      Staging: iio: signedness bug
      Staging: lirc: remove unneeded variable
      Staging: rtl8192e: add curly braces to if statement
      Staging: ti-st: writing past end of array
      Staging: quickstart: acpi_status is unsigned
      Staging: solo6x10: return -EFAULT on copy_to_user errors
      Staging: bcm: return -EFAULT on copy_to_user() failures
      Staging: bcm: make major and minor signed
      Staging: bcm: mocro expansion bug
      Staging: bcm: dereferencing before checking
      Staging: bcm: return -EFAULT on copy_to_user() errors
      Staging: bcm: remove unneeded NULL check
      Staging: bcm: silence off by one warning
      Staging: brcm80211: make interface name buffer smaller
      Staging: ft1000-usb: fix array overflow
      Staging: lirc: fix PTR_ERR() check
      Staging: ft1000-usb: use the correct list head
      Staging: intel_sst: cleanup naming a little
      Staging: intel_sst: return -EFAULT if copy_to_user() fails
      Staging: intel_sst: off by one bug
      Staging: sst: more copy_to_user() changes

David Cross (10):
      Staging: add West Bridge Astoria Driver
      Staging: west bridge: Kconfig fix
      Staging: west bridge: block driver api fix
      staging: west bridge: cyasgadget, remove file system / vfs calls
      staging: west bridge: pnand hal fixes
      Staging: west bridge, cyasgadget fix for usb_gadget_probe_driver
      Staging: west bridge, removal of " " before ";"
      staging: west bridge cyasgadget, removal of " " before ";"
      staging: west bridge, addition of common lock on cyasdevice
      staging: west bridge, block driver change for partition support

Denis Kirjanov (1):
      Staging: slicoss: Remove explicit arch dependencies

Diego H. Iglesias (1):
      staging: vt6656: removed not required parentheses.

Ema Cuevas (1):
      staging: vt6656: removed dummy errors like extra spaces

Emanuel Mariano Ravera (1):
      staging: vt6656: Space Added after definition of Variable MSG_LEVEL_INFO

Ernesto Ramos (3):
      staging: ti dspbridge: remove cmm_xlator_delete wrapper
      staging: ti dspbridge: Replace find_lcm with lcm kernel func
      staging: ti dspbridge: disable all peripherals at bridge_brd_stop

Felipe Contreras (2):
      omap: add dsp platform device
      staging: tidspbridge: use omap_dsp_platform_data

Fernando Guzman Lugo (12):
      staging: tidspbridge: replace iommu custom for opensource implementation
      staging: tidspbridge - move shared memory iommu maps to tiomap3430.c
      staging: tidspbridge - rename bridge_brd_mem_map/unmap to a proper name
      staging: tidspbridge - remove custom mmu code from tiomap3430.c
      staging: tidspbridge - fix mmufault support
      staging: tidspbridge - remove hw directory
      staging: tidspbridge - move all iommu related code to a new file
      staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct
      staging: tidspbridge - remove reserved memory clean up
      staging: tidspbridge - deprecate reserve/unreserve_memory funtions
      staging: tidspbridge - remove dmm custom module
      staging: tidspbridge - update Kconfig to select IOMMU module

Gorskin Ilya (1):
      Staging: cx25821: clenup warnings found by checkpatch.pl tool in cx25821-audio-upstream.c and cx25821-audio.h.

Greg Kroah-Hartman (132):
      Staging: delete rtl8192su driver
      Staging: westbridge: mark BROKEN as it doesn't currently build properly
      Staging: rt2860: Fix brace coding style issue
      Staging: xgifb: revert a warning fix and resolve it properly
      Staging: keucr: fix up some coding style issues in the .h files
      Staging: fix Makefile so broadcom driver will actually build.
      Staging: keucr: prevent the driver from being built as a module.
      staging: line6: remove unneeded EXPORT_SYMBOL() usage
      Staging: line6: minor coding style cleanups
      Staging: ft1000: fix build
      Staging: ft1000: remove trailing whitespace
      Staging: ft1000: fix mode of firmware image file
      Staging: ft1000: mark pcmcia driver broken
      Staging: brcm80211: clean up makefile cflag lines
      Staging: brcm80211: remove driver specific -W options
      Staging: brcm80211: remove Module.symvers file from the tree
      Staging: keucr: fix compiler warning
      Staging: autofs3: create TODO file
      Staging: brcm80211: remove unneeded #ifdef checks
      Staging: brcm80211: remove UNUSED_PARAMETER macro
      Staging: brcm80211: remove INLINE definition
      Staging: brcm80211: remove floating point typedefs
      Staging: brcm80211: remove PTRSZ definition
      Staging: brcm80211: remove redefinition of size_t
      Staging: brcm80211: remove bool redefinition
      Staging: brcm80211: typedefs.h: remove some unused #if logic
      Staging: brcm80211: typedefs.h: remove version.h inclusion
      Staging: brcm80211: typedefs.h move types.h to the top of the file
      Staging: brcm80211: remove unit64 and int64 typedefs
      Staging: brcm80211: typedefs.h: remove NULL definition
      Staging: brcm80211: util: s/uint8/u8/
      Staging: brcm80211: sys: s/uint8/u8/
      Staging: brcm80211: brcmfmac: s/uint8/u8/
      Staging: brcm80211: phy: s/uint8/u8/
      Staging: brcm80211: include: s/uint8/u8/
      Staging: brcm80211: typedefs.h: remove uint8 definition
      Staging: brcm80211: s/int8/s8/
      Staging: brcm80211: s/uchar/unsigned char/
      Staging: brcm80211: s/ushort/unsigned short/
      Staging: brcm80211: s/ulong/unsigned long/
      Staging: brcm80211: remove CONST definition
      Staging: brcm80211: remove STATIC definition
      Staging: brcm80211: bcmdefs.h: remove unused #defines
      Staging: autofs3: fix up TODO
      Staging: olpc_dcon: mark the driver as CONFIG_BROKEN for now
      staging: autofs3: get the TODO file right the third time
      Staging: the tree is now kept in git, not quilt
      Staging: brcm80211: remove MY_INIT_WORK macro
      Staging: brcm80211: remove old module macro wrappers
      Staging: brcm80211: remove free_netdev wrapper
      Staging: brcm80211: remove unneeded pci macros
      Staging: brcm80211: remove some unused macros
      Staging: brcm80211: remove unneeded pm macro
      Staging: brcm80211: remove unused irq typedef
      Staging: brcm80211: remove some more macros from linuxver.h
      Staging: brcm80211: wl_cfg80211.c: fix compiler warnings
      Staging: brcm80211: remove forgotten undef
      Staging: brcm80211: s/uint16/u16/
      Staging: brcm80211: s/int16/s16/
      Staging: speakup: fix speakup core to build properly
      Staging: brcm80211: s/uint32/u32/
      Staging: brcm80211: s/int32/s32/
      Staging: brcm80211: remove unused typedefs in typedefs.h
      Staging: brcm80211: util: remove unneeded usage of uintptr
      Staging: brcm80211: remove broken MIN() implementation
      Staging: brcm80211: remove broken MAX() implementation
      Staging: brcm80211: remove OFFSETOF macro
      Staging: brcm80211: remove ARRAYSIZE macro
      Staging: brcm80211: remove unused ALIGN_ADDR() macro
      Staging: brcm80211: remove ISALIGNED macro
      Staging: brcm80211: remove ROUNDUP macro
      Staging: brcm80211: remove VALID_MASK macro
      Staging: brcm80211: hnddma.c: fix compiler warning
      Staging: brcm80211: phy: wlc_phy_n: fix some comparison warnings
      Staging: brcm80211: sys: wlc_ampdu: fix some comparison warnings
      Staging: brcm80211: sys: fix some comparison warnings
      Staging: brcm80211: brcmfmac: fix some comparison warnings
      Staging: brcm80211: remove BCMATTACHDATA macro
      Staging: brcm80211: remove BCMATTACHFN macro
      Staging: phison: fix problem caused by libata change
      Staging: brcm80211: remove __cplusplus markers
      Staging: brcm80211: remove TRUE #define
      Staging: brcm80211: remove FALSE #define
      Staging: brcm80211: bcmsdpcm: remove a bunch of unused macros
      Staging: brcm80211: include: remove unneeded use of uintptr
      Staging: brcm80211: phy: remove unneeded use of uintptr
      Staging: brcm80211: sys: remove unneeded use of uintptr
      Staging: brcm80211: util: remove unneeded use of uintptr
      Staging: brcm80211: remove sbpciregs_t typedef
      Staging: brcm80211: fix up compiler warnings I created
      Staging: hv: make alloc_channel static
      Staging: hv: remove VmbusGetChannelInfo
      Staging: hv: remove GetInfo pointer from struct vmbus_channel_interface
      Staging: hv: remove GetChannelInfo from struct vmbus_driver
      Staging: hv: vmbus_drv: remove vmbus_child_device_get_info
      Staging: hv: make get_channel_info static
      Staging: hv: channel: export vmbus_teardown_gpadl to modules
      Staging: hv: netvsc: call vmbus_teardown_gpadl directly
      Staging: hv: remove TeardownGpadl from struct vmbus_channel_interface
      Staging: hv: channel: export vmbus_establish_gpadl to modules
      Staging: hv: netvsc: call vmbus_establish_gpadl directly
      Staging: hv: remove EstablishGpadl from struct vmbus_channel_interface
      Staging: hv: make *context a real pointer in struct hv_device
      Staging: hv: rename context to channel in struct hv_device
      Staging: hv: channel: export vmbus_receivepacket_raw to modules
      Staging: hv: netvsc: call vmbus_receivepacket_raw directly
      Staging: hv: remove RecvPacketRaw from struct vmbus_channel_interface
      Staging: hv: storvsc: call vmbus_recvpacket directly
      Staging: hv: remove RecvPacket from struct vmbus_channel_interface
      Staging: hv: channel: export vmbus_sendpacket_multipagebuffer to modules
      Staging: hv: storvsc: call vmbus_sendpacket_multipagebuffer directly
      Staging: hv: remove SendPacketMultiPageBuffer from struct vmbus_channel_interface
      Staging: hv: channel: export vmbus_sendpacket_pagebuffer to modules
      Staging: hv: netvsc: call vmbus_sendpacket_pagebuffer directly
      Staging: hv: remove SendPacketPageBuffer from struct vmbus_channel_interface
      Staging: hv: netvsc: call vmbus_sendpacket directly
      Staging: hv: storvsc: call vmbus_sendpacket directly
      Staging: hv: remove SendPacket from struct vmbus_channel_interface
      Staging: hv: channel: export vmbus_close to modules
      Staging: hv: storvsc: call vmbus_close directly
      Staging: hv: netvsc: call vmbus_close directly
      Staging: hv: remove Close from struct vmbus_channel_interface
      Staging: hv: channel: export vmbus_open to modules
      Staging: hv: netvsc: call vmbus_open directly
      Staging: hv: storvsc: call vmbus_open directly
      Staging: hv: remove Open from struct vmbus_channel_interface
      Staging: hv: remove struct vmbus_channel_interface
      Staging: brcm80211: remove uintptr typedef usage
      Staging: brcm80211: remove typedefs.h
      Staging: keucr: fix up US_ macro change
      Staging: bcm: fix up network device reference counting
      Staging: brcm80211: fix usage of roundup in structures

Gustavo Silva (1):
      Staging: frontier: fix coding style issues in tranzport.c

Haiyang Zhang (9):
      staging: hv: Convert vmbus driver interface function pointer table to constant
      staging: hv: Remove camel cases of vmbus packet buffer structures
      staging: hv: Remove camel case variables in channel.c
      staging: hv: Rename camel cased functions in channel.c to lowercase
      staging: hv: Convert camel cased local variables in channel_interface.c to lower cases
      staging: hv: Convert camel cased function names in channel_interface.c to lower cases
      staging: hv: Convert camel cased parameter in channel_interface.h to lower case
      staging: hv: Convert camel cased local variable names in channel_mgmt.c to lower case
      staging: hv: Convert camel cased functions in channel_mgmt.c to lower case

Hank Janssen (1):
      staging: hv: Doubled ringbuffer size for Hyper-v network driver

Henry Ptasinski (25):
      Staging: Add initial release of brcm80211 - Broadcom 802.11n wireless LAN driver.
      staging: brcm80211: Add contact info to TODO list.
      staging: brcm80211: Fix URLs for firmware files.
      staging: brcm80211: add fullmac driver
      staging: brcm80211: Fix compile issue when BRCM80211_PCI is not set.
      staging: brcm80211: Make compiling of brcm80211.ko and brcmfmac.ko mutually exclusive.
      staging: brcm80211: Remove unneeded compile flags.
      staging: brcm80211: Remove unused structure.
      staging: brcm80211: Remove unnecessary assertions.
      staging: brcm80211: Remove unused field from wlc_info structure.
      staging: brcm80211: Remove unnecessary debug print routines.
      staging: brcm80211: Remove unnecessary assertions.
      staging: brcm80211: Remove unneeded definitions and structures.
      staging: brcm80211: Remove dead code from aiutils.c
      staging: brcm80211: Use linux/bitops.h instead of bitfuncs.h
      staging: brcm80211: Don't include bitfuncs.h
      staging: brcm80211: Remove unnecessary bitfuncs.h
      staging: brcm80211: Remove unnecessary hndtcam.h
      staging: brcm80211: Remove dead code from linux_osl.c.
      staging: brcm80211: Remove dead code from bcmwifi.c
      staging: brcm80211: Remove dead code from siutils.c
      staging: brcm80211: Removed unnecessary pktsetprio() function.
      staging: brcm80211: Remove unnecessary includes from bcmutils.c
      staging: brcm80211: Remove unnecessary header files.
      staging: brcm80211: brcmfmac: Removed codeversion from firmware filenames.

Ivan Gomez Castellanos (11):
      staging: tidspbridge: Move sync.c from services to core
      staging: tidspbridge: Remove ntfy.c
      staging: tidspbridge: Remove cfg_get_auto_start()
      staging: tidspbridge: Remove cfg_init() and cfg_exit()
      staging: tidspbridge: Remove cfg_get_dev_object() and do a trivial cleanup
      staging: tidspbridge: Remove cfg_get_exec_file()
      staging: tidspbridge: Remove cfg_get_object()
      staging: tidspbridge: Remove cfg_set_dev_object()
      staging: tidspbridge: Remove cfg_set_object()
      staging: tidspbridge: Remove cfg.c and cfg.h files
      staging: tidspbridge: Remove services.c and services.h

Jacob Smith (1):
      staging: rt2860: rtmp: Fixed coding style issue in rtmp.h

Jarod Wilson (1):
      Staging: lirc: fix compiler warning

Jason Cooper (51):
      staging: brcm80211: fix 'ERROR: "foo * bar" should be "foo *bar"'
      staging: brcm80211: fix "ERROR: open brace '{' following function dec..."
      staging: brcm80211: fix "ERROR: return is not a function, paren..."
      staging: brcm80211: fix "ERROR: do not use assignment in if condition"
      staging: brcm80211: fix "ERROR: trailing statements should be on next line"
      staging: brcm80211: fix "ERROR: that open brace { ... prev line"
      staging: brcm80211: fix "ERROR: while should follow close brace '}'"
      staging: brcm80211: fix "ERROR: do not initialise globals to 0 or NULL"
      staging: brcm80211: fix "ERROR: do not initialise statics to 0 or NULL"
      staging: brcm80211: fix "ERROR: Macros w/ complex values ... parenthesis"
      staging: brcm80211: fix "ERROR: Macros w/ mult. statements ... do - while loop"
      staging: brcm80211: fix 'ERROR: "(foo*)" should be "(foo *)"'
      staging: brcm80211: fix "ERROR: need consistent spacing around '*'"
      staging: brcm80211: fix "ERROR: space prohibited after that ..."
      staging: brcm80211: fix "ERROR: space prohibited before ...close square bracket"
      staging: brcm80211: fix "ERROR: space required after that close brace"
      staging: brcm80211: fix "ERROR: space required after that ..."
      staging: brcm80211: fix "ERROR: space required before that ..."
      staging: brcm80211: fix "ERROR: spaces prohibited around that ':' ..."
      staging: brcm80211: fix "ERROR: spaces required around that ..."
      staging: brcm80211: fix "ERROR: trailing whitespace."
      staging: brcm80211: fix remaining checkpatch errors.
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: fix checkpatch errors 'assignment in if condition'
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: fix checkpatch error 'assignment in if condition'
      staging: brcm80211: brcmfmac/*: fix remaining 'assignment in if condition'
      staging: brcm80211: fix 'do not init globals to 0 or NULL'
      staging: brcm80211: fix 'do not init statics to 0 or NULL'
      staging: brcm80211: fix various checkpatch spacing errors.
      staging: brcm80211: fix checkpatch macro errors.
      staging: brcm80211: wl_cfg80211.c: fix 'assignment in if condition'
      staging: brcm80211: remove ';' after while() in macros.
      staging: brcm80211: remove kernel_thread() for dhd_watchdog_thread.
      staging: brcm80211: remove kernel_thread() for dhd_dpc_thread.
      staging: brcm80211: remove kernel_thread() for _dhd_sysioc_thread.
      staging: brcm80211: remove kernel_thread() for _iscan_sysioc_thread.
      staging: brcm80211: remove kernel_thread() for wl_iscan_thread and wl_event_thread.
      staging: brcm80211: remove BLOCKABLE so no one uses it.
      staging: brcm80211: fix 'comparison..cast' compiler warnings.
      staging: brcm80211: s/unsigned char/size_t/ for min_t()
      staging: brcm80211: fix various checkpatch errors.
      staging: brcm80211: remove BCMINITDATA() macro.
      staging: brcm80211: remove BCMINITFN() macro.
      staging: brcm80211: remove BCMUNINITFN() macro.
      staging: brcm80211: remove BCMNMIATTACHFN() macro.

Javier Martinez Canillas (19):
      staging: comedi (dt3000): use PCI_DEVICE() macro
      staging: comedi (cb_pcidas64): use PCI_DEVICE() macro
      staging: comedi (adv_pci1723): use PCI_DEVICE() macro
      staging: comedi (adv_pci1710): use PCI_DEVICE() macro
      staging: comedi (skel): use PCI_DEVICE() macro
      staging: comedi (adl_pci9118): use PCI_DEVICE() macro
      staging: comedi (adl_pci6208): use PCI_DEVICE() macro
      staging: comedi (adv_pci_dio): use PCI_DEVICE() macro
      staging: comedi (cb_pcimdas): use PCI_DEVICE() macro
      staging: comedi (me4000): use PCI_DEVICE() macro
      staging: comedi (rtd520): use PCI_DEVICE() macro
      staging: comedi (cb_pcidio): user PCI_DEVICE() macro
      staging: comedi (cb_pcidda): use PCI_DEVICE() macro
      staging: comedi (cb_pcidas): use PCI_DEVICE() macro
      staging: xgifb: use DEFINE_PCI_DEVICE_TABLE() macro
      staging: xgifb: Removes unused variable
      staging: xgifb: Initialize uninitialized variables
      staging : xgifb: Removes compilation conditionals
      staging: xgifb: Removes unnecesary log

Jiri Slaby (3):
      Staging: lirc, fix NULL dereference
      Staging: lirc, fix lock imbalance
      Staging: ath6kl, remove unneeded ptr checking

Joe Perches (3):
      staging: lirc: Remove unnecessary casts of private_data
      staging: msm: Remove pr_<level> uses of KERN_<level>
      staging: Use static const char * const where possible

Jonathan Cameron (49):
      staging: iio: convert idr to ida as pointer never provided
      staging: iio: simplify logic in iio_interrupt_handler
      staging: iio: unecessary header removal and kernel doc clean up
      staging: iio: Remove long dead function definitions from headers
      staging: iio: Remove deprecated ATTR_TEMP in favour of ATTR_TEMP_RAW
      staging: iio: Make use of the convenient IIO_TRIGGER_NAME_ATTR macro
      staging: iio: remove odd structure definition.
      staging: iio: lis3l02dqbuffersimple.c bring example up to date.
      staging: iio: documentation - partial update to make more of it true.
      staging: iio: lis3l02dq add _type attributes for all scan elements
      staging: iio: max1363 add _type attributes for all scan elements
      staging: iio: adis16209 add _type attributes for all scan elements
      staging: iio: adis16240 add _type attributes for all scan elements
      staging: iio: sca3000 add _type attributes for all scan elements
      staging: iio: adis16260 add _type attributes for all scan elements
      staging: iio: adis16300 add _type attributes for all scan elements
      staging: iio: adis16350 add _type attributes for all scan elements
      staging: iio: adis16400 add _type attributes for all scan elements
      staging: iio: Remove unused bit_count from struct iio_scan_el
      staging: iio: amend macros for SCAN_EL creation to add separate index attr
      staging: iio: lis3l02dq add _index attribute registration
      staging: iio: adis16209 add _index attribute registration
      staging: iio: adis16240 add _index attribute registration
      staging: iio: adis16260 add _index attribute registration
      staging: iio: adis16300 add _index attribute registration
      staging: iio: adis16350 add _index attribute registration
      staging: iio: adis16400 add _index attribute registration
      staging: iio: max1363 add _index attribute registration
      staging: iio: sca3000 add _index attribute registration
      staging: iio: remove deprecated form of scan_el attribute naming.
      staging: iio: sysfs abi documentation. Add _type and _index attrs
      staging: iio: timestamp_en naming typo fix.
      staging: iio: sca3000 fix bug due to scan_element directory move.
      staging: iio: max1363 fix bug due to scan_element directory move.
      staging: iio: events define macros for new event code system
      staging: iio: adc events update to new numbering system
      staging: iio: lis3l02dq move to new event code scheme
      staging: iio: sca3000 move to new event code scheme and add combined orientations
      staging: iio: accel remove old event codes
      staging: iio: tsl2563 move to new event numbering scheme and remove old definitions
      staging: iio: events move buffer codes so they do not clash with new scheme
      staging: iio: lis3l02dq event attribute renames
      staging: iio: sca3000 event attribute name updates
      staging: iio: accel remove deprecated and misleading event macros.
      staging: iio: tsl2563 event attribute name updates
      staging: iio: light remove empty light.h file
      staging: iio: events update documentation to match new abi.
      staging: iio: adc add numbers to naming of all adc channels as needed to associate events with them.
      staging: iio: update example application.

Julia Lawall (6):
      staging: Drop unnecessary null test
      drivers/staging/iio: call mutex_unlock in error handling code
      staging: Use available error codes
      staging: rtl8193*: Remove double test
      Staging: comedi: Fix unsigned return type
      staging: tidspbridge: Clean up error-handling code

Justin P. Mattock (1):
      staging: update web addresses in staging

Krzysztof Halasa (1):
      Staging: Add SBE 2T3E3 WAN driver

Kulikov Vasiliy (10):
      staging: vt6655: do not use PCI resources before pci_enable_device()
      staging: crystalhd: call disable_pci_device() if pci_probe() failed
      staging: rtl8187se: call disable_pci_device() if pci_probe() failed
      staging: spectra: call disable_pci_device() if pci_probe() failed
      staging: rtl8187e: call disable_pci_device() if pci_probe() failed
      staging: sm7xx: call disable_pci_device() if pci_probe() failed
      staging: cx25821: call disable_pci_device() if pci_probe() failed
      staging: usbip: fix memory leak
      staging: tm6000: fix memory leak
      staging: adis16255: fix sysfs leak

Larry Finger (9):
      staging: r8712u: Add the new driver to the mainline kernel
      staging: r8712u: Fix rate setting when HT is not enabled
      staging: r8712u: Fix sparse warnings
      staging: r8712u: Use 802.11bg mode to make a WEP connection
      staging: r8712u: Add module parameter to disable turbo mode
      staging: r8712u: Fix potential crash issue
      staging: r8712u: Update driver version to v7_0.20100831
      staging: r8712u: Add TODO to driver files
      staging: r8712u: Update copy-to list for patches

Linus Lüssing (2):
      Staging: batman-adv: Always synchronize rcu's on module shutdown
      Staging: batman-adv: Fix resizing of broadcast seqno buffers on if deletion

Luis Bosch (1):
      staging: vt6656: resolved checkpatch finding

Luis R. Rodriguez (1):
      staging: remove the Atheros otus vendor driver

Manuel Stahl (9):
      staging: iio rename ring attributes
      staging: iio: lis3l02dq adjust lis3l02dq_configure_ring
      staging: iio move scan_elements into ring buffer
      staging: iio partial documentation update
      staging: iio sync drivers with current ABI
      staging: iio sync scale units
      staging: iio: hmc5843 change ABI to comply with documentation
      staging: iio: sca3000 fix sca3000_[show,store]_ring_bpse
      staging: iio: sca3000 convert byte order of ring buffer data

Marek Belisko (26):
      Staging: Add support for Flarion OFDM usb and pcmcia devices.
      staging: ft1000-usb: Add correct procedure for fw image downloading.
      staging: ft1000-usb: Remove global flag DSP_loading.
      staging: ft1000: Fix memory leak when polling fail.
      staging: ft1000: Remove unused/unnecessary comments.
      staging: ft1000: get rid of typedef usage.
      staging: ft1000: various checkpatch.pl fixes.
      staging: ft1000: lines over 80 characters corrected.
      staging: ft1000: replace and remove c99 comments.
      staging: ft1000: correct indentations for ft1000_usb.c file.
      staging: ft1000: remove dead code.
      staging: ft1000: Get rid of using atoi.
      staging: ft1000: Use specific error return value.
      staging: ft1000: Remove unused function ft1000_hbchk()
      staging: ft1000: Remove MEDIAMSG typedef usage.
      staging: ft1000: Remove DSPINITMSG typedef usage.
      staging: ft1000: Remove APP_INFO_BLOCK typedef usage.
      staging: ft1000: Remove PROV_RECORD typedef usage.
      staging: ft1000: Remove PSEUDO_HDR typedef usage.
      staging: ft1000: Remove DRVMGS typedef usage.
      staging: ft1000: Check return value when init net device.
      staging: ft1000: Use specific return error codes.
      staging: ft1000: Use specific error return code for reg_ft1000_netdev().
      staging: ft1000: Get rid of using typedef.
      staging: ft1000: Remove dead code from ft1000_hw.c
      staging: ft1000: Remove FT1000_INFO typedef usage.

Marek Lindner (10):
      Staging: batman-adv: refactoring unicast payload code
      Staging: batman-adv: register the batman-adv packet type per interface
      Staging: batman-adv: attach each hard-interface to a soft-interface
      Staging: batman-adv: multiple mesh clouds
      Staging: batman-adv: removing redundant assignment of skb->dev
      Staging: batman-adv: Introduce update_primary_addr to update mac address
      Staging: batman-adv: document fragmentation sysfs API
      Staging: batman-adv: protect against ogm packet overflow by checking table length
      Staging: batman-adv: fix crash when new OGM is generated
      Staging: batman-adv: process OGMs bigger than MAX_AGGREGATION_BYTES

Markus Grabner (3):
      staging: line6: sync with upstream
      Staging: line6: another upstream sync
      Staging: line6: workaround for null pointer bug

Maurice Dawson (6):
      Staging: comedi: fix space coding style issue in adl_pci9111.c
      Staging: comedi: fix macro coding style issue in adl_pci9111.c
      Staging: comedi: fix printk() coding style issue in adl_pci9111.c
      Staging: comedi: fix EXPORT SYMBOL coding style issue in ni_labpc.c
      staging: comedi: file: Removed whitespaces before quoted newlines
      Staging: comedi: file: Removed braces from some statement blocks

Max Vozeler (2):
      staging: usbip: Notify usb core of port status changes
      staging: usbip: Process event flags without delay

Michael Hennerich (13):
      staging: iio: adc: Enable driver support for ad799x AD converters
      staging: iio: adc: Address mailing list feedback by Jonathan Cameron
      staging: iio: adc: ad799x: prevent buffer overflow
      staging: iio: adc: max1363: prevent buffer overflow
      staging: iio: adc: ad799x: Address iio list feedback
      staging: iio: iio_ring_rip_outer return immediately if rip_lots returns <= 0
      staging: iio: adc: max1363: remove unused variable
      staging: iio: adc: ad799x drop in_precision in favor of new in_type
      staging: iio: ring_generic: provide IIO_CONST_ATTR_SCAN_EL_TYPE_WITH_SHIFT
      staging: iio: adc: ad7476 new SPI ADC driver
      staging: iio: adc: ad7476 more list review feedback by Jonathan Cameron
      staging: iio: adc: ad799x miscellaneous cleanups
      staging: iio: ad7476: fix !CONFIG_IIO_RING_BUFFER build issue reported by Randy Dunlap

Michael Prokop (1):
      Staging: cxt1e1: Kconfig: SBE_PMCC4_NCOMM can not be compiled as module, adjust help description

Mike McCormack (38):
      Staging: rtl8192e: Delete unused function dm_shadow_init()
      Staging: rtl8192e: Simplify some return codes
      Staging: rtl8192e: Remove backslashes at end of lines
      Staging: rtl8192e: Make functions static
      Staging: rtl8192e: Don't compare bHwRadioOff with true
      Staging: rtl8192e: Remove unused function
      Staging: rtl8192e: Remove unnecessary externs
      Staging: rtl8192e: Remove pointless return statements
      Staging: rtl8192e: Remove redundant brackets around return values
      Staging: rtl8192e: Remove some redundant code
      Staging: rtl8192e: Remove function name comments at end of functions
      Staging: rtl8192e: Remove some commented out code
      Staging: rtl8192e: Remove unused macros
      Staging: rtl8192e: Remove function with no effect
      Staging: rtl8192e: Remove extern and redundant declarations
      Staging: rtl8192e: Remove some redundant comments
      Staging: rtl8192e: Fix indent in some places
      Staging: rtl8192e: Less verbose function headers
      staging: rtl8192e: Delete dead and commented out code
      staging: rtl8192e: Clean up function headers
      staging: rtl8192e: Clean up rtl8192_hard_data_xmit()
      staging: rtl8192e: Remove empty function force_pci_posting()
      staging: rtl8192e: Remove commented function rtl8192_set_mode()
      staging: rtl8192e: Remove dead code from rtl8192_set_chan()
      staging: rtl8192e: Fix indent of some functions
      staging: rtl8192e: Remove dead code in CamResetAllEntry()
      staging: rtl8192e: Remove some dead code
      staging: rtl8192e: Clean up rtl8192_hard_start_xmit()
      Staging: rtl8192e: Clean up rtl8192_net_update()
      Staging: rtl8192e: Clean up formatting in MapHwQueueToFirmwareQueue()
      Staging: rtl8192e: Delete some dead code
      Staging: rtl8192e: Clean up rtl8192_qos_association_resp()
      Staging: rtl8192e: Clean up rtl8192_halt_adapter()
      Staging: rtl8192e: Remove dead code from rtl8192_tx
      Staging: rtl8192e: Clean formatting in rtl8192_tx()
      Staging: rtl8192e: Clean up rtl8192_pci_initdescring()
      Staging: rtl8192e: Clean formatting in rtl8192_hard_start_xmit()
      Staging: rtl8192e: Convert macros to inline functions

Neil Munro (3):
      Staging: RT2860: Fixed both coding style errors in eeprom.h
      Staging: RT2860: Fixed the spacing error in oid.h
      Staging: RT2860: Fixed all warnings and errors in the iface directory

Nicolas Kaiser (3):
      staging: tidspbridge: remove duplicated include
      staging: lirc: remove duplicated include
      staging: spectra: remove duplicated includes

Nikitas Angelinas (1):
      Staging: vt6656: use ARRAY_SIZE macro in channel.c

Nitin Gupta (4):
      Staging: zram: Replace ioctls with sysfs interface
      Staging: zram: Document sysfs entries
      Staging: zram: Remove need for explicit device initialization
      Staging: zram: Update zram documentation

Nohee Ko (1):
      staging: brcm80211: fix #ifdef BRCM_FULLMAC mess

Omar Ramirez Luna (1):
      staging: tidspbridge: bind driver name to device name

Pavan Savoy (10):
      Staging: ti-st: remove st_get_plat_device
      staging: ti-st: fix kim platform device id
      staging: ti-st: set right the data types
      staging: ti-st: mv headers to ti_wilink_st
      tty.h: new ldisc for TI WiLink ST
      staging: ti-st: drop the __KERNEL__
      staging: ti-st: mv ti_wilink_st header
      staging: ti-st: move TI_ST from staging to misc/
      misc: ti-st: Kconfig & Makefile for TI_ST
      drivers: misc: ti-st: fix review comments

Pekka Enberg (10):
      staging: w35und: Kill dead HAL macros in wbhal_f.h
      staging: w35und: Remove remaining typedef declarations
      staging: w35und: Kill unused scan_s.h header
      staging: w35und: Remove dead code from mlme_s.h
      staging: w35und: Inline mlme_s.h to core.h
      staging: w35und: Remove unused spinlocks
      staging: w35und: Remove unused fields from struct wbsoft_priv
      staging: w35und: Use NETDEV_TX_BUSY if MLMESendFrame fails
      staging: w35und: Inline MLMESendFrame() to wbsoft_tx()
      staging: w35und: Add locking problems to TODO list

Phillip Kurtenbach (1):
      staging: iio: whitespace cleanup

Prashant P. Shah (7):
      Staging: solo6x10: fixed assignments in if conditions in solo6010-core.c
      Staging: xgifb: fixed many style issue in vb_ext.c
      Staging: xgifb: fixed many style issue in vb_setmode.c
      Staging: xgifb: fixed many style issues in vb_init.c
      Staging: xgifb: fixed many style issues in vb_util.c
      Staging: xgifb: fixed many style issues in XGI_main_26.c
      Staging: otus: removes global variable initialization to 0 in wwrap.c

Ramkumar Ramachandra (1):
      Staging: rtl8192e: Cleanup style and whitespace

Randy Dunlap (8):
      Staging: xgifb: fix lots of sparse warnings
      staging/keucr: update TODO list and ask question about it
      staging/keucr: fix build when CONFIG_PM is not enabled
      staging/bcm: fix printk format warnings
      staging/bcm: fix build for CONFIG_PM not enabled
      staging: ST_BT depends on RFKILL
      staging: intel_sst: include delay.h to fix build error
      staging: speakup: fix printk format warning

Rhyland Klein (1):
      staging: iio: light: Adding driver for ISL29018 ALS

Roberto Rodriguez Alkala (1):
      staging: otus: fix compile warning and some style issues

Simon Wunderlich (2):
      Staging: batman-adv: Count Ethernet header for incoming packets
      Staging: batman-adv: move queue counters into bat_priv

Stefan Weil (1):
      Staging: rtl81*: Fix spelling fuction -> function in comments

Stephen Hemminger (1):
      staging: Beeceem USB Wimax driver

Sunny Aujla (1):
      Staging: comedi: fix brace coding style issue in dt2817.c

Sven Eckelmann (29):
      Revert: "Staging: batman-adv: Adding netfilter-bridge hooks"
      Staging: batman-adv: Remove CHANGELOG
      Staging: batman-adv: Start new development cycle
      Staging: batman-adv: Calculate hamming weight using optimized kernel functions
      Staging: batman-adv: Directly prepare icmp packets in socket buffer
      Staging: batman-adv: Keep header writable and unshared
      Staging: batman-adv: Only clone skb data for multiple broadcasts
      Staging: batman-adv: Aggregate batman packets directly in skb
      Staging: batman-adv: Prepare vis packets directly inside a skb
      Staging: batman-adv: Create copy of skb with pre-allocated headroom
      Staging: batman-adv: Provide full headers and packets as linear skb
      Staging: batman-adv: Remove duplicate of attached device name
      Staging: batman-adv: Don't inform about dropped packets in nodebug
      Staging: batman-adv: Update mtu of bat device by changing mtu of slave device
      Staging: batman-adv: Remove currently unused gw_* datastructures
      Staging: batman-adv: Add rcu TODO
      Staging: batman-adv: checkpatch cleanup of comments
      Staging: batman-adv: Move mailing list address to .org
      Staging: batman-adv: Mark debugfs files as nonseekable
      Staging: batman-adv: wait for call_rcu before unloading module
      Staging: batman-adv: Introduce if_list_lock to protect if_list
      Staging: batman-adv: Always protect list_for_each_entry_rcu with RCU
      Staging: batman-adv: Remove unneeded rcu_read_lock
      Staging: batman-adv: Use synchronize_rcu instead of call_rcu
      Staging: batman-adv: Use refcnt to track usage count of batman_if
      Staging: batman-adv: count batman_if list queries as reference
      Staging: batman-adv: Track references of batman_if in set_primary_if
      Staging: batman-adv: Add hash recommendations to TODO
      Staging: batman-adv: Don't dereference unchecked incoming soft_iface

Thomas Gleixner (1):
      staging: Bulk convert the semaphore mess

Tracey Dent (60):
      Staging: rtl8187se: r8180.h: fixed alot of checkpatch.pl issues
      Staging: rtl8187se: r8180_hw: fixed a lot of checkpatch.pl issues
      Staging: rtl8187se: r8180_rtl8225: fixed a lot of checkpatch.pl issues
      Staging: rtl8187se: r8180_wx: fixed a lot of checkptahc.pl issues
      Staging: rtl8187se: r8185b_init: fixed a lot of checkpatch.pl issues
      Staging: cx25821: Makefile: cleaned up Makefile cflag lines
      Staging: wlags49_h2: Makefile: cleaned up Makefile cflag lines
      Staging: vt6655: Makefile: cleaned up Makefile cflag lines
      Staging: vt6656: Makefile: cleaned up Makefile cflag lines
      Staging: wlags49_h25: Makefile: cleaned up Makefile cflag lines
      Staging: rtl8192u: ieee80211: Makefile: cleaned up Makefile cflag lines
      Staging: rtl8192e: Makefile: cleaned up Makefile cflag lines
      Staging: tm6000: Makefile: cleaned up Makefile cflag lines
      Staging: rtl8187se: Makefile: cleaned up Makefile cflag lines
      Staging: cxt1e1: Makefile: cleaned up Makefile cflag lines
      Staging: dream: camera: Makefile: cleaned up Makefile cflag lines
      Staging: dream: Makefile: cleaned up Makefile cflag lines
      Staging: rt2870: Makefile: cleaned up Makefile cflag lines
      Staging: easycap: Makefile: cleaned up Makefile cflag lines
      Staging: dream: qdsp5: Makefile: cleaned up Makefile cflag lines
      Staging: usbip: Makefile: cleaned up Makefile cflag lines
      Staging: rt2860: Makefile: cleaned up Makefile cflag lines
      Staging: rtl8192u: Makefile: cleaned up Makefile cflag lines
      Staging: autofs: Makefile: replace the use of <module>-objs with <module>-y
      Staging: tidspbridge: Makefile: replace the use of <module>-objs with <module>-y
      Staging: winbond: Makefile: replace the use of <module>-objs with <module>-y
      Staging: tm6000: Makefile: replace the use of <module>-objs with <module>-y
      Staging: xgifb: Makefile: replace the use of <module>-objs with <module>-y
      Staging: zram: Makefile: replace the use of <module>-objs with <module>-y
      Staging: usbip: Makefile: replace the use of <module>-objs with <module>-y
      Staging: rtl8192u: Makefile: replace the use of <module>-objs with <module>-y
      Staging: wlan-ng: Makefile: replace the use of <module>-objs with <module>-y
      Staging: solo6x10: Makefile: replace the use of <module>-objs with <module>-y
      Staging: keucr: Makefile: Makefile clean up
      Staging: smbfs: Makefile: Makefile clean up
      Staging: sbe-2t3e3: Makefile: replace the use of <module>-objs with <module>-y
      Staging: rtl8712: Makefile: replace the use of <module>-objs with <module>-y
      Staging: rtl8187se: Makefile: replace the use of <module>-objs with <module>-y
      Staging: rt2860: Makefile: replace the use of <module>-objs with <module>-y
      Staging: rt2870: Makefile: replace the use of <module>-objs with <module>-y
      Staging: octeon: Makefile: replace the use of <module>-objs with <module>-y
      Staging: line6: Makefile: replace the use of <module>-objs with <module>-y
      Staging: intel_sst: Makefile: replace the use of <module>-objs with <module>-y
      Staging: hv: Makefile: replace the use of <module>-objs with <module>-y
      Staging: ft1000: ft1000-usb: Makefile: replace the use of <module>-objs with <module>-y
      Staging: et131x: Makefile: replace the use of <module>-objs with <module>-y
      Staging: ft1000:ft1000-pcmia: Makefile: replace the use of <module>-objs with <module>-y
      Staging: go7007: Makefile: makefile cleanup
      Staging: cxt1e1: Makefile: replace the use of <module>-objs with <module>-y
      Staging: easycap: Makefile: replace the use of <module>-objs with <module>-y
      Staging: cx25821: Makefile: replace the use of <module>-objs with <module>-y
      Staging: crystalhd: Makefile: replace the use of <module>-objs with <module>-y
      Staging: comedi: Makefile: replace the use of <module>-objs with <module>-y
      Staging: bcm: Makefile: replace the use of <module>-objs with <module>-y
      Staging: batman-adv: Makefile: replace the use of <module>-objs with <module>-y
      Staging: speakup: Makefile: Makefile clean up
      Staging: speakup: keyhelp: Coding style fix
      Staging: speakup: devsynth: file_operations should be const
      Staging: speakup: serialio: Fixed errors in file
      Staging: speakup: i18n.c: cleaned up file

Uwe Kleine-König (6):
      staging/comedi: fix syntax error
      staging/trivial: fix typos concerning "access"
      staging/trivial: fix typos concerning "address"
      staging/trivial: fix typos concerning "initiali[zs]e"
      staging/trivial: fix typos concerning "management"
      staging/trivial: fix typos concerning "through"

Vasiliy Kulikov (25):
      staging: tidspbridge: check return code of kzalloc
      staging: rtl8192u: improve error path
      staging: tidspbridge: check return code of get_user
      staging: comedi: check return code of put_user
      staging: ath6kl: check return code of get_user and put_user
      staging: westbridge: improve error path
      Staging: batman-adv: check kmalloc() return value
      staging: solo6010: fix signess bug
      staging: crystalhd: fix signed bug
      staging: comedi: fix signess bug
      staging: keucr: check kmalloc() return value
      staging: spectra: off by one
      staging: ft1000: fix skb, netdev, memory leaks
      staging: wlags49_h2: use free_netdev(netdev) instead of kfree()
      staging: otus: use free_netdev(netdev) instead of kfree()
      staging: ath6kl: use free_netdev(netdev) instead of kfree()
      staging: octeon: use free_netdev(netdev) instead of kfree()
      staging: slicoss: use free_netdev(netdev) instead of kfree()
      staging: ft1000: fix error path
      staging: ft1000: fix kernel info leak to userland for statistics
      staging: tidspbridge: fix signess error
      staging: intel_sst: fix signess error
      staging: intel_sst: use signed int for error codes
      staging: speakup: fix leaks of sysfs groups
      staging: speakup: fix memory leak

Victor Rosales (2):
      staging: vt6656: removed extra spaces
      staging: winbond: mds.c: Fixed all checkpatch's errors

Vinod Koul (2):
      Staging: sst: Intel SST audio driver
      staging: sst: remove the kernel locking in ioctl

Vipin Mehta (6):
      staging: add ath6kl driver for AR6003 chip
      staging: ath6kl: Fixing a compilation error introduced by commit ec53d6123bea9f69887f194b5d4294a43292120d.
      staging: ath6kl: Eliminating the symlink to 2.0 header files
      staging: ath6kl: Removing duplicate includes
      staging: ath6kl: Fixing a compile error
      staging: ath6kl: Fixing a race condition during initialization

William Hubbs (12):
      Staging: add speakup to the staging directory
      staging: speakup: devsynth.c: style fixes
      staging: speakup: i18n.c: style fixes
      staging: speakup: keyhelp.c: style fixes
      staging: speakup: kobjects.c: style fixes
      staging: speakup: i18n.c fix long lines
      staging: speakup: main.c style fixes
      staging: speakup: selection.c style fixes
      staging: speakup: serialio.c style fixes
      staging: speakup: synth.c style fixes
      staging: speakup: thread.c style fixes
      staging: speakup: varhandlers.c style fixes

matias (1):
      staging: vt6656: delete some parenthesis

mike.rapoport@gmail.com (7):
      staging: brcm80211: remove OSL_DELAY
      staging: brcm80211: remove DHD_USE_STATIC_BUF
      staging: brcm80211: remove osl_malloced()/MALLOCED()
      staging: brcm80211: replace MALLOC() with k[zm]alloc
      staging: brcm80211: remove unused NATIVE_{MALLOC,MFREE}
      staging: brcm80211: replace MFREE with kfree
      staging: brcm80211: remove unrefrenced malloced field

nohee ko (17):
      staging: brcm80211: bug fix for n_ssids usage and update drv_info
      staging: brcm80211: remove duplicated file, bcmwifi.c
      staging: brcm80211: removed duplicated file, linux_osl.c
      staging: brcm80211: bug fix - connection status report
      staging: brcm80211: bug fix- dual band problem
      staging: brcm80211: remove duplicated file, bcmutils.c
      staging: brcm80211: remove unnecessary cflag, BCMWPA2
      staging: brcm80211: remove unnecessary cflag, CONFIG_CFG80211
      staging: brcm80211: remove unnecessary cflag, LINUX
      staging: brcm80211: remove duplicated function, wf_channel2mhz
      staging: brcm80211: bug fix- rmmod hang problem
      staging: brcm80211: brcmfmac: replace KILL_PROC with send_sig()
      staging: brcm80211: brcmfmac: bug fix - scan result report
      staging: brcm80211: brcmfmac: remove unnecessary cflags, WL_ISCAN_DISABLED & WL_ROAM_DISABLED
      staging: brcm80211: brcmfmac: enable passive, active scan selection
      staging: brcm80211: brcmfmac: add profile, beacon_int, dtim_period
      staging: brcm80211: brcmfmac: add debugfs, display wi-fi statistics

