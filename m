Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0IKOSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:18:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50581 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab0IKORn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oQfj5xalulTDZB/sG2aPeZFO94OGJknANNdly+pGzMdIYj9dXR0S9we8cNMagplQ2E
         bPWmt0t2iOWYEcmaudPmQBmdcfkWSXB4oM6V3JCS4i2tIzJitpW+Ms0PeRVdWWCQDYRG
         IL2ztoMhzuKIAIGkcjWLkZwI436RYA+c0m0ZM=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 08/10] staging: rtl8712: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:11 +0300
Message-Id: <5066513a91a4c8e143891baefeaa9f8ec9e46583.1284214460.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
In-Reply-To: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
References: <735b00c1124fd4c2c68dfe9446ac05db9aa72fcd.1284214458.git.andy.shevchenko@gmail.com>
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
index eac049b..a54e25d 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1917,8 +1917,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 									irqL);
 			return -EINVAL;
 		}
-		printk(KERN_INFO "r8712u: BSSID:" MACSTR "\n",
-		       MAC2STR(bssid));
+		printk(KERN_INFO "r8712u: BSSID:%pM\n", &bssid[0]);
 		if (!memcmp(bssid, pnetwork->network.MacAddress, ETH_ALEN)) {
 			/* BSSID match, then check if supporting wpa/wpa2 */
 			pbuf = r8712_get_wpa_ie(&pnetwork->network.IEs[12],
-- 
1.7.2.2

