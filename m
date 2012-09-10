Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab2IJUxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:53:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58173 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2IJUxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:53:39 -0400
From: Luis Gonzalez Fernandez <luisgf@gmail.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Luis Gonzalez Fernandez <luisgf@gmail.com>
Subject: [PATCH 1/1] regulator: Fix incorrect casting in tps6230-regulator.c
Date: Mon, 10 Sep 2012 22:53:29 +0200
Message-Id: <1347310409-25976-1-git-send-email-luisgf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-3.6/drivers/regulator/tps62360-regulator.c: In function ‘tps62360_probe’:
linux-3.6/drivers/regulator/tps62360-regulator.c:364:13: warning: cast from poi$

Fix incorrect cast in tps62360_probe() function.

Signed-off-by: Luis Gonzalez Fernandez <luisgf@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 68729a7..02ff11c 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -361,7 +361,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 			dev_err(&client->dev, "Error: No device match found\n");
 			return -ENODEV;
 		}
-		chip_id = (int)match->data;
+		chip_id = *((int *)match->data);
 		if (!pdata)
 			pdata = of_get_tps62360_platform_data(&client->dev);
 	}
-- 
1.7.9.5

