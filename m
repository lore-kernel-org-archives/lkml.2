Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0IMTsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:33 -0400
Received: from mail.perches.com ([173.55.12.10]:1843 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab0IMTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:25 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: [PATCH 07/25] drivers/media: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:45 -0700
Message-Id: <6b7055a2e53510e8903828a53cad300a7d5bb912.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/zoran/zoran_device.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/video/zoran/zoran_device.c
index 6f846ab..ea8a1e9 100644
--- a/drivers/media/video/zoran/zoran_device.c
+++ b/drivers/media/video/zoran/zoran_device.c
@@ -1470,8 +1470,7 @@ zoran_irq (int             irq,
 		    (zr->codec_mode == BUZ_MODE_MOTION_DECOMPRESS ||
 		     zr->codec_mode == BUZ_MODE_MOTION_COMPRESS)) {
 			if (zr36067_debug > 1 && (!zr->frame_num || zr->JPEG_error)) {
-				char sc[] = "0000";
-				char sv[5];
+				char sv[sizeof("0000")];
 				int i;
 
 				printk(KERN_INFO
@@ -1481,7 +1480,7 @@ zoran_irq (int             irq,
 				       zr->jpg_settings.field_per_buff,
 				       zr->JPEG_missed);
 
-				strcpy(sv, sc);
+				strcpy(sv, "0000");
 				for (i = 0; i < 4; i++) {
 					if (le32_to_cpu(zr->stat_com[i]) & 1)
 						sv[i] = '1';
-- 
1.7.3.rc1

