Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0IKORp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 10:17:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62351 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0IKORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 10:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bnjz/kOvnc6M5v5m3nhrJmEOxS2L5bmcY0fWSF6XfDVab47M3KFsKpGV7YQOhHwKL6
         TYIPcP8R5VIvkSpedxJWPb4mDZTh22cIWZ7AKJs0EBCMkVDv7RunQ1F/PObOBZX0aQ/2
         kNEewmnOSSq4VQPIoRwPV/ivpjHMl3Cy/qtis=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 06/10] staging: otus: use '%pM' format to print MAC address
Date: Sat, 11 Sep 2010 17:17:09 +0300
Message-Id: <65a673d5f658daa3b274d10d190877ab99c9ac3e.1284214460.git.andy.shevchenko@gmail.com>
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
 drivers/staging/otus/ioctl.c   |    5 +----
 drivers/staging/otus/wrap_ev.c |   15 ++++-----------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
index dc3066d..405bd29 100644
--- a/drivers/staging/otus/ioctl.c
+++ b/drivers/staging/otus/ioctl.c
@@ -2188,10 +2188,7 @@ int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm)
 		printk(KERN_ERR "usbdrv_wpa_ioctl: ZD_CMD_SET_MLME\n");
 
 		/* Translate STA's address */
-		sprintf(mac_addr, "%02x:%02x:%02x:%02x:%02x:%02x",
-			zdparm->sta_addr[0], zdparm->sta_addr[1],
-			zdparm->sta_addr[2], zdparm->sta_addr[3],
-			zdparm->sta_addr[4], zdparm->sta_addr[5]);
+		sprintf(mac_addr, "%pM", &zdparm->sta_addr[0]);
 
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

