Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1IYHkN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 03:40:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1IYHjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 03:39:02 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 1/4] staging: wlags49_h2: Fixup WEXT capabilities
Date: Sun, 25 Sep 2011 08:30:18 +0100
Message-Id: <1316935821-6980-2-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
References: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add recently added events to the capabilities reported in iw_range.
Use capability macros instead of assuming the array offsets.

Explicitly list scan capabilities.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_wext.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 917c949..80bd938 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -523,15 +523,17 @@ retry:
 	DBG_TRACE( DbgInfo, "wl_wireless_stats done\n" );
 
 	/* Event capability (kernel + driver) */
-	range->event_capa[0] = (IW_EVENT_CAPA_K_0 |
-				IW_EVENT_CAPA_MASK(SIOCGIWAP) |
-				IW_EVENT_CAPA_MASK(SIOCGIWSCAN));
-	range->event_capa[1] = IW_EVENT_CAPA_K_1;
-	range->event_capa[4] = (IW_EVENT_CAPA_MASK(IWEVREGISTERED) |
-				IW_EVENT_CAPA_MASK(IWEVCUSTOM) |
-				IW_EVENT_CAPA_MASK(IWEVEXPIRED));
+	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
+	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
+	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
+	IW_EVENT_CAPA_SET(range->event_capa, IWEVREGISTERED);
+	IW_EVENT_CAPA_SET(range->event_capa, IWEVEXPIRED);
+	IW_EVENT_CAPA_SET(range->event_capa, IWEVMICHAELMICFAILURE);
+	IW_EVENT_CAPA_SET(range->event_capa, IWEVASSOCREQIE);
+	IW_EVENT_CAPA_SET(range->event_capa, IWEVASSOCRESPIE);
 
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_CIPHER_TKIP;
+	range->scan_capa = IW_SCAN_CAPA_NONE;
 
 out_unlock:
     	wl_act_int_on( lp );
-- 
1.7.4.1

