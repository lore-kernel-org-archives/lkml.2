Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0ISMzB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 08:55:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58608 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab0ISMy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 08:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XZpjTXSmo/VzBaylbHJi75KNbn95Fyolx08tNmh9ddFCIFUNyuk+gw0UpgK9o4JDoI
         bComVw6ADdgmpAiW25KfN1FOMylm0FM0rAvJOqzehO64Sk8Jx9ITjdj7xPeQ85aDgt4b
         +Wd4r0K31hrRhOBQ0GOfzQgDwmc7JO+sbOzC4=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] message: i2o: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:54:52 +0400
Message-Id: <1284900893-24411-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device_register() fails then call put_device().
See comment to device_register.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 compile tested.

 drivers/message/i2o/device.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 0ee4264..3ac8ec3 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -234,8 +234,10 @@ static int i2o_device_add(struct i2o_controller *c, i2o_lct_entry *entry)
 	i2o_dev->device.parent = &c->device;
 
 	rc = device_register(&i2o_dev->device);
-	if (rc)
+	if (rc) {
+		put_device(&i2o_dev->device);
 		goto err;
+	}
 
 	list_add_tail(&i2o_dev->list, &c->devices);
 
-- 
1.7.0.4

