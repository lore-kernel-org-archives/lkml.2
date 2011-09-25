Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1IYHjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 03:39:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1IYHjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 03:39:07 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 4/4] staging: wlags49_h2: Use IW_HANDLER macro
Date: Sun, 25 Sep 2011 08:30:21 +0100
Message-Id: <1316935821-6980-5-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
References: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to declare wireless handlers.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |   89 ++++++++++++----------------------
 1 files changed, 31 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 1f6b4dc..764a320 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -3904,66 +3904,39 @@ void wl_wext_event_assoc_ie( struct net_device *dev )
 
 static const iw_handler wl_handler[] =
 {
-                (iw_handler) wireless_commit,           /* SIOCSIWCOMMIT */
-                (iw_handler) wireless_get_protocol,     /* SIOCGIWNAME */
-                (iw_handler) NULL,                      /* SIOCSIWNWID */
-                (iw_handler) NULL,                      /* SIOCGIWNWID */
-                (iw_handler) wireless_set_frequency,    /* SIOCSIWFREQ */
-                (iw_handler) wireless_get_frequency,    /* SIOCGIWFREQ */
-                (iw_handler) wireless_set_porttype,     /* SIOCSIWMODE */
-                (iw_handler) wireless_get_porttype,     /* SIOCGIWMODE */
-                (iw_handler) wireless_set_sensitivity,  /* SIOCSIWSENS */
-                (iw_handler) wireless_get_sensitivity,  /* SIOCGIWSENS */
-                (iw_handler) NULL ,                     /* SIOCSIWRANGE */
-                (iw_handler) wireless_get_range,        /* SIOCGIWRANGE */
-                (iw_handler) NULL ,                     /* SIOCSIWPRIV */
-                (iw_handler) NULL /* kernel code */,    /* SIOCGIWPRIV */
-                (iw_handler) NULL ,                     /* SIOCSIWSTATS */
-                (iw_handler) NULL /* kernel code */,    /* SIOCGIWSTATS */
-                iw_handler_set_spy,                     /* SIOCSIWSPY */
-                iw_handler_get_spy,                     /* SIOCGIWSPY */
-                NULL,                                   /* SIOCSIWTHRSPY */
-                NULL,                                   /* SIOCGIWTHRSPY */
-                (iw_handler) NULL,                      /* SIOCSIWAP */
+	IW_HANDLER(SIOCSIWCOMMIT, (iw_handler) wireless_commit),
+	IW_HANDLER(SIOCGIWNAME, (iw_handler) wireless_get_protocol),
+	IW_HANDLER(SIOCSIWFREQ, (iw_handler) wireless_set_frequency),
+	IW_HANDLER(SIOCGIWFREQ, (iw_handler) wireless_get_frequency),
+	IW_HANDLER(SIOCSIWMODE, (iw_handler) wireless_set_porttype),
+	IW_HANDLER(SIOCGIWMODE, (iw_handler) wireless_get_porttype),
+	IW_HANDLER(SIOCSIWSENS, (iw_handler) wireless_set_sensitivity),
+	IW_HANDLER(SIOCGIWSENS, (iw_handler) wireless_get_sensitivity),
+	IW_HANDLER(SIOCGIWRANGE, (iw_handler) wireless_get_range),
+	IW_HANDLER(SIOCSIWSPY, iw_handler_set_spy),
+	IW_HANDLER(SIOCGIWSPY, iw_handler_get_spy),
 #if 1 //;? (HCF_TYPE) & HCF_TYPE_STA
-                (iw_handler) wireless_get_bssid,        /* SIOCGIWAP */
-#else
-                (iw_handler) NULL,                      /* SIOCGIWAP */
+	IW_HANDLER(SIOCGIWAP, (iw_handler) wireless_get_bssid),
 #endif
-                (iw_handler) NULL,                      /* SIOCSIWMLME */
-                (iw_handler) wireless_get_ap_list,      /* SIOCGIWAPLIST */
-                (iw_handler) wireless_set_scan,         /* SIOCSIWSCAN */
-                (iw_handler) wireless_get_scan,         /* SIOCGIWSCAN */
-                (iw_handler) wireless_set_essid,        /* SIOCSIWESSID */
-                (iw_handler) wireless_get_essid,        /* SIOCGIWESSID */
-                (iw_handler) wireless_set_nickname,     /* SIOCSIWNICKN */
-                (iw_handler) wireless_get_nickname,     /* SIOCGIWNICKN */
-                (iw_handler) NULL,                      /* -- hole -- */
-                (iw_handler) NULL,                      /* -- hole -- */
-                (iw_handler) wireless_set_rate,         /* SIOCSIWRATE */
-                (iw_handler) wireless_get_rate,         /* SIOCGIWRATE */
-                (iw_handler) wireless_set_rts_threshold,/* SIOCSIWRTS */
-                (iw_handler) wireless_get_rts_threshold,/* SIOCGIWRTS */
-                (iw_handler) NULL,                      /* SIOCSIWFRAG */
-                (iw_handler) NULL,                      /* SIOCGIWFRAG */
-                (iw_handler) NULL,                      /* SIOCSIWTXPOW */
-                (iw_handler) wireless_get_tx_power,     /* SIOCGIWTXPOW */
-                (iw_handler) NULL,                      /* SIOCSIWRETRY */
-                (iw_handler) NULL,                      /* SIOCGIWRETRY */
-                (iw_handler) wireless_set_encode,       /* SIOCSIWENCODE */
-                (iw_handler) wireless_get_encode,       /* SIOCGIWENCODE */
-                (iw_handler) wireless_set_power,        /* SIOCSIWPOWER */
-                (iw_handler) wireless_get_power,        /* SIOCGIWPOWER */
-                (iw_handler) NULL,                      /* -- hole -- */
-                (iw_handler) NULL,                      /* -- hole -- */
-                (iw_handler) wireless_get_genie,        /* SIOCSIWGENIE */
-                (iw_handler) NULL,                      /* SIOCGIWGENIE */
-                (iw_handler) wireless_set_auth,         /* SIOCSIWAUTH */
-                (iw_handler) NULL,                      /* SIOCGIWAUTH */
-                (iw_handler) wireless_set_encodeext,    /* SIOCSIWENCODEEXT */
-                (iw_handler) NULL,                      /* SIOCGIWENCODEEXT */
-                (iw_handler) NULL,                      /* SIOCSIWPMKSA */
-                (iw_handler) NULL,                      /* -- hole -- */
+	IW_HANDLER(SIOCGIWAPLIST, (iw_handler) wireless_get_ap_list),
+	IW_HANDLER(SIOCSIWSCAN, (iw_handler) wireless_set_scan),
+	IW_HANDLER(SIOCGIWSCAN, (iw_handler) wireless_get_scan),
+	IW_HANDLER(SIOCSIWESSID, (iw_handler) wireless_set_essid),
+	IW_HANDLER(SIOCGIWESSID, (iw_handler) wireless_get_essid),
+	IW_HANDLER(SIOCSIWNICKN, (iw_handler) wireless_set_nickname),
+	IW_HANDLER(SIOCGIWNICKN, (iw_handler) wireless_get_nickname),
+	IW_HANDLER(SIOCSIWRATE, (iw_handler) wireless_set_rate),
+	IW_HANDLER(SIOCGIWRATE, (iw_handler) wireless_get_rate),
+	IW_HANDLER(SIOCSIWRTS, (iw_handler) wireless_set_rts_threshold),
+	IW_HANDLER(SIOCGIWRTS, (iw_handler) wireless_get_rts_threshold),
+	IW_HANDLER(SIOCGIWTXPOW, (iw_handler) wireless_get_tx_power),
+	IW_HANDLER(SIOCSIWENCODE, (iw_handler) wireless_set_encode),
+	IW_HANDLER(SIOCGIWENCODE, (iw_handler) wireless_get_encode),
+	IW_HANDLER(SIOCSIWPOWER, (iw_handler) wireless_set_power),
+	IW_HANDLER(SIOCGIWPOWER, (iw_handler) wireless_get_power),
+	IW_HANDLER(SIOCSIWGENIE, (iw_handler) wireless_get_genie),
+	IW_HANDLER(SIOCSIWAUTH, (iw_handler) wireless_set_auth),
+	IW_HANDLER(SIOCSIWENCODEEXT, (iw_handler) wireless_set_encodeext),
 };
 
 static const iw_handler wl_private_handler[] =
-- 
1.7.4.1

