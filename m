Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3ADFLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:11:52 -0500
Received: from mail-da0-f45.google.com ([209.85.210.45]:57057 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3ADFLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:11:47 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2] tvp514x: use devm_kzalloc() instead of kzalloc()
Date: Fri,  4 Jan 2013 10:41:16 +0530
Message-Id: <1357276277-21812-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357276277-21812-1-git-send-email-prabhakar.lad@ti.com>
References: <1357276277-21812-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
simplifies their clean up paths.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 Changes for v2:
 1: Fixed comments pointed out by Laurent.

 drivers/media/i2c/tvp514x.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index d5e1021..aa94ebc 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -951,7 +951,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		return -ENODEV;
 	}
 
-	decoder = kzalloc(sizeof(*decoder), GFP_KERNEL);
+	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
 	if (!decoder)
 		return -ENOMEM;
 
@@ -998,7 +998,6 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		int err = decoder->hdl.error;
 
 		v4l2_ctrl_handler_free(&decoder->hdl);
-		kfree(decoder);
 		return err;
 	}
 	v4l2_ctrl_handler_setup(&decoder->hdl);
@@ -1023,7 +1022,6 @@ static int tvp514x_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
-	kfree(decoder);
 	return 0;
 }
 /* TVP5146 Init/Power on Sequence */
-- 
1.7.4.1

