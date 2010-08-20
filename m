Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0HTSCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:02:08 -0400
Received: from server103.greatnet.de ([83.133.97.6]:59795 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0HTSCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:02:07 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: rpurdie@rpsys.net
Cc: sameo@linux.intel.com, mjg@redhat.com, henne@nachtwindheim.de,
        error27@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] backlight: 88pm860x_bl: fix build failure
Date: Fri, 20 Aug 2010 20:01:55 +0200
Message-Id: <1282327315-5259-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64 system this driver fails to build, since theres already a
macro called CURRENT_MASK in arch/asm/include/page_64_types.h
So I renamed this macro to BL_CURRENT_MASK to aviod a collision.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
This patch is against Linux tree and tested.

 drivers/video/backlight/88pm860x_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 38ffc3f..68bd602 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -21,7 +21,7 @@
 #define MAX_BRIGHTNESS		(0xFF)
 #define MIN_BRIGHTNESS		(0)
 
-#define CURRENT_MASK		(0x1F << 1)
+#define BL_CURRENT_MASK		(0x1F << 1)
 
 struct pm860x_backlight_data {
 	struct pm860x_chip *chip;
@@ -85,7 +85,7 @@ static int pm860x_backlight_set(struct backlight_device *bl, int brightness)
 	if ((data->current_brightness == 0) && brightness) {
 		if (data->iset) {
 			ret = pm860x_set_bits(data->i2c, wled_idc(data->port),
-					      CURRENT_MASK, data->iset);
+					      BL_CURRENT_MASK, data->iset);
 			if (ret < 0)
 				goto out;
 		}
-- 
1.7.0.4

