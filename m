Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0IMIlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:41:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49729 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab0IMIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=C9Zu61fBEDJ8E/1j5MaLR5X9sE1J1bKr06xU0GYxg8mluEm1Sp+Gt6a/F/WqmlWaPE
         lvK7nx+DJgOhQvGm8BO/qkTl27qSQVHTrUjkZqQoS/z4t027I3wPYAtV40gg+8+ly0ag
         JSJTfK4dNJVIfpybVkZK/a5B4e8maoGtmFG08=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 06/10] staging: otus: use '%pM' format to print MAC address
Date: Mon, 13 Sep 2010 11:40:30 +0300
Message-Id: <b9f7be19391dafe3d913ef0418a26aa5e0c8a019.1284316739.git.andy.shevchenko@gmail.com>
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
 drivers/staging/otus/ioctl.c   |    5 +----
 drivers/staging/otus/wrap_ev.c |   15 ++++-----------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index dc3066d..a403d9c 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -2188,10 +2188,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
 		printk(KERN_ERR "usbdrv_wpa_ioctl: ZD_CMD_SET_MLME\n");
 
 		/* Translate STA's address */
-		sprintf(mac_addr, "%02x:%02x:%02x:%02x:%02x:%02x",
-			zdparm->sta_addr[0], zdparm->sta_addr[1],
-			zdparm->sta_addr[2], zdparm->sta_addr[3],
-			zdparm->sta_addr[4], zdparm->sta_addr[5]);
+		sprintf(mac_addr, "%pM", zdparm->sta_addr);
 
 		switch (zdparm->u.mlme.cmd) {
 		case MLME_STA_DEAUTH:
diff --git a/drivers/staging/otus/wrap_ev.c b/drivers/staging/otus/wrap_ev.c
index 29f5603..1c312ad 100644
--- a/drivers/staging/otus/wrap_ev.c
+++ b/drivers/staging/otus/wrap_ev.c
@@ -49,8 +49,7 @@ u16_t zfLnxAsocNotify(zdev_t *dev, u16_t *macAddr, u8_t *body, u16_t bodySize,
 	memset(&wreq, 0, sizeof(wreq));
 	memcpy(wreq.addr.sa_data, macAddr, ETH_ALEN);
 	wreq.addr.sa_family = ARPHRD_ETHER;
-	printk(KERN_DEBUG "join_event of MAC: %02x:%02x:%02x:%02x:%02x:%02x\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
+	printk(KERN_DEBUG "join_event of MAC: %pM\n", addr);
 
 	for (i = 0; i < ZM_OAL_MAX_STA_SUPPORT; i++) {
 		for (j = 0; j < IEEE80211_ADDR_LEN; j++) {
@@ -114,9 +113,7 @@ u16_t zfLnxDisAsocNotify(zdev_t *dev, u8_t *macAddr, u16_t port)
 	memset(&wreq, 0, sizeof(wreq));
 	memcpy(wreq.addr.sa_data, macAddr, ETH_ALEN);
 	wreq.addr.sa_family = ARPHRD_ETHER;
-	printk(KERN_DEBUG "zfwDisAsocNotify(), MAC: %02x:%02x:%02x:%02x:%02x:%02x\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
-
+	printk(KERN_DEBUG "zfwDisAsocNotify(), MAC: %pM\n", addr);
 
 	return 0;
 }
@@ -131,9 +128,7 @@ u16_t zfLnxApConnectNotify(zdev_t *dev, u8_t *macAddr, u16_t port)
 	memset(&wreq, 0, sizeof(wreq));
 	memcpy(wreq.addr.sa_data, macAddr, ETH_ALEN);
 	wreq.addr.sa_family = ARPHRD_ETHER;
-	printk(KERN_DEBUG "zfwApConnectNotify(), MAC: %02x:%02x:%02x:%02x:%02x:%02x\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
-
+	printk(KERN_DEBUG "zfwApConnectNotify(), MAC: %pM\n", addr);
 
 	return 0;
 }
@@ -254,9 +249,7 @@ void zfLnxApMicFailureNotify(zdev_t *dev, u8_t *addr, zbuf_t *buf)
 	memset(&wreq, 0, sizeof(wreq));
 	memcpy(wreq.addr.sa_data, addr, ETH_ALEN);
 	wreq.addr.sa_family = ARPHRD_ETHER;
-	printk(KERN_DEBUG "zfwApMicFailureNotify(), "
-			"MAC: %02x:%02x:%02x:%02x:%02x:%02x\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
+	printk(KERN_DEBUG "zfwApMicFailureNotify(), MAC: %pM\n", addr);
 
 	return;
 }
-- 
1.7.2.2

