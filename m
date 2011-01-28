Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1A1EEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:04:42 -0500
Received: from mail.perches.com ([173.55.12.10]:3413 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab1A1EEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:41 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [git pull-request and PATCH 00/15] staging: ath6kl: Cleanups
Date: Thu, 27 Jan 2011 20:04:17 -0800
Message-Id: <cover.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First block of many patches to be sent in blocks of 15.

The following changes since commit af109f2e323e9dc6aeb49962e3bc0237ce653cb9:

  Staging: Westbridge: fix EXPORT_SYMBOL errors reported by checkpatch.pl (2011-01-26 15:02:53 +0800)

are available in the git repository at:
  git://repo.or.cz/linux-2.6/trivial-mods.git 20110127_ath6kl

Joe Perches (15):
  staging: ath6kl: Update cfg80211 to recent calling convention changes
  staging: ath6kl: Convert enum A_STATUS to int
  staging: ath6kl: Remove A_SUCCESS macro
  staging: ath6kl: Remove A_FAILED macro
  staging: ath6kl: wmi.h: Convert packed structures with A_BOOL to u32
  staging: ath6kl: Convert bypasswmi to bool
  staging: ath6kl: Convert type of streamExists to A_UINT8
  staging: ath6kl: Convert BDADDR_Present uses to TRUE/FALSE bugfix
  staging: ath6kl: Convert A_BOOL compressed sets from 0 to FALSE
  staging: ath6kl: Convert 0 to FALSE
  staging: ath6kl: cfg80211: Convert forceFgScan to A_UINT32
  staging: ath6kl: Convert A_UINT8 is_amsdu and is_acl_data_frame to A_BOOL
  staging: ath6kl: Convert A_NETBUF_QUEUE_EMPTY to return TRUE or FALSE
  staging: ath6kl: Convert sets of scanSpecificSsid to TRUE/FALSE.
  staging: ath6kl: Convert tspecCompliance from A_BOOL to int

 drivers/staging/ath6kl/bmi/include/bmi_internal.h  |    4 +-
 drivers/staging/ath6kl/bmi/src/bmi.c               |   80 ++--
 .../hif/sdio/linux_sdio/include/hif_internal.h     |   10 +-
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   52 +-
 .../ath6kl/hif/sdio/linux_sdio/src/hif_scatter.c   |   18 +-
 drivers/staging/ath6kl/htc2/AR6000/ar6k.c          |  102 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |   88 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k_events.c   |   66 ++--
 drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox.c    |   74 ++--
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |  123 +++---
 drivers/staging/ath6kl/htc2/htc.c                  |   28 +-
 drivers/staging/ath6kl/htc2/htc_internal.h         |    8 +-
 drivers/staging/ath6kl/htc2/htc_recv.c             |   92 ++--
 drivers/staging/ath6kl/htc2/htc_send.c             |   14 +-
 drivers/staging/ath6kl/htc2/htc_services.c         |   12 +-
 drivers/staging/ath6kl/include/a_debug.h           |    4 +-
 drivers/staging/ath6kl/include/ar3kconfig.h        |    4 +-
 drivers/staging/ath6kl/include/ar6000_diag.h       |   10 +-
 drivers/staging/ath6kl/include/bmi.h               |   34 +-
 drivers/staging/ath6kl/include/common/athdefs.h    |   78 ++--
 drivers/staging/ath6kl/include/common/wmi.h        |   16 +-
 drivers/staging/ath6kl/include/common_drv.h        |   24 +-
 drivers/staging/ath6kl/include/dset_api.h          |    4 +-
 drivers/staging/ath6kl/include/gpio_api.h          |   10 +-
 drivers/staging/ath6kl/include/hci_transport_api.h |   18 +-
 drivers/staging/ath6kl/include/hif.h               |   34 +-
 drivers/staging/ath6kl/include/htc_api.h           |   18 +-
 drivers/staging/ath6kl/include/htc_packet.h        |    2 +-
 drivers/staging/ath6kl/include/wlan_api.h          |    2 +-
 drivers/staging/ath6kl/include/wmi_api.h           |  274 +++++-----
 drivers/staging/ath6kl/miscdrv/ar3kconfig.c        |   76 ++--
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.c   |   28 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |    4 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c   |   22 +-
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.h   |    6 +-
 drivers/staging/ath6kl/miscdrv/common_drv.c        |   84 ++--
 drivers/staging/ath6kl/miscdrv/credit_dist.c       |    2 +-
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |    8 +-
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |  172 ++++----
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   34 +-
 drivers/staging/ath6kl/os/linux/ar6000_raw_if.c    |   14 +-
 drivers/staging/ath6kl/os/linux/ar6k_pal.c         |   20 +-
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   20 +-
 .../staging/ath6kl/os/linux/export_hci_transport.c |   28 +-
 drivers/staging/ath6kl/os/linux/hci_bridge.c       |   66 ++--
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    8 +-
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |   30 +-
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |    2 +-
 .../ath6kl/os/linux/include/export_hci_transport.h |   22 +-
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |   20 +-
 drivers/staging/ath6kl/os/linux/ioctl.c            |   45 +-
 drivers/staging/ath6kl/os/linux/netbuf.c           |   18 +-
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |   14 +-
 drivers/staging/ath6kl/reorder/rcv_aggr.c          |    4 +-
 drivers/staging/ath6kl/wlan/src/wlan_recv_beacon.c |    2 +-
 drivers/staging/ath6kl/wmi/wmi.c                   |  538 ++++++++++----------
 56 files changed, 1299 insertions(+), 1291 deletions(-)

-- 
1.7.4.rc3

