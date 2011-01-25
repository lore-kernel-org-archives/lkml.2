Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1AYNF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:05:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64668 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1AYNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=C8kh102njZex2j9N/kAyZyZmh/rzZX9QZ7t2BON+a5Nm9gle+UGOyBcV1b+l2zH/yo
         B8KcKhoK31uDUIPembYjG7ZV4mO4V5uS69MiaNvr0MeolyflmY/n3Y7QczG5NsXa/CPT
         kHs8mSWWQ7Kmu7np3oS7FGzb5c2AxAywSJ5mU=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 04/11] staging: ft1000: Fix coding style in get_handshake_usb() function.
Date: Tue, 25 Jan 2011 14:04:59 +0100
Message-Id: <1295960706-15667-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   74 +++++++++++---------
 1 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 1472943..07604a7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -273,42 +273,50 @@ static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
 
 static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value)
 {
-   u16            handshake;
-   int               loopcnt;
-   u16            temp;
-   u32             status=0;
+	u16 handshake
+	int loopcnt;
+	u16 temp;
+	u32 status = 0;
 
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
-   loopcnt = 0;
-   handshake = 0;
-   while (loopcnt < 100)
-   {
-       if (pft1000info->usbboot == 2) {
-           status = ft1000_read_dpram32 (ft1000dev, 0, (u8 *)&(pft1000info->tempbuf[0]), 64);
-           for (temp=0; temp<16; temp++)
-               DEBUG("tempbuf %d = 0x%x\n", temp, pft1000info->tempbuf[temp]);
-           status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
-           DEBUG("handshake from read_dpram16 = 0x%x\n", handshake);
-           if (pft1000info->dspalive == pft1000info->tempbuf[6])
-               handshake = 0;
-           else {
-               handshake = pft1000info->tempbuf[1];
-               pft1000info->dspalive = pft1000info->tempbuf[6];
-           }
-       }
-       else {
-           status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
-       }
-       loopcnt++;
-       msleep(10);
-       handshake = ntohs(handshake);
-       if ((handshake == expected_value) || (handshake == HANDSHAKE_RESET_VALUE_USB))
-       {
-           return handshake;
-       }
-   }
+	loopcnt = 0;
+	handshake = 0;
+
+	while (loopcnt < 100) {
+		if (pft1000info->usbboot == 2) {
+			status = ft1000_read_dpram32(ft1000dev, 0,
+					(u8 *)&(pft1000info->tempbuf[0]), 64);
+			for (temp = 0; temp < 16; temp++) {
+				DEBUG("tempbuf %d = 0x%x\n", temp,
+					pft1000info->tempbuf[temp]);
+			}
+			status = ft1000_read_dpram16(ft1000dev,
+						DWNLD_MAG1_HANDSHAKE_LOC,
+						(u8 *)&handshake, 1);
+			DEBUG("handshake from read_dpram16 = 0x%x\n",
+				handshake);
+			if (pft1000info->dspalive == pft1000info->tempbuf[6]) {
+				handshake = 0;
+			} else {
+				handshake = pft1000info->tempbuf[1];
+				pft1000info->dspalive =
+						pft1000info->tempbuf[6];
+			}
+		} else {
+			status = ft1000_read_dpram16(ft1000dev,
+						DWNLD_MAG1_HANDSHAKE_LOC,
+						(u8 *)&handshake, 1);
+		}
 
-   return HANDSHAKE_TIMEOUT_VALUE;
+		loopcnt++;
+		msleep(10);
+		handshake = ntohs(handshake);
+		if ((handshake == expected_value) ||
+		    (handshake == HANDSHAKE_RESET_VALUE_USB))
+			return handshake;
+	}
+
+	return HANDSHAKE_TIMEOUT_VALUE;
 }
 
 static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_value)
-- 
1.7.1

