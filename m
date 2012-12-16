Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2LPM2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:28:47 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:34783 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2LPM2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:28:45 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: wlan-ng: Update get_tx_power()/set_tx_power() signature
Date: Sun, 16 Dec 2012 13:28:42 +0100
Message-Id: <1355660922-12833-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from drivers/staging/wlan-ng/p80211netdev.c:92:
drivers/staging/wlan-ng/cfg80211.c:735: warning: initialization from incompatible pointer type
drivers/staging/wlan-ng/cfg80211.c:736: warning: initialization from incompatible pointer type

Cfr. commit c8442118ad9cd05cfe3b993f058e70ab25b1009a ("cfg80211: allow per
interface TX power setting"), which added a new parameter.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/wlan-ng/cfg80211.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 18c06a5..1d31eab 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -638,8 +638,8 @@ int prism2_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 }
 
 
-int prism2_set_tx_power(struct wiphy *wiphy, enum nl80211_tx_power_setting type,
-			int mbm)
+int prism2_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
+			enum nl80211_tx_power_setting type, int mbm)
 {
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = priv->wlandev;
@@ -665,7 +665,8 @@ exit:
 	return err;
 }
 
-int prism2_get_tx_power(struct wiphy *wiphy, int *dbm)
+int prism2_get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
+			int *dbm)
 {
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = priv->wlandev;
-- 
1.7.0.4

