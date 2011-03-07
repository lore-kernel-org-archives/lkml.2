Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1CGIXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:23:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60411 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1CGIWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:22:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=KKMBkcG0jtW8sgV7HLbnJogoCG5idiaqk5z/AeDMef9nFZ+J5yONarAqPLP5U+wOQ6
         2UsUJsyH+DGTL86IpWQeZ9KkSQ2Or/BYulSUzg5p9V+Rq8KEAxwBJJsKHzmnOETduEDO
         swfaz80/yH0HzOH5kffT27r9Oo7B4I9wyH5T4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 18/21] staging: ft1000: Fix coding style in ft1000_chkcard function.
Date: Mon,  7 Mar 2011 09:21:23 +0100
Message-Id: <1299486086-7325-19-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   61 +++++++++++++------------
 1 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index a76e380..5fdfbbd 100644
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

