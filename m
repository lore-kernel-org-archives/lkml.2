Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab2K2Upt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:45:49 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40146 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab2K2Upp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:45:45 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: backports@vger.kernel.org, alexander.stein@systec-electronic.com,
        brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
        frankyl@broadcom.com, kanyan@broadcom.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, srinidhi.kasagar@stericsson.com,
        linus.walleij@linaro.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 5/6] brcmfmac: convert struct spinlock to spinlock_t
Date: Thu, 29 Nov 2012 12:45:09 -0800
Message-Id: <1354221910-22493-6-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
References: <1354221910-22493-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

spinlock_t should always be used.

  LD      drivers/net/wireless/brcm80211/built-in.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/fwil.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/fwil.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/fweh.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/fweh.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/dhd_common.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/usb.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/usb.o
  CHECK   drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.o
  LD [M]  drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.o
  LD      drivers/net/wireless/brcm80211/brcmsmac/built-in.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:1311:6: warning: context imbalance in 'brcms_down' - unexpected unlock
drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c:1598:6: warning: context imbalance in 'brcms_rfkill_set_hw_state' - unexpected unlock
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/ucode_loader.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/ucode_loader.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/ampdu.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/antsel.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/antsel.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/channel.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/channel.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/main.c
drivers/net/wireless/brcm80211/brcmsmac/main.c:6246:36: warning: Initializer entry defined twice
drivers/net/wireless/brcm80211/brcmsmac/main.c:6246:43:   also defined here
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/main.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy_shim.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/pmu.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/pmu.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/rate.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/rate.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/stf.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/stf.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/aiutils.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c:3313:46: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c:17688:47: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c:18187:53: warning: cast truncates bits from constant value (ffff3fff becomes 3fff)
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c:21160:36: warning: cast truncates bits from constant value (ffff3fff becomes 3fff)
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c:23321:35: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c:28343:44: warning: cast truncates bits from constant value (ffff1fff becomes 1fff)
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_n.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_n.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/phy/phy_qmath.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/phy/phy_qmath.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/dma.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/dma.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.o
  CHECK   drivers/net/wireless/brcm80211/brcmsmac/debug.c
  CC [M]  drivers/net/wireless/brcm80211/brcmsmac/debug.o
  LD [M]  drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.o
  LD      drivers/net/wireless/brcm80211/brcmutil/built-in.o
  CHECK   drivers/net/wireless/brcm80211/brcmutil/utils.c
  CC [M]  drivers/net/wireless/brcm80211/brcmutil/utils.o
  LD [M]  drivers/net/wireless/brcm80211/brcmutil/brcmutil.o
  Building modules, stage 2.
  MODPOST 3 modules
  CC      drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.mod.o
  LD [M]  drivers/net/wireless/brcm80211/brcmfmac/brcmfmac.ko
  CC      drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.mod.o
  LD [M]  drivers/net/wireless/brcm80211/brcmsmac/brcmsmac.ko
  CC      drivers/net/wireless/brcm80211/brcmutil/brcmutil.mod.o
  LD [M]  drivers/net/wireless/brcm80211/brcmutil/brcmutil.ko

Cc: Brett Rudley <brudley@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Cc: Kan Yan <kanyan@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list@broadcom.com
Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index b39246a..240a2ea 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -158,7 +158,7 @@ typedef int (*brcmf_fweh_handler_t)(struct brcmf_if *ifp,
  */
 struct brcmf_fweh_info {
 	struct work_struct event_work;
-	struct spinlock evt_q_lock;
+	spinlock_t evt_q_lock;
 	struct list_head event_q;
 	int (*evt_handler[BRCMF_E_LAST])(struct brcmf_if *ifp,
 					 const struct brcmf_event_msg *evtmsg,
-- 
1.7.10.4

