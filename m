Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162461Ab2GLWuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:50:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162217Ab2GLWpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [ 173/187] net/wireless: ipw2x00: add supported cipher suites to wiphy initialization
Date: Thu, 12 Jul 2012 15:35:29 -0700
Message-Id: <20120712191539.338389764@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ipw2x00/ipw.h     |   23 +++++++++++++++++++++++
 drivers/net/wireless/ipw2x00/ipw2100.c |    4 ++++
 drivers/net/wireless/ipw2x00/ipw2200.c |    4 ++++
 3 files changed, 31 insertions(+)

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
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -166,6 +166,7 @@ that only one external action is invoked
 #include <net/lib80211.h>
 
 #include "ipw2100.h"
+#include "ipw.h"
 
 #define IPW2100_VERSION "git-1.2.2"
 
@@ -1946,6 +1947,9 @@ static int ipw2100_wdev_init(struct net_
 		wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = bg_band;
 	}
 
+	wdev->wiphy->cipher_suites = ipw_cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(ipw_cipher_suites);
+
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 	if (wiphy_register(wdev->wiphy)) {
 		ipw2100_down(priv);
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <net/cfg80211-wext.h>
 #include "ipw2200.h"
+#include "ipw.h"
 
 
 #ifndef KBUILD_EXTMOD
@@ -11544,6 +11545,9 @@ static int ipw_wdev_init(struct net_devi
 		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = a_band;
 	}
 
+	wdev->wiphy->cipher_suites = ipw_cipher_suites;
+	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(ipw_cipher_suites);
+
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 
 	/* With that information in place, we can now register the wiphy... */


