Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab1GTHiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 03:38:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48920 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1GTHiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 03:38:17 -0400
Subject: [PATCH] Input: mpu3050 - call  input_free_device() in
 mpu3050_probe() error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joseph Lai <joseph_lai@wistron.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 15:38:10 +0800
Message-ID: <1311147490.10091.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3dcc899388d98a68c22d14b3149d3cc472f8d2fa Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 20 Jul 2011 15:34:33 +0800
Subject: [PATCH] Input: mpu3050 - correct call to input_free_device

input_free_device() should be used if input_register_device() was not called
yet or if it failed.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/misc/mpu3050.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/mpu3050.c b/drivers/input/misc/mpu3050.c
index b95fac1..f71dc72 100644
--- a/drivers/input/misc/mpu3050.c
+++ b/drivers/input/misc/mpu3050.c
@@ -282,7 +282,7 @@ err_free_irq:
 err_pm_set_suspended:
 	pm_runtime_set_suspended(&client->dev);
 err_free_mem:
-	input_unregister_device(idev);
+	input_free_device(idev);
 	kfree(sensor);
 	return error;
 }
-- 
1.7.4.1



