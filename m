Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1BIOD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:03:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab1BIODX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:03:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GzQipoKQzBkD/zsUZRHmEhHRr/dCFaM68T95MeAdj9DkFZorR4EvIiz47gsH6j1F1F
         p6risvMX8XmqZL1aPfuQyKCZyUBdycNBFTYrcWJFC2o5KtX7l9SybU+4Ep6WJuY3onVc
         uoIcRDkxofP8zWdlANQP4xrUt2KMwTfNk52TU=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 7/9] staging: ft1000: Fix coding style in fix_ft1000_read_dpram32 function.
Date: Wed,  9 Feb 2011 15:02:40 +0100
Message-Id: <1297260162-19263-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   49 +++++++++++--------------
 1 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index aa4ad7b..6195ee9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -319,36 +319,31 @@ int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u
 // Notes:
 //
 //---------------------------------------------------------------------------
-int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
+int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx,
+			    u8 *buffer)
 {
-    u8 buf[16];
-    u16 pos;
-    int ret = STATUS_SUCCESS;
-
-    //DEBUG("fix_ft1000_read_dpram32: indx: %d  \n", indx);
-    pos = (indx / 4)*4;
-    ret = ft1000_read_dpram32(ft1000dev, pos, buf, 16);
-    if (ret == STATUS_SUCCESS)
-    {
-        pos = (indx % 4)*4;
-        *buffer++ = buf[pos++];
-        *buffer++ = buf[pos++];
-        *buffer++ = buf[pos++];
-        *buffer++ = buf[pos++];
-    }
-    else
-    {
-        DEBUG("fix_ft1000_read_dpram32: DPRAM32 Read failed\n");
-        *buffer++ = 0;
-        *buffer++ = 0;
-        *buffer++ = 0;
-        *buffer++ = 0;
+	u8 buf[16];
+	u16 pos;
+	int ret = STATUS_SUCCESS;
 
-    }
+	pos = (indx / 4) * 4;
+	ret = ft1000_read_dpram32(ft1000dev, pos, buf, 16);
 
-   //DEBUG("fix_ft1000_read_dpram32: data is  %x \n", *buffer);
-   return ret;
+	if (ret == STATUS_SUCCESS) {
+		pos = (indx % 4) * 4;
+		*buffer++ = buf[pos++];
+		*buffer++ = buf[pos++];
+		*buffer++ = buf[pos++];
+		*buffer++ = buf[pos++];
+	} else {
+		DEBUG("fix_ft1000_read_dpram32: DPRAM32 Read failed\n");
+		*buffer++ = 0;
+		*buffer++ = 0;
+		*buffer++ = 0;
+		*buffer++ = 0;
+	}
 
+	return ret;
 }
 
 
-- 
1.7.1

