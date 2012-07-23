Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2GWCKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:10:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53982 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab2GWBmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:15 -0400
Message-Id: <20120723010652.464822846@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:06:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 006/108] net/wireless: ipw2x00: add supported cipher suites to wiphy
 initialization
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Yakovlev <stas.yakovlev@gmail.com>

commit a141e6a0097118bb35024485f1faffc0d9042f5c upstream.

Driver doesn't report its supported cipher suites through cfg80211
interface. It still uses wext interface and probably will not work
through nl80211, but will at least correctly advertise supported
features.

Bug was reported by Omar Siam.
https://bugzilla.kernel.org/show_bug.cgi?id=43049

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ipw2x00/ipw.h     |   23 +++++++++++++++++++++++
 drivers/net/wireless/ipw2x00/ipw2100.c |    4 ++++
 drivers/net/wireless/ipw2x00/ipw2200.c |    4 ++++
 3 files changed, 31 insertions(+)
 create mode 100644 drivers/net/wireless/ipw2x00/ipw.h

diff --git a/drivers/net/wireless/ipw2x00/ipw.h b/drivers/net/wireless/ipw2x00/ipw.h
new file mode 100644
index 0000000..4007bf5
--- /dev/null
+++ b/drivers/net/wireless/ipw2x00/ipw.h
@@ -0,0 +1,23 @@
+/*
+ * Intel Pro/Wireless 2100, 2200BG, 2915ABG network connection driver
+ *
+ * Copyright 2012 Stanislav Yakovlev <stas.yakovlev@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __IPW_H__
+#define __IPW_H__
+
+#include <linux/ieee80211.h>
+
+static const u32 ipw_cipher_suites[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+};
+
+#endif
diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index d8d804e..8193687 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -166,6 +166,7 @@ that only one external action is invoked at a time.
 #include <net/lib80211.h>
 
 #include "ipw2100.h"
+#include "ipw.h"
 
 #define IPW2100_VERSION "git-1.2.2"
 
@@ -1946,6 +1947,9 @@ static int ipw2100_wdev_init(struct net_device *dev)
 		wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = bg_band;
 	}
 
+	wdev->wiphy->cipher_suites = ipw_cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(ipw_cipher_suites);
+
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 	if (wiphy_register(wdev->wiphy)) {
 		ipw2100_down(priv);
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 77c5d2f..f37d315 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <net/cfg80211-wext.h>
 #include "ipw2200.h"
+#include "ipw.h"
 
 
 #ifndef KBUILD_EXTMOD
@@ -11532,6 +11533,9 @@ static int ipw_wdev_init(struct net_device *dev)
 		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = a_band;
 	}
 
+	wdev->wiphy->cipher_suites = ipw_cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(ipw_cipher_suites);
+
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 
 	/* With that information in place, we can now register the wiphy... */


