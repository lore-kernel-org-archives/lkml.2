Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1AYLIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:08:00 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1AYLH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=M2a3YxiaIJAoFjJJ/x8TZYk9VnBtauqL1RiFrJAhNXWWAUm/QzyGvXoaR7IObEmz3b
         1meq4ZJjb0HnKjQmv88n2s4qwKVYM0Ok8ubSL+0/7CZBv7U5P8UzwAkFrcyWnsz19UFn
         H+8xxzZFWewpzZ8ivoO0EXnnXtPeYNPG99ElM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 07/12] staging: ft1000: Fix coding style.
Date: Tue, 25 Jan 2011 12:08:12 +0100
Message-Id: <1295953697-9805-7-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style in get_request_type() function.

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

