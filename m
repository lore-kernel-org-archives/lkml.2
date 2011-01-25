Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1AYLcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:32:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1AYLa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:30:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=kkeURfuGhgCOYqP0eB3ubszqd0c12xp7dXfUgkAY/h6ExHgqtkvcOzozkbvXvfwBwX
         Rmp7Miy6SHkqQwmw7/ljZtqnU8CGx5NIKSdhG+BN/GY9EsvMsRXLoB2N8eT+pgeMqn1W
         oQyxtOI4wF2+jRDEFiew8t8ZmcNKfRS5lijFE=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 07/12] staging: ft1000: Fix coding style in get_request_type() function.
Date: Tue, 25 Jan 2011 12:31:18 +0100
Message-Id: <1295955083-11086-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   38 +++++++++-----------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index a1d5592..bf20e64 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -340,30 +340,26 @@ static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_valu
 //---------------------------------------------------------------------------
 static u16 get_request_type(struct ft1000_device *ft1000dev)
 {
-   u16   request_type;
-   u32    status;
-   u16   tempword;
-   u32    tempx;
+	u16   request_type;
+	u32    status;
+	u16   tempword;
+	u32    tempx;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
-   if ( pft1000info->bootmode == 1)
-   {
-       status = fix_ft1000_read_dpram32 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
-       tempx = ntohl(tempx);
-   }
-   else
-   {
-       tempx = 0;
-
-       status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
-       tempx |= (tempword << 16);
-       tempx = ntohl(tempx);
-   }
-   request_type = (u16)tempx;
-
-   //DEBUG("get_request_type: request_type is %x\n", request_type);
-   return request_type;
+	if (pft1000info->bootmode == 1) {
+		status = fix_ft1000_read_dpram32(ft1000dev,
+				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
+		tempx = ntohl(tempx);
+	} else {
+		tempx = 0;
+		status = ft1000_read_dpram16(ft1000dev,
+				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
+		tempx |= (tempword << 16);
+		tempx = ntohl(tempx);
+	}
+	request_type = (u16)tempx;
 
+	return request_type;
 }
 
 static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
-- 
1.7.1

