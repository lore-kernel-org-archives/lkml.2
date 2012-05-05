Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2EEXDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 19:03:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46010 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab2EEXDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 19:03:15 -0400
From: Olof Johansson <olof@lixom.net>
To: sameo@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] mfd: da9052: fix of_match_node() arguments
Date: Sat,  5 May 2012 16:02:48 -0700
Message-Id: <1336258968-6423-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver calls of_match_node() with the arguments swapped.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/mfd/da9052-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index d8abdb3..8410065 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -104,7 +104,7 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 		struct device_node *np = client->dev.of_node;
 		const struct of_device_id *deviceid;
 
-		deviceid = of_match_node(np, dialog_dt_ids);
+		deviceid = of_match_node(dialog_dt_ids, np);
 		id = (const struct i2c_device_id *)deviceid->data;
 	}
 #endif
-- 
1.7.9.5

