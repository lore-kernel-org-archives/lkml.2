Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1AYNHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:07:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab1AYNEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UjN46P1BMC79n1ZHMI1vBbVlLr0yzCnXiZgmj3AP4hd5qLjhAOVeLMg0B0VYsKHwnx
         CzKChhKlnEpFW/hVL0ORJcgbHOevODj6nvaKnB+pOSyrgrbKD2K3H5uVP7nRduTsxWF+
         2Qc0JPXQXxVdRy7dSYRziGOj2ksqdNkehyhIo=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 02/11] staging: ft1000: Fix coding style in check_usb_db() function.
Date: Tue, 25 Jan 2011 14:04:57 +0100
Message-Id: <1295960706-15667-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   89 +++++++++----------
 1 files changed, 42 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 0ee80b5..03694db 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -125,53 +125,48 @@ struct dsp_image_info {
 //---------------------------------------------------------------------------
 static u32 check_usb_db (struct ft1000_device *ft1000dev)
 {
-   int               loopcnt;
-   u16            temp;
-   u32             status;
-
-   loopcnt = 0;
-   while (loopcnt < 10)
-   {
-
-      status = ft1000_read_register (ft1000dev, &temp, FT1000_REG_DOORBELL);
-      DEBUG("check_usb_db: read FT1000_REG_DOORBELL value is %x\n", temp);
-      if (temp & 0x0080)
-      {
-           DEBUG("FT1000:Got checkusb doorbell\n");
-           status = ft1000_write_register (ft1000dev, 0x0080, FT1000_REG_DOORBELL);
-           status = ft1000_write_register (ft1000dev, 0x0100, FT1000_REG_DOORBELL);
-           status = ft1000_write_register (ft1000dev,  0x8000, FT1000_REG_DOORBELL);
-           break;
-      }
-      else
-      {
-           loopcnt++;
-           msleep (10);
-      }
-
-   } //end of while
-
-
-   loopcnt = 0;
-   while (loopcnt < 20)
-   {
-
-      status = ft1000_read_register (ft1000dev, &temp, FT1000_REG_DOORBELL);
-      DEBUG("FT1000:check_usb_db:Doorbell = 0x%x\n", temp);
-      if (temp & 0x8000)
-      {
-         loopcnt++;
-         msleep (10);
-      }
-      else
-      {
-         DEBUG("check_usb_db: door bell is cleared, return 0\n");
-         return 0;
-      }
-   }
+	int loopcnt;
+	u16 temp;
+	u32 status;
+
+	loopcnt = 0;
+
+	while (loopcnt < 10) {
+		status = ft1000_read_register(ft1000dev, &temp,
+					       FT1000_REG_DOORBELL);
+		DEBUG("check_usb_db: read FT1000_REG_DOORBELL value is %x\n",
+		       temp);
+		if (temp & 0x0080) {
+			DEBUG("FT1000:Got checkusb doorbell\n");
+			status = ft1000_write_register(ft1000dev, 0x0080,
+						FT1000_REG_DOORBELL);
+			status = ft1000_write_register(ft1000dev, 0x0100,
+						FT1000_REG_DOORBELL);
+			status = ft1000_write_register(ft1000dev,  0x8000,
+						FT1000_REG_DOORBELL);
+			break;
+		} else {
+			loopcnt++;
+			msleep(10);
+		}
 
-   return HANDSHAKE_MAG_TIMEOUT_VALUE;
+	}
+
+	loopcnt = 0;
+	while (loopcnt < 20) {
+		status = ft1000_read_register(ft1000dev, &temp,
+					       FT1000_REG_DOORBELL);
+		DEBUG("FT1000:check_usb_db:Doorbell = 0x%x\n", temp);
+		if (temp & 0x8000) {
+			loopcnt++;
+			msleep(10);
+		} else	{
+			DEBUG("check_usb_db: door bell is cleared, return 0\n");
+			return 0;
+		}
+	}
 
+	return HANDSHAKE_MAG_TIMEOUT_VALUE;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

