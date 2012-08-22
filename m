Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2HVHHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 03:07:00 -0400
Received: from mail.telros.ru ([83.136.244.21]:55296 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225Ab2HVHGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 03:06:55 -0400
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 09/10] staging: media: go7007: Adlink_MPG24 board initialization fix.
Date: Wed, 22 Aug 2012 14:45:18 +0400
Message-Id: <1345632319-23224-9-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setting via gpio i2c bus support at every time then init encoder.

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-driver.c |    5 +++++
 drivers/staging/media/go7007/go7007-usb.c    |    3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index a66e339..c0ea312 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -173,6 +173,11 @@ static int go7007_init_encoder(struct go7007 *go)
 		go7007_write_addr(go, 0x3c82, 0x0001);
 		go7007_write_addr(go, 0x3c80, 0x00fe);
 	}
+	if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
+		/* set GPIO5 to be an output, currently low */
+		go7007_write_addr(go, 0x3c82, 0x0000);
+		go7007_write_addr(go, 0x3c80, 0x00df);
+	}
 	return 0;
 }
 
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index a6cad15..9dbf5ec 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1110,9 +1110,6 @@ static int go7007_usb_probe(struct usb_interface *intf,
 			} else {
 				u16 channel;
 
-				/* set GPIO5 to be an output, currently low */
-				go7007_write_addr(go, 0x3c82, 0x0000);
-				go7007_write_addr(go, 0x3c80, 0x00df);
 				/* read channel number from GPIO[1:0] */
 				go7007_read_addr(go, 0x3c81, &channel);
 				channel &= 0x3;
-- 
1.7.7.6

