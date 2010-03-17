Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0CQOlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:41:11 -0400
Received: from rsk.demon.co.uk ([80.176.90.227]:34347 "EHLO castor.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754320Ab0CQOlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:41:09 -0400
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] staging wlan-ng: tidy up iw_handler
Date: Wed, 17 Mar 2010 14:40:55 +0000
Message-Id: <1268836857-31738-2-git-send-email-richard@rsk.demon.co.uk>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1268836857-31738-1-git-send-email-richard@rsk.demon.co.uk>
References: <1268836857-31738-1-git-send-email-richard@rsk.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use array initialisation technique copied from ipw2200.c.

This should always get the function pointers in the correct place,
without the needed for endless counting, skipping blanks etc.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211wext.c |   98 ++++++++++++++-------------------
 1 files changed, 42 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211wext.c b/drivers/staging/wlan-ng/p80211wext.c
index 2fa1dfa..94d933c 100644
--- a/drivers/staging/wlan-ng/p80211wext.c
+++ b/drivers/staging/wlan-ng/p80211wext.c
@@ -1682,64 +1682,50 @@ static int p80211_wext_get_iwauth(struct net_device *dev,
 	return result;
 }
 
+#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]
+
 static iw_handler p80211wext_handlers[] = {
-	(iw_handler) p80211wext_siwcommit,	/* SIOCSIWCOMMIT */
-	(iw_handler) p80211wext_giwname,	/* SIOCGIWNAME */
-	(iw_handler) NULL,	/* SIOCSIWNWID */
-	(iw_handler) NULL,	/* SIOCGIWNWID */
-	(iw_handler) p80211wext_siwfreq,	/* SIOCSIWFREQ */
-	(iw_handler) p80211wext_giwfreq,	/* SIOCGIWFREQ */
-	(iw_handler) p80211wext_siwmode,	/* SIOCSIWMODE */
-	(iw_handler) p80211wext_giwmode,	/* SIOCGIWMODE */
-	(iw_handler) NULL,	/* SIOCSIWSENS */
-	(iw_handler) NULL,	/* SIOCGIWSENS */
-	(iw_handler) NULL,	/* not used *//* SIOCSIWRANGE */
-	(iw_handler) p80211wext_giwrange,	/* SIOCGIWRANGE */
-	(iw_handler) NULL,	/* not used *//* SIOCSIWPRIV */
-	(iw_handler) NULL,	/* kernel code *//* SIOCGIWPRIV */
-	(iw_handler) NULL,	/* not used *//* SIOCSIWSTATS */
-	(iw_handler) NULL,	/* kernel code *//* SIOCGIWSTATS */
-	(iw_handler) p80211wext_siwspy,	/* SIOCSIWSPY */
-	(iw_handler) p80211wext_giwspy,	/* SIOCGIWSPY */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* SIOCSIWAP */
-	(iw_handler) p80211wext_giwap,	/* SIOCGIWAP */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* SIOCGIWAPLIST */
-	(iw_handler) p80211wext_siwscan,	/* SIOCSIWSCAN */
-	(iw_handler) p80211wext_giwscan,	/* SIOCGIWSCAN */
-	(iw_handler) p80211wext_siwessid,	/* SIOCSIWESSID */
-	(iw_handler) p80211wext_giwessid,	/* SIOCGIWESSID */
-	(iw_handler) NULL,	/* SIOCSIWNICKN */
-	(iw_handler) p80211wext_giwessid,	/* SIOCGIWNICKN */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* SIOCSIWRATE */
-	(iw_handler) p80211wext_giwrate,	/* SIOCGIWRATE */
-	(iw_handler) p80211wext_siwrts,	/* SIOCSIWRTS */
-	(iw_handler) p80211wext_giwrts,	/* SIOCGIWRTS */
-	(iw_handler) p80211wext_siwfrag,	/* SIOCSIWFRAG */
-	(iw_handler) p80211wext_giwfrag,	/* SIOCGIWFRAG */
-	(iw_handler) p80211wext_siwtxpow,	/* SIOCSIWTXPOW */
-	(iw_handler) p80211wext_giwtxpow,	/* SIOCGIWTXPOW */
-	(iw_handler) p80211wext_siwretry,	/* SIOCSIWRETRY */
-	(iw_handler) p80211wext_giwretry,	/* SIOCGIWRETRY */
-	(iw_handler) p80211wext_siwencode,	/* SIOCSIWENCODE */
-	(iw_handler) p80211wext_giwencode,	/* SIOCGIWENCODE */
-	(iw_handler) NULL,	/* SIOCSIWPOWER */
-	(iw_handler) NULL,	/* SIOCGIWPOWER */
+	IW_IOCTL(SIOCSIWCOMMIT) = (iw_handler) p80211wext_siwcommit,
+	IW_IOCTL(SIOCGIWNAME) = (iw_handler) p80211wext_giwname,
+/* SIOCSIWNWID,SIOCGIWNWID */
+	IW_IOCTL(SIOCSIWFREQ) = (iw_handler) p80211wext_siwfreq,
+	IW_IOCTL(SIOCGIWFREQ) = (iw_handler) p80211wext_giwfreq,
+	IW_IOCTL(SIOCSIWMODE) = (iw_handler) p80211wext_siwmode,
+	IW_IOCTL(SIOCGIWMODE) = (iw_handler) p80211wext_giwmode,
+/* SIOCSIWSENS,SIOCGIWSENS,SIOCSIWRANGE */
+	IW_IOCTL(SIOCGIWRANGE) = (iw_handler) p80211wext_giwrange,
+/* SIOCSIWPRIV,SIOCGIWPRIV,SIOCSIWSTATS,SIOCGIWSTATS */
+	IW_IOCTL(SIOCSIWSPY) = (iw_handler) p80211wext_siwspy,
+	IW_IOCTL(SIOCGIWSPY) = (iw_handler) p80211wext_giwspy,
+/* SIOCSIWAP */
+	IW_IOCTL(SIOCGIWAP) = (iw_handler) p80211wext_giwap,
+/* SIOCGIWAPLIST */
+	IW_IOCTL(SIOCSIWSCAN) = (iw_handler) p80211wext_siwscan,
+	IW_IOCTL(SIOCGIWSCAN) = (iw_handler) p80211wext_giwscan,
+	IW_IOCTL(SIOCSIWESSID) = (iw_handler) p80211wext_siwessid,
+	IW_IOCTL(SIOCGIWESSID) = (iw_handler) p80211wext_giwessid,
+/* SIOCSIWNICKN */
+	IW_IOCTL(SIOCGIWNICKN) = (iw_handler) p80211wext_giwessid,
+/* SIOCSIWRATE */
+	IW_IOCTL(SIOCGIWRATE) = (iw_handler) p80211wext_giwrate,
+	IW_IOCTL(SIOCSIWRTS) = (iw_handler) p80211wext_siwrts,
+	IW_IOCTL(SIOCGIWRTS) = (iw_handler) p80211wext_giwrts,
+	IW_IOCTL(SIOCSIWFRAG) = (iw_handler) p80211wext_siwfrag,
+	IW_IOCTL(SIOCGIWFRAG) = (iw_handler) p80211wext_giwfrag,
+	IW_IOCTL(SIOCSIWTXPOW) = (iw_handler) p80211wext_siwtxpow,
+	IW_IOCTL(SIOCGIWTXPOW) = (iw_handler) p80211wext_giwtxpow,
+	IW_IOCTL(SIOCSIWRETRY) = (iw_handler) p80211wext_siwretry,
+	IW_IOCTL(SIOCGIWRETRY) = (iw_handler) p80211wext_giwretry,
+	IW_IOCTL(SIOCSIWENCODE) = (iw_handler) p80211wext_siwencode,
+	IW_IOCTL(SIOCGIWENCODE) = (iw_handler) p80211wext_giwencode,
+/* SIOCSIWPOWER,SIOCGIWPOWER */
 /* WPA operations */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* -- hole -- */
-	(iw_handler) NULL,	/* SIOCSIWGENIE      set generic IE */
-	(iw_handler) NULL,	/* SIOCGIWGENIE      get generic IE */
-	(iw_handler) p80211_wext_set_iwauth,	/* SIOCSIWAUTH     set authentication mode params */
-	(iw_handler) p80211_wext_get_iwauth,	/* SIOCGIWAUTH     get authentication mode params */
-
-	(iw_handler) p80211wext_set_encodeext,	/* SIOCSIWENCODEEXT  set encoding token & mode */
-	(iw_handler) p80211wext_get_encodeext,	/* SIOCGIWENCODEEXT  get encoding token & mode */
-	(iw_handler) NULL,	/* SIOCSIWPMKSA      PMKSA cache operation */
+/* SIOCSIWGENIE,SIOCGIWGENIE generic IE */
+	IW_IOCTL(SIOCSIWAUTH) = (iw_handler) p80211_wext_set_iwauth, /*set authentication mode params */
+	IW_IOCTL(SIOCGIWAUTH) = (iw_handler) p80211_wext_get_iwauth, /*get authentication mode params */
+	IW_IOCTL(SIOCSIWENCODEEXT) = (iw_handler) p80211wext_set_encodeext, /*set encoding token & mode */
+	IW_IOCTL(SIOCGIWENCODEEXT) = (iw_handler) p80211wext_get_encodeext, /*get encoding token & mode */
+/* SIOCSIWPMKSA      PMKSA cache operation */
 };
 
 struct iw_handler_def p80211wext_handler_def = {
-- 
1.6.6.1

