Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835Ab2DLVXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:23:35 -0400
Received: from mail.tpi.com ([70.99.223.143]:3078 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab2DLVXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:23:33 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH linux-next] video: vicam: Add MODULE_FIRMWARE
Date: Thu, 12 Apr 2012 15:23:21 -0600
Message-Id: <1334265801-126023-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/video/gspca/vicam.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/gspca/vicam.c b/drivers/media/video/gspca/vicam.c
index 911152e..e48ec4d 100644
--- a/drivers/media/video/gspca/vicam.c
+++ b/drivers/media/video/gspca/vicam.c
@@ -37,9 +37,12 @@
 #include <linux/ihex.h>
 #include "gspca.h"
 
+#define VICAM_FIRMWARE "vicam/firmware.fw"
+
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
 MODULE_DESCRIPTION("GSPCA ViCam USB Camera Driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(VICAM_FIRMWARE);
 
 enum e_ctrl {
 	GAIN,
@@ -268,7 +271,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	const struct firmware *uninitialized_var(fw);
 	u8 *firmware_buf;
 
-	ret = request_ihex_firmware(&fw, "vicam/firmware.fw",
+	ret = request_ihex_firmware(&fw, VICAM_FIRMWARE,
 				    &gspca_dev->dev->dev);
 	if (ret) {
 		pr_err("Failed to load \"vicam/firmware.fw\": %d\n", ret);
-- 
1.7.9.5

