Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3ACNX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:23:57 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57487 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3ACNXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:23:53 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH] ths7303: use devm_kzalloc() instead of kzalloc()
Date: Thu,  3 Jan 2013 18:52:40 +0530
Message-Id: <1357219362-9080-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com>
References: <1357219362-9080-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
simplifies their clean up paths.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/i2c/ths7303.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
index c31cc04..e747524 100644
--- a/drivers/media/i2c/ths7303.c
+++ b/drivers/media/i2c/ths7303.c
@@ -175,7 +175,7 @@ static int ths7303_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = devm_kzalloc(&client->dev, sizeof(struct v4l2_subdev), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 
@@ -189,7 +189,6 @@ static int ths7303_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
 	v4l2_device_unregister_subdev(sd);
-	kfree(sd);
 
 	return 0;
 }
-- 
1.7.4.1

