Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1BIODD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:03:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab1BIODB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=F2x1w7G3uaPqBO5BeeQM3c/T0Yckfpgv0y2yCpZXGaDgeMRyvcNEZr2Xfz4QwDGHta
         ikz+PqZBJMj2VCDrdRfY7VjDOO2/Z1jZHUKghjZfiESqohELuc6GgNmbUVCikJ0H/qk4
         D1avqpN8VesPMlrlxNwhQ+iy1R5/SGOvsM6cc=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 8/9] staging: ft1000: Fix coding style in fix_ft1000_write_dpram32 fucntion.
Date: Wed,  9 Feb 2011 15:02:41 +0100
Message-Id: <1297260162-19263-8-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  104 +++++++++++--------------
 1 files changed, 47 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 6195ee9..437aee3 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -365,68 +365,58 @@ int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx,
 //---------------------------------------------------------------------------
 int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
 {
-    u16 pos1;
-    u16 pos2;
-    u16 i;
-    u8 buf[32];
-    u8 resultbuffer[32];
-    u8 *pdata;
-    int ret  = STATUS_SUCCESS;
-
-    //DEBUG("fix_ft1000_write_dpram32: Entered:\n");
-
-    pos1 = (indx / 4)*4;
-    pdata = buffer;
-    ret = ft1000_read_dpram32(ft1000dev, pos1, buf, 16);
-    if (ret == STATUS_SUCCESS)
-    {
-        pos2 = (indx % 4)*4;
-        buf[pos2++] = *buffer++;
-        buf[pos2++] = *buffer++;
-        buf[pos2++] = *buffer++;
-        buf[pos2++] = *buffer++;
-        ret = ft1000_write_dpram32(ft1000dev, pos1, buf, 16);
-    }
-    else
-    {
-        DEBUG("fix_ft1000_write_dpram32: DPRAM32 Read failed\n");
+	u16 pos1;
+	u16 pos2;
+	u16 i;
+	u8 buf[32];
+	u8 resultbuffer[32];
+	u8 *pdata;
+	int ret  = STATUS_SUCCESS;
+
+	pos1 = (indx / 4) * 4;
+	pdata = buffer;
+	ret = ft1000_read_dpram32(ft1000dev, pos1, buf, 16);
 
-        return ret;
-    }
-
-    ret = ft1000_read_dpram32(ft1000dev, pos1, (u8 *)&resultbuffer[0], 16);
-    if (ret == STATUS_SUCCESS)
-    {
-        buffer = pdata;
-        for (i=0; i<16; i++)
-        {
-            if (buf[i] != resultbuffer[i]){
+	if (ret == STATUS_SUCCESS) {
+		pos2 = (indx % 4)*4;
+		buf[pos2++] = *buffer++;
+		buf[pos2++] = *buffer++;
+		buf[pos2++] = *buffer++;
+		buf[pos2++] = *buffer++;
+		ret = ft1000_write_dpram32(ft1000dev, pos1, buf, 16);
+	} else {
+		DEBUG("fix_ft1000_write_dpram32: DPRAM32 Read failed\n");
+		return ret;
+	}
 
-                ret = STATUS_FAILURE;
-            }
-        }
-    }
+	ret = ft1000_read_dpram32(ft1000dev, pos1, (u8 *)&resultbuffer[0], 16);
 
-    if (ret == STATUS_FAILURE)
-    {
-        ret = ft1000_write_dpram32(ft1000dev, pos1, (u8 *)&tempbuffer[0], 16);
-        ret = ft1000_read_dpram32(ft1000dev, pos1, (u8 *)&resultbuffer[0], 16);
-        if (ret == STATUS_SUCCESS)
-        {
-            buffer = pdata;
-            for (i=0; i<16; i++)
-            {
-                if (tempbuffer[i] != resultbuffer[i])
-                {
-                    ret = STATUS_FAILURE;
-                    DEBUG("fix_ft1000_write_dpram32 Failed to write\n");
-                }
-            }
-         }
-    }
+	if (ret == STATUS_SUCCESS) {
+		buffer = pdata;
+		for (i = 0; i < 16; i++) {
+			if (buf[i] != resultbuffer[i])
+				ret = STATUS_FAILURE;
+		}
+	}
 
-    return ret;
+	if (ret == STATUS_FAILURE) {
+		ret = ft1000_write_dpram32(ft1000dev, pos1,
+					   (u8 *)&tempbuffer[0], 16);
+		ret = ft1000_read_dpram32(ft1000dev, pos1,
+					  (u8 *)&resultbuffer[0], 16);
+		if (ret == STATUS_SUCCESS) {
+			buffer = pdata;
+			for (i = 0; i < 16; i++) {
+				if (tempbuffer[i] != resultbuffer[i]) {
+					ret = STATUS_FAILURE;
+					DEBUG("%s Failed to write\n",
+					      __func__);
+				}
+			}
+		}
+	}
 
+	return ret;
 }
 
 
-- 
1.7.1

