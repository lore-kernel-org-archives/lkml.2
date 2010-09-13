Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0IMWHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 18:07:17 -0400
Received: from mail.perches.com ([173.55.12.10]:1966 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab0IMWHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 18:07:16 -0400
Subject: [PATCH 07/25] drivers/media/video/zoran: Don't use initialized
 char array
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        linux-media@vger.kernel.org
In-Reply-To: <4C8E9C95.8070201@infradead.org>
References: <cover.1284406638.git.joe@perches.com>
	 <6b7055a2e53510e8903828a53cad300a7d5bb912.1284406638.git.joe@perches.com>
	 <4C8E9C95.8070201@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Sep 2010 15:07:14 -0700
Message-ID: <1284415634.26719.103.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just fill the array as necessary and terminate with 0

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/video/zoran/zoran_device.c
index 6f846ab..b02007e 100644
--- a/drivers/media/video/zoran/zoran_device.c
+++ b/drivers/media/video/zoran/zoran_device.c
@@ -1470,8 +1470,7 @@ zoran_irq (int             irq,
 		    (zr->codec_mode == BUZ_MODE_MOTION_DECOMPRESS ||
 		     zr->codec_mode == BUZ_MODE_MOTION_COMPRESS)) {
 			if (zr36067_debug > 1 && (!zr->frame_num || zr->JPEG_error)) {
-				char sc[] = "0000";
-				char sv[5];
+				char sv[BUZ_NUM_STAT_COM + 1];
 				int i;
 
 				printk(KERN_INFO
@@ -1481,12 +1480,9 @@ zoran_irq (int             irq,
 				       zr->jpg_settings.field_per_buff,
 				       zr->JPEG_missed);
 
-				strcpy(sv, sc);
-				for (i = 0; i < 4; i++) {
-					if (le32_to_cpu(zr->stat_com[i]) & 1)
-						sv[i] = '1';
-				}
-				sv[4] = 0;
+				for (i = 0; i < BUZ_NUM_STAT_COM; i++)
+					sv[i] = le32_to_cpu(zr->stat_com[i]) & 1 ? '1' : '0';
+				sv[BUZ_NUM_STAT_COM] = 0;
 				printk(KERN_INFO
 				       "%s: stat_com=%s queue_state=%ld/%ld/%ld/%ld\n",
 				       ZR_DEVNAME(zr), sv,


