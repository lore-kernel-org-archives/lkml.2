Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2L2P05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 10:26:57 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:46893 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2L2P0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 10:26:53 -0500
From: Emil Goode <emilgoode@gmail.com>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        krzysztof.wilczynski@linux.com, devendra.aaru@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] Staging: wlan-ng: Add missing argument
Date: Sat, 29 Dec 2012 16:27:17 +0100
Message-Id: <1356794837-14631-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit c8442118 introduced a struct wireless_dev pointer
as a second argument of the function pointers set_tx_power
and get_tx_power. This patch adds the missing arguments for
the wlan-ng driver.

Sparse warnings:

drivers/staging/wlan-ng/cfg80211.c:735:25: warning:
	incorrect type in initializer (incompatible argument 2
	(different base types))
	drivers/staging/wlan-ng/cfg80211.c:735:25:
	expected int ( *set_tx_power )( ... )
	drivers/staging/wlan-ng/cfg80211.c:735:25:
	got int ( extern [toplevel] *<noident> )( ... )

drivers/staging/wlan-ng/cfg80211.c:736:25: warning:
	incorrect type in initializer (incompatible argument 2
	(different base types))
	drivers/staging/wlan-ng/cfg80211.c:736:25:
	expected int ( *get_tx_power )( ... )
	drivers/staging/wlan-ng/cfg80211.c:736:25:
	got int ( extern [toplevel] *<noident> )( ... )

drivers/staging/wlan-ng/cfg80211.c:735:2: warning:
	initialization from incompatible pointer type [enabled by default]

drivers/staging/wlan-ng/cfg80211.c:735:2: warning:
	(near initialization for ‘prism2_usb_cfg_ops.set_tx_power’)
	[enabled by default]

drivers/staging/wlan-ng/cfg80211.c:736:2: warning:
	initialization from incompatible pointer type [enabled by default]

drivers/staging/wlan-ng/cfg80211.c:736:2: warning:
	(near initialization for ‘prism2_usb_cfg_ops.get_tx_power’)
	[enabled by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/staging/wlan-ng/cfg80211.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
1.7.10.4

