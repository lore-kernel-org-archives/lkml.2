Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1HUXAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:00:34 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:49519 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932075Ab1HUXAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:00:30 -0400
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Leandro Costantino <lcostantino@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] [media] t613: Use current logging styles
Date: Sun, 21 Aug 2011 15:56:56 -0700
Message-Id: <04fd76ed7e6e810e402acdfa3ef6cf5c6f3b441c.1313966090.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1313966088.git.joe@perches.com>
References: <cover.1313966088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Convert usb style logging macros to pr_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/gspca/t613.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/gspca/t613.c b/drivers/media/video/gspca/t613.c
index d1d733b..90f0877 100644
--- a/drivers/media/video/gspca/t613.c
+++ b/drivers/media/video/gspca/t613.c
@@ -26,6 +26,8 @@
  *			Costantino Leandro
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define MODULE_NAME "t613"
 
 #include <linux/slab.h>
@@ -572,7 +574,7 @@ static void reg_w_buf(struct gspca_dev *gspca_dev,
 
 		tmpbuf = kmemdup(buffer, len, GFP_KERNEL);
 		if (!tmpbuf) {
-			err("Out of memory");
+			pr_err("Out of memory\n");
 			return;
 		}
 		usb_control_msg(gspca_dev->dev,
@@ -598,7 +600,7 @@ static void reg_w_ixbuf(struct gspca_dev *gspca_dev,
 	} else {
 		p = tmpbuf = kmalloc(len * 2, GFP_KERNEL);
 		if (!tmpbuf) {
-			err("Out of memory");
+			pr_err("Out of memory\n");
 			return;
 		}
 	}
@@ -652,7 +654,7 @@ static void om6802_sensor_init(struct gspca_dev *gspca_dev)
 	}
 	byte = reg_r(gspca_dev, 0x0063);
 	if (byte != 0x17) {
-		err("Bad sensor reset %02x", byte);
+		pr_err("Bad sensor reset %02x\n", byte);
 		/* continue? */
 	}
 
@@ -890,7 +892,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		sd->sensor = SENSOR_OM6802;
 		break;
 	default:
-		err("unknown sensor %04x", sensor_id);
+		pr_err("unknown sensor %04x\n", sensor_id);
 		return -EINVAL;
 	}
 
@@ -905,7 +907,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 				break;		/* OK */
 		}
 		if (i < 0) {
-			err("Bad sensor reset %02x", test_byte);
+			pr_err("Bad sensor reset %02x\n", test_byte);
 			return -EIO;
 		}
 		reg_w_buf(gspca_dev, n2, sizeof n2);
-- 
1.7.6.405.gc1be0

