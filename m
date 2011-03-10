Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1CJKwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:52:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63830 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab1CJKwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Ljrow//kDhDWOO9AVTMZ0W4eQWHQmyKVCh4R+wHwAMbHepjz75UhnbgI52W3uOWbqG
         3qBvGzbLYBo8H186g8pWgkaToEytNDqPfjSLqISaj90ysCmhj8Gzw2NqHraQH+K9NASo
         WDD8QLx/Euc+zrq4T/fngSTPGMOUOKrN6Ei7M=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 18/21] staging: ft1000: Fix coding style in ft1000_chkcard function.
Date: Thu, 10 Mar 2011 11:51:32 +0100
Message-Id: <1299754295-8493-19-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   61 +++++++++++++------------
 1 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 8f38b08..3f70283 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1325,40 +1325,41 @@ Jim
 //              TRUE  (device is present)
 //
 //---------------------------------------------------------------------------
-static int ft1000_chkcard (struct ft1000_device *dev) {
-    u16 tempword;
-    u16 status;
+static int ft1000_chkcard(struct ft1000_device *dev)
+{
+	u16 tempword;
+	u16 status;
 	struct ft1000_info *info = netdev_priv(dev->net);
 
-    if (info->fCondResetPend)
-    {
-        DEBUG("ft1000_hw:ft1000_chkcard:Card is being reset, return FALSE\n");
-        return TRUE;
-    }
-
-    // Mask register is used to check for device presence since it is never
-    // set to zero.
-    status = ft1000_read_register(dev, &tempword, FT1000_REG_SUP_IMASK);
-    //DEBUG("ft1000_hw:ft1000_chkcard: read FT1000_REG_SUP_IMASK = %x\n", tempword);
-    if (tempword == 0) {
-        DEBUG("ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
-        return FALSE;
-    }
-
-    // The system will return the value of 0xffff for the version register
-    // if the device is not present.
-    status = ft1000_read_register(dev, &tempword, FT1000_REG_ASIC_ID);
-    //DEBUG("ft1000_hw:ft1000_chkcard: read FT1000_REG_ASIC_ID = %x\n", tempword);
-    if (tempword != 0x1b01 ){
-	dev->status |= FT1000_STATUS_CLOSING; //mbelian
-        DEBUG("ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
-        return FALSE;
-    }
-    return TRUE;
+	if (info->fCondResetPend) {
+		DEBUG
+		    ("ft1000_hw:ft1000_chkcard:Card is being reset, return FALSE\n");
+		return TRUE;
+	}
+	/* Mask register is used to check for device presence since it is never
+	 * set to zero.
+	 */
+	status = ft1000_read_register(dev, &tempword, FT1000_REG_SUP_IMASK);
+	//DEBUG("ft1000_hw:ft1000_chkcard: read FT1000_REG_SUP_IMASK = %x\n", tempword);
+	if (tempword == 0) {
+		DEBUG
+		    ("ft1000_hw:ft1000_chkcard: IMASK = 0 Card not detected\n");
+		return FALSE;
+	}
+	/* The system will return the value of 0xffff for the version register
+	 * if the device is not present.
+	 */
+	status = ft1000_read_register(dev, &tempword, FT1000_REG_ASIC_ID);
+	//DEBUG("ft1000_hw:ft1000_chkcard: read FT1000_REG_ASIC_ID = %x\n", tempword);
+	if (tempword != 0x1b01) {
+		dev->status |= FT1000_STATUS_CLOSING;	//mbelian
+		DEBUG
+		    ("ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
+		return FALSE;
+	}
+	return TRUE;
 }
 
-
-
 //---------------------------------------------------------------------------
 //
 // Function:   ft1000_receive_cmd
-- 
1.7.1

