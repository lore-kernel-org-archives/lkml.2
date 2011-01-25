Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1AYNF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:05:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1AYNEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=C0PswdsOXMVaP05w4RrLcZz5YHcTZQrg586ncCQ408yD8c8HF/fQPlqRJyzwhMSr3w
         zJIBWR2BYUJjZKnTtEiVG5j2ESImgqZbjvnYY96o+RZ0VF7ctKtOn/1xLSxIkfQRSHej
         eoCIorZGt37gv55cHvcbxHcFdKYKBJfqTpqIc=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 08/11] staging: ft1000: Fix coding style in get_request_value() function.
Date: Tue, 25 Jan 2011 14:05:03 +0100
Message-Id: <1295960706-15667-9-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   38 +++++++++-----------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 3385eac..b34429c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -406,30 +406,26 @@ static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static long get_request_value(struct ft1000_device *ft1000dev)
 {
-   u32     value;
-   u16   tempword;
-   u32    status;
+	u32 value;
+	u16 tempword;
+	u32 status;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
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
-
+	return value;
 }
 
 
-- 
1.7.1

