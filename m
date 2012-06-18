Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab2FREOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:14:01 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37585 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2FREIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:08:48 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 04/22 v4] Input: atmel_mxt_ts - warn if sysfs could not be created
Date: Mon, 18 Jun 2012 12:08:24 +0800
Message-Id: <1339992522-22073-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sysfs entry creation fails, the driver is still usable, so don't
just abort probe.  Just warn and continue.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 00b37b1..0c49a1e 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1168,13 +1168,10 @@ static int __devinit mxt_probe(struct i2c_client *client,
 
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error)
-		goto err_unregister_device;
+		dev_warn(&client->dev, "error creating sysfs entries.\n");
 
 	return 0;
 
-err_unregister_device:
-	input_unregister_device(input_dev);
-	input_dev = NULL;
 err_free_irq:
 	free_irq(client->irq, data);
 err_free_object:
-- 
1.7.7.3

