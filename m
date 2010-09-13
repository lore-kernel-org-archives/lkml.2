Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0IMImA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:42:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54439 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0IMIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W0ANkJRC1V0EunVxtKbpyscCqEvl2o/hk9iIblWzemedYMTCHfPLyiGDd0mFW3CFIl
         sLJhuDeWH5DnkWJWeLVLIpuSfoRPLxOHXxRozx2qf022BeVIpY6fbmI/7V7NfgwC5Yv8
         f0IeVNC7QWw9pXfhY4nBEEHPZZg3iDyIZbD0w=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 08/10] staging: rtl8712: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:32 +0300
Message-Id: <902ab98e983ba92bc6d2575ed2549966cc1d9796.1284316740.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/rtl8712/osdep_service.h       |    3 ---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    3 +--
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 73509da..7fca42c 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -251,9 +251,6 @@ static inline u32 _RND512(u32 sz)
 	return val;
 }
 
-#define MAC2STR(a) (a)[0], (a)[1], (a)[2], (a)[3], (a)[4], (a)[5]
-#define MACSTR "%02x:%02x:%02x:%02x:%02x:%02x"
-
 #define STRUCT_PACKED __attribute__ ((packed))
 
 #endif
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index eac049b..685a7b1 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1917,8 +1917,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 									irqL);
 			return -EINVAL;
 		}
-		printk(KERN_INFO "r8712u: BSSID:" MACSTR "\n",
-		       MAC2STR(bssid));
+		printk(KERN_INFO "r8712u: BSSID:%pM\n", bssid);
 		if (!memcmp(bssid, pnetwork->network.MacAddress, ETH_ALEN)) {
 			/* BSSID match, then check if supporting wpa/wpa2 */
 			pbuf = r8712_get_wpa_ie(&pnetwork->network.IEs[12],
-- 
1.7.2.2

