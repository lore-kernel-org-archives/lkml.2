Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1BIOCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:02:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BIOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=gyugrDIYTo04QPUN3l4CV2Sr27Wkq7cXgZ0YvZ2NMFdQCQJzn4GWxncZn85e0itFKC
         nDH+hTZSh7sikViGg5vs6Z6ceGOBmfUnDBd1mE4dxRk9VWHJhzIjUExCs7Y77y7JJEp8
         QrCO81l89bV+7ftv7otqTHA/4hPjz7jAcrzac=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/9] staging: ft1000: Fix coding style in ft1000_control function.
Date: Wed,  9 Feb 2011 15:02:34 +0100
Message-Id: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   43 +++++++------------------
 1 files changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 643a637..bb28a2b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -65,45 +65,26 @@ static u8 tempbuffer[1600];
 // Notes:
 //
 //---------------------------------------------------------------------------
-static int ft1000_control(struct ft1000_device *ft1000dev,unsigned int pipe,
-                          u8 request,
-                          u8 requesttype,
-                          u16 value,
-                          u16 index,
-                          void *data,
-                          u16 size,
-                          int timeout)
+static int ft1000_control(struct ft1000_device *ft1000dev, unsigned int pipe,
+			  u8 request, u8 requesttype, u16 value, u16 index,
+			  void *data, u16 size, int timeout)
 {
 	u16 ret;
 
-    if (ft1000dev == NULL )
-    {
-        DEBUG("NULL ft1000dev, failure\n");
-	return -ENODEV;
-    }
-    else if ( ft1000dev->dev == NULL )
-    {
-        DEBUG("NULL ft1000dev->dev, failure\n");
-	return -ENODEV;
-    }
+	if ((ft1000dev == NULL) || (ft1000dev->dev == NULL)) {
+		DEBUG("ft1000dev or ft1000dev->dev == NULL, failure\n");
+		return -ENODEV;
+	}
 
-    ret = usb_control_msg(ft1000dev->dev,
-                          pipe,
-                          request,
-                          requesttype,
-                          value,
-                          index,
-                          data,
-                          size,
-                          LARGE_TIMEOUT);
+	ret = usb_control_msg(ft1000dev->dev, pipe, request, requesttype,
+			      value, index, data, size, LARGE_TIMEOUT);
 
 	if (ret > 0)
 		ret = 0;
 
-    return ret;
-
-
+	return ret;
 }
+
 //---------------------------------------------------------------------------
 // Function:    ft1000_read_register
 //
-- 
1.7.1

