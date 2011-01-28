Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1A1EFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:16 -0500
Received: from mail.perches.com ([173.55.12.10]:3444 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1A1EEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:54 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] staging: ath6kl: cfg80211: Convert forceFgScan to A_UINT32
Date: Thu, 27 Jan 2011 20:04:28 -0800
Message-Id: <6439db44bee5d029f180a909058da3c0d2462f77.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's declared that way in the prototype, use it that way too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index e3dc99a..936879e 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -726,7 +726,7 @@ ar6k_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(ndev);
     int ret = 0;
-    A_BOOL forceFgScan = FALSE;
+    A_UINT32 forceFgScan = 0;
 
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("%s: \n", __func__));
 
@@ -765,7 +765,7 @@ ar6k_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
     }
 
     if(ar->arConnected) {
-        forceFgScan = TRUE;
+        forceFgScan = 1;
     }
 
     if(wmi_startscan_cmd(ar->arWmi, WMI_LONG_SCAN, forceFgScan, FALSE, \
-- 
1.7.4.rc3

