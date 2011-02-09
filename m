Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1BIODO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:03:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab1BIODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:03:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=eCRmt5A8r2KgG4PAyuSwBXCQNesvLz4591OzYKIX2UnFdbfMC+EPhPmWkurJJEDZhM
         b5DMrKLbUtzaMueBKM72YwWapVtY6Ay+7soc7VJO7/Qe25QuZ+4o3lNQyZaOUIcjf/57
         8OSP93WQoyJSyCzrkD8gSPnR2Ehp5RDf+dLSc=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 9/9] staging: ft1000: Fix coding style in card_reset_dsp function.
Date: Wed,  9 Feb 2011 15:02:42 +0100
Message-Id: <1297260162-19263-9-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   59 ++++++++++++++-----------
 1 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 437aee3..e3b9934 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -430,33 +430,40 @@ int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buff
 //
 //  Returns:    None
 //-----------------------------------------------------------------------
-static void card_reset_dsp (struct ft1000_device *ft1000dev, bool value)
+static void card_reset_dsp(struct ft1000_device *ft1000dev, bool value)
 {
-    u16 status = STATUS_SUCCESS;
-    u16 tempword;
-
-    status = ft1000_write_register (ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
-    status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_SUP_CTRL);
-    if (value)
-    {
-        DEBUG("Reset DSP\n");
-        status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
-        tempword |= DSP_RESET_BIT;
-        status = ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
-    }
-    else
-    {
-        DEBUG("Activate DSP\n");
-        status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
-	tempword |= DSP_ENCRYPTED;
-	tempword &= ~DSP_UNENCRYPTED;
-	status = ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
-        status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
-        tempword &= ~EFUSE_MEM_DISABLE;
-        tempword &= ~DSP_RESET_BIT;
-        status = ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
-        status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
-    }
+	u16 status = STATUS_SUCCESS;
+	u16 tempword;
+
+	status = ft1000_write_register(ft1000dev, HOST_INTF_BE,
+					FT1000_REG_SUP_CTRL);
+	status = ft1000_read_register(ft1000dev, &tempword,
+				      FT1000_REG_SUP_CTRL);
+
+	if (value) {
+		DEBUG("Reset DSP\n");
+		status = ft1000_read_register(ft1000dev, &tempword,
+					      FT1000_REG_RESET);
+		tempword |= DSP_RESET_BIT;
+		status = ft1000_write_register(ft1000dev, tempword,
+					       FT1000_REG_RESET);
+	} else {
+		DEBUG("Activate DSP\n");
+		status = ft1000_read_register(ft1000dev, &tempword,
+					      FT1000_REG_RESET);
+		tempword |= DSP_ENCRYPTED;
+		tempword &= ~DSP_UNENCRYPTED;
+		status = ft1000_write_register(ft1000dev, tempword,
+					       FT1000_REG_RESET);
+		status = ft1000_read_register(ft1000dev, &tempword,
+					      FT1000_REG_RESET);
+		tempword &= ~EFUSE_MEM_DISABLE;
+		tempword &= ~DSP_RESET_BIT;
+		status = ft1000_write_register(ft1000dev, tempword,
+					       FT1000_REG_RESET);
+		status = ft1000_read_register(ft1000dev, &tempword,
+					      FT1000_REG_RESET);
+	}
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

