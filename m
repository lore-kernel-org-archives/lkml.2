Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab0HKRvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:51:33 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:40509 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980Ab0HKRvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:51:32 -0400
Subject: [PATCH] staging/wlan-ng: Explicitly set some fields in cfg80211
 interface
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 18:16:08 +0100
Message-ID: <1281546968.2010.5.camel@dellpc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=CajpU43aiusA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=WTt5kjEsJSIZ9A_Y8bgA:9 a=JzZ8TulfSlWQzrKGyY86Sh8ETewA:4 a=QEXdDO2ut3YA:10 a=_dQi-Dcv4p4A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg

Now that the wlan-ng driver has been switched to cfg80211 in mainline,
can this small patch be forwarded also, to catch up with some new fields
that have gone into the cfg80211 api also in this cycle.

Thanks
Karl





Explicitly set some fields in cfg80211 interface

Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>

---

The cfg80211 api has introduced a few new fields. Rather than assume
what cfg80211 api does by default, set these explicitly.


--- a/drivers/staging/wlan-ng/cfg80211.c	2010-08-11 18:04:27.000000000
+0100
+++ b/drivers/staging/wlan-ng/cfg80211.c	2010-07-07 10:17:27.000000000
+0100
@@ -214,6 +214,7 @@ int prism2_get_key(struct wiphy *wiphy, 
 	} else return -ENOENT;
 	params.key_len = len;
 	params.key = wlandev->wep_keys[key_index];
+	params.seq_len = 0;
 
 	callback(cookie, &params);
 	return 0;
@@ -709,6 +710,8 @@ struct wiphy *wlan_create_wiphy(struct d
 	priv->band.n_channels = ARRAY_SIZE(prism2_channels);
 	priv->band.bitrates = priv->rates;
 	priv->band.n_bitrates = ARRAY_SIZE(prism2_rates);
+	priv->band.band = IEEE80211_BAND_2GHZ;
+	priv->band.ht_cap.ht_supported = false;
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 	set_wiphy_dev(wiphy, dev);


