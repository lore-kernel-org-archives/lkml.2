Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1CGIXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:23:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab1CGIWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=XpzGL9uo2I33MuQBYy0/dHCXeYIeQLVc/WaMkPmu9cayKN0JGbl5qYoCRuKrX5bnF+
         lbwHRv8qT6XsrOMamm3OPWbZ66VGUMxuMDjwJui4MAtflGl9Fr78NELaVXognIlD4Itp
         Oddw3KJIYAl02XxXeKkV1jaoqDV4M5TYjWTT4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 19/21] staging: ft1000: Fix coding style in ft1000_receive_cmd function.
Date: Mon,  7 Mar 2011 09:21:24 +0100
Message-Id: <1299486086-7325-20-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  112 ++++++++++++++-----------
 1 files changed, 63 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 5fdfbbd..9e0b696 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1373,56 +1373,70 @@ static int ft1000_chkcard(struct ft1000_device *dev)
 //          = 1 (successful)
 //
 //---------------------------------------------------------------------------
-static bool ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int maxsz, u16 *pnxtph) {
-    u16 size, ret;
-    u16 *ppseudohdr;
-    int i;
-    u16 tempword;
+static bool ft1000_receive_cmd(struct ft1000_device *dev, u16 *pbuffer,
+			       int maxsz, u16 *pnxtph)
+{
+	u16 size, ret;
+	u16 *ppseudohdr;
+	int i;
+	u16 tempword;
 
-    ret = ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (u8 *)&size, FT1000_MAG_PH_LEN_INDX);
-    size = ntohs(size) + PSEUDOSZ;
-    if (size > maxsz) {
-        DEBUG("FT1000:ft1000_receive_cmd:Invalid command length = %d\n", size);
-        return FALSE;
-    }
-    else {
-        ppseudohdr = (u16 *)pbuffer;
-        ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE, FT1000_REG_DPRAM_ADDR);
-        ret = ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
-        //DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
-        pbuffer++;
-        ft1000_write_register(dev,  FT1000_DPRAM_MAG_RX_BASE+1, FT1000_REG_DPRAM_ADDR);
-        for (i=0; i<=(size>>2); i++) {
-            ret = ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
-            pbuffer++;
-            ret = ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
-            pbuffer++;
-        }
-        //copy odd aligned word
-        ret = ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
-        //DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
-        pbuffer++;
-        ret = ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
-        //DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
-        pbuffer++;
-        if (size & 0x0001) {
-            //copy odd byte from fifo
-            ret = ft1000_read_register(dev, &tempword, FT1000_REG_DPRAM_DATA);
-            *pbuffer = ntohs(tempword);
-        }
+	ret =
+	    ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (u8 *) &size,
+				FT1000_MAG_PH_LEN_INDX);
+	size = ntohs(size) + PSEUDOSZ;
+	if (size > maxsz) {
+		DEBUG("FT1000:ft1000_receive_cmd:Invalid command length = %d\n",
+		      size);
+		return FALSE;
+	} else {
+		ppseudohdr = (u16 *) pbuffer;
+		ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE,
+				      FT1000_REG_DPRAM_ADDR);
+		ret =
+		    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
+		//DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
+		pbuffer++;
+		ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE + 1,
+				      FT1000_REG_DPRAM_ADDR);
+		for (i = 0; i <= (size >> 2); i++) {
+			ret =
+			    ft1000_read_register(dev, pbuffer,
+						 FT1000_REG_MAG_DPDATAL);
+			pbuffer++;
+			ret =
+			    ft1000_read_register(dev, pbuffer,
+						 FT1000_REG_MAG_DPDATAH);
+			pbuffer++;
+		}
+		/* copy odd aligned word */
+		ret =
+		    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAL);
+		//DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
+		pbuffer++;
+		ret =
+		    ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
+		//DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
+		pbuffer++;
+		if (size & 0x0001) {
+			/* copy odd byte from fifo */
+			ret =
+			    ft1000_read_register(dev, &tempword,
+						 FT1000_REG_DPRAM_DATA);
+			*pbuffer = ntohs(tempword);
+		}
+		/* Check if pseudo header checksum is good
+		 * Calculate pseudo header checksum
+		 */
+		tempword = *ppseudohdr++;
+		for (i = 1; i < 7; i++)
+			tempword ^= *ppseudohdr++;
 
-        // Check if pseudo header checksum is good
-        // Calculate pseudo header checksum
-        tempword = *ppseudohdr++;
-        for (i=1; i<7; i++) {
-            tempword ^= *ppseudohdr++;
-        }
-        if ( (tempword != *ppseudohdr) ) {
-            return FALSE;
-        }
+		if ((tempword != *ppseudohdr))
+			return FALSE;
 
-        return TRUE;
-    }
+		return TRUE;
+	}
 }
 
 
-- 
1.7.1

