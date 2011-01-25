Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1AYLHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:07:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1AYLHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:07:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Z0besm8AUtiKcrsS/FrjkXLwC2lClCvkJoOxbKBG7zuBOJD/pkftN/2Pguj2SNVjAT
         3VcmuG+b9jXRmA/KR9ZnuOXrICs1Tiyyhc064AGjVW7fFNFv091eFEkV0q4EvCLxR2Ck
         Ze4kmI0nfryWbivi2rXjdi8Dvj+y/kedOyllU=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 03/12] staging: ft1000: Fix coding style.
Date: Tue, 25 Jan 2011 12:08:08 +0100
Message-Id: <1295953697-9805-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style in check_usb_db() function.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   87 +++++++++----------
 1 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index edeabff..30501f5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -125,54 +125,49 @@ struct dsp_image_info {
 //---------------------------------------------------------------------------
 static u32 check_usb_db (struct ft1000_device *ft1000dev)
 {
-   int               loopcnt;
-   u16            temp;
-   u32             status, ret_val = HANDSHAKE_MAG_TIMEOUT_VALUE;
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
-	ret_val = 0;
-	break;
-      }
-   }
+	int loopcnt;
+	u16 temp;
+	u32 status, ret_val = HANDSHAKE_MAG_TIMEOUT_VALUE;
+
+	loopcnt = 0;
+	while (loopcnt < 10) {
+
+		status = ft1000_read_register(ft1000dev, &temp,
+						FT1000_REG_DOORBELL);
+		DEBUG("check_usb_db: read FT1000_REG_DOORBELL value is %x\n",
+			temp);
+		if (temp & 0x0080) {
+			DEBUG("FT1000:Got checkusb doorbell\n");
+			status = ft1000_write_register(ft1000dev, 0x0080,
+							FT1000_REG_DOORBELL);
+			status = ft1000_write_register(ft1000dev, 0x0100,
+							FT1000_REG_DOORBELL);
+			status = ft1000_write_register(ft1000dev,  0x8000,
+							FT1000_REG_DOORBELL);
+			break;
+		} else {
+			loopcnt++;
+			msleep(10);
+		}
+	}
+
+	loopcnt = 0;
+	while (loopcnt < 20) {
+
+		status = ft1000_read_register(ft1000dev, &temp,
+						FT1000_REG_DOORBELL);
+		DEBUG("FT1000:check_usb_db:Doorbell = 0x%x\n", temp);
+		if (temp & 0x8000) {
+			loopcnt++;
+			msleep(10);
+		} else {
+			DEBUG("check_usb_db: door bell is cleared,return 0\n");
+			ret_val = 0;
+			break;
+		}
+	}
 
 	return ret_val;
-
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

