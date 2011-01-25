Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab1AYLbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:31:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab1AYLbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:31:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XqgpxLT3odfaRaxZMWNR6lpeu8pNspQacvsERJmnt5WkA2bqG3hXt16TSMaYF3qpV0
         8KMWOvc3jSdoaGpRYCciHLUfUI3X4LJmkP1AYOed3dK4+XSuQwCORSk/S6YoyKDGX7eM
         lbhxKgTH8rGbcu2YTsqMT3xpByfqRSXmLO39w=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 09/12] staging: ft1000: Fix coding style in get_request_value() function.
Date: Tue, 25 Jan 2011 12:31:20 +0100
Message-Id: <1295955083-11086-9-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   37 +++++++++-----------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 3b56661..a5dca6c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -406,30 +406,27 @@ static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static long get_request_value(struct ft1000_device *ft1000dev)
 {
-   u32     value;
-   u16   tempword;
-   u32    status;
+	u32     value;
+	u16   tempword;
+	u32    status;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
 
-       if ( pft1000info->bootmode == 1)
-       {
-	   status = fix_ft1000_read_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&value);
-	   value = ntohl(value);
-       }
-       else
-       {
-	   status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 0);
-	   value = tempword;
-           status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
-	   value |= (tempword << 16);
-	   value = ntohl(value);
-       }
-
-
-   //DEBUG("get_request_value: value is %x\n", value);
-   return value;
+	if (pft1000info->bootmode == 1) {
+		status = fix_ft1000_read_dpram32(ft1000dev,
+				DWNLD_MAG1_SIZE_LOC, (u8 *)&value);
+		value = ntohl(value);
+	} else	{
+		status = ft1000_read_dpram16(ft1000dev,
+				DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 0);
+		value = tempword;
+		status = ft1000_read_dpram16(ft1000dev,
+				DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
+		value |= (tempword << 16);
+		value = ntohl(value);
+	}
 
+	return value;
 }
 
 
-- 
1.7.1

