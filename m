Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1A1EEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:04:43 -0500
Received: from mail.perches.com ([173.55.12.10]:3416 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab1A1EEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:41 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/15] staging: ath6kl: Update cfg80211 to recent calling convention changes
Date: Thu, 27 Jan 2011 20:04:18 -0800
Message-Id: <9f92ccc5786180a9055ee22b28d1b6ea8cbda425.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bool unicast and bool multicast to set_default_key
Return struct net_device * to add_virtual_intf

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 7269d0a..cbd9d55 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -978,7 +978,7 @@ ar6k_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 
 static int
 ar6k_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *ndev,
-                              A_UINT8 key_index)
+                              A_UINT8 key_index, bool unicast, bool multicast)
 {
     AR_SOFTC_T *ar = (AR_SOFTC_T *)ar6k_priv(ndev);
     struct ar_key *key = NULL;
@@ -1201,7 +1201,7 @@ ar6k_cfg80211_set_power_mgmt(struct wiphy *wiphy,
     return 0;
 }
 
-static int
+static struct net_device *
 ar6k_cfg80211_add_virtual_intf(struct wiphy *wiphy, char *name,
             				    enum nl80211_iftype type, u32 *flags,
             				    struct vif_params *params)
@@ -1212,7 +1212,7 @@ ar6k_cfg80211_add_virtual_intf(struct wiphy *wiphy, char *name,
     /* Multiple virtual interface is not supported.
      * The default interface supports STA and IBSS type
      */
-    return -EOPNOTSUPP;
+    return ERR_PTR(-EOPNOTSUPP);
 }
 
 static int
-- 
1.7.4.rc3

