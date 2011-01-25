Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1AYLbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:31:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab1AYLbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=QSXnT4rVDOV9rhaR5Ec0acWUNT1gVviCbUr1eMhDb7iTi4FNZNA90y6jGz17hHEHKQ
         CVc8UhtaGKl7Y9a5fQj3Z4VmjAh9yr6NxBIvl83I2n0K6PFuSwvjPCJVUQFPWt8TEDKx
         UY72dd7zpRbWJk/OPSqTUqU5uJwlJ0IF3oiTU=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 12/12] staging: ft1000: Fix coding style in get_handshake() function.
Date: Tue, 25 Jan 2011 12:31:23 +0100
Message-Id: <1295955083-11086-12-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   90 +++++++++-----------
 1 files changed, 41 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 596c923..700a206 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -186,57 +186,49 @@ static u32 check_usb_db (struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 {
-   u16            handshake;
-   int               loopcnt;
-   u32             status=0;
+	u16 handshake;
+	int loopcnt;
+	u32 status = 0;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
-   loopcnt = 0;
-   while (loopcnt < 100)
-   {
+	loopcnt = 0;
 
-           // Need to clear downloader doorbell if Hartley ASIC
-           status = ft1000_write_register (ft1000dev,  FT1000_DB_DNLD_RX, FT1000_REG_DOORBELL);
-           //DEBUG("FT1000:get_handshake:doorbell = 0x%x\n", temp);
-               if (pft1000info->fcodeldr)
-               {
-                   DEBUG(" get_handshake: fcodeldr is %d\n", pft1000info->fcodeldr);
-                   pft1000info->fcodeldr = 0;
-                   status = check_usb_db(ft1000dev);
-                   if (status != STATUS_SUCCESS)
-                   {
-                       DEBUG("get_handshake: check_usb_db failed\n");
-                       status = STATUS_FAILURE;
-                       break;
-                   }
-                   status = ft1000_write_register (ft1000dev,  FT1000_DB_DNLD_RX, FT1000_REG_DOORBELL);
-               }
+	while (loopcnt < 100) {
+		/* Need to clear downloader doorbell if Hartley ASIC */
+		status = ft1000_write_register(ft1000dev,  FT1000_DB_DNLD_RX,
+						FT1000_REG_DOORBELL);
+		if (pft1000info->fcodeldr) {
+			DEBUG(" get_handshake: fcodeldr is %d\n",
+				pft1000info->fcodeldr);
+			pft1000info->fcodeldr = 0;
+			status = check_usb_db(ft1000dev);
+			if (status != STATUS_SUCCESS) {
+				DEBUG("get_handshake: check_usb_db failed\n");
+				status = STATUS_FAILURE;
+				break;
+			}
+			status = ft1000_write_register(ft1000dev,
+					FT1000_DB_DNLD_RX,
+					FT1000_REG_DOORBELL);
+		}
 
-                status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
-                //DEBUG("get_handshake: handshake is %x\n", tempx);
-                handshake = ntohs(handshake);
-                //DEBUG("get_handshake: after swap, handshake is %x\n", handshake);
-
-        if (status)
-           return HANDSHAKE_TIMEOUT_VALUE;
-
-        //DEBUG("get_handshake: handshake= %x\n", handshake);
-        if ((handshake == expected_value) || (handshake == HANDSHAKE_RESET_VALUE_USB))
-        {
-            //DEBUG("get_handshake: return handshake %x\n", handshake);
-            return handshake;
-        }
-        else
-        {
-            loopcnt++;
-            msleep (10);
-        }
-        //DEBUG("HANDSHKE LOOP: %d\n", loopcnt);
+		status = ft1000_read_dpram16(ft1000dev,
+				DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
+		handshake = ntohs(handshake);
 
-   }
+		if (status)
+			return HANDSHAKE_TIMEOUT_VALUE;
 
-   //DEBUG("get_handshake: return handshake time out\n");
-   return HANDSHAKE_TIMEOUT_VALUE;
+		if ((handshake == expected_value) ||
+		    (handshake == HANDSHAKE_RESET_VALUE_USB)) {
+			return handshake;
+		} else	{
+			loopcnt++;
+			msleep(10);
+		}
+	}
+
+	return HANDSHAKE_TIMEOUT_VALUE;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

